Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E4B2801D9
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732745AbgJAO6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:58:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732695AbgJAO6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D1GaYh4TywjpetFJw/1l5SinB2MvVQqsSwYQOXbJLag=;
        b=M/fJfYRzkBZvkEGCDh6EKn8+TjAndd/ECyfI2UpCsz85HtWinfRmNyQ1njVu1WQVjvxs4W
        QhmJ453ar0nxnO9W8Yz7LOaxCm9nWgEyumQmeYkbsi5ZIi3rnZDZ2ZrWp/FM8nPmArmNO5
        ZuDnUFsbN48cxCPuIJ9qfafWHkOkVM0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-NlAeTUCIPs-jJs2stp0Tug-1; Thu, 01 Oct 2020 10:57:55 -0400
X-MC-Unique: NlAeTUCIPs-jJs2stp0Tug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B56618CBC44;
        Thu,  1 Oct 2020 14:57:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 545BB73679;
        Thu,  1 Oct 2020 14:57:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 10/23] rxrpc: Remove the rxk5 security class as it's
 now defunct
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:57:52 +0100
Message-ID: <160156427255.1728886.5451251580445698757.stgit@warthog.procyon.org.uk>
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

Remove the rxrpc rxk5 security class as it's now defunct and nothing uses
it anymore.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/keys/rxrpc-type.h |   55 -----
 net/rxrpc/key.c           |  468 ---------------------------------------------
 2 files changed, 523 deletions(-)

diff --git a/include/keys/rxrpc-type.h b/include/keys/rxrpc-type.h
index 2b0b15a71228..8e4ced9b4ecf 100644
--- a/include/keys/rxrpc-type.h
+++ b/include/keys/rxrpc-type.h
@@ -31,54 +31,6 @@ struct rxkad_key {
 	u8	ticket[];		/* the encrypted ticket */
 };
 
-/*
- * Kerberos 5 principal
- *	name/name/name@realm
- */
-struct krb5_principal {
-	u8	n_name_parts;		/* N of parts of the name part of the principal */
-	char	**name_parts;		/* parts of the name part of the principal */
-	char	*realm;			/* parts of the realm part of the principal */
-};
-
-/*
- * Kerberos 5 tagged data
- */
-struct krb5_tagged_data {
-	/* for tag value, see /usr/include/krb5/krb5.h
-	 * - KRB5_AUTHDATA_* for auth data
-	 * -
-	 */
-	s32		tag;
-	u32		data_len;
-	u8		*data;
-};
-
-/*
- * RxRPC key for Kerberos V (type-5 security)
- */
-struct rxk5_key {
-	u64			authtime;	/* time at which auth token generated */
-	u64			starttime;	/* time at which auth token starts */
-	u64			endtime;	/* time at which auth token expired */
-	u64			renew_till;	/* time to which auth token can be renewed */
-	s32			is_skey;	/* T if ticket is encrypted in another ticket's
-						 * skey */
-	s32			flags;		/* mask of TKT_FLG_* bits (krb5/krb5.h) */
-	struct krb5_principal	client;		/* client principal name */
-	struct krb5_principal	server;		/* server principal name */
-	u16			ticket_len;	/* length of ticket */
-	u16			ticket2_len;	/* length of second ticket */
-	u8			n_authdata;	/* number of authorisation data elements */
-	u8			n_addresses;	/* number of addresses */
-	struct krb5_tagged_data	session;	/* session data; tag is enctype */
-	struct krb5_tagged_data *addresses;	/* addresses */
-	u8			*ticket;	/* krb5 ticket */
-	u8			*ticket2;	/* second krb5 ticket, if related to ticket (via
-						 * DUPLICATE-SKEY or ENC-TKT-IN-SKEY) */
-	struct krb5_tagged_data *authdata;	/* authorisation data */
-};
-
 /*
  * list of tokens attached to an rxrpc key
  */
@@ -87,7 +39,6 @@ struct rxrpc_key_token {
 	struct rxrpc_key_token *next;	/* the next token in the list */
 	union {
 		struct rxkad_key *kad;
-		struct rxk5_key *k5;
 	};
 };
 
