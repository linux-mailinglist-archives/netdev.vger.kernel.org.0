Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705618C925
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbfHNCMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbfHNCMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAF19208C2;
        Wed, 14 Aug 2019 02:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748771;
        bh=6Y7v6No6PsmmDaWMBYx4jzdQPDqHWu5vByZImdbGZVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgfMegnP3+BdDLmXms7CBAyPgm/7c428ELyyDVUv5EKaGRzJ3N7SYbK12rqs2IGXi
         xqGC7jA+vaDrRsEfBiOVxz+Cd+dXrFBlfDd12nIM62CYHftwAhMxO2mdkgaHAltSOz
         VKK+V6UYuRH+HKdRC8LaLqWs5plG95YozbgO8k48=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        syzbot+72af434e4b3417318f84@syzkaller.appspotmail.com,
        Marc Dionne <marc.dionne@auristor.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 059/123] rxrpc: Fix potential deadlock
Date:   Tue, 13 Aug 2019 22:09:43 -0400
Message-Id: <20190814021047.14828-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 60034d3d146b11922ab1db613bce062dddc0327a ]

There is a potential deadlock in rxrpc_peer_keepalive_dispatch() whereby
rxrpc_put_peer() is called with the peer_hash_lock held, but if it reduces
the peer's refcount to 0, rxrpc_put_peer() calls __rxrpc_put_peer() - which
the tries to take the already held lock.

Fix this by providing a version of rxrpc_put_peer() that can be called in
situations where the lock is already held.

The bug may produce the following lockdep report:

============================================
WARNING: possible recursive locking detected
5.2.0-next-20190718 #41 Not tainted
--------------------------------------------
kworker/0:3/21678 is trying to acquire lock:
00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at: spin_lock_bh
/./include/linux/spinlock.h:343 [inline]
00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at:
__rxrpc_put_peer /net/rxrpc/peer_object.c:415 [inline]
00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at:
rxrpc_put_peer+0x2d3/0x6a0 /net/rxrpc/peer_object.c:435

but task is already holding lock:
00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at: spin_lock_bh
/./include/linux/spinlock.h:343 [inline]
00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at:
rxrpc_peer_keepalive_dispatch /net/rxrpc/peer_event.c:378 [inline]
00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at:
rxrpc_peer_keepalive_worker+0x6b3/0xd02 /net/rxrpc/peer_event.c:430

Fixes: 330bdcfadcee ("rxrpc: Fix the keepalive generator [ver #2]")
Reported-by: syzbot+72af434e4b3417318f84@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-internal.h |  1 +
 net/rxrpc/peer_event.c  |  2 +-
 net/rxrpc/peer_object.c | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 80335b4ee4fd6..822f45386e311 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1061,6 +1061,7 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *);
 struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *);
 struct rxrpc_peer *rxrpc_get_peer_maybe(struct rxrpc_peer *);
 void rxrpc_put_peer(struct rxrpc_peer *);
+void rxrpc_put_peer_locked(struct rxrpc_peer *);
 
 /*
  * proc.c
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 9f2f45c09e583..7666ec72d37e5 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -378,7 +378,7 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 		spin_lock_bh(&rxnet->peer_hash_lock);
 		list_add_tail(&peer->keepalive_link,
 			      &rxnet->peer_keepalive[slot & mask]);
-		rxrpc_put_peer(peer);
+		rxrpc_put_peer_locked(peer);
 	}
 
 	spin_unlock_bh(&rxnet->peer_hash_lock);
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 9d3ce81cf8ae8..9c3ac96f71cbf 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -436,6 +436,24 @@ void rxrpc_put_peer(struct rxrpc_peer *peer)
 	}
 }
 
+/*
+ * Drop a ref on a peer record where the caller already holds the
+ * peer_hash_lock.
+ */
+void rxrpc_put_peer_locked(struct rxrpc_peer *peer)
+{
+	const void *here = __builtin_return_address(0);
+	int n;
+
+	n = atomic_dec_return(&peer->usage);
+	trace_rxrpc_peer(peer, rxrpc_peer_put, n, here);
+	if (n == 0) {
+		hash_del_rcu(&peer->hash_link);
+		list_del_init(&peer->keepalive_link);
+		kfree_rcu(peer, rcu);
+	}
+}
+
 /*
  * Make sure all peer records have been discarded.
  */
-- 
2.20.1

