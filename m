Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675E96EB461
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 00:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbjDUWEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 18:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbjDUWEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 18:04:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C30AC
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 15:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682114633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ejU3CHJlEVdqeTxzhMOwDdKIBa+AQnr4MNeCEdZSVeY=;
        b=OdFLUND/1VNdAgr5cJ5ug4uL8vosQCfwqLeSbjfiOY1j7++HK4t/iBjb8yMwA+2AXQF4uU
        kRz+K9nYgRdM7DgL58VBpq4Sl++4FEUPZD3BA0RaYDAqNcdkWPsL5r58kl99gDefooeLjt
        9Db+lJz1vACFwIYfWHJfTI8mLk6x9+I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-2pCQDPHhPA6S5rmXOgbU5Q-1; Fri, 21 Apr 2023 18:03:48 -0400
X-MC-Unique: 2pCQDPHhPA6S5rmXOgbU5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1345F3C0ED58;
        Fri, 21 Apr 2023 22:03:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.158])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C368040C2064;
        Fri, 21 Apr 2023 22:03:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
cc:     dhowells@redhat.com, Jeffrey Altman <jaltman@auristor.com>,
        kafs-testing+fedora36_64checkkafs-build-306@auristor.com,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] rxrpc: Fix potential race in error handling in afs_make_call()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <228969.1682114626.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 21 Apr 2023 23:03:46 +0100
Message-ID: <228970.1682114626@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    =

If the rxrpc call set up by afs_make_call() receives an error whilst it is
transmitting the request, there's the possibility that it may get to the
point the rxrpc call is ended (after the error_kill_call label) just as th=
e
call is queued for async processing.

This could manifest itself as call->rxcall being seen as NULL in
afs_deliver_to_call() when it tries to lock the call.

Fix this by splitting rxrpc_kernel_end_call() into a function to shut down
an rxrpc call and a function to release the caller's reference and calling
the latter only when we get to afs_put_call().

Reported-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: kafs-testing+fedora36_64checkkafs-build-306@auristor.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
---
 Documentation/networking/rxrpc.rst |   17 ++++++++++++-----
 fs/afs/rxrpc.c                     |    9 ++++-----
 include/net/af_rxrpc.h             |    3 ++-
 net/rxrpc/af_rxrpc.c               |   37 +++++++++++++++++++++++++------=
------
 net/rxrpc/rxperf.c                 |    3 ++-
 5 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/Documentation/networking/rxrpc.rst b/Documentation/networking=
/rxrpc.rst
index ec1323d92c96..c318ac5eb66f 100644
--- a/Documentation/networking/rxrpc.rst
+++ b/Documentation/networking/rxrpc.rst
@@ -848,14 +848,21 @@ The kernel interface functions are as follows:
      returned.  The caller now holds a reference on this and it must be
      properly ended.
 =

