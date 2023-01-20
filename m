Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7D967503D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjATJI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjATJIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:08:54 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74708A0D6;
        Fri, 20 Jan 2023 01:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674205728; x=1705741728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uEMF9TCCjZbyqBWvBiORg0LCeVtcWpkpg/xC93cHKoY=;
  b=b9rhWIvMHHufl/bGNSjWCLINq1jqpgb3szdyHe72BjuYXoPwTrMDdck/
   9/QB1ltRAG6NqEamZDCc+x4EtAbjeB91N1O+v4J23mlERWkleZNXb9/uT
   NK8TnZUy9i0d88Omrh5LGq5D74Iea+xKh3sAAsKLSaexF1svm3BgNe76B
   N5tUkezQ8/jNJ814S6QgvdEQT8JT6K5GY3u2icx8jsjQebaTRkmlTNyNZ
   vup26vmBRL0EK7A/lDk7ZAdKQayL3Aq+1qzu/p0U7nM39aMlkL+Xds7BK
   nssFxPP6yYfNh+J5LrP63GkO34RxN6dSJEcIudvOk1An+v5g8cG7l9Wln
   A==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="208608269"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 02:08:48 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 02:08:47 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 02:08:43 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/8] net: microchip: sparx5: Add IS0 VCAP keyset configuration for Sparx5
Date:   Fri, 20 Jan 2023 10:08:25 +0100
Message-ID: <20230120090831.20032-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230120090831.20032-1-steen.hegelund@microchip.com>
References: <20230120090831.20032-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the IS0 VCAP port keyset configuration for Sparx5 and also
updates the debugFS support to show the keyset configuration.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_main_regs.h       |  64 ++-
 .../microchip/sparx5/sparx5_vcap_debugfs.c    | 131 ++++++-
 .../microchip/sparx5/sparx5_vcap_impl.c       | 365 +++++++++++++++---
 .../microchip/sparx5/sparx5_vcap_impl.h       |  58 +++
 4 files changed, 564 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
index 6c93dd6b01b0..15d9ba8285cc 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
@@ -4,8 +4,8 @@
  * Copyright (c) 2021 Microchip Technology Inc.
  */
 
-/* This file is autogenerated by cml-utils 2022-09-28 11:17:02 +0200.
- * Commit ID: 385c8a11d71a9f6a60368d3a3cb648fa257b479a
+/* This file is autogenerated by cml-utils 2022-12-06 15:28:38 +0100.
+ * Commit ID: 3db2ac730f134c160496f2b9f10915e347d871cb
  */
 
 #ifndef _SPARX5_MAIN_REGS_H_
