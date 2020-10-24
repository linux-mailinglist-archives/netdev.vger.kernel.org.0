Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2093A297C9B
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 15:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761756AbgJXNiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 09:38:09 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:54171 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1761745AbgJXNiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 09:38:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C617ACAD;
        Sat, 24 Oct 2020 09:38:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 24 Oct 2020 09:38:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ygthwpBB9JERqR1fwYIri0UGRgUu0baDfw4Gk8Ml9UU=; b=BDIPBMCx
        Gm/7KYWIYhm1jreAlX0pikYaNfTzUXBloMYXAIsz3nLyq/ybWeAvbP9EGsXJerCe
        bUpAcdXQBx9XHrRmMyI1T5lwXlYqja7gf6qWA+zkNtVSt3qPhnvTNqVnyhhrSfXD
        NM0x3wKc/uY42VwQl1ICHul1mCt2Hnbf22/y04xq3oO4Sna/yKgzhqzkxBVAJ9Oa
        v2zBGaPv+qNpG1W4KnHAM3X+Ny0GBcMCw4LK+HB3stFtGttbfVpdCkHcdVEL+Dia
        yqXOu1OjaAeD6TGO/FTA2DKEeOKCi9FAVL+3cT76TDQ9GGMa4VpZWPntDt9aRi5Y
        mc7KT6ppsOan3A==
X-ME-Sender: <xms:PC6UX6_laa4IY_Uyu81wYHkeeMWBDnOY0-zBmAC6KfejqEPY6kXG9A>
    <xme:PC6UX6shvC4uUpeTxB7Y0pc_HHaUpsMaXcqR0h69hnq64R5dcIXskEUPXfxrlF2ge
    Ma4PJeib7-lsSc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrvddvkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:PC6UXwBQXjdy3MBRoH8WHZoFUMaHDlCfnwIuyEJbRYvl85x-NKMsHg>
    <xmx:PC6UXyd861PZx0VbSCXaoFRkRSWC85m4W7OWXtfJX1nDgdrylKg_2Q>
    <xmx:PC6UX_OqBs_1g6flhkL3IRgqOcTgPXJDS0dudd6rcyE5CA-m6i_Xug>
    <xmx:PC6UX4rtKYlvTTeb_mE7buNEaPMOkb0VXao4486vHwmJ01mwPgGIqg>
Received: from shredder.mtl.com (igld-84-229-37-228.inter.net.il [84.229.37.228])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0503A3280065;
        Sat, 24 Oct 2020 09:38:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/3] mlxsw: Only advertise link modes supported by both driver and device
Date:   Sat, 24 Oct 2020 16:37:31 +0300
Message-Id: <20201024133733.2107509-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024133733.2107509-1-idosch@idosch.org>
References: <20201024133733.2107509-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

During port creation the driver instructs the device to advertise all
the supported link modes queried from the device.

Since cited commit not all the link modes supported by the device are
supported by the driver. This can result in the device negotiating a
link mode that is not recognized by the driver causing ethtool to show
an unsupported speed:

$ ethtool swp1
...
Speed: Unknown!

This is especially problematic when the netdev is enslaved to a bond, as
the bond driver uses unknown speed as an indication that the link is
down:

[13048.900895] net_ratelimit: 86 callbacks suppressed
[13048.900902] t_bond0: (slave swp52): failed to get link speed/duplex
[13048.912160] t_bond0: (slave swp49): failed to get link speed/duplex

Fix this by making sure that only link modes that are supported by both
the device and the driver are advertised.

Fixes: b97cd891268d ("mlxsw: Remove 56G speed support")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  9 ++++--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../mellanox/mlxsw/spectrum_ethtool.c         | 30 +++++++++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 16b47fce540b..b08853f71b2b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1174,11 +1174,14 @@ mlxsw_sp_port_speed_by_width_set(struct mlxsw_sp_port *mlxsw_sp_port)
 	u32 eth_proto_cap, eth_proto_admin, eth_proto_oper;
 	const struct mlxsw_sp_port_type_speed_ops *ops;
 	char ptys_pl[MLXSW_REG_PTYS_LEN];
