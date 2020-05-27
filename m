Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17811E3476
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgE0BJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:09:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbgE0BJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:09:11 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 544C820C09;
        Wed, 27 May 2020 01:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590541750;
        bh=woi69U0MvLIHbd7SKZKRg4mL1cYmCUdiJCJmqLrp6fU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lb55FrAl2ojUyI/UT+bfQhUaqYuwe4nwDcFKTUz2vsrun+p5dHSQLJzhA9p+vGF8q
         MoXSkouuPP9I/PuugtM8+BRKoFh1ji7b20qfOAYAD9WqY/br52RWzpA5ajiCLbmS5t
         3fy1Wu0jkVZdwXXmMUzR1eUPWUhKLhF8h2DhDPRk=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH bpf-next 2/5] bpf: Add support to attach bpf program to a devmap entry
Date:   Tue, 26 May 2020 19:09:02 -0600
Message-Id: <20200527010905.48135-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200527010905.48135-1-dsahern@kernel.org>
References: <20200527010905.48135-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF_XDP_DEVMAP attach type for use with programs associated with a
DEVMAP entry.

DEVMAPs can associate a program with a device entry by setting the
value to <index, fd> pair. The program associated with the fd must have
type XDP with expected attach type BPF_XDP_DEVMAP. When a program is
associated with a device index, the program is run on an XDP_REDIRECT
and before the buffer is added to the per-cpu queue. At this point
rxq data is still valid; the next patch adds tx device information
allowing the prorgam to see both ingress and egress device indices.

XDP generic is skb based and XDP programs do not work with skb's. Block
the use case by walking maps used by a program that is to be attached
via xdpgeneric and fail if any of them are DEVMAP / DEVMAP_HASH with
8-bytes values.

Block attach of BPF_XDP_DEVMAP programs to devices.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 include/linux/bpf.h            |  5 ++
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/devmap.c            | 92 ++++++++++++++++++++++++++++++----
 net/core/dev.c                 | 18 +++++++
 tools/include/uapi/linux/bpf.h |  1 +
 5 files changed, 108 insertions(+), 9 deletions(-)

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
index 95db6d8beebc..7658b3e2e7fc 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -73,6 +73,7 @@ struct bpf_dtab_netdev {
 	struct net_device *dev; /* must be first member, due to tracepoint */
 	struct hlist_node index_hlist;
 	struct bpf_dtab *dtab;
+	struct bpf_prog *xdp_prog;
 	struct rcu_head rcu;
 	unsigned int idx;
 	struct dev_map_ext_val val;
@@ -231,6 +232,8 @@ static void dev_map_free(struct bpf_map *map)
 
 			hlist_for_each_entry_safe(dev, next, head, index_hlist) {
 				hlist_del_rcu(&dev->index_hlist);
+				if (dev->xdp_prog)
+					bpf_prog_put(dev->xdp_prog);
 				dev_put(dev->dev);
 				kfree(dev);
 			}
@@ -245,6 +248,8 @@ static void dev_map_free(struct bpf_map *map)
 			if (!dev)
 				continue;
 
+			if (dev->xdp_prog)
+				bpf_prog_put(dev->xdp_prog);
 			dev_put(dev->dev);
 			kfree(dev);
 		}
@@ -331,6 +336,16 @@ static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
 	return -ENOENT;
 }
 
+bool dev_map_can_have_prog(struct bpf_map *map)
+{
+	if ((map->map_type == BPF_MAP_TYPE_DEVMAP ||
+	     map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) &&
+	    map->value_size != 4)
+		return true;
+
+	return false;
+}
+
 static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 {
 	struct net_device *dev = bq->dev;
@@ -455,6 +470,35 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
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
@@ -466,6 +510,11 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 {
 	struct net_device *dev = dst->dev;
 
+	if (dst->xdp_prog) {
+		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
+		if (!xdp)
+			return 0;
+	}
 	return __xdp_enqueue(dev, xdp, dev_rx);
 }
 
@@ -502,6 +551,8 @@ static void __dev_map_entry_free(struct rcu_head *rcu)
 	struct bpf_dtab_netdev *dev;
 
 	dev = container_of(rcu, struct bpf_dtab_netdev, rcu);
+	if (dev->xdp_prog)
+		bpf_prog_put(dev->xdp_prog);
 	dev_put(dev->dev);
 	kfree(dev);
 }
