Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421EA6448AF
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbiLFQEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiLFQCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:02:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7C32E9DF
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zh+CUvgeim6a0paY65hFPVdBjOgf/SnX+dj5UVXnCX8=;
        b=YK3VWdZKnu147wKGP4fpBTUIaOcsZE6iwsL3P6DEsrVTVnaGOndDZDbC99+b+CQzEdE5/P
        /rmHKkOsKE01jAeTmUcGsD9eMpL3/4PjhgnLhtJBAEAR8himmqRpVb5WTyVhT5/+fJ0YYb
        hdSaYhmK7imdDmicMG7L9ceeEXLlJw4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-UA5juY0RNz6tHGaN38G1Zg-1; Tue, 06 Dec 2022 11:01:45 -0500
X-MC-Unique: UA5juY0RNz6tHGaN38G1Zg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 652FE3C0F421;
        Tue,  6 Dec 2022 16:01:45 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E1DA40C213F;
        Tue,  6 Dec 2022 16:01:44 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 22/32] rxrpc: Split out the call state changing
 functions into their own file
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:01:41 +0000
Message-ID: <167034250159.1105287.10034224411568767550.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split out the functions that change the state of an rxrpc call into their
own file.  The idea being to remove anything to do with changing the state
of a call directly from the rxrpc sendmsg() and recvmsg() paths and have
all that done in the I/O thread only, with the ultimate aim of removing the
state lock entirely.  Moving the code out of sendmsg.c and recvmsg.c makes
that easier to manage.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/Makefile      |    1 +
 net/rxrpc/ar-internal.h |   16 +++++---
 net/rxrpc/call_state.c  |   92 +++++++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/recvmsg.c     |   84 -------------------------------------------
 4 files changed, 103 insertions(+), 90 deletions(-)
 create mode 100644 net/rxrpc/call_state.c

diff --git a/net/rxrpc/Makefile b/net/rxrpc/Makefile
index e76d3459d78e..ac5caf5a48e1 100644
--- a/net/rxrpc/Makefile
+++ b/net/rxrpc/Makefile
@@ -10,6 +10,7 @@ rxrpc-y := \
 	call_accept.o \
 	call_event.o \
 	call_object.o \
+	call_state.o \
 	conn_client.o \
 	conn_event.o \
 	conn_object.o \
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index c0704a983055..a95e161bd980 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -886,6 +886,16 @@ static inline bool rxrpc_is_client_call(const struct rxrpc_call *call)
 	return !rxrpc_is_service_call(call);
 }
 
+/*
+ * call_state.c
+ */
+bool __rxrpc_set_call_completion(struct rxrpc_call *, enum rxrpc_call_completion, u32, int);
+bool rxrpc_set_call_completion(struct rxrpc_call *, enum rxrpc_call_completion, u32, int);
+bool __rxrpc_call_completed(struct rxrpc_call *);
+bool rxrpc_call_completed(struct rxrpc_call *);
+bool __rxrpc_abort_call(struct rxrpc_call *, rxrpc_seq_t, u32, int, enum rxrpc_abort_reason);
+bool rxrpc_abort_call(struct rxrpc_call *, rxrpc_seq_t, u32, int, enum rxrpc_abort_reason);
+
 /*
  * conn_client.c
  */
@@ -1115,12 +1125,6 @@ extern const struct seq_operations rxrpc_local_seq_ops;
  * recvmsg.c
  */
 void rxrpc_notify_socket(struct rxrpc_call *);
