Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD0F49F403
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346642AbiA1HFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:05:33 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:50134 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S242660AbiA1HFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:05:32 -0500
X-UUID: 239db7c3b33240db89b4a730e45ffa28-20220128
X-UUID: 239db7c3b33240db89b4a730e45ffa28-20220128
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 199247826; Fri, 28 Jan 2022 15:05:30 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 28 Jan 2022 15:05:30 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 28 Jan 2022 15:05:27 +0800
Message-ID: <2bdb6c9b5ec90b6c606b7db8c13f8acb34910b36.camel@mediatek.com>
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
Date:   Fri, 28 Jan 2022 15:05:27 +0800
In-Reply-To: <20220127194338.01722b3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220127015857.9868-1-biao.huang@mediatek.com>
         <20220127015857.9868-10-biao.huang@mediatek.com>
         <20220127194338.01722b3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub,
	Thanks for your comments!

On Thu, 2022-01-27 at 19:43 -0800, Jakub Kicinski wrote:
> On Thu, 27 Jan 2022 09:58:57 +0800 Biao Huang wrote:
> > Current driver may lost tx interrupts under bidirectional test with
> > iperf3,
> > which leads to some unexpected issues.
> > 
> > This patch let rx/tx interrupt enable/disable separately, and rx/tx
> > are
> > handled in different NAPIs.
> > +/* mtk_star_handle_irq - Interrupt Handler.
> > + * @irq: interrupt number.
> > + * @data: pointer to a network interface device structure.
> 
> if you mean this to me a kdoc comment it needs to start with /**
Yes, will fix in next send.
> 
> > + * Description : this is the driver interrupt service routine.
> > + * it mainly handles:
> > + *  1. tx complete interrupt for frame transmission.
> > + *  2. rx complete interrupt for frame reception.
> > + *  3. MAC Management Counter interrupt to avoid counter overflow.
> >   */
> >  static irqreturn_t mtk_star_handle_irq(int irq, void *data)
> >  {
> > -	struct mtk_star_priv *priv;
> > -	struct net_device *ndev;
> > +	struct net_device *ndev = data;
> > +	struct mtk_star_priv *priv = netdev_priv(ndev);
> > +	unsigned int intr_status = mtk_star_intr_ack_all(priv);
> > +	unsigned long flags = 0;
> > +
> > +	if (intr_status & MTK_STAR_BIT_INT_STS_FNRC) {
> > +		if (napi_schedule_prep(&priv->rx_napi)) {
> > +			spin_lock_irqsave(&priv->lock, flags);
> > +			/* mask Rx Complete interrupt */
> > +			mtk_star_disable_dma_irq(priv, true, false);
> > +			spin_unlock_irqrestore(&priv->lock, flags);
> > +			__napi_schedule_irqoff(&priv->rx_napi);
> > +		}
> > +	}
> >  
> > -	ndev = data;
> > -	priv = netdev_priv(ndev);
> > +	if (intr_status & MTK_STAR_BIT_INT_STS_TNTC) {
> > +		if (napi_schedule_prep(&priv->tx_napi)) {
> > +			spin_lock_irqsave(&priv->lock, flags);
> > +			/* mask Tx Complete interrupt */
> > +			mtk_star_disable_dma_irq(priv, false, true);
> > +			spin_unlock_irqrestore(&priv->lock, flags);
> > +			__napi_schedule_irqoff(&priv->tx_napi);
> > +		}
> > +	}
> 
> Seems a little wasteful to retake the same lock twice if two IRQ
> sources fire at the same time.
The TX/RX irq control bits are in the same register,
but they are triggered independently.
So it seems necessary to protect the register
access with a spin lock.
> 
> > @@ -1043,6 +1085,17 @@ static int mtk_star_netdev_start_xmit(struct
> > sk_buff *skb,
> >  	struct mtk_star_ring *ring = &priv->tx_ring;
> >  	struct device *dev = mtk_star_get_dev(priv);
> >  	struct mtk_star_ring_desc_data desc_data;
> > +	int nfrags = skb_shinfo(skb)->nr_frags;
> > +
> > +	if (unlikely(mtk_star_tx_ring_avail(ring) < nfrags + 1)) {
> > +		if (!netif_queue_stopped(ndev)) {
> > +			netif_stop_queue(ndev);
> > +			/* This is a hard error, log it. */
> > +			netdev_err(priv->ndev, "%s: Tx Ring full when
> > queue awake\n",
> > +				   __func__);
> 
> This needs to be rate limited. Also no point printing the function
> name, unless the same message appears in multiple places.
OK, will fix in next send.
> 
> > +		}
> > +		return NETDEV_TX_BUSY;
> > +	}
> >  
> >  	desc_data.dma_addr = mtk_star_dma_map_tx(priv, skb);
> >  	if (dma_mapping_error(dev, desc_data.dma_addr))
> > @@ -1050,18 +1103,10 @@ static int
> > mtk_star_netdev_start_xmit(struct sk_buff *skb,
> >  
> >  	desc_data.skb = skb;
> >  	desc_data.len = skb->len;
> > -
> > -	spin_lock_bh(&priv->lock);
> > 
> >  	mtk_star_ring_push_head_tx(ring, &desc_data);
> >  
> >  	netdev_sent_queue(ndev, skb->len);
> >  
> > -	if (mtk_star_ring_full(ring))
> > -		netif_stop_queue(ndev);
> 
> Are you stopping the queue in advance somewhere else now? Did you
> only
> test this with BQL enabled? Only place that stops the ring also
> prints
> a loud warning now AFAICS..
No.

We modify the ring full condition, and will not invoke netif_stop_queue
if queue is already stopped.
Test pass no matter whether BQL is enabled or disabled.

It's much safer to judge queue is full or not at the beginning of
start_xmit() to avoid invalid setting.
> 
> > -static void mtk_star_tx_complete_all(struct mtk_star_priv *priv)
> > +static int mtk_star_tx_poll(struct napi_struct *napi, int budget)
> >  {
> > -	struct mtk_star_ring *ring = &priv->tx_ring;
> > -	struct net_device *ndev = priv->ndev;
> > -	int ret, pkts_compl, bytes_compl;
> > +	int ret, pkts_compl = 0, bytes_compl = 0, count = 0;
> > +	struct mtk_star_priv *priv;
> > +	struct mtk_star_ring *ring;
> > +	struct net_device *ndev;
> > +	unsigned long flags = 0;
> > +	unsigned int entry;
> >  	bool wake = false;
> >  
> > -	spin_lock(&priv->lock);
> > +	priv = container_of(napi, struct mtk_star_priv, tx_napi);
> > +	ndev = priv->ndev;
> >  
> > -	for (pkts_compl = 0, bytes_compl = 0;;
> > +	__netif_tx_lock_bh(netdev_get_tx_queue(priv->ndev, 0));
> 
> Do you really need to lock out the Tx while cleaning?
> 
> Drivers usually manage to implement concurrent Tx and cleanup with
> just
> a couple of memory barriers.
We'll simplify the lock handling in next send,
the lock should protect tx descriptor ring, which is accessed by xmit()
and tx_complete().
> 
> > +	ring = &priv->tx_ring;
> > +	entry = ring->tail;
> > +	for (pkts_compl = 0, bytes_compl = 0;
> > +	     (entry != ring->head) && (count < budget);
> 
> budget is not really relevant for Tx, you can clean the whole ring.
> netpoll will pass a budget of 0 to clean up rings.
OK, will fix in next send.
> 
> >  	     pkts_compl++, bytes_compl += ret, wake = true) {
> > -		if (!mtk_star_ring_descs_available(ring))
> > -			break;
> >  
> >  		ret = mtk_star_tx_complete_one(priv);
> >  		if (ret < 0)
> >  			break;
> > +		count++;
> > +		entry = ring->tail;
> >  	}
> >  
> > @@ -1196,7 +1258,7 @@ static const struct ethtool_ops
> > mtk_star_ethtool_ops = {
> >  	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
> >  };
> >  
> > -static int mtk_star_receive_packet(struct mtk_star_priv *priv)
> > +static int mtk_star_rx(struct mtk_star_priv *priv, int budget)
> >  {
> >  	struct mtk_star_ring *ring = &priv->rx_ring;
> >  	struct device *dev = mtk_star_get_dev(priv);
> > @@ -1204,107 +1266,86 @@ static int mtk_star_receive_packet(struct
> > mtk_star_priv *priv)
> >  	struct net_device *ndev = priv->ndev;
> >  	struct sk_buff *curr_skb, *new_skb;
> >  	dma_addr_t new_dma_addr;
> > -	int ret;
> > +	int ret, count = 0;
> >  
> > -	spin_lock(&priv->lock);
> > -	ret = mtk_star_ring_pop_tail(ring, &desc_data);
> > -	spin_unlock(&priv->lock);
> > -	if (ret)
> > -		return -1;
> > +	while (count < budget) {
> > +		ret = mtk_star_ring_pop_tail(ring, &desc_data);
> > +		if (ret)
> > +			return -1;
> > -static int mtk_star_process_rx(struct mtk_star_priv *priv, int
> > budget)
> > -{
> > -	int received, ret;
> > +		count++;
> >  
> > -	for (received = 0, ret = 0; received < budget && ret == 0;
> > received++)
> > -		ret = mtk_star_receive_packet(priv);
> > +		desc_data.len = skb_tailroom(new_skb);
> > +		desc_data.skb = new_skb;
> > +		mtk_star_ring_push_head_rx(ring, &desc_data);
> > +	}
> >  
> >  	mtk_star_dma_resume_rx(priv);
> 
> Again you can get a call with a budget of 0, not sure if it's okay to
> resume DMA in that case..
OK, we'll take it into consideration in next send.
> 
> > -	return received;
> > +	return count;
> >  }
> 
> 
Regards!
Biao

