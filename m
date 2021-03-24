Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547F53482AF
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238181AbhCXUPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:15:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52527 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238121AbhCXUO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:14:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 647AB5C015B;
        Wed, 24 Mar 2021 16:14:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 24 Mar 2021 16:14:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=9YxUJmaic4ikWoVPwmF/iPAjpSEDDux4ZdreCWT9gHA=; b=i41c3qPs
        FJrrMmG6siNtMs5aLh7Erj1mom+oONmcdA03h+imzC2sfLVvo8hBxdfCMc/E2ltX
        nCWZTIA2vPZsOt+EPCCXW/xYeH4BeOa7xnQAQzVH5883a/6DUIz3V6NO4Lk7jXW0
        o2qgvGiVEIzIq8GZ3Xlu4U26N4DuUGAxx6445TONhgistw9O+XZ6CS71gsZtiYrM
        YnIIdimC5paXDZI9woDRkRUPDMmUt46EsUo99viOCq2Cgn220F+dxkm1P5SwpTaE
        XuPYxrgsd/lBCATCCOxbVL/nQqWqgeLLp4iQKLMCkt+u035kt1SG+2xOEsxuRKqY
        hh3QzLSJkSy1Jw==
X-ME-Sender: <xms:w51bYAflnzDHwTk0mbQMdbdhOBlNjnW5HveZppIqDjtGkUF1VHeb6Q>
    <xme:w51bYCJPwvjkjinuJ6zYpaSLGRl-x6nXAcgmiEfwNZH8_Vur9YVtnc66Z9vj48J-j
    BRo01iuQdImfwo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:w51bYOYyUY5BKatVVp-it1DKISFO2mbU9kotKa7D4DXE6VYqxf9oZA>
    <xmx:w51bYNs8AK6rDxxJmPZxCYGlyReH9uEDj8-cagGieng4nXIubqA0BA>
    <xmx:w51bYLu0qV9E0W842alanC11UzVyBC_i5mUMOOYBk-GWbYCe1N4pSQ>
    <xmx:w51bYBTSb1QYddOqyulh7FLvK3VRaAaTUSwj-0ddmO_ZpJKlfEBu4w>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7ED99240422;
        Wed, 24 Mar 2021 16:14:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/10] mlxsw: spectrum_router: Periodically update activity of nexthop buckets
Date:   Wed, 24 Mar 2021 22:14:21 +0200
Message-Id: <20210324201424.157387-8-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324201424.157387-1-idosch@idosch.org>
References: <20210324201424.157387-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The kernel periodically checks the idle time of nexthop buckets to
determine if they are idle and can be re-populated with a new nexthop.

When the resilient nexthop group is offloaded to hardware, the kernel
will not see activity on nexthop buckets unless it is reported from
hardware.

Therefore, periodically (every 1 second) query the hardware for activity
of adjacency entries used as part of a resilient nexthop group and
report it to the nexthop code.

The activity is only queried if resilient nexthop groups are in use. The
delayed work is canceled otherwise.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 100 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   2 +
 2 files changed, 102 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 862c8667813b..1d74341596da 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2913,6 +2913,7 @@ struct mlxsw_sp_nexthop_group_info {
 	u8 adj_index_valid:1,
 	   gateway:1, /* routes using the group use a gateway */
 	   is_resilient:1;
+	struct list_head list; /* member in nh_res_grp_list */
 	struct mlxsw_sp_nexthop nexthops[0];
 #define nh_rif	nexthops[0].rif
 };
@@ -4373,8 +4374,85 @@ static void mlxsw_sp_nexthop_rif_gone_sync(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
+static void
+mlxsw_sp_nh_grp_activity_get(struct mlxsw_sp *mlxsw_sp,
+			     const struct mlxsw_sp_nexthop_group *nh_grp,
+			     unsigned long *activity)
+{
+	char *ratrad_pl;
+	int i, err;
+
+	ratrad_pl = kmalloc(MLXSW_REG_RATRAD_LEN, GFP_KERNEL);
+	if (!ratrad_pl)
+		return;
+
+	mlxsw_reg_ratrad_pack(ratrad_pl, nh_grp->nhgi->adj_index,
+			      nh_grp->nhgi->count);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ratrad), ratrad_pl);
+	if (err)
+		goto out;
+
+	for (i = 0; i < nh_grp->nhgi->count; i++) {
+		if (!mlxsw_reg_ratrad_activity_vector_get(ratrad_pl, i))
+			continue;
+		bitmap_set(activity, i, 1);
+	}
+
+out:
+	kfree(ratrad_pl);
+}
+
 #define MLXSW_SP_NH_GRP_ACTIVITY_UPDATE_INTERVAL 1000 /* ms */
 
