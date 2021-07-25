Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B81F3D4F84
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 20:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhGYRwS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 25 Jul 2021 13:52:18 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:48365 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229825AbhGYRwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 13:52:18 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4GXs9q1cxpzBCTn;
        Sun, 25 Jul 2021 20:32:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qNNbYLWewUwJ; Sun, 25 Jul 2021 20:32:47 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4GXs9q0Sj8zBCTX;
        Sun, 25 Jul 2021 20:32:47 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id 5ED5A3D9; Sun, 25 Jul 2021 20:38:04 +0200 (CEST)
Received: from 37-165-12-41.coucou-networks.fr
 (37-165-12-41.coucou-networks.fr [37.165.12.41]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Sun, 25 Jul 2021 20:38:04 +0200
Date:   Sun, 25 Jul 2021 20:38:04 +0200
Message-ID: <20210725203804.Horde.sruKcwZQKonIWKjB98332A2@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Geoff Levand <geoff@infradead.org>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 10/10] net/ps3_gelic: Fix DMA mapping problems
References: <cover.1627068552.git.geoff@infradead.org>
 <7aa1d9b1b4ffadcbdc6f88e4f8d4a323da307595.1627068552.git.geoff@infradead.org>
In-Reply-To: <7aa1d9b1b4ffadcbdc6f88e4f8d4a323da307595.1627068552.git.geoff@infradead.org>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geoff Levand <geoff@infradead.org> a écrit :

> Fixes several DMA mapping problems with the PS3's gelic network driver:
>
>  * Change from checking the return value of dma_map_single to using the
>    dma_mapping_error routine.
>  * Use the correct buffer length when mapping the RX skb.
>  * Improved error checking and debug logging.

The patch is quite big and probably deserves more explanation. For  
instance, explain why the buffer length is not correct today.

Also as it is a bug fixing patch, it should include a 'fixes' tag, and  
a Cc: to stable@vger.kernel.org. Also, when possible, bug fixes should  
be one of the first patches in a series like that so that they can be  
applied to stable without applying the whole series.

Christophe

