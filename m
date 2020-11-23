Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7692C1631
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733109AbgKWUMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:12:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733020AbgKWUME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606162323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MMVEnt4xxQNZzSubeQ4H0pBS/Rnmlnby+Kv3/jhsz+0=;
        b=fjI19YTeJYvwlPfyXp3f/KsEhVxAxvau7JbnR6IZq6d8Ev9M+2qUSa94wq0qkIr8cdui5z
        ApdTI/EW/k2Jd5gPzjWQaKi0CKoJm1W7t00hopVXF0rYLulCkpe52h/2m/jMiscth2Ad/N
        3iyMevX/8nwLihLK3/JhSFDPu+NKQZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-LQPWOo1DP0GLEWB7-kLetA-1; Mon, 23 Nov 2020 15:11:58 -0500
X-MC-Unique: LQPWOo1DP0GLEWB7-kLetA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1F5880364B;
        Mon, 23 Nov 2020 20:11:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C91085D9CC;
        Mon, 23 Nov 2020 20:11:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 16/17] rxrpc: rxkad: Don't use pskb_pull() to advance
 through the response packet
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 20:11:55 +0000
Message-ID: <160616231598.830164.7732957625125102010.stgit@warthog.procyon.org.uk>
In-Reply-To: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
References: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
 


