Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E83A39BB9B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 17:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhFDPUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 11:20:04 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:54988 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhFDPUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 11:20:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1622819894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u8KcRiC5mWVVM2THyvIX2Xl3zmS3c02PavxpNfenwpg=;
        b=iMjj2YQdc5ia0L6TzguFoF3wn3cD0KIqW4Hs2sSaULgAkb0Y3Jy+PIjvh+/1e57kJkgxcJ
        bwghpsxKjPpfVQgGskd4elWNrMlMXq9IyfYIIccioSbN7XmF2xHUKhEwIXPNfYK5lNoM83
        KSH/+LOaWUMawQ0b70LQg1cOLU7u/iw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9f590534 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 4 Jun 2021 15:18:13 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
Subject: [PATCH net 8/9] wireguard: allowedips: allocate nodes in kmem_cache
Date:   Fri,  4 Jun 2021 17:17:37 +0200
Message-Id: <20210604151738.220232-9-Jason@zx2c4.com>
In-Reply-To: <20210604151738.220232-1-Jason@zx2c4.com>
References: <20210604151738.220232-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit moved from O(n) to O(1) for removal, but in the
process introduced an additional pointer member to a struct that
increased the size from 60 to 68 bytes, putting nodes in the 128-byte
slab. With deployed systems having as many as 2 million nodes, this
represents a significant doubling in memory usage (128 MiB -> 256 MiB).
Fix this by using our own kmem_cache, that's sized exactly right. This
also makes wireguard's memory usage more transparent in tools like
slabtop and /proc/slabinfo.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/allowedips.c | 31 ++++++++++++++++++++++++------
 drivers/net/wireguard/allowedips.h |  5 ++++-
 drivers/net/wireguard/main.c       | 10 +++++++++-
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
index 2785cfd3a221..c540dce8d224 100644
--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -6,6 +6,8 @@
 #include "allowedips.h"
 #include "peer.h"
 
+static struct kmem_cache *node_cache;
+
 static void swap_endian(u8 *dst, const u8 *src, u8 bits)
 {
 	if (bits == 32) {
@@ -40,6 +42,11 @@ static void push_rcu(struct allowedips_node **stack,
 	}
 }
 
+static void node_free_rcu(struct rcu_head *rcu)
+{
+	kmem_cache_free(node_cache, container_of(rcu, struct allowedips_node, rcu));
+}
+
 static void root_free_rcu(struct rcu_head *rcu)
 {
 	struct allowedips_node *node, *stack[128] = {
@@ -49,7 +56,7 @@ static void root_free_rcu(struct rcu_head *rcu)
 	while (len > 0 && (node = stack[--len])) {
 		push_rcu(stack, node->bit[0], &len);
 		push_rcu(stack, node->bit[1], &len);
-		kfree(node);
+		kmem_cache_free(node_cache, node);
 	}
 }
 
@@ -164,7 +171,7 @@ static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key,
 		return -EINVAL;
 
 	if (!rcu_access_pointer(*trie)) {
-		node = kzalloc(sizeof(*node), GFP_KERNEL);
+		node = kmem_cache_zalloc(node_cache, GFP_KERNEL);
 		if (unlikely(!node))
 			return -ENOMEM;
 		RCU_INIT_POINTER(node->peer, peer);
@@ -180,7 +187,7 @@ static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key,
 		return 0;
 	}
 
-	newnode = kzalloc(sizeof(*newnode), GFP_KERNEL);
+	newnode = kmem_cache_zalloc(node_cache, GFP_KERNEL);
 	if (unlikely(!newnode))
 		return -ENOMEM;
 	RCU_INIT_POINTER(newnode->peer, peer);
@@ -213,10 +220,10 @@ static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key,
 		return 0;
 	}
 
-	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	node = kmem_cache_zalloc(node_cache, GFP_KERNEL);
 	if (unlikely(!node)) {
 		list_del(&newnode->peer_list);
-		kfree(newnode);
+		kmem_cache_free(node_cache, newnode);
 		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&node->peer_list);
@@ -306,7 +313,7 @@ void wg_allowedips_remove_by_peer(struct allowedips *table,
 		if (child)
 			child->parent_bit = node->parent_bit;
 		*rcu_dereference_protected(node->parent_bit, lockdep_is_held(lock)) = child;
-		kfree_rcu(node, rcu);
+		call_rcu(&node->rcu, node_free_rcu);
 
 		/* TODO: Note that we currently don't walk up and down in order to
 		 * free any potential filler nodes. This means that this function
@@ -350,4 +357,16 @@ struct wg_peer *wg_allowedips_lookup_src(struct allowedips *table,
 	return NULL;
 }
 
+int __init wg_allowedips_slab_init(void)
+{
+	node_cache = KMEM_CACHE(allowedips_node, 0);
+	return node_cache ? 0 : -ENOMEM;
+}
+
+void wg_allowedips_slab_uninit(void)
+{
+	rcu_barrier();
+	kmem_cache_destroy(node_cache);
+}
+
 #include "selftest/allowedips.c"
diff --git a/drivers/net/wireguard/allowedips.h b/drivers/net/wireguard/allowedips.h
index f08f552e6852..32d611aaf3cc 100644
--- a/drivers/net/wireguard/allowedips.h
+++ b/drivers/net/wireguard/allowedips.h
@@ -19,7 +19,7 @@ struct allowedips_node {
 	u8 bits[16] __aligned(__alignof(u64));
 
 	/* Keep rarely used members at bottom to be beyond cache line. */
-	struct allowedips_node *__rcu *parent_bit; /* XXX: this puts us at 68->128 bytes instead of 60->64 bytes!! */
+	struct allowedips_node *__rcu *parent_bit;
 	union {
 		struct list_head peer_list;
 		struct rcu_head rcu;
@@ -53,4 +53,7 @@ struct wg_peer *wg_allowedips_lookup_src(struct allowedips *table,
 bool wg_allowedips_selftest(void);
 #endif
 
+int wg_allowedips_slab_init(void);
+void wg_allowedips_slab_uninit(void);
+
 #endif /* _WG_ALLOWEDIPS_H */
diff --git a/drivers/net/wireguard/main.c b/drivers/net/wireguard/main.c
index 0a3ebfdac794..75dbe77b0b4b 100644
--- a/drivers/net/wireguard/main.c
+++ b/drivers/net/wireguard/main.c
@@ -21,10 +21,15 @@ static int __init mod_init(void)
 {
 	int ret;
 
+	ret = wg_allowedips_slab_init();
+	if (ret < 0)
+		goto err_allowedips;
+
 #ifdef DEBUG
+	ret = -ENOTRECOVERABLE;
 	if (!wg_allowedips_selftest() || !wg_packet_counter_selftest() ||
 	    !wg_ratelimiter_selftest())
-		return -ENOTRECOVERABLE;
+		goto err_peer;
 #endif
 	wg_noise_init();
 
@@ -50,6 +55,8 @@ static int __init mod_init(void)
 err_device:
 	wg_peer_uninit();
 err_peer:
+	wg_allowedips_slab_uninit();
+err_allowedips:
 	return ret;
 }
 
@@ -58,6 +65,7 @@ static void __exit mod_exit(void)
 	wg_genetlink_uninit();
 	wg_device_uninit();
 	wg_peer_uninit();
+	wg_allowedips_slab_uninit();
 }
 
 module_init(mod_init);
-- 
2.31.1

