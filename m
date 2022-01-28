Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C3849FD0B
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349665AbiA1Po6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:44:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37160 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiA1Po5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:44:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28D8660DD5;
        Fri, 28 Jan 2022 15:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27F4C340E0;
        Fri, 28 Jan 2022 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643384696;
        bh=tBLay+o+eLrzKqcv6juJyl5BpntLLfH1nmE4tQVkqOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y/G5V8Pvgkh6qVfEMzR5GQbkaMA4nl/3Tx5R5Wbxt/AJbXHo3nyc8ivxe1gkQCgno
         a5PwXkKvRyTfJUAIYbswanYXF15XWDyUz0EXiwiFjPs+Nip2ykPYcbmvsR4hJPpF4a
         6+rJm15brN+3A8EY/3P8TgJq1c2N7UH6WQMCJjGSRdMoHCsWkhfixNTotVuwzROgLD
         pUF7dSFbOLtvtU3SLIhOzhwoDdjfYDowZy5ZfXwleqbPLbCA5PAC7YyaMRm6MvltCi
         IgqmQ3XuTcnuG/QyHE+QvqVQomBX3KaZiuiWkTYsUaDyNpu+911BswVX0L8hvXUEEr
         uoB4xjcPIFAvg==
Date:   Fri, 28 Jan 2022 07:44:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: Re: [PATCH net-next v2 9/9] net: ethernet: mtk-star-emac: separate
 tx/rx handling with two NAPIs
Message-ID: <20220128074454.46d0ca29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2bdb6c9b5ec90b6c606b7db8c13f8acb34910b36.camel@mediatek.com>
References: <20220127015857.9868-1-biao.huang@mediatek.com>
        <20220127015857.9868-10-biao.huang@mediatek.com>
        <20220127194338.01722b3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2bdb6c9b5ec90b6c606b7db8c13f8acb34910b36.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 15:05:27 +0800 Biao Huang wrote:
> > > + * Description : this is the driver interrupt service routine.
> > > + * it mainly handles:
> > > + *  1. tx complete interrupt for frame transmission.
> > > + *  2. rx complete interrupt for frame reception.
> > > + *  3. MAC Management Counter interrupt to avoid counter overflow.
> > >   */
> > >  static irqreturn_t mtk_star_handle_irq(int irq, void *data)
> > >  {
> > > -	struct mtk_star_priv *priv;
> > > -	struct net_device *ndev;
> > > +	struct net_device *ndev = data;
> > > +	struct mtk_star_priv *priv = netdev_priv(ndev);
> > > +	unsigned int intr_status = mtk_star_intr_ack_all(priv);
> > > +	unsigned long flags = 0;
> > > +
> > > +	if (intr_status & MTK_STAR_BIT_INT_STS_FNRC) {
> > > +		if (napi_schedule_prep(&priv->rx_napi)) {
> > > +			spin_lock_irqsave(&priv->lock, flags);
> > > +			/* mask Rx Complete interrupt */
> > > +			mtk_star_disable_dma_irq(priv, true, false);
> > > +			spin_unlock_irqrestore(&priv->lock, flags);
> > > +			__napi_schedule_irqoff(&priv->rx_napi);
> > > +		}
> > > +	}
> > >  
> > > -	ndev = data;
> > > -	priv = netdev_priv(ndev);
> > > +	if (intr_status & MTK_STAR_BIT_INT_STS_TNTC) {
> > > +		if (napi_schedule_prep(&priv->tx_napi)) {
> > > +			spin_lock_irqsave(&priv->lock, flags);
> > > +			/* mask Tx Complete interrupt */
> > > +			mtk_star_disable_dma_irq(priv, false, true);
> > > +			spin_unlock_irqrestore(&priv->lock, flags);
> > > +			__napi_schedule_irqoff(&priv->tx_napi);
> > > +		}
> > > +	}  
> > 
> > Seems a little wasteful to retake the same lock twice if two IRQ
> > sources fire at the same time.  
> The TX/RX irq control bits are in the same register,
> but they are triggered independently.
> So it seems necessary to protect the register
> access with a spin lock.

This is what I meant:

rx = (status & RX) && napi_schedule_prep(rx_napi);
tx = (status & TX) && napi_schedule_prep(tx_napi);

if (rx || tx) {
	spin_lock()
	disable_irq(priv, rx, tx);	
	spin_unlock();
	if (rx)
		__napi_schedule_irqoff(rx_napi)
	if (tx)
		__napi_schedule_irqoff(tx_napi)
}

> > >  	desc_data.dma_addr = mtk_star_dma_map_tx(priv, skb);
> > >  	if (dma_mapping_error(dev, desc_data.dma_addr))
> > > @@ -1050,18 +1103,10 @@ static int
> > > mtk_star_netdev_start_xmit(struct sk_buff *skb,
> > >  
> > >  	desc_data.skb = skb;
> > >  	desc_data.len = skb->len;
> > > -
> > > -	spin_lock_bh(&priv->lock);
> > > 
> > >  	mtk_star_ring_push_head_tx(ring, &desc_data);
> > >  
> > >  	netdev_sent_queue(ndev, skb->len);
> > >  
> > > -	if (mtk_star_ring_full(ring))
> > > -		netif_stop_queue(ndev);  
> > 
> > Are you stopping the queue in advance somewhere else now? Did you
> > only
> > test this with BQL enabled? Only place that stops the ring also
> > prints
> > a loud warning now AFAICS..  
> No.
> 
> We modify the ring full condition, and will not invoke netif_stop_queue
> if queue is already stopped.

I don't understand what you're saying.

> Test pass no matter whether BQL is enabled or disabled.
> 
> It's much safer to judge queue is full or not at the beginning of
> start_xmit() to avoid invalid setting.

Drivers are expected to stop their queues at the end of xmit routine if
the ring can't accommodate another frame. It's more efficient to stop
the queues early than have to put skbs already dequeued from the qdisc
layer back into the qdiscs.
