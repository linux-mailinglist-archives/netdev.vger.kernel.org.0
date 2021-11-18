Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346A045587E
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245428AbhKRKEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:04:21 -0500
Received: from inva021.nxp.com ([92.121.34.21]:59636 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245406AbhKRKCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 05:02:55 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A06242033C2;
        Thu, 18 Nov 2021 10:59:53 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 663CE200938;
        Thu, 18 Nov 2021 10:59:53 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id C655F183AC96;
        Thu, 18 Nov 2021 17:59:50 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, po.liu@nxp.com, leoyang.li@nxp.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com, vladimir.oltean@nxp.com,
        kuba@kernel.org, mingkai.hu@nxp.com
Subject: [PATCH v7 net-next 2/8] net: mscc: ocelot: set vcap IS2 chain to goto PSFP chain
Date:   Thu, 18 Nov 2021 18:11:58 +0800
Message-Id: <20211118101204.4338-3-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
References: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
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
index 769a8159373e..ed609bc4398e 100644
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
 
@@ -407,7 +418,7 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 
 	if (filter->goto_target == -1) {
 		if ((filter->block_id == VCAP_IS2 && filter->lookup == 1) ||
-		    chain == 0) {
+		    chain == 0 || filter->block_id == PSFP_BLOCK_ID) {
 			allow_missing_goto_target = true;
 		} else {
 			NL_SET_ERR_MSG_MOD(extack, "Missing GOTO action");
-- 
2.17.1

