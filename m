Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9E43D4867
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 17:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhGXPF3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 24 Jul 2021 11:05:29 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:22279 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhGXPF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Jul 2021 11:05:29 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4GX9Wq5LCfzB98V;
        Sat, 24 Jul 2021 17:45:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 85scSz3fQsun; Sat, 24 Jul 2021 17:45:59 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4GX9Wq43tZzB97C;
        Sat, 24 Jul 2021 17:45:59 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id D9D58653; Sat, 24 Jul 2021 17:51:15 +0200 (CEST)
Received: from 37-165-72-176.coucou-networks.fr
 (37-165-72-176.coucou-networks.fr [37.165.72.176]) by messagerie.c-s.fr
 (Horde Framework) with HTTP; Sat, 24 Jul 2021 17:51:15 +0200
Date:   Sat, 24 Jul 2021 17:51:15 +0200
Message-ID: <20210724175115.Horde.YWZWzH4jmau2AO_D_X9IHw1@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Geoff Levand <geoff@infradead.org>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 02/10] net/ps3_gelic: Use local dev variable
References: <cover.1627068552.git.geoff@infradead.org>
 <26f56a1c8332d227156cd33586b176a329570117.1627068552.git.geoff@infradead.org>
In-Reply-To: <26f56a1c8332d227156cd33586b176a329570117.1627068552.git.geoff@infradead.org>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geoff Levand <geoff@infradead.org> a écrit :

