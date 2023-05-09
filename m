Return-Path: <netdev+bounces-1070-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F8C6FC136
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C1211C20970
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7090F17AC2;
	Tue,  9 May 2023 08:06:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFB738C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86436C433D2;
	Tue,  9 May 2023 08:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683619592;
	bh=pnpJkZ6ShhWSccuSvXs3t8FG3FEoNoM8n+mK8NfLCos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eqIDo8ef+XbfwKb1XhQRKECddNn9sQudtSuICHKq4/0S/i5QHQZp+bcfzlbg9ZML9
	 yDZocQAz/ush4VaNfOcZpoz+4ujJrFrqk/37FpD8K/h6UxeS4OAGB/L8lf6feN3uJu
	 JO41sqmuWc7SN6UV0EmUG5tVxbwvZWyZFTrneOs7OCmntN90pO4NEyJTTHpA03qVtq
	 kn09d6CYZHICdEewk+CpamUPStP9lUxjnHORldAqadvaLgC4aCXD3b2OnrcRBuDqC5
	 4+0JfEfTh7TvuB3Rk72uPlSEQ/XqrR7SbYOcGf/I09MxrPve7tx4nNB/+Y7PJZ4sbD
	 72GKE9VyWKF9w==
Date: Tue, 9 May 2023 11:06:27 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Philipp Rosenberger <p.rosenberger@kunbus.com>,
	Zhi Han <hanzhi09@gmail.com>
Subject: Re: [PATCH net-next] net: enc28j60: Use threaded interrupt instead
 of workqueue
Message-ID: <20230509080627.GF38143@unreal>
References: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>

On Tue, May 09, 2023 at 06:28:56AM +0200, Lukas Wunner wrote:
> From: Philipp Rosenberger <p.rosenberger@kunbus.com>
> 
> The Microchip ENC28J60 SPI Ethernet driver schedules a work item from
> the interrupt handler because accesses to the SPI bus may sleep.
> 
> On PREEMPT_RT (which forces interrupt handling into threads) this
> old-fashioned approach unnecessarily increases latency because an
> interrupt results in first waking the interrupt thread, then scheduling
> the work item.  So, a double indirection to handle an interrupt.
> 
> Avoid by converting the driver to modern threaded interrupt handling.
> 
> Signed-off-by: Philipp Rosenberger <p.rosenberger@kunbus.com>
> Signed-off-by: Zhi Han <hanzhi09@gmail.com>
> [lukas: rewrite commit message, linewrap request_threaded_irq() call]

This is part of changelog which doesn't belong to commit message. The
examples which you can find in git log, for such format like you used,
are usually reserved to maintainers when they apply the patch.

Thanks

> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  drivers/net/ethernet/microchip/enc28j60.c | 28 +++++------------------
>  1 file changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
> index 176efbeae127..d6c9491537e4 100644
> --- a/drivers/net/ethernet/microchip/enc28j60.c
> +++ b/drivers/net/ethernet/microchip/enc28j60.c
> @@ -58,7 +58,6 @@ struct enc28j60_net {
>  	struct mutex lock;
>  	struct sk_buff *tx_skb;
>  	struct work_struct tx_work;
> -	struct work_struct irq_work;
>  	struct work_struct setrx_work;
>  	struct work_struct restart_work;
>  	u8 bank;		/* current register bank selected */
> @@ -1118,10 +1117,9 @@ static int enc28j60_rx_interrupt(struct net_device *ndev)
>  	return ret;
>  }
>  
> -static void enc28j60_irq_work_handler(struct work_struct *work)
> +static irqreturn_t enc28j60_irq(int irq, void *dev_id)
>  {
> -	struct enc28j60_net *priv =
> -		container_of(work, struct enc28j60_net, irq_work);
> +	struct enc28j60_net *priv = dev_id;
>  	struct net_device *ndev = priv->netdev;
>  	int intflags, loop;
>  
> @@ -1225,6 +1223,8 @@ static void enc28j60_irq_work_handler(struct work_struct *work)
>  
>  	/* re-enable interrupts */
>  	locked_reg_bfset(priv, EIE, EIE_INTIE);
> +
> +	return IRQ_HANDLED;
>  }
>  
>  /*
> @@ -1309,22 +1309,6 @@ static void enc28j60_tx_work_handler(struct work_struct *work)
>  	enc28j60_hw_tx(priv);
>  }
>  
> -static irqreturn_t enc28j60_irq(int irq, void *dev_id)
> -{
> -	struct enc28j60_net *priv = dev_id;
> -
> -	/*
> -	 * Can't do anything in interrupt context because we need to
> -	 * block (spi_sync() is blocking) so fire of the interrupt
> -	 * handling workqueue.
> -	 * Remember that we access enc28j60 registers through SPI bus
> -	 * via spi_sync() call.
> -	 */
> -	schedule_work(&priv->irq_work);
> -
> -	return IRQ_HANDLED;
> -}
> -
>  static void enc28j60_tx_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct enc28j60_net *priv = netdev_priv(ndev);
> @@ -1559,7 +1543,6 @@ static int enc28j60_probe(struct spi_device *spi)
>  	mutex_init(&priv->lock);
>  	INIT_WORK(&priv->tx_work, enc28j60_tx_work_handler);
>  	INIT_WORK(&priv->setrx_work, enc28j60_setrx_work_handler);
> -	INIT_WORK(&priv->irq_work, enc28j60_irq_work_handler);
>  	INIT_WORK(&priv->restart_work, enc28j60_restart_work_handler);
>  	spi_set_drvdata(spi, priv);	/* spi to priv reference */
>  	SET_NETDEV_DEV(dev, &spi->dev);
> @@ -1578,7 +1561,8 @@ static int enc28j60_probe(struct spi_device *spi)
>  	/* Board setup must set the relevant edge trigger type;
>  	 * level triggers won't currently work.
>  	 */
> -	ret = request_irq(spi->irq, enc28j60_irq, 0, DRV_NAME, priv);
> +	ret = request_threaded_irq(spi->irq, NULL, enc28j60_irq, IRQF_ONESHOT,
> +				   DRV_NAME, priv);
>  	if (ret < 0) {
>  		if (netif_msg_probe(priv))
>  			dev_err(&spi->dev, "request irq %d failed (ret = %d)\n",
> -- 
> 2.39.2
> 
> 

