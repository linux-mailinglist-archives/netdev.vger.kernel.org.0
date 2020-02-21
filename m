Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44F51685AF
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgBURzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:55:05 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55071 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729407AbgBURzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:55:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2CECC21B2B;
        Fri, 21 Feb 2020 12:55:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:55:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=DPvDxRb5I/FCd8l+nnWKcdHYYY3rWqGNdsCLc9sPZds=; b=N9U6parQ
        ULG/utKM079lgIaNSFOsPYfhG9zgkTJZKe4qxwNOfhzQWldi3KajkfPMqtj/2alF
        Dw9S2dGe8C5O8zxZlAkAaPG/wad/FFWprEJUEV17y0iT2ay0F/AslvGBIyxzV6Dy
        5eEqDlEN5dpeypFSowDMfmN65qVKAJViMrDq5Zu4DJD6e206Hq/q+09rCyxihXg3
        NweilY82VHf110WeoAoH75uE3/S1svRbk5DZ3v5HnWQaSA3ugL3toflBHREFgXiB
        t2pDVxVdr3bz2txqYtjyTAzIyZ2JDWuGND3xKy6K237e2+YeXSGohzXpr3/8K3rf
        6aY9r+yakgzt0Q==
X-ME-Sender: <xms:dRlQXvM142ectxVummIEpNqEQvI7T_IWHctT_-3v7iGWqX-aj9O_3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:dRlQXjwPmgBXNuoV1NbrfYTQsfHj8BRj90sK608RN29oJnQ1OzSlDQ>
    <xmx:dRlQXq3s-cpCg-ctCIKsENR1MHhBrcQYEVBwb7BkfdWYSZpfyTm2vg>
    <xmx:dRlQXhGu0UTHWFirihyEZHo3sqkPcUxS3bCQiRN4Owgg1ymm_DDRdQ>
    <xmx:dRlQXg6bd1V-o6m4UBC-J5I8oDIDb74QelL6gvwB0YUm-ewsHl1yQg>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8BA1A3060D1A;
        Fri, 21 Feb 2020 12:54:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/12] mlxsw: spectrum_router: Take router lock from exported helpers
Date:   Fri, 21 Feb 2020 19:54:14 +0200
Message-Id: <20200221175415.390884-12-idosch@idosch.org>
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

The routing code exports some helper functions that can be called from
other driver modules such as the bridge. These helpers are never called
with the router lock already held and therefore need to take it in order
to serialize access to shared router structures.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 80 ++++++++++++++-----
 1 file changed, 58 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 61d323d8b91d..0f5ecb47d0c2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -731,13 +731,18 @@ int mlxsw_sp_router_tb_id_vr_id(struct mlxsw_sp *mlxsw_sp, u32 tb_id,
 				u16 *vr_id)
 {
 	struct mlxsw_sp_vr *vr;
+	int err = 0;
 
+	mutex_lock(&mlxsw_sp->router->lock);
 	vr = mlxsw_sp_vr_find(mlxsw_sp, tb_id);
-	if (!vr)
-		return -ESRCH;
+	if (!vr) {
+		err = -ESRCH;
+		goto out;
+	}
 	*vr_id = vr->id;
-
-	return 0;
+out:
+	mutex_unlock(&mlxsw_sp->router->lock);
+	return err;
 }
 
 static struct mlxsw_sp_fib *mlxsw_sp_vr_fib(const struct mlxsw_sp_vr *vr,
@@ -1850,10 +1855,14 @@ int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 	enum mlxsw_sp_fib_entry_type type = MLXSW_SP_FIB_ENTRY_TYPE_TRAP;
 	struct mlxsw_sp_router *router = mlxsw_sp->router;
 	struct mlxsw_sp_fib_entry *fib_entry;
-	int err;
+	int err = 0;
 
-	if (WARN_ON_ONCE(router->nve_decap_config.valid))
-		return -EINVAL;
+	mutex_lock(&mlxsw_sp->router->lock);
+
+	if (WARN_ON_ONCE(router->nve_decap_config.valid)) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	router->nve_decap_config.ul_tb_id = ul_tb_id;
 	router->nve_decap_config.tunnel_index = tunnel_index;
@@ -1868,7 +1877,7 @@ int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 							 ul_proto, ul_sip,
 							 type);
 	if (!fib_entry)
-		return 0;
+		goto out;
 
 	fib_entry->decap.tunnel_index = tunnel_index;
 	fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP;
@@ -1877,11 +1886,13 @@ int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 	if (err)
 		goto err_fib_entry_update;
 
-	return 0;
+	goto out;
 
 err_fib_entry_update:
 	fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_TRAP;
 	mlxsw_sp_fib_entry_update(mlxsw_sp, fib_entry);
+out:
+	mutex_unlock(&mlxsw_sp->router->lock);
 	return err;
 }
 
@@ -1893,8 +1904,10 @@ void mlxsw_sp_router_nve_demote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 	struct mlxsw_sp_router *router = mlxsw_sp->router;
 	struct mlxsw_sp_fib_entry *fib_entry;
 
