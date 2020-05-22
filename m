Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CE91DECF2
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 18:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbgEVQL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 12:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbgEVQL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 12:11:56 -0400
Received: from localhost.localdomain.com (unknown [151.48.155.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 831B22070A;
        Fri, 22 May 2020 16:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590163915;
        bh=YUPYH1pavOTQQhLvMnno/MI050aqPX20bHvF2tUzOW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORYJgfWO8lli0RoKDxrQE9KpQ81nVMi2w93QU26Ekan2v5Tcu1OznrqC3PIY000rn
         /E91w0ugxQPP6jEwrBpq/0oXkoTlnLXSh3VGvgVpjq1bmoc2UvH76JRNqP9rAmeV8X
         Uy4pC2ptdhyzqmdD4XV3NIou154sb7He5ssY5WNM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [RFC bpf-next 1/2] bpf: cpumap: add the possibility to attach a eBPF program to cpumap
Date:   Fri, 22 May 2020 18:11:31 +0200
Message-Id: <6685dc56730e109758bd3affb1680114c3064da1.1590162098.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1590162098.git.lorenzo@kernel.org>
References: <cover.1590162098.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to attach a eBPF program to cpumap entries.
The idea behind this feature is to add the possibility to define on
which CPU run the eBPF program if the underlying hw does not support
RSS. Current supported verdicts are XDP_DROP and XDP_PASS

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/bpf/cpumap.c | 111 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 92 insertions(+), 19 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 8b85bfddfac7..38f738220b36 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -48,17 +48,25 @@ struct xdp_bulk_queue {
 	unsigned int count;
 };
 
+struct bpf_cpu_map_entry_value {
+	u32 prog_id;
+	u32 qsize;
+};
+
 /* Struct for every remote "destination" CPU in map */
 struct bpf_cpu_map_entry {
 	u32 cpu;    /* kthread CPU and map index */
 	int map_id; /* Back reference to map */
-	u32 qsize;  /* Queue size placeholder for map lookup */
+
+	struct bpf_cpu_map_entry_value value;
 
 	/* XDP can run multiple RX-ring queues, need __percpu enqueue store */
 	struct xdp_bulk_queue __percpu *bulkq;
 
 	struct bpf_cpu_map *cmap;
 
+	struct bpf_prog *prog;
+
 	/* Queue with potential multi-producers, and single-consumer kthread */
 	struct ptr_ring *queue;
 	struct task_struct *kthread;
@@ -90,7 +98,8 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	/* check sanity of attributes */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
-	    attr->value_size != 4 || attr->map_flags & ~BPF_F_NUMA_NODE)
+	    (attr->value_size != sizeof(struct bpf_cpu_map_entry_value) &&
+	     attr->value_size != 4) || attr->map_flags & ~BPF_F_NUMA_NODE)
 		return ERR_PTR(-EINVAL);
 
 	cmap = kzalloc(sizeof(*cmap), GFP_USER);
@@ -234,11 +243,13 @@ static int cpu_map_kthread_run(void *data)
 	 * kthread_stop signal until queue is empty.
 	 */
 	while (!kthread_should_stop() || !__ptr_ring_empty(rcpu->queue)) {
+		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
 		unsigned int drops = 0, sched = 0;
+		void *xdp_frames[CPUMAP_BATCH];
 		void *frames[CPUMAP_BATCH];
 		void *skbs[CPUMAP_BATCH];
-		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
-		int i, n, m;
+		int i, n, m, nframes = 0;
+		struct bpf_prog *prog;
 
 		/* Release CPU reschedule checks */
 		if (__ptr_ring_empty(rcpu->queue)) {
@@ -259,28 +270,64 @@ static int cpu_map_kthread_run(void *data)
 		 * kthread CPU pinned. Lockless access to ptr_ring
 		 * consume side valid as no-resize allowed of queue.
 		 */
-		n = ptr_ring_consume_batched(rcpu->queue, frames, CPUMAP_BATCH);
+		n = ptr_ring_consume_batched(rcpu->queue, xdp_frames,
+					     CPUMAP_BATCH);
 
+		rcu_read_lock();
+
+		prog = READ_ONCE(rcpu->prog);
 		for (i = 0; i < n; i++) {
-			void *f = frames[i];
+			void *f = xdp_frames[i];
 			struct page *page = virt_to_page(f);
+			struct xdp_frame *xdpf;
+			struct xdp_buff xdp;
+			u32 act;
 
 			/* Bring struct page memory area to curr CPU. Read by
 			 * build_skb_around via page_is_pfmemalloc(), and when
 			 * freed written by page_frag_free call.
 			 */
 			prefetchw(page);
+			if (!prog) {
+				frames[nframes++] = xdp_frames[i];
+				continue;
+			}
+
+			xdpf = f;
+			xdp.data_hard_start = xdpf->data - xdpf->headroom;
+			xdp.data = xdpf->data;
+			xdp.data_end = xdpf->data + xdpf->len;
+			xdp.data_meta = xdpf->data - xdpf->metasize;
+			xdp.frame_sz = xdpf->frame_sz;
+			/* TODO: rxq */
+
+			act = bpf_prog_run_xdp(prog, &xdp);
+			switch (act) {
+			case XDP_PASS:
+				frames[nframes++] = xdp_frames[i];
+				break;
+			default:
+				bpf_warn_invalid_xdp_action(act);
+				/* fallthrough */
+			case XDP_DROP:
+				xdp_return_frame(xdpf);
+				drops++;
+				break;
+			}
 		}
 
-		m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, n, skbs);
+		rcu_read_unlock();
+
+		m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp,
+					  nframes, skbs);
 		if (unlikely(m == 0)) {
-			for (i = 0; i < n; i++)
+			for (i = 0; i < nframes; i++)
 				skbs[i] = NULL; /* effect: xdp_return_frame */
-			drops = n;
+			drops = nframes;
 		}
 
 		local_bh_disable();
-		for (i = 0; i < n; i++) {
+		for (i = 0; i < nframes; i++) {
 			struct xdp_frame *xdpf = frames[i];
 			struct sk_buff *skb = skbs[i];
 			int ret;
@@ -307,8 +354,23 @@ static int cpu_map_kthread_run(void *data)
 	return 0;
 }
 
-static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
-						       int map_id)
+static int __cpu_map_load_bpf_program(struct bpf_cpu_map_entry *rcpu,
+				      u32 prog_id)
+{
+	struct bpf_prog *prog;
+
+	/* TODO attach type */
+	prog = bpf_prog_by_id(prog_id);
+	if (IS_ERR(prog) || prog->type != BPF_PROG_TYPE_XDP)
+		return -EINVAL;
+
+	rcpu->prog = prog;
+
+	return 0;
+}
+
+static struct bpf_cpu_map_entry *
+__cpu_map_entry_alloc(u32 qsize, u32 cpu, int map_id, u32 prog_id)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct bpf_cpu_map_entry *rcpu;
@@ -344,7 +406,7 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
 
 	rcpu->cpu    = cpu;
 	rcpu->map_id = map_id;
-	rcpu->qsize  = qsize;
+	rcpu->value.qsize  = qsize;
 
 	/* Setup kthread */
 	rcpu->kthread = kthread_create_on_node(cpu_map_kthread_run, rcpu, numa,
@@ -355,6 +417,9 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
 	get_cpu_map_entry(rcpu); /* 1-refcnt for being in cmap->cpu_map[] */
 	get_cpu_map_entry(rcpu); /* 1-refcnt for kthread */
 
+	if (prog_id && __cpu_map_load_bpf_program(rcpu, prog_id))
+		goto free_ptr_ring;
+
 	/* Make sure kthread runs on a single CPU */
 	kthread_bind(rcpu->kthread, cpu);
 	wake_up_process(rcpu->kthread);
@@ -414,6 +479,8 @@ static void __cpu_map_entry_replace(struct bpf_cpu_map *cmap,
 
 	old_rcpu = xchg(&cmap->cpu_map[key_cpu], rcpu);
 	if (old_rcpu) {
+		if (old_rcpu->prog)
+			bpf_prog_put(old_rcpu->prog);
 		call_rcu(&old_rcpu->rcu, __cpu_map_entry_free);
 		INIT_WORK(&old_rcpu->kthread_stop_wq, cpu_map_kthread_stop);
 		schedule_work(&old_rcpu->kthread_stop_wq);
@@ -437,12 +504,18 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 			       u64 map_flags)
 {
 	struct bpf_cpu_map *cmap = container_of(map, struct bpf_cpu_map, map);
+	struct bpf_cpu_map_entry_value *elem;
 	struct bpf_cpu_map_entry *rcpu;
-
 	/* Array index key correspond to CPU number */
-	u32 key_cpu = *(u32 *)key;
-	/* Value is the queue size */
-	u32 qsize = *(u32 *)value;
+	u32 qsize, key_cpu = *(u32 *)key, prog_id = 0;
+
+	if (map->value_size == sizeof(*elem)) {
+		elem = (struct bpf_cpu_map_entry_value *)value;
+		qsize = elem->qsize;
+		prog_id = elem->prog_id;
+	} else {
+		qsize = *(u32 *)value;
+	}
 
 	if (unlikely(map_flags > BPF_EXIST))
 		return -EINVAL;
@@ -461,7 +534,7 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 		rcpu = NULL; /* Same as deleting */
 	} else {
 		/* Updating qsize cause re-allocation of bpf_cpu_map_entry */
-		rcpu = __cpu_map_entry_alloc(qsize, key_cpu, map->id);
+		rcpu = __cpu_map_entry_alloc(qsize, key_cpu, map->id, prog_id);
 		if (!rcpu)
 			return -ENOMEM;
 		rcpu->cmap = cmap;
@@ -523,7 +596,7 @@ static void *cpu_map_lookup_elem(struct bpf_map *map, void *key)
 	struct bpf_cpu_map_entry *rcpu =
 		__cpu_map_lookup_elem(map, *(u32 *)key);
 
-	return rcpu ? &rcpu->qsize : NULL;
+	return rcpu ? &rcpu->value.qsize : NULL;
 }
 
 static int cpu_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
-- 
2.26.2

