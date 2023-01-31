Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A0B68337C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjAaROM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjAaROA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:14:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F3240D6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bF6yHBQW4tFwNLDv4jMN9Y5XX+hHW8AgUnVl4ZHhd9E=;
        b=R8TWFYJ2Frfmd/xqfvsK9D7D867oUwXaUzhwjx3RD0Qu3tm9P5FN7eXTqzZSRhdlYRHXqu
        hRc8R6u/BP8jvqVNFPMU03Dpj1ZVRd3lbEWsPL1q3f1S0koKRDsHuV24XNugkkfIJ8WUBC
        WF595lPt88D5+yNSF1IfA6DtwkgI6XY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-_rBey_VKPW68yRV6zxVTVQ-1; Tue, 31 Jan 2023 12:12:51 -0500
X-MC-Unique: _rBey_VKPW68yRV6zxVTVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32AED85CCE9;
        Tue, 31 Jan 2023 17:12:48 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13B2D1121330;
        Tue, 31 Jan 2023 17:12:45 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/13] rxrpc: Don't lock call->tx_lock to access call->tx_buffer
Date:   Tue, 31 Jan 2023 17:12:23 +0000
Message-Id: <20230131171227.3912130-10-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

call->tx_buffer is now only accessed within the I/O thread (->tx_sendmsg is
the way sendmsg passes packets to the I/O thread) so there's no need to
lock around it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 net/rxrpc/txbuf.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
index d2cf2aac3adb..d43be8512386 100644
--- a/net/rxrpc/txbuf.c
+++ b/net/rxrpc/txbuf.c
@@ -110,12 +110,8 @@ void rxrpc_shrink_call_tx_buffer(struct rxrpc_call *call)
 
 	_enter("%x/%x/%x", call->tx_bottom, call->acks_hard_ack, call->tx_top);
 
-	for (;;) {
-		spin_lock(&call->tx_lock);
-		txb = list_first_entry_or_null(&call->tx_buffer,
-					       struct rxrpc_txbuf, call_link);
-		if (!txb)
-			break;
+	while ((txb = list_first_entry_or_null(&call->tx_buffer,
+					       struct rxrpc_txbuf, call_link))) {
 		hard_ack = smp_load_acquire(&call->acks_hard_ack);
 		if (before(hard_ack, txb->seq))
 			break;
@@ -128,15 +124,11 @@ void rxrpc_shrink_call_tx_buffer(struct rxrpc_call *call)
 
 		trace_rxrpc_txqueue(call, rxrpc_txqueue_dequeue);
 
-		spin_unlock(&call->tx_lock);
-
 		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_rotated);
 		if (after(call->acks_hard_ack, call->tx_bottom + 128))
 			wake = true;
 	}
 
-	spin_unlock(&call->tx_lock);
-
 	if (wake)
 		wake_up(&call->waitq);
 }

