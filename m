Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29ECC64DE74
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiLOQVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiLOQVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:21:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BD933C07
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 08:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671121227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MB0Ttgf9azxOIzx1p0f/RPHF2cWXqyuUsYswBifp1WA=;
        b=TeKQM5KxzKL5UQM0Aoh7f0aNuQfLxWpe2/8r+fyvbzBau4lVzPQSCJ0yCufOjG7nKwsWRW
        DXkcwpaXOrjpkAbRvKbmUaN+dKYNG00+rDpqj0CbU27ecVs0fZRz9Nh7jCTdxdAesbpv+g
        1xu5l3Oxf+rsoLDoroDq7Wt0HQMVDts=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-m2PO4ligMAOhbeHfJwwa_A-1; Thu, 15 Dec 2022 11:20:25 -0500
X-MC-Unique: m2PO4ligMAOhbeHfJwwa_A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F01893804526;
        Thu, 15 Dec 2022 16:20:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D7231121314;
        Thu, 15 Dec 2022 16:20:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 5/9] rxrpc: Fix locking issues in rxrpc_put_peer_locked()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 15 Dec 2022 16:20:21 +0000
Message-ID: <167112122167.152641.16949946906317090681.stgit@warthog.procyon.org.uk>
In-Reply-To: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
References: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that rxrpc_put_local() may call kthread_stop(), it can't be called
under spinlock as it might sleep.  This can cause a problem in the peer
keepalive code in rxrpc as it tries to avoid dropping the peer_hash_lock
from the point it needs to re-add peer->keepalive_link to going round the
loop again in rxrpc_peer_keepalive_dispatch().

Fix this by just dropping the lock when we don't need it and accepting that
we'll have to take it again.  This code is only called about every 20s for
each peer, so not very often.

This allows rxrpc_put_peer_unlocked() to be removed also.

If triggered, this bug produces an oops like the following, as reproduced
by a syzbot reproducer for a different oops[1]:

BUG: sleeping function called from invalid context at kernel/sched/completion.c:101
...
RCU nest depth: 0, expected: 0
3 locks held by kworker/u9:0/50:
 #0: ffff88810e74a138 ((wq_completion)krxrpcd){+.+.}-{0:0}, at: process_one_work+0x294/0x636
 #1: ffff8881013a7e20 ((work_completion)(&rxnet->peer_keepalive_work)){+.+.}-{0:0}, at: process_one_work+0x294/0x636
 #2: ffff88817d366390 (&rxnet->peer_hash_lock){+.+.}-{2:2}, at: rxrpc_peer_keepalive_dispatch+0x2bd/0x35f
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x4c/0x5f
 __might_resched+0x2cf/0x2f2
 __wait_for_common+0x87/0x1e8
 kthread_stop+0x14d/0x255
 rxrpc_peer_keepalive_dispatch+0x333/0x35f
 rxrpc_peer_keepalive_worker+0x2e9/0x449
 process_one_work+0x3c1/0x636
 worker_thread+0x25f/0x359
 kthread+0x1a6/0x1b5
 ret_from_fork+0x1f/0x30

Fixes: a275da62e8c1 ("rxrpc: Create a per-local endpoint receive queue and I/O thread")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/0000000000002b4a9f05ef2b616f@google.com/ [1]
---

 net/rxrpc/ar-internal.h |    1 -
 net/rxrpc/peer_event.c  |   10 +++++++---
 net/rxrpc/peer_object.c |   19 -------------------
 3 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 37f3aec784cc..5b732a4af009 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1073,7 +1073,6 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *);
 struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *, enum rxrpc_peer_trace);
 struct rxrpc_peer *rxrpc_get_peer_maybe(struct rxrpc_peer *, enum rxrpc_peer_trace);
 void rxrpc_put_peer(struct rxrpc_peer *, enum rxrpc_peer_trace);
-void rxrpc_put_peer_locked(struct rxrpc_peer *, enum rxrpc_peer_trace);
 
 /*
  * proc.c
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 6685bf917aa6..552ba84a255c 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -235,6 +235,7 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 	struct rxrpc_peer *peer;
 	const u8 mask = ARRAY_SIZE(rxnet->peer_keepalive) - 1;
 	time64_t keepalive_at;
+	bool use;
 	int slot;
 
 	spin_lock(&rxnet->peer_hash_lock);
@@ -247,9 +248,10 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 		if (!rxrpc_get_peer_maybe(peer, rxrpc_peer_get_keepalive))
 			continue;
 
-		if (__rxrpc_use_local(peer->local, rxrpc_local_use_peer_keepalive)) {
-			spin_unlock(&rxnet->peer_hash_lock);
+		use = __rxrpc_use_local(peer->local, rxrpc_local_use_peer_keepalive);
+		spin_unlock(&rxnet->peer_hash_lock);
 
+		if (use) {
 			keepalive_at = peer->last_tx_at + RXRPC_KEEPALIVE_TIME;
 			slot = keepalive_at - base;
 			_debug("%02x peer %u t=%d {%pISp}",
@@ -270,9 +272,11 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 			spin_lock(&rxnet->peer_hash_lock);
 			list_add_tail(&peer->keepalive_link,
 				      &rxnet->peer_keepalive[slot & mask]);
+			spin_unlock(&rxnet->peer_hash_lock);
 			rxrpc_unuse_local(peer->local, rxrpc_local_unuse_peer_keepalive);
 		}
-		rxrpc_put_peer_locked(peer, rxrpc_peer_put_keepalive);
+		rxrpc_put_peer(peer, rxrpc_peer_put_keepalive);
+		spin_lock(&rxnet->peer_hash_lock);
 	}
 
 	spin_unlock(&rxnet->peer_hash_lock);
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 608946dcc505..82de295393a0 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -438,25 +438,6 @@ void rxrpc_put_peer(struct rxrpc_peer *peer, enum rxrpc_peer_trace why)
 	}
 }
 
-/*
- * Drop a ref on a peer record where the caller already holds the
- * peer_hash_lock.
- */
-void rxrpc_put_peer_locked(struct rxrpc_peer *peer, enum rxrpc_peer_trace why)
-{
-	unsigned int debug_id = peer->debug_id;
-	bool dead;
-	int r;
-
-	dead = __refcount_dec_and_test(&peer->ref, &r);
-	trace_rxrpc_peer(debug_id, r - 1, why);
-	if (dead) {
-		hash_del_rcu(&peer->hash_link);
-		list_del_init(&peer->keepalive_link);
-		rxrpc_free_peer(peer);
-	}
-}
-
 /*
  * Make sure all peer records have been discarded.
  */


