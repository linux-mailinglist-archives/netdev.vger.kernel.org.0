Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAD4483810
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 21:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiACUpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 15:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiACUpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 15:45:21 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7990C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 12:45:20 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id u22so57428640lju.7
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 12:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sZIF1bsrqBOw1Q6kp/L4cnQ/BpebWAQoJDuDoSSlybg=;
        b=UMEYTuYnaD3tOcCquNj+fPJeSH/7+DDYie4LTXV4X6+YWWIc/5VfQeRR5RYEhOq+w4
         /inJi/hQZQFO7UXJyKc9MwCVu59KYtp939buzHTf2ECsPO0cxB2u2/YG1kB2qHkfCVeH
         PtezueW+NvPLQx44ypTPpS4bQLR1FpRQ95Wig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sZIF1bsrqBOw1Q6kp/L4cnQ/BpebWAQoJDuDoSSlybg=;
        b=yHIEk4V1hn/j/wnL5DKZEwoga2rGMlilJHHhGc1k6dnR7W3K/6/yvDiyEkMos0PjPZ
         s1+n1TUC731BcEJY+TLMwrAkDYfzb8PwJWthhN7kWTnxiKFgzsH3hv3EhtkO5H8yJ2Nf
         aGomzp8kpTVVOUcsFB1Exx7nwiIJDD1qSLlHtmSxQMk4dwt7wkAvKS6Dxus6N7MLHG5p
         pC+b1WiFHTVfwFk86epm4/hWzmDoJQZxvz5ddYPNz1bfhfUjyYlWzZf5U/m1buNrIxLq
         YZqmwxR/BKPET5mpRu+RkYWCsOpUP7xzkAVPoocxBxFX+Mh90qoSwscwDyvaQUYCZFBY
         hrjA==
X-Gm-Message-State: AOAM531eM8VP13fBW7eNggtEOExmpuL5U2N+fyo3XmLdAKbwr3fF1ic5
        40IFt4YKmCAJHyd5LfryU4XYmKGyEa4Cen/1RME8rtOA5JhBEg==
X-Google-Smtp-Source: ABdhPJxVX+qFBw0naVZdCJWzSYdrKMF8AA+V1iYT8jvAAM0Q5jw4L724y8U5I6OEfDrlPS81UHpLD9CnrAtsfJnF9qs=
X-Received: by 2002:a05:651c:544:: with SMTP id q4mr23688284ljp.391.1641242718968;
 Mon, 03 Jan 2022 12:45:18 -0800 (PST)
MIME-Version: 1.0
References: <20211231090833.98977-1-dmichail@fungible.com> <20211231090833.98977-7-dmichail@fungible.com>
 <YdCWD97QfLzGq/mZ@lunn.ch>
In-Reply-To: <YdCWD97QfLzGq/mZ@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Mon, 3 Jan 2022 12:45:06 -0800
Message-ID: <CAOkoqZm6x1P5eBOcChzuOXHq2Y7ce3vLt3M6rfpZX9pbKbmdnw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 6/8] net/funeth: add the data path
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 1, 2022 at 9:57 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +++ b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
>
> > +/* See if a page is running low on refs we are holding and if so take more. */
> > +static inline void refresh_refs(struct funeth_rxbuf *buf)
> > +{
> > +     if (unlikely(buf->pg_refs < MIN_PAGE_REFS)) {
> > +             buf->pg_refs += EXTRA_PAGE_REFS;
> > +             page_ref_add(buf->page, EXTRA_PAGE_REFS);
> > +     }
> > +}
>
> No inline functions in C files please. Let the compiler decide. Please
> check for this in the whole driver.

Removed.

>
> > +/* A CQE contains a fixed completion structure along with optional metadata and
> > + * even packet data. Given the start address of a CQE return the start of the
> > + * contained fixed structure, which lies at the end.
> > + */
> > +static inline const void *cqe_to_info(const void *cqe)
> > +{
> > +     return cqe + FUNETH_CQE_INFO_OFFSET;
> > +}
> > +
> > +/* The inverse of cqe_to_info(). */
> > +static inline const void *info_to_cqe(const void *cqe_info)
> > +{
> > +     return cqe_info - FUNETH_CQE_INFO_OFFSET;
> > +}
>
> This looks pretty brittle. Can you define a struct cqe, so avoid all
> this arithmetic on void * pointers?

The top and bottom parts of a CQE are defined by FW (fun_eth_cqe and
fun_cqe_info) and there's a variable number of unused bytes in the middle
determined by the driver's choice of descriptor size. The driver would need
to define a struct with FUNETH_CQE_INFO_OFFSET - sizeof(fun_cqe_info)
space in the middle. Certainly doable but from a quick prototyping it
looks uglier to me.

