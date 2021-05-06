Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55D837501C
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 09:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbhEFHZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 03:25:28 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53565 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233378AbhEFHZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 03:25:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D8375C00F2;
        Thu,  6 May 2021 03:24:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 06 May 2021 03:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dunuqcwK9OLviMsU2
        CESa6ag2jdxH/v4Jenxqgi7q7k=; b=hFyqOFOLJoRv8wW6BYwXJME95QvDx+BGO
        QKNeYaHpRhUdw2W/9YHllvX7dxS+P8uIsg7sOyasR+K9+xuBfCpCwCu6qP1yzRcR
        h91J44sJeaklIB2ZzmfJuqTiNUC4Iye5VB8WZ39zqa9Ml8lbO6VEjCwNp3IuaBzB
        TI6F99C+MSS59jv7YF/RdQkaC2CDe1VIIZ6tEoE1YtY04tkxhrr0p/FdeOG3vtaf
        5K6KgxIZyOIB37UK5Aq0vEYx0aF8P8PVTYy67hp4kcf8Jqaj0lIccdA6oOlVcNbT
        fV4UaPFPGzYuRdsOj3QKYSUVsiW2q6vo/OUOkTwQTmhtD1lKqi/hg==
X-ME-Sender: <xms:rJmTYBmFzyzQrwCKwLxig5pVabuz2Uytre_kDoCqmWJBhX1lDJOOyQ>
    <xme:rJmTYM098i4gP_CF9UiONWrBW5FsASUCAE7VgrP7bb-cplRfPdEucww7zedcLJLCQ
    RM2A2qeiUnpmdk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefledguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrddukeej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:rJmTYHrWBlePy-FbecqNSR555YtPDLR3xGXWnuyk0itgxk2gf0tBHw>
    <xmx:rJmTYBla9vvaWA6HCdJuZNPKnEr-JrcB3mVwFc_gz1Key_8W72rkIA>
    <xmx:rJmTYP2WJpa5NRLh8MqAvi7vmF-z91EtyzuvV8y0x3nv6vaonJrUXA>
    <xmx:rZmTYKScRKkNvJp4huMuqavHagmxygr16jkwSIwQ-_HNtqUDVE3POw>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu,  6 May 2021 03:24:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH net] mlxsw: spectrum_mr: Update egress RIF list before route's action
Date:   Thu,  6 May 2021 10:23:08 +0300
Message-Id: <20210506072308.3834303-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Each multicast route that is forwarding packets (as opposed to trapping
them) points to a list of egress router interfaces (RIFs) through which
packets are replicated.

A route's action can transition from trap to forward when a RIF is
created for one of the route's egress virtual interfaces (eVIF). When
this happens, the route's action is first updated and only later the
list of egress RIFs is committed to the device.

This results in the route pointing to an invalid list. In case the list
pointer is out of range (due to uninitialized memory), the device will
complain:

mlxsw_spectrum2 0000:06:00.0: EMAD reg access failed (tid=5733bf490000905c,reg_id=300f(pefa),type=write,status=7(bad parameter))

Fix this by first committing the list of egress RIFs to the device and
only later update the route's action.

Note that a fix is not needed in the reverse function (i.e.,
mlxsw_sp_mr_route_evif_unresolve()), as there the route's action is
first updated and only later the RIF is removed from the list.

Cc: stable@vger.kernel.org
Fixes: c011ec1bbfd6 ("mlxsw: spectrum: Add the multicast routing offloading logic")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_mr.c | 30 +++++++++----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index 7846a21555ef..1f6bc0c7e91d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -535,6 +535,16 @@ mlxsw_sp_mr_route_evif_resolve(struct mlxsw_sp_mr_table *mr_table,
 	u16 erif_index = 0;
 	int err;
 
+	/* Add the eRIF */
+	if (mlxsw_sp_mr_vif_valid(rve->mr_vif)) {
+		erif_index = mlxsw_sp_rif_index(rve->mr_vif->rif);
+		err = mr->mr_ops->route_erif_add(mlxsw_sp,
+						 rve->mr_route->route_priv,
+						 erif_index);
+		if (err)
+			return err;
+	}
+
 	/* Update the route action, as the new eVIF can be a tunnel or a pimreg
 	 * device which will require updating the action.
 	 */
@@ -544,17 +554,7 @@ mlxsw_sp_mr_route_evif_resolve(struct mlxsw_sp_mr_table *mr_table,
 						      rve->mr_route->route_priv,
 						      route_action);
 		if (err)
-			return err;
-	}
-
-	/* Add the eRIF */
-	if (mlxsw_sp_mr_vif_valid(rve->mr_vif)) {
-		erif_index = mlxsw_sp_rif_index(rve->mr_vif->rif);
-		err = mr->mr_ops->route_erif_add(mlxsw_sp,
-						 rve->mr_route->route_priv,
-						 erif_index);
-		if (err)
-			goto err_route_erif_add;
+			goto err_route_action_update;
 	}
 
 	/* Update the minimum MTU */
@@ -572,14 +572,14 @@ mlxsw_sp_mr_route_evif_resolve(struct mlxsw_sp_mr_table *mr_table,
 	return 0;
 
 err_route_min_mtu_update:
-	if (mlxsw_sp_mr_vif_valid(rve->mr_vif))
-		mr->mr_ops->route_erif_del(mlxsw_sp, rve->mr_route->route_priv,
-					   erif_index);
-err_route_erif_add:
 	if (route_action != rve->mr_route->route_action)
 		mr->mr_ops->route_action_update(mlxsw_sp,
 						rve->mr_route->route_priv,
 						rve->mr_route->route_action);
+err_route_action_update:
+	if (mlxsw_sp_mr_vif_valid(rve->mr_vif))
+		mr->mr_ops->route_erif_del(mlxsw_sp, rve->mr_route->route_priv,
+					   erif_index);
 	return err;
 }
 
-- 
2.30.2

