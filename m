Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0FD698783
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjBOVtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBOVs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:48:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CED75592
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 13:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676497691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=u8Ps7KgJ0Bbhv4F8g4MkmlHXdKUo/8YcDvGuJM+sj5M=;
        b=ON0RUzkQSARINEjfKN41+Hh3oP/d9Jjn2wm/MiXqIdyewRDPDgg8xD3RfGGyezG5hQzigh
        qR7n4szj4tsrtl3968ixWyPkfU2LmHUolh/iCrws+sULJXHi9FSf73B1TjIqYeh6fIthPb
        02vFdEmL8pAyx5iRcTaqWdzgGu7NTPk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-Ddr-0pwyMLK_fDHvgn5R1g-1; Wed, 15 Feb 2023 16:48:07 -0500
X-MC-Unique: Ddr-0pwyMLK_fDHvgn5R1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44155101A55E;
        Wed, 15 Feb 2023 21:48:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19BA02026D68;
        Wed, 15 Feb 2023 21:48:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] rxrpc: Fix overproduction of wakeups to recvmsg()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3386148.1676497685.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 15 Feb 2023 21:48:05 +0000
Message-ID: <3386149.1676497685@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix three cases of overproduction of wakeups:

 (1) rxrpc_input_split_jumbo() conditionally notifies the app that there's
     data for recvmsg() to collect if it queues some data - and then its
     only caller, rxrpc_input_data(), goes and wakes up recvmsg() anyway.

     Fix the rxrpc_input_data() to only do the wakeup in failure cases.

 (2) If a DATA packet is received for a call by the I/O thread whilst
     recvmsg() is busy draining the call's rx queue in the app thread, the
     call will left on the recvmsg() queue for recvmsg() to pick up, even
     though there isn't any data on it.

     This can cause an unexpected recvmsg() with a 0 return and no MSG_EOR
     set after the reply has been posted to a service call.

     Fix this by discarding pending calls from the recvmsg() queue that
     don't need servicing yet.

 (3) Not-yet-completed calls get requeued after having data read from them=
,
     even if they have no data to read.

     Fix this by only requeuing them if they have data waiting on them; if
     they don't, the I/O thread will requeue them when data arrives or the=
y
     fail.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 include/trace/events/rxrpc.h |    1 +
 net/rxrpc/input.c            |    2 +-
 net/rxrpc/recvmsg.c          |   16 +++++++++++++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index c3c0b0aa8381..4c53a5ef6257 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -318,6 +318,7 @@
 	EM(rxrpc_recvmsg_return,		"RETN") \
 	EM(rxrpc_recvmsg_terminal,		"TERM") \
 	EM(rxrpc_recvmsg_to_be_accepted,	"TBAC") \
+	EM(rxrpc_recvmsg_unqueue,		"UNQU") \
 	E_(rxrpc_recvmsg_wait,			"WAIT")
 =

 #define rxrpc_rtt_tx_traces \
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index d68848fce51f..030d64f282f3 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -606,7 +606,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, =
struct sk_buff *skb)
 		rxrpc_proto_abort(call, sp->hdr.seq, rxrpc_badmsg_bad_jumbo);
 		goto out_notify;
 	}
-	skb =3D NULL;
+	return;
 =

 out_notify:
 	trace_rxrpc_notify_socket(call->debug_id, serial);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 76eb2b9cd936..a482f88c5fc5 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -334,10 +334,23 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr=
 *msg, size_t len,
 =

 	/* Find the next call and dequeue it if we're not just peeking.  If we
 	 * do dequeue it, that comes with a ref that we will need to release.
+	 * We also want to weed out calls that got requeued whilst we were
+	 * shovelling data out.
 	 */
 	spin_lock(&rx->recvmsg_lock);
 	l =3D rx->recvmsg_q.next;
 	call =3D list_entry(l, struct rxrpc_call, recvmsg_link);
+
+	if (!rxrpc_call_is_complete(call) &&
+	    skb_queue_empty(&call->recvmsg_queue)) {
+		list_del_init(&call->recvmsg_link);
+		spin_unlock(&rx->recvmsg_lock);
+		release_sock(&rx->sk);
+		trace_rxrpc_recvmsg(call->debug_id, rxrpc_recvmsg_unqueue, 0);
+		rxrpc_put_call(call, rxrpc_call_put_recvmsg);
+		goto try_again;
+	}
+
 	if (!(flags & MSG_PEEK))
 		list_del_init(&call->recvmsg_link);
 	else
@@ -402,7 +415,8 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *=
msg, size_t len,
 	if (rxrpc_call_has_failed(call))
 		goto call_failed;
 =

-	rxrpc_notify_socket(call);
+	if (!skb_queue_empty(&call->recvmsg_queue))
+		rxrpc_notify_socket(call);
 	goto not_yet_complete;
 =

 call_failed:

