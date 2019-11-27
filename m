Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560A410AD06
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfK0J6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:58:48 -0500
Received: from first.geanix.com ([116.203.34.67]:40472 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbfK0J6r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:58:47 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 8BE22932E2;
        Wed, 27 Nov 2019 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1574848501; bh=EqbvLJUqmlNqOu2BfsSKko8WT0L0d1pwMozqcVEo61M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=DrajxCbK2NpLi73k4FJUd4/Vv/yFXep5Hd90PsqfbeziX26wVfE0K+5/gJnoVOyfE
         VWkev2iZCRsjM7HSnfzQPxgqcz/eXZtty5E8NWZXcXwWcBymm3UETNKJKIeR5KmhB8
         MTWlWlK87bX3XfJXPRe/iAs+1/GPL1uusA1AR1ML/LCH/vcVwOJIw+XzqZOjp61V/u
         mTGWnyJMTPqDqR8kj7EC1IOMjOzNlqF03TvOYf3pvL/Y1ROLSeWTxq/D1t/JhWUoBm
         a9++Cpowi4A4u6H/VZJa5+owlh7GpYoJpM1zFaztoG2fPX36eC2jteXJ+vUfn07zxG
         /OyRTe6YHmEng==
Subject: Re: [PATCH V2 1/4] can: flexcan: fix deadlock when using self wakeup
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-2-qiangqing.zhang@nxp.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <199aa895-833c-f6b0-105b-1450600fc21e@geanix.com>
Date:   Wed, 27 Nov 2019 10:58:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191127055334.1476-2-qiangqing.zhang@nxp.com>
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
> From: Sean Nyekjaer <sean@geanix.com>
> 
> When suspending, when there is still can traffic on the interfaces the
> flexcan immediately wakes the platform again. As it should :-). But it
> throws this error msg:
> [ 3169.378661] PM: noirq suspend of devices failed
> 
> On the way down to suspend the interface that throws the error message does
> call flexcan_suspend but fails to call flexcan_noirq_suspend. That means the
> flexcan_enter_stop_mode is called, but on the way out of suspend the driver
> only calls flexcan_resume and skips flexcan_noirq_resume, thus it doesn't call
> flexcan_exit_stop_mode. This leaves the flexcan in stop mode, and with the
> current driver it can't recover from this even with a soft reboot, it requires
> a hard reboot.
> 
> This patch can fix deadlock when using self wakeup, it happenes to be
> able to fix another issue that frames out-of-order in first IRQ handler
> run after wakeup.
> 
> In wakeup case, after system resume, frames received out-of-order in
> first IRQ handler, the problem is wakeup latency from frame reception to
> IRQ handler is much bigger than the counter overflow. This means it's
> impossible to sort the CAN frames by timestamp. The reason is that controller
> exits stop mode during noirq resume, then it can receive the frame immediately.
> If noirq reusme stage consumes much time, it will extend interrupt response
> time. So exit stop mode during resume stage instead of noirq resume can
> fix this issue.
> 
> Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
> ------
> ChangeLog:
> 	V1->V2: no change.
> ---
>   drivers/net/can/flexcan.c | 19 +++++++++++--------
>   1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index 2efa06119f68..2297663cacb2 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -134,8 +134,7 @@
>   	(FLEXCAN_ESR_ERR_BUS | FLEXCAN_ESR_ERR_STATE)
>   #define FLEXCAN_ESR_ALL_INT \
>   	(FLEXCAN_ESR_TWRN_INT | FLEXCAN_ESR_RWRN_INT | \
> -	 FLEXCAN_ESR_BOFF_INT | FLEXCAN_ESR_ERR_INT | \
> -	 FLEXCAN_ESR_WAK_INT)
> +	 FLEXCAN_ESR_BOFF_INT | FLEXCAN_ESR_ERR_INT)
>   
>   /* FLEXCAN interrupt flag register (IFLAG) bits */
>   /* Errata ERR005829 step7: Reserve first valid MB */
> @@ -960,6 +959,12 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
>   
>   	reg_esr = priv->read(&regs->esr);
>   
> +	/* ACK wakeup interrupt */
> +	if (reg_esr & FLEXCAN_ESR_WAK_INT) {
> +		handled = IRQ_HANDLED;
> +		priv->write(reg_esr & FLEXCAN_ESR_WAK_INT, &regs->esr);
> +	}
> +
>   	/* ACK all bus error and state change IRQ sources */
>   	if (reg_esr & FLEXCAN_ESR_ALL_INT) {
>   		handled = IRQ_HANDLED;
> @@ -1722,6 +1727,9 @@ static int __maybe_unused flexcan_resume(struct device *device)
>   		netif_start_queue(dev);
>   		if (device_may_wakeup(device)) {
>   			disable_irq_wake(dev->irq);
> +			err = flexcan_exit_stop_mode(priv);
> +			if (err)
> +				return err;
>   		} else {
>   			err = pm_runtime_force_resume(device);
>   			if (err)
> @@ -1767,14 +1775,9 @@ static int __maybe_unused flexcan_noirq_resume(struct device *device)
>   {
>   	struct net_device *dev = dev_get_drvdata(device);
>   	struct flexcan_priv *priv = netdev_priv(dev);
> -	int err;
>   
> -	if (netif_running(dev) && device_may_wakeup(device)) {
> +	if (netif_running(dev) && device_may_wakeup(device))
>   		flexcan_enable_wakeup_irq(priv, false);
> -		err = flexcan_exit_stop_mode(priv);
> -		if (err)
> -			return err;
> -	}
>   
>   	return 0;
>   }
> 
