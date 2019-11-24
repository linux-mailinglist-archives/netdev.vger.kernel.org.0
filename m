Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE6010827A
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 08:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfKXHtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 02:49:08 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43017 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725980AbfKXHtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 02:49:08 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 74A99227F8;
        Sun, 24 Nov 2019 02:49:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 24 Nov 2019 02:49:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=m5JjsiiQzRB7DLLlXztEUUanUuUc2WX4ArnFDnJHwHI=; b=s1ZOvMz/
        Me2SQha95y8iXAuvPjGsSKkbO6mJF9WHYE935ESViUTS+KO7WLHOwxtjteu5MsSQ
        b5J6ZA/JuTv9VsdGz+VG9DpTGinOBMouzTIk8mIR+feWQB2TtMfBZfqHF2uHoxgj
        rk3G2ppF/Qj5emnlvDd6zKtQB8Ai8d7R3tbsv5BAmS0JWTUV5KBvgUBN7a3IZlcg
        1v/02bguax0fcLm4QOIorqpEgaCQ2nQd8sio7IyLY2ZCY2gfFRq69JzS5xJcgIle
        CYli/MkryASPwDMLSXdez4s09+0HR6awnVV43ltiwlzekaqZ7MgbauV3l/qCsbGf
        N4HLtijRQB2IlA==
X-ME-Sender: <xms:8zXaXTdyQurY4U71TC6KFiewRsqAm6u6R8qFg2W2FTykmBL9J6g5Vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehjedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:8zXaXcppfaLU-bL-8I_wT453EL8xYbD93jIubYll_HIIPtZjTN0Aig>
    <xmx:8zXaXYxjfCw796MB71gYGgBFzaLaT5JIOyWpvBPIALsdMGjTF5NuIg>
    <xmx:8zXaXd_Zw8Q8t40AD_e7db7t2hjYJkmanotHUMtRmyAUILM2m_vUVw>
    <xmx:8zXaXdlQlKLWUzvruTDJfkcMNO08hmtjlXk7AJIxvX1s6tWaDZe_9A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD1D4306005E;
        Sun, 24 Nov 2019 02:49:05 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@mellanox.com, petrm@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] mlxsw: spectrum_router: After underlay moves, demote conflicting tunnels
Date:   Sun, 24 Nov 2019 09:48:02 +0200
Message-Id: <20191124074803.19166-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191124074803.19166-1-idosch@idosch.org>
References: <20191124074803.19166-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

When a GRE tunnel is bound to an underlay netdevice and that netdevice is
moved to a different VRF, that could cause two tunnels to have the same
underlay local address in the same VRF. Linux in this situation dispatches
the traffic according to the tunnel key (or lack thereof), but that cannot
be offloaded to Spectrum devices.

Detect this situation and unoffload the two impacted tunnels when it
happens.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 39 ++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 86e25824fcd8..4c4d99ab15a0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1614,8 +1614,25 @@ static int
 mlxsw_sp_netdevice_ipip_ul_vrf_event(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_ipip_entry *ipip_entry,
 				     struct net_device *ul_dev,
+				     bool *demote_this,
 				     struct netlink_ext_ack *extack)
 {
+	u32 ul_tb_id = l3mdev_fib_table(ul_dev) ? : RT_TABLE_MAIN;
+	enum mlxsw_sp_l3proto ul_proto;
+	union mlxsw_sp_l3addr saddr;
+
+	/* Moving underlay to a different VRF might cause local address
+	 * conflict, and the conflicting tunnels need to be demoted.
+	 */
+	ul_proto = mlxsw_sp->router->ipip_ops_arr[ipip_entry->ipipt]->ul_proto;
+	saddr = mlxsw_sp_ipip_netdev_saddr(ul_proto, ipip_entry->ol_dev);
+	if (mlxsw_sp_ipip_demote_tunnel_by_saddr(mlxsw_sp, ul_proto,
+						 saddr, ul_tb_id,
+						 ipip_entry)) {
+		*demote_this = true;
+		return 0;
+	}
+
 	return __mlxsw_sp_ipip_entry_update_tunnel(mlxsw_sp, ipip_entry,
 						   true, true, false, extack);
 }
@@ -1766,6 +1783,7 @@ static int
 __mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_ipip_entry *ipip_entry,
 				   struct net_device *ul_dev,
+				   bool *demote_this,
 				   unsigned long event,
 				   struct netdev_notifier_info *info)
 {
@@ -1780,6 +1798,7 @@ __mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 			return mlxsw_sp_netdevice_ipip_ul_vrf_event(mlxsw_sp,
 								    ipip_entry,
 								    ul_dev,
+								    demote_this,
 								    extack);
 		break;
 
@@ -1806,13 +1825,31 @@ mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 	while ((ipip_entry = mlxsw_sp_ipip_entry_find_by_ul_dev(mlxsw_sp,
 								ul_dev,
 								ipip_entry))) {
+		struct mlxsw_sp_ipip_entry *prev;
+		bool demote_this = false;
+
 		err = __mlxsw_sp_netdevice_ipip_ul_event(mlxsw_sp, ipip_entry,
-							 ul_dev, event, info);
+							 ul_dev, &demote_this,
+							 event, info);
 		if (err) {
 			mlxsw_sp_ipip_demote_tunnel_by_ul_netdev(mlxsw_sp,
 								 ul_dev);
 			return err;
 		}
+
+		if (demote_this) {
+			if (list_is_first(&ipip_entry->ipip_list_node,
+					  &mlxsw_sp->router->ipip_list))
+				prev = NULL;
+			else
+				/* This can't be cached from previous iteration,
+				 * because that entry could be gone now.
+				 */
+				prev = list_prev_entry(ipip_entry,
+						       ipip_list_node);
+			mlxsw_sp_ipip_entry_demote_tunnel(mlxsw_sp, ipip_entry);
+			ipip_entry = prev;
+		}
 	}
 
 	return 0;
-- 
2.21.0

