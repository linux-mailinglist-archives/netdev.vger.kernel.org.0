Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E271E82B2
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgE2P74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:59:56 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39243 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727975AbgE2P7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590767993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bYCPxtdFIiGZUN6W74kZUbXLvdY9TQpxmXT34V760Lg=;
        b=CxoZVySXsI+bdeysQlYxX5B53NQavyR1wiMCtQ5xGVQe9bMCffT9VciUMEicP/9PIfRG9i
        Zk1AVu+7TUP2ND/z4Jtqj/g0jHmwVjStC8UQEws6eHEOxBjtVlrkdOI3gludEQdWEIM0Rm
        pDVgPYyyMT/R/7EGdD0QoYT65nqobEc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-DfXgvlR5PiGifKHuN4s6XA-1; Fri, 29 May 2020 11:59:51 -0400
X-MC-Unique: DfXgvlR5PiGifKHuN4s6XA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D331BEC1A3;
        Fri, 29 May 2020 15:59:49 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2423768DC;
        Fri, 29 May 2020 15:59:46 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B0DAD300003E9;
        Fri, 29 May 2020 17:59:45 +0200 (CEST)
Subject: [PATCH bpf-next RFC 2/3] bpf: devmap dynamic map-value storage area
 based on BTF
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 29 May 2020 17:59:45 +0200
Message-ID: <159076798566.1387573.8417040652693679408.stgit@firesoul>
In-Reply-To: <159076794319.1387573.8722376887638960093.stgit@firesoul>
References: <159076794319.1387573.8722376887638960093.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devmap map-value can be read from BPF-prog side, and could be used for a
storage area per device. This could e.g. contain info on headers that need
to be added when packet egress this device.

This patchset adds a dynamic storage member to struct bpf_devmap_val. More
importantly the struct bpf_devmap_val is made dynamic via leveraging and
requiring BTF for struct sizes above 4. The only mandatory struct member is
'ifindex' with a fixed offset of zero.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 kernel/bpf/devmap.c |  216 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 185 insertions(+), 31 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 4ab67b2d8159..9cf2dadcc0fe 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -48,6 +48,7 @@
 #include <net/xdp.h>
 #include <linux/filter.h>
 #include <trace/events/xdp.h>
+#include <linux/btf.h>
 
 #define DEV_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
