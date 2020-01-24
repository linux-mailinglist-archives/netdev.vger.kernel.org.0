Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF641485E8
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389582AbgAXNYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:13 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50995 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387562AbgAXNYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 654A421D73;
        Fri, 24 Jan 2020 08:24:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=t88/Uu3eXzGJeHE0QdJNn+50bQYsqRRMv1Jsl0scUuo=; b=q83oJpnT
        Cl51k0VOKbrE18qx/NKk2PTuGxSvliemyePa4HUNxqBcaRAFi7jPATM/Rti9JVol
        ZE71Y/NdRzu2jd1i6pVVqNeMCqV4ND9ET2fpT3NVW2EAx1YQ6k95eN2phMgTKp+f
        ZaDIxo9k3roqRCq+Rug+eK+qxp+S54sjt8GrEb9orwm0Y/ApwdlmNE6kGIAAbO96
        utgQZI8hAy96b4poyUBkMsECGSPR/vLeg3yiqWKZU3FGmZXJwXwLF+IfiRDPcLNu
        ilmhCw7nmjpI5fkpTtOqWEzIoFkC32SCPCQrPcVhOkL+lUju1Ek7Yhs9GJK/8Kmm
        qvvn2ewuiY8B3A==
X-ME-Sender: <xms:--8qXkcHelktPdIdse41oedICa6mBsu2oyWLJkZ2XkFnawGKVPCFgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:--8qXoHAR-udbc-20Bmg12kdHHtQ4yVcRVX-Td1Qy0iyZFwWthOr1w>
    <xmx:--8qXu7ikVje-MTvq3PtkJtjrC4Retu2cZesOJ9LEIelJbirwu5Lng>
    <xmx:--8qXjdLBChOGr3NFDXVDXFz7y1SYbZGlglSy_NiByiiyO7H0uGyxA>
    <xmx:--8qXtO4JYtrWymO4-aIy-NHbZarwJhofeOC6ibaCcMgxLmhuVRfqQ>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D1583060F14;
        Fri, 24 Jan 2020 08:24:08 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/14] mlxsw: spectrum_qdisc: Add mlxsw_sp_qdisc_get_class_stats()
Date:   Fri, 24 Jan 2020 15:23:08 +0200
Message-Id: <20200124132318.712354-5-idosch@idosch.org>
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

Add a wrapper around mlxsw_sp_qdisc_collect_tc_stats() and
mlxsw_sp_qdisc_update_stats() for the simple case of doing both in one go:
mlxsw_sp_qdisc_get_class_stats(). Dispatch to that function from
mlxsw_sp_qdisc_get_red_stats(). This new function will be useful for other
leaf Qdiscs as well.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 29 ++++++++++++-------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index ef63b8cbbc94..a0f07e951607 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -273,6 +273,24 @@ mlxsw_sp_qdisc_update_stats(struct mlxsw_sp *mlxsw_sp,
 	stats_base->tx_packets += tx_packets;
 }
 
+static void
+mlxsw_sp_qdisc_get_tc_stats(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			    struct tc_qopt_offload_stats *stats_ptr)
+{
+	u64 tx_packets = 0;
+	u64 tx_bytes = 0;
+	u64 backlog = 0;
+	u64 drops = 0;
+
+	mlxsw_sp_qdisc_collect_tc_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
+					&tx_bytes, &tx_packets,
+					&drops, &backlog);
+	mlxsw_sp_qdisc_update_stats(mlxsw_sp_port->mlxsw_sp, mlxsw_sp_qdisc,
+				    tx_bytes, tx_packets, drops, backlog,
+				    stats_ptr);
+}
+
 static int
 mlxsw_sp_tclass_congestion_enable(struct mlxsw_sp_port *mlxsw_sp_port,
 				  int tclass_num, u32 min, u32 max,
@@ -452,24 +470,15 @@ mlxsw_sp_qdisc_get_red_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 	u8 tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_qdisc_stats *stats_base;
 	struct mlxsw_sp_port_xstats *xstats;
-	u64 tx_packets = 0;
-	u64 tx_bytes = 0;
-	u64 backlog = 0;
 	u64 overlimits;
-	u64 drops = 0;
 
 	xstats = &mlxsw_sp_port->periodic_hw_stats.xstats;
 	stats_base = &mlxsw_sp_qdisc->stats_base;
 
-	mlxsw_sp_qdisc_collect_tc_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
-					&tx_bytes, &tx_packets,
-					&drops, &backlog);
+	mlxsw_sp_qdisc_get_tc_stats(mlxsw_sp_port, mlxsw_sp_qdisc, stats_ptr);
 	overlimits = xstats->wred_drop[tclass_num] + xstats->ecn -
 		     stats_base->overlimits;
 
-	mlxsw_sp_qdisc_update_stats(mlxsw_sp_port->mlxsw_sp, mlxsw_sp_qdisc,
-				    tx_bytes, tx_packets, drops, backlog,
-				    stats_ptr);
 	stats_ptr->qstats->overlimits += overlimits;
 	stats_base->overlimits += overlimits;
 
-- 
2.24.1

