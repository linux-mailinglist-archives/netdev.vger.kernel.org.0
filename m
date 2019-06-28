Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C87A7596FF
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 11:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfF1JMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 05:12:42 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41771 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfF1JMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 05:12:39 -0400
Received: by mail-ed1-f65.google.com with SMTP id p15so10027941eds.8
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 02:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AP03q8u5eSI4cgd+eOT4WqpHa+HuqxECWtdQleCHxr0=;
        b=mMgA6NylKc+qBxUK7uQ4LHgzOJCEvxqgTlPJPqTZ8nV3ahiLT4iGPovVUud+sgVHgb
         PytTTa5eVr2s18197iFSpPT6TTrJ9dDuSer51dcqQEmIhP6nIRP7M9IHpWKmECwxXzjh
         R1+dwgMyJiBJvIWudSgxYbb2y5iqoaqAmkGUND1DTnGE89RBbxyVrYe467tRS51UOc5c
         aEI/z1eviex+SVAfXoWqInmVz8wPITTrx90JWBOpjb+GAJ410i6pdK4Mpif33HfQE1VS
         CXwtTFt6k6L34rZJn1SZHZiy2djImaexXfA+tUz/+QVj7ZwapD3dvqyolAJvx/1Q/5PJ
         IPNA==
X-Gm-Message-State: APjAAAXGcOuSy6JiRAi0K9voGIMgNmUuCKuLfOtcHBHaa0jRYXrRCfHO
        qilkDV49hbW1ScgCORcprq3Ttg==
X-Google-Smtp-Source: APXvYqy3Rs1XL5gi6KxBvfMZhTyIH4g8nbXu0Y1vSq+xW/vXC9cGvwmRLT7uYA0nl4zC+3yAZM1aFA==
X-Received: by 2002:a17:906:7541:: with SMTP id a1mr7539096ejn.50.1561713155947;
        Fri, 28 Jun 2019 02:12:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id e33sm496785eda.83.2019.06.28.02.12.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:12:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D64A8181CA9; Fri, 28 Jun 2019 11:12:34 +0200 (CEST)
Subject: [PATCH bpf-next v6 2/5] devmap/cpumap: Use flush list instead of
 bitmap
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Fri, 28 Jun 2019 11:12:34 +0200
Message-ID: <156171315481.9468.14671374601304883219.stgit@alrua-x1>
In-Reply-To: <156171315462.9468.3367572649463706996.stgit@alrua-x1>
References: <156171315462.9468.3367572649463706996.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The socket map uses a linked list instead of a bitmap to keep track of
which entries to flush. Do the same for devmap and cpumap, as this means we
don't have to care about the map index when enqueueing things into the
map (and so we can cache the map lookup).

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/cpumap.c |  105 +++++++++++++++++++++++---------------------------
 kernel/bpf/devmap.c |  107 ++++++++++++++++++++++-----------------------------
 net/core/filter.c   |    2 -
 3 files changed, 95 insertions(+), 119 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 8dff08768087..ef49e17ae47c 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -32,14 +32,19 @@
 
 /* General idea: XDP packets getting XDP redirected to another CPU,
  * will maximum be stored/queued for one driver ->poll() call.  It is
- * guaranteed that setting flush bit and flush operation happen on
+ * guaranteed that queueing the frame and the flush operation happen on
  * same CPU.  Thus, cpu_map_flush operation can deduct via this_cpu_ptr()
  * which queue in bpf_cpu_map_entry contains packets.
  */
 
 #define CPU_MAP_BULK_SIZE 8  /* 8 == one cacheline on 64-bit archs */
+struct bpf_cpu_map_entry;
+struct bpf_cpu_map;
+
 struct xdp_bulk_queue {
 	void *q[CPU_MAP_BULK_SIZE];
+	struct list_head flush_node;
+	struct bpf_cpu_map_entry *obj;
 	unsigned int count;
 };
 
