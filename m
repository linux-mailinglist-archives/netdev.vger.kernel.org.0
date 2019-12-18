Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC26C124522
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfLRKyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:54:32 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42482 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfLRKyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:54:32 -0500
Received: by mail-pg1-f196.google.com with SMTP id s64so1064463pgb.9;
        Wed, 18 Dec 2019 02:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aX+RSJUAErZVjQSmhFzZLtLEVib2oRvWACoJXzWZ8lw=;
        b=fjAQqhzgdjaHeR11Ro3XTN/7s3Jui7+ND/PsdJ6oYq/b1qZvDzPTBenr1Bhc4DML3Z
         vVQ16cmu3ULCOqAtOacms6D3icYQxFz1xSGqGTJ+gH8m00p+cY12O1mXhoptKZIttE4G
         9ipcpIPTK0hAT+4XZame94KhQYnKRn38lM4mapwLQ/FrQbfGDmK+ADa7ktTrCf3h0YIl
         rEgfVJDclpFOXWTLAHcFvJHeij1UbTd0rT+hbZYsvS/KnVM5tGlP2Ii94ySkcloSqwwR
         bpArkrgAWwCM0jFcT4+W/6wOjJ6ZoQ+yFAJGd4ImJI22re3i8xh03kE71RJS84mffG2Y
         vYEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aX+RSJUAErZVjQSmhFzZLtLEVib2oRvWACoJXzWZ8lw=;
        b=NQSnYN8D21wcqybAc9mD1MN7+wmzGt1qLDQByQNOC6px+oDfZMd/A4MGG9wGd5paPc
         kFOVlPQtfBCk+59fddNAT8WPvYwE7nWe96p34VOsybFGE7ol3zEhV9ulEeqgcn+NHYp4
         yite67k4Xq3I4phkAr3KCktXqoMRQMfYUVVMm2bJByJVxa1H9yPJvoIf0VB7Zjs6YrZu
         rOOMXM4JWLCxEwV14tTkGHzrGgBiP2CxqGKT2cUhld7/J8MUUsyYW6U88HOQRUAbp5gd
         UcEqrF70uHdtr9/TXEBVgjLquxW2+RqgwC+WlPQdOin022al7F4FU+1ZELk/KlO1ZaFu
         EG+A==
X-Gm-Message-State: APjAAAUBV0cwN1Xcq1VD8RUgXasu7LbHpxmklrI3Utgk0mV6VEVd80qS
        OR4ouITWvnYVWm5QaHyLRwx6zKImkb8Iig==
X-Google-Smtp-Source: APXvYqz5QC11vn7uKVCg9WQJa0KQEgo4Jlrj2O6j9ZbweZvtS7awIMwzLgRgb8oigW3bxmFrUm3ZHA==
X-Received: by 2002:aa7:8a99:: with SMTP id a25mr2318135pfc.233.1576666471104;
        Wed, 18 Dec 2019 02:54:31 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id k9sm2339000pje.26.2019.12.18.02.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 02:54:30 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 5/8] xdp: make devmap flush_list common for all map instances
Date:   Wed, 18 Dec 2019 11:53:57 +0100
Message-Id: <20191218105400.2895-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191218105400.2895-1-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The devmap flush list is used to track entries that need to flushed
from via the xdp_do_flush_map() function. This list used to be
per-map, but there is really no reason for that. Instead make the
flush list global for all devmaps, which simplifies __dev_map_flush()
and dev_map_init_map().

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h |  4 ++--
 kernel/bpf/devmap.c | 37 ++++++++++++++-----------------------
 net/core/filter.c   |  2 +-
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d467983e61bb..31191804ca09 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -959,7 +959,7 @@ struct sk_buff;
 
 struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key);
 struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key);
-void __dev_map_flush(struct bpf_map *map);
+void __dev_map_flush(void);
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
@@ -1068,7 +1068,7 @@ static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_map *map
 	return NULL;
 }
 
