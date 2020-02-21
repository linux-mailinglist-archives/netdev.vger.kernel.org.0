Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6DF1685AE
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbgBURzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:55:02 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56303 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729169AbgBURy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:54:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9FE32217DD;
        Fri, 21 Feb 2020 12:54:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/Ie5nd9/VvZwBIi7a05QKYd+BWzNUSN6vGy1bnWStr8=; b=fh2XjWac
        FDhs4gpNnMUBbTajciKaFpXuipumBr8y1XdMNUf+27IIOxrvS+SZepTQV1bu8B9r
        b945C68vLn0Cr/gEb1EEuIY+/tIyYnIdgj70n8TaG5YV+HXrMCndBIpgscMuWtas
        hflSXShV61Q+MbWcJXaaFkMlucK1WBb6xjZpK/iAPiToPop1v7Uob1Li8H0Ju1vl
        Pu4T0D6nH59VDZ/BgzQ7GFY6aV1RwboKTk6FEZ9rIwn7qnQWTxxr1+lh7gBewFyE
        TZ6lSvA/1fGRjCiTnom11Z2WeqMJDux8tTdDQn+N4Qg5mClBtyPleyr3jCrSupXk
        4vbUmAxuOTmorQ==
X-ME-Sender: <xms:bxlQXgqIIqQEEpGannLH6W2xy43Qh3eYtJMQTKUWVxqhlegYUXC56Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:bxlQXvQrc_W8iYX5mtvTzleRLq9F5jmonW8mRbQQ2RTgY0a7dn36Mg>
    <xmx:bxlQXsrBWw-HFIdL8-3SCsA2tmpmo3mEoQlyjGvcCghE1EOUyTSuHg>
    <xmx:bxlQXh0aMJyWVfL55QkYSdqcBMqZCgbnYMhujgG_qfDLRW2BiHD4NQ>
    <xmx:bxlQXsBROVbRpubP7ZFlGp-5oh68PypbPQRw0lvid8YVyCBccqGGbA>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0E9133060FCB;
        Fri, 21 Feb 2020 12:54:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/12] mlxsw: spectrum_dpipe: Take router lock from dpipe code
Date:   Fri, 21 Feb 2020 19:54:11 +0200
Message-Id: <20200221175415.390884-9-idosch@idosch.org>
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

The dpipe code traverses internal router structures such as neighbours
and adjacency entries and dumps them to user space via netlink. Up until
now the routing code did not have its own locks and relied on RTNL lock
to serialize access. This is going to change with the introduction of
the router lock.

Take the router lock in the code paths where RTNL lock is currently
taken so that the latter could be removed by subsequent patches.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c   | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index 2dc0978428e6..63fc1f56ef00 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2017-2018 Mellanox Technologies. All rights reserved */
 
 #include <linux/kernel.h>
+#include <linux/mutex.h>
 #include <net/devlink.h>
 
 #include "spectrum.h"
@@ -211,6 +212,7 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 
 	rif_count = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	i = 0;
 start_again:
 	err = devlink_dpipe_entry_ctx_prepare(dump_ctx);
@@ -241,6 +243,7 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 	devlink_dpipe_entry_ctx_close(dump_ctx);
 	if (i != rif_count)
 		goto start_again;
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 
 	devlink_dpipe_entry_clear(&entry);
@@ -248,6 +251,7 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 err_entry_append:
 err_entry_get:
 err_ctx_prepare:
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 	devlink_dpipe_entry_clear(&entry);
 	return err;
@@ -259,6 +263,7 @@ static int mlxsw_sp_dpipe_table_erif_counters_update(void *priv, bool enable)
 	int i;
 
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++) {
 		struct mlxsw_sp_rif *rif = mlxsw_sp_rif_by_index(mlxsw_sp, i);
 
@@ -271,6 +276,7 @@ static int mlxsw_sp_dpipe_table_erif_counters_update(void *priv, bool enable)
 			mlxsw_sp_rif_counter_free(mlxsw_sp, rif,
 						  MLXSW_SP_RIF_COUNTER_EGRESS);
 	}
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 	return 0;
 }
@@ -547,6 +553,7 @@ mlxsw_sp_dpipe_table_host_entries_get(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	i = 0;
 	rif_count = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
 start_again:
@@ -602,11 +609,13 @@ mlxsw_sp_dpipe_table_host_entries_get(struct mlxsw_sp *mlxsw_sp,
 	if (i != rif_count)
 		goto start_again;
 
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 	return 0;
 
 err_ctx_prepare:
 err_entry_append:
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 	return err;
 }
@@ -663,6 +672,7 @@ mlxsw_sp_dpipe_table_host_counters_update(struct mlxsw_sp *mlxsw_sp,
 	int i;
 
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++) {
 		struct mlxsw_sp_rif *rif = mlxsw_sp_rif_by_index(mlxsw_sp, i);
 		struct mlxsw_sp_neigh_entry *neigh_entry;
@@ -684,6 +694,7 @@ mlxsw_sp_dpipe_table_host_counters_update(struct mlxsw_sp *mlxsw_sp,
 							    enable);
 		}
 	}
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 }
 
@@ -702,6 +713,7 @@ mlxsw_sp_dpipe_table_host_size_get(struct mlxsw_sp *mlxsw_sp, int type)
 	int i;
 
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++) {
 		struct mlxsw_sp_rif *rif = mlxsw_sp_rif_by_index(mlxsw_sp, i);
 		struct mlxsw_sp_neigh_entry *neigh_entry;
@@ -721,6 +733,7 @@ mlxsw_sp_dpipe_table_host_size_get(struct mlxsw_sp *mlxsw_sp, int type)
 			size++;
 		}
 	}
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 
 	return size;
@@ -1094,6 +1107,7 @@ mlxsw_sp_dpipe_table_adj_entries_get(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	nh_count_max = mlxsw_sp_dpipe_table_adj_size(mlxsw_sp);
 start_again:
 	err = devlink_dpipe_entry_ctx_prepare(dump_ctx);
@@ -1130,12 +1144,14 @@ mlxsw_sp_dpipe_table_adj_entries_get(struct mlxsw_sp *mlxsw_sp,
 	devlink_dpipe_entry_ctx_close(dump_ctx);
 	if (nh_count != nh_count_max)
 		goto start_again;
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 
 	return 0;
 
 err_ctx_prepare:
 err_entry_append:
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 	return err;
 }
@@ -1207,7 +1223,9 @@ mlxsw_sp_dpipe_table_adj_size_get(void *priv)
 	u64 size;
 
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	size = mlxsw_sp_dpipe_table_adj_size(mlxsw_sp);
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 
 	return size;
-- 
2.24.1

