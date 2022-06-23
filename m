Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45775557CFC
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbiFWN30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbiFWN3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:29:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5B6243AE0
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655990943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TYwJyNlorDfkZL5hbdP7tAvf4Wvs6EAxSqE4KohLuJk=;
        b=J9mbnVlR1H07v+gibgJD8R+nTLQt0+aMbLowTWqYcCYaxLtF5NMAm/MQI+a2HubM0QrfMY
        /yQ5LjQpPeMJ2CrpxfpPYf+DoD51GwDFTjmZkpagKY63NXM2lKGq2XyXTFVQz1/CNfrn+M
        YbToyeEC1Z0Lmy1KNkwAD0urpRQhOYw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-5EYduaVENkOqkC9KijmIDw-1; Thu, 23 Jun 2022 09:29:00 -0400
X-MC-Unique: 5EYduaVENkOqkC9KijmIDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7376D101E986;
        Thu, 23 Jun 2022 13:29:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8739F40CFD0B;
        Thu, 23 Jun 2022 13:28:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 1/8] rxrpc: List open sockets in /proc/net/rxrpc/sockets
From:   David Howells <dhowells@redhat.com>
To:     linux-afs@lists.infradead.org
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Jun 2022 14:28:58 +0100
Message-ID: <165599093879.1827880.359068963357629741.stgit@warthog.procyon.org.uk>
In-Reply-To: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
References: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a list of open sockets in /proc/net/rxrpc/sockets, providing a few
useful stats.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/af_rxrpc.c    |    9 +++++
 net/rxrpc/ar-internal.h |    5 ++-
 net/rxrpc/net_ns.c      |    4 ++
 net/rxrpc/proc.c        |   92 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index ceba28e9dce6..5519c2bef7f5 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -787,6 +787,10 @@ static int rxrpc_create(struct net *net, struct socket *sock, int protocol,
 	memset(&rx->srx, 0, sizeof(rx->srx));
 
 	rxnet = rxrpc_net(sock_net(&rx->sk));
+	mutex_lock(&rxnet->local_mutex);
+	hlist_add_head_rcu(&rx->ns_link, &rxnet->sockets);
+	mutex_unlock(&rxnet->local_mutex);
+
 	timer_reduce(&rxnet->peer_keepalive_timer, jiffies + 1);
 
 	_leave(" = 0 [%p]", rx);
@@ -851,6 +855,7 @@ static void rxrpc_sock_destructor(struct sock *sk)
 static int rxrpc_release_sock(struct sock *sk)
 {
 	struct rxrpc_sock *rx = rxrpc_sk(sk);
+	struct rxrpc_net *rxnet = rxrpc_net(sock_net(&rx->sk));
 
 	_enter("%p{%d,%d}", sk, sk->sk_state, refcount_read(&sk->sk_refcnt));
 
@@ -887,6 +892,10 @@ static int rxrpc_release_sock(struct sock *sk)
 	flush_workqueue(rxrpc_workqueue);
 	rxrpc_purge_queue(&sk->sk_receive_queue);
 
+	mutex_lock(&rxnet->local_mutex);
+	hlist_del_rcu(&rx->ns_link);
+	mutex_unlock(&rxnet->local_mutex);
+
 	rxrpc_unuse_local(rx->local);
 	rxrpc_put_local(rx->local);
 	rx->local = NULL;
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 571436064cd6..68d269598305 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -80,8 +80,9 @@ struct rxrpc_net {
 	struct work_struct	client_conn_reaper;
 	struct timer_list	client_conn_reap_timer;
 
+	struct hlist_head	sockets;	/* List of sockets */
 	struct hlist_head	local_endpoints;
-	struct mutex		local_mutex;	/* Lock for ->local_endpoints */
+	struct mutex		local_mutex;	/* Lock for ->local_endpoints, ->sockets */
 
 	DECLARE_HASHTABLE	(peer_hash, 10);
 	spinlock_t		peer_hash_lock;	/* Lock for ->peer_hash */
@@ -130,6 +131,7 @@ struct rxrpc_sock {
 	struct list_head	sock_calls;	/* List of calls owned by this socket */
 	struct list_head	to_be_accepted;	/* calls awaiting acceptance */
 	struct list_head	recvmsg_q;	/* Calls awaiting recvmsg's attention  */
+	struct hlist_node	ns_link;	/* Link in net->sockets */
 	rwlock_t		recvmsg_lock;	/* Lock for recvmsg_q */
 	struct key		*key;		/* security for this socket */
 	struct key		*securities;	/* list of server security descriptors */
@@ -1008,6 +1010,7 @@ extern const struct seq_operations rxrpc_call_seq_ops;
 extern const struct seq_operations rxrpc_connection_seq_ops;
 extern const struct seq_operations rxrpc_peer_seq_ops;
 extern const struct seq_operations rxrpc_local_seq_ops;
+extern const struct seq_operations rxrpc_socket_seq_ops;
 
 /*
  * recvmsg.c
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index bb4c25d6df64..4107099a259c 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -72,6 +72,7 @@ static __net_init int rxrpc_init_net(struct net *net)
 	timer_setup(&rxnet->client_conn_reap_timer,
 		    rxrpc_client_conn_reap_timeout, 0);
 
+	INIT_HLIST_HEAD(&rxnet->sockets);
 	INIT_HLIST_HEAD(&rxnet->local_endpoints);
 	mutex_init(&rxnet->local_mutex);
 
@@ -101,6 +102,9 @@ static __net_init int rxrpc_init_net(struct net *net)
 	proc_create_net("locals", 0444, rxnet->proc_net,
 			&rxrpc_local_seq_ops,
 			sizeof(struct seq_net_private));
+	proc_create_net("sockets", 0444, rxnet->proc_net,
+			&rxrpc_socket_seq_ops,
+			sizeof(struct seq_net_private));
 	return 0;
 
 err_proc:
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 245418943e01..b92303012338 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -397,3 +397,95 @@ const struct seq_operations rxrpc_local_seq_ops = {
 	.stop   = rxrpc_local_seq_stop,
 	.show   = rxrpc_local_seq_show,
 };
+
+/*
+ * Generate a list of extant sockets in /proc/net/rxrpc/sockets
+ */
+static int rxrpc_socket_seq_show(struct seq_file *seq, void *v)
+{
+	struct rxrpc_local *local;
+	struct rxrpc_sock *rx;
+	struct list_head *p;
+	char lbuff[50];
+	unsigned int nr_calls = 0, nr_acc = 0, nr_attend = 0;
+
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(seq,
+			 "Proto Local                                          "
+			 " Use Svc1 Svc2 nCal nAcc nAtn\n");
+		return 0;
+	}
+
+	rx = hlist_entry(v, struct rxrpc_sock, ns_link);
+	local = rx->local;
+
+	if (local)
+		sprintf(lbuff, "%pISpc", &local->srx.transport);
+	else
+		sprintf(lbuff, "-");
+
+	read_lock(&rx->call_lock);
+	list_for_each(p, &rx->sock_calls) {
+		nr_calls++;
+	}
+	list_for_each(p, &rx->to_be_accepted) {
+		nr_acc++;
+	}
+	read_unlock(&rx->call_lock);
+
+	read_lock_bh(&rx->recvmsg_lock);
+	list_for_each(p, &rx->recvmsg_q) {
+		nr_attend++;
+	}
+	read_unlock_bh(&rx->recvmsg_lock);
+
+	seq_printf(seq,
+		   "UDP   %-47.47s %3d %4x %4x %4u %4u %4u\n",
+		   lbuff,
+		   refcount_read(&rx->sk.sk_refcnt),
+		   rx->srx.srx_service, rx->second_service,
+		   nr_calls, nr_acc, nr_attend);
+
+	return 0;
+}
+
+static void *rxrpc_socket_seq_start(struct seq_file *seq, loff_t *_pos)
+	__acquires(rcu)
+{
+	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
+	unsigned int n;
+
+	rcu_read_lock();
+
+	if (*_pos >= UINT_MAX)
+		return NULL;
+
+	n = *_pos;
+	if (n == 0)
+		return SEQ_START_TOKEN;
+
+	return seq_hlist_start_rcu(&rxnet->sockets, n - 1);
+}
+
+static void *rxrpc_socket_seq_next(struct seq_file *seq, void *v, loff_t *_pos)
+{
+	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
+
+	if (*_pos >= UINT_MAX)
+		return NULL;
+
+	return seq_hlist_next_rcu(v, &rxnet->sockets, _pos);
+}
+
+static void rxrpc_socket_seq_stop(struct seq_file *seq, void *v)
+	__releases(rcu)
+{
+	rcu_read_unlock();
+}
+
+const struct seq_operations rxrpc_socket_seq_ops = {
+	.start  = rxrpc_socket_seq_start,
+	.next   = rxrpc_socket_seq_next,
+	.stop   = rxrpc_socket_seq_stop,
+	.show   = rxrpc_socket_seq_show,
+};


