Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9378816F9B8
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbgBZIj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:39:27 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37122 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbgBZIj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:39:26 -0500
Received: by mail-wm1-f68.google.com with SMTP id a141so1227825wme.2
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q1t1Wxa8Fc3OhniYorWrQqZMq6OsztuvCbogcdRKR/U=;
        b=cH3DFzhMdqSAst9vkRIQAJ8gxghZdiwF0mQy2b5KX2A/h9obg7s8lUXXvBUCGaZ8ZN
         ReOSlK/i8dhdNsJuHOyYLFI+d7ECGAief7lT/qEUAd0scyfTSzLwoQiBbQHN8jcPyNCc
         aJZtxxGVTb/RuEoJ3Iq/S9JbYSBNMlqfWc7fQM7Guw3vw9kiWmJI+V3QeB934bot7p4k
         tomZfOAGMleHFG8botO0w/jfZFbgPKcoF4f6OLsn0gykbOQ6Upf9hDvKWY2g3v4otWQr
         un0+4+e8OqSS3uUwyjcOi0FhNvU1/PTyqgG8vRWaYISFm4ufmmZjn1lZI4wjXXY+/MKj
         rVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q1t1Wxa8Fc3OhniYorWrQqZMq6OsztuvCbogcdRKR/U=;
        b=S7GSw36gDLAmqnGUGBvCQ0DAAnPnc+oaoxGa6MPj05TG+eZy7L8bYrfu/GG0U/uEc+
         /lZjmOYiiBkqIUCDcTMny+6JxJ7/imvShqJHot/9JQhvm1xHFWO13AY5GLGKOWpldteJ
         mMromQu7G4IiQJe/162tcP2cdDUUblsHeMN69oFaZzcLPawBTnlFhpp0s7Y5qVNf4+6K
         2Qqthh8YopO1q+d6QZv/EPJFeOtf0GOEE8X8B0W4z0Hjkol8dM5AxMMfN4VVQt2bRmhq
         TAOw9DOWs7Ax3Qktq5YPm7AYGqdRvSZmM11ckjSS7tJvN8bmfw6i3kQC3as1pKrs/L84
         bE5w==
X-Gm-Message-State: APjAAAVapyUsa/nGZFhswwEe3bVng6Dh9UJveyLqukEpsRGLd1fhd+ih
        WJLDy2COxQn3pmHIcsapIySKnOxPdBE=
X-Google-Smtp-Source: APXvYqyzLjbNjo9GtD2Ec3ZVNWPDr48hSR4hcaK4Oy0IyCzVj/NJagU1QfLLMzdKPH0nd9Qh4xmAwA==
X-Received: by 2002:a1c:6308:: with SMTP id x8mr4213373wmb.80.1582706364152;
        Wed, 26 Feb 2020 00:39:24 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id b186sm1926080wmb.40.2020.02.26.00.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:39:23 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 2/4] mlxsw: spectrum: Move the ECN-marked packet counter to ethtool
Date:   Wed, 26 Feb 2020 09:39:18 +0100
Message-Id: <20200226083920.16232-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200226083920.16232-1-jiri@resnulli.us>
References: <20200226083920.16232-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Spectrum-1 and Spectrum-2 do not have a per-TC counter of number of packets
marked by ECN. The value reported currently is the total number of marked
packets. Showing this value at individual TC Qdiscs is misleading.

