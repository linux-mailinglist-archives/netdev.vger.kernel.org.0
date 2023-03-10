Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1506B350A
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 04:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCJDvC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Mar 2023 22:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjCJDvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 22:51:00 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461B4101F3D;
        Thu,  9 Mar 2023 19:50:59 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32A3oFplD010067, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32A3oFplD010067
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Fri, 10 Mar 2023 11:50:15 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 10 Mar 2023 11:49:49 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 10 Mar 2023 11:49:48 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Fri, 10 Mar 2023 11:49:48 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Dongliang Mu <dzm91@hust.edu.cn>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] wifi: rtw88: fix memory leak in rtw_usb_probe()
Thread-Topic: [PATCH v2] wifi: rtw88: fix memory leak in rtw_usb_probe()
Thread-Index: AQHZUi8SMsf/3uLRP0mluFYdnBlKyK7zYkMQ
Date:   Fri, 10 Mar 2023 03:49:48 +0000
Message-ID: <3a8382b826464d76b3c721e99613d6e9@realtek.com>
References: <20230309021636.528601-1-dzm91@hust.edu.cn>
In-Reply-To: <20230309021636.528601-1-dzm91@hust.edu.cn>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/3/9_=3F=3F_11:07:00?=
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
> From: Dongliang Mu <dzm91@hust.edu.cn>
> Sent: Thursday, March 9, 2023 10:17 AM
> To: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>
> Cc: Dongliang Mu <dzm91@hust.edu.cn>; linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH v2] wifi: rtw88: fix memory leak in rtw_usb_probe()
> 
> drivers/net/wireless/realtek/rtw88/usb.c:876 rtw_usb_probe()
> warn: 'hw' from ieee80211_alloc_hw() not released on lines: 811
> 
> Fix this by modifying return to a goto statement.
> 
> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
> v1->v2: modify the commit title
>  drivers/net/wireless/realtek/rtw88/usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
> index 2a8336b1847a..68e1b782d199 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -808,7 +808,7 @@ int rtw_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
> 
>         ret = rtw_usb_alloc_rx_bufs(rtwusb);
>         if (ret)
> -               return ret;
> +               goto err_release_hw;
> 
>         ret = rtw_core_init(rtwdev);
>         if (ret)
> --
> 2.39.2

