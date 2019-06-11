Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6794F3D132
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391795AbfFKPoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:44:09 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37198 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391768AbfFKPoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:44:06 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so20823532eds.4
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 08:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=r7sHv5eIpHmRRhYEHOfGX6WdnGudv/1SMqwmlkcnoQM=;
        b=YHRM0EpAkZYv0v/VEXtLFzqixMYkQ7ATqOt0AHnENB5Y3I8oCC2mpBfkW9ku1jJNCo
         iNTnvRlVX0qcWHYdlZ2Pq+3Yws7AnGJk8YNxnAAEX8b0n6HEglGIcvc5USBv0H0JA/EF
         WWab75GaTXaSiwQkDNXhTURGs2HJQeEEPF4a0Q/wkluzn3VOlkpkemOButWLOh6H1yX5
         cXx1tU6pIvFn/DUbuo3ITN0bPp1VDJIdLPDTK/E97fkY1BLsds9IX6cUzzzakhc+GPCG
         NSyNf4h2ZnVbm/oRH63TbzE/nFY43uP/xZHy37YzGG2SFIK7Q+S6H3H9wzhWktsQsU6m
         aBGA==
X-Gm-Message-State: APjAAAU0sNtYtYEJ+1TBRRRArS4u3jiYIVkivvEHT0oCAk2YrgDb7jf1
        MKawU6dkxh2WP+/NEB6wj+lJZQ==
X-Google-Smtp-Source: APXvYqz4a0CitAc3V4+MqEyZ+4wrD/3mYLtIlKJFRQvzDuT3bwr5E4lG5GudXNToGA9RktFp7FxkXQ==
X-Received: by 2002:a50:996e:: with SMTP id l43mr56758237edb.187.1560267843976;
        Tue, 11 Jun 2019 08:44:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id e26sm864144ejr.66.2019.06.11.08.44.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 08:44:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1C5AC18037F; Tue, 11 Jun 2019 17:44:00 +0200 (CEST)
Subject: [PATCH bpf-next v3 1/3] devmap/cpumap: Use flush list instead of
 bitmap
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Tue, 11 Jun 2019 17:44:00 +0200
Message-ID: <156026784005.26748.1807371376992707392.stgit@alrua-x1>
In-Reply-To: <156026783994.26748.2899804283816365487.stgit@alrua-x1>
References: <156026783994.26748.2899804283816365487.stgit@alrua-x1>
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
 kernel/bpf/cpumap.c |   97 ++++++++++++++++++++++++---------------------------
 kernel/bpf/devmap.c |   93 ++++++++++++++++++++++---------------------------
 net/core/filter.c   |    2 -
 3 files changed, 87 insertions(+), 105 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index b31a71909307..02dc3503ef4d 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -38,8 +38,13 @@
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
@@ -115,11 +116,13 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	}
 
 	/* A per cpu bitfield with a bit per possible CPU in map  */
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
@@ -129,7 +132,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	return &cmap->map;
 free_percpu:
-	free_percpu(cmap->flush_needed);
+	free_percpu(cmap->flush_list);
 free_charge:
 	bpf_map_charge_finish(&cmap->map.memory);
 free_cmap:
@@ -331,7 +334,8 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct bpf_cpu_map_entry *rcpu;
-	int numa, err;
+	struct xdp_bulk_queue *bq;
+	int numa, err, i;
 
 	/* Have map->numa_node, but choose node of redirect target CPU */
 	numa = cpu_to_node(cpu);
@@ -346,6 +350,11 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
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
@@ -402,7 +411,7 @@ static void __cpu_map_entry_free(struct rcu_head *rcu)
 		struct xdp_bulk_queue *bq = per_cpu_ptr(rcpu->bulkq, cpu);
 
 		/* No concurrent bq_enqueue can run at this point */
-		bq_flush_to_queue(rcpu, bq, false);
+		bq_flush_to_queue(bq, false);
 	}
 	free_percpu(rcpu->bulkq);
 	/* Cannot kthread_stop() here, last put free rcpu resources */
@@ -485,6 +494,7 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 		rcpu = __cpu_map_entry_alloc(qsize, key_cpu, map->id);
 		if (!rcpu)
 			return -ENOMEM;
+		rcpu->cmap = cmap;
 	}
 	rcu_read_lock();
 	__cpu_map_entry_replace(cmap, key_cpu, rcpu);
@@ -516,9 +526,9 @@ static void cpu_map_free(struct bpf_map *map)
 	 * from the program we can assume no new bits will be set.
 	 */
 	for_each_online_cpu(cpu) {
-		unsigned long *bitmap = per_cpu_ptr(cmap->flush_needed, cpu);
+		struct list_head *flush_list = per_cpu_ptr(cmap->flush_list, cpu);
 
-		while (!bitmap_empty(bitmap, cmap->map.max_entries))
+		while (!list_empty(flush_list))
 			cond_resched();
 	}
 
@@ -535,7 +545,7 @@ static void cpu_map_free(struct bpf_map *map)
 		/* bq flush and cleanup happens after RCU graze-period */
 		__cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
 	}
-	free_percpu(cmap->flush_needed);
+	free_percpu(cmap->flush_list);
 	bpf_map_area_free(cmap->cpu_map);
 	kfree(cmap);
 }
