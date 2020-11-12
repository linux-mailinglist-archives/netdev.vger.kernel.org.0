Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC322B05AA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgKLNAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:00:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728264AbgKLNAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:00:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605186047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AenMsUHNek1p9GbSntFVDq8v3nHDim3WZP0WdDpuhRI=;
        b=WJNBx2fNyo5KOX7t74Nu1USJUrgTu4gIaZnIpYFcDu4/94pVaA7Q0MW6DWAxAMtx7I2ByB
        b3S7OkL0VegY5VLZ7mGGa3SQgQo7dkqcrL0XDYz/EdaixEeI9EEI7hnz4pURwjRvaJaOeE
        TfIzqGEB5Om2nt3RZ1Hkw25qH2VW+MU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-jf8QS1iPOoejZOZYgMYiWQ-1; Thu, 12 Nov 2020 08:00:43 -0500
X-MC-Unique: jf8QS1iPOoejZOZYgMYiWQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ADC380A1BE;
        Thu, 12 Nov 2020 13:00:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41EAF5D98F;
        Thu, 12 Nov 2020 13:00:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 17/18] rxrpc: rxgk: Implement connection rekeying
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 13:00:05 +0000
Message-ID: <160518600537.2277919.5458566746685787619.stgit@warthog.procyon.org.uk>
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

Implement rekeying of connections with the RxGK security class.  This
involves regenerating the keys with a different key number as part of the
input data after a certain amount of time or a certain amount of bytes
encrypted.  Rekeying may be triggered by either end.

The LSW of the key number is inserted into the security-specific field in
the RX header, and we try and expand it to 32-bits to make it last longer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    6 ++
 net/rxrpc/conn_object.c |    2 +
 net/rxrpc/rxgk.c        |  156 +++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 157 insertions(+), 7 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index efdb3334ad88..3f2469714422 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -462,11 +462,15 @@ struct rxrpc_connection {
 			u32	nonce;		/* response re-use preventer */
 		} rxkad;
 		struct {
-			struct rxgk_context *keys[1];
+			struct rxgk_context *keys[4]; /* (Re-)keying buffer */
 			u64	start_time;	/* The start time for TK derivation */
 			u8	nonce[20];	/* Response re-use preventer */
+			u32	key_number;	/* Current key number */
 		} rxgk;
 	};
+	rwlock_t		security_lock;	/* Lock allowing modification of security */
+	struct mutex		rekeying_lock;	/* Lock allowing rekeying */
+
 	unsigned long		flags;
 	unsigned long		events;
 	unsigned long		idle_timestamp;	/* Time at which last became idle */
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 8dd1ef25b98f..ff60526d0e0f 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -47,6 +47,8 @@ struct rxrpc_connection *rxrpc_alloc_connection(gfp_t gfp)
 		INIT_LIST_HEAD(&conn->link);
 		skb_queue_head_init(&conn->rx_queue);
 		conn->security = &rxrpc_no_security;
+		rwlock_init(&conn->security_lock);
+		mutex_init(&conn->rekeying_lock);
 		spin_lock_init(&conn->state_lock);
 		conn->debug_id = atomic_inc_return(&rxrpc_debug_id);
 		conn->size_align = 4;
diff --git a/net/rxrpc/rxgk.c b/net/rxrpc/rxgk.c
index 703e46e8b508..0aa6da93b8d4 100644
--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -90,11 +90,153 @@ static void rxgk_describe_server_key(const struct key *key, struct seq_file *m)
 		seq_printf(m, ": %s", krb5->name);
 }
 
