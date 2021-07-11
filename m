Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2E73C3D1B
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 15:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhGKOBP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Jul 2021 10:01:15 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:1574 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232730AbhGKOBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 10:01:14 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4GN7lj62GKzBBW0;
        Sun, 11 Jul 2021 15:58:25 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wL5f4drCoZa5; Sun, 11 Jul 2021 15:58:25 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4GN7lj4m1LzBBTL;
        Sun, 11 Jul 2021 15:58:25 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id 021D8565; Sun, 11 Jul 2021 16:03:30 +0200 (CEST)
Received: from 37.173.248.140 ([37.173.248.140]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Sun, 11 Jul 2021 16:03:30 +0200
Date:   Sun, 11 Jul 2021 16:03:30 +0200
Message-ID: <20210711160330.Horde.YmbaUrNaGLYM4ADZvVr_gA1@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Geoff Levand <geoff@infradead.org>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/2] net/ps3_gelic: Add gelic_descr structures
References: <cover.1625976141.git.geoff@infradead.org>
 <e63dc0564b7c6e4f699c306bf36feb4bd9c30f26.1625976141.git.geoff@infradead.org>
In-Reply-To: <e63dc0564b7c6e4f699c306bf36feb4bd9c30f26.1625976141.git.geoff@infradead.org>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geoff Levand <geoff@infradead.org> a écrit :

> Create two new structures, struct gelic_hw_regs and struct gelic_chain_link,
> and replace the corresponding members of struct gelic_descr with the new
> structures.  struct gelic_hw_regs holds the register variables used by the
> gelic hardware device.  struct gelic_chain_link holds variables used to
> manage the driver's linked list of gelic descr structures.
>
> Fixes several DMA mapping problems with the PS3's gelic network driver:
>
>  * Change from checking the return value of dma_map_single to using the
>    dma_mapping_error routine.
>  * Use the correct buffer length when mapping the RX skb.
>  * Improved error checking and debug logging.

Your patch has a lot of cosmetic changes. Several of them are just  
wrong. The other ones belong to another patch. This patch should focus  
only on the changes it targets.

Your patch is way too big and addresses several different topics.  
Should be split in several patches.

I suggest you run checkpatch.pl --strict on your patch


