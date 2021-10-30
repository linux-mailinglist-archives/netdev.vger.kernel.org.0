Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF3D4408C9
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 14:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhJ3Mmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 08:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhJ3Mma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 08:42:30 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E26AC061714
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 05:40:00 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i5so8629364pla.5
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 05:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YbkHG+jWy8mr5rfy1igQyH4+KnOs2uZhJkGK97A47CM=;
        b=bsuGrw6AoHwJY9CRDsd4mSE2Q8Uih3Ys4+sPc6K80GaICyUeU1LT5nRcntukWY7ete
         wuEmenqZstruiLgMjUm1IwsdDqZI4fiBMLwsVgvrnGmTyUHB3Do1ySGHCg8XwXnrzOgn
         bZ5j2bGs6yJR4Qog1m9nqnGVQ+nQg85ACjl1HZ8YLrx1hnkkeaYMb3nzS8vFsCWoBxpM
         GG2cVMU5pZS/7sqsszf6J+yT/zTJngaegBh+a3koMbHN7JCFqMUjS5Hq3ER7z1vVU2KM
         X/6SpH8LCOsLndUQB3HNld4vRCzTU4Dt7mneKnfw5hGUw5FjGXSN6LWa7huGNJdPq3SM
         aqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YbkHG+jWy8mr5rfy1igQyH4+KnOs2uZhJkGK97A47CM=;
        b=Q5qTGWEy/DpF1sXb1KuxIBk2sDgH9wq5XoJf1HjGPaCKjLSi3uqCjypCPuR+lO+tbG
         y0CIi1CAIVYfLg91g7VAT6RQhoJY3uByUrJd6nMLUHrcOXg840eeG5Tbu7Aj/50mIgG/
         z18BM4gQMKDyX+94A7xmB8D2WhDL4jB4Kc5+QEaU4IQr8Ufgti3sEPZBLxEGOWk5yozT
         eSG57BHPZ/4iWfAwWWjWGn0KiRHkgAi7y0GZuLtagkEgKBAFEUt8oeKoykRgddAC9W0O
         pEudvIpXVFpnouRM5ybWytFkZJWqgLKYOhblBPU+tdEeVNSAimWqwNsCgdsD/Udiy0mX
         jA4Q==
X-Gm-Message-State: AOAM532lgssuskcHxbpUCkUwcMD2IVfh42aD6J/VzAduuQx107mofwyA
        a7GDX47JJj+TY11n1MgFl4M=
X-Google-Smtp-Source: ABdhPJyAUV1mFfsPuCK3mDgvb1nCsq9OwUUVL+DKPhg8PGxkOjBbH+WsUBNYf476XtxxB6wRcRCc1A==
X-Received: by 2002:a17:90b:4c4f:: with SMTP id np15mr24831172pjb.48.1635597599418;
        Sat, 30 Oct 2021 05:39:59 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k73sm7312664pgc.63.2021.10.30.05.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 05:39:58 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     dkirjanov@suse.de, ap420073@gmail.com
Subject: [PATCH net-next v5 3/5] amt: add multicast(IGMP) report message handler
Date:   Sat, 30 Oct 2021 12:39:19 +0000
Message-Id: <20211030123921.29672-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211030123921.29672-1-ap420073@gmail.com>
References: <20211030123921.29672-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

amt 'Relay' interface manages multicast groups(igmp/mld) and sources.
In order to manage, it should have the function to parse igmp/mld
report messages. So, this adds the logic for parsing igmp report messages
and saves them on their own data structure.

   struct amt_group_node means one group(igmp/mld).
   struct amt_source_node means one source.

The same source can't exist in the same group.
The same group can exist in the same tunnel because it manages
the host address too.

The group information is used when forwarding multicast data.
If there are no groups in the specific tunnel, Relay doesn't forward it.

Although Relay manages sources, it doesn't support the source filtering
feature. Because the reason to manage sources is just that in order
to manage group more correctly.

In the next patch, MLD part will be added.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - Eliminate sparse warnings.
   - Use bool type instead of __be16 for identifying v4/v6 protocol.

v2 -> v3:
 - Fix compile warning due to unsed variable.
 - Add missing spinlock comment.
 - Update help message of amt in Kconfig.

v3 -> v4:
 - Split patch.

v4 -> v5:
 - Refactoring.

 drivers/net/amt.c | 1132 ++++++++++++++++++++++++++++++++++++++++++++-
 include/net/amt.h |  104 ++++-
 2 files changed, 1234 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 54128314b015..1fbb1d3fd67d 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -31,6 +31,13 @@
 
 static struct workqueue_struct *amt_wq;
 
