Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F5164DE77
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiLOQVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiLOQVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:21:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE1236D40
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 08:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671121235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0OFFCx+Ud/PJ6j1vAHUL6aiu41cAP1H16FBjALOEB94=;
        b=KqL+yN4cogQ+ZJiBKTft/P7Q0mKEjvFpwmerE7bcHvUpuHUwUsG8xFMCLIu9EkZKgmeoV5
        JcqUaTMZ1C3RU2V2I+AkzNqyQaxygWiNDwNCFNHLFqZ7I8Rgwxza0VynJQSqSo3iIVOdjf
        5AFdsWyhdSlTdjziLQmGdLfbvUHNaOQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-7WlTZoq6Nf2OD85ToF7TzQ-1; Thu, 15 Dec 2022 11:20:33 -0500
X-MC-Unique: 7WlTZoq6Nf2OD85ToF7TzQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E2C318A6474;
        Thu, 15 Dec 2022 16:20:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AADAB2166B26;
        Thu, 15 Dec 2022 16:20:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 6/9] rxrpc: Fix switched parameters in peer tracing
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 15 Dec 2022 16:20:30 +0000
Message-ID: <167112123012.152641.2352534564614232538.stgit@warthog.procyon.org.uk>
In-Reply-To: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
References: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
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

Fix the switched parameters on rxrpc_alloc_peer() and rxrpc_get_peer().
The ref argument and the why argument got mixed.

Fixes: 47c810a79844 ("rxrpc: trace: Don't use __builtin_return_address for rxrpc_peer tracing")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    2 +-
 net/rxrpc/peer_object.c      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 049b52e7aa6a..c6cfed00d0c6 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -471,7 +471,7 @@ TRACE_EVENT(rxrpc_peer,
 	    TP_STRUCT__entry(
 		    __field(unsigned int,	peer		)
 		    __field(int,		ref		)
-		    __field(int,		why		)
+		    __field(enum rxrpc_peer_trace, why		)
 			     ),
 
 	    TP_fast_assign(
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 82de295393a0..4eecea2be307 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -226,7 +226,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp,
 		rxrpc_peer_init_rtt(peer);
 
 		peer->cong_ssthresh = RXRPC_TX_MAX_WINDOW;
-		trace_rxrpc_peer(peer->debug_id, why, 1);
+		trace_rxrpc_peer(peer->debug_id, 1, why);
 	}
 
 	_leave(" = %p", peer);
@@ -382,7 +382,7 @@ struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *peer, enum rxrpc_peer_trace
 	int r;
 
 	__refcount_inc(&peer->ref, &r);
-	trace_rxrpc_peer(peer->debug_id, why, r + 1);
+	trace_rxrpc_peer(peer->debug_id, r + 1, why);
 	return peer;
 }
 


