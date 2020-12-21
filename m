Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2273F2DFD8D
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 16:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgLUP13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 10:27:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35716 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgLUP12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 10:27:28 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1krN5B-00D9ko-LI; Mon, 21 Dec 2020 16:26:45 +0100
Date:   Mon, 21 Dec 2020 16:26:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: lantiq_etop: check the result of request_irq()
Message-ID: <20201221152645.GH3026679@lunn.ch>
References: <20201221054323.247483-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201221054323.247483-1-masahiroy@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 02:43:23PM +0900, Masahiro Yamada wrote:
> The declaration of request_irq() in <linux/interrupt.h> is marked as
> __must_check.
> 
> Without the return value check, I see the following warnings:
> 
> drivers/net/ethernet/lantiq_etop.c: In function 'ltq_etop_hw_init':
> drivers/net/ethernet/lantiq_etop.c:273:4: warning: ignoring return value of 'request_irq', declared with attribute warn_unused_result [-Wunused-result]
>   273 |    request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
>       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/lantiq_etop.c:281:4: warning: ignoring return value of 'request_irq', declared with attribute warn_unused_result [-Wunused-result]
>   281 |    request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
>       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Reported-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
> 
>  drivers/net/ethernet/lantiq_etop.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
> index 2d0c52f7106b..960494f9752b 100644
> --- a/drivers/net/ethernet/lantiq_etop.c
> +++ b/drivers/net/ethernet/lantiq_etop.c
> @@ -264,13 +264,18 @@ ltq_etop_hw_init(struct net_device *dev)
>  	for (i = 0; i < MAX_DMA_CHAN; i++) {
>  		int irq = LTQ_DMA_CH0_INT + i;
>  		struct ltq_etop_chan *ch = &priv->ch[i];
> +		int ret;
>  
>  		ch->idx = ch->dma.nr = i;
>  		ch->dma.dev = &priv->pdev->dev;
>  
>  		if (IS_TX(i)) {
>  			ltq_dma_alloc_tx(&ch->dma);
> -			request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
> +			ret = request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
> +			if (ret) {
> +				netdev_err(dev, "failed to request irq\n");
> +				return ret;

You need to cleanup what ltq_dma_alloc_tx() did.

> +			}
>  		} else if (IS_RX(i)) {
>  			ltq_dma_alloc_rx(&ch->dma);
>  			for (ch->dma.desc = 0; ch->dma.desc < LTQ_DESC_NUM;
> @@ -278,7 +283,11 @@ ltq_etop_hw_init(struct net_device *dev)
>  				if (ltq_etop_alloc_skb(ch))
>  					return -ENOMEM;
>  			ch->dma.desc = 0;
> -			request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
> +			ret = request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
> +			if (ret) {
> +				netdev_err(dev, "failed to request irq\n");
> +				return ret;

And here you need to cleanup ltq_dma_alloc_rx().

    Andrew
