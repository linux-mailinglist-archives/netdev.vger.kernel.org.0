Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CA5482815
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 18:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbiAAR5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 12:57:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46804 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230259AbiAAR5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jan 2022 12:57:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=B/vtZgTRPWy1UnrRYAWw0GX+/10f5CNSq39ymnRwnQM=; b=d+l5mLKtu06HgPD4IifS0fNdH5
        Ta3VpToTGmeRw3OByfkMg7Bhb1H7p8eAMpo0qnkSDHPM5FGTx5iy75RRjyZSbcdqvYxgAN8R3FItQ
        Qrywxl8bx+zW2wzawCHez7xQPgUY2EI3rp120ALtFkQKzdcFDHZSFK/v97dGT77NeVa4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n3idL-000HCN-GB; Sat, 01 Jan 2022 18:57:35 +0100
Date:   Sat, 1 Jan 2022 18:57:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/8] net/funeth: add the data path
Message-ID: <YdCWD97QfLzGq/mZ@lunn.ch>
References: <20211231090833.98977-1-dmichail@fungible.com>
 <20211231090833.98977-7-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231090833.98977-7-dmichail@fungible.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/ethernet/fungible/funeth/funeth_rx.c

> +/* See if a page is running low on refs we are holding and if so take more. */
> +static inline void refresh_refs(struct funeth_rxbuf *buf)
> +{
> +	if (unlikely(buf->pg_refs < MIN_PAGE_REFS)) {
> +		buf->pg_refs += EXTRA_PAGE_REFS;
> +		page_ref_add(buf->page, EXTRA_PAGE_REFS);
> +	}
> +}

No inline functions in C files please. Let the compiler decide. Please
check for this in the whole driver.

> +/* A CQE contains a fixed completion structure along with optional metadata and
> + * even packet data. Given the start address of a CQE return the start of the
> + * contained fixed structure, which lies at the end.
> + */
> +static inline const void *cqe_to_info(const void *cqe)
> +{
> +	return cqe + FUNETH_CQE_INFO_OFFSET;
> +}
> +
> +/* The inverse of cqe_to_info(). */
> +static inline const void *info_to_cqe(const void *cqe_info)
> +{
> +	return cqe_info - FUNETH_CQE_INFO_OFFSET;
> +}

This looks pretty brittle. Can you define a struct cqe, so avoid all
this arithmetic on void * pointers?

> +static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
> +				   unsigned int tls_len)
> +{
> +	unsigned int idx = q->prod_cnt & q->mask;
> +	struct fun_eth_tx_req *req = fun_tx_desc_addr(q, idx);

You need to move the assignment into the body to keep with reverse
Christmas tree.

> +	if (txq_to_end(q, gle) == 0) {
> +		gle = (struct fun_dataop_gl *)q->desc;
> +		for ( ; i < ngle; i++, gle++)
> +			fun_dataop_gl_init(gle, 0, 0, lens[i], addrs[i]);
> +	}
> +
> +#ifdef CONFIG_TLS_DEVICE

If possible, use if (IS_ENABLED(TLS_DEVICE)), not #ifdef. It will give
you better compile testing, if it works.

> +	if (unlikely(tls_len)) {
> +		struct fun_eth_tls *tls = (struct fun_eth_tls *)gle;
> +		struct fun_ktls_tx_ctx *tls_ctx;
> +
> +		req->len8 += FUNETH_TLS_SZ / 8;
> +		req->flags = cpu_to_be16(FUN_ETH_TX_TLS);
> +
> +		tls_ctx = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
> +		tls->tlsid = tls_ctx->tlsid;
> +		tls_ctx->next_seq += tls_len;
> +
> +		u64_stats_update_begin(&q->syncp);
> +		q->stats.tx_tls_bytes += tls_len;
> +		q->stats.tx_tls_pkts += 1 + extra_pkts;
> +		u64_stats_update_end(&q->syncp);
> +	}
> +#endif

> +/* Create a Tx queue, allocating all the host and device resources needed. */
> +struct funeth_txq *funeth_txq_create(struct net_device *dev, unsigned int qidx,
> +				     unsigned int ndesc, struct fun_irq *irq)
> +{
> +	struct funeth_priv *fp = netdev_priv(dev);
> +	unsigned int ethid = fp->ethid_start + qidx;
> +	int numa_node, err = -ENOMEM;
> +	struct funeth_txq *q;
> +	const char *qtype;

...

> +	netif_info(fp, ifup, dev,
> +		   "%s queue %u, depth %u, HW qid %u, IRQ idx %u, node %d\n",
> +		   qtype, qidx, ndesc, q->hw_qid, q->irq_idx, numa_node);

Probably should be _dbg(). We try not to spam the kernel log.

> +struct funeth_txq_stats {  /* per Tx queue SW counters */
> +	u64 tx_pkts;       /* # of Tx packets */
> +	u64 tx_bytes;      /* total bytes of Tx packets */
> +	u64 tx_cso;        /* # of packets with checksum offload */
> +	u64 tx_tso;        /* # of TSO super-packets */
> +	u64 tx_more;       /* # of DBs elided due to xmit_more */
> +	u64 tx_nstops;     /* # of times the queue has stopped */
> +	u64 tx_nrestarts;  /* # of times the queue has restarted */
> +	u64 tx_map_err;    /* # of packets dropped due to DMA mapping errors */
> +	u64 tx_len_err;    /* # of packets dropped due to unsupported length */
> +	u64 tx_xdp_full;   /* # of XDP packets that could not be enqueued */
> +#ifdef CONFIG_TLS_DEVICE
> +	u64 tx_tls_pkts;   /* # of Tx TLS packets offloaded to HW */
> +	u64 tx_tls_bytes;  /* Tx bytes of HW-handled TLS payload */
> +	u64 tx_tls_fallback; /* attempted Tx TLS offloads punted to SW */
> +	u64 tx_tls_drops;  /* attempted Tx TLS offloads dropped */
> +#endif

You might want to think about this, and kAPI stability. I assume it
implies a different number of statistics are returned by ethtool -S,
depending on how the driver is built. That could be surprising for
user space. It might be better to always have the statistics, and just
return 0 when TLS is not available.

       Andrew