@@ -552,9 +603,10 @@ static int dev_map_hash_delete_elem(struct bpf_map *map, void *key)
 
 static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 						    struct bpf_dtab *dtab,
-						    u32 ifindex,
+						    u32 ifindex, int fd,
 						    unsigned int idx)
 {
+	struct bpf_prog *prog = NULL;
 	struct bpf_dtab_netdev *dev;
 
 	dev = kmalloc_node(sizeof(*dev), GFP_ATOMIC | __GFP_NOWARN,
@@ -566,12 +618,30 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 	if (!dev->dev)
 		goto err_out;
 
+	if (fd >= 0) {
+		prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP, false);
+		if (IS_ERR(prog))
+			goto err_put_dev;
+		if (prog->expected_attach_type != BPF_XDP_DEVMAP)
+			goto err_put_prog;
+	}
+
 	dev->idx = idx;
 	dev->dtab = dtab;
-
+	if (prog) {
+		dev->xdp_prog = prog;
+		dev->val.prog_id = prog->aux->id;
+	} else {
+		dev->xdp_prog = NULL;
+		dev->val.prog_id = 0;
+	}
 	dev->val.ifindex = ifindex;
 
 	return dev;
+err_put_prog:
+	bpf_prog_put(prog);
+err_put_dev:
+	dev_put(dev->dev);
 err_out:
 	kfree(dev);
 	return ERR_PTR(-EINVAL);
@@ -582,8 +652,8 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dev, *old_dev;
-	u32 i = *(u32 *)key;
-	u32 ifindex;
+	u32 i = *(u32 *)key, ifindex;
+	int fd = -1;
 
 	if (map->value_size == 4) {
 		ifindex = *(u32 *)value;
@@ -591,6 +661,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 		struct dev_map_ext_val *val = value;
 
 		ifindex = val->ifindex;
+		fd = val->prog_fd;
 	}
 
 	if (unlikely(map_flags > BPF_EXIST))
@@ -602,8 +673,11 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 
 	if (!ifindex) {
 		dev = NULL;
+		/* can not specify fd if ifindex is 0 */
+		if (fd != -1)
+			return -EINVAL;
 	} else {
-		dev = __dev_map_alloc_node(net, dtab, ifindex, i);
+		dev = __dev_map_alloc_node(net, dtab, ifindex, fd, i);
 		if (IS_ERR(dev))
 			return PTR_ERR(dev);
 	}
@@ -631,10 +705,9 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dev, *old_dev;
-	u32 idx = *(u32 *)key;
+	u32 idx = *(u32 *)key, ifindex;
+	int err = -EEXIST, fd = -1;
 	unsigned long flags;
-	int err = -EEXIST;
-	u32 ifindex;
 
 	if (map->value_size == 4) {
 		ifindex = *(u32 *)value;
@@ -642,6 +715,7 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 		struct dev_map_ext_val *val = value;
 
 		ifindex = val->ifindex;
+		fd = val->prog_fd;
 	}
 
 	if (unlikely(map_flags > BPF_EXIST || !ifindex))
@@ -653,7 +727,7 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 	if (old_dev && (map_flags & BPF_NOEXIST))
 		goto out_err;
 
-	dev = __dev_map_alloc_node(net, dtab, ifindex, idx);
+	dev = __dev_map_alloc_node(net, dtab, ifindex, fd, idx);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out_err;
diff --git a/net/core/dev.c b/net/core/dev.c
index ae37586f6ee8..10684833f864 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5420,6 +5420,18 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 	struct bpf_prog *new = xdp->prog;
 	int ret = 0;
 
+	if (new) {
+		u32 i;
+
+		/* generic XDP does not work with DEVMAPs that can
+		 * have a bpf_prog installed on an entry
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
@@ -8835,6 +8847,12 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
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

