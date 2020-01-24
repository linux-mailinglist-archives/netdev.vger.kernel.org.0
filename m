Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256D71485E5
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389540AbgAXNYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:10 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52881 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387562AbgAXNYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:10 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E877921F32;
        Fri, 24 Jan 2020 08:24:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=DTJVvOy1VY3Pm8Y9OVjKSL8hCTRUMg+zMGmoduwLnO4=; b=eF6WBbxF
        xuRWZjQxLA3m52UiE0M/zO38eTp6IvlBhxvK+1kLp9JbYryH3NOCU4jmHmX+kOFS
        c2vf5hvXK/dF9q+52jwcP4Kj5JqjQAtjYd7onrQ1lareDp3t+K74kmyAO3OqouCd
        eEXsw1mp7A8jHIX7id3uGVp3jQT9f7HzbrYn6sr/qNhpE2gqwoSIO+mziAngFuqO
        XwHPKCntbOoi4lBLUzZCGGQFK8d32ZgLCPp2rWJQ0llvrXW3MvJhB468KcBr5DlW
        Uxqp4iDMBVBPR+6IDa2Wxk5ovnTNbqfuWMn1ZaxaaaP4Nq8KE454jL0FI0vYKTIJ
        pHWG+2L8eBqm6g==
X-ME-Sender: <xms:-O8qXpJPLtsWfsNS17m_ojnZIAXvPbsYe6dmd-FrfLMxb8dgKClOOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:-O8qXpDHyvBebiCH8_74wvl3PwpLWJnrVnnySnqaumHD9PwdIJSIuw>
    <xmx:-O8qXvZyN-FA4s_psjpxLFaaNmcmO7JoPZyTflfPBf915Ikzru_hNw>
    <xmx:-O8qXjZhwtFlMOAefhXo4k3Gw8lZvrhVpcLaA-VoKb6aJiZqDyGA8A>
    <xmx:-O8qXmqTdewo5GOkIQNeb_OmxTzqjzWISPzlu7kqekM3jLNSLKBLeg>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id E38F13060F14;
        Fri, 24 Jan 2020 08:24:06 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/14] mlxsw: spectrum_qdisc: Extract a per-TC stat function
Date:   Fri, 24 Jan 2020 15:23:07 +0200
Message-Id: <20200124132318.712354-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Extract from mlxsw_sp_qdisc_get_prio_stats() two new functions:
mlxsw_sp_qdisc_collect_tc_stats() to accumulate stats for that one TC only,
and mlxsw_sp_qdisc_update_stats() that makes the stats relative to base
values stored earlier. Use them from mlxsw_sp_qdisc_get_red_stats().

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 119 ++++++++++--------
 1 file changed, 70 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index d57c9b15f45e..ef63b8cbbc94 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -227,6 +227,52 @@ mlxsw_sp_qdisc_bstats_per_priority_get(struct mlxsw_sp_port_xstats *xstats,
 	}
 }
 
+static void
+mlxsw_sp_qdisc_collect_tc_stats(struct mlxsw_sp_port *mlxsw_sp_port,
+				struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+				u64 *p_tx_bytes, u64 *p_tx_packets,
+				u64 *p_drops, u64 *p_backlog)
+{
+	u8 tclass_num = mlxsw_sp_qdisc->tclass_num;
+	struct mlxsw_sp_port_xstats *xstats;
+	u64 tx_bytes, tx_packets;
+
+	xstats = &mlxsw_sp_port->periodic_hw_stats.xstats;
+	mlxsw_sp_qdisc_bstats_per_priority_get(xstats,
+					       mlxsw_sp_qdisc->prio_bitmap,
+					       &tx_packets, &tx_bytes);
+
+	*p_tx_packets += tx_packets;
+	*p_tx_bytes += tx_bytes;
+	*p_drops += xstats->wred_drop[tclass_num] +
+		    mlxsw_sp_xstats_tail_drop(xstats, tclass_num);
+	*p_backlog += mlxsw_sp_xstats_backlog(xstats, tclass_num);
+}
+
+static void
+mlxsw_sp_qdisc_update_stats(struct mlxsw_sp *mlxsw_sp,
+			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			    u64 tx_bytes, u64 tx_packets,
+			    u64 drops, u64 backlog,
+			    struct tc_qopt_offload_stats *stats_ptr)
+{
+	struct mlxsw_sp_qdisc_stats *stats_base = &mlxsw_sp_qdisc->stats_base;
+
+	tx_bytes -= stats_base->tx_bytes;
+	tx_packets -= stats_base->tx_packets;
+	drops -= stats_base->drops;
+	backlog -= stats_base->backlog;
+
+	_bstats_update(stats_ptr->bstats, tx_bytes, tx_packets);
+	stats_ptr->qstats->drops += drops;
+	stats_ptr->qstats->backlog += mlxsw_sp_cells_bytes(mlxsw_sp, backlog);
+
+	stats_base->backlog += backlog;
+	stats_base->drops += drops;
+	stats_base->tx_bytes += tx_bytes;
+	stats_base->tx_packets += tx_packets;
+}
+
 static int
 mlxsw_sp_tclass_congestion_enable(struct mlxsw_sp_port *mlxsw_sp_port,
 				  int tclass_num, u32 min, u32 max,
@@ -403,41 +449,30 @@ mlxsw_sp_qdisc_get_red_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 			     struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			     struct tc_qopt_offload_stats *stats_ptr)
 {
-	u64 tx_bytes, tx_packets, overlimits, drops, backlog;
 	u8 tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_qdisc_stats *stats_base;
 	struct mlxsw_sp_port_xstats *xstats;
+	u64 tx_packets = 0;
+	u64 tx_bytes = 0;
+	u64 backlog = 0;
+	u64 overlimits;
+	u64 drops = 0;
 
 	xstats = &mlxsw_sp_port->periodic_hw_stats.xstats;
 	stats_base = &mlxsw_sp_qdisc->stats_base;
 
-	mlxsw_sp_qdisc_bstats_per_priority_get(xstats,
-					       mlxsw_sp_qdisc->prio_bitmap,
-					       &tx_packets, &tx_bytes);
-	tx_bytes = tx_bytes - stats_base->tx_bytes;
-	tx_packets = tx_packets - stats_base->tx_packets;
-
+	mlxsw_sp_qdisc_collect_tc_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
+					&tx_bytes, &tx_packets,
+					&drops, &backlog);
 	overlimits = xstats->wred_drop[tclass_num] + xstats->ecn -
 		     stats_base->overlimits;
