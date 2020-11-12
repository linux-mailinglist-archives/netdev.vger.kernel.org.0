Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B932B05AB
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgKLNA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:00:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728559AbgKLNA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:00:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605186054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qmTzZMw26ZOxVsw6AE+Yi1dOtYZgOHQMXHW1UsBHzzI=;
        b=TDzr6E43/xSW0ZUBO1S0QubSxxA2Cxg8dprElgAVXKrP0uHtzYBP5angP81M5eLvmNCtW8
        fYIfew0Syf33bdomPcB7lgS6Mpakg3vqD8jNEVgI4Nb2rbNoJdkfyakXKKYIKSr1E8FSj3
        w6ZeBghxuh2RWYR3TI2q6Tp7be/jxQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-0UbhHBIRPjeq6bbaj7-23A-1; Thu, 12 Nov 2020 08:00:51 -0500
X-MC-Unique: 0UbhHBIRPjeq6bbaj7-23A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7587811CC7EF;
        Thu, 12 Nov 2020 13:00:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA9375B4DB;
        Thu, 12 Nov 2020 13:00:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 18/18] rxgk: Support OpenAFS's rxgk implementation
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 13:00:45 +0000
Message-ID: <160518604546.2277919.883911770718886136.stgit@warthog.procyon.org.uk>
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


---

 net/rxrpc/ar-internal.h |    1 
 net/rxrpc/key.c         |  136 +++++++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/rxgk.c        |   25 +++++++++
 net/rxrpc/rxgk_app.c    |  135 +++++++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/rxgk_common.h |    2 +
 net/rxrpc/security.c    |    3 +
 6 files changed, 302 insertions(+)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 3f2469714422..ed44ceeeab68 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1070,6 +1070,7 @@ void rxrpc_peer_init_rtt(struct rxrpc_peer *);
 /*
  * rxgk.c
  */
