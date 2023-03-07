Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9DF6AF84B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjCGWKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjCGWJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:09:50 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA6A8E3C2;
        Tue,  7 Mar 2023 14:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678226987; x=1709762987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qviZ8IHVVxspQPM72jxTR79FC5J/TQprnZWEfqmGyPg=;
  b=lW1M+UBJ30EYUK/Rvbkr2TZrBkx9gnM4aercTSRQw+0SJxNOVX5qFgNr
   NRLpQhKgCr+DDggmmAH1MeyLRegvN1+xUnsuuTinhGt69409KyhTJZ6rr
   mgvXDpuDTYDYvi4xHvAaL/vdIgDFpIT+Uter4cDJBOifX7138M85HzXoe
   3Xckki1wEbIsnU0tM3uBf46UHpQNInZg+ZWhuGJI4k7O1VUruFlwkloXN
   oiEmG6DhFQJwebyhGuK+rdKyj4kPsOVNyZ25JklTzUrCbhcv4SAYvAeKK
   k/PTXiXdbVsd3wv8T/B6DXv7VTahHgDr0zF/fi6FM44C8rQ6OMpVVBa2M
   g==;
X-IronPort-AV: E=Sophos;i="5.98,242,1673938800"; 
   d="scan'208";a="215245452"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 15:09:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 15:09:46 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 15:09:44 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/5] net: lan966x: Add IS1 VCAP keyset configuration for lan966x
Date:   Tue, 7 Mar 2023 23:09:26 +0100
Message-ID: <20230307220929.834219-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230307220929.834219-1-horatiu.vultur@microchip.com>
References: <20230307220929.834219-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add IS1 VCAP port keyset configuration for lan966x and also update debug
fs support to show the keyset configuration.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.h |  38 ++++
 .../ethernet/microchip/lan966x/lan966x_regs.h |  36 ++++
 .../microchip/lan966x/lan966x_vcap_debugfs.c  | 133 +++++++++++-
 .../microchip/lan966x/lan966x_vcap_impl.c     | 192 ++++++++++++++++--
 4 files changed, 383 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 49f5159afbf30..cbdae0ab8bb6d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -92,6 +92,11 @@
 #define SE_IDX_QUEUE			0  /* 0-79 : Queue scheduler elements */
 #define SE_IDX_PORT			80 /* 80-89 : Port schedular elements */
 
+#define LAN966X_VCAP_CID_IS1_L0 VCAP_CID_INGRESS_L0 /* IS1 lookup 0 */
+#define LAN966X_VCAP_CID_IS1_L1 VCAP_CID_INGRESS_L1 /* IS1 lookup 1 */
+#define LAN966X_VCAP_CID_IS1_L2 VCAP_CID_INGRESS_L2 /* IS1 lookup 2 */
+#define LAN966X_VCAP_CID_IS1_MAX (VCAP_CID_INGRESS_L3 - 1) /* IS1 Max */
+
 #define LAN966X_VCAP_CID_IS2_L0 VCAP_CID_INGRESS_STAGE2_L0 /* IS2 lookup 0 */
 #define LAN966X_VCAP_CID_IS2_L1 VCAP_CID_INGRESS_STAGE2_L1 /* IS2 lookup 1 */
 #define LAN966X_VCAP_CID_IS2_MAX (VCAP_CID_INGRESS_STAGE2_L2 - 1) /* IS2 Max */
@@ -139,6 +144,39 @@ enum vcap_is2_port_sel_ipv6 {
 	VCAP_IS2_PS_IPV6_MAC_ETYPE,
 };
 