>
> Fixes runtime errors like these, and also other randomly occurring errors:
>
>   IP-Config: Complete:
>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc
>
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 183 +++++++++++--------
>  1 file changed, 108 insertions(+), 75 deletions(-)
>
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c  
> b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index 42f4de9ad5fe..11ddeacb1159 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -336,22 +336,31 @@ static int gelic_card_init_chain(struct  
> gelic_card *card,
>  	struct gelic_descr_chain *chain, struct gelic_descr *start_descr,
>  	int descr_count)
>  {
> -	int i;
> -	struct gelic_descr *descr;
> +	struct gelic_descr *descr = start_descr;
>  	struct device *dev = ctodev(card);
> +	unsigned int index;
>
> -	descr = start_descr;
> -	memset(descr, 0, sizeof(*descr) *descr_count);
> +	memset(start_descr, 0, descr_count * sizeof(*start_descr));
>
> -	for (i = 0; i < descr_count; i++, descr++) {
> -		descr->link.size = sizeof(struct gelic_hw_regs);
> +	for (index = 0, descr = start_descr; index < descr_count;
> +		index++, descr++) {
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
> -		descr->link.cpu_addr =
> -			dma_map_single(dev, descr, descr->link.size,
> -				DMA_BIDIRECTIONAL);
>
> -		if (!descr->link.cpu_addr)
> -			goto iommu_error;
> +		descr->link.size = sizeof(struct gelic_hw_regs);
> +		descr->link.cpu_addr = dma_map_single(dev, descr,
> +			descr->link.size, DMA_BIDIRECTIONAL);
> +
> +		if (unlikely(dma_mapping_error(dev, descr->link.cpu_addr))) {
> +			dev_err(dev, "%s:%d: dma_mapping_error\n", __func__,
> +				__LINE__);
> +
> +			for (index--, descr--; index > 0; index--, descr--) {
> +				if (descr->link.cpu_addr) {
> +					gelic_unmap_link(dev, descr);
> +				}
> +			}
> +			return -ENOMEM;
> +		}
>
>  		descr->next = descr + 1;
>  		descr->prev = descr - 1;
> @@ -360,8 +369,9 @@ static int gelic_card_init_chain(struct gelic_card *card,
>  	(descr - 1)->next = start_descr;
>  	start_descr->prev = (descr - 1);
>
> -	descr = start_descr;
> -	for (i = 0; i < descr_count; i++, descr++) {
> +	/* chain bus addr of hw descriptor */
> +	for (index = 0, descr = start_descr; index < descr_count;
> +		index++, descr++) {
>  		descr->hw_regs.next_descr_addr =
>  			cpu_to_be32(descr->next->link.cpu_addr);
>  	}
> @@ -373,12 +383,6 @@ static int gelic_card_init_chain(struct  
> gelic_card *card,
>  	(descr - 1)->hw_regs.next_descr_addr = 0;
>
>  	return 0;
> -
> -iommu_error:
> -	for (i--, descr--; 0 <= i; i--, descr--)
> -		if (descr->link.cpu_addr)
> -			gelic_unmap_link(dev, descr);
> -	return -ENOMEM;
>  }
>
>  /**
> @@ -395,49 +399,63 @@ static int gelic_descr_prepare_rx(struct  
> gelic_card *card,
>  	struct gelic_descr *descr)
>  {
>  	struct device *dev = ctodev(card);
> -	int offset;
> -	unsigned int bufsize;
> +	struct aligned_buff {
> +		unsigned int total_bytes;
> +		unsigned int offset;
> +	};
> +	struct aligned_buff a_buf;
> +	dma_addr_t cpu_addr;
>
>  	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE) {
>  		dev_err(dev, "%s:%d: ERROR status\n", __func__, __LINE__);
>  	}
>
> -	/* we need to round up the buffer size to a multiple of 128 */
> -	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
> +	a_buf.total_bytes = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN)
> +		+ GELIC_NET_RXBUF_ALIGN;
> +
> +	descr->skb = dev_alloc_skb(a_buf.total_bytes);
>
> -	/* and we need to have it 128 byte aligned, therefore we allocate a
> -	 * bit more */
> -	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
>  	if (!descr->skb) {
> -		descr->hw_regs.payload.dev_addr = 0; /* tell DMAC don't touch memory */
> +		descr->hw_regs.payload.dev_addr = 0;
> +		descr->hw_regs.payload.size = 0;
>  		return -ENOMEM;
>  	}
> -	descr->hw_regs.payload.size = cpu_to_be32(bufsize);
> +
> +	a_buf.offset = PTR_ALIGN(descr->skb->data, GELIC_NET_RXBUF_ALIGN)
> +		- descr->skb->data;
> +
> +	if (a_buf.offset) {
> +		dev_dbg(dev, "%s:%d: offset=%u\n", __func__, __LINE__,
> +			a_buf.offset);
> +		skb_reserve(descr->skb, a_buf.offset);
> +	}
> +
>  	descr->hw_regs.dmac_cmd_status = 0;
>  	descr->hw_regs.result_size = 0;
>  	descr->hw_regs.valid_size = 0;
>  	descr->hw_regs.data_error = 0;
>
> -	offset = ((unsigned long)descr->skb->data) &
> -		(GELIC_NET_RXBUF_ALIGN - 1);
> -	if (offset)
> -		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
> -	/* io-mmu-map the skb */
> -	descr->hw_regs.payload.dev_addr = cpu_to_be32(dma_map_single(dev,
> -						     descr->skb->data,
> -						     GELIC_NET_MAX_MTU,
> -						     DMA_FROM_DEVICE));
> -	if (!descr->hw_regs.payload.dev_addr) {
> +	descr->hw_regs.payload.size = a_buf.total_bytes - a_buf.offset;
> +	cpu_addr = dma_map_single(dev, descr->skb->data,
> +		descr->hw_regs.payload.size, DMA_FROM_DEVICE);
> +	descr->hw_regs.payload.dev_addr = cpu_to_be32(cpu_addr);
> +
> +	if (unlikely(dma_mapping_error(dev, cpu_addr))) {
> +		dev_err(dev, "%s:%d: dma_mapping_error\n", __func__, __LINE__);
> +
> +		descr->hw_regs.payload.dev_addr = 0;
> +		descr->hw_regs.payload.size = 0;
> +
>  		dev_kfree_skb_any(descr->skb);
>  		descr->skb = NULL;
> -		dev_info(dev,
> -			 "%s:Could not iommu-map rx buffer\n", __func__);
> +
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
> +
>  		return -ENOMEM;
> -	} else {
> -		gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
> -		return 0;
>  	}
> +
> +	gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
> +	return 0;
>  }
>
>  /**
> @@ -454,13 +472,18 @@ static void gelic_card_release_rx_chain(struct  
> gelic_card *card)
>  		if (descr->skb) {
>  			dma_unmap_single(dev,
>  				be32_to_cpu(descr->hw_regs.payload.dev_addr),
> -				descr->skb->len, DMA_FROM_DEVICE);
> -			descr->hw_regs.payload.dev_addr = 0;
> +				descr->hw_regs.payload.size, DMA_FROM_DEVICE);
> +
>  			dev_kfree_skb_any(descr->skb);
>  			descr->skb = NULL;
> +
>  			gelic_descr_set_status(descr,
>  				GELIC_DESCR_DMA_NOT_IN_USE);
>  		}
> +
> +		descr->hw_regs.payload.dev_addr = 0;
> +		descr->hw_regs.payload.size = 0;
> +
>  		descr = descr->next;
>  	} while (descr != card->rx_chain.head);
>  }
> @@ -526,17 +549,19 @@ static void gelic_descr_release_tx(struct  
> gelic_card *card,
>  		GELIC_DESCR_TX_TAIL));
>
>  	dma_unmap_single(dev, be32_to_cpu(descr->hw_regs.payload.dev_addr),
> -		skb->len, DMA_TO_DEVICE);
> -	dev_kfree_skb_any(skb);
> +		descr->hw_regs.payload.size, DMA_TO_DEVICE);
>
>  	descr->hw_regs.payload.dev_addr = 0;
>  	descr->hw_regs.payload.size = 0;
> +
> +	dev_kfree_skb_any(skb);
> +	descr->skb = NULL;
> +
>  	descr->hw_regs.next_descr_addr = 0;
>  	descr->hw_regs.result_size = 0;
>  	descr->hw_regs.valid_size = 0;
>  	descr->hw_regs.data_status = 0;
>  	descr->hw_regs.data_error = 0;
> -	descr->skb = NULL;
>
>  	gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  }
> @@ -565,31 +590,34 @@ static void gelic_card_wake_queues(struct  
> gelic_card *card)
>  static void gelic_card_release_tx_chain(struct gelic_card *card, int stop)
>  {
>  	struct gelic_descr_chain *tx_chain;
> -	enum gelic_descr_dma_status status;
>  	struct device *dev = ctodev(card);
> -	struct net_device *netdev;
> -	int release = 0;
> +	int release;
> +
> +	for (release = 0, tx_chain = &card->tx_chain;
> +		tx_chain->head != tx_chain->tail && tx_chain->tail;
> +		tx_chain->tail = tx_chain->tail->next) {
> +		enum gelic_descr_dma_status status;
> +		struct gelic_descr *descr;
> +		struct net_device *netdev;
> +
> +		descr = tx_chain->tail;
> +		status = gelic_descr_get_status(descr);
> +		netdev = descr->skb->dev;
>
> -	for (tx_chain = &card->tx_chain;
> -	     tx_chain->head != tx_chain->tail && tx_chain->tail;
> -	     tx_chain->tail = tx_chain->tail->next) {
> -		status = gelic_descr_get_status(tx_chain->tail);
> -		netdev = tx_chain->tail->skb->dev;
>  		switch (status) {
>  		case GELIC_DESCR_DMA_RESPONSE_ERROR:
>  		case GELIC_DESCR_DMA_PROTECTION_ERROR:
>  		case GELIC_DESCR_DMA_FORCE_END:
> -			 dev_info_ratelimited(dev,
> -					 "%s:%d: forcing end of tx descriptor with status %x\n",
> -					 __func__, __LINE__, status);
> +			dev_info_ratelimited(dev,
> +				"%s:%d: forcing end of tx descriptor with status %x\n",
> +				__func__, __LINE__, status);
>  			netdev->stats.tx_dropped++;
>  			break;
>
>  		case GELIC_DESCR_DMA_COMPLETE:
> -			if (tx_chain->tail->skb) {
> +			if (descr->skb) {
>  				netdev->stats.tx_packets++;
> -				netdev->stats.tx_bytes +=
> -					tx_chain->tail->skb->len;
> +				netdev->stats.tx_bytes += descr->skb->len;
>  			}
>  			break;
>
> @@ -599,7 +627,7 @@ static void gelic_card_release_tx_chain(struct  
> gelic_card *card, int stop)
>  			}
>  		}
>
> -		gelic_descr_release_tx(card, tx_chain->tail);
> +		gelic_descr_release_tx(card, descr);
>  		release++;
>  	}
>  out:
> @@ -703,19 +731,19 @@ int gelic_net_stop(struct net_device *netdev)
>   *
>   * returns the address of the next descriptor, or NULL if not available.
>   */
> -static struct gelic_descr *
> -gelic_card_get_next_tx_descr(struct gelic_card *card)
> +static struct gelic_descr *gelic_card_get_next_tx_descr(struct  
> gelic_card *card)
>  {
>  	if (!card->tx_chain.head)
>  		return NULL;
> +
>  	/*  see if the next descriptor is free */
>  	if (card->tx_chain.tail != card->tx_chain.head->next &&
> -		gelic_descr_get_status(card->tx_chain.head) ==
> -			GELIC_DESCR_DMA_NOT_IN_USE)
> +		(gelic_descr_get_status(card->tx_chain.head) ==
> +			GELIC_DESCR_DMA_NOT_IN_USE)) {
>  		return card->tx_chain.head;
> -	else
> -		return NULL;
> +	}
>
> +	return NULL;
>  }
>
>  /**
> @@ -809,18 +837,23 @@ static int gelic_descr_prepare_tx(struct  
> gelic_card *card,
>  		if (!skb_tmp) {
>  			return -ENOMEM;
>  		}
> +
>  		skb = skb_tmp;
>  	}
>
> -	cpu_addr = dma_map_single(dev, skb->data, skb->len, DMA_TO_DEVICE);
> +	descr->hw_regs.payload.size = skb->len;
> +	cpu_addr = dma_map_single(dev, skb->data, descr->hw_regs.payload.size,
> +		DMA_TO_DEVICE);
> +	descr->hw_regs.payload.dev_addr = cpu_to_be32(cpu_addr);
>
> -	if (!cpu_addr) {
> +	if (unlikely(dma_mapping_error(dev, cpu_addr))) {
>  		dev_err(dev, "%s:%d: dma_mapping_error\n", __func__, __LINE__);
> +
> +		descr->hw_regs.payload.dev_addr = 0;
> +		descr->hw_regs.payload.size = 0;
>  		return -ENOMEM;
>  	}
>
> -	descr->hw_regs.payload.dev_addr = cpu_to_be32(cpu_addr);
> -	descr->hw_regs.payload.size = cpu_to_be32(skb->len);
>  	descr->skb = skb;
>  	descr->hw_regs.data_status = 0;
>  	descr->hw_regs.next_descr_addr = 0; /* terminate hw descr */
> @@ -948,9 +981,9 @@ static void gelic_net_pass_skb_up(struct  
> gelic_descr *descr,
>
>  	data_status = be32_to_cpu(descr->hw_regs.data_status);
>  	data_error = be32_to_cpu(descr->hw_regs.data_error);
> -	/* unmap skb buffer */
> +
>  	dma_unmap_single(dev, be32_to_cpu(descr->hw_regs.payload.dev_addr),
> -			 GELIC_NET_MAX_MTU, DMA_FROM_DEVICE);
> +			 descr->hw_regs.payload.size, DMA_FROM_DEVICE);
>
>  	skb_put(skb, be32_to_cpu(descr->hw_regs.valid_size) ?
>  		be32_to_cpu(descr->hw_regs.valid_size) :
> --
> 2.25.1


