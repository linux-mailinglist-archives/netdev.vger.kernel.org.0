Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E39A628E63
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiKOAbY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Nov 2022 19:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKOAbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:31:23 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31F06D11D;
        Mon, 14 Nov 2022 16:31:23 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2AF0UGtF4016853, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2AF0UGtF4016853
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 15 Nov 2022 08:30:16 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Tue, 15 Nov 2022 08:30:56 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 15 Nov 2022 08:30:55 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Tue, 15 Nov 2022 08:30:55 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()
Thread-Topic: [PATCH] wifi: rtw89: Fix some error handling path in
 rtw89_core_sta_assoc()
Thread-Index: AQHY93eI5D4TEOTQ2EmDk/3qQhZtKK4/JA5Q
Date:   Tue, 15 Nov 2022 00:30:55 +0000
Message-ID: <3d97dc8a2b3447e998861ab6b8fb74af@realtek.com>
References: <7b1d82594635e4406d3438f33d8da29eaa056c5a.1668354547.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <7b1d82594635e4406d3438f33d8da29eaa056c5a.1668354547.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/14_=3F=3F_10:23:00?=
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
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Sunday, November 13, 2022 11:49 PM
> To: Ping-Ke Shih <pkshih@realtek.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Cc: linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Christophe JAILLET
> <christophe.jaillet@wanadoo.fr>; linux-wireless@vger.kernel.org; netdev@vger.kernel.org
> Subject: [PATCH] wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()
> 
> 'ret' is not updated after a function call in rtw89_core_sta_assoc().
> This prevent error handling from working.
> 
> Add the missing assignment.
> 
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw89/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
> index e716b96d0f56..f30aadc41f2b 100644
> --- a/drivers/net/wireless/realtek/rtw89/core.c
> +++ b/drivers/net/wireless/realtek/rtw89/core.c
> @@ -2535,7 +2535,7 @@ int rtw89_core_sta_assoc(struct rtw89_dev *rtwdev,
>  	}
> 
>  	/* update cam aid mac_id net_type */
> -	rtw89_fw_h2c_cam(rtwdev, rtwvif, rtwsta, NULL);
> +	ret = rtw89_fw_h2c_cam(rtwdev, rtwvif, rtwsta, NULL);
>  	if (ret) {
>  		rtw89_warn(rtwdev, "failed to send h2c cam\n");
>  		return ret;
> --
> 2.34.1

