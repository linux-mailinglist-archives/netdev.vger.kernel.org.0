Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1ACA63FCAA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiLBAQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiLBAQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:16:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33659CEFBE
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tZhNZFams/h1M5Oz8q+H1JnK8KioZ8hbpqzvIEfUKEk=;
        b=a+XClS6ZEofb1dKCmt7ob5BAc2dp9m+I5+H13lA9noiuqS3cZSsDCqX0KXpmjaw6rYaSkw
        NxOdSCaj3HwrK8QUAxleQlvD9voldCmmv5A4D/cHvbYt6aQBW2JqT1WzLIkpqw4mflFCJ2
        q1eOjR/ypsitM+Ml6KDswu+M4d93a00=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-G3tJkehqN8GMnd8j2h221Q-1; Thu, 01 Dec 2022 19:15:30 -0500
X-MC-Unique: G3tJkehqN8GMnd8j2h221Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5641833A06;
        Fri,  2 Dec 2022 00:15:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E2FB40C94AA;
        Fri,  2 Dec 2022 00:15:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 03/36] rxrpc: Fix call leak
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:15:28 +0000
Message-ID: <166994012846.1732290.4843407933665625105.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When retransmitting a packet, rxrpc_resend() shouldn't be attaching a ref
to the call to the txbuf as that pins the call and prevents the call from
clearing the packet buffer.

Signed-off-by: David Howells <dhowells@redhat.com>
Fixes: d57a3a151660 ("rxrpc: Save last ACK's SACK table rather than marking txbufs")
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/call_event.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 1e21a708390e..349f3df569ba 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -198,7 +198,6 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 
 			if (list_empty(&txb->tx_link)) {
 				rxrpc_get_txbuf(txb, rxrpc_txbuf_get_retrans);
-				rxrpc_get_call(call, rxrpc_call_got_tx);
 				list_add_tail(&txb->tx_link, &retrans_queue);
 				set_bit(RXRPC_TXBUF_RESENT, &txb->flags);
 			}


