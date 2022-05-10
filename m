Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C1A521553
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241760AbiEJM2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241686AbiEJMZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:25:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD16F9BAFD;
        Tue, 10 May 2022 05:22:01 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 11/17] netfilter: conntrack: add nf_ct_iter_data object for nf_ct_iterate_cleanup*()
Date:   Tue, 10 May 2022 14:21:44 +0200
Message-Id: <20220510122150.92533-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220510122150.92533-1-pablo@netfilter.org>
References: <20220510122150.92533-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a structure to collect all the context data that is
passed to the cleanup iterator.

 struct nf_ct_iter_data {
       struct net *net;
       void *data;
       u32 portid;
       int report;
 };

There is a netns field that allows to clean up conntrack entries
specifically owned by the specified netns.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h | 12 ++++--
 net/netfilter/nf_conntrack_core.c    | 56 +++++++++++-----------------
 net/netfilter/nf_conntrack_netlink.c | 10 ++++-
 net/netfilter/nf_conntrack_proto.c   | 10 +++--
 net/netfilter/nf_conntrack_timeout.c |  7 +++-
 net/netfilter/nf_nat_masquerade.c    |  5 ++-
 6 files changed, 56 insertions(+), 44 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 3ce9a5b42fe5..a32be8aa7ed2 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -236,10 +236,16 @@ static inline bool nf_ct_kill(struct nf_conn *ct)
 	return nf_ct_delete(ct, 0, 0);
 }
 
+struct nf_ct_iter_data {
+	struct net *net;
+	void *data;
+	u32 portid;
+	int report;
+};
+
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
-void nf_ct_iterate_cleanup_net(struct net *net,
-			       int (*iter)(struct nf_conn *i, void *data),
-			       void *data, u32 portid, int report);
+void nf_ct_iterate_cleanup_net(int (*iter)(struct nf_conn *i, void *data),
+			       const struct nf_ct_iter_data *iter_data);
 
 /* also set unconfirmed conntracks as dying. Only use in module exit path. */
 void nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data),
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 6e59a35a29b9..d3ffdfbe4dd9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2338,7 +2338,7 @@ static bool nf_conntrack_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
 /* Bring out ya dead! */
 static struct nf_conn *
 get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
-		void *data, unsigned int *bucket)
+		const struct nf_ct_iter_data *iter_data, unsigned int *bucket)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
@@ -2369,7 +2369,12 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 			 * tuple while iterating.
 			 */
 			ct = nf_ct_tuplehash_to_ctrack(h);
-			if (iter(ct, data))
+
+			if (iter_data->net &&
+			    !net_eq(iter_data->net, nf_ct_net(ct)))
+				continue;
+
+			if (iter(ct, iter_data->data))
 				goto found;
 		}
 		spin_unlock(lockp);
@@ -2386,7 +2391,7 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 }
 
 static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
-				  void *data, u32 portid, int report)
+				  const struct nf_ct_iter_data *iter_data)
 {
 	unsigned int bucket = 0;
 	struct nf_conn *ct;
@@ -2394,49 +2399,28 @@ static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
 	might_sleep();
 
 	mutex_lock(&nf_conntrack_mutex);
-	while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
+	while ((ct = get_next_corpse(iter, iter_data, &bucket)) != NULL) {
 		/* Time to push up daises... */
 
-		nf_ct_delete(ct, portid, report);
+		nf_ct_delete(ct, iter_data->portid, iter_data->report);
 		nf_ct_put(ct);
 		cond_resched();
 	}
 	mutex_unlock(&nf_conntrack_mutex);
 }
 
-struct iter_data {
-	int (*iter)(struct nf_conn *i, void *data);
-	void *data;
-	struct net *net;
-};
-
-static int iter_net_only(struct nf_conn *i, void *data)
-{
-	struct iter_data *d = data;
-
-	if (!net_eq(d->net, nf_ct_net(i)))
-		return 0;
-
-	return d->iter(i, d->data);
-}
-
-void nf_ct_iterate_cleanup_net(struct net *net,
-			       int (*iter)(struct nf_conn *i, void *data),
-			       void *data, u32 portid, int report)
+void nf_ct_iterate_cleanup_net(int (*iter)(struct nf_conn *i, void *data),
+			       const struct nf_ct_iter_data *iter_data)
 {
+	struct net *net = iter_data->net;
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-	struct iter_data d;
 
 	might_sleep();
 
 	if (atomic_read(&cnet->count) == 0)
 		return;
 
-	d.iter = iter;
-	d.data = data;
-	d.net = net;
-
-	nf_ct_iterate_cleanup(iter_net_only, &d, portid, report);
+	nf_ct_iterate_cleanup(iter, iter_data);
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup_net);
 
