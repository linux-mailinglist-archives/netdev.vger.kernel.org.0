Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062002935CE
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405177AbgJTHcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:32:42 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36598 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405157AbgJTHcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:32:41 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B89011A0693;
        Tue, 20 Oct 2020 09:32:38 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A0F7D1A0718;
        Tue, 20 Oct 2020 09:32:30 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 9B4B3402F2;
        Tue, 20 Oct 2020 09:32:20 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com
Subject: [PATCH v1 net-next 2/5] net: mscc: ocelot: set vcap IS2 chain to goto PSFP chain
Date:   Tue, 20 Oct 2020 15:23:18 +0800
Message-Id: <20201020072321.36921-3-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
References: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VSC9959 supports Per-Stream Filtering and Policing(PSFP), which is
processing after VCAP blocks. We set this block on chain 30000 and
set vcap IS2 chain to goto PSFP chain if hardware support.

An example set is:
	> tc filter add dev swp0 ingress chain 21000 flower
		skip_sw action goto chain 30000

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 14 +++++++++-----
 include/soc/mscc/ocelot.h                 | 10 ++++++++++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 729495a1a77e..89f35aecbda7 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -11,15 +11,14 @@
 /* Arbitrarily chosen constants for encoding the VCAP block and lookup number
  * into the chain number. This is UAPI.
  */
-#define VCAP_BLOCK			10000
 #define VCAP_LOOKUP			1000
 #define VCAP_IS1_NUM_LOOKUPS		3
 #define VCAP_IS2_NUM_LOOKUPS		2
 #define VCAP_IS2_NUM_PAG		256
 #define VCAP_IS1_CHAIN(lookup)		\
-	(1 * VCAP_BLOCK + (lookup) * VCAP_LOOKUP)
+	(OCELOT_INGRESS_IS1 * OCELOT_HW_BLOCK + (lookup) * VCAP_LOOKUP)
 #define VCAP_IS2_CHAIN(lookup, pag)	\
-	(2 * VCAP_BLOCK + (lookup) * VCAP_LOOKUP + (pag))
+	(OCELOT_INGRESS_IS2 * OCELOT_HW_BLOCK + (lookup) * VCAP_LOOKUP + (pag))
 
 static int ocelot_chain_to_block(int chain, bool ingress)
 {
@@ -84,7 +83,8 @@ static bool ocelot_is_goto_target_valid(int goto_target, int chain,
 			goto_target == VCAP_IS1_CHAIN(1) ||
 			goto_target == VCAP_IS1_CHAIN(2) ||
 			goto_target == VCAP_IS2_CHAIN(0, 0) ||
-			goto_target == VCAP_IS2_CHAIN(1, 0));
+			goto_target == VCAP_IS2_CHAIN(1, 0) ||
+			goto_target == OCELOT_PSFP_CHAIN);
 
 	if (chain == VCAP_IS1_CHAIN(0))
 		return (goto_target == VCAP_IS1_CHAIN(1));
@@ -111,7 +111,11 @@ static bool ocelot_is_goto_target_valid(int goto_target, int chain,
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
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 31da33fdb7ac..67e71d75fc97 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -556,6 +556,16 @@ enum ocelot_tag_prefix {
 	OCELOT_TAG_PREFIX_LONG,
 };
 
+enum ocelot_ingress_blocks {
+	OCELOT_INGRESS_DEFAULT		= 0,
+	OCELOT_INGRESS_IS1,
+	OCELOT_INGRESS_IS2,
+	OCELOT_INGRESS_PSFP,
+};
+
+#define OCELOT_HW_BLOCK		10000
+#define OCELOT_PSFP_CHAIN	(OCELOT_INGRESS_PSFP * OCELOT_HW_BLOCK)
+
 struct ocelot;
 
 struct ocelot_ops {
-- 
2.17.1

