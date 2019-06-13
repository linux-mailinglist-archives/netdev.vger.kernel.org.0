Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E01543B92
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbfFMPaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:30:07 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35551 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbfFMLRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 07:17:25 -0400
Received: by mail-ed1-f66.google.com with SMTP id p26so26615059edr.2
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 04:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sZl0oLi7GY7/Db/ftie1D8URfO4L3GMi7+p5zlBirmw=;
        b=HnThAGJy+l/swlVDLETvLpAs/cXebhVo0iW7QPnV7dmmWCLVKbanSAHP88a07QUVN4
         wcbUapVUuzNMhpaHCn3LjIQ2KhC8p3tF4mT7EAckBhNg2BSUhF4mnLmOjsDP6Eap6PVu
         j7tJ2/DeZ3GgweihrU98QNg9GzMynI1xvYQXbobX1whdhZewCAQMShgj7JuSpjjBtG+W
         M433Qgp/bYj2HDHis/dANjqnzoRM70vexAXnudHRyDS0u+lfd7AtKI6ZmhGbHpOX7+mV
         nEIDQOKxCLFHd44Uu4Mo4OWROV/ovt+/fvOQt6pwMVZaSQ2Luv1KU0sPuu5qAMqnf865
         6syg==
X-Gm-Message-State: APjAAAVWibt0lpVzPuDPMWMebHXqq3JAEt0wjByUlS+/vWpG+LPeGLcB
        InaKUQXNFalhRBolZCUqBy/CqhVFH10=
X-Google-Smtp-Source: APXvYqysj2+moTj0VgqKEEvHd+h5TKkij/lSbpBpoGfn7+pxLPM4JUEu5DN2cwQPO87w30gD4Sw2sw==
X-Received: by 2002:a17:906:5512:: with SMTP id r18mr76720512ejp.298.1560424642763;
        Thu, 13 Jun 2019 04:17:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id s57sm806182edd.54.2019.06.13.04.17.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 04:17:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 876361804B0; Thu, 13 Jun 2019 13:17:21 +0200 (CEST)
Subject: [PATCH bpf-next v4 1/3] devmap/cpumap: Use flush list instead of
 bitmap
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Thu, 13 Jun 2019 13:17:21 +0200
Message-ID: <156042464148.25684.11881534392137955942.stgit@alrua-x1>
In-Reply-To: <156042464138.25684.15061870566905680617.stgit@alrua-x1>
References: <156042464138.25684.15061870566905680617.stgit@alrua-x1>
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
---
 kernel/bpf/cpumap.c |  106 +++++++++++++++++++++++----------------------------
 kernel/bpf/devmap.c |  107 +++++++++++++++++++++++----------------------------
 net/core/filter.c   |    2 -
 3 files changed, 97 insertions(+), 118 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index b31a71909307..a8dc49b04e9b 100644
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
@@ -331,7 +333,8 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct bpf_cpu_map_entry *rcpu;
-	int numa, err;
+	struct xdp_bulk_queue *bq;
+	int numa, err, i;
 
 	/* Have map->numa_node, but choose node of redirect target CPU */
 	numa = cpu_to_node(cpu);
@@ -346,6 +349,11 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
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
@@ -402,7 +410,7 @@ static void __cpu_map_entry_free(struct rcu_head *rcu)
 		struct xdp_bulk_queue *bq = per_cpu_ptr(rcpu->bulkq, cpu);
 
 		/* No concurrent bq_enqueue can run at this point */
-		bq_flush_to_queue(rcpu, bq, false);
+		bq_flush_to_queue(bq, false);
 	}
 	free_percpu(rcpu->bulkq);
 	/* Cannot kthread_stop() here, last put free rcpu resources */
@@ -485,6 +493,7 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 		rcpu = __cpu_map_entry_alloc(qsize, key_cpu, map->id);
 		if (!rcpu)
 			return -ENOMEM;
+		rcpu->cmap = cmap;
 	}
 	rcu_read_lock();
 	__cpu_map_entry_replace(cmap, key_cpu, rcpu);
@@ -511,14 +520,14 @@ static void cpu_map_free(struct bpf_map *map)
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
 
@@ -535,7 +544,7 @@ static void cpu_map_free(struct bpf_map *map)
 		/* bq flush and cleanup happens after RCU graze-period */
 		__cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
 	}
-	free_percpu(cmap->flush_needed);
+	free_percpu(cmap->flush_list);
 	bpf_map_area_free(cmap->cpu_map);
 	kfree(cmap);
 }
@@ -587,9 +596,9 @@ const struct bpf_map_ops cpu_map_ops = {
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
@@ -618,6 +627,9 @@ static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
 	bq->count = 0;
 	spin_unlock(&q->producer_lock);
 
+	__list_del(bq->flush_node.prev, bq->flush_node.next);
+	bq->flush_node.prev = NULL;
+
 	/* Feedback loop via tracepoints */
 	trace_xdp_cpumap_enqueue(rcpu->map_id, processed, drops, to_cpu);
 	return 0;
@@ -628,10 +640,11 @@ static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
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
@@ -643,6 +656,10 @@ static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 	 * operation, when completing napi->poll call.
 	 */
 	bq->q[bq->count++] = xdpf;
+
+	if (!bq->flush_node.prev)
+		list_add(&bq->flush_node, flush_list);
+
 	return 0;
 }
 
