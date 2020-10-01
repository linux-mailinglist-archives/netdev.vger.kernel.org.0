Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DA12801BF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732529AbgJAO5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:57:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732513AbgJAO5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HedO1XyP/60FFHQo5ha5XlYFvUzHiIh1ZZJCehpSLMU=;
        b=RoC7jAeaH+feJMz9tvkQewCiWAote7iZIrBvYL0kUqyfgjEYoofOG3INHV3wgGz0D5bt3v
        9wzTQu5ws2EF489vQih9FUsMn+XbkFzfVEOPCDG1/AyQiEXoxJir0tIw4Z+h/7cc5BH+l9
        ekdL3D9KUHiIgn1Q6vqeR3z1r/zFIvU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-ByuSho4aM1KwGDFVydsjVQ-1; Thu, 01 Oct 2020 10:57:00 -0400
X-MC-Unique: ByuSho4aM1KwGDFVydsjVQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A7CE1891E81;
        Thu,  1 Oct 2020 14:56:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 495B155767;
        Thu,  1 Oct 2020 14:56:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 02/23] rxrpc: Fix bundle counting for exclusive
 connections
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:56:57 +0100
Message-ID: <160156421754.1728886.8795264390611254169.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix rxrpc_unbundle_conn() to not drop the bundle usage count when cleaning
up an exclusive connection.

Based on the suggested fix from Hillf Danton.

Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
Reported-by: syzbot+d57aaf84dd8a550e6d91@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hillf Danton <hdanton@sina.com>
---

 net/rxrpc/conn_client.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 78c845a4f1ad..5d9adfd4c84f 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -901,7 +901,7 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 	struct rxrpc_bundle *bundle = conn->bundle;
 	struct rxrpc_local *local = bundle->params.local;
 	unsigned int bindex;
-	bool need_drop = false;
+	bool need_drop = false, need_put = false;
 	int i;
 
 	_enter("C=%x", conn->debug_id);
@@ -928,10 +928,11 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 		if (i == ARRAY_SIZE(bundle->conns) && !bundle->params.exclusive) {
 			_debug("erase bundle");
 			rb_erase(&bundle->local_node, &local->client_bundles);
+			need_put = true;
 		}
 
 		spin_unlock(&local->client_bundles_lock);
-		if (i == ARRAY_SIZE(bundle->conns))
+		if (need_put)
 			rxrpc_put_bundle(bundle);
 	}
 


