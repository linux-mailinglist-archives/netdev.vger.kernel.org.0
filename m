Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE7077AB71
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbfG3OuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728722AbfG3OuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 10:50:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AAC50C049E17;
        Tue, 30 Jul 2019 14:50:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99C2B60623;
        Tue, 30 Jul 2019 14:50:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/2] rxrpc: Fix potential deadlock
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 30 Jul 2019 15:50:18 +0100
Message-ID: <156449821803.9558.698598559203701656.stgit@warthog.procyon.org.uk>
In-Reply-To: <156449821120.9558.2821927090314866621.stgit@warthog.procyon.org.uk>
References: <156449821120.9558.2821927090314866621.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 30 Jul 2019 14:50:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---

 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/peer_event.c  |    2 +-
 net/rxrpc/peer_object.c |   18 ++++++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 80335b4ee4fd..822f45386e31 100644
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
index 9f2f45c09e58..7666ec72d37e 100644
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
index 9d3ce81cf8ae..9c3ac96f71cb 100644
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

