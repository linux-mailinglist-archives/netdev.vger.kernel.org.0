Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE22294364
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 21:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409257AbgJTTnQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Oct 2020 15:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405175AbgJTTnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 15:43:16 -0400
X-Greylist: delayed 88583 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 20 Oct 2020 12:43:14 PDT
Received: from pechkin.mail.miralogic.ru (pechkin.mail.miralogic.ru [IPv6:2a02:17d0:8006:2::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A52A9C0613CE;
        Tue, 20 Oct 2020 12:43:14 -0700 (PDT)
Received: from mail.itmh.ru (unknown [IPv6:2a02:17d0:810a:100::2])
        by pechkin.mail.miralogic.ru (Postfix) with ESMTP id 95EB044DCC;
        Wed, 21 Oct 2020 00:43:12 +0500 (YEKT)
Received: from arden.corp.itmh.ru (2a02:17d0:810a:100::2) by
 arden.corp.itmh.ru (2a02:17d0:810a:100::2) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Oct 2020 00:43:12 +0500
Received: from arden.corp.itmh.ru ([fe80::a5a9:460a:d0d8:f5cb]) by
 arden.corp.itmh.ru ([fe80::a5a9:460a:d0d8:f5cb%12]) with mapi id
 15.00.1497.000; Wed, 21 Oct 2020 00:43:12 +0500
From:   =?koi8-r?B?7cHSy8/XIO3JyMHJzCDhzMXL08HOxNLP18ne?= 
        <markov.mikhail@itmh.ru>
To:     Stanislaw Gruszka <stf_xl@wp.pl>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Helmut Schaa" <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "\"David S. Miller\"" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "illumin@yandex.ru" <illumin@yandex.ru>
Subject: [PATCH v2] rt2x00: save survey for every channel visited
Thread-Topic: [PATCH v2] rt2x00: save survey for every channel visited
Thread-Index: AQHWpxk+BXXDNxt6q0e4vzZbkNLD9Q==
Date:   Tue, 20 Oct 2020 19:43:12 +0000
Message-ID: <1603222991841.29674@itmh.ru>
References: <1603134408870.78805@itmh.ru>,<20201020071243.GA302394@wp.pl>
In-Reply-To: <20201020071243.GA302394@wp.pl>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2a02:17d0:8118:10a::2]
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rt2800 only gives you survey for current channel.

Survey-based ACS algorithms are failing to perform their job when working
with rt2800.

Make rt2800 save survey for every channel visited and be able to give away
that information.

There is a bug registered https://dev.archive.openwrt.org/ticket/19081 and
this patch solves the issue.

Signed-off-by: Markov Mikhail <markov.mikhail@itmh.ru>

---
Changes are now aggregated in rt2800lib.c.
---
 .../net/wireless/ralink/rt2x00/rt2800lib.c    | 61 ++++++++++++++-----
 drivers/net/wireless/ralink/rt2x00/rt2x00.h   | 10 +++
 2 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a779fe771a55..12a709d99e44 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1228,6 +1228,17 @@ static int rt2800_check_hung(struct data_queue *queue)
 	return queue->wd_count > 16;
 }
 
