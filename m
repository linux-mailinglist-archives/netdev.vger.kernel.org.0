Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9F41E8AFB
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 00:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgE2WH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 18:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbgE2WHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 18:07:25 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1E3720DD4;
        Fri, 29 May 2020 22:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590790043;
        bh=aKTsRnptCHDYa/ARNduJQlHTCdQ9a2HMI92d1lB0Des=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIjXcZEa7NR9huZdwJg5s06ptqHnKDAq5JmtxClDfu/kYUNz3bNBOgUYbYVmzWCdN
         fApDgyhRvil0trKAkgYNkSmtpPP4v/Y/fe49jpOaQHhs+xaTFfAT+FBeliY+w7pG/p
         gxKD4NTq+j4EIymCjceWq8Mnq4ZSva5cPCHCpx5M=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, toke@redhat.com, lorenzo@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH v4 bpf-next 2/5] bpf: Add support to attach bpf program to a devmap entry
Date:   Fri, 29 May 2020 16:07:13 -0600
Message-Id: <20200529220716.75383-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200529220716.75383-1-dsahern@kernel.org>
References: <20200529220716.75383-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF_XDP_DEVMAP attach type for use with programs associated with a
DEVMAP entry.

Allow DEVMAPs to associate a program with a device entry by adding
a bpf_prog.fd to 'struct bpf_devmap_val'. Values read show the program
id, so the fd and id are a union. bpf programs can get access to the
struct via vmlinux.h.

The program associated with the fd must have type XDP with expected
attach type BPF_XDP_DEVMAP. When a program is associated with a device
index, the program is run on an XDP_REDIRECT and before the buffer is
added to the per-cpu queue. At this point rxq data is still valid; the
next patch adds tx device information allowing the prorgam to see both
ingress and egress device indices.

XDP generic is skb based and XDP programs do not work with skb's. Block
the use case by walking maps used by a program that is to be attached
via xdpgeneric and fail if any of them are DEVMAP / DEVMAP_HASH with
> 4-byte values.

Block attach of BPF_XDP_DEVMAP programs to devices.

Signed-off-by: David Ahern <dsahern@kernel.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h            |  5 ++
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/devmap.c            | 88 ++++++++++++++++++++++++++++++++--
 net/core/dev.c                 | 18 +++++++
 tools/include/uapi/linux/bpf.h |  1 +
 5 files changed, 109 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e5884f7f801c..e042311f991f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1250,6 +1250,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
+bool dev_map_can_have_prog(struct bpf_map *map);
 
 struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key);
 void __cpu_map_flush(void);
@@ -1363,6 +1364,10 @@ static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_map *map
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
index 974ca6e948e3..65d7717bce2f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -225,6 +225,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_GETPEERNAME,
 	BPF_CGROUP_INET4_GETSOCKNAME,
 	BPF_CGROUP_INET6_GETSOCKNAME,
