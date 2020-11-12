Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5F62B059B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgKLNAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:00:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23387 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728531AbgKLNAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:00:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605186011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VacggVq1NxiTEfCcpXQrk3CybU38633I0WB8KyzzIbg=;
        b=aPAl1lN1f4f7XSzWn1bo3q8MElgsq5DN1orAfRkYAsA4Wz8Ucv0liYgdtttLPxIISOF3p4
        7MstK2/OA7r8vjzKeXsPJTgS9zE/5SGnDBy1mTpLNO76izacdQVLMVhC2oWSOI4GKVuxu0
        sg00I8z5EKBtW/8fypgKk3SoCb0MOYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463--7VXsiEvNyKULdskpphZjw-1; Thu, 12 Nov 2020 08:00:02 -0500
X-MC-Unique: -7VXsiEvNyKULdskpphZjw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 269171017DD5;
        Thu, 12 Nov 2020 13:00:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8DF05D98F;
        Thu, 12 Nov 2020 12:59:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 16/18] rxrpc: rxgk: Implement the yfs-rxgk security class
 (GSSAPI)
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:59:55 +0000
Message-ID: <160518599595.2277919.13767473448752027378.stgit@warthog.procyon.org.uk>
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

Implement the basic parts of the yfs-rxgk security class (security index 6)
to support GSSAPI-negotiated security.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/trace/events/rxrpc.h |    4 
 net/rxrpc/Makefile           |    2 
 net/rxrpc/ar-internal.h      |   12 
 net/rxrpc/rxgk.c             | 1063 ++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/rxgk_app.c         |  289 +++++++++++
 net/rxrpc/rxgk_common.h      |  118 +++++
 net/rxrpc/security.c         |    3 
 7 files changed, 1491 insertions(+)
 create mode 100644 net/rxrpc/rxgk.c
 create mode 100644 net/rxrpc/rxgk_app.c

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index e70c90116eda..dd541c6d5ea3 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -210,6 +210,8 @@ enum rxrpc_tx_point {
 	rxrpc_tx_point_call_data_nofrag,
 	rxrpc_tx_point_call_final_resend,
 	rxrpc_tx_point_conn_abort,
+	rxrpc_tx_point_rxgk_challenge,
+	rxrpc_tx_point_rxgk_response,
 	rxrpc_tx_point_rxkad_challenge,
 	rxrpc_tx_point_rxkad_response,
 	rxrpc_tx_point_reject,
@@ -440,6 +442,8 @@ enum rxrpc_tx_point {
 	EM(rxrpc_tx_point_call_final_resend,	"CallFinalResend") \
 	EM(rxrpc_tx_point_conn_abort,		"ConnAbort") \
 	EM(rxrpc_tx_point_reject,		"Reject") \
+	EM(rxrpc_tx_point_rxgk_challenge,	"RxGKChall") \
+	EM(rxrpc_tx_point_rxgk_response,	"RxGKResp") \
 	EM(rxrpc_tx_point_rxkad_challenge,	"RxkadChall") \
 	EM(rxrpc_tx_point_rxkad_response,	"RxkadResp") \
 	EM(rxrpc_tx_point_version_keepalive,	"VerKeepalive") \
diff --git a/net/rxrpc/Makefile b/net/rxrpc/Makefile
index 08636858e77f..4be98775dc7f 100644
--- a/net/rxrpc/Makefile
+++ b/net/rxrpc/Makefile
@@ -37,4 +37,6 @@ rxrpc-$(CONFIG_RXKAD) += rxkad.o
 rxrpc-$(CONFIG_SYSCTL) += sysctl.o
 
 rxrpc-$(CONFIG_RXGK) += \
+	rxgk.o \
+	rxgk_app.o \
 	rxgk_kdf.o
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 4e0766b4a714..efdb3334ad88 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -37,6 +37,7 @@ struct rxrpc_crypt {
 
 struct key_preparsed_payload;
 struct rxrpc_connection;
+struct rxgk_context;
 
 /*
  * Mark applied to socket buffers in skb->mark.  skb->priority is used
@@ -264,6 +265,10 @@ struct rxrpc_security {
 
 	/* clear connection security */
 	void (*clear)(struct rxrpc_connection *);
+
+	/* Default ticket -> key decoder */
+	int (*default_decode_ticket)(struct sk_buff *, unsigned int, unsigned int,
+				     u32 *, struct key **);
 };
 
 /*
@@ -457,7 +462,9 @@ struct rxrpc_connection {
 			u32	nonce;		/* response re-use preventer */
 		} rxkad;
 		struct {
+			struct rxgk_context *keys[1];
 			u64	start_time;	/* The start time for TK derivation */
+			u8	nonce[20];	/* Response re-use preventer */
 		} rxgk;
 	};
 	unsigned long		flags;
