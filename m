Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74F4165835
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgBTHIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:39 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38853 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbgBTHIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:38 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C427621ACE;
        Thu, 20 Feb 2020 02:08:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=onmdnNgxXToeVASq/d+a4daqdDvUhaQHK/qbWd0783Y=; b=MDDxsCW5
        uLH4p2ax4mTUgw1GrUc4OynuKLDH0HWh52v8UgA9xFpiSEUSnZs/UvjBbleXfuer
        +B4aLrlLRW463Egy776+TTMzljW4cTasRIiJUqXtgwTlPfh6DxEPfNto/l3CQAZY
        ZFSqG3ya52YUnfVSTbFy7/dwxzCA1ja092u3GOduPIRt7s9nvo4QH4vquuQgp1eS
        8SzpLLoBJmTIlVYeAzboCY8qvflIxX06vToPzbPu51EmtTzPmgvSiTbOpfosbDUn
        W0M4SntwZVi302UyNjbS7J4KBjvT1X2zEYzikKwzSYHabiJJPm+9+D7e+Lt0oavb
        tCMPp8uDhpJDlQ==
X-ME-Sender: <xms:dDBOXpAY2dZrrxE7CJhUpU-tYYftiQzFtdnv3qZA5BsR1Rlp2lFmWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:dDBOXi_niQrQNzip04RYMEh3lpfxse3h7TV10JMaw1XmdRSxO4u6Iw>
    <xmx:dDBOXjTPsJPM3OZqpLTJiRyoIEnB4TWNe8ewxn7TAXW1uwLtRPn1fg>
    <xmx:dDBOXg4gAzG7zMK2xGQdTKycsmwUBR62Xakb5BcReA5N_2zBL7h13A>
    <xmx:dDBOXlJgjLabAd5SDxlrLjHowP2DFG5_6IVKTrwDiKasEJJ7I5livQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA8D13060C21;
        Thu, 20 Feb 2020 02:08:35 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 14/15] mlxsw: spectrum: Export function to check if RIF exists
Date:   Thu, 20 Feb 2020 09:07:59 +0200
Message-Id: <20200220070800.364235-15-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220070800.364235-1-idosch@idosch.org>
References: <20200220070800.364235-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

After the previous patch, all the callers of mlxsw_sp_rif_find_by_dev()
outside of the routing code use it to understand if a RIF exists for the
passed netdev.

Therefore, export a function to check if a RIF exists and make
mlxsw_sp_rif_find_by_dev() internal to the routing code.

This will later allow us to more easily introduce the router lock which
will also protect the RIFs.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c        |  8 ++++----
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h        |  4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 11 ++++++++++-
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 7358b5bc7eb6..d78e790ba94a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -6316,7 +6316,7 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 			return -EINVAL;
 		}
 		if (netif_is_macvlan(upper_dev) &&
-		    !mlxsw_sp_rif_find_by_dev(mlxsw_sp, lower_dev)) {
+		    !mlxsw_sp_rif_exists(mlxsw_sp, lower_dev)) {
 			NL_SET_ERR_MSG_MOD(extack, "macvlan is only supported on top of router interfaces");
 			return -EOPNOTSUPP;
 		}
@@ -6472,7 +6472,7 @@ static int mlxsw_sp_netdevice_port_vlan_event(struct net_device *vlan_dev,
 			return -EINVAL;
 		}
 		if (netif_is_macvlan(upper_dev) &&
-		    !mlxsw_sp_rif_find_by_dev(mlxsw_sp, vlan_dev)) {
+		    !mlxsw_sp_rif_exists(mlxsw_sp, vlan_dev)) {
 			NL_SET_ERR_MSG_MOD(extack, "macvlan is only supported on top of router interfaces");
 			return -EOPNOTSUPP;
 		}
@@ -6549,7 +6549,7 @@ static int mlxsw_sp_netdevice_bridge_vlan_event(struct net_device *vlan_dev,
 		if (!info->linking)
 			break;
 		if (netif_is_macvlan(upper_dev) &&
-		    !mlxsw_sp_rif_find_by_dev(mlxsw_sp, vlan_dev)) {
+		    !mlxsw_sp_rif_exists(mlxsw_sp, vlan_dev)) {
 			NL_SET_ERR_MSG_MOD(extack, "macvlan is only supported on top of router interfaces");
 			return -EOPNOTSUPP;
 		}
@@ -6609,7 +6609,7 @@ static int mlxsw_sp_netdevice_bridge_event(struct net_device *br_dev,
 		if (!info->linking)
 			break;
 		if (netif_is_macvlan(upper_dev) &&
-		    !mlxsw_sp_rif_find_by_dev(mlxsw_sp, br_dev)) {
+		    !mlxsw_sp_rif_exists(mlxsw_sp, br_dev)) {
 			NL_SET_ERR_MSG_MOD(extack, "macvlan is only supported on top of router interfaces");
 			return -EOPNOTSUPP;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 890af4f9f1b8..bed86f4825a8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -563,8 +563,8 @@ void
 mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan);
 void mlxsw_sp_rif_destroy_by_dev(struct mlxsw_sp *mlxsw_sp,
 				 struct net_device *dev);
-struct mlxsw_sp_rif *mlxsw_sp_rif_find_by_dev(const struct mlxsw_sp *mlxsw_sp,
-					      const struct net_device *dev);
+bool mlxsw_sp_rif_exists(struct mlxsw_sp *mlxsw_sp,
+			 const struct net_device *dev);
 u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev);
 u8 mlxsw_sp_router_port(const struct mlxsw_sp *mlxsw_sp);
 int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 535788cced8c..634a9a949777 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -145,6 +145,9 @@ struct mlxsw_sp_rif_ops {
 	void (*fdb_del)(struct mlxsw_sp_rif *rif, const char *mac);
 };
 
+static struct mlxsw_sp_rif *
+mlxsw_sp_rif_find_by_dev(const struct mlxsw_sp *mlxsw_sp,
+			 const struct net_device *dev);
 static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif);
 static void mlxsw_sp_lpm_tree_hold(struct mlxsw_sp_lpm_tree *lpm_tree);
 static void mlxsw_sp_lpm_tree_put(struct mlxsw_sp *mlxsw_sp,
@@ -6256,7 +6259,7 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 	return NOTIFY_BAD;
 }
 
-struct mlxsw_sp_rif *
+static struct mlxsw_sp_rif *
 mlxsw_sp_rif_find_by_dev(const struct mlxsw_sp *mlxsw_sp,
 			 const struct net_device *dev)
 {
@@ -6270,6 +6273,12 @@ mlxsw_sp_rif_find_by_dev(const struct mlxsw_sp *mlxsw_sp,
 	return NULL;
 }
 
+bool mlxsw_sp_rif_exists(struct mlxsw_sp *mlxsw_sp,
+			 const struct net_device *dev)
+{
+	return !!mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
+}
+
 u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev)
 {
 	struct mlxsw_sp_rif *rif;
-- 
2.24.1

