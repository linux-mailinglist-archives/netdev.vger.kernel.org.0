Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5CBB635A04
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbiKWKcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbiKWKcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:32:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCFF11179
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5PNaYT+Sz99XRNBjyLDOgrtAK/xBqCVeZx4CGkNAneI=;
        b=Woftb85a3uaokMDR3wu14cvGCHFjC9ldwIAe9novUSdihspCGPKdwCwtRNvuJf83eTfwdu
        OQziNNq3/6CkpCnd/f9Onjo3/ndQaNirvlJV9PhbeFczaSsdoHOGPfjZoMdQZJ2+GQ7Tbf
        9X0TvTN8EsQsaMKZ94AfSQcuNHmzrY0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-0Aze-MpiMEK7za2QBPEdYQ-1; Wed, 23 Nov 2022 05:15:16 -0500
X-MC-Unique: 0Aze-MpiMEK7za2QBPEdYQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84A9F811E84;
        Wed, 23 Nov 2022 10:15:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0BA12024CBE;
        Wed, 23 Nov 2022 10:15:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 06/17] rxrpc: Don't use sk->sk_receive_queue.lock to
 guard socket state changes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:15:13 +0000
Message-ID: <166919851334.1258552.5693472286628426234.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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