@@ -662,41 +679,16 @@ int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
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
index 5ae7cce5ef16..5cb04a198139 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -25,9 +25,8 @@
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
@@ -56,9 +55,13 @@
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
 
@@ -73,23 +76,19 @@ struct bpf_dtab_netdev {
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
 	int err = -EINVAL;
 	u64 cost;
+	int cpu;
 
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -107,7 +106,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 
 	/* make sure page count doesn't overflow */
 	cost = (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *);
-	cost += dev_map_bitmap_size(attr) * num_possible_cpus();
+	cost += sizeof(struct list_head) * num_possible_cpus();
 
 	/* if map size is larger than memlock limit, reject it */
 	err = bpf_map_charge_init(&dtab->map.memory, cost);
@@ -116,28 +115,30 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 
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
@@ -166,14 +167,14 @@ static void dev_map_free(struct bpf_map *map)
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
 
@@ -188,7 +189,7 @@ static void dev_map_free(struct bpf_map *map)
 		kfree(dev);
 	}
 
-	free_percpu(dtab->flush_needed);
+	free_percpu(dtab->flush_list);
 	bpf_map_area_free(dtab->netdev_map);
 	kfree(dtab);
 }
@@ -210,18 +211,10 @@ static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
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
@@ -248,6 +241,8 @@ static int bq_xmit_all(struct bpf_dtab_netdev *obj,
 	trace_xdp_devmap_xmit(&obj->dtab->map, obj->bit,
 			      sent, drops, bq->dev_rx, dev, err);
 	bq->dev_rx = NULL;
+	__list_del(bq->flush_node.prev, bq->flush_node.next);
+	bq->flush_node.prev = NULL;
 	return 0;
 error:
 	/* If ndo_xdp_xmit fails with an errno, no frames have been
@@ -270,30 +265,17 @@ static int bq_xmit_all(struct bpf_dtab_netdev *obj,
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
-
-	for_each_set_bit(bit, bitmap, map->max_entries) {
-		struct bpf_dtab_netdev *dev = READ_ONCE(dtab->netdev_map[bit]);
-		struct xdp_bulk_queue *bq;
+	struct list_head *flush_list = this_cpu_ptr(dtab->flush_list);
+	struct xdp_bulk_queue *bq, *tmp;
 
-		/* This is possible if the dev entry is removed by user space
-		 * between xdp redirect and flush op.
-		 */
-		if (unlikely(!dev))
-			continue;
-
-		__clear_bit(bit, bitmap);
-
-		bq = this_cpu_ptr(dev->bulkq);
-		bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, true);
-	}
+	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
+		bq_xmit_all(bq, XDP_XMIT_FLUSH, true);
 }
 
 /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or
@@ -319,10 +301,11 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf,
 		      struct net_device *dev_rx)
 
 {
+	struct list_head *flush_list = this_cpu_ptr(obj->dtab->flush_list);
 	struct xdp_bulk_queue *bq = this_cpu_ptr(obj->bulkq);
 
 	if (unlikely(bq->count == DEV_MAP_BULK_SIZE))
-		bq_xmit_all(obj, bq, 0, true);
+		bq_xmit_all(bq, 0, true);
 
 	/* Ingress dev_rx will be the same for all xdp_frame's in
 	 * bulk_queue, because bq stored per-CPU and must be flushed
@@ -332,6 +315,10 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf,
 		bq->dev_rx = dev_rx;
 
 	bq->q[bq->count++] = xdpf;
+
+	if (!bq->flush_node.prev)
+		list_add(&bq->flush_node, flush_list);
+
 	return 0;
 }
 
@@ -382,16 +369,11 @@ static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
 {
 	if (dev->dev->netdev_ops->ndo_xdp_xmit) {
 		struct xdp_bulk_queue *bq;
-		unsigned long *bitmap;
-
 		int cpu;
 
 		for_each_online_cpu(cpu) {
-			bitmap = per_cpu_ptr(dev->dtab->flush_needed, cpu);
-			__clear_bit(dev->bit, bitmap);
-
 			bq = per_cpu_ptr(dev->bulkq, cpu);
-			bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, false);
+			bq_xmit_all(bq, XDP_XMIT_FLUSH, false);
 		}
 	}
 }
@@ -437,8 +419,10 @@ static int dev_map_update_elem(struct bpf_map *map, void *key, void *value,
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
@@ -461,6 +445,11 @@ static int dev_map_update_elem(struct bpf_map *map, void *key, void *value,
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
index 55bfc941d17a..7a996887c500 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3526,7 +3526,6 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 		err = dev_map_enqueue(dst, xdp, dev_rx);
 		if (unlikely(err))
 			return err;
-		__dev_map_insert_ctx(map, index);
 		break;
 	}
 	case BPF_MAP_TYPE_CPUMAP: {
@@ -3535,7 +3534,6 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 		err = cpu_map_enqueue(rcpu, xdp, dev_rx);
 		if (unlikely(err))
 			return err;
-		__cpu_map_insert_ctx(map, index);
 		break;
 	}
 	case BPF_MAP_TYPE_XSKMAP: {