@@ -587,9 +597,9 @@ const struct bpf_map_ops cpu_map_ops = {
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
@@ -618,6 +628,9 @@ static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
 	bq->count = 0;
 	spin_unlock(&q->producer_lock);
 
+	__list_del(bq->flush_node.prev, bq->flush_node.next);
+	bq->flush_node.prev = NULL;
+
 	/* Feedback loop via tracepoints */
 	trace_xdp_cpumap_enqueue(rcpu->map_id, processed, drops, to_cpu);
 	return 0;
@@ -628,10 +641,11 @@ static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
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
@@ -643,6 +657,10 @@ static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 	 * operation, when completing napi->poll call.
 	 */
 	bq->q[bq->count++] = xdpf;
+
+	if (!bq->flush_node.prev)
+		list_add(&bq->flush_node, flush_list);
+
 	return 0;
 }
 
@@ -662,41 +680,16 @@ int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
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
index 5ae7cce5ef16..c945518225f3 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -56,9 +56,13 @@
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
 
@@ -73,23 +77,19 @@ struct bpf_dtab_netdev {
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
@@ -107,7 +107,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 
 	/* make sure page count doesn't overflow */
 	cost = (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *);
-	cost += dev_map_bitmap_size(attr) * num_possible_cpus();
+	cost += sizeof(struct list_head) * num_possible_cpus();
 
 	/* if map size is larger than memlock limit, reject it */
 	err = bpf_map_charge_init(&dtab->map.memory, cost);
@@ -116,28 +116,30 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 
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
@@ -171,9 +173,9 @@ static void dev_map_free(struct bpf_map *map)
 	 * from the program we can assume no new bits will be set.
 	 */
 	for_each_online_cpu(cpu) {
-		unsigned long *bitmap = per_cpu_ptr(dtab->flush_needed, cpu);
+		struct list_head *flush_list = per_cpu_ptr(dtab->flush_list, cpu);
 
-		while (!bitmap_empty(bitmap, dtab->map.max_entries))
+		while (!list_empty(flush_list))
 			cond_resched();
 	}
 
@@ -188,7 +190,7 @@ static void dev_map_free(struct bpf_map *map)
 		kfree(dev);
 	}
 
-	free_percpu(dtab->flush_needed);
+	free_percpu(dtab->flush_list);
 	bpf_map_area_free(dtab->netdev_map);
 	kfree(dtab);
 }
@@ -210,18 +212,11 @@ static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
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
+
+	struct bpf_dtab_netdev *obj = bq->obj;
 	struct net_device *dev = obj->dev;
 	int sent = 0, drops = 0, err = 0;
 	int i;
@@ -248,6 +243,8 @@ static int bq_xmit_all(struct bpf_dtab_netdev *obj,
 	trace_xdp_devmap_xmit(&obj->dtab->map, obj->bit,
 			      sent, drops, bq->dev_rx, dev, err);
 	bq->dev_rx = NULL;
+	__list_del(bq->flush_node.prev, bq->flush_node.next);
+	bq->flush_node.prev = NULL;
 	return 0;
 error:
 	/* If ndo_xdp_xmit fails with an errno, no frames have been
@@ -276,24 +273,11 @@ static int bq_xmit_all(struct bpf_dtab_netdev *obj,
 void __dev_map_flush(struct bpf_map *map)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	unsigned long *bitmap = this_cpu_ptr(dtab->flush_needed);
-	u32 bit;
+	struct list_head *flush_list = this_cpu_ptr(dtab->flush_list);
+	struct xdp_bulk_queue *bq, *tmp;
 
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
-		__clear_bit(bit, bitmap);
-
-		bq = this_cpu_ptr(dev->bulkq);
-		bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, true);
-	}
+	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
+		bq_xmit_all(bq, XDP_XMIT_FLUSH, true);
 }
 
 /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or
@@ -319,10 +303,11 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf,
 		      struct net_device *dev_rx)
 
 {
+	struct list_head *flush_list = this_cpu_ptr(obj->dtab->flush_list);
 	struct xdp_bulk_queue *bq = this_cpu_ptr(obj->bulkq);
 
 	if (unlikely(bq->count == DEV_MAP_BULK_SIZE))
-		bq_xmit_all(obj, bq, 0, true);
+		bq_xmit_all(bq, 0, true);
 
 	/* Ingress dev_rx will be the same for all xdp_frame's in
 	 * bulk_queue, because bq stored per-CPU and must be flushed
@@ -332,6 +317,10 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf,
 		bq->dev_rx = dev_rx;
 
 	bq->q[bq->count++] = xdpf;
+
+	if (!bq->flush_node.prev)
+		list_add(&bq->flush_node, flush_list);
+
 	return 0;
 }
 
@@ -382,16 +371,11 @@ static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
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
@@ -439,6 +423,8 @@ static int dev_map_update_elem(struct bpf_map *map, void *key, void *value,
 	struct bpf_dtab_netdev *dev, *old_dev;
 	u32 i = *(u32 *)key;
 	u32 ifindex = *(u32 *)value;
+	struct xdp_bulk_queue *bq;
+	int cpu;
 
 	if (unlikely(map_flags > BPF_EXIST))
 		return -EINVAL;
@@ -461,6 +447,11 @@ static int dev_map_update_elem(struct bpf_map *map, void *key, void *value,
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