@@ -52,6 +57,8 @@ struct bpf_cpu_map_entry {
 	/* XDP can run multiple RX-ring queues, need __percpu enqueue store */
 	struct xdp_bulk_queue __percpu *bulkq;
 
+	struct bpf_cpu_map *cmap;
+
 	/* Queue with potential multi-producers, and single-consumer kthread */
 	struct ptr_ring *queue;
 	struct task_struct *kthread;
@@ -65,23 +72,17 @@ struct bpf_cpu_map {
 	struct bpf_map map;
 	/* Below members specific for map type */
 	struct bpf_cpu_map_entry **cpu_map;
-	unsigned long __percpu *flush_needed;
+	struct list_head __percpu *flush_list;
 };
 
-static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
-			     struct xdp_bulk_queue *bq, bool in_napi_ctx);
-
-static u64 cpu_map_bitmap_size(const union bpf_attr *attr)
-{
-	return BITS_TO_LONGS(attr->max_entries) * sizeof(unsigned long);
-}
+static int bq_flush_to_queue(struct xdp_bulk_queue *bq, bool in_napi_ctx);
 
 static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_cpu_map *cmap;
 	int err = -ENOMEM;
+	int ret, cpu;
 	u64 cost;
-	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -105,7 +106,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	/* make sure page count doesn't overflow */
 	cost = (u64) cmap->map.max_entries * sizeof(struct bpf_cpu_map_entry *);
-	cost += cpu_map_bitmap_size(attr) * num_possible_cpus();
+	cost += sizeof(struct list_head) * num_possible_cpus();
 
 	/* Notice returns -EPERM on if map size is larger than memlock limit */
 	ret = bpf_map_charge_init(&cmap->map.memory, cost);
@@ -114,12 +115,13 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 		goto free_cmap;
 	}
 
-	/* A per cpu bitfield with a bit per possible CPU in map  */
-	cmap->flush_needed = __alloc_percpu(cpu_map_bitmap_size(attr),
-					    __alignof__(unsigned long));
-	if (!cmap->flush_needed)
+	cmap->flush_list = alloc_percpu(struct list_head);
+	if (!cmap->flush_list)
 		goto free_charge;
 
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(per_cpu_ptr(cmap->flush_list, cpu));
+
 	/* Alloc array for possible remote "destination" CPUs */
 	cmap->cpu_map = bpf_map_area_alloc(cmap->map.max_entries *
 					   sizeof(struct bpf_cpu_map_entry *),
@@ -129,7 +131,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	return &cmap->map;
 free_percpu:
-	free_percpu(cmap->flush_needed);
+	free_percpu(cmap->flush_list);
 free_charge:
 	bpf_map_charge_finish(&cmap->map.memory);
 free_cmap:
@@ -334,7 +336,8 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct bpf_cpu_map_entry *rcpu;
-	int numa, err;
+	struct xdp_bulk_queue *bq;
+	int numa, err, i;
 
 	/* Have map->numa_node, but choose node of redirect target CPU */
 	numa = cpu_to_node(cpu);
@@ -349,6 +352,11 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
 	if (!rcpu->bulkq)
 		goto free_rcu;
 
+	for_each_possible_cpu(i) {
+		bq = per_cpu_ptr(rcpu->bulkq, i);
+		bq->obj = rcpu;
+	}
+
 	/* Alloc queue */
 	rcpu->queue = kzalloc_node(sizeof(*rcpu->queue), gfp, numa);
 	if (!rcpu->queue)
@@ -405,7 +413,7 @@ static void __cpu_map_entry_free(struct rcu_head *rcu)
 		struct xdp_bulk_queue *bq = per_cpu_ptr(rcpu->bulkq, cpu);
 
 		/* No concurrent bq_enqueue can run at this point */
-		bq_flush_to_queue(rcpu, bq, false);
+		bq_flush_to_queue(bq, false);
 	}
 	free_percpu(rcpu->bulkq);
 	/* Cannot kthread_stop() here, last put free rcpu resources */
@@ -488,6 +496,7 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 		rcpu = __cpu_map_entry_alloc(qsize, key_cpu, map->id);
 		if (!rcpu)
 			return -ENOMEM;