@@ -843,6 +843,66 @@ enum sparx5_target {
 /*      ANA_CL:PORT:CAPTURE_BPDU_CFG */
 #define ANA_CL_CAPTURE_BPDU_CFG(g) __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 196, 0, 1, 4)
 
+/*      ANA_CL:PORT:ADV_CL_CFG_2 */
+#define ANA_CL_ADV_CL_CFG_2(g, r) __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 200, r, 6, 4)
+
+#define ANA_CL_ADV_CL_CFG_2_USE_CL_TCI0_ENA      BIT(1)
+#define ANA_CL_ADV_CL_CFG_2_USE_CL_TCI0_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_ADV_CL_CFG_2_USE_CL_TCI0_ENA, x)
+#define ANA_CL_ADV_CL_CFG_2_USE_CL_TCI0_ENA_GET(x)\
+	FIELD_GET(ANA_CL_ADV_CL_CFG_2_USE_CL_TCI0_ENA, x)
+
+#define ANA_CL_ADV_CL_CFG_2_USE_CL_DSCP_ENA      BIT(0)
+#define ANA_CL_ADV_CL_CFG_2_USE_CL_DSCP_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_ADV_CL_CFG_2_USE_CL_DSCP_ENA, x)
+#define ANA_CL_ADV_CL_CFG_2_USE_CL_DSCP_ENA_GET(x)\
+	FIELD_GET(ANA_CL_ADV_CL_CFG_2_USE_CL_DSCP_ENA, x)
+
+/*      ANA_CL:PORT:ADV_CL_CFG */
+#define ANA_CL_ADV_CL_CFG(g, r)   __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 224, r, 6, 4)
+
+#define ANA_CL_ADV_CL_CFG_IP4_CLM_KEY_SEL        GENMASK(30, 26)
+#define ANA_CL_ADV_CL_CFG_IP4_CLM_KEY_SEL_SET(x)\
+	FIELD_PREP(ANA_CL_ADV_CL_CFG_IP4_CLM_KEY_SEL, x)
+#define ANA_CL_ADV_CL_CFG_IP4_CLM_KEY_SEL_GET(x)\
+	FIELD_GET(ANA_CL_ADV_CL_CFG_IP4_CLM_KEY_SEL, x)
+
+#define ANA_CL_ADV_CL_CFG_IP6_CLM_KEY_SEL        GENMASK(25, 21)
+#define ANA_CL_ADV_CL_CFG_IP6_CLM_KEY_SEL_SET(x)\
+	FIELD_PREP(ANA_CL_ADV_CL_CFG_IP6_CLM_KEY_SEL, x)
+#define ANA_CL_ADV_CL_CFG_IP6_CLM_KEY_SEL_GET(x)\
+	FIELD_GET(ANA_CL_ADV_CL_CFG_IP6_CLM_KEY_SEL, x)
+
+#define ANA_CL_ADV_CL_CFG_MPLS_UC_CLM_KEY_SEL    GENMASK(20, 16)
+#define ANA_CL_ADV_CL_CFG_MPLS_UC_CLM_KEY_SEL_SET(x)\
+	FIELD_PREP(ANA_CL_ADV_CL_CFG_MPLS_UC_CLM_KEY_SEL, x)
+#define ANA_CL_ADV_CL_CFG_MPLS_UC_CLM_KEY_SEL_GET(x)\
+	FIELD_GET(ANA_CL_ADV_CL_CFG_MPLS_UC_CLM_KEY_SEL, x)
+
+#define ANA_CL_ADV_CL_CFG_MPLS_MC_CLM_KEY_SEL    GENMASK(15, 11)
+#define ANA_CL_ADV_CL_CFG_MPLS_MC_CLM_KEY_SEL_SET(x)\
+	FIELD_PREP(ANA_CL_ADV_CL_CFG_MPLS_MC_CLM_KEY_SEL, x)
+#define ANA_CL_ADV_CL_CFG_MPLS_MC_CLM_KEY_SEL_GET(x)\
+	FIELD_GET(ANA_CL_ADV_CL_CFG_MPLS_MC_CLM_KEY_SEL, x)
+
+#define ANA_CL_ADV_CL_CFG_MLBS_CLM_KEY_SEL       GENMASK(10, 6)
+#define ANA_CL_ADV_CL_CFG_MLBS_CLM_KEY_SEL_SET(x)\
+	FIELD_PREP(ANA_CL_ADV_CL_CFG_MLBS_CLM_KEY_SEL, x)
+#define ANA_CL_ADV_CL_CFG_MLBS_CLM_KEY_SEL_GET(x)\
+	FIELD_GET(ANA_CL_ADV_CL_CFG_MLBS_CLM_KEY_SEL, x)
+
+#define ANA_CL_ADV_CL_CFG_ETYPE_CLM_KEY_SEL      GENMASK(5, 1)
+#define ANA_CL_ADV_CL_CFG_ETYPE_CLM_KEY_SEL_SET(x)\
+	FIELD_PREP(ANA_CL_ADV_CL_CFG_ETYPE_CLM_KEY_SEL, x)
+#define ANA_CL_ADV_CL_CFG_ETYPE_CLM_KEY_SEL_GET(x)\
+	FIELD_GET(ANA_CL_ADV_CL_CFG_ETYPE_CLM_KEY_SEL, x)
+
+#define ANA_CL_ADV_CL_CFG_LOOKUP_ENA             BIT(0)
+#define ANA_CL_ADV_CL_CFG_LOOKUP_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_ADV_CL_CFG_LOOKUP_ENA, x)
+#define ANA_CL_ADV_CL_CFG_LOOKUP_ENA_GET(x)\
+	FIELD_GET(ANA_CL_ADV_CL_CFG_LOOKUP_ENA, x)
+
 /*      ANA_CL:COMMON:OWN_UPSID */
 #define ANA_CL_OWN_UPSID(r)       __REG(TARGET_ANA_CL, 0, 1, 166912, 0, 1, 756, 0, r, 3, 4)
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
index c9423adc92ce..58f86dfa54bb 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
@@ -13,10 +13,113 @@
 #include "sparx5_vcap_impl.h"
 #include "sparx5_vcap_ag_api.h"
 
-static void sparx5_vcap_port_keys(struct sparx5 *sparx5,
-				  struct vcap_admin *admin,
-				  struct sparx5_port *port,
-				  struct vcap_output_print *out)
+static const char *sparx5_vcap_is0_etype_str(u32 value)
+{
+	switch (value) {
+	case VCAP_IS0_PS_ETYPE_DEFAULT:
+		return "default";
+	case VCAP_IS0_PS_ETYPE_NORMAL_7TUPLE:
+		return "normal_7tuple";
+	case VCAP_IS0_PS_ETYPE_NORMAL_5TUPLE_IP4:
+		return "normal_5tuple_ip4";
+	case VCAP_IS0_PS_ETYPE_MLL:
+		return "mll";
+	case VCAP_IS0_PS_ETYPE_LL_FULL:
+		return "ll_full";
+	case VCAP_IS0_PS_ETYPE_PURE_5TUPLE_IP4:
+		return "pure_5tuple_ip4";
+	case VCAP_IS0_PS_ETYPE_ETAG:
+		return "etag";
+	case VCAP_IS0_PS_ETYPE_NO_LOOKUP:
+		return "no lookup";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *sparx5_vcap_is0_mpls_str(u32 value)
+{
+	switch (value) {
+	case VCAP_IS0_PS_MPLS_FOLLOW_ETYPE:
+		return "follow_etype";
+	case VCAP_IS0_PS_MPLS_NORMAL_7TUPLE:
+		return "normal_7tuple";
+	case VCAP_IS0_PS_MPLS_NORMAL_5TUPLE_IP4:
+		return "normal_5tuple_ip4";
+	case VCAP_IS0_PS_MPLS_MLL:
+		return "mll";
+	case VCAP_IS0_PS_MPLS_LL_FULL:
+		return "ll_full";
+	case VCAP_IS0_PS_MPLS_PURE_5TUPLE_IP4:
+		return "pure_5tuple_ip4";
+	case VCAP_IS0_PS_MPLS_ETAG:
+		return "etag";
+	case VCAP_IS0_PS_MPLS_NO_LOOKUP:
+		return "no lookup";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *sparx5_vcap_is0_mlbs_str(u32 value)
+{
+	switch (value) {
+	case VCAP_IS0_PS_MLBS_FOLLOW_ETYPE:
+		return "follow_etype";
+	case VCAP_IS0_PS_MLBS_NO_LOOKUP:
+		return "no lookup";
+	default:
+		return "unknown";
+	}
+}
+
+static void sparx5_vcap_is0_port_keys(struct sparx5 *sparx5,
+				      struct vcap_admin *admin,
+				      struct sparx5_port *port,
+				      struct vcap_output_print *out)
+{
+	int lookup;
+	u32 value, val;
+
+	out->prf(out->dst, "  port[%02d] (%s): ", port->portno,
+		 netdev_name(port->ndev));
+	for (lookup = 0; lookup < admin->lookups; ++lookup) {
+		out->prf(out->dst, "\n    Lookup %d: ", lookup);
+
+		/* Get lookup state */
+		value = spx5_rd(sparx5,
+				ANA_CL_ADV_CL_CFG(port->portno, lookup));
+		out->prf(out->dst, "\n      state: ");
+		if (ANA_CL_ADV_CL_CFG_LOOKUP_ENA_GET(value))
+			out->prf(out->dst, "on");
+		else
+			out->prf(out->dst, "off");
+		val = ANA_CL_ADV_CL_CFG_ETYPE_CLM_KEY_SEL_GET(value);
+		out->prf(out->dst, "\n      etype: %s",
+			 sparx5_vcap_is0_etype_str(val));
+		val = ANA_CL_ADV_CL_CFG_IP4_CLM_KEY_SEL_GET(value);
+		out->prf(out->dst, "\n      ipv4: %s",
+			 sparx5_vcap_is0_etype_str(val));
+		val = ANA_CL_ADV_CL_CFG_IP6_CLM_KEY_SEL_GET(value);
+		out->prf(out->dst, "\n      ipv6: %s",
+			 sparx5_vcap_is0_etype_str(val));
+		val = ANA_CL_ADV_CL_CFG_MPLS_UC_CLM_KEY_SEL_GET(value);
+		out->prf(out->dst, "\n      mpls_uc: %s",
+			 sparx5_vcap_is0_mpls_str(val));
+		val = ANA_CL_ADV_CL_CFG_MPLS_MC_CLM_KEY_SEL_GET(value);
+		out->prf(out->dst, "\n      mpls_mc: %s",
+			 sparx5_vcap_is0_mpls_str(val));
+		val = ANA_CL_ADV_CL_CFG_MLBS_CLM_KEY_SEL_GET(value);
+		out->prf(out->dst, "\n      mlbs: %s",
+			 sparx5_vcap_is0_mlbs_str(val));
+	}
+	out->prf(out->dst, "\n");
+}
+
+static void sparx5_vcap_is2_port_keys(struct sparx5 *sparx5,
+				      struct vcap_admin *admin,
+				      struct sparx5_port *port,
+				      struct vcap_output_print *out)
 {
 	int lookup;
 	u32 value;
@@ -126,9 +229,9 @@ static void sparx5_vcap_port_keys(struct sparx5 *sparx5,
 	out->prf(out->dst, "\n");
 }
 
-static void sparx5_vcap_port_stickies(struct sparx5 *sparx5,
-				      struct vcap_admin *admin,
-				      struct vcap_output_print *out)
+static void sparx5_vcap_is2_port_stickies(struct sparx5 *sparx5,
+					  struct vcap_admin *admin,
+					  struct vcap_output_print *out)
 {
 	int lookup;
 	u32 value;
@@ -194,7 +297,17 @@ int sparx5_port_info(struct net_device *ndev,
 	vctrl = sparx5->vcap_ctrl;
 	vcap = &vctrl->vcaps[admin->vtype];
 	out->prf(out->dst, "%s:\n", vcap->name);
-	sparx5_vcap_port_keys(sparx5, admin, port, out);
-	sparx5_vcap_port_stickies(sparx5, admin, out);
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		sparx5_vcap_is0_port_keys(sparx5, admin, port, out);
+		break;
+	case VCAP_TYPE_IS2:
+		sparx5_vcap_is2_port_keys(sparx5, admin, port, out);
+		sparx5_vcap_is2_port_stickies(sparx5, admin, out);
+		break;
+	default:
+		out->prf(out->dst, "  no info\n");
+		break;
+	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index 0d4b40997bb4..cceb4301103b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -27,6 +27,16 @@
 	 ANA_ACL_VCAP_S2_KEY_SEL_IP6_UC_KEY_SEL_SET(_v6_uc) | \
 	 ANA_ACL_VCAP_S2_KEY_SEL_ARP_KEY_SEL_SET(_arp))
 
+#define SPARX5_IS0_LOOKUPS 6
+#define VCAP_IS0_KEYSEL(_ena, _etype, _ipv4, _ipv6, _mpls_uc, _mpls_mc, _mlbs) \
+	(ANA_CL_ADV_CL_CFG_LOOKUP_ENA_SET(_ena) | \
+	ANA_CL_ADV_CL_CFG_ETYPE_CLM_KEY_SEL_SET(_etype) | \
+	ANA_CL_ADV_CL_CFG_IP4_CLM_KEY_SEL_SET(_ipv4) | \
+	ANA_CL_ADV_CL_CFG_IP6_CLM_KEY_SEL_SET(_ipv6) | \
+	ANA_CL_ADV_CL_CFG_MPLS_UC_CLM_KEY_SEL_SET(_mpls_uc) | \
+	ANA_CL_ADV_CL_CFG_MPLS_MC_CLM_KEY_SEL_SET(_mpls_mc) | \
+	ANA_CL_ADV_CL_CFG_MLBS_CLM_KEY_SEL_SET(_mlbs))
+
 static struct sparx5_vcap_inst {
 	enum vcap_type vtype; /* type of vcap */
 	int vinst; /* instance number within the same type */
@@ -39,6 +49,39 @@ static struct sparx5_vcap_inst {
 	int blockno; /* starting block in super vcap (if applicable) */
 	int blocks; /* number of blocks in super vcap (if applicable) */
 } sparx5_vcap_inst_cfg[] = {
+	{
+		.vtype = VCAP_TYPE_IS0, /* CLM-0 */
+		.vinst = 0,
+		.map_id = 1,
+		.lookups = SPARX5_IS0_LOOKUPS,
+		.lookups_per_instance = SPARX5_IS0_LOOKUPS / 3,
+		.first_cid = SPARX5_VCAP_CID_IS0_L0,
+		.last_cid = SPARX5_VCAP_CID_IS0_L2 - 1,
+		.blockno = 8, /* Maps block 8-9 */
+		.blocks = 2,
+	},
+	{
+		.vtype = VCAP_TYPE_IS0, /* CLM-1 */
+		.vinst = 1,
+		.map_id = 2,
+		.lookups = SPARX5_IS0_LOOKUPS,
+		.lookups_per_instance = SPARX5_IS0_LOOKUPS / 3,
+		.first_cid = SPARX5_VCAP_CID_IS0_L2,
+		.last_cid = SPARX5_VCAP_CID_IS0_L4 - 1,
+		.blockno = 6, /* Maps block 6-7 */
+		.blocks = 2,
+	},
+	{
+		.vtype = VCAP_TYPE_IS0, /* CLM-2 */
+		.vinst = 2,
+		.map_id = 3,
+		.lookups = SPARX5_IS0_LOOKUPS,
+		.lookups_per_instance = SPARX5_IS0_LOOKUPS / 3,
+		.first_cid = SPARX5_VCAP_CID_IS0_L4,
+		.last_cid = SPARX5_VCAP_CID_IS0_MAX,
+		.blockno = 4, /* Maps block 4-5 */
+		.blocks = 2,
+	},
 	{
 		.vtype = VCAP_TYPE_IS2, /* IS2-0 */
 		.vinst = 0,
@@ -63,6 +106,14 @@ static struct sparx5_vcap_inst {
 	},
 };
 
+static void sparx5_vcap_type_err(struct sparx5 *sparx5,
+				 struct vcap_admin *admin,
+				 const char *fname)
+{
+	pr_err("%s: vcap type: %s not supported\n",
+	       fname, sparx5_vcaps[admin->vtype].name);
+}
+
 /* Await the super VCAP completion of the current operation */
 static void sparx5_vcap_wait_super_update(struct sparx5 *sparx5)
 {
@@ -73,7 +124,7 @@ static void sparx5_vcap_wait_super_update(struct sparx5 *sparx5)
 			  false, sparx5, VCAP_SUPER_CTRL);
 }
 
-/* Initializing a VCAP address range: only IS2 for now */
+/* Initializing a VCAP address range: IS0 and IS2 for now */
 static void _sparx5_vcap_range_init(struct sparx5 *sparx5,
 				    struct vcap_admin *admin,
 				    u32 addr, u32 count)
@@ -112,6 +163,17 @@ static const char *sparx5_vcap_keyset_name(struct net_device *ndev,
 	return vcap_keyset_name(port->sparx5->vcap_ctrl, keyset);
 }
 
+/* Check if this is the first lookup of IS0 */
+static bool sparx5_vcap_is0_is_first_chain(struct vcap_rule *rule)
+{
+	return (rule->vcap_chain_id >= SPARX5_VCAP_CID_IS0_L0 &&
+		rule->vcap_chain_id < SPARX5_VCAP_CID_IS0_L1) ||
+		((rule->vcap_chain_id >= SPARX5_VCAP_CID_IS0_L2 &&
+		  rule->vcap_chain_id < SPARX5_VCAP_CID_IS0_L3)) ||
+		((rule->vcap_chain_id >= SPARX5_VCAP_CID_IS0_L4 &&
+		  rule->vcap_chain_id < SPARX5_VCAP_CID_IS0_L5));
+}
+
 /* Check if this is the first lookup of IS2 */
 static bool sparx5_vcap_is2_is_first_chain(struct vcap_rule *rule)
 {
@@ -153,12 +215,30 @@ static void sparx5_vcap_add_wide_port_mask(struct vcap_rule *rule,
 	vcap_rule_add_key_u72(rule, VCAP_KF_IF_IGR_PORT_MASK, &port_mask);
 }
 
-/* Convert chain id to vcap lookup id */
-static int sparx5_vcap_cid_to_lookup(int cid)
+/* Convert IS0 chain id to vcap lookup id */
+static int sparx5_vcap_is0_cid_to_lookup(int cid)
+{
+	int lookup = 0;
+
+	if (cid >= SPARX5_VCAP_CID_IS0_L1 && cid < SPARX5_VCAP_CID_IS0_L2)
+		lookup = 1;
+	else if (cid >= SPARX5_VCAP_CID_IS0_L2 && cid < SPARX5_VCAP_CID_IS0_L3)
+		lookup = 2;
+	else if (cid >= SPARX5_VCAP_CID_IS0_L3 && cid < SPARX5_VCAP_CID_IS0_L4)
+		lookup = 3;
+	else if (cid >= SPARX5_VCAP_CID_IS0_L4 && cid < SPARX5_VCAP_CID_IS0_L5)
+		lookup = 4;
+	else if (cid >= SPARX5_VCAP_CID_IS0_L5 && cid < SPARX5_VCAP_CID_IS0_MAX)
+		lookup = 5;
+
+	return lookup;
+}
+
+/* Convert IS2 chain id to vcap lookup id */
+static int sparx5_vcap_is2_cid_to_lookup(int cid)
 {
 	int lookup = 0;
 
-	/* For now only handle IS2 */
 	if (cid >= SPARX5_VCAP_CID_IS2_L1 && cid < SPARX5_VCAP_CID_IS2_L2)
 		lookup = 1;
 	else if (cid >= SPARX5_VCAP_CID_IS2_L2 && cid < SPARX5_VCAP_CID_IS2_L3)
@@ -169,6 +249,79 @@ static int sparx5_vcap_cid_to_lookup(int cid)
 	return lookup;
 }
 
+/* Add ethernet type IS0 keyset to a list */
+static void
+sparx5_vcap_is0_get_port_etype_keysets(struct vcap_keyset_list *keysetlist,
+				       u32 value)
+{
+	switch (ANA_CL_ADV_CL_CFG_ETYPE_CLM_KEY_SEL_GET(value)) {
+	case VCAP_IS0_PS_ETYPE_NORMAL_7TUPLE:
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_NORMAL_7TUPLE);
+		break;
+	case VCAP_IS0_PS_ETYPE_NORMAL_5TUPLE_IP4:
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_NORMAL_5TUPLE_IP4);
+		break;
+	}
+}
+
+/* Return the list of keysets for the vcap port configuration */
+static int sparx5_vcap_is0_get_port_keysets(struct net_device *ndev,
+					    int lookup,
+					    struct vcap_keyset_list *keysetlist,
+					    u16 l3_proto)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	u32 value;
+
+	value = spx5_rd(sparx5, ANA_CL_ADV_CL_CFG(portno, lookup));
+
+	/* Check if the port keyset selection is enabled */
+	if (!ANA_CL_ADV_CL_CFG_LOOKUP_ENA_GET(value))
+		return -ENOENT;
+
+	/* Collect all keysets for the port in a list */
+	if (l3_proto == ETH_P_ALL)
+		sparx5_vcap_is0_get_port_etype_keysets(keysetlist, value);
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_IP)
+		switch (ANA_CL_ADV_CL_CFG_IP4_CLM_KEY_SEL_GET(value)) {
+		case VCAP_IS0_PS_ETYPE_DEFAULT:
+			sparx5_vcap_is0_get_port_etype_keysets(keysetlist,
+							       value);
+			break;
+		case VCAP_IS0_PS_ETYPE_NORMAL_7TUPLE:
+			vcap_keyset_list_add(keysetlist,
+					     VCAP_KFS_NORMAL_7TUPLE);
+			break;
+		case VCAP_IS0_PS_ETYPE_NORMAL_5TUPLE_IP4:
+			vcap_keyset_list_add(keysetlist,
+					     VCAP_KFS_NORMAL_5TUPLE_IP4);
+			break;
+		}
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_IPV6)
+		switch (ANA_CL_ADV_CL_CFG_IP6_CLM_KEY_SEL_GET(value)) {
+		case VCAP_IS0_PS_ETYPE_DEFAULT:
+			sparx5_vcap_is0_get_port_etype_keysets(keysetlist,
+							       value);
+			break;
+		case VCAP_IS0_PS_ETYPE_NORMAL_7TUPLE:
+			vcap_keyset_list_add(keysetlist,
+					     VCAP_KFS_NORMAL_7TUPLE);
+			break;
+		case VCAP_IS0_PS_ETYPE_NORMAL_5TUPLE_IP4:
+			vcap_keyset_list_add(keysetlist,
+					     VCAP_KFS_NORMAL_5TUPLE_IP4);
+			break;
+		}
+
+	if (l3_proto != ETH_P_IP && l3_proto != ETH_P_IPV6)
+		sparx5_vcap_is0_get_port_etype_keysets(keysetlist, value);
+	return 0;
+}
+
 /* Return the list of keysets for the vcap port configuration */
 static int sparx5_vcap_is2_get_port_keysets(struct net_device *ndev,
 					    int lookup,
@@ -281,10 +434,26 @@ int sparx5_vcap_get_port_keyset(struct net_device *ndev,
 				u16 l3_proto,
 				struct vcap_keyset_list *kslist)
 {
-	int lookup;
-
-	lookup = sparx5_vcap_cid_to_lookup(cid);
-	return sparx5_vcap_is2_get_port_keysets(ndev, lookup, kslist, l3_proto);
+	int lookup, err = -EINVAL;
+	struct sparx5_port *port;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		lookup = sparx5_vcap_is0_cid_to_lookup(cid);
+		err = sparx5_vcap_is0_get_port_keysets(ndev, lookup, kslist,
+						       l3_proto);
+		break;
+	case VCAP_TYPE_IS2:
+		lookup = sparx5_vcap_is2_cid_to_lookup(cid);
+		err = sparx5_vcap_is2_get_port_keysets(ndev, lookup, kslist,
+						       l3_proto);
+		break;
+	default:
+		port = netdev_priv(ndev);
+		sparx5_vcap_type_err(port->sparx5, admin, __func__);
+		break;
+	}
+	return err;
 }
 
 /* API callback used for validating a field keyset (check the port keysets) */
@@ -297,16 +466,32 @@ sparx5_vcap_validate_keyset(struct net_device *ndev,
 {
 	struct vcap_keyset_list keysetlist = {};
 	enum vcap_keyfield_set keysets[10] = {};
+	struct sparx5_port *port;
 	int idx, jdx, lookup;
 
 	if (!kslist || kslist->cnt == 0)
 		return VCAP_KFS_NO_VALUE;
 
-	/* Get a list of currently configured keysets in the lookups */
-	lookup = sparx5_vcap_cid_to_lookup(rule->vcap_chain_id);
 	keysetlist.max = ARRAY_SIZE(keysets);
 	keysetlist.keysets = keysets;
-	sparx5_vcap_is2_get_port_keysets(ndev, lookup, &keysetlist, l3_proto);
+
+	/* Get a list of currently configured keysets in the lookups */
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		lookup = sparx5_vcap_is0_cid_to_lookup(rule->vcap_chain_id);
+		sparx5_vcap_is0_get_port_keysets(ndev, lookup, &keysetlist,
+						 l3_proto);
+		break;
+	case VCAP_TYPE_IS2:
+		lookup = sparx5_vcap_is2_cid_to_lookup(rule->vcap_chain_id);
+		sparx5_vcap_is2_get_port_keysets(ndev, lookup, &keysetlist,
+						 l3_proto);
+		break;
+	default:
+		port = netdev_priv(ndev);
+		sparx5_vcap_type_err(port->sparx5, admin, __func__);
+		break;
+	}
 
 	/* Check if there is a match and return the match */
 	for (idx = 0; idx < kslist->cnt; ++idx)
@@ -327,6 +512,8 @@ static void sparx5_vcap_add_default_fields(struct net_device *ndev,
 					   struct vcap_rule *rule)
 {
 	const struct vcap_field *field;
+	struct sparx5_port *port;
+	bool is_first = true;
 
 	field = vcap_lookup_keyfield(rule, VCAP_KF_IF_IGR_PORT_MASK);
 	if (field && field->width == SPX5_PORTS)
@@ -337,8 +524,22 @@ static void sparx5_vcap_add_default_fields(struct net_device *ndev,
 		pr_err("%s:%d: %s: could not add an ingress port mask for: %s\n",
 		       __func__, __LINE__, netdev_name(ndev),
 		       sparx5_vcap_keyset_name(ndev, rule->keyset));
+
 	/* add the lookup bit */
-	if (sparx5_vcap_is2_is_first_chain(rule))
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		is_first = sparx5_vcap_is0_is_first_chain(rule);
+		break;
+	case VCAP_TYPE_IS2:
+		is_first = sparx5_vcap_is2_is_first_chain(rule);
+		break;
+	default:
+		port = netdev_priv(ndev);
+		sparx5_vcap_type_err(port->sparx5, admin, __func__);
+		break;
+	}
+
+	if (is_first)
 		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS, VCAP_BIT_1);
 	else
 		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS, VCAP_BIT_0);
@@ -391,15 +592,26 @@ static void sparx5_vcap_cache_write(struct net_device *ndev,
 		break;
 	}
 	if (sel & VCAP_SEL_COUNTER) {
-		start = start & 0xfff; /* counter limit */
-		if (admin->vinst == 0)
+		switch (admin->vtype) {
+		case VCAP_TYPE_IS0:
 			spx5_wr(admin->cache.counter, sparx5,
-				ANA_ACL_CNT_A(start));
-		else
-			spx5_wr(admin->cache.counter, sparx5,
-				ANA_ACL_CNT_B(start));
-		spx5_wr(admin->cache.sticky, sparx5,
-			VCAP_SUPER_VCAP_CNT_DAT(0));
+				VCAP_SUPER_VCAP_CNT_DAT(0));
+			break;
+		case VCAP_TYPE_IS2:
+			start = start & 0xfff; /* counter limit */
+			if (admin->vinst == 0)
+				spx5_wr(admin->cache.counter, sparx5,
+					ANA_ACL_CNT_A(start));
+			else
+				spx5_wr(admin->cache.counter, sparx5,
+					ANA_ACL_CNT_B(start));
+			spx5_wr(admin->cache.sticky, sparx5,
+				VCAP_SUPER_VCAP_CNT_DAT(0));
+			break;
+		default:
+			sparx5_vcap_type_err(sparx5, admin, __func__);
+			break;
+		}
 	}
 }
 
@@ -432,15 +644,28 @@ static void sparx5_vcap_cache_read(struct net_device *ndev,
 					      VCAP_SUPER_VCAP_ACTION_DAT(idx));
 	}
 	if (sel & VCAP_SEL_COUNTER) {
-		start = start & 0xfff; /* counter limit */
-		if (admin->vinst == 0)
-			admin->cache.counter =
-				spx5_rd(sparx5, ANA_ACL_CNT_A(start));
-		else
+		switch (admin->vtype) {
+		case VCAP_TYPE_IS0:
 			admin->cache.counter =
-				spx5_rd(sparx5, ANA_ACL_CNT_B(start));
-		admin->cache.sticky =
-			spx5_rd(sparx5, VCAP_SUPER_VCAP_CNT_DAT(0));
+				spx5_rd(sparx5, VCAP_SUPER_VCAP_CNT_DAT(0));
+			admin->cache.sticky =
+				spx5_rd(sparx5, VCAP_SUPER_VCAP_CNT_DAT(0));
+			break;
+		case VCAP_TYPE_IS2:
+			start = start & 0xfff; /* counter limit */
+			if (admin->vinst == 0)
+				admin->cache.counter =
+					spx5_rd(sparx5, ANA_ACL_CNT_A(start));
+			else
+				admin->cache.counter =
+					spx5_rd(sparx5, ANA_ACL_CNT_B(start));
+			admin->cache.sticky =
+				spx5_rd(sparx5, VCAP_SUPER_VCAP_CNT_DAT(0));
+			break;
+		default:
+			sparx5_vcap_type_err(sparx5, admin, __func__);
+			break;
+		}
 	}
 }
 