@@ -2454,6 +2438,7 @@ EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup_net);
 void
 nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 {
+	struct nf_ct_iter_data iter_data = {};
 	struct net *net;
 
 	down_read(&net_rwsem);
@@ -2481,7 +2466,8 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 	synchronize_net();
 
 	nf_ct_ext_bump_genid();
-	nf_ct_iterate_cleanup(iter, data, 0, 0);
+	iter_data.data = data;
+	nf_ct_iterate_cleanup(iter, &iter_data);
 
 	/* Another cpu might be in a rcu read section with
 	 * rcu protected pointer cleared in iter callback
@@ -2495,7 +2481,7 @@ EXPORT_SYMBOL_GPL(nf_ct_iterate_destroy);
 
 static int kill_all(struct nf_conn *i, void *data)
 {
-	return net_eq(nf_ct_net(i), data);
+	return 1;
 }
 
 void nf_conntrack_cleanup_start(void)
@@ -2530,8 +2516,9 @@ void nf_conntrack_cleanup_net(struct net *net)
 
 void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 {
-	int busy;
+	struct nf_ct_iter_data iter_data = {};
 	struct net *net;
+	int busy;
 
 	/*
 	 * This makes sure all current packets have passed through
@@ -2544,7 +2531,8 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
-		nf_ct_iterate_cleanup(kill_all, net, 0, 0);
+		iter_data.net = net;
+		nf_ct_iterate_cleanup_net(kill_all, &iter_data);
 		if (atomic_read(&cnet->count) != 0)
 			busy = 1;
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index eafe640b3387..e768f59741a6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1559,6 +1559,11 @@ static int ctnetlink_flush_conntrack(struct net *net,
 				     u32 portid, int report, u8 family)
 {
 	struct ctnetlink_filter *filter = NULL;
+	struct nf_ct_iter_data iter = {
+		.net		= net,
+		.portid		= portid,
+		.report		= report,
+	};
 
 	if (ctnetlink_needs_filter(family, cda)) {
 		if (cda[CTA_FILTER])
@@ -1567,10 +1572,11 @@ static int ctnetlink_flush_conntrack(struct net *net,
 		filter = ctnetlink_alloc_filter(cda, family);
 		if (IS_ERR(filter))
 			return PTR_ERR(filter);
+
+		iter.data = filter;
 	}
 
-	nf_ct_iterate_cleanup_net(net, ctnetlink_flush_iterate, filter,
-				  portid, report);
+	nf_ct_iterate_cleanup_net(ctnetlink_flush_iterate, &iter);
 	kfree(filter);
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index d1f2d3c8d2b1..895b09cbd7cf 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -538,9 +538,13 @@ static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
  out_unlock:
 	mutex_unlock(&nf_ct_proto_mutex);
 
-	if (fixup_needed)
-		nf_ct_iterate_cleanup_net(net, nf_ct_tcp_fixup,
-					  (void *)(unsigned long)nfproto, 0, 0);
+	if (fixup_needed) {
+		struct nf_ct_iter_data iter_data = {
+			.net	= net,
+			.data	= (void *)(unsigned long)nfproto,
+		};
+		nf_ct_iterate_cleanup_net(nf_ct_tcp_fixup, &iter_data);
+	}
 
 	return err;
 }
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index cec166ecba77..0f828d05ea60 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -38,7 +38,12 @@ static int untimeout(struct nf_conn *ct, void *timeout)
 
 void nf_ct_untimeout(struct net *net, struct nf_ct_timeout *timeout)
 {
-	nf_ct_iterate_cleanup_net(net, untimeout, timeout, 0, 0);
+	struct nf_ct_iter_data iter_data = {
+		.net	= net,
+		.data	= timeout,
+	};
+
+	nf_ct_iterate_cleanup_net(untimeout, &iter_data);
 }
 EXPORT_SYMBOL_GPL(nf_ct_untimeout);
 
diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index e32fac374608..1a506b0c6511 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -77,11 +77,14 @@ EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4);
 
 static void iterate_cleanup_work(struct work_struct *work)
 {
+	struct nf_ct_iter_data iter_data = {};
 	struct masq_dev_work *w;
 
 	w = container_of(work, struct masq_dev_work, work);
 
-	nf_ct_iterate_cleanup_net(w->net, w->iter, (void *)w, 0, 0);
+	iter_data.net = w->net;
+	iter_data.data = (void *)w;
+	nf_ct_iterate_cleanup_net(w->iter, &iter_data);
 
 	put_net_track(w->net, &w->ns_tracker);
 	kfree(w);
-- 
2.30.2

