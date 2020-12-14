Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98752D976F
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437740AbgLNLer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:34:47 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38503 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437995AbgLNLdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:33:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C8B3D5C0191;
        Mon, 14 Dec 2020 06:31:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=gxPGPwA5QZqXvPG2Xm5n1PZD3rc7WPljFhsWbmNEy0I=; b=L2vjKQrZ
        J2FWxOXUqM3q84ow4g1Ohy13A+j8Si7Tzdy242dFAJ8pguYEzhSFuA5/lvn8bCDN
        VYAoewsK50LjwM1Pqkda6A1KqrQvYVqXHdE6ZHCTTkn0kc3hHGwkzHHfuiwrLExx
        GEnJscolHlANWFV2r1VqwnGbXSxJLGlLN97plmvvBt4gl3YKjnVtmqE3c54zEeCf
        HmE8PozADt4Z7JZD0HynJwEo7F9L/s/uo+rHXQjYpwaierUXdknIW+Awzjq7virB
        hmfODEb8vwhtfVz1FbnDh63z+ywp4EiAYnMSXIzm9SNgNu52Q8ZpHDDbR8aWildn
        COuMbUBwosviLQ==
X-ME-Sender: <xms:BU3XX6Wy3JIMl61XQSY_Za0Z24hGIw1vSS2swtmM58jI8c8Z42YMXA>
    <xme:BU3XX2lqit7sAqU-kzRN8dahf_vdw-OLd59nNBB4e-9xIgK75Hk9oAUTzC3-BajFv
    WuXCw4No2uNrGs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrfedu
    necuvehluhhsthgvrhfuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BU3XX-b8tTqnNKQZuG8-Nj6GvJHClE6-uxaeoiJr8MQlQXh1RCwVxg>
    <xmx:BU3XXxW-nl2vb8EcKs_OlvA7Eikll-N3M0-ZSFfRcrb_Hjo7NlFRWg>
    <xmx:BU3XX0mR_ShtSqSyQFpoew-8bEEM4BWEAMChRrDswyDjQ4DdWEUteg>
    <xmx:BU3XX5weRNmSNIesoxDWBicLEC5H-CQ-WBOmvjl99hBa_5NymPmb8w>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id A96041080059;
        Mon, 14 Dec 2020 06:31:16 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 13/15] mlxsw: spectrum_router_xm: Introduce basic XM cache flushing
Date:   Mon, 14 Dec 2020 13:30:39 +0200
Message-Id: <20201214113041.2789043-14-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
References: <20201214113041.2789043-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Upon route insertion and removal, it is needed to flush possibly cached
entries from the XM cache. Extend XM op context to carry information
needed for the flush. Implement the flush in delayed work since for HW
design reasons there is a need to wait 50usec before the flush can be
done. If during this time comes the same flush request, consolidate it
to the first one. Implement this queued flushes by a hashtable.

v2:
* Fix GENMASK() high bit

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_router_xm.c       | 291 ++++++++++++++++++
 1 file changed, 291 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
