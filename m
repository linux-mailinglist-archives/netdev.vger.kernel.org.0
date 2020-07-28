Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5314B231628
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbgG1XKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 19:10:11 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52917 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730041AbgG1XKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 19:10:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595977807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XUmHWaIn8FCqLTurCz3Fw/l96qXWW2bMBVNyIMdJ1Kw=;
        b=YImhjnK1EfjVKPeDdPF3I3sliKJrpPIvS22Xz2NSJxMy8FHKBAtC7XDVxPMw8KLeHJ5llx
        bFDASNkN12vwsU4z31oFcAFLRycPOPTPuganO85Tf63F4h841iihz4RUnhD95UVw8cenSQ
        SzUi+Bd9fcACaEyCRUYF4K7/ktZyHbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-C9CTVi7_MBG799-v11yjuA-1; Tue, 28 Jul 2020 19:03:59 -0400
X-MC-Unique: C9CTVi7_MBG799-v11yjuA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B65D1005504;
        Tue, 28 Jul 2020 23:03:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-32.rdu2.redhat.com [10.10.112.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40CC819C71;
        Tue, 28 Jul 2020 23:03:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix race between recvmsg and sendmsg on immediate
 call failure
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     syzbot+b54969381df354936d96@syzkaller.appspotmail.com,
        Marc Dionne <marc.dionne@auristor.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 29 Jul 2020 00:03:56 +0100
Message-ID: <159597743637.3473535.17426270487937799293.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a race between rxrpc_sendmsg setting up a call, but then failing to
send anything on it due to an error, and recvmsg() seeing the call
completion occur and trying to return the state to the user.

An assertion fails in rxrpc_recvmsg() because the call has already been
released from the socket and is about to be released again as recvmsg deals
with it.  (The recvmsg_q queue on the socket holds a ref, so there's no
problem with use-after-free.)

We also have to be careful not to end up reporting an error twice, in such
a way that both returns indicate to userspace that the user ID supplied
with the call is no longer in use - which could cause the client to
malfunction if it recycles the user ID fast enough.

Fix this by the following means:

 (1) When sendmsg() creates a call after the point that the call has been
     successfully added to the socket, don't return any errors through
     sendmsg(), but rather complete the call and let recvmsg() retrieve
     them.  Make sendmsg() return 0 at this point.  Further calls to
     sendmsg() for that call will fail with ESHUTDOWN.

     Note that at this point, we haven't send any packets yet, so the
     server doesn't yet know about the call.

 (2) If sendmsg() returns an error when it was expected to create a new
     call, it means that the user ID wasn't used.

 (3) Mark the call disconnected before marking it completed to prevent an
     oops in rxrpc_release_call().

 (4) recvmsg() will then retrieve the error and set MSG_EOR to indicate
     that the user ID is no longer known by the kernel.


An oops like the following is produced:

	kernel BUG at net/rxrpc/recvmsg.c:605!
	...
	RIP: 0010:rxrpc_recvmsg+0x256/0x5ae
	...
	Call Trace:
	 ? __init_waitqueue_head+0x2f/0x2f
	 ____sys_recvmsg+0x8a/0x148
	 ? import_iovec+0x69/0x9c
	 ? copy_msghdr_from_user+0x5c/0x86
	 ___sys_recvmsg+0x72/0xaa
	 ? __fget_files+0x22/0x57
	 ? __fget_light+0x46/0x51
	 ? fdget+0x9/0x1b
	 do_recvmmsg+0x15e/0x232
	 ? _raw_spin_unlock+0xa/0xb
	 ? vtime_delta+0xf/0x25
	 __x64_sys_recvmmsg+0x2c/0x2f
	 do_syscall_64+0x4c/0x78
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 357f5ef64628 ("rxrpc: Call rxrpc_release_call() on error in rxrpc_new_client_call()")
Reported-by: syzbot+b54969381df354936d96@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
---

 net/rxrpc/call_object.c |   27 +++++++++++++++++++--------
 net/rxrpc/conn_object.c |    8 +++++---
 net/rxrpc/recvmsg.c     |    2 +-
 net/rxrpc/sendmsg.c     |    3 +++
 4 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index f07970207b54..38a46167523f 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -288,7 +288,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	 */
 	ret = rxrpc_connect_call(rx, call, cp, srx, gfp);
 	if (ret < 0)
-		goto error;
+		goto error_attached_to_socket;
 
 	trace_rxrpc_call(call->debug_id, rxrpc_call_connected,
 			 atomic_read(&call->usage), here, NULL);
@@ -308,18 +308,29 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 error_dup_user_ID:
 	write_unlock(&rx->call_lock);
 	release_sock(&rx->sk);
-	ret = -EEXIST;
-
-error:
 	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
-				    RX_CALL_DEAD, ret);
+				    RX_CALL_DEAD, -EEXIST);
 	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
-			 atomic_read(&call->usage), here, ERR_PTR(ret));
+			 atomic_read(&call->usage), here, ERR_PTR(-EEXIST));
 	rxrpc_release_call(rx, call);
 	mutex_unlock(&call->user_mutex);
 	rxrpc_put_call(call, rxrpc_call_put);
-	_leave(" = %d", ret);
-	return ERR_PTR(ret);
+	_leave(" = -EEXIST");
+	return ERR_PTR(-EEXIST);
+
+	/* We got an error, but the call is attached to the socket and is in
+	 * need of release.  However, we might now race with recvmsg() when
+	 * completing the call queues it.  Return 0 from sys_sendmsg() and
+	 * leave the error to recvmsg() to deal with.
+	 */
+error_attached_to_socket:
+	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
+			 atomic_read(&call->usage), here, ERR_PTR(ret));
+	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
+	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
+				    RX_CALL_DEAD, ret);
+	_leave(" = c=%08x [err]", call->debug_id);
+	return call;
 }
 
 /*
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 19e141eeed17..8cbe0bf20ed5 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -212,9 +212,11 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 
 	call->peer->cong_cwnd = call->cong_cwnd;
 
-	spin_lock_bh(&conn->params.peer->lock);
-	hlist_del_rcu(&call->error_link);
-	spin_unlock_bh(&conn->params.peer->lock);
+	if (!hlist_unhashed(&call->error_link)) {
+		spin_lock_bh(&call->peer->lock);
+		hlist_del_rcu(&call->error_link);
+		spin_unlock_bh(&call->peer->lock);
+	}
 
 	if (rxrpc_is_client_call(call))
 		return rxrpc_disconnect_client_call(call);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 490b1927215c..efecc5a8f67d 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -620,7 +620,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			goto error_unlock_call;
 	}
 
-	if (msg->msg_name) {
+	if (msg->msg_name && call->peer) {
 		struct sockaddr_rxrpc *srx = msg->msg_name;
 		size_t len = sizeof(call->peer->srx);
 
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 03a30d014bb6..f3f6da6e4ad2 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -681,6 +681,9 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		if (IS_ERR(call))
 			return PTR_ERR(call);
 		/* ... and we have the call lock. */
+		ret = 0;
+		if (READ_ONCE(call->state) == RXRPC_CALL_COMPLETE)
+			goto out_put_unlock;
 	} else {
 		switch (READ_ONCE(call->state)) {
 		case RXRPC_CALL_UNINITIALISED:


