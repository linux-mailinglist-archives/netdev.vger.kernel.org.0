Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF3252F0FA
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351814AbiETQqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351816AbiETQqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:46:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F20E2EA14
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653065165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8tY2q7zn9VRWJYmO/jzh+mhL3v7V1mGbIaM8GBQpyXM=;
        b=gnPOufxYHO8wSAJlcGBTkt5Z8CieSjA6lHXZt50V4gYaeWswexPt+U2LZoMadWRuxg5548
        ID6CHntVoa/cBp2p2EmxDybzDgRwrMKtD7p4qAMv71GdcQc7ia7v5kkYuTOyU3GD71y3b6
        41PzqVW9C7SiCXJtXGAcUW6PAlDXVIw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-KHhhVru3OwCsl5Dc4OFBKw-1; Fri, 20 May 2022 12:46:02 -0400
X-MC-Unique: KHhhVru3OwCsl5Dc4OFBKw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A5F6101A52C;
        Fri, 20 May 2022 16:46:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 547387AE4;
        Fri, 20 May 2022 16:46:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 1/7] rxrpc: Allow list of in-use local UDP endpoints
 to be viewed in /proc
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 20 May 2022 17:46:00 +0100
Message-ID: <165306516064.34989.17925915798150710365.stgit@warthog.procyon.org.uk>
In-Reply-To: <165306515409.34989.4713077338482294594.stgit@warthog.procyon.org.uk>
References: <165306515409.34989.4713077338482294594.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the list of in-use local UDP endpoints in the current network
namespace to be viewed in /proc.

