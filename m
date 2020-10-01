Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DB22801EF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732789AbgJAO6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:58:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50575 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732346AbgJAO6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:58:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A1L+CLDgahX1dLa83/139k7hBVfIPF9BtuC1pCAcBA0=;
        b=FTUNf8mTeJfcR7wUZHHzOe+F7HwcY50//NPdin80k6YzPQKLw7JwG5oaTo3Lz/Q+F9+Pnw
        HqlN7noCrHPH4joJORUNZwg2RuCYe/9ZKnlTCXdlAf/KQfp5rUTVMm6Rys3fK9h+IPs7VH
        8yvuaVR1K5yuZ6Shpym5HlGBMgv61o4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-5BLGIh_2MXWTLfjB60eQIQ-1; Thu, 01 Oct 2020 10:58:09 -0400
X-MC-Unique: 5BLGIh_2MXWTLfjB60eQIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05D1D801AB3;
        Thu,  1 Oct 2020 14:58:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D2F655767;
        Thu,  1 Oct 2020 14:58:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 12/23] rxrpc: Allow for a security trailer in a
 packet
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:58:06 +0100
Message-ID: <160156428634.1728886.8717790947771496289.stgit@warthog.procyon.org.uk>
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

Allow for a security trailer to added to a packet.  The size is stored in
conn->security_trailer.  Note any size alignment set by the security class
must be applied after subtracting the trailer (but the alignment includes
the security header, which is assumed to be encrypted).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/sendmsg.c     |   28 ++++++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index dce48162f6c2..5aacd6d7cf28 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -455,6 +455,7 @@ struct rxrpc_connection {
 	u32			service_id;	/* Service ID, possibly upgraded */
 	u8			size_align;	/* data size alignment (for security) */
 	u8			security_size;	/* security header size */
+	u8			security_trailer; /* Security trailer size */
 	u8			security_ix;	/* security type */
 	u8			out_clientflag;	/* RXRPC_CLIENT_INITIATED if we are client */
 	u8			bundle_shift;	/* Index into bundle->avail_chans */
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index d27140c836cc..258224bb1227 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -327,7 +327,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			rxrpc_send_ack_packet(call, false, NULL);
 
 		if (!skb) {
-			size_t size, chunk, max, space;
+			size_t size, chunk, limit, space, shdr;
 
 			_debug("alloc");
 
@@ -342,18 +342,22 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 					goto maybe_error;
 			}
 
-			max = RXRPC_JUMBO_DATALEN;
-			max -= call->conn->security_size;
-			max &= ~(call->conn->size_align - 1UL);
-
-			chunk = max;
-			if (chunk > msg_data_left(msg) && !more)
+			/* Work out the maximum size of a packet.  Assume that
+			 * the security header is going to be in the padded
+			 * region (enc blocksize), but the trailer is not.
+			 */
+			shdr = call->conn->security_size;
+			limit = RXRPC_JUMBO_DATALEN;
+			limit -= call->conn->security_trailer;
+			space = round_down(limit, call->conn->size_align);
+
+			chunk = space - shdr;
+			if (msg_data_left(msg) < chunk && !more) {
 				chunk = msg_data_left(msg);
+				space = round_up(shdr + chunk, call->conn->size_align);
+			}
 
-			space = chunk + call->conn->size_align;
-			space &= ~(call->conn->size_align - 1UL);
-
-			size = space + call->conn->security_size;
+			size = space + call->conn->security_trailer;
 
 			_debug("SIZE: %zu/%zu/%zu", chunk, space, size);
 
@@ -425,7 +429,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			size_t pad;
 
 			/* pad out if we're using security */
-			if (conn->security_ix) {
+			if (conn->size_align > 0) {
 				pad = conn->security_size + skb->mark;
 				pad = conn->size_align - pad;
 				pad &= conn->size_align - 1;