+	BPF_XDP_DEVMAP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a1459de0914e..0089d56617ec 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -63,12 +63,17 @@ struct xdp_dev_bulk_queue {
 /* DEVMAP values */
 struct bpf_devmap_val {
 	u32 ifindex;   /* device index */
+	union {
+		int fd;  /* prog fd on map write */
+		u32 id;  /* prog id on map read */
+	} bpf_prog;
 };
 
 struct bpf_dtab_netdev {
 	struct net_device *dev; /* must be first member, due to tracepoint */
 	struct hlist_node index_hlist;
 	struct bpf_dtab *dtab;
+	struct bpf_prog *xdp_prog;
 	struct rcu_head rcu;
 	unsigned int idx;
 	struct bpf_devmap_val val;
@@ -111,12 +116,18 @@ static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
 
 static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 {
+	u32 valsize = attr->value_size;
 	u64 cost = 0;
 	int err;
 
-	/* check sanity of attributes */
+	/* check sanity of attributes. 2 value sizes supported:
+	 * 4 bytes: ifindex
+	 * 8 bytes: ifindex + prog fd
+	 */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
-	    attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
+	    (valsize != offsetofend(struct bpf_devmap_val, ifindex) &&
+	     valsize != offsetofend(struct bpf_devmap_val, bpf_prog.fd)) ||
+	    attr->map_flags & ~DEV_CREATE_FLAG_MASK)
 		return -EINVAL;
 
 	/* Lookup returns a pointer straight to dev->ifindex, so make sure the
@@ -223,6 +234,8 @@ static void dev_map_free(struct bpf_map *map)
 
 			hlist_for_each_entry_safe(dev, next, head, index_hlist) {
 				hlist_del_rcu(&dev->index_hlist);
+				if (dev->xdp_prog)
+					bpf_prog_put(dev->xdp_prog);
 				dev_put(dev->dev);
 				kfree(dev);
 			}
@@ -237,6 +250,8 @@ static void dev_map_free(struct bpf_map *map)
 			if (!dev)
 				continue;
 
+			if (dev->xdp_prog)
+				bpf_prog_put(dev->xdp_prog);
 			dev_put(dev->dev);
 			kfree(dev);
 		}
@@ -323,6 +338,16 @@ static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
 	return -ENOENT;
 }
 
+bool dev_map_can_have_prog(struct bpf_map *map)
+{
+	if ((map->map_type == BPF_MAP_TYPE_DEVMAP ||
+	     map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) &&
+	    map->value_size != offsetofend(struct bpf_devmap_val, ifindex))
+		return true;
+
+	return false;
+}
+
 static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 {
 	struct net_device *dev = bq->dev;
@@ -447,6 +472,30 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
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
+	case XDP_PASS:
+		return xdp;
+	case XDP_DROP:
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(dev, xdp_prog, act);
+		break;
+	}
+
+	xdp_return_buff(xdp);
+	return NULL;
+}
+
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx)
 {
@@ -458,6 +507,11 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 {
 	struct net_device *dev = dst->dev;
 
+	if (dst->xdp_prog) {
+		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
+		if (!xdp)
+			return 0;
+	}
 	return __xdp_enqueue(dev, xdp, dev_rx);
 }
 
@@ -494,6 +548,8 @@ static void __dev_map_entry_free(struct rcu_head *rcu)
 	struct bpf_dtab_netdev *dev;
 
 	dev = container_of(rcu, struct bpf_dtab_netdev, rcu);
+	if (dev->xdp_prog)
+		bpf_prog_put(dev->xdp_prog);
 	dev_put(dev->dev);
 	kfree(dev);
 }
@@ -547,6 +603,7 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 						    struct bpf_devmap_val *val,
 						    unsigned int idx)
 {
+	struct bpf_prog *prog = NULL;
 	struct bpf_dtab_netdev *dev;
 
 	dev = kmalloc_node(sizeof(*dev), GFP_ATOMIC | __GFP_NOWARN,
@@ -558,11 +615,31 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 	if (!dev->dev)
 		goto err_out;
 
+	if (val->bpf_prog.fd >= 0) {
+		prog = bpf_prog_get_type_dev(val->bpf_prog.fd,
+					     BPF_PROG_TYPE_XDP, false);
+		if (IS_ERR(prog))
+			goto err_put_dev;
+		if (prog->expected_attach_type != BPF_XDP_DEVMAP)
+			goto err_put_prog;
+	}
+
 	dev->idx = idx;
 	dev->dtab = dtab;
+	if (prog) {
+		dev->xdp_prog = prog;
+		dev->val.bpf_prog.id = prog->aux->id;
+	} else {
+		dev->xdp_prog = NULL;
+		dev->val.bpf_prog.id = 0;
+	}
 	dev->val.ifindex = val->ifindex;
 
 	return dev;
+err_put_prog:
+	bpf_prog_put(prog);
+err_put_dev:
+	dev_put(dev->dev);
 err_out:
 	kfree(dev);
 	return ERR_PTR(-EINVAL);
@@ -572,8 +649,8 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 				 void *key, void *value, u64 map_flags)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
+	struct bpf_devmap_val val = { .bpf_prog.fd = -1 };
 	struct bpf_dtab_netdev *dev, *old_dev;
-	struct bpf_devmap_val val = { };
 	u32 i = *(u32 *)key;
 
 	if (unlikely(map_flags > BPF_EXIST))
@@ -588,6 +665,9 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 
 	if (!val.ifindex) {
 		dev = NULL;
+		/* can not specify fd if ifindex is 0 */
+		if (val.bpf_prog.fd != -1)
+			return -EINVAL;
 	} else {
 		dev = __dev_map_alloc_node(net, dtab, &val, i);
 		if (IS_ERR(dev))
@@ -616,8 +696,8 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 				     void *key, void *value, u64 map_flags)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
+	struct bpf_devmap_val val = { .bpf_prog.fd = -1 };
 	struct bpf_dtab_netdev *dev, *old_dev;
-	struct bpf_devmap_val val = { };
 	u32 idx = *(u32 *)key;
 	unsigned long flags;
 	int err = -EEXIST;
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
index 974ca6e948e3..65d7717bce2f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -225,6 +225,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_GETPEERNAME,
 	BPF_CGROUP_INET4_GETSOCKNAME,
 	BPF_CGROUP_INET6_GETSOCKNAME,
+	BPF_XDP_DEVMAP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.21.1 (Apple Git-122.3)