+	mutex_lock(&mlxsw_sp->router->lock);
+
 	if (WARN_ON_ONCE(!router->nve_decap_config.valid))
-		return;
+		goto out;
 
 	router->nve_decap_config.valid = false;
 
@@ -1902,10 +1915,12 @@ void mlxsw_sp_router_nve_demote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 							 ul_proto, ul_sip,
 							 type);
 	if (!fib_entry)
-		return;
+		goto out;
 
 	fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_TRAP;
 	mlxsw_sp_fib_entry_update(mlxsw_sp, fib_entry);
+out:
+	mutex_unlock(&mlxsw_sp->router->lock);
 }
 
 static bool mlxsw_sp_router_nve_is_decap(struct mlxsw_sp *mlxsw_sp,
@@ -6298,7 +6313,13 @@ mlxsw_sp_rif_find_by_dev(const struct mlxsw_sp *mlxsw_sp,
 bool mlxsw_sp_rif_exists(struct mlxsw_sp *mlxsw_sp,
 			 const struct net_device *dev)
 {
-	return !!mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
+	struct mlxsw_sp_rif *rif;
+
+	mutex_lock(&mlxsw_sp->router->lock);
+	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
+	mutex_unlock(&mlxsw_sp->router->lock);
+
+	return rif;
 }
 
 u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev)
@@ -6306,6 +6327,7 @@ u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev)
 	struct mlxsw_sp_rif *rif;
 	u16 vid = 0;
 
+	mutex_lock(&mlxsw_sp->router->lock);
 	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
 	if (!rif)
 		goto out;
@@ -6319,6 +6341,7 @@ u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev)
 	vid = mlxsw_sp_fid_8021q_vid(rif->fid);
 
 out:
+	mutex_unlock(&mlxsw_sp->router->lock);
 	return vid;
 }
 
@@ -6600,10 +6623,13 @@ void mlxsw_sp_rif_destroy_by_dev(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_rif *rif;
 
+	mutex_lock(&mlxsw_sp->router->lock);
 	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
 	if (!rif)
-		return;
+		goto out;
 	mlxsw_sp_rif_destroy(rif);
+out:
+	mutex_unlock(&mlxsw_sp->router->lock);
 }
 
 static void
@@ -6725,7 +6751,11 @@ __mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 void
 mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 {
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port_vlan->mlxsw_sp_port->mlxsw_sp;
+
+	mutex_lock(&mlxsw_sp->router->lock);
 	__mlxsw_sp_port_vlan_router_leave(mlxsw_sp_port_vlan);
+	mutex_unlock(&mlxsw_sp->router->lock);
 }
 
 static int mlxsw_sp_inetaddr_port_vlan_event(struct net_device *l3_dev,
@@ -6947,7 +6977,9 @@ static void __mlxsw_sp_rif_macvlan_del(struct mlxsw_sp *mlxsw_sp,
 void mlxsw_sp_rif_macvlan_del(struct mlxsw_sp *mlxsw_sp,
 			      const struct net_device *macvlan_dev)
 {
+	mutex_lock(&mlxsw_sp->router->lock);
 	__mlxsw_sp_rif_macvlan_del(mlxsw_sp, macvlan_dev);
+	mutex_unlock(&mlxsw_sp->router->lock);
 }
 
 static int mlxsw_sp_inetaddr_macvlan_event(struct mlxsw_sp *mlxsw_sp,
@@ -7833,28 +7865,32 @@ int mlxsw_sp_router_ul_rif_get(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 			       u16 *ul_rif_index)
 {
 	struct mlxsw_sp_rif *ul_rif;
+	int err = 0;
 
-	ASSERT_RTNL();
-
+	mutex_lock(&mlxsw_sp->router->lock);
 	ul_rif = mlxsw_sp_ul_rif_get(mlxsw_sp, ul_tb_id, NULL);
-	if (IS_ERR(ul_rif))
-		return PTR_ERR(ul_rif);
+	if (IS_ERR(ul_rif)) {
+		err = PTR_ERR(ul_rif);
+		goto out;
+	}
 	*ul_rif_index = ul_rif->rif_index;
-
-	return 0;
+out:
+	mutex_unlock(&mlxsw_sp->router->lock);
+	return err;
 }
 
 void mlxsw_sp_router_ul_rif_put(struct mlxsw_sp *mlxsw_sp, u16 ul_rif_index)
 {
 	struct mlxsw_sp_rif *ul_rif;
 
-	ASSERT_RTNL();
-
+	mutex_lock(&mlxsw_sp->router->lock);
 	ul_rif = mlxsw_sp->router->rifs[ul_rif_index];
 	if (WARN_ON(!ul_rif))
-		return;
+		goto out;
 
 	mlxsw_sp_ul_rif_put(ul_rif);
+out:
+	mutex_unlock(&mlxsw_sp->router->lock);
 }
 
 static int
-- 
2.24.1

