Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E94361685AD
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgBURzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:55:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52461 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729368AbgBURy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:54:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6A039220A7;
        Fri, 21 Feb 2020 12:54:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:54:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=f9C083yEmk/r7lcnLUOXnpXSeQqYw1wmsPTrzrY3z4w=; b=pdOeLh9Y
        /iO/U6WhBfuP+D2jRdancP0VHgXeAjrSnobNCJAhnGFktHtf0xSpJ5EfJ4WFU38M
        2SmHINa2G8znHZswpuprA8v2Dp2o/G6vGsN4KkhoTUuQwSrx9yxltqndBFYISuzc
        ccR903DTrn8JVVmRO4mHfrw2T5x61wdJG8q+4LRXnNXX2HuZdVIRhMf561dd/H8a
        uk6Lo7MdcZoHGnqMlSkj6TRIKjcdyGGOjWtHtZT46R2rh93/r7TyJc9HucCyw7QM
        zs7eSRy5KEpSQfY2r/f5aCJ3QAXoBCjO+BDWx9p8NzOmZ0N5FTBvoPSFOS3Gtt9p
        VzMni1l6JC7WBg==
X-ME-Sender: <xms:cRlQXmPgmVn2gNL5CbJ0Da-MnJeQpqqa-P5FxOi5QvZKdMedc8yDbA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:cRlQXsrSFneexEGKNN8MZwoocjE_3ComTsSNADu9YobbdplgGpu0WQ>
    <xmx:cRlQXgsjI6gY3VDbzD23FaSpsAmR6-er1VW8yfuShNuECEte7KR3IQ>
    <xmx:cRlQXoTRDg0k4ntu6Ue3SP08kaL8ip0pxQp2QRmj1Byd5z-FzLyX0w>
    <xmx:cRlQXn3WCb0WzBzMX8yE9rYweXvYSbwmpAshcXGgOGvcHWxTBMeMpQ>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id D81153060FCB;
        Fri, 21 Feb 2020 12:54:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/12] mlxsw: spectrum_router: Take router lock from netdev listener
Date:   Fri, 21 Feb 2020 19:54:12 +0200
Message-Id: <20200221175415.390884-10-idosch@idosch.org>
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

One entry point into the routing code is from the netdev listener block.
Some netdev events require access to internal router structures. For
example, changing the MTU of a netdev requires looking-up the backing
RIF and adjusting its MTU.

In order to serialize access to shared router structures, take the
router lock when processing netdev events that require access to it.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 66 ++++++++++++-------
 2 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 66cfe27e1f9b..bb02a0361bfd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -548,7 +548,7 @@ int mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
 				 struct netdev_notifier_changeupper_info *info);
 bool mlxsw_sp_netdev_is_ipip_ol(const struct mlxsw_sp *mlxsw_sp,
 				const struct net_device *dev);
