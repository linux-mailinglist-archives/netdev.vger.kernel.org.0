Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53741557D0C
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbiFWNas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiFWNaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:30:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF8C84B1EB
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655990992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XEH3C0zuHNcT1lLHRvIHFRNJqbbdr5eW+BQfgJT/gP0=;
        b=LTgmEGLazgOBVbbWSrjdIKmR/1eqXz+0boARJc9JT4o4lN3u/JalxjFxedVJh94a+wBS/N
        PZqi/JOGypame85IQGn7IVJdAFbYY3HwGVGmiCv+nyb6JyfgBqM8gjLASy2RYZgEQaAfz/
        wPBXJO1JYyJSRMAB92z2YxuOQ2dom6s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-e5OfKFrNNve4nDMqPAd9-g-1; Thu, 23 Jun 2022 09:29:48 -0400
X-MC-Unique: e5OfKFrNNve4nDMqPAd9-g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 283E73C11054;
        Thu, 23 Jun 2022 13:29:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A48340CF8EE;
        Thu, 23 Jun 2022 13:29:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 8/8] rxrpc: Set call security params in sendmsg() cmsg
From:   David Howells <dhowells@redhat.com>
To:     linux-afs@lists.infradead.org
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Jun 2022 14:29:46 +0100
Message-ID: <165599098652.1827880.6539943845908900391.stgit@warthog.procyon.org.uk>
In-Reply-To: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
References: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow a call's security parameters to be overridden from the socket
defaults by placing appropriate control messages in control message buffer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/uapi/linux/rxrpc.h |    2 ++
 net/rxrpc/af_rxrpc.c       |    2 +-
 net/rxrpc/ar-internal.h    |    6 +++++-
 net/rxrpc/key.c            |   26 ++++++++++++++++++++++++--
 net/rxrpc/sendmsg.c        |   39 +++++++++++++++++++++++++++++++++++----
 5 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/rxrpc.h b/include/uapi/linux/rxrpc.h
index b4bbaa809b78..2e1a05b83be7 100644
--- a/include/uapi/linux/rxrpc.h
+++ b/include/uapi/linux/rxrpc.h
@@ -59,6 +59,8 @@ enum rxrpc_cmsg_type {
 	RXRPC_TX_LENGTH		= 12,	/* s-: Total length of Tx data */
 	RXRPC_SET_CALL_TIMEOUT	= 13,	/* s-: Set one or more call timeouts */
 	RXRPC_CHARGE_ACCEPT	= 14,	/* s-: Charge the accept pool with a user call ID */
+	RXRPC_SET_SECURITY_KEY	= 15,	/* s-: Set the security key description for the call */
+	RXRPC_SET_SECURITY_LEVEL = 16,	/* s-: Set the security level for the call */
 	RXRPC__SUPPORTED
 };
 
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index bf2bb1b99890..8b7e8ad6e020 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -920,7 +920,7 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
 			ret = -EISCONN;
 			if (rx->sk.sk_state != RXRPC_UNBOUND)
 				goto error;
-			ret = rxrpc_request_key(rx, optval, optlen);
+			ret = rxrpc_set_key(rx, optval, optlen);
 			goto error;
 
 		case RXRPC_SECURITY_KEYRING:
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 526169effe89..b80a9136e978 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -777,6 +777,9 @@ struct rxrpc_send_params {
 	enum rxrpc_command	command : 8;	/* The command to implement */
 	bool			exclusive;	/* Shared or exclusive call */
 	bool			upgrade;	/* If the connection is upgradeable */
+	unsigned int		sec_level;	/* Security level */
+	unsigned int		key_desc_len;
+	char			*key_desc;	/* Description of key to use (or NULL) */
 };
 
 #include <trace/events/rxrpc.h>
@@ -950,7 +953,8 @@ extern const struct rxrpc_security rxrpc_no_security;
  */
 extern struct key_type key_type_rxrpc;
 
-int rxrpc_request_key(struct rxrpc_sock *, sockptr_t , int);
+struct key *rxrpc_request_key(struct rxrpc_sock *, const char *, int);
+int rxrpc_set_key(struct rxrpc_sock *, const sockptr_t, int);
 int rxrpc_get_server_data_key(struct rxrpc_connection *, const void *, time64_t,
 			      u32);
 
diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index bbb270a01810..4ab1ec62ad2f 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -443,9 +443,31 @@ static void rxrpc_describe(const struct key *key, struct seq_file *m)
 }
 
 /*
- * grab the security key for a socket
+ * Look up a security key
  */
-int rxrpc_request_key(struct rxrpc_sock *rx, sockptr_t optval, int optlen)
+struct key *rxrpc_request_key(struct rxrpc_sock *rx, const char *name, int len)
+{
+	struct key *key;
+	char *description;
+
+	_enter("");
+
+	if (len <= 0 || len > PAGE_SIZE - 1)
+		return ERR_PTR(-EINVAL);
+
+	description = kmemdup_nul(name, len, GFP_KERNEL);
+	if (IS_ERR(description))
+		return ERR_PTR(-ENOMEM);
+
+	key = request_key_net(&key_type_rxrpc, description, sock_net(&rx->sk), NULL);
+	kfree(description);
+	return key;
+}
+
+/*
+ * Set the security key for a socket
+ */
+int rxrpc_set_key(struct rxrpc_sock *rx, sockptr_t optval, int optlen)
 {
 	struct key *key;
 	char *description;
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 77699008c428..9153baf33635 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -560,6 +560,19 @@ static int rxrpc_sendmsg_cmsg(struct msghdr *msg, struct rxrpc_send_params *p)
 				return -ERANGE;
 			break;
 
+		case RXRPC_SET_SECURITY_KEY:
+			p->key_desc = CMSG_DATA(cmsg);
+			p->key_desc_len = len;
+			break;
+
+		case RXRPC_SET_SECURITY_LEVEL:
+			if (len != sizeof(p->sec_level))
+				return -EINVAL;
+			memcpy(&p->sec_level, CMSG_DATA(cmsg), sizeof(p->sec_level));
+			if (p->sec_level > RXRPC_SECURITY_ENCRYPT)
+				return -EINVAL;
+			break;
+
 		default:
 			return -EINVAL;
 		}
@@ -587,6 +600,7 @@ rxrpc_new_client_call_for_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg,
 	struct rxrpc_conn_parameters cp;
 	struct rxrpc_call *call;
 	struct key *key;
+	bool put_key = false;
 
 	DECLARE_SOCKADDR(struct sockaddr_rxrpc *, srx, msg->msg_name);
 
@@ -597,14 +611,27 @@ rxrpc_new_client_call_for_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg,
 		return ERR_PTR(-EDESTADDRREQ);
 	}
 
-	key = rx->key;
-	if (key && !rx->key->payload.data[0])
-		key = NULL;
+	if (p->key_desc) {
+		if (!*p->key_desc) {
+			key = NULL;
+		} else {
+			key = rxrpc_request_key(rx, p->key_desc, p->key_desc_len);
+			if (IS_ERR(key)) {
+				release_sock(&rx->sk);
+				return ERR_CAST(key);
+			}
+			put_key = true;
+		}
+	} else  {
+		key = rx->key;
+		if (key && !rx->key->payload.data[0])
+			key = NULL;
+	}
 
 	memset(&cp, 0, sizeof(cp));
 	cp.local		= rx->local;
 	cp.key			= rx->key;
-	cp.security_level	= rx->min_sec_level;
+	cp.security_level	= p->sec_level;
 	cp.exclusive		= rx->exclusive | p->exclusive;
 	cp.upgrade		= p->upgrade;
 	cp.service_id		= srx->srx_service;
@@ -613,6 +640,8 @@ rxrpc_new_client_call_for_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg,
 	/* The socket is now unlocked */
 
 	rxrpc_put_peer(cp.peer);
+	if (put_key)
+		key_put(key);
 	_leave(" = %p\n", call);
 	return call;
 }
@@ -640,6 +669,8 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		.command		= RXRPC_CMD_SEND_DATA,
 		.exclusive		= false,
 		.upgrade		= false,
+		.sec_level		= rx->min_sec_level,
+		.key_desc		= NULL,
 	};
 
 	_enter("");


