Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1DA39BB94
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 17:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhFDPTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 11:19:55 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:54948 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhFDPTy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 11:19:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1622819886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oBjY5vDoMMy6mIXgNjOV+szgQeVTSx5zMFLE7TfVt+g=;
        b=CppsgXqfq2kb1EWxc+aiUta+vUR1hBO77SpLtijLBzeEzAmfJQ5bqDZeyHoYwpP7yurDQY
        +m8PrhyynqqR3gUpi98WMw3gUJcv4ChKMLjeCAY+tvkxBhaZQyILJ6cSn2tiqg5XJ5LEr/
        STK5I3dXPbRVC2rPjTGO3pN/reHbKHM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 00ccca12 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 4 Jun 2021 15:18:05 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
Subject: [PATCH net 5/9] wireguard: peer: allocate in kmem_cache
Date:   Fri,  4 Jun 2021 17:17:34 +0200
Message-Id: <20210604151738.220232-6-Jason@zx2c4.com>
In-Reply-To: <20210604151738.220232-1-Jason@zx2c4.com>
References: <20210604151738.220232-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With deployments having upwards of 600k peers now, this somewhat heavy
structure could benefit from more fine-grained allocations.
Specifically, instead of using a 2048-byte slab for a 1544-byte object,
we can now use 1544-byte objects directly, thus saving almost 25%
per-peer, or with 600k peers, that's a savings of 303 MiB. This also
makes wireguard's memory usage more transparent in tools like slabtop
and /proc/slabinfo.

Fixes: 8b5553ace83c ("wireguard: queueing: get rid of per-peer ring buffers")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/main.c |  7 +++++++
 drivers/net/wireguard/peer.c | 21 +++++++++++++++++----
 drivers/net/wireguard/peer.h |  3 +++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/main.c b/drivers/net/wireguard/main.c
index 7a7d5f1a80fc..0a3ebfdac794 100644
--- a/drivers/net/wireguard/main.c
+++ b/drivers/net/wireguard/main.c
@@ -28,6 +28,10 @@ static int __init mod_init(void)
 #endif
 	wg_noise_init();
 
+	ret = wg_peer_init();
+	if (ret < 0)
+		goto err_peer;
+
 	ret = wg_device_init();
 	if (ret < 0)
 		goto err_device;
@@ -44,6 +48,8 @@ static int __init mod_init(void)
 err_netlink:
 	wg_device_uninit();
 err_device:
+	wg_peer_uninit();
+err_peer:
 	return ret;
 }
 
@@ -51,6 +57,7 @@ static void __exit mod_exit(void)
 {
 	wg_genetlink_uninit();
 	wg_device_uninit();
+	wg_peer_uninit();
 }
 
 module_init(mod_init);
diff --git a/drivers/net/wireguard/peer.c b/drivers/net/wireguard/peer.c
index 3a042d28eb2e..1acd00ab2fbc 100644
--- a/drivers/net/wireguard/peer.c
+++ b/drivers/net/wireguard/peer.c
@@ -15,6 +15,7 @@
 #include <linux/rcupdate.h>
 #include <linux/list.h>
 
+static struct kmem_cache *peer_cache;
 static atomic64_t peer_counter = ATOMIC64_INIT(0);
 
 struct wg_peer *wg_peer_create(struct wg_device *wg,
@@ -29,10 +30,10 @@ struct wg_peer *wg_peer_create(struct wg_device *wg,
 	if (wg->num_peers >= MAX_PEERS_PER_DEVICE)
 		return ERR_PTR(ret);
 
-	peer = kzalloc(sizeof(*peer), GFP_KERNEL);
+	peer = kmem_cache_zalloc(peer_cache, GFP_KERNEL);
 	if (unlikely(!peer))
 		return ERR_PTR(ret);
-	if (dst_cache_init(&peer->endpoint_cache, GFP_KERNEL))
+	if (unlikely(dst_cache_init(&peer->endpoint_cache, GFP_KERNEL)))
 		goto err;
 
 	peer->device = wg;
@@ -64,7 +65,7 @@ struct wg_peer *wg_peer_create(struct wg_device *wg,
 	return peer;
 
 err:
-	kfree(peer);
+	kmem_cache_free(peer_cache, peer);
 	return ERR_PTR(ret);
 }
 
@@ -193,7 +194,8 @@ static void rcu_release(struct rcu_head *rcu)
 	/* The final zeroing takes care of clearing any remaining handshake key
 	 * material and other potentially sensitive information.
 	 */
-	kfree_sensitive(peer);
+	memzero_explicit(peer, sizeof(*peer));
+	kmem_cache_free(peer_cache, peer);
 }
 
 static void kref_release(struct kref *refcount)
@@ -225,3 +227,14 @@ void wg_peer_put(struct wg_peer *peer)
 		return;
 	kref_put(&peer->refcount, kref_release);
 }
+
+int __init wg_peer_init(void)
+{
+	peer_cache = KMEM_CACHE(wg_peer, 0);
+	return peer_cache ? 0 : -ENOMEM;
+}
+
+void wg_peer_uninit(void)
+{
+	kmem_cache_destroy(peer_cache);
+}
diff --git a/drivers/net/wireguard/peer.h b/drivers/net/wireguard/peer.h
index 8d53b687a1d1..76e4d3128ad4 100644
--- a/drivers/net/wireguard/peer.h
+++ b/drivers/net/wireguard/peer.h
@@ -80,4 +80,7 @@ void wg_peer_put(struct wg_peer *peer);
 void wg_peer_remove(struct wg_peer *peer);
 void wg_peer_remove_all(struct wg_device *wg);
 
+int wg_peer_init(void);
+void wg_peer_uninit(void);
+
 #endif /* _WG_PEER_H */
-- 
2.31.1