> In an effort to make the PS3 gelic driver easier to maintain, add a
> local variable dev to those routines that use the device structure that
> makes the use the device structure more consistent.
>
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 340 +++++++++++--------
>  1 file changed, 191 insertions(+), 149 deletions(-)
>
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c  
> b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index cb45571573d7..ba008a98928a 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -48,13 +48,15 @@ MODULE_LICENSE("GPL");
>  /* set irq_mask */
>  int gelic_card_set_irq_mask(struct gelic_card *card, u64 mask)
>  {
> +	struct device *dev = ctodev(card);
>  	int status;
>
>  	status = lv1_net_set_interrupt_mask(bus_id(card), dev_id(card),
>  					    mask, 0);
> -	if (status)
> -		dev_info(ctodev(card),
> -			 "%s failed %d\n", __func__, status);
> +	if (status) {

There shall be no { } for single line statements. And anyway this  
change is not part of this patch as it is unrelated to the use of  
local dev variable.

> +		dev_err(dev, "%s:%d failed: %d\n", __func__, __LINE__, status);
> +	}
> +
>  	return status;
>  }
>
> @@ -103,6 +105,7 @@ gelic_descr_get_status(struct gelic_descr *descr)
>
>  static int gelic_card_set_link_mode(struct gelic_card *card, int mode)
>  {
> +	struct device *dev = ctodev(card);
>  	int status;
>  	u64 v1, v2;
>
> @@ -110,8 +113,8 @@ static int gelic_card_set_link_mode(struct  
> gelic_card *card, int mode)
>  				 GELIC_LV1_SET_NEGOTIATION_MODE,
>  				 GELIC_LV1_PHY_ETHERNET_0, mode, 0, &v1, &v2);
>  	if (status) {
> -		pr_info("%s: failed setting negotiation mode %d\n", __func__,
> -			status);
> +		dev_err(dev, "%s:%d: Failed setting negotiation mode: %d\n",
> +			__func__, __LINE__, status);

Changing from pr_info to dev_err is unrelated to the use of a dev local var

>  		return -EBUSY;
>  	}
>
> @@ -128,13 +131,15 @@ static int gelic_card_set_link_mode(struct  
> gelic_card *card, int mode)
>   */
>  static void gelic_card_disable_txdmac(struct gelic_card *card)
>  {
> +	struct device *dev = ctodev(card);
>  	int status;
>
>  	/* this hvc blocks until the DMA in progress really stopped */
>  	status = lv1_net_stop_tx_dma(bus_id(card), dev_id(card));
> -	if (status)
> -		dev_err(ctodev(card),
> -			"lv1_net_stop_tx_dma failed, status=%d\n", status);
> +
> +	if (status) {
> +		dev_err(dev, "lv1_net_stop_tx_dma failed, status=%d\n", status);
> +	}
>  }
>
>  /**
> @@ -146,6 +151,7 @@ static void gelic_card_disable_txdmac(struct  
> gelic_card *card)
>   */
>  static void gelic_card_enable_rxdmac(struct gelic_card *card)
>  {
> +	struct device *dev = ctodev(card);
>  	int status;
>
>  #ifdef DEBUG
> @@ -161,9 +167,10 @@ static void gelic_card_enable_rxdmac(struct  
> gelic_card *card)
>  #endif
>  	status = lv1_net_start_rx_dma(bus_id(card), dev_id(card),
>  				card->rx_chain.head->link.cpu_addr, 0);
> -	if (status)
> -		dev_info(ctodev(card),
> -			 "lv1_net_start_rx_dma failed, status=%d\n", status);
> +	if (status) {
> +		dev_err(dev, "lv1_net_start_rx_dma failed, status=%d\n",
> +			status);
> +	}
>  }
>
>  /**
> @@ -175,13 +182,15 @@ static void gelic_card_enable_rxdmac(struct  
> gelic_card *card)
>   */
>  static void gelic_card_disable_rxdmac(struct gelic_card *card)
>  {
> +	struct device *dev = ctodev(card);
>  	int status;
>
>  	/* this hvc blocks until the DMA in progress really stopped */
>  	status = lv1_net_stop_rx_dma(bus_id(card), dev_id(card));
> -	if (status)
> -		dev_err(ctodev(card),
> -			"lv1_net_stop_rx_dma failed, %d\n", status);
> +
> +	if (status) {
> +		dev_err(dev, "lv1_net_stop_rx_dma failed, %d\n", status);
> +	}
>  }
>
>  /**
> @@ -235,10 +244,11 @@ static void gelic_card_reset_chain(struct  
> gelic_card *card,
>
>  void gelic_card_up(struct gelic_card *card)
>  {
> -	pr_debug("%s: called\n", __func__);
> +	struct device *dev = ctodev(card);
> +
>  	mutex_lock(&card->updown_lock);
>  	if (atomic_inc_return(&card->users) == 1) {
> -		pr_debug("%s: real do\n", __func__);
> +		dev_dbg(dev, "%s:%d: Starting...\n", __func__, __LINE__);
>  		/* enable irq */
>  		gelic_card_set_irq_mask(card, card->irq_mask);
>  		/* start rx */
> @@ -247,16 +257,16 @@ void gelic_card_up(struct gelic_card *card)
>  		napi_enable(&card->napi);
>  	}
>  	mutex_unlock(&card->updown_lock);
> -	pr_debug("%s: done\n", __func__);
>  }
>
>  void gelic_card_down(struct gelic_card *card)
>  {
> +	struct device *dev = ctodev(card);
>  	u64 mask;
> -	pr_debug("%s: called\n", __func__);
> +
>  	mutex_lock(&card->updown_lock);
>  	if (atomic_dec_if_positive(&card->users) == 0) {
> -		pr_debug("%s: real do\n", __func__);
> +		dev_dbg(dev, "%s:%d: Stopping...\n", __func__, __LINE__);
>  		napi_disable(&card->napi);
>  		/*
>  		 * Disable irq. Wireless interrupts will
> @@ -273,7 +283,6 @@ void gelic_card_down(struct gelic_card *card)
>  		gelic_card_disable_txdmac(card);
>  	}
>  	mutex_unlock(&card->updown_lock);
> -	pr_debug("%s: done\n", __func__);
>  }
>
>  /**
> @@ -284,11 +293,12 @@ void gelic_card_down(struct gelic_card *card)
>  static void gelic_card_free_chain(struct gelic_card *card,
>  				  struct gelic_descr *descr_in)
>  {
> +	struct device *dev = ctodev(card);
>  	struct gelic_descr *descr;
>
>  	for (descr = descr_in; descr && descr->link.cpu_addr; descr =  
> descr->next) {
> -		dma_unmap_single(ctodev(card), descr->link.cpu_addr,
> -				 descr->link.size, DMA_BIDIRECTIONAL);
> +		dma_unmap_single(dev, descr->link.cpu_addr, descr->link.size,
> +			DMA_BIDIRECTIONAL);
>  		descr->link.cpu_addr = 0;
>  	}
>  }
> @@ -311,6 +321,7 @@ static int gelic_card_init_chain(struct gelic_card *card,
>  {
>  	int i;
>  	struct gelic_descr *descr;
> +	struct device *dev = ctodev(card);
>
>  	descr = start_descr;
>  	memset(descr, 0, sizeof(*descr) * no);
> @@ -320,9 +331,8 @@ static int gelic_card_init_chain(struct gelic_card *card,
>  		descr->link.size = sizeof(struct gelic_hw_regs);
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		descr->link.cpu_addr =
> -			dma_map_single(ctodev(card), descr,
> -				       descr->link.size,
> -				       DMA_BIDIRECTIONAL);
> +			dma_map_single(dev, descr, descr->link.size,
> +				DMA_BIDIRECTIONAL);
>
>  		if (!descr->link.cpu_addr)
>  			goto iommu_error;
> @@ -351,7 +361,7 @@ static int gelic_card_init_chain(struct gelic_card *card,
>  iommu_error:
>  	for (i--, descr--; 0 <= i; i--, descr--)
>  		if (descr->link.cpu_addr)
> -			dma_unmap_single(ctodev(card), descr->link.cpu_addr,
> +			dma_unmap_single(dev, descr->link.cpu_addr,
>  					 descr->link.size,
>  					 DMA_BIDIRECTIONAL);
>  	return -ENOMEM;
> @@ -370,11 +380,14 @@ static int gelic_card_init_chain(struct  
> gelic_card *card,
>  static int gelic_descr_prepare_rx(struct gelic_card *card,
>  				  struct gelic_descr *descr)
>  {
> +	struct device *dev = ctodev(card);
>  	int offset;
>  	unsigned int bufsize;
>
> -	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
> -		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
> +	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE) {
> +		dev_err(dev, "%s:%d: ERROR status\n", __func__, __LINE__);
> +	}
> +
>  	/* we need to round up the buffer size to a multiple of 128 */
>  	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
>
> @@ -396,14 +409,14 @@ static int gelic_descr_prepare_rx(struct  
> gelic_card *card,
>  	if (offset)
>  		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
>  	/* io-mmu-map the skb */
> -	descr->hw_regs.payload.dev_addr = cpu_to_be32(dma_map_single(ctodev(card),
> +	descr->hw_regs.payload.dev_addr = cpu_to_be32(dma_map_single(dev,
>  						     descr->skb->data,
>  						     GELIC_NET_MAX_MTU,
>  						     DMA_FROM_DEVICE));
>  	if (!descr->hw_regs.payload.dev_addr) {
>  		dev_kfree_skb_any(descr->skb);
>  		descr->skb = NULL;
> -		dev_info(ctodev(card),
> +		dev_info(dev,
>  			 "%s:Could not iommu-map rx buffer\n", __func__);
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		return -ENOMEM;
> @@ -421,10 +434,11 @@ static int gelic_descr_prepare_rx(struct  
> gelic_card *card,
>  static void gelic_card_release_rx_chain(struct gelic_card *card)
>  {
>  	struct gelic_descr *descr = card->rx_chain.head;
> +	struct device *dev = ctodev(card);
>
>  	do {
>  		if (descr->skb) {
> -			dma_unmap_single(ctodev(card),
> +			dma_unmap_single(dev,
>  					 be32_to_cpu(descr->hw_regs.payload.dev_addr),
>  					 descr->skb->len,
>  					 DMA_FROM_DEVICE);
> @@ -493,10 +507,11 @@ static void gelic_descr_release_tx(struct  
> gelic_card *card,
>  				       struct gelic_descr *descr)
>  {
>  	struct sk_buff *skb = descr->skb;
> +	struct device *dev = ctodev(card);
>
>  	BUG_ON(!(be32_to_cpu(descr->hw_regs.data_status) & GELIC_DESCR_TX_TAIL));
>
> -	dma_unmap_single(ctodev(card),  
> be32_to_cpu(descr->hw_regs.payload.dev_addr), skb->len,
> +	dma_unmap_single(dev,  
> be32_to_cpu(descr->hw_regs.payload.dev_addr), skb->len,
>  			 DMA_TO_DEVICE);
>  	dev_kfree_skb_any(skb);
>
> @@ -538,6 +553,7 @@ static void gelic_card_release_tx_chain(struct  
> gelic_card *card, int stop)
>  {
>  	struct gelic_descr_chain *tx_chain;
>  	enum gelic_descr_dma_status status;
> +	struct device *dev = ctodev(card);
>  	struct net_device *netdev;
>  	int release = 0;
>
> @@ -550,11 +566,9 @@ static void gelic_card_release_tx_chain(struct  
> gelic_card *card, int stop)
>  		case GELIC_DESCR_DMA_RESPONSE_ERROR:
>  		case GELIC_DESCR_DMA_PROTECTION_ERROR:
>  		case GELIC_DESCR_DMA_FORCE_END:
> -			if (printk_ratelimit())
> -				dev_info(ctodev(card),
> -					 "%s: forcing end of tx descriptor " \
> -					 "with status %x\n",
> -					 __func__, status);
> +			 dev_info_ratelimited(dev,

Unrelated change

> +					 "%s:%d: forcing end of tx descriptor with status %x\n",
> +					 __func__, __LINE__, status);
>  			netdev->stats.tx_dropped++;
>  			break;
>
> @@ -592,6 +606,7 @@ static void gelic_card_release_tx_chain(struct  
> gelic_card *card, int stop)
>  void gelic_net_set_multi(struct net_device *netdev)
>  {
>  	struct gelic_card *card = netdev_card(netdev);
> +	struct device *dev = ctodev(card);
>  	struct netdev_hw_addr *ha;
>  	unsigned int i;
>  	uint8_t *p;
> @@ -601,27 +616,31 @@ void gelic_net_set_multi(struct net_device *netdev)
>  	/* clear all multicast address */
>  	status = lv1_net_remove_multicast_address(bus_id(card), dev_id(card),
>  						  0, 1);
> -	if (status)
> -		dev_err(ctodev(card),
> -			"lv1_net_remove_multicast_address failed %d\n",
> -			status);
> +	if (status) {
> +		dev_err(dev,
> +			"%s:%d: lv1_net_remove_multicast_address failed %d\n",
> +			__func__, __LINE__, status);
> +	}
> +
>  	/* set broadcast address */
>  	status = lv1_net_add_multicast_address(bus_id(card), dev_id(card),
>  					       GELIC_NET_BROADCAST_ADDR, 0);
> -	if (status)
> -		dev_err(ctodev(card),
> -			"lv1_net_add_multicast_address failed, %d\n",
> -			status);
> +	if (status) {
> +		dev_err(dev,
> +			"%s:%d: lv1_net_add_multicast_address failed, %d\n",
> +			__func__, __LINE__, status);
> +	}
>
>  	if ((netdev->flags & IFF_ALLMULTI) ||
>  	    (netdev_mc_count(netdev) > GELIC_NET_MC_COUNT_MAX)) {
>  		status = lv1_net_add_multicast_address(bus_id(card),
>  						       dev_id(card),
>  						       0, 1);
> -		if (status)
> -			dev_err(ctodev(card),
> -				"lv1_net_add_multicast_address failed, %d\n",
> -				status);
> +		if (status) {
> +			dev_err(dev,
> +				"%s:%d: lv1_net_add_multicast_address failed, %d\n",
> +				__func__, __LINE__, status);
> +		}
>  		return;
>  	}
>
> @@ -636,10 +655,11 @@ void gelic_net_set_multi(struct net_device *netdev)
>  		status = lv1_net_add_multicast_address(bus_id(card),
>  						       dev_id(card),
>  						       addr, 0);
> -		if (status)
> -			dev_err(ctodev(card),
> -				"lv1_net_add_multicast_address failed, %d\n",
> -				status);
> +		if (status) {
> +			dev_err(dev,
> +				"%s:%d: lv1_net_add_multicast_address failed, %d\n",
> +				__func__, __LINE__, status);
> +		}
>  	}
>  }
>
> @@ -651,17 +671,17 @@ void gelic_net_set_multi(struct net_device *netdev)
>   */
>  int gelic_net_stop(struct net_device *netdev)
>  {
> -	struct gelic_card *card;
> +	struct gelic_card *card = netdev_card(netdev);
> +	struct device *dev = ctodev(card);
>
> -	pr_debug("%s: start\n", __func__);
> +	dev_dbg(dev, "%s:%d: >\n", __func__, __LINE__);
>
>  	netif_stop_queue(netdev);
>  	netif_carrier_off(netdev);
>
> -	card = netdev_card(netdev);
>  	gelic_card_down(card);
>
> -	pr_debug("%s: done\n", __func__);
> +	dev_dbg(dev, "%s:%d: <\n", __func__, __LINE__);
>  	return 0;
>  }
>
> @@ -764,6 +784,7 @@ static int gelic_descr_prepare_tx(struct  
> gelic_card *card,
>  				  struct gelic_descr *descr,
>  				  struct sk_buff *skb)
>  {
> +	struct device *dev = ctodev(card);
>  	dma_addr_t cpu_addr;
>
>  	if (card->vlan_required) {
> @@ -778,12 +799,10 @@ static int gelic_descr_prepare_tx(struct  
> gelic_card *card,
>  		skb = skb_tmp;
>  	}
>
> -	cpu_addr = dma_map_single(ctodev(card), skb->data, skb->len,  
> DMA_TO_DEVICE);
> +	cpu_addr = dma_map_single(dev, skb->data, skb->len, DMA_TO_DEVICE);
>
>  	if (!cpu_addr) {
> -		dev_err(ctodev(card),
> -			"dma map 2 failed (%p, %i). Dropping packet\n",
> -			skb->data, skb->len);
> +		dev_err(dev, "%s:%d: dma_mapping_error\n", __func__, __LINE__);
>  		return -ENOMEM;
>  	}
>
> @@ -808,6 +827,7 @@ static int gelic_descr_prepare_tx(struct  
> gelic_card *card,
>  static int gelic_card_kick_txdma(struct gelic_card *card,
>  				 struct gelic_descr *descr)
>  {
> +	struct device *dev = ctodev(card);
>  	int status = 0;
>
>  	if (card->tx_dma_progress)
> @@ -819,8 +839,8 @@ static int gelic_card_kick_txdma(struct gelic_card *card,
>  					      descr->link.cpu_addr, 0);
>  		if (status) {
>  			card->tx_dma_progress = 0;
> -			dev_info(ctodev(card), "lv1_net_start_txdma failed," \
> -				 "status=%d\n", status);
> +			dev_info(dev, "%s:%d: lv1_net_start_txdma failed: %d\n",
> +				__func__, __LINE__, status);
>  		}
>  	}
>  	return status;
> @@ -836,6 +856,7 @@ static int gelic_card_kick_txdma(struct gelic_card *card,
>  netdev_tx_t gelic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
>  {
>  	struct gelic_card *card = netdev_card(netdev);
> +	struct device *dev = ctodev(card);
>  	struct gelic_descr *descr;
>  	int result;
>  	unsigned long flags;
> @@ -888,7 +909,7 @@ netdev_tx_t gelic_net_xmit(struct sk_buff *skb,  
> struct net_device *netdev)
>  		card->tx_chain.head = descr;
>  		/* reset hw termination */
>  		descr->prev->hw_regs.next_descr_addr = 0;
> -		dev_info(ctodev(card), "%s: kick failure\n", __func__);
> +		dev_info(dev, "%s:%d: kick failure\n", __func__, __LINE__);
>  	}
>
>  	spin_unlock_irqrestore(&card->tx_lock, flags);
> @@ -909,24 +930,28 @@ static void gelic_net_pass_skb_up(struct  
> gelic_descr *descr,
>  				  struct net_device *netdev)
>
>  {
> +	struct device *dev = ctodev(card);
>  	struct sk_buff *skb = descr->skb;
>  	u32 data_status, data_error;
>
>  	data_status = be32_to_cpu(descr->hw_regs.data_status);
>  	data_error = be32_to_cpu(descr->hw_regs.data_error);
>  	/* unmap skb buffer */
> -	dma_unmap_single(ctodev(card),  
> be32_to_cpu(descr->hw_regs.payload.dev_addr),
> +	dma_unmap_single(dev, be32_to_cpu(descr->hw_regs.payload.dev_addr),
>  			 GELIC_NET_MAX_MTU,
>  			 DMA_FROM_DEVICE);
>
>  	skb_put(skb, be32_to_cpu(descr->hw_regs.valid_size)?
>  		be32_to_cpu(descr->hw_regs.valid_size) :
>  		be32_to_cpu(descr->hw_regs.result_size));
> -	if (!descr->hw_regs.valid_size)
> -		dev_info(ctodev(card), "buffer full %x %x %x\n",
> +
> +	if (!descr->hw_regs.valid_size) {
> +		dev_err(dev, "%s:%d: buffer full %x %x %x\n", __func__,
> +			__LINE__,
>  			 be32_to_cpu(descr->hw_regs.result_size),
>  			 be32_to_cpu(descr->hw_regs.payload.size),
>  			 be32_to_cpu(descr->hw_regs.dmac_cmd_status));
> +	}
>
>  	descr->skb = NULL;
>  	/*
> @@ -968,6 +993,7 @@ static int gelic_card_decode_one_descr(struct  
> gelic_card *card)
>  	enum gelic_descr_dma_status status;
>  	struct gelic_descr_chain *chain = &card->rx_chain;
>  	struct gelic_descr *descr = chain->head;
> +	struct device *dev = ctodev(card);
>  	struct net_device *netdev = NULL;
>  	int dmac_chain_ended;
>
> @@ -977,7 +1003,8 @@ static int gelic_card_decode_one_descr(struct  
> gelic_card *card)
>  		return 0;
>
>  	if (status == GELIC_DESCR_DMA_NOT_IN_USE) {
> -		dev_dbg(ctodev(card), "dormant descr? %p\n", descr);
> +		dev_dbg(dev, "%s:%d: dormant descr? %px\n", __func__, __LINE__,
> +			descr);
>  		return 0;
>  	}
>
> @@ -993,7 +1020,8 @@ static int gelic_card_decode_one_descr(struct  
> gelic_card *card)
>  			}
>  		}
>  		if (GELIC_PORT_MAX <= i) {
> -			pr_info("%s: unknown packet vid=%x\n", __func__, vid);
> +			dev_info(dev, "%s:%d: unknown packet vid=%x\n",
> +				__func__, __LINE__, vid);
>  			goto refill;
>  		}
>  	} else
> @@ -1002,8 +1030,8 @@ static int gelic_card_decode_one_descr(struct  
> gelic_card *card)
>  	if ((status == GELIC_DESCR_DMA_RESPONSE_ERROR) ||
>  	    (status == GELIC_DESCR_DMA_PROTECTION_ERROR) ||
>  	    (status == GELIC_DESCR_DMA_FORCE_END)) {
> -		dev_info(ctodev(card), "dropping RX descriptor with state %x\n",
> -			 status);
> +		dev_info(dev, "%s:%d: dropping RX descriptor with state %x\n",
> +			__func__, __LINE__, status);
>  		netdev->stats.rx_dropped++;
>  		goto refill;
>  	}
> @@ -1018,7 +1046,7 @@ static int gelic_card_decode_one_descr(struct  
> gelic_card *card)
>  		 * Anyway this frame was longer than the MTU,
>  		 * just drop it.
>  		 */
> -		dev_info(ctodev(card), "overlength frame\n");
> +		dev_info(dev, "%s:%d: overlength frame\n", __func__, __LINE__);
>  		goto refill;
>  	}
>  	/*
> @@ -1026,8 +1054,8 @@ static int gelic_card_decode_one_descr(struct  
> gelic_card *card)
>  	 * be treated as error.
>  	 */
>  	if (status != GELIC_DESCR_DMA_FRAME_END) {
> -		dev_dbg(ctodev(card), "RX descriptor with state %x\n",
> -			status);
> +		dev_dbg(dev, "%s:%d: RX descriptor with state %x\n", __func__,
> +			__LINE__, status);
>  		goto refill;
>  	}
>
> @@ -1174,14 +1202,11 @@ int gelic_net_open(struct net_device *netdev)
>  {
>  	struct gelic_card *card = netdev_card(netdev);
>
> -	dev_dbg(ctodev(card), " -> %s %p\n", __func__, netdev);
> -
>  	gelic_card_up(card);
>
>  	netif_start_queue(netdev);
>  	gelic_card_get_ether_port_status(card, 1);
>
> -	dev_dbg(ctodev(card), " <- %s\n", __func__);
>  	return 0;
>  }
>
> @@ -1196,6 +1221,7 @@ static int  
> gelic_ether_get_link_ksettings(struct net_device *netdev,
>  					  struct ethtool_link_ksettings *cmd)
>  {
>  	struct gelic_card *card = netdev_card(netdev);
> +	struct device *dev = ctodev(card);
>  	u32 supported, advertising;
>
>  	gelic_card_get_ether_port_status(card, 0);
> @@ -1216,7 +1242,7 @@ static int  
> gelic_ether_get_link_ksettings(struct net_device *netdev,
>  		cmd->base.speed = SPEED_1000;
>  		break;
>  	default:
> -		pr_info("%s: speed unknown\n", __func__);
> +		dev_dbg(dev, "%s:%d: speed unknown\n", __func__, __LINE__);
>  		cmd->base.speed = SPEED_10;
>  		break;
>  	}
> @@ -1247,6 +1273,7 @@ gelic_ether_set_link_ksettings(struct  
> net_device *netdev,
>  			       const struct ethtool_link_ksettings *cmd)
>  {
>  	struct gelic_card *card = netdev_card(netdev);
> +	struct device *dev = ctodev(card);
>  	u64 mode;
>  	int ret;
>
> @@ -1269,7 +1296,9 @@ gelic_ether_set_link_ksettings(struct  
> net_device *netdev,
>  		if (cmd->base.duplex == DUPLEX_FULL) {
>  			mode |= GELIC_LV1_ETHER_FULL_DUPLEX;
>  		} else if (cmd->base.speed == SPEED_1000) {
> -			pr_info("1000 half duplex is not supported.\n");
> +			dev_dbg(dev,
> +				"%s:%d: 1000 half duplex is not supported.\n",
> +				__func__, __LINE__);
>  			return -EINVAL;
>  		}
>  	}
> @@ -1296,8 +1325,9 @@ static void gelic_net_get_wol(struct  
> net_device *netdev,
>  static int gelic_net_set_wol(struct net_device *netdev,
>  			     struct ethtool_wolinfo *wol)
>  {
> +	struct gelic_card *card = netdev_card(netdev);
> +	struct device *dev = ctodev(card);
>  	int status;
> -	struct gelic_card *card;
>  	u64 v1, v2;
>
>  	if (ps3_compare_firmware_version(2, 2, 0) < 0 ||
> @@ -1307,7 +1337,6 @@ static int gelic_net_set_wol(struct net_device *netdev,
>  	if (wol->wolopts & ~WAKE_MAGIC)
>  		return -EINVAL;
>
> -	card = netdev_card(netdev);
>  	if (wol->wolopts & WAKE_MAGIC) {
>  		status = lv1_net_control(bus_id(card), dev_id(card),
>  					 GELIC_LV1_SET_WOL,
> @@ -1315,8 +1344,8 @@ static int gelic_net_set_wol(struct net_device *netdev,
>  					 0, GELIC_LV1_WOL_MP_ENABLE,
>  					 &v1, &v2);
>  		if (status) {
> -			pr_info("%s: enabling WOL failed %d\n", __func__,
> -				status);
> +			dev_dbg(dev, "%s:%d: Enabling WOL failed: %d\n",
> +				__func__, __LINE__, status);
>  			status = -EIO;
>  			goto done;
>  		}
> @@ -1328,8 +1357,8 @@ static int gelic_net_set_wol(struct net_device *netdev,
>  		if (!status)
>  			ps3_sys_manager_set_wol(1);
>  		else {
> -			pr_info("%s: enabling WOL filter failed %d\n",
> -				__func__, status);
> +			dev_dbg(dev, "%s:%d: Enabling WOL filter failed: %d\n",
> +				__func__, __LINE__, status);
>  			status = -EIO;
>  		}
>  	} else {
> @@ -1339,8 +1368,8 @@ static int gelic_net_set_wol(struct net_device *netdev,
>  					 0, GELIC_LV1_WOL_MP_DISABLE,
>  					 &v1, &v2);
>  		if (status) {
> -			pr_info("%s: disabling WOL failed %d\n", __func__,
> -				status);
> +			dev_dbg(dev, "%s:%d: Disabling WOL failed: %d\n",
> +				__func__, __LINE__, status);
>  			status = -EIO;
>  			goto done;
>  		}
> @@ -1352,8 +1381,8 @@ static int gelic_net_set_wol(struct net_device *netdev,
>  		if (!status)
>  			ps3_sys_manager_set_wol(0);
>  		else {
> -			pr_info("%s: removing WOL filter failed %d\n",
> -				__func__, status);
> +			dev_dbg(dev, "%s:%d: Removing WOL filter failed: %d\n",
> +				__func__, __LINE__, status);
>  			status = -EIO;
>  		}
>  	}
> @@ -1382,8 +1411,9 @@ static void gelic_net_tx_timeout_task(struct  
> work_struct *work)
>  	struct gelic_card *card =
>  		container_of(work, struct gelic_card, tx_timeout_task);
>  	struct net_device *netdev = card->netdev[GELIC_PORT_ETHERNET_0];
> +	struct device *dev = ctodev(card);
>
> -	dev_info(ctodev(card), "%s:Timed out. Restarting...\n", __func__);
> +	dev_info(dev, "%s:%d: Timed out. Restarting...\n", __func__, __LINE__);
>
>  	if (!(netdev->flags & IFF_UP))
>  		goto out;
> @@ -1459,6 +1489,7 @@ static void  
> gelic_ether_setup_netdev_ops(struct net_device *netdev,
>   **/
>  int gelic_net_setup_netdev(struct net_device *netdev, struct  
> gelic_card *card)
>  {
> +	struct device *dev = ctodev(card);
>  	int status;
>  	u64 v1, v2;
>
> @@ -1473,9 +1504,8 @@ int gelic_net_setup_netdev(struct net_device  
> *netdev, struct gelic_card *card)
>  				 0, 0, 0, &v1, &v2);
>  	v1 <<= 16;
>  	if (status || !is_valid_ether_addr((u8 *)&v1)) {
> -		dev_info(ctodev(card),
> -			 "%s:lv1_net_control GET_MAC_ADDR failed %d\n",
> -			 __func__, status);
> +		dev_dbg(dev, "%s:%d: lv1_net_control GET_MAC_ADDR failed: %d\n",
> +			__func__, __LINE__, status);
>  		return -EINVAL;
>  	}
>  	memcpy(netdev->dev_addr, &v1, ETH_ALEN);
> @@ -1494,13 +1524,15 @@ int gelic_net_setup_netdev(struct net_device  
> *netdev, struct gelic_card *card)
>  	netdev->max_mtu = GELIC_NET_MAX_MTU;
>
>  	status = register_netdev(netdev);
> +
>  	if (status) {
> -		dev_err(ctodev(card), "%s:Couldn't register %s %d\n",
> -			__func__, netdev->name, status);
> +		dev_err(dev, "%s:%d: Couldn't register %s: %d\n", __func__,
> +			__LINE__, netdev->name, status);
>  		return status;
>  	}
> -	dev_info(ctodev(card), "%s: MAC addr %pM\n",
> -		 netdev->name, netdev->dev_addr);
> +
> +	dev_info(dev, "%s:%d: %s MAC addr %pxM\n", __func__, __LINE__,
> +		netdev->name, netdev->dev_addr);
>
>  	return 0;
>  }
> @@ -1566,6 +1598,7 @@ static struct gelic_card  
> *gelic_alloc_card_net(struct net_device **netdev)
>
>  static void gelic_card_get_vlan_info(struct gelic_card *card)
>  {
> +	struct device *dev = ctodev(card);
>  	u64 v1, v2;
>  	int status;
>  	unsigned int i;
> @@ -1590,10 +1623,12 @@ static void gelic_card_get_vlan_info(struct  
> gelic_card *card)
>  					 vlan_id_ix[i].tx,
>  					 0, 0, &v1, &v2);
>  		if (status || !v1) {
> -			if (status != LV1_NO_ENTRY)
> -				dev_dbg(ctodev(card),
> -					"get vlan id for tx(%d) failed(%d)\n",
> -					vlan_id_ix[i].tx, status);
> +			if (status != LV1_NO_ENTRY) {
> +				dev_dbg(dev,
> +					"%s:%d: Get vlan id for tx(%d) failed: %d\n",
> +					__func__, __LINE__, vlan_id_ix[i].tx,
> +					status);
> +			}
>  			card->vlan[i].tx = 0;
>  			card->vlan[i].rx = 0;
>  			continue;
> @@ -1606,18 +1641,20 @@ static void gelic_card_get_vlan_info(struct  
> gelic_card *card)
>  					 vlan_id_ix[i].rx,
>  					 0, 0, &v1, &v2);
>  		if (status || !v1) {
> -			if (status != LV1_NO_ENTRY)
> -				dev_info(ctodev(card),
> -					 "get vlan id for rx(%d) failed(%d)\n",
> -					 vlan_id_ix[i].rx, status);
> +			if (status != LV1_NO_ENTRY) {
> +				dev_dbg(dev,
> +					"%s:%d: Get vlan id for rx(%d) failed: %d\n",
> +					__func__, __LINE__, vlan_id_ix[i].rx,
> +					status);
> +			}
>  			card->vlan[i].tx = 0;
>  			card->vlan[i].rx = 0;
>  			continue;
>  		}
>  		card->vlan[i].rx = (u16)v1;
>
> -		dev_dbg(ctodev(card), "vlan_id[%d] tx=%02x rx=%02x\n",
> -			i, card->vlan[i].tx, card->vlan[i].rx);
> +		dev_dbg(dev, "%s:%d: vlan_id[%d] tx=%02x rx=%02x\n", __func__,
> +			__LINE__, i, card->vlan[i].tx, card->vlan[i].rx);
>  	}
>
>  	if (card->vlan[GELIC_PORT_ETHERNET_0].tx) {
> @@ -1632,35 +1669,36 @@ static void gelic_card_get_vlan_info(struct  
> gelic_card *card)
>  		card->vlan[GELIC_PORT_WIRELESS].rx = 0;
>  	}
>
> -	dev_info(ctodev(card), "internal vlan %s\n",
> -		 card->vlan_required? "enabled" : "disabled");
> +	dev_dbg(dev, "%s:%d: internal vlan %s\n", __func__, __LINE__,
> +		card->vlan_required ? "enabled" : "disabled");
>  }
>  /*
>   * ps3_gelic_driver_probe - add a device to the control of this driver
>   */
> -static int ps3_gelic_driver_probe(struct ps3_system_bus_device *dev)
> +static int ps3_gelic_driver_probe(struct ps3_system_bus_device *sb_dev)
>  {
> +	struct device *dev = &sb_dev->core;
>  	struct gelic_card *card;
>  	struct net_device *netdev;
>  	int result;
>
> -	pr_debug("%s: called\n", __func__);
> +	dev_dbg(dev, "%s:%d: >\n", __func__, __LINE__);
>
>  	udbg_shutdown_ps3gelic();
>
> -	result = ps3_open_hv_device(dev);
> +	result = ps3_open_hv_device(sb_dev);
>
>  	if (result) {
> -		dev_dbg(&dev->core, "%s:ps3_open_hv_device failed\n",
> -			__func__);
> +		dev_err(dev, "%s:%d: ps3_open_hv_device failed: %d\n",
> +			__func__, __LINE__, result);
>  		goto fail_open;
>  	}
>
> -	result = ps3_dma_region_create(dev->d_region);
> +	result = ps3_dma_region_create(sb_dev->d_region);
>
>  	if (result) {
> -		dev_dbg(&dev->core, "%s:ps3_dma_region_create failed(%d)\n",
> -			__func__, result);
> +		dev_err(dev, "%s:%d: ps3_dma_region_create failed: %d\n",
> +			__func__, __LINE__, result);
>  		BUG_ON("check region type");
>  		goto fail_dma_region;
>  	}
> @@ -1668,13 +1706,13 @@ static int ps3_gelic_driver_probe(struct  
> ps3_system_bus_device *dev)
>  	/* alloc card/netdevice */
>  	card = gelic_alloc_card_net(&netdev);
>  	if (!card) {
> -		dev_info(&dev->core, "%s:gelic_net_alloc_card failed\n",
> -			 __func__);
> +		dev_info(dev, "%s:%d: gelic_net_alloc_card failed.\n", __func__,
> +			__LINE__);
>  		result = -ENOMEM;
>  		goto fail_alloc_card;
>  	}
> -	ps3_system_bus_set_drvdata(dev, card);
> -	card->dev = dev;
> +	ps3_system_bus_set_drvdata(sb_dev, card);
> +	card->dev = sb_dev;
>
>  	/* get internal vlan info */
>  	gelic_card_get_vlan_info(card);
> @@ -1688,20 +1726,19 @@ static int ps3_gelic_driver_probe(struct  
> ps3_system_bus_device *dev)
>  		0);
>
>  	if (result) {
> -		dev_dbg(&dev->core,
> -			"%s:set_interrupt_status_indicator failed: %s\n",
> -			__func__, ps3_result(result));
> +		dev_dbg(dev,
> +			"%s:%d: set_interrupt_status_indicator failed: %s\n",
> +			__func__, __LINE__, ps3_result(result));
>  		result = -EIO;
>  		goto fail_status_indicator;
>  	}
>
> -	result = ps3_sb_event_receive_port_setup(dev, PS3_BINDING_CPU_ANY,
> +	result = ps3_sb_event_receive_port_setup(sb_dev, PS3_BINDING_CPU_ANY,
>  		&card->irq);
>
>  	if (result) {
> -		dev_info(ctodev(card),
> -			 "%s:gelic_net_open_device failed (%d)\n",
> -			 __func__, result);
> +		dev_dbg(dev, "%s:%d: gelic_net_open_device failed: %d\n",
> +			__func__, __LINE__, result);
>  		result = -EPERM;
>  		goto fail_alloc_irq;
>  	}
> @@ -1709,8 +1746,8 @@ static int ps3_gelic_driver_probe(struct  
> ps3_system_bus_device *dev)
>  			     0, netdev->name, card);
>
>  	if (result) {
> -		dev_info(ctodev(card), "%s:request_irq failed (%d)\n",
> -			__func__, result);
> +		dev_dbg(dev, "%s:%d: request_irq failed: %d\n",
> +			__func__, __LINE__, result);
>  		goto fail_request_irq;
>  	}
>
> @@ -1732,9 +1769,11 @@ static int ps3_gelic_driver_probe(struct  
> ps3_system_bus_device *dev)
>  	/* head of chain */
>  	card->tx_top = card->tx_chain.head;
>  	card->rx_top = card->rx_chain.head;
> -	dev_dbg(ctodev(card), "descr rx %p, tx %p, size %#lx, num %#x\n",
> -		card->rx_top, card->tx_top, sizeof(struct gelic_descr),
> -		GELIC_NET_RX_DESCRIPTORS);
> +
> +	dev_dbg(dev, "%s:%d: descr rx %px, tx %px, size %#lx, num %#x\n",
> +		__func__, __LINE__, card->rx_top, card->tx_top,
> +		sizeof(struct gelic_descr), GELIC_NET_RX_DESCRIPTORS);
> +
>  	/* allocate rx skbs */
>  	result = gelic_card_alloc_rx_skbs(card);
>  	if (result)
> @@ -1745,23 +1784,23 @@ static int ps3_gelic_driver_probe(struct  
> ps3_system_bus_device *dev)
>
>  	/* setup net_device structure */
>  	netdev->irq = card->irq;
> -	SET_NETDEV_DEV(netdev, &card->dev->core);
> +	SET_NETDEV_DEV(netdev, dev);
>  	gelic_ether_setup_netdev_ops(netdev, &card->napi);
>  	result = gelic_net_setup_netdev(netdev, card);
>  	if (result) {
> -		dev_dbg(&dev->core, "%s: setup_netdev failed %d\n",
> -			__func__, result);
> +		dev_err(dev, "%s:%d: setup_netdev failed: %d\n", __func__,
> +			__LINE__, result);
>  		goto fail_setup_netdev;
>  	}
>
>  #ifdef CONFIG_GELIC_WIRELESS
>  	result = gelic_wl_driver_probe(card);
>  	if (result) {
> -		dev_dbg(&dev->core, "%s: WL init failed\n", __func__);
> +		dev_dbg(dev, "%s:%d: WL init failed\n", __func__, __LINE__);
>  		goto fail_setup_netdev;
>  	}
>  #endif
> -	pr_debug("%s: done\n", __func__);
> +	dev_dbg(dev, "%s:%d: < OK\n", __func__, __LINE__);
>  	return 0;
>
>  fail_setup_netdev:
> @@ -1773,20 +1812,21 @@ static int ps3_gelic_driver_probe(struct  
> ps3_system_bus_device *dev)
>  	free_irq(card->irq, card);
>  	netdev->irq = 0;
>  fail_request_irq:
> -	ps3_sb_event_receive_port_destroy(dev, card->irq);
> +	ps3_sb_event_receive_port_destroy(sb_dev, card->irq);
>  fail_alloc_irq:
>  	lv1_net_set_interrupt_status_indicator(bus_id(card),
>  					       bus_id(card),
>  					       0, 0);

>  fail_status_indicator:
> -	ps3_system_bus_set_drvdata(dev, NULL);
> +	ps3_system_bus_set_drvdata(sb_dev, NULL);
>  	kfree(netdev_card(netdev)->unalign);
>  	free_netdev(netdev);
>  fail_alloc_card:
> -	ps3_dma_region_free(dev->d_region);
> +	ps3_dma_region_free(sb_dev->d_region);
>  fail_dma_region:
> -	ps3_close_hv_device(dev);
> +	ps3_close_hv_device(sb_dev);
>  fail_open:
> +	dev_dbg(dev, "%s:%d: < error\n", __func__, __LINE__);
>  	return result;
>  }
>
> @@ -1794,11 +1834,13 @@ static int ps3_gelic_driver_probe(struct  
> ps3_system_bus_device *dev)
>   * ps3_gelic_driver_remove - remove a device from the control of this driver
>   */
>
> -static void ps3_gelic_driver_remove(struct ps3_system_bus_device *dev)
> +static void ps3_gelic_driver_remove(struct ps3_system_bus_device *sb_dev)
>  {
> -	struct gelic_card *card = ps3_system_bus_get_drvdata(dev);
> +	struct gelic_card *card = ps3_system_bus_get_drvdata(sb_dev);
> +	struct device *dev = &sb_dev->core;
>  	struct net_device *netdev0;
> -	pr_debug("%s: called\n", __func__);
> +
> +	dev_dbg(dev, "%s:%d: >\n", __func__, __LINE__);
>
>  	/* set auto-negotiation */
>  	gelic_card_set_link_mode(card, GELIC_LV1_ETHER_AUTO_NEG);
> @@ -1836,13 +1878,13 @@ static void ps3_gelic_driver_remove(struct  
> ps3_system_bus_device *dev)
>  	kfree(netdev_card(netdev0)->unalign);
>  	free_netdev(netdev0);
>
> -	ps3_system_bus_set_drvdata(dev, NULL);
> +	ps3_system_bus_set_drvdata(sb_dev, NULL);
>
> -	ps3_dma_region_free(dev->d_region);
> +	ps3_dma_region_free(sb_dev->d_region);
>
> -	ps3_close_hv_device(dev);
> +	ps3_close_hv_device(sb_dev);
>
> -	pr_debug("%s: done\n", __func__);
> +	dev_dbg(dev, "%s:%d: <\n", __func__, __LINE__);
>  }
>
>  static struct ps3_system_bus_driver ps3_gelic_driver = {
> --
> 2.25.1


