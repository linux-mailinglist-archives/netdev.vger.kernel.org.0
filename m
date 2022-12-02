Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C5963FCAF
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbiLBARF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbiLBAQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:16:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02404CEFA3
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnHFfz7r7prpFSiz+JpSCCTL+bVoik9Funx4d+jmueA=;
        b=VliNBMfBXH9B5nCBQ+8f+vQ/8Z5Whcx9oPtPJ6PcNvjUzyTa+eJKdPNYg4FQz/9On59MQw
        fzccv/Uo0URIiaJKPmZBFWJ2gppaCJkct3SSCJqj6qqrj9HdiV7QrdxQvn0995g1pSbPCT
        9L1WHQcxEfOqbSZOjDiy/GGKS/ZPSWI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-H-s64rtzP8G0OJF8lnjYFw-1; Thu, 01 Dec 2022 19:15:47 -0500
X-MC-Unique: H-s64rtzP8G0OJF8lnjYFw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE086101A52A;
        Fri,  2 Dec 2022 00:15:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3161A492B11;
        Fri,  2 Dec 2022 00:15:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 05/36] rxrpc: Remove handling of duplicate packets in
 recvmsg_queue
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:15:43 +0000
Message-ID: <166994014360.1732290.8322698250914935431.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should not now see duplicate packets in the recvmsg_queue.  At one
point, jumbo packets that overlapped with already queued data would be
added to the queue and dealt with in recvmsg rather than in the softirq
input code, but now jumbo packets are split/cloned before being processed
by the input code and the subpackets can be discarded individually.

So remove the recvmsg-side code for handling this.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/recvmsg.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index efb85f983657..134122f5961a 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -228,7 +228,6 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 
 	_enter("%d", call->debug_id);
 
-further_rotation:
 	skb = skb_dequeue(&call->recvmsg_queue);
 	rxrpc_see_skb(skb, rxrpc_skb_rotated);
 
@@ -250,17 +249,6 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 		return;
 	}
 
-	/* The next packet on the queue might entirely overlap with the one we
-	 * just consumed; if so, rotate that away also.
-	 */
-	skb = skb_peek(&call->recvmsg_queue);
-	if (skb) {
-		sp = rxrpc_skb(skb);
-		if (sp->hdr.seq != call->rx_consumed &&
-		    after_eq(call->rx_consumed, sp->hdr.seq))
-			goto further_rotation;
-	}
-
 	/* Check to see if there's an ACK that needs sending. */
 	acked = atomic_add_return(call->rx_consumed - old_consumed,
 				  &call->ackr_nr_consumed);
@@ -318,11 +306,6 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 		sp = rxrpc_skb(skb);
 		seq = sp->hdr.seq;
 
-		if (after_eq(call->rx_consumed, seq)) {
-			kdebug("obsolete %x %x", call->rx_consumed, seq);
-			goto skip_obsolete;
-		}
-
 		if (!(flags & MSG_PEEK))
 			trace_rxrpc_receive(call, rxrpc_receive_front,
 					    sp->hdr.serial, seq);
@@ -373,7 +356,6 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 			break;
 		}
 
-	skip_obsolete:
 		/* The whole packet has been transferred. */
 		if (sp->hdr.flags & RXRPC_LAST_PACKET)
 			ret = 1;