+enum vcap_is1_port_sel_other {
+	VCAP_IS1_PS_OTHER_NORMAL,
+	VCAP_IS1_PS_OTHER_7TUPLE,
+	VCAP_IS1_PS_OTHER_DBL_VID,
+	VCAP_IS1_PS_OTHER_DMAC_VID,
+};
+
+enum vcap_is1_port_sel_ipv4 {
+	VCAP_IS1_PS_IPV4_NORMAL,
+	VCAP_IS1_PS_IPV4_7TUPLE,
+	VCAP_IS1_PS_IPV4_5TUPLE_IP4,
+	VCAP_IS1_PS_IPV4_DBL_VID,
+	VCAP_IS1_PS_IPV4_DMAC_VID,
+};
+
+enum vcap_is1_port_sel_ipv6 {
+	VCAP_IS1_PS_IPV6_NORMAL,
+	VCAP_IS1_PS_IPV6_7TUPLE,
+	VCAP_IS1_PS_IPV6_5TUPLE_IP4,
+	VCAP_IS1_PS_IPV6_NORMAL_IP6,
+	VCAP_IS1_PS_IPV6_5TUPLE_IP6,
+	VCAP_IS1_PS_IPV6_DBL_VID,
+	VCAP_IS1_PS_IPV6_DMAC_VID,
+};
+
+enum vcap_is1_port_sel_rt {
+	VCAP_IS1_PS_RT_NORMAL,
+	VCAP_IS1_PS_RT_7TUPLE,
+	VCAP_IS1_PS_RT_DBL_VID,
+	VCAP_IS1_PS_RT_DMAC_VID,
+	VCAP_IS1_PS_RT_FOLLOW_OTHER = 7,
+};
+
 struct lan966x_port;
 
 struct lan966x_db {
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 9767b5a1c9580..f99f88b5caa88 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -316,6 +316,42 @@ enum lan966x_target {
 #define ANA_DROP_CFG_DROP_MC_SMAC_ENA_GET(x)\
 	FIELD_GET(ANA_DROP_CFG_DROP_MC_SMAC_ENA, x)
 
+/*      ANA:PORT:VCAP_CFG */
+#define ANA_VCAP_CFG(g)           __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 12, 0, 1, 4)
+
+#define ANA_VCAP_CFG_S1_ENA                      BIT(14)
+#define ANA_VCAP_CFG_S1_ENA_SET(x)\
+	FIELD_PREP(ANA_VCAP_CFG_S1_ENA, x)
+#define ANA_VCAP_CFG_S1_ENA_GET(x)\
+	FIELD_GET(ANA_VCAP_CFG_S1_ENA, x)
+
+/*      ANA:PORT:VCAP_S1_KEY_CFG */
+#define ANA_VCAP_S1_CFG(g, r)     __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 16, r, 3, 4)
+
+#define ANA_VCAP_S1_CFG_KEY_RT_CFG               GENMASK(11, 9)
+#define ANA_VCAP_S1_CFG_KEY_RT_CFG_SET(x)\
+	FIELD_PREP(ANA_VCAP_S1_CFG_KEY_RT_CFG, x)
+#define ANA_VCAP_S1_CFG_KEY_RT_CFG_GET(x)\
+	FIELD_GET(ANA_VCAP_S1_CFG_KEY_RT_CFG, x)
+
+#define ANA_VCAP_S1_CFG_KEY_IP6_CFG              GENMASK(8, 6)
+#define ANA_VCAP_S1_CFG_KEY_IP6_CFG_SET(x)\
+	FIELD_PREP(ANA_VCAP_S1_CFG_KEY_IP6_CFG, x)
+#define ANA_VCAP_S1_CFG_KEY_IP6_CFG_GET(x)\
+	FIELD_GET(ANA_VCAP_S1_CFG_KEY_IP6_CFG, x)
+
+#define ANA_VCAP_S1_CFG_KEY_IP4_CFG              GENMASK(5, 3)
+#define ANA_VCAP_S1_CFG_KEY_IP4_CFG_SET(x)\
+	FIELD_PREP(ANA_VCAP_S1_CFG_KEY_IP4_CFG, x)
+#define ANA_VCAP_S1_CFG_KEY_IP4_CFG_GET(x)\
+	FIELD_GET(ANA_VCAP_S1_CFG_KEY_IP4_CFG, x)
+
+#define ANA_VCAP_S1_CFG_KEY_OTHER_CFG            GENMASK(2, 0)
+#define ANA_VCAP_S1_CFG_KEY_OTHER_CFG_SET(x)\
+	FIELD_PREP(ANA_VCAP_S1_CFG_KEY_OTHER_CFG, x)
+#define ANA_VCAP_S1_CFG_KEY_OTHER_CFG_GET(x)\
+	FIELD_GET(ANA_VCAP_S1_CFG_KEY_OTHER_CFG, x)
+
 /*      ANA:PORT:VCAP_S2_CFG */
 #define ANA_VCAP_S2_CFG(g)        __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 28, 0, 1, 4)
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c
index 7a0db58f55136..d90c08cfcf142 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c
@@ -5,9 +5,124 @@
 #include "vcap_api.h"
 #include "vcap_api_client.h"
 
-static void lan966x_vcap_port_keys(struct lan966x_port *port,
-				   struct vcap_admin *admin,
-				   struct vcap_output_print *out)
+static void lan966x_vcap_is1_port_keys(struct lan966x_port *port,
+				       struct vcap_admin *admin,
+				       struct vcap_output_print *out)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u32 val;
+
+	out->prf(out->dst, "  port[%d] (%s): ", port->chip_port,
+		 netdev_name(port->dev));
+
+	val = lan_rd(lan966x, ANA_VCAP_CFG(port->chip_port));
+	out->prf(out->dst, "\n    state: ");
+	if (ANA_VCAP_CFG_S1_ENA_GET(val))
+		out->prf(out->dst, "on");
+	else
+		out->prf(out->dst, "off");
+
+	for (int l = 0; l < admin->lookups; ++l) {
+		out->prf(out->dst, "\n    Lookup %d: ", l);
+
+		out->prf(out->dst, "\n      other: ");
+		switch (ANA_VCAP_S1_CFG_KEY_OTHER_CFG_GET(val)) {
+		case VCAP_IS1_PS_OTHER_NORMAL:
+			out->prf(out->dst, "normal");
+			break;
+		case VCAP_IS1_PS_OTHER_7TUPLE:
+			out->prf(out->dst, "7tuple");
+			break;
+		case VCAP_IS1_PS_OTHER_DBL_VID:
+			out->prf(out->dst, "dbl_vid");
+			break;
+		case VCAP_IS1_PS_OTHER_DMAC_VID:
+			out->prf(out->dst, "dmac_vid");
+			break;
+		default:
+			out->prf(out->dst, "-");
+			break;
+		}
+
+		out->prf(out->dst, "\n      ipv4: ");
+		switch (ANA_VCAP_S1_CFG_KEY_IP4_CFG_GET(val)) {
+		case VCAP_IS1_PS_IPV4_NORMAL:
+			out->prf(out->dst, "normal");
+			break;
+		case VCAP_IS1_PS_IPV4_7TUPLE:
+			out->prf(out->dst, "7tuple");
+			break;
+		case VCAP_IS1_PS_IPV4_5TUPLE_IP4:
+			out->prf(out->dst, "5tuple_ipv4");
+			break;
+		case VCAP_IS1_PS_IPV4_DBL_VID:
+			out->prf(out->dst, "dbl_vid");
+			break;
+		case VCAP_IS1_PS_IPV4_DMAC_VID:
+			out->prf(out->dst, "dmac_vid");
+			break;
+		default:
+			out->prf(out->dst, "-");
+			break;
+		}
+
+		out->prf(out->dst, "\n      ipv6: ");
+		switch (ANA_VCAP_S1_CFG_KEY_IP6_CFG_GET(val)) {
+		case VCAP_IS1_PS_IPV6_NORMAL:
+			out->prf(out->dst, "normal");
+			break;
+		case VCAP_IS1_PS_IPV6_7TUPLE:
+			out->prf(out->dst, "7tuple");
+			break;
+		case VCAP_IS1_PS_IPV6_5TUPLE_IP4:
+			out->prf(out->dst, "5tuple_ip4");
+			break;
+		case VCAP_IS1_PS_IPV6_NORMAL_IP6:
+			out->prf(out->dst, "normal_ip6");
+			break;
+		case VCAP_IS1_PS_IPV6_5TUPLE_IP6:
+			out->prf(out->dst, "5tuple_ip6");
+			break;
+		case VCAP_IS1_PS_IPV6_DBL_VID:
+			out->prf(out->dst, "dbl_vid");
+			break;
+		case VCAP_IS1_PS_IPV6_DMAC_VID:
+			out->prf(out->dst, "dmac_vid");
+			break;
+		default:
+			out->prf(out->dst, "-");
+			break;
+		}
+
+		out->prf(out->dst, "\n      rt: ");
+		switch (ANA_VCAP_S1_CFG_KEY_RT_CFG_GET(val)) {
+		case VCAP_IS1_PS_RT_NORMAL:
+			out->prf(out->dst, "normal");
+			break;
+		case VCAP_IS1_PS_RT_7TUPLE:
+			out->prf(out->dst, "7tuple");
+			break;
+		case VCAP_IS1_PS_RT_DBL_VID:
+			out->prf(out->dst, "dbl_vid");
+			break;
+		case VCAP_IS1_PS_RT_DMAC_VID:
+			out->prf(out->dst, "dmac_vid");
+			break;
+		case VCAP_IS1_PS_RT_FOLLOW_OTHER:
+			out->prf(out->dst, "follow_other");
+			break;
+		default:
+			out->prf(out->dst, "-");
+			break;
+		}
+	}
+
+	out->prf(out->dst, "\n");
+}
+
+static void lan966x_vcap_is2_port_keys(struct lan966x_port *port,
+				       struct vcap_admin *admin,
+				       struct vcap_output_print *out)
 {
 	struct lan966x *lan966x = port->lan966x;
 	u32 val;
@@ -88,7 +203,17 @@ int lan966x_vcap_port_info(struct net_device *dev,
 	vcap = &vctrl->vcaps[admin->vtype];
 
 	out->prf(out->dst, "%s:\n", vcap->name);
-	lan966x_vcap_port_keys(port, admin, out);
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS2:
+		lan966x_vcap_is2_port_keys(port, admin, out);
+		break;
+	case VCAP_TYPE_IS1:
+		lan966x_vcap_is1_port_keys(port, admin, out);
+		break;
+	default:
+		out->prf(out->dst, "  no info\n");
+		break;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
index 68f9d69fd37b6..7ea8e86336091 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -8,6 +8,7 @@
 
 #define STREAMSIZE (64 * 4)
 
+#define LAN966X_IS1_LOOKUPS 3
 #define LAN966X_IS2_LOOKUPS 2
 
 static struct lan966x_vcap_inst {
@@ -19,6 +20,15 @@ static struct lan966x_vcap_inst {
 	int count; /* number of available addresses */
 	bool ingress; /* is vcap in the ingress path */
 } lan966x_vcap_inst_cfg[] = {
+	{
+		.vtype = VCAP_TYPE_IS1, /* IS1-0 */
+		.tgt_inst = 1,
+		.lookups = LAN966X_IS1_LOOKUPS,
+		.first_cid = LAN966X_VCAP_CID_IS1_L0,
+		.last_cid = LAN966X_VCAP_CID_IS1_MAX,
+		.count = 768,
+		.ingress = true,
+	},
 	{
 		.vtype = VCAP_TYPE_IS2, /* IS2-0 */
 		.tgt_inst = 2,
@@ -72,7 +82,21 @@ static void __lan966x_vcap_range_init(struct lan966x *lan966x,
 	lan966x_vcap_wait_update(lan966x, admin->tgt_inst);
 }
 
-static int lan966x_vcap_cid_to_lookup(int cid)
+static int lan966x_vcap_is1_cid_to_lookup(int cid)
+{
+	int lookup = 0;
+
+	if (cid >= LAN966X_VCAP_CID_IS1_L1 &&
+	    cid < LAN966X_VCAP_CID_IS1_L2)
+		lookup = 1;
+	else if (cid >= LAN966X_VCAP_CID_IS1_L2 &&
+		 cid < LAN966X_VCAP_CID_IS1_MAX)
+		lookup = 2;
+
+	return lookup;
+}
+
+static int lan966x_vcap_is2_cid_to_lookup(int cid)
 {
 	if (cid >= LAN966X_VCAP_CID_IS2_L1 &&
 	    cid < LAN966X_VCAP_CID_IS2_MAX)
@@ -81,6 +105,67 @@ static int lan966x_vcap_cid_to_lookup(int cid)
 	return 0;
 }
 
+/* Return the list of keysets for the vcap port configuration */
+static int
+lan966x_vcap_is1_get_port_keysets(struct net_device *ndev, int lookup,
+				  struct vcap_keyset_list *keysetlist,
+				  u16 l3_proto)
+{
+	struct lan966x_port *port = netdev_priv(ndev);
+	struct lan966x *lan966x = port->lan966x;
+	u32 val;
+
+	val = lan_rd(lan966x, ANA_VCAP_S1_CFG(port->chip_port, lookup));
+
+	/* Collect all keysets for the port in a list */
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_IP) {
+		switch (ANA_VCAP_S1_CFG_KEY_IP4_CFG_GET(val)) {
+		case VCAP_IS1_PS_IPV4_7TUPLE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_7TUPLE);
+			break;
+		case VCAP_IS1_PS_IPV4_5TUPLE_IP4:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_5TUPLE_IP4);
+			break;
+		case VCAP_IS1_PS_IPV4_NORMAL:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_NORMAL);
+			break;
+		}
+	}
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_IPV6) {
+		switch (ANA_VCAP_S1_CFG_KEY_IP6_CFG_GET(val)) {
+		case VCAP_IS1_PS_IPV6_NORMAL:
+		case VCAP_IS1_PS_IPV6_NORMAL_IP6:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_NORMAL);
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_NORMAL_IP6);
+			break;
+		case VCAP_IS1_PS_IPV6_5TUPLE_IP6:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_5TUPLE_IP6);
+			break;
+		case VCAP_IS1_PS_IPV6_7TUPLE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_7TUPLE);
+			break;
+		case VCAP_IS1_PS_IPV6_5TUPLE_IP4:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_5TUPLE_IP4);
+			break;
+		case VCAP_IS1_PS_IPV6_DMAC_VID:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_DMAC_VID);
+			break;
+		}
+	}
+
+	switch (ANA_VCAP_S1_CFG_KEY_OTHER_CFG_GET(val)) {
+	case VCAP_IS1_PS_OTHER_7TUPLE:
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_7TUPLE);
+		break;
+	case VCAP_IS1_PS_OTHER_NORMAL:
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_NORMAL);
+		break;
+	}
+
+	return 0;
+}
+
 static int
 lan966x_vcap_is2_get_port_keysets(struct net_device *dev, int lookup,
 				  struct vcap_keyset_list *keysetlist,
@@ -180,11 +265,26 @@ lan966x_vcap_validate_keyset(struct net_device *dev,
 	if (!kslist || kslist->cnt == 0)
 		return VCAP_KFS_NO_VALUE;
 
-	lookup = lan966x_vcap_cid_to_lookup(rule->vcap_chain_id);
 	keysetlist.max = ARRAY_SIZE(keysets);
 	keysetlist.keysets = keysets;
-	err = lan966x_vcap_is2_get_port_keysets(dev, lookup, &keysetlist,
-						l3_proto);
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS1:
+		lookup = lan966x_vcap_is1_cid_to_lookup(rule->vcap_chain_id);
+		err = lan966x_vcap_is1_get_port_keysets(dev, lookup, &keysetlist,
+							l3_proto);
+		break;
+	case VCAP_TYPE_IS2:
+		lookup = lan966x_vcap_is2_cid_to_lookup(rule->vcap_chain_id);
+		err = lan966x_vcap_is2_get_port_keysets(dev, lookup, &keysetlist,
+							l3_proto);
+		break;
+	default:
+		pr_err("vcap type: %s not supported\n",
+		       lan966x_vcaps[admin->vtype].name);
+		return VCAP_KFS_NO_VALUE;
+	}
+
 	if (err)
 		return VCAP_KFS_NO_VALUE;
 
@@ -197,17 +297,32 @@ lan966x_vcap_validate_keyset(struct net_device *dev,
 	return VCAP_KFS_NO_VALUE;
 }
 
-static bool lan966x_vcap_is_first_chain(struct vcap_rule *rule)
+static bool lan966x_vcap_is2_is_first_chain(struct vcap_rule *rule)
 {
 	return (rule->vcap_chain_id >= LAN966X_VCAP_CID_IS2_L0 &&
 		rule->vcap_chain_id < LAN966X_VCAP_CID_IS2_L1);
 }
 
-static void lan966x_vcap_add_default_fields(struct net_device *dev,
-					    struct vcap_admin *admin,
-					    struct vcap_rule *rule)
+static void lan966x_vcap_is1_add_default_fields(struct lan966x_port *port,
+						struct vcap_admin *admin,
+						struct vcap_rule *rule)
+{
+	u32 value, mask;
+	u32 lookup;
+
+	if (vcap_rule_get_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK,
+				  &value, &mask))
+		vcap_rule_add_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK, 0,
+				      ~BIT(port->chip_port));
+
+	lookup = lan966x_vcap_is1_cid_to_lookup(rule->vcap_chain_id);
+	vcap_rule_add_key_u32(rule, VCAP_KF_LOOKUP_INDEX, lookup, 0x3);
+}
+
+static void lan966x_vcap_is2_add_default_fields(struct lan966x_port *port,
+						struct vcap_admin *admin,
+						struct vcap_rule *rule)
 {
-	struct lan966x_port *port = netdev_priv(dev);
 	u32 value, mask;
 
 	if (vcap_rule_get_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK,
@@ -215,7 +330,7 @@ static void lan966x_vcap_add_default_fields(struct net_device *dev,
 		vcap_rule_add_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK, 0,
 				      ~BIT(port->chip_port));
 
-	if (lan966x_vcap_is_first_chain(rule))
+	if (lan966x_vcap_is2_is_first_chain(rule))
 		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS,
 				      VCAP_BIT_1);
 	else
@@ -223,6 +338,26 @@ static void lan966x_vcap_add_default_fields(struct net_device *dev,
 				      VCAP_BIT_0);
 }
 