index c069092aa5ac..2f1e70e5a262 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
@@ -24,6 +24,9 @@ struct mlxsw_sp_router_xm {
 	bool ipv6_supported;
 	unsigned int entries_size;
 	struct rhashtable ltable_ht;
+	struct rhashtable flush_ht; /* Stores items about to be flushed from cache */
+	unsigned int flush_count;
+	bool flush_all_mode;
 };
 
 struct mlxsw_sp_router_xm_ltable_node {
@@ -41,11 +44,20 @@ static const struct rhashtable_params mlxsw_sp_router_xm_ltable_ht_params = {
 	.automatic_shrinking = true,
 };
 
+struct mlxsw_sp_router_xm_flush_info {
+	bool all;
+	enum mlxsw_sp_l3proto proto;
+	u16 virtual_router;
+	u8 prefix_len;
+	unsigned char addr[sizeof(struct in6_addr)];
+};
+
 struct mlxsw_sp_router_xm_fib_entry {
 	bool committed;
 	struct mlxsw_sp_router_xm_ltable_node *ltable_node; /* Parent node */
 	u16 mindex; /* Store for processing from commit op */
 	u8 lvalue;
+	struct mlxsw_sp_router_xm_flush_info flush_info;
 };
 
 #define MLXSW_SP_ROUTE_LL_XM_ENTRIES_MAX \
@@ -125,6 +137,7 @@ static void mlxsw_sp_router_ll_xm_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ct
 {
 	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
 	struct mlxsw_sp_router_xm_fib_entry *fib_entry = (void *) priv->priv;
+	struct mlxsw_sp_router_xm_flush_info *flush_info;
 	enum mlxsw_reg_xmdr_c_ltr_op xmdr_c_ltr_op;
 	unsigned int len;
 
@@ -171,6 +184,15 @@ static void mlxsw_sp_router_ll_xm_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ct
 
 	fib_entry->lvalue = prefix_len > mlxsw_sp_router_xm_m_val[proto] ?
 			       prefix_len - mlxsw_sp_router_xm_m_val[proto] : 0;
+
+	flush_info = &fib_entry->flush_info;
+	flush_info->proto = proto;
+	flush_info->virtual_router = virtual_router;
+	flush_info->prefix_len = prefix_len;
+	if (addr)
+		memcpy(flush_info->addr, addr, sizeof(flush_info->addr));
+	else
+		memset(flush_info->addr, 0, sizeof(flush_info->addr));
 }
 
 static void
@@ -262,6 +284,231 @@ static int mlxsw_sp_router_xm_ltable_lvalue_set(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xrmt), xrmt_pl);
 }
 
