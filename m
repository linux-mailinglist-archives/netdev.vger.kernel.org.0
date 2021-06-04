Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5589F39BB92
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 17:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhFDPTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 11:19:54 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:54948 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230374AbhFDPTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 11:19:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1622819883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ew2oDN9uOXatxBQ4LLdwymBBFALjUrTav2zPF6ydiF4=;
        b=PmPYj8u0I9/Jb6nV0nhvQM7LjqfR7bq9lxX7zTnhZHhMkyubPvdzy+EMF+hynlNGcv/Fuo
        zcovG6a7Yq2pzDIEXORUFL11CPyeytXXV9il1zLCbQ6VfTFLMjJNjTWfteVfbzuft7xoo6
        EV2am2nIb2c+AMTVyvHXkonV+SCS66w=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a67f05fe (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 4 Jun 2021 15:18:03 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH net 4/9] wireguard: use synchronize_net rather than synchronize_rcu
Date:   Fri,  4 Jun 2021 17:17:33 +0200
Message-Id: <20210604151738.220232-5-Jason@zx2c4.com>
In-Reply-To: <20210604151738.220232-1-Jason@zx2c4.com>
References: <20210604151738.220232-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many of the synchronization points are sometimes called under the rtnl
lock, which means we should use synchronize_net rather than
synchronize_rcu. Under the hood, this expands to using the expedited
flavor of function in the event that rtnl is held, in order to not stall
other concurrent changes.

This fixes some very, very long delays when removing multiple peers at
once, which would cause some operations to take several minutes.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/peer.c   | 6 +++---
 drivers/net/wireguard/socket.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/peer.c b/drivers/net/wireguard/peer.c
index cd5cb0292cb6..3a042d28eb2e 100644
--- a/drivers/net/wireguard/peer.c
+++ b/drivers/net/wireguard/peer.c
@@ -88,7 +88,7 @@ static void peer_make_dead(struct wg_peer *peer)
 	/* Mark as dead, so that we don't allow jumping contexts after. */
 	WRITE_ONCE(peer->is_dead, true);
 
-	/* The caller must now synchronize_rcu() for this to take effect. */
+	/* The caller must now synchronize_net() for this to take effect. */
 }
 
 static void peer_remove_after_dead(struct wg_peer *peer)
@@ -160,7 +160,7 @@ void wg_peer_remove(struct wg_peer *peer)
 	lockdep_assert_held(&peer->device->device_update_lock);
 
 	peer_make_dead(peer);
-	synchronize_rcu();
+	synchronize_net();
 	peer_remove_after_dead(peer);
 }
 
@@ -178,7 +178,7 @@ void wg_peer_remove_all(struct wg_device *wg)
 		peer_make_dead(peer);
 		list_add_tail(&peer->peer_list, &dead_peers);
 	}
-	synchronize_rcu();
+	synchronize_net();
 	list_for_each_entry_safe(peer, temp, &dead_peers, peer_list)
 		peer_remove_after_dead(peer);
 }
diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index d9ad850daa79..8c496b747108 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -430,7 +430,7 @@ void wg_socket_reinit(struct wg_device *wg, struct sock *new4,
 	if (new4)
 		wg->incoming_port = ntohs(inet_sk(new4)->inet_sport);
 	mutex_unlock(&wg->socket_update_lock);
-	synchronize_rcu();
+	synchronize_net();
 	sock_free(old4);
 	sock_free(old6);
 }
-- 
2.31.1

