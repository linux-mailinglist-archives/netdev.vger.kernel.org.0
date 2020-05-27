Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFA01E3474
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgE0BJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgE0BJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:09:09 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB022088E;
        Wed, 27 May 2020 01:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590541749;
        bh=EVKvZTAKo51BxuCC6GxeQuKZYFAGqYw71tiDWCtvi/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNZfJai0QQX02VUVwRjCRAZjEO/s9TS6yi2aW+xhTupPqSb/XgT7QC3AaLyt/0dRv
         B5Ylgpz3U2Mjh8H4JrKJTYXEPazoyDr+7ytC3WlvZr4xvnoABcMyqiDfJhfbTTLuAq
         u/nBGIbgQPD/+s/IbNAPU0xK0fDajvQ3zT+DdHXo=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH bpf-next 1/5] bpf: Handle 8-byte values in DEVMAP and DEVMAP_HASH
Date:   Tue, 26 May 2020 19:09:01 -0600
Message-Id: <20200527010905.48135-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200527010905.48135-1-dsahern@kernel.org>
References: <20200527010905.48135-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to DEVMAP and DEVMAP_HASH to support 8-byte values as a
<device index, program id> pair. To do this, a new struct is needed in
bpf_dtab_netdev to hold the values to return on lookup.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 kernel/bpf/devmap.c | 56 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 13 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a51d9fb7a359..95db6d8beebc 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -60,12 +60,22 @@ struct xdp_dev_bulk_queue {
 	unsigned int count;
 };
 
+/* devmap value can be dev index or dev index + prog fd/id */
+struct dev_map_ext_val {
+	u32 ifindex;	/* must be first for compat with 4-byte values */
+	union {
+		int prog_fd;  /* prog fd on write */
+		u32 prog_id;  /* prog id on read */
+	};
+};
+
 struct bpf_dtab_netdev {
 	struct net_device *dev; /* must be first member, due to tracepoint */
 	struct hlist_node index_hlist;
 	struct bpf_dtab *dtab;
 	struct rcu_head rcu;
 	unsigned int idx;
+	struct dev_map_ext_val val;
 };
 
 struct bpf_dtab {
@@ -108,9 +118,13 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 	u64 cost = 0;
 	int err;
 
-	/* check sanity of attributes */
+	/* check sanity of attributes. 2 value sizes supported:
+	 * 4 bytes: ifindex
+	 * 8 bytes: ifindex + prog fd
+	 */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
-	    attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
+	    (attr->value_size != 4 && attr->value_size != 8) ||
+	    attr->map_flags & ~DEV_CREATE_FLAG_MASK)
 		return -EINVAL;
 
 	/* Lookup returns a pointer straight to dev->ifindex, so make sure the
@@ -472,18 +486,15 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 static void *dev_map_lookup_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_dtab_netdev *obj = __dev_map_lookup_elem(map, *(u32 *)key);
-	struct net_device *dev = obj ? obj->dev : NULL;
 
-	return dev ? &dev->ifindex : NULL;
+	return obj ? &obj->val : NULL;
 }
 
 static void *dev_map_hash_lookup_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_dtab_netdev *obj = __dev_map_hash_lookup_elem(map,
 								*(u32 *)key);
-	struct net_device *dev = obj ? obj->dev : NULL;
-
-	return dev ? &dev->ifindex : NULL;
+	return obj ? &obj->val : NULL;
 }
 
 static void __dev_map_entry_free(struct rcu_head *rcu)
@@ -552,15 +563,18 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 		return ERR_PTR(-ENOMEM);
 
 	dev->dev = dev_get_by_index(net, ifindex);
-	if (!dev->dev) {
-		kfree(dev);
-		return ERR_PTR(-EINVAL);
-	}
+	if (!dev->dev)
+		goto err_out;
 
 	dev->idx = idx;
 	dev->dtab = dtab;
 
+	dev->val.ifindex = ifindex;
+
 	return dev;
+err_out:
+	kfree(dev);
+	return ERR_PTR(-EINVAL);
 }
 
 static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
@@ -568,8 +582,16 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dev, *old_dev;
-	u32 ifindex = *(u32 *)value;
 	u32 i = *(u32 *)key;
+	u32 ifindex;
+
+	if (map->value_size == 4) {
+		ifindex = *(u32 *)value;
+	} else {
+		struct dev_map_ext_val *val = value;
+
+		ifindex = val->ifindex;
+	}
 
 	if (unlikely(map_flags > BPF_EXIST))
 		return -EINVAL;
@@ -609,10 +631,18 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dev, *old_dev;
-	u32 ifindex = *(u32 *)value;
 	u32 idx = *(u32 *)key;
 	unsigned long flags;
 	int err = -EEXIST;
+	u32 ifindex;
+
+	if (map->value_size == 4) {
+		ifindex = *(u32 *)value;
+	} else {
+		struct dev_map_ext_val *val = value;
+
+		ifindex = val->ifindex;
+	}
 
 	if (unlikely(map_flags > BPF_EXIST || !ifindex))
 		return -EINVAL;
-- 
2.21.1 (Apple Git-122.3)