+	u32 eth_proto_cap_masked;
 	int err;
 
 	ops = mlxsw_sp->port_type_speed_ops;
 
-	/* Set advertised speeds to supported speeds. */
+	/* Set advertised speeds to speeds supported by both the driver
+	 * and the device.
+	 */
 	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
 			       0, false);
 	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
@@ -1187,8 +1190,10 @@ mlxsw_sp_port_speed_by_width_set(struct mlxsw_sp_port *mlxsw_sp_port)
 
 	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap,
 				 &eth_proto_admin, &eth_proto_oper);
+	eth_proto_cap_masked = ops->ptys_proto_cap_masked_get(eth_proto_cap);
 	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
-			       eth_proto_cap, mlxsw_sp_port->link.autoneg);
+			       eth_proto_cap_masked,
+			       mlxsw_sp_port->link.autoneg);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 3e26eb6cb140..74b3959b36d4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -342,6 +342,7 @@ struct mlxsw_sp_port_type_speed_ops {
 				    u32 *p_eth_proto_cap,
 				    u32 *p_eth_proto_admin,
 				    u32 *p_eth_proto_oper);
+	u32 (*ptys_proto_cap_masked_get)(u32 eth_proto_cap);
 };
 
 static inline struct net_device *
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 2096b6478958..540616469e28 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1303,6 +1303,20 @@ mlxsw_sp1_reg_ptys_eth_unpack(struct mlxsw_sp *mlxsw_sp, char *payload,
 				  p_eth_proto_oper);
 }
 
+static u32 mlxsw_sp1_ptys_proto_cap_masked_get(u32 eth_proto_cap)
+{
+	u32 ptys_proto_cap_masked = 0;
+	int i;
+
+	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if (mlxsw_sp1_port_link_mode[i].mask & eth_proto_cap)
+			ptys_proto_cap_masked |=
+				mlxsw_sp1_port_link_mode[i].mask;
+	}
+
+	return ptys_proto_cap_masked;
+}
+
 const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp1_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp1_from_ptys_link,
@@ -1313,6 +1327,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops = {
 	.to_ptys_speed			= mlxsw_sp1_to_ptys_speed,
 	.reg_ptys_eth_pack		= mlxsw_sp1_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		= mlxsw_sp1_reg_ptys_eth_unpack,
+	.ptys_proto_cap_masked_get	= mlxsw_sp1_ptys_proto_cap_masked_get,
 };
 
 static const enum ethtool_link_mode_bit_indices
@@ -1731,6 +1746,20 @@ mlxsw_sp2_reg_ptys_eth_unpack(struct mlxsw_sp *mlxsw_sp, char *payload,
 				      p_eth_proto_admin, p_eth_proto_oper);
 }
 
+static u32 mlxsw_sp2_ptys_proto_cap_masked_get(u32 eth_proto_cap)
+{
+	u32 ptys_proto_cap_masked = 0;
+	int i;
+
+	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if (mlxsw_sp2_port_link_mode[i].mask & eth_proto_cap)
+			ptys_proto_cap_masked |=
+				mlxsw_sp2_port_link_mode[i].mask;
+	}
+
+	return ptys_proto_cap_masked;
+}
+
 const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp2_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp2_from_ptys_link,
@@ -1741,4 +1770,5 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops = {
 	.to_ptys_speed			= mlxsw_sp2_to_ptys_speed,
 	.reg_ptys_eth_pack		= mlxsw_sp2_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		= mlxsw_sp2_reg_ptys_eth_unpack,
+	.ptys_proto_cap_masked_get	= mlxsw_sp2_ptys_proto_cap_masked_get,
 };
-- 
2.26.2