+static struct igmpv3_grec igmpv3_zero_grec;
+
+static HLIST_HEAD(source_gc_list);
+/* Lock for source_gc_list */
+static spinlock_t source_gc_lock;
+static struct delayed_work source_gc_wq;
+
 static char *status_str[] = {
 	"AMT_STATUS_INIT",
 	"AMT_STATUS_SENT_DISCOVERY",
@@ -55,6 +62,15 @@ static char *type_str[] = {
 	"AMT_MSG_TEARDOWM",
 };
 
+static char *action_str[] = {
+	"AMT_ACT_GMI",
+	"AMT_ACT_GMI_ZERO",
+	"AMT_ACT_GT",
+	"AMT_ACT_STATUS_FWD_NEW",
+	"AMT_ACT_STATUS_D_FWD_NEW",
+	"AMT_ACT_STATUS_NONE_NEW",
+};
+
 static struct amt_skb_cb *amt_skb_cb(struct sk_buff *skb)
 {
 	BUILD_BUG_ON(sizeof(struct amt_skb_cb) + sizeof(struct qdisc_skb_cb) >
@@ -64,6 +80,400 @@ static struct amt_skb_cb *amt_skb_cb(struct sk_buff *skb)
 		sizeof(struct qdisc_skb_cb));
 }
 
+static void __amt_source_gc_work(void)
+{
+	struct amt_source_node *snode;
+	struct hlist_head gc_list;
+	struct hlist_node *t;
+
+	spin_lock_bh(&source_gc_lock);
+	hlist_move_list(&source_gc_list, &gc_list);
+	spin_unlock_bh(&source_gc_lock);
+
+	hlist_for_each_entry_safe(snode, t, &gc_list, node) {
+		hlist_del_rcu(&snode->node);
+		kfree_rcu(snode, rcu);
+	}
+}
+
+static void amt_source_gc_work(struct work_struct *work)
+{
+	__amt_source_gc_work();
+
+	spin_lock_bh(&source_gc_lock);
+	mod_delayed_work(amt_wq, &source_gc_wq,
+			 msecs_to_jiffies(AMT_GC_INTERVAL));
+	spin_unlock_bh(&source_gc_lock);
+}
+
+static bool amt_addr_equal(union amt_addr *a, union amt_addr *b)
+{
+	return !memcmp(a, b, sizeof(union amt_addr));
+}
+
+static u32 amt_source_hash(struct amt_tunnel_list *tunnel, union amt_addr *src)
+{
+	u32 hash = jhash(src, sizeof(*src), tunnel->amt->hash_seed);
+
+	return reciprocal_scale(hash, tunnel->amt->hash_buckets);
+}
+
+static bool amt_status_filter(struct amt_source_node *snode,
+			      enum amt_filter filter)
+{
+	bool rc = false;
+
+	switch (filter) {
+	case AMT_FILTER_FWD:
+		if (snode->status == AMT_SOURCE_STATUS_FWD &&
+		    snode->flags == AMT_SOURCE_OLD)
+			rc = true;
+		break;
+	case AMT_FILTER_D_FWD:
+		if (snode->status == AMT_SOURCE_STATUS_D_FWD &&
+		    snode->flags == AMT_SOURCE_OLD)
+			rc = true;
+		break;
+	case AMT_FILTER_FWD_NEW:
+		if (snode->status == AMT_SOURCE_STATUS_FWD &&
+		    snode->flags == AMT_SOURCE_NEW)
+			rc = true;
+		break;
+	case AMT_FILTER_D_FWD_NEW:
+		if (snode->status == AMT_SOURCE_STATUS_D_FWD &&
+		    snode->flags == AMT_SOURCE_NEW)
+			rc = true;
+		break;
+	case AMT_FILTER_ALL:
+		rc = true;
+		break;
+	case AMT_FILTER_NONE_NEW:
+		if (snode->status == AMT_SOURCE_STATUS_NONE &&
+		    snode->flags == AMT_SOURCE_NEW)
+			rc = true;
+		break;
+	case AMT_FILTER_BOTH:
+		if ((snode->status == AMT_SOURCE_STATUS_D_FWD ||
+		     snode->status == AMT_SOURCE_STATUS_FWD) &&
+		    snode->flags == AMT_SOURCE_OLD)
+			rc = true;
+		break;
+	case AMT_FILTER_BOTH_NEW:
+		if ((snode->status == AMT_SOURCE_STATUS_D_FWD ||
+		     snode->status == AMT_SOURCE_STATUS_FWD) &&
+		    snode->flags == AMT_SOURCE_NEW)
+			rc = true;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	return rc;
+}
+
+static struct amt_source_node *amt_lookup_src(struct amt_tunnel_list *tunnel,
+					      struct amt_group_node *gnode,
+					      enum amt_filter filter,
+					      union amt_addr *src)
+{
+	u32 hash = amt_source_hash(tunnel, src);
+	struct amt_source_node *snode;
+
+	hlist_for_each_entry_rcu(snode, &gnode->sources[hash], node)
+		if (amt_status_filter(snode, filter) &&
+		    amt_addr_equal(&snode->source_addr, src))
+			return snode;
+
+	return NULL;
+}
+
+static u32 amt_group_hash(struct amt_tunnel_list *tunnel, union amt_addr *group)
+{
+	u32 hash = jhash(group, sizeof(*group), tunnel->amt->hash_seed);
+
+	return reciprocal_scale(hash, tunnel->amt->hash_buckets);
+}
+
+static struct amt_group_node *amt_lookup_group(struct amt_tunnel_list *tunnel,
+					       union amt_addr *group,
+					       union amt_addr *host,
+					       bool v6)
+{
+	u32 hash = amt_group_hash(tunnel, group);
+	struct amt_group_node *gnode;
+
+	hlist_for_each_entry_rcu(gnode, &tunnel->groups[hash], node) {
+		if (amt_addr_equal(&gnode->group_addr, group) &&
+		    amt_addr_equal(&gnode->host_addr, host) &&
+		    gnode->v6 == v6)
+			return gnode;
+	}
+
+	return NULL;
+}
+
+static void amt_destroy_source(struct amt_source_node *snode)
+{
+	struct amt_group_node *gnode = snode->gnode;
+	struct amt_tunnel_list *tunnel;
+
+	tunnel = gnode->tunnel_list;
+
+	if (!gnode->v6) {
+		netdev_dbg(snode->gnode->amt->dev,
+			   "Delete source %pI4 from %pI4\n",
+			   &snode->source_addr.ip4,
+			   &gnode->group_addr.ip4);
+	}
+
+	cancel_delayed_work(&snode->source_timer);
+	hlist_del_init_rcu(&snode->node);
+	tunnel->nr_sources--;
+	gnode->nr_sources--;
+	spin_lock_bh(&source_gc_lock);
+	hlist_add_head_rcu(&snode->node, &source_gc_list);
+	spin_unlock_bh(&source_gc_lock);
+}
+
+static void amt_del_group(struct amt_dev *amt, struct amt_group_node *gnode)
+{
+	struct amt_source_node *snode;
+	struct hlist_node *t;
+	int i;
+
+	if (cancel_delayed_work(&gnode->group_timer))
+		dev_put(amt->dev);
+	hlist_del_rcu(&gnode->node);
+	gnode->tunnel_list->nr_groups--;
+
+	if (!gnode->v6)
+		netdev_dbg(amt->dev, "Leave group %pI4\n",
+			   &gnode->group_addr.ip4);
+	for (i = 0; i < amt->hash_buckets; i++)
+		hlist_for_each_entry_safe(snode, t, &gnode->sources[i], node)
+			amt_destroy_source(snode);
+
+	/* tunnel->lock was acquired outside of amt_del_group()
+	 * But rcu_read_lock() was acquired too so It's safe.
+	 */
+	kfree_rcu(gnode, rcu);
+}
+
+/* If a source timer expires with a router filter-mode for the group of
+ * INCLUDE, the router concludes that traffic from this particular
+ * source is no longer desired on the attached network, and deletes the
+ * associated source record.
+ */
+static void amt_source_work(struct work_struct *work)
+{
+	struct amt_source_node *snode = container_of(to_delayed_work(work),
+						     struct amt_source_node,
+						     source_timer);
+	struct amt_group_node *gnode = snode->gnode;
+	struct amt_dev *amt = gnode->amt;
+	struct amt_tunnel_list *tunnel;
+
+	tunnel = gnode->tunnel_list;
+	spin_lock_bh(&tunnel->lock);
+	rcu_read_lock();
+	if (gnode->filter_mode == MCAST_INCLUDE) {
+		amt_destroy_source(snode);
+		if (!gnode->nr_sources)
+			amt_del_group(amt, gnode);
+	} else {
+		/* When a router filter-mode for a group is EXCLUDE,
+		 * source records are only deleted when the group timer expires
+		 */
+		snode->status = AMT_SOURCE_STATUS_D_FWD;
+	}
+	rcu_read_unlock();
+	spin_unlock_bh(&tunnel->lock);
+}
+
+static void amt_act_src(struct amt_tunnel_list *tunnel,
+			struct amt_group_node *gnode,
+			struct amt_source_node *snode,
+			enum amt_act act)
+{
+	struct amt_dev *amt = tunnel->amt;
+
+	switch (act) {
+	case AMT_ACT_GMI:
+		mod_delayed_work(amt_wq, &snode->source_timer,
+				 msecs_to_jiffies(amt_gmi(amt)));
+		break;
+	case AMT_ACT_GMI_ZERO:
+		cancel_delayed_work(&snode->source_timer);
+		break;
+	case AMT_ACT_GT:
+		mod_delayed_work(amt_wq, &snode->source_timer,
+				 gnode->group_timer.timer.expires);
+		break;
+	case AMT_ACT_STATUS_FWD_NEW:
+		snode->status = AMT_SOURCE_STATUS_FWD;
+		snode->flags = AMT_SOURCE_NEW;
+		break;
+	case AMT_ACT_STATUS_D_FWD_NEW:
+		snode->status = AMT_SOURCE_STATUS_D_FWD;
+		snode->flags = AMT_SOURCE_NEW;
+		break;
+	case AMT_ACT_STATUS_NONE_NEW:
+		cancel_delayed_work(&snode->source_timer);
+		snode->status = AMT_SOURCE_STATUS_NONE;
+		snode->flags = AMT_SOURCE_NEW;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	if (!gnode->v6)
+		netdev_dbg(amt->dev, "Source %pI4 from %pI4 Acted %s\n",
+			   &snode->source_addr.ip4,
+			   &gnode->group_addr.ip4,
+			   action_str[act]);
+}
+
+static struct amt_source_node *amt_alloc_snode(struct amt_group_node *gnode,
+					       union amt_addr *src)
+{
+	struct amt_source_node *snode;
+
+	snode = kzalloc(sizeof(*snode), GFP_ATOMIC);
+	if (!snode)
+		return NULL;
+
+	memcpy(&snode->source_addr, src, sizeof(union amt_addr));
+	snode->gnode = gnode;
+	snode->status = AMT_SOURCE_STATUS_NONE;
+	snode->flags = AMT_SOURCE_NEW;
+	INIT_HLIST_NODE(&snode->node);
+	INIT_DELAYED_WORK(&snode->source_timer, amt_source_work);
+
+	return snode;
+}
+
+/* RFC 3810 - 7.2.2.  Definition of Filter Timers
+ *
+ *  Router Mode          Filter Timer         Actions/Comments
+ *  -----------       -----------------       ----------------
+ *
+ *    INCLUDE             Not Used            All listeners in
+ *                                            INCLUDE mode.
+ *
+ *    EXCLUDE             Timer > 0           At least one listener
+ *                                            in EXCLUDE mode.
+ *
+ *    EXCLUDE             Timer == 0          No more listeners in
+ *                                            EXCLUDE mode for the
+ *                                            multicast address.
+ *                                            If the Requested List
+ *                                            is empty, delete
+ *                                            Multicast Address
+ *                                            Record.  If not, switch
+ *                                            to INCLUDE filter mode;
+ *                                            the sources in the
+ *                                            Requested List are
+ *                                            moved to the Include
+ *                                            List, and the Exclude
+ *                                            List is deleted.
+ */
+static void amt_group_work(struct work_struct *work)
+{
+	struct amt_group_node *gnode = container_of(to_delayed_work(work),
+						    struct amt_group_node,
+						    group_timer);
+	struct amt_tunnel_list *tunnel = gnode->tunnel_list;
+	struct amt_dev *amt = gnode->amt;
+	struct amt_source_node *snode;
+	bool delete_group = true;
+	struct hlist_node *t;
+	int i, buckets;
+
+	buckets = amt->hash_buckets;
+
+	spin_lock_bh(&tunnel->lock);
+	if (gnode->filter_mode == MCAST_INCLUDE) {
+		/* Not Used */
+		spin_unlock_bh(&tunnel->lock);
+		goto out;
+	}
+
+	rcu_read_lock();
+	for (i = 0; i < buckets; i++) {
+		hlist_for_each_entry_safe(snode, t,
+					  &gnode->sources[i], node) {
+			if (!delayed_work_pending(&snode->source_timer) ||
+			    snode->status == AMT_SOURCE_STATUS_D_FWD) {
+				amt_destroy_source(snode);
+			} else {
+				delete_group = false;
+				snode->status = AMT_SOURCE_STATUS_FWD;
+			}
+		}
+	}
+	if (delete_group)
+		amt_del_group(amt, gnode);
+	else
+		gnode->filter_mode = MCAST_INCLUDE;
+	rcu_read_unlock();
+	spin_unlock_bh(&tunnel->lock);
+out:
+	dev_put(amt->dev);
+}
+
+/* Non-existant group is created as INCLUDE {empty}:
+ *
+ * RFC 3376 - 5.1. Action on Change of Interface State
+ *
+ * If no interface state existed for that multicast address before
+ * the change (i.e., the change consisted of creating a new
+ * per-interface record), or if no state exists after the change
+ * (i.e., the change consisted of deleting a per-interface record),
+ * then the "non-existent" state is considered to have a filter mode
+ * of INCLUDE and an empty source list.
+ */
+static struct amt_group_node *amt_add_group(struct amt_dev *amt,
+					    struct amt_tunnel_list *tunnel,
+					    union amt_addr *group,
+					    union amt_addr *host,
+					    bool v6)
+{
+	struct amt_group_node *gnode;
+	u32 hash;
+	int i;
+
+	if (tunnel->nr_groups >= amt->max_groups)
+		return ERR_PTR(-ENOSPC);
+
+	gnode = kzalloc(sizeof(*gnode) +
+			(sizeof(struct hlist_head) * amt->hash_buckets),
+			GFP_ATOMIC);
+	if (unlikely(!gnode))
+		return ERR_PTR(-ENOMEM);
+
+	gnode->amt = amt;
+	gnode->group_addr = *group;
+	gnode->host_addr = *host;
+	gnode->v6 = v6;
+	gnode->tunnel_list = tunnel;
+	gnode->filter_mode = MCAST_INCLUDE;
+	INIT_HLIST_NODE(&gnode->node);
+	INIT_DELAYED_WORK(&gnode->group_timer, amt_group_work);
+	for (i = 0; i < amt->hash_buckets; i++)
+		INIT_HLIST_HEAD(&gnode->sources[i]);
+
+	hash = amt_group_hash(tunnel, group);
+	hlist_add_head_rcu(&gnode->node, &tunnel->groups[hash]);
+	tunnel->nr_groups++;
+
+	if (!gnode->v6)
+		netdev_dbg(amt->dev, "Join group %pI4\n",
+			   &gnode->group_addr.ip4);
+	return gnode;
+}
+
 static struct sk_buff *amt_build_igmp_gq(struct amt_dev *amt)
 {
 	u8 ra[AMT_IPHDR_OPTS] = { IPOPT_RA, 4, 0, 0 };
@@ -610,12 +1020,15 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct amt_dev *amt = netdev_priv(dev);
 	struct amt_tunnel_list *tunnel;
+	struct amt_group_node *gnode;
+	union amt_addr group = {0,};
 	bool report = false;
 	struct igmphdr *ih;
 	bool query = false;
 	struct iphdr *iph;
 	bool data = false;
 	bool v6 = false;
+	u32 hash;
 
 	iph = ip_hdr(skb);
 	if (iph->version == 4) {
@@ -639,6 +1052,7 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			data = true;
 		}
 		v6 = false;
+		group.ip4 = iph->daddr;
 	} else {
 		dev->stats.tx_errors++;
 		goto free;
@@ -674,8 +1088,18 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		if (!data)
 			goto free;
-		list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list)
+		list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list) {
+			hash = amt_group_hash(tunnel, &group);
+			hlist_for_each_entry_rcu(gnode, &tunnel->groups[hash],
+						 node) {
+				if (!v6)
+					if (gnode->group_addr.ip4 == iph->daddr)
+						goto found;
+			}
+			continue;
+found:;
 			amt_send_multicast_data(amt, skb, tunnel, v6);
+		}
 	}
 
 	dev_kfree_skb(skb);
@@ -705,6 +1129,22 @@ static int amt_parse_type(struct sk_buff *skb)
 	return amth->type;
 }
 
