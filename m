Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D538CDF07
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfJGKQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:16:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbfJGKQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 06:16:21 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2EB3618C8907;
        Mon,  7 Oct 2019 10:16:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-125-72.rdu2.redhat.com [10.10.125.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 313F35D9CC;
        Mon,  7 Oct 2019 10:16:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 6/6] rxrpc: Fix call crypto state cleanup
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 07 Oct 2019 11:16:19 +0100
Message-ID: <157044337944.32635.18243892067759177258.stgit@warthog.procyon.org.uk>
In-Reply-To: <157044333551.32635.10133219357337058780.stgit@warthog.procyon.org.uk>
References: <157044333551.32635.10133219357337058780.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Mon, 07 Oct 2019 10:16:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the cleanup of the crypto state on a call after the call has been
disconnected.  As the call has been disconnected, its connection ref has
been discarded and so we can't go through that to get to the security ops
table.

Fix this by caching the security ops pointer in the rxrpc_call struct and
using that when freeing the call security state.  Also use this in other
places we're dealing with call-specific security.

The symptoms look like:

    BUG: KASAN: use-after-free in rxrpc_release_call+0xb2d/0xb60
    net/rxrpc/call_object.c:481
    Read of size 8 at addr ffff888062ffeb50 by task syz-executor.5/4764

Fixes: 1db88c534371 ("rxrpc: Fix -Wframe-larger-than= warnings from on-stack crypto")
Reported-by: syzbot+eed305768ece6682bb7f@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/call_accept.c |    1 +
 net/rxrpc/call_object.c |    6 +++---
 net/rxrpc/conn_client.c |    3 +++
 net/rxrpc/recvmsg.c     |    6 +++---
 net/rxrpc/sendmsg.c     |    2 +-
 6 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 1091bf35a199..ecc17dabec8f 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -556,6 +556,7 @@ struct rxrpc_call {
 	struct rxrpc_peer	*peer;		/* Peer record for remote address */
 	struct rxrpc_sock __rcu	*socket;	/* socket responsible */
 	struct rxrpc_net	*rxnet;		/* Network namespace to which call belongs */
+	const struct rxrpc_security *security;	/* applied security module */
 	struct mutex		user_mutex;	/* User access mutex */
 	unsigned long		ack_at;		/* When deferred ACK needs to happen */
 	unsigned long		ack_lost_at;	/* When ACK is figured as lost */
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 1f778102ed8d..135bf5cd8dd5 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -307,6 +307,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 
 	rxrpc_see_call(call);
 	call->conn = conn;
+	call->security = conn->security;
 	call->peer = rxrpc_get_peer(conn->params.peer);
 	call->cong_cwnd = call->peer->cong_cwnd;
 	return call;
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 6dace078971a..a31c18c09894 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -493,10 +493,10 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 
 	_debug("RELEASE CALL %p (%d CONN %p)", call, call->debug_id, conn);
 
-	if (conn) {
+	if (conn)
 		rxrpc_disconnect_call(call);
-		conn->security->free_call_crypto(call);
-	}
+	if (call->security)
+		call->security->free_call_crypto(call);
 
 	rxrpc_cleanup_ring(call);
 	_leave("");
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 700eb77173fc..376370cd9285 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -353,6 +353,7 @@ static int rxrpc_get_client_conn(struct rxrpc_sock *rx,
 
 	if (cp->exclusive) {
 		call->conn = candidate;
+		call->security = candidate->security;
 		call->security_ix = candidate->security_ix;
 		call->service_id = candidate->service_id;
 		_leave(" = 0 [exclusive %d]", candidate->debug_id);
@@ -404,6 +405,7 @@ static int rxrpc_get_client_conn(struct rxrpc_sock *rx,
 candidate_published:
 	set_bit(RXRPC_CONN_IN_CLIENT_CONNS, &candidate->flags);
 	call->conn = candidate;
+	call->security = candidate->security;
 	call->security_ix = candidate->security_ix;
 	call->service_id = candidate->service_id;
 	spin_unlock(&local->client_conns_lock);
@@ -426,6 +428,7 @@ static int rxrpc_get_client_conn(struct rxrpc_sock *rx,
 
 	spin_lock(&conn->channel_lock);
 	call->conn = conn;
+	call->security = conn->security;
 	call->security_ix = conn->security_ix;
 	call->service_id = conn->service_id;
 	list_add_tail(&call->chan_wait_link, &conn->waiting_calls);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 3b0becb12041..a4090797c9b2 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -251,8 +251,8 @@ static int rxrpc_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
 		seq += subpacket;
 	}
 
-	return call->conn->security->verify_packet(call, skb, offset, len,
-						   seq, cksum);
+	return call->security->verify_packet(call, skb, offset, len,
+					     seq, cksum);
 }
 
 /*
@@ -291,7 +291,7 @@ static int rxrpc_locate_data(struct rxrpc_call *call, struct sk_buff *skb,
 
 	*_offset = offset;
 	*_len = len;
-	call->conn->security->locate_data(call, skb, _offset, _len);
+	call->security->locate_data(call, skb, _offset, _len);
 	return 0;
 }
 
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 22f51a7e356e..813fd6888142 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -419,7 +419,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 				 call->tx_winsize)
 				sp->hdr.flags |= RXRPC_MORE_PACKETS;
 
-			ret = conn->security->secure_packet(
+			ret = call->security->secure_packet(
 				call, skb, skb->mark, skb->head);
 			if (ret < 0)
 				goto out;

