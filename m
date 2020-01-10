Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0D3136F39
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgAJOWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:22:11 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60942 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728022AbgAJOWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 09:22:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578666127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oDlskFlUp4GTMIV5+OuJoEY887sUEXyIhUjGs/LvtnM=;
        b=EV+d5maRs21Ot7cyyymoJ/uPmZB1lKkhoklZ5NIAtwLZyj3OhXeHUiXU6ypDhjSZY/Emkt
        SfBSkpMxTTwIGCLxgI72nw3Qpd/qzxAnBmqry/IypRYQab2GwM6hbEEWNeUHTzLng8RGUJ
        u+ctGPm6c00q1DfMeW+LSQJFKGyktmk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-8u7XjBbgPeKUqBSCyHkYAw-1; Fri, 10 Jan 2020 09:22:06 -0500
X-MC-Unique: 8u7XjBbgPeKUqBSCyHkYAw-1
Received: by mail-wm1-f69.google.com with SMTP id b131so842404wmd.9
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 06:22:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oDlskFlUp4GTMIV5+OuJoEY887sUEXyIhUjGs/LvtnM=;
        b=Q82ukDG7FhmiyTeqewEy3mbruJzt7qSXGr4NWnfVoKUOY7nwzoMH5GagDgXh3nEVSZ
         LlASMyq71Op3ZenPt8zCwPtUo3NFSiOR9XOD1ktgMmotH+HBY1vG6y313T4l6rZYnX6P
         Cno9yBTjCCVVZVv7KgyxU0F5R9SodouNITFmOnxLVt0eiVU7imq8wchD/ysHX+3fqOw1
         amkJkUKHxTUjjn3XVuz+vmstu5Fncb9N7sij7Kb/ZZkr16D6PY2x0/5LXQxWvZTL2wJ3
         NOupwPdOnZp6G+fY4vi9rFMakryLyRkJehEKeg+e7lgErXwCqHfMLSSwEfQiDB7/B1Rg
         cIUQ==
X-Gm-Message-State: APjAAAWeV//j3Edm/Hj8l8D+dWJD1l/Mia7JCtdZyS12mPgg73oliZCC
        EJlvZt6+cn9FoEXFiBcEbIAJh8o/7jOnvj8vvwb+iLLm64vmgJWIxtO6jcC5NLs9U1+9pX34gRO
        mkHZ/taWsSCt4MyIv
X-Received: by 2002:a1c:22c6:: with SMTP id i189mr4947589wmi.15.1578666125055;
        Fri, 10 Jan 2020 06:22:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqxgQfV5Kpj5aQ1WMO07+CZEr+a9mJEWC2SJjD2Yzh77NFO2LLVaH7xz9ogrEoLmQHAZIo5C2g==
X-Received: by 2002:a1c:22c6:: with SMTP id i189mr4947566wmi.15.1578666124785;
        Fri, 10 Jan 2020 06:22:04 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c2sm2375598wrp.46.2020.01.10.06.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 06:22:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E224318009C; Fri, 10 Jan 2020 15:22:02 +0100 (CET)
