Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7D5165834
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgBTHIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:38 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38011 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726856AbgBTHIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A3D1221EAF;
        Thu, 20 Feb 2020 02:08:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=a88tU49OZDLaussboTVlOdYcE53178lmGaTgFfbwToE=; b=VgnevAN5
        ZM42JB0wAc2dtx9naaoj7rqDBtOTWMY7rOgIZEboVIVLvODSeDqTcFCbx6uxqxnB
        L2LMdq7Zz6E3lqzEuhzPL8aeiR2BILKHpTbFGdSsvGVsVHwiFtxwEXcvJnVKwNle
        RVD9rnTealzINRJJ3mVoCP+tJUwkZSFV+FV8vge7vqQowWZ7pimLmecOZQGu+AYV
        HlKOKhaTq9QvHoH1B7slk6SSPW6HsrPS/Xx0hEY2ipUin0ry+Zl2qwIX79rIRXfC
        yIim7q34zHMDenqemTzpdgjwoj9Ua4PlfPjzqayHfkXjfW+1AGUP95s8/K3nJXOK
        KWnqaPRRlOuffw==
X-ME-Sender: <xms:czBOXs9pCcl0YKE5xAZ9YuiPjD7OXm2BK-t83nnHuc5uskWnBx88hQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:czBOXmq1_3Sv0LaaPTsYq-yRDbFA7x10Te3c1Q10GAYUqRCRNNjfwg>
    <xmx:czBOXsZtG2d8l0VabmszrQeOipFOy72MRQ5vbotFmWMwzkGCj3G6ug>
    <xmx:czBOXpzHR1XrfOaJdEfenrUB3YT4qehDFJtR-9FR_SyfyJmNvrBrkA>
    <xmx:czBOXq9z_ObfHRMfNMdJrEkpdzv92Hu8SPymlpmTzSwY9-MOShkSbw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89FD33060C28;
        Thu, 20 Feb 2020 02:08:34 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 13/15] mlxsw: spectrum: Prevent RIF access outside of routing code
Date:   Thu, 20 Feb 2020 09:07:58 +0200
Message-Id: <20200220070800.364235-14-idosch@idosch.org>
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

There are currently 5 users of mlxsw_sp_rif_find_by_dev() outside of the
routing code. Only one call site actually needs to dereference the
router interface (RIF). The rest merely need to know if a RIF exists for
the provided netdev.

Convert this call site to query the needed information directly from the
routing code instead of dereferencing the RIF.

This will later allow us to replace mlxsw_sp_rif_find_by_dev() with a
function that checks if a RIF exist.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 26 +++++++++++++++----
 .../mellanox/mlxsw/spectrum_switchdev.c       |  8 ++----
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 2f3d2f8b2377..890af4f9f1b8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -565,8 +565,8 @@ void mlxsw_sp_rif_destroy_by_dev(struct mlxsw_sp *mlxsw_sp,
 				 struct net_device *dev);
 struct mlxsw_sp_rif *mlxsw_sp_rif_find_by_dev(const struct mlxsw_sp *mlxsw_sp,
 					      const struct net_device *dev);
+u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev);
 u8 mlxsw_sp_router_port(const struct mlxsw_sp *mlxsw_sp);
-struct mlxsw_sp_fid *mlxsw_sp_rif_fid(const struct mlxsw_sp_rif *rif);
 int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 				      enum mlxsw_sp_l3proto ul_proto,
 				      const union mlxsw_sp_l3addr *ul_sip,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 5c4b28a81b07..535788cced8c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6270,6 +6270,27 @@ mlxsw_sp_rif_find_by_dev(const struct mlxsw_sp *mlxsw_sp,
 	return NULL;
 }
 
+u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev)
+{
+	struct mlxsw_sp_rif *rif;
+	u16 vid = 0;
+
+	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
+	if (!rif)
+		goto out;
+
+	/* We only return the VID for VLAN RIFs. Otherwise we return an
+	 * invalid value (0).
+	 */
+	if (rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN)
+		goto out;
+
+	vid = mlxsw_sp_fid_8021q_vid(rif->fid);
+
+out:
+	return vid;
+}
+
 static int mlxsw_sp_router_rif_disable(struct mlxsw_sp *mlxsw_sp, u16 rif)
 {
 	char ritr_pl[MLXSW_REG_RITR_LEN];
@@ -6436,11 +6457,6 @@ const struct net_device *mlxsw_sp_rif_dev(const struct mlxsw_sp_rif *rif)
 	return rif->dev;
 }
 
-struct mlxsw_sp_fid *mlxsw_sp_rif_fid(const struct mlxsw_sp_rif *rif)
-{
-	return rif->fid;
-}
-
 static struct mlxsw_sp_rif *
 mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 		    const struct mlxsw_sp_rif_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index d70865f29105..339c69da83b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1173,16 +1173,12 @@ mlxsw_sp_br_ban_rif_pvid_change(struct mlxsw_sp *mlxsw_sp,
 				const struct net_device *br_dev,
 				const struct switchdev_obj_port_vlan *vlan)
 {
-	struct mlxsw_sp_rif *rif;
-	struct mlxsw_sp_fid *fid;
 	u16 pvid;
 	u16 vid;
 
-	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, br_dev);
-	if (!rif)
+	pvid = mlxsw_sp_rif_vid(mlxsw_sp, br_dev);
+	if (!pvid)
 		return 0;
-	fid = mlxsw_sp_rif_fid(rif);
-	pvid = mlxsw_sp_fid_8021q_vid(fid);
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
 		if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
-- 
2.24.1

