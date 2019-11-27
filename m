Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF40910AD0A
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfK0J7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:59:06 -0500
Received: from first.geanix.com ([116.203.34.67]:40484 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbfK0J7G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:59:06 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 77787932E2;
        Wed, 27 Nov 2019 09:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1574848519; bh=550yh0WqHSwAJsBZEPoNt0ZuxTL9MA4Pwlz0992BOXE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=WTsZlUP2lWiAV9RUJtjShma22mtGWV3DYx/De4zeZx+w0dSOxt7ewoQIGv4rb5e7Z
         cONYh2wSlTKjTn28AaoLSp0kCtqCAIuurl12UFoN8OtOrIsWF7FvfEMlo77O+yU0lK
         tVfiZjeMizR5jSSAp7Ch+wLbx5Cowv0jQzTKPccESrHF9YstlrX5jqWOHHU4Fp3XIn
         x4evgqnEYmZjjJ5dZ6Heus+Clh0aU2nJeMsnjERLdwxJ+amb27y10nee0M9yooDau7
         7fQSD4D0LUSG80Q9wElQDZYcPk3Ls+Cx5osQXqLRIguIMyDrMiZS7e7ciGri/7oyOY
         5QZXJ1D7DnHng==
Subject: Re: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-3-qiangqing.zhang@nxp.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <5fe4918e-2ec1-0b88-1f02-3c2d39c99e07@geanix.com>
Date:   Wed, 27 Nov 2019 10:58:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191127055334.1476-3-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b0d531b295e6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/11/2019 06.56, Joakim Zhang wrote:
> CAN controller could be stucked in stop mode once it enters stop mode
> when suspend, and then it fails to exit stop mode when resume. Only code
> reset can get CAN out of stop mode, so add stop mode remove request
> during probe stage for other methods(soft reset from chip level,
> unbind/bind driver, etc) to let CAN active again. MCR[LPMACK] will be
> checked when enable CAN in register_flexcandev().
> 
> Suggested-by: Sean Nyekjaer <sean@geanix.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
> ------
> ChangeLog:
> 	V1->V2: new add.
> ---
>   drivers/net/can/flexcan.c | 28 ++++++++++++++++++++++------
>   1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index 2297663cacb2..5d5ed28d3005 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -449,6 +449,13 @@ static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
>   	return 0;
>   }
>   
> +static void flexcan_try_exit_stop_mode(struct flexcan_priv *priv)
> +{
> +	/* remove stop request */
> +	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
> +			   1 << priv->stm.req_bit, 0);
> +}
> +
>   static inline void flexcan_error_irq_enable(const struct flexcan_priv *priv)
>   {
>   	struct flexcan_regs __iomem *regs = priv->regs;
> @@ -1649,6 +1656,21 @@ static int flexcan_probe(struct platform_device *pdev)
>   	priv->devtype_data = devtype_data;
>   	priv->reg_xceiver = reg_xceiver;
>   
> +	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE) {
> +		err = flexcan_setup_stop_mode(pdev);
> +		if (err)
> +			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
> +
> +		/* CAN controller could be stucked in stop mode once it enters
> +		 * stop mode when suspend, and then it fails to exit stop
> +		 * mode when resume. Only code reset can get CAN out of stop
> +		 * mode, so add stop mode remove request here for other methods
> +		 * (soft reset, bind, etc) to let CAN active again. MCR[LPMACK]
> +		 * will be checked when enable CAN in register_flexcandev().
> +		 */
> +		flexcan_try_exit_stop_mode(priv);
> +	}
> +
>   	pm_runtime_get_noresume(&pdev->dev);
>   	pm_runtime_set_active(&pdev->dev);
>   	pm_runtime_enable(&pdev->dev);
> @@ -1661,12 +1683,6 @@ static int flexcan_probe(struct platform_device *pdev)
>   
>   	devm_can_led_init(dev);
>   
> -	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE) {
> -		err = flexcan_setup_stop_mode(pdev);
> -		if (err)
> -			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
> -	}
> -
>   	return 0;
>   
>    failed_register:
> 
