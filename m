Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57FE207783
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 17:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404561AbgFXPes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 11:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404107AbgFXPer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 11:34:47 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24C67206FA;
        Wed, 24 Jun 2020 15:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593012886;
        bh=gu003s1kOx2vFmSU2IwDenfc7VG62A96O7cT4LXLTLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vWN61VWmv8ldUFkbWxZPc/2+6ePX3UyoJ+LVUEA5Rmzl5OJNMtc7DN5e+4nB2aNH
         e0YgAoZGUVGZHv4kC21Eq/+oCwi13fPTihqpJ3Mu0PCBqi+ptVa43Hfy4WIwAOjgn3
         Rrer1EdG5mVZ4A4ckKYrKkQRFhINph9NrdoEjtB0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com
Subject: [PATCH v4 bpf-next 5/9] bpf: cpumap: add the possibility to attach an eBPF program to cpumap
Date:   Wed, 24 Jun 2020 17:33:54 +0200
Message-Id: <9645b21a225d0fde3242cfa0d29a933b5dce8aaf.1593012598.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593012598.git.lorenzo@kernel.org>
References: <cover.1593012598.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to attach an eBPF program to cpumap entries.
The idea behind this feature is to add the possibility to define on
which CPU run the eBPF program if the underlying hw does not support
RSS. Current supported verdicts are XDP_DROP and XDP_PASS.

This patch has been tested on Marvell ESPRESSObin using xdp_redirect_cpu
sample available in the kernel tree to identify possible performance
regressions. Results show there are no observable differences in
packet-per-second:

$./xdp_redirect_cpu --progname xdp_cpu_map0 --dev eth0 --cpu 1
rx: 354.8 Kpps
rx: 356.0 Kpps
rx: 356.8 Kpps
rx: 356.3 Kpps
rx: 356.6 Kpps
rx: 356.6 Kpps
rx: 356.7 Kpps
rx: 355.8 Kpps
rx: 356.8 Kpps
rx: 356.8 Kpps

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/bpf.h            |   6 ++
 include/net/xdp.h              |   5 ++
 include/trace/events/xdp.h     |  14 ++--
 include/uapi/linux/bpf.h       |   5 ++
 kernel/bpf/cpumap.c            | 122 +++++++++++++++++++++++++++++----
 net/core/dev.c                 |   8 +++
 tools/include/uapi/linux/bpf.h |   5 ++
 7 files changed, 148 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1e1501ee53ce..759f280265d0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1265,6 +1265,7 @@ struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key);
 void __cpu_map_flush(void);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
+bool cpu_map_prog_allowed(struct bpf_map *map);
 
 /* Return map's numa specified by userspace */
 static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
@@ -1425,6 +1426,11 @@ static inline int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu,
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
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 5b383c450858..83b9e0142b52 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -98,6 +98,11 @@ struct xdp_frame {
 	struct net_device *dev_rx; /* used by cpumap */
 };
 