>
> Fixes runtime errors like these, and also other randomly occurring errors:
>
>   IP-Config: Complete:
>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc
>
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 573 +++++++++++--------
>  drivers/net/ethernet/toshiba/ps3_gelic_net.h |  24 +-
>  2 files changed, 341 insertions(+), 256 deletions(-)
>
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c  
> b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index 55e652624bd7..e01938128882 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -96,9 +96,11 @@ static void  
> gelic_card_get_ether_port_status(struct gelic_card *card,
>   * returns the status as in the dmac_cmd_status field of the descriptor
>   */
>  static enum gelic_descr_dma_status
> +

This blank line is pointless and misleading

>  gelic_descr_get_status(struct gelic_descr *descr)
>  {
> -	return be32_to_cpu(descr->dmac_cmd_status) & GELIC_DESCR_DMA_STAT_MASK;
> +	return be32_to_cpu(descr->hw_regs.dmac_cmd_status)
> +		& GELIC_DESCR_DMA_STAT_MASK;

The & should be at the end of previous line and the second line should  
be aligned to the open parenthesis

>  }
>
>  static int gelic_card_set_link_mode(struct gelic_card *card, int mode)
> @@ -146,24 +148,34 @@ static void gelic_card_disable_txdmac(struct  
> gelic_card *card)
>   */
>  static void gelic_card_enable_rxdmac(struct gelic_card *card)
>  {
> +	struct device *dev = ctodev(card);
>  	int status;
> +#if defined(DEBUG)
> +	static const int debug_build = 1;
> +#else
> +	static const int debug_build = 0;
> +#endif

Useless

You can directly use __is_defined(DEBUG) below

>
> -#ifdef DEBUG
> -	if (gelic_descr_get_status(card->rx_chain.head) !=
> -	    GELIC_DESCR_DMA_CARDOWNED) {
> -		printk(KERN_ERR "%s: status=%x\n", __func__,
> -		       be32_to_cpu(card->rx_chain.head->dmac_cmd_status));
> -		printk(KERN_ERR "%s: nextphy=%x\n", __func__,
> -		       be32_to_cpu(card->rx_chain.head->next_descr_addr));
> -		printk(KERN_ERR "%s: head=%p\n", __func__,
> -		       card->rx_chain.head);
> +	if (debug_build

&& must be at the en of first line

> +		&& (gelic_descr_get_status(card->rx_chain.head)
> +			!= GELIC_DESCR_DMA_CARDOWNED)) {

!= must be at end of previous line

> +		dev_err(dev, "%s:%d: status=%x\n", __func__, __LINE__,
> +			be32_to_cpu(
> +				card->rx_chain.head->hw_regs.dmac_cmd_status));

Alignment should match open parentesis. And lines can be 100 chars  
long when nécessary


> +		dev_err(dev, "%s:%d: nextphy=%x\n", __func__, __LINE__,
> +			be32_to_cpu(
> +				card->rx_chain.head->hw_regs.next_descr_addr));
> +		dev_err(dev, "%s:%d: head=%px\n", __func__, __LINE__,
> +			card->rx_chain.head);
>  	}
> -#endif
> +
>  	status = lv1_net_start_rx_dma(bus_id(card), dev_id(card),
> -				card->rx_chain.head->bus_addr, 0);
> -	if (status)
> -		dev_info(ctodev(card),
> -			 "lv1_net_start_rx_dma failed, status=%d\n", status);
> +		card->rx_chain.head->link.cpu_addr, 0);
> +
> +	if (status) {

No { } for single lines


> +		dev_err(dev, "%s:%d: lv1_net_start_rx_dma failed: %d\n",
> +			__func__, __LINE__, status);
> +	}
>  }
>
>  /**
> @@ -193,11 +205,11 @@ static void gelic_card_disable_rxdmac(struct  
> gelic_card *card)
>   * in the status
>   */
>  static void gelic_descr_set_status(struct gelic_descr *descr,
> -				   enum gelic_descr_dma_status status)
> +	enum gelic_descr_dma_status status)
>  {
> -	descr->dmac_cmd_status = cpu_to_be32(status |
> -			(be32_to_cpu(descr->dmac_cmd_status) &
> -			 ~GELIC_DESCR_DMA_STAT_MASK));
> +	descr->hw_regs.dmac_cmd_status = cpu_to_be32(status
> +		| (be32_to_cpu(descr->hw_regs.dmac_cmd_status)
> +		& ~GELIC_DESCR_DMA_STAT_MASK));
>  	/*
>  	 * dma_cmd_status field is used to indicate whether the descriptor
>  	 * is valid or not.
> @@ -224,13 +236,14 @@ static void gelic_card_reset_chain(struct  
> gelic_card *card,
>
>  	for (descr = start_descr; start_descr != descr->next; descr++) {
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
> -		descr->next_descr_addr = cpu_to_be32(descr->next->bus_addr);
> +		descr->hw_regs.next_descr_addr
> +			= cpu_to_be32(descr->next->link.cpu_addr);
>  	}
>
>  	chain->head = start_descr;
>  	chain->tail = (descr - 1);
>
> -	(descr - 1)->next_descr_addr = 0;
> +	(descr - 1)->hw_regs.next_descr_addr = 0;
>  }
>
>  void gelic_card_up(struct gelic_card *card)
> @@ -276,20 +289,35 @@ void gelic_card_down(struct gelic_card *card)
>  	pr_debug("%s: done\n", __func__);
>  }
>
> +static void gelic_unmap_link(struct device *dev, struct gelic_descr *descr)
> +{
> +	BUG_ON(descr->hw_regs.payload.dev_addr);
> +	BUG_ON(descr->hw_regs.payload.size);
> +
> +	BUG_ON(!descr->link.cpu_addr);
> +	BUG_ON(!descr->link.size);

Don't add BUG_ON() unless absolutely necessary. Gracefully handle  
errors when possible


> +
> +	dma_unmap_single(dev, descr->link.cpu_addr, descr->link.size,
> +		DMA_BIDIRECTIONAL);
> +
> +	descr->link.cpu_addr = 0;
> +	descr->link.size = 0;
> +}
> +
>  /**
>   * gelic_card_free_chain - free descriptor chain
>   * @card: card structure
>   * @descr_in: address of desc
>   */
>  static void gelic_card_free_chain(struct gelic_card *card,
> -				  struct gelic_descr *descr_in)
> +	struct gelic_descr *descr_in)


Bad indent, should match open parenthesis

