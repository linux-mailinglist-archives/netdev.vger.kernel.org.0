Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4D91685A3
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgBURyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:54:45 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36185 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728699AbgBURyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:54:43 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1888A2207D;
        Fri, 21 Feb 2020 12:54:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:54:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Kx/SPIS+iSzjZDPgSw1tAcmzq+jDtXl+s/Ia7pEDPmk=; b=u+GTbhd2
        fKyXwPjYMnhdkFr/PLgjnIOAxltMR3k8Xeq65YlDlj7SEWypcxjiH8khbnu6+hPn
        Do7Q5TJbeXFG8G1ogxmk9nuTRCnrfKuGAdBLvOmwhc6cwO3a9xZpe+kdVYdSpArI
        mphEIUhxxTa4N+LxOmq1HFebQIYVjKvY97hW0X76GhJi/duDQkFc2snc5hJ58IkQ
        06xWB9sQQIvzPvIU1xgNOyfOVPuKnImw0IbJueGFG1XAkkAZvzufUxWTY53V00xy
        WvzHpAXFMQqtZgDt/3osPb/Kxh45/OW1vnPq9IfiScRnSNbu8OGNR6FUJSUO+x8j
        uqnd25uswmSrcg==
X-ME-Sender: <xms:YhlQXgx1WCdqProEkQ5yaTzLcvERLzG0OL_Pvzn1z0Bww-z_y3jRtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:YhlQXoiTByrnzZd2RBhJpUne2jklDSmapNrzxMVwLhP9FiCk7tyAHA>
    <xmx:YhlQXtXt0GZLdnZV4KnAmbRr6rIF36m5Qh8GW_x2kLSDf6z-C_6azw>
    <xmx:YhlQXi2r_YGOm5LKTMG4kCcU5A4XcpRpHpi0JXf9wW-TbkvQi1ibag>
    <xmx:YxlQXjAlFzdCkGBzHLJQv_jA--nqgF-RDT0WZlZUe4gIxLNpp8jh9A>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D0443060C21;
        Fri, 21 Feb 2020 12:54:41 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/12] mlxsw: spectrum_mr: Publish multicast route after writing it to the device
Date:   Fri, 21 Feb 2020 19:54:04 +0200
Message-Id: <20200221175415.390884-2-idosch@idosch.org>
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

The driver periodically traverses the linked list of multicast routes
and updates the kernel about packets and bytes statistics from each
multicast route. These statistics are read from a counter associated
with the route when it is written to the device.

Currently, multicast routes are published via this linked list before
they are associated with a counter. Despite that, it is not possible for
the driver to access an invalid counter because the delayed work that
reads the statistics and multicast route addition / deletion are
mutually exclusive using RTNL.

In order to be able to remove RTNL, the list needs to be protected by a
dedicated lock, but any route published via the list must have an
associated counter, otherwise the driver will access an invalid counter.

Solve this by re-ordering the operations during multicast route addition
so that the route is only added to the linked list after it was written
to the device. Similarly, during deletion the route is first removed
from the linked list before its deletion from the device.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_mr.c   | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index 423eedebcd22..e40437d5aa76 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -371,10 +371,10 @@ static void __mlxsw_sp_mr_route_del(struct mlxsw_sp_mr_table *mr_table,
 				    struct mlxsw_sp_mr_route *mr_route)
 {
 	mlxsw_sp_mr_mfc_offload_set(mr_route, false);
-	mlxsw_sp_mr_route_erase(mr_table, mr_route);
 	rhashtable_remove_fast(&mr_table->route_ht, &mr_route->ht_node,
 			       mlxsw_sp_mr_route_ht_params);
 	list_del(&mr_route->node);
+	mlxsw_sp_mr_route_erase(mr_table, mr_route);
 	mlxsw_sp_mr_route_destroy(mr_table, mr_route);
 }
 
@@ -415,6 +415,11 @@ int mlxsw_sp_mr_route_add(struct mlxsw_sp_mr_table *mr_table,
 		goto err_duplicate_route;
 	}
 
+	/* Write the route to the hardware */
+	err = mlxsw_sp_mr_route_write(mr_table, mr_route, replace);
+	if (err)
+		goto err_mr_route_write;
+
 	/* Put it in the table data-structures */
 	list_add_tail(&mr_route->node, &mr_table->route_list);
 	err = rhashtable_insert_fast(&mr_table->route_ht,
@@ -423,11 +428,6 @@ int mlxsw_sp_mr_route_add(struct mlxsw_sp_mr_table *mr_table,
 	if (err)
 		goto err_rhashtable_insert;
 
-	/* Write the route to the hardware */
-	err = mlxsw_sp_mr_route_write(mr_table, mr_route, replace);
-	if (err)
-		goto err_mr_route_write;
-
 	/* Destroy the original route */
 	if (replace) {
 		rhashtable_remove_fast(&mr_table->route_ht,
@@ -440,11 +440,10 @@ int mlxsw_sp_mr_route_add(struct mlxsw_sp_mr_table *mr_table,
 	mlxsw_sp_mr_mfc_offload_update(mr_route);
 	return 0;
 
-err_mr_route_write:
-	rhashtable_remove_fast(&mr_table->route_ht, &mr_route->ht_node,
-			       mlxsw_sp_mr_route_ht_params);
 err_rhashtable_insert:
 	list_del(&mr_route->node);
+	mlxsw_sp_mr_route_erase(mr_table, mr_route);
+err_mr_route_write:
 err_no_orig_route:
 err_duplicate_route:
 	mlxsw_sp_mr_route_destroy(mr_table, mr_route);
-- 
2.24.1

