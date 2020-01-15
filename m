Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C0813BEED
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 12:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbgAOLyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 06:54:24 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40451 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730202AbgAOLyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 06:54:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A36D52202C;
        Wed, 15 Jan 2020 06:54:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Jan 2020 06:54:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=jWKdYPjhMys37ItvfSVL7mq1no+N8ziY9esoOWA40bs=; b=cGDUTb6d
        4lWt5KDAL8eZ5yZ70bbxldLPi8HJ1pLIO7e3Vt8UW8cn1gakUkFU0tMA7kWUvgWj
        SVpBMtjgm4XfjJqakFOPzPh+NFfJbmctZsFwDzYfKCrDsY2aW4Hlt+SA2sIsrbGk
        VdfjZJe1M+AZEvhZEF0vIQQq5Q59cCowq2ZSQpHGSmjFh8nbKmFfW/Z3G7GcaUbh
        dV0g7qZJivC3TWzJc5o5vCgaYMaWqelmRuzvW98YuhybhccDkExQTX+9te0zY3oW
        cjqNN0yI5a2HxMdFuAekNKaWyBGzm8pDrb7kidGcPMV9HG+MSIMO4gcFwpxufLJZ
        KJCQkN3sLupHDQ==
X-ME-Sender: <xms:bP0eXty6-Pz_TpIrZnpwxdZ9XCOIQaKvYfT1egB3PPveXzHGWf9GeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeduleefrd
    egjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:bP0eXlJCRFOd3ZzyVketfSnkbWEup7UdW8BtBDApkCUghpbRuRfpHg>
    <xmx:bP0eXmtI8bozdsrLbnryDY1C4xQO9-ePvWNz2K4pGTzXse1ttBtRiw>
    <xmx:bP0eXnR_wQAvw6n5Tc4KqsyElvtYZzvaHp96vfDK-kZ4VrUasv8G7Q>
    <xmx:bP0eXjM4KO75eIV3tdiwh39YvoLNj3jW__N-b2S3htcNMm2jzkW2eA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 49A3880069;
        Wed, 15 Jan 2020 06:54:19 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net v2 6/6] mlxsw: spectrum_qdisc: Include MC TCs in Qdisc counters
Date:   Wed, 15 Jan 2020 13:53:49 +0200
Message-Id: <20200115115349.1273610-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115115349.1273610-1-idosch@idosch.org>
References: <20200115115349.1273610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

mlxsw configures Spectrum in such a way that BUM traffic is passed not
through its nominal traffic class TC, but through its MC counterpart TC+8.
However, when collecting statistics, Qdiscs only look at the nominal TC and
ignore the MC TC.

Add two helpers to compute the value for logical TC from the constituents,
one for backlog, the other for tail drops. Use them throughout instead of
going through the xstats pointer directly.

Counters for TX bytes and packets are deduced from packet priority
counters, and therefore already include BUM traffic. wred_drop counter is
irrelevant on MC TCs, because RED is not enabled on them.

Fixes: 7b8195306694 ("mlxsw: spectrum: Configure MC-aware mode on mlxsw ports")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 30 ++++++++++++++-----
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 46d43cfd04e9..0124bfe1963b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -195,6 +195,20 @@ mlxsw_sp_qdisc_get_xstats(struct mlxsw_sp_port *mlxsw_sp_port,
 	return -EOPNOTSUPP;
 }
 
+static u64
+mlxsw_sp_xstats_backlog(struct mlxsw_sp_port_xstats *xstats, int tclass_num)
+{
+	return xstats->backlog[tclass_num] +
+	       xstats->backlog[tclass_num + 8];
+}
+
+static u64
+mlxsw_sp_xstats_tail_drop(struct mlxsw_sp_port_xstats *xstats, int tclass_num)
+{
+	return xstats->tail_drop[tclass_num] +
+	       xstats->tail_drop[tclass_num + 8];
+}
+
 static void
 mlxsw_sp_qdisc_bstats_per_priority_get(struct mlxsw_sp_port_xstats *xstats,
 				       u8 prio_bitmap, u64 *tx_packets,
@@ -269,7 +283,7 @@ mlxsw_sp_setup_tc_qdisc_red_clean_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 					       &stats_base->tx_bytes);
 	red_base->prob_mark = xstats->ecn;
 	red_base->prob_drop = xstats->wred_drop[tclass_num];
-	red_base->pdrop = xstats->tail_drop[tclass_num];
+	red_base->pdrop = mlxsw_sp_xstats_tail_drop(xstats, tclass_num);
 
 	stats_base->overlimits = red_base->prob_drop + red_base->prob_mark;
 	stats_base->drops = red_base->prob_drop + red_base->pdrop;
@@ -370,7 +384,8 @@ mlxsw_sp_qdisc_get_red_xstats(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	early_drops = xstats->wred_drop[tclass_num] - xstats_base->prob_drop;
 	marks = xstats->ecn - xstats_base->prob_mark;
-	pdrops = xstats->tail_drop[tclass_num] - xstats_base->pdrop;
+	pdrops = mlxsw_sp_xstats_tail_drop(xstats, tclass_num) -
+		 xstats_base->pdrop;
 
 	res->pdrop += pdrops;
 	res->prob_drop += early_drops;
@@ -403,9 +418,10 @@ mlxsw_sp_qdisc_get_red_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	overlimits = xstats->wred_drop[tclass_num] + xstats->ecn -
 		     stats_base->overlimits;
-	drops = xstats->wred_drop[tclass_num] + xstats->tail_drop[tclass_num] -
+	drops = xstats->wred_drop[tclass_num] +
+		mlxsw_sp_xstats_tail_drop(xstats, tclass_num) -
 		stats_base->drops;
-	backlog = xstats->backlog[tclass_num];
+	backlog = mlxsw_sp_xstats_backlog(xstats, tclass_num);
 
 	_bstats_update(stats_ptr->bstats, tx_bytes, tx_packets);
 	stats_ptr->qstats->overlimits += overlimits;
@@ -576,9 +592,9 @@ mlxsw_sp_qdisc_get_prio_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 	tx_packets = stats->tx_packets - stats_base->tx_packets;
 
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		drops += xstats->tail_drop[i];
+		drops += mlxsw_sp_xstats_tail_drop(xstats, i);
 		drops += xstats->wred_drop[i];
-		backlog += xstats->backlog[i];
+		backlog += mlxsw_sp_xstats_backlog(xstats, i);
 	}
 	drops = drops - stats_base->drops;
 
@@ -614,7 +630,7 @@ mlxsw_sp_setup_tc_qdisc_prio_clean_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	stats_base->drops = 0;
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		stats_base->drops += xstats->tail_drop[i];
+		stats_base->drops += mlxsw_sp_xstats_tail_drop(xstats, i);
 		stats_base->drops += xstats->wred_drop[i];
 	}
 
-- 
2.24.1

