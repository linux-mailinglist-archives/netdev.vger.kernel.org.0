Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A31F63DB53
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiK3RAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiK3RAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:00:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA8B10FDA
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5PNaYT+Sz99XRNBjyLDOgrtAK/xBqCVeZx4CGkNAneI=;
        b=SSlacf02F53wBNabWkQ+BQ/Mb1Wxu56TPaQc02SBUp8L1ph3DpAf7mM04TzBuVVh9tIkMa
        z3kgHvWEvGNcIYzXwDlo2nSYI0yJJO/TNGLWehSv0JjvYRE5KW7TxsTaC+A6JPG87PrCEs
        hRHQLUHqN7hXCG71o4U6MsGKt1spABw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-mVBMQwUBP2i2fCO7O-6Gew-1; Wed, 30 Nov 2022 11:57:32 -0500
X-MC-Unique: mVBMQwUBP2i2fCO7O-6Gew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98F9B3C11040;
        Wed, 30 Nov 2022 16:57:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F327A2166B26;
        Wed, 30 Nov 2022 16:57:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 22/35] rxrpc: Don't use sk->sk_receive_queue.lock to
 guard socket state changes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:57:28 +0000
Message-ID: <166982744839.621383.17007015557156214209.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
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

Don't use sk->sk_receive_queue.lock to guard socket state changes as the
socket mutex is sufficient.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/af_rxrpc.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 7a0dc01741e7..8ad4d85acb0b 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -812,14 +812,12 @@ static int rxrpc_shutdown(struct socket *sock, int flags)
 
 	lock_sock(sk);
 
-	spin_lock_bh(&sk->sk_receive_queue.lock);
 	if (sk->sk_state < RXRPC_CLOSE) {
 		sk->sk_state = RXRPC_CLOSE;
 		sk->sk_shutdown = SHUTDOWN_MASK;
 	} else {
 		ret = -ESHUTDOWN;
 	}
-	spin_unlock_bh(&sk->sk_receive_queue.lock);
 
 	rxrpc_discard_prealloc(rx);
 
@@ -872,9 +870,7 @@ static int rxrpc_release_sock(struct sock *sk)
 		break;
 	}
 
-	spin_lock_bh(&sk->sk_receive_queue.lock);
 	sk->sk_state = RXRPC_CLOSE;
-	spin_unlock_bh(&sk->sk_receive_queue.lock);
 
 	if (rx->local && rcu_access_pointer(rx->local->service) == rx) {
 		write_lock(&rx->local->services_lock);