@@ -116,12 +67,6 @@ struct rxrpc_key_data_v1 {
 #define AFSTOKEN_RK_TIX_MAX		12000	/* max RxKAD ticket size */
 #define AFSTOKEN_GK_KEY_MAX		64	/* max GSSAPI key size */
 #define AFSTOKEN_GK_TOKEN_MAX		16384	/* max GSSAPI token size */
-#define AFSTOKEN_K5_COMPONENTS_MAX	16	/* max K5 components */
-#define AFSTOKEN_K5_NAME_MAX		128	/* max K5 name length */
-#define AFSTOKEN_K5_REALM_MAX		64	/* max K5 realm name length */
-#define AFSTOKEN_K5_TIX_MAX		16384	/* max K5 ticket size */
-#define AFSTOKEN_K5_ADDRESSES_MAX	16	/* max K5 addresses */
-#define AFSTOKEN_K5_AUTHDATA_MAX	16	/* max K5 pieces of auth data */
 
 /*
  * Truncate a time64_t to the range from 1970 to 2106 as in the network
diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 75e84ed4fa63..75b500650257 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -165,391 +165,6 @@ static int rxrpc_preparse_xdr_rxkad(struct key_preparsed_payload *prep,
 	return 0;
 }
 
-static void rxrpc_free_krb5_principal(struct krb5_principal *princ)
-{
-	int loop;
-
-	if (princ->name_parts) {
-		for (loop = princ->n_name_parts - 1; loop >= 0; loop--)
-			kfree(princ->name_parts[loop]);
-		kfree(princ->name_parts);
-	}
-	kfree(princ->realm);
-}
-
-static void rxrpc_free_krb5_tagged(struct krb5_tagged_data *td)
-{
-	kfree(td->data);
-}
-
-/*
- * free up an RxK5 token
- */
-static void rxrpc_rxk5_free(struct rxk5_key *rxk5)
-{
-	int loop;
-
-	rxrpc_free_krb5_principal(&rxk5->client);
-	rxrpc_free_krb5_principal(&rxk5->server);
-	rxrpc_free_krb5_tagged(&rxk5->session);
-
-	if (rxk5->addresses) {
-		for (loop = rxk5->n_addresses - 1; loop >= 0; loop--)
-			rxrpc_free_krb5_tagged(&rxk5->addresses[loop]);
-		kfree(rxk5->addresses);
-	}
-	if (rxk5->authdata) {
-		for (loop = rxk5->n_authdata - 1; loop >= 0; loop--)
-			rxrpc_free_krb5_tagged(&rxk5->authdata[loop]);
-		kfree(rxk5->authdata);
-	}
-
-	kfree(rxk5->ticket);
-	kfree(rxk5->ticket2);
-	kfree(rxk5);
-}
-
-/*
- * extract a krb5 principal
- */
-static int rxrpc_krb5_decode_principal(struct krb5_principal *princ,
-				       const __be32 **_xdr,
-				       unsigned int *_toklen)
-{
-	const __be32 *xdr = *_xdr;
-	unsigned int toklen = *_toklen, n_parts, loop, tmp, paddedlen;
-
-	/* there must be at least one name, and at least #names+1 length
-	 * words */
-	if (toklen <= 12)
-		return -EINVAL;
-
-	_enter(",{%x,%x,%x},%u",
-	       ntohl(xdr[0]), ntohl(xdr[1]), ntohl(xdr[2]), toklen);
-
-	n_parts = ntohl(*xdr++);
-	toklen -= 4;
-	if (n_parts <= 0 || n_parts > AFSTOKEN_K5_COMPONENTS_MAX)
-		return -EINVAL;
-	princ->n_name_parts = n_parts;
-
-	if (toklen <= (n_parts + 1) * 4)
-		return -EINVAL;
-
-	princ->name_parts = kcalloc(n_parts, sizeof(char *), GFP_KERNEL);
-	if (!princ->name_parts)
-		return -ENOMEM;
-
-	for (loop = 0; loop < n_parts; loop++) {
-		if (toklen < 4)
-			return -EINVAL;
-		tmp = ntohl(*xdr++);
-		toklen -= 4;
-		if (tmp <= 0 || tmp > AFSTOKEN_STRING_MAX)
-			return -EINVAL;
-		paddedlen = (tmp + 3) & ~3;
-		if (paddedlen > toklen)
-			return -EINVAL;
-		princ->name_parts[loop] = kmalloc(tmp + 1, GFP_KERNEL);
-		if (!princ->name_parts[loop])
-			return -ENOMEM;
-		memcpy(princ->name_parts[loop], xdr, tmp);
-		princ->name_parts[loop][tmp] = 0;
-		toklen -= paddedlen;
-		xdr += paddedlen >> 2;
-	}
-
-	if (toklen < 4)
-		return -EINVAL;
-	tmp = ntohl(*xdr++);
-	toklen -= 4;
-	if (tmp <= 0 || tmp > AFSTOKEN_K5_REALM_MAX)
-		return -EINVAL;
-	paddedlen = (tmp + 3) & ~3;
-	if (paddedlen > toklen)
-		return -EINVAL;
-	princ->realm = kmalloc(tmp + 1, GFP_KERNEL);
-	if (!princ->realm)
-		return -ENOMEM;
-	memcpy(princ->realm, xdr, tmp);
-	princ->realm[tmp] = 0;
-	toklen -= paddedlen;
-	xdr += paddedlen >> 2;
-
-	_debug("%s/...@%s", princ->name_parts[0], princ->realm);
-
-	*_xdr = xdr;
-	*_toklen = toklen;
-	_leave(" = 0 [toklen=%u]", toklen);
-	return 0;
-}
-
-/*
- * extract a piece of krb5 tagged data
- */
-static int rxrpc_krb5_decode_tagged_data(struct krb5_tagged_data *td,
-					 size_t max_data_size,
-					 const __be32 **_xdr,
-					 unsigned int *_toklen)
-{
-	const __be32 *xdr = *_xdr;
-	unsigned int toklen = *_toklen, len, paddedlen;
-
-	/* there must be at least one tag and one length word */
-	if (toklen <= 8)
-		return -EINVAL;
-
-	_enter(",%zu,{%x,%x},%u",
-	       max_data_size, ntohl(xdr[0]), ntohl(xdr[1]), toklen);
-
-	td->tag = ntohl(*xdr++);
-	len = ntohl(*xdr++);
-	toklen -= 8;
-	if (len > max_data_size)
-		return -EINVAL;
-	paddedlen = (len + 3) & ~3;
-	if (paddedlen > toklen)
-		return -EINVAL;
-	td->data_len = len;
-
-	if (len > 0) {
-		td->data = kmemdup(xdr, len, GFP_KERNEL);
-		if (!td->data)
-			return -ENOMEM;
-		toklen -= paddedlen;
-		xdr += paddedlen >> 2;
-	}
-
-	_debug("tag %x len %x", td->tag, td->data_len);
-
-	*_xdr = xdr;
-	*_toklen = toklen;
-	_leave(" = 0 [toklen=%u]", toklen);
-	return 0;
-}
-
-/*
- * extract an array of tagged data
- */
-static int rxrpc_krb5_decode_tagged_array(struct krb5_tagged_data **_td,
-					  u8 *_n_elem,
-					  u8 max_n_elem,
-					  size_t max_elem_size,
-					  const __be32 **_xdr,
-					  unsigned int *_toklen)
-{
-	struct krb5_tagged_data *td;
-	const __be32 *xdr = *_xdr;
-	unsigned int toklen = *_toklen, n_elem, loop;
-	int ret;
-
-	/* there must be at least one count */
-	if (toklen < 4)
-		return -EINVAL;
-
-	_enter(",,%u,%zu,{%x},%u",
-	       max_n_elem, max_elem_size, ntohl(xdr[0]), toklen);
-
-	n_elem = ntohl(*xdr++);
-	toklen -= 4;
-	if (n_elem > max_n_elem)
-		return -EINVAL;
-	*_n_elem = n_elem;
-	if (n_elem > 0) {
-		if (toklen <= (n_elem + 1) * 4)
-			return -EINVAL;
-
-		_debug("n_elem %d", n_elem);
-
-		td = kcalloc(n_elem, sizeof(struct krb5_tagged_data),
-			     GFP_KERNEL);
-		if (!td)
-			return -ENOMEM;
-		*_td = td;
-
-		for (loop = 0; loop < n_elem; loop++) {
-			ret = rxrpc_krb5_decode_tagged_data(&td[loop],
-							    max_elem_size,
-							    &xdr, &toklen);
-			if (ret < 0)
-				return ret;
-		}
-	}
-
-	*_xdr = xdr;
-	*_toklen = toklen;
-	_leave(" = 0 [toklen=%u]", toklen);
-	return 0;
-}
-
-/*
- * extract a krb5 ticket
- */
-static int rxrpc_krb5_decode_ticket(u8 **_ticket, u16 *_tktlen,
-				    const __be32 **_xdr, unsigned int *_toklen)
-{
-	const __be32 *xdr = *_xdr;
-	unsigned int toklen = *_toklen, len, paddedlen;
-
-	/* there must be at least one length word */
-	if (toklen <= 4)
-		return -EINVAL;
-
-	_enter(",{%x},%u", ntohl(xdr[0]), toklen);
-
-	len = ntohl(*xdr++);
-	toklen -= 4;
-	if (len > AFSTOKEN_K5_TIX_MAX)
-		return -EINVAL;
-	paddedlen = (len + 3) & ~3;
-	if (paddedlen > toklen)
-		return -EINVAL;
-	*_tktlen = len;
-
-	_debug("ticket len %u", len);
-
-	if (len > 0) {
-		*_ticket = kmemdup(xdr, len, GFP_KERNEL);
-		if (!*_ticket)
-			return -ENOMEM;
-		toklen -= paddedlen;
-		xdr += paddedlen >> 2;
-	}
-
-	*_xdr = xdr;
-	*_toklen = toklen;
-	_leave(" = 0 [toklen=%u]", toklen);
-	return 0;
-}
-
-/*
- * parse an RxK5 type XDR format token
- * - the caller guarantees we have at least 4 words
- */
-static int rxrpc_preparse_xdr_rxk5(struct key_preparsed_payload *prep,
-				   size_t datalen,
-				   const __be32 *xdr, unsigned int toklen)
-{
-	struct rxrpc_key_token *token, **pptoken;
-	struct rxk5_key *rxk5;
-	const __be32 *end_xdr = xdr + (toklen >> 2);
-	time64_t expiry;
-	int ret;
-
-	_enter(",{%x,%x,%x,%x},%u",
-	       ntohl(xdr[0]), ntohl(xdr[1]), ntohl(xdr[2]), ntohl(xdr[3]),
-	       toklen);
-
-	/* reserve some payload space for this subkey - the length of the token
-	 * is a reasonable approximation */
-	prep->quotalen = datalen + toklen;
-
-	token = kzalloc(sizeof(*token), GFP_KERNEL);
-	if (!token)
-		return -ENOMEM;
-
-	rxk5 = kzalloc(sizeof(*rxk5), GFP_KERNEL);
-	if (!rxk5) {
-		kfree(token);
-		return -ENOMEM;
-	}
-
-	token->security_index = RXRPC_SECURITY_RXK5;
-	token->k5 = rxk5;
-
-	/* extract the principals */
-	ret = rxrpc_krb5_decode_principal(&rxk5->client, &xdr, &toklen);
-	if (ret < 0)
-		goto error;
-	ret = rxrpc_krb5_decode_principal(&rxk5->server, &xdr, &toklen);
-	if (ret < 0)
-		goto error;
-
-	/* extract the session key and the encoding type (the tag field ->
-	 * ENCTYPE_xxx) */
-	ret = rxrpc_krb5_decode_tagged_data(&rxk5->session, AFSTOKEN_DATA_MAX,
-					    &xdr, &toklen);
-	if (ret < 0)
-		goto error;
-
-	if (toklen < 4 * 8 + 2 * 4)
-		goto inval;
-	rxk5->authtime	= be64_to_cpup((const __be64 *) xdr);
-	xdr += 2;
-	rxk5->starttime	= be64_to_cpup((const __be64 *) xdr);
-	xdr += 2;
-	rxk5->endtime	= be64_to_cpup((const __be64 *) xdr);
-	xdr += 2;
-	rxk5->renew_till = be64_to_cpup((const __be64 *) xdr);
-	xdr += 2;
-	rxk5->is_skey = ntohl(*xdr++);
-	rxk5->flags = ntohl(*xdr++);
-	toklen -= 4 * 8 + 2 * 4;
-
-	_debug("times: a=%llx s=%llx e=%llx rt=%llx",
-	       rxk5->authtime, rxk5->starttime, rxk5->endtime,
-	       rxk5->renew_till);
-	_debug("is_skey=%x flags=%x", rxk5->is_skey, rxk5->flags);
-
-	/* extract the permitted client addresses */
-	ret = rxrpc_krb5_decode_tagged_array(&rxk5->addresses,
-					     &rxk5->n_addresses,
-					     AFSTOKEN_K5_ADDRESSES_MAX,
-					     AFSTOKEN_DATA_MAX,
-					     &xdr, &toklen);
-	if (ret < 0)
-		goto error;
-
-	ASSERTCMP((end_xdr - xdr) << 2, ==, toklen);
-
-	/* extract the tickets */
-	ret = rxrpc_krb5_decode_ticket(&rxk5->ticket, &rxk5->ticket_len,
-				       &xdr, &toklen);
-	if (ret < 0)
-		goto error;
-	ret = rxrpc_krb5_decode_ticket(&rxk5->ticket2, &rxk5->ticket2_len,
-				       &xdr, &toklen);
-	if (ret < 0)
-		goto error;
-
-	ASSERTCMP((end_xdr - xdr) << 2, ==, toklen);
-
-	/* extract the typed auth data */
-	ret = rxrpc_krb5_decode_tagged_array(&rxk5->authdata,
-					     &rxk5->n_authdata,
-					     AFSTOKEN_K5_AUTHDATA_MAX,
-					     AFSTOKEN_BDATALN_MAX,
-					     &xdr, &toklen);
-	if (ret < 0)
-		goto error;
-
-	ASSERTCMP((end_xdr - xdr) << 2, ==, toklen);
-
-	if (toklen != 0)
-		goto inval;
-
-	/* attach the payload */
-	for (pptoken = (struct rxrpc_key_token **)&prep->payload.data[0];
-	     *pptoken;
-	     pptoken = &(*pptoken)->next)
-		continue;
-	*pptoken = token;
-	expiry = rxrpc_u32_to_time64(token->k5->endtime);
-	if (expiry < prep->expiry)
-		prep->expiry = expiry;
-
-	_leave(" = 0");
-	return 0;
-
-inval:
-	ret = -EINVAL;
-error:
-	rxrpc_rxk5_free(rxk5);
-	kfree(token);
-	_leave(" = %d", ret);
-	return ret;
-}
-
 /*
  * attempt to parse the data as the XDR format
  * - the caller guarantees we have more than 7 words
@@ -650,12 +265,6 @@ static int rxrpc_preparse_xdr(struct key_preparsed_payload *prep)
 				goto error;
 			break;
 
-		case RXRPC_SECURITY_RXK5:
-			ret = rxrpc_preparse_xdr_rxk5(prep, datalen, xdr, toklen);
-			if (ret != 0)
-				goto error;
-			break;
-
 		default:
 			ret = -EPROTONOSUPPORT;
 			goto error;
@@ -805,10 +414,6 @@ static void rxrpc_free_token_list(struct rxrpc_key_token *token)
 		case RXRPC_SECURITY_RXKAD:
 			kfree(token->kad);
 			break;
-		case RXRPC_SECURITY_RXK5:
-			if (token->k5)
-				rxrpc_rxk5_free(token->k5);
-			break;
 		default:
 			pr_err("Unknown token type %x on rxrpc key\n",
 			       token->security_index);
@@ -1044,12 +649,10 @@ static long rxrpc_read(const struct key *key,
 		       char *buffer, size_t buflen)
 {
 	const struct rxrpc_key_token *token;
-	const struct krb5_principal *princ;
 	size_t size;
 	__be32 *xdr, *oldxdr;
 	u32 cnlen, toksize, ntoks, tok, zero;
 	u16 toksizes[AFSTOKEN_MAX];
-	int loop;
 
 	_enter("");
 
@@ -1077,35 +680,6 @@ static long rxrpc_read(const struct key *key,
 			toksize += RND(token->kad->ticket_len);
 			break;
 
-		case RXRPC_SECURITY_RXK5:
-			princ = &token->k5->client;
-			toksize += 4 + princ->n_name_parts * 4;
-			for (loop = 0; loop < princ->n_name_parts; loop++)
-				toksize += RND(strlen(princ->name_parts[loop]));
-			toksize += 4 + RND(strlen(princ->realm));
-
-			princ = &token->k5->server;
-			toksize += 4 + princ->n_name_parts * 4;
-			for (loop = 0; loop < princ->n_name_parts; loop++)
-				toksize += RND(strlen(princ->name_parts[loop]));
-			toksize += 4 + RND(strlen(princ->realm));
-
-			toksize += 8 + RND(token->k5->session.data_len);
-
-			toksize += 4 * 8 + 2 * 4;
-
-			toksize += 4 + token->k5->n_addresses * 8;
-			for (loop = 0; loop < token->k5->n_addresses; loop++)
-				toksize += RND(token->k5->addresses[loop].data_len);
-
-			toksize += 4 + RND(token->k5->ticket_len);
-			toksize += 4 + RND(token->k5->ticket2_len);
-
-			toksize += 4 + token->k5->n_authdata * 8;
-			for (loop = 0; loop < token->k5->n_authdata; loop++)
-				toksize += RND(token->k5->authdata[loop].data_len);
-			break;
-
 		default: /* we have a ticket we can't encode */
 			pr_err("Unsupported key token type (%u)\n",
 			       token->security_index);
@@ -1181,48 +755,6 @@ static long rxrpc_read(const struct key *key,
 			ENCODE_DATA(token->kad->ticket_len, token->kad->ticket);
 			break;
 
-		case RXRPC_SECURITY_RXK5:
-			princ = &token->k5->client;
-			ENCODE(princ->n_name_parts);
-			for (loop = 0; loop < princ->n_name_parts; loop++)
-				ENCODE_STR(princ->name_parts[loop]);
-			ENCODE_STR(princ->realm);
-
-			princ = &token->k5->server;
-			ENCODE(princ->n_name_parts);
-			for (loop = 0; loop < princ->n_name_parts; loop++)
-				ENCODE_STR(princ->name_parts[loop]);
-			ENCODE_STR(princ->realm);
-
-			ENCODE(token->k5->session.tag);
-			ENCODE_DATA(token->k5->session.data_len,
-				    token->k5->session.data);
-
-			ENCODE64(token->k5->authtime);
-			ENCODE64(token->k5->starttime);
-			ENCODE64(token->k5->endtime);
-			ENCODE64(token->k5->renew_till);
-			ENCODE(token->k5->is_skey);
-			ENCODE(token->k5->flags);
-
-			ENCODE(token->k5->n_addresses);
-			for (loop = 0; loop < token->k5->n_addresses; loop++) {
-				ENCODE(token->k5->addresses[loop].tag);
-				ENCODE_DATA(token->k5->addresses[loop].data_len,
-					    token->k5->addresses[loop].data);
-			}
-
-			ENCODE_DATA(token->k5->ticket_len, token->k5->ticket);
-			ENCODE_DATA(token->k5->ticket2_len, token->k5->ticket2);
-
-			ENCODE(token->k5->n_authdata);
-			for (loop = 0; loop < token->k5->n_authdata; loop++) {
-				ENCODE(token->k5->authdata[loop].tag);
-				ENCODE_DATA(token->k5->authdata[loop].data_len,
-					    token->k5->authdata[loop].data);
-			}
-			break;
-
 		default:
 			break;
 		}


