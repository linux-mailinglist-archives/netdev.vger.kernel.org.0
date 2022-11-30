Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985A263DB24
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiK3Q4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiK3Qzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:55:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D7F8BD13
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tZhNZFams/h1M5Oz8q+H1JnK8KioZ8hbpqzvIEfUKEk=;
        b=VymbBCrrvu2Bb1FfomSr151aPViHPeg9Znid1v4+NueI0UHlAIH19L8ZZCnTQdXMq58oZw
        OT4RPIzGE9WCOCMeACGL27kIntP7gLAaSuSm+6i29wZ1Klzcgv7UwEujsmEgw7a5qI1i7V
        w5KzXu5HLbGj8lp5aCREgzcHzP2RhSQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-7T1dIkhGMpCDCP97tHXzpA-1; Wed, 30 Nov 2022 11:54:39 -0500
X-MC-Unique: 7T1dIkhGMpCDCP97tHXzpA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5790B29DD99C;
        Wed, 30 Nov 2022 16:54:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39EAA14152E8;
        Wed, 30 Nov 2022 16:54:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 02/35] rxrpc: Fix call leak
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:54:34 +0000
Message-ID: <166982727463.621383.1222840539683065766.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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