+static void amt_clear_groups(struct amt_tunnel_list *tunnel)
+{
+	struct amt_dev *amt = tunnel->amt;
+	struct amt_group_node *gnode;
+	struct hlist_node *t;
+	int i;
+
+	spin_lock_bh(&tunnel->lock);
+	rcu_read_lock();
+	for (i = 0; i < amt->hash_buckets; i++)
+		hlist_for_each_entry_safe(gnode, t, &tunnel->groups[i], node)
+			amt_del_group(amt, gnode);
+	rcu_read_unlock();
+	spin_unlock_bh(&tunnel->lock);
+}
+
 static void amt_tunnel_expire(struct work_struct *work)
 {
 	struct amt_tunnel_list *tunnel = container_of(to_delayed_work(work),
@@ -716,11 +1156,687 @@ static void amt_tunnel_expire(struct work_struct *work)
 	rcu_read_lock();
 	list_del_rcu(&tunnel->list);
 	amt->nr_tunnels--;
+	amt_clear_groups(tunnel);
 	rcu_read_unlock();
 	spin_unlock_bh(&amt->lock);
 	kfree_rcu(tunnel, rcu);
 }
 
+static void amt_cleanup_srcs(struct amt_dev *amt,
+			     struct amt_tunnel_list *tunnel,
+			     struct amt_group_node *gnode)
+{
+	struct amt_source_node *snode;
+	struct hlist_node *t;
+	int i;
+
+	/* Delete old sources */
+	for (i = 0; i < amt->hash_buckets; i++) {
+		hlist_for_each_entry_safe(snode, t, &gnode->sources[i], node) {
+			if (snode->flags == AMT_SOURCE_OLD)
+				amt_destroy_source(snode);
+		}
+	}
+
+	/* switch from new to old */
+	for (i = 0; i < amt->hash_buckets; i++)  {
+		hlist_for_each_entry_rcu(snode, &gnode->sources[i], node) {
+			snode->flags = AMT_SOURCE_OLD;
+			if (!gnode->v6)
+				netdev_dbg(snode->gnode->amt->dev,
+					   "Add source as OLD %pI4 from %pI4\n",
+					   &snode->source_addr.ip4,
+					   &gnode->group_addr.ip4);
+		}
+	}
+}
+
+static void amt_add_srcs(struct amt_dev *amt, struct amt_tunnel_list *tunnel,
+			 struct amt_group_node *gnode, void *grec,
+			 bool v6)
+{
+	struct igmpv3_grec *igmp_grec;
+	struct amt_source_node *snode;
+	union amt_addr src = {0,};
+	u16 nsrcs;
+	u32 hash;
+	int i;
+
+	if (!v6) {
+		igmp_grec = (struct igmpv3_grec *)grec;
+		nsrcs = ntohs(igmp_grec->grec_nsrcs);
+	} else {
+		return;
+	}
+	for (i = 0; i < nsrcs; i++) {
+		if (tunnel->nr_sources >= amt->max_sources)
+			return;
+		if (!v6)
+			src.ip4 = igmp_grec->grec_src[i];
+		if (amt_lookup_src(tunnel, gnode, AMT_FILTER_ALL, &src))
+			continue;
+
+		snode = amt_alloc_snode(gnode, &src);
+		if (snode) {
+			hash = amt_source_hash(tunnel, &snode->source_addr);
+			hlist_add_head_rcu(&snode->node, &gnode->sources[hash]);
+			tunnel->nr_sources++;
+			gnode->nr_sources++;
+
+			if (!gnode->v6)
+				netdev_dbg(snode->gnode->amt->dev,
+					   "Add source as NEW %pI4 from %pI4\n",
+					   &snode->source_addr.ip4,
+					   &gnode->group_addr.ip4);
+		}
+	}
+}
+
+/* Router State   Report Rec'd New Router State
+ * ------------   ------------ ----------------
+ * EXCLUDE (X,Y)  IS_IN (A)    EXCLUDE (X+A,Y-A)
+ *
+ * -----------+-----------+-----------+
+ *            |    OLD    |    NEW    |
+ * -----------+-----------+-----------+
+ *    FWD     |     X     |    X+A    |
+ * -----------+-----------+-----------+
+ *    D_FWD   |     Y     |    Y-A    |
+ * -----------+-----------+-----------+
+ *    NONE    |           |     A     |
+ * -----------+-----------+-----------+
+ *
+ * a) Received sources are NONE/NEW
+ * b) All NONE will be deleted by amt_cleanup_srcs().
+ * c) All OLD will be deleted by amt_cleanup_srcs().
+ * d) After delete, NEW source will be switched to OLD.
+ */
+static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
+				struct amt_group_node *gnode,
+				void *grec,
+				enum amt_ops ops,
+				enum amt_filter filter,
+				enum amt_act act,
+				bool v6)
+{
+	struct amt_dev *amt = tunnel->amt;
+	struct amt_source_node *snode;
+	struct igmpv3_grec *igmp_grec;
+	union amt_addr src = {0,};
+	struct hlist_node *t;
+	u16 nsrcs;
+	int i, j;
+
+	if (!v6) {
+		igmp_grec = (struct igmpv3_grec *)grec;
+		nsrcs = ntohs(igmp_grec->grec_nsrcs);
+	} else {
+		return;
+	}
+
+	memset(&src, 0, sizeof(union amt_addr));
+	switch (ops) {
+	case AMT_OPS_INT:
+		/* A*B */
+		for (i = 0; i < nsrcs; i++) {
+			if (!v6)
+				src.ip4 = igmp_grec->grec_src[i];
+			snode = amt_lookup_src(tunnel, gnode, filter, &src);
+			if (!snode)
+				continue;
+			amt_act_src(tunnel, gnode, snode, act);
+		}
+		break;
+	case AMT_OPS_UNI:
+		/* A+B */
+		for (i = 0; i < amt->hash_buckets; i++) {
+			hlist_for_each_entry_safe(snode, t, &gnode->sources[i],
+						  node) {
+				if (amt_status_filter(snode, filter))
+					amt_act_src(tunnel, gnode, snode, act);
+			}
+		}
+		for (i = 0; i < nsrcs; i++) {
+			if (!v6)
+				src.ip4 = igmp_grec->grec_src[i];
+			snode = amt_lookup_src(tunnel, gnode, filter, &src);
+			if (!snode)
+				continue;
+			amt_act_src(tunnel, gnode, snode, act);
+		}
+		break;
+	case AMT_OPS_SUB:
+		/* A-B */
+		for (i = 0; i < amt->hash_buckets; i++) {
+			hlist_for_each_entry_safe(snode, t, &gnode->sources[i],
+						  node) {
+				if (!amt_status_filter(snode, filter))
+					continue;
+				for (j = 0; j < nsrcs; j++) {
+					if (!v6)
+						src.ip4 = igmp_grec->grec_src[j];
+					if (amt_addr_equal(&snode->source_addr,
+							   &src))
+						goto out_sub;
+				}
+				amt_act_src(tunnel, gnode, snode, act);
+				continue;
+out_sub:;
+			}
+		}
+		break;
+	case AMT_OPS_SUB_REV:
+		/* B-A */
+		for (i = 0; i < nsrcs; i++) {
+			if (!v6)
+				src.ip4 = igmp_grec->grec_src[i];
+			snode = amt_lookup_src(tunnel, gnode, AMT_FILTER_ALL,
+					       &src);
+			if (!snode) {
+				snode = amt_lookup_src(tunnel, gnode,
+						       filter, &src);
+				if (snode)
+					amt_act_src(tunnel, gnode, snode, act);
+			}
+		}
+		break;
+	default:
+		netdev_dbg(amt->dev, "Invalid type\n");
+		return;
+	}
+}
+
+static void amt_mcast_is_in_handler(struct amt_dev *amt,
+				    struct amt_tunnel_list *tunnel,
+				    struct amt_group_node *gnode,
+				    void *grec, void *zero_grec, bool v6)
+{
+	if (gnode->filter_mode == MCAST_INCLUDE) {
+/* Router State   Report Rec'd New Router State        Actions
+ * ------------   ------------ ----------------        -------
+ * INCLUDE (A)    IS_IN (B)    INCLUDE (A+B)           (B)=GMI
+ */
+		/* Update IS_IN (B) as FWD/NEW */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_UNI,
+				    AMT_FILTER_NONE_NEW,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* Update INCLUDE (A) as NEW */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_UNI,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* (B)=GMI */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_INT,
+				    AMT_FILTER_FWD_NEW,
+				    AMT_ACT_GMI,
+				    v6);
+	} else {
+/* State        Actions
+ * ------------   ------------ ----------------        -------
+ * EXCLUDE (X,Y)  IS_IN (A)    EXCLUDE (X+A,Y-A)       (A)=GMI
+ */
+		/* Update (A) in (X, Y) as NONE/NEW */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_INT,
+				    AMT_FILTER_BOTH,
+				    AMT_ACT_STATUS_NONE_NEW,
+				    v6);
+		/* Update FWD/OLD as FWD/NEW */
+		amt_lookup_act_srcs(tunnel, gnode, zero_grec, AMT_OPS_UNI,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* Update IS_IN (A) as FWD/NEW */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_INT,
+				    AMT_FILTER_NONE_NEW,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* Update EXCLUDE (, Y-A) as D_FWD_NEW */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_SUB,
+				    AMT_FILTER_D_FWD,
+				    AMT_ACT_STATUS_D_FWD_NEW,
+				    v6);
+	}
+}
+
+static void amt_mcast_is_ex_handler(struct amt_dev *amt,
+				    struct amt_tunnel_list *tunnel,
+				    struct amt_group_node *gnode,
+				    void *grec, void *zero_grec, bool v6)
+{
+	if (gnode->filter_mode == MCAST_INCLUDE) {
+/* Router State   Report Rec'd  New Router State         Actions
+ * ------------   ------------  ----------------         -------
+ * INCLUDE (A)    IS_EX (B)     EXCLUDE (A*B,B-A)        (B-A)=0
+ *                                                       Delete (A-B)
+ *                                                       Group Timer=GMI
+ */
+		/* EXCLUDE(A*B, ) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_INT,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* EXCLUDE(, B-A) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_SUB_REV,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_D_FWD_NEW,
+				    v6);
+		/* (B-A)=0 */
+		amt_lookup_act_srcs(tunnel, gnode, zero_grec, AMT_OPS_UNI,
+				    AMT_FILTER_D_FWD_NEW,
+				    AMT_ACT_GMI_ZERO,
+				    v6);
+		/* Group Timer=GMI */
+		if (!mod_delayed_work(amt_wq, &gnode->group_timer,
+				      msecs_to_jiffies(amt_gmi(amt))))
+			dev_hold(amt->dev);
+		gnode->filter_mode = MCAST_EXCLUDE;
+		/* Delete (A-B) will be worked by amt_cleanup_srcs(). */
+	} else {
+/* Router State   Report Rec'd  New Router State	Actions
+ * ------------   ------------  ----------------	-------
+ * EXCLUDE (X,Y)  IS_EX (A)     EXCLUDE (A-Y,Y*A)	(A-X-Y)=GMI
+ *							Delete (X-A)
+ *							Delete (Y-A)
+ *							Group Timer=GMI
+ */
+		/* EXCLUDE (A-Y, ) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_SUB_REV,
+				    AMT_FILTER_D_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* EXCLUDE (, Y*A ) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_INT,
+				    AMT_FILTER_D_FWD,
+				    AMT_ACT_STATUS_D_FWD_NEW,
+				    v6);
+		/* (A-X-Y)=GMI */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_SUB_REV,
+				    AMT_FILTER_BOTH_NEW,
+				    AMT_ACT_GMI,
+				    v6);
+		/* Group Timer=GMI */
+		if (!mod_delayed_work(amt_wq, &gnode->group_timer,
+				      msecs_to_jiffies(amt_gmi(amt))))
+			dev_hold(amt->dev);
+		/* Delete (X-A), (Y-A) will be worked by amt_cleanup_srcs(). */
+	}
+}
+
+static void amt_mcast_to_in_handler(struct amt_dev *amt,
+				    struct amt_tunnel_list *tunnel,
+				    struct amt_group_node *gnode,
+				    void *grec, void *zero_grec, bool v6)
+{
+	if (gnode->filter_mode == MCAST_INCLUDE) {
+/* Router State   Report Rec'd New Router State        Actions
+ * ------------   ------------ ----------------        -------
+ * INCLUDE (A)    TO_IN (B)    INCLUDE (A+B)           (B)=GMI
+ *						       Send Q(G,A-B)
+ */
+		/* Update TO_IN (B) sources as FWD/NEW */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_UNI,
+				    AMT_FILTER_NONE_NEW,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* Update INCLUDE (A) sources as NEW */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_UNI,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* (B)=GMI */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_INT,
+				    AMT_FILTER_FWD_NEW,
+				    AMT_ACT_GMI,
+				    v6);
+	} else {
+/* Router State   Report Rec'd New Router State        Actions
+ * ------------   ------------ ----------------        -------
+ * EXCLUDE (X,Y)  TO_IN (A)    EXCLUDE (X+A,Y-A)       (A)=GMI
+ *						       Send Q(G,X-A)
+ *						       Send Q(G)
+ */
+		/* Update TO_IN (A) sources as FWD/NEW */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_UNI,
+				    AMT_FILTER_NONE_NEW,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* Update EXCLUDE(X,) sources as FWD/NEW */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_UNI,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* EXCLUDE (, Y-A)
+		 * (A) are already switched to FWD_NEW.
+		 * So, D_FWD/OLD -> D_FWD/NEW is okay.
+		 */
+		amt_lookup_act_srcs(tunnel, gnode, zero_grec, AMT_OPS_UNI,
+				    AMT_FILTER_D_FWD,
+				    AMT_ACT_STATUS_D_FWD_NEW,
+				    v6);
+		/* (A)=GMI
+		 * Only FWD_NEW will have (A) sources.
+		 */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_INT,
+				    AMT_FILTER_FWD_NEW,
+				    AMT_ACT_GMI,
+				    v6);
+	}
+}
+
+static void amt_mcast_to_ex_handler(struct amt_dev *amt,
+				    struct amt_tunnel_list *tunnel,
+				    struct amt_group_node *gnode,
+				    void *grec, void *zero_grec, bool v6)
+{
+	if (gnode->filter_mode == MCAST_INCLUDE) {
+/* Router State   Report Rec'd New Router State        Actions
+ * ------------   ------------ ----------------        -------
+ * INCLUDE (A)    TO_EX (B)    EXCLUDE (A*B,B-A)       (B-A)=0
+ *						       Delete (A-B)
+ *						       Send Q(G,A*B)
+ *						       Group Timer=GMI
+ */
+		/* EXCLUDE (A*B, ) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_INT,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* EXCLUDE (, B-A) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_SUB_REV,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_D_FWD_NEW,
+				    v6);
+		/* (B-A)=0 */
+		amt_lookup_act_srcs(tunnel, gnode, zero_grec, AMT_OPS_UNI,
+				    AMT_FILTER_D_FWD_NEW,
+				    AMT_ACT_GMI_ZERO,
+				    v6);
+		/* Group Timer=GMI */
+		if (!mod_delayed_work(amt_wq, &gnode->group_timer,
+				      msecs_to_jiffies(amt_gmi(amt))))
+			dev_hold(amt->dev);
+		gnode->filter_mode = MCAST_EXCLUDE;
+		/* Delete (A-B) will be worked by amt_cleanup_srcs(). */
+	} else {
+/* Router State   Report Rec'd New Router State        Actions
+ * ------------   ------------ ----------------        -------
+ * EXCLUDE (X,Y)  TO_EX (A)    EXCLUDE (A-Y,Y*A)       (A-X-Y)=Group Timer
+ *						       Delete (X-A)
+ *						       Delete (Y-A)
+ *						       Send Q(G,A-Y)
+ *						       Group Timer=GMI
+ */
+		/* Update (A-X-Y) as NONE/OLD */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_SUB_REV,
+				    AMT_FILTER_BOTH,
+				    AMT_ACT_GT,
+				    v6);
+		/* EXCLUDE (A-Y, ) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_SUB_REV,
+				    AMT_FILTER_D_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* EXCLUDE (, Y*A) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_INT,
+				    AMT_FILTER_D_FWD,
+				    AMT_ACT_STATUS_D_FWD_NEW,
+				    v6);
+		/* Group Timer=GMI */
+		if (!mod_delayed_work(amt_wq, &gnode->group_timer,
+				      msecs_to_jiffies(amt_gmi(amt))))
+			dev_hold(amt->dev);
+		/* Delete (X-A), (Y-A) will be worked by amt_cleanup_srcs(). */
+	}
+}
+
+static void amt_mcast_allow_handler(struct amt_dev *amt,
+				    struct amt_tunnel_list *tunnel,
+				    struct amt_group_node *gnode,
+				    void *grec, void *zero_grec, bool v6)
+{
+	if (gnode->filter_mode == MCAST_INCLUDE) {
+/* Router State   Report Rec'd New Router State        Actions
+ * ------------   ------------ ----------------        -------
+ * INCLUDE (A)    ALLOW (B)    INCLUDE (A+B)	       (B)=GMI
+ */
+		/* INCLUDE (A+B) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_UNI,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* (B)=GMI */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_INT,
+				    AMT_FILTER_FWD_NEW,
+				    AMT_ACT_GMI,
+				    v6);
+	} else {
+/* Router State   Report Rec'd New Router State        Actions
+ * ------------   ------------ ----------------        -------
+ * EXCLUDE (X,Y)  ALLOW (A)    EXCLUDE (X+A,Y-A)       (A)=GMI
+ */
+		/* EXCLUDE (X+A, ) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_UNI,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* EXCLUDE (, Y-A) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_SUB,
+				    AMT_FILTER_D_FWD,
+				    AMT_ACT_STATUS_D_FWD_NEW,
+				    v6);
+		/* (A)=GMI
+		 * All (A) source are now FWD/NEW status.
+		 */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_INT,
+				    AMT_FILTER_FWD_NEW,
+				    AMT_ACT_GMI,
+				    v6);
+	}
+}
+
+static void amt_mcast_block_handler(struct amt_dev *amt,
+				    struct amt_tunnel_list *tunnel,
+				    struct amt_group_node *gnode,
+				    void *grec, void *zero_grec, bool v6)
+{
+	if (gnode->filter_mode == MCAST_INCLUDE) {
+/* Router State   Report Rec'd New Router State        Actions
+ * ------------   ------------ ----------------        -------
+ * INCLUDE (A)    BLOCK (B)    INCLUDE (A)             Send Q(G,A*B)
+ */
+		/* INCLUDE (A) */
+		amt_lookup_act_srcs(tunnel, gnode, zero_grec, AMT_OPS_UNI,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+	} else {
+/* Router State   Report Rec'd New Router State        Actions
+ * ------------   ------------ ----------------        -------
+ * EXCLUDE (X,Y)  BLOCK (A)    EXCLUDE (X+(A-Y),Y)     (A-X-Y)=Group Timer
+ *						       Send Q(G,A-Y)
+ */
+		/* (A-X-Y)=Group Timer */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_SUB_REV,
+				    AMT_FILTER_BOTH,
+				    AMT_ACT_GT,
+				    v6);
+		/* EXCLUDE (X, ) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_UNI,
+				    AMT_FILTER_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* EXCLUDE (X+(A-Y) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_SUB_REV,
+				    AMT_FILTER_D_FWD,
+				    AMT_ACT_STATUS_FWD_NEW,
+				    v6);
+		/* EXCLUDE (, Y) */
+		amt_lookup_act_srcs(tunnel, gnode, grec, AMT_OPS_UNI,
+				    AMT_FILTER_D_FWD,
+				    AMT_ACT_STATUS_D_FWD_NEW,
+				    v6);
+	}
+}
+
+/* RFC 3376
+ * 7.3.2. In the Presence of Older Version Group Members
+ *
+ * When Group Compatibility Mode is IGMPv2, a router internally
+ * translates the following IGMPv2 messages for that group to their
+ * IGMPv3 equivalents:
+ *
+ * IGMPv2 Message                IGMPv3 Equivalent
+ * --------------                -----------------
+ * Report                        IS_EX( {} )
+ * Leave                         TO_IN( {} )
+ */
+static void amt_igmpv2_report_handler(struct amt_dev *amt, struct sk_buff *skb,
+				      struct amt_tunnel_list *tunnel)
+{
+	struct igmphdr *ih = igmp_hdr(skb);
+	struct iphdr *iph = ip_hdr(skb);
+	struct amt_group_node *gnode;
+	union amt_addr group, host;
+
+	memset(&group, 0, sizeof(union amt_addr));
+	group.ip4 = ih->group;
+	memset(&host, 0, sizeof(union amt_addr));
+	host.ip4 = iph->saddr;
+
+	gnode = amt_lookup_group(tunnel, &group, &host, false);
+	if (!gnode) {
+		gnode = amt_add_group(amt, tunnel, &group, &host, false);
+		if (!IS_ERR(gnode)) {
+			gnode->filter_mode = MCAST_EXCLUDE;
+			if (!mod_delayed_work(amt_wq, &gnode->group_timer,
+					      msecs_to_jiffies(amt_gmi(amt))))
+				dev_hold(amt->dev);
+		}
+	}
+}
+
+/* RFC 3376
+ * 7.3.2. In the Presence of Older Version Group Members
+ *
+ * When Group Compatibility Mode is IGMPv2, a router internally
+ * translates the following IGMPv2 messages for that group to their
+ * IGMPv3 equivalents:
+ *
+ * IGMPv2 Message                IGMPv3 Equivalent
+ * --------------                -----------------
+ * Report                        IS_EX( {} )
+ * Leave                         TO_IN( {} )
+ */
+static void amt_igmpv2_leave_handler(struct amt_dev *amt, struct sk_buff *skb,
+				     struct amt_tunnel_list *tunnel)
+{
+	struct igmphdr *ih = igmp_hdr(skb);
+	struct iphdr *iph = ip_hdr(skb);
+	struct amt_group_node *gnode;
+	union amt_addr group, host;
+
+	memset(&group, 0, sizeof(union amt_addr));
+	group.ip4 = ih->group;
+	memset(&host, 0, sizeof(union amt_addr));
+	host.ip4 = iph->saddr;
+
+	gnode = amt_lookup_group(tunnel, &group, &host, false);
+	if (gnode)
+		amt_del_group(amt, gnode);
+}
+
+static void amt_igmpv3_report_handler(struct amt_dev *amt, struct sk_buff *skb,
+				      struct amt_tunnel_list *tunnel)
+{
+	struct igmpv3_report *ihrv3 = igmpv3_report_hdr(skb);
+	int len = skb_transport_offset(skb) + sizeof(*ihrv3);
+	void *zero_grec = (void *)&igmpv3_zero_grec;
+	struct iphdr *iph = ip_hdr(skb);
+	struct amt_group_node *gnode;
+	union amt_addr group, host;
+	struct igmpv3_grec *grec;
+	u16 nsrcs;
+	int i;
+
+	for (i = 0; i < ntohs(ihrv3->ngrec); i++) {
+		len += sizeof(*grec);
+		if (!ip_mc_may_pull(skb, len))
+			break;
+
+		grec = (void *)(skb->data + len - sizeof(*grec));
+		nsrcs = ntohs(grec->grec_nsrcs);
+
+		len += nsrcs * sizeof(__be32);
+		if (!ip_mc_may_pull(skb, len))
+			break;
+
+		memset(&group, 0, sizeof(union amt_addr));
+		group.ip4 = grec->grec_mca;
+		memset(&host, 0, sizeof(union amt_addr));
+		host.ip4 = iph->saddr;
+		gnode = amt_lookup_group(tunnel, &group, &host, false);
+		if (!gnode) {
+			gnode = amt_add_group(amt, tunnel, &group, &host,
+					      false);
+			if (IS_ERR(gnode))
+				continue;
+		}
+
+		amt_add_srcs(amt, tunnel, gnode, grec, false);
+		switch (grec->grec_type) {
+		case IGMPV3_MODE_IS_INCLUDE:
+			amt_mcast_is_in_handler(amt, tunnel, gnode, grec,
+						zero_grec, false);
+			break;
+		case IGMPV3_MODE_IS_EXCLUDE:
+			amt_mcast_is_ex_handler(amt, tunnel, gnode, grec,
+						zero_grec, false);
+			break;
+		case IGMPV3_CHANGE_TO_INCLUDE:
+			amt_mcast_to_in_handler(amt, tunnel, gnode, grec,
+						zero_grec, false);
+			break;
+		case IGMPV3_CHANGE_TO_EXCLUDE:
+			amt_mcast_to_ex_handler(amt, tunnel, gnode, grec,
+						zero_grec, false);
+			break;
+		case IGMPV3_ALLOW_NEW_SOURCES:
+			amt_mcast_allow_handler(amt, tunnel, gnode, grec,
+						zero_grec, false);
+			break;
+		case IGMPV3_BLOCK_OLD_SOURCES:
+			amt_mcast_block_handler(amt, tunnel, gnode, grec,
+						zero_grec, false);
+			break;
+		default:
+			break;
+		}
+		amt_cleanup_srcs(amt, tunnel, gnode);
+	}
+}
+
+/* caller held tunnel->lock */
+static void amt_igmp_report_handler(struct amt_dev *amt, struct sk_buff *skb,
+				    struct amt_tunnel_list *tunnel)
+{
+	struct igmphdr *ih = igmp_hdr(skb);
+
+	switch (ih->type) {
+	case IGMPV3_HOST_MEMBERSHIP_REPORT:
+		amt_igmpv3_report_handler(amt, skb, tunnel);
+		break;
+	case IGMPV2_HOST_MEMBERSHIP_REPORT:
+		amt_igmpv2_report_handler(amt, skb, tunnel);
+		break;
+	case IGMP_HOST_LEAVE_MESSAGE:
+		amt_igmpv2_leave_handler(amt, skb, tunnel);
+		break;
+	default:
+		break;
+	}
+}
+
 static bool amt_advertisement_handler(struct amt_dev *amt, struct sk_buff *skb)
 {
 	struct amt_header_advertisement *amta;
@@ -904,6 +2020,10 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 			return true;
 		}
 