+		rcpu->cmap = cmap;
 	}
 	rcu_read_lock();
 	__cpu_map_entry_replace(cmap, key_cpu, rcpu);
@@ -514,14 +523,14 @@ static void cpu_map_free(struct bpf_map *map)
 	synchronize_rcu();
 
 	/* To ensure all pending flush operations have completed wait for flush
-	 * bitmap to indicate all flush_needed bits to be zero on _all_ cpus.
-	 * Because the above synchronize_rcu() ensures the map is disconnected
-	 * from the program we can assume no new bits will be set.
+	 * list be empty on _all_ cpus. Because the above synchronize_rcu()
+	 * ensures the map is disconnected from the program we can assume no new
+	 * items will be added to the list.
 	 */
 	for_each_online_cpu(cpu) {
-		unsigned long *bitmap = per_cpu_ptr(cmap->flush_needed, cpu);
+		struct list_head *flush_list = per_cpu_ptr(cmap->flush_list, cpu);
 
-		while (!bitmap_empty(bitmap, cmap->map.max_entries))
+		while (!list_empty(flush_list))
 			cond_resched();
 	}
 
@@ -538,7 +547,7 @@ static void cpu_map_free(struct bpf_map *map)
 		/* bq flush and cleanup happens after RCU graze-period */
 		__cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
 	}
-	free_percpu(cmap->flush_needed);
+	free_percpu(cmap->flush_list);
 	bpf_map_area_free(cmap->cpu_map);
 	kfree(cmap);
 }
@@ -590,9 +599,9 @@ const struct bpf_map_ops cpu_map_ops = {
 	.map_check_btf		= map_check_no_btf,
 };
 
-static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
-			     struct xdp_bulk_queue *bq, bool in_napi_ctx)
+static int bq_flush_to_queue(struct xdp_bulk_queue *bq, bool in_napi_ctx)
 {
+	struct bpf_cpu_map_entry *rcpu = bq->obj;
 	unsigned int processed = 0, drops = 0;
 	const int to_cpu = rcpu->cpu;
 	struct ptr_ring *q;
@@ -621,6 +630,8 @@ static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
 	bq->count = 0;
 	spin_unlock(&q->producer_lock);
 
+	__list_del_clearprev(&bq->flush_node);
+
 	/* Feedback loop via tracepoints */
 	trace_xdp_cpumap_enqueue(rcpu->map_id, processed, drops, to_cpu);
 	return 0;
@@ -631,10 +642,11 @@ static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
  */
 static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 {
+	struct list_head *flush_list = this_cpu_ptr(rcpu->cmap->flush_list);
 	struct xdp_bulk_queue *bq = this_cpu_ptr(rcpu->bulkq);
 
 	if (unlikely(bq->count == CPU_MAP_BULK_SIZE))
-		bq_flush_to_queue(rcpu, bq, true);
+		bq_flush_to_queue(bq, true);
 
 	/* Notice, xdp_buff/page MUST be queued here, long enough for
 	 * driver to code invoking us to finished, due to driver
@@ -646,6 +658,10 @@ static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 	 * operation, when completing napi->poll call.
 	 */
 	bq->q[bq->count++] = xdpf;
+
+	if (!bq->flush_node.prev)
+		list_add(&bq->flush_node, flush_list);
+
 	return 0;
 }
 
@@ -665,41 +681,16 @@ int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 	return 0;
 }
 