+/*
+ * Handle rekeying the connection when the we see our limits overrun or when
+ * the far side decided to rekey.
+ *
+ * Returns a ref on the context if successful or -ESTALE if the key is out of
+ * date.
+ */
+static struct rxgk_context *rxgk_rekey(struct rxrpc_connection *conn,
+				       const u16 *specific_key_number)
+{
+	struct rxgk_context *gk, *dead = NULL;
+	unsigned int key_number, current_key, mask = ARRAY_SIZE(conn->rxgk.keys) - 1;
+	bool crank = false;
+
+	_enter("%d", specific_key_number ? *specific_key_number : -1);
+
+	mutex_lock(&conn->rekeying_lock);
+
+	current_key = conn->rxgk.key_number;
+	if (!specific_key_number) {
+		key_number = current_key;
+	} else {
+		if (*specific_key_number == (u16)current_key)
+			key_number = current_key;
+		else if (*specific_key_number == (u16)(current_key - 1))
+			key_number = current_key - 1;
+		else if (*specific_key_number == (u16)(current_key + 1))
+			goto crank_window;
+		else
+			goto bad_key;
+	}
+
+	gk = conn->rxgk.keys[key_number & mask];
+	if (!gk)
+		goto generate_key;
+	if (!specific_key_number &&
+	    test_bit(RXGK_TK_NEEDS_REKEY, &gk->flags))
+		goto crank_window;
+
+grab:
+	refcount_inc(&gk->usage);
+	mutex_unlock(&conn->rekeying_lock);
+	rxgk_put(dead);
+	return gk;
+
+crank_window:
+	if (current_key == UINT_MAX)
+		goto bad_key;
+	if (current_key + 1 == UINT_MAX)
+		set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
+
+	key_number = current_key + 1;
+	if (WARN_ON(conn->rxgk.keys[key_number & mask]))
+		goto bad_key;
+	crank = true;
+
+generate_key:
+	gk = conn->rxgk.keys[current_key & mask];
+	gk = rxgk_generate_transport_key(conn, gk->key, key_number, GFP_NOFS);
+	if (IS_ERR(gk)) {
+		mutex_unlock(&conn->rekeying_lock);
+		return gk;
+	}
+
+	write_lock(&conn->security_lock);
+	if (crank) {
+		current_key++;
+		conn->rxgk.key_number = current_key;
+		dead = conn->rxgk.keys[(current_key - 2) & mask];
+		conn->rxgk.keys[(current_key - 2) & mask] = NULL;
+	}
+	conn->rxgk.keys[current_key & mask] = gk;
+	write_unlock(&conn->security_lock);
+	goto grab;
+
+bad_key:
+	mutex_unlock(&conn->rekeying_lock);
+	return ERR_PTR(-ESTALE);
+}
+
+/*
+ * Get the specified keying context.
+ *
+ * Returns a ref on the context if successful or -ESTALE if the key is out of
+ * date.
+ */
 static struct rxgk_context *rxgk_get_key(struct rxrpc_connection *conn,
-					 u16 *specific_key_number)
+					 const u16 *specific_key_number)
 {
-	refcount_inc(&conn->rxgk.keys[0]->usage);
-	return conn->rxgk.keys[0];
+	struct rxgk_context *gk;
+	unsigned int key_number, current_key, mask = ARRAY_SIZE(conn->rxgk.keys) - 1;
+
+	_enter("{%u},%d",
+	       conn->rxgk.key_number, specific_key_number ? *specific_key_number : -1);
+
+	read_lock(&conn->security_lock);
+
+	current_key = conn->rxgk.key_number;
+	if (!specific_key_number) {
+		key_number = current_key;
+	} else {
+		/* Only the bottom 16 bits of the key number are exposed in the
+		 * header, so we try and keep the upper 16 bits in step.  The
+		 * whole 32 bits are used to generate the TK.
+		 */
+		if (*specific_key_number == (u16)current_key)
+			key_number = current_key;
+		else if (*specific_key_number == (u16)(current_key - 1))
+			key_number = current_key - 1;
+		else if (*specific_key_number == (u16)(current_key + 1))
+			goto rekey;
+		else
+			goto bad_key;
+	}
+
+	gk = conn->rxgk.keys[key_number & mask];
+	if (!gk)
+		goto slow_path;
+	if (!specific_key_number &&
+	    key_number < UINT_MAX) {
+		if (time_after(jiffies, gk->expiry) ||
+		    gk->bytes_remaining < 0) {
+			set_bit(RXGK_TK_NEEDS_REKEY, &gk->flags);
+			goto slow_path;
+		}
+
+		if (test_bit(RXGK_TK_NEEDS_REKEY, &gk->flags))
+			goto slow_path;
+	}
+
+	refcount_inc(&gk->usage);
+	read_unlock(&conn->security_lock);
+	return gk;
+
+rekey:
+	_debug("rekey");
+	if (current_key == UINT_MAX)
+		goto bad_key;
+	gk = conn->rxgk.keys[current_key & mask];
+	if (gk)
+		set_bit(RXGK_TK_NEEDS_REKEY, &gk->flags);
+slow_path:
+	read_unlock(&conn->security_lock);
+	return rxgk_rekey(conn, specific_key_number);
+bad_key:
+	read_unlock(&conn->security_lock);
+	return ERR_PTR(-ESTALE);
 }
 
 /*
@@ -106,7 +248,8 @@ static int rxgk_init_connection_security(struct rxrpc_connection *conn,
 	struct rxgk_context *gk;
 	int ret;
 
-	_enter("{%d},{%x}", conn->debug_id, key_serial(conn->params.key));
+	_enter("{%d,%u},{%x}",
+	       conn->debug_id, conn->rxgk.key_number, key_serial(conn->params.key));
 
 	conn->security_ix = token->security_index;
 	conn->params.security_level = token->rxgk->level;
@@ -116,10 +259,11 @@ static int rxgk_init_connection_security(struct rxrpc_connection *conn,
 		do_div(conn->rxgk.start_time, 100);
 	}
 
-	gk = rxgk_generate_transport_key(conn, token->rxgk, 0, GFP_NOFS);
+	gk = rxgk_generate_transport_key(conn, token->rxgk, conn->rxgk.key_number,
+					 GFP_NOFS);
 	if (IS_ERR(gk))
 		return PTR_ERR(gk);
-	conn->rxgk.keys[0] = gk;
+	conn->rxgk.keys[gk->key_number & 3] = gk;
 
 	switch (conn->params.security_level) {
 	case RXRPC_SECURITY_PLAIN:


