Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B121E9A9A
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 23:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgEaVrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 17:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbgEaVro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 17:47:44 -0400
Received: from lore-desk.lan (unknown [151.48.128.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28EA420707;
        Sun, 31 May 2020 21:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590961663;
        bh=VDhhbsDMHu2r0TmrcmhRF+R1qdtCEYevimTO8kZzLLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0/HadfDj4u7gCRNzdoCGJT5P7tpmOaf1k2c1zGG63/Xw40eq471eTU7Jt9Y7UVG1
         U4JjHeahsmaWTGB1LcexT5AoHj+BpZUMBMMtgi51ovdw5oVg+hfcrLOR1SXYF4tXiP
         IKQczCmiRKKJyXnvwAB0VXZIVHY7yHLzKyg/e26E=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH bpf-next 4/6] bpf: cpumap: add the possibility to attach an eBPF program to cpumap
Date:   Sun, 31 May 2020 23:46:49 +0200
Message-Id: <2543519aa9cdb368504cb6043fad6cae6f6ec745.1590960613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1590960613.git.lorenzo@kernel.org>
References: <cover.1590960613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to attach an eBPF program to cpumap entries.
The idea behind this feature is to add the possibility to define on
which CPU run the eBPF program if the underlying hw does not support
RSS. Current supported verdicts are XDP_DROP and XDP_PASS

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/bpf.h            |   6 ++
 include/trace/events/xdp.h     |  14 +++--
 include/uapi/linux/bpf.h       |   1 +
 kernel/bpf/cpumap.c            | 106 +++++++++++++++++++++++++++++----
 net/core/dev.c                 |   8 +++
 net/core/filter.c              |   7 +++
 tools/include/uapi/linux/bpf.h |   1 +
 7 files changed, 128 insertions(+), 15 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e042311f991f..d5bbcdcc8321 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1256,6 +1256,7 @@ struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key);
 void __cpu_map_flush(void);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
+bool cpu_map_prog_allowed(struct bpf_map *map);
 
 /* Return map's numa specified by userspace */
 static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
@@ -1416,6 +1417,11 @@ static inline int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu,
 	return 0;
 }
 
