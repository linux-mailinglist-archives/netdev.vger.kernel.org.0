Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00DD621F00
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiKHWTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiKHWTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:19:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0274415A3E
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RM4drjFxVfK0AtdFAz36VEYSNWGUYyCeJmp+7O6N89A=;
        b=Lx9WFVLVpOaQGlTPUU4zXH8tb/UuvIA2bYr4nd5cBsvhgWBwQnbmEv6Fkr+9Z4JlnBaMOk
        iA19IGCh8lBda5r7dC8jkm8Tb3W4Y4wft0aEYZA9BDkBR//m9lrXn7etDVT0M+oC10AywE
        2lsPjtQh58VyiSkINDI/i+7hAJ1sOTg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-MNk_zZluM9KhehoEF4OqLg-1; Tue, 08 Nov 2022 17:18:25 -0500
X-MC-Unique: MNk_zZluM9KhehoEF4OqLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62460185A7A3;
        Tue,  8 Nov 2022 22:18:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0797112132E;
        Tue,  8 Nov 2022 22:18:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 05/26] rxrpc: Add stats procfile and DATA packet
 stats
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:18:24 +0000
Message-ID: <166794590418.2389296.11209665956142046349.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a procfile, /proc/net/rxrpc/stats, to display some statistics about
what rxrpc has been doing.  Writing a blank line to the stats file will
clear the increment-only counters.  Allocated resource counters don't get
cleared.

Add some counters to count various things about DATA packets, including the
number created, transmitted and retransmitted and the number received, the
number of ACK-requests markings and the number of jumbo packets received.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |   17 +++++++++++++++++
 net/rxrpc/call_event.c  |    1 +
 net/rxrpc/input.c       |    6 ++++++
 net/rxrpc/net_ns.c      |    2 ++
 net/rxrpc/output.c      |    2 ++
 net/rxrpc/proc.c        |   48 +++++++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/sendmsg.c     |    2 ++
 7 files changed, 78 insertions(+)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 6c93a2fa9628..ed406a5f939b 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -93,6 +93,14 @@ struct rxrpc_net {
 	struct list_head	peer_keepalive_new;
 	struct timer_list	peer_keepalive_timer;
 	struct work_struct	peer_keepalive_work;
+
+	atomic_t		stat_tx_data;
+	atomic_t		stat_tx_data_retrans;
+	atomic_t		stat_tx_data_send;
+	atomic_t		stat_tx_data_send_frag;
+	atomic_t		stat_rx_data;
+	atomic_t		stat_rx_data_reqack;
+	atomic_t		stat_rx_data_jumbo;
 };
 
 /*
@@ -1092,6 +1100,15 @@ void rxrpc_get_skb(struct sk_buff *, enum rxrpc_skb_trace);
 void rxrpc_free_skb(struct sk_buff *, enum rxrpc_skb_trace);
 void rxrpc_purge_queue(struct sk_buff_head *);
 
+/*
+ * stats.c
+ */
+int rxrpc_stats_show(struct seq_file *seq, void *v);
+int rxrpc_stats_clear(struct file *file, char *buf, size_t size);
+
+#define rxrpc_inc_stat(rxnet, s) atomic_inc(&(rxnet)->s)
+#define rxrpc_dec_stat(rxnet, s) atomic_dec(&(rxnet)->s)
+
 /*
  * sysctl.c
  */
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 2a93e7b5fbd0..c5b3ae1fe80b 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -261,6 +261,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 		rxrpc_get_skb(skb, rxrpc_skb_got);
 		spin_unlock_bh(&call->lock);
 
+		rxrpc_inc_stat(call->rxnet, stat_tx_data_retrans);
 		if (rxrpc_send_data_packet(call, skb, true) < 0) {
 			rxrpc_free_skb(skb, rxrpc_skb_freed);
 			return;
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 4ba678f0c384..e7586d5ea2c3 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -443,6 +443,12 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		}
 	}
 