>  {
> +	struct device *dev = ctodev(card);
>  	struct gelic_descr *descr;
>
> -	for (descr = descr_in; descr && descr->bus_addr; descr = descr->next) {
> -		dma_unmap_single(ctodev(card), descr->bus_addr,
> -				 GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
> -		descr->bus_addr = 0;
> +	for (descr = descr_in; descr && descr->link.cpu_addr;
> +		descr = descr->next) {
> +		gelic_unmap_link(dev, descr);
>  	}
>  }
>
> @@ -298,7 +326,7 @@ static void gelic_card_free_chain(struct  
> gelic_card *card,
>   * @card: card structure
>   * @chain: address of chain
>   * @start_descr: address of descriptor array
> - * @no: number of descriptors
> + * @descr_count: number of descriptors
>   *
>   * we manage a circular list that mirrors the hardware structure,
>   * except that the hardware uses bus addresses.
> @@ -306,54 +334,57 @@ static void gelic_card_free_chain(struct  
> gelic_card *card,
>   * returns 0 on success, <0 on failure
>   */
>  static int gelic_card_init_chain(struct gelic_card *card,
> -				 struct gelic_descr_chain *chain,
> -				 struct gelic_descr *start_descr, int no)
> +	struct gelic_descr_chain *chain, struct gelic_descr *start_descr,
> +	int descr_count)
>  {
> -	int i;
> -	struct gelic_descr *descr;
> +	struct gelic_descr *descr = start_descr;
> +	struct device *dev = ctodev(card);
> +	unsigned int index;
>
> -	descr = start_descr;
> -	memset(descr, 0, sizeof(*descr) * no);
> +	memset(start_descr, 0, descr_count * sizeof(*start_descr));
>
> -	/* set up the hardware pointers in each descriptor */
> -	for (i = 0; i < no; i++, descr++) {
> +	for (index = 0, descr = start_descr; index < descr_count;
> +		index++, descr++) {
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
> -		descr->bus_addr =
> -			dma_map_single(ctodev(card), descr,
> -				       GELIC_DESCR_SIZE,
> -				       DMA_BIDIRECTIONAL);
>
> -		if (!descr->bus_addr)
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
>  	}
> -	/* make them as ring */
> +
>  	(descr - 1)->next = start_descr;
>  	start_descr->prev = (descr - 1);
>
>  	/* chain bus addr of hw descriptor */
> -	descr = start_descr;
> -	for (i = 0; i < no; i++, descr++) {
> -		descr->next_descr_addr = cpu_to_be32(descr->next->bus_addr);
> +
> +	for (index = 0, descr = start_descr; index < descr_count;
> +		index++, descr++) {
> +		descr->hw_regs.next_descr_addr
> +			= cpu_to_be32(descr->next->link.cpu_addr);
>  	}
>
>  	chain->head = start_descr;
>  	chain->tail = start_descr;
>
>  	/* do not chain last hw descriptor */
> -	(descr - 1)->next_descr_addr = 0;
> +	(descr - 1)->hw_regs.next_descr_addr = 0;
>
>  	return 0;
> -
> -iommu_error:
> -	for (i--, descr--; 0 <= i; i--, descr--)
> -		if (descr->bus_addr)
> -			dma_unmap_single(ctodev(card), descr->bus_addr,
> -					 GELIC_DESCR_SIZE,
> -					 DMA_BIDIRECTIONAL);
> -	return -ENOMEM;
>  }
>
>  /**
> @@ -367,49 +398,66 @@ static int gelic_card_init_chain(struct  
> gelic_card *card,
>   * Activate the descriptor state-wise
>   */
>  static int gelic_descr_prepare_rx(struct gelic_card *card,
> -				  struct gelic_descr *descr)
> +	struct gelic_descr *descr)
>  {
> -	int offset;
> -	unsigned int bufsize;
> +	struct device *dev = ctodev(card);
> +	struct aligned_buff {
> +		unsigned int total_bytes;
> +		unsigned int offset;
> +	};
> +	struct aligned_buff a_buf;
> +	dma_addr_t cpu_addr;
> +
> +	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE) {
> +		dev_err(dev, "%s:%d: ERROR status\n", __func__, __LINE__);
> +	}
>
> -	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
> -		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
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
> -		descr->buf_addr = 0; /* tell DMAC don't touch memory */
> +		descr->hw_regs.payload.dev_addr = 0;
> +		descr->hw_regs.payload.size = 0;
>  		return -ENOMEM;
>  	}
> -	descr->buf_size = cpu_to_be32(bufsize);
> -	descr->dmac_cmd_status = 0;
> -	descr->result_size = 0;
> -	descr->valid_size = 0;
> -	descr->data_error = 0;
> -
> -	offset = ((unsigned long)descr->skb->data) &
> -		(GELIC_NET_RXBUF_ALIGN - 1);
> -	if (offset)
> -		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
> -	/* io-mmu-map the skb */
> -	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
> -						     descr->skb->data,
> -						     GELIC_NET_MAX_MTU,
> -						     DMA_FROM_DEVICE));
> -	if (!descr->buf_addr) {
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
> +	descr->hw_regs.dmac_cmd_status = 0;
> +	descr->hw_regs.result_size = 0;
> +	descr->hw_regs.valid_size = 0;
> +	descr->hw_regs.data_error = 0;
> +
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
> -		dev_info(ctodev(card),
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
> @@ -420,19 +468,24 @@ static int gelic_descr_prepare_rx(struct  
> gelic_card *card,
>  static void gelic_card_release_rx_chain(struct gelic_card *card)
>  {
>  	struct gelic_descr *descr = card->rx_chain.head;
> +	struct device *dev = ctodev(card);
>
>  	do {
>  		if (descr->skb) {
> -			dma_unmap_single(ctodev(card),
> -					 be32_to_cpu(descr->buf_addr),
> -					 descr->skb->len,
> -					 DMA_FROM_DEVICE);
> -			descr->buf_addr = 0;
> +			dma_unmap_single(dev,
> +				be32_to_cpu(descr->hw_regs.payload.dev_addr),
> +				descr->hw_regs.payload.size, DMA_FROM_DEVICE);
> +
>  			dev_kfree_skb_any(descr->skb);
>  			descr->skb = NULL;
> +
>  			gelic_descr_set_status(descr,
> -					       GELIC_DESCR_DMA_NOT_IN_USE);
> +				GELIC_DESCR_DMA_NOT_IN_USE);
>  		}
> +
> +		descr->hw_regs.payload.dev_addr = 0;
> +		descr->hw_regs.payload.size = 0;
> +
>  		descr = descr->next;
>  	} while (descr != card->rx_chain.head);
>  }
> @@ -489,26 +542,29 @@ static int gelic_card_alloc_rx_skbs(struct  
> gelic_card *card)
>   * releases a used tx descriptor (unmapping, freeing of skb)
>   */
>  static void gelic_descr_release_tx(struct gelic_card *card,
> -				       struct gelic_descr *descr)
> +	struct gelic_descr *descr)
>  {
>  	struct sk_buff *skb = descr->skb;
> +	struct device *dev = ctodev(card);
>
> -	BUG_ON(!(be32_to_cpu(descr->data_status) & GELIC_DESCR_TX_TAIL));
> +	BUG_ON(!(be32_to_cpu(descr->hw_regs.data_status)
> +		& GELIC_DESCR_TX_TAIL));
>
> -	dma_unmap_single(ctodev(card), be32_to_cpu(descr->buf_addr), skb->len,
> -			 DMA_TO_DEVICE);
> -	dev_kfree_skb_any(skb);
> +	dma_unmap_single(dev, be32_to_cpu(descr->hw_regs.payload.dev_addr),
> +		descr->hw_regs.payload.size, DMA_TO_DEVICE);
> +
> +	descr->hw_regs.payload.dev_addr = 0;
> +	descr->hw_regs.payload.size = 0;
>
> -	descr->buf_addr = 0;
> -	descr->buf_size = 0;
> -	descr->next_descr_addr = 0;
> -	descr->result_size = 0;
> -	descr->valid_size = 0;
> -	descr->data_status = 0;
> -	descr->data_error = 0;
> +	dev_kfree_skb_any(skb);
>  	descr->skb = NULL;
>
> -	/* set descr status */
> +	descr->hw_regs.next_descr_addr = 0;
> +	descr->hw_regs.result_size = 0;
> +	descr->hw_regs.valid_size = 0;
> +	descr->hw_regs.data_status = 0;
> +	descr->hw_regs.data_error = 0;
> +
>  	gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  }
>
> @@ -536,48 +592,53 @@ static void gelic_card_wake_queues(struct  
> gelic_card *card)
>  static void gelic_card_release_tx_chain(struct gelic_card *card, int stop)
>  {
>  	struct gelic_descr_chain *tx_chain;
> -	enum gelic_descr_dma_status status;
> -	struct net_device *netdev;
> -	int release = 0;
> +	struct device *dev = ctodev(card);
> +	int release;
>
> -	for (tx_chain = &card->tx_chain;
> +	for (release = 0, tx_chain = &card->tx_chain;
>  	     tx_chain->head != tx_chain->tail && tx_chain->tail;
>  	     tx_chain->tail = tx_chain->tail->next) {
> -		status = gelic_descr_get_status(tx_chain->tail);
> -		netdev = tx_chain->tail->skb->dev;
> +		enum gelic_descr_dma_status status;
> +		struct gelic_descr *descr;
> +		struct net_device *netdev;
> +
> +		descr = tx_chain->tail;
> +		status= gelic_descr_get_status(descr);
> +		netdev = descr->skb->dev;
> +
>  		switch (status) {
>  		case GELIC_DESCR_DMA_RESPONSE_ERROR:
>  		case GELIC_DESCR_DMA_PROTECTION_ERROR:
>  		case GELIC_DESCR_DMA_FORCE_END:
> -			if (printk_ratelimit())
> -				dev_info(ctodev(card),
> -					 "%s: forcing end of tx descriptor " \
> -					 "with status %x\n",
> -					 __func__, status);
> +			if (printk_ratelimit()) {
> +				dev_info(dev,
> +					 "%s:%d: forcing end of tx descriptor with status %x\n",
> +					 __func__, __LINE__, status);
> +			}
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
>  		case GELIC_DESCR_DMA_CARDOWNED:
> -			/* pending tx request */
>  		default:
> -			/* any other value (== GELIC_DESCR_DMA_NOT_IN_USE) */
> -			if (!stop)
> +			if (!stop) {
>  				goto out;
> +			}
>  		}
> -		gelic_descr_release_tx(card, tx_chain->tail);
> -		release ++;
> +
> +		gelic_descr_release_tx(card, descr);
> +		release++;
>  	}
>  out:
> -	if (!stop && release)
> +	if (!stop && release) {
>  		gelic_card_wake_queues(card);
> +	}
>  }
>
>  /**
> @@ -695,30 +756,30 @@ gelic_card_get_next_tx_descr(struct gelic_card *card)
>   * has executed before.
>   */
>  static void gelic_descr_set_tx_cmdstat(struct gelic_descr *descr,
> -				       struct sk_buff *skb)
> +	struct sk_buff *skb)
>  {
>  	if (skb->ip_summed != CHECKSUM_PARTIAL)
> -		descr->dmac_cmd_status =
> +		descr->hw_regs.dmac_cmd_status =
>  			cpu_to_be32(GELIC_DESCR_DMA_CMD_NO_CHKSUM |
> -				    GELIC_DESCR_TX_DMA_FRAME_TAIL);
> +				GELIC_DESCR_TX_DMA_FRAME_TAIL);
>  	else {
>  		/* is packet ip?
>  		 * if yes: tcp? udp? */
>  		if (skb->protocol == htons(ETH_P_IP)) {
>  			if (ip_hdr(skb)->protocol == IPPROTO_TCP)
> -				descr->dmac_cmd_status =
> +				descr->hw_regs.dmac_cmd_status =
>  				cpu_to_be32(GELIC_DESCR_DMA_CMD_TCP_CHKSUM |
>  					    GELIC_DESCR_TX_DMA_FRAME_TAIL);
>
>  			else if (ip_hdr(skb)->protocol == IPPROTO_UDP)
> -				descr->dmac_cmd_status =
> +				descr->hw_regs.dmac_cmd_status =
>  				cpu_to_be32(GELIC_DESCR_DMA_CMD_UDP_CHKSUM |
>  					    GELIC_DESCR_TX_DMA_FRAME_TAIL);
>  			else	/*
>  				 * the stack should checksum non-tcp and non-udp
>  				 * packets on his own: NETIF_F_IP_CSUM
>  				 */
> -				descr->dmac_cmd_status =
> +				descr->hw_regs.dmac_cmd_status =
>  				cpu_to_be32(GELIC_DESCR_DMA_CMD_NO_CHKSUM |
>  					    GELIC_DESCR_TX_DMA_FRAME_TAIL);
>  		}
> @@ -760,37 +821,41 @@ static struct sk_buff  
> *gelic_put_vlan_tag(struct sk_buff *skb,
>   *
>   */
>  static int gelic_descr_prepare_tx(struct gelic_card *card,
> -				  struct gelic_descr *descr,
> -				  struct sk_buff *skb)
> +	struct gelic_descr *descr, struct sk_buff *skb)
>  {
> -	dma_addr_t buf;
> +	struct device *dev = ctodev(card);
> +	dma_addr_t cpu_addr;
>
>  	if (card->vlan_required) {
>  		struct sk_buff *skb_tmp;
>  		enum gelic_port_type type;
>
>  		type = netdev_port(skb->dev)->type;
> -		skb_tmp = gelic_put_vlan_tag(skb,
> -					     card->vlan[type].tx);
> -		if (!skb_tmp)
> +		skb_tmp = gelic_put_vlan_tag(skb, card->vlan[type].tx);
> +
> +		if (!skb_tmp) {
>  			return -ENOMEM;
> +		}
> +
>  		skb = skb_tmp;
>  	}
>
> -	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
> +	descr->hw_regs.payload.size = skb->len;
> +	cpu_addr = dma_map_single(dev, skb->data, descr->hw_regs.payload.size,
> +		DMA_TO_DEVICE);
> +	descr->hw_regs.payload.dev_addr = cpu_to_be32(cpu_addr);
>
> -	if (!buf) {
> -		dev_err(ctodev(card),
> -			"dma map 2 failed (%p, %i). Dropping packet\n",
> -			skb->data, skb->len);
> +	if (unlikely(dma_mapping_error(dev, cpu_addr))) {
> +		dev_err(dev, "%s:%d: dma_mapping_error\n", __func__, __LINE__);
> +
> +		descr->hw_regs.payload.dev_addr = 0;
> +		descr->hw_regs.payload.size = 0;
>  		return -ENOMEM;
>  	}
>
> -	descr->buf_addr = cpu_to_be32(buf);
> -	descr->buf_size = cpu_to_be32(skb->len);
>  	descr->skb = skb;
> -	descr->data_status = 0;
> -	descr->next_descr_addr = 0; /* terminate hw descr */
> +	descr->hw_regs.data_status = 0;
> +	descr->hw_regs.next_descr_addr = 0; /* terminate hw descr */
>  	gelic_descr_set_tx_cmdstat(descr, skb);
>
>  	/* bump free descriptor pointer */
> @@ -805,8 +870,9 @@ static int gelic_descr_prepare_tx(struct  
> gelic_card *card,
>   *
>   */
>  static int gelic_card_kick_txdma(struct gelic_card *card,
> -				 struct gelic_descr *descr)
> +	struct gelic_descr *descr)
>  {
> +	struct device *dev = ctodev(card);
>  	int status = 0;
>
>  	if (card->tx_dma_progress)
> @@ -815,11 +881,11 @@ static int gelic_card_kick_txdma(struct  
> gelic_card *card,
>  	if (gelic_descr_get_status(descr) == GELIC_DESCR_DMA_CARDOWNED) {
>  		card->tx_dma_progress = 1;
>  		status = lv1_net_start_tx_dma(bus_id(card), dev_id(card),
> -					      descr->bus_addr, 0);
> +					      descr->link.cpu_addr, 0);
>  		if (status) {
>  			card->tx_dma_progress = 0;
> -			dev_info(ctodev(card), "lv1_net_start_txdma failed," \
> -				 "status=%d\n", status);
> +			dev_info(dev, "%s:%d: lv1_net_start_txdma failed: %d\n",
> +				__func__, __LINE__, status);
>  		}
>  	}
>  	return status;
> @@ -835,6 +901,7 @@ static int gelic_card_kick_txdma(struct gelic_card *card,
>  netdev_tx_t gelic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
>  {
>  	struct gelic_card *card = netdev_card(netdev);
> +	struct device *dev = ctodev(card);
>  	struct gelic_descr *descr;
>  	int result;
>  	unsigned long flags;
> @@ -868,7 +935,9 @@ netdev_tx_t gelic_net_xmit(struct sk_buff *skb,  
> struct net_device *netdev)
>  	 * link this prepared descriptor to previous one
>  	 * to achieve high performance
>  	 */
> -	descr->prev->next_descr_addr = cpu_to_be32(descr->bus_addr);
> +	descr->prev->hw_regs.next_descr_addr
> +		= cpu_to_be32(descr->link.cpu_addr);
> +
>  	/*
>  	 * as hardware descriptor is modified in the above lines,
>  	 * ensure that the hardware sees it
> @@ -881,13 +950,13 @@ netdev_tx_t gelic_net_xmit(struct sk_buff  
> *skb, struct net_device *netdev)
>  		 */
>  		netdev->stats.tx_dropped++;
>  		/* don't trigger BUG_ON() in gelic_descr_release_tx */
> -		descr->data_status = cpu_to_be32(GELIC_DESCR_TX_TAIL);
> +		descr->hw_regs.data_status = cpu_to_be32(GELIC_DESCR_TX_TAIL);
>  		gelic_descr_release_tx(card, descr);
>  		/* reset head */
>  		card->tx_chain.head = descr;
>  		/* reset hw termination */
> -		descr->prev->next_descr_addr = 0;
> -		dev_info(ctodev(card), "%s: kick failure\n", __func__);
> +		descr->prev->hw_regs.next_descr_addr = 0;
> +		dev_info(dev, "%s:%d: kick failure\n", __func__, __LINE__);
>  	}
>
>  	spin_unlock_irqrestore(&card->tx_lock, flags);
> @@ -904,28 +973,29 @@ netdev_tx_t gelic_net_xmit(struct sk_buff  
> *skb, struct net_device *netdev)
>   * stack. The descriptor state is not changed.

>   */
>  static void gelic_net_pass_skb_up(struct gelic_descr *descr,
> -				  struct gelic_card *card,
> -				  struct net_device *netdev)
> -
> +	struct gelic_card *card, struct net_device *netdev)
>  {
> +	struct device *dev = ctodev(card);
>  	struct sk_buff *skb = descr->skb;
>  	u32 data_status, data_error;
>
> -	data_status = be32_to_cpu(descr->data_status);
> -	data_error = be32_to_cpu(descr->data_error);
> -	/* unmap skb buffer */
> -	dma_unmap_single(ctodev(card), be32_to_cpu(descr->buf_addr),
> -			 GELIC_NET_MAX_MTU,
> -			 DMA_FROM_DEVICE);
> -
> -	skb_put(skb, be32_to_cpu(descr->valid_size)?
> -		be32_to_cpu(descr->valid_size) :
> -		be32_to_cpu(descr->result_size));
> -	if (!descr->valid_size)
> -		dev_info(ctodev(card), "buffer full %x %x %x\n",
> -			 be32_to_cpu(descr->result_size),
> -			 be32_to_cpu(descr->buf_size),
> -			 be32_to_cpu(descr->dmac_cmd_status));
> +	data_status = be32_to_cpu(descr->hw_regs.data_status);
> +	data_error = be32_to_cpu(descr->hw_regs.data_error);
> +
> +	dma_unmap_single(dev, be32_to_cpu(descr->hw_regs.payload.dev_addr),
> +		descr->hw_regs.payload.size, DMA_FROM_DEVICE);
> +
> +	skb_put(skb, be32_to_cpu(descr->hw_regs.valid_size)?
> +		be32_to_cpu(descr->hw_regs.valid_size) :
> +		be32_to_cpu(descr->hw_regs.result_size));
> +
> +	if (!descr->hw_regs.valid_size) {
> +		dev_err(dev, "%s:%d: buffer full %x %x %x\n", __func__,
> +			__LINE__,
> +			 be32_to_cpu(descr->hw_regs.result_size),
> +			 be32_to_cpu(descr->hw_regs.payload.size),
> +			 be32_to_cpu(descr->hw_regs.dmac_cmd_status));
> +	}
>
>  	descr->skb = NULL;
>  	/*
> @@ -964,9 +1034,10 @@ static void gelic_net_pass_skb_up(struct  
> gelic_descr *descr,
>   */
>  static int gelic_card_decode_one_descr(struct gelic_card *card)
>  {
> -	enum gelic_descr_dma_status status;
>  	struct gelic_descr_chain *chain = &card->rx_chain;
>  	struct gelic_descr *descr = chain->head;
> +	enum gelic_descr_dma_status status;
> +	struct device *dev = ctodev(card);
>  	struct net_device *netdev = NULL;
>  	int dmac_chain_ended;
>
> @@ -976,7 +1047,8 @@ static int gelic_card_decode_one_descr(struct  
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
> @@ -992,7 +1064,8 @@ static int gelic_card_decode_one_descr(struct  
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
> @@ -1001,8 +1074,8 @@ static int gelic_card_decode_one_descr(struct  
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
> @@ -1017,7 +1090,7 @@ static int gelic_card_decode_one_descr(struct  
> gelic_card *card)
>  		 * Anyway this frame was longer than the MTU,
>  		 * just drop it.
>  		 */
> -		dev_info(ctodev(card), "overlength frame\n");
> +		dev_info(dev, "%s:%d: overlength frame\n", __func__, __LINE__);
>  		goto refill;
>  	}
>  	/*
> @@ -1025,8 +1098,8 @@ static int gelic_card_decode_one_descr(struct  
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
> @@ -1035,15 +1108,14 @@ static int  
> gelic_card_decode_one_descr(struct gelic_card *card)
>  refill:
>
>  	/* is the current descriptor terminated with next_descr == NULL? */
> -	dmac_chain_ended =
> -		be32_to_cpu(descr->dmac_cmd_status) &
> +	dmac_chain_ended = be32_to_cpu(descr->hw_regs.dmac_cmd_status) &
>  		GELIC_DESCR_RX_DMA_CHAIN_END;
>  	/*
>  	 * So that always DMAC can see the end
>  	 * of the descriptor chain to avoid
>  	 * from unwanted DMAC overrun.
>  	 */
> -	descr->next_descr_addr = 0;
> +	descr->hw_regs.next_descr_addr = 0;
>
>  	/* change the descriptor state: */
>  	gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
> @@ -1060,15 +1132,17 @@ static int  
> gelic_card_decode_one_descr(struct gelic_card *card)
>  	/*
>  	 * Set this descriptor the end of the chain.
>  	 */
> -	descr->prev->next_descr_addr = cpu_to_be32(descr->bus_addr);
> +	descr->prev->hw_regs.next_descr_addr
> +		= cpu_to_be32(descr->link.cpu_addr);
>
>  	/*
>  	 * If dmac chain was met, DMAC stopped.
>  	 * thus re-enable it
>  	 */
>
> -	if (dmac_chain_ended)
> +	if (dmac_chain_ended) {
>  		gelic_card_enable_rxdmac(card);
> +	}
>
>  	return 1;
>  }
> @@ -1192,9 +1266,10 @@ void gelic_net_get_drvinfo(struct net_device *netdev,
>  }
>
>  static int gelic_ether_get_link_ksettings(struct net_device *netdev,
> -					  struct ethtool_link_ksettings *cmd)
> +	struct ethtool_link_ksettings *cmd)
>  {
>  	struct gelic_card *card = netdev_card(netdev);
> +	struct device *dev = ctodev(card);
>  	u32 supported, advertising;
>
>  	gelic_card_get_ether_port_status(card, 0);
> @@ -1215,16 +1290,17 @@ static int  
> gelic_ether_get_link_ksettings(struct net_device *netdev,
>  		cmd->base.speed = SPEED_1000;
>  		break;
>  	default:
> -		pr_info("%s: speed unknown\n", __func__);
> +		dev_dbg(dev, "%s:%d: speed unknown\n", __func__, __LINE__);
>  		cmd->base.speed = SPEED_10;
>  		break;
>  	}
>
>  	supported = SUPPORTED_TP | SUPPORTED_Autoneg |
> -			SUPPORTED_10baseT_Half | SUPPORTED_10baseT_Full |
> -			SUPPORTED_100baseT_Half | SUPPORTED_100baseT_Full |
> -			SUPPORTED_1000baseT_Full;
> +		SUPPORTED_10baseT_Half | SUPPORTED_10baseT_Full |
> +		SUPPORTED_100baseT_Half | SUPPORTED_100baseT_Full |
> +		SUPPORTED_1000baseT_Full;
>  	advertising = supported;
> +
>  	if (card->link_mode & GELIC_LV1_ETHER_AUTO_NEG) {
>  		cmd->base.autoneg = AUTONEG_ENABLE;
>  	} else {
> @@ -1234,9 +1310,9 @@ static int  
> gelic_ether_get_link_ksettings(struct net_device *netdev,
>  	cmd->base.port = PORT_TP;
>
>  	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
> -						supported);
> +		supported);
>  	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
> -						advertising);
> +		advertising);
>
>  	return 0;
>  }
> @@ -1637,130 +1713,134 @@ static void  
> gelic_card_get_vlan_info(struct gelic_card *card)
>  /*
>   * ps3_gelic_driver_probe - add a device to the control of this driver
>   */
> -static int ps3_gelic_driver_probe(struct ps3_system_bus_device *dev)
> +static int ps3_gelic_driver_probe(struct ps3_system_bus_device *sb_dev)
>  {
> -	struct gelic_card *card;
> +	struct device *dev = &sb_dev->core;
>  	struct net_device *netdev;
> +	struct gelic_card *card;
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
>
> -	/* alloc card/netdevice */
>  	card = gelic_alloc_card_net(&netdev);
> +
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
>
> -	/* get internal vlan info */
> +	ps3_system_bus_set_drvdata(sb_dev, card);
> +	card->dev = sb_dev;
>  	gelic_card_get_vlan_info(card);
> -
>  	card->link_mode = GELIC_LV1_ETHER_AUTO_NEG;
>
> -	/* setup interrupt */
>  	result = lv1_net_set_interrupt_status_indicator(bus_id(card),
> -							dev_id(card),
> -		ps3_mm_phys_to_lpar(__pa(&card->irq_status)),
> -		0);
> +		dev_id(card), ps3_mm_phys_to_lpar(__pa(&card->irq_status)), 0);
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
> +			 __func__, __LINE__, result);
>  		result = -EPERM;
>  		goto fail_alloc_irq;
>  	}
> +
>  	result = request_irq(card->irq, gelic_card_interrupt,
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
> -	/* setup card structure */
>  	card->irq_mask = GELIC_CARD_RXINT | GELIC_CARD_TXINT |
>  		GELIC_CARD_PORT_STATUS_CHANGED;
>
> +	result = gelic_card_init_chain(card, &card->tx_chain, card->descr,
> +		GELIC_NET_TX_DESCRIPTORS);
>
> -	result = gelic_card_init_chain(card, &card->tx_chain,
> -				       card->descr, GELIC_NET_TX_DESCRIPTORS);
> -	if (result)
> +	if (result) {
>  		goto fail_alloc_tx;
> +	}
> +
>  	result = gelic_card_init_chain(card, &card->rx_chain,
> -				       card->descr + GELIC_NET_TX_DESCRIPTORS,
> -				       GELIC_NET_RX_DESCRIPTORS);
> -	if (result)
> +		card->descr + GELIC_NET_TX_DESCRIPTORS,
> +		GELIC_NET_RX_DESCRIPTORS);
> +
> +	if (result) {
>  		goto fail_alloc_rx;
> +	}
>
> -	/* head of chain */
>  	card->tx_top = card->tx_chain.head;
>  	card->rx_top = card->rx_chain.head;
> -	dev_dbg(ctodev(card), "descr rx %p, tx %p, size %#lx, num %#x\n",
> -		card->rx_top, card->tx_top, sizeof(struct gelic_descr),
> -		GELIC_NET_RX_DESCRIPTORS);
> -	/* allocate rx skbs */
> +
> +	dev_dbg(dev, "%s:%d: descr rx %px, tx %px, size %#lx, num %#x\n",
> +		__func__, __LINE__, card->rx_top, card->tx_top,
> +		sizeof(struct gelic_descr), GELIC_NET_RX_DESCRIPTORS);
> +
>  	result = gelic_card_alloc_rx_skbs(card);
> -	if (result)
> +
> +	if (result) {
>  		goto fail_alloc_skbs;
> +	}
>
>  	spin_lock_init(&card->tx_lock);
>  	card->tx_dma_progress = 0;
>
> -	/* setup net_device structure */
>  	netdev->irq = card->irq;
> -	SET_NETDEV_DEV(netdev, &card->dev->core);
> +	SET_NETDEV_DEV(netdev, dev);
>  	gelic_ether_setup_netdev_ops(netdev, &card->napi);
> +
>  	result = gelic_net_setup_netdev(netdev, card);
> +
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
> +
>  	if (result) {
> -		dev_dbg(&dev->core, "%s: WL init failed\n", __func__);
> +		dev_dbg(dev, "%s:%d: WL init failed\n", __func__, __LINE__);
>  		goto fail_setup_netdev;
>  	}
>  #endif
> -	pr_debug("%s: done\n", __func__);
> +
> +	dev_dbg(dev, "%s:%d: < OK\n", __func__, __LINE__);
>  	return 0;
>
>  fail_setup_netdev:
> @@ -1772,20 +1852,19 @@ static int ps3_gelic_driver_probe(struct  
> ps3_system_bus_device *dev)
>  	free_irq(card->irq, card);
>  	netdev->irq = 0;
>  fail_request_irq:
> -	ps3_sb_event_receive_port_destroy(dev, card->irq);
> +	ps3_sb_event_receive_port_destroy(sb_dev, card->irq);
>  fail_alloc_irq:
> -	lv1_net_set_interrupt_status_indicator(bus_id(card),
> -					       bus_id(card),
> -					       0, 0);
> +	lv1_net_set_interrupt_status_indicator(bus_id(card), bus_id(card), 0, 0);
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
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h  
> b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
> index 68f324ed4eaf..fb0d314d53e5 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
> @@ -220,29 +220,35 @@ enum gelic_lv1_phy {
>  	GELIC_LV1_PHY_ETHERNET_0	= 0x0000000000000002L,
>  };
>
> -/* size of hardware part of gelic descriptor */
> -#define GELIC_DESCR_SIZE	(32)
> -
>  enum gelic_port_type {
>  	GELIC_PORT_ETHERNET_0	= 0,
>  	GELIC_PORT_WIRELESS	= 1,
>  	GELIC_PORT_MAX
>  };
>
> -struct gelic_descr {
> -	/* as defined by the hardware */
> -	__be32 buf_addr;
> -	__be32 buf_size;
> +/* as defined by the hardware */
> +struct gelic_hw_regs {
> +	struct  {
> +		__be32 dev_addr;
> +		__be32 size;
> +	} __attribute__ ((packed)) payload;
>  	__be32 next_descr_addr;
>  	__be32 dmac_cmd_status;
>  	__be32 result_size;
>  	__be32 valid_size;	/* all zeroes for tx */
>  	__be32 data_status;
>  	__be32 data_error;	/* all zeroes for tx */
> +} __attribute__ ((packed));
>
> -	/* used in the driver */
> +struct gelic_chain_link {
> +	dma_addr_t cpu_addr;
> +	unsigned int size;
> +};
> +
> +struct gelic_descr {
> +	struct gelic_hw_regs hw_regs;
> +	struct gelic_chain_link link;
>  	struct sk_buff *skb;
> -	dma_addr_t bus_addr;
>  	struct gelic_descr *next;
>  	struct gelic_descr *prev;
>  } __attribute__((aligned(32)));
> --
> 2.25.1