-bool mlxsw_sp_netdev_is_ipip_ul(const struct mlxsw_sp *mlxsw_sp,
+bool mlxsw_sp_netdev_is_ipip_ul(struct mlxsw_sp *mlxsw_sp,
 				const struct net_device *dev);
 int mlxsw_sp_netdevice_ipip_ol_event(struct mlxsw_sp *mlxsw_sp,
 				     struct net_device *l3_dev,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 601fa4a1abbb..7ad5cb5c2d3e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1346,10 +1346,16 @@ mlxsw_sp_ipip_entry_find_by_ul_dev(const struct mlxsw_sp *mlxsw_sp,
 	return NULL;
 }
 
-bool mlxsw_sp_netdev_is_ipip_ul(const struct mlxsw_sp *mlxsw_sp,
+bool mlxsw_sp_netdev_is_ipip_ul(struct mlxsw_sp *mlxsw_sp,
 				const struct net_device *dev)
 {
-	return mlxsw_sp_ipip_entry_find_by_ul_dev(mlxsw_sp, dev, NULL);
+	bool is_ipip_ul;
+
+	mutex_lock(&mlxsw_sp->router->lock);
+	is_ipip_ul = mlxsw_sp_ipip_entry_find_by_ul_dev(mlxsw_sp, dev, NULL);
+	mutex_unlock(&mlxsw_sp->router->lock);
+
+	return is_ipip_ul;
 }
 
 static bool mlxsw_sp_netdevice_ipip_can_offload(struct mlxsw_sp *mlxsw_sp,
@@ -1721,35 +1727,41 @@ int mlxsw_sp_netdevice_ipip_ol_event(struct mlxsw_sp *mlxsw_sp,
 {
 	struct netdev_notifier_changeupper_info *chup;
 	struct netlink_ext_ack *extack;
+	int err = 0;
 
+	mutex_lock(&mlxsw_sp->router->lock);
 	switch (event) {
 	case NETDEV_REGISTER:
-		return mlxsw_sp_netdevice_ipip_ol_reg_event(mlxsw_sp, ol_dev);
+		err = mlxsw_sp_netdevice_ipip_ol_reg_event(mlxsw_sp, ol_dev);
+		break;
 	case NETDEV_UNREGISTER:
 		mlxsw_sp_netdevice_ipip_ol_unreg_event(mlxsw_sp, ol_dev);
-		return 0;
+		break;
 	case NETDEV_UP:
 		mlxsw_sp_netdevice_ipip_ol_up_event(mlxsw_sp, ol_dev);
-		return 0;
+		break;
 	case NETDEV_DOWN:
 		mlxsw_sp_netdevice_ipip_ol_down_event(mlxsw_sp, ol_dev);
-		return 0;
+		break;
 	case NETDEV_CHANGEUPPER:
 		chup = container_of(info, typeof(*chup), info);
 		extack = info->extack;
 		if (netif_is_l3_master(chup->upper_dev))
-			return mlxsw_sp_netdevice_ipip_ol_vrf_event(mlxsw_sp,
-								    ol_dev,
-								    extack);
-		return 0;
+			err = mlxsw_sp_netdevice_ipip_ol_vrf_event(mlxsw_sp,
+								   ol_dev,
+								   extack);
+		break;
 	case NETDEV_CHANGE:
 		extack = info->extack;
-		return mlxsw_sp_netdevice_ipip_ol_change_event(mlxsw_sp,
-							       ol_dev, extack);
+		err = mlxsw_sp_netdevice_ipip_ol_change_event(mlxsw_sp,
+							      ol_dev, extack);
+		break;
 	case NETDEV_CHANGEMTU:
-		return mlxsw_sp_netdevice_ipip_ol_update_mtu(mlxsw_sp, ol_dev);
+		err = mlxsw_sp_netdevice_ipip_ol_update_mtu(mlxsw_sp, ol_dev);
+		break;
 	}
-	return 0;
+	mutex_unlock(&mlxsw_sp->router->lock);
+	return err;
 }
 
 static int
@@ -1793,8 +1805,9 @@ mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 				 struct netdev_notifier_info *info)
 {
 	struct mlxsw_sp_ipip_entry *ipip_entry = NULL;
-	int err;
+	int err = 0;
 
+	mutex_lock(&mlxsw_sp->router->lock);
 	while ((ipip_entry = mlxsw_sp_ipip_entry_find_by_ul_dev(mlxsw_sp,
 								ul_dev,
 								ipip_entry))) {
@@ -1807,7 +1820,7 @@ mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 		if (err) {
 			mlxsw_sp_ipip_demote_tunnel_by_ul_netdev(mlxsw_sp,
 								 ul_dev);
-			return err;
+			break;
 		}
 
 		if (demote_this) {
@@ -1824,8 +1837,9 @@ mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 			ipip_entry = prev;
 		}
 	}
+	mutex_unlock(&mlxsw_sp->router->lock);
 
-	return 0;
+	return err;
 }
 
 int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
@@ -7223,24 +7237,30 @@ int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
 {
 	struct mlxsw_sp *mlxsw_sp;
 	struct mlxsw_sp_rif *rif;
+	int err = 0;
 
 	mlxsw_sp = mlxsw_sp_lower_get(dev);
 	if (!mlxsw_sp)
 		return 0;
 
+	mutex_lock(&mlxsw_sp->router->lock);
 	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
 	if (!rif)
-		return 0;
+		goto out;
 
 	switch (event) {
 	case NETDEV_CHANGEMTU: /* fall through */
 	case NETDEV_CHANGEADDR:
-		return mlxsw_sp_router_port_change_event(mlxsw_sp, rif);
+		err = mlxsw_sp_router_port_change_event(mlxsw_sp, rif);
+		break;
 	case NETDEV_PRE_CHANGEADDR:
-		return mlxsw_sp_router_port_pre_changeaddr_event(rif, ptr);
+		err = mlxsw_sp_router_port_pre_changeaddr_event(rif, ptr);
+		break;
 	}
 
-	return 0;
+out:
+	mutex_unlock(&mlxsw_sp->router->lock);
+	return err;
 }
 
 static int mlxsw_sp_port_vrf_join(struct mlxsw_sp *mlxsw_sp,
@@ -7283,9 +7303,10 @@ int mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
 	if (!mlxsw_sp || netif_is_macvlan(l3_dev))
 		return 0;
 
+	mutex_lock(&mlxsw_sp->router->lock);
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
-		return 0;
+		break;
 	case NETDEV_CHANGEUPPER:
 		if (info->linking) {
 			struct netlink_ext_ack *extack;
@@ -7297,6 +7318,7 @@ int mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
 		}
 		break;
 	}
+	mutex_unlock(&mlxsw_sp->router->lock);
 
 	return err;
 }
-- 
2.24.1

