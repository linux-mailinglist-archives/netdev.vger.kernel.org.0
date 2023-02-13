Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E806940C9
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjBMJVU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Feb 2023 04:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBMJVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:21:19 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24146C169;
        Mon, 13 Feb 2023 01:21:17 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31D9KszF6014041, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31D9KszF6014041
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 13 Feb 2023 17:20:54 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Mon, 13 Feb 2023 17:20:55 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 13 Feb 2023 17:20:55 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 13 Feb 2023 17:20:55 +0800
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
Subject: RE: [PATCH] rtlwifi: reduce duplicate decision
Thread-Topic: [PATCH] rtlwifi: reduce duplicate decision
Thread-Index: AQHZPs9aXkh98hwRAU2rmp7vPIhLIK7Mmj9Q
Date:   Mon, 13 Feb 2023 09:20:55 +0000
Message-ID: <95d88453d583421da774bbe105206bdf@realtek.com>
References: <20230212104640.2018995-1-jiconglu58@gmail.com>
In-Reply-To: <20230212104640.2018995-1-jiconglu58@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/2/13_=3F=3F_06:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
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
> Sent: Sunday, February 12, 2023 6:47 PM
> To: Ping-Ke Shih <pkshih@realtek.com>; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com
> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Lu jicong
> <jiconglu58@gmail.com>
> Subject: [PATCH] rtlwifi: reduce duplicate decision

Need "wifi: " prefix.
Subject is too common. How about pointing out 'autoload' or something like that?


> 
> This return can go in previous decision.
> 
> Signed-off-by: Lu jicong <jiconglu58@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/efuse.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c
> b/drivers/net/wireless/realtek/rtlwifi/efuse.c
> index 2e945554ed6d..70c4e22fc426 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
> @@ -1243,14 +1243,12 @@ int rtl_get_hwinfo(struct ieee80211_hw *hw, struct rtl_priv *rtlpriv,
>  		rtl_dbg(rtlpriv, COMP_ERR, DBG_WARNING,
>  			"EEPROM ID(%#x) is invalid!!\n", eeprom_id);
>  		rtlefuse->autoload_failflag = true;
> +		return 1;
>  	} else {
>  		rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD, "Autoload OK\n");
>  		rtlefuse->autoload_failflag = false;
>  	}
> 
> -	if (rtlefuse->autoload_failflag)
> -		return 1;
> -

Honestly, I prefer the original version that looks more clear, and we don't need
to stir this chunk.

>  	rtlefuse->eeprom_vid = *(u16 *)&hwinfo[params[1]];
>  	rtlefuse->eeprom_did = *(u16 *)&hwinfo[params[2]];
>  	rtlefuse->eeprom_svid = *(u16 *)&hwinfo[params[3]];
> --
> 2.30.2