@@ -455,7 +680,7 @@ static void sparx5_vcap_range_init(struct net_device *ndev,
 	_sparx5_vcap_range_init(sparx5, admin, addr, count);
 }
 
-/* API callback used for updating the VCAP cache */
+/* API callback used for updating the VCAP cache, IS0 and IS2 for now */
 static void sparx5_vcap_update(struct net_device *ndev,
 			       struct vcap_admin *admin, enum vcap_command cmd,
 			       enum vcap_selection sel, u32 addr)
@@ -510,7 +735,6 @@ static void sparx5_vcap_move(struct net_device *ndev, struct vcap_admin *admin,
 	sparx5_vcap_wait_super_update(sparx5);
 }
 
-/* API callback operations: only IS2 is supported for now */
 static struct vcap_operations sparx5_vcap_ops = {
 	.validate_keyset = sparx5_vcap_validate_keyset,
 	.add_default_fields = sparx5_vcap_add_default_fields,
@@ -523,16 +747,39 @@ static struct vcap_operations sparx5_vcap_ops = {
 	.port_info = sparx5_port_info,
 };
 
-/* Enable lookups per port and set the keyset generation: only IS2 for now */
-static void sparx5_vcap_port_key_selection(struct sparx5 *sparx5,
-					   struct vcap_admin *admin)
+/* Enable IS0 lookups per port and set the keyset generation */
+static void sparx5_vcap_is0_port_key_selection(struct sparx5 *sparx5,
+					       struct vcap_admin *admin)
+{
+	int portno, lookup;
+	u32 keysel;
+
+	keysel = VCAP_IS0_KEYSEL(false,
+				 VCAP_IS0_PS_ETYPE_NORMAL_7TUPLE,
+				 VCAP_IS0_PS_ETYPE_NORMAL_5TUPLE_IP4,
+				 VCAP_IS0_PS_ETYPE_NORMAL_7TUPLE,
+				 VCAP_IS0_PS_MPLS_FOLLOW_ETYPE,
+				 VCAP_IS0_PS_MPLS_FOLLOW_ETYPE,
+				 VCAP_IS0_PS_MLBS_FOLLOW_ETYPE);
+	for (lookup = 0; lookup < admin->lookups; ++lookup) {
+		for (portno = 0; portno < SPX5_PORTS; ++portno) {
+			spx5_wr(keysel, sparx5,
+				ANA_CL_ADV_CL_CFG(portno, lookup));
+			spx5_rmw(ANA_CL_ADV_CL_CFG_LOOKUP_ENA,
+				 ANA_CL_ADV_CL_CFG_LOOKUP_ENA,
+				 sparx5,
+				 ANA_CL_ADV_CL_CFG(portno, lookup));
+		}
+	}
+}
+
+/* Enable IS2 lookups per port and set the keyset generation */
+static void sparx5_vcap_is2_port_key_selection(struct sparx5 *sparx5,
+					       struct vcap_admin *admin)
 {
 	int portno, lookup;
 	u32 keysel;
 
-	/* all traffic types generate the MAC_ETYPE keyset for now in all
-	 * lookups on all ports
-	 */
 	keysel = VCAP_IS2_KEYSEL(true, VCAP_IS2_PS_NONETH_MAC_ETYPE,
 				 VCAP_IS2_PS_IPV4_MC_IP4_TCP_UDP_OTHER,
 				 VCAP_IS2_PS_IPV4_UC_IP4_TCP_UDP_OTHER,
@@ -553,17 +800,49 @@ static void sparx5_vcap_port_key_selection(struct sparx5 *sparx5,
 			 ANA_ACL_VCAP_S2_CFG(portno));
 }
 
-/* Disable lookups per port and set the keyset generation: only IS2 for now */
+/* Enable lookups per port and set the keyset generation */
+static void sparx5_vcap_port_key_selection(struct sparx5 *sparx5,
+					   struct vcap_admin *admin)
+{
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		sparx5_vcap_is0_port_key_selection(sparx5, admin);
+		break;
+	case VCAP_TYPE_IS2:
+		sparx5_vcap_is2_port_key_selection(sparx5, admin);
+		break;
+	default:
+		sparx5_vcap_type_err(sparx5, admin, __func__);
+		break;
+	}
+}
+
+/* Disable lookups per port */
 static void sparx5_vcap_port_key_deselection(struct sparx5 *sparx5,
 					     struct vcap_admin *admin)
 {
-	int portno;
+	int portno, lookup;
 
-	for (portno = 0; portno < SPX5_PORTS; ++portno)
-		spx5_rmw(ANA_ACL_VCAP_S2_CFG_SEC_ENA_SET(0),
-			 ANA_ACL_VCAP_S2_CFG_SEC_ENA,
-			 sparx5,
-			 ANA_ACL_VCAP_S2_CFG(portno));
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		for (lookup = 0; lookup < admin->lookups; ++lookup)
+			for (portno = 0; portno < SPX5_PORTS; ++portno)
+				spx5_rmw(ANA_CL_ADV_CL_CFG_LOOKUP_ENA_SET(0),
+					 ANA_CL_ADV_CL_CFG_LOOKUP_ENA,
+					 sparx5,
+					 ANA_CL_ADV_CL_CFG(portno, lookup));
+		break;
+	case VCAP_TYPE_IS2:
+		for (portno = 0; portno < SPX5_PORTS; ++portno)
+			spx5_rmw(ANA_ACL_VCAP_S2_CFG_SEC_ENA_SET(0),
+				 ANA_ACL_VCAP_S2_CFG_SEC_ENA,
+				 sparx5,
+				 ANA_ACL_VCAP_S2_CFG(portno));
+		break;
+	default:
+		sparx5_vcap_type_err(sparx5, admin, __func__);
+		break;
+	}
 }
 
 static void sparx5_vcap_admin_free(struct vcap_admin *admin)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