+extern const struct rxrpc_security rxgk_openafs;
 extern const struct rxrpc_security rxgk_yfs;
 
 /*
diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index b7f154701d97..3479ef285980 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -147,6 +147,135 @@ static time64_t rxrpc_s64_to_time64(s64 time_in_100ns)
 	return neg ? -tmp : tmp;
 }
 
+/*
+ * Parse an OpenAFS RxGK type XDR format token
+ * - the caller guarantees we have at least 4 words
+ *
+ * struct token_rxgk {
+ *	afs_int64	0 gk_viceid;
+ *	afs_int32	2 gk_enctype;
+ *	afs_int32	3 gk_level;
+ *	afs_uint32	4 gk_lifetime;
+ *	afs_uint32	5 gk_bytelife;
+ *	afs_int64	6 gk_expiration;
+ *	opaque		8 gk_token<AFSTOKEN_GK_TOK_MAX>;
+ *	opaque		9 gk_k0<AFSTOKEN_GK_TOK_MAX>;
+ * };
+ */
+static int rxrpc_preparse_xdr_rxgk(struct key_preparsed_payload *prep,
+				   size_t datalen,
+				   const __be32 *xdr, unsigned int toklen)
+{
+	struct rxrpc_key_token *token, **pptoken;
+	time64_t expiry;
+	size_t plen;
+	const __be32 *ticket, *key;
+	u32 tktlen, keylen;
+
+	_enter(",{%x,%x,%x,%x},%x",
+	       ntohl(xdr[0]), ntohl(xdr[1]), ntohl(xdr[2]), ntohl(xdr[3]),
+	       toklen);
+
+	if (toklen / 4 < 10)
+		goto reject;
+
+	ticket = xdr + 9;
+	tktlen = ntohl(ticket[-1]);
+	_debug("tktlen: %x", tktlen);
+	tktlen = round_up(tktlen, 4);
+	if (toklen < 10 * 4 + tktlen)
+		goto reject;
+
+	key = ticket + (tktlen / 4) + 1;
+	keylen = ntohl(key[-1]);
+	_debug("keylen: %x", keylen);
+	keylen = round_up(keylen, 4);
+	if (10 * 4 + tktlen + keylen != toklen) {
+		kleave(" = -EKEYREJECTED [%x!=%x, %x,%x]",
+		       10 * 4 + tktlen + keylen, toklen, tktlen, keylen);
+		goto reject;
+	}
+
+	plen = sizeof(*token) + sizeof(*token->rxgk) + tktlen + keylen;
+	prep->quotalen = datalen + plen;
+
+	plen -= sizeof(*token);
+	token = kzalloc(sizeof(*token), GFP_KERNEL);
+	if (!token)
+		goto nomem;
+
+	token->rxgk = kzalloc(sizeof(struct rxgk_key) + keylen, GFP_KERNEL);
+	if (!token->rxgk)
+		goto nomem_token;
+
+	token->security_index	= RXRPC_SECURITY_RXGK;
+	token->rxgk->begintime	= 0;
+	token->rxgk->endtime	= xdr_dec64(xdr + 6);
+	token->rxgk->level	= ntohl(xdr[3]);
+	if (token->rxgk->level > RXRPC_SECURITY_ENCRYPT)
+		goto reject_token;
+	token->rxgk->lifetime	= ntohl(xdr[4]);
+	token->rxgk->bytelife	= ntohl(xdr[5]);
+	token->rxgk->enctype	= ntohl(xdr[2]);
+	token->rxgk->key.len	= ntohl(key[-1]);
+	token->rxgk->key.data	= token->rxgk->_key;
+	token->rxgk->ticket.len = ntohl(ticket[-1]);
+
+	expiry = rxrpc_s64_to_time64(token->rxgk->endtime);
+	if (expiry < 0)
+		goto expired;
+	if (expiry < prep->expiry)
+		prep->expiry = expiry;
+
+	memcpy(token->rxgk->key.data, key, token->rxgk->key.len);
+
+	/* Pad the ticket so that we can use it directly in XDR */
+	token->rxgk->ticket.data = kzalloc(round_up(token->rxgk->ticket.len, 4),
+					   GFP_KERNEL);
+	if (!token->rxgk->ticket.data)
+		goto nomem_yrxgk;
+	memcpy(token->rxgk->ticket.data, ticket, token->rxgk->ticket.len);
+
+	_debug("SCIX: %u",	token->security_index);
+	_debug("LIFE: %llx",	token->rxgk->lifetime);
+	_debug("BYTE: %llx",	token->rxgk->bytelife);
+	_debug("ENC : %u",	token->rxgk->enctype);
+	_debug("LEVL: %u",	token->rxgk->level);
+	_debug("KLEN: %u",	token->rxgk->key.len);
+	_debug("TLEN: %u",	token->rxgk->ticket.len);
+	_debug("KEY0: %*phN",	token->rxgk->key.len, token->rxgk->key.data);
+	_debug("TICK: %*phN",
+	       min_t(u32, token->rxgk->ticket.len, 32), token->rxgk->ticket.data);
+
+	/* count the number of tokens attached */
+	prep->payload.data[1] = (void *)((unsigned long)prep->payload.data[1] + 1);
+
+	/* attach the data */
+	for (pptoken = (struct rxrpc_key_token **)&prep->payload.data[0];
+	     *pptoken;
+	     pptoken = &(*pptoken)->next)
+		continue;
+	*pptoken = token;
+
+	_leave(" = 0");
+	return 0;
+
+nomem_yrxgk:
+	kfree(token->rxgk);
+nomem_token:
+	kfree(token);
+nomem:
+	return -ENOMEM;
+reject_token:
+	kfree(token);
+reject:
+	return -EKEYREJECTED;
+expired:
+	kfree(token->rxgk);
+	kfree(token);
+	return -EKEYEXPIRED;
+}
+
 /*
  * Parse a YFS-RxGK type XDR format token
  * - the caller guarantees we have at least 4 words
@@ -380,6 +509,9 @@ static int rxrpc_preparse_xdr(struct key_preparsed_payload *prep)
 		case RXRPC_SECURITY_RXKAD:
 			ret2 = rxrpc_preparse_xdr_rxkad(prep, datalen, token, toklen);
 			break;
+		case RXRPC_SECURITY_RXGK:
+			ret2 = rxrpc_preparse_xdr_rxgk(prep, datalen, token, toklen);
+			break;
 		case RXRPC_SECURITY_YFS_RXGK:
 			ret2 = rxrpc_preparse_xdr_yfs_rxgk(prep, datalen, token, toklen);
 			break;
@@ -545,6 +677,7 @@ static void rxrpc_free_token_list(struct rxrpc_key_token *token)
 		case RXRPC_SECURITY_RXKAD:
 			kfree(token->kad);
 			break;
+		case RXRPC_SECURITY_RXGK:
 		case RXRPC_SECURITY_YFS_RXGK:
 			kfree(token->rxgk->ticket.data);
 			kfree(token->rxgk);
@@ -592,6 +725,9 @@ static void rxrpc_describe(const struct key *key, struct seq_file *m)
 		case RXRPC_SECURITY_RXKAD:
 			seq_puts(m, "ka");
 			break;
+		case RXRPC_SECURITY_RXGK:
+			seq_puts(m, "ogk");
+			break;
 		case RXRPC_SECURITY_YFS_RXGK:
 			seq_puts(m, "ygk");
 			break;
diff --git a/net/rxrpc/rxgk.c b/net/rxrpc/rxgk.c
index 0aa6da93b8d4..bad68d293ced 100644
--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -1181,6 +1181,31 @@ static void rxgk_exit(void)
 {
 }
 
+/*
+ * RxRPC OpenAFS GSSAPI-based security
+ */
+const struct rxrpc_security rxgk_openafs = {
+	.name				= "rxgk",
+	.security_index			= RXRPC_SECURITY_RXGK,
+	.no_key_abort			= RXGK_NOTAUTH,
+	.init				= rxgk_init,
+	.exit				= rxgk_exit,
+	.preparse_server_key		= rxgk_preparse_server_key,
+	.free_preparse_server_key	= rxgk_free_preparse_server_key,
+	.destroy_server_key		= rxgk_destroy_server_key,
+	.describe_server_key		= rxgk_describe_server_key,
+	.init_connection_security	= rxgk_init_connection_security,
+	.secure_packet			= rxgk_secure_packet,
+	.verify_packet			= rxgk_verify_packet,
+	.free_call_crypto		= rxgk_free_call_crypto,
+	.locate_data			= rxgk_locate_data,
+	.issue_challenge		= rxgk_issue_challenge,
+	.respond_to_challenge		= rxgk_respond_to_challenge,
+	.verify_response		= rxgk_verify_response,
+	.clear				= rxgk_clear,
+	.default_decode_ticket		= rxgk_openafs_decode_ticket,
+};
+
 /*
  * RxRPC YFS GSSAPI-based security
  */
