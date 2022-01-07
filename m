Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0BB487437
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 09:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbiAGImg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 Jan 2022 03:42:36 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:60462 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbiAGImf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 03:42:35 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 2078gC4z9031079, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 2078gC4z9031079
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 7 Jan 2022 16:42:12 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 7 Jan 2022 16:42:12 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 7 Jan 2022 00:42:12 -0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Fri, 7 Jan 2022 16:42:12 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH 3/9] rtw88: Move rtw_update_sta_info() out of rtw_ra_mask_info_update_iter()
Thread-Topic: [PATCH 3/9] rtw88: Move rtw_update_sta_info() out of
 rtw_ra_mask_info_update_iter()
Thread-Index: AQHX/DAKvkoPg4jC/0epBaMSmZ/kxKxXS7/A
Date:   Fri, 7 Jan 2022 08:42:11 +0000
Message-ID: <1e9ed12ac55e42beb2197524c524e69f@realtek.com>
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
 <20211228211501.468981-4-martin.blumenstingl@googlemail.com>
In-Reply-To: <20211228211501.468981-4-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/1/7_=3F=3F_06:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Wednesday, December 29, 2021 5:15 AM
> To: linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@codeaurora.org; johannes@sipsolutions.net; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Neo Jou <neojou@gmail.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Pkshih <pkshih@realtek.com>; Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH 3/9] rtw88: Move rtw_update_sta_info() out of rtw_ra_mask_info_update_iter()
> 
> rtw_update_sta_info() internally access some registers while being
> called unter an atomic lock acquired by rtw_iterate_vifs_atomic(). Move
> rtw_update_sta_info() call out of (rtw_ra_mask_info_update_iter) in
> preparation for SDIO support where register access may sleep.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> v1 -> v2:
> - this patch is new in v2
> - keep rtw_iterate_vifs_atomic() to prevent deadlocks as Johannes
>   suggested. Keep track of all relevant stations inside
>   rtw_ra_mask_info_update_iter() and the iter-data and then call
>   rtw_update_sta_info() while held under rtwdev->mutex instead
> 
>  drivers/net/wireless/realtek/rtw88/mac80211.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c
> b/drivers/net/wireless/realtek/rtw88/mac80211.c
> index ae7d97de5fdf..3bd12354a8a1 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c

[...]

> @@ -699,11 +702,20 @@ static void rtw_ra_mask_info_update(struct rtw_dev *rtwdev,
>  				    const struct cfg80211_bitrate_mask *mask)
>  {
>  	struct rtw_iter_bitrate_mask_data br_data;
> +	unsigned int i;
> +
> +	mutex_lock(&rtwdev->mutex);

I think this lock is used to protect br_data.si[i], right?

And, I prefer to move mutex lock to caller, like:

@@ -734,7 +734,9 @@ static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
 {
        struct rtw_dev *rtwdev = hw->priv;

+       mutex_lock(&rtwdev->mutex);
        rtw_ra_mask_info_update(rtwdev, vif, mask);
+       mutex_unlock(&rtwdev->mutex);

        return 0;
 }

> 
>  	br_data.rtwdev = rtwdev;
>  	br_data.vif = vif;
>  	br_data.mask = mask;
> +	br_data.num_si = 0;
>  	rtw_iterate_stas_atomic(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
> +
> +	for (i = 0; i < br_data.num_si; i++)
> +		rtw_update_sta_info(rtwdev, br_data.si[i]);
> +
> +	mutex_unlock(&rtwdev->mutex);
>  }
> 

--
Ping-Ke