+struct xdp_cpumap_stats {
+	unsigned int pass;
+	unsigned int drop;
+};
+
 /* Clear kernel pointers in xdp_frame */
 static inline void xdp_scrub_frame(struct xdp_frame *frame)
 {
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index b73d3e141323..e2c99f5bee39 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -177,9 +177,9 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map_err,
 TRACE_EVENT(xdp_cpumap_kthread,
 
 	TP_PROTO(int map_id, unsigned int processed,  unsigned int drops,
-		 int sched),
+		 int sched, struct xdp_cpumap_stats *xdp_stats),
 
-	TP_ARGS(map_id, processed, drops, sched),
+	TP_ARGS(map_id, processed, drops, sched, xdp_stats),
 
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
+		__entry->xdp_pass	= xdp_stats->pass;
+		__entry->xdp_drop	= xdp_stats->drop;
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
index fa3b342985f9..856c8db22517 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -226,6 +226,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET4_GETSOCKNAME,
 	BPF_CGROUP_INET6_GETSOCKNAME,
 	BPF_XDP_DEVMAP,
+	BPF_XDP_CPUMAP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3781,6 +3782,10 @@ struct bpf_devmap_val {
  */
 struct bpf_cpumap_val {
 	__u32 qsize;	/* queue size to remote target CPU */
+	union {
+		int   fd;	/* prog fd on map write */
+		__u32 id;	/* prog id on map read */
+	} bpf_prog;
 };
 
 enum sk_action {
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 7e8eec4f7089..4e4cd240f07b 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -67,6 +67,7 @@ struct bpf_cpu_map_entry {
 	struct rcu_head rcu;
 
 	struct bpf_cpumap_val value;
+	struct bpf_prog *prog;
 };
 
 struct bpf_cpu_map {
@@ -81,6 +82,7 @@ static int bq_flush_to_queue(struct xdp_bulk_queue *bq);
 
 static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 {
+	u32 value_size = attr->value_size;
 	struct bpf_cpu_map *cmap;
 	int err = -ENOMEM;
 	u64 cost;
@@ -91,7 +93,9 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	/* check sanity of attributes */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
-	    attr->value_size != 4 || attr->map_flags & ~BPF_F_NUMA_NODE)
+	    (value_size != offsetofend(struct bpf_cpumap_val, qsize) &&
+	     value_size != offsetofend(struct bpf_cpumap_val, bpf_prog.fd)) ||
+	    attr->map_flags & ~BPF_F_NUMA_NODE)
 		return ERR_PTR(-EINVAL);
 
 	cmap = kzalloc(sizeof(*cmap), GFP_USER);
@@ -221,6 +225,63 @@ static void put_cpu_map_entry(struct bpf_cpu_map_entry *rcpu)
 	}
 }
 
+static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
+				    void **frames, int n,
+				    struct xdp_cpumap_stats *stats)
+{
+	struct xdp_rxq_info rxq;
+	struct bpf_prog *prog;
+	struct xdp_buff xdp;
+	int i, nframes = 0;
+
+	if (!rcpu->prog)
+		return n;
+
+	xdp_set_return_frame_no_direct();
+	xdp.rxq = &rxq;
+
+	rcu_read_lock();
+
+	prog = READ_ONCE(rcpu->prog);
+	for (i = 0; i < n; i++) {
+		struct xdp_frame *xdpf = frames[i];
+		u32 act;
+		int err;
+
+		rxq.dev = xdpf->dev_rx;
+		rxq.mem = xdpf->mem;
+		/* TODO: report queue_index to xdp_rxq_info */
+
+		xdp_convert_frame_to_buff(xdpf, &xdp);
+
+		act = bpf_prog_run_xdp(prog, &xdp);
+		switch (act) {
+		case XDP_PASS:
+			err = xdp_update_frame_from_buff(&xdp, xdpf);
+			if (err < 0) {
+				xdp_return_frame(xdpf);
+				stats->drop++;
+			} else {
+				frames[nframes++] = xdpf;
+				stats->pass++;
+			}
+			break;
+		default:
+			bpf_warn_invalid_xdp_action(act);
+			/* fallthrough */
+		case XDP_DROP:
+			xdp_return_frame(xdpf);
+			stats->drop++;
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+	xdp_clear_return_frame_no_direct();
+
+	return nframes;
+}
+
 #define CPUMAP_BATCH 8
 
 static int cpu_map_kthread_run(void *data)
@@ -235,11 +296,12 @@ static int cpu_map_kthread_run(void *data)
 	 * kthread_stop signal until queue is empty.
 	 */
 	while (!kthread_should_stop() || !__ptr_ring_empty(rcpu->queue)) {
+		struct xdp_cpumap_stats stats = {}; /* zero stats */
+		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
 		unsigned int drops = 0, sched = 0;
 		void *frames[CPUMAP_BATCH];
 		void *skbs[CPUMAP_BATCH];
-		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
-		int i, n, m;
+		int i, n, m, nframes;
 
 		/* Release CPU reschedule checks */
 		if (__ptr_ring_empty(rcpu->queue)) {
@@ -260,8 +322,8 @@ static int cpu_map_kthread_run(void *data)
 		 * kthread CPU pinned. Lockless access to ptr_ring
 		 * consume side valid as no-resize allowed of queue.
 		 */
-		n = __ptr_ring_consume_batched(rcpu->queue, frames, CPUMAP_BATCH);
-
+		n = __ptr_ring_consume_batched(rcpu->queue, frames,
+					       CPUMAP_BATCH);
 		for (i = 0; i < n; i++) {
 			void *f = frames[i];
 			struct page *page = virt_to_page(f);
@@ -273,15 +335,19 @@ static int cpu_map_kthread_run(void *data)
 			prefetchw(page);
 		}
 
-		m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, n, skbs);
-		if (unlikely(m == 0)) {
-			for (i = 0; i < n; i++)
-				skbs[i] = NULL; /* effect: xdp_return_frame */
-			drops = n;
+		/* Support running another XDP prog on this CPU */
+		nframes = cpu_map_bpf_prog_run_xdp(rcpu, frames, n, &stats);
+		if (nframes) {
+			m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, nframes, skbs);
+			if (unlikely(m == 0)) {
+				for (i = 0; i < nframes; i++)
+					skbs[i] = NULL; /* effect: xdp_return_frame */
+				drops += nframes;
+			}
 		}
 
 		local_bh_disable();
-		for (i = 0; i < n; i++) {
+		for (i = 0; i < nframes; i++) {
 			struct xdp_frame *xdpf = frames[i];
 			struct sk_buff *skb = skbs[i];
 			int ret;
@@ -298,7 +364,7 @@ static int cpu_map_kthread_run(void *data)
 				drops++;
 		}
 		/* Feedback loop via tracepoint */
-		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched);
+		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched, &stats);
 
 		local_bh_enable(); /* resched point, may call do_softirq() */
 	}
@@ -308,13 +374,38 @@ static int cpu_map_kthread_run(void *data)
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
+	rcpu->value.bpf_prog.id = prog->aux->id;
+	rcpu->prog = prog;
+
+	return 0;
+}
+
 static struct bpf_cpu_map_entry *
 __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
 {
+	int numa, err, i, fd = value->bpf_prog.fd;
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct bpf_cpu_map_entry *rcpu;
 	struct xdp_bulk_queue *bq;
-	int numa, err, i;
 
 	/* Have map->numa_node, but choose node of redirect target CPU */
 	numa = cpu_to_node(cpu);
@@ -356,6 +447,9 @@ __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
 	get_cpu_map_entry(rcpu); /* 1-refcnt for being in cmap->cpu_map[] */
 	get_cpu_map_entry(rcpu); /* 1-refcnt for kthread */
 
+	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, fd))
+		goto free_ptr_ring;
+
 	/* Make sure kthread runs on a single CPU */
 	kthread_bind(rcpu->kthread, cpu);
 	wake_up_process(rcpu->kthread);
