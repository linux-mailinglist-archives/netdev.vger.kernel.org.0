Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C08CDEFE
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfJGKQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:16:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfJGKQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 06:16:14 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 396BF18C8907;
        Mon,  7 Oct 2019 10:16:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-125-72.rdu2.redhat.com [10.10.125.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 635EC1001B28;
        Mon,  7 Oct 2019 10:16:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 5/6] rxrpc: rxrpc_peer needs to hold a ref on the
 rxrpc_local record
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 07 Oct 2019 11:16:12 +0100
Message-ID: <157044337266.32635.16355496559521893007.stgit@warthog.procyon.org.uk>
In-Reply-To: <157044333551.32635.10133219357337058780.stgit@warthog.procyon.org.uk>
References: <157044333551.32635.10133219357337058780.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Mon, 07 Oct 2019 10:16:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rxrpc_peer record needs to hold a reference on the rxrpc_local record
it points as the peer is used as a base to access information in the
rxrpc_local record.

This can cause problems in __rxrpc_put_peer(), where we need the network
namespace pointer, and in rxrpc_send_keepalive(), where we need to access
the UDP socket, leading to symptoms like:

    BUG: KASAN: use-after-free in __rxrpc_put_peer net/rxrpc/peer_object.c:411
    [inline]
    BUG: KASAN: use-after-free in rxrpc_put_peer+0x685/0x6a0
    net/rxrpc/peer_object.c:435
    Read of size 8 at addr ffff888097ec0058 by task syz-executor823/24216

Fix this by taking a ref on the local record for the peer record.

Fixes: ace45bec6d77 ("rxrpc: Fix firewall route keepalive")
Fixes: 2baec2c3f854 ("rxrpc: Support network namespacing")
Reported-by: syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/peer_object.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index b700b7ecaa3d..64830d8c1fdb 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -216,7 +216,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 	peer = kzalloc(sizeof(struct rxrpc_peer), gfp);
 	if (peer) {
 		atomic_set(&peer->usage, 1);
-		peer->local = local;
+		peer->local = rxrpc_get_local(local);
 		INIT_HLIST_HEAD(&peer->error_targets);
 		peer->service_conns = RB_ROOT;
 		seqlock_init(&peer->service_conn_lock);
@@ -307,7 +307,6 @@ void rxrpc_new_incoming_peer(struct rxrpc_sock *rx, struct rxrpc_local *local,
 	unsigned long hash_key;
 
 	hash_key = rxrpc_peer_hash_key(local, &peer->srx);
-	peer->local = local;
 	rxrpc_init_peer(rx, peer, hash_key);
 
 	spin_lock(&rxnet->peer_hash_lock);
@@ -417,6 +416,7 @@ static void __rxrpc_put_peer(struct rxrpc_peer *peer)
 	list_del_init(&peer->keepalive_link);
 	spin_unlock_bh(&rxnet->peer_hash_lock);
 
+	rxrpc_put_local(peer->local);
 	kfree_rcu(peer, rcu);
 }
 
@@ -453,6 +453,7 @@ void rxrpc_put_peer_locked(struct rxrpc_peer *peer)
 	if (n == 0) {
 		hash_del_rcu(&peer->hash_link);
 		list_del_init(&peer->keepalive_link);
+		rxrpc_put_local(peer->local);
 		kfree_rcu(peer, rcu);
 	}
 }

