Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4AE64DE78
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiLOQVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiLOQVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:21:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4159633C21
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 08:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671121229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3/uwkkZAQE5l+dl7H8fN7biifOYzFqKLocOrCEWHoxs=;
        b=TpOlxbuFoWIoiTFITF7Pd6gM+a+lyM4IwdDdifrMhOoBFWg4QPtZgw8/CIlV2tNsvRiYUg
        KAGYTwElkdI3P1j3s71KZGU0WvD/Xct/HCNHgGkYXxkNp0PWsOEWN9eMIJHbOYjhE1/Yie
        u6Nx/0lXEpD/3bBpvxzo0uECmGfQx7Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-mcEedSfTNzSgcIN80A-Z2g-1; Thu, 15 Dec 2022 11:19:59 -0500
X-MC-Unique: mcEedSfTNzSgcIN80A-Z2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 731A0885628;
        Thu, 15 Dec 2022 16:19:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D04992166B26;
        Thu, 15 Dec 2022 16:19:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 2/9] rxrpc: Fix security setting propagation
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 15 Dec 2022 16:19:56 +0000
Message-ID: <167112119625.152641.17989220946528839395.stgit@warthog.procyon.org.uk>
In-Reply-To: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
References: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the propagation of the security settings from sendmsg to the rxrpc_call
struct.

Fixes: f3441d4125fc ("rxrpc: Copy client call parameters into rxrpc_call earlier")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/call_object.c |    1 +
 net/rxrpc/conn_client.c |    2 --
 net/rxrpc/security.c    |    6 +++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index be5eb8cdf549..89dcf60b1158 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -217,6 +217,7 @@ static struct rxrpc_call *rxrpc_alloc_client_call(struct rxrpc_sock *rx,
 	call->tx_total_len	= p->tx_total_len;
 	call->key		= key_get(cp->key);
 	call->local		= rxrpc_get_local(cp->local, rxrpc_local_get_call);
+	call->security_level	= cp->security_level;
 	if (p->kernel)
 		__set_bit(RXRPC_CALL_KERNEL, &call->flags);
 	if (cp->upgrade)
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index a08e33c9e54b..87efa0373aed 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -551,8 +551,6 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 	call->conn	= rxrpc_get_connection(conn, rxrpc_conn_get_activate_call);
 	call->cid	= conn->proto.cid | channel;
 	call->call_id	= call_id;
-	call->security	= conn->security;
-	call->security_ix = conn->security_ix;
 	call->dest_srx.srx_service = conn->service_id;
 
 	trace_rxrpc_connect_call(call);
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index 209f2c25a0da..ab968f65a490 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -67,13 +67,13 @@ const struct rxrpc_security *rxrpc_security_lookup(u8 security_index)
  */
 int rxrpc_init_client_call_security(struct rxrpc_call *call)
 {
-	const struct rxrpc_security *sec;
+	const struct rxrpc_security *sec = &rxrpc_no_security;
 	struct rxrpc_key_token *token;
 	struct key *key = call->key;
 	int ret;
 
 	if (!key)
-		return 0;
+		goto found;
 
 	ret = key_validate(key);
 	if (ret < 0)
@@ -88,7 +88,7 @@ int rxrpc_init_client_call_security(struct rxrpc_call *call)
 
 found:
 	call->security = sec;
-	_leave(" = 0");
+	call->security_ix = sec->security_index;
 	return 0;
 }
 


