require 'bundler'
Bundler.require
require 'open-uri'

doc = Nokogiri::HTML(open('http://yawaspi.com/yuzumori/'))

updated_at = Date.parse(doc.at('.comicNewsDay').text.sub('最新更新日: ', '').strip)
next_at = Date.parse(doc.at('.comicNextDay').text.sub('次回更新日: ', '').strip)

today = Date.today
diff = next_at.mjd - today.mjd

if today == updated_at
  tweet = "南みれぃ「私の計算によると、今日は柚子森さんの更新日ぷりよ。みんな、今すぐ読むっぷり。」 http://yawaspi.com/yuzumori/"
elsif diff == 1
  tweet = "南みれぃ「私の計算によると、明日、柚子森さんが更新されるっぷりね。」"
elsif diff == 2
  tweet = "南みれぃ「私の計算によると、明後日、柚子森さんが更新されるっぷりね。」"
else
  tweet = "南みれぃ「私の計算によると、柚子森さん更新日まであと#{diff}日っぷりね。」"
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
end

client.update(tweet)