+static void lan966x_vcap_add_default_fields(struct net_device *dev,
+					    struct vcap_admin *admin,
+					    struct vcap_rule *rule)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS1:
+		lan966x_vcap_is1_add_default_fields(port, admin, rule);
+		break;
+	case VCAP_TYPE_IS2:
+		lan966x_vcap_is2_add_default_fields(port, admin, rule);
+		break;
+	default:
+		pr_err("vcap type: %s not supported\n",
+		       lan966x_vcaps[admin->vtype].name);
+		break;
+	}
+}
+
 static void lan966x_vcap_cache_erase(struct vcap_admin *admin)
 {
 	memset(admin->cache.keystream, 0, STREAMSIZE);
@@ -464,8 +599,37 @@ static void lan966x_vcap_block_init(struct lan966x *lan966x,
 static void lan966x_vcap_port_key_deselection(struct lan966x *lan966x,
 					      struct vcap_admin *admin)
 {
-	for (int p = 0; p < lan966x->num_phys_ports; ++p)
-		lan_wr(0, lan966x, ANA_VCAP_S2_CFG(p));
+	u32 val;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS1:
+		val = ANA_VCAP_S1_CFG_KEY_IP6_CFG_SET(VCAP_IS1_PS_IPV6_5TUPLE_IP6) |
+		      ANA_VCAP_S1_CFG_KEY_IP4_CFG_SET(VCAP_IS1_PS_IPV4_5TUPLE_IP4) |
+		      ANA_VCAP_S1_CFG_KEY_OTHER_CFG_SET(VCAP_IS1_PS_OTHER_NORMAL);
+
+		for (int p = 0; p < lan966x->num_phys_ports; ++p) {
+			if (!lan966x->ports[p])
+				continue;
+
+			for (int l = 0; l < LAN966X_IS1_LOOKUPS; ++l)
+				lan_wr(val, lan966x, ANA_VCAP_S1_CFG(p, l));
+
+			lan_rmw(ANA_VCAP_CFG_S1_ENA_SET(true),
+				ANA_VCAP_CFG_S1_ENA, lan966x,
+				ANA_VCAP_CFG(p));
+		}
+
+		break;
+	case VCAP_TYPE_IS2:
+		for (int p = 0; p < lan966x->num_phys_ports; ++p)
+			lan_wr(0, lan966x, ANA_VCAP_S2_CFG(p));
+
+		break;
+	default:
+		pr_err("vcap type: %s not supported\n",
+		       lan966x_vcaps[admin->vtype].name);
+		break;
+	}
 }
 
 int lan966x_vcap_init(struct lan966x *lan966x)
@@ -506,6 +670,10 @@ int lan966x_vcap_init(struct lan966x *lan966x)
 			lan_rmw(ANA_VCAP_S2_CFG_ENA_SET(true),
 				ANA_VCAP_S2_CFG_ENA, lan966x,
 				ANA_VCAP_S2_CFG(lan966x->ports[p]->chip_port));
+
+			lan_rmw(ANA_VCAP_CFG_S1_ENA_SET(true),
+				ANA_VCAP_CFG_S1_ENA, lan966x,
+				ANA_VCAP_CFG(lan966x->ports[p]->chip_port));
 		}
 	}
 
-- 
2.38.0

