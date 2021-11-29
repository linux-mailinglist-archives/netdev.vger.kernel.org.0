Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2D9461B60
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 16:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344665AbhK2PzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:55:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344005AbhK2PxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 10:53:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638200993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R4aGDOrX7kcOpTnhun/H7dZMm8ovWOT28uEyeLsRZjw=;
        b=TRer8MB/I8c1ddFkEzyURHahZn3WXE0V2R0H21nxjzkSDJl2uUt4Tz40HHs8v9yHZ1Q8WG
        EU8AEOc9O/WxEu/oP8LHI0Zk7bwdDkU9MwA3zrTW7Hejk4Q/g+5AkRIE8PELx5u8OiwcSr
        HqvZ2Vpz9XuiSIZ4Chzt11splqg+fz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-5RMct4JbP7mUAsrGR1TcNQ-1; Mon, 29 Nov 2021 10:49:49 -0500
X-MC-Unique: 5RMct4JbP7mUAsrGR1TcNQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56A3C1006AA4;
        Mon, 29 Nov 2021 15:49:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 386031002388;
        Mon, 29 Nov 2021 15:49:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/2] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Mon, 29 Nov 2021 15:49:46 +0000
Message-ID: <163820098638.226370.7530819133161024558.stgit@warthog.procyon.org.uk>
In-Reply-To: <163820097905.226370.17234085194655347888.stgit@warthog.procyon.org.uk>
References: <163820097905.226370.17234085194655347888.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>

Need to call rxrpc_put_peer() for bundle candidate before kfree() as it
holds a ref to rxrpc_peer.

[DH: v2: Changed to abstract out the bundle freeing code into a function]

Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/20211121041608.133740-1-eiichi.tsukata@nutanix.com/ # v1
---

 net/rxrpc/conn_client.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index dbea0bfee48e..8120138dac01 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -135,16 +135,20 @@ struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *bundle)
 	return bundle;
 }
 
+static void rxrpc_free_bundle(struct rxrpc_bundle *bundle)
+{
+	rxrpc_put_peer(bundle->params.peer);
+	kfree(bundle);
+}
+
 void rxrpc_put_bundle(struct rxrpc_bundle *bundle)
 {
 	unsigned int d = bundle->debug_id;
 	unsigned int u = atomic_dec_return(&bundle->usage);
 
 	_debug("PUT B=%x %u", d, u);
-	if (u == 0) {
-		rxrpc_put_peer(bundle->params.peer);
-		kfree(bundle);
-	}
+	if (u == 0)
+		rxrpc_free_bundle(bundle);
 }
 
 /*
@@ -328,7 +332,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 	return candidate;
 
 found_bundle_free:
-	kfree(candidate);
+	rxrpc_free_bundle(candidate);
 found_bundle:
 	rxrpc_get_bundle(bundle);
 	spin_unlock(&local->client_bundles_lock);