-bool __rxrpc_set_call_completion(struct rxrpc_call *, enum rxrpc_call_completion, u32, int);
-bool rxrpc_set_call_completion(struct rxrpc_call *, enum rxrpc_call_completion, u32, int);
-bool __rxrpc_call_completed(struct rxrpc_call *);
-bool rxrpc_call_completed(struct rxrpc_call *);
-bool __rxrpc_abort_call(struct rxrpc_call *, rxrpc_seq_t, u32, int, enum rxrpc_abort_reason);
-bool rxrpc_abort_call(struct rxrpc_call *, rxrpc_seq_t, u32, int, enum rxrpc_abort_reason);
 int rxrpc_recvmsg(struct socket *, struct msghdr *, size_t, int);
 
 /*
diff --git a/net/rxrpc/call_state.c b/net/rxrpc/call_state.c
new file mode 100644
index 000000000000..24d240773a6f
--- /dev/null
+++ b/net/rxrpc/call_state.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Call state changing functions.
+ *
+ * Copyright (C) 2022 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include "ar-internal.h"
+
+/*
+ * Transition a call to the complete state.
+ */
+bool __rxrpc_set_call_completion(struct rxrpc_call *call,
+				 enum rxrpc_call_completion compl,
+				 u32 abort_code,
+				 int error)
+{
+	if (call->state < RXRPC_CALL_COMPLETE) {
+		call->abort_code = abort_code;
+		call->error = error;
+		call->completion = compl;
+		/* Allow reader of completion state to operate locklessly */
+		smp_store_release(&call->state, RXRPC_CALL_COMPLETE);
+		trace_rxrpc_call_complete(call);
+		wake_up(&call->waitq);
+		rxrpc_notify_socket(call);
+		return true;
+	}
+	return false;
+}
+
+bool rxrpc_set_call_completion(struct rxrpc_call *call,
+			       enum rxrpc_call_completion compl,
+			       u32 abort_code,
+			       int error)
+{
+	bool ret = false;
+
+	if (call->state < RXRPC_CALL_COMPLETE) {
+		spin_lock(&call->state_lock);
+		ret = __rxrpc_set_call_completion(call, compl, abort_code, error);
+		spin_unlock(&call->state_lock);
+	}
+	return ret;
+}
+
+/*
+ * Record that a call successfully completed.
+ */
+bool __rxrpc_call_completed(struct rxrpc_call *call)
+{
+	return __rxrpc_set_call_completion(call, RXRPC_CALL_SUCCEEDED, 0, 0);
+}
+
+bool rxrpc_call_completed(struct rxrpc_call *call)
+{
+	bool ret = false;
+
+	if (call->state < RXRPC_CALL_COMPLETE) {
+		spin_lock(&call->state_lock);
+		ret = __rxrpc_call_completed(call);
+		spin_unlock(&call->state_lock);
+	}
+	return ret;
+}
+
+/*
+ * Record that a call is locally aborted.
+ */
+bool __rxrpc_abort_call(struct rxrpc_call *call, rxrpc_seq_t seq,
+			u32 abort_code, int error,
+			enum rxrpc_abort_reason why)
+{
+	trace_rxrpc_abort(call->debug_id, why, call->cid, call->call_id, seq,
+			  abort_code, error);
+	return __rxrpc_set_call_completion(call, RXRPC_CALL_LOCALLY_ABORTED,
+					   abort_code, error);
+}
+
+bool rxrpc_abort_call(struct rxrpc_call *call, rxrpc_seq_t seq,
+		      u32 abort_code, int error,
+		      enum rxrpc_abort_reason why)
+{
+	bool ret;
+
+	spin_lock(&call->state_lock);
+	ret = __rxrpc_abort_call(call, seq, abort_code, error, why);
+	spin_unlock(&call->state_lock);
+	if (ret)
+		rxrpc_send_abort_packet(call);
+	return ret;
+}
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index b7178f2150c0..c163c103aa1d 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -58,90 +58,6 @@ void rxrpc_notify_socket(struct rxrpc_call *call)
 	_leave("");
 }
 
-/*
- * Transition a call to the complete state.
- */
-bool __rxrpc_set_call_completion(struct rxrpc_call *call,
-				 enum rxrpc_call_completion compl,
-				 u32 abort_code,
-				 int error)
-{
-	if (call->state < RXRPC_CALL_COMPLETE) {
-		call->abort_code = abort_code;
-		call->error = error;
-		call->completion = compl;
-		/* Allow reader of completion state to operate locklessly */
-		smp_store_release(&call->state, RXRPC_CALL_COMPLETE);
-		trace_rxrpc_call_complete(call);
-		wake_up(&call->waitq);
-		rxrpc_notify_socket(call);
-		return true;
-	}
-	return false;
-}
-
-bool rxrpc_set_call_completion(struct rxrpc_call *call,
-			       enum rxrpc_call_completion compl,
-			       u32 abort_code,
-			       int error)
-{
-	bool ret = false;
-
-	if (call->state < RXRPC_CALL_COMPLETE) {
-		spin_lock(&call->state_lock);
-		ret = __rxrpc_set_call_completion(call, compl, abort_code, error);
-		spin_unlock(&call->state_lock);
-	}
-	return ret;
-}
-
-/*
- * Record that a call successfully completed.
- */
-bool __rxrpc_call_completed(struct rxrpc_call *call)
-{
-	return __rxrpc_set_call_completion(call, RXRPC_CALL_SUCCEEDED, 0, 0);
-}
-
-bool rxrpc_call_completed(struct rxrpc_call *call)
-{
-	bool ret = false;
-
-	if (call->state < RXRPC_CALL_COMPLETE) {
-		spin_lock(&call->state_lock);
-		ret = __rxrpc_call_completed(call);
-		spin_unlock(&call->state_lock);
-	}
-	return ret;
-}
-
-/*
- * Record that a call is locally aborted.
- */
-bool __rxrpc_abort_call(struct rxrpc_call *call, rxrpc_seq_t seq,
-			u32 abort_code, int error,
-			enum rxrpc_abort_reason why)
-{
-	trace_rxrpc_abort(call->debug_id, why, call->cid, call->call_id, seq,
-			  abort_code, error);
-	return __rxrpc_set_call_completion(call, RXRPC_CALL_LOCALLY_ABORTED,
-					   abort_code, error);
-}
-
-bool rxrpc_abort_call(struct rxrpc_call *call, rxrpc_seq_t seq,
-		      u32 abort_code, int error,
-		      enum rxrpc_abort_reason why)
-{
-	bool ret;
-
-	spin_lock(&call->state_lock);
-	ret = __rxrpc_abort_call(call, seq, abort_code, error, why);
-	spin_unlock(&call->state_lock);
-	if (ret)
-		rxrpc_send_abort_packet(call);
-	return ret;
-}
-
 /*
  * Pass a call terminating message to userspace.
  */


