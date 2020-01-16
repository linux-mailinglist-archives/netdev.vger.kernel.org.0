Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEF913E222
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731450AbgAPQyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731391AbgAPQyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9468A214AF;
        Thu, 16 Jan 2020 16:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193640;
        bh=ejBNIGZGMxjzJ1lBq89t0fo9r5nqDm5BVFfXjSVWCUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liLlk0aCw/ShY/8XOQYgqbmJ6H8xh/o9/29EpjhlN1oLbOvVKmWWG0wM+UvUlc5Up
         Vm1aNOrz+XktAGIjgozrJ7mUaJ0si2JESte7uZfs9bbDUt7Mpgwp5tPhXhBHoQncmB
         +2DcPPzxup9BudSirPc+rL3kP0zlfIr5b4a1f18w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 172/205] xdp: Fix cleanup on map free for devmap_hash map type
Date:   Thu, 16 Jan 2020 11:42:27 -0500
Message-Id: <20200116164300.6705-172-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 071cdecec57fb5d5df78e6a12114ad7bccea5b0e ]

Tetsuo pointed out that it was not only the device unregister hook that was
broken for devmap_hash types, it was also cleanup on map free. So better
fix this as well.

While we're at it, there's no reason to allocate the netdev_map array for
DEVMAP_HASH, so skip that and adjust the cost accordingly.

Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devices by hashed index")
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20191121133612.430414-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 74 ++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 28 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3867864cdc2f..3d3d61b5985b 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -74,7 +74,7 @@ struct bpf_dtab_netdev {
 
 struct bpf_dtab {
 	struct bpf_map map;
-	struct bpf_dtab_netdev **netdev_map;
+	struct bpf_dtab_netdev **netdev_map; /* DEVMAP type only */
 	struct list_head __percpu *flush_list;
 	struct list_head list;
 
@@ -101,6 +101,12 @@ static struct hlist_head *dev_map_create_hash(unsigned int entries)
 	return hash;
 }
 
+static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
+						    int idx)
+{
+	return &dtab->dev_index_head[idx & (dtab->n_buckets - 1)];
+}
+
 static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 {
 	int err, cpu;
@@ -120,8 +126,7 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 	bpf_map_init_from_attr(&dtab->map, attr);
 
 	/* make sure page count doesn't overflow */
-	cost = (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *);
-	cost += sizeof(struct list_head) * num_possible_cpus();
+	cost = (u64) sizeof(struct list_head) * num_possible_cpus();
 
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		dtab->n_buckets = roundup_pow_of_two(dtab->map.max_entries);
@@ -129,6 +134,8 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 		if (!dtab->n_buckets) /* Overflow check */
 			return -EINVAL;
 		cost += (u64) sizeof(struct hlist_head) * dtab->n_buckets;
+	} else {
+		cost += (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *);
 	}
 
 	/* if map size is larger than memlock limit, reject it */
@@ -143,24 +150,22 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 	for_each_possible_cpu(cpu)
 		INIT_LIST_HEAD(per_cpu_ptr(dtab->flush_list, cpu));
 
-	dtab->netdev_map = bpf_map_area_alloc(dtab->map.max_entries *
-					      sizeof(struct bpf_dtab_netdev *),
-					      dtab->map.numa_node);
-	if (!dtab->netdev_map)
-		goto free_percpu;
-
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets);
 		if (!dtab->dev_index_head)
-			goto free_map_area;
+			goto free_percpu;
 
 		spin_lock_init(&dtab->index_lock);
+	} else {
+		dtab->netdev_map = bpf_map_area_alloc(dtab->map.max_entries *
+						      sizeof(struct bpf_dtab_netdev *),
+						      dtab->map.numa_node);
+		if (!dtab->netdev_map)
+			goto free_percpu;
 	}
 
 	return 0;
 
-free_map_area:
-	bpf_map_area_free(dtab->netdev_map);
 free_percpu:
 	free_percpu(dtab->flush_list);
 free_charge:
@@ -228,21 +233,40 @@ static void dev_map_free(struct bpf_map *map)
 			cond_resched();
 	}
 
-	for (i = 0; i < dtab->map.max_entries; i++) {
-		struct bpf_dtab_netdev *dev;
+	if (dtab->map.map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
+		for (i = 0; i < dtab->n_buckets; i++) {
+			struct bpf_dtab_netdev *dev;
+			struct hlist_head *head;
+			struct hlist_node *next;
 
-		dev = dtab->netdev_map[i];
-		if (!dev)
-			continue;
+			head = dev_map_index_hash(dtab, i);
 
-		free_percpu(dev->bulkq);
-		dev_put(dev->dev);
-		kfree(dev);
+			hlist_for_each_entry_safe(dev, next, head, index_hlist) {
+				hlist_del_rcu(&dev->index_hlist);
+				free_percpu(dev->bulkq);
+				dev_put(dev->dev);
+				kfree(dev);
+			}
+		}
+
+		kfree(dtab->dev_index_head);
+	} else {
+		for (i = 0; i < dtab->map.max_entries; i++) {
+			struct bpf_dtab_netdev *dev;
+
+			dev = dtab->netdev_map[i];
+			if (!dev)
+				continue;
+
+			free_percpu(dev->bulkq);
+			dev_put(dev->dev);
+			kfree(dev);
+		}
+
+		bpf_map_area_free(dtab->netdev_map);
 	}
 
 	free_percpu(dtab->flush_list);
-	bpf_map_area_free(dtab->netdev_map);
-	kfree(dtab->dev_index_head);
 	kfree(dtab);
 }
 
@@ -263,12 +287,6 @@ static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	return 0;
 }
 
-static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
-						    int idx)
-{
-	return &dtab->dev_index_head[idx & (dtab->n_buckets - 1)];
-}
-
 struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-- 
2.20.1

