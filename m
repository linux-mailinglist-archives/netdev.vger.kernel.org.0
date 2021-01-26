Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C50C3057D1
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314424AbhAZXH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391756AbhAZSnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 13:43:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86D5022A85;
        Tue, 26 Jan 2021 18:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611686551;
        bh=9BvhNhDHnU6jsGLFkKZKqL/AxJq7Qp6jP8i0mqzYq3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrjLFmHScoywk1VJO4g9ssCgW/PHsPOp0/bTwlXlkBi0IeJce7Lm0ufplGBOP4H6H
         Dn/1gjBr81tnbyVdfU204yUtPdfOSghdSJZnioD1fY+OOrPCyGwCR65QLTLBTpTRAs
         hldKKbM+S27+Kqr0zmyvlzt+Vjhl7FCB1F9LiQenSnYoy7kHQSunE52reDwQQuCBxU
         3zMknVU1ZY6RUx70ziCF4go/GpIk1zbcaTvwh+vgZgvgL4tQRoaEkTxJJboDelXJKd
         MSj5bmyfis8gwd3rgK/1RgtC9fsAtHH9nBtLntmhD2xbZrg+h81/ZkyMWKHk7amsEw
         A6+xidV/s9jIQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, toshiaki.makita1@gmail.com,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com
Subject: [PATCH bpf-next 2/3] net: xdp: move XDP_BATCH_SIZE in common header
Date:   Tue, 26 Jan 2021 19:42:00 +0100
Message-Id: <59195b7a7e53630f43ed7d55eb3b0237b72a9e11.1611685778.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611685778.git.lorenzo@kernel.org>
References: <cover.1611685778.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move CPUMAP_BATCH macro in xdp common header and rename it to
XDP_BATCH_SIZE in order to be reused in veth driver

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c  |  2 +-
 include/net/xdp.h   |  1 +
 kernel/bpf/cpumap.c | 13 +++++--------
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 23137d9966da..ff77b541e5fc 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -793,7 +793,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 		int i, n_frame, n_skb = 0;
 
 		n_frame = __ptr_ring_consume_batched(&rq->xdp_ring, frames,
-						     VETH_XDP_BATCH);
+						     XDP_BATCH_SIZE);
 		if (!n_frame)
 			break;
 
diff --git a/include/net/xdp.h b/include/net/xdp.h
index c4bfdc9a8b79..c0e15bcb3a22 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -124,6 +124,7 @@ struct xdp_frame {
 	struct net_device *dev_rx; /* used by cpumap */
 };
 
+#define XDP_BATCH_SIZE		8 /* 8 == one cacheline on 64-bit archs */
 #define XDP_BULK_QUEUE_SIZE	16
 struct xdp_frame_bulk {
 	int count;
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 5d1469de6921..ecda8eadd837 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -37,12 +37,11 @@
  * which queue in bpf_cpu_map_entry contains packets.
  */
 
-#define CPU_MAP_BULK_SIZE 8  /* 8 == one cacheline on 64-bit archs */
 struct bpf_cpu_map_entry;
 struct bpf_cpu_map;
 
 struct xdp_bulk_queue {
-	void *q[CPU_MAP_BULK_SIZE];
+	void *q[XDP_BATCH_SIZE];
 	struct list_head flush_node;
 	struct bpf_cpu_map_entry *obj;
 	unsigned int count;
@@ -237,8 +236,6 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 	return nframes;
 }
 
-#define CPUMAP_BATCH 8
-
 static int cpu_map_kthread_run(void *data)
 {
 	struct bpf_cpu_map_entry *rcpu = data;
@@ -254,8 +251,8 @@ static int cpu_map_kthread_run(void *data)
 		struct xdp_cpumap_stats stats = {}; /* zero stats */
 		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
 		unsigned int drops = 0, sched = 0;
-		void *frames[CPUMAP_BATCH];
-		void *skbs[CPUMAP_BATCH];
+		void *frames[XDP_BATCH_SIZE];
+		void *skbs[XDP_BATCH_SIZE];
 		int i, n, m, nframes;
 
 		/* Release CPU reschedule checks */
@@ -278,7 +275,7 @@ static int cpu_map_kthread_run(void *data)
 		 * consume side valid as no-resize allowed of queue.
 		 */
 		n = __ptr_ring_consume_batched(rcpu->queue, frames,
-					       CPUMAP_BATCH);
+					       XDP_BATCH_SIZE);
 		for (i = 0; i < n; i++) {
 			void *f = frames[i];
 			struct page *page = virt_to_page(f);
@@ -656,7 +653,7 @@ static void bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 	struct list_head *flush_list = this_cpu_ptr(&cpu_map_flush_list);
 	struct xdp_bulk_queue *bq = this_cpu_ptr(rcpu->bulkq);
 
-	if (unlikely(bq->count == CPU_MAP_BULK_SIZE))
+	if (unlikely(bq->count == XDP_BATCH_SIZE))
 		bq_flush_to_queue(bq);
 
 	/* Notice, xdp_buff/page MUST be queued here, long enough for
-- 
2.29.2

