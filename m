Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140751E7548
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 07:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgE2FVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 01:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgE2FVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 01:21:17 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE4D12100A;
        Fri, 29 May 2020 05:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590729676;
        bh=WGhClBxntw2URuQedtHNHFBhgm6Dy7i9QMwjGQ2hubg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wH4xfmjW9/DOmvKFs0VgAcYEVZU8mpq2DOgi7t58pkmDTDDwWS3pG6Oicvxz7yRfZ
         /YBbeoJeXQ3YKakIRv9X0coRRYb0/NXQEkpb3jKJuQAwzWimxEVVAyYG7zLPbxPFV/
         DFxNPLVjQBxbWWIjRvWu1pIiC4m1wCx5TvDjwm+A=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, toke@redhat.com, lorenzo@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH v3 bpf-next 1/5] devmap: Formalize map value as a named struct
Date:   Thu, 28 May 2020 23:20:53 -0600
Message-Id: <20200529052057.69378-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200529052057.69378-1-dsahern@kernel.org>
References: <20200529052057.69378-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 'struct bpf_devmap_val' to the bpf uapi to formalize the
expected values that can be passed in for a DEVMAP.
Update devmap code to use the struct.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 include/uapi/linux/bpf.h       |  5 +++++
 kernel/bpf/devmap.c            | 40 +++++++++++++++++++---------------
 tools/include/uapi/linux/bpf.h |  5 +++++
 3 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 54b93f8b49b8..42c884dfbad9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3625,6 +3625,11 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 };
 
+/* DEVMAP values */
+struct bpf_devmap_val {
+	__u32 ifindex;   /* device index */
+};
+
 enum sk_action {
 	SK_DROP = 0,
 	SK_PASS,
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a51d9fb7a359..2887fe6d1e1d 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -66,6 +66,7 @@ struct bpf_dtab_netdev {
 	struct bpf_dtab *dtab;
 	struct rcu_head rcu;
 	unsigned int idx;
+	struct bpf_devmap_val val;
 };
 
 struct bpf_dtab {
@@ -472,18 +473,15 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
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
@@ -541,7 +539,7 @@ static int dev_map_hash_delete_elem(struct bpf_map *map, void *key)
 
 static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 						    struct bpf_dtab *dtab,
-						    u32 ifindex,
+						    struct bpf_devmap_val *val,
 						    unsigned int idx)
 {
 	struct bpf_dtab_netdev *dev;
@@ -551,16 +549,18 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	dev->dev = dev_get_by_index(net, ifindex);
-	if (!dev->dev) {
-		kfree(dev);
-		return ERR_PTR(-EINVAL);
-	}
+	dev->dev = dev_get_by_index(net, val->ifindex);
+	if (!dev->dev)
+		goto err_out;
 
 	dev->idx = idx;
 	dev->dtab = dtab;
+	dev->val.ifindex = val->ifindex;
 
 	return dev;
+err_out:
+	kfree(dev);
+	return ERR_PTR(-EINVAL);
 }
 
 static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
@@ -568,7 +568,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dev, *old_dev;
-	u32 ifindex = *(u32 *)value;
+	struct bpf_devmap_val val = { };
 	u32 i = *(u32 *)key;
 
 	if (unlikely(map_flags > BPF_EXIST))
@@ -578,10 +578,13 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 	if (unlikely(map_flags == BPF_NOEXIST))
 		return -EEXIST;
 
-	if (!ifindex) {
+	/* already verified value_size <= sizeof val */
+	memcpy(&val, value, map->value_size);
+
+	if (!val.ifindex) {
 		dev = NULL;
 	} else {
-		dev = __dev_map_alloc_node(net, dtab, ifindex, i);
+		dev = __dev_map_alloc_node(net, dtab, &val, i);
 		if (IS_ERR(dev))
 			return PTR_ERR(dev);
 	}
@@ -609,12 +612,15 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dev, *old_dev;
-	u32 ifindex = *(u32 *)value;
+	struct bpf_devmap_val val = { };
 	u32 idx = *(u32 *)key;
 	unsigned long flags;
 	int err = -EEXIST;
 
-	if (unlikely(map_flags > BPF_EXIST || !ifindex))
+	/* already verified value_size <= sizeof val */
+	memcpy(&val, value, map->value_size);
+
+	if (unlikely(map_flags > BPF_EXIST || !val.ifindex))
 		return -EINVAL;
 
 	spin_lock_irqsave(&dtab->index_lock, flags);
@@ -623,7 +629,7 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 	if (old_dev && (map_flags & BPF_NOEXIST))
 		goto out_err;
 
-	dev = __dev_map_alloc_node(net, dtab, ifindex, idx);
+	dev = __dev_map_alloc_node(net, dtab, &val, idx);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out_err;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 54b93f8b49b8..42c884dfbad9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3625,6 +3625,11 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 };
 
+/* DEVMAP values */
+struct bpf_devmap_val {
+	__u32 ifindex;   /* device index */
+};
+
 enum sk_action {
 	SK_DROP = 0,
 	SK_PASS,
-- 
2.21.1 (Apple Git-122.3)

