Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1ADD1DDC65
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 03:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgEVBFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 21:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726940AbgEVBFb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 21:05:31 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3528220884;
        Fri, 22 May 2020 01:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590109530;
        bh=4uBayyMQxFlZZlIIWESquZk5hzygGMKYGOx7XhW92oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ou7tifJ+tXqsjTtrD0hWUET4i1md6bpZBdcJzZltTqJ/B+5YJ9C8muEAijDIlxUJF
         hEUhh4BnRoGR4YDKbMh9YHMxAer7EBOyRwt8Qdal6FAk2E2isxF4BH/LQg+C9TFhIC
         gSWp2/qN3FsPD4AmfH3FBRz+9KCYCuLHAnsxLudg=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC bpf-next 2/4] bpf: Add support to attach bpf program to a devmap
Date:   Thu, 21 May 2020 19:05:24 -0600
Message-Id: <20200522010526.14649-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200522010526.14649-1-dsahern@kernel.org>
References: <20200522010526.14649-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF_XDP_DEVMAP attach type for use with programs associated with a
DEVMAP.

DEVMAPs can associate a program with a device entry by setting the
value to <index,id> pair. The program associated with the id must have
type XDP with expected attach type BPF_XDP_DEVMAP. When a program is
associated with a device index, the program is run on an XDP_REDIRECT
and before the buffer is added to the per-cpu queue. At this point
rxq data is still valid; the next patch adds tx device information
allowing the prorgam to see both ingress and egress device indices.

XDP generic is skb based and XDP programs do not work with skb's. Block
the use case by walking maps used by a program that is to be attached
via xdpgeneric and fail if any of them are DEVMAP / DEVMAP_HASH with
8-bytes values.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 include/linux/bpf.h            |  5 +++
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/devmap.c            | 82 +++++++++++++++++++++++++++++++---
 net/core/dev.c                 | 18 ++++++++
 tools/include/uapi/linux/bpf.h |  1 +
 5 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index efe8836b5c48..088751bc09aa 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1242,6 +1242,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
+bool dev_map_can_have_prog(struct bpf_map *map);
 
 struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key);
 void __cpu_map_flush(void);
@@ -1355,6 +1356,10 @@ static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_map *map
 {
 	return NULL;
 }
+static inline bool dev_map_can_have_prog(struct bpf_map *map)
+{
+	return false;
+}
 
 static inline void __dev_flush(void)
 {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 97e1fd19ff58..8c2c0d0c9a0e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -224,6 +224,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_GETPEERNAME,
 	BPF_CGROUP_INET4_GETSOCKNAME,
 	BPF_CGROUP_INET6_GETSOCKNAME,
+	BPF_XDP_DEVMAP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2c01ce434306..06f4c746fa7c 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -70,6 +70,7 @@ struct bpf_dtab_netdev {
 	struct net_device *dev; /* must be first member, due to tracepoint */
 	struct hlist_node index_hlist;
 	struct bpf_dtab *dtab;
+	struct bpf_prog *xdp_prog;
 	struct rcu_head rcu;
 	unsigned int idx;
 	struct dev_map_ext_val val;
@@ -228,6 +229,8 @@ static void dev_map_free(struct bpf_map *map)
 
 			hlist_for_each_entry_safe(dev, next, head, index_hlist) {
 				hlist_del_rcu(&dev->index_hlist);
+				if (dev->xdp_prog)
+					bpf_prog_put(dev->xdp_prog);
 				dev_put(dev->dev);
 				kfree(dev);
 			}
@@ -242,6 +245,8 @@ static void dev_map_free(struct bpf_map *map)
 			if (!dev)
 				continue;
 
+			if (dev->xdp_prog)
+				bpf_prog_put(dev->xdp_prog);
 			dev_put(dev->dev);
 			kfree(dev);
 		}
@@ -328,6 +333,16 @@ static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
 	return -ENOENT;
 }
 
+bool dev_map_can_have_prog(struct bpf_map *map)
+{
+	if ((map->map_type == BPF_MAP_TYPE_DEVMAP ||
+	     map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) &&
+	    map->value_size == 8)
+		return true;
+
+	return false;
+}
+
 static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 {
 	struct net_device *dev = bq->dev;
@@ -452,6 +467,39 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 	return bq_enqueue(dev, xdpf, dev_rx);
 }
 
+static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
+					 struct xdp_buff *xdp,
+					 struct bpf_prog *xdp_prog)
+{
+	u32 act;
+
+	act = bpf_prog_run_xdp(xdp_prog, xdp);
+	switch (act) {
+	case XDP_DROP:
+		fallthrough;
+	case XDP_PASS:
+		break;
+	case XDP_TX:
+		fallthrough;
+	case XDP_REDIRECT:
+		fallthrough;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(dev, xdp_prog, act);
+		act = XDP_DROP;
+		break;
+	}
+
+	if (act == XDP_DROP) {
+		xdp_return_buff(xdp);
+		xdp = NULL;
+	}
+
+	return xdp;
+}
+
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx)
 {
@@ -463,6 +511,11 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 {
 	struct net_device *dev = dst->dev;
 
+	if (dst->xdp_prog) {
+		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
+		if (!xdp)
+			return 0;
+	}
 	return __xdp_enqueue(dev, xdp, dev_rx);
 }
 
@@ -499,6 +552,8 @@ static void __dev_map_entry_free(struct rcu_head *rcu)
 	struct bpf_dtab_netdev *dev;
 
 	dev = container_of(rcu, struct bpf_dtab_netdev, rcu);
+	if (dev->xdp_prog)
+		bpf_prog_put(dev->xdp_prog);
 	dev_put(dev->dev);
 	kfree(dev);
 }
