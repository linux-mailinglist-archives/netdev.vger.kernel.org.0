Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FF4695AEA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 08:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjBNHtw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Feb 2023 02:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjBNHtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 02:49:47 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D6C1E1D9;
        Mon, 13 Feb 2023 23:49:41 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31E7nFkrD018280, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31E7nFkrD018280
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Tue, 14 Feb 2023 15:49:15 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Tue, 14 Feb 2023 15:49:16 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 14 Feb 2023 15:49:16 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Tue, 14 Feb 2023 15:49:16 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Lu jicong <jiconglu58@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2] wifi: rtlwifi: rtl8192ce: fix dealing empty EEPROM values
Thread-Topic: [PATCH V2] wifi: rtlwifi: rtl8192ce: fix dealing empty EEPROM
 values
Thread-Index: AQHZQD9UVtZbD0wqL06rafBouwcZ0q7OD/AQ
Date:   Tue, 14 Feb 2023 07:49:16 +0000
Message-ID: <212c55c0308c4e33a92b3d2f62742675@realtek.com>
References: <20230214063602.2257263-1-jiconglu58@gmail.com>
In-Reply-To: <20230214063602.2257263-1-jiconglu58@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Lu jicong <jiconglu58@gmail.com>
> Sent: Tuesday, February 14, 2023 2:36 PM
> To: Ping-Ke Shih <pkshih@realtek.com>; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com
> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Lu jicong
> <jiconglu58@gmail.com>
> Subject: [PATCH V2] wifi: rtlwifi: rtl8192ce: fix dealing empty EEPROM values
> 
> On OpenWRT platform, RTL8192CE could be soldered on board, but not standard PCI
> module. In this case, some EEPROM values aren't programmed and left 0xff.
> Load default values when the EEPROM values are empty to avoid problems.
> 
> Signed-off-by: Lu jicong <jiconglu58@gmail.com>

As discussion privately, RTL8192CE on OpenWRT could be left some EEPROM values
as 0xff, so I think it's worth to add a patch to support this kind of RTL8192CE.
Since regular RTL8192CE must be programmed EEPROM values properly, this patch
can be compatible them. 

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
> v2: add more detailed commit message
> ---
>  .../wireless/realtek/rtlwifi/rtl8192ce/hw.c   | 31 +++++++++++++------
>  1 file changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
> b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
> index b9c62640d2cb..8ddf0017af4c 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
> @@ -1428,7 +1428,9 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
> 
>  	for (rf_path = 0; rf_path < 2; rf_path++) {
>  		for (i = 0; i < 3; i++) {
> -			if (!autoload_fail) {
> +			if (!autoload_fail &&
> +			    hwinfo[EEPROM_TXPOWERCCK + rf_path * 3 + i] != 0xff &&
> +			    hwinfo[EEPROM_TXPOWERHT40_1S + rf_path * 3 + i] != 0xff) {
>  				rtlefuse->
>  				    eeprom_chnlarea_txpwr_cck[rf_path][i] =
>  				    hwinfo[EEPROM_TXPOWERCCK + rf_path * 3 + i];
> @@ -1448,7 +1450,8 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
>  	}
> 
>  	for (i = 0; i < 3; i++) {
> -		if (!autoload_fail)
> +		if (!autoload_fail &&
> +		    hwinfo[EEPROM_TXPOWERHT40_2SDIFF + i] != 0xff)
>  			tempval = hwinfo[EEPROM_TXPOWERHT40_2SDIFF + i];
>  		else
>  			tempval = EEPROM_DEFAULT_HT40_2SDIFF;
> @@ -1518,7 +1521,9 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
>  	}
> 
>  	for (i = 0; i < 3; i++) {
> -		if (!autoload_fail) {
> +		if (!autoload_fail &&
> +		    hwinfo[EEPROM_TXPWR_GROUP + i] != 0xff &&
> +		    hwinfo[EEPROM_TXPWR_GROUP + 3 + i] != 0xff) {
>  			rtlefuse->eeprom_pwrlimit_ht40[i] =
>  			    hwinfo[EEPROM_TXPWR_GROUP + i];
>  			rtlefuse->eeprom_pwrlimit_ht20[i] =
> @@ -1563,7 +1568,8 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
>  	for (i = 0; i < 14; i++) {
>  		index = rtl92c_get_chnl_group((u8)i);
> 
> -		if (!autoload_fail)
> +		if (!autoload_fail &&
> +		    hwinfo[EEPROM_TXPOWERHT20DIFF + index] != 0xff)
>  			tempval = hwinfo[EEPROM_TXPOWERHT20DIFF + index];
>  		else
>  			tempval = EEPROM_DEFAULT_HT20_DIFF;
> @@ -1580,7 +1586,8 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
> 
>  		index = rtl92c_get_chnl_group((u8)i);
> 
> -		if (!autoload_fail)
> +		if (!autoload_fail &&
> +		    hwinfo[EEPROM_TXPOWER_OFDMDIFF + index] != 0xff)
>  			tempval = hwinfo[EEPROM_TXPOWER_OFDMDIFF + index];
>  		else
>  			tempval = EEPROM_DEFAULT_LEGACYHTTXPOWERDIFF;
> @@ -1610,14 +1617,16 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
>  			"RF-B Legacy to HT40 Diff[%d] = 0x%x\n",
>  			i, rtlefuse->txpwr_legacyhtdiff[RF90_PATH_B][i]);
> 
> -	if (!autoload_fail)
> +	if (!autoload_fail && hwinfo[RF_OPTION1] != 0xff)
>  		rtlefuse->eeprom_regulatory = (hwinfo[RF_OPTION1] & 0x7);
>  	else
>  		rtlefuse->eeprom_regulatory = 0;
>  	RTPRINT(rtlpriv, FINIT, INIT_TXPOWER,
>  		"eeprom_regulatory = 0x%x\n", rtlefuse->eeprom_regulatory);
> 
> -	if (!autoload_fail) {
> +	if (!autoload_fail &&
> +	    hwinfo[EEPROM_TSSI_A] != 0xff &&
> +	    hwinfo[EEPROM_TSSI_B] != 0xff) {
>  		rtlefuse->eeprom_tssi[RF90_PATH_A] = hwinfo[EEPROM_TSSI_A];
>  		rtlefuse->eeprom_tssi[RF90_PATH_B] = hwinfo[EEPROM_TSSI_B];
>  	} else {
> @@ -1628,7 +1637,7 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
>  		rtlefuse->eeprom_tssi[RF90_PATH_A],
>  		rtlefuse->eeprom_tssi[RF90_PATH_B]);
> 
> -	if (!autoload_fail)
> +	if (!autoload_fail && hwinfo[EEPROM_THERMAL_METER] != 0xff)
>  		tempval = hwinfo[EEPROM_THERMAL_METER];
>  	else
>  		tempval = EEPROM_DEFAULT_THERMALMETER;
> --
> 2.30.2

