Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0091D64487C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiLFP7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiLFP7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:59:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C4A233BF
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 07:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjAmjxe3yPO04heheB0Cnmxd8gGqiVxalfGtpsaO3Q0=;
        b=boBtKnenSZLVi2JhQm8FqLlYq6lL7rcBOziTw/eO9QR79IoXYr38ikVw9J5qo4V28AEB1N
        A4+eyAx6fS1pJQUVJefE6K0iI7euX1kME8cRqNDMDD4MKwY0NTICyBNM8S960d8JwdHd0f
        KrZZhXmL4qXTFBicleaKp2mnDzBU+5s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-N1JghW5oMiKJM0y-bpVWgQ-1; Tue, 06 Dec 2022 10:58:57 -0500
X-MC-Unique: N1JghW5oMiKJM0y-bpVWgQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96C1A3C02B76;
        Tue,  6 Dec 2022 15:58:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F05481121315;
        Tue,  6 Dec 2022 15:58:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 02/32] rxrpc: Fix security setting propagation
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 15:58:53 +0000
Message-ID: <167034233329.1105287.18187783114467913357.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
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

Fix the propagation of the security settings from sendmsg to the rxrpc_call
struct.

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
 


