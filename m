Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6669130B105
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhBAT6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:58:15 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:42425 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232626AbhBATtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:49:52 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7DA2F580508;
        Mon,  1 Feb 2021 14:48:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Feb 2021 14:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=EoRTweBmHMtEPOISSYlh+0N+awSDk4O0htJH2VRUa7Q=; b=fkLd6j18
        Woc0hxbX+CZR3liiq2lrfgrwE11mA8LJjAbTlXHI6YRg57MPUp3JWWzgNJQSu4Ak
        nUtIL/54QjI0DUJ9bxGZaFy5JEG2DV8JTS6VXYQTDHahmeJpaU9X3R7YvQOkQAga
        XVURoneMVcm/DWlTKx2eFDWiY6XMUaYI4tfqW7YiFQrrkaQ1dNUdGOQrvHA9UaCk
        kDQWAGXLqhhCpVu1CXQEiX928BJ6SlpvFOXX/3zC2erYZO/m6TCbLPuvpgE26fB6
        i5AeK1+0KIVb+pTm6LnlAihDWyPAnFRdsp76IYxIZRYgVAU/SPNP/bXlNu1DY2xQ
        FJCRfCIWDlaR6g==
X-ME-Sender: <xms:HFsYYN0Ef79FPMzHq5Ki1iu-ToqrgMjO6IIS1EndZkdaJWXSzSRoxQ>
    <xme:HFsYYEG8JREiD12JB-OmgmVM2o8jNWeDfPwPozK5N1ljwVX7pha5W-Au1RaQO8McQ
    SbEe_K3HBUd2Xo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:HFsYYN7lfxU28Q9bNFamoEMf-p_MXc-b_SH2W9wQ8F5AfU0Jhixogw>
    <xmx:HFsYYK2_hcE_O5OJ153v9BVmzHQQXtA54IZtW_N3SXZDeQdvaM-hZQ>
    <xmx:HFsYYAHP54Wqkcjt9PbvMYcgdJDMpqahjKYtYBN3R9vdiDt9S-CnwQ>
    <xmx:HFsYYOYBjBXcWqNBtOyCsi4qkHOdT7VqvcwpBt0F5vevq_QY5fPADA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 69F0F24005D;
        Mon,  1 Feb 2021 14:48:41 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, jiri@nvidia.com, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 02/10] netdevsim: fib: Perform the route programming in a non-atomic context
Date:   Mon,  1 Feb 2021 21:47:49 +0200
Message-Id: <20210201194757.3463461-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201194757.3463461-1-idosch@idosch.org>
References: <20210201194757.3463461-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, netdevsim implements dummy FIB offload and marks notified
routes with RTM_F_TRAP flag. netdevsim does not defer route notifications
to a work queue because it does not need to program any hardware.

Given that netdevsim's purpose is to both give an example implementation
and allow developers to test their code, align netdevsim to a "real"
hardware device driver like mlxsw and have it also perform the route
"programming" in a non-atomic context.

It will be used to test route flags notifications which will be added in
the next patches.

The following changes are needed when route handling is performed in WQ:
- Handle the accounting in the main context, to be able to return an
  error for adding route when all the routes are used.
  For FIB_EVENT_ENTRY_REPLACE increase the counter before scheduling
  the delayed work, and in case that this event replaces an existing route,
  decrease the counter as part of the delayed work.

- For IPv6, cannot use fen6_info->rt->fib6_siblings list because it
  might be changed during handling the delayed work.
  Save an array with the nexthops as part of fib6_event struct, and take
  a reference for each nexthop to prevent them from being freed while
  event is queued.

- Change GFP_ATOMIC allocations to GFP_KERNEL.

- Use single work item that is handling a list of ordered routes.
  Handling routes must be processed in the order they were submitted to
  avoid logical errors that could lead to unexpected failures.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: David Ahern <dsahern@kernel.org>
