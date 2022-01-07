Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB144871D3
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346078AbiAGEga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346079AbiAGEgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:36:23 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92980C0611FD
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 20:36:23 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id g11-20020a17090a7d0b00b001b2c12c7273so5784109pjl.0
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 20:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=l9iQFGWPoY1/o0gC8wgLtxO2cPA9cQ2XyAMsAeAYwUo=;
        b=U2L4lNVoPX/9LQlXab30DDsM8LNSSdTpakcMVuWEMCVLMifxKEgif2ozDUM2kmsjoZ
         lHu5xy0Ym9v/7068LcX8IVOJVoZZYazrB5DcOD1YceJ2fS76u36XMO8MpcxYQqG34nCI
         GgmA1ARYRGu24Hl+d515xf/Gde/Thjjk8Q48o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l9iQFGWPoY1/o0gC8wgLtxO2cPA9cQ2XyAMsAeAYwUo=;
        b=0zy5DLUMeBzG0AJHEodqYmwQnB/zB8Ki8VEk73+s22nWRWvYo+ciUr7b0hb2xjzIkN
         HjvgClQExhnO5Utlq0ItsHedDlv1zRP9+uAX1L9cWJrMzXtFQczehCGDkr8Aw5LLflQX
         zK6CMYqP1dg8mYcLz456iOMwnnyZIVSgp4kEXSFH7LgQVfkOIDwtfJeTBYfTLQmSXtdx
         aWNcq7UFzx6LML1c8kIKiJxYxudt7nym3diEEc7V+h0oREZ2FZb85Ga10NhcmyPVrhfi
         HfGZpF0M14FQHZBBJZ8xVVpvpWAfp0hJ9qPCZl3KihXBwGLkl9575QGwyku8KTA+kpC0
         cYfg==
X-Gm-Message-State: AOAM532cw0xU2hDqXyrYzl8UTeS/W7kiADIDtYIRlZl+YJruoJgignBf
        UL/nI/PmWXDXsnXFqUP7/6FE/kF3zb90RQ==
X-Google-Smtp-Source: ABdhPJww0saJIXMPH2+CjzeSv9VfGS/dezifeKD/uSpCGfRNc9NZMcLa+d5AxC80m9S2zDqtKOCgwA==
X-Received: by 2002:a17:902:b591:b0:149:66d6:7589 with SMTP id a17-20020a170902b59100b0014966d67589mr55289338pls.24.1641530182471;
        Thu, 06 Jan 2022 20:36:22 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id p12sm4297877pfo.95.2022.01.06.20.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 20:36:21 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v5 6/8] net/funeth: add the data path
