Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A431621EFD
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiKHWT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiKHWTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:19:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B2A63CD2
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b0o6AMSNcNXDnrR4liOC7JJgQ9B2BEG3x8yUaLj5l3M=;
        b=IEOd2jeuhi+DUwC5bjBTcg1wBYGCfblKkcC6N8FBIsom/sBqIbBgcFjwuvgChuKudNWnQ7
        PyNTORS1U7jTOhMtSgpUMJExUumnSPMSlD79VsrBSsu5A9nKqovQ72eaqfGZ6KluQxzwNp
        8tLUOm9G4qH9BApOnRVmXPYg5Eokr4Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-uHQhlk_DPMOEQTUah_3gaQ-1; Tue, 08 Nov 2022 17:18:14 -0500
X-MC-Unique: uHQhlk_DPMOEQTUah_3gaQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F0DF101A52A;
        Tue,  8 Nov 2022 22:18:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01F41112132E;
        Tue,  8 Nov 2022 22:18:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 03/26] rxrpc: Split call timer-expiration from call
 timer-set tracepoint
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:18:11 +0000
Message-ID: <166794589129.2389296.4624747993035742861.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Split the tracepoint for call timer-set to separate out the call
timer-expiration event

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   42 +++++++++++++++++++++++++++++++++++++++++-
 net/rxrpc/call_object.c      |    2 +-
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 4c501c660123..a72f04e3d264 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -133,7 +133,6 @@
 
 #define rxrpc_timer_traces \
 	EM(rxrpc_timer_begin,			"Begin ") \
-	EM(rxrpc_timer_expired,			"*EXPR*") \
 	EM(rxrpc_timer_exp_ack,			"ExpAck") \
 	EM(rxrpc_timer_exp_hard,		"ExpHrd") \
 	EM(rxrpc_timer_exp_idle,		"ExpIdl") \
@@ -1019,6 +1018,47 @@ TRACE_EVENT(rxrpc_timer,
 		      __entry->timer - __entry->now)
 	    );
 
+TRACE_EVENT(rxrpc_timer_expired,
+	    TP_PROTO(struct rxrpc_call *call, unsigned long now),
+
+	    TP_ARGS(call, now),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,			call		)
+		    __field(long,				now		)
+		    __field(long,				ack_at		)
+		    __field(long,				ack_lost_at	)
+		    __field(long,				resend_at	)
+		    __field(long,				ping_at		)
+		    __field(long,				expect_rx_by	)
+		    __field(long,				expect_req_by	)
+		    __field(long,				expect_term_by	)
+		    __field(long,				timer		)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->call		= call->debug_id;
+		    __entry->now		= now;
+		    __entry->ack_at		= call->ack_at;
+		    __entry->ack_lost_at	= call->ack_lost_at;
+		    __entry->resend_at		= call->resend_at;
+		    __entry->expect_rx_by	= call->expect_rx_by;
+		    __entry->expect_req_by	= call->expect_req_by;
+		    __entry->expect_term_by	= call->expect_term_by;
+		    __entry->timer		= call->timer.expires;
+			   ),
+
+	    TP_printk("c=%08x EXPIRED a=%ld la=%ld r=%ld xr=%ld xq=%ld xt=%ld t=%ld",
+		      __entry->call,
+		      __entry->ack_at - __entry->now,
+		      __entry->ack_lost_at - __entry->now,
+		      __entry->resend_at - __entry->now,
+		      __entry->expect_rx_by - __entry->now,
+		      __entry->expect_req_by - __entry->now,
+		      __entry->expect_term_by - __entry->now,
+		      __entry->timer - __entry->now)
+	    );
+
 TRACE_EVENT(rxrpc_rx_lose,
 	    TP_PROTO(struct rxrpc_skb_priv *sp),
 
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 6401cdf7a624..a75861a0c477 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -52,7 +52,7 @@ static void rxrpc_call_timer_expired(struct timer_list *t)
 	_enter("%d", call->debug_id);
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
-		trace_rxrpc_timer(call, rxrpc_timer_expired, jiffies);
+		trace_rxrpc_timer_expired(call, jiffies);
 		__rxrpc_queue_call(call);
 	} else {
 		rxrpc_put_call(call, rxrpc_call_put);


