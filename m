Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710DB4D7B1E
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 08:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbiCNHCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 03:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiCNHCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 03:02:44 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C487F40900;
        Mon, 14 Mar 2022 00:01:34 -0700 (PDT)
X-UUID: 4decd2aa2f854a098042a04bf0a4a7e3-20220314
X-UUID: 4decd2aa2f854a098042a04bf0a4a7e3-20220314
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 669941624; Mon, 14 Mar 2022 15:01:27 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Mon, 14 Mar 2022 15:01:26 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Mar 2022 15:01:23 +0800
Message-ID: <2d0ab5290e63069f310987a4423ef2a46f02f1b3.camel@mediatek.com>
Subject: Re: [PATCH net-next v2 9/9] net: ethernet: mtk-star-emac: separate
 tx/rx handling with two NAPIs
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     David Miller <davem@davemloft.net>,
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
Date:   Mon, 14 Mar 2022 15:01:23 +0800
In-Reply-To: <20220128074454.46d0ca29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220127015857.9868-1-biao.huang@mediatek.com>
         <20220127015857.9868-10-biao.huang@mediatek.com>
         <20220127194338.01722b3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <2bdb6c9b5ec90b6c606b7db8c13f8acb34910b36.camel@mediatek.com>
         <20220128074454.46d0ca29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub,
	Thanks for your comments~

On Fri, 2022-01-28 at 07:44 -0800, Jakub Kicinski wrote:
> On Fri, 28 Jan 2022 15:05:27 +0800 Biao Huang wrote:
> > > > + * Description : this is the driver interrupt service routine.
> > > > + * it mainly handles:
> > > > + *  1. tx complete interrupt for frame transmission.
> > > > + *  2. rx complete interrupt for frame reception.
> > > > + *  3. MAC Management Counter interrupt to avoid counter
> > > > overflow.
> > > >   */
> > > >  static irqreturn_t mtk_star_handle_irq(int irq, void *data)
> > > >  {
> > > > -	struct mtk_star_priv *priv;
> > > > -	struct net_device *ndev;
> > > > +	struct net_device *ndev = data;
> > > > +	struct mtk_star_priv *priv = netdev_priv(ndev);
> > > > +	unsigned int intr_status = mtk_star_intr_ack_all(priv);
> > > > +	unsigned long flags = 0;
> > > > +
> > > > +	if (intr_status & MTK_STAR_BIT_INT_STS_FNRC) {
> > > > +		if (napi_schedule_prep(&priv->rx_napi)) {
> > > > +			spin_lock_irqsave(&priv->lock, flags);
> > > > +			/* mask Rx Complete interrupt */
> > > > +			mtk_star_disable_dma_irq(priv, true,
> > > > false);
> > > > +			spin_unlock_irqrestore(&priv->lock,
> > > > flags);
> > > > +			__napi_schedule_irqoff(&priv->rx_napi);
> > > > +		}
> > > > +	}
> > > >  
> > > > -	ndev = data;
> > > > -	priv = netdev_priv(ndev);
> > > > +	if (intr_status & MTK_STAR_BIT_INT_STS_TNTC) {
> > > > +		if (napi_schedule_prep(&priv->tx_napi)) {
> > > > +			spin_lock_irqsave(&priv->lock, flags);
> > > > +			/* mask Tx Complete interrupt */
> > > > +			mtk_star_disable_dma_irq(priv, false,
> > > > true);
> > > > +			spin_unlock_irqrestore(&priv->lock,
> > > > flags);
> > > > +			__napi_schedule_irqoff(&priv->tx_napi);
> > > > +		}
> > > > +	}  
> > > 
> > > Seems a little wasteful to retake the same lock twice if two IRQ
> > > sources fire at the same time.  
> > 
> > The TX/RX irq control bits are in the same register,
> > but they are triggered independently.
> > So it seems necessary to protect the register
> > access with a spin lock.
> 
> This is what I meant:
> 
> rx = (status & RX) && napi_schedule_prep(rx_napi);
> tx = (status & TX) && napi_schedule_prep(tx_napi);
> 
> if (rx || tx) {
> 	spin_lock()
> 	disable_irq(priv, rx, tx);	
> 	spin_unlock();
> 	if (rx)
> 		__napi_schedule_irqoff(rx_napi)
> 	if (tx)
> 		__napi_schedule_irqoff(tx_napi)
> }
> 
OK, We'll adopt your suggestion, and corresponding modification will be
added in next send.
> > > >  	desc_data.dma_addr = mtk_star_dma_map_tx(priv, skb);
> > > >  	if (dma_mapping_error(dev, desc_data.dma_addr))
> > > > @@ -1050,18 +1103,10 @@ static int
> > > > mtk_star_netdev_start_xmit(struct sk_buff *skb,
> > > >  
> > > >  	desc_data.skb = skb;
> > > >  	desc_data.len = skb->len;
> > > > -
> > > > -	spin_lock_bh(&priv->lock);
> > > > 
> > > >  	mtk_star_ring_push_head_tx(ring, &desc_data);
> > > >  
> > > >  	netdev_sent_queue(ndev, skb->len);
> > > >  
> > > > -	if (mtk_star_ring_full(ring))
> > > > -		netif_stop_queue(ndev);  
> > > 
> > > Are you stopping the queue in advance somewhere else now? Did you
> > > only
> > > test this with BQL enabled? Only place that stops the ring also
> > > prints
> > > a loud warning now AFAICS..  
> > 
> > No.
> > 
> > We modify the ring full condition, and will not invoke
> > netif_stop_queue
> > if queue is already stopped.
> 
> I don't understand what you're saying.
> 
> > Test pass no matter whether BQL is enabled or disabled.
> > 
> > It's much safer to judge queue is full or not at the beginning of
> > start_xmit() to avoid invalid setting.
> 
> Drivers are expected to stop their queues at the end of xmit routine
> if
> the ring can't accommodate another frame. It's more efficient to stop
> the queues early than have to put skbs already dequeued from the
> qdisc
> layer back into the qdiscs.
Yes, if descriptors ring is full, it's meaningful to stop the queue 
at the end of xmit; 
But driver seems hard to know how many descriptors the next skb will
request, e.g. 3 descriptors are available for next round send, but the
next skb may need 4 descriptors, in this case, we still need judge
whether descriptors are enough for skb transmission, then decide stop
the queue or not, at the beginning of xmit routine.

Maybe we should judge ring is full or not at the beginning and the end
of xmit routine(seems a little redundancy).

Regards~

