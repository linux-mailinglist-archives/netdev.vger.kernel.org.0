Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0066A21F33B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgGNN5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgGNN5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 09:57:18 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D83D32250F;
        Tue, 14 Jul 2020 13:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594735037;
        bh=OyVIQEREi5XLm47Aep0Hvx3ZbUAbBRJ1PrFSW9Hu2h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3VXuskF31Zr4RUhK2Rka696FdvryPRipMngNlj2bLDhsc9Sbqq7L08EtOVqksCYj
         UWKb6RL0CXqkXfc3W9zHZE7SzcZVkWfqM9E0JipevYVdH0BpDOYIkW/aYd+GmZrUeL
         b+8d9jtjI3dqaJmOxXIjUVtqKzpswwh1OljihXGE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com
Subject: [PATCH v7 bpf-next 4/9] cpumap: formalize map value as a named struct
Date:   Tue, 14 Jul 2020 15:56:37 +0200
Message-Id: <754f950674665dae6139c061d28c1d982aaf4170.1594734381.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1594734381.git.lorenzo@kernel.org>
References: <cover.1594734381.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it has been already done for devmap, introduce 'struct bpf_cpumap_val'
to formalize the expected values that can be passed in for a CPUMAP.
Update cpumap code to use the struct.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/uapi/linux/bpf.h       |  9 +++++++++
 kernel/bpf/cpumap.c            | 28 +++++++++++++++-------------
 tools/include/uapi/linux/bpf.h |  9 +++++++++
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5e386389913a..109623527358 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3849,6 +3849,15 @@ struct bpf_devmap_val {
 	} bpf_prog;
 };
 
+/* CPUMAP map-value layout
+ *
+ * The struct data-layout of map-value is a configuration interface.
+ * New members can only be added to the end of this structure.
+ */
+struct bpf_cpumap_val {
+	__u32 qsize;	/* queue size to remote target CPU */
+};
+
 enum sk_action {
 	SK_DROP = 0,
 	SK_PASS,
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 323c91c4fab0..ff48dc00e8d0 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -52,7 +52,6 @@ struct xdp_bulk_queue {
 struct bpf_cpu_map_entry {
 	u32 cpu;    /* kthread CPU and map index */
 	int map_id; /* Back reference to map */
-	u32 qsize;  /* Queue size placeholder for map lookup */
 
 	/* XDP can run multiple RX-ring queues, need __percpu enqueue store */
 	struct xdp_bulk_queue __percpu *bulkq;
@@ -62,10 +61,13 @@ struct bpf_cpu_map_entry {
 	/* Queue with potential multi-producers, and single-consumer kthread */
 	struct ptr_ring *queue;
 	struct task_struct *kthread;
-	struct work_struct kthread_stop_wq;
+
+	struct bpf_cpumap_val value;
 
 	atomic_t refcnt; /* Control when this struct can be free'ed */
 	struct rcu_head rcu;
+
+	struct work_struct kthread_stop_wq;
 };
 
 struct bpf_cpu_map {
@@ -307,8 +309,8 @@ static int cpu_map_kthread_run(void *data)
 	return 0;
 }
 
-static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
-						       int map_id)
+static struct bpf_cpu_map_entry *
+__cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct bpf_cpu_map_entry *rcpu;
@@ -338,13 +340,13 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
 	if (!rcpu->queue)
 		goto free_bulkq;
 
-	err = ptr_ring_init(rcpu->queue, qsize, gfp);
+	err = ptr_ring_init(rcpu->queue, value->qsize, gfp);
 	if (err)
 		goto free_queue;
 
 	rcpu->cpu    = cpu;
 	rcpu->map_id = map_id;
-	rcpu->qsize  = qsize;
+	rcpu->value.qsize  = value->qsize;
 
 	/* Setup kthread */
 	rcpu->kthread = kthread_create_on_node(cpu_map_kthread_run, rcpu, numa,
@@ -437,12 +439,12 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 			       u64 map_flags)
 {
 	struct bpf_cpu_map *cmap = container_of(map, struct bpf_cpu_map, map);
+	struct bpf_cpumap_val cpumap_value = {};
 	struct bpf_cpu_map_entry *rcpu;
-
 	/* Array index key correspond to CPU number */
 	u32 key_cpu = *(u32 *)key;
-	/* Value is the queue size */
-	u32 qsize = *(u32 *)value;
+
+	memcpy(&cpumap_value, value, map->value_size);
 
 	if (unlikely(map_flags > BPF_EXIST))
 		return -EINVAL;
@@ -450,18 +452,18 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -E2BIG;
 	if (unlikely(map_flags == BPF_NOEXIST))
 		return -EEXIST;
-	if (unlikely(qsize > 16384)) /* sanity limit on qsize */
+	if (unlikely(cpumap_value.qsize > 16384)) /* sanity limit on qsize */
 		return -EOVERFLOW;
 
 	/* Make sure CPU is a valid possible cpu */
 	if (key_cpu >= nr_cpumask_bits || !cpu_possible(key_cpu))
 		return -ENODEV;
 
-	if (qsize == 0) {
+	if (cpumap_value.qsize == 0) {
 		rcpu = NULL; /* Same as deleting */
 	} else {
 		/* Updating qsize cause re-allocation of bpf_cpu_map_entry */
-		rcpu = __cpu_map_entry_alloc(qsize, key_cpu, map->id);
+		rcpu = __cpu_map_entry_alloc(&cpumap_value, key_cpu, map->id);
 		if (!rcpu)
 			return -ENOMEM;
 		rcpu->cmap = cmap;
@@ -523,7 +525,7 @@ static void *cpu_map_lookup_elem(struct bpf_map *map, void *key)
 	struct bpf_cpu_map_entry *rcpu =
 		__cpu_map_lookup_elem(map, *(u32 *)key);
 
-	return rcpu ? &rcpu->qsize : NULL;
+	return rcpu ? &rcpu->value : NULL;
 }
 
 static int cpu_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5e386389913a..109623527358 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3849,6 +3849,15 @@ struct bpf_devmap_val {
 	} bpf_prog;
 };
 
+/* CPUMAP map-value layout
+ *
+ * The struct data-layout of map-value is a configuration interface.
+ * New members can only be added to the end of this structure.
+ */
+struct bpf_cpumap_val {
+	__u32 qsize;	/* queue size to remote target CPU */
+};
+
 enum sk_action {
 	SK_DROP = 0,
 	SK_PASS,
-- 
2.26.2

