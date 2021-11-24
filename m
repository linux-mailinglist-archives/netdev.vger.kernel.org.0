Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E50645C79B
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351927AbhKXOlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:41:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351615AbhKXOlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 09:41:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637764670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v/0HJBxmnrpwlX0tB2lVxqG/MEc291G0md/VX7QbXe8=;
        b=DS635/TM770goc2x7FPzNp6zsICpykPtOIoZ0TtvIeN6QZgtq/9TpT1wfPx1oKOmviM1E2
        QUYqZSN9DfGkP1tvgYp2tVKGydEDa+AanNplSjkxCYBn4GBUaZvKDN9B1Vm74bJMc3NNT5
        jX6kmupyxhrFuFceC9Dsg7/KaJnR5wE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-566-PGhS75WRPSS2jXHQ1e2e0A-1; Wed, 24 Nov 2021 09:37:44 -0500
X-MC-Unique: PGhS75WRPSS2jXHQ1e2e0A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C905483DD20;
        Wed, 24 Nov 2021 14:37:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C73560854;
        Wed, 24 Nov 2021 14:37:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/2] rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()
From:   David Howells <dhowells@redhat.com>
To:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Nov 2021 14:37:40 +0000
Message-ID: <163776466062.1844202.16759821367213247018.stgit@warthog.procyon.org.uk>
In-Reply-To: <163776465314.1844202.9057900281265187616.stgit@warthog.procyon.org.uk>
References: <163776465314.1844202.9057900281265187616.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>

Need to call rxrpc_put_local() for peer candidate before kfree() as it
holds a ref to rxrpc_local.

[DH: v2: Changed to abstract the peer freeing code out into a function]

Fixes: 9ebeddef58c4 ("rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record")
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/all/20211121041608.133740-2-eiichi.tsukata@nutanix.com/ # v1
---

 net/rxrpc/peer_object.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 68396d052052..0298fe2ad6d3 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -299,6 +299,12 @@ static struct rxrpc_peer *rxrpc_create_peer(struct rxrpc_sock *rx,
 	return peer;
 }
 
+static void rxrpc_free_peer(struct rxrpc_peer *peer)
+{
+	rxrpc_put_local(peer->local);
+	kfree_rcu(peer, rcu);
+}
+
 /*
  * Set up a new incoming peer.  There shouldn't be any other matching peers
  * since we've already done a search in the list from the non-reentrant context
@@ -365,7 +371,7 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 		spin_unlock_bh(&rxnet->peer_hash_lock);
 
 		if (peer)
-			kfree(candidate);
+			rxrpc_free_peer(candidate);
 		else
 			peer = candidate;
 	}
@@ -420,8 +426,7 @@ static void __rxrpc_put_peer(struct rxrpc_peer *peer)
 	list_del_init(&peer->keepalive_link);
 	spin_unlock_bh(&rxnet->peer_hash_lock);
 
-	rxrpc_put_local(peer->local);
-	kfree_rcu(peer, rcu);
+	rxrpc_free_peer(peer);
 }
 
 /*
@@ -457,8 +462,7 @@ void rxrpc_put_peer_locked(struct rxrpc_peer *peer)
 	if (n == 0) {
 		hash_del_rcu(&peer->hash_link);
 		list_del_init(&peer->keepalive_link);
-		rxrpc_put_local(peer->local);
-		kfree_rcu(peer, rcu);
+		rxrpc_free_peer(peer);
 	}
 }
 