Subject: [PATCH bpf-next 1/2] xdp: Move devmap bulk queue into struct
 net_device
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Date:   Fri, 10 Jan 2020 15:22:02 +0100
Message-ID: <157866612285.432695.6722430952732620313.stgit@toke.dk>
In-Reply-To: <157866612174.432695.5077671447287539053.stgit@toke.dk>
References: <157866612174.432695.5077671447287539053.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Commit 96360004b862 ("xdp: Make devmap flush_list common for all map
instances"), changed devmap flushing to be a global operation instead of a
per-map operation. However, the queue structure used for bulking was still
allocated as part of the containing map.

This patch moves the devmap bulk queue into struct net_device. The
motivation for this is reusing it for the non-map variant of XDP_REDIRECT,
which will be changed in a subsequent commit.

We defer the actual allocation of the bulk queue structure until the
NETDEV_REGISTER notification devmap.c. This makes it possible to check for
ndo_xdp_xmit support before allocating the structure, which is not possible
at the time struct net_device is allocated. However, we keep the freeing in
free_netdev() to avoid adding another RCU callback on NETDEV_UNREGISTER.

Because of this change, we lose the reference back to the map that
originated the redirect, so change the tracepoint to always return 0 as the
map ID and index. Otherwise no functional change is intended with this
patch.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/netdevice.h  |    3 ++
 include/trace/events/xdp.h |    2 +
 kernel/bpf/devmap.c        |   61 ++++++++++++++++++--------------------------
 net/core/dev.c             |    2 +
 4 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2741aa35bec6..1b2bc2a7522e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -876,6 +876,7 @@ enum bpf_netdev_command {
 struct bpf_prog_offload_ops;
 struct netlink_ext_ack;
 struct xdp_umem;
+struct xdp_dev_bulk_queue;
 
 struct netdev_bpf {
 	enum bpf_netdev_command command;
@@ -1993,6 +1994,8 @@ struct net_device {
 	spinlock_t		tx_global_lock;
 	int			watchdog_timeo;
 
+	struct xdp_dev_bulk_queue __percpu *xdp_bulkq;
+
 #ifdef CONFIG_XPS
 	struct xps_dev_maps __rcu *xps_cpus_map;
 	struct xps_dev_maps __rcu *xps_rxqs_map;
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index a7378bcd9928..72bad13d4a3c 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -278,7 +278,7 @@ TRACE_EVENT(xdp_devmap_xmit,
 	),
 
 	TP_fast_assign(
-		__entry->map_id		= map->id;
+		__entry->map_id		= map ? map->id : 0;
 		__entry->act		= XDP_REDIRECT;
 		__entry->map_index	= map_index;
 		__entry->drops		= drops;
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index da9c832fc5c8..bcb05cb6b728 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -53,13 +53,11 @@
 	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
 
 #define DEV_MAP_BULK_SIZE 16
-struct bpf_dtab_netdev;
-
-struct xdp_bulk_queue {
+struct xdp_dev_bulk_queue {
 	struct xdp_frame *q[DEV_MAP_BULK_SIZE];
 	struct list_head flush_node;
+	struct net_device *dev;
 	struct net_device *dev_rx;
-	struct bpf_dtab_netdev *obj;
 	unsigned int count;
 };
 
@@ -67,9 +65,8 @@ struct bpf_dtab_netdev {
 	struct net_device *dev; /* must be first member, due to tracepoint */
 	struct hlist_node index_hlist;
 	struct bpf_dtab *dtab;
-	struct xdp_bulk_queue __percpu *bulkq;
 	struct rcu_head rcu;
-	unsigned int idx; /* keep track of map index for tracepoint */
+	unsigned int idx;
 };
 
 struct bpf_dtab {
@@ -219,7 +216,6 @@ static void dev_map_free(struct bpf_map *map)
 
 			hlist_for_each_entry_safe(dev, next, head, index_hlist) {
 				hlist_del_rcu(&dev->index_hlist);
-				free_percpu(dev->bulkq);
 				dev_put(dev->dev);
 				kfree(dev);
 			}
@@ -234,7 +230,6 @@ static void dev_map_free(struct bpf_map *map)
 			if (!dev)
 				continue;
 
-			free_percpu(dev->bulkq);
 			dev_put(dev->dev);
 			kfree(dev);
 		}
@@ -320,10 +315,9 @@ static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
 	return -ENOENT;
 }
 
-static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags)
+static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 {
-	struct bpf_dtab_netdev *obj = bq->obj;
-	struct net_device *dev = obj->dev;
+	struct net_device *dev = bq->dev;
 	int sent = 0, drops = 0, err = 0;
 	int i;
 
@@ -346,8 +340,7 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags)
 out:
 	bq->count = 0;
 
-	trace_xdp_devmap_xmit(&obj->dtab->map, obj->idx,
-			      sent, drops, bq->dev_rx, dev, err);
+	trace_xdp_devmap_xmit(NULL, 0, sent, drops, bq->dev_rx, dev, err);
 	bq->dev_rx = NULL;
 	__list_del_clearprev(&bq->flush_node);
 	return 0;
@@ -374,7 +367,7 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags)
 void __dev_map_flush(void)
 {
 	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
-	struct xdp_bulk_queue *bq, *tmp;
+	struct xdp_dev_bulk_queue *bq, *tmp;
 
 	rcu_read_lock();
 	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
@@ -401,12 +394,12 @@ struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
 /* Runs under RCU-read-side, plus in softirq under NAPI protection.
  * Thus, safe percpu variable access.
  */
-static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf,
+static int bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 		      struct net_device *dev_rx)
 
 {
 	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
-	struct xdp_bulk_queue *bq = this_cpu_ptr(obj->bulkq);
+	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
 
 	if (unlikely(bq->count == DEV_MAP_BULK_SIZE))
 		bq_xmit_all(bq, 0);
@@ -444,7 +437,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 	if (unlikely(!xdpf))
 		return -EOVERFLOW;
 
-	return bq_enqueue(dst, xdpf, dev_rx);
+	return bq_enqueue(dev, xdpf, dev_rx);
 }
 
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
@@ -483,7 +476,6 @@ static void __dev_map_entry_free(struct rcu_head *rcu)
 	struct bpf_dtab_netdev *dev;
 
 	dev = container_of(rcu, struct bpf_dtab_netdev, rcu);
-	free_percpu(dev->bulkq);
 	dev_put(dev->dev);
 	kfree(dev);
 }
@@ -538,30 +530,14 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 						    u32 ifindex,
 						    unsigned int idx)
 {
-	gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN;
 	struct bpf_dtab_netdev *dev;
-	struct xdp_bulk_queue *bq;
-	int cpu;
 
-	dev = kmalloc_node(sizeof(*dev), gfp, dtab->map.numa_node);
+	dev = kmalloc_node(sizeof(*dev), GFP_ATOMIC | __GFP_NOWARN, dtab->map.numa_node);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	dev->bulkq = __alloc_percpu_gfp(sizeof(*dev->bulkq),
-					sizeof(void *), gfp);
-	if (!dev->bulkq) {
-		kfree(dev);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	for_each_possible_cpu(cpu) {
-		bq = per_cpu_ptr(dev->bulkq, cpu);
-		bq->obj = dev;
-	}
-
 	dev->dev = dev_get_by_index(net, ifindex);
 	if (!dev->dev) {
-		free_percpu(dev->bulkq);
 		kfree(dev);
 		return ERR_PTR(-EINVAL);
 	}
@@ -721,9 +697,22 @@ static int dev_map_notification(struct notifier_block *notifier,
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
 	struct bpf_dtab *dtab;
-	int i;
+	int i, cpu;
 
 	switch (event) {
+	case NETDEV_REGISTER:
+		if (!netdev->netdev_ops->ndo_xdp_xmit || netdev->xdp_bulkq)
+			break;
+
+		/* will be freed in free_netdev() */
+		netdev->xdp_bulkq = __alloc_percpu_gfp(sizeof(struct xdp_dev_bulk_queue),
+						       sizeof(void *), GFP_ATOMIC);
+		if (!netdev->xdp_bulkq)
+			return NOTIFY_BAD;
+
+		for_each_possible_cpu(cpu)
+			per_cpu_ptr(netdev->xdp_bulkq, cpu)->dev = netdev;
+		break;
 	case NETDEV_UNREGISTER:
 		/* This rcu_read_lock/unlock pair is needed because
 		 * dev_map_list is an RCU list AND to ensure a delete
diff --git a/net/core/dev.c b/net/core/dev.c
index d99f88c58636..e7802a41ae7f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9847,6 +9847,8 @@ void free_netdev(struct net_device *dev)
 
 	free_percpu(dev->pcpu_refcnt);
 	dev->pcpu_refcnt = NULL;
+	free_percpu(dev->xdp_bulkq);
+	dev->xdp_bulkq = NULL;
 
 	netdev_unregister_lockdep_key(dev);
 