---
 drivers/net/netdevsim/fib.c | 467 +++++++++++++++++++++++++-----------
 1 file changed, 327 insertions(+), 140 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 7be603e06769..d557533d43dd 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -46,10 +46,13 @@ struct nsim_fib_data {
 	struct nsim_fib_entry nexthops;
 	struct rhashtable fib_rt_ht;
 	struct list_head fib_rt_list;
-	spinlock_t fib_lock;	/* Protects hashtable and list */
+	struct mutex fib_lock; /* Protects hashtable and list */
 	struct notifier_block nexthop_nb;
 	struct rhashtable nexthop_ht;
 	struct devlink *devlink;
+	struct work_struct fib_event_work;
+	struct list_head fib_event_queue;
+	spinlock_t fib_event_queue_lock; /* Protects fib event queue list */
 };
 
 struct nsim_fib_rt_key {
@@ -83,6 +86,22 @@ struct nsim_fib6_rt_nh {
 	struct fib6_info *rt;
 };
 
+struct nsim_fib6_event {
+	struct fib6_info **rt_arr;
+	unsigned int nrt6;
+};
+
+struct nsim_fib_event {
+	struct list_head list; /* node in fib queue */
+	union {
+		struct fib_entry_notifier_info fen_info;
+		struct nsim_fib6_event fib6_event;
+	};
+	struct nsim_fib_data *data;
+	unsigned long event;
+	int family;
+};
+
 static const struct rhashtable_params nsim_fib_rt_ht_params = {
 	.key_offset = offsetof(struct nsim_fib_rt, key),
 	.head_offset = offsetof(struct nsim_fib_rt, ht_node),
@@ -194,16 +213,13 @@ static int nsim_fib_rule_event(struct nsim_fib_data *data,
 	return err;
 }
 
-static int nsim_fib_account(struct nsim_fib_entry *entry, bool add,
-			    struct netlink_ext_ack *extack)
+static int nsim_fib_account(struct nsim_fib_entry *entry, bool add)
 {
 	int err = 0;
 
 	if (add) {
-		if (!atomic64_add_unless(&entry->num, 1, entry->max)) {
+		if (!atomic64_add_unless(&entry->num, 1, entry->max))
 			err = -ENOSPC;
-			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported fib entries");
-		}
 	} else {
 		atomic64_dec_if_positive(&entry->num);
 	}
@@ -250,7 +266,7 @@ nsim_fib4_rt_create(struct nsim_fib_data *data,
 {
 	struct nsim_fib4_rt *fib4_rt;
 
-	fib4_rt = kzalloc(sizeof(*fib4_rt), GFP_ATOMIC);
+	fib4_rt = kzalloc(sizeof(*fib4_rt), GFP_KERNEL);
 	if (!fib4_rt)
 		return NULL;
 
@@ -307,51 +323,52 @@ static void nsim_fib4_rt_hw_flags_set(struct net *net,
 }
 
 static int nsim_fib4_rt_add(struct nsim_fib_data *data,
-			    struct nsim_fib4_rt *fib4_rt,
-			    struct netlink_ext_ack *extack)
+			    struct nsim_fib4_rt *fib4_rt)
 {
 	struct net *net = devlink_net(data->devlink);
 	int err;
 
-	err = nsim_fib_account(&data->ipv4.fib, true, extack);
-	if (err)
-		return err;
-
 	err = rhashtable_insert_fast(&data->fib_rt_ht,
 				     &fib4_rt->common.ht_node,
 				     nsim_fib_rt_ht_params);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "Failed to insert IPv4 route");
+	if (err)
 		goto err_fib_dismiss;
-	}
 
+	/* Simulate hardware programming latency. */
+	msleep(1);
 	nsim_fib4_rt_hw_flags_set(net, fib4_rt, true);
 
 	return 0;
 
 err_fib_dismiss:
-	nsim_fib_account(&data->ipv4.fib, false, extack);
+	/* Drop the accounting that was increased from the notification
+	 * context when FIB_EVENT_ENTRY_REPLACE was triggered.
+	 */
+	nsim_fib_account(&data->ipv4.fib, false);
 	return err;
 }
 
 static int nsim_fib4_rt_replace(struct nsim_fib_data *data,
 				struct nsim_fib4_rt *fib4_rt,
-				struct nsim_fib4_rt *fib4_rt_old,
-				struct netlink_ext_ack *extack)
+				struct nsim_fib4_rt *fib4_rt_old)
 {
 	struct net *net = devlink_net(data->devlink);
 	int err;
 
-	/* We are replacing a route, so no need to change the accounting. */
+	/* We are replacing a route, so need to remove the accounting which
+	 * was increased when FIB_EVENT_ENTRY_REPLACE was triggered.
+	 */
+	err = nsim_fib_account(&data->ipv4.fib, false);
+	if (err)
+		return err;
 	err = rhashtable_replace_fast(&data->fib_rt_ht,
 				      &fib4_rt_old->common.ht_node,
 				      &fib4_rt->common.ht_node,
 				      nsim_fib_rt_ht_params);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "Failed to replace IPv4 route");
+	if (err)
 		return err;
-	}
 
+	msleep(1);
 	nsim_fib4_rt_hw_flags_set(net, fib4_rt, true);
 
 	nsim_fib4_rt_hw_flags_set(net, fib4_rt_old, false);