@@ -60,13 +61,30 @@ struct xdp_dev_bulk_queue {
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
-	__u32 ifindex;   /* device index */
+	__u32 ifindex;   /* device index - mandatory */
 	union {
 		int   fd;  /* prog fd on map write */
 		__u32 id;  /* prog id on map read */
 	} bpf_prog;
+	struct {
+		/* This 'storage' member is meant as a dynamically sized area,
+		 * that BPF developer can redefine.  As other members are added
+		 * overtime, this area can shrink, as size can be regained by
+		 * not using members above. Add new members above this struct.
+		 */
+		unsigned char data[24];
+	} storage;
 };
 
 struct bpf_dtab_netdev {
@@ -79,10 +97,18 @@ struct bpf_dtab_netdev {
 	struct bpf_devmap_val val;
 };
 
+struct bpf_devmap_val_cfg {
+	struct {
+		int ifindex;
+		int bpf_prog;
+	} btf_offset;
+};
+
 struct bpf_dtab {
 	struct bpf_map map;
 	struct bpf_dtab_netdev **netdev_map; /* DEVMAP type only */
 	struct list_head list;
+	struct bpf_devmap_val_cfg cfg;
 
 	/* these are only used for DEVMAP_HASH type maps */
 	struct hlist_head *dev_index_head;
@@ -116,20 +142,24 @@ static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
 
 static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 {
-	__u32 valsize = attr->value_size;
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
 	/* Lookup returns a pointer straight to dev->ifindex, so make sure the
 	 * verifier prevents writes from the BPF side
 	 */
@@ -199,6 +229,119 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
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
+		return off;
+	}
+	return off;
+}
+
+/* Expected BTF layout that match struct bpf_devmap_val */
+static const struct expect layout[] = {
+	{BTF_KIND_INT,		true,	 0,	 4,	"ifindex"},
+	{BTF_KIND_UNION,	false,	32,	 4,	"bpf_prog"},
+	{BTF_KIND_STRUCT,	false,	-1,	-1,	"storage"}
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
+	/* Validate VALUE have layout that match/map-to struct bpf_devmap_val
+	 * - With a flexible size of member 'storage'.
+	 */
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
@@ -601,42 +744,53 @@ static int dev_map_hash_delete_elem(struct bpf_map *map, void *key)
 	return ret;
 }
 
+static inline bool map_value_has_bpf_prog(const struct bpf_dtab *dtab)
+{
+	return dtab->cfg.btf_offset.bpf_prog >= 0;
+}
+
 static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
-						    struct bpf_dtab *dtab,
+						    struct bpf_map *map,
 						    struct bpf_devmap_val *val,
 						    unsigned int idx)
 {
+	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_prog *prog = NULL;
 	struct bpf_dtab_netdev *dev;
 
-	dev = kmalloc_node(sizeof(*dev), GFP_ATOMIC | __GFP_NOWARN,
+	dev = kzalloc_node(sizeof(*dev), GFP_ATOMIC | __GFP_NOWARN,
 			   dtab->map.numa_node);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
+	/* Member: ifindex is mandatory, both BTF and kABI */
 	dev->dev = dev_get_by_index(net, val->ifindex);
 	if (!dev->dev)
 		goto err_out;
 
-	if (val->bpf_prog.fd >= 0) {
-		prog = bpf_prog_get_type_dev(val->bpf_prog.fd,
-					     BPF_PROG_TYPE_XDP, false);
-		if (IS_ERR(prog))
-			goto err_put_dev;
-		if (prog->expected_attach_type != BPF_XDP_DEVMAP)
-			goto err_put_prog;
+	/* Member: bpf_prog union is optional, but have fixed offset if exist */
+	if (map_value_has_bpf_prog(dtab)) {
+		if (val->bpf_prog.fd >= 0) {
+			prog = bpf_prog_get_type_dev(val->bpf_prog.fd,
+						     BPF_PROG_TYPE_XDP, false);
+			if (IS_ERR(prog))
+				goto err_put_dev;
+			if (prog->expected_attach_type != BPF_XDP_DEVMAP)
+				goto err_put_prog;
+		}
+		if (prog) {
+			dev->xdp_prog = prog;
+			val->bpf_prog.id = prog->aux->id;
+		} else {
+			dev->xdp_prog = NULL;
+			val->bpf_prog.id = 0;
+		}
 	}
-
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
+
+	/* After adjustment copy map value to get storage area */
+	memcpy(&dev->val, val, map->value_size);
 
 	return dev;
 err_put_prog:
@@ -672,7 +826,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 		if (val.bpf_prog.fd != -1)
 			return -EINVAL;
 	} else {
-		dev = __dev_map_alloc_node(net, dtab, &val, i);
+		dev = __dev_map_alloc_node(net, map, &val, i);
 		if (IS_ERR(dev))
 			return PTR_ERR(dev);
 	}
@@ -717,7 +871,7 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 	if (old_dev && (map_flags & BPF_NOEXIST))
 		goto out_err;
 
-	dev = __dev_map_alloc_node(net, dtab, &val, idx);
+	dev = __dev_map_alloc_node(net, map, &val, idx);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out_err;
@@ -762,7 +916,7 @@ const struct bpf_map_ops dev_map_ops = {
 	.map_lookup_elem = dev_map_lookup_elem,
 	.map_update_elem = dev_map_update_elem,
 	.map_delete_elem = dev_map_delete_elem,
-	.map_check_btf = map_check_no_btf,
+	.map_check_btf = dev_map_check_btf,
 };
 
 const struct bpf_map_ops dev_map_hash_ops = {
@@ -772,7 +926,7 @@ const struct bpf_map_ops dev_map_hash_ops = {
 	.map_lookup_elem = dev_map_hash_lookup_elem,
 	.map_update_elem = dev_map_hash_update_elem,
 	.map_delete_elem = dev_map_hash_delete_elem,
-	.map_check_btf = map_check_no_btf,
+	.map_check_btf = dev_map_check_btf,
 };
 
 static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,


