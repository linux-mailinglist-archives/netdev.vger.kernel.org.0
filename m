Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64361CBD93
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389329AbfJDOky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:40:54 -0400
Received: from mail.bitwise.fi ([109.204.228.163]:44302 "EHLO mail.bitwise.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389119AbfJDOkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 10:40:53 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Oct 2019 10:40:52 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.bitwise.fi (Postfix) with ESMTP id A3E8260027;
        Fri,  4 Oct 2019 17:32:55 +0300 (EEST)
X-Virus-Scanned: Debian amavisd-new at mail.bitwise.fi
Received: from mail.bitwise.fi ([127.0.0.1])
        by localhost (mail.bitwise.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1_nSWJbb_H5q; Fri,  4 Oct 2019 17:32:52 +0300 (EEST)
Received: from [192.168.5.238] (fw1.dmz.bitwise.fi [192.168.69.1])
        (using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: anssiha)
        by mail.bitwise.fi (Postfix) with ESMTPSA id C99FB60064;
        Fri,  4 Oct 2019 17:32:52 +0300 (EEST)
Subject: Re: [PATCH 2/6] net: can: xilinx_can: Fix flags field initialization
 for axi can and canps
To:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org
References: <1552908766-26753-1-git-send-email-appana.durga.rao@xilinx.com>
 <1552908766-26753-3-git-send-email-appana.durga.rao@xilinx.com>
From:   Anssi Hannula <anssi.hannula@bitwise.fi>
Message-ID: <d1bedb13-f66f-b0fd-bd6d-9f95b64fc405@bitwise.fi>
Date:   Fri, 4 Oct 2019 17:32:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1552908766-26753-3-git-send-email-appana.durga.rao@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.3.2019 13.32, Appana Durga Kedareswara rao wrote:
> AXI CAN IP and CANPS IP supports tx fifo empty feature, this patch updates
> the flags field for the same.
>
> Signed-off-by: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
> ---
>  drivers/net/can/xilinx_can.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> index 2de51ac..22569ef 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -1428,6 +1428,7 @@ static const struct dev_pm_ops xcan_dev_pm_ops = {
>  };
>  
>  static const struct xcan_devtype_data xcan_zynq_data = {
> +	.flags = XCAN_FLAG_TXFEMP,
>  	.bittiming_const = &xcan_bittiming_const,
>  	.btr_ts2_shift = XCAN_BTR_TS2_SHIFT,
>  	.btr_sjw_shift = XCAN_BTR_SJW_SHIFT,

Thanks for catching this, this line seemed to have been incorrectly
removed by my 9e5f1b273e ("can: xilinx_can: add support for Xilinx CAN
FD core").

But:

> @@ -1435,6 +1436,7 @@ static const struct xcan_devtype_data xcan_zynq_data = {
>  };
>  
>  static const struct xcan_devtype_data xcan_axi_data = {
> +	.flags = XCAN_FLAG_TXFEMP,
>  	.bittiming_const = &xcan_bittiming_const,
>  	.btr_ts2_shift = XCAN_BTR_TS2_SHIFT,
>  	.btr_sjw_shift = XCAN_BTR_SJW_SHIFT,


Are you sure this is right?
In the documentation [1] there does not seem to be any TXFEMP interrupt,
it would be interrupt bit 14 but AXI CAN 5.0 seems to only go up to 11.

Or maybe it is undocumented or there is a newer version somewhere?

[1]
https://www.xilinx.com/support/documentation/ip_documentation/can/v5_0/pg096-can.pdf

-- 
Anssi Hannula / Bitwise Oy
+358 503803997