+	rxrpc_inc_stat(call->rxnet, stat_rx_data);
+	if (sp->hdr.flags & RXRPC_REQUEST_ACK)
+		rxrpc_inc_stat(call->rxnet, stat_rx_data_reqack);
+	if (sp->hdr.flags & RXRPC_JUMBO_PACKET)
+		rxrpc_inc_stat(call->rxnet, stat_rx_data_jumbo);
+
 	spin_lock(&call->input_lock);
 
 	/* Received data implicitly ACKs all of the request packets we sent
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index bb4c25d6df64..84242c0e467c 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -101,6 +101,8 @@ static __net_init int rxrpc_init_net(struct net *net)
 	proc_create_net("locals", 0444, rxnet->proc_net,
 			&rxrpc_local_seq_ops,
 			sizeof(struct seq_net_private));
+	proc_create_net_single_write("stats", S_IFREG | 0644, rxnet->proc_net,
+				     rxrpc_stats_show, rxrpc_stats_clear, NULL);
 	return 0;
 
 err_proc:
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 2922c10bd500..8fddad2f63fc 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -462,6 +462,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	 *   - in which case, we'll have processed the ICMP error
 	 *     message and update the peer record
 	 */
+	rxrpc_inc_stat(call->rxnet, stat_tx_data_send);
 	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 2, len);
 	conn->params.peer->last_tx_at = ktime_get_seconds();
 
@@ -537,6 +538,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	case AF_INET:
 		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
 				IP_PMTUDISC_DONT);
+		rxrpc_inc_stat(call->rxnet, stat_tx_data_send_frag);
 		ret = kernel_sendmsg(conn->params.local->socket, &msg,
 				     iov, 2, len);
 		conn->params.peer->last_tx_at = ktime_get_seconds();
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 245418943e01..102744411932 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -397,3 +397,51 @@ const struct seq_operations rxrpc_local_seq_ops = {
 	.stop   = rxrpc_local_seq_stop,
 	.show   = rxrpc_local_seq_show,
 };
+
+/*
+ * Display stats in /proc/net/rxrpc/stats
+ */
+int rxrpc_stats_show(struct seq_file *seq, void *v)
+{
+	struct rxrpc_net *rxnet = rxrpc_net(seq_file_single_net(seq));
+
+	seq_printf(seq,
+		   "Data     : send=%u sendf=%u\n",
+		   atomic_read(&rxnet->stat_tx_data_send),
+		   atomic_read(&rxnet->stat_tx_data_send_frag));
+	seq_printf(seq,
+		   "Data-Tx  : nr=%u retrans=%u\n",
+		   atomic_read(&rxnet->stat_tx_data),
+		   atomic_read(&rxnet->stat_tx_data_retrans));
+	seq_printf(seq,
+		   "Data-Rx  : nr=%u reqack=%u jumbo=%u\n",
+		   atomic_read(&rxnet->stat_rx_data),
+		   atomic_read(&rxnet->stat_rx_data_reqack),
+		   atomic_read(&rxnet->stat_rx_data_jumbo));
+	seq_printf(seq,
+		   "Buffers  : txb=%u rxb=%u\n",
+		   atomic_read(&rxrpc_n_tx_skbs),
+		   atomic_read(&rxrpc_n_rx_skbs));
+	return 0;
+}
+
+/*
+ * Clear stats if /proc/net/rxrpc/stats is written to.
+ */
+int rxrpc_stats_clear(struct file *file, char *buf, size_t size)
+{
+	struct seq_file *m = file->private_data;
+	struct rxrpc_net *rxnet = rxrpc_net(seq_file_single_net(m));
+
+	if (size > 1 || (size == 1 && buf[0] != '\n'))
+		return -EINVAL;
+
+	atomic_set(&rxnet->stat_tx_data, 0);
+	atomic_set(&rxnet->stat_tx_data_retrans, 0);
+	atomic_set(&rxnet->stat_tx_data_send, 0);
+	atomic_set(&rxnet->stat_tx_data_send_frag, 0);
+	atomic_set(&rxnet->stat_rx_data, 0);
+	atomic_set(&rxnet->stat_rx_data_reqack, 0);
+	atomic_set(&rxnet->stat_rx_data_jumbo, 0);
+	return size;
+}
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 3c3a626459de..ad6f2cd08916 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -200,6 +200,8 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 
 	_net("queue skb %p [%d]", skb, seq);
 
+	rxrpc_inc_stat(call->rxnet, stat_tx_data);
+
 	ASSERTCMP(seq, ==, call->tx_top + 1);
 
 	if (last)