@@ -549,9 +604,10 @@ static int dev_map_hash_delete_elem(struct bpf_map *map, void *key)
 
 static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 						    struct bpf_dtab *dtab,
-						    u32 ifindex,
+						    u32 ifindex, u32 prog_id,
 						    unsigned int idx)
 {
+	struct bpf_prog *prog = NULL;
 	struct bpf_dtab_netdev *dev;
 
 	dev = kmalloc_node(sizeof(*dev), GFP_ATOMIC | __GFP_NOWARN,
@@ -563,12 +619,23 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 	if (!dev->dev)
 		goto err_out;
 
+	if (prog_id) {
+		prog = bpf_prog_by_id(prog_id);
+		if (IS_ERR(prog) || prog->type != BPF_PROG_TYPE_XDP ||
+		    prog->expected_attach_type != BPF_XDP_DEVMAP)
+			goto err_dev;
+	}
+
 	dev->idx = idx;
 	dev->dtab = dtab;
 
+	dev->xdp_prog = prog;
 	dev->val.ifindex = ifindex;
+	dev->val.prog_id = prog_id;
 
 	return dev;
+err_dev:
+	dev_put(dev->dev);
 err_out:
 	kfree(dev);
 	return ERR_PTR(-EINVAL);
@@ -580,7 +647,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dev, *old_dev;
 	u32 i = *(u32 *)key;
-	u32 ifindex;
+	u32 ifindex, id = 0;
 
 	if (map->value_size == 4) {
 		ifindex = *(u32 *)value;
@@ -588,6 +655,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 		struct dev_map_ext_val *val = value;
 
 		ifindex = val->ifindex;
+		id = val->prog_id;
 	}
 
 	if (unlikely(map_flags > BPF_EXIST))
@@ -599,8 +667,11 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 
 	if (!ifindex) {
 		dev = NULL;
+		/* can not specify id if ifindex is 0 */
+		if (id)
+			return -EINVAL;
 	} else {
-		dev = __dev_map_alloc_node(net, dtab, ifindex, i);
+		dev = __dev_map_alloc_node(net, dtab, ifindex, id, i);
 		if (IS_ERR(dev))
 			return PTR_ERR(dev);
 	}
@@ -630,8 +701,8 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 	struct bpf_dtab_netdev *dev, *old_dev;
 	u32 idx = *(u32 *)key;
 	unsigned long flags;
+	u32 ifindex, id = 0;
 	int err = -EEXIST;
-	u32 ifindex;
 
 	if (map->value_size == 4) {
 		ifindex = *(u32 *)value;
@@ -639,6 +710,7 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 		struct dev_map_ext_val *val = value;
 
 		ifindex = val->ifindex;
+		id = val->prog_id;
 	}
 
 	if (unlikely(map_flags > BPF_EXIST || !ifindex))
@@ -650,7 +722,7 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 	if (old_dev && (map_flags & BPF_NOEXIST))
 		goto out_err;
 
-	dev = __dev_map_alloc_node(net, dtab, ifindex, idx);
+	dev = __dev_map_alloc_node(net, dtab, ifindex, id, idx);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out_err;
diff --git a/net/core/dev.c b/net/core/dev.c
index f36bd3b21997..2571a8976cd4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5410,6 +5410,18 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 	struct bpf_prog *new = xdp->prog;
 	int ret = 0;
 
+	if (new) {
+		u32 i;
+
+		/* generic XDP does not work with DEVMAPs that can
+		 * have a bpf_prog installed
+		 */
+		for (i = 0; i < new->aux->used_map_cnt; i++) {
+			if (dev_map_can_have_prog(new->aux->used_maps[i]))
+				return -EINVAL;
+		}
+	}
+
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		rcu_assign_pointer(dev->xdp_prog, new);
@@ -8825,6 +8837,12 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return -EINVAL;
 		}
 
+		if (prog->expected_attach_type == BPF_XDP_DEVMAP) {
+			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
+			bpf_prog_put(prog);
+			return -EINVAL;
+		}
+
 		/* prog->aux->id may be 0 for orphaned device-bound progs */
 		if (prog->aux->id && prog->aux->id == prog_id) {
 			bpf_prog_put(prog);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 97e1fd19ff58..8c2c0d0c9a0e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -224,6 +224,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_GETPEERNAME,
 	BPF_CGROUP_INET4_GETSOCKNAME,
 	BPF_CGROUP_INET6_GETSOCKNAME,
+	BPF_XDP_DEVMAP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.21.1 (Apple Git-122.3)

