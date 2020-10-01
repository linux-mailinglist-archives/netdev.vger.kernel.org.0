Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE992801F3
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732866AbgJAO7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:59:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732586AbgJAO6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:58:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2QbhpUg9SJrIBCKWCPwsMbX+4EeoycPcPI8VKjfbL1s=;
        b=fmsPakr0Bo+zBMixAkorWwsiWZ4kU/m3sYhSBFWGfkcN4LYRKgxYblM/H10yw9m+/EGZbj
        NPMMkJcy+YYQ3L5AajK4mBG6BCnqztOJ1cCUOKUQpSCSMbkgGBllp7qUdHhEf4LgZ7bUrE
        fBlzWgVYi9VzX8/MYi459aGJBsPEh7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583--6qFRIhjO_iNYVr5MO3ySg-1; Thu, 01 Oct 2020 10:58:51 -0400
X-MC-Unique: -6qFRIhjO_iNYVr5MO3ySg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB11D873183;
        Thu,  1 Oct 2020 14:58:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAD5881C4F;
        Thu,  1 Oct 2020 14:58:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 18/23] rxrpc: Don't reserve security header in Tx
 DATA skbuff
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:58:48 +0100
Message-ID: <160156432811.1728886.13296622825563470512.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Insert the security header into the skbuff representing a DATA packet to be
transmitted rather than using skb_reserve() when the packet is allocated.
This makes it easier to apply crypto that spans the security header and the
data, particularly in the upcoming RxGK class where we have a common
encrypt-and-checksum function that is used in a number of circumstances.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    5 +----
 net/rxrpc/insecure.c    |    6 ++----
 net/rxrpc/rxkad.c       |   24 +++++++++---------------
 net/rxrpc/sendmsg.c     |    6 ++----
 4 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 047587ffe7bb..f314b7a33d37 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -233,10 +233,7 @@ struct rxrpc_security {
 
 
 	/* impose security on a packet */
-	int (*secure_packet)(struct rxrpc_call *,
-			     struct sk_buff *,
-			     size_t,
-			     void *);
+	int (*secure_packet)(struct rxrpc_call *, struct sk_buff *, size_t);
 
 	/* verify the security on a received packet */
 	int (*verify_packet)(struct rxrpc_call *, struct sk_buff *,
diff --git a/net/rxrpc/insecure.c b/net/rxrpc/insecure.c
index 914e2f2e2990..e06725e21c05 100644
--- a/net/rxrpc/insecure.c
+++ b/net/rxrpc/insecure.c
@@ -14,10 +14,8 @@ static int none_init_connection_security(struct rxrpc_connection *conn,
 	return 0;
 }
 
-static int none_secure_packet(struct rxrpc_call *call,
-			      struct sk_buff *skb,
-			      size_t data_size,
-			      void *sechdr)
+static int none_secure_packet(struct rxrpc_call *call, struct sk_buff *skb,
+			      size_t data_size)
 {
 	return 0;
 }
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 301894857473..37335d887570 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -230,9 +230,7 @@ static void rxkad_free_call_crypto(struct rxrpc_call *call)
  * partially encrypt a packet (level 1 security)
  */
 static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
-				    struct sk_buff *skb,
-				    u32 data_size,
-				    void *sechdr,
+				    struct sk_buff *skb, u32 data_size,
 				    struct skcipher_request *req)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -247,12 +245,12 @@ static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
 	data_size |= (u32)check << 16;
 
 	hdr.data_size = htonl(data_size);
-	memcpy(sechdr, &hdr, sizeof(hdr));
+	memcpy(skb->head, &hdr, sizeof(hdr));
 
 	/* start the encryption afresh */
 	memset(&iv, 0, sizeof(iv));
 
-	sg_init_one(&sg, sechdr, 8);
+	sg_init_one(&sg, skb->head, 8);
 	skcipher_request_set_sync_tfm(req, call->conn->cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
@@ -269,7 +267,6 @@ static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
 static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 				       struct sk_buff *skb,
 				       u32 data_size,
-				       void *sechdr,
 				       struct skcipher_request *req)
 {
 	const struct rxrpc_key_token *token;
@@ -289,13 +286,13 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 
 	rxkhdr.data_size = htonl(data_size | (u32)check << 16);
 	rxkhdr.checksum = 0;
-	memcpy(sechdr, &rxkhdr, sizeof(rxkhdr));
+	memcpy(skb->head, &rxkhdr, sizeof(rxkhdr));
 
 	/* encrypt from the session key */
 	token = call->conn->params.key->payload.data[0];
 	memcpy(&iv, token->kad->session_key, sizeof(iv));
 
-	sg_init_one(&sg[0], sechdr, sizeof(rxkhdr));
+	sg_init_one(&sg[0], skb->head, sizeof(rxkhdr));
 	skcipher_request_set_sync_tfm(req, call->conn->cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg[0], &sg[0], sizeof(rxkhdr), iv.x);
@@ -310,7 +307,7 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 	len &= ~(call->conn->size_align - 1);
 
 	sg_init_table(sg, ARRAY_SIZE(sg));
-	err = skb_to_sgvec(skb, sg, 0, len);
+	err = skb_to_sgvec(skb, sg, 8, len);
 	if (unlikely(err < 0))
 		goto out;
 	skcipher_request_set_crypt(req, sg, sg, len, iv.x);
@@ -329,8 +326,7 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
  */
 static int rxkad_secure_packet(struct rxrpc_call *call,
 			       struct sk_buff *skb,
-			       size_t data_size,
-			       void *sechdr)
+			       size_t data_size)
 {
 	struct rxrpc_skb_priv *sp;
 	struct skcipher_request	*req;
@@ -383,12 +379,10 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
 		ret = 0;
 		break;
 	case RXRPC_SECURITY_AUTH:
-		ret = rxkad_secure_packet_auth(call, skb, data_size, sechdr,
-					       req);
+		ret = rxkad_secure_packet_auth(call, skb, data_size, req);
 		break;
 	case RXRPC_SECURITY_ENCRYPT:
-		ret = rxkad_secure_packet_encrypt(call, skb, data_size,
-						  sechdr, req);
+		ret = rxkad_secure_packet_encrypt(call, skb, data_size, req);
 		break;
 	default:
 		ret = -EPERM;
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 258224bb1227..d4d57e2666b8 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -376,8 +376,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			ASSERTCMP(skb->mark, ==, 0);
 
 			_debug("HS: %u", call->conn->security_size);
-			skb_reserve(skb, call->conn->security_size);
-			skb->len += call->conn->security_size;
+			__skb_put(skb, call->conn->security_size);
 
 			sp->remain = chunk;
 			if (sp->remain > skb_tailroom(skb))
@@ -450,8 +449,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 				 call->tx_winsize)
 				sp->hdr.flags |= RXRPC_MORE_PACKETS;
 
-			ret = call->security->secure_packet(
-				call, skb, skb->mark, skb->head);
+			ret = call->security->secure_packet(call, skb, skb->mark);
 			if (ret < 0)
 				goto out;
 