+		spin_lock_bh(&tunnel->lock);
+		amt_igmp_report_handler(amt, skb, tunnel);
+		spin_unlock_bh(&tunnel->lock);
+
 		skb_push(skb, sizeof(struct ethhdr));
 		skb_reset_mac_header(skb);
 		eth = eth_hdr(skb);
@@ -1334,6 +2454,7 @@ static int amt_dev_stop(struct net_device *dev)
 		list_del_rcu(&tunnel->list);
 		amt->nr_tunnels--;
 		cancel_delayed_work_sync(&tunnel->gc_wq);
+		amt_clear_groups(tunnel);
 		kfree_rcu(tunnel, rcu);
 	}
 
@@ -1703,6 +2824,13 @@ static int __init amt_init(void)
 	if (!amt_wq)
 		goto rtnl_unregister;
 
+	spin_lock_init(&source_gc_lock);
+	spin_lock_bh(&source_gc_lock);
+	INIT_DELAYED_WORK(&source_gc_wq, amt_source_gc_work);
+	mod_delayed_work(amt_wq, &source_gc_wq,
+			 msecs_to_jiffies(AMT_GC_INTERVAL));
+	spin_unlock_bh(&source_gc_lock);
+
 	return 0;
 
 rtnl_unregister:
@@ -1719,6 +2847,8 @@ static void __exit amt_fini(void)
 {
 	rtnl_link_unregister(&amt_link_ops);
 	unregister_netdevice_notifier(&amt_notifier_block);
+	flush_delayed_work(&source_gc_wq);
+	__amt_source_gc_work();
 	destroy_workqueue(amt_wq);
 }
 module_exit(amt_fini);
