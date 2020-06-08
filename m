Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5BC1F1F4A
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 20:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgFHSuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 14:50:10 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39688 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726101AbgFHSuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 14:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591642207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rH8MpXGVAV4nFViikxVNGQ6cewnlNkwGUrQ6pwHt3dQ=;
        b=bZdnpChFIkeT8EDEpv+ZwlnPRnRxleUsx4L3ysHKHz9zxg9ql8hisGmUOoA57DsgjlngCT
        oDSgJixQW9H9qniCp0Lt2BTXm356pMffOK6AP/hQYuKJi77ZzWxKvB04dlQWLBl+rdm84R
        ZSvDvbmIp/0BROx4SH2JuzbH/4q88VQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-y9DUsuAwMhaWWEpFPB7X8g-1; Mon, 08 Jun 2020 14:50:05 -0400
X-MC-Unique: y9DUsuAwMhaWWEpFPB7X8g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEC4B1005512;
        Mon,  8 Jun 2020 18:50:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BB8C100239B;
        Mon,  8 Jun 2020 18:50:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 2/2] rxrpc: Fix missing notification
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Gerry Seidman <gerry@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Mon, 08 Jun 2020 19:50:01 +0100
Message-ID: <159164220145.2758133.3370434050398146640.stgit@warthog.procyon.org.uk>
In-Reply-To: <159164218727.2758133.1046957228494479308.stgit@warthog.procyon.org.uk>
References: <159164218727.2758133.1046957228494479308.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under some circumstances, rxrpc will fail a transmit a packet through the
underlying UDP socket (ie. UDP sendmsg returns an error).  This may result
in a call getting stuck.

In the instance being seen, where AFS tries to send a probe to the Volume
Location server, tracepoints show the UDP Tx failure (in this case returing
error 99 EADDRNOTAVAIL) and then nothing more:

 afs_make_vl_call: c=0000015d VL.GetCapabilities
 rxrpc_call: c=0000015d NWc u=1 sp=rxrpc_kernel_begin_call+0x106/0x170 [rxrpc] a=00000000dd89ee8a
 rxrpc_call: c=0000015d Gus u=2 sp=rxrpc_new_client_call+0x14f/0x580 [rxrpc] a=00000000e20e4b08
 rxrpc_call: c=0000015d SEE u=2 sp=rxrpc_activate_one_channel+0x7b/0x1c0 [rxrpc] a=00000000e20e4b08
 rxrpc_call: c=0000015d CON u=2 sp=rxrpc_kernel_begin_call+0x106/0x170 [rxrpc] a=00000000e20e4b08
 rxrpc_tx_fail: c=0000015d r=1 ret=-99 CallDataNofrag

The problem is that if the initial packet fails and the retransmission
timer hasn't been started, the call is set to completed and an error is
returned from rxrpc_send_data_packet() to rxrpc_queue_packet().  Though
rxrpc_instant_resend() is called, this does nothing because the call is
marked completed.

So rxrpc_notify_socket() isn't called and the error is passed back up to
rxrpc_send_data(), rxrpc_kernel_send_data() and thence to afs_make_call()
and afs_vl_get_capabilities() where it is simply ignored because it is
assumed that the result of a probe will be collected asynchronously.

Fileserver probing is similarly affected via afs_fs_get_capabilities().

Fix this by always issuing a notification in __rxrpc_set_call_completion()
if it shifts a call to the completed state, even if an error is also
returned to the caller through the function return value.

Also put in a little bit of optimisation to avoid taking the call
state_lock and disabling softirqs if the call is already in the completed
state and remove some now redundant rxrpc_notify_socket() calls.

