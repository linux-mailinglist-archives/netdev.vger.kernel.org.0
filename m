Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341681614BB
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgBQObZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:31:25 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58133 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729002AbgBQObX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:31:23 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9C35321873;
        Mon, 17 Feb 2020 09:31:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 09:31:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=EiA81wtQBwUyH5aVtrmdicXwJY4JwmuKgbPrijY6x7U=; b=wXCQ2EsP
        Y8la2Ol+emvgPKGGbT7uRrJfFBCMXMfLVucnGigpZ8iP0WWSYdhZA0zfwKWTiRx6
        EB4nO33Lg1pRsVyuzdpGqSDB5Cf+ffimKFWPHKEoVRAW+9+1uGOk1RLrREU+Goid
        uv3nRpRsCXMLIuI++WcWwjyfp4Pl5YzJirFYcq9safFvTJGeP3FRSmfzKnvGIXQG
        dHNJUdHPieVkePxgejoISc8RCvQb+HQot53h5CAu+iLObz+jvnlrpl1oE7a2J8B9
        DvBzcxq/jnDiNOPtplXgbyUGD69z3hi7JcT7GQOqREUSwrNCPp6/u85PyN/rOw9f
        NuhJjcS8tTKZOg==
X-ME-Sender: <xms:uqNKXmxI7qf-Cj2nUL9WaYW2tAqz8H1410L04Zf0CoGHhQC3QYibxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:uqNKXo0eXqfeJTlk3-_kT6KPKrwxFrIW5tQhhssAP1bUSQiww-suFw>
    <xmx:uqNKXljcCrRZcurna3uVu3OB7sRKlsIITKS_5t4LAgb79JmnUtJUAQ>
    <xmx:uqNKXunC6-hkxRxQQLA-Th-1CWnr78rrA5HddalbNGF32I_d4iIrvg>
    <xmx:uqNKXh5xNHYCKTg49HjTHAJRjqq4x5JGqT1ZpGLFFq4JZ7XvRAveJA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7FB353060C28;
        Mon, 17 Feb 2020 09:31:21 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/10] mlxsw: spectrum: Reduce dependency between bridge and router code
Date:   Mon, 17 Feb 2020 16:29:35 +0200
Message-Id: <20200217142940.307014-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217142940.307014-1-idosch@idosch.org>
References: <20200217142940.307014-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Commit f40be47a3e40 ("mlxsw: spectrum_router: Do not force specific
configuration order") added a call from the routing code to the bridge
code in order to handle the case where VNI should be set on a FID
following the joining of the router port to the FID.

This is no longer required, as previous patches made VXLAN devices
explicitly take a reference on the FID and set VNI on it.

Therefore, remove the unnecessary call and simply have the RIF take a
reference on the FID without checking if VNI should also be set on it.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |  4 ----
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  4 ++--
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 14 --------------
 3 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a0f1f9dceec5..4c3d39223a46 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -468,10 +468,6 @@ int mlxsw_sp_bridge_vxlan_join(struct mlxsw_sp *mlxsw_sp,
 			       struct netlink_ext_ack *extack);
 void mlxsw_sp_bridge_vxlan_leave(struct mlxsw_sp *mlxsw_sp,
 				 const struct net_device *vxlan_dev);
-struct mlxsw_sp_fid *mlxsw_sp_bridge_fid_get(struct mlxsw_sp *mlxsw_sp,
-					     const struct net_device *br_dev,
-					     u16 vid,
-					     struct netlink_ext_ack *extack);
 extern struct notifier_block mlxsw_sp_switchdev_notifier;
 
 /* spectrum.c */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 4a77b511ead2..def75d7fcd06 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7428,7 +7428,7 @@ mlxsw_sp_rif_vlan_fid_get(struct mlxsw_sp_rif *rif,
 		}
 	}
 
-	return mlxsw_sp_bridge_fid_get(rif->mlxsw_sp, br_dev, vid, extack);
+	return mlxsw_sp_fid_8021q_get(rif->mlxsw_sp, vid);
 }
 
 static void mlxsw_sp_rif_vlan_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
@@ -7519,7 +7519,7 @@ static struct mlxsw_sp_fid *
 mlxsw_sp_rif_fid_fid_get(struct mlxsw_sp_rif *rif,
 			 struct netlink_ext_ack *extack)
 {
-	return mlxsw_sp_bridge_fid_get(rif->mlxsw_sp, rif->dev, 0, extack);
+	return mlxsw_sp_fid_8021d_get(rif->mlxsw_sp, rif->dev->ifindex);
 }
 
 static void mlxsw_sp_rif_fid_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index c3a890e0bba1..6213fa43aa7b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2358,20 +2358,6 @@ void mlxsw_sp_bridge_vxlan_leave(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_fid_put(fid);
 }
 
-struct mlxsw_sp_fid *mlxsw_sp_bridge_fid_get(struct mlxsw_sp *mlxsw_sp,
-					     const struct net_device *br_dev,
-					     u16 vid,
-					     struct netlink_ext_ack *extack)
-{
-	struct mlxsw_sp_bridge_device *bridge_device;
-
-	bridge_device = mlxsw_sp_bridge_device_find(mlxsw_sp->bridge, br_dev);
-	if (WARN_ON(!bridge_device))
-		return ERR_PTR(-EINVAL);
-
-	return bridge_device->ops->fid_get(bridge_device, vid, extack);
-}
-
 static void
 mlxsw_sp_switchdev_vxlan_addr_convert(const union vxlan_addr *vxlan_addr,
 				      enum mlxsw_sp_l3proto *proto,
-- 
2.24.1

