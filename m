Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D544D1E8AF4
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 00:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgE2WHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 18:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbgE2WHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 18:07:23 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A440520B80;
        Fri, 29 May 2020 22:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590790042;
        bh=9ejb3JJZTO2uA6wVq2xDcVJjABkI3hNwj+8SeykZGaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iL+TJgVPNS1Q5m5eXFB+/kamhczdPd9S6b5EN8qUvNx5jozzV3UEpk2E1s27gh0JL
         /GVsEt7XQrl2e01ZiXaqcui3gV1YBk3ddoql7RZnaqIyJx53VpuoH8D50kX2uAcNf2
         GbWa9uGvEhMFTDO9W2LSnatW0zl3r8kb74Dd48bU=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, toke@redhat.com, lorenzo@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH v4 bpf-next 1/5] devmap: Formalize map value as a named struct
Date:   Fri, 29 May 2020 16:07:12 -0600
Message-Id: <20200529220716.75383-2-dsahern@kernel.org>
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

Add 'struct bpf_devmap_val' to formalize the expected values that can
be passed in for a DEVMAP. Update devmap code to use the struct.

Signed-off-by: David Ahern <dsahern@kernel.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/devmap.c | 45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a51d9fb7a359..a1459de0914e 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -60,12 +60,18 @@ struct xdp_dev_bulk_queue {
 	unsigned int count;
 };
 
+/* DEVMAP values */
+struct bpf_devmap_val {
+	u32 ifindex;   /* device index */
+};
+
 struct bpf_dtab_netdev {
 	struct net_device *dev; /* must be first member, due to tracepoint */
 	struct hlist_node index_hlist;
 	struct bpf_dtab *dtab;
 	struct rcu_head rcu;
 	unsigned int idx;
+	struct bpf_devmap_val val;
 };
 
 struct bpf_dtab {
@@ -472,18 +478,15 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
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
@@ -541,7 +544,7 @@ static int dev_map_hash_delete_elem(struct bpf_map *map, void *key)
 
 static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 						    struct bpf_dtab *dtab,
-						    u32 ifindex,
+						    struct bpf_devmap_val *val,
 						    unsigned int idx)
 {
 	struct bpf_dtab_netdev *dev;
@@ -551,16 +554,18 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
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
@@ -568,7 +573,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dev, *old_dev;
-	u32 ifindex = *(u32 *)value;
+	struct bpf_devmap_val val = { };
 	u32 i = *(u32 *)key;
 
 	if (unlikely(map_flags > BPF_EXIST))
@@ -578,10 +583,13 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
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
@@ -609,12 +617,15 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
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
@@ -623,7 +634,7 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 	if (old_dev && (map_flags & BPF_NOEXIST))
 		goto out_err;
 
-	dev = __dev_map_alloc_node(net, dtab, ifindex, idx);
+	dev = __dev_map_alloc_node(net, dtab, &val, idx);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out_err;
-- 
2.21.1 (Apple Git-122.3)