diff --git a/include/net/amt.h b/include/net/amt.h
index efa8ec98c72d..9581711b4d5c 100644
--- a/include/net/amt.h
+++ b/include/net/amt.h
@@ -22,6 +22,46 @@ enum amt_msg_type {
 
 #define AMT_MSG_MAX (__AMT_MSG_MAX - 1)
 
+enum amt_ops {
+	/* A*B */
+	AMT_OPS_INT,
+	/* A+B */
+	AMT_OPS_UNI,
+	/* A-B */
+	AMT_OPS_SUB,
+	/* B-A */
+	AMT_OPS_SUB_REV,
+	__AMT_OPS_MAX,
+};
+
+#define AMT_OPS_MAX (__AMT_OPS_MAX - 1)
+
+enum amt_filter {
+	AMT_FILTER_FWD,
+	AMT_FILTER_D_FWD,
+	AMT_FILTER_FWD_NEW,
+	AMT_FILTER_D_FWD_NEW,
+	AMT_FILTER_ALL,
+	AMT_FILTER_NONE_NEW,
+	AMT_FILTER_BOTH,
+	AMT_FILTER_BOTH_NEW,
+	__AMT_FILTER_MAX,
+};
+
+#define AMT_FILTER_MAX (__AMT_FILTER_MAX - 1)
+
+enum amt_act {
+	AMT_ACT_GMI,
+	AMT_ACT_GMI_ZERO,
+	AMT_ACT_GT,
+	AMT_ACT_STATUS_FWD_NEW,
+	AMT_ACT_STATUS_D_FWD_NEW,
+	AMT_ACT_STATUS_NONE_NEW,
+	__AMT_ACT_MAX,
+};
+
+#define AMT_ACT_MAX (__AMT_ACT_MAX - 1)
+
 enum amt_status {
 	AMT_STATUS_INIT,
 	AMT_STATUS_SENT_DISCOVERY,
@@ -153,6 +193,17 @@ struct amt_header_mcast_data {
 #endif
 } __packed;
 
+struct amt_headers {
+	union {
+		struct amt_header_discovery discovery;
+		struct amt_header_advertisement advertisement;
+		struct amt_header_request request;
+		struct amt_header_membership_query query;
+		struct amt_header_membership_update update;
+		struct amt_header_mcast_data data;
+	};
+} __packed;
+
 struct amt_gw_headers {
 	union {
 		struct amt_header_discovery discovery;
@@ -192,6 +243,56 @@ struct amt_tunnel_list {
 	struct hlist_head	groups[];
 };
 
+union amt_addr {
+	__be32			ip4;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct in6_addr		ip6;
+#endif
+};
+
+/* RFC 3810
+ *
+ * When the router is in EXCLUDE mode, the router state is represented
+ * by the notation EXCLUDE (X,Y), where X is called the "Requested List"
+ * and Y is called the "Exclude List".  All sources, except those from
+ * the Exclude List, will be forwarded by the router
+ */
+enum amt_source_status {
+	AMT_SOURCE_STATUS_NONE,
+	/* Node of Requested List */
+	AMT_SOURCE_STATUS_FWD,
+	/* Node of Exclude List */
+	AMT_SOURCE_STATUS_D_FWD,
+};
+
+/* protected by gnode->lock */
+struct amt_source_node {
+	struct hlist_node	node;
+	struct amt_group_node	*gnode;
+	struct delayed_work     source_timer;
+	union amt_addr		source_addr;
+	enum amt_source_status	status;
+#define AMT_SOURCE_OLD	0
+#define AMT_SOURCE_NEW	1
+	u8			flags;
+	struct rcu_head		rcu;
+};
+
+/* Protected by amt_tunnel_list->lock */
+struct amt_group_node {
+	struct amt_dev		*amt;
+	union amt_addr		group_addr;
+	union amt_addr		host_addr;
+	bool			v6;
+	u8			filter_mode;
+	u32			nr_sources;
+	struct amt_tunnel_list	*tunnel_list;
+	struct hlist_node	node;
+	struct delayed_work     group_timer;
+	struct rcu_head		rcu;
+	struct hlist_head	sources[];
+};
+
 struct amt_dev {
 	struct net_device       *dev;
 	struct net_device       *stream_dev;
@@ -247,8 +348,9 @@ struct amt_dev {
 				reserved:16;
 };
 
-#define AMT_TOS                 0xc0
+#define AMT_TOS			0xc0
 #define AMT_IPHDR_OPTS		4
+#define AMT_GC_INTERVAL		(30 * 1000)
 #define AMT_MAX_GROUP		32
 #define AMT_MAX_SOURCE		128
 #define AMT_HSIZE_SHIFT		8
-- 
2.17.1

