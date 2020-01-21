Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E6514428C
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgAUQy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:54:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbgAUQy2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 11:54:28 -0500
Received: from cakuba (unknown [199.201.64.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A06621569;
        Tue, 21 Jan 2020 16:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579625666;
        bh=n988vk8kzQ+ii9jm1htwTiNDOSpllrsKLfIGi54T3Ww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fzWui9d//Os99tK6+r+WbunuVmA/ZGIRTpzh1lXzRkX+5YuAPWfISmRQSYYy9XZqz
         9FmkuxCMpWaEDXxPha2UZaWuzYEPJC6svIjBWIcpQDp8gtZfn9i6ulX+NX5Y5tD1r8
         vZvppfswQuVTpJ0d5wFGVEEdMchEayHQ/9bYMApM=
Date:   Tue, 21 Jan 2020 08:54:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: Re: [PATCH v4 07/17] octeontx2-pf: Add packet transmission support
Message-ID: <20200121085425.652eae8c@cakuba>
In-Reply-To: <1579612911-24497-8-git-send-email-sunil.kovvuri@gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579612911-24497-8-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jan 2020 18:51:41 +0530, sunil.kovvuri@gmail.com wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> This patch adds the packet transmission support.
> For a given skb prepares send queue descriptors (SQEs) and pushes them
> to HW. Here driver doesn't maintain it's own SQ rings, SQEs are pushed
> to HW using a silicon specific operations called LMTST. From the
> instuction HW derives the transmit queue number and queues the SQE to
> that queue. These LMTST instructions are designed to avoid queue
> maintenance in SW and lockless behavior ie when multiple cores are trying
> to add SQEs to same queue then HW will takecare of serialization, no need
> for SW to hold locks.
> 
> Also supports scatter/gather.
> 
> Co-developed-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

> +static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
> +

Spurious new line

> +{
> +	struct otx2_nic *pf = netdev_priv(netdev);
> +	int qidx = skb_get_queue_mapping(skb);
> +	struct otx2_snd_queue *sq;
> +	struct netdev_queue *txq;
> +
> +	/* Check for minimum and maximum packet length */

You only check for min

> +	if (skb->len <= ETH_HLEN) {
> +		dev_kfree_skb(skb);
> +		return NETDEV_TX_OK;
> +	}
> +
> +	sq = &pf->qset.sq[qidx];
> +	txq = netdev_get_tx_queue(netdev, qidx);
> +
> +	if (netif_tx_queue_stopped(txq)) {
> +		dev_kfree_skb(skb);

This should never happen.

> +	} else if (!otx2_sq_append_skb(netdev, sq, skb, qidx)) {
> +		netif_tx_stop_queue(txq);
> +
> +		/* Check again, incase SQBs got freed up */
> +		smp_mb();
> +		if (((sq->num_sqbs - *sq->aura_fc_addr) * sq->sqe_per_sqb)
> +							> sq->sqe_thresh)
> +			netif_tx_wake_queue(txq);
> +
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	return NETDEV_TX_OK;
> +}

> +/* NIX send memory subdescriptor structure */
> +struct nix_sqe_mem_s {
> +#if defined(__BIG_ENDIAN_BITFIELD)  /* W0 */
> +	u64 subdc         : 4;
> +	u64 alg           : 4;
> +	u64 dsz           : 2;
> +	u64 wmem          : 1;
> +	u64 rsvd_52_16    : 37;
> +	u64 offset        : 16;
> +#else
> +	u64 offset        : 16;
> +	u64 rsvd_52_16    : 37;
> +	u64 wmem          : 1;
> +	u64 dsz           : 2;
> +	u64 alg           : 4;
> +	u64 subdc         : 4;
> +#endif

Traditionally we prefer to extract the bitfields with masks and shifts
manually in the kernel, rather than having those (subjectively) ugly
and finicky bitfield structs. But I guess if nobody else complains this
can stay :/

> +	u64 addr;

Why do you care about big endian bitfields tho, if you don't care about
endianness of the data itself? 

> +};
> +
>  #endif /* OTX2_STRUCT_H */
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> index e6be18d..f416603 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> @@ -32,6 +32,78 @@ static struct nix_cqe_hdr_s *otx2_get_next_cqe(struct otx2_cq_queue *cq)
>  	return cqe_hdr;
>  }
>  
> +static unsigned int frag_num(unsigned int i)
> +{
> +#ifdef __BIG_ENDIAN
> +	return (i & ~3) + 3 - (i & 3);
> +#else
> +	return i;
> +#endif
> +}
> +
> +static dma_addr_t otx2_dma_map_skb_frag(struct otx2_nic *pfvf,
> +					struct sk_buff *skb, int seg, int *len)
> +{
> +	const skb_frag_t *frag;
> +	struct page *page;
> +	int offset;
> +
> +	/* First segment is always skb->data */
> +	if (!seg) {
> +		page = virt_to_page(skb->data);
> +		offset = offset_in_page(skb->data);
> +		*len = skb_headlen(skb);
> +	} else {
> +		frag = &skb_shinfo(skb)->frags[seg - 1];
> +		page = skb_frag_page(frag);
> +		offset = skb_frag_off(frag);
> +		*len = skb_frag_size(frag);
> +	}
> +	return otx2_dma_map_page(pfvf, page, offset, *len, DMA_TO_DEVICE);
> +}
> +
> +static void otx2_dma_unmap_skb_frags(struct otx2_nic *pfvf, struct sg_list *sg)
> +{
> +	int seg;
> +
> +	for (seg = 0; seg < sg->num_segs; seg++) {
> +		otx2_dma_unmap_page(pfvf, sg->dma_addr[seg],
> +				    sg->size[seg], DMA_TO_DEVICE);
> +	}

no need for parenthesis

> +	sg->num_segs = 0;
> +}
> +
> +static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
> +				 struct otx2_cq_queue *cq,
> +				 struct otx2_snd_queue *sq,
> +				 struct nix_cqe_tx_s *cqe,
> +				 int budget, int *tx_pkts, int *tx_bytes)
> +{
> +	struct nix_send_comp_s *snd_comp = &cqe->comp;
> +	struct sk_buff *skb = NULL;
> +	struct sg_list *sg;
> +
> +	if (unlikely(snd_comp->status)) {
> +		netdev_info(pfvf->netdev,
> +			    "TX%d: Error in send CQ status:%x\n",
> +			    cq->cint_idx, snd_comp->status);

This should probably be ratelimitted

> +	}

unnecessary parenthesis

> +
> +	/* Barrier, so that update to sq by other cpus is visible */
> +	smp_mb();

Could you please rephrase this comment to explain between what and what
this barrier is? :S

> +	sg = &sq->sg[snd_comp->sqe_id];
> +
> +	skb = (struct sk_buff *)sg->skb;
> +	if (unlikely(!skb))
> +		return;
> +
> +	*tx_bytes += skb->len;
> +	(*tx_pkts)++;
> +	otx2_dma_unmap_skb_frags(pfvf, sg);
> +	napi_consume_skb(skb, budget);
> +	sg->skb = (u64)NULL;
> +}
> +

> @@ -225,6 +331,169 @@ int otx2_napi_handler(struct napi_struct *napi, int budget)
>  	return workdone;
>  }
>  
> +static void otx2_sqe_flush(struct otx2_snd_queue *sq, int size)
> +{
> +	u64 status;
> +
> +	/* Packet data stores should finish before SQE is flushed to HW */

Packet data is synced by the dma operations the barrier shouldn't be
needed AFAIK (and if it would be, dma_wmb() would not be the one, as it
only works for iomem AFAIU).

> +	dma_wmb();
> +
> +	do {
> +		memcpy(sq->lmt_addr, sq->sqe_base, size);
> +		status = otx2_lmt_flush(sq->io_addr);
> +	} while (status == 0);
> +
> +	sq->head++;
> +	sq->head &= (sq->sqe_cnt - 1);
> +}