-void __cpu_map_insert_ctx(struct bpf_map *map, u32 bit)
-{
-	struct bpf_cpu_map *cmap = container_of(map, struct bpf_cpu_map, map);
-	unsigned long *bitmap = this_cpu_ptr(cmap->flush_needed);
-
-	__set_bit(bit, bitmap);
-}
-
 void __cpu_map_flush(struct bpf_map *map)
 {
 	struct bpf_cpu_map *cmap = container_of(map, struct bpf_cpu_map, map);
-	unsigned long *bitmap = this_cpu_ptr(cmap->flush_needed);
-	u32 bit;
-
-	/* The napi->poll softirq makes sure __cpu_map_insert_ctx()
-	 * and __cpu_map_flush() happen on same CPU. Thus, the percpu
-	 * bitmap indicate which percpu bulkq have packets.
-	 */
-	for_each_set_bit(bit, bitmap, map->max_entries) {
-		struct bpf_cpu_map_entry *rcpu = READ_ONCE(cmap->cpu_map[bit]);
-		struct xdp_bulk_queue *bq;
-
-		/* This is possible if entry is removed by user space
-		 * between xdp redirect and flush op.
-		 */
-		if (unlikely(!rcpu))
-			continue;
-
-		__clear_bit(bit, bitmap);
+	struct list_head *flush_list = this_cpu_ptr(cmap->flush_list);
+	struct xdp_bulk_queue *bq, *tmp;
 
-		/* Flush all frames in bulkq to real queue */
-		bq = this_cpu_ptr(rcpu->bulkq);
-		bq_flush_to_queue(rcpu, bq, true);
+	list_for_each_entry_safe(bq, tmp, flush_list, flush_node) {
+		bq_flush_to_queue(bq, true);
 
 		/* If already running, costs spin_lock_irqsave + smb_mb */
-		wake_up_process(rcpu->kthread);
+		wake_up_process(bq->obj->kthread);
 	}
 }
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 40e86a7e0ef0..a4dddc867cbf 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -17,9 +17,8 @@
  * datapath always has a valid copy. However, the datapath does a "flush"
  * operation that pushes any pending packets in the driver outside the RCU
  * critical section. Each bpf_dtab_netdev tracks these pending operations using
- * an atomic per-cpu bitmap. The bpf_dtab_netdev object will not be destroyed
- * until all bits are cleared indicating outstanding flush operations have
- * completed.
+ * a per-cpu flush list. The bpf_dtab_netdev object will not be destroyed  until
+ * this list is empty, indicating outstanding flush operations have completed.
  *
  * BPF syscalls may race with BPF program calls on any of the update, delete
  * or lookup operations. As noted above the xchg() operation also keep the
@@ -48,9 +47,13 @@
 	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
 
 #define DEV_MAP_BULK_SIZE 16
+struct bpf_dtab_netdev;
+
 struct xdp_bulk_queue {
 	struct xdp_frame *q[DEV_MAP_BULK_SIZE];
+	struct list_head flush_node;
 	struct net_device *dev_rx;
+	struct bpf_dtab_netdev *obj;
 	unsigned int count;
 };
 
@@ -65,23 +68,18 @@ struct bpf_dtab_netdev {
 struct bpf_dtab {
 	struct bpf_map map;
 	struct bpf_dtab_netdev **netdev_map;
-	unsigned long __percpu *flush_needed;
+	struct list_head __percpu *flush_list;
 	struct list_head list;
 };
 
 static DEFINE_SPINLOCK(dev_map_lock);
 static LIST_HEAD(dev_map_list);
 
-static u64 dev_map_bitmap_size(const union bpf_attr *attr)
-{
-	return BITS_TO_LONGS((u64) attr->max_entries) * sizeof(unsigned long);
-}
-
 static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_dtab *dtab;
+	int err, cpu;
 	u64 cost;
-	int err;
 
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -99,7 +97,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 
 	/* make sure page count doesn't overflow */
 	cost = (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *);
-	cost += dev_map_bitmap_size(attr) * num_possible_cpus();
+	cost += sizeof(struct list_head) * num_possible_cpus();
 
 	/* if map size is larger than memlock limit, reject it */
 	err = bpf_map_charge_init(&dtab->map.memory, cost);
@@ -108,28 +106,30 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 
 	err = -ENOMEM;
 
-	/* A per cpu bitfield with a bit per possible net device */
-	dtab->flush_needed = __alloc_percpu_gfp(dev_map_bitmap_size(attr),
-						__alignof__(unsigned long),
-						GFP_KERNEL | __GFP_NOWARN);
-	if (!dtab->flush_needed)
+	dtab->flush_list = alloc_percpu(struct list_head);
+	if (!dtab->flush_list)
 		goto free_charge;
 
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(per_cpu_ptr(dtab->flush_list, cpu));
+
 	dtab->netdev_map = bpf_map_area_alloc(dtab->map.max_entries *
 					      sizeof(struct bpf_dtab_netdev *),
 					      dtab->map.numa_node);
 	if (!dtab->netdev_map)
-		goto free_charge;
+		goto free_percpu;
 
 	spin_lock(&dev_map_lock);
 	list_add_tail_rcu(&dtab->list, &dev_map_list);
 	spin_unlock(&dev_map_lock);
 
 	return &dtab->map;
+
+free_percpu:
+	free_percpu(dtab->flush_list);
 free_charge:
 	bpf_map_charge_finish(&dtab->map.memory);
 free_dtab:
-	free_percpu(dtab->flush_needed);
 	kfree(dtab);
 	return ERR_PTR(err);
 }
@@ -158,14 +158,14 @@ static void dev_map_free(struct bpf_map *map)
 	rcu_barrier();
 
 	/* To ensure all pending flush operations have completed wait for flush
-	 * bitmap to indicate all flush_needed bits to be zero on _all_ cpus.
+	 * list to empty on _all_ cpus.
 	 * Because the above synchronize_rcu() ensures the map is disconnected
-	 * from the program we can assume no new bits will be set.
+	 * from the program we can assume no new items will be added.
 	 */
 	for_each_online_cpu(cpu) {
-		unsigned long *bitmap = per_cpu_ptr(dtab->flush_needed, cpu);
+		struct list_head *flush_list = per_cpu_ptr(dtab->flush_list, cpu);
 
-		while (!bitmap_empty(bitmap, dtab->map.max_entries))
+		while (!list_empty(flush_list))
 			cond_resched();
 	}
 
@@ -181,7 +181,7 @@ static void dev_map_free(struct bpf_map *map)
 		kfree(dev);
 	}
 
