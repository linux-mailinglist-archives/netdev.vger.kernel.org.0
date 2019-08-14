Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA0B8D13D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 12:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfHNKsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 06:48:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbfHNKsA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 06:48:00 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 34B82182D;
        Wed, 14 Aug 2019 10:48:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68FC145D5;
        Wed, 14 Aug 2019 10:47:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/2] rxrpc: Fix local endpoint replacement
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 14 Aug 2019 11:47:58 +0100
Message-ID: <156577967871.1405.8345779596542080666.stgit@warthog.procyon.org.uk>
In-Reply-To: <156577967167.1405.3581547705200268244.stgit@warthog.procyon.org.uk>
References: <156577967167.1405.3581547705200268244.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 14 Aug 2019 10:48:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a local endpoint (struct rxrpc_local) ceases to be in use by any
AF_RXRPC sockets, it starts the process of being destroyed, but this
doesn't cause it to be removed from the namespace endpoint list immediately
as tearing it down isn't trivial and can't be done in softirq context, so
it gets deferred.

If a new socket comes along that wants to bind to the same endpoint, a new
rxrpc_local object will be allocated and rxrpc_lookup_local() will use
list_replace() to substitute the new one for the old.

Then, when the dying object gets to rxrpc_local_destroyer(), it is removed
unconditionally from whatever list it is on by calling list_del_init().

However, list_replace() doesn't reset the pointers in the replaced
list_head and so the list_del_init() will likely corrupt the local
endpoints list.

Fix this by using list_replace_init() instead.

Fixes: 730c5fd42c1e ("rxrpc: Fix local endpoint refcounting")
Reported-by: syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/local_object.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index c9db3e762d8d..c45765b7263e 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -283,7 +283,7 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 		goto sock_error;
 
 	if (cursor != &rxnet->local_endpoints)
-		list_replace(cursor, &local->link);
+		list_replace_init(cursor, &local->link);
 	else
 		list_add_tail(&local->link, cursor);
 	age = "new";

