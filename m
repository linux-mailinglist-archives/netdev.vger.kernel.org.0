Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D625165838
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgBTHIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:45 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38865 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbgBTHId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:33 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D96421EAE;
        Thu, 20 Feb 2020 02:08:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=xI+nMxxBD0/AJfMb2wY4hQpLeVSszvr6+0HRyJUt0b4=; b=q1hQQazP
        j7Bk4ju2m19s5pwGmbbN7TecqCxBPp8fxHKcqilfjj7fdDd70pHH7mlTROEsjpKB
        Lq4BgY3/8xjVLhizhxFb0TlXW2VRvRsdStzikudbhag7FeziBw3hFWId/K2zBJ6k
        6oEWigJkBjb9gqmvLa0oBhhd/SC4ovGn7tlFsA03GEJmH3LCjCvtv68o7FMasUuk
        80ewCVOzQ9W0CiVs2vudu+MdgvyRADUqKXMuTcSJyfUc3SZyMtHt1PJZP8pdUe14
        Wr3tvBwzLSySPOcm2OZSl5JDuGYoh8EIzj38krGE80toJQkpjdtUnHpaJ/YTYk2z
        QumBTh6U1U8tbw==
X-ME-Sender: <xms:bzBOXlePhdOmXKGk0xlyBQsGuoFRCP5zYec7dGPTsNnhGe6BQeKMvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:bzBOXpo0QrQgeuA50V7xJFEPcxZdUPCrZvrXm_Qvx0Hr9q9Eji_MAg>
    <xmx:bzBOXnX4mRN3Tsd5JtdsdgYghFJBGWgfaiJzaf2BdiL-XLhHHXchBQ>
    <xmx:bzBOXuPbU6Auo3yaBn4lnINCL6-7TRnJBwMBLaYZx0aPNgdu2JNHeA>
    <xmx:cDBOXmE6TpFEH2IrQUddjiYTw5zNXlvZsvn-X6Cz8mb5lrx2UwBw2A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id EBE8B3060C21;
        Thu, 20 Feb 2020 02:08:30 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/15] mlxsw: spectrum_router: Do not assume RTNL is taken when resolving underlay device
Date:   Thu, 20 Feb 2020 09:07:55 +0200
Message-Id: <20200220070800.364235-11-idosch@idosch.org>
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

The function that resolves the underlay device of the IPIP tunnel
assumes that RTNL is taken, but this will not be correct when RTNL is
removed from the route insertion path.

Convert the function to use dev_get_by_index_rcu() instead of
__dev_get_by_index() and make sure it is always called from an RCU
read-side critical section.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 39 ++++++++++++++-----
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 21e8539727be..000aa68e7e31 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -988,17 +988,23 @@ __mlxsw_sp_ipip_netdev_ul_dev_get(const struct net_device *ol_dev)
 	struct ip_tunnel *tun = netdev_priv(ol_dev);
 	struct net *net = dev_net(ol_dev);
 
-	return __dev_get_by_index(net, tun->parms.link);
+	return dev_get_by_index_rcu(net, tun->parms.link);
 }
 
 u32 mlxsw_sp_ipip_dev_ul_tb_id(const struct net_device *ol_dev)
 {
-	struct net_device *d = __mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
+	struct net_device *d;
+	u32 tb_id;
 
+	rcu_read_lock();
+	d = __mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
 	if (d)
-		return l3mdev_fib_table(d) ? : RT_TABLE_MAIN;
+		tb_id = l3mdev_fib_table(d) ? : RT_TABLE_MAIN;
 	else
-		return RT_TABLE_MAIN;
+		tb_id = RT_TABLE_MAIN;
+	rcu_read_unlock();
+
+	return tb_id;
 }
 
 static struct mlxsw_sp_rif *
@@ -1355,8 +1361,12 @@ mlxsw_sp_ipip_entry_find_by_ul_dev(const struct mlxsw_sp *mlxsw_sp,
 					ipip_list_node);
 	list_for_each_entry_continue(ipip_entry, &mlxsw_sp->router->ipip_list,
 				     ipip_list_node) {
-		struct net_device *ipip_ul_dev =
-			__mlxsw_sp_ipip_netdev_ul_dev_get(ipip_entry->ol_dev);
+		struct net_device *ol_dev = ipip_entry->ol_dev;
+		struct net_device *ipip_ul_dev;
+
+		rcu_read_lock();
+		ipip_ul_dev = __mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
+		rcu_read_unlock();
 
 		if (ipip_ul_dev == ul_dev)
 			return ipip_entry;
@@ -1722,9 +1732,12 @@ static void mlxsw_sp_ipip_demote_tunnel_by_ul_netdev(struct mlxsw_sp *mlxsw_sp,
 
 	list_for_each_entry_safe(ipip_entry, tmp, &mlxsw_sp->router->ipip_list,
 				 ipip_list_node) {
-		struct net_device *ipip_ul_dev =
-			__mlxsw_sp_ipip_netdev_ul_dev_get(ipip_entry->ol_dev);
+		struct net_device *ol_dev = ipip_entry->ol_dev;
+		struct net_device *ipip_ul_dev;
 
+		rcu_read_lock();
+		ipip_ul_dev = __mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
+		rcu_read_unlock();
 		if (ipip_ul_dev == ul_dev)
 			mlxsw_sp_ipip_entry_demote_tunnel(mlxsw_sp, ipip_entry);
 	}
@@ -3711,9 +3724,15 @@ static void mlxsw_sp_nexthop_neigh_fini(struct mlxsw_sp *mlxsw_sp,
 
 static bool mlxsw_sp_ipip_netdev_ul_up(struct net_device *ol_dev)
 {
-	struct net_device *ul_dev = __mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
+	struct net_device *ul_dev;
+	bool is_up;
+
+	rcu_read_lock();
+	ul_dev = __mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
+	is_up = ul_dev ? (ul_dev->flags & IFF_UP) : true;
+	rcu_read_unlock();
 
-	return ul_dev ? (ul_dev->flags & IFF_UP) : true;
+	return is_up;
 }
 
 static void mlxsw_sp_nexthop_ipip_init(struct mlxsw_sp *mlxsw_sp,
-- 
2.24.1

