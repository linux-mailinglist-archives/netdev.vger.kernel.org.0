Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E409F293811
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 11:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392757AbgJTJd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 05:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391743AbgJTJd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 05:33:57 -0400
Received: from lore-desk.redhat.com (unknown [151.66.125.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AF3F222C8;
        Tue, 20 Oct 2020 09:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603186436;
        bh=TO2mQCrZ4gEjafEEdiwpDNPoeRvJOuZg3DXkV4CWg28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkMyuuKIVERtvrttDWafGL6YELuB2LbGvLNaH9a1Xxk3sFOSt605jPaWBo7xwHegU
         NskvCh2AC9LEhxJqq+RAnJEqCHybth1idKwr2qXmanKepTBmlbMs7+p3rvihqEgxFi
         6o0O5FJzvE1f5m5z0k/FMFF3r3D0bUPEuj7hSra4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [RFC 1/2] net: xdp: introduce bulking for xdp tx return path
Date:   Tue, 20 Oct 2020 11:33:37 +0200
Message-Id: <62165fcacf47521edae67ae739827aa5f751fb8b.1603185591.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603185591.git.lorenzo@kernel.org>
References: <cover.1603185591.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bulking capability in xdp tx return path (XDP_TX and
XDP_REDIRECT). xdp_return_frame and xdp_return_frame_napi are usually
run inside the driver NAPI tx completion loop so it is possible batch
them.
Current implementation considers only page_pool memory model.
Convert mvneta driver to xdp_return_frame_bulk APIs.

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c |  8 ++---
 include/net/xdp.h                     | 11 ++++++
 net/core/xdp.c                        | 50 +++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 54b0bf574c05..af33cc62ed4c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -663,6 +663,8 @@ struct mvneta_tx_queue {
 
 	/* Affinity mask for CPUs*/
 	cpumask_t affinity_mask;
+
+	struct xdp_frame_bulk bq;
 };
 
 struct mvneta_rx_queue {
@@ -1854,12 +1856,10 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 			dev_kfree_skb_any(buf->skb);
 		} else if (buf->type == MVNETA_TYPE_XDP_TX ||
 			   buf->type == MVNETA_TYPE_XDP_NDO) {
-			if (napi && buf->type == MVNETA_TYPE_XDP_TX)
-				xdp_return_frame_rx_napi(buf->xdpf);
-			else
-				xdp_return_frame(buf->xdpf);
+			xdp_return_frame_bulk(buf->xdpf, &txq->bq, napi);
 		}
 	}
+	xdp_flush_frame_bulk(&txq->bq, napi);
 
 	netdev_tx_completed_queue(nq, pkts_compl, bytes_compl);
 }
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 3814fb631d52..4b79d50afe36 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -104,6 +104,12 @@ struct xdp_frame {
 	struct net_device *dev_rx; /* used by cpumap */
 };
 
+#define XDP_BULK_QUEUE_SIZE	16
+struct xdp_frame_bulk {
+	void *q[XDP_BULK_QUEUE_SIZE];
+	int count;
+	void *xa;
+};
 
 static inline struct skb_shared_info *
 xdp_get_shared_info_from_frame(struct xdp_frame *frame)
@@ -194,6 +200,11 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
 void xdp_return_frame(struct xdp_frame *xdpf);
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
 void xdp_return_buff(struct xdp_buff *xdp);
+void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq,
+			  bool napi_direct);
+void xdp_return_frame_bulk(struct xdp_frame *xdpf,
+			   struct xdp_frame_bulk *bq,
+			   bool napi_direct);
 
 /* When sending xdp_frame into the network stack, then there is no
  * return point callback, which is needed to release e.g. DMA-mapping
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 48aba933a5a8..b05467a916b4 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -380,6 +380,56 @@ void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
 
+void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq,
+			  bool napi_direct)
+{
+	struct xdp_mem_allocator *xa = bq->xa;
+	int i;
+
+	for (i = 0; i < bq->count; i++) {
+		napi_direct &= !xdp_return_frame_no_direct();
+		page_pool_put_full_page(xa->page_pool,
+					virt_to_head_page(bq->q[i]),
+					napi_direct);
+	}
+	bq->count = 0;
+}
+EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
+
+void xdp_return_frame_bulk(struct xdp_frame *xdpf,
+			   struct xdp_frame_bulk *bq,
+			   bool napi_direct)
+{
+	struct xdp_mem_info *mem = &xdpf->mem;
+	struct xdp_mem_allocator *xa, *nxa;
+
+	if (mem->type != MEM_TYPE_PAGE_POOL) {
+		__xdp_return(xdpf->data, &xdpf->mem, napi_direct);
+		return;
+	}
+
+	rcu_read_lock();
+
+	xa = bq->xa;
+	if (unlikely(!xa || mem->id != xa->mem.id)) {
+		nxa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
+		if (unlikely(!xa)) {
+			bq->xa = nxa;
+			xa = nxa;
+		}
+	}
+
+	if (mem->id != xa->mem.id || bq->count == XDP_BULK_QUEUE_SIZE)
+		xdp_flush_frame_bulk(bq, napi_direct);
+
+	bq->q[bq->count++] = xdpf->data;
+	if (mem->id != xa->mem.id)
+		bq->xa = nxa;
+
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
+
 void xdp_return_buff(struct xdp_buff *xdp)
 {
 	__xdp_return(xdp->data, &xdp->rxq->mem, true);
-- 
2.26.2