+static void rt2800_update_survey(struct rt2x00_dev *rt2x00dev)
+{
+	struct ieee80211_channel *chan = rt2x00dev->hw->conf.chandef.chan;
+	struct rt2x00_chan_survey *chan_survey =
+		   &rt2x00dev->chan_survey[chan->hw_value];
+
+	chan_survey->time_idle += rt2800_register_read(rt2x00dev, CH_IDLE_STA);
+	chan_survey->time_busy += rt2800_register_read(rt2x00dev, CH_BUSY_STA);
+	chan_survey->time_ext_busy += rt2800_register_read(rt2x00dev, CH_BUSY_STA_SEC);
+}
+
 void rt2800_watchdog(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
@@ -1237,6 +1248,8 @@ void rt2800_watchdog(struct rt2x00_dev *rt2x00dev)
 	if (test_bit(DEVICE_STATE_SCANNING, &rt2x00dev->flags))
 		return;
 
+	rt2800_update_survey(rt2x00dev);
+
 	queue_for_each(rt2x00dev, queue) {
 		switch (queue->qid) {
 		case QID_AC_VO:
@@ -5553,6 +5566,12 @@ void rt2800_config(struct rt2x00_dev *rt2x00dev,
 	rt2800_config_lna_gain(rt2x00dev, libconf);
 
 	if (flags & IEEE80211_CONF_CHANGE_CHANNEL) {
+		/*
+		 * To provide correct survey data for survey-based ACS algorithm
+		 * we have to save survey data for current channel before switching.
+		 */
+		rt2800_update_survey(rt2x00dev);
+
 		rt2800_config_channel(rt2x00dev, libconf->conf,
 				      &libconf->rf, &libconf->channel);
 		rt2800_config_txpower(rt2x00dev, libconf->conf->chandef.chan,
@@ -10111,12 +10130,20 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
-	 * Create channel information array
+	 * Create channel information and survey arrays
 	 */
 	info = kcalloc(spec->num_channels, sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
+	rt2x00dev->chan_survey =
+		kcalloc(spec->num_channels, sizeof(struct rt2x00_chan_survey),
+			GFP_KERNEL);
+	if (!rt2x00dev->chan_survey) {
+		kfree(info);
+		return -ENOMEM;
+	}
+
 	spec->channels_info = info;
 
 	default_power1 = rt2800_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
@@ -10504,26 +10531,30 @@ int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
-	u32 idle, busy, busy_ext;
+	struct rt2x00_chan_survey *chan_survey =
+		   &rt2x00dev->chan_survey[idx];
+	enum nl80211_band band = NL80211_BAND_2GHZ;
 
-	if (idx != 0)
+	if (idx >= rt2x00dev->bands[band].n_channels) {
+		idx -= rt2x00dev->bands[band].n_channels;
+		band = NL80211_BAND_5GHZ;
+	}
+
+	if (idx >= rt2x00dev->bands[band].n_channels)
 		return -ENOENT;
 
-	survey->channel = conf->chandef.chan;
+	if (idx == 0)
+		rt2800_update_survey(rt2x00dev);
 
-	idle = rt2800_register_read(rt2x00dev, CH_IDLE_STA);
-	busy = rt2800_register_read(rt2x00dev, CH_BUSY_STA);
-	busy_ext = rt2800_register_read(rt2x00dev, CH_BUSY_STA_SEC);
+	survey->channel = &rt2x00dev->bands[band].channels[idx];
 
-	if (idle || busy) {
-		survey->filled = SURVEY_INFO_TIME |
-				 SURVEY_INFO_TIME_BUSY |
-				 SURVEY_INFO_TIME_EXT_BUSY;
+	survey->filled = SURVEY_INFO_TIME |
+			 SURVEY_INFO_TIME_BUSY |
+			 SURVEY_INFO_TIME_EXT_BUSY;
 
-		survey->time = (idle + busy) / 1000;
-		survey->time_busy = busy / 1000;
-		survey->time_ext_busy = busy_ext / 1000;
-	}
+	survey->time = div_u64(chan_survey->time_idle + chan_survey->time_busy, 1000);
+	survey->time_busy = div_u64(chan_survey->time_busy, 1000);
+	survey->time_ext_busy = div_u64(chan_survey->time_ext_busy, 1000);
 
 	if (!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
 		survey->filled |= SURVEY_INFO_IN_USE;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index ecc60d8cbb01..ae0c76067c4a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -181,6 +181,15 @@ struct rf_channel {
 	u32 rf4;
 };
 
+/*
+ * Information structure for channel survey.
+ */
+struct rt2x00_chan_survey {
+	u64 time_idle;
+	u64 time_busy;
+	u64 time_ext_busy;
+};
+
 /*
  * Channel information structure
  */
@@ -752,6 +761,7 @@ struct rt2x00_dev {
 	 */
 	struct ieee80211_hw *hw;
 	struct ieee80211_supported_band bands[NUM_NL80211_BANDS];
+	struct rt2x00_chan_survey *chan_survey;
 	enum nl80211_band curr_band;
 	int curr_freq;
 
-- 
2.17.1

________________________________________
От: Stanislaw Gruszka <stf_xl@wp.pl>
Отправлено: 20 октября 2020 г. 12:12
Кому: Марков Михаил Александрович
Копия: linux-wireless@vger.kernel.org; Helmut Schaa; Kalle Valo; "David S. Miller"; Jakub Kicinski; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; illumin@yandex.ru
Тема: Re: [PATCH] rt2x00: save survey for every channel visited

On Mon, Oct 19, 2020 at 07:06:47PM +0000, Марков Михаил Александрович wrote:
> rt2800 only gives you survey for current channel.
<snip>
>      .watchdog        = rt2800_watchdog,
> +    .update_survey        = rt2800_update_survey,

Since this feature is rt2800 specific, I would do not add new generic
callback. It could be fully done in rt2800* code, i.e ...

> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index 8c6d3099b19d..8eff57132154 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> @@ -1026,6 +1026,12 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
>      if (!rates)
>          goto exit_free_channels;
>
> +    rt2x00dev->chan_survey =
> +        kcalloc(spec->num_channels, sizeof(struct rt2x00_chan_survey),
> +            GFP_KERNEL);
> +    if (!rt2x00dev->chan_survey)
> +        goto exit_free_rates;
.. this could be placed in rt2800_probe_hw_mode() just after
channel info array allocation ...

> @@ -316,6 +316,15 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
>      if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
>          return 0;
>
> +    /*
> +     * To provide correct survey data for survey-based ACS algorithm
> +     * we have to save survey data for current channel before switching.
> +     */
> +    if (rt2x00dev->ops->lib->update_survey &&
> +        (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
.. and this in rt2800_config()

Thanks
Stanislaw