index 0a0f2412c980..80c99b0d50e7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
@@ -16,6 +16,15 @@
 #include "vcap_api.h"
 #include "vcap_api_client.h"
 
+#define SPARX5_VCAP_CID_IS0_L0 VCAP_CID_INGRESS_L0 /* IS0/CLM lookup 0 */
+#define SPARX5_VCAP_CID_IS0_L1 VCAP_CID_INGRESS_L1 /* IS0/CLM lookup 1 */
+#define SPARX5_VCAP_CID_IS0_L2 VCAP_CID_INGRESS_L2 /* IS0/CLM lookup 2 */
+#define SPARX5_VCAP_CID_IS0_L3 VCAP_CID_INGRESS_L3 /* IS0/CLM lookup 3 */
+#define SPARX5_VCAP_CID_IS0_L4 VCAP_CID_INGRESS_L4 /* IS0/CLM lookup 4 */
+#define SPARX5_VCAP_CID_IS0_L5 VCAP_CID_INGRESS_L5 /* IS0/CLM lookup 5 */
+#define SPARX5_VCAP_CID_IS0_MAX \
+	(VCAP_CID_INGRESS_L5 + VCAP_CID_LOOKUP_SIZE - 1) /* IS0/CLM Max */
+
 #define SPARX5_VCAP_CID_IS2_L0 VCAP_CID_INGRESS_STAGE2_L0 /* IS2 lookup 0 */
 #define SPARX5_VCAP_CID_IS2_L1 VCAP_CID_INGRESS_STAGE2_L1 /* IS2 lookup 1 */
 #define SPARX5_VCAP_CID_IS2_L2 VCAP_CID_INGRESS_STAGE2_L2 /* IS2 lookup 2 */