@@ -1056,6 +1063,11 @@ void rxrpc_peer_add_rtt(struct rxrpc_call *, enum rxrpc_rtt_rx_trace, int,
 unsigned long rxrpc_get_rto_backoff(struct rxrpc_peer *, bool);
 void rxrpc_peer_init_rtt(struct rxrpc_peer *);
 
+/*
+ * rxgk.c
+ */
+extern const struct rxrpc_security rxgk_yfs;
+
 /*
  * rxkad.c
  */
diff --git a/net/rxrpc/rxgk.c b/net/rxrpc/rxgk.c
new file mode 100644
index 000000000000..703e46e8b508
--- /dev/null
+++ b/net/rxrpc/rxgk.c
@@ -0,0 +1,1063 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* GSSAPI-based RxRPC security
+ *
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/net.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/key-type.h>
+#include "ar-internal.h"
+#include "rxgk_common.h"
+
+struct rxgk_header {
+	__be32	epoch;
+	__be32	cid;
+	__be32	call_number;
+	__be32	seq;
+	__be32	sec_index;
+	__be32	data_len;
+} __packed;
+
+struct rxgk_response {
+	__be64	start_time;
+	__be32	token_len;
+} __packed;
+
+/*
+ * Parse the information from a server key
+ */
+static int rxgk_preparse_server_key(struct key_preparsed_payload *prep)
+{
+	const struct krb5_enctype *krb5;
+	struct krb5_buffer *server_key = (void *)&prep->payload.data[2];
+	unsigned int service, sec_class, kvno, enctype;
+	int n = 0;
+
+	_enter("%zu", prep->datalen);
+
+	if (sscanf(prep->orig_description, "%u:%u:%u:%u%n",
+		   &service, &sec_class, &kvno, &enctype, &n) != 4)
+		return -EINVAL;
+
+	if (prep->orig_description[n])
+		return -EINVAL;
+
+	krb5 = crypto_krb5_find_enctype(enctype);
+	if (!krb5)
+		return -ENOPKG;
+
+	prep->payload.data[0] = (struct krb5_enctype *)krb5;
+
+	if (prep->datalen != krb5->key_len)
+		return -EKEYREJECTED;
+
+	server_key->len = prep->datalen;
+	server_key->data = kmemdup(prep->data, prep->datalen, GFP_KERNEL);
+	if (!server_key->data)
+		return -ENOMEM;
+
+	_leave(" = 0");
+	return 0;
+}
+
+static void rxgk_free_server_key(union key_payload *payload)
+{
+	struct krb5_buffer *server_key = (void *)&payload->data[2];
+
+	kfree_sensitive(server_key->data);
+}
+
+static void rxgk_free_preparse_server_key(struct key_preparsed_payload *prep)
+{
+	rxgk_free_server_key(&prep->payload);
+}
+
+static void rxgk_destroy_server_key(struct key *key)
+{
+	rxgk_free_server_key(&key->payload);
+}
+
+static void rxgk_describe_server_key(const struct key *key, struct seq_file *m)
+{
+	const struct krb5_enctype *krb5 = key->payload.data[0];
+
+	if (krb5)
+		seq_printf(m, ": %s", krb5->name);
+}
+
+static struct rxgk_context *rxgk_get_key(struct rxrpc_connection *conn,
+					 u16 *specific_key_number)
+{
+	refcount_inc(&conn->rxgk.keys[0]->usage);
+	return conn->rxgk.keys[0];
+}
+
+/*
+ * initialise connection security
+ */
+static int rxgk_init_connection_security(struct rxrpc_connection *conn,
+					 struct rxrpc_key_token *token)
+{
+	struct rxgk_context *gk;
+	int ret;
+
+	_enter("{%d},{%x}", conn->debug_id, key_serial(conn->params.key));
+
+	conn->security_ix = token->security_index;
+	conn->params.security_level = token->rxgk->level;
+
+	if (rxrpc_conn_is_client(conn)) {
+		conn->rxgk.start_time = ktime_get();
+		do_div(conn->rxgk.start_time, 100);
+	}
+
+	gk = rxgk_generate_transport_key(conn, token->rxgk, 0, GFP_NOFS);
+	if (IS_ERR(gk))
+		return PTR_ERR(gk);
+	conn->rxgk.keys[0] = gk;
+
+	switch (conn->params.security_level) {
+	case RXRPC_SECURITY_PLAIN:
+		break;
+	case RXRPC_SECURITY_AUTH:
+		conn->security_size = gk->krb5->cksum_len;
+		break;
+	case RXRPC_SECURITY_ENCRYPT:
+		if (gk->krb5->pad)
+			conn->size_align = gk->krb5->block_len;
+		conn->security_size = gk->krb5->conf_len + sizeof(struct rxgk_header);
+		conn->security_trailer = gk->krb5->cksum_len;
+		break;
+	default:
+		ret = -EKEYREJECTED;
+		goto error;
+	}
+
+	ret = 0;
+error:
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * Clean up the crypto on a call.
+ */
+static void rxgk_free_call_crypto(struct rxrpc_call *call)
+{
+}
+
+/*
+ * Integrity mode (sign a packet - level 1 security)
+ */
+static int rxgk_secure_packet_integrity(const struct rxrpc_call *call,
+					struct rxgk_context *gk,
+					struct sk_buff *skb, u32 data_size)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	struct rxgk_header *hdr;
+	struct krb5_buffer metadata;
+	int ret = -ENOMEM;
+
+	_enter("");
+
+	hdr = kzalloc(sizeof(*hdr), GFP_NOFS);
+	if (!hdr)
+		goto error_gk;
+
+	hdr->epoch	= htonl(call->conn->proto.epoch);
+	hdr->cid	= htonl(call->cid);
+	hdr->call_number = htonl(call->call_id);
+	hdr->seq	= htonl(sp->hdr.seq);
+	hdr->sec_index	= htonl(call->security_ix);
+	hdr->data_len	= htonl(data_size);
+
+	metadata.len = sizeof(*hdr);
+	metadata.data = hdr;
+	ret = rxgk_get_mic_skb(gk->krb5, gk->tx_Kc, &metadata, skb,
+			       0, skb->len, gk->krb5->cksum_len, data_size);
+	if (ret >= 0)
+		gk->bytes_remaining -= ret;
+	kfree(hdr);
+error_gk:
+	rxgk_put(gk);
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * wholly encrypt a packet (level 2 security)
+ */
+static int rxgk_secure_packet_encrypted(const struct rxrpc_call *call,
+					struct rxgk_context *gk,
+					struct sk_buff *skb, u32 data_size)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	struct rxgk_header hdr;
+	int ret;
+
+	_enter("%x,%x", skb->len, data_size);
+
+	/* Insert the header into the skb */
+	hdr.epoch	= htonl(call->conn->proto.epoch);
+	hdr.cid		= htonl(call->cid);
+	hdr.call_number = htonl(call->call_id);
+	hdr.seq		= htonl(sp->hdr.seq);
+	hdr.sec_index	= htonl(call->security_ix);
+	hdr.data_len	= htonl(data_size);
+
+	ret = skb_store_bits(skb, gk->krb5->conf_len, &hdr, sizeof(hdr));
+	if (ret < 0)
+		goto error;
+
+	/* Increase the buffer size to allow for the checksum to be written in */
+	skb->len += gk->krb5->cksum_len;
+
+	ret = rxgk_encrypt_skb(gk->krb5, &gk->tx_enc, skb,
+			       0, skb->len, gk->krb5->conf_len, sizeof(hdr) + data_size,
+			       false);
+	if (ret >= 0)
+		gk->bytes_remaining -= ret;
+
+error:
+	rxgk_put(gk);
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * checksum an RxRPC packet header
+ */
+static int rxgk_secure_packet(struct rxrpc_call *call,
+			      struct sk_buff *skb,
+			      size_t data_size)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	struct rxgk_context *gk;
+	int ret;
+
+	sp = rxrpc_skb(skb);
+
+	_enter("{%d{%x}},{#%u},%zu,",
+	       call->debug_id, key_serial(call->conn->params.key),
+	       sp->hdr.seq, data_size);
+
+	gk = rxgk_get_key(call->conn, NULL);
+	if (IS_ERR(gk))
+		return PTR_ERR(gk) == -ESTALE ? -EKEYREJECTED : PTR_ERR(gk);
+
+	ret = key_validate(call->conn->params.key);
+	if (ret < 0)
+		return ret;
+
+	sp->hdr.cksum = gk->key_number;
+
+	switch (call->conn->params.security_level) {
+	case RXRPC_SECURITY_PLAIN:
+		rxgk_put(gk);
+		return 0;
+	case RXRPC_SECURITY_AUTH:
+		return rxgk_secure_packet_integrity(call, gk, skb, data_size);
+	case RXRPC_SECURITY_ENCRYPT:
+		return rxgk_secure_packet_encrypted(call, gk, skb, data_size);
+	default:
+		rxgk_put(gk);
+		return -EPERM;
+	}
+}
+
+/*
+ * Integrity mode (check the signature on a packet - level 1 security)
+ */
+static int rxgk_verify_packet_integrity(struct rxrpc_call *call,
+					struct rxgk_context *gk,
+					struct sk_buff *skb,
+					unsigned int offset, unsigned int len,
+					rxrpc_seq_t seq)
+{
+	struct rxgk_header *hdr;
+	struct krb5_buffer metadata;
+	bool aborted;
+	u32 ac;
+	int ret = -ENOMEM;
+
+	_enter("");
+
+	hdr = kzalloc(sizeof(*hdr), GFP_NOFS);
+	if (!hdr)
+		goto error;
+
+	hdr->epoch	= htonl(call->conn->proto.epoch);
+	hdr->cid	= htonl(call->cid);
+	hdr->call_number = htonl(call->call_id);
+	hdr->seq	= htonl(seq);
+	hdr->sec_index	= htonl(call->security_ix);
+	hdr->data_len	= htonl(len - gk->krb5->cksum_len);
+
+	metadata.len = sizeof(*hdr);
+	metadata.data = hdr;
+	ret = rxgk_verify_mic_skb(gk->krb5, gk->rx_Kc, &metadata,
+				  skb, &offset, &len, &ac);
+	kfree(hdr);
+	if (ret < 0) {
+		if (ret == -EPROTO) {
+			aborted = rxrpc_abort_eproto(call, skb, "rxgk_2_vfy",
+						     "V1V", ac);
+			goto protocol_error;
+		}
+		goto error;
+	}
+
+error:
+	rxgk_put(gk);
+	_leave(" = %d", ret);
+	return ret;
+
+protocol_error:
+	if (aborted)
+		rxrpc_send_abort_packet(call);
+	ret = -EPROTO;
+	goto error;
+}
+
+/*
+ * Decrypt an encrypted packet (level 2 security).
+ */
+static int rxgk_verify_packet_encrypted(struct rxrpc_call *call,
+					struct rxgk_context *gk,
+					struct sk_buff *skb,
+					unsigned int offset, unsigned int len,
+					rxrpc_seq_t seq)
+{
+	struct rxgk_header hdr;
+	bool aborted;
+	int ret;
+	u32 ac;
+
+	_enter("");
+
+	ret = rxgk_decrypt_skb(gk->krb5, &gk->rx_enc, skb, &offset, &len, &ac);
+	if (ret < 0) {
+		if (ret == -EPROTO) {
+			aborted = rxrpc_abort_eproto(call, skb, "rxgk_2_dec",
+						     "V2D", ac);
+			goto protocol_error;
+		}
+		goto error;
+	}
+
+	if (len < sizeof(hdr)) {
+		aborted = rxrpc_abort_eproto(call, skb, "rxgk_2_hdr",
+					     "V2L", RXGK_PACKETSHORT);
+		goto protocol_error;
+	}
+
+	/* Extract the header from the skb */
+	ret = skb_copy_bits(skb, offset, &hdr, sizeof(hdr));
+	if (ret < 0)
+		goto error;
+	len -= sizeof(hdr);
+
+	if (ntohl(hdr.epoch)		!= call->conn->proto.epoch ||
+	    ntohl(hdr.cid)		!= call->cid ||
+	    ntohl(hdr.call_number)	!= call->call_id ||
+	    ntohl(hdr.seq)		!= seq ||
+	    ntohl(hdr.sec_index)	!= call->security_ix ||
+	    ntohl(hdr.data_len)		> len) {
+		aborted = rxrpc_abort_eproto(call, skb, "rxgk_2_hdr", "V2H",
+					     RXGK_SEALED_INCON);
+		goto protocol_error;
+	}
+
+	ret = 0;
+
+error:
+	rxgk_put(gk);
+	_leave(" = %d", ret);
+	return ret;
+
+protocol_error:
+	if (aborted)
+		rxrpc_send_abort_packet(call);
+	ret = -EPROTO;
+	goto error;
+}
+
+/*
+ * Verify the security on a received packet or subpacket (if part of a
+ * jumbo packet).
+ */
+static int rxgk_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
+			      unsigned int offset, unsigned int len,
+			      rxrpc_seq_t seq, u16 key_number)
+{
+	struct rxgk_context *gk;
+	bool aborted;
+
+	_enter("{%d{%x}},{#%u}",
+	       call->debug_id, key_serial(call->conn->params.key), seq);
+
+	gk = rxgk_get_key(call->conn, &key_number);
+	if (IS_ERR(gk)) {
+		switch (PTR_ERR(gk)) {
+		case -ESTALE:
+			aborted = rxrpc_abort_eproto(call, skb, "rxgk_csum", "VKY",
+						     RXGK_BADKEYNO);
+			gk = NULL;
+			goto protocol_error;
+		default:
+			return PTR_ERR(gk);
+		}
+	}
+
+	switch (call->conn->params.security_level) {
+	case RXRPC_SECURITY_PLAIN:
+		return 0;
+	case RXRPC_SECURITY_AUTH:
+		return rxgk_verify_packet_integrity(call, gk, skb, offset, len, seq);
+	case RXRPC_SECURITY_ENCRYPT:
+		return rxgk_verify_packet_encrypted(call, gk, skb, offset, len, seq);
+	default:
+		rxgk_put(gk);
+		return -ENOANO;
+	}
+
+protocol_error:
+	if (aborted)
+		rxrpc_send_abort_packet(call);
+	rxgk_put(gk);
+	return -EPROTO;
+}
+
+/*
+ * Locate the data contained in a packet that was partially encrypted.
+ */
+static void rxgk_locate_data_1(struct rxrpc_call *call, struct sk_buff *skb,
+			       unsigned int *_offset, unsigned int *_len)
+{
+	*_offset += call->conn->security_size;
+	*_len -= call->conn->security_size;
+}
+
+/*
+ * Locate the data contained in a packet that was completely encrypted.
+ */
+static void rxgk_locate_data_2(struct rxrpc_call *call, struct sk_buff *skb,
+			       unsigned int *_offset, unsigned int *_len)
+{
+	unsigned int off = call->conn->security_size - sizeof(__be32);
+	__be32 data_length_be;
+	u32 data_length;
+
+	if (skb_copy_bits(skb, *_offset + off, &data_length_be, sizeof(u32)) < 0)
+		BUG();
+	data_length = ntohl(data_length_be);
+	*_offset += call->conn->security_size;
+	*_len = data_length;
+}
+
+/*
+ * Locate the data contained in an already decrypted packet.
+ */
+static void rxgk_locate_data(struct rxrpc_call *call, struct sk_buff *skb,
+			     unsigned int *_offset, unsigned int *_len)
+{
+	switch (call->conn->params.security_level) {
+	case RXRPC_SECURITY_AUTH:
+		rxgk_locate_data_1(call, skb, _offset, _len);
+		return;
+	case RXRPC_SECURITY_ENCRYPT:
+		rxgk_locate_data_2(call, skb, _offset, _len);
+		return;
+	default:
+		return;
+	}
+}
+
+/*
+ * issue a challenge
+ */
+static int rxgk_issue_challenge(struct rxrpc_connection *conn)
+{
+	struct rxrpc_wire_header whdr;
+	struct msghdr msg;
+	struct kvec iov[2];
+	size_t len;
+	u32 serial;
+	int ret;
+
+	_enter("{%d}", conn->debug_id);
+
+	get_random_bytes(&conn->rxgk.nonce, sizeof(conn->rxgk.nonce));
+
+	msg.msg_name	= &conn->params.peer->srx.transport;
+	msg.msg_namelen	= conn->params.peer->srx.transport_len;
+	msg.msg_control	= NULL;
+	msg.msg_controllen = 0;
+	msg.msg_flags	= 0;
+
+	whdr.epoch	= htonl(conn->proto.epoch);
+	whdr.cid	= htonl(conn->proto.cid);
+	whdr.callNumber	= 0;
+	whdr.seq	= 0;
+	whdr.type	= RXRPC_PACKET_TYPE_CHALLENGE;
+	whdr.flags	= conn->out_clientflag;
+	whdr.userStatus	= 0;
+	whdr.securityIndex = conn->security_ix;
+	whdr._rsvd	= 0;
+	whdr.serviceId	= htons(conn->service_id);
+
+	iov[0].iov_base	= &whdr;
+	iov[0].iov_len	= sizeof(whdr);
+	iov[1].iov_base	= conn->rxgk.nonce;
+	iov[1].iov_len	= sizeof(conn->rxgk.nonce);
+
+	len = iov[0].iov_len + iov[1].iov_len;
+
+	serial = atomic_inc_return(&conn->serial);
+	whdr.serial = htonl(serial);
+	_proto("Tx CHALLENGE %%%u", serial);
+
+	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 2, len);
+	if (ret < 0) {
+		trace_rxrpc_tx_fail(conn->debug_id, serial, ret,
+				    rxrpc_tx_point_rxgk_challenge);
+		return -EAGAIN;
+	}
+
+	conn->params.peer->last_tx_at = ktime_get_seconds();
+	trace_rxrpc_tx_packet(conn->debug_id, &whdr,
+			      rxrpc_tx_point_rxgk_challenge);
+	_leave(" = 0");
+	return 0;
+}
+
+/*
+ * Send a response packet.
+ */
+static int rxgk_send_response(struct rxrpc_connection *conn,
+			      struct sk_buff *skb)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	struct rxrpc_wire_header whdr;
+	struct msghdr msg;
+	struct kvec iov[2];
+	size_t len;
+	u32 serial;
+	int ret, i;
+
+	_enter("");
+
+	msg.msg_name	= &conn->params.peer->srx.transport;
+	msg.msg_namelen	= conn->params.peer->srx.transport_len;
+	msg.msg_control	= NULL;
+	msg.msg_controllen = 0;
+	msg.msg_flags	= 0;
+
+	memset(&whdr, 0, sizeof(whdr));
+	whdr.epoch	= htonl(sp->hdr.epoch);
+	whdr.cid	= htonl(sp->hdr.cid);
+	whdr.type	= RXRPC_PACKET_TYPE_RESPONSE;
+	whdr.flags	= sp->hdr.flags;
+	whdr.securityIndex = sp->hdr.securityIndex;
+	whdr.cksum	= htons(sp->hdr.cksum);
+	whdr.serviceId	= htons(sp->hdr.serviceId);
+
+	iov[0].iov_base	= &whdr;
+	iov[0].iov_len	= sizeof(whdr);
+	iov[1].iov_base	= skb->head;
+	iov[1].iov_len	= skb->len;
+
+	len = 0;
+	for (i = 0; i < ARRAY_SIZE(iov); i++)
+		len += iov[i].iov_len;
+
+	serial = atomic_inc_return(&conn->serial);
+	whdr.serial = htonl(serial);
+	_proto("Tx RESPONSE %%%u", serial);
+
+	ret = kernel_sendmsg(conn->params.local->socket, &msg,
+			     iov, ARRAY_SIZE(iov), len);
+	if (ret < 0) {
+		trace_rxrpc_tx_fail(conn->debug_id, serial, ret,
+				    rxrpc_tx_point_rxgk_response);
+		return -EAGAIN;
+	}
+
+	conn->params.peer->last_tx_at = ktime_get_seconds();
+	_leave(" = 0");
+	return 0;
+}
+
+/*
+ * Construct the authenticator to go in the response packet
+ *
+ * struct RXGK_Authenticator {
+ *	opaque nonce[20];
+ *	opaque appdata<>;
+ *	RXGK_Level level;
+ *	unsigned int epoch;
+ *	unsigned int cid;
+ *	unsigned int call_numbers<>;
+ * };
+ */
+static void rxgk_construct_authenticator(struct rxrpc_connection *conn,
+					 const u8 *nonce,
+					 struct sk_buff *skb)
+{
+	__be32 xdr[9];
+
+	__skb_put_data(skb, nonce, 20);
+
+	xdr[0] = htonl(0); /* appdata len */
+	xdr[1] = htonl(conn->params.security_level);
+	xdr[2] = htonl(conn->proto.epoch);
+	xdr[3] = htonl(conn->proto.cid);
+	xdr[4] = htonl(4); /* # call_numbers */
+	xdr[5] = htonl(conn->channels[0].call_counter);
+	xdr[6] = htonl(conn->channels[1].call_counter);
+	xdr[7] = htonl(conn->channels[2].call_counter);
+	xdr[8] = htonl(conn->channels[3].call_counter);
+
+	__skb_put_data(skb, xdr, sizeof(xdr));
+}
+
+/*
+ * Construct the response.
+ *
+ * struct RXGK_Response {
+ *	rxgkTime start_time;
+ *	RXGK_Data token;
+ *	opaque authenticator<RXGK_MAXAUTHENTICATOR>
+ * };
+ */
+static int rxgk_construct_response(struct rxrpc_connection *conn,
+				   struct sk_buff *challenge,
+				   const u8 *nonce)
+{
+	struct rxrpc_skb_priv *csp = rxrpc_skb(challenge), *rsp;
+	struct rxgk_context *gk;
+	struct sk_buff *skb;
+	unsigned short resp_len, auth_len, pad_len, enc_len, auth_pad_len, authx_len;
+	unsigned short auth_offset, authx_offset;
+	__be64 start_time;
+	__be32 tmp;
+	void *p;
+	int ret;
+
+	gk = rxgk_get_key(conn, NULL);
+	if (IS_ERR(gk))
+		return PTR_ERR(gk);
+
+	auth_len = 20 + 4 /* appdatalen */ + 12 + (1 + 4) * 4;
+	if (gk->krb5->pad) {
+		enc_len = round_up(gk->krb5->conf_len + auth_len, gk->krb5->block_len);
+		pad_len = enc_len - (gk->krb5->conf_len + auth_len);
+	} else {
+		enc_len = gk->krb5->conf_len + auth_len;
+		pad_len = 0;
+	}
+	authx_len = enc_len + gk->krb5->cksum_len;
+	auth_pad_len = xdr_round_up(authx_len) - authx_len;
+
+	resp_len  = 8;
+	resp_len += 4 + xdr_round_up(gk->key->ticket.len);
+	resp_len += 4 + xdr_round_up(authx_len);
+
+	ret = -ENOMEM;
+	skb = alloc_skb(resp_len, GFP_NOFS);
+	if (!skb)
+		goto error_gk;
+
+	rsp = rxrpc_skb(skb);
+	rsp->hdr = csp->hdr;
+	rsp->hdr.flags = conn->out_clientflag;
+	rsp->hdr.cksum = gk->key_number;
+
+	start_time = cpu_to_be64(conn->rxgk.start_time);
+	p = __skb_put_data(skb, &start_time, 8);
+
+	tmp = htonl(gk->key->ticket.len);
+	__skb_put_data(skb, &tmp, 4);
+	__skb_put_data(skb, gk->key->ticket.data, xdr_round_up(gk->key->ticket.len));
+	tmp = htonl(authx_len);
+	__skb_put_data(skb, &tmp, 4);
+	authx_offset = skb->len;
+	__skb_put_zero(skb, gk->krb5->conf_len);
+	auth_offset = skb->len;
+	rxgk_construct_authenticator(conn, nonce, skb);
+	__skb_put_zero(skb, pad_len + gk->krb5->cksum_len + auth_pad_len);
+
+	ret = rxgk_encrypt_skb(gk->krb5, &gk->resp_enc, skb,
+			       authx_offset, authx_len,
+			       auth_offset, auth_len, false);
+	if (ret < 0)
+		goto error;
+
+	ret = rxgk_send_response(conn, skb);
+error:
+	kfree_skb(skb);
+error_gk:
+	rxgk_put(gk);
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * Respond to a challenge packet
+ */
+static int rxgk_respond_to_challenge(struct rxrpc_connection *conn,
+				     struct sk_buff *skb,
+				     u32 *_abort_code)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	const char *eproto;
+	u32 abort_code;
+	u8 nonce[20];
+	int ret;
+
+	_enter("{%d,%x}", conn->debug_id, key_serial(conn->params.key));
+
+	eproto = tracepoint_string("chall_no_key");
+	abort_code = RX_PROTOCOL_ERROR;
+	if (!conn->params.key)
+		goto protocol_error;
+
+	abort_code = RXGK_EXPIRED;
+	ret = key_validate(conn->params.key);
+	if (ret < 0)
+		goto other_error;
+
+	eproto = tracepoint_string("chall_short");
+	abort_code = RXGK_PACKETSHORT;
+	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
+			  nonce, sizeof(nonce)) < 0)
+		goto protocol_error;
+
+	_proto("Rx CHALLENGE %%%u { n=%20phN }", sp->hdr.serial, nonce);
+
+	ret = rxgk_construct_response(conn, skb, nonce);
+	if (ret < 0)
+		goto error;
+	return ret;
+
+protocol_error:
+	trace_rxrpc_rx_eproto(NULL, sp->hdr.serial, eproto);
+	ret = -EPROTO;
+other_error:
+	*_abort_code = abort_code;
+error:
+	return ret;
+}
+
+/*
+ * Verify the authenticator.
+ *
+ * struct RXGK_Authenticator {
+ *	opaque nonce[20];
+ *	opaque appdata<>;
+ *	RXGK_Level level;
+ *	unsigned int epoch;
+ *	unsigned int cid;
+ *	unsigned int call_numbers<>;
+ * };
+ */
+static int rxgk_verify_authenticator(struct rxrpc_connection *conn,
+				     const struct krb5_enctype *krb5,
+				     struct sk_buff *skb,
+				     unsigned int auth_offset, unsigned int auth_len,
+				     u32 *_abort_code, const char **_eproto)
+{
+	void *auth;
+	__be32 *p, *end;
+	u32 app_len, call_count, level, epoch, cid, i;
+	int ret;
+
+	_enter("");
+
+	auth = kmalloc(auth_len, GFP_NOFS);
+	if (!auth)
+		return -ENOMEM;
+
+	ret = skb_copy_bits(skb, auth_offset, auth, auth_len);
+	if (ret < 0)
+		goto error;
+
+	*_eproto = tracepoint_string("rxgk_rsp_nonce");
+	p = auth;
+	end = auth + auth_len;
+	if (memcmp(auth, conn->rxgk.nonce, 20) != 0)
+		goto bad_auth;
+	p += 20 / sizeof(__be32);
+
+	*_eproto = tracepoint_string("rxgk_rsp_applen");
+	app_len	= ntohl(*p++);
+	if (app_len > (end - p) * sizeof(__be32))
+		goto bad_auth;
+	p += xdr_round_up(app_len) / sizeof(__be32);
+	if (end - p < 4)
+		goto bad_auth;
+	level	= ntohl(*p++);
+	epoch	= ntohl(*p++);
+	cid	= ntohl(*p++);
+	call_count = ntohl(*p++);
+
+	*_eproto = tracepoint_string("rxgk_rsp_params");
+	if (level	!= conn->params.security_level ||
+	    epoch	!= conn->proto.epoch ||
+	    cid		!= conn->proto.cid ||
+	    call_count	> 4)
+		goto bad_auth;
+	if (end - p < call_count)
+		goto bad_auth;
+
+	spin_lock(&conn->bundle->channel_lock);
+	for (i = 0; i < call_count; i++) {
+		struct rxrpc_call *call;
+		u32 call_id = ntohl(*p++);
+
+		*_eproto = tracepoint_string("rxgk_rsp_callid");
+		if (call_id > INT_MAX)
+			goto bad_auth_unlock;
+
+		*_eproto = tracepoint_string("rxgk_rsp_callctr");
+		if (call_id < conn->channels[i].call_counter)
+			goto bad_auth_unlock;
+
+		*_eproto = tracepoint_string("rxgk_rsp_callst");
+		if (call_id > conn->channels[i].call_counter) {
+			call = rcu_dereference_protected(
+				conn->channels[i].call,
+				lockdep_is_held(&conn->bundle->channel_lock));
+			if (call && call->state < RXRPC_CALL_COMPLETE)
+				goto bad_auth_unlock;
+			conn->channels[i].call_counter = call_id;
+		}
+	}
+	spin_unlock(&conn->bundle->channel_lock);
+	ret = 0;
+error:
+	kfree(auth);
+	_leave(" = %d", ret);
+	return ret;
+
+bad_auth_unlock:
+	spin_unlock(&conn->bundle->channel_lock);
+bad_auth:
+	*_abort_code = RXGK_NOTAUTH;
+	ret = -EPROTO;
+	goto error;
+}
+
+/*
+ * Verify a response.
+ *
+ * struct RXGK_Response {
+ *	rxgkTime	start_time;
+ *	RXGK_Data	token;
+ *	opaque		authenticator<RXGK_MAXAUTHENTICATOR>
+ * };
+ */
+static int rxgk_verify_response(struct rxrpc_connection *conn,
+				struct sk_buff *skb,
+				u32 *_abort_code)
+{
+	const struct krb5_enctype *krb5;
+	struct rxrpc_key_token *token;
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	struct krb5_enc_keys token_enc = {};
+	struct rxgk_context *gk;
+	struct key *key = NULL;
+	const char *eproto;
+	unsigned int offset = sizeof(struct rxrpc_wire_header);
+	unsigned int len = skb->len - sizeof(struct rxrpc_wire_header);
+	unsigned int token_offset, token_len;
+	unsigned int auth_offset, auth_len;
+	__be32 xauth_len;
+	u32 abort_code;
+	int ret;
+
+	struct rxgk_response rhdr;
+
+	_enter("{%d}", conn->debug_id);
+
+	/* Parse the RXGK_Response object */
+	if (sizeof(rhdr) + sizeof(__be32) > len)
+		goto short_packet;
+
+	if (skb_copy_bits(skb, offset, &rhdr, sizeof(rhdr)) < 0)
+		goto short_packet;
+	offset	+= sizeof(rhdr);
+	len	-= sizeof(rhdr);
+
+	token_offset	= offset;
+	token_len	= ntohl(rhdr.token_len);
+	if (xdr_round_up(token_len) + sizeof(__be32) > len)
+		goto short_packet;
+
+	offset	+= xdr_round_up(token_len);
+	len	-= xdr_round_up(token_len);
+
+	if (skb_copy_bits(skb, offset, &xauth_len, sizeof(xauth_len)) < 0)
+		goto short_packet;
+	offset	+= sizeof(xauth_len);
+	len	-= sizeof(xauth_len);
+
+	auth_offset	= offset;
+	auth_len	= ntohl(xauth_len);
+	if (auth_len < len)
+		goto short_packet;
+	if (auth_len & 3)
+		goto inconsistent;
+	if (auth_len < 20 + 9 * 4)
+		goto auth_too_short;
+
+	/* We need to extract and decrypt the token and instantiate a session
+	 * key for it.  This bit, however, is application-specific.  If
+	 * possible, we use a default parser, but we might end up bumping this
+	 * to the app to deal with - which might mean a round trip to
+	 * userspace.
+	 */
+	ret = rxgk_extract_token(conn, skb, token_offset, token_len, &key,
+				 &abort_code, &eproto);
+	if (ret < 0)
+		goto protocol_error;
+
+	/* We now have a key instantiated from the decrypted ticket.  We can
+	 * pass this to the application so that they can parse the ticket
+	 * content and we can use the session key it contains to derive the
+	 * keys we need.
+	 *
+	 * Note that we have to switch enctype at this point as the enctype of
+	 * the ticket doesn't necessarily match that of the transport.
+	 */
+	token = key->payload.data[0];
+	conn->params.security_level = token->rxgk->level;
+	conn->rxgk.start_time = __be64_to_cpu(rhdr.start_time);
+
+	gk = rxgk_generate_transport_key(conn, token->rxgk, sp->hdr.cksum, GFP_NOFS);
+	if (IS_ERR(gk)) {
+		ret = PTR_ERR(gk);
+		goto cant_get_token;
+	}
+
+	krb5 = gk->krb5;
+
+	/* Decrypt, parse and verify the authenticator. */
+	eproto = tracepoint_string("rxgk_rsp_dec_auth");
+	ret = rxgk_decrypt_skb(krb5, &gk->resp_enc, skb,
+			       &auth_offset, &auth_len, &abort_code);
+	if (ret < 0)
+		goto protocol_error;
+
+	ret = rxgk_verify_authenticator(conn, krb5, skb, auth_offset, auth_len,
+					&abort_code, &eproto);
+	if (ret < 0)
+		goto protocol_error;
+
+	conn->params.key = key;
+	key = NULL;
+	ret = 0;
+out:
+	key_put(key);
+	crypto_krb5_free_enc_keys(&token_enc);
+	_leave(" = %d", ret);
+	return ret;
+
+inconsistent:
+	eproto = tracepoint_string("rxgk_rsp_xdr_align");
+	abort_code = RXGK_INCONSISTENCY;
+	ret = -EPROTO;
+	goto protocol_error;
+auth_too_short:
+	eproto = tracepoint_string("rxgk_rsp_short_auth");
+	abort_code = RXGK_PACKETSHORT;
+	ret = -EPROTO;
+	goto protocol_error;
+short_packet:
+	eproto = tracepoint_string("rxgk_rsp_short");
+	abort_code = RXGK_PACKETSHORT;
+	ret = -EPROTO;
+protocol_error:
+	trace_rxrpc_rx_eproto(NULL, sp->hdr.serial, eproto);
+	*_abort_code = abort_code;
+	goto out;
+
+cant_get_token:
+	switch (ret) {
+	case -ENOMEM:
+		goto temporary_error;
+	case -EINVAL:
+		eproto = tracepoint_string("rxgk_rsp_internal_error");
+		abort_code = RXGK_NOTAUTH;
+		ret = -EKEYREJECTED;
+		goto protocol_error;
+	case -ENOPKG:
+		eproto = tracepoint_string("rxgk_rsp_nopkg");
+		abort_code = RXGK_BADETYPE;
+		ret = -EKEYREJECTED;
+		goto protocol_error;
+	}
+
+temporary_error:
+	/* Ignore the response packet if we got a temporary error such as
+	 * ENOMEM.  We just want to send the challenge again.  Note that we
+	 * also come out this way if the ticket decryption fails.
+	 */
+	goto out;
+}
+
+/*
+ * clear the connection security
+ */
+static void rxgk_clear(struct rxrpc_connection *conn)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(conn->rxgk.keys); i++)
+		rxgk_put(conn->rxgk.keys[i]);
+}
+
+/*
+ * Initialise the RxGK security service.
+ */
+static int rxgk_init(void)
+{
+	return 0;
+}
+
+/*
+ * Clean up the RxGK security service.
+ */
+static void rxgk_exit(void)
+{
+}
+
+/*
+ * RxRPC YFS GSSAPI-based security
+ */
+const struct rxrpc_security rxgk_yfs = {
+	.name				= "yfs-rxgk",
+	.security_index			= RXRPC_SECURITY_YFS_RXGK,
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
+	.default_decode_ticket		= rxgk_yfs_decode_ticket,
+};
diff --git a/net/rxrpc/rxgk_app.c b/net/rxrpc/rxgk_app.c
new file mode 100644
index 000000000000..895879f3acfb
--- /dev/null
+++ b/net/rxrpc/rxgk_app.c
@@ -0,0 +1,289 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Application-specific bits for GSSAPI-based RxRPC security
+ *
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/net.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/key-type.h>
+#include "ar-internal.h"
+#include "rxgk_common.h"
+
+/*
+ * Decode a default-style YFS ticket in a response and turn it into an
+ * rxrpc-type key.
+ *
+ * struct rxgk_key {
+ *	afs_uint32	enctype;
+ *	opaque		key<>;
+ * };
+ *
+ * struct RXGK_AuthName {
+ *	afs_int32	kind;
+ *	opaque		data<AUTHDATAMAX>;
+ *	opaque		display<AUTHPRINTABLEMAX>;
+ * };
+ *
+ * struct RXGK_Token {
+ *	rxgk_key		K0;
+ *	RXGK_Level		level;
+ *	rxgkTime		starttime;
+ *	afs_int32		lifetime;
+ *	afs_int32		bytelife;
+ *	rxgkTime		expirationtime;
+ *	struct RXGK_AuthName	identities<>;
+ * };
+ */
+int rxgk_yfs_decode_ticket(struct sk_buff *skb,
+			   unsigned int ticket_offset, unsigned int ticket_len,
+			   u32 *_abort_code,
+			   struct key **_key)
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
+	if (klen > ticket_len - 10 * sizeof(__be32)) {
+		*_abort_code = RXGK_INCONSISTENCY;
+		return -EPROTO;
+	}
+
+	pre_ticket_len = ((5 + 14) * sizeof(__be32) +
+			  xdr_round_up(klen) +
+			  sizeof(__be32));
+	payload_len = pre_ticket_len + xdr_round_up(ticket_len);
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
+	p[4] = htonl(15 * sizeof(__be32) + xdr_round_up(klen) + xdr_round_up(ticket_len)); /* Token len */
+
+	/* Now fill in the body.  Most of this we can just scrape directly from
+	 * the ticket.
+	 */
+	t = ticket + sizeof(__be32) * 2 + xdr_round_up(klen);
+	q = payload + 5 * sizeof(__be32);
+	q[ 0] = htonl(RXRPC_SECURITY_YFS_RXGK);
+	q[ 1] = t[1];		/* begintime - msw */
+	q[ 2] = t[2];		/* - lsw */
+	q[ 3] = t[5];		/* endtime - msw */
+	q[ 4] = t[6];		/* - lsw */
+	q[ 5] = 0;		/* level - msw */
+	q[ 6] = t[0];		/* - lsw */
+	q[ 7] = 0;		/* lifetime - msw */
+	q[ 8] = t[3];		/* - lsw */
+	q[ 9] = 0;		/* bytelife - msw */
+	q[10] = t[4];		/* - lsw */
+	q[11] = 0;		/* enctype - msw */
+	q[12] = htonl(enctype);	/* - lsw */
+	q[13] = htonl(klen);	/* Key length */
+
+	q += 14;
+
+	memcpy(q, ticket + sizeof(__be32) * 2, klen);
+	q += xdr_round_up(klen) / 4;
+	q[0] = ntohl(ticket_len);
+	q++;
+	if (WARN_ON((unsigned long)q != (unsigned long)ticket)) {
+		ret = -EIO;
+		goto error;
+	}
+
+	/* Ticket read in with skb_copy_bits above */
+	q += xdr_round_up(ticket_len) / 4;
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
+/*
+ * Extract the token and set up a session key from the details.
+ *
+ * struct RXGK_TokenContainer {
+ *	afs_int32	kvno;
+ *	afs_int32	enctype;
+ *	opaque		encrypted_token<>;
+ * };
+ *
+ * [tools.ietf.org/html/draft-wilkinson-afs3-rxgk-afs-08 sec 6.1]
+ */
+int rxgk_extract_token(struct rxrpc_connection *conn,
+		       struct sk_buff *skb,
+		       unsigned int token_offset, unsigned int token_len,
+		       struct key **_key,
+		       u32 *_abort_code, const char **_eproto)
+{
+	const struct krb5_enctype *krb5;
+	const struct krb5_buffer *server_secret;
+	struct krb5_enc_keys token_enc = {};
+	struct key *server_key;
+	unsigned int ticket_offset, ticket_len;
+	u32 kvno, enctype;
+	int ret;
+
+	struct {
+		__be32 kvno;
+		__be32 enctype;
+		__be32 token_len;
+	} container;
+
+	/* Decode the RXGK_TokenContainer object.  This tells us which server
+	 * key we should be using.  We can then fetch the key, get the secret
+	 * and set up the crypto to extract the token.
+	 */
+	if (skb_copy_bits(skb, token_offset, &container, sizeof(container)) < 0)
+		goto short_packet;
+
+	kvno		= ntohl(container.kvno);
+	enctype		= ntohl(container.enctype);
+	ticket_len	= ntohl(container.token_len);
+	ticket_offset	= token_offset + sizeof(container);
+
+	if (xdr_round_up(ticket_len) > token_len - 3 * 4)
+		goto short_packet;
+
+	_debug("KVNO %u", kvno);
+	_debug("ENC  %u", enctype);
+	_debug("TLEN %u", ticket_len);
+
+	server_key = rxrpc_look_up_server_security(conn, skb, kvno, enctype);
+	if (IS_ERR(server_key))
+		goto cant_get_server_key;
+
+	down_read(&server_key->sem);
+	server_secret = (const void *)&server_key->payload.data[2];
+	ret = rxgk_set_up_token_cipher(server_secret, &token_enc, enctype, &krb5, GFP_NOFS);
+	up_read(&server_key->sem);
+	key_put(server_key);
+	if (ret < 0)
+		goto cant_get_token;
+
+	/* We can now decrypt and parse the token/ticket.  This allows us to
+	 * gain access to K0, from which we can derive the transport key and
+	 * thence decode the authenticator.
+	 */
+	*_eproto = tracepoint_string("rxgk_rsp_dec_tkt");
+	ret = rxgk_decrypt_skb(krb5, &token_enc, skb,
+			       &ticket_offset, &ticket_len, _abort_code);
+	if (ret < 0)
+		return ret;
+
+	ret = conn->security->default_decode_ticket(skb, ticket_offset, ticket_len,
+						    _abort_code, _key);
+	if (ret < 0)
+		goto cant_get_token;
+
+	_leave(" = 0");
+	return ret;
+
+short_packet:
+	*_eproto = tracepoint_string("rxgk_rsp_short");
+	*_abort_code = RXGK_PACKETSHORT;
+	return -EPROTO;
+
+cant_get_server_key:
+	ret = PTR_ERR(server_key);
+	switch (ret) {
+	case -ENOMEM:
+		goto temporary_error;
+	case -ENOKEY:
+	case -EKEYREJECTED:
+	case -EKEYEXPIRED:
+	case -EKEYREVOKED:
+	case -EPERM:
+		*_eproto = tracepoint_string("rxgk_rsp_nokey");
+		*_abort_code = RXGK_BADKEYNO;
+		return -EKEYREJECTED;
+	default:
+		*_eproto = tracepoint_string("rxgk_rsp_keyerr");
+		*_abort_code = RXGK_NOTAUTH;
+		return -EKEYREJECTED;
+	}
+
+cant_get_token:
+	switch (ret) {
+	case -ENOMEM:
+		goto temporary_error;
+	case -EINVAL:
+		*_eproto = tracepoint_string("rxgk_rsp_internal_error");
+		*_abort_code = RXGK_NOTAUTH;
+		return -EKEYREJECTED;
+	case -ENOPKG:
+		*_eproto = tracepoint_string("rxgk_rsp_nopkg");
+		*_abort_code = RXGK_BADETYPE;
+		return -EKEYREJECTED;
+	}
+
+temporary_error:
+	/* Ignore the response packet if we got a temporary error such as
+	 * ENOMEM.  We just want to send the challenge again.  Note that we
+	 * also come out this way if the ticket decryption fails.
+	 */
+	return ret;
+}
diff --git a/net/rxrpc/rxgk_common.h b/net/rxrpc/rxgk_common.h
index 3047ad531877..38473b13e67d 100644
--- a/net/rxrpc/rxgk_common.h
+++ b/net/rxrpc/rxgk_common.h
@@ -33,6 +33,17 @@ struct rxgk_context {
 	struct krb5_enc_keys	resp_enc;	/* Response packet enc key */
 };
 
