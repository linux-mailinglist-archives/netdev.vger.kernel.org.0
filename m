Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBEEDE5D5A
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfJZNgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbfJZNQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2A06222BD;
        Sat, 26 Oct 2019 13:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095789;
        bh=6aVhr7608eofXvvGSLtA+juskwIu+HL1BwWnA/CWjJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AriZYOFG/wwbJ0dxUoEXTIExgbkFzNmFaGr0XWXayTx+3HFG+WBXr+NfOA0G6yCNk
         PRmoCl6MtLoFv/uE2q3MR6tWVqdx89Pg1i1o4qIW6rxTVto5wWJJRkqAsZwe9aCe6N
         2c6VhYmkOAjvYCdZa4J1QQNrsZ2+e4RUtkpapsCU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 17/99] rxrpc: Fix trace-after-put looking at the put peer record
Date:   Sat, 26 Oct 2019 09:14:38 -0400
Message-Id: <20191026131600.2507-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 55f6c98e3674ce16038a1949c3f9ca5a9a99f289 ]

rxrpc_put_peer() calls trace_rxrpc_peer() after it has done the decrement
of the refcount - which looks at the debug_id in the peer record.  But
unless the refcount was reduced to zero, we no longer have the right to
look in the record and, indeed, it may be deleted by some other thread.

Fix this by getting the debug_id out before decrementing the refcount and
then passing that into the tracepoint.

This can cause the following symptoms:

    BUG: KASAN: use-after-free in __rxrpc_put_peer net/rxrpc/peer_object.c:411
    [inline]
    BUG: KASAN: use-after-free in rxrpc_put_peer+0x685/0x6a0
    net/rxrpc/peer_object.c:435
    Read of size 8 at addr ffff888097ec0058 by task syz-executor823/24216

Fixes: 1159d4b496f5 ("rxrpc: Add a tracepoint to track rxrpc_peer refcounting")
Reported-by: syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h |  6 +++---
 net/rxrpc/peer_object.c      | 11 +++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index edc5c887a44c8..45556fe771c36 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -519,10 +519,10 @@ TRACE_EVENT(rxrpc_local,
 	    );
 
 TRACE_EVENT(rxrpc_peer,
-	    TP_PROTO(struct rxrpc_peer *peer, enum rxrpc_peer_trace op,
+	    TP_PROTO(unsigned int peer_debug_id, enum rxrpc_peer_trace op,
 		     int usage, const void *where),
 
-	    TP_ARGS(peer, op, usage, where),
+	    TP_ARGS(peer_debug_id, op, usage, where),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,	peer		)
@@ -532,7 +532,7 @@ TRACE_EVENT(rxrpc_peer,
 			     ),
 
 	    TP_fast_assign(
-		    __entry->peer = peer->debug_id;
+		    __entry->peer = peer_debug_id;
 		    __entry->op = op;
 		    __entry->usage = usage;
 		    __entry->where = where;
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 9c3ac96f71cbf..b700b7ecaa3d8 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -382,7 +382,7 @@ struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *peer)
 	int n;
 
 	n = atomic_inc_return(&peer->usage);
-	trace_rxrpc_peer(peer, rxrpc_peer_got, n, here);
+	trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, n, here);
 	return peer;
 }
 
@@ -396,7 +396,7 @@ struct rxrpc_peer *rxrpc_get_peer_maybe(struct rxrpc_peer *peer)
 	if (peer) {
 		int n = atomic_fetch_add_unless(&peer->usage, 1, 0);
 		if (n > 0)
-			trace_rxrpc_peer(peer, rxrpc_peer_got, n + 1, here);
+			trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, n + 1, here);
 		else
 			peer = NULL;
 	}
@@ -426,11 +426,13 @@ static void __rxrpc_put_peer(struct rxrpc_peer *peer)
 void rxrpc_put_peer(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
+	unsigned int debug_id;
 	int n;
 
 	if (peer) {
+		debug_id = peer->debug_id;
 		n = atomic_dec_return(&peer->usage);
-		trace_rxrpc_peer(peer, rxrpc_peer_put, n, here);
+		trace_rxrpc_peer(debug_id, rxrpc_peer_put, n, here);
 		if (n == 0)
 			__rxrpc_put_peer(peer);
 	}
@@ -443,10 +445,11 @@ void rxrpc_put_peer(struct rxrpc_peer *peer)
 void rxrpc_put_peer_locked(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
+	unsigned int debug_id = peer->debug_id;
 	int n;
 
 	n = atomic_dec_return(&peer->usage);
-	trace_rxrpc_peer(peer, rxrpc_peer_put, n, here);
+	trace_rxrpc_peer(debug_id, rxrpc_peer_put, n, here);
 	if (n == 0) {
 		hash_del_rcu(&peer->hash_link);
 		list_del_init(&peer->keepalive_link);
-- 
2.20.1

