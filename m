Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0921E5220
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 02:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgE1AOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 20:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgE1AO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 20:14:27 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D19E212CC;
        Thu, 28 May 2020 00:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590624866;
        bh=xMD1jGWNAzVYiA5n3C1gzcMHP3JwCOSHyMffh1X7S8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+L8PKpC0QeL2BqmTEtiVRx39J9LGN0v5byz4o35ed3QO9vW85eGyVocKxVmgHxWu
         4GtbslUdvoSUi4gVk4rpQmdwtPLsaH2PH9jv1/lbNORy6Wvr4eRzddLaN5QmOM6z40
         cTMLg4zgWDtNLL1FDBsGHHXmcLmjPKa4wAhpeqX0=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com
Subject: [PATCH v2 bpf-next 1/5] devmap: Formalize map value as a named struct
Date:   Wed, 27 May 2020 18:14:19 -0600
Message-Id: <20200528001423.58575-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200528001423.58575-1-dsahern@kernel.org>
References: <20200528001423.58575-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add 'struct devmap_val' to the bpf uapi to formalize the
expected values that can be passed in for a DEVMAP.
Update devmap code to use the struct.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/uapi/linux/bpf.h       |  5 ++++
 kernel/bpf/devmap.c            | 43 ++++++++++++++++++++--------------
 tools/include/uapi/linux/bpf.h |  5 ++++
 3 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 54b93f8b49b8..d27302ecaa9c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3625,6 +3625,11 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 };
 
+/* DEVMAP values */
+struct devmap_val {
+	__u32 ifindex;   /* device index */
+};
+
 enum sk_action {
 	SK_DROP = 0,
 	SK_PASS,
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a51d9fb7a359..069a50113e26 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -66,6 +66,7 @@ struct bpf_dtab_netdev {
 	struct bpf_dtab *dtab;
 	struct rcu_head rcu;
 	unsigned int idx;
+	struct devmap_val val;
 };
 
 struct bpf_dtab {
@@ -110,7 +111,8 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 
 	/* check sanity of attributes */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
-	    attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
+	    attr->value_size > sizeof(struct devmap_val) ||
+	    attr->map_flags & ~DEV_CREATE_FLAG_MASK)
 		return -EINVAL;
 
 	/* Lookup returns a pointer straight to dev->ifindex, so make sure the
@@ -472,18 +474,15 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
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
@@ -541,7 +540,7 @@ static int dev_map_hash_delete_elem(struct bpf_map *map, void *key)
 
 static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 						    struct bpf_dtab *dtab,
-						    u32 ifindex,
+						    struct devmap_val *val,
 						    unsigned int idx)
 {
 	struct bpf_dtab_netdev *dev;
@@ -551,16 +550,18 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
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
@@ -568,7 +569,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dev, *old_dev;
-	u32 ifindex = *(u32 *)value;
+	struct devmap_val val = { };
 	u32 i = *(u32 *)key;
 
 	if (unlikely(map_flags > BPF_EXIST))
@@ -578,10 +579,13 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
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
@@ -609,12 +613,15 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dev, *old_dev;
-	u32 ifindex = *(u32 *)value;
+	struct devmap_val val = { };
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
@@ -623,7 +630,7 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 	if (old_dev && (map_flags & BPF_NOEXIST))
 		goto out_err;
 
-	dev = __dev_map_alloc_node(net, dtab, ifindex, idx);
+	dev = __dev_map_alloc_node(net, dtab, &val, idx);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out_err;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 54b93f8b49b8..d27302ecaa9c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3625,6 +3625,11 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 };
 
+/* DEVMAP values */
+struct devmap_val {
+	__u32 ifindex;   /* device index */
+};
+
 enum sk_action {
 	SK_DROP = 0,
 	SK_PASS,
-- 
2.21.1 (Apple Git-122.3)