-	free_percpu(dtab->flush_needed);
+	free_percpu(dtab->flush_list);
 	bpf_map_area_free(dtab->netdev_map);
 	kfree(dtab);
 }
@@ -203,18 +203,10 @@ static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	return 0;
 }
 
-void __dev_map_insert_ctx(struct bpf_map *map, u32 bit)
-{
-	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	unsigned long *bitmap = this_cpu_ptr(dtab->flush_needed);
-
-	__set_bit(bit, bitmap);
-}
-
-static int bq_xmit_all(struct bpf_dtab_netdev *obj,
-		       struct xdp_bulk_queue *bq, u32 flags,
+static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags,
 		       bool in_napi_ctx)
 {
+	struct bpf_dtab_netdev *obj = bq->obj;
 	struct net_device *dev = obj->dev;
 	int sent = 0, drops = 0, err = 0;
 	int i;
@@ -241,6 +233,7 @@ static int bq_xmit_all(struct bpf_dtab_netdev *obj,
 	trace_xdp_devmap_xmit(&obj->dtab->map, obj->bit,
 			      sent, drops, bq->dev_rx, dev, err);
 	bq->dev_rx = NULL;
+	__list_del_clearprev(&bq->flush_node);
 	return 0;
 error:
 	/* If ndo_xdp_xmit fails with an errno, no frames have been
@@ -263,31 +256,18 @@ static int bq_xmit_all(struct bpf_dtab_netdev *obj,
  * from the driver before returning from its napi->poll() routine. The poll()
  * routine is called either from busy_poll context or net_rx_action signaled
  * from NET_RX_SOFTIRQ. Either way the poll routine must complete before the
- * net device can be torn down. On devmap tear down we ensure the ctx bitmap
- * is zeroed before completing to ensure all flush operations have completed.
+ * net device can be torn down. On devmap tear down we ensure the flush list
+ * is empty before completing to ensure all flush operations have completed.
  */
 void __dev_map_flush(struct bpf_map *map)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	unsigned long *bitmap = this_cpu_ptr(dtab->flush_needed);
-	u32 bit;
+	struct list_head *flush_list = this_cpu_ptr(dtab->flush_list);
+	struct xdp_bulk_queue *bq, *tmp;
 
 	rcu_read_lock();
-	for_each_set_bit(bit, bitmap, map->max_entries) {
-		struct bpf_dtab_netdev *dev = READ_ONCE(dtab->netdev_map[bit]);
-		struct xdp_bulk_queue *bq;
-
-		/* This is possible if the dev entry is removed by user space
-		 * between xdp redirect and flush op.
-		 */
-		if (unlikely(!dev))
-			continue;
-
-		bq = this_cpu_ptr(dev->bulkq);
-		bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, true);
-
-		__clear_bit(bit, bitmap);
-	}
+	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
+		bq_xmit_all(bq, XDP_XMIT_FLUSH, true);
 	rcu_read_unlock();
 }
 