@@ -23,6 +32,55 @@
 #define SPARX5_VCAP_CID_IS2_MAX \
 	(VCAP_CID_INGRESS_STAGE2_L3 + VCAP_CID_LOOKUP_SIZE - 1) /* IS2 Max */
 
+/* IS0 port keyset selection control */
+
+/* IS0 ethernet, IPv4, IPv6 traffic type keyset generation */
+enum vcap_is0_port_sel_etype {
+	VCAP_IS0_PS_ETYPE_DEFAULT, /* None or follow depending on class */
+	VCAP_IS0_PS_ETYPE_MLL,
+	VCAP_IS0_PS_ETYPE_SGL_MLBS,
+	VCAP_IS0_PS_ETYPE_DBL_MLBS,
+	VCAP_IS0_PS_ETYPE_TRI_MLBS,
+	VCAP_IS0_PS_ETYPE_TRI_VID,
+	VCAP_IS0_PS_ETYPE_LL_FULL,
+	VCAP_IS0_PS_ETYPE_NORMAL_SRC,
+	VCAP_IS0_PS_ETYPE_NORMAL_DST,
+	VCAP_IS0_PS_ETYPE_NORMAL_7TUPLE,
+	VCAP_IS0_PS_ETYPE_NORMAL_5TUPLE_IP4,
+	VCAP_IS0_PS_ETYPE_PURE_5TUPLE_IP4,
+	VCAP_IS0_PS_ETYPE_DBL_VID_IDX,
+	VCAP_IS0_PS_ETYPE_ETAG,
+	VCAP_IS0_PS_ETYPE_NO_LOOKUP,
+};
+
+/* IS0 MPLS traffic type keyset generation */
+enum vcap_is0_port_sel_mpls_uc_mc {
+	VCAP_IS0_PS_MPLS_FOLLOW_ETYPE,
+	VCAP_IS0_PS_MPLS_MLL,
+	VCAP_IS0_PS_MPLS_SGL_MLBS,
+	VCAP_IS0_PS_MPLS_DBL_MLBS,
+	VCAP_IS0_PS_MPLS_TRI_MLBS,
+	VCAP_IS0_PS_MPLS_TRI_VID,
+	VCAP_IS0_PS_MPLS_LL_FULL,
+	VCAP_IS0_PS_MPLS_NORMAL_SRC,
+	VCAP_IS0_PS_MPLS_NORMAL_DST,
+	VCAP_IS0_PS_MPLS_NORMAL_7TUPLE,
+	VCAP_IS0_PS_MPLS_NORMAL_5TUPLE_IP4,
+	VCAP_IS0_PS_MPLS_PURE_5TUPLE_IP4,
+	VCAP_IS0_PS_MPLS_DBL_VID_IDX,
+	VCAP_IS0_PS_MPLS_ETAG,
+	VCAP_IS0_PS_MPLS_NO_LOOKUP,
+};
+
+/* IS0 MBLS traffic type keyset generation */
+enum vcap_is0_port_sel_mlbs {
+	VCAP_IS0_PS_MLBS_FOLLOW_ETYPE,
+	VCAP_IS0_PS_MLBS_SGL_MLBS,
+	VCAP_IS0_PS_MLBS_DBL_MLBS,
+	VCAP_IS0_PS_MLBS_TRI_MLBS,
+	VCAP_IS0_PS_MLBS_NO_LOOKUP = 17,
+};
+
 /* IS2 port keyset selection control */
 
 /* IS2 non-ethernet traffic type keyset generation */
-- 
2.39.1