diff --git a/net/rxrpc/rxgk_app.c b/net/rxrpc/rxgk_app.c
index 895879f3acfb..8c35e3a88119 100644
--- a/net/rxrpc/rxgk_app.c
+++ b/net/rxrpc/rxgk_app.c
@@ -14,6 +14,141 @@
 #include "ar-internal.h"
 #include "rxgk_common.h"
 
+/*
+ * Decode a default-style OpenAFS ticket in a response and turn it into an
+ * rxrpc-type key.
+ *
+ * struct RXGK_Token {
+ *	afs_int32		enctype;
+ *	opaque			K0<>;
+ *	RXGK_Level		level;
+ *	afs_int32		lifetime;
+ *	afs_int32		bytelife;
+ *	rxgkTime		expirationtime;
+ *	struct RXGK_PrAuthName	identities<>;
+ * };
+ */
+int rxgk_openafs_decode_ticket(struct sk_buff *skb,
+			       unsigned int ticket_offset, unsigned int ticket_len,
+			       u32 *_abort_code,
+			       struct key **_key)
+{
+	struct rxrpc_key_token *token;
+	const struct cred *cred = current_cred(); // TODO - use socket creds
+	struct key *key;
+	size_t pre_ticket_len, payload_len;
+	unsigned int klen, enctype;
+	void *payload, *ticket;
+	__be32 *t, *p, *q, tmp[2];
+	int ret;
+
+	_enter("");
+
+	/* Get the session key length */
+	ret = skb_copy_bits(skb, ticket_offset, tmp, sizeof(tmp));
+	if (ret < 0)
+		goto error_out;
+	enctype = ntohl(tmp[0]);
+	klen = ntohl(tmp[1]);
+
+	if (klen > ticket_len - 8 * sizeof(__be32)) {
+		*_abort_code = RXGK_INCONSISTENCY;
+		return -EPROTO;
+	}
+
+	pre_ticket_len = ((5 + 10) * sizeof(__be32));
+	payload_len = pre_ticket_len + xdr_round_up(ticket_len) +
+		sizeof(__be32) + xdr_round_up(klen);
+
+	payload = kzalloc(payload_len, GFP_NOFS);
+	if (!payload)
+		return -ENOMEM;
+
+	/* We need to fill out the XDR form for a key payload that we can pass
+	 * to add_key().  Start by copying in the ticket so that we can parse
+	 * it.
+	 */
+	ticket = payload + pre_ticket_len;
+	ret = skb_copy_bits(skb, ticket_offset, ticket, ticket_len);
+	if (ret < 0)
+		goto error;
+
+	/* Fill out the form header. */
+	p = payload;
+	p[0] = htonl(0); /* Flags */
+	p[1] = htonl(1); /* len(cellname) */
+	p[2] = htonl(0x20000000); /* Cellname " " */
+	p[3] = htonl(1); /* #tokens */
+	p[4] = htonl(11 * sizeof(__be32) +
+		     xdr_round_up(klen) + xdr_round_up(ticket_len)); /* Token len */
+
+	/* Now fill in the body.  Most of this we can just scrape directly from
+	 * the ticket.
+	 */
+	t = ticket + sizeof(__be32) * 2 + xdr_round_up(klen);
+	q = payload + 5 * sizeof(__be32);
+	q[ 0] = htonl(RXRPC_SECURITY_RXGK);
+	q[ 1] = 0;		/* gk_viceid - msw */
+	q[ 2] = 0;		/* - lsw */
+	q[ 3] = htonl(enctype);	/* gkenctype - msw */
+	q[ 4] = t[0];		/* gk_level */
+	q[ 5] = t[1];		/* gk_lifetime */
+	q[ 6] = t[2];		/* gk_bytelife */
+	q[ 7] = t[3];		/* gk_expiration - msw */
+	q[ 8] = t[4];		/* - lsw */
+	q[ 9] = htonl(ticket_len); /* gk_token.length */
+
+	q += 10;
+	if (WARN_ON((unsigned long)q != (unsigned long)ticket)) {
+		kdebug("%lx %lx", (long)q, (long)ticket);
+		ret = -EIO;
+		goto error;
+	}
+
+	/* Ticket read in with skb_copy_bits above */
+	q += xdr_round_up(ticket_len) / 4;
+	q[0] = ntohl(klen);
+	q++;
+
+	memcpy(q, ticket + sizeof(__be32) * 2, klen);
+
+	q += xdr_round_up(klen) / 4;
+	if (WARN_ON((unsigned long)q - (unsigned long)payload != payload_len)) {
+		ret = -EIO;
+		goto error;
+	}
+
+	/* Now turn that into a key. */
+	key = key_alloc(&key_type_rxrpc, "x",
+			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred, 0, // TODO: Use socket owner
+			KEY_ALLOC_NOT_IN_QUOTA, NULL);
+	if (IS_ERR(key)) {
+		_leave(" = -ENOMEM [alloc %ld]", PTR_ERR(key));
+		goto error;
+	}
+
+	_debug("key %d", key_serial(key));
+
+	ret = key_instantiate_and_link(key, payload, payload_len, NULL, NULL);
+	if (ret < 0)
+		goto error_key;
+
+	token = key->payload.data[0];
+	token->no_leak_key = true;
+	*_key = key;
+	key = NULL;
+	ret = 0;
+	goto error;
+
+error_key:
+	key_put(key);
+error:
+	kfree_sensitive(payload);
+error_out:
+	_leave(" = %d", ret);
+	return ret;
+}
+
 /*
  * Decode a default-style YFS ticket in a response and turn it into an
  * rxrpc-type key.
diff --git a/net/rxrpc/rxgk_common.h b/net/rxrpc/rxgk_common.h
index 38473b13e67d..88278da64c6a 100644
--- a/net/rxrpc/rxgk_common.h
+++ b/net/rxrpc/rxgk_common.h
@@ -38,6 +38,8 @@ struct rxgk_context {
 /*
  * rxgk_app.c
  */
+int rxgk_openafs_decode_ticket(struct sk_buff *, unsigned int, unsigned int,
+			       u32 *, struct key **);
 int rxgk_yfs_decode_ticket(struct sk_buff *, unsigned int, unsigned int,
 			   u32 *, struct key **);
 int rxgk_extract_token(struct rxrpc_connection *,
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index 278a510b2956..dd11aa1aa137 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -20,6 +20,9 @@ static const struct rxrpc_security *rxrpc_security_types[] = {
 #ifdef CONFIG_RXKAD
 	[RXRPC_SECURITY_RXKAD]	= &rxkad,
 #endif
+#ifdef CONFIG_RXGK
+	[RXRPC_SECURITY_RXGK]	= &rxgk_openafs,
+#endif
 #ifdef CONFIG_RXGK
 	[RXRPC_SECURITY_YFS_RXGK] = &rxgk_yfs,
 #endif


