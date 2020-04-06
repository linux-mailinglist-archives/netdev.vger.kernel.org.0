Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC77719F406
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgDFLBo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Apr 2020 07:01:44 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60770 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgDFLBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 07:01:44 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 036B1KSr8017517, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 036B1KSr8017517
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 6 Apr 2020 19:01:20 +0800
Received: from RTEXMB03.realtek.com.tw (172.21.6.96) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 6 Apr 2020 19:01:20 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 6 Apr 2020 19:01:20 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Mon, 6 Apr 2020 19:01:20 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtw88: Add delay on polling h2c command status bit
Thread-Topic: [PATCH] rtw88: Add delay on polling h2c command status bit
Thread-Index: AQHWC/bdJYgYrtvTIE2p2Ip9l+r986hr7Eug
Date:   Mon, 6 Apr 2020 11:01:20 +0000
Message-ID: <3b815e889a934491bca23593a84532d7@realtek.com>
References: <20200406093623.3980-1-kai.heng.feng@canonical.com>
In-Reply-To: <20200406093623.3980-1-kai.heng.feng@canonical.com>
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

> Subject: [PATCH] rtw88: Add delay on polling h2c command status bit
> 
> On some systems we can constanly see rtw88 complains:
> [39584.721375] rtw_pci 0000:03:00.0: failed to send h2c command
> 
> Increase interval of each check to wait the status bit really changes.
> 
> While at it, add some helpers so we can use standarized
> readx_poll_timeout() macro.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/wireless/realtek/rtw88/fw.c  | 12 ++++++------
>  drivers/net/wireless/realtek/rtw88/hci.h |  4 ++++
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c
> b/drivers/net/wireless/realtek/rtw88/fw.c
> index 05c430b3489c..bc9982e77524 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -2,6 +2,8 @@
>  /* Copyright(c) 2018-2019  Realtek Corporation
>   */
> 
> +#include <linux/iopoll.h>
> +
>  #include "main.h"
>  #include "coex.h"
>  #include "fw.h"
> @@ -193,8 +195,8 @@ static void rtw_fw_send_h2c_command(struct
> rtw_dev *rtwdev,
>  	u8 box;
>  	u8 box_state;
>  	u32 box_reg, box_ex_reg;
> -	u32 h2c_wait;
>  	int idx;
> +	int ret;
> 
>  	rtw_dbg(rtwdev, RTW_DBG_FW,
>  		"send H2C content %02x%02x%02x%02x %02x%02x%02x%02x\n",
> @@ -226,12 +228,10 @@ static void rtw_fw_send_h2c_command(struct
> rtw_dev *rtwdev,
>  		goto out;
>  	}
> 
> -	h2c_wait = 20;
> -	do {
> -		box_state = rtw_read8(rtwdev, REG_HMETFR);
> -	} while ((box_state >> box) & 0x1 && --h2c_wait > 0);
> +	ret = readx_poll_timeout(rr8, REG_HMETFR, box_state,
> +				 !((box_state >> box) & 0x1), 100, 3000);
> 
> -	if (!h2c_wait) {
> +	if (ret) {
>  		rtw_err(rtwdev, "failed to send h2c command\n");
>  		goto out;
>  	}
> diff --git a/drivers/net/wireless/realtek/rtw88/hci.h
> b/drivers/net/wireless/realtek/rtw88/hci.h
> index 2cba327e6218..24062c7079c6 100644
> --- a/drivers/net/wireless/realtek/rtw88/hci.h
> +++ b/drivers/net/wireless/realtek/rtw88/hci.h
> @@ -253,6 +253,10 @@ rtw_write8_mask(struct rtw_dev *rtwdev, u32 addr,
> u32 mask, u8 data)
>  	rtw_write8(rtwdev, addr, set);
>  }
> 
> +#define rr8(addr)      rtw_read8(rtwdev, addr)
> +#define rr16(addr)     rtw_read16(rtwdev, addr)
> +#define rr32(addr)     rtw_read32(rtwdev, addr)
> +
>  static inline enum rtw_hci_type rtw_hci_type(struct rtw_dev *rtwdev)
>  {
>  	return rtwdev->hci.type;
> --

I think the timeout is because the H2C is triggered when the lower 4 bytes are written.
So, we probably should write h2c[4] ~ h2c[7] before h2c[0] ~ h2c[3].

But this delay still works, I think you can keep it, and reorder the h2c write sequence.

Yen-Hsuan