Move the counter to ethtool instead.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 25 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  |  9 ++-----
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 0e399b068435..1aae1c06077a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2228,6 +2228,15 @@ static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_rfc_3635_stats[] = {
 #define MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN \
 	ARRAY_SIZE(mlxsw_sp_port_hw_rfc_3635_stats)
 
+static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_ext_stats[] = {
+	{
+		.str = "ecn_marked",
+		.getter = mlxsw_reg_ppcnt_ecn_marked_get,
+	},
+};
+
+#define MLXSW_SP_PORT_HW_EXT_STATS_LEN ARRAY_SIZE(mlxsw_sp_port_hw_ext_stats)
+
 static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_discard_stats[] = {
 	{
 		.str = "discard_ingress_general",
@@ -2337,6 +2346,7 @@ static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_tc_stats[] = {
 					 MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN + \
 					 MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN + \
 					 MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN + \
+					 MLXSW_SP_PORT_HW_EXT_STATS_LEN + \
 					 MLXSW_SP_PORT_HW_DISCARD_STATS_LEN + \
 					 (MLXSW_SP_PORT_HW_PRIO_STATS_LEN * \
 					  IEEE_8021QAZ_MAX_TCS) + \
@@ -2398,6 +2408,12 @@ static void mlxsw_sp_port_get_strings(struct net_device *dev,
 			p += ETH_GSTRING_LEN;
 		}
 
+		for (i = 0; i < MLXSW_SP_PORT_HW_EXT_STATS_LEN; i++) {
+			memcpy(p, mlxsw_sp_port_hw_ext_stats[i].str,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
 		for (i = 0; i < MLXSW_SP_PORT_HW_DISCARD_STATS_LEN; i++) {
 			memcpy(p, mlxsw_sp_port_hw_discard_stats[i].str,
 			       ETH_GSTRING_LEN);
@@ -2459,6 +2475,10 @@ mlxsw_sp_get_hw_stats_by_group(struct mlxsw_sp_port_hw_stats **p_hw_stats,
 		*p_hw_stats = mlxsw_sp_port_hw_rfc_3635_stats;
 		*p_len = MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN;
 		break;
+	case MLXSW_REG_PPCNT_EXT_CNT:
+		*p_hw_stats = mlxsw_sp_port_hw_ext_stats;
+		*p_len = MLXSW_SP_PORT_HW_EXT_STATS_LEN;
+		break;
 	case MLXSW_REG_PPCNT_DISCARD_CNT:
 		*p_hw_stats = mlxsw_sp_port_hw_discard_stats;
 		*p_len = MLXSW_SP_PORT_HW_DISCARD_STATS_LEN;
@@ -2528,6 +2548,11 @@ static void mlxsw_sp_port_get_stats(struct net_device *dev,
 				  data, data_index);
 	data_index += MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN;
 
+	/* Extended Counters */
+	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_EXT_CNT, 0,
+				  data, data_index);
+	data_index += MLXSW_SP_PORT_HW_EXT_STATS_LEN;
+
 	/* Discard Counters */
 	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_DISCARD_CNT, 0,
 				  data, data_index);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 02526c53d4f5..13a054c0ce0f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -347,7 +347,6 @@ mlxsw_sp_setup_tc_qdisc_red_clean_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 					       mlxsw_sp_qdisc->prio_bitmap,
 					       &stats_base->tx_packets,
 					       &stats_base->tx_bytes);
-	red_base->prob_mark = xstats->ecn;
 	red_base->prob_drop = xstats->wred_drop[tclass_num];
 	red_base->pdrop = mlxsw_sp_xstats_tail_drop(xstats, tclass_num);
 
@@ -453,22 +452,19 @@ mlxsw_sp_qdisc_get_red_xstats(struct mlxsw_sp_port *mlxsw_sp_port,
 	u8 tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_port_xstats *xstats;
 	struct red_stats *res = xstats_ptr;
-	int early_drops, marks, pdrops;
+	int early_drops, pdrops;
 
 	xstats = &mlxsw_sp_port->periodic_hw_stats.xstats;
 
 	early_drops = xstats->wred_drop[tclass_num] - xstats_base->prob_drop;
-	marks = xstats->ecn - xstats_base->prob_mark;
 	pdrops = mlxsw_sp_xstats_tail_drop(xstats, tclass_num) -
 		 xstats_base->pdrop;
 
 	res->pdrop += pdrops;
 	res->prob_drop += early_drops;
-	res->prob_mark += marks;
 
 	xstats_base->pdrop += pdrops;
 	xstats_base->prob_drop += early_drops;
-	xstats_base->prob_mark += marks;
 	return 0;
 }
 
@@ -486,8 +482,7 @@ mlxsw_sp_qdisc_get_red_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 	stats_base = &mlxsw_sp_qdisc->stats_base;
 
 	mlxsw_sp_qdisc_get_tc_stats(mlxsw_sp_port, mlxsw_sp_qdisc, stats_ptr);
-	overlimits = xstats->wred_drop[tclass_num] + xstats->ecn -
-		     stats_base->overlimits;
+	overlimits = xstats->wred_drop[tclass_num] - stats_base->overlimits;
 
 	stats_ptr->qstats->overlimits += overlimits;
 	stats_base->overlimits += overlimits;
-- 
2.21.1