+static inline bool cpu_map_prog_allowed(struct bpf_map *map)
+{
+	return false;
+}
+
 static inline struct bpf_prog *bpf_prog_get_type_path(const char *name,
 				enum bpf_prog_type type)
 {
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index b73d3e141323..06ec557c6bf5 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -177,9 +177,9 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map_err,
 TRACE_EVENT(xdp_cpumap_kthread,
 
 	TP_PROTO(int map_id, unsigned int processed,  unsigned int drops,
-		 int sched),
+		 int sched, unsigned int xdp_pass, unsigned int xdp_drop),
 
-	TP_ARGS(map_id, processed, drops, sched),
+	TP_ARGS(map_id, processed, drops, sched, xdp_pass, xdp_drop),
 
 	TP_STRUCT__entry(
 		__field(int, map_id)
@@ -188,6 +188,8 @@ TRACE_EVENT(xdp_cpumap_kthread,
 		__field(unsigned int, drops)
 		__field(unsigned int, processed)
 		__field(int, sched)
+		__field(unsigned int, xdp_pass)
+		__field(unsigned int, xdp_drop)
 	),
 
 	TP_fast_assign(
@@ -197,16 +199,20 @@ TRACE_EVENT(xdp_cpumap_kthread,
 		__entry->drops		= drops;
 		__entry->processed	= processed;
 		__entry->sched	= sched;
+		__entry->xdp_pass	= xdp_pass;
+		__entry->xdp_drop	= xdp_drop;
 	),
 
 	TP_printk("kthread"
 		  " cpu=%d map_id=%d action=%s"
 		  " processed=%u drops=%u"
-		  " sched=%d",
+		  " sched=%d"
+		  " xdp_pass=%u xdp_drop=%u",
 		  __entry->cpu, __entry->map_id,
 		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
 		  __entry->processed, __entry->drops,
-		  __entry->sched)
+		  __entry->sched,
+		  __entry->xdp_pass, __entry->xdp_drop)
 );
 
 TRACE_EVENT(xdp_cpumap_enqueue,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f74bc4a2385e..10158943c0db 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -226,6 +226,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET4_GETSOCKNAME,
 	BPF_CGROUP_INET6_GETSOCKNAME,
 	BPF_XDP_DEVMAP,
+	BPF_XDP_CPUMAP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 57402276d8af..24ab0a6b9772 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -51,6 +51,10 @@ struct xdp_bulk_queue {
 /* CPUMAP value */
 struct bpf_cpumap_val {
 	u32 qsize;	/* queue size */
+	union {
+		int fd;	/* program file descriptor */
+		u32 id;	/* program id */
+	} prog;
 };
 
 /* Struct for every remote "destination" CPU in map */
@@ -72,6 +76,7 @@ struct bpf_cpu_map_entry {
 	struct rcu_head rcu;
 
 	struct bpf_cpumap_val value;
+	struct bpf_prog *prog;
 };
 
 struct bpf_cpu_map {
@@ -86,6 +91,7 @@ static int bq_flush_to_queue(struct xdp_bulk_queue *bq);
 
 static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 {
+	u32 value_size = attr->value_size;
 	struct bpf_cpu_map *cmap;
 	int err = -ENOMEM;
 	u64 cost;
@@ -96,7 +102,9 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	/* check sanity of attributes */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
-	    attr->value_size != 4 || attr->map_flags & ~BPF_F_NUMA_NODE)
+	    (value_size != offsetofend(struct bpf_cpumap_val, qsize) &&
+	     value_size != offsetofend(struct bpf_cpumap_val, prog.fd)) ||
+	    attr->map_flags & ~BPF_F_NUMA_NODE)
 		return ERR_PTR(-EINVAL);
 
 	cmap = kzalloc(sizeof(*cmap), GFP_USER);
@@ -240,11 +248,14 @@ static int cpu_map_kthread_run(void *data)
 	 * kthread_stop signal until queue is empty.
 	 */
 	while (!kthread_should_stop() || !__ptr_ring_empty(rcpu->queue)) {
+		unsigned int xdp_pass = 0, xdp_drop = 0;
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
@@ -265,28 +276,67 @@ static int cpu_map_kthread_run(void *data)
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
+			int err;
 
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
+			xdp_convert_frame_to_buff(xdpf, &xdp);
+
+			act = bpf_prog_run_xdp(prog, &xdp);
+			switch (act) {
+			case XDP_PASS:
+				err = xdp_update_frame_from_buff(&xdp, xdpf);
+				if (err < 0) {
+					xdp_return_frame(xdpf);
+					drops++;
+				} else {
+					frames[nframes++] = xdpf;
+					xdp_pass++;
+				}
+				break;
+			default:
+				bpf_warn_invalid_xdp_action(act);
+				/* fallthrough */
+			case XDP_DROP:
+				xdp_return_frame(xdpf);
+				xdp_drop++;
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
+			drops += nframes;
 		}
 
 		local_bh_disable();
-		for (i = 0; i < n; i++) {
+		for (i = 0; i < nframes; i++) {
 			struct xdp_frame *xdpf = frames[i];
 			struct sk_buff *skb = skbs[i];
 			int ret;
@@ -303,7 +353,8 @@ static int cpu_map_kthread_run(void *data)
 				drops++;
 		}
 		/* Feedback loop via tracepoint */
-		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched);
+		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched,
+					 xdp_pass, xdp_drop);
 
 		local_bh_enable(); /* resched point, may call do_softirq() */
 	}
@@ -313,11 +364,37 @@ static int cpu_map_kthread_run(void *data)
 	return 0;
 }
 
+bool cpu_map_prog_allowed(struct bpf_map *map)
+{
+	return map->map_type == BPF_MAP_TYPE_CPUMAP &&
+	       map->value_size != offsetofend(struct bpf_cpumap_val, qsize);
+}
+
+static int __cpu_map_load_bpf_program(struct bpf_cpu_map_entry *rcpu, int fd)
+{
+	struct bpf_prog *prog;
+
+	prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP, false);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	if (prog->expected_attach_type != BPF_XDP_CPUMAP) {
+		bpf_prog_put(prog);
+		return -EINVAL;
+	}
+
+	rcpu->value.prog.id = prog->aux->id;
+	rcpu->prog = prog;
+
+	return 0;
+}
+
 static struct bpf_cpu_map_entry *
 __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct bpf_cpu_map_entry *rcpu;
