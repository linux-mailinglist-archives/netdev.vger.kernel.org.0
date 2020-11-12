Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6572B058B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgKLM7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:59:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727739AbgKLM7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:59:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B5WvSEa2+oXzMRb5vYLYlFmIu/7LQYDhHpYTqPt6M5g=;
        b=BsX1zwymlCObMSf3zmL9A4lgaskQ6eMWC6JphvoYvX8+1VR8m4cDy4Upapmjolhg3LTvIo
        9zE2Czw8jQ+eTl1XNzT0hzfiQpLhPp4sXROuHOc1rtNH9DPZApKGCR1tMkkEKlO0ogh2Ys
        8ceqmM/OZ5ZH0YgdTbrCDAF244O6il8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-vcD4p_K8Pfaf_iXTg1N6nA-1; Thu, 12 Nov 2020 07:59:44 -0500
X-MC-Unique: vcD4p_K8Pfaf_iXTg1N6nA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52A72804753;
        Thu, 12 Nov 2020 12:59:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FBFF5D9E4;
        Thu, 12 Nov 2020 12:59:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 14/18] rxrpc: Add YFS RxGK (GSSAPI) security class
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:59:39 +0000
Message-ID: <160518597935.2277919.239077296822909986.stgit@warthog.procyon.org.uk>
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the YFS-variant RxGK security class to support
GSSAPI-derived authentication.  This also allows the use of better crypto
over the rxkad security class.

The key payload is XDR encoded of the form:

    typedef int64_t opr_time;

    const AFSTOKEN_RK_TIX_MAX = 12000; 	/* Matches entry in rxkad.h */

    struct token_rxkad {
	afs_int32 viceid;
	afs_int32 kvno;
	afs_int64 key;
	afs_int32 begintime;
	afs_int32 endtime;
	afs_int32 primary_flag;
	opaque ticket<AFSTOKEN_RK_TIX_MAX>;
    };

    struct token_rxgk {
	opr_time begintime;
	opr_time endtime;
	afs_int64 level;
	afs_int64 lifetime;
	afs_int64 bytelife;
	afs_int64 enctype;
	opaque key<>;
	opaque ticket<>;
    };

    const AFSTOKEN_UNION_NOAUTH = 0;
    const AFSTOKEN_UNION_KAD = 2;
    const AFSTOKEN_UNION_YFSGK = 6;

    union ktc_tokenUnion switch (afs_int32 type) {
	case AFSTOKEN_UNION_KAD:
	    token_rxkad kad;
	case AFSTOKEN_UNION_YFSGK:
	    token_rxgk  gk;
    };

    const AFSTOKEN_LENGTH_MAX = 16384;
    typedef opaque token_opaque<AFSTOKEN_LENGTH_MAX>;

    const AFSTOKEN_MAX = 8;
    const AFSTOKEN_CELL_MAX = 64;

    struct ktc_setTokenData {
	afs_int32 flags;
	string cell<AFSTOKEN_CELL_MAX>;
	token_opaque tokens<AFSTOKEN_MAX>;
    };

The parser for the basic token struct is already present, as is the rxkad
token type.  This adds a parser for the rxgk token type.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/keys/rxrpc-type.h |   17 ++++
 net/rxrpc/key.c           |  183 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 200 insertions(+)

diff --git a/include/keys/rxrpc-type.h b/include/keys/rxrpc-type.h
index 333c0f49a9cd..0ddbe197a261 100644
--- a/include/keys/rxrpc-type.h
+++ b/include/keys/rxrpc-type.h
@@ -9,6 +9,7 @@
 #define _KEYS_RXRPC_TYPE_H
 
 #include <linux/key.h>
+#include <crypto/krb5.h>
 
 /*
  * key type for AF_RXRPC keys
@@ -31,6 +32,21 @@ struct rxkad_key {
 	u8	ticket[];		/* the encrypted ticket */
 };
 
