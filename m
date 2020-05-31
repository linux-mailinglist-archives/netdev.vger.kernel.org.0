Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA081E9A99
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 23:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgEaVrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 17:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbgEaVrj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 17:47:39 -0400
Received: from lore-desk.lan (unknown [151.48.128.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18C53206F1;
        Sun, 31 May 2020 21:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590961658;
        bh=vIDBqI4LeBbmbgXUpAeR5oXjD6W4UaeuCDblUyQUXxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5+nj7e7vyn/htHNL0x2tyKIonkNX/NXf4++/XrJHaz+peVQTK73xjrR2GUMjlcoZ
         OtsvI3XzDETdxb5LLIKyXXDOCPqkIj5gebyDmQmvjZeMDlsUk+JHxlxd51Z1n56KMT
         VU5CAuOq9LFXF9nK91JAR3xsvgxES4Og6hHDz+ME=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH bpf-next 3/6] cpumap: formalize map value as a named struct
Date:   Sun, 31 May 2020 23:46:48 +0200
Message-Id: <02fcf47c1b0dcf37b108994ba6f44266ad89bee6.1590960613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1590960613.git.lorenzo@kernel.org>
References: <cover.1590960613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it has been already done for devmap, introduce 'struct bpf_cpumap_val'
to formalize the expected values that can be passed in for a CPUMAP.
Update cpumap code to use the struct.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/bpf/cpumap.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 27595fc6da56..57402276d8af 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -48,11 +48,15 @@ struct xdp_bulk_queue {
 	unsigned int count;
 };
 
+/* CPUMAP value */
+struct bpf_cpumap_val {
+	u32 qsize;	/* queue size */
+};
+
 /* Struct for every remote "destination" CPU in map */
 struct bpf_cpu_map_entry {
 	u32 cpu;    /* kthread CPU and map index */
 	int map_id; /* Back reference to map */
-	u32 qsize;  /* Queue size placeholder for map lookup */
 
 	/* XDP can run multiple RX-ring queues, need __percpu enqueue store */
 	struct xdp_bulk_queue __percpu *bulkq;
@@ -66,6 +70,8 @@ struct bpf_cpu_map_entry {
 
 	atomic_t refcnt; /* Control when this struct can be free'ed */
 	struct rcu_head rcu;
+
+	struct bpf_cpumap_val value;
 };
 
 struct bpf_cpu_map {
@@ -307,8 +313,8 @@ static int cpu_map_kthread_run(void *data)
 	return 0;
 }
 
-static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
-						       int map_id)
+static struct bpf_cpu_map_entry *
+__cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct bpf_cpu_map_entry *rcpu;
@@ -338,13 +344,13 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
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
@@ -437,12 +443,12 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
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
@@ -450,18 +456,18 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
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
@@ -523,7 +529,7 @@ static void *cpu_map_lookup_elem(struct bpf_map *map, void *key)
 	struct bpf_cpu_map_entry *rcpu =
 		__cpu_map_lookup_elem(map, *(u32 *)key);
 
-	return rcpu ? &rcpu->qsize : NULL;
+	return rcpu ? &rcpu->value.qsize : NULL;
 }
 
 static int cpu_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
-- 
2.26.2