+	int prog_fd = value->prog.fd;
 	struct xdp_bulk_queue *bq;
 	int numa, err, i;
 
@@ -361,6 +438,9 @@ __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
 	get_cpu_map_entry(rcpu); /* 1-refcnt for being in cmap->cpu_map[] */
 	get_cpu_map_entry(rcpu); /* 1-refcnt for kthread */
 
+	if (prog_fd >= 0 && __cpu_map_load_bpf_program(rcpu, prog_fd))
+		goto free_ptr_ring;
+
 	/* Make sure kthread runs on a single CPU */
 	kthread_bind(rcpu->kthread, cpu);
 	wake_up_process(rcpu->kthread);
@@ -420,6 +500,8 @@ static void __cpu_map_entry_replace(struct bpf_cpu_map *cmap,
 
 	old_rcpu = xchg(&cmap->cpu_map[key_cpu], rcpu);
 	if (old_rcpu) {
+		if (old_rcpu->prog)
+			bpf_prog_put(old_rcpu->prog);
 		call_rcu(&old_rcpu->rcu, __cpu_map_entry_free);
 		INIT_WORK(&old_rcpu->kthread_stop_wq, cpu_map_kthread_stop);
 		schedule_work(&old_rcpu->kthread_stop_wq);
@@ -443,7 +525,9 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 			       u64 map_flags)
 {
 	struct bpf_cpu_map *cmap = container_of(map, struct bpf_cpu_map, map);
-	struct bpf_cpumap_val cpumap_value = {};
+	struct bpf_cpumap_val cpumap_value = {
+		.prog.fd = -1,
+	};
 	struct bpf_cpu_map_entry *rcpu;
 	/* Array index key correspond to CPU number */
 	u32 key_cpu = *(u32 *)key;
diff --git a/net/core/dev.c b/net/core/dev.c
index 10684833f864..4b95adaa4641 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5429,6 +5429,8 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 		for (i = 0; i < new->aux->used_map_cnt; i++) {
 			if (dev_map_can_have_prog(new->aux->used_maps[i]))
 				return -EINVAL;
+			if (cpu_map_prog_allowed(new->aux->used_maps[i]))
+				return -EINVAL;
 		}
 	}
 
@@ -8853,6 +8855,12 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return -EINVAL;
 		}
 
+		if (prog->expected_attach_type == BPF_XDP_CPUMAP) {
+			NL_SET_ERR_MSG(extack, "BPF_XDP_CPUMAP programs can not be attached to a device");
+			bpf_prog_put(prog);
+			return -EINVAL;
+		}
+
 		/* prog->aux->id may be 0 for orphaned device-bound progs */
 		if (prog->aux->id && prog->aux->id == prog_id) {
 			bpf_prog_put(prog);
diff --git a/net/core/filter.c b/net/core/filter.c
index 2e9dbfd8e60c..0c748c95179e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7021,6 +7021,13 @@ static bool xdp_is_valid_access(int off, int size,
 		}
 	}
 
+	if (prog->expected_attach_type == BPF_XDP_CPUMAP) {
+		switch (off) {
+		case offsetof(struct xdp_md, ingress_ifindex):
+			return false;
+		}
+	}
+
 	if (type == BPF_WRITE) {
 		if (bpf_prog_is_dev_bound(prog->aux)) {
 			switch (off) {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f74bc4a2385e..10158943c0db 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -226,6 +226,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET4_GETSOCKNAME,
 	BPF_CGROUP_INET6_GETSOCKNAME,
 	BPF_XDP_DEVMAP,
+	BPF_XDP_CPUMAP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.26.2