Date:   Thu,  6 Jan 2022 20:36:10 -0800
Message-Id: <20220107043612.21342-7-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107043612.21342-1-dmichail@fungible.com>
References: <20220107043612.21342-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the driver's data path. Tx handles skbs, XDP, and kTLS, Rx has skbs
and XDP. Also included are Rx and Tx queue creation/tear-down and
tracing.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../net/ethernet/fungible/funeth/funeth_rx.c  | 791 ++++++++++++++++++
 .../ethernet/fungible/funeth/funeth_trace.h   | 117 +++
 .../net/ethernet/fungible/funeth/funeth_tx.c  | 745 +++++++++++++++++
 .../ethernet/fungible/funeth/funeth_txrx.h    | 245 ++++++
 4 files changed, 1898 insertions(+)
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_rx.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_trace.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_tx.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_txrx.h

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_rx.c b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
new file mode 100644
index 000000000000..e5307122708c
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
@@ -0,0 +1,791 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+#include <linux/bpf_trace.h>
+#include <linux/dma-mapping.h>
+#include <linux/etherdevice.h>
+#include <linux/filter.h>
+#include <linux/irq.h>
+#include <linux/pci.h>
+#include <linux/skbuff.h>
+#include "funeth_txrx.h"
+#include "funeth.h"
+#include "fun_queue.h"
+
+#define CREATE_TRACE_POINTS
+#include "funeth_trace.h"
+
+/* Given the device's max supported MTU and pages of at least 4KB a packet can
+ * be scattered into at most 4 buffers.
+ */
+#define RX_MAX_FRAGS 4
+
+/* Per packet headroom in non-XDP mode. Present only for 1-frag packets. */
+#define FUN_RX_HEADROOM (NET_SKB_PAD + NET_IP_ALIGN)
+
+/* We try to reuse pages for our buffers. To avoid frequent page ref writes we
+ * take EXTRA_PAGE_REFS references at once and then hand them out one per packet
+ * occupying the buffer.
+ */
+#define EXTRA_PAGE_REFS 1000000
+#define MIN_PAGE_REFS 1000
+
+enum {
+	FUN_XDP_FLUSH_REDIR = 1,
+	FUN_XDP_FLUSH_TX = 2,
+};
+
+/* See if a page is running low on refs we are holding and if so take more. */
+static void refresh_refs(struct funeth_rxbuf *buf)
+{
+	if (unlikely(buf->pg_refs < MIN_PAGE_REFS)) {
+		buf->pg_refs += EXTRA_PAGE_REFS;
+		page_ref_add(buf->page, EXTRA_PAGE_REFS);
+	}
+}
+
+/* Offer a buffer to the Rx buffer cache. The cache will hold the buffer if its
+ * page is worth retaining and there's room for it. Otherwise the page is
+ * unmapped and our references released.
+ */
+static void cache_offer(struct funeth_rxq *q, const struct funeth_rxbuf *buf)
+{
+	struct funeth_rx_cache *c = &q->cache;
+
+	if (c->prod_cnt - c->cons_cnt <= c->mask && buf->node == numa_mem_id()) {
+		c->bufs[c->prod_cnt & c->mask] = *buf;
+		c->prod_cnt++;
+	} else {
+		dma_unmap_page_attrs(q->dma_dev, buf->dma_addr, PAGE_SIZE,
+				     DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
+		__page_frag_cache_drain(buf->page, buf->pg_refs);
+	}
+}
+
+/* Get a page from the Rx buffer cache. We only consider the next available
+ * page and return it if we own all its references.
+ */
+static bool cache_get(struct funeth_rxq *q, struct funeth_rxbuf *rb)
+{
+	struct funeth_rx_cache *c = &q->cache;
+	struct funeth_rxbuf *buf;
+
+	if (c->prod_cnt == c->cons_cnt)
+		return false;             /* empty cache */
+
+	buf = &c->bufs[c->cons_cnt & c->mask];
+	if (page_ref_count(buf->page) == buf->pg_refs) {
+		dma_sync_single_for_device(q->dma_dev, buf->dma_addr,
+					   PAGE_SIZE, DMA_FROM_DEVICE);
+		*rb = *buf;
+		buf->page = NULL;
+		refresh_refs(rb);
+		c->cons_cnt++;
+		return true;
+	}
+
+	/* Page can't be reused. If the cache is full drop this page. */
+	if (c->prod_cnt - c->cons_cnt > c->mask) {
+		dma_unmap_page_attrs(q->dma_dev, buf->dma_addr, PAGE_SIZE,
+				     DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
+		__page_frag_cache_drain(buf->page, buf->pg_refs);
+		buf->page = NULL;
+		c->cons_cnt++;
+	}
+	return false;
+}
+
+/* Allocate and DMA-map a page for receive. */
+static int funeth_alloc_page(struct funeth_rxq *q, struct funeth_rxbuf *rb,
+			     int node, gfp_t gfp)
+{
+	struct page *p;
+
+	if (cache_get(q, rb))
+		return 0;
+
+	p = __alloc_pages_node(node, gfp | __GFP_NOWARN, 0);
+	if (unlikely(!p))
+		return -ENOMEM;
+
+	rb->dma_addr = dma_map_page(q->dma_dev, p, 0, PAGE_SIZE,
+				    DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(q->dma_dev, rb->dma_addr))) {
+		FUN_QSTAT_INC(q, rx_map_err);
+		__free_page(p);
+		return -ENOMEM;
+	}
+
+	FUN_QSTAT_INC(q, rx_page_alloc);
+
+	rb->page = p;
+	rb->pg_refs = 1;
+	refresh_refs(rb);
+	rb->node = page_is_pfmemalloc(p) ? -1 : page_to_nid(p);
+	return 0;
+}
+
+static void funeth_free_page(struct funeth_rxq *q, struct funeth_rxbuf *rb)
+{
+	if (rb->page) {
+		dma_unmap_page(q->dma_dev, rb->dma_addr, PAGE_SIZE,
+			       DMA_FROM_DEVICE);
+		__page_frag_cache_drain(rb->page, rb->pg_refs);
+		rb->page = NULL;
+	}
+}
+
+/* Run the XDP program assigned to an Rx queue.
+ * Return %NULL if the buffer is consumed, or the virtual address of the packet
+ * to turn into an skb.
+ */
+static void *fun_run_xdp(struct funeth_rxq *q, skb_frag_t *frags, void *buf_va,
+			 int ref_ok, struct funeth_txq *xdp_q)
+{
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	u32 act;
+
+	/* VA includes the headroom, frag size includes headroom + tailroom */
+	xdp_init_buff(&xdp, ALIGN(skb_frag_size(frags), FUN_EPRQ_PKT_ALIGN),
+		      &q->xdp_rxq);
+	xdp_prepare_buff(&xdp, buf_va, FUN_XDP_HEADROOM, skb_frag_size(frags) -
+			 (FUN_RX_TAILROOM + FUN_XDP_HEADROOM), false);
+
+	xdp_prog = READ_ONCE(q->xdp_prog);
+	act = bpf_prog_run_xdp(xdp_prog, &xdp);
+
+	switch (act) {
+	case XDP_PASS:
+		/* remove headroom, which may not be FUN_XDP_HEADROOM now */
+		skb_frag_size_set(frags, xdp.data_end - xdp.data);
+		skb_frag_off_add(frags, xdp.data - xdp.data_hard_start);
+		goto pass;
+	case XDP_TX:
+		if (unlikely(!ref_ok))
+			goto pass;
+		if (!fun_xdp_tx(xdp_q, xdp.data, xdp.data_end - xdp.data))
+			goto xdp_error;
+		FUN_QSTAT_INC(q, xdp_tx);
+		q->xdp_flush |= FUN_XDP_FLUSH_TX;
+		break;
+	case XDP_REDIRECT:
+		if (unlikely(!ref_ok))
+			goto pass;
+		if (unlikely(xdp_do_redirect(q->netdev, &xdp, xdp_prog)))
+			goto xdp_error;
+		FUN_QSTAT_INC(q, xdp_redir);
+		q->xdp_flush |= FUN_XDP_FLUSH_REDIR;
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(q->netdev, xdp_prog, act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(q->netdev, xdp_prog, act);
+xdp_error:
+		q->cur_buf->pg_refs++; /* return frags' page reference */
+		FUN_QSTAT_INC(q, xdp_err);
+		break;
+	case XDP_DROP:
+		q->cur_buf->pg_refs++;
+		FUN_QSTAT_INC(q, xdp_drops);
+		break;
+	}
+	return NULL;
+
+pass:
+	return xdp.data;
+}
+
+/* A CQE contains a fixed completion structure along with optional metadata and
+ * even packet data. Given the start address of a CQE return the start of the
+ * contained fixed structure, which lies at the end.
+ */
+static const void *cqe_to_info(const void *cqe)
+{
+	return cqe + FUNETH_CQE_INFO_OFFSET;
+}
+
+/* The inverse of cqe_to_info(). */
+static const void *info_to_cqe(const void *cqe_info)
+{
+	return cqe_info - FUNETH_CQE_INFO_OFFSET;
+}
+
+/* Return the type of hash provided by the device based on the L3 and L4
+ * protocols it parsed for the packet.
+ */
+static enum pkt_hash_types cqe_to_pkt_hash_type(u16 pkt_parse)
+{
+	static const enum pkt_hash_types htype_map[] = {
+		PKT_HASH_TYPE_NONE, PKT_HASH_TYPE_L3,
+		PKT_HASH_TYPE_NONE, PKT_HASH_TYPE_L4,
+		PKT_HASH_TYPE_NONE, PKT_HASH_TYPE_L3,
+		PKT_HASH_TYPE_NONE, PKT_HASH_TYPE_L3
+	};
+	u16 key;
+
+	/* Build the key from the TCP/UDP and IP/IPv6 bits */
+	key = ((pkt_parse >> FUN_ETH_RX_CV_OL4_PROT_S) & 6) |
+	      ((pkt_parse >> (FUN_ETH_RX_CV_OL3_PROT_S + 1)) & 1);
+
+	return htype_map[key];
+}
+
+/* Each received packet can be scattered across several Rx buffers or can
+ * share a buffer with previously received packets depending on the buffer
+ * and packet sizes and the room available in the most recently used buffer.
+ *
+ * The rules are:
+ * - If the buffer at the head of an RQ has not been used it gets (part of) the
+ *   next incoming packet.
+ * - Otherwise, if the packet fully fits in the buffer's remaining space the
+ *   packet is written there.
+ * - Otherwise, the packet goes into the next Rx buffer.
+ *
+ * This function returns the Rx buffer for a packet or fragment thereof of the
+ * given length. If it isn't @buf it either recycles or frees that buffer
+ * before advancing the queue to the next buffer.
+ *
+ * If called repeatedly with the remaining length of a packet it will walk
+ * through all the buffers containing the packet.
+ */
+static struct funeth_rxbuf *
+get_buf(struct funeth_rxq *q, struct funeth_rxbuf *buf, unsigned int len)
+{
+	if (q->buf_offset + len <= PAGE_SIZE || !q->buf_offset)
+		return buf;            /* @buf holds (part of) the packet */
+
+	/* The packet occupies part of the next buffer. Move there after
+	 * replenishing the current buffer slot either with the spare page or
+	 * by reusing the slot's existing page. Note that if a spare page isn't
+	 * available and the current packet occupies @buf it is a multi-frag
+	 * packet that will be dropped leaving @buf available for reuse.
+	 */
+	if ((page_ref_count(buf->page) == buf->pg_refs &&
+	     buf->node == numa_mem_id()) || !q->spare_buf.page) {
+		dma_sync_single_for_device(q->dma_dev, buf->dma_addr,
+					   PAGE_SIZE, DMA_FROM_DEVICE);
+		refresh_refs(buf);
+	} else {
+		cache_offer(q, buf);
+		*buf = q->spare_buf;
+		q->spare_buf.page = NULL;
+		q->rqes[q->rq_cons & q->rq_mask] =
+			FUN_EPRQ_RQBUF_INIT(buf->dma_addr);
+	}
+	q->buf_offset = 0;
+	q->rq_cons++;
+	return &q->bufs[q->rq_cons & q->rq_mask];
+}
+
+/* Gather the page fragments making up the first Rx packet on @q. Its total
+ * length @tot_len includes optional head- and tail-rooms.
+ *
+ * Return 0 if the device retains ownership of at least some of the pages.
+ * In this case the caller may only copy the packet.
+ *
+ * A non-zero return value gives the caller permission to use references to the
+ * pages, e.g., attach them to skbs. Additionally, if the value is <0 at least
+ * one of the pages is PF_MEMALLOC.
+ *
+ * Regardless of outcome the caller is granted a reference to each of the pages.
+ */
+static int fun_gather_pkt(struct funeth_rxq *q, unsigned int tot_len,
+			  skb_frag_t *frags)
+{
+	struct funeth_rxbuf *buf = q->cur_buf;
+	unsigned int frag_len;
+	int ref_ok = 1;
+
+	for (;;) {
+		buf = get_buf(q, buf, tot_len);
+
+		/* We always keep the RQ full of buffers so before we can give
+		 * one of our pages to the stack we require that we can obtain
+		 * a replacement page. If we can't the packet will either be
+		 * copied or dropped so we can retain ownership of the page and
+		 * reuse it.
+		 */
+		if (!q->spare_buf.page &&
+		    funeth_alloc_page(q, &q->spare_buf, numa_mem_id(),
+				      GFP_ATOMIC | __GFP_MEMALLOC))
+			ref_ok = 0;
+
+		frag_len = min_t(unsigned int, tot_len,
+				 PAGE_SIZE - q->buf_offset);
+		dma_sync_single_for_cpu(q->dma_dev,
+					buf->dma_addr + q->buf_offset,
+					frag_len, DMA_FROM_DEVICE);
+		buf->pg_refs--;
+		if (ref_ok)
+			ref_ok |= buf->node;
+
+		__skb_frag_set_page(frags, buf->page);
+		skb_frag_off_set(frags, q->buf_offset);
+		skb_frag_size_set(frags++, frag_len);
+
+		tot_len -= frag_len;
+		if (!tot_len)
+			break;
+
+		q->buf_offset = PAGE_SIZE;
+	}
+	q->buf_offset = ALIGN(q->buf_offset + frag_len, FUN_EPRQ_PKT_ALIGN);
+	q->cur_buf = buf;
+	return ref_ok;
+}
+
+static bool rx_hwtstamp_enabled(const struct net_device *dev)
+{
+	const struct funeth_priv *d = netdev_priv(dev);
+
+	return d->hwtstamp_cfg.rx_filter == HWTSTAMP_FILTER_ALL;
+}
+
+/* Advance the CQ pointers and phase tag to the next CQE. */
+static void advance_cq(struct funeth_rxq *q)
+{
+	if (unlikely(q->cq_head == q->cq_mask)) {
+		q->cq_head = 0;
+		q->phase ^= 1;
+		q->next_cqe_info = cqe_to_info(q->cqes);
+	} else {
+		q->cq_head++;
+		q->next_cqe_info += FUNETH_CQE_SIZE;
+	}
+	prefetch(q->next_cqe_info);
+}
+
+/* Process the packet represented by the head CQE of @q. Gather the packet's
+ * fragments, run it through the optional XDP program, and if needed construct
+ * an skb and pass it to the stack.
+ */
+static void fun_handle_cqe_pkt(struct funeth_rxq *q, struct funeth_txq *xdp_q)
+{
+	const struct fun_eth_cqe *rxreq = info_to_cqe(q->next_cqe_info);
+	unsigned int i, tot_len, pkt_len = be32_to_cpu(rxreq->pkt_len);
+	struct net_device *ndev = q->netdev;
+	skb_frag_t frags[RX_MAX_FRAGS];
+	struct skb_shared_info *si;
+	unsigned int headroom;
+	gro_result_t gro_res;
+	struct sk_buff *skb;
+	int ref_ok;
+	void *va;
+	u16 cv;
+
+	u64_stats_update_begin(&q->syncp);
+	q->stats.rx_pkts++;
+	q->stats.rx_bytes += pkt_len;
+	u64_stats_update_end(&q->syncp);
+
+	advance_cq(q);
+
+	/* account for head- and tail-room, present only for 1-buffer packets */
+	tot_len = pkt_len;
+	headroom = be16_to_cpu(rxreq->headroom);
+	if (likely(headroom))
+		tot_len += FUN_RX_TAILROOM + headroom;
+
+	ref_ok = fun_gather_pkt(q, tot_len, frags);
+	va = skb_frag_address(frags);
+	if (xdp_q && headroom == FUN_XDP_HEADROOM) {
+		va = fun_run_xdp(q, frags, va, ref_ok, xdp_q);
+		if (!va)
+			return;
+		headroom = 0;   /* XDP_PASS trims it */
+	}
+	if (unlikely(!ref_ok))
+		goto no_mem;
+
+	if (likely(headroom)) {
+		/* headroom is either FUN_RX_HEADROOM or FUN_XDP_HEADROOM */
+		prefetch(va + headroom);
+		skb = build_skb(va, ALIGN(tot_len, FUN_EPRQ_PKT_ALIGN));
+		if (unlikely(!skb))
+			goto no_mem;
+
+		skb_reserve(skb, headroom);
+		__skb_put(skb, pkt_len);
+		skb->protocol = eth_type_trans(skb, ndev);
+	} else {
+		prefetch(va);
+		skb = napi_get_frags(q->napi);
+		if (unlikely(!skb))
+			goto no_mem;
+
+		if (ref_ok < 0)
+			skb->pfmemalloc = 1;
+
+		si = skb_shinfo(skb);
+		si->nr_frags = rxreq->nsgl;
+		for (i = 0; i < si->nr_frags; i++)
+			si->frags[i] = frags[i];
+
+		skb->len = pkt_len;
+		skb->data_len = pkt_len;
+		skb->truesize += round_up(pkt_len, FUN_EPRQ_PKT_ALIGN);
+	}
+
+	skb_record_rx_queue(skb, q->qidx);
+	cv = be16_to_cpu(rxreq->pkt_cv);
+	if (likely((q->netdev->features & NETIF_F_RXHASH) && rxreq->hash))
+		skb_set_hash(skb, be32_to_cpu(rxreq->hash),
+			     cqe_to_pkt_hash_type(cv));
+	if (likely((q->netdev->features & NETIF_F_RXCSUM) && rxreq->csum)) {
+		FUN_QSTAT_INC(q, rx_cso);
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		skb->csum_level = be16_to_cpu(rxreq->csum) - 1;
+	}
+	if (unlikely(rx_hwtstamp_enabled(q->netdev)))
+		skb_hwtstamps(skb)->hwtstamp = be64_to_cpu(rxreq->timestamp);
+
+	trace_funeth_rx(q, rxreq->nsgl, pkt_len, skb->hash, cv);
+
+	gro_res = skb->data_len ? napi_gro_frags(q->napi) :
+				  napi_gro_receive(q->napi, skb);
+	if (gro_res == GRO_MERGED || gro_res == GRO_MERGED_FREE)
+		FUN_QSTAT_INC(q, gro_merged);
+	else if (gro_res == GRO_HELD)
+		FUN_QSTAT_INC(q, gro_pkts);
+	return;
+
+no_mem:
+	FUN_QSTAT_INC(q, rx_mem_drops);
+
+	/* Release the references we've been granted for the frag pages.
+	 * We return the ref of the last frag and free the rest.
+	 */
+	q->cur_buf->pg_refs++;
+	for (i = 0; i < rxreq->nsgl - 1; i++)
+		__free_page(skb_frag_page(frags + i));
+}
+
+/* Return 0 if the phase tag of the CQE at the CQ's head matches expectations
+ * indicating the CQE is new.
+ */
+static u16 cqe_phase_mismatch(const struct fun_cqe_info *ci, u16 phase)
+{
+	u16 sf_p = be16_to_cpu(ci->sf_p);
+
+	return (sf_p & 1) ^ phase;
+}
+
+/* Walk through a CQ identifying and processing fresh CQEs up to the given
+ * budget. Return the remaining budget.
+ */
+static int fun_process_cqes(struct funeth_rxq *q, int budget)
+{
+	struct funeth_priv *fp = netdev_priv(q->netdev);
+	struct funeth_txq **xdpqs, *xdp_q = NULL;
+
+	xdpqs = rcu_dereference_bh(fp->xdpqs);
+	if (xdpqs)
+		xdp_q = xdpqs[smp_processor_id()];
+
+	while (budget && !cqe_phase_mismatch(q->next_cqe_info, q->phase)) {
+		/* access other descriptor fields after the phase check */
+		dma_rmb();
+
+		fun_handle_cqe_pkt(q, xdp_q);
+		budget--;
+	}
+
+	if (unlikely(q->xdp_flush)) {
+		if (q->xdp_flush & FUN_XDP_FLUSH_TX)
+			fun_txq_wr_db(xdp_q);
+		if (q->xdp_flush & FUN_XDP_FLUSH_REDIR)
+			xdp_do_flush();
+		q->xdp_flush = 0;
+	}
+
+	return budget;
+}
+
+/* NAPI handler for Rx queues. Calls the CQE processing loop and writes RQ/CQ
+ * doorbells as needed.
+ */
+int fun_rxq_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct fun_irq *irq = container_of(napi, struct fun_irq, napi);
+	struct funeth_rxq *q = irq->rxq;
+	int work_done = budget - fun_process_cqes(q, budget);
+	u32 cq_db_val = q->cq_head;
+
+	if (unlikely(work_done >= budget))
+		FUN_QSTAT_INC(q, rx_budget);
+	else if (napi_complete_done(napi, work_done))
+		cq_db_val |= q->irq_db_val;
+
+	/* check whether to post new Rx buffers */
+	if (q->rq_cons - q->rq_cons_db >= q->rq_db_thres) {
+		u64_stats_update_begin(&q->syncp);
+		q->stats.rx_bufs += q->rq_cons - q->rq_cons_db;
+		u64_stats_update_end(&q->syncp);
+		q->rq_cons_db = q->rq_cons;
+		writel((q->rq_cons - 1) & q->rq_mask, q->rq_db);
+	}
+
+	writel(cq_db_val, q->cq_db);
+	return work_done;
+}
+
+/* Free the Rx buffers of an Rx queue. */
+static void fun_rxq_free_bufs(struct funeth_rxq *q)
+{
+	struct funeth_rxbuf *b = q->bufs;
+	unsigned int i;
+
+	for (i = 0; i <= q->rq_mask; i++, b++)
+		funeth_free_page(q, b);
+
+	funeth_free_page(q, &q->spare_buf);
+	q->cur_buf = NULL;
+}
+
+/* Initially provision an Rx queue with Rx buffers. */
+static int fun_rxq_alloc_bufs(struct funeth_rxq *q, int node)
+{
+	struct funeth_rxbuf *b = q->bufs;
+	unsigned int i;
+
+	for (i = 0; i <= q->rq_mask; i++, b++) {
+		if (funeth_alloc_page(q, b, node, GFP_KERNEL)) {
+			fun_rxq_free_bufs(q);
+			return -ENOMEM;
+		}
+		q->rqes[i] = FUN_EPRQ_RQBUF_INIT(b->dma_addr);
+	}
+	q->cur_buf = q->bufs;
+	return 0;
+}
+
+/* Initialize a used-buffer cache of the given depth. */
+static int fun_rxq_init_cache(struct funeth_rx_cache *c, unsigned int depth,
+			      int node)
+{
+	c->mask = depth - 1;
+	c->bufs = kvzalloc_node(depth * sizeof(*c->bufs), GFP_KERNEL, node);
+	return c->bufs ? 0 : -ENOMEM;
+}
+
+/* Deallocate an Rx queue's used-buffer cache and its contents. */
+static void fun_rxq_free_cache(struct funeth_rxq *q)
+{
+	struct funeth_rxbuf *b = q->cache.bufs;
+	unsigned int i;
+
+	for (i = 0; i <= q->cache.mask; i++, b++)
+		funeth_free_page(q, b);
+
+	kvfree(q->cache.bufs);
+	q->cache.bufs = NULL;
+}
+
+int fun_rxq_set_bpf(struct funeth_rxq *q, struct bpf_prog *prog)
+{
+	struct funeth_priv *fp = netdev_priv(q->netdev);
+	struct fun_admin_epcq_req cmd;
+	unsigned int headroom;
+	int err;
+
+	headroom = prog ? FUN_XDP_HEADROOM : FUN_RX_HEADROOM;
+	if (headroom != q->headroom) {
+		cmd.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_EPCQ,
+							sizeof(cmd));
+		cmd.u.modify =
+			FUN_ADMIN_EPCQ_MODIFY_REQ_INIT(FUN_ADMIN_SUBOP_MODIFY,
+						       0, q->hw_cqid, headroom);
+		err = fun_submit_admin_sync_cmd(fp->fdev, &cmd.common, NULL, 0,
+						0);
+		if (err)
+			return err;
+		q->headroom = headroom;
+	}
+
+	WRITE_ONCE(q->xdp_prog, prog);
+	return 0;
+}
+
+/* Create an Rx queue, allocating the host memory it needs. */
+static struct funeth_rxq *funeth_rxq_create_sw(struct net_device *dev,
+					       unsigned int qidx,
+					       unsigned int ncqe,
+					       unsigned int nrqe,
+					       struct fun_irq *irq)
+{
+	struct funeth_priv *fp = netdev_priv(dev);
+	struct funeth_rxq *q;
+	int err = -ENOMEM;
+	int numa_node;
+
+	numa_node = fun_irq_node(irq);
+	q = kzalloc_node(sizeof(*q), GFP_KERNEL, numa_node);
+	if (!q)
+		goto err;
+
+	q->netdev = dev;
+	q->napi = &irq->napi;
+	q->dma_dev = &fp->pdev->dev;
+	q->cq_mask = ncqe - 1;
+	q->rq_mask = nrqe - 1;
+	q->qidx = qidx;
+	q->numa_node = numa_node;
+
+	q->rqes = fun_alloc_ring_mem(q->dma_dev, nrqe, sizeof(*q->rqes),
+				     sizeof(*q->bufs), false, numa_node,
+				     &q->rq_dma_addr, (void **)&q->bufs, NULL);
+	if (!q->rqes)
+		goto free_q;
+
+	q->cqes = fun_alloc_ring_mem(q->dma_dev, ncqe, FUNETH_CQE_SIZE, 0,
+				     false, numa_node, &q->cq_dma_addr, NULL,
+				     NULL);
+	if (!q->cqes)
+		goto free_rqes;
+
+	err = fun_rxq_init_cache(&q->cache, nrqe, numa_node);
+	if (err)
+		goto free_cqes;
+
+	err = fun_rxq_alloc_bufs(q, numa_node);
+	if (err)
+		goto free_cache;
+
+	err = xdp_rxq_info_reg(&q->xdp_rxq, dev, qidx, irq->napi.napi_id);
+	if (err)
+		goto free_bufs;
+
+	err = xdp_rxq_info_reg_mem_model(&q->xdp_rxq, MEM_TYPE_PAGE_SHARED,
+					 NULL);
+	if (err)
+		goto xdp_unreg;
+
+	q->phase = 1;
+	q->irq_idx = irq->irq_idx;
+	q->rq_db_thres = nrqe / 4;
+	q->next_cqe_info = cqe_to_info(q->cqes);
+	q->stats.rx_bufs = q->rq_mask;
+	u64_stats_init(&q->syncp);
+
+	return q;
+
+xdp_unreg:
+	xdp_rxq_info_unreg(&q->xdp_rxq);
+free_bufs:
+	fun_rxq_free_bufs(q);
+free_cache:
+	fun_rxq_free_cache(q);
+free_cqes:
+	dma_free_coherent(q->dma_dev, ncqe * FUNETH_CQE_SIZE, q->cqes,
+			  q->cq_dma_addr);
+free_rqes:
+	fun_free_ring_mem(q->dma_dev, nrqe, sizeof(*q->rqes), false, q->rqes,
+			  q->rq_dma_addr, q->bufs);
+free_q:
+	kfree(q);
+err:
+	netdev_err(dev, "Unable to allocate memory for Rx queue %u\n", qidx);
+	return ERR_PTR(err);
+}
+
+static void funeth_rxq_free_sw(struct funeth_rxq *q)
+{
+	struct funeth_priv *fp = netdev_priv(q->netdev);
+
+	fun_rxq_free_cache(q);
+	fun_rxq_free_bufs(q);
+	xdp_rxq_info_unreg(&q->xdp_rxq);
+	fun_free_ring_mem(q->dma_dev, q->rq_mask + 1, sizeof(*q->rqes), false,
+			  q->rqes, q->rq_dma_addr, q->bufs);
+	dma_free_coherent(q->dma_dev, (q->cq_mask + 1) * FUNETH_CQE_SIZE,
+			  q->cqes, q->cq_dma_addr);
+
+	/* Before freeing the queue transfer key counters to the device. */
+	fp->rx_packets += q->stats.rx_pkts;
+	fp->rx_bytes   += q->stats.rx_bytes;
+	fp->rx_dropped += q->stats.rx_map_err + q->stats.rx_mem_drops;
+
+	kfree(q);
+}
+
+/* Create an Rx queue's resources on the device. */
+static int funeth_rxq_create_dev(struct funeth_rxq *q)
+{
+	struct funeth_priv *fp = netdev_priv(q->netdev);
+	unsigned int ncqe = q->cq_mask + 1;
+	unsigned int nrqe = q->rq_mask + 1;
+	int err;
+
+	q->xdp_prog = fp->xdp_prog;
+	q->headroom = fp->xdp_prog ? FUN_XDP_HEADROOM : FUN_RX_HEADROOM;
+
+	err = fun_sq_create(fp->fdev, FUN_ADMIN_RES_CREATE_FLAG_ALLOCATOR |
+			    FUN_ADMIN_EPSQ_CREATE_FLAG_RQ, 0,
+			    FUN_HCI_ID_INVALID, 0, nrqe, q->rq_dma_addr, 0, 0,
+			    0, 0, fp->fdev->kern_end_qid, PAGE_SHIFT,
+			    &q->hw_sqid, &q->rq_db);
+	if (err)
+		goto out;
+
+	err = fun_cq_create(fp->fdev, FUN_ADMIN_RES_CREATE_FLAG_ALLOCATOR |
+			    FUN_ADMIN_EPCQ_CREATE_FLAG_RQ, 0,
+			    q->hw_sqid, ilog2(FUNETH_CQE_SIZE), ncqe,
+			    q->cq_dma_addr, q->headroom, FUN_RX_TAILROOM, 0, 0,
+			    q->irq_idx, 0, fp->fdev->kern_end_qid, &q->hw_cqid,
+			    &q->cq_db);
+	if (err)
+		goto free_rq;
+
+	writel(q->rq_mask, q->rq_db);
+
+	netif_info(fp, ifup, q->netdev,
+		   "Rx queue %u, depth %u/%u, HW qid %u/%u, IRQ idx %u, node %d, headroom %u\n",
+		   q->qidx, ncqe, nrqe, q->hw_cqid, q->hw_sqid, q->irq_idx,
+		   q->numa_node, q->headroom);
+	return 0;
+
+free_rq:
+	fun_destroy_sq(fp->fdev, q->hw_sqid);
+out:
+	netdev_err(q->netdev,
+		   "Failed to create Rx queue %u on device, error %d\n",
+		   q->qidx, err);
+	return err;
+}
+
+/* Create an Rx queue, allocating all the host and device resources needed. */
+struct funeth_rxq *funeth_rxq_create(struct net_device *dev, unsigned int qidx,
+				     unsigned int ncqe, unsigned int nrqe,
+				     struct fun_irq *irq)
+{
+	struct funeth_rxq *q;
+	int err;
+
+	q = funeth_rxq_create_sw(dev, qidx, ncqe, nrqe, irq);
+	if (IS_ERR(q))
+		return q;
+
+	err = funeth_rxq_create_dev(q);
+	if (err) {
+		funeth_rxq_free_sw(q);
+		return ERR_PTR(err);
+	}
+
+	irq->rxq = q;
+	return q;
+}
+
+/* Destroy and free an Rx queue. */
+void funeth_rxq_free(struct funeth_rxq *q)
+{
+	struct funeth_priv *fp = netdev_priv(q->netdev);
+
+	fun_destroy_sq(fp->fdev, q->hw_sqid);
+	fun_destroy_cq(fp->fdev, q->hw_cqid);
+
+	netif_info(fp, ifdown, q->netdev,
+		   "Freeing Rx queue %u (id %u/%u), IRQ %u\n",
+		   q->qidx, q->hw_cqid, q->hw_sqid, q->irq_idx);
+	funeth_rxq_free_sw(q);
+}
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_trace.h b/drivers/net/ethernet/fungible/funeth/funeth_trace.h
new file mode 100644
index 000000000000..9e58dfec19d5
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_trace.h
@@ -0,0 +1,117 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM funeth
+
+#if !defined(_TRACE_FUNETH_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FUNETH_H
+
+#include <linux/tracepoint.h>
+
+#include "funeth_txrx.h"
+
+TRACE_EVENT(funeth_tx,
+
+	TP_PROTO(const struct funeth_txq *txq,
+		 u32 len,
+		 u32 sqe_idx,
+		 u32 ngle),
+
+	TP_ARGS(txq, len, sqe_idx, ngle),
+
+	TP_STRUCT__entry(
+		__field(u32, qidx)
+		__field(u32, len)
+		__field(u32, sqe_idx)
+		__field(u32, ngle)
+		__string(devname, txq->netdev->name)
+	),
+
+	TP_fast_assign(
+		__entry->qidx = txq->qidx;
+		__entry->len = len;
+		__entry->sqe_idx = sqe_idx;
+		__entry->ngle = ngle;
+		__assign_str(devname, txq->netdev->name);
+	),
+
+	TP_printk("%s: Txq %u, SQE idx %u, len %u, num GLEs %u",
+		  __get_str(devname), __entry->qidx, __entry->sqe_idx,
+		  __entry->len, __entry->ngle)
+);
+
+TRACE_EVENT(funeth_tx_free,
+
+	TP_PROTO(const struct funeth_txq *txq,
+		 u32 sqe_idx,
+		 u32 num_sqes,
+		 u32 hw_head),
+
+	TP_ARGS(txq, sqe_idx, num_sqes, hw_head),
+
+	TP_STRUCT__entry(
+		__field(u32, qidx)
+		__field(u32, sqe_idx)
+		__field(u32, num_sqes)
+		__field(u32, hw_head)
+		__string(devname, txq->netdev->name)
+	),
+
+	TP_fast_assign(
+		__entry->qidx = txq->qidx;
+		__entry->sqe_idx = sqe_idx;
+		__entry->num_sqes = num_sqes;
+		__entry->hw_head = hw_head;
+		__assign_str(devname, txq->netdev->name);
+	),
+
+	TP_printk("%s: Txq %u, SQE idx %u, SQEs %u, HW head %u",
+		  __get_str(devname), __entry->qidx, __entry->sqe_idx,
+		  __entry->num_sqes, __entry->hw_head)
+);
+
+TRACE_EVENT(funeth_rx,
+
+	TP_PROTO(const struct funeth_rxq *rxq,
+		 u32 num_rqes,
+		 u32 pkt_len,
+		 u32 hash,
+		 u32 cls_vec),
+
+	TP_ARGS(rxq, num_rqes, pkt_len, hash, cls_vec),
+
+	TP_STRUCT__entry(
+		__field(u32, qidx)
+		__field(u32, cq_head)
+		__field(u32, num_rqes)
+		__field(u32, len)
+		__field(u32, hash)
+		__field(u32, cls_vec)
+		__string(devname, rxq->netdev->name)
+	),
+
+	TP_fast_assign(
+		__entry->qidx = rxq->qidx;
+		__entry->cq_head = rxq->cq_head;
+		__entry->num_rqes = num_rqes;
+		__entry->len = pkt_len;
+		__entry->hash = hash;
+		__entry->cls_vec = cls_vec;
+		__assign_str(devname, rxq->netdev->name);
+	),
+
+	TP_printk("%s: Rxq %u, CQ head %u, RQEs %u, len %u, hash %u, CV %#x",
+		  __get_str(devname), __entry->qidx, __entry->cq_head,
+		  __entry->num_rqes, __entry->len, __entry->hash,
+		  __entry->cls_vec)
+);
+
+#endif /* _TRACE_FUNETH_H */
+
+/* Below must be outside protection. */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE funeth_trace
+
+#include <trace/define_trace.h>
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
new file mode 100644
index 000000000000..e02e1b2fbc1e
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -0,0 +1,745 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+#include <linux/dma-mapping.h>
+#include <linux/ip.h>
+#include <linux/pci.h>
+#include <linux/skbuff.h>
+#include <linux/tcp.h>
+#include <uapi/linux/udp.h>
+#include "funeth.h"
+#include "funeth_txrx.h"
+#include "funeth_trace.h"
+#include "fun_queue.h"
+
+/* minimum packet size supported by HW is 33B */
+#define FUN_TX_MIN_LEN 33
+
+#define FUN_XDP_CLEAN_THRES 32
+#define FUN_XDP_CLEAN_BATCH 16
+
+/* DMA-map a packet and return the (length, DMA_address) pairs for its
+ * segments. If a mapping error occurs -ENOMEM is returned.
+ */
+static int map_skb(const struct sk_buff *skb, struct device *dev,
+		   dma_addr_t *addr, unsigned int *len)
+{
+	const struct skb_shared_info *si;
+	const skb_frag_t *fp, *end;
+
+	*len = skb_headlen(skb);
+	*addr = dma_map_single(dev, skb->data, *len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, *addr))
+		return -ENOMEM;
+
+	si = skb_shinfo(skb);
+	end = &si->frags[si->nr_frags];
+
+	for (fp = si->frags; fp < end; fp++) {
+		*++len = skb_frag_size(fp);
+		*++addr = skb_frag_dma_map(dev, fp, 0, *len, DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, *addr))
+			goto unwind;
+	}
+	return 0;
+
+unwind:
+	while (fp-- > si->frags)
+		dma_unmap_page(dev, *--addr, skb_frag_size(fp), DMA_TO_DEVICE);
+
+	dma_unmap_single(dev, addr[-1], skb_headlen(skb), DMA_TO_DEVICE);
+	return -ENOMEM;
+}
+
+/* Return the address just past the end of a Tx queue's descriptor ring.
+ * It exploits the fact that the HW writeback area is just after the end
+ * of the descriptor ring.
+ */
+static void *txq_end(const struct funeth_txq *q)
+{
+	return (void *)q->hw_wb;
+}
+
+/* Return the amount of space within a Tx ring from the given address to the
+ * end.
+ */
+static unsigned int txq_to_end(const struct funeth_txq *q, void *p)
+{
+	return txq_end(q) - p;
+}
+
+/* Return the number of Tx descriptors occupied by a Tx request. */
+static unsigned int tx_req_ndesc(const struct fun_eth_tx_req *req)
+{
+	return DIV_ROUND_UP(req->len8, FUNETH_SQE_SIZE / 8);
+}
+
+static __be16 tcp_hdr_doff_flags(const struct tcphdr *th)
+{
+	return *(__be16 *)&tcp_flag_word(th);
+}
+
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+#include "funeth_ktls.h"
+
+static struct sk_buff *fun_tls_tx(struct sk_buff *skb, struct funeth_txq *q,
+				  unsigned int *tls_len)
+{
+	const struct fun_ktls_tx_ctx *tls_ctx;
+	u32 datalen, seq;
+
+	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	if (!datalen)
+		return skb;
+
+	if (likely(!tls_offload_tx_resync_pending(skb->sk))) {
+		seq = ntohl(tcp_hdr(skb)->seq);
+		tls_ctx = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
+
+		if (likely(tls_ctx->next_seq == seq)) {
+			*tls_len = datalen;
+			return skb;
+		}
+		if (seq - tls_ctx->next_seq < U32_MAX / 4) {
+			tls_offload_tx_resync_request(skb->sk, seq,
+						      tls_ctx->next_seq);
+		}
+	}
+
+	FUN_QSTAT_INC(q, tx_tls_fallback);
+	skb = tls_encrypt_skb(skb);
+	if (!skb)
+		FUN_QSTAT_INC(q, tx_tls_drops);
+
+	return skb;
+}
+#endif
+
+/* Write as many descriptors as needed for the supplied skb starting at the
+ * current producer location. The caller has made certain enough descriptors
+ * are available.
+ *
+ * Returns the number of descriptors written, 0 on error.
+ */
+static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
+				   unsigned int tls_len)
+{
+	unsigned int extra_bytes = 0, extra_pkts = 0;
+	unsigned int idx = q->prod_cnt & q->mask;
+	const struct skb_shared_info *shinfo;
+	unsigned int lens[MAX_SKB_FRAGS + 1];
+	dma_addr_t addrs[MAX_SKB_FRAGS + 1];
+	struct fun_eth_tx_req *req;
+	struct fun_dataop_gl *gle;
+	const struct tcphdr *th;
+	unsigned int ngle, i;
+	u16 flags;
+
+	if (unlikely(skb->len < FUN_TX_MIN_LEN)) {
+		FUN_QSTAT_INC(q, tx_len_err);
+		return 0;
+	}
+
+	if (unlikely(map_skb(skb, q->dma_dev, addrs, lens))) {
+		FUN_QSTAT_INC(q, tx_map_err);
+		return 0;
+	}
+
+	req = fun_tx_desc_addr(q, idx);
+	req->op = FUN_ETH_OP_TX;
+	req->len8 = 0;
+	req->flags = 0;
+	req->suboff8 = offsetof(struct fun_eth_tx_req, dataop);
+	req->repr_idn = 0;
+	req->encap_proto = 0;
+
+	shinfo = skb_shinfo(skb);
+	if (likely(shinfo->gso_size)) {
+		if (skb->encapsulation) {
+			flags = FUN_ETH_OUTER_EN | FUN_ETH_INNER_LSO |
+				FUN_ETH_UPDATE_INNER_L4_CKSUM |
+				FUN_ETH_UPDATE_OUTER_L3_LEN;
+			if (shinfo->gso_type & (SKB_GSO_UDP_TUNNEL |
+						SKB_GSO_UDP_TUNNEL_CSUM)) {
+				flags |= FUN_ETH_UPDATE_OUTER_L4_LEN |
+					 FUN_ETH_OUTER_UDP;
+				if (shinfo->gso_type & SKB_GSO_UDP_TUNNEL_CSUM)
+					flags |= FUN_ETH_UPDATE_OUTER_L4_CKSUM;
+			}
+			if (ip_hdr(skb)->version == 4)
+				flags |= FUN_ETH_UPDATE_OUTER_L3_CKSUM;
+			else
+				flags |= FUN_ETH_OUTER_IPV6;
+
+			if (skb->inner_network_header) {
+				if (inner_ip_hdr(skb)->version == 4)
+					flags |= FUN_ETH_UPDATE_INNER_L3_CKSUM |
+						 FUN_ETH_UPDATE_INNER_L3_LEN;
+				else
+					flags |= FUN_ETH_INNER_IPV6 |
+						 FUN_ETH_UPDATE_INNER_L3_LEN;
+			}
+			th = inner_tcp_hdr(skb);
+			fun_eth_offload_init(&req->offload, flags,
+					     shinfo->gso_size,
+					     tcp_hdr_doff_flags(th), 0,
+					     skb_inner_network_offset(skb),
+					     skb_inner_transport_offset(skb),
+					     skb_network_offset(skb),
+					     skb_transport_offset(skb));
+		} else {
+			/* HW considers one set of headers as inner */
+			flags = FUN_ETH_INNER_LSO |
+				FUN_ETH_UPDATE_INNER_L4_CKSUM |
+				FUN_ETH_UPDATE_INNER_L3_LEN;
+			if (shinfo->gso_type & SKB_GSO_TCPV6)
+				flags |= FUN_ETH_INNER_IPV6;
+			else
+				flags |= FUN_ETH_UPDATE_INNER_L3_CKSUM;
+			th = tcp_hdr(skb);
+			fun_eth_offload_init(&req->offload, flags,
+					     shinfo->gso_size,
+					     tcp_hdr_doff_flags(th), 0,
+					     skb_network_offset(skb),
+					     skb_transport_offset(skb), 0, 0);
+		}
+
+		u64_stats_update_begin(&q->syncp);
+		q->stats.tx_tso++;
+		q->stats.tx_cso += shinfo->gso_segs;
+		u64_stats_update_end(&q->syncp);
+
+		extra_pkts = shinfo->gso_segs - 1;
+		extra_bytes = (be16_to_cpu(req->offload.inner_l4_off) +
+			       __tcp_hdrlen(th)) * extra_pkts;
+	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
+		flags = FUN_ETH_UPDATE_INNER_L4_CKSUM;
+		if (skb->csum_offset == offsetof(struct udphdr, check))
+			flags |= FUN_ETH_INNER_UDP;
+		fun_eth_offload_init(&req->offload, flags, 0, 0, 0, 0,
+				     skb_checksum_start_offset(skb), 0, 0);
+		FUN_QSTAT_INC(q, tx_cso);
+	} else {
+		fun_eth_offload_init(&req->offload, 0, 0, 0, 0, 0, 0, 0, 0);
+	}
+
+	ngle = shinfo->nr_frags + 1;
+	req->len8 = (sizeof(*req) + ngle * sizeof(*gle)) / 8;
+	req->dataop = FUN_DATAOP_HDR_INIT(ngle, 0, ngle, 0, skb->len);
+
+	for (i = 0, gle = (struct fun_dataop_gl *)req->dataop.imm;
+	     i < ngle && txq_to_end(q, gle); i++, gle++)
+		fun_dataop_gl_init(gle, 0, 0, lens[i], addrs[i]);
+
+	if (txq_to_end(q, gle) == 0) {
+		gle = (struct fun_dataop_gl *)q->desc;
+		for ( ; i < ngle; i++, gle++)
+			fun_dataop_gl_init(gle, 0, 0, lens[i], addrs[i]);
+	}
+
+	if (IS_ENABLED(CONFIG_TLS_DEVICE) && unlikely(tls_len)) {
+		struct fun_eth_tls *tls = (struct fun_eth_tls *)gle;
+		struct fun_ktls_tx_ctx *tls_ctx;
+
+		req->len8 += FUNETH_TLS_SZ / 8;
+		req->flags = cpu_to_be16(FUN_ETH_TX_TLS);
+
+		tls_ctx = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
+		tls->tlsid = tls_ctx->tlsid;
+		tls_ctx->next_seq += tls_len;
+
+		u64_stats_update_begin(&q->syncp);
+		q->stats.tx_tls_bytes += tls_len;
+		q->stats.tx_tls_pkts += 1 + extra_pkts;
+		u64_stats_update_end(&q->syncp);
+	}
+
+	u64_stats_update_begin(&q->syncp);
+	q->stats.tx_bytes += skb->len + extra_bytes;
+	q->stats.tx_pkts += 1 + extra_pkts;
+	u64_stats_update_end(&q->syncp);
+
+	q->info[idx].skb = skb;
+
+	trace_funeth_tx(q, skb->len, idx, req->dataop.ngather);
+	return tx_req_ndesc(req);
+}
+
+/* Return the number of available descriptors of a Tx queue.
+ * HW assumes head==tail means the ring is empty so we need to keep one
+ * descriptor unused.
+ */
+static unsigned int fun_txq_avail(const struct funeth_txq *q)
+{
+	return q->mask - q->prod_cnt + q->cons_cnt;
+}
+
+/* Stop a queue if it can't handle another worst-case packet. */
+static void fun_tx_check_stop(struct funeth_txq *q)
+{
+	if (likely(fun_txq_avail(q) >= FUNETH_MAX_PKT_DESC))
+		return;
+
+	netif_tx_stop_queue(q->ndq);
+
+	/* NAPI reclaim is freeing packets in parallel with us and we may race.
+	 * We have stopped the queue but check again after synchronizing with
+	 * reclaim.
+	 */
+	smp_mb();
+	if (likely(fun_txq_avail(q) < FUNETH_MAX_PKT_DESC))
+		FUN_QSTAT_INC(q, tx_nstops);
+	else
+		netif_tx_start_queue(q->ndq);
+}
+
+/* Return true if a queue has enough space to restart. Current condition is
+ * that the queue must be >= 1/4 empty.
+ */
+static bool fun_txq_may_restart(struct funeth_txq *q)
+{
+	return fun_txq_avail(q) >= q->mask / 4;
+}
+
+netdev_tx_t fun_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	unsigned int qid = skb_get_queue_mapping(skb);
+	struct funeth_txq *q = fp->txqs[qid];
+	unsigned int tls_len = 0;
+	unsigned int ndesc;
+
+	if (IS_ENABLED(CONFIG_TLS_DEVICE) && skb->sk &&
+	    tls_is_sk_tx_device_offloaded(skb->sk)) {
+		skb = fun_tls_tx(skb, q, &tls_len);
+		if (unlikely(!skb))
+			goto dropped;
+	}
+
+	ndesc = write_pkt_desc(skb, q, tls_len);
+	if (unlikely(!ndesc)) {
+		dev_kfree_skb_any(skb);
+		goto dropped;
+	}
+
+	q->prod_cnt += ndesc;
+	fun_tx_check_stop(q);
+
+	skb_tx_timestamp(skb);
+
+	if (__netdev_tx_sent_queue(q->ndq, skb->len, netdev_xmit_more()))
+		fun_txq_wr_db(q);
+	else
+		FUN_QSTAT_INC(q, tx_more);
+
+	return NETDEV_TX_OK;
+
+dropped:
+	/* A dropped packet may be the last one in a xmit_more train,
+	 * ring the doorbell just in case.
+	 */
+	if (!netdev_xmit_more())
+		fun_txq_wr_db(q);
+	return NETDEV_TX_OK;
+}
+
+/* Return a Tx queue's HW head index written back to host memory. */
+static u16 txq_hw_head(const struct funeth_txq *q)
+{
+	return (u16)be64_to_cpu(*q->hw_wb);
+}
+
+/* Unmap the Tx packet starting at the given descriptor index and
+ * return the number of Tx descriptors it occupied.
+ */
+static unsigned int unmap_skb(const struct funeth_txq *q, unsigned int idx)
+{
+	const struct fun_eth_tx_req *req = fun_tx_desc_addr(q, idx);
+	unsigned int ngle = req->dataop.ngather;
+	struct fun_dataop_gl *gle;
+
+	if (ngle) {
+		gle = (struct fun_dataop_gl *)req->dataop.imm;
+		dma_unmap_single(q->dma_dev, be64_to_cpu(gle->sgl_data),
+				 be32_to_cpu(gle->sgl_len), DMA_TO_DEVICE);
+
+		for (gle++; --ngle && txq_to_end(q, gle); gle++)
+			dma_unmap_page(q->dma_dev, be64_to_cpu(gle->sgl_data),
+				       be32_to_cpu(gle->sgl_len),
+				       DMA_TO_DEVICE);
+
+		for (gle = (struct fun_dataop_gl *)q->desc; ngle; ngle--, gle++)
+			dma_unmap_page(q->dma_dev, be64_to_cpu(gle->sgl_data),
+				       be32_to_cpu(gle->sgl_len),
+				       DMA_TO_DEVICE);
+	}
+
+	return tx_req_ndesc(req);
+}
+
+/* Reclaim completed Tx descriptors and free their packets. Restart a stopped
+ * queue if we freed enough descriptors.
+ *
+ * Return true if we exhausted the budget while there is more work to be done.
+ */
+static bool fun_txq_reclaim(struct funeth_txq *q, int budget)
+{
+	unsigned int npkts = 0, nbytes = 0, ndesc = 0;
+	unsigned int head, limit, reclaim_idx;
+
+	/* budget may be 0, e.g., netpoll */
+	limit = budget ? budget : UINT_MAX;
+
+	for (head = txq_hw_head(q), reclaim_idx = q->cons_cnt & q->mask;
+	     head != reclaim_idx && npkts < limit; head = txq_hw_head(q)) {
+		/* The HW head is continually updated, ensure we don't read
+		 * descriptor state before the head tells us to reclaim it.
+		 * On the enqueue side the doorbell is an implicit write
+		 * barrier.
+		 */
+		rmb();
+
+		do {
+			unsigned int pkt_desc = unmap_skb(q, reclaim_idx);
+			struct sk_buff *skb = q->info[reclaim_idx].skb;
+
+			trace_funeth_tx_free(q, reclaim_idx, pkt_desc, head);
+
+			nbytes += skb->len;
+			napi_consume_skb(skb, budget);
+			ndesc += pkt_desc;
+			reclaim_idx = (reclaim_idx + pkt_desc) & q->mask;
+			npkts++;
+		} while (reclaim_idx != head && npkts < limit);
+	}
+
+	q->cons_cnt += ndesc;
+	netdev_tx_completed_queue(q->ndq, npkts, nbytes);
+	smp_mb(); /* pairs with the one in fun_tx_check_stop() */
+
+	if (unlikely(netif_tx_queue_stopped(q->ndq) &&
+		     fun_txq_may_restart(q))) {
+		netif_tx_wake_queue(q->ndq);
+		FUN_QSTAT_INC(q, tx_nrestarts);
+	}
+
+	return reclaim_idx != head;
+}
+
+/* The NAPI handler for Tx queues. */
+int fun_txq_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct fun_irq *irq = container_of(napi, struct fun_irq, napi);
+	struct funeth_txq *q = irq->txq;
+	unsigned int db_val;
+
+	if (fun_txq_reclaim(q, budget))
+		return budget;               /* exhausted budget */
+
+	napi_complete(napi);                 /* exhausted pending work */
+	db_val = READ_ONCE(q->irq_db_val) | (q->cons_cnt & q->mask);
+	writel(db_val, q->db);
+	return 0;
+}
+
+static void fun_xdp_unmap(const struct funeth_txq *q, unsigned int idx)
+{
+	const struct fun_eth_tx_req *req = fun_tx_desc_addr(q, idx);
+	const struct fun_dataop_gl *gle;
+
+	gle = (const struct fun_dataop_gl *)req->dataop.imm;
+	dma_unmap_single(q->dma_dev, be64_to_cpu(gle->sgl_data),
+			 be32_to_cpu(gle->sgl_len), DMA_TO_DEVICE);
+}
+
+/* Reclaim up to @budget completed Tx descriptors from a TX XDP queue. */
+static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
+{
+	unsigned int npkts = 0, head, reclaim_idx;
+
+	for (head = txq_hw_head(q), reclaim_idx = q->cons_cnt & q->mask;
+	     head != reclaim_idx && npkts < budget; head = txq_hw_head(q)) {
+		/* The HW head is continually updated, ensure we don't read
+		 * descriptor state before the head tells us to reclaim it.
+		 * On the enqueue side the doorbell is an implicit write
+		 * barrier.
+		 */
+		rmb();
+
+		do {
+			fun_xdp_unmap(q, reclaim_idx);
+			page_frag_free(q->info[reclaim_idx].vaddr);
+
+			trace_funeth_tx_free(q, reclaim_idx, 1, head);
+
+			reclaim_idx = (reclaim_idx + 1) & q->mask;
+			npkts++;
+		} while (reclaim_idx != head && npkts < budget);
+	}
+
+	q->cons_cnt += npkts;
+	return npkts;
+}
+
+bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len)
+{
+	struct fun_eth_tx_req *req;
+	struct fun_dataop_gl *gle;
+	unsigned int idx;
+	dma_addr_t dma;
+
+	if (unlikely(len < FUN_TX_MIN_LEN)) {
+		FUN_QSTAT_INC(q, tx_len_err);
+		return false;
+	}
+
+	if (fun_txq_avail(q) < FUN_XDP_CLEAN_THRES)
+		fun_xdpq_clean(q, FUN_XDP_CLEAN_BATCH);
+
+	if (!unlikely(fun_txq_avail(q))) {
+		FUN_QSTAT_INC(q, tx_xdp_full);
+		return false;
+	}
+
+	dma = dma_map_single(q->dma_dev, data, len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(q->dma_dev, dma))) {
+		FUN_QSTAT_INC(q, tx_map_err);
+		return false;
+	}
+
+	idx = q->prod_cnt & q->mask;
+	req = fun_tx_desc_addr(q, idx);
+	req->op = FUN_ETH_OP_TX;
+	req->len8 = (sizeof(*req) + sizeof(*gle)) / 8;
+	req->flags = 0;
+	req->suboff8 = offsetof(struct fun_eth_tx_req, dataop);
+	req->repr_idn = 0;
+	req->encap_proto = 0;
+	fun_eth_offload_init(&req->offload, 0, 0, 0, 0, 0, 0, 0, 0);
+	req->dataop = FUN_DATAOP_HDR_INIT(1, 0, 1, 0, len);
+
+	gle = (struct fun_dataop_gl *)req->dataop.imm;
+	fun_dataop_gl_init(gle, 0, 0, len, dma);
+
+	q->info[idx].vaddr = data;
+
+	u64_stats_update_begin(&q->syncp);
+	q->stats.tx_bytes += len;
+	q->stats.tx_pkts++;
+	u64_stats_update_end(&q->syncp);
+
+	trace_funeth_tx(q, len, idx, 1);
+	q->prod_cnt++;
+
+	return true;
+}
+
+int fun_xdp_xmit_frames(struct net_device *dev, int n,
+			struct xdp_frame **frames, u32 flags)
+{
+	struct funeth_priv *fp = netdev_priv(dev);
+	struct funeth_txq *q, **xdpqs;
+	int i, q_idx;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	xdpqs = rcu_dereference_bh(fp->xdpqs);
+	if (unlikely(!xdpqs))
+		return -ENETDOWN;
+
+	q_idx = smp_processor_id();
+	if (unlikely(q_idx >= fp->num_xdpqs))
+		return -ENXIO;
+
+	for (q = xdpqs[q_idx], i = 0; i < n; i++) {
+		const struct xdp_frame *xdpf = frames[i];
+
+		if (!fun_xdp_tx(q, xdpf->data, xdpf->len))
+			break;
+	}
+
+	if (unlikely(flags & XDP_XMIT_FLUSH))
+		fun_txq_wr_db(q);
+	return i;
+}
+
+/* Purge a Tx queue of any queued packets. Should be called once HW access
+ * to the packets has been revoked, e.g., after the queue has been disabled.
+ */
+static void fun_txq_purge(struct funeth_txq *q)
+{
+	while (q->cons_cnt != q->prod_cnt) {
+		unsigned int idx = q->cons_cnt & q->mask;
+
+		q->cons_cnt += unmap_skb(q, idx);
+		dev_kfree_skb_any(q->info[idx].skb);
+	}
+	netdev_tx_reset_queue(q->ndq);
+}
+
+static void fun_xdpq_purge(struct funeth_txq *q)
+{
+	while (q->cons_cnt != q->prod_cnt) {
+		unsigned int idx = q->cons_cnt & q->mask;
+
+		fun_xdp_unmap(q, idx);
+		page_frag_free(q->info[idx].vaddr);
+		q->cons_cnt++;
+	}
+}
+
+/* Create a Tx queue, allocating all the host resources needed. */
+static struct funeth_txq *funeth_txq_create_sw(struct net_device *dev,
+					       unsigned int qidx,
+					       unsigned int ndesc,
+					       struct fun_irq *irq)
+{
+	struct funeth_priv *fp = netdev_priv(dev);
+	struct funeth_txq *q;
+	unsigned int ethid;
+	const char *qtype;
+	int numa_node;
+
+	ethid = fp->ethid_start + qidx;
+	if (irq) {
+		/* regular Tx queue */
+		qtype = "Tx";
+		numa_node = fun_irq_node(irq);
+	} else {
+		/* XDP Tx queue */
+		qtype = "XDP";
+		numa_node = cpu_to_node(qidx);
+		ethid += dev->real_num_tx_queues;
+	}
+
+	q = kzalloc_node(sizeof(*q), GFP_KERNEL, numa_node);
+	if (!q)
+		goto err;
+
+	q->irq_db_val = FUN_IRQ_SQ_DB(fp->tx_coal_usec, fp->tx_coal_count);
+	q->netdev = dev;
+	q->dma_dev = &fp->pdev->dev;
+	q->mask = ndesc - 1;
+	q->qidx = qidx;
+	q->ethid = ethid;
+	q->numa_node = numa_node;
+	u64_stats_init(&q->syncp);
+
+	q->desc = fun_alloc_ring_mem(q->dma_dev, ndesc, FUNETH_SQE_SIZE,
+				     sizeof(*q->info), true, numa_node,
+				     &q->dma_addr, (void **)&q->info,
+				     &q->hw_wb);
+	if (!q->desc)
+		goto free_q;
+
+	if (irq) {
+		q->ndq = netdev_get_tx_queue(dev, qidx);
+		q->irq_idx = irq->irq_idx;
+	}
+
+	return q;
+
+free_q:
+	kfree(q);
+err:
+	netdev_err(dev, "Can't allocate memory for %s queue %u\n", qtype, qidx);
+	return NULL;
+}
+
+static void funeth_txq_free_sw(struct funeth_txq *q)
+{
+	struct funeth_priv *fp = netdev_priv(q->netdev);
+
+	if (q->ndq)
+		fun_txq_purge(q);
+	else
+		fun_xdpq_purge(q);
+
+	fun_free_ring_mem(q->dma_dev, q->mask + 1, FUNETH_SQE_SIZE, true,
+			  q->desc, q->dma_addr, q->info);
+
+	fp->tx_packets += q->stats.tx_pkts;
+	fp->tx_bytes   += q->stats.tx_bytes;
+	fp->tx_dropped += q->stats.tx_map_err + q->stats.tx_len_err;
+
+	kfree(q);
+}
+
+/* Allocate the device portion of a Tx queue. */
+static int funeth_txq_create_dev(struct funeth_txq *q)
+{
+	struct funeth_priv *fp = netdev_priv(q->netdev);
+	unsigned int ndesc = q->mask + 1;
+	int err;
+
+	err = fun_sq_create(fp->fdev,
+			    FUN_ADMIN_EPSQ_CREATE_FLAG_HEAD_WB_ADDRESS |
+			    FUN_ADMIN_RES_CREATE_FLAG_ALLOCATOR, 0,
+			    FUN_HCI_ID_INVALID, ilog2(FUNETH_SQE_SIZE), ndesc,
+			    q->dma_addr, fp->tx_coal_count, fp->tx_coal_usec,
+			    q->irq_idx, 0, fp->fdev->kern_end_qid, 0,
+			    &q->hw_qid, &q->db);
+	if (err)
+		goto out;
+
+	err = fun_create_and_bind_tx(fp, q->ethid, q->hw_qid);
+	if (err)
+		goto free_devq;
+
+	if (q->irq_idx)
+		writel(q->irq_db_val, q->db);
+
+	netif_info(fp, ifup, q->netdev,
+		   "%s queue %u, depth %u, HW qid %u, IRQ idx %u, eth id %u, node %d\n",
+		   q->ndq ? "Tx" : "XDP", q->qidx, ndesc, q->hw_qid, q->irq_idx,
+		   q->ethid, q->numa_node);
+	return 0;
+
+free_devq:
+	fun_destroy_sq(fp->fdev, q->hw_qid);
+out:
+	netdev_err(q->netdev,
+		   "Failed to create %s queue %u on device, error %d\n",
+		   q->ndq ? "Tx" : "XDP", q->qidx, err);
+	return err;
+}
+
+/* Create a Tx queue, allocating all the host and device resources needed. */
+struct funeth_txq *funeth_txq_create(struct net_device *dev, unsigned int qidx,
+				     unsigned int ndesc, struct fun_irq *irq)
+{
+	struct funeth_txq *q;
+	int err;
+
+	q = funeth_txq_create_sw(dev, qidx, ndesc, irq);
+	if (!q)
+		return ERR_PTR(-ENOMEM);
+
+	err = funeth_txq_create_dev(q);
+	if (err) {
+		funeth_txq_free_sw(q);
+		return ERR_PTR(err);
+	}
+
+	if (irq)
+		irq->txq = q;
+
+	return q;
+}
+
+/* Destroy and free a Tx queue.
+ * The queue must be already disconnected from the stack.
+ */
+void funeth_txq_free(struct funeth_txq *q)
+{
+	struct funeth_priv *fp = netdev_priv(q->netdev);
+
+	fun_destroy_sq(fp->fdev, q->hw_qid);
+	fun_res_destroy(fp->fdev, FUN_ADMIN_OP_ETH, 0, q->ethid);
+
+	netif_info(fp, ifdown, q->netdev,
+		   "Freeing %s queue %u (id %u), IRQ %u, ethid %u\n",
+		   q->ndq ? "Tx" : "XDP", q->qidx, q->hw_qid, q->irq_idx,
+		   q->ethid);
+	funeth_txq_free_sw(q);
+}
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
new file mode 100644
index 000000000000..98e087d29093
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
@@ -0,0 +1,245 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
+#ifndef _FUNETH_TXRX_H
+#define _FUNETH_TXRX_H
+
+#include <linux/netdevice.h>
+#include <linux/u64_stats_sync.h>
+
+/* Tx descriptor size */
+#define FUNETH_SQE_SIZE 64U
+
+/* Size of device headers per Tx packet */
+#define FUNETH_FUNOS_HDR_SZ (sizeof(struct fun_eth_tx_req))
+
+/* Number of gather list entries per Tx descriptor */
+#define FUNETH_GLE_PER_DESC (FUNETH_SQE_SIZE / sizeof(struct fun_dataop_gl))
+
+/* Max gather list size in bytes for an sk_buff. */
+#define FUNETH_MAX_GL_SZ ((MAX_SKB_FRAGS + 1) * sizeof(struct fun_dataop_gl))
+
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+# define FUNETH_TLS_SZ sizeof(struct fun_eth_tls)
+#else
+# define FUNETH_TLS_SZ 0
+#endif
+
+/* Max number of Tx descriptors for an sk_buff using a gather list. */
+#define FUNETH_MAX_GL_DESC \
+	DIV_ROUND_UP((FUNETH_FUNOS_HDR_SZ + FUNETH_MAX_GL_SZ + FUNETH_TLS_SZ), \
+		     FUNETH_SQE_SIZE)
+
+/* Max number of Tx descriptors for any packet. */
+#define FUNETH_MAX_PKT_DESC FUNETH_MAX_GL_DESC
+
+/* Rx CQ descriptor size. */
+#define FUNETH_CQE_SIZE 64U
+
+/* Offset of cqe_info within a CQE. */
+#define FUNETH_CQE_INFO_OFFSET (FUNETH_CQE_SIZE - sizeof(struct fun_cqe_info))
+
+/* Construct the IRQ portion of a CQ doorbell. The resulting value arms the
+ * interrupt with the supplied time delay and packet count moderation settings.
+ */
+#define FUN_IRQ_CQ_DB(usec, pkts) \
+	(FUN_DB_IRQ_ARM_F | ((usec) << FUN_DB_INTCOAL_USEC_S) | \
+	 ((pkts) << FUN_DB_INTCOAL_ENTRIES_S))
+
+/* As above for SQ doorbells. */
+#define FUN_IRQ_SQ_DB(usec, pkts) \
+	(FUN_DB_IRQ_ARM_F | \
+	 ((usec) << FUN_DB_INTCOAL_USEC_S) | \
+	 ((pkts) << FUN_DB_INTCOAL_ENTRIES_S))
+
+/* Per packet tailroom. Present only for 1-frag packets. */
+#define FUN_RX_TAILROOM SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
+
+/* Per packet headroom for XDP. Preferred over XDP_PACKET_HEADROOM to
+ * accommodate two packets per buffer for 4K pages and 1500B MTUs.
+ */
+#define FUN_XDP_HEADROOM 192
+
+struct bpf_prog;
+
+struct funeth_txq_stats {  /* per Tx queue SW counters */
+	u64 tx_pkts;       /* # of Tx packets */
+	u64 tx_bytes;      /* total bytes of Tx packets */
+	u64 tx_cso;        /* # of packets with checksum offload */
+	u64 tx_tso;        /* # of TSO super-packets */
+	u64 tx_more;       /* # of DBs elided due to xmit_more */
+	u64 tx_nstops;     /* # of times the queue has stopped */
+	u64 tx_nrestarts;  /* # of times the queue has restarted */
+	u64 tx_map_err;    /* # of packets dropped due to DMA mapping errors */
+	u64 tx_len_err;    /* # of packets dropped due to unsupported length */
+	u64 tx_xdp_full;   /* # of XDP packets that could not be enqueued */
+	u64 tx_tls_pkts;   /* # of Tx TLS packets offloaded to HW */
+	u64 tx_tls_bytes;  /* Tx bytes of HW-handled TLS payload */
+	u64 tx_tls_fallback; /* attempted Tx TLS offloads punted to SW */
+	u64 tx_tls_drops;  /* attempted Tx TLS offloads dropped */
+};
+
+struct funeth_tx_info {      /* per Tx descriptor state */
+	union {
+		struct sk_buff *skb; /* associated packet */
+		void *vaddr;         /* start address for XDP */
+	};
+};
+
+struct funeth_txq {
+	/* RO cacheline of frequently accessed data */
+	u32 mask;               /* queue depth - 1 */
+	u32 hw_qid;             /* device ID of the queue */
+	void *desc;             /* base address of descriptor ring */
+	struct funeth_tx_info *info;
+	struct device *dma_dev; /* device for DMA mappings */
+	volatile __be64 *hw_wb; /* HW write-back location */
+	u32 __iomem *db;        /* SQ doorbell register address */
+	struct netdev_queue *ndq;
+	dma_addr_t dma_addr;    /* DMA address of descriptor ring */
+	/* producer R/W cacheline */
+	u16 qidx;               /* queue index within net_device */
+	u16 irq_idx;            /* IRQ index asserted by queue */
+	u32 prod_cnt;           /* producer counter */
+	struct funeth_txq_stats stats;
+	/* shared R/W cacheline, primarily accessed by consumer */
+	u32 irq_db_val;         /* value written to IRQ doorbell */
+	u32 cons_cnt;           /* consumer (cleanup) counter */
+	struct net_device *netdev;
+	int numa_node;
+	u16 ethid;
+	bool hang_reported;
+	struct u64_stats_sync syncp;
+};
+
+struct funeth_rxq_stats {  /* per Rx queue SW counters */
+	u64 rx_pkts;       /* # of received packets, including SW drops */
+	u64 rx_bytes;      /* total size of received packets */
+	u64 rx_cso;        /* # of packets with checksum offload */
+	u64 rx_bufs;       /* total # of Rx buffers provided to device */
+	u64 gro_pkts;      /* # of GRO superpackets */
+	u64 gro_merged;    /* # of pkts merged into existing GRO superpackets */
+	u64 rx_page_alloc; /* # of page allocations for Rx buffers */
+	u64 rx_budget;     /* NAPI iterations that exhausted their budget */
+	u64 rx_mem_drops;  /* # of packets dropped due to memory shortage */
+	u64 rx_map_err;    /* # of page DMA mapping errors */
+	u64 xdp_drops;     /* XDP_DROPped packets */
+	u64 xdp_tx;        /* successful XDP transmits */
+	u64 xdp_redir;     /* successful XDP redirects */
+	u64 xdp_err;       /* packets dropped due to XDP errors */
+};
+
+struct funeth_rxbuf {          /* per Rx buffer state */
+	struct page *page;     /* associated page */
+	dma_addr_t dma_addr;   /* DMA address of page start */
+	int pg_refs;           /* page refs held by driver */
+	int node;              /* page node, or -1 if it is PF_MEMALLOC */
+};
+
+struct funeth_rx_cache {       /* cache of DMA-mapped previously used buffers */
+	struct funeth_rxbuf *bufs; /* base of Rx buffer state ring */
+	unsigned int prod_cnt;     /* producer counter */
+	unsigned int cons_cnt;     /* consumer counter */
+	unsigned int mask;         /* depth - 1 */
+};
+
+/* An Rx queue consists of a CQ and an SQ used to provide Rx buffers. */
+struct funeth_rxq {
+	struct net_device *netdev;
+	struct napi_struct *napi;
+	struct device *dma_dev;    /* device for DMA mappings */
+	void *cqes;                /* base of CQ descriptor ring */
+	const void *next_cqe_info; /* fun_cqe_info of next CQE */
+	u32 __iomem *cq_db;        /* CQ doorbell register address */
+	unsigned int cq_head;      /* CQ head index */
+	unsigned int cq_mask;      /* CQ depth - 1 */
+	u16 phase;                 /* CQ phase tag */
+	u16 qidx;                  /* queue index within net_device */
+	unsigned int irq_db_val;   /* IRQ info for CQ doorbell */
+	struct fun_eprq_rqbuf *rqes; /* base of RQ descriptor ring */
+	struct funeth_rxbuf *bufs; /* base of Rx buffer state ring */
+	struct funeth_rxbuf *cur_buf; /* currently active buffer */
+	u32 __iomem *rq_db;        /* RQ doorbell register address */
+	unsigned int rq_cons;      /* RQ consumer counter */
+	unsigned int rq_mask;      /* RQ depth - 1 */
+	unsigned int buf_offset;   /* offset of next pkt in head buffer */
+	u8 xdp_flush;              /* XDP flush types needed at NAPI end */
+	unsigned int rq_cons_db;   /* value of rq_cons at last RQ db */
+	unsigned int rq_db_thres;  /* # of new buffers needed to write RQ db */
+	struct funeth_rxbuf spare_buf; /* spare for next buffer replacement */
+	struct funeth_rx_cache cache; /* used buffer cache */
+	struct bpf_prog *xdp_prog; /* optional XDP BPF program */
+	struct funeth_rxq_stats stats;
+	dma_addr_t cq_dma_addr;    /* DMA address of CQE ring */
+	dma_addr_t rq_dma_addr;    /* DMA address of RQE ring */
+	unsigned int headroom;     /* per packet headroom */
+	u16 irq_idx;               /* IRQ index for CQ interrupt */
+	u16 irq_cnt;               /* IRQ counter for DIM */
+	u32 hw_cqid;               /* device ID of the queue's CQ */
+	u32 hw_sqid;               /* device ID of the queue's SQ */
+	int numa_node;
+	struct u64_stats_sync syncp;
+	struct xdp_rxq_info xdp_rxq;
+};
+
+#define FUN_QSTAT_INC(q, counter) \
+	do { \
+		u64_stats_update_begin(&(q)->syncp); \
+		(q)->stats.counter++; \
+		u64_stats_update_end(&(q)->syncp); \
+	} while (0)
+
+#define FUN_QSTAT_READ(q, seq, stats_copy) \
+	do { \
+		seq = u64_stats_fetch_begin(&(q)->syncp); \
+		stats_copy = (q)->stats; \
+	} while (u64_stats_fetch_retry(&(q)->syncp, (seq)))
+
+#define FUN_INT_NAME_LEN (IFNAMSIZ + 16)
+
+struct fun_irq {
+	struct napi_struct napi;
+	struct funeth_txq *txq;
+	struct funeth_rxq *rxq;
+	u16 irq_idx;              /* index of MSI-X interrupt */
+	int irq;                  /* Linux IRQ vector */
+	cpumask_t affinity_mask;  /* IRQ affinity */
+	struct irq_affinity_notify aff_notify;
+	char name[FUN_INT_NAME_LEN];
+} ____cacheline_internodealigned_in_smp;
+
+/* Return the start address of the idx-th Tx descriptor. */
+static inline void *fun_tx_desc_addr(const struct funeth_txq *q,
+				     unsigned int idx)
+{
+	return q->desc + idx * FUNETH_SQE_SIZE;
+}
+
+static inline void fun_txq_wr_db(const struct funeth_txq *q)
+{
+	unsigned int tail = q->prod_cnt & q->mask;
+
+	writel(tail, q->db);
+}
+
+static inline int fun_irq_node(const struct fun_irq *p)
+{
+	return local_memory_node(cpu_to_node(cpumask_first(&p->affinity_mask)));
+}
+
+int fun_rxq_napi_poll(struct napi_struct *napi, int budget);
+int fun_txq_napi_poll(struct napi_struct *napi, int budget);
+netdev_tx_t fun_start_xmit(struct sk_buff *skb, struct net_device *netdev);
+bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len);
+int fun_xdp_xmit_frames(struct net_device *dev, int n,
+			struct xdp_frame **frames, u32 flags);
+
+struct funeth_txq *funeth_txq_create(struct net_device *dev, unsigned int qidx,
+				     unsigned int ndesc, struct fun_irq *irq);
+void funeth_txq_free(struct funeth_txq *q);
+struct funeth_rxq *funeth_rxq_create(struct net_device *dev, unsigned int qidx,
+				     unsigned int ncqe, unsigned int nrqe,
+				     struct fun_irq *irq);
+void funeth_rxq_free(struct funeth_rxq *q);
+int fun_rxq_set_bpf(struct funeth_rxq *q, struct bpf_prog *prog);
+
+#endif /* _FUNETH_TXRX_H */
-- 
2.25.1

