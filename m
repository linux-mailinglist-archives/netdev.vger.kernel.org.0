Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DA0644899
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiLFQBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbiLFQBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:01:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37722E9E4
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fBG0v7ZhfemP2OkST4l4S4HMt7ZN0ON4gfIK4H0n0DE=;
        b=Zhr8dZvM2xh3SRNfWgJpUE2tTgcGKHzbdHpG2zGsLOLlDhWy5aiVeqqtKZ8Id0WWPT3FEZ
        /mpgJksLwRRetAoRFWZ6TH7b8/u1SOHNnCrvnUrpP7tqbF3GepRBOrEM0ef2qKXdrsa8YP
        VFE6jdgR2V2XJOUC83PRbszifN05xUA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-R21qLhxlMCSTcpKaNZf71g-1; Tue, 06 Dec 2022 11:00:38 -0500
X-MC-Unique: R21qLhxlMCSTcpKaNZf71g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 633F4802804;
        Tue,  6 Dec 2022 16:00:37 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCDFD2166B26;
        Tue,  6 Dec 2022 16:00:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 14/32] rxrpc: Remove local->defrag_sem
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:00:34 +0000
Message-ID: <167034243403.1105287.2323199364671061536.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
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

We no longer need local->defrag_sem as all DATA packet transmission is now
done from one thread, so remove it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h  |    1 -
 net/rxrpc/local_object.c |    1 -
 net/rxrpc/output.c       |    7 -------
 3 files changed, 9 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 092413e2b12a..29a8803236e8 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -288,7 +288,6 @@ struct rxrpc_local {
 	struct socket		*socket;	/* my UDP socket */
 	struct task_struct	*io_thread;
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
-	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 #ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
 	struct sk_buff_head	rx_delay_queue;	/* Delay injection queue */
 #endif
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index b35628ca57a5..b77e3076f6d9 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -96,7 +96,6 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		atomic_set(&local->active_users, 1);
 		local->rxnet = rxnet;
 		INIT_HLIST_NODE(&local->link);
-		init_rwsem(&local->defrag_sem);
 #ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
 		skb_queue_head_init(&local->rx_delay_queue);
 #endif
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 86dafa41236a..4c2c4b9828b8 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -409,8 +409,6 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	if (txb->len >= call->peer->maxdata)
 		goto send_fragmentable;
 
-	down_read(&conn->local->defrag_sem);
-
 	txb->last_sent = ktime_get_real();
 	if (txb->wire.flags & RXRPC_REQUEST_ACK)
 		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_data);
@@ -425,7 +423,6 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
 	conn->peer->last_tx_at = ktime_get_seconds();
 
-	up_read(&conn->local->defrag_sem);
 	if (ret < 0) {
 		rxrpc_inc_stat(call->rxnet, stat_tx_data_send_fail);
 		rxrpc_cancel_rtt_probe(call, serial, rtt_slot);
@@ -486,8 +483,6 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	/* attempt to send this message with fragmentation enabled */
 	_debug("send fragment");
 
-	down_write(&conn->local->defrag_sem);
-
 	txb->last_sent = ktime_get_real();
 	if (txb->wire.flags & RXRPC_REQUEST_ACK)
 		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_data);
@@ -519,8 +514,6 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 				      rxrpc_tx_point_call_data_frag);
 	}
 	rxrpc_tx_backoff(call, ret);
-
-	up_write(&conn->local->defrag_sem);
 	goto done;
 }
 