+/*
+ * RxRPC key for YFS-RxGK (type-6 security)
+ */
+struct rxgk_key {
+	s64		begintime;	/* Time at which the ticket starts */
+	s64		endtime;	/* Time at which the ticket ends */
+	u64		lifetime;	/* Maximum lifespan of a connection (seconds) */
+	u64		bytelife;	/* Maximum number of bytes on a connection */
+	unsigned int	enctype;	/* Encoding type */
+	s8		level;		/* Negotiated security RXRPC_SECURITY_PLAIN/AUTH/ENCRYPT */
+	struct krb5_buffer key;		/* Master key, K0 */
+	struct krb5_buffer ticket;	/* Ticket to be passed to server */
+	u8		_key[];		/* Key storage */
+};
+
 /*
  * list of tokens attached to an rxrpc key
  */
@@ -40,6 +56,7 @@ struct rxrpc_key_token {
 	struct rxrpc_key_token *next;	/* the next token in the list */
 	union {
 		struct rxkad_key *kad;
+		struct rxgk_key *rxgk;
 	};
 };
 
diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 9631aa8543b5..b7f154701d97 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -129,6 +129,158 @@ static int rxrpc_preparse_xdr_rxkad(struct key_preparsed_payload *prep,
 	return 0;
 }
 
+static u64 xdr_dec64(const __be32 *xdr)
+{
+	return (u64)ntohl(xdr[0]) << 32 | (u64)ntohl(xdr[1]);
+}
+
+static time64_t rxrpc_s64_to_time64(s64 time_in_100ns)
+{
+	bool neg = false;
+	u64 tmp = time_in_100ns;
+
+	if (time_in_100ns < 0) {
+		tmp = -time_in_100ns;
+		neg = true;
+	}
+	do_div(tmp, 10000000);
+	return neg ? -tmp : tmp;
+}
+
+/*
+ * Parse a YFS-RxGK type XDR format token
+ * - the caller guarantees we have at least 4 words
+ *
+ * struct token_rxgk {
+ *	opr_time begintime;
+ *	opr_time endtime;
+ *	afs_int64 level;
+ *	afs_int64 lifetime;
+ *	afs_int64 bytelife;
+ *	afs_int64 enctype;
+ *	opaque key<>;
+ *	opaque ticket<>;
+ * };
+ */
+static int rxrpc_preparse_xdr_yfs_rxgk(struct key_preparsed_payload *prep,
+				       size_t datalen,
+				       const __be32 *xdr, unsigned int toklen)
+{
+	struct rxrpc_key_token *token, **pptoken;
+	time64_t expiry;
+	size_t plen;
+	const __be32 *ticket, *key;
+	s64 tmp;
+	u32 tktlen, keylen;
+
+	_enter(",{%x,%x,%x,%x},%x",
+	       ntohl(xdr[0]), ntohl(xdr[1]), ntohl(xdr[2]), ntohl(xdr[3]),
+	       toklen);
+
+	if (6 * 2 + 2 > toklen / 4)
+		goto reject;
+
+	key = xdr + (6 * 2 + 1);
+	keylen = ntohl(key[-1]);
+	_debug("keylen: %x", keylen);
+	keylen = round_up(keylen, 4);
+	if ((6 * 2 + 2) * 4 + keylen > toklen)
+		goto reject;
+
+	ticket = xdr + (6 * 2 + 1 + (keylen / 4) + 1);
+	tktlen = ntohl(ticket[-1]);
+	_debug("tktlen: %x", tktlen);
+	tktlen = round_up(tktlen, 4);
+	if ((6 * 2 + 2) * 4 + keylen + tktlen != toklen) {
+		kleave(" = -EKEYREJECTED [%x!=%x, %x,%x]",
+		       (6 * 2 + 2) * 4 + keylen + tktlen, toklen,
+		       keylen, tktlen);
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
+	token->security_index	= RXRPC_SECURITY_YFS_RXGK;
+	token->rxgk->begintime	= xdr_dec64(xdr + 0 * 2);
+	token->rxgk->endtime	= xdr_dec64(xdr + 1 * 2);
+	token->rxgk->level	= tmp = xdr_dec64(xdr + 2 * 2);
+	if (tmp < -1LL || tmp > RXRPC_SECURITY_ENCRYPT)
+		goto reject_token;
+	token->rxgk->lifetime	= xdr_dec64(xdr + 3 * 2);
+	token->rxgk->bytelife	= xdr_dec64(xdr + 4 * 2);
+	token->rxgk->enctype	= tmp = xdr_dec64(xdr + 5 * 2);
+	if (tmp < 0 || tmp > UINT_MAX)
+		goto reject_token;
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
+	_debug("EXPY: %llx",	token->rxgk->endtime);
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
  * attempt to parse the data as the XDR format
  * - the caller guarantees we have more than 7 words
@@ -228,6 +380,9 @@ static int rxrpc_preparse_xdr(struct key_preparsed_payload *prep)
 		case RXRPC_SECURITY_RXKAD:
 			ret2 = rxrpc_preparse_xdr_rxkad(prep, datalen, token, toklen);
 			break;
+		case RXRPC_SECURITY_YFS_RXGK:
+			ret2 = rxrpc_preparse_xdr_yfs_rxgk(prep, datalen, token, toklen);
+			break;
 		default:
 			ret2 = -EPROTONOSUPPORT;
 			break;
@@ -390,6 +545,10 @@ static void rxrpc_free_token_list(struct rxrpc_key_token *token)
 		case RXRPC_SECURITY_RXKAD:
 			kfree(token->kad);
 			break;
+		case RXRPC_SECURITY_YFS_RXGK:
+			kfree(token->rxgk->ticket.data);
+			kfree(token->rxgk);
+			break;
 		default:
 			pr_err("Unknown token type %x on rxrpc key\n",
 			       token->security_index);
@@ -433,6 +592,9 @@ static void rxrpc_describe(const struct key *key, struct seq_file *m)
 		case RXRPC_SECURITY_RXKAD:
 			seq_puts(m, "ka");
 			break;
+		case RXRPC_SECURITY_YFS_RXGK:
+			seq_puts(m, "ygk");
+			break;
 		default: /* we have a ticket we can't encode */
 			seq_printf(m, "%u", token->security_index);
 			break;
@@ -595,6 +757,13 @@ static long rxrpc_read(const struct key *key,
 				toksize += RND(token->kad->ticket_len);
 			break;
 
+		case RXRPC_SECURITY_YFS_RXGK:
+			toksize += 6 * 8 + 2 * 4;
+			if (!token->no_leak_key)
+				toksize += RND(token->rxgk->key.len);
+			toksize += RND(token->rxgk->ticket.len);
+			break;
+
 		default: /* we have a ticket we can't encode */
 			pr_err("Unsupported key token type (%u)\n",
 			       token->security_index);
@@ -673,6 +842,20 @@ static long rxrpc_read(const struct key *key,
 				ENCODE_DATA(token->kad->ticket_len, token->kad->ticket);
 			break;
 
+		case RXRPC_SECURITY_YFS_RXGK:
+			ENCODE64(token->rxgk->begintime);
+			ENCODE64(token->rxgk->endtime);
+			ENCODE64(token->rxgk->level);
+			ENCODE64(token->rxgk->lifetime);
+			ENCODE64(token->rxgk->bytelife);
+			ENCODE64(token->rxgk->enctype);
+			ENCODE_DATA(token->rxgk->ticket.len, token->rxgk->ticket.data);
+			if (token->no_leak_key)
+				ENCODE(0);
+			else
+				ENCODE_DATA(token->rxgk->key.len, token->rxgk->key.data);
+			break;
+
 		default:
 			break;
 		}


