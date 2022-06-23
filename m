Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79EA5557D05
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiFWNaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiFWN3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:29:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4912F35DF1
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655990978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tBP8wjmH4TfVY1MD58FzTIzfpnxs/mB1rKQMTwCUA1I=;
        b=ZQCmkTjdAaRoHYzl3K4nj+9wWkiJWERyqAltZ3DMFUsye0cKualbncfye0a23nRHsXmWj8
        5WVoDONq63sZTvhKFs0Q7KrYxiyIU04LNHu2ZrUfVleX4E5n95dBFLCFxqa664FD4RLg9d
        6ST03jesZR7o1X964eRowdxubYfZqgs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-jq1NeFK5M7u19AD5h0la4w-1; Thu, 23 Jun 2022 09:29:35 -0400
X-MC-Unique: jq1NeFK5M7u19AD5h0la4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94BDE1C0512E;
        Thu, 23 Jun 2022 13:29:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3657141510C;
        Thu, 23 Jun 2022 13:29:33 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 6/8] rxrpc: Use selected call in recvmsg()
From:   David Howells <dhowells@redhat.com>
To:     linux-afs@lists.infradead.org
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Jun 2022 14:29:33 +0100
Message-ID: <165599097309.1827880.4896993880358856739.stgit@warthog.procyon.org.uk>
In-Reply-To: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
References: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow an AF_RXRPC socket to be limited temporarily such that recvmsg() will
only retreive messages and data pertaining to one particular call.  The
call to be read from must be preselected with setsockopt():

	setsockopt(client, SOL_RXRPC, RXRPC_SELECT_CALL_FOR_RECV,
		   &call_id, sizeof(call_id));
	ret = recvmsg(client, &msg, 0);

The preselected call can be cleared by giving it a call ID of 0.  The
preselection is also automatically cleared if recvmsg returns the
completion state of the call (MSG_EOR will be set).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/recvmsg.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 2b596e2172ce..3fc6bf8b1ff2 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -540,6 +540,51 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		return -EAGAIN;
 	}
 
+	if (rx->selected_recv_call) {
+		/* The call to receive from was dictated by
+		 * setsockopt(RXRPC_SELECT_CALL_FOR_RECV).
+		 */
+		call = rx->selected_recv_call;
+		rxrpc_get_call(call, rxrpc_call_got);
+		if (!list_empty(&call->recvmsg_link)) {
+			write_lock_bh(&rx->recvmsg_lock);
+			goto use_this_call;
+		}
+
+		if (timeo == 0) {
+			ret = -EWOULDBLOCK;
+			call = NULL;
+			goto error_no_call;
+		}
+
+		release_sock(&rx->sk);
+
+		/* Wait for something to happen */
+		prepare_to_wait_exclusive(sk_sleep(&rx->sk), &wait,
+					  TASK_INTERRUPTIBLE);
+		for (;;) {
+			ret = sock_error(&rx->sk);
+			if (ret) {
+				rxrpc_put_call(call, rxrpc_call_put);
+				goto wait_error;
+			}
+
+			if (!list_empty(&call->recvmsg_link))
+				break;
+
+			if (signal_pending(current)) {
+				rxrpc_put_call(call, rxrpc_call_put);
+				goto wait_interrupted;
+			}
+			trace_rxrpc_recvmsg(NULL, rxrpc_recvmsg_wait,
+					    0, 0, 0, 0);
+			timeo = schedule_timeout(timeo);
+		}
+		finish_wait(sk_sleep(&rx->sk), &wait);
+		write_lock_bh(&rx->recvmsg_lock);
+		goto use_this_call;
+	}
+
 	if (list_empty(&rx->recvmsg_q)) {
 		ret = -EWOULDBLOCK;
 		if (timeo == 0) {
@@ -573,10 +618,11 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	write_lock_bh(&rx->recvmsg_lock);
 	l = rx->recvmsg_q.next;
 	call = list_entry(l, struct rxrpc_call, recvmsg_link);
+	if (flags & MSG_PEEK)
+		rxrpc_get_call(call, rxrpc_call_got);
+use_this_call:
 	if (!(flags & MSG_PEEK))
 		list_del_init(&call->recvmsg_link);
-	else
-		rxrpc_get_call(call, rxrpc_call_got);
 	write_unlock_bh(&rx->recvmsg_lock);
 
 	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_dequeue, 0, 0, 0, 0);
@@ -654,8 +700,15 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		ret = rxrpc_recvmsg_term(call, msg);
 		if (ret < 0)
 			goto error_unlock_call;
-		if (!(flags & MSG_PEEK))
+		if (!(flags & MSG_PEEK)) {
+			struct rxrpc_call *old = call;
+			if (try_cmpxchg(&rx->selected_recv_call, &old, NULL))
+				rxrpc_put_call(call, rxrpc_call_put);
+			old = call;
+			if (try_cmpxchg(&rx->selected_send_call, &old, NULL))
+				rxrpc_put_call(call, rxrpc_call_put);
 			rxrpc_release_call(call);
+		}
 		msg->msg_flags |= MSG_EOR;
 		ret = 1;
 	}