+struct mlxsw_sp_router_xm_flush_node {
+	struct rhash_head ht_node; /* Member of router_xm->flush_ht */
+	struct list_head list;
+	struct mlxsw_sp_router_xm_flush_info flush_info;
+	struct delayed_work dw;
+	struct mlxsw_sp *mlxsw_sp;
+	unsigned long start_jiffies;
+	unsigned int reuses; /* By how many flush calls this was reused. */
+	refcount_t refcnt;
+};
+
+static const struct rhashtable_params mlxsw_sp_router_xm_flush_ht_params = {
+	.key_offset = offsetof(struct mlxsw_sp_router_xm_flush_node, flush_info),
+	.head_offset = offsetof(struct mlxsw_sp_router_xm_flush_node, ht_node),
+	.key_len = sizeof(struct mlxsw_sp_router_xm_flush_info),
+	.automatic_shrinking = true,
+};
+
+static struct mlxsw_sp_router_xm_flush_node *
+mlxsw_sp_router_xm_cache_flush_node_create(struct mlxsw_sp *mlxsw_sp,
+					   struct mlxsw_sp_router_xm_flush_info *flush_info)
+{
+	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
+	struct mlxsw_sp_router_xm_flush_node *flush_node;
+	int err;
+
+	flush_node = kzalloc(sizeof(*flush_node), GFP_KERNEL);
+	if (!flush_node)
+		return ERR_PTR(-ENOMEM);
+
+	flush_node->flush_info = *flush_info;
+	err = rhashtable_insert_fast(&router_xm->flush_ht, &flush_node->ht_node,
+				     mlxsw_sp_router_xm_flush_ht_params);
+	if (err) {
+		kfree(flush_node);
+		return ERR_PTR(err);
+	}
+	router_xm->flush_count++;
+	flush_node->mlxsw_sp = mlxsw_sp;
+	flush_node->start_jiffies = jiffies;
+	refcount_set(&flush_node->refcnt, 1);
+	return flush_node;
+}
+
+static void
+mlxsw_sp_router_xm_cache_flush_node_hold(struct mlxsw_sp_router_xm_flush_node *flush_node)
+{
+	if (!flush_node)
+		return;
+	refcount_inc(&flush_node->refcnt);
+}
+
+static void
+mlxsw_sp_router_xm_cache_flush_node_put(struct mlxsw_sp_router_xm_flush_node *flush_node)
+{
+	if (!flush_node || !refcount_dec_and_test(&flush_node->refcnt))
+		return;
+	kfree(flush_node);
+}
+
+static void
+mlxsw_sp_router_xm_cache_flush_node_destroy(struct mlxsw_sp *mlxsw_sp,
+					    struct mlxsw_sp_router_xm_flush_node *flush_node)
+{
+	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
+
+	router_xm->flush_count--;
+	rhashtable_remove_fast(&router_xm->flush_ht, &flush_node->ht_node,
+			       mlxsw_sp_router_xm_flush_ht_params);
+	mlxsw_sp_router_xm_cache_flush_node_put(flush_node);
+}
+
+static u32 mlxsw_sp_router_xm_flush_mask4(u8 prefix_len)
+{
+	return GENMASK(31, 32 - prefix_len);
+}
+
+static unsigned char *mlxsw_sp_router_xm_flush_mask6(u8 prefix_len)
+{
+	static unsigned char mask[sizeof(struct in6_addr)];
+
+	memset(mask, 0, sizeof(mask));
+	memset(mask, 0xff, prefix_len / 8);
+	mask[prefix_len / 8] = GENMASK(8, 8 - prefix_len % 8);
+	return mask;
+}
+
+#define MLXSW_SP_ROUTER_XM_CACHE_PARALLEL_FLUSHES_LIMIT 15
+#define MLXSW_SP_ROUTER_XM_CACHE_FLUSH_ALL_MIN_REUSES 15
+#define MLXSW_SP_ROUTER_XM_CACHE_DELAY 50 /* usecs */
+#define MLXSW_SP_ROUTER_XM_CACHE_MAX_WAIT (MLXSW_SP_ROUTER_XM_CACHE_DELAY * 10)
+
+static void mlxsw_sp_router_xm_cache_flush_work(struct work_struct *work)
+{
+	struct mlxsw_sp_router_xm_flush_info *flush_info;
+	struct mlxsw_sp_router_xm_flush_node *flush_node;
+	char rlcmld_pl[MLXSW_REG_RLCMLD_LEN];
+	enum mlxsw_reg_rlcmld_select select;
+	struct mlxsw_sp *mlxsw_sp;
+	u32 addr4;
+	int err;
+
+	flush_node = container_of(work, struct mlxsw_sp_router_xm_flush_node,
+				  dw.work);
+	mlxsw_sp = flush_node->mlxsw_sp;
+	flush_info = &flush_node->flush_info;
+
+	if (flush_info->all) {
+		char rlpmce_pl[MLXSW_REG_RLPMCE_LEN];
+
+		mlxsw_reg_rlpmce_pack(rlpmce_pl, true, false);
+		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rlpmce),
+				      rlpmce_pl);
+		if (err)
+			dev_err(mlxsw_sp->bus_info->dev, "Failed to flush XM cache\n");
+
+		if (flush_node->reuses <
+		    MLXSW_SP_ROUTER_XM_CACHE_FLUSH_ALL_MIN_REUSES)
+			/* Leaving flush-all mode. */
+			mlxsw_sp->router->xm->flush_all_mode = false;
+		goto out;
+	}
+
+	select = MLXSW_REG_RLCMLD_SELECT_M_AND_ML_ENTRIES;
+
+	switch (flush_info->proto) {
+	case MLXSW_SP_L3_PROTO_IPV4:
+		addr4 = *((u32 *) flush_info->addr);
+		addr4 &= mlxsw_sp_router_xm_flush_mask4(flush_info->prefix_len);
+
+		/* In case the flush prefix length is bigger than M-value,
+		 * it makes no sense to flush M entries. So just flush
+		 * the ML entries.
+		 */
+		if (flush_info->prefix_len > MLXSW_SP_ROUTER_XM_M_VAL)
+			select = MLXSW_REG_RLCMLD_SELECT_ML_ENTRIES;
+
+		mlxsw_reg_rlcmld_pack4(rlcmld_pl, select,
+				       flush_info->virtual_router, addr4,
+				       mlxsw_sp_router_xm_flush_mask4(flush_info->prefix_len));
+		break;
+	case MLXSW_SP_L3_PROTO_IPV6:
+		mlxsw_reg_rlcmld_pack6(rlcmld_pl, select,
+				       flush_info->virtual_router, flush_info->addr,
+				       mlxsw_sp_router_xm_flush_mask6(flush_info->prefix_len));
+		break;
+	default:
+		WARN_ON(true);
+		goto out;
+	}
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rlcmld), rlcmld_pl);
+	if (err)
+		dev_err(mlxsw_sp->bus_info->dev, "Failed to flush XM cache\n");
+
+out:
+	mlxsw_sp_router_xm_cache_flush_node_destroy(mlxsw_sp, flush_node);
+}
+
+static bool
+mlxsw_sp_router_xm_cache_flush_may_cancel(struct mlxsw_sp_router_xm_flush_node *flush_node)
+{
+	unsigned long max_wait = usecs_to_jiffies(MLXSW_SP_ROUTER_XM_CACHE_MAX_WAIT);
+	unsigned long delay = usecs_to_jiffies(MLXSW_SP_ROUTER_XM_CACHE_DELAY);
+
+	/* In case there is the same flushing work pending, check
+	 * if we can consolidate with it. We can do it up to MAX_WAIT.
+	 * Cancel the delayed work. If the work was still pending.
+	 */
+	if (time_is_before_jiffies(flush_node->start_jiffies + max_wait - delay) &&
+	    cancel_delayed_work_sync(&flush_node->dw))
+		return true;
+	return false;
+}
+
+static int
+mlxsw_sp_router_xm_cache_flush_schedule(struct mlxsw_sp *mlxsw_sp,
+					struct mlxsw_sp_router_xm_flush_info *flush_info)
+{
+	unsigned long delay = usecs_to_jiffies(MLXSW_SP_ROUTER_XM_CACHE_DELAY);
+	struct mlxsw_sp_router_xm_flush_info flush_all_info = {.all = true};
+	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
+	struct mlxsw_sp_router_xm_flush_node *flush_node;
+
+	/* Check if the queued number of flushes reached critical amount after
+	 * which it is better to just flush the whole cache.
+	 */
+	if (router_xm->flush_count == MLXSW_SP_ROUTER_XM_CACHE_PARALLEL_FLUSHES_LIMIT)
+		/* Entering flush-all mode. */
+		router_xm->flush_all_mode = true;
+
+	if (router_xm->flush_all_mode)
+		flush_info = &flush_all_info;
+
+	rcu_read_lock();
+	flush_node = rhashtable_lookup_fast(&router_xm->flush_ht, flush_info,
+					    mlxsw_sp_router_xm_flush_ht_params);
+	/* Take a reference so the object is not freed before possible
+	 * delayed work cancel could be done.
+	 */
+	mlxsw_sp_router_xm_cache_flush_node_hold(flush_node);
+	rcu_read_unlock();
+
+	if (flush_node && mlxsw_sp_router_xm_cache_flush_may_cancel(flush_node)) {
+		flush_node->reuses++;
+		mlxsw_sp_router_xm_cache_flush_node_put(flush_node);
+		 /* Original work was within wait period and was canceled.
+		  * That means that the reference is still held and the
+		  * flush_node_put() call above did not free the flush_node.
+		  * Reschedule it with fresh delay.
+		  */
+		goto schedule_work;
+	} else {
+		mlxsw_sp_router_xm_cache_flush_node_put(flush_node);
+	}
+
+	flush_node = mlxsw_sp_router_xm_cache_flush_node_create(mlxsw_sp, flush_info);
+	if (IS_ERR(flush_node))
+		return PTR_ERR(flush_node);
+	INIT_DELAYED_WORK(&flush_node->dw, mlxsw_sp_router_xm_cache_flush_work);
+
+schedule_work:
+	mlxsw_core_schedule_dw(&flush_node->dw, delay);
+	return 0;
+}
+
 static int
 mlxsw_sp_router_xm_ml_entry_add(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_router_xm_fib_entry *fib_entry)