- (#) End a client call::
+ (#) Shut down a client call::
 =

-	void rxrpc_kernel_end_call(struct socket *sock,
+	void rxrpc_kernel_shutdown_call(struct socket *sock,
+					struct rxrpc_call *call);
+
+     This is used to shut down a previously begun call.  The user_call_ID=
 is
+     expunged from AF_RXRPC's knowledge and will not be seen again in
+     association with the specified call.
+
+ (#) Release the ref on a client call::
+
+	void rxrpc_kernel_put_call(struct socket *sock,
 				   struct rxrpc_call *call);
 =

-     This is used to end a previously begun call.  The user_call_ID is ex=
punged
-     from AF_RXRPC's knowledge and will not be seen again in association =
with
-     the specified call.
+     This is used to release the caller's ref on an rxrpc call.
 =

  (#) Send data through a call::
 =

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 7817e2b860e5..e08b850c3e6d 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -179,7 +179,8 @@ void afs_put_call(struct afs_call *call)
 		ASSERT(call->type->name !=3D NULL);
 =

 		if (call->rxcall) {
-			rxrpc_kernel_end_call(net->socket, call->rxcall);
+			rxrpc_kernel_shutdown_call(net->socket, call->rxcall);
+			rxrpc_kernel_put_call(net->socket, call->rxcall);
 			call->rxcall =3D NULL;
 		}
 		if (call->type->destructor)
@@ -420,10 +421,8 @@ void afs_make_call(struct afs_addr_cursor *ac, struct=
 afs_call *call, gfp_t gfp)
 	 * The call, however, might be queued on afs_async_calls and we need to
 	 * make sure we don't get any more notifications that might requeue it.
 	 */
-	if (call->rxcall) {
-		rxrpc_kernel_end_call(call->net->socket, call->rxcall);
-		call->rxcall =3D NULL;
-	}
+	if (call->rxcall)
+		rxrpc_kernel_shutdown_call(call->net->socket, call->rxcall);
 	if (call->async) {
 		if (cancel_work_sync(&call->async_work))
 			afs_put_call(call);
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index ba717eac0229..01a35e113ab9 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -57,7 +57,8 @@ int rxrpc_kernel_recv_data(struct socket *, struct rxrpc=
_call *,
 			   struct iov_iter *, size_t *, bool, u32 *, u16 *);
 bool rxrpc_kernel_abort_call(struct socket *, struct rxrpc_call *,
 			     u32, int, enum rxrpc_abort_reason);
-void rxrpc_kernel_end_call(struct socket *, struct rxrpc_call *);
+void rxrpc_kernel_shutdown_call(struct socket *sock, struct rxrpc_call *c=
all);
+void rxrpc_kernel_put_call(struct socket *sock, struct rxrpc_call *call);
 void rxrpc_kernel_get_peer(struct socket *, struct rxrpc_call *,
 			   struct sockaddr_rxrpc *);
 bool rxrpc_kernel_get_srtt(struct socket *, struct rxrpc_call *, u32 *);
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 9022071c55e3..ebe5b2906a59 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -341,31 +341,44 @@ static void rxrpc_dummy_notify_rx(struct sock *sk, s=
truct rxrpc_call *rxcall,
 }
 =

 /**
- * rxrpc_kernel_end_call - Allow a kernel service to end a call it was us=
ing
+ * rxrpc_kernel_shutdown_call - Allow a kernel service to shut down a cal=
l it was using
  * @sock: The socket the call is on
  * @call: The call to end
  *
- * Allow a kernel service to end a call it was using.  The call must be
+ * Allow a kernel service to shut down a call it was using.  The call mus=
t be
  * complete before this is called (the call should be aborted if necessar=
y).
  */
-void rxrpc_kernel_end_call(struct socket *sock, struct rxrpc_call *call)
+void rxrpc_kernel_shutdown_call(struct socket *sock, struct rxrpc_call *c=
all)
 {
 	_enter("%d{%d}", call->debug_id, refcount_read(&call->ref));
 =

 	mutex_lock(&call->user_mutex);
-	rxrpc_release_call(rxrpc_sk(sock->sk), call);
-
-	/* Make sure we're not going to call back into a kernel service */
-	if (call->notify_rx) {
-		spin_lock(&call->notify_lock);
-		call->notify_rx =3D rxrpc_dummy_notify_rx;
-		spin_unlock(&call->notify_lock);
+	if (!test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
+		rxrpc_release_call(rxrpc_sk(sock->sk), call);
+
+		/* Make sure we're not going to call back into a kernel service */
+		if (call->notify_rx) {
+			spin_lock(&call->notify_lock);
+			call->notify_rx =3D rxrpc_dummy_notify_rx;
+			spin_unlock(&call->notify_lock);
+		}
 	}
-
 	mutex_unlock(&call->user_mutex);
+}
+EXPORT_SYMBOL(rxrpc_kernel_shutdown_call);
+
+/**
+ * rxrpc_kernel_put_call - Release a reference to a call
+ * @sock: The socket the call is on
+ * @call: The call to put
+ *
+ * Drop the application's ref on an rxrpc call.
+ */
+void rxrpc_kernel_put_call(struct socket *sock, struct rxrpc_call *call)
+{
 	rxrpc_put_call(call, rxrpc_call_put_kernel);
 }
-EXPORT_SYMBOL(rxrpc_kernel_end_call);
+EXPORT_SYMBOL(rxrpc_kernel_put_call);
 =

 /**
  * rxrpc_kernel_check_life - Check to see whether a call is still alive
diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index 4a2e90015ca7..085e7892d310 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -342,7 +342,8 @@ static void rxperf_deliver_to_call(struct work_struct =
*work)
 call_complete:
 	rxperf_set_call_complete(call, ret, remote_abort);
 	/* The call may have been requeued */
-	rxrpc_kernel_end_call(rxperf_socket, call->rxcall);
+	rxrpc_kernel_shutdown_call(rxperf_socket, call->rxcall);
+	rxrpc_kernel_put_call(rxperf_socket, call->rxcall);
 	cancel_work(&call->work);
 	kfree(call);
 }