-	drops = xstats->wred_drop[tclass_num] +
-		mlxsw_sp_xstats_tail_drop(xstats, tclass_num) -
-		stats_base->drops;
-	backlog = mlxsw_sp_xstats_backlog(xstats, tclass_num);
 
-	_bstats_update(stats_ptr->bstats, tx_bytes, tx_packets);
+	mlxsw_sp_qdisc_update_stats(mlxsw_sp_port->mlxsw_sp, mlxsw_sp_qdisc,
+				    tx_bytes, tx_packets, drops, backlog,
+				    stats_ptr);
 	stats_ptr->qstats->overlimits += overlimits;
-	stats_ptr->qstats->drops += drops;
-	stats_ptr->qstats->backlog +=
-				mlxsw_sp_cells_bytes(mlxsw_sp_port->mlxsw_sp,
-						     backlog) -
-				mlxsw_sp_cells_bytes(mlxsw_sp_port->mlxsw_sp,
-						     stats_base->backlog);
-
-	stats_base->backlog = backlog;
-	stats_base->drops +=  drops;
 	stats_base->overlimits += overlimits;
-	stats_base->tx_bytes += tx_bytes;
-	stats_base->tx_packets += tx_packets;
+
 	return 0;
 }
 
@@ -628,37 +663,23 @@ mlxsw_sp_qdisc_get_prio_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			      struct tc_qopt_offload_stats *stats_ptr)
 {
-	u64 tx_bytes, tx_packets, drops = 0, backlog = 0;
-	struct mlxsw_sp_qdisc_stats *stats_base;
-	struct mlxsw_sp_port_xstats *xstats;
-	struct rtnl_link_stats64 *stats;
+	struct mlxsw_sp_qdisc *tc_qdisc;
+	u64 tx_packets = 0;
+	u64 tx_bytes = 0;
+	u64 backlog = 0;
+	u64 drops = 0;
 	int i;
 
-	xstats = &mlxsw_sp_port->periodic_hw_stats.xstats;
-	stats = &mlxsw_sp_port->periodic_hw_stats.stats;
-	stats_base = &mlxsw_sp_qdisc->stats_base;
-
-	tx_bytes = stats->tx_bytes - stats_base->tx_bytes;
-	tx_packets = stats->tx_packets - stats_base->tx_packets;
-
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		drops += mlxsw_sp_xstats_tail_drop(xstats, i);
-		drops += xstats->wred_drop[i];
-		backlog += mlxsw_sp_xstats_backlog(xstats, i);
+		tc_qdisc = &mlxsw_sp_port->tclass_qdiscs[i];
+		mlxsw_sp_qdisc_collect_tc_stats(mlxsw_sp_port, tc_qdisc,
+						&tx_bytes, &tx_packets,
+						&drops, &backlog);
 	}
-	drops = drops - stats_base->drops;
 
-	_bstats_update(stats_ptr->bstats, tx_bytes, tx_packets);
-	stats_ptr->qstats->drops += drops;
-	stats_ptr->qstats->backlog +=
-				mlxsw_sp_cells_bytes(mlxsw_sp_port->mlxsw_sp,
-						     backlog) -
-				mlxsw_sp_cells_bytes(mlxsw_sp_port->mlxsw_sp,
-						     stats_base->backlog);
-	stats_base->backlog = backlog;
-	stats_base->drops += drops;
-	stats_base->tx_bytes += tx_bytes;
-	stats_base->tx_packets += tx_packets;
+	mlxsw_sp_qdisc_update_stats(mlxsw_sp_port->mlxsw_sp, mlxsw_sp_qdisc,
+				    tx_bytes, tx_packets, drops, backlog,
+				    stats_ptr);
 	return 0;
 }
 
-- 
2.24.1

