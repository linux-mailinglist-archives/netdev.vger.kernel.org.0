Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B483741D4BD
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348863AbhI3HwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:52:09 -0400
Received: from inva021.nxp.com ([92.121.34.21]:37148 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348701AbhI3HwB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 03:52:01 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E8E7A2017C0;
        Thu, 30 Sep 2021 09:50:17 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B02532017D6;
        Thu, 30 Sep 2021 09:50:17 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 04A03183AC89;
        Thu, 30 Sep 2021 15:50:14 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com
Subject: [PATCH v6 net-next 3/8] net: mscc: ocelot: set vcap IS2 chain to goto PSFP chain
Date:   Thu, 30 Sep 2021 15:59:43 +0800
Message-Id: <20210930075948.36981-4-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
References: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some chips in the ocelot series such as VSC9959 support Per-Stream
Filtering and Policing(PSFP), which is processing after VCAP blocks.
We set this block on chain 30000 and set vcap IS2 chain to goto PSFP
chain if hardware support.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 8b843d3c9189..ce812194e44c 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -20,6 +20,9 @@
 	(1 * VCAP_BLOCK + (lookup) * VCAP_LOOKUP)
 #define VCAP_IS2_CHAIN(lookup, pag)	\
 	(2 * VCAP_BLOCK + (lookup) * VCAP_LOOKUP + (pag))
+/* PSFP chain and block ID */
+#define PSFP_BLOCK_ID			OCELOT_NUM_VCAP_BLOCKS
+#define OCELOT_PSFP_CHAIN		(3 * VCAP_BLOCK)
 
 static int ocelot_chain_to_block(int chain, bool ingress)
 {
@@ -46,6 +49,9 @@ static int ocelot_chain_to_block(int chain, bool ingress)
 			if (chain == VCAP_IS2_CHAIN(lookup, pag))
 				return VCAP_IS2;
 
+	if (chain == OCELOT_PSFP_CHAIN)
+		return PSFP_BLOCK_ID;
+
 	return -EOPNOTSUPP;
 }
 
@@ -84,7 +90,8 @@ static bool ocelot_is_goto_target_valid(int goto_target, int chain,
 			goto_target == VCAP_IS1_CHAIN(1) ||
 			goto_target == VCAP_IS1_CHAIN(2) ||
 			goto_target == VCAP_IS2_CHAIN(0, 0) ||
-			goto_target == VCAP_IS2_CHAIN(1, 0));
+			goto_target == VCAP_IS2_CHAIN(1, 0) ||
+			goto_target == OCELOT_PSFP_CHAIN);
 
 	if (chain == VCAP_IS1_CHAIN(0))
 		return (goto_target == VCAP_IS1_CHAIN(1));
@@ -111,7 +118,11 @@ static bool ocelot_is_goto_target_valid(int goto_target, int chain,
 		if (chain == VCAP_IS2_CHAIN(0, pag))
 			return (goto_target == VCAP_IS2_CHAIN(1, pag));
 
-	/* VCAP IS2 lookup 1 cannot jump anywhere */
+	/* VCAP IS2 lookup 1 can goto to PSFP block if hardware support */
+	for (pag = 0; pag < VCAP_IS2_NUM_PAG; pag++)
+		if (chain == VCAP_IS2_CHAIN(1, pag))
+			return (goto_target == OCELOT_PSFP_CHAIN);
+
 	return false;
 }
 
@@ -353,7 +364,7 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 
 	if (filter->goto_target == -1) {
 		if ((filter->block_id == VCAP_IS2 && filter->lookup == 1) ||
-		    chain == 0) {
+		    chain == 0 || filter->block_id == PSFP_BLOCK_ID) {
 			allow_missing_goto_target = true;
 		} else {
 			NL_SET_ERR_MSG_MOD(extack, "Missing GOTO action");
-- 
2.17.1

