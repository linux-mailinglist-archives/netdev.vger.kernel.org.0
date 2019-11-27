Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B62210AD10
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfK0J7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:59:35 -0500
Received: from first.geanix.com ([116.203.34.67]:40536 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfK0J7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:59:34 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id ECD98932E2;
        Wed, 27 Nov 2019 09:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1574848548; bh=pCBMs1+4TyKgx4Yf4XCivsPLFaR7wIHPML0iaaZtTIo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=RA+u824bqYGCua2R5aq1z0Y0toxOngDc1Wa6ao9/XOvRCWedchdZff1W9TtkMGL+a
         Qfc3ZjkDqQY7Vnw8K0tHPrsJRsqWac0tUZM/STvg9RrFwL4GtDGWgYYTrHNE+9Ktz9
         B68NKgPT/k/GbdznZXMf4VX7eL0l9uiYAKQZx/X7SuQNw1mGecyDp5kGCXtz+Rr3sl
         oToyWAFNHeDHN4fLtNAh7fSCqPBTQtNb6J5dIWtmnKEaqn3fgPgQ9yqZhmS8W+/yar
         e/MUGpked3UhZvwCl8evJZJ5EN8/NZ/gpk+qusbF8Ymj4XSISNGYOULHuyEV2fdD0v
         4Vf3Qb+uyWlIg==
Subject: Re: [PATCH V2 3/4] can: flexcan: change the way of stop mode
 acknowledgment
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-4-qiangqing.zhang@nxp.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <9924005b-6136-534d-4a5d-e41716803038@geanix.com>
Date:   Wed, 27 Nov 2019 10:58:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191127055334.1476-4-qiangqing.zhang@nxp.com>
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
> Stop mode is entered when Stop mode is requested at chip level and
> MCR[LPM_ACK] is asserted by the FlexCAN.
> 
> Double check with IP owner, should poll MCR[LPM_ACK] for stop mode
> acknowledgment, not the acknowledgment from chip level which is used
> for glitch filter.
> 
> Fixes: 5f186c257fa4(can: flexcan: fix stop mode acknowledgment)
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
> ------
> ChangeLog:
> 	V1->V2: no change.
> ---
>   drivers/net/can/flexcan.c | 64 ++++++++++++++++++++-------------------
>   1 file changed, 33 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index 5d5ed28d3005..d178146b3da5 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -388,6 +388,34 @@ static struct flexcan_mb __iomem *flexcan_get_mb(const struct flexcan_priv *priv
>   		(&priv->regs->mb[bank][priv->mb_size * mb_index]);
>   }
>   
> +static int flexcan_enter_low_power_ack(struct flexcan_priv *priv)
> +{
> +	struct flexcan_regs __iomem *regs = priv->regs;
> +	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
> +
> +	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> +		udelay(10);
> +
> +	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}
> +
> +static int flexcan_exit_low_power_ack(struct flexcan_priv *priv)
> +{
> +	struct flexcan_regs __iomem *regs = priv->regs;
> +	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
> +
> +	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> +		udelay(10);
> +
> +	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}
> +
>   static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool enable)
>   {
>   	struct flexcan_regs __iomem *regs = priv->regs;
> @@ -406,7 +434,6 @@ static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool enable)
>   static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
>   {
>   	struct flexcan_regs __iomem *regs = priv->regs;
> -	unsigned int ackval;
>   	u32 reg_mcr;
>   
>   	reg_mcr = priv->read(&regs->mcr);
> @@ -418,35 +445,24 @@ static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
>   			   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
>   
>   	/* get stop acknowledgment */
> -	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
> -				     ackval, ackval & (1 << priv->stm.ack_bit),
> -				     0, FLEXCAN_TIMEOUT_US))
> -		return -ETIMEDOUT;
> -
> -	return 0;
> +	return flexcan_enter_low_power_ack(priv);
>   }
>   
>   static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
>   {
>   	struct flexcan_regs __iomem *regs = priv->regs;
> -	unsigned int ackval;
>   	u32 reg_mcr;
>   
>   	/* remove stop request */
>   	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
>   			   1 << priv->stm.req_bit, 0);
>   
> -	/* get stop acknowledgment */
> -	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
> -				     ackval, !(ackval & (1 << priv->stm.ack_bit)),
> -				     0, FLEXCAN_TIMEOUT_US))
> -		return -ETIMEDOUT;
> -
>   	reg_mcr = priv->read(&regs->mcr);
>   	reg_mcr &= ~FLEXCAN_MCR_SLF_WAK;
>   	priv->write(reg_mcr, &regs->mcr);
>   
> -	return 0;
> +	/* get stop acknowledgment */
> +	return flexcan_exit_low_power_ack(priv);
>   }
>   
>   static void flexcan_try_exit_stop_mode(struct flexcan_priv *priv)
> @@ -512,39 +528,25 @@ static inline int flexcan_transceiver_disable(const struct flexcan_priv *priv)
>   static int flexcan_chip_enable(struct flexcan_priv *priv)
>   {
>   	struct flexcan_regs __iomem *regs = priv->regs;
> -	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
>   	u32 reg;
>   
>   	reg = priv->read(&regs->mcr);
>   	reg &= ~FLEXCAN_MCR_MDIS;
>   	priv->write(reg, &regs->mcr);
>   
> -	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> -		udelay(10);
> -
> -	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
> -		return -ETIMEDOUT;
> -
> -	return 0;
> +	return flexcan_exit_low_power_ack(priv);
>   }
>   
>   static int flexcan_chip_disable(struct flexcan_priv *priv)
>   {
>   	struct flexcan_regs __iomem *regs = priv->regs;
> -	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
>   	u32 reg;
>   
>   	reg = priv->read(&regs->mcr);
>   	reg |= FLEXCAN_MCR_MDIS;
>   	priv->write(reg, &regs->mcr);
>   
> -	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> -		udelay(10);
> -
> -	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> -		return -ETIMEDOUT;
> -
> -	return 0;
> +	return flexcan_enter_low_power_ack(priv);
>   }
>   
>   static int flexcan_chip_freeze(struct flexcan_priv *priv)
> 
