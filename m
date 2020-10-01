Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B31280200
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732931AbgJAO7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:59:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38365 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732650AbgJAO7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MMVEnt4xxQNZzSubeQ4H0pBS/Rnmlnby+Kv3/jhsz+0=;
        b=af2H84AEgZIIWNAu4vKlSth0mKsutEJ7e6wJQlfVK1GSgJLfIC2o7qtfXkM8YQcLWBf0EB
        6g33+4il1I/x+/1vtZO7Te7Xgrfq4ZllL766n1dXBeBGO6b/av+PNLDofe1tilOO6Kk9qK
        1XbB0HGjzrLzxa6LPdCW+7+VaGktTbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-BM6Iyj18Nk-k-3ngvUK_TQ-1; Thu, 01 Oct 2020 10:59:26 -0400
X-MC-Unique: BM6Iyj18Nk-k-3ngvUK_TQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B18EAAEB59;
        Thu,  1 Oct 2020 14:59:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8BB473696;
        Thu,  1 Oct 2020 14:59:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 23/23] rxrpc: rxkad: Don't use pskb_pull() to advance
 through the response packet
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:59:24 +0100
Message-ID: <160156436403.1728886.6524119306801766435.stgit@warthog.procyon.org.uk>
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

In the rxkad security class, don't use pskb_pull() to advance through the
contents of the response packet.  There's no point, especially as the next
and last access to the skbuff still has to allow for the wire header in the
offset (which we didn't advance over).

Better to just add the displacement to the next offset.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/rxkad.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index f3182edfcbae..e5b4bbdd0f34 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -1162,8 +1162,6 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
 			  response, sizeof(*response)) < 0)
 		goto protocol_error;
-	if (!pskb_pull(skb, sizeof(*response)))
-		BUG();
 
 	version = ntohl(response->version);
 	ticket_len = ntohl(response->ticket_len);
@@ -1194,7 +1192,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 
 	eproto = tracepoint_string("rxkad_tkt_short");
 	abort_code = RXKADPACKETSHORT;
-	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
+	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header) + sizeof(*response),
 			  ticket, ticket_len) < 0)
 		goto protocol_error_free;
 