@@ -363,7 +380,6 @@ static int nsim_fib4_rt_replace(struct nsim_fib_data *data,
 static int nsim_fib4_rt_insert(struct nsim_fib_data *data,
 			       struct fib_entry_notifier_info *fen_info)
 {
-	struct netlink_ext_ack *extack = fen_info->info.extack;
 	struct nsim_fib4_rt *fib4_rt, *fib4_rt_old;
 	int err;
 
@@ -373,9 +389,9 @@ static int nsim_fib4_rt_insert(struct nsim_fib_data *data,
 
 	fib4_rt_old = nsim_fib4_rt_lookup(&data->fib_rt_ht, fen_info);
 	if (!fib4_rt_old)
-		err = nsim_fib4_rt_add(data, fib4_rt, extack);
+		err = nsim_fib4_rt_add(data, fib4_rt);
 	else
-		err = nsim_fib4_rt_replace(data, fib4_rt, fib4_rt_old, extack);
+		err = nsim_fib4_rt_replace(data, fib4_rt, fib4_rt_old);
 
 	if (err)
 		nsim_fib4_rt_destroy(fib4_rt);
@@ -386,7 +402,6 @@ static int nsim_fib4_rt_insert(struct nsim_fib_data *data,
 static void nsim_fib4_rt_remove(struct nsim_fib_data *data,
 				const struct fib_entry_notifier_info *fen_info)
 {
-	struct netlink_ext_ack *extack = fen_info->info.extack;
 	struct nsim_fib4_rt *fib4_rt;
 
 	fib4_rt = nsim_fib4_rt_lookup(&data->fib_rt_ht, fen_info);
@@ -395,19 +410,15 @@ static void nsim_fib4_rt_remove(struct nsim_fib_data *data,
 
 	rhashtable_remove_fast(&data->fib_rt_ht, &fib4_rt->common.ht_node,
 			       nsim_fib_rt_ht_params);
-	nsim_fib_account(&data->ipv4.fib, false, extack);
 	nsim_fib4_rt_destroy(fib4_rt);
 }
 
 static int nsim_fib4_event(struct nsim_fib_data *data,
-			   struct fib_notifier_info *info,
+			   struct fib_entry_notifier_info *fen_info,
 			   unsigned long event)
 {
-	struct fib_entry_notifier_info *fen_info;
 	int err = 0;
 
-	fen_info = container_of(info, struct fib_entry_notifier_info, info);
-
 	switch (event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 		err = nsim_fib4_rt_insert(data, fen_info);
@@ -441,7 +452,7 @@ static int nsim_fib6_rt_nh_add(struct nsim_fib6_rt *fib6_rt,
 {
 	struct nsim_fib6_rt_nh *fib6_rt_nh;
 
-	fib6_rt_nh = kzalloc(sizeof(*fib6_rt_nh), GFP_ATOMIC);
+	fib6_rt_nh = kzalloc(sizeof(*fib6_rt_nh), GFP_KERNEL);
 	if (!fib6_rt_nh)
 		return -ENOMEM;
 
@@ -453,6 +464,17 @@ static int nsim_fib6_rt_nh_add(struct nsim_fib6_rt *fib6_rt,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static void nsim_rt6_release(struct fib6_info *rt)
+{
+	fib6_info_release(rt);
+}
+#else
+static void nsim_rt6_release(struct fib6_info *rt)
+{
+}
+#endif
+
 static void nsim_fib6_rt_nh_del(struct nsim_fib6_rt *fib6_rt,
 				const struct fib6_info *rt)
 {
@@ -464,22 +486,20 @@ static void nsim_fib6_rt_nh_del(struct nsim_fib6_rt *fib6_rt,
 
 	fib6_rt->nhs--;
 	list_del(&fib6_rt_nh->list);
-#if IS_ENABLED(CONFIG_IPV6)
-	fib6_info_release(fib6_rt_nh->rt);
-#endif
+	nsim_rt6_release(fib6_rt_nh->rt);
 	kfree(fib6_rt_nh);
 }
 
 static struct nsim_fib6_rt *
 nsim_fib6_rt_create(struct nsim_fib_data *data,
-		    struct fib6_entry_notifier_info *fen6_info)
+		    struct fib6_info **rt_arr, unsigned int nrt6)
 {
-	struct fib6_info *iter, *rt = fen6_info->rt;
+	struct fib6_info *rt = rt_arr[0];
 	struct nsim_fib6_rt *fib6_rt;
 	int i = 0;
 	int err;
 
-	fib6_rt = kzalloc(sizeof(*fib6_rt), GFP_ATOMIC);
+	fib6_rt = kzalloc(sizeof(*fib6_rt), GFP_KERNEL);
 	if (!fib6_rt)
 		return ERR_PTR(-ENOMEM);
 
@@ -493,32 +513,18 @@ nsim_fib6_rt_create(struct nsim_fib_data *data,
 	 */
 	INIT_LIST_HEAD(&fib6_rt->nh_list);
 
-	err = nsim_fib6_rt_nh_add(fib6_rt, rt);
-	if (err)
-		goto err_fib_rt_fini;
-
-	if (!fen6_info->nsiblings)
-		return fib6_rt;
-
-	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {
-		if (i == fen6_info->nsiblings)
-			break;
-
-		err = nsim_fib6_rt_nh_add(fib6_rt, iter);
+	for (i = 0; i < nrt6; i++) {
+		err = nsim_fib6_rt_nh_add(fib6_rt, rt_arr[i]);
 		if (err)
 			goto err_fib6_rt_nh_del;
-		i++;
 	}
-	WARN_ON_ONCE(i != fen6_info->nsiblings);
 
 	return fib6_rt;
 
 err_fib6_rt_nh_del:
-	list_for_each_entry_continue_reverse(iter, &rt->fib6_siblings,
-					     fib6_siblings)
-		nsim_fib6_rt_nh_del(fib6_rt, iter);
-	nsim_fib6_rt_nh_del(fib6_rt, rt);
-err_fib_rt_fini:
+	for (i--; i >= 0; i--) {
+		nsim_fib6_rt_nh_del(fib6_rt, rt_arr[i]);
+	};
 	nsim_fib_rt_fini(&fib6_rt->common);
 	kfree(fib6_rt);
 	return ERR_PTR(err);
@@ -551,47 +557,31 @@ nsim_fib6_rt_lookup(struct rhashtable *fib_rt_ht, const struct fib6_info *rt)
 }
 
 static int nsim_fib6_rt_append(struct nsim_fib_data *data,
-			       struct fib6_entry_notifier_info *fen6_info)
+			       struct nsim_fib6_event *fib6_event)
 {
-	struct fib6_info *iter, *rt = fen6_info->rt;
+	struct fib6_info *rt = fib6_event->rt_arr[0];
 	struct nsim_fib6_rt *fib6_rt;
-	int i = 0;
-	int err;
+	int i, err;
 
 	fib6_rt = nsim_fib6_rt_lookup(&data->fib_rt_ht, rt);
 	if (WARN_ON_ONCE(!fib6_rt))
 		return -EINVAL;
 
-	err = nsim_fib6_rt_nh_add(fib6_rt, rt);
-	if (err)
-		return err;
-	rt->trap = true;
-
-	if (!fen6_info->nsiblings)
-		return 0;
-
-	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {
-		if (i == fen6_info->nsiblings)
-			break;
-
-		err = nsim_fib6_rt_nh_add(fib6_rt, iter);
+	for (i = 0; i < fib6_event->nrt6; i++) {
+		err = nsim_fib6_rt_nh_add(fib6_rt, fib6_event->rt_arr[i]);
 		if (err)
 			goto err_fib6_rt_nh_del;
-		iter->trap = true;
-		i++;
+
+		fib6_event->rt_arr[i]->trap = true;
 	}
-	WARN_ON_ONCE(i != fen6_info->nsiblings);
 
 	return 0;
 
 err_fib6_rt_nh_del:
-	list_for_each_entry_continue_reverse(iter, &rt->fib6_siblings,
-					     fib6_siblings) {
-		iter->trap = false;
-		nsim_fib6_rt_nh_del(fib6_rt, iter);
+	for (i--; i >= 0; i--) {
+		fib6_event->rt_arr[i]->trap = false;
+		nsim_fib6_rt_nh_del(fib6_rt, fib6_event->rt_arr[i]);
 	}
-	rt->trap = false;
-	nsim_fib6_rt_nh_del(fib6_rt, rt);
 	return err;
 }
 
@@ -605,49 +595,52 @@ static void nsim_fib6_rt_hw_flags_set(const struct nsim_fib6_rt *fib6_rt,
 }
 
 static int nsim_fib6_rt_add(struct nsim_fib_data *data,
-			    struct nsim_fib6_rt *fib6_rt,
-			    struct netlink_ext_ack *extack)
+			    struct nsim_fib6_rt *fib6_rt)
 {
 	int err;
 
-	err = nsim_fib_account(&data->ipv6.fib, true, extack);
-	if (err)
-		return err;
-
 	err = rhashtable_insert_fast(&data->fib_rt_ht,
 				     &fib6_rt->common.ht_node,
 				     nsim_fib_rt_ht_params);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "Failed to insert IPv6 route");
+
+	if (err)
 		goto err_fib_dismiss;
-	}
 
+	msleep(1);
 	nsim_fib6_rt_hw_flags_set(fib6_rt, true);
 
 	return 0;
 
 err_fib_dismiss:
-	nsim_fib_account(&data->ipv6.fib, false, extack);
+	/* Drop the accounting that was increased from the notification
+	 * context when FIB_EVENT_ENTRY_REPLACE was triggered.
+	 */
+	nsim_fib_account(&data->ipv6.fib, false);
 	return err;
 }
 
 static int nsim_fib6_rt_replace(struct nsim_fib_data *data,
 				struct nsim_fib6_rt *fib6_rt,
-				struct nsim_fib6_rt *fib6_rt_old,
-				struct netlink_ext_ack *extack)
+				struct nsim_fib6_rt *fib6_rt_old)
 {
 	int err;
 
-	/* We are replacing a route, so no need to change the accounting. */
+	/* We are replacing a route, so need to remove the accounting which
+	 * was increased when FIB_EVENT_ENTRY_REPLACE was triggered.
+	 */
+	err = nsim_fib_account(&data->ipv6.fib, false);
+	if (err)
+		return err;
+
 	err = rhashtable_replace_fast(&data->fib_rt_ht,
 				      &fib6_rt_old->common.ht_node,
 				      &fib6_rt->common.ht_node,
 				      nsim_fib_rt_ht_params);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "Failed to replace IPv6 route");
+
+	if (err)
 		return err;
-	}
 
+	msleep(1);
 	nsim_fib6_rt_hw_flags_set(fib6_rt, true);
 
 	nsim_fib6_rt_hw_flags_set(fib6_rt_old, false);
@@ -657,21 +650,22 @@ static int nsim_fib6_rt_replace(struct nsim_fib_data *data,
 }
 
 static int nsim_fib6_rt_insert(struct nsim_fib_data *data,
-			       struct fib6_entry_notifier_info *fen6_info)
+			       struct nsim_fib6_event *fib6_event)
 {
-	struct netlink_ext_ack *extack = fen6_info->info.extack;
+	struct fib6_info *rt = fib6_event->rt_arr[0];
 	struct nsim_fib6_rt *fib6_rt, *fib6_rt_old;
 	int err;
 
-	fib6_rt = nsim_fib6_rt_create(data, fen6_info);
+	fib6_rt = nsim_fib6_rt_create(data, fib6_event->rt_arr,
+				      fib6_event->nrt6);
 	if (IS_ERR(fib6_rt))
 		return PTR_ERR(fib6_rt);
 
-	fib6_rt_old = nsim_fib6_rt_lookup(&data->fib_rt_ht, fen6_info->rt);
+	fib6_rt_old = nsim_fib6_rt_lookup(&data->fib_rt_ht, rt);
 	if (!fib6_rt_old)
-		err = nsim_fib6_rt_add(data, fib6_rt, extack);
+		err = nsim_fib6_rt_add(data, fib6_rt);
 	else
-		err = nsim_fib6_rt_replace(data, fib6_rt, fib6_rt_old, extack);
+		err = nsim_fib6_rt_replace(data, fib6_rt, fib6_rt_old);
 
 	if (err)
 		nsim_fib6_rt_destroy(fib6_rt);
@@ -679,59 +673,100 @@ static int nsim_fib6_rt_insert(struct nsim_fib_data *data,
 	return err;
 }
 
-static void
-nsim_fib6_rt_remove(struct nsim_fib_data *data,
-		    const struct fib6_entry_notifier_info *fen6_info)
+static void nsim_fib6_rt_remove(struct nsim_fib_data *data,
+				struct nsim_fib6_event *fib6_event)
 {
-	struct netlink_ext_ack *extack = fen6_info->info.extack;
+	struct fib6_info *rt = fib6_event->rt_arr[0];
 	struct nsim_fib6_rt *fib6_rt;
+	int i;
 
 	/* Multipath routes are first added to the FIB trie and only then
 	 * notified. If we vetoed the addition, we will get a delete
 	 * notification for a route we do not have. Therefore, do not warn if
 	 * route was not found.
 	 */
-	fib6_rt = nsim_fib6_rt_lookup(&data->fib_rt_ht, fen6_info->rt);
+	fib6_rt = nsim_fib6_rt_lookup(&data->fib_rt_ht, rt);
 	if (!fib6_rt)
 		return;
 
 	/* If not all the nexthops are deleted, then only reduce the nexthop
 	 * group.
 	 */
-	if (fen6_info->nsiblings + 1 != fib6_rt->nhs) {
-		nsim_fib6_rt_nh_del(fib6_rt, fen6_info->rt);
+	if (fib6_event->nrt6 != fib6_rt->nhs) {
+		for (i = 0; i < fib6_event->nrt6; i++)
+			nsim_fib6_rt_nh_del(fib6_rt, fib6_event->rt_arr[i]);
 		return;
 	}
 
 	rhashtable_remove_fast(&data->fib_rt_ht, &fib6_rt->common.ht_node,
 			       nsim_fib_rt_ht_params);
-	nsim_fib_account(&data->ipv6.fib, false, extack);
 	nsim_fib6_rt_destroy(fib6_rt);
 }
 
+static int nsim_fib6_event_init(struct nsim_fib6_event *fib6_event,
+				struct fib6_entry_notifier_info *fen6_info)
+{
+	struct fib6_info *rt = fen6_info->rt;
+	struct fib6_info **rt_arr;
+	struct fib6_info *iter;
+	unsigned int nrt6;
+	int i = 0;
+
+	nrt6 = fen6_info->nsiblings + 1;
+
+	rt_arr = kcalloc(nrt6, sizeof(struct fib6_info *), GFP_ATOMIC);
+	if (!rt_arr)
+		return -ENOMEM;
+
+	fib6_event->rt_arr = rt_arr;
+	fib6_event->nrt6 = nrt6;
+
+	rt_arr[0] = rt;
+	fib6_info_hold(rt);
+
+	if (!fen6_info->nsiblings)
+		return 0;
+
+	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {
+		if (i == fen6_info->nsiblings)
+			break;
+
+		rt_arr[i + 1] = iter;
+		fib6_info_hold(iter);
+		i++;
+	}
+	WARN_ON_ONCE(i != fen6_info->nsiblings);
+
+	return 0;
+}
+
+static void nsim_fib6_event_fini(struct nsim_fib6_event *fib6_event)
+{
+	int i;
+
+	for (i = 0; i < fib6_event->nrt6; i++)
+		nsim_rt6_release(fib6_event->rt_arr[i]);
+	kfree(fib6_event->rt_arr);
+}
+
 static int nsim_fib6_event(struct nsim_fib_data *data,
-			   struct fib_notifier_info *info,
+			   struct nsim_fib6_event *fib6_event,
 			   unsigned long event)
 {
-	struct fib6_entry_notifier_info *fen6_info;
 	int err = 0;
 
-	fen6_info = container_of(info, struct fib6_entry_notifier_info, info);
-
-	if (fen6_info->rt->fib6_src.plen) {
-		NL_SET_ERR_MSG_MOD(info->extack, "IPv6 source-specific route is not supported");
+	if (fib6_event->rt_arr[0]->fib6_src.plen)
 		return 0;
-	}
 
 	switch (event) {
 	case FIB_EVENT_ENTRY_REPLACE:
-		err = nsim_fib6_rt_insert(data, fen6_info);
+		err = nsim_fib6_rt_insert(data, fib6_event);
 		break;
 	case FIB_EVENT_ENTRY_APPEND:
-		err = nsim_fib6_rt_append(data, fen6_info);
+		err = nsim_fib6_rt_append(data, fib6_event);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		nsim_fib6_rt_remove(data, fen6_info);
+		nsim_fib6_rt_remove(data, fib6_event);
 		break;
 	default:
 		break;
@@ -740,48 +775,165 @@ static int nsim_fib6_event(struct nsim_fib_data *data,
 	return err;
 }
 
-static int nsim_fib_event(struct nsim_fib_data *data,
-			  struct fib_notifier_info *info, unsigned long event)
+static int nsim_fib_event(struct nsim_fib_event *fib_event)
 {
 	int err = 0;
 
-	switch (info->family) {
+	switch (fib_event->family) {
 	case AF_INET:
-		err = nsim_fib4_event(data, info, event);
+		nsim_fib4_event(fib_event->data, &fib_event->fen_info,
+				fib_event->event);
+		fib_info_put(fib_event->fen_info.fi);
 		break;
 	case AF_INET6:
-		err = nsim_fib6_event(data, info, event);
+		nsim_fib6_event(fib_event->data, &fib_event->fib6_event,
+				fib_event->event);
+		nsim_fib6_event_fini(&fib_event->fib6_event);
 		break;
 	}
 
 	return err;
 }
 
+static int nsim_fib4_prepare_event(struct fib_notifier_info *info,
+				   struct nsim_fib_event *fib_event,
+				   unsigned long event)
+{
+	struct nsim_fib_data *data = fib_event->data;
+	struct fib_entry_notifier_info *fen_info;
+	struct netlink_ext_ack *extack;
+	int err = 0;
+
+	fen_info = container_of(info, struct fib_entry_notifier_info,
+				info);
+	fib_event->fen_info = *fen_info;
+	extack = info->extack;
+
+	switch (event) {
+	case FIB_EVENT_ENTRY_REPLACE:
+		err = nsim_fib_account(&data->ipv4.fib, true);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported fib entries");
+			return err;
+		}
+		break;
+	case FIB_EVENT_ENTRY_DEL:
+		nsim_fib_account(&data->ipv4.fib, false);
+		break;
+	}
+
+	/* Take reference on fib_info to prevent it from being
+	 * freed while event is queued. Release it afterwards.
+	 */
+	fib_info_hold(fib_event->fen_info.fi);
+
+	return 0;
+}
+
+static int nsim_fib6_prepare_event(struct fib_notifier_info *info,
+				   struct nsim_fib_event *fib_event,
+				   unsigned long event)
+{
+	struct nsim_fib_data *data = fib_event->data;
+	struct fib6_entry_notifier_info *fen6_info;
+	struct netlink_ext_ack *extack;
+	int err = 0;
+
+	fen6_info = container_of(info, struct fib6_entry_notifier_info,
+				 info);
+
+	err = nsim_fib6_event_init(&fib_event->fib6_event, fen6_info);
+	if (err)
+		return err;
+
+	extack = info->extack;
+	switch (event) {
+	case FIB_EVENT_ENTRY_REPLACE:
+		err = nsim_fib_account(&data->ipv6.fib, true);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported fib entries");
+			goto err_fib6_event_fini;
+		}
+		break;
+	case FIB_EVENT_ENTRY_DEL:
+		nsim_fib_account(&data->ipv6.fib, false);
+		break;
+	}
+
+	return 0;
+
+err_fib6_event_fini:
+	nsim_fib6_event_fini(&fib_event->fib6_event);
+	return err;
+}
+
+static int nsim_fib_event_schedule_work(struct nsim_fib_data *data,
+					struct fib_notifier_info *info,
+					unsigned long event)
+{
+	struct nsim_fib_event *fib_event;
+	int err;
+
+	if (info->family != AF_INET && info->family != AF_INET6)
+		/* netdevsim does not support 'RTNL_FAMILY_IP6MR' and
+		 * 'RTNL_FAMILY_IPMR' and should ignore them.
+		 */
+		return NOTIFY_DONE;
+
+	fib_event = kzalloc(sizeof(*fib_event), GFP_ATOMIC);
+	if (!fib_event)
+		return NOTIFY_BAD;
+
+	fib_event->data = data;
+	fib_event->event = event;
+	fib_event->family = info->family;
+
+	switch (info->family) {
+	case AF_INET:
+		err = nsim_fib4_prepare_event(info, fib_event, event);
+		break;
+	case AF_INET6:
+		err = nsim_fib6_prepare_event(info, fib_event, event);
+		break;
+	}
+
+	if (err)
+		goto err_fib_prepare_event;
+
+	/* Enqueue the event and trigger the work */
+	spin_lock_bh(&data->fib_event_queue_lock);
+	list_add_tail(&fib_event->list, &data->fib_event_queue);
+	spin_unlock_bh(&data->fib_event_queue_lock);
+	schedule_work(&data->fib_event_work);
+
+	return NOTIFY_DONE;
+
+err_fib_prepare_event:
+	kfree(fib_event);
+	return NOTIFY_BAD;
+}
+
 static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct nsim_fib_data *data = container_of(nb, struct nsim_fib_data,
 						  fib_nb);
 	struct fib_notifier_info *info = ptr;
-	int err = 0;
+	int err;
 
 	switch (event) {
 	case FIB_EVENT_RULE_ADD:
 	case FIB_EVENT_RULE_DEL:
 		err = nsim_fib_rule_event(data, info,
 					  event == FIB_EVENT_RULE_ADD);
-		break;
+		return notifier_from_errno(err);
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_APPEND:
 	case FIB_EVENT_ENTRY_DEL:
-		/* IPv6 routes can be added via RAs from softIRQ. */
-		spin_lock_bh(&data->fib_lock);
-		err = nsim_fib_event(data, info, event);
-		spin_unlock_bh(&data->fib_lock);
-		break;
+		return nsim_fib_event_schedule_work(data, info, event);
 	}
 
-	return notifier_from_errno(err);
+	return NOTIFY_DONE;
 }
 
 static void nsim_fib4_rt_free(struct nsim_fib_rt *fib_rt,
@@ -792,7 +944,7 @@ static void nsim_fib4_rt_free(struct nsim_fib_rt *fib_rt,
 
 	fib4_rt = container_of(fib_rt, struct nsim_fib4_rt, common);
 	nsim_fib4_rt_hw_flags_set(devlink_net(devlink), fib4_rt, false);
-	nsim_fib_account(&data->ipv4.fib, false, NULL);
+	nsim_fib_account(&data->ipv4.fib, false);
 	nsim_fib4_rt_destroy(fib4_rt);
 }
 
@@ -803,7 +955,7 @@ static void nsim_fib6_rt_free(struct nsim_fib_rt *fib_rt,
 
 	fib6_rt = container_of(fib_rt, struct nsim_fib6_rt, common);
 	nsim_fib6_rt_hw_flags_set(fib6_rt, false);
-	nsim_fib_account(&data->ipv6.fib, false, NULL);
+	nsim_fib_account(&data->ipv6.fib, false);
 	nsim_fib6_rt_destroy(fib6_rt);
 }
 
@@ -831,6 +983,9 @@ static void nsim_fib_dump_inconsistent(struct notifier_block *nb)
 						  fib_nb);
 	struct nsim_fib_rt *fib_rt, *fib_rt_tmp;
 
+	/* Flush the work to make sure there is no race with notifications. */
+	flush_work(&data->fib_event_work);
+
 	/* The notifier block is still not registered, so we do not need to
 	 * take any locks here.
 	 */
@@ -1101,6 +1256,29 @@ static void nsim_fib_set_max_all(struct nsim_fib_data *data,
 	}
 }
 
+static void nsim_fib_event_work(struct work_struct *work)
+{
+	struct nsim_fib_data *data = container_of(work, struct nsim_fib_data,
+						  fib_event_work);
+	struct nsim_fib_event *fib_event, *next_fib_event;
+
+	LIST_HEAD(fib_event_queue);
+
+	spin_lock_bh(&data->fib_event_queue_lock);
+	list_splice_init(&data->fib_event_queue, &fib_event_queue);
+	spin_unlock_bh(&data->fib_event_queue_lock);
+
+	mutex_lock(&data->fib_lock);
+	list_for_each_entry_safe(fib_event, next_fib_event, &fib_event_queue,
+				 list) {
+		nsim_fib_event(fib_event);
+		list_del(&fib_event->list);
+		kfree(fib_event);
+		cond_resched();
+	}
+	mutex_unlock(&data->fib_lock);
+}
+
 struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 				      struct netlink_ext_ack *extack)
 {
@@ -1116,12 +1294,16 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 	if (err)
 		goto err_data_free;
 
-	spin_lock_init(&data->fib_lock);
+	mutex_init(&data->fib_lock);
 	INIT_LIST_HEAD(&data->fib_rt_list);
 	err = rhashtable_init(&data->fib_rt_ht, &nsim_fib_rt_ht_params);
 	if (err)
 		goto err_rhashtable_nexthop_destroy;
 
+	INIT_WORK(&data->fib_event_work, nsim_fib_event_work);
+	INIT_LIST_HEAD(&data->fib_event_queue);
+	spin_lock_init(&data->fib_event_queue_lock);
+
 	nsim_fib_set_max_all(data, devlink);
 
 	data->nexthop_nb.notifier_call = nsim_nexthop_event_nb;
@@ -1165,11 +1347,13 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 err_nexthop_nb_unregister:
 	unregister_nexthop_notifier(devlink_net(devlink), &data->nexthop_nb);
 err_rhashtable_fib_destroy:
+	flush_work(&data->fib_event_work);
 	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
 				    data);
 err_rhashtable_nexthop_destroy:
 	rhashtable_free_and_destroy(&data->nexthop_ht, nsim_nexthop_free,
 				    data);
+	mutex_destroy(&data->fib_lock);
 err_data_free:
 	kfree(data);
 	return ERR_PTR(err);
@@ -1189,10 +1373,13 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 					    NSIM_RESOURCE_IPV4_FIB);
 	unregister_fib_notifier(devlink_net(devlink), &data->fib_nb);
 	unregister_nexthop_notifier(devlink_net(devlink), &data->nexthop_nb);
+	flush_work(&data->fib_event_work);
 	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
 				    data);
 	rhashtable_free_and_destroy(&data->nexthop_ht, nsim_nexthop_free,
 				    data);
+	WARN_ON_ONCE(!list_empty(&data->fib_event_queue));
 	WARN_ON_ONCE(!list_empty(&data->fib_rt_list));
+	mutex_destroy(&data->fib_lock);
 	kfree(data);
 }
-- 
2.29.2

