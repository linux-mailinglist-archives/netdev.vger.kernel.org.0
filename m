Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4CF658B26
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 10:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbiL2Jkp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Dec 2022 04:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbiL2Jim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 04:38:42 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F61B12A91;
        Thu, 29 Dec 2022 01:37:29 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BT9aKnG5025140, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BT9aKnG5025140
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 29 Dec 2022 17:36:20 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 29 Dec 2022 17:37:14 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 29 Dec 2022 17:37:14 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 29 Dec 2022 17:37:14 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
Thread-Topic: [PATCH 2/4] rtw88: Configure the registers from rtw_bf_assoc()
 outside the RCU lock
Thread-Index: AQHZGsFurUjvb3aD0kCYMaooMT/wGK6EnLJg
Date:   Thu, 29 Dec 2022 09:37:14 +0000
Message-ID: <7523003b476f45aea711a6abb634cc57@realtek.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
 <20221228133547.633797-3-martin.blumenstingl@googlemail.com>
In-Reply-To: <20221228133547.633797-3-martin.blumenstingl@googlemail.com>
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
> Subject: [PATCH 2/4] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
> 
> USB and (upcoming) SDIO support may sleep in the read/write handlers.
> Shrink the RCU critical section so it only cover the call to
> ieee80211_find_sta() and finding the ic_vht_cap/vht_cap based on the
> found station. This moves the chip's BFEE configuration outside the
> rcu_read_lock section and thus prevent "scheduling while atomic" or
> "Voluntary context switch within RCU read-side critical section!"
> warnings when accessing the registers using an SDIO card (which is
> where this issue has been spotted in the real world - but it also
> affects USB cards).
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>


> ---
>  drivers/net/wireless/realtek/rtw88/bf.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/bf.c b/drivers/net/wireless/realtek/rtw88/bf.c
> index 038a30b170ef..c827c4a2814b 100644
> --- a/drivers/net/wireless/realtek/rtw88/bf.c
> +++ b/drivers/net/wireless/realtek/rtw88/bf.c
> @@ -49,19 +49,23 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
> 
>  	sta = ieee80211_find_sta(vif, bssid);
>  	if (!sta) {
> +		rcu_read_unlock();
> +
>  		rtw_warn(rtwdev, "failed to find station entry for bss %pM\n",
>  			 bssid);
> -		goto out_unlock;
> +		return;
>  	}
> 
>  	ic_vht_cap = &hw->wiphy->bands[NL80211_BAND_5GHZ]->vht_cap;
>  	vht_cap = &sta->deflink.vht_cap;
> 
> +	rcu_read_unlock();
> +
>  	if ((ic_vht_cap->cap & IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE) &&
>  	    (vht_cap->cap & IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)) {
>  		if (bfinfo->bfer_mu_cnt >= chip->bfer_mu_max_num) {
>  			rtw_dbg(rtwdev, RTW_DBG_BF, "mu bfer number over limit\n");
> -			goto out_unlock;
> +			return;
>  		}
> 
>  		ether_addr_copy(bfee->mac_addr, bssid);
> @@ -75,7 +79,7 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
>  		   (vht_cap->cap & IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)) {
>  		if (bfinfo->bfer_su_cnt >= chip->bfer_su_max_num) {
>  			rtw_dbg(rtwdev, RTW_DBG_BF, "su bfer number over limit\n");
> -			goto out_unlock;
> +			return;
>  		}
> 
>  		sound_dim = vht_cap->cap &
> @@ -98,9 +102,6 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
> 
>  		rtw_chip_config_bfee(rtwdev, rtwvif, bfee, true);
>  	}
> -
> -out_unlock:
> -	rcu_read_unlock();
>  }
> 
>  void rtw_bf_init_bfer_entry_mu(struct rtw_dev *rtwdev,
> --
> 2.39.0