-static inline void __dev_map_flush(struct bpf_map *map)
+static inline void __dev_map_flush(void)
 {
 }
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 1fcafc641c12..da9c832fc5c8 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -75,7 +75,6 @@ struct bpf_dtab_netdev {
 struct bpf_dtab {
 	struct bpf_map map;
 	struct bpf_dtab_netdev **netdev_map; /* DEVMAP type only */
-	struct list_head __percpu *flush_list;
 	struct list_head list;
 
 	/* these are only used for DEVMAP_HASH type maps */
@@ -85,6 +84,7 @@ struct bpf_dtab {
 	u32 n_buckets;
 };
 
+static DEFINE_PER_CPU(struct list_head, dev_map_flush_list);
 static DEFINE_SPINLOCK(dev_map_lock);
 static LIST_HEAD(dev_map_list);
 
@@ -109,8 +109,8 @@ static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
 
 static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 {
-	int err, cpu;
-	u64 cost;
+	u64 cost = 0;
+	int err;
 
 	/* check sanity of attributes */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
@@ -125,9 +125,6 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 
 	bpf_map_init_from_attr(&dtab->map, attr);
 
-	/* make sure page count doesn't overflow */
-	cost = (u64) sizeof(struct list_head) * num_possible_cpus();
-
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		dtab->n_buckets = roundup_pow_of_two(dtab->map.max_entries);
 
@@ -143,17 +140,10 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 	if (err)
 		return -EINVAL;
 
-	dtab->flush_list = alloc_percpu(struct list_head);
-	if (!dtab->flush_list)
-		goto free_charge;
-
-	for_each_possible_cpu(cpu)
-		INIT_LIST_HEAD(per_cpu_ptr(dtab->flush_list, cpu));
-
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets);
 		if (!dtab->dev_index_head)
-			goto free_percpu;
+			goto free_charge;
 
 		spin_lock_init(&dtab->index_lock);
 	} else {
@@ -161,13 +151,11 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 						      sizeof(struct bpf_dtab_netdev *),
 						      dtab->map.numa_node);
 		if (!dtab->netdev_map)
-			goto free_percpu;
+			goto free_charge;
 	}
 
 	return 0;
 
-free_percpu:
-	free_percpu(dtab->flush_list);
 free_charge:
 	bpf_map_charge_finish(&dtab->map.memory);
 	return -ENOMEM;
@@ -201,7 +189,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 static void dev_map_free(struct bpf_map *map)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	int i, cpu;
+	int i;
 
 	/* At this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
 	 * so the programs (can be more than one that used this map) were
@@ -254,7 +242,6 @@ static void dev_map_free(struct bpf_map *map)
 		bpf_map_area_free(dtab->netdev_map);
 	}
 
-	free_percpu(dtab->flush_list);
 	kfree(dtab);
 }
 
@@ -384,10 +371,9 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags)
  * net device can be torn down. On devmap tear down we ensure the flush list
  * is empty before completing to ensure all flush operations have completed.
  */
-void __dev_map_flush(struct bpf_map *map)
+void __dev_map_flush(void)
 {
-	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	struct list_head *flush_list = this_cpu_ptr(dtab->flush_list);
+	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
 	struct xdp_bulk_queue *bq, *tmp;
 
 	rcu_read_lock();
@@ -419,7 +405,7 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf,
 		      struct net_device *dev_rx)
 
 {
-	struct list_head *flush_list = this_cpu_ptr(obj->dtab->flush_list);
+	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
 	struct xdp_bulk_queue *bq = this_cpu_ptr(obj->bulkq);
 
 	if (unlikely(bq->count == DEV_MAP_BULK_SIZE))
@@ -777,10 +763,15 @@ static struct notifier_block dev_map_notifier = {
 
 static int __init dev_map_init(void)
 {
+	int cpu;
+
 	/* Assure tracepoint shadow struct _bpf_dtab_netdev is in sync */
 	BUILD_BUG_ON(offsetof(struct bpf_dtab_netdev, dev) !=
 		     offsetof(struct _bpf_dtab_netdev, dev));
 	register_netdevice_notifier(&dev_map_notifier);
+
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(dev_map_flush_list, cpu));
 	return 0;
 }
 
diff --git a/net/core/filter.c b/net/core/filter.c
index c51678c473c5..b7570cb84902 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3555,7 +3555,7 @@ void xdp_do_flush_map(void)
 		switch (map->map_type) {
 		case BPF_MAP_TYPE_DEVMAP:
 		case BPF_MAP_TYPE_DEVMAP_HASH:
-			__dev_map_flush(map);
+			__dev_map_flush();
 			break;
 		case BPF_MAP_TYPE_CPUMAP:
 			__cpu_map_flush(map);
-- 
2.20.1