To aid with this, the endpoint list is converted to an hlist and RCU-safe
manipulation is used so that the list can be read with only the RCU
read lock held.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h  |    5 ++-
 net/rxrpc/local_object.c |   37 ++++++++++++-------------
 net/rxrpc/net_ns.c       |    5 +++
 net/rxrpc/proc.c         |   69 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 22 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 969e532f77a9..ac1f88a0e120 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -88,7 +88,7 @@ struct rxrpc_net {
 	struct work_struct	client_conn_reaper;
 	struct timer_list	client_conn_reap_timer;
 
-	struct list_head	local_endpoints;
+	struct hlist_head	local_endpoints;
 	struct mutex		local_mutex;	/* Lock for ->local_endpoints */
 
 	DECLARE_HASHTABLE	(peer_hash, 10);
@@ -281,7 +281,7 @@ struct rxrpc_local {
 	atomic_t		active_users;	/* Number of users of the local endpoint */
 	atomic_t		usage;		/* Number of references to the structure */
 	struct rxrpc_net	*rxnet;		/* The network ns in which this resides */
-	struct list_head	link;
+	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
 	struct work_struct	processor;
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
@@ -1014,6 +1014,7 @@ void rxrpc_put_peer_locked(struct rxrpc_peer *);
 extern const struct seq_operations rxrpc_call_seq_ops;
 extern const struct seq_operations rxrpc_connection_seq_ops;
 extern const struct seq_operations rxrpc_peer_seq_ops;
+extern const struct seq_operations rxrpc_local_seq_ops;
 
 /*
  * recvmsg.c
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 6a1611b0e303..ea6f338bd131 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -82,7 +82,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		atomic_set(&local->usage, 1);
 		atomic_set(&local->active_users, 1);
 		local->rxnet = rxnet;
-		INIT_LIST_HEAD(&local->link);
+		INIT_HLIST_NODE(&local->link);
 		INIT_WORK(&local->processor, rxrpc_local_processor);
 		init_rwsem(&local->defrag_sem);
 		skb_queue_head_init(&local->reject_queue);
@@ -180,7 +180,7 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 {
 	struct rxrpc_local *local;
 	struct rxrpc_net *rxnet = rxrpc_net(net);
-	struct list_head *cursor;
+	struct hlist_node *cursor;
 	const char *age;
 	long diff;
 	int ret;
@@ -190,16 +190,12 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 
 	mutex_lock(&rxnet->local_mutex);
 
-	for (cursor = rxnet->local_endpoints.next;
-	     cursor != &rxnet->local_endpoints;
-	     cursor = cursor->next) {
-		local = list_entry(cursor, struct rxrpc_local, link);
+	hlist_for_each(cursor, &rxnet->local_endpoints) {
+		local = hlist_entry(cursor, struct rxrpc_local, link);
 
 		diff = rxrpc_local_cmp_key(local, srx);
-		if (diff < 0)
+		if (diff != 0)
 			continue;
-		if (diff > 0)
-			break;
 
 		/* Services aren't allowed to share transport sockets, so
 		 * reject that here.  It is possible that the object is dying -
@@ -211,9 +207,10 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 			goto addr_in_use;
 		}
 
-		/* Found a match.  We replace a dying object.  Attempting to
-		 * bind the transport socket may still fail if we're attempting
-		 * to use a local address that the dying object is still using.
+		/* Found a match.  We want to replace a dying object.
+		 * Attempting to bind the transport socket may still fail if
+		 * we're attempting to use a local address that the dying
+		 * object is still using.
 		 */
 		if (!rxrpc_use_local(local))
 			break;
@@ -230,10 +227,12 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 	if (ret < 0)
 		goto sock_error;
 
-	if (cursor != &rxnet->local_endpoints)
-		list_replace_init(cursor, &local->link);
-	else
-		list_add_tail(&local->link, cursor);
+	if (cursor) {
+		hlist_replace_rcu(cursor, &local->link);
+		cursor->pprev = NULL;
+	} else {
+		hlist_add_head_rcu(&local->link, &rxnet->local_endpoints);
+	}
 	age = "new";
 
 found:
@@ -374,7 +373,7 @@ static void rxrpc_local_destroyer(struct rxrpc_local *local)
 	local->dead = true;
 
 	mutex_lock(&rxnet->local_mutex);
-	list_del_init(&local->link);
+	hlist_del_init_rcu(&local->link);
 	mutex_unlock(&rxnet->local_mutex);
 
 	rxrpc_clean_up_local_conns(local);
@@ -458,9 +457,9 @@ void rxrpc_destroy_all_locals(struct rxrpc_net *rxnet)
 
 	flush_workqueue(rxrpc_workqueue);
 
-	if (!list_empty(&rxnet->local_endpoints)) {
+	if (!hlist_empty(&rxnet->local_endpoints)) {
 		mutex_lock(&rxnet->local_mutex);
-		list_for_each_entry(local, &rxnet->local_endpoints, link) {
+		hlist_for_each_entry(local, &rxnet->local_endpoints, link) {
 			pr_err("AF_RXRPC: Leaked local %p {%d}\n",
 			       local, atomic_read(&local->usage));
 		}
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index cc7e30733feb..34f389975a7d 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -72,7 +72,7 @@ static __net_init int rxrpc_init_net(struct net *net)
 	timer_setup(&rxnet->client_conn_reap_timer,
 		    rxrpc_client_conn_reap_timeout, 0);
 
-	INIT_LIST_HEAD(&rxnet->local_endpoints);
+	INIT_HLIST_HEAD(&rxnet->local_endpoints);
 	mutex_init(&rxnet->local_mutex);
 
 	hash_init(rxnet->peer_hash);
@@ -98,6 +98,9 @@ static __net_init int rxrpc_init_net(struct net *net)
 	proc_create_net("peers", 0444, rxnet->proc_net,
 			&rxrpc_peer_seq_ops,
 			sizeof(struct seq_net_private));
+	proc_create_net("locals", 0444, rxnet->proc_net,
+			&rxrpc_local_seq_ops,
+			sizeof(struct seq_net_private));
 	return 0;
 
 err_proc:
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index e2f990754f88..8a8f776f91ae 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -334,3 +334,72 @@ const struct seq_operations rxrpc_peer_seq_ops = {
 	.stop   = rxrpc_peer_seq_stop,
 	.show   = rxrpc_peer_seq_show,
 };
+
+/*
+ * Generate a list of extant virtual local endpoints in /proc/net/rxrpc/locals
+ */
+static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
+{
+	struct rxrpc_local *local;
+	char lbuff[50];
+
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(seq,
+			 "Proto Local                                          "
+			 " Use Act\n");
+		return 0;
+	}
+
+	local = hlist_entry(v, struct rxrpc_local, link);
+
+	sprintf(lbuff, "%pISpc", &local->srx.transport);
+
+	seq_printf(seq,
+		   "UDP   %-47.47s %3u %3u\n",
+		   lbuff,
+		   atomic_read(&local->usage),
+		   atomic_read(&local->active_users));
+
+	return 0;
+}
+
+static void *rxrpc_local_seq_start(struct seq_file *seq, loff_t *_pos)
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
+	return seq_hlist_start_rcu(&rxnet->local_endpoints, n - 1);
+}
+
+static void *rxrpc_local_seq_next(struct seq_file *seq, void *v, loff_t *_pos)
+{
+	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
+
+	if (*_pos >= UINT_MAX)
+		return NULL;
+
+	return seq_hlist_next_rcu(v, &rxnet->local_endpoints, _pos);
+}
+
+static void rxrpc_local_seq_stop(struct seq_file *seq, void *v)
+	__releases(rcu)
+{
+	rcu_read_unlock();
+}
+
+const struct seq_operations rxrpc_local_seq_ops = {
+	.start  = rxrpc_local_seq_start,
+	.next   = rxrpc_local_seq_next,
+	.stop   = rxrpc_local_seq_stop,
+	.show   = rxrpc_local_seq_show,
+};