@@ -282,10 +529,18 @@ mlxsw_sp_router_xm_ml_entry_add(struct mlxsw_sp *mlxsw_sp,
 							   ltable_node);
 		if (err)
 			goto err_lvalue_set;
+
+		/* The L value for prefix/M is increased.
+		 * Therefore, all entries in M and ML caches matching
+		 * {prefix/M, proto, VR} need to be flushed. Set the flush
+		 * prefix length to M to achieve that.
+		 */
+		fib_entry->flush_info.prefix_len = MLXSW_SP_ROUTER_XM_M_VAL;
 	}
 
 	ltable_node->lvalue_ref[lvalue]++;
 	fib_entry->ltable_node = ltable_node;
+
 	return 0;
 
 err_lvalue_set:
@@ -313,6 +568,13 @@ mlxsw_sp_router_xm_ml_entry_del(struct mlxsw_sp *mlxsw_sp,
 
 		ltable_node->current_lvalue = new_lvalue;
 		mlxsw_sp_router_xm_ltable_lvalue_set(mlxsw_sp, ltable_node);
+
+		/* The L value for prefix/M is decreased.
+		 * Therefore, all entries in M and ML caches matching
+		 * {prefix/M, proto, VR} need to be flushed. Set the flush
+		 * prefix length to M to achieve that.
+		 */
+		fib_entry->flush_info.prefix_len = MLXSW_SP_ROUTER_XM_M_VAL;
 	}
 	mlxsw_sp_router_xm_ltable_node_put(router_xm, ltable_node);
 }
