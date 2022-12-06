Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AE164489A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbiLFQBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbiLFQBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:01:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53416248C0
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nm99J5fBRF83ahpphn7gkgsZrt+3d7S4X1otUXEJDXM=;
        b=hnrujo9x/B+y/A4oy+EIn3Y8hhhCllxUC/rPR1ixMimHnh59HhfUn1OT1vvyNvFFgzB+OU
        X6kGHoAbC4h5EZPS9aI13Si2vX1quSYSCLDgIGtVoKYo+Yq8VYkh0GNY6liIOVJJ9Lp9EG
        Ew84akpi1GSjuPMMFmXaKndDSytE7pQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-tXxJFZEWN2KDq9frugKPYA-1; Tue, 06 Dec 2022 11:00:29 -0500
X-MC-Unique: tXxJFZEWN2KDq9frugKPYA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D581B3810D3D;
        Tue,  6 Dec 2022 16:00:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B8272166B26;
        Tue,  6 Dec 2022 16:00:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 13/32] rxrpc: Don't lock call->tx_lock to access
 call->tx_buffer
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:00:25 +0000
Message-ID: <167034242563.1105287.10561421349650229204.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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

 net/rxrpc/txbuf.c |   12 ++----------
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


