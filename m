Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392BA68337F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjAaROQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbjAaROA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:14:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5302B4203
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zMmRZ2FHRtn2bJjGLjlAYjam0XhR/5jhivnXAcSdEhA=;
        b=SOmW5h3axZoiOSPAAypSo0JmmbvPRFyxwg18MTGHghxlxTTM8aT0XobUyV/WmM2RWlckyp
        qxChucEF+BqB3EOgv3YuQGCMHE/NpYfVG25Xp0IiuBuyHlwGQSP+v5zJAYSungQRVkVCDV
        QCJ2RJkyYxiiwzwiWKyFN7XWSSzk9EY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-ITfWSNPRNJebGV_tu_1ubA-1; Tue, 31 Jan 2023 12:12:53 -0500
X-MC-Unique: ITfWSNPRNJebGV_tu_1ubA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1E78857A8E;
        Tue, 31 Jan 2023 17:12:49 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C784F492B05;
        Tue, 31 Jan 2023 17:12:48 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/13] rxrpc: Remove local->defrag_sem
Date:   Tue, 31 Jan 2023 17:12:24 +0000
Message-Id: <20230131171227.3912130-11-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
 net/rxrpc/ar-internal.h  | 1 -
 net/rxrpc/local_object.c | 1 -
 net/rxrpc/output.c       | 7 -------
 3 files changed, 9 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 2b1d0d3ca064..9e19688b0e06 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -284,7 +284,6 @@ struct rxrpc_local {
 	struct task_struct	*io_thread;
 	struct completion	io_thread_ready; /* Indication that the I/O thread started */
 	struct rxrpc_sock	*service;	/* Service(s) listening on this endpoint */
-	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 #ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
 	struct sk_buff_head	rx_delay_queue;	/* Delay injection queue */
 #endif
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 07d83a4e5841..7d910aee4f8c 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -108,7 +108,6 @@ static struct rxrpc_local *rxrpc_alloc_local(struct net *net,
 		local->net = net;
 		local->rxnet = rxrpc_net(net);
 		INIT_HLIST_NODE(&local->link);
-		init_rwsem(&local->defrag_sem);
 		init_completion(&local->io_thread_ready);
 #ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
 		skb_queue_head_init(&local->rx_delay_queue);
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index c69c31470fa8..6b2022240076 100644
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
 