@@ -314,10 +294,11 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf,
 		      struct net_device *dev_rx)
 
 {
+	struct list_head *flush_list = this_cpu_ptr(obj->dtab->flush_list);
 	struct xdp_bulk_queue *bq = this_cpu_ptr(obj->bulkq);
 
 	if (unlikely(bq->count == DEV_MAP_BULK_SIZE))
-		bq_xmit_all(obj, bq, 0, true);
+		bq_xmit_all(bq, 0, true);
 
 	/* Ingress dev_rx will be the same for all xdp_frame's in
 	 * bulk_queue, because bq stored per-CPU and must be flushed
@@ -327,6 +308,10 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf,
 		bq->dev_rx = dev_rx;
 
 	bq->q[bq->count++] = xdpf;
+
+	if (!bq->flush_node.prev)
+		list_add(&bq->flush_node, flush_list);
+
 	return 0;
 }
 
@@ -377,17 +362,12 @@ static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
 {
 	if (dev->dev->netdev_ops->ndo_xdp_xmit) {
 		struct xdp_bulk_queue *bq;
-		unsigned long *bitmap;
-
 		int cpu;
 
 		rcu_read_lock();
 		for_each_online_cpu(cpu) {
-			bitmap = per_cpu_ptr(dev->dtab->flush_needed, cpu);
-			__clear_bit(dev->bit, bitmap);
-
 			bq = per_cpu_ptr(dev->bulkq, cpu);
-			bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, false);
+			bq_xmit_all(bq, XDP_XMIT_FLUSH, false);
 		}
 		rcu_read_unlock();
 	}
@@ -434,8 +414,10 @@ static int dev_map_update_elem(struct bpf_map *map, void *key, void *value,
 	struct net *net = current->nsproxy->net_ns;
 	gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN;
 	struct bpf_dtab_netdev *dev, *old_dev;
-	u32 i = *(u32 *)key;
 	u32 ifindex = *(u32 *)value;
+	struct xdp_bulk_queue *bq;
+	u32 i = *(u32 *)key;
+	int cpu;
 
 	if (unlikely(map_flags > BPF_EXIST))
 		return -EINVAL;
@@ -458,6 +440,11 @@ static int dev_map_update_elem(struct bpf_map *map, void *key, void *value,
 			return -ENOMEM;
 		}
 
+		for_each_possible_cpu(cpu) {
+			bq = per_cpu_ptr(dev->bulkq, cpu);
+			bq->obj = dev;
+		}
+
 		dev->dev = dev_get_by_index(net, ifindex);
 		if (!dev->dev) {
 			free_percpu(dev->bulkq);
diff --git a/net/core/filter.c b/net/core/filter.c
index 2014d76e0d2a..183bf4d8e301 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3523,7 +3523,6 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 		err = dev_map_enqueue(dst, xdp, dev_rx);
 		if (unlikely(err))
 			return err;
-		__dev_map_insert_ctx(map, index);
 		break;
 	}
 	case BPF_MAP_TYPE_CPUMAP: {
@@ -3532,7 +3531,6 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 		err = cpu_map_enqueue(rcpu, xdp, dev_rx);
 		if (unlikely(err))
 			return err;
-		__cpu_map_insert_ctx(map, index);
 		break;
 	}
 	case BPF_MAP_TYPE_XSKMAP: {

