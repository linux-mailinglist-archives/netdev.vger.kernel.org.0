Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5391FECE0
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 09:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgFRHuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 03:50:35 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36538 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728244AbgFRHue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 03:50:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592466633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JBBnzSTgV07Inj6t/+ejJpVqvLXQbxzitIbVvtHPvpE=;
        b=Mm+o7MtNnTfyDeMb9QWZHVxEcjLrlGRSmTodjo52jeX3ACv9/gSyCTCqavYZK3ZxGoDLoB
        SuloPe2gPsgxv6zFsdxvwGVhTz4zpoSRLulupNAyVXa/JsQ70NPHq3RDDTrC2gFwsUPERf
        aRK2p4p+y1Hfzf1LIqa/8lGMaR8+H0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-pxvtYJBTM5GudaUUSuZR_A-1; Thu, 18 Jun 2020 03:50:31 -0400
X-MC-Unique: pxvtYJBTM5GudaUUSuZR_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63381835B43;
        Thu, 18 Jun 2020 07:50:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A152819945;
        Thu, 18 Jun 2020 07:50:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 2/3] rxrpc: Fix handling of rwind from an ACK packet
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 18 Jun 2020 08:50:28 +0100
Message-ID: <159246662887.1229328.9298909880359151026.stgit@warthog.procyon.org.uk>
In-Reply-To: <159246661514.1229328.4419873299996950969.stgit@warthog.procyon.org.uk>
References: <159246661514.1229328.4419873299996950969.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The handling of the receive window size (rwind) from a received ACK packet
is not correct.  The rxrpc_input_ackinfo() function currently checks the
current Tx window size against the rwind from the ACK to see if it has
changed, but then limits the rwind size before storing it in the tx_winsize
member and, if it increased, wake up the transmitting process.  This means
that if rwind > RXRPC_RXTX_BUFF_SIZE - 1, this path will always be
followed.

Fix this by limiting rwind before we compare it to tx_winsize.

The effect of this can be seen by enabling the rxrpc_rx_rwind_change
tracepoint.

Fixes: 702f2ac87a9a ("rxrpc: Wake up the transmitter if Rx window size increases on the peer")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/input.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 299ac98e9754..767579328a06 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -722,13 +722,12 @@ static void rxrpc_input_ackinfo(struct rxrpc_call *call, struct sk_buff *skb,
 	       ntohl(ackinfo->rxMTU), ntohl(ackinfo->maxMTU),
 	       rwind, ntohl(ackinfo->jumbo_max));
 
+	if (rwind > RXRPC_RXTX_BUFF_SIZE - 1)
+		rwind = RXRPC_RXTX_BUFF_SIZE - 1;
 	if (call->tx_winsize != rwind) {
-		if (rwind > RXRPC_RXTX_BUFF_SIZE - 1)
-			rwind = RXRPC_RXTX_BUFF_SIZE - 1;
 		if (rwind > call->tx_winsize)
 			wake = true;
-		trace_rxrpc_rx_rwind_change(call, sp->hdr.serial,
-					    ntohl(ackinfo->rwind), wake);
+		trace_rxrpc_rx_rwind_change(call, sp->hdr.serial, rwind, wake);
 		call->tx_winsize = rwind;
 	}
 