+static void
+mlxsw_sp_nh_grp_activity_update(struct mlxsw_sp *mlxsw_sp,
+				const struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	unsigned long *activity;
+
+	activity = bitmap_zalloc(nh_grp->nhgi->count, GFP_KERNEL);
+	if (!activity)
+		return;
+
+	mlxsw_sp_nh_grp_activity_get(mlxsw_sp, nh_grp, activity);
+	nexthop_res_grp_activity_update(mlxsw_sp_net(mlxsw_sp), nh_grp->obj.id,
+					nh_grp->nhgi->count, activity);
+
+	bitmap_free(activity);
+}
+
+static void
+mlxsw_sp_nh_grp_activity_work_schedule(struct mlxsw_sp *mlxsw_sp)
+{
+	unsigned int interval = MLXSW_SP_NH_GRP_ACTIVITY_UPDATE_INTERVAL;
+
+	mlxsw_core_schedule_dw(&mlxsw_sp->router->nh_grp_activity_dw,
+			       msecs_to_jiffies(interval));
+}
+
+static void mlxsw_sp_nh_grp_activity_work(struct work_struct *work)
+{
+	struct mlxsw_sp_nexthop_group_info *nhgi;
+	struct mlxsw_sp_router *router;
+	bool reschedule = false;
+
+	router = container_of(work, struct mlxsw_sp_router,
+			      nh_grp_activity_dw.work);
+
+	mutex_lock(&router->lock);
+
+	list_for_each_entry(nhgi, &router->nh_res_grp_list, list) {
+		mlxsw_sp_nh_grp_activity_update(router->mlxsw_sp, nhgi->nh_grp);
+		reschedule = true;
+	}
+
+	mutex_unlock(&router->lock);
+
+	if (!reschedule)
+		return;
+	mlxsw_sp_nh_grp_activity_work_schedule(router->mlxsw_sp);
+}
+
 static int
 mlxsw_sp_nexthop_obj_single_validate(struct mlxsw_sp *mlxsw_sp,
 				     const struct nh_notifier_single_info *nh,
@@ -4632,6 +4710,15 @@ mlxsw_sp_nexthop_obj_group_info_init(struct mlxsw_sp *mlxsw_sp,
 		goto err_group_refresh;
 	}
 
+	/* Add resilient nexthop groups to a list so that the activity of their
+	 * nexthop buckets will be periodically queried and cleared.
+	 */
+	if (nhgi->is_resilient) {
+		if (list_empty(&mlxsw_sp->router->nh_res_grp_list))
+			mlxsw_sp_nh_grp_activity_work_schedule(mlxsw_sp);
+		list_add(&nhgi->list, &mlxsw_sp->router->nh_res_grp_list);
+	}
+
 	return 0;
 
 err_group_refresh:
@@ -4650,8 +4737,15 @@ mlxsw_sp_nexthop_obj_group_info_fini(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_nexthop_group *nh_grp)
 {
 	struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
+	struct mlxsw_sp_router *router = mlxsw_sp->router;
 	int i;
 
+	if (nhgi->is_resilient) {
+		list_del(&nhgi->list);
+		if (list_empty(&mlxsw_sp->router->nh_res_grp_list))
+			cancel_delayed_work(&router->nh_grp_activity_dw);
+	}
+
 	for (i = nhgi->count - 1; i >= 0; i--) {
 		struct mlxsw_sp_nexthop *nh = &nhgi->nexthops[i];
 
@@ -9652,6 +9746,10 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_ll_op_ctx_init;
 
+	INIT_LIST_HEAD(&mlxsw_sp->router->nh_res_grp_list);
+	INIT_DELAYED_WORK(&mlxsw_sp->router->nh_grp_activity_dw,
+			  mlxsw_sp_nh_grp_activity_work);
+
 	INIT_LIST_HEAD(&mlxsw_sp->router->nexthop_neighs_list);
 	err = __mlxsw_sp_router_init(mlxsw_sp);
 	if (err)
@@ -9775,6 +9873,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_rifs_init:
 	__mlxsw_sp_router_fini(mlxsw_sp);
 err_router_init:
+	cancel_delayed_work_sync(&mlxsw_sp->router->nh_grp_activity_dw);
 	mlxsw_sp_router_ll_op_ctx_fini(router);
 err_ll_op_ctx_init:
 	mlxsw_sp_router_xm_fini(mlxsw_sp);
@@ -9806,6 +9905,7 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_ipips_fini(mlxsw_sp);
 	mlxsw_sp_rifs_fini(mlxsw_sp);
 	__mlxsw_sp_router_fini(mlxsw_sp);
+	cancel_delayed_work_sync(&mlxsw_sp->router->nh_grp_activity_dw);
 	mlxsw_sp_router_ll_op_ctx_fini(mlxsw_sp->router);
 	mlxsw_sp_router_xm_fini(mlxsw_sp);
 	mutex_destroy(&mlxsw_sp->router->lock);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index b85c5f6c2262..be7708a375e1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -80,6 +80,8 @@ struct mlxsw_sp_router {
 	struct mlxsw_sp_router_xm *xm;
 	const struct mlxsw_sp_adj_grp_size_range *adj_grp_size_ranges;
 	size_t adj_grp_size_ranges_count;
+	struct delayed_work nh_grp_activity_dw;
+	struct list_head nh_res_grp_list;
 };
 
 struct mlxsw_sp_fib_entry_priv {
-- 
2.30.2