+#define xdr_round_up(x) (round_up((x), sizeof(__be32)))
+
+/*
+ * rxgk_app.c
+ */
+int rxgk_yfs_decode_ticket(struct sk_buff *, unsigned int, unsigned int,
+			   u32 *, struct key **);
+int rxgk_extract_token(struct rxrpc_connection *,
+		       struct sk_buff *, unsigned int, unsigned int,
+		       struct key **, u32 *, const char **);
+
 /*
  * rxgk_kdf.c
  */
@@ -42,3 +53,110 @@ int rxgk_set_up_token_cipher(const struct krb5_buffer *, struct krb5_enc_keys *,
 			     unsigned int, const struct krb5_enctype **,
 			     gfp_t);
 void rxgk_put(struct rxgk_context *);
+
+/*
+ * Apply encryption and checksumming functions to part of an skbuff.
+ */
+static inline
+int rxgk_encrypt_skb(const struct krb5_enctype *krb5,
+		     struct krb5_enc_keys *keys,
+		     struct sk_buff *skb,
+		     u16 secure_offset, u16 secure_len,
+		     u16 data_offset, u16 data_len,
+		     bool preconfounded)
+{
+	struct scatterlist sg[16];
+	int nr_sg;
+
+	sg_init_table(sg, ARRAY_SIZE(sg));
+	nr_sg = skb_to_sgvec(skb, sg, secure_offset, secure_len);
+	if (unlikely(nr_sg < 0))
+		return nr_sg;
+
+	data_offset -= secure_offset;
+	return crypto_krb5_encrypt(krb5, keys, sg, nr_sg, secure_len,
+				   data_offset, data_len, preconfounded);
+}
+
+/*
+ * Apply decryption and checksumming functions to part of an skbuff.  The
+ * offset and length are updated to reflect the actual content of the encrypted
+ * region.
+ */
+static inline
+int rxgk_decrypt_skb(const struct krb5_enctype *krb5,
+		     struct krb5_enc_keys *keys,
+		     struct sk_buff *skb,
+		     unsigned int *_offset, unsigned int *_len,
+		     int *_error_code)
+{
+	struct scatterlist sg[16];
+	size_t offset = 0, len = *_len;
+	int nr_sg, ret;
+
+	sg_init_table(sg, ARRAY_SIZE(sg));
+	nr_sg = skb_to_sgvec(skb, sg, *_offset, len);
+	if (unlikely(nr_sg < 0))
+		return nr_sg;
+
+	ret = crypto_krb5_decrypt(krb5, keys, sg, nr_sg,
+				  &offset, &len, _error_code);
+
+	*_offset += offset;
+	*_len = len;
+	return ret;
+}
+
+/*
+ * Generate a checksum over some metadata and part of an skbuff and insert the
+ * MIC into the skbuff immediately prior to the data.
+ */
+static inline
+int rxgk_get_mic_skb(const struct krb5_enctype *krb5,
+		     struct crypto_shash *shash,
+		     const struct krb5_buffer *metadata,
+		     struct sk_buff *skb,
+		     u16 secure_offset, u16 secure_len,
+		     u16 data_offset, u16 data_len)
+{
+	struct scatterlist sg[16];
+	int nr_sg;
+
+	sg_init_table(sg, ARRAY_SIZE(sg));
+	nr_sg = skb_to_sgvec(skb, sg, secure_offset, secure_len);
+	if (unlikely(nr_sg < 0))
+		return nr_sg;
+
+	data_offset -= secure_offset;
+	return crypto_krb5_get_mic(krb5, shash, metadata, sg, nr_sg, secure_len,
+				   data_offset, data_len);
+}
+
+/*
+ * Check the MIC on a region of an skbuff.  The offset and length are updated
+ * to reflect the actual content of the secure region.
+ */
+static inline
+int rxgk_verify_mic_skb(const struct krb5_enctype *krb5,
+			struct crypto_shash *shash,
+			const struct krb5_buffer *metadata,
+			struct sk_buff *skb,
+			unsigned int *_offset, unsigned int *_len,
+			u32 *_error_code)
+{
+	struct scatterlist sg[16];
+	size_t offset = 0, len = *_len;
+	int nr_sg, ret;
+
+	sg_init_table(sg, ARRAY_SIZE(sg));
+	nr_sg = skb_to_sgvec(skb, sg, *_offset, len);
+	if (unlikely(nr_sg < 0))
+		return nr_sg;
+
+	ret = crypto_krb5_verify_mic(krb5, shash, metadata, sg, nr_sg,
+				     &offset, &len, _error_code);
+
+	*_offset += offset;
+	*_len = len;
+	return 0;
+}
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index 50cb5f1ee0c0..278a510b2956 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -20,6 +20,9 @@ static const struct rxrpc_security *rxrpc_security_types[] = {
 #ifdef CONFIG_RXKAD
 	[RXRPC_SECURITY_RXKAD]	= &rxkad,
 #endif
+#ifdef CONFIG_RXGK
+	[RXRPC_SECURITY_YFS_RXGK] = &rxgk_yfs,
+#endif
 };
 
 int __init rxrpc_init_security(void)


