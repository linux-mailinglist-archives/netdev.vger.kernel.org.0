Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D00658B2E
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 10:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiL2Jms convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Dec 2022 04:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbiL2Jkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 04:40:42 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40A5512D29;
        Thu, 29 Dec 2022 01:39:38 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BT9cUM21026268, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BT9cUM21026268
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 29 Dec 2022 17:38:30 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 29 Dec 2022 17:39:24 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 29 Dec 2022 17:39:24 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 29 Dec 2022 17:39:24 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/4] rtw88: Use non-atomic rtw_iterate_stas() in rtw_ra_mask_info_update()
Thread-Topic: [PATCH 4/4] rtw88: Use non-atomic rtw_iterate_stas() in
 rtw_ra_mask_info_update()
Thread-Index: AQHZGsFuDJ0s6Ba8rkOgPtvNKrTJ9K6EnVFQ
Date:   Thu, 29 Dec 2022 09:39:24 +0000
Message-ID: <b4a237a786dc46fab383aab3c26cac60@realtek.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
 <20221228133547.633797-5-martin.blumenstingl@googlemail.com>
In-Reply-To: <20221228133547.633797-5-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/29_=3F=3F_07:25:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Wednesday, December 28, 2022 9:36 PM
> To: linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@kernel.org; Ping-Ke Shih <pkshih@realtek.com>; tehuang@realtek.com;
> s.hauer@pengutronix.de; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Martin Blumenstingl
> <martin.blumenstingl@googlemail.com>
> Subject: [PATCH 4/4] rtw88: Use non-atomic rtw_iterate_stas() in rtw_ra_mask_info_update()
> 
> USB and (upcoming) SDIO support may sleep in the read/write handlers.
> Use non-atomic rtw_iterate_stas() in rtw_ra_mask_info_update() because
> the iterator function rtw_ra_mask_info_update_iter() needs to read and
> write registers from within rtw_update_sta_info(). Using the non-atomic
> iterator ensures that we can sleep during USB and SDIO register reads
> and writes. This fixes "scheduling while atomic" or "Voluntary context
> switch within RCU read-side critical section!" warnings as seen by SDIO
> card users (but it also affects USB cards).
> 
> Fixes: 78d5bf925f30 ("wifi: rtw88: iterate over vif/sta list non-atomically")
> Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw88/mac80211.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c
> b/drivers/net/wireless/realtek/rtw88/mac80211.c
> index 776a9a9884b5..3b92ac611d3f 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -737,7 +737,7 @@ static void rtw_ra_mask_info_update(struct rtw_dev *rtwdev,
>  	br_data.rtwdev = rtwdev;
>  	br_data.vif = vif;
>  	br_data.mask = mask;
> -	rtw_iterate_stas_atomic(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
> +	rtw_iterate_stas(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
>  }
> 
>  static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
> @@ -746,7 +746,9 @@ static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
>  {
>  	struct rtw_dev *rtwdev = hw->priv;
> 
> +	mutex_lock(&rtwdev->mutex);
>  	rtw_ra_mask_info_update(rtwdev, vif, mask);
> +	mutex_unlock(&rtwdev->mutex);
> 
>  	return 0;
>  }
> --
> 2.39.0