Fixes: f5c17aaeb2ae ("rxrpc: Calls should only have one terminal state")
Reported-by: Gerry Seidman <gerry@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
---

 net/rxrpc/call_event.c |    1 -
 net/rxrpc/conn_event.c |    7 +++----
 net/rxrpc/input.c      |    7 ++-----
 net/rxrpc/peer_event.c |    4 +---
 net/rxrpc/recvmsg.c    |   21 +++++++++++++--------
 net/rxrpc/sendmsg.c    |    6 ++----
 6 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 2a65ac41055f..61a51c251e1b 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -320,7 +320,6 @@ void rxrpc_process_call(struct work_struct *work)
 
 	if (call->state == RXRPC_CALL_COMPLETE) {
 		del_timer_sync(&call->timer);
-		rxrpc_notify_socket(call);
 		goto out_put;
 	}
 
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 06fcff2ebbba..447f55ca6886 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -173,10 +173,9 @@ static void rxrpc_abort_calls(struct rxrpc_connection *conn,
 			else
 				trace_rxrpc_rx_abort(call, serial,
 						     conn->abort_code);
-			if (rxrpc_set_call_completion(call, compl,
-						      conn->abort_code,
-						      conn->error))
-				rxrpc_notify_socket(call);
+			rxrpc_set_call_completion(call, compl,
+						  conn->abort_code,
+						  conn->error);
 		}
 	}
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 3be4177baf70..299ac98e9754 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -275,7 +275,6 @@ static bool rxrpc_end_tx_phase(struct rxrpc_call *call, bool reply_begun,
 
 	case RXRPC_CALL_SERVER_AWAIT_ACK:
 		__rxrpc_call_completed(call);
-		rxrpc_notify_socket(call);
 		state = call->state;
 		break;
 
@@ -1013,9 +1012,8 @@ static void rxrpc_input_abort(struct rxrpc_call *call, struct sk_buff *skb)
 
 	_proto("Rx ABORT %%%u { %x }", sp->hdr.serial, abort_code);
 
-	if (rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
-				      abort_code, -ECONNABORTED))
-		rxrpc_notify_socket(call);
+	rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
+				  abort_code, -ECONNABORTED);
 }
 
 /*
@@ -1102,7 +1100,6 @@ static void rxrpc_input_implicit_end_call(struct rxrpc_sock *rx,
 	spin_lock(&rx->incoming_lock);
 	__rxrpc_disconnect_call(conn, call);
 	spin_unlock(&rx->incoming_lock);
-	rxrpc_notify_socket(call);
 }
 
 /*
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index b1449d971883..4704a8dceced 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -289,9 +289,7 @@ static void rxrpc_distribute_error(struct rxrpc_peer *peer, int error,
 
 	hlist_for_each_entry_rcu(call, &peer->error_targets, error_link) {
 		rxrpc_see_call(call);
-		if (call->state < RXRPC_CALL_COMPLETE &&
-		    rxrpc_set_call_completion(call, compl, 0, -error))
-			rxrpc_notify_socket(call);
+		rxrpc_set_call_completion(call, compl, 0, -error);
 	}
 }
 
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 6c4ba4224ddc..2989742a4aa1 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -73,6 +73,7 @@ bool __rxrpc_set_call_completion(struct rxrpc_call *call,
 		call->state = RXRPC_CALL_COMPLETE;
 		trace_rxrpc_call_complete(call);
 		wake_up(&call->waitq);
+		rxrpc_notify_socket(call);
 		return true;
 	}
 	return false;
@@ -83,11 +84,13 @@ bool rxrpc_set_call_completion(struct rxrpc_call *call,
 			       u32 abort_code,
 			       int error)
 {
-	bool ret;
+	bool ret = false;
 
-	write_lock_bh(&call->state_lock);
-	ret = __rxrpc_set_call_completion(call, compl, abort_code, error);
-	write_unlock_bh(&call->state_lock);
+	if (call->state < RXRPC_CALL_COMPLETE) {
+		write_lock_bh(&call->state_lock);
+		ret = __rxrpc_set_call_completion(call, compl, abort_code, error);
+		write_unlock_bh(&call->state_lock);
+	}
 	return ret;
 }
 
@@ -101,11 +104,13 @@ bool __rxrpc_call_completed(struct rxrpc_call *call)
 
 bool rxrpc_call_completed(struct rxrpc_call *call)
 {
-	bool ret;
+	bool ret = false;
 
-	write_lock_bh(&call->state_lock);
-	ret = __rxrpc_call_completed(call);
-	write_unlock_bh(&call->state_lock);
+	if (call->state < RXRPC_CALL_COMPLETE) {
+		write_lock_bh(&call->state_lock);
+		ret = __rxrpc_call_completed(call);
+		write_unlock_bh(&call->state_lock);
+	}
 	return ret;
 }
 
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 5dd9ba000c00..1304b8608f56 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -261,10 +261,8 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 		case -ENETUNREACH:
 		case -EHOSTUNREACH:
 		case -ECONNREFUSED:
-			if (rxrpc_set_call_completion(call,
-						      RXRPC_CALL_LOCAL_ERROR,
-						      0, ret))
-				rxrpc_notify_socket(call);
+			rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
+						  0, ret);
 			goto out;
 		}
 		_debug("need instant resend %d", ret);


