Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03C996C4C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731124AbfHTWdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37026 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731059AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2NZNW7Fy8k5K4XtJRjaafLU/dV4S5mZFuLucCgRMnqY=; b=J/Lav1bDj8uBH5UaEj05ORjcq3
        IUay/1EYccRoCmPLFq5qE8wCLijqXrrBUFLWZN7QY+Zlb4eThHGKZOsrQr2wf7xz+/llaS8x1A737
        lFk/k/DacWPhHMc0wNrgBMwT9DCKPINN4MpJb7Ef2X/mOyzqF1M5UCXqA1UEykGfXQ4AXCbQtGMyp
        UNVYwZrII5kHB81RvXPMMYsJkByd58U5ucI9vq5N07VpwtggQDGNN0dhEtxwnCz75rYlCepkEMMOU
        j4hxtxf9O1AAgcGxIQo6ELaTRfvs1j4lu1F8xW6q6Rfi/R8Jx6UvQYJj9UD/51wA9hyfu9Bwzy83n
        0VY80HVg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005so-GQ; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 34/38] net_namespace: Convert netns_ids to XArray
Date:   Tue, 20 Aug 2019 15:32:55 -0700
Message-Id: <20190820223259.22348-35-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

This is a straightforward conversion; it should be possible to eliminate
nsid_lock as it seems to only be used to protect netns_ids.  The tricky
part is that dropping the lock (eg to allocate memory) could end up
allowing two networks which are equal to each other being allocated.
So stick with the GFP_ATOMIC allocations and double locking until
someone who's more savvy wants to try their hand at eliminating it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/net_namespace.h |  2 +-
 net/core/net_namespace.c    | 65 +++++++++++++++++--------------------
 2 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 4a9da951a794..6c80cadc6396 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -78,7 +78,7 @@ struct net {
 	struct user_namespace   *user_ns;	/* Owning user namespace */
 	struct ucounts		*ucounts;
 	spinlock_t		nsid_lock;
-	struct idr		netns_ids;
+	struct xarray		netns_ids;
 
 	struct ns_common	ns;
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a0e0d298c991..c9b16e1b4a7e 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -188,27 +188,18 @@ static void ops_free_list(const struct pernet_operations *ops,
 /* should be called with nsid_lock held */
 static int alloc_netid(struct net *net, struct net *peer, int reqid)
 {
-	int min = 0, max = 0;
+	int ret;
 
 	if (reqid >= 0) {
-		min = reqid;
-		max = reqid + 1;
+		ret = xa_insert(&net->netns_ids, reqid, peer, GFP_ATOMIC);
+	} else {
+		ret = xa_alloc(&net->netns_ids, &reqid, peer, xa_limit_31b,
+				GFP_ATOMIC);
 	}
 
-	return idr_alloc(&net->netns_ids, peer, min, max, GFP_ATOMIC);
-}
-
-/* This function is used by idr_for_each(). If net is equal to peer, the
- * function returns the id so that idr_for_each() stops. Because we cannot
- * returns the id 0 (idr_for_each() will not stop), we return the magic value
- * NET_ID_ZERO (-1) for it.
- */
-#define NET_ID_ZERO -1
-static int net_eq_idr(int id, void *net, void *peer)
-{
-	if (net_eq(net, peer))
-		return id ? : NET_ID_ZERO;
-	return 0;
+	if (ret)
+		return ret;
+	return reqid;
 }
 
 /* Should be called with nsid_lock held. If a new id is assigned, the bool alloc
@@ -217,16 +208,17 @@ static int net_eq_idr(int id, void *net, void *peer)
  */
 static int __peernet2id_alloc(struct net *net, struct net *peer, bool *alloc)
 {
-	int id = idr_for_each(&net->netns_ids, net_eq_idr, peer);
+	int id;
+	struct net *tmp;
+	unsigned long index;
 	bool alloc_it = *alloc;
 
-	*alloc = false;
-
-	/* Magic value for id 0. */
-	if (id == NET_ID_ZERO)
-		return 0;
-	if (id > 0)
-		return id;
+	xa_for_each(&net->netns_ids, index, tmp) {
+		if (net_eq(tmp, peer)) {
+			*alloc = false;
+			return index;
+		}
+	}
 
 	if (alloc_it) {
 		id = alloc_netid(net, peer, -1);
@@ -261,7 +253,7 @@ int peernet2id_alloc(struct net *net, struct net *peer)
 	 * When peer is obtained from RCU lists, we may race with
 	 * its cleanup. Check whether it's alive, and this guarantees
 	 * we never hash a peer back to net->netns_ids, after it has
-	 * just been idr_remove()'d from there in cleanup_net().
+	 * just been removed from there in cleanup_net().
 	 */
 	if (maybe_get_net(peer))
 		alive = alloc = true;
@@ -303,7 +295,7 @@ struct net *get_net_ns_by_id(struct net *net, int id)
 		return NULL;
 
 	rcu_read_lock();
-	peer = idr_find(&net->netns_ids, id);
+	peer = xa_load(&net->netns_ids, id);
 	if (peer)
 		peer = maybe_get_net(peer);
 	rcu_read_unlock();
@@ -326,7 +318,7 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 	get_random_bytes(&net->hash_mix, sizeof(u32));
 	net->dev_base_seq = 1;
 	net->user_ns = user_ns;
-	idr_init(&net->netns_ids);
+	xa_init_flags(&net->netns_ids, XA_FLAGS_ALLOC);
 	spin_lock_init(&net->nsid_lock);
 	mutex_init(&net->ipv4.ra_mutex);
 
@@ -529,16 +521,14 @@ static void unhash_nsid(struct net *net, struct net *last)
 		spin_lock_bh(&tmp->nsid_lock);
 		id = __peernet2id(tmp, net);
 		if (id >= 0)
-			idr_remove(&tmp->netns_ids, id);
+			xa_erase(&tmp->netns_ids, id);
 		spin_unlock_bh(&tmp->nsid_lock);
 		if (id >= 0)
 			rtnl_net_notifyid(tmp, RTM_DELNSID, id);
 		if (tmp == last)
 			break;
 	}
-	spin_lock_bh(&net->nsid_lock);
-	idr_destroy(&net->netns_ids);
-	spin_unlock_bh(&net->nsid_lock);
+	BUG_ON(!xa_empty(&net->netns_ids));
 }
 
 static LLIST_HEAD(cleanup_list);
@@ -766,7 +756,7 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err >= 0) {
 		rtnl_net_notifyid(net, RTM_NEWNSID, err);
 		err = 0;
-	} else if (err == -ENOSPC && nsid >= 0) {
+	} else if (err == -EBUSY && nsid >= 0) {
 		err = -EEXIST;
 		NL_SET_BAD_ATTR(extack, tb[NETNSA_NSID]);
 		NL_SET_ERR_MSG(extack, "The specified nsid is already used");
@@ -946,9 +936,9 @@ struct rtnl_net_dump_cb {
 	int s_idx;
 };
 
-static int rtnl_net_dumpid_one(int id, void *peer, void *data)
+static int rtnl_net_dumpid_one(int id, struct net *peer,
+		struct rtnl_net_dump_cb *net_cb)
 {
-	struct rtnl_net_dump_cb *net_cb = (struct rtnl_net_dump_cb *)data;
 	int ret;
 
 	if (net_cb->idx < net_cb->s_idx)
@@ -1022,6 +1012,8 @@ static int rtnl_net_dumpid(struct sk_buff *skb, struct netlink_callback *cb)
 		.idx = 0,
 		.s_idx = cb->args[0],
 	};
+	struct net *peer;
+	unsigned long index;
 	int err = 0;
 
 	if (cb->strict_check) {
@@ -1038,7 +1030,8 @@ static int rtnl_net_dumpid(struct sk_buff *skb, struct netlink_callback *cb)
 		err = -EAGAIN;
 		goto end;
 	}
-	idr_for_each(&net_cb.tgt_net->netns_ids, rtnl_net_dumpid_one, &net_cb);
+	xa_for_each(&net_cb.tgt_net->netns_ids, index, peer)
+		rtnl_net_dumpid_one(index, peer, &net_cb);
 	if (net_cb.fillargs.add_ref &&
 	    !net_eq(net_cb.ref_net, net_cb.tgt_net))
 		spin_unlock_bh(&net_cb.ref_net->nsid_lock);
-- 
2.23.0.rc1

