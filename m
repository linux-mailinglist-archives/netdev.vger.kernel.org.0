Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8161685B0
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbgBURzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:55:06 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40647 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729169AbgBURzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:55:04 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3FC0B21B2B;
        Fri, 21 Feb 2020 12:55:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:55:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/yf6DN2TFT6DXPIxCSzyO5KpYtVBCu31dEEnds0Z7hI=; b=20YRJlog
        3bkdltW6DrGvMJ3Xv7HcfcpfYT+rfXxGwvOqCtUWd2IoknrONvi5AfhFuz4I2Mqq
        N/1buanru8NVywiOIz4GzGP/rY7ggVQCEhQ2k2ifhSyP5h62H5xeRjetIYF4i0/c
        G6ubjxvdPz1vq3yGvH+czgPiBzZ2O3M0a1SeNJLuYK2dqORJAclJnSqAsxeF66NB
        ybemG12R0M+eNgLSNjvjhPE6ywFfZ/t3a5efnmToIlykAwrzQbE49qYghvzJOJh0
        +P01pWPQ+CBfhOb2cBBqCPyWqZS3Jx2CD/x+fqnI1OO6sPRSU5x22WBVqTk7IbOm
        6gXzh0Zv1RaigQ==
X-ME-Sender: <xms:dxlQXrCHxz-QtgptDKvACGcsrvFv7dQi9oHV-Y0h6BvevA5WwqHKNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpeduudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:dxlQXlcPhsdE_esLf2tNyiTThCKaHbeFbxTz_-eYUbjQC1CpT5Sqqg>
    <xmx:dxlQXvqwQzuKYKNohJiFwPLzPxpvO66M1V1tSHgVgqTdbKTPoqD0eg>
    <xmx:dxlQXmR-8bewmB74dW2LT3u0wDPgjdKxOOeJsEd4BArJy6J1Rw4sBQ>
    <xmx:dxlQXq9pMQKNW3HywWjc_kXrwbof7JlRoqwAAtQaahtb49urCFcHkw>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id 65F193060BD1;
        Fri, 21 Feb 2020 12:55:01 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/12] mlxsw: spectrum: Remove RTNL where possible
Date:   Fri, 21 Feb 2020 19:54:15 +0200
Message-Id: <20200221175415.390884-13-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221175415.390884-1-idosch@idosch.org>
References: <20200221175415.390884-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

After introducing the router lock in previous patches and making sure it
protects internal router structures, we no longer need to rely on RTNL
to serialize access to these structures.

Remove RTNL from call sites that no longer require it.

Two calls sites that keep taking the lock are
mlxsw_sp_router_fibmr_event_work() and mlxsw_sp_inet6addr_event_work().
The first calls into ACL code that still assumes RTNL is taken. The
second potentially calls into the FID code that also relies on RTNL.
Removing RTNL from these two call sites is the subject of future work.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c    | 17 -----------------
 .../ethernet/mellanox/mlxsw/spectrum_router.c   | 12 ------------
 2 files changed, 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index 63fc1f56ef00..daf029931b5f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -211,7 +211,6 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 		return err;
 
 	rif_count = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
-	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
 	i = 0;
 start_again:
@@ -244,7 +243,6 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 	if (i != rif_count)
 		goto start_again;
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 
 	devlink_dpipe_entry_clear(&entry);
 	return 0;
@@ -252,7 +250,6 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 err_entry_get:
 err_ctx_prepare:
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 	devlink_dpipe_entry_clear(&entry);
 	return err;
 }
@@ -262,7 +259,6 @@ static int mlxsw_sp_dpipe_table_erif_counters_update(void *priv, bool enable)
 	struct mlxsw_sp *mlxsw_sp = priv;
 	int i;
 
-	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++) {
 		struct mlxsw_sp_rif *rif = mlxsw_sp_rif_by_index(mlxsw_sp, i);
@@ -277,7 +273,6 @@ static int mlxsw_sp_dpipe_table_erif_counters_update(void *priv, bool enable)
 						  MLXSW_SP_RIF_COUNTER_EGRESS);
 	}
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 	return 0;
 }
 
