Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD4614EA93
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 11:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgAaKXx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 31 Jan 2020 05:23:53 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:35106 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgAaKXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 05:23:53 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00VANfqG016275, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTEXMB06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00VANfqG016275
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jan 2020 18:23:41 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 31 Jan 2020 18:23:41 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 31 Jan 2020 18:23:40 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Fri, 31 Jan 2020 18:23:40 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: [PATCH] rtw88: Initialize ret in rtw_wow_check_fw_status
Thread-Topic: [PATCH] rtw88: Initialize ret in rtw_wow_check_fw_status
Thread-Index: AQHV1w0+cQfBiHwgKkKd8alOOCYKsqgEkmQA
Date:   Fri, 31 Jan 2020 10:23:40 +0000
Message-ID: <e0fb1ead6dcc4ecc973b3b9b5399ef66@realtek.com>
References: <20200130013308.16395-1-natechancellor@gmail.com>
In-Reply-To: <20200130013308.16395-1-natechancellor@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.175]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor
> Subject: [PATCH] rtw88: Initialize ret in rtw_wow_check_fw_status
> 
> Clang warns a few times (trimmed for brevity):
> 
> ../drivers/net/wireless/realtek/rtw88/wow.c:295:7: warning: variable
> 'ret' is used uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
> 
> Initialize ret to true and change the other assignments to false because
> it is a boolean value.
> 
> Fixes: 44bc17f7f5b3 ("rtw88: support wowlan feature for 8822c")
> Link: https://github.com/ClangBuiltLinux/linux/issues/850
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/wow.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/wow.c
> b/drivers/net/wireless/realtek/rtw88/wow.c
> index af5c27e1bb07..5db49802c72c 100644
> --- a/drivers/net/wireless/realtek/rtw88/wow.c
> +++ b/drivers/net/wireless/realtek/rtw88/wow.c
> @@ -283,18 +283,18 @@ static void rtw_wow_rx_dma_start(struct rtw_dev
> *rtwdev)
> 
>  static bool rtw_wow_check_fw_status(struct rtw_dev *rtwdev, bool
> wow_enable)
>  {
> -	bool ret;
> +	bool ret = true;
> 
>  	/* wait 100ms for wow firmware to finish work */
>  	msleep(100);
> 
>  	if (wow_enable) {
>  		if (!rtw_read8(rtwdev, REG_WOWLAN_WAKE_REASON))
> -			ret = 0;
> +			ret = false;
>  	} else {
>  		if (rtw_read32_mask(rtwdev, REG_FE1IMR, BIT_FS_RXDONE) == 0
> &&
>  		    rtw_read32_mask(rtwdev, REG_RXPKT_NUM,
> BIT_RW_RELEASE) == 0)
> -			ret = 0;
> +			ret = false;
>  	}
> 
>  	if (ret)
> --
> 2.25.0

NACK.

This patch could lead to incorrect behavior of WOW.
I will send a new patch to fix it, and change the type to "int".

Yan-Hsuan
