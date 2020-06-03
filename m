Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099B41ED3AC
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 17:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgFCPo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 11:44:56 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725904AbgFCPoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 11:44:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591199093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XyOuRJsHowdUXUmUAi8QxDMWVoI0Rd9WkLrMvFHe7s0=;
        b=cn04slwu7TMT/M5sma11Tgisbo3+U0BtJrYPtBOsQzYYvTThVArU5VVHC6rrlc46i/kmOU
        dbFe+Ef7ib+8lKT7MTVdtpNkOa3EprbYNwEwHhWWMAJBw/6vurR3g4IRhcKeLdUP8vwYUY
        MQc8Qy8YVZlM6HnRXow4ETAOQfxlvQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-xWWntckVMt-mDPQohPVU0A-1; Wed, 03 Jun 2020 11:44:49 -0400
X-MC-Unique: xWWntckVMt-mDPQohPVU0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E66851883600;
        Wed,  3 Jun 2020 15:44:47 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8603F5C220;
        Wed,  3 Jun 2020 15:44:44 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 7BD5B300003EB;
        Wed,  3 Jun 2020 17:44:43 +0200 (CEST)
Subject: [PATCH bpf-next V1] bpf: devmap dynamic map-value area based on BTF
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Wed, 03 Jun 2020 17:44:43 +0200
Message-ID: <159119908343.1649854.17264745504030734400.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent commit fbee97feed9b ("bpf: Add support to attach bpf program to a
devmap entry"), introduced ability to attach (and run) a separate XDP
bpf_prog for each devmap entry. A bpf_prog is added via a file-descriptor,
thus not using the feature requires using value minus-1. The UAPI is
extended via tail-extending struct bpf_devmap_val and using map->value_size
to determine the feature set.

There is a specific problem with dev_map_can_have_prog() check, which is
called from net/core/dev.c in generic_xdp_install() to refuse usage of
devmap's from generic-XDP that support these bpf_prog's. The check is size
based. This means that all newer features will be blocked from being use by
generic-XDP.

This patch allows userspace to skip handling of 'bpf_prog' on map-inserts.
The feature can be skipped, via not including the member 'bpf_prog' in the
map-value struct, which is propagated/described via BTF.

Fixes: fbee97feed9b ("bpf: Add support to attach bpf program to a devmap entry")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com
---
 kernel/bpf/devmap.c                                |  295 ++++++++++++++++----
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |    4 
 2 files changed, 235 insertions(+), 64 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 854b09beb16b..8a223557123c 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -48,6 +48,7 @@
 #include <net/xdp.h>
 #include <linux/filter.h>
 #include <trace/events/xdp.h>
+#include <linux/btf.h>
 
 #define DEV_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
@@ -60,10 +61,19 @@ struct xdp_dev_bulk_queue {
 	unsigned int count;
 };
 
-/* DEVMAP values */
+/* DEVMAP map-value layout.
+ *
+ * The struct data-layout of map-value is a configuration interface.
+ * BPF-prog side have read-only access to this memory.
+ *
+ * The layout might be different than below, because some struct members are
+ * optional.  This is made dynamic by requiring userspace provides an BTF
+ * description of the struct layout, when creating the BPF-map. Struct names
+ * are important and part of API, as BTF use these names to identify members.
+ */
 struct bpf_devmap_val {
 	u32 ifindex;   /* device index */
-	union {
+	union bpf_prog_union {
 		int fd;  /* prog fd on map write */
 		u32 id;  /* prog id on map read */
 	} bpf_prog;
@@ -76,13 +86,21 @@ struct bpf_dtab_netdev {
 	struct bpf_prog *xdp_prog;
 	struct rcu_head rcu;
 	unsigned int idx;
-	struct bpf_devmap_val val;
+	struct bpf_devmap_val val; /* actual layout defined by userspace BTF */
+};
+
+struct bpf_devmap_val_cfg {
+	struct {
+		int ifindex;
+		int bpf_prog;
+	} btf_offset;
 };
 
 struct bpf_dtab {
 	struct bpf_map map;
 	struct bpf_dtab_netdev **netdev_map; /* DEVMAP type only */
 	struct list_head list;
+	struct bpf_devmap_val_cfg cfg;
 
 	/* these are only used for DEVMAP_HASH type maps */
 	struct hlist_head *dev_index_head;
@@ -116,20 +134,27 @@ static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
 
 static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 {
-	u32 valsize = attr->value_size;
 	u64 cost = 0;
 	int err;
 
-	/* check sanity of attributes. 2 value sizes supported:
-	 * 4 bytes: ifindex
-	 * 8 bytes: ifindex + prog fd
-	 */
+	/* Value contents validated in dev_map_check_btf */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
-	    (valsize != offsetofend(struct bpf_devmap_val, ifindex) &&
-	     valsize != offsetofend(struct bpf_devmap_val, bpf_prog.fd)) ||
+	    attr->value_size > sizeof(struct bpf_devmap_val) ||
 	    attr->map_flags & ~DEV_CREATE_FLAG_MASK)
 		return -EINVAL;
 
+	/* Enforce BTF for userspace, unless dealing with legacy kABI */
+	if (attr->value_size != 4 &&
+	    (!attr->btf_key_type_id || !attr->btf_value_type_id))
+		return -EOPNOTSUPP;
+
+	/* Mark BTF offset's as invalid */
+	dtab->cfg.btf_offset.ifindex  = -1;
+	dtab->cfg.btf_offset.bpf_prog = -1;
+
+	if (attr->value_size == 4 &&  !attr->btf_value_type_id)
+		dtab->cfg.btf_offset.ifindex  = 0;
+
 	/* Lookup returns a pointer straight to dev->ifindex, so make sure the
 	 * verifier prevents writes from the BPF side
 	 */
@@ -199,6 +224,118 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	return &dtab->map;
 }
 
+struct expect {
+	u8 btf_kind;
+	bool mandatory;
+	int bit_offset;
+	int size;
+	const char *name;
+};
+
+/* Note: refactor and move to kernel/bpf/btf.c when other users appear */
+static int btf_find_expect_layout_offset(const struct btf *btf,
+					 const struct btf_type *value_type,
+					 const struct expect *layout)
+{
+	const struct btf_member *member;
+	u32 i, off = -ENOENT;
+
+	for_each_member(i, value_type, member) {
+		const struct btf_type *member_type;
+		const char *member_name;
+
+		member_type = btf_type_skip_modifiers(btf, member->type, NULL);
+		if (BTF_INFO_KIND(member_type->info) != layout->btf_kind) {
+			continue;
+		}
+
+		member_name = btf_name_by_offset(btf, member->name_off);
+		if (!member_name)
+			return -EINVAL;
+
+		if (strcmp(layout->name, member_name))
+			continue;
+
+		if (layout->size > 0 &&  // btf_type_has_size(member_type) &&
+		    member_type->size != layout->size)
+			continue;
+
+		off = btf_member_bit_offset(value_type, member);
+		if (layout->bit_offset > 0 &&
+		    layout->bit_offset != off) {
+			off = -ENOENT;
+			continue;
+		}
+
+		if (off % 8) /* valid C code cannot generate such BTF */
+			return -EINVAL;
+
+		return off;
+	}
+	return off;
+}
+
+/* Expected BTF layout that match struct bpf_devmap_val */
+static const struct expect layout[] = {
+	{BTF_KIND_INT,		true,	-1,	 4,	"ifindex"},
+	{BTF_KIND_UNION,	false,	-1,	 4,	"bpf_prog"}
+};
+
+static int dev_map_check_btf(const struct bpf_map *map,
+			     const struct btf *btf,
+			     const struct btf_type *key_type,
+			     const struct btf_type *value_type)
+{
+	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
+	u32 found_members_cnt = 0;
+	u32 int_data;
+	int off;
+	u32 i;
+
+	/* Validate KEY type and size */
+	if (BTF_INFO_KIND(key_type->info) != BTF_KIND_INT)
+		return -EOPNOTSUPP;
+
+	int_data = *(u32 *)(key_type + 1);
+	if (BTF_INT_BITS(int_data) != 32 || BTF_INT_OFFSET(int_data) != 0)
+		return -EOPNOTSUPP;
+
+	if (BTF_INFO_KIND(value_type->info) != BTF_KIND_STRUCT)
+		return -EOPNOTSUPP;
+
+	/* Struct/union members in BTF must not exceed (max) expected members */
+	if (btf_type_vlen(value_type) > ARRAY_SIZE(layout))
+			return -E2BIG;
+
+	for (i = 0; i < ARRAY_SIZE(layout); i++) {
+		off = btf_find_expect_layout_offset(btf, value_type, &layout[i]);
+
+		if (off < 0 && layout[i].mandatory)
+			return -EUCLEAN;
+
+		if (off >= 0)
+			found_members_cnt++;
+
+		/* Transfer layout config to map */
+		switch (i) {
+		case 0:
+			dtab->cfg.btf_offset.ifindex = off;
+			break;
+		case 1:
+			dtab->cfg.btf_offset.bpf_prog = off;
+			break;
+		default:
+			break;
+		}
+	}
+
+	/* Detect if BTF/vlen have members that were not found */
+	if (btf_type_vlen(value_type) > found_members_cnt)
+		return -E2BIG;
+
+	return 0;
+}
+
 static void dev_map_free(struct bpf_map *map)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
@@ -338,16 +475,6 @@ static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
 	return -ENOENT;
 }
 
-bool dev_map_can_have_prog(struct bpf_map *map)
-{
-	if ((map->map_type == BPF_MAP_TYPE_DEVMAP ||
-	     map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) &&
-	    map->value_size != offsetofend(struct bpf_devmap_val, ifindex))
-		return true;
-
-	return false;
-}
-
 static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 {
 	struct net_device *dev = bq->dev;
@@ -601,42 +728,101 @@ static int dev_map_hash_delete_elem(struct bpf_map *map, void *key)
 	return ret;
 }
 
+static inline bool map_value_has_bpf_prog(const struct bpf_dtab *dtab)
+{
+	return dtab->cfg.btf_offset.bpf_prog >= 0;
+}
+
+bool dev_map_can_have_prog(struct bpf_map *map)
+{
+	struct bpf_dtab *dtab;
+
+	if (map->map_type != BPF_MAP_TYPE_DEVMAP &&
+	    map->map_type != BPF_MAP_TYPE_DEVMAP_HASH)
+		return false;
+
+	dtab = container_of(map, struct bpf_dtab, map);
+	if (map_value_has_bpf_prog(dtab))
+		return true;
+
+	return false;
+}
+
+static union bpf_prog_union *map_value_ptr_bpf_prog(const struct bpf_dtab *dtab,
+						    void* val)
+{
+	u32 off = dtab->cfg.btf_offset.bpf_prog / 8;
+	union bpf_prog_union *bpf_prog = NULL;
+
+	bpf_prog  = (union bpf_prog_union *)(val + off);
+	return bpf_prog;
+}
+
+static int map_value_ifindex(const struct bpf_dtab *dtab, void* val)
+{
+	int ifindex = 0;
+	u32 off;
+
+	if (dtab->cfg.btf_offset.ifindex < 0)
+		goto out;
+
+	off = dtab->cfg.btf_offset.ifindex / 8;
+	ifindex = *(int *)(val + off);
+out:
+	return ifindex;
+}
+
 static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
-						    struct bpf_dtab *dtab,
-						    struct bpf_devmap_val *val,
+						    struct bpf_map *map,
+						    void *value,
 						    unsigned int idx)
 {
+	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_prog *prog = NULL;
 	struct bpf_dtab_netdev *dev;
+	int ifindex;
 
-	dev = kmalloc_node(sizeof(*dev), GFP_ATOMIC | __GFP_NOWARN,
+	dev = kzalloc_node(sizeof(*dev), GFP_ATOMIC | __GFP_NOWARN,
 			   dtab->map.numa_node);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	dev->dev = dev_get_by_index(net, val->ifindex);
+	/* Already verified value_size <= sizeof bpf_devmap_val */
+	memcpy(&dev->val, value, map->value_size);
+
+	/* Member: ifindex is mandatory, both BTF and kABI */
+	ifindex = map_value_ifindex(dtab, &dev->val);
+	if (!ifindex)
+		return ERR_PTR(-EINVAL);
+
+	dev->dev = dev_get_by_index(net, ifindex);
 	if (!dev->dev)
 		goto err_out;
 
-	if (val->bpf_prog.fd >= 0) {
-		prog = bpf_prog_get_type_dev(val->bpf_prog.fd,
-					     BPF_PROG_TYPE_XDP, false);
-		if (IS_ERR(prog))
-			goto err_put_dev;
-		if (prog->expected_attach_type != BPF_XDP_DEVMAP)
-			goto err_put_prog;
-	}
+	/* Member: bpf_prog union is optional */
+	if (map_value_has_bpf_prog(dtab)) {
+		union bpf_prog_union *bpf_prog;
 
+		bpf_prog = map_value_ptr_bpf_prog(dtab, &dev->val);
+
+		if (bpf_prog->fd >= 0) {
+			prog = bpf_prog_get_type_dev(bpf_prog->fd,
+						     BPF_PROG_TYPE_XDP, false);
+			if (IS_ERR(prog))
+				goto err_put_dev;
+			if (prog->expected_attach_type != BPF_XDP_DEVMAP)
+				goto err_put_prog;
+		}
+		if (prog) {
+			dev->xdp_prog = prog;
+			bpf_prog->id = prog->aux->id;
+		} else {
+			dev->xdp_prog = NULL;
+			bpf_prog->id = 0;
+		}
+	}
 	dev->idx = idx;
 	dev->dtab = dtab;
-	if (prog) {
-		dev->xdp_prog = prog;
-		dev->val.bpf_prog.id = prog->aux->id;
-	} else {
-		dev->xdp_prog = NULL;
-		dev->val.bpf_prog.id = 0;
-	}
-	dev->val.ifindex = val->ifindex;
 
 	return dev;
 err_put_prog:
@@ -652,7 +838,6 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 				 void *key, void *value, u64 map_flags)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	struct bpf_devmap_val val = { .bpf_prog.fd = -1 };
 	struct bpf_dtab_netdev *dev, *old_dev;
 	u32 i = *(u32 *)key;
 
@@ -663,19 +848,9 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 	if (unlikely(map_flags == BPF_NOEXIST))
 		return -EEXIST;
 
-	/* already verified value_size <= sizeof val */
-	memcpy(&val, value, map->value_size);
-
-	if (!val.ifindex) {
-		dev = NULL;
-		/* can not specify fd if ifindex is 0 */
-		if (val.bpf_prog.fd != -1)
-			return -EINVAL;
-	} else {
-		dev = __dev_map_alloc_node(net, dtab, &val, i);
-		if (IS_ERR(dev))
-			return PTR_ERR(dev);
-	}
+	dev = __dev_map_alloc_node(net, map, value, i);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
 
 	/* Use call_rcu() here to ensure rcu critical sections have completed
 	 * Remembering the driver side flush operation will happen before the
@@ -699,16 +874,12 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 				     void *key, void *value, u64 map_flags)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	struct bpf_devmap_val val = { .bpf_prog.fd = -1 };
 	struct bpf_dtab_netdev *dev, *old_dev;
 	u32 idx = *(u32 *)key;
 	unsigned long flags;
 	int err = -EEXIST;
 
-	/* already verified value_size <= sizeof val */
-	memcpy(&val, value, map->value_size);
-
-	if (unlikely(map_flags > BPF_EXIST || !val.ifindex))
+	if (unlikely(map_flags > BPF_EXIST))
 		return -EINVAL;
 
 	spin_lock_irqsave(&dtab->index_lock, flags);
@@ -717,7 +888,7 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 	if (old_dev && (map_flags & BPF_NOEXIST))
 		goto out_err;
 
-	dev = __dev_map_alloc_node(net, dtab, &val, idx);
+	dev = __dev_map_alloc_node(net, map, value, idx);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out_err;
@@ -762,7 +933,7 @@ const struct bpf_map_ops dev_map_ops = {
 	.map_lookup_elem = dev_map_lookup_elem,
 	.map_update_elem = dev_map_update_elem,
 	.map_delete_elem = dev_map_delete_elem,
-	.map_check_btf = map_check_no_btf,
+	.map_check_btf = dev_map_check_btf,
 };
 
 const struct bpf_map_ops dev_map_hash_ops = {
@@ -772,7 +943,7 @@ const struct bpf_map_ops dev_map_hash_ops = {
 	.map_lookup_elem = dev_map_hash_lookup_elem,
 	.map_update_elem = dev_map_hash_update_elem,
 	.map_delete_elem = dev_map_hash_delete_elem,
-	.map_check_btf = map_check_no_btf,
+	.map_check_btf = dev_map_check_btf,
 };
 
 static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
index deef0e050863..d2481ec10764 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
@@ -5,8 +5,8 @@
 
 struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP);
-	__uint(key_size, sizeof(__u32));
-	__uint(value_size, sizeof(struct bpf_devmap_val));
+	__type(key, u32);
+	__type(value, struct bpf_devmap_val);
 	__uint(max_entries, 4);
 } dm_ports SEC(".maps");
 