This is for these queues that have a compile-time descriptor size
and known top part. The funcore library module does similar
info<->cqe conversions in a somewhat different form but
because it's a library it doesn't know the desc size at compile time
and wouldn't be able to define the structure. The two modules would
deviate in how they handle this while today their difference is one uses
a compile-time offset and the other a run-time one.


> > +static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
> > +                                unsigned int tls_len)
> > +{
> > +     unsigned int idx = q->prod_cnt & q->mask;
> > +     struct fun_eth_tx_req *req = fun_tx_desc_addr(q, idx);
>
> You need to move the assignment into the body to keep with reverse
> Christmas tree.

Done

> > +     if (txq_to_end(q, gle) == 0) {
> > +             gle = (struct fun_dataop_gl *)q->desc;
> > +             for ( ; i < ngle; i++, gle++)
> > +                     fun_dataop_gl_init(gle, 0, 0, lens[i], addrs[i]);
> > +     }
> > +
> > +#ifdef CONFIG_TLS_DEVICE
>
> If possible, use if (IS_ENABLED(TLS_DEVICE)), not #ifdef. It will give
> you better compile testing, if it works.

Done

> > +     if (unlikely(tls_len)) {
> > +             struct fun_eth_tls *tls = (struct fun_eth_tls *)gle;
> > +             struct fun_ktls_tx_ctx *tls_ctx;
> > +
> > +             req->len8 += FUNETH_TLS_SZ / 8;
> > +             req->flags = cpu_to_be16(FUN_ETH_TX_TLS);
> > +
> > +             tls_ctx = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
> > +             tls->tlsid = tls_ctx->tlsid;
> > +             tls_ctx->next_seq += tls_len;
> > +
> > +             u64_stats_update_begin(&q->syncp);
> > +             q->stats.tx_tls_bytes += tls_len;
> > +             q->stats.tx_tls_pkts += 1 + extra_pkts;
> > +             u64_stats_update_end(&q->syncp);
> > +     }
> > +#endif
>
> > +/* Create a Tx queue, allocating all the host and device resources needed. */
> > +struct funeth_txq *funeth_txq_create(struct net_device *dev, unsigned int qidx,
> > +                                  unsigned int ndesc, struct fun_irq *irq)
> > +{
> > +     struct funeth_priv *fp = netdev_priv(dev);
> > +     unsigned int ethid = fp->ethid_start + qidx;
> > +     int numa_node, err = -ENOMEM;
> > +     struct funeth_txq *q;
> > +     const char *qtype;
>
> ...
>
> > +     netif_info(fp, ifup, dev,
> > +                "%s queue %u, depth %u, HW qid %u, IRQ idx %u, node %d\n",
> > +                qtype, qidx, ndesc, q->hw_qid, q->irq_idx, numa_node);
>
> Probably should be _dbg(). We try not to spam the kernel log.

One needs to set msglvl in ethtool to get this. msglvl defaults to 0 so it
doesn't log if not requested.

> > +struct funeth_txq_stats {  /* per Tx queue SW counters */
> > +     u64 tx_pkts;       /* # of Tx packets */
> > +     u64 tx_bytes;      /* total bytes of Tx packets */
> > +     u64 tx_cso;        /* # of packets with checksum offload */
> > +     u64 tx_tso;        /* # of TSO super-packets */
> > +     u64 tx_more;       /* # of DBs elided due to xmit_more */
> > +     u64 tx_nstops;     /* # of times the queue has stopped */
> > +     u64 tx_nrestarts;  /* # of times the queue has restarted */
> > +     u64 tx_map_err;    /* # of packets dropped due to DMA mapping errors */
> > +     u64 tx_len_err;    /* # of packets dropped due to unsupported length */
> > +     u64 tx_xdp_full;   /* # of XDP packets that could not be enqueued */
> > +#ifdef CONFIG_TLS_DEVICE
> > +     u64 tx_tls_pkts;   /* # of Tx TLS packets offloaded to HW */
> > +     u64 tx_tls_bytes;  /* Tx bytes of HW-handled TLS payload */
> > +     u64 tx_tls_fallback; /* attempted Tx TLS offloads punted to SW */
> > +     u64 tx_tls_drops;  /* attempted Tx TLS offloads dropped */
> > +#endif
>
> You might want to think about this, and kAPI stability. I assume it
> implies a different number of statistics are returned by ethtool -S,
> depending on how the driver is built. That could be surprising for
> user space. It might be better to always have the statistics, and just
> return 0 when TLS is not available.

Yes, ethtool -S has them based on config. Perfectly happy to always
have them. Will change it.

>
>        Andrew