@@ -415,6 +509,8 @@ static void __cpu_map_entry_replace(struct bpf_cpu_map *cmap,
 
 	old_rcpu = xchg(&cmap->cpu_map[key_cpu], rcpu);
 	if (old_rcpu) {
+		if (old_rcpu->prog)
+			bpf_prog_put(old_rcpu->prog);
 		call_rcu(&old_rcpu->rcu, __cpu_map_entry_free);
 		INIT_WORK(&old_rcpu->kthread_stop_wq, cpu_map_kthread_stop);
 		schedule_work(&old_rcpu->kthread_stop_wq);
diff --git a/net/core/dev.c b/net/core/dev.c
index 6bc2388141f6..2867df05cf82 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5440,6 +5440,8 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 		for (i = 0; i < new->aux->used_map_cnt; i++) {
 			if (dev_map_can_have_prog(new->aux->used_maps[i]))
 				return -EINVAL;
+			if (cpu_map_prog_allowed(new->aux->used_maps[i]))
+				return -EINVAL;
 		}
 	}
 
@@ -8864,6 +8866,12 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
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
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index fa3b342985f9..856c8db22517 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -226,6 +226,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET4_GETSOCKNAME,
 	BPF_CGROUP_INET6_GETSOCKNAME,
 	BPF_XDP_DEVMAP,
+	BPF_XDP_CPUMAP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3781,6 +3782,10 @@ struct bpf_devmap_val {
  */
 struct bpf_cpumap_val {
 	__u32 qsize;	/* queue size to remote target CPU */
+	union {
+		int   fd;	/* prog fd on map write */
+		__u32 id;	/* prog id on map read */
+	} bpf_prog;
 };
 
 enum sk_action {
-- 
2.26.2