@@ -354,6 +616,23 @@ mlxsw_sp_router_xm_ml_entries_del(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
+static void
+mlxsw_sp_router_xm_ml_entries_cache_flush(struct mlxsw_sp *mlxsw_sp,
+					  struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm)
+{
+	struct mlxsw_sp_router_xm_fib_entry *fib_entry;
+	int err;
+	int i;
+
+	for (i = 0; i < op_ctx_xm->entries_count; i++) {
+		fib_entry = op_ctx_xm->entries[i];
+		err = mlxsw_sp_router_xm_cache_flush_schedule(mlxsw_sp,
+							      &fib_entry->flush_info);
+		if (err)
+			dev_err(mlxsw_sp->bus_info->dev, "Failed to flush XM cache\n");
+	}
+}
+
 static int mlxsw_sp_router_ll_xm_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
 						  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 						  bool *postponed_for_bulk)
@@ -414,6 +693,11 @@ static int mlxsw_sp_router_ll_xm_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
 		 */
 		mlxsw_sp_router_xm_ml_entries_del(mlxsw_sp, op_ctx_xm);
 
+	/* At the very end, do the XLT cache flushing to evict stale
+	 * M and ML cache entries after prefixes were inserted/removed.
+	 */
+	mlxsw_sp_router_xm_ml_entries_cache_flush(mlxsw_sp, op_ctx_xm);
+
 out:
 	/* Next pack call is going to do reinitialization */
 	op_ctx->initialized = false;
@@ -490,9 +774,15 @@ int mlxsw_sp_router_xm_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_ltable_ht_init;
 
+	err = rhashtable_init(&router_xm->flush_ht, &mlxsw_sp_router_xm_flush_ht_params);
+	if (err)
+		goto err_flush_ht_init;
+
 	mlxsw_sp->router->xm = router_xm;
 	return 0;
 
+err_flush_ht_init:
+	rhashtable_destroy(&router_xm->ltable_ht);
 err_ltable_ht_init:
 err_rxltm_write:
 err_mindex_size_check:
@@ -509,6 +799,7 @@ void mlxsw_sp_router_xm_fini(struct mlxsw_sp *mlxsw_sp)
 	if (!mlxsw_sp->bus_info->xm_exists)
 		return;
 
+	rhashtable_destroy(&router_xm->flush_ht);
 	rhashtable_destroy(&router_xm->ltable_ht);
 	kfree(router_xm);
 }
-- 
2.29.2