@@ -552,7 +547,6 @@ mlxsw_sp_dpipe_table_host_entries_get(struct mlxsw_sp *mlxsw_sp,
 	int i, j;
 	int err;
 
-	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
 	i = 0;
 	rif_count = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
@@ -610,13 +604,11 @@ mlxsw_sp_dpipe_table_host_entries_get(struct mlxsw_sp *mlxsw_sp,
 		goto start_again;
 
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 	return 0;
 
 err_ctx_prepare:
 err_entry_append:
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 	return err;
 }
 
@@ -671,7 +663,6 @@ mlxsw_sp_dpipe_table_host_counters_update(struct mlxsw_sp *mlxsw_sp,
 {
 	int i;
 
-	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++) {
 		struct mlxsw_sp_rif *rif = mlxsw_sp_rif_by_index(mlxsw_sp, i);
@@ -695,7 +686,6 @@ mlxsw_sp_dpipe_table_host_counters_update(struct mlxsw_sp *mlxsw_sp,
 		}
 	}
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 }
 
 static int mlxsw_sp_dpipe_table_host4_counters_update(void *priv, bool enable)
@@ -712,7 +702,6 @@ mlxsw_sp_dpipe_table_host_size_get(struct mlxsw_sp *mlxsw_sp, int type)
 	u64 size = 0;
 	int i;
 
-	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++) {
 		struct mlxsw_sp_rif *rif = mlxsw_sp_rif_by_index(mlxsw_sp, i);
@@ -734,7 +723,6 @@ mlxsw_sp_dpipe_table_host_size_get(struct mlxsw_sp *mlxsw_sp, int type)
 		}
 	}
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 
 	return size;
 }
@@ -1106,7 +1094,6 @@ mlxsw_sp_dpipe_table_adj_entries_get(struct mlxsw_sp *mlxsw_sp,
 	int j;
 	int err;
 
-	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
 	nh_count_max = mlxsw_sp_dpipe_table_adj_size(mlxsw_sp);
 start_again:
@@ -1145,14 +1132,12 @@ mlxsw_sp_dpipe_table_adj_entries_get(struct mlxsw_sp *mlxsw_sp,
 	if (nh_count != nh_count_max)
 		goto start_again;
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 
 	return 0;
 
 err_ctx_prepare:
 err_entry_append:
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 	return err;
 }
 
@@ -1222,11 +1207,9 @@ mlxsw_sp_dpipe_table_adj_size_get(void *priv)
 	struct mlxsw_sp *mlxsw_sp = priv;
 	u64 size;
 
-	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
 	size = mlxsw_sp_dpipe_table_adj_size(mlxsw_sp);
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 
 	return size;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0f5ecb47d0c2..b527387ccf80 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2307,7 +2307,6 @@ __mlxsw_sp_router_neighs_update_rauhtd(struct mlxsw_sp *mlxsw_sp,
 	int i, num_rec;
 	int err;
 
-	rtnl_lock();
 	/* Ensure the RIF we read from the device does not change mid-dump. */
 	mutex_lock(&mlxsw_sp->router->lock);
 	do {
@@ -2324,7 +2323,6 @@ __mlxsw_sp_router_neighs_update_rauhtd(struct mlxsw_sp *mlxsw_sp,
 							  i);
 	} while (mlxsw_sp_router_rauhtd_is_full(rauhtd_pl));
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 
 	return err;
 }
@@ -2355,7 +2353,6 @@ static void mlxsw_sp_router_neighs_update_nh(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_neigh_entry *neigh_entry;
 
-	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
 	list_for_each_entry(neigh_entry, &mlxsw_sp->router->nexthop_neighs_list,
 			    nexthop_neighs_list_node)
@@ -2364,7 +2361,6 @@ static void mlxsw_sp_router_neighs_update_nh(struct mlxsw_sp *mlxsw_sp)
 		 */
 		neigh_event_send(neigh_entry->key.n, NULL);
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 }
 
 static void
@@ -2405,14 +2401,12 @@ static void mlxsw_sp_router_probe_unresolved_nexthops(struct work_struct *work)
 	 * but it wouldn't get resolved ever in case traffic is flowing in HW
 	 * using different nexthop.
 	 */
-	rtnl_lock();
 	mutex_lock(&router->lock);
 	list_for_each_entry(neigh_entry, &router->nexthop_neighs_list,
 			    nexthop_neighs_list_node)
 		if (!neigh_entry->connected)
 			neigh_event_send(neigh_entry->key.n, NULL);
 	mutex_unlock(&router->lock);
-	rtnl_unlock();
 
 	mlxsw_core_schedule_dw(&router->nexthop_probe_dw,
 			       MLXSW_SP_UNRESOLVED_NH_PROBE_INTERVAL);
@@ -2550,7 +2544,6 @@ static void mlxsw_sp_router_neigh_event_work(struct work_struct *work)
 	dead = n->dead;
 	read_unlock_bh(&n->lock);
 
-	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
@@ -2574,7 +2567,6 @@ static void mlxsw_sp_router_neigh_event_work(struct work_struct *work)
 
 out:
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 	neigh_release(n);
 	kfree(net_work);
 }
@@ -5981,7 +5973,6 @@ static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
 	int err;
 
-	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
@@ -6005,7 +5996,6 @@ static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 		break;
 	}
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 	kfree(fib_work);
 }
 
@@ -6016,7 +6006,6 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
 	int err;
 
-	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
@@ -6045,7 +6034,6 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 		break;
 	}
 	mutex_unlock(&mlxsw_sp->router->lock);
-	rtnl_unlock();
 	kfree(fib_work);
 }
 
-- 
2.24.1

