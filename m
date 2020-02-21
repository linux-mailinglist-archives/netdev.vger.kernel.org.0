Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054F41685A4
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgBURyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:54:47 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33115 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728699AbgBURyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:54:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F37A52207D;
        Fri, 21 Feb 2020 12:54:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:54:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=dlelFQQIRIn/QHOwfgXWK///zuZ0PoXCi4vaMZf1/GI=; b=CPLNba+j
        8TDFQEbAO8iaFYrPgpS7PzSOYHQ/sYLJoJTddlycC1iuf3OuEz9khkcujEbi/Q5D
        VOE1NL4ohW1JdOw/jlmMtJG8ZwmQzT6+99gnQ4g1FaJ8dKuE6hyobrE1CFoCRGPr
        QDa+3IjKqz+kc0efCJlkOR04xth53xU5N5enmTJigD7JMLUwqapgPBAkF03DOE0e
        KDiFrWuWsAqdZ0od9HRqq1MjkM/hAdRO+4O5o7WM8CUWEK2aMyiVdDeQRMOOy4/I
        J9+OOug8GkUm2WVxy8+w/5c2S/9/lcjDnmZcvc+kp5cLMEJA/oYDlIf3TN+4jew3
        0sdHWanVvJGV4A==
X-ME-Sender: <xms:ZBlQXvtKKY2xp0chmB_lpiPHMC5KtCI8hyEXgAY459o_JdsIoX-hFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:ZBlQXsxbAb9Jhe59wd2_GUzNRHiqmHAQVSBMGi6_OPZ2Zu_Qb6b8Vw>
    <xmx:ZBlQXlhnHCMB9Uh9sKMnhVPu49kuo0d10JFQMbeXPUzAzIsp7Rjp7g>
    <xmx:ZBlQXgCwpOUFDBC0fka2bthCXcUg6QpGLkP6dslo0Aka9sCy4mV1KA>
    <xmx:ZBlQXlf0DSATYqa0lEJf7gUOtX2P5eulnheudnevR3C56ymhDnJj6Q>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id 47CB03060BD1;
        Fri, 21 Feb 2020 12:54:43 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/12] mlxsw: spectrum_mr: Protect multicast table list with a lock
Date:   Fri, 21 Feb 2020 19:54:05 +0200
Message-Id: <20200221175415.390884-3-idosch@idosch.org>
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

The multicast table list is traversed from a delayed work that
periodically updates the kernel about packets and bytes statistics from
each multicast route.

The list is currently protected by RTNL, but subsequent patches will
remove the driver's dependence on this contended lock.

In order to be able to remove dependence on RTNL in the next patch,
guard this list with a dedicated mutex.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index e40437d5aa76..0d64d8c4038b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
 /* Copyright (c) 2017-2018 Mellanox Technologies. All rights reserved */
 
+#include <linux/mutex.h>
 #include <linux/rhashtable.h>
 #include <net/ipv6.h>
 
@@ -12,6 +13,7 @@ struct mlxsw_sp_mr {
 	void *catchall_route_priv;
 	struct delayed_work stats_update_dw;
 	struct list_head table_list;
+	struct mutex table_list_lock; /* Protects table_list */
 #define MLXSW_SP_MR_ROUTES_COUNTER_UPDATE_INTERVAL 5000 /* ms */
 	unsigned long priv[0];
 	/* priv has to be always the last item */
@@ -926,7 +928,9 @@ struct mlxsw_sp_mr_table *mlxsw_sp_mr_table_create(struct mlxsw_sp *mlxsw_sp,
 				       &catchall_route_params);
 	if (err)
 		goto err_ops_route_create;
+	mutex_lock(&mr->table_list_lock);
 	list_add_tail(&mr_table->node, &mr->table_list);
+	mutex_unlock(&mr->table_list_lock);
 	return mr_table;
 
 err_ops_route_create:
@@ -942,7 +946,9 @@ void mlxsw_sp_mr_table_destroy(struct mlxsw_sp_mr_table *mr_table)
 	struct mlxsw_sp_mr *mr = mlxsw_sp->mr;
 
 	WARN_ON(!mlxsw_sp_mr_table_empty(mr_table));
+	mutex_lock(&mr->table_list_lock);
 	list_del(&mr_table->node);
+	mutex_unlock(&mr->table_list_lock);
 	mr->mr_ops->route_destroy(mlxsw_sp, mr->priv,
 				  &mr_table->catchall_route_priv);
 	rhashtable_destroy(&mr_table->route_ht);
@@ -1000,10 +1006,12 @@ static void mlxsw_sp_mr_stats_update(struct work_struct *work)
 	unsigned long interval;
 
 	rtnl_lock();
+	mutex_lock(&mr->table_list_lock);
 	list_for_each_entry(mr_table, &mr->table_list, node)
 		list_for_each_entry(mr_route, &mr_table->route_list, node)
 			mlxsw_sp_mr_route_stats_update(mr_table->mlxsw_sp,
 						       mr_route);
+	mutex_unlock(&mr->table_list_lock);
 	rtnl_unlock();
 
 	interval = msecs_to_jiffies(MLXSW_SP_MR_ROUTES_COUNTER_UPDATE_INTERVAL);
@@ -1023,6 +1031,7 @@ int mlxsw_sp_mr_init(struct mlxsw_sp *mlxsw_sp,
 	mr->mr_ops = mr_ops;
 	mlxsw_sp->mr = mr;
 	INIT_LIST_HEAD(&mr->table_list);
+	mutex_init(&mr->table_list_lock);
 
 	err = mr_ops->init(mlxsw_sp, mr->priv);
 	if (err)
@@ -1034,6 +1043,7 @@ int mlxsw_sp_mr_init(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_core_schedule_dw(&mr->stats_update_dw, interval);
 	return 0;
 err:
+	mutex_destroy(&mr->table_list_lock);
 	kfree(mr);
 	return err;
 }
@@ -1044,5 +1054,6 @@ void mlxsw_sp_mr_fini(struct mlxsw_sp *mlxsw_sp)
 
 	cancel_delayed_work_sync(&mr->stats_update_dw);
 	mr->mr_ops->fini(mlxsw_sp, mr->priv);
+	mutex_destroy(&mr->table_list_lock);
 	kfree(mr);
 }
-- 
2.24.1

