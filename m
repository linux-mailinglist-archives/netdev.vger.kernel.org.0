Return-Path: <netdev+bounces-1056-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78BA46FC06C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8D6F1C20AED
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABBE7125A7;
	Tue,  9 May 2023 07:27:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9721311CB0
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:27:02 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F47659F;
	Tue,  9 May 2023 00:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683617220; x=1715153220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rMbvF74XxIM4pJRj6ktpHcOKv3IrPzBVtco4vwIgD1g=;
  b=lUp1RlKwv5QTRzt5UX4L7TBKU4nGA2ankDlDnIYNHMgsNbyKzrfDxwOd
   6ycqBwlrBiFd2bxPIU3reBWOvqZOM8uIOSWwRz9ohsVt3BNQ9HblLsCwA
   7+Pv8uX9spbuX6xlgrKZ3q77iCoI+QPEadnHNjpLztVBVy7plBxrknSlp
   8RkgXTc9lq94shnsBYXTgpobzuwU+ueCB8Pi+o07n1/iVXRPd6IAZmzRF
   TyLiBfL7fdgHPlXzBf6JgXG8+cwHeHkRkdQ07qj2xDuYHroMZBdBlvA0Q
   GaPhVoZoCQUZWeqp1hdjtkoOTp0p1AsatJlPOp7ymjxg+dXqgqiukFIM3
   A==;
X-IronPort-AV: E=Sophos;i="5.99,261,1677567600"; 
   d="scan'208";a="212523853"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2023 00:26:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 9 May 2023 00:26:59 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 9 May 2023 00:26:56 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <lars.povlsen@microchip.com>,
	<Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
	<UNGLinuxDriver@microchip.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/3] net: lan966x: Add ES0 VCAP keyset configuration for lan966x
Date: Tue, 9 May 2023 09:26:44 +0200
Message-ID: <20230509072645.3245949-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230509072645.3245949-1-horatiu.vultur@microchip.com>
References: <20230509072645.3245949-1-horatiu.vultur@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add ES0 VCAP port keyset configuration for lan966x and also update
debugfs to show the keyset configuration.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.h |  3 +
 .../ethernet/microchip/lan966x/lan966x_regs.h | 15 ++++
 .../microchip/lan966x/lan966x_vcap_debugfs.c  | 23 ++++++
 .../microchip/lan966x/lan966x_vcap_impl.c     | 82 +++++++++++++++++++
 4 files changed, 123 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index c977c70abc3dc..882d5a08e7d51 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -101,6 +101,9 @@
 #define LAN966X_VCAP_CID_IS2_L1 VCAP_CID_INGRESS_STAGE2_L1 /* IS2 lookup 1 */
 #define LAN966X_VCAP_CID_IS2_MAX (VCAP_CID_INGRESS_STAGE2_L2 - 1) /* IS2 Max */
 
+#define LAN966X_VCAP_CID_ES0_L0 VCAP_CID_EGRESS_L0 /* ES0 lookup 0 */
+#define LAN966X_VCAP_CID_ES0_MAX (VCAP_CID_EGRESS_L1 - 1) /* ES0 Max */
+
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index f99f88b5caa88..2220391802766 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -1471,12 +1471,27 @@ enum lan966x_target {
 /*      REW:PORT:PORT_CFG */
 #define REW_PORT_CFG(g)           __REG(TARGET_REW, 0, 1, 0, g, 10, 128, 8, 0, 1, 4)
 
+#define REW_PORT_CFG_ES0_EN                      BIT(4)
+#define REW_PORT_CFG_ES0_EN_SET(x)\
+	FIELD_PREP(REW_PORT_CFG_ES0_EN, x)
+#define REW_PORT_CFG_ES0_EN_GET(x)\
+	FIELD_GET(REW_PORT_CFG_ES0_EN, x)
+
 #define REW_PORT_CFG_NO_REWRITE                  BIT(0)
 #define REW_PORT_CFG_NO_REWRITE_SET(x)\
 	FIELD_PREP(REW_PORT_CFG_NO_REWRITE, x)
 #define REW_PORT_CFG_NO_REWRITE_GET(x)\
 	FIELD_GET(REW_PORT_CFG_NO_REWRITE, x)
 
+/*      REW:COMMON:STAT_CFG */
+#define REW_STAT_CFG              __REG(TARGET_REW, 0, 1, 3072, 0, 1, 528, 520, 0, 1, 4)
+
+#define REW_STAT_CFG_STAT_MODE                   GENMASK(1, 0)
+#define REW_STAT_CFG_STAT_MODE_SET(x)\
+	FIELD_PREP(REW_STAT_CFG_STAT_MODE, x)
+#define REW_STAT_CFG_STAT_MODE_GET(x)\
+	FIELD_GET(REW_STAT_CFG_STAT_MODE, x)
+
 /*      SYS:SYSTEM:RESET_CFG */
 #define SYS_RESET_CFG             __REG(TARGET_SYS, 0, 1, 4128, 0, 1, 168, 0, 0, 1, 4)
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c
index d90c08cfcf142..ac525ff1503e6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c
@@ -190,6 +190,26 @@ static void lan966x_vcap_is2_port_keys(struct lan966x_port *port,
 	out->prf(out->dst, "\n");
 }
 
+static void lan966x_vcap_es0_port_keys(struct lan966x_port *port,
+				       struct vcap_admin *admin,
+				       struct vcap_output_print *out)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u32 val;
+
+	out->prf(out->dst, "  port[%d] (%s): ", port->chip_port,
+		 netdev_name(port->dev));
+
+	val = lan_rd(lan966x, REW_PORT_CFG(port->chip_port));
+	out->prf(out->dst, "\n    state: ");
+	if (REW_PORT_CFG_ES0_EN_GET(val))
+		out->prf(out->dst, "on");
+	else
+		out->prf(out->dst, "off");
+
+	out->prf(out->dst, "\n");
+}
+
 int lan966x_vcap_port_info(struct net_device *dev,
 			   struct vcap_admin *admin,
 			   struct vcap_output_print *out)
@@ -210,6 +230,9 @@ int lan966x_vcap_port_info(struct net_device *dev,
 	case VCAP_TYPE_IS1:
 		lan966x_vcap_is1_port_keys(port, admin, out);
 		break;
+	case VCAP_TYPE_ES0:
+		lan966x_vcap_es0_port_keys(port, admin, out);
+		break;
 	default:
 		out->prf(out->dst, "  no info\n");
 		break;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
index 7ea8e86336091..a4414f63c9b1c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -10,6 +10,12 @@
 
 #define LAN966X_IS1_LOOKUPS 3
 #define LAN966X_IS2_LOOKUPS 2
+#define LAN966X_ES0_LOOKUPS 1
+
+#define LAN966X_STAT_ESDX_GRN_BYTES 0x300
+#define LAN966X_STAT_ESDX_GRN_PKTS 0x301
+#define LAN966X_STAT_ESDX_YEL_BYTES 0x302
+#define LAN966X_STAT_ESDX_YEL_PKTS 0x303
 
 static struct lan966x_vcap_inst {
 	enum vcap_type vtype; /* type of vcap */
@@ -20,6 +26,14 @@ static struct lan966x_vcap_inst {
 	int count; /* number of available addresses */
 	bool ingress; /* is vcap in the ingress path */
 } lan966x_vcap_inst_cfg[] = {
+	{
+		.vtype = VCAP_TYPE_ES0,
+		.tgt_inst = 0,
+		.lookups = LAN966X_ES0_LOOKUPS,
+		.first_cid = LAN966X_VCAP_CID_ES0_L0,
+		.last_cid = LAN966X_VCAP_CID_ES0_MAX,
+		.count = 64,
+	},
 	{
 		.vtype = VCAP_TYPE_IS1, /* IS1-0 */
 		.tgt_inst = 1,
@@ -279,6 +293,8 @@ lan966x_vcap_validate_keyset(struct net_device *dev,
 		err = lan966x_vcap_is2_get_port_keysets(dev, lookup, &keysetlist,
 							l3_proto);
 		break;
+	case VCAP_TYPE_ES0:
+		return kslist->keysets[0];
 	default:
 		pr_err("vcap type: %s not supported\n",
 		       lan966x_vcaps[admin->vtype].name);
@@ -338,6 +354,14 @@ static void lan966x_vcap_is2_add_default_fields(struct lan966x_port *port,
 				      VCAP_BIT_0);
 }
 
+static void lan966x_vcap_es0_add_default_fields(struct lan966x_port *port,
+						struct vcap_admin *admin,
+						struct vcap_rule *rule)
+{
+	vcap_rule_add_key_u32(rule, VCAP_KF_IF_EGR_PORT_NO,
+			      port->chip_port, GENMASK(4, 0));
+}
+
 static void lan966x_vcap_add_default_fields(struct net_device *dev,
 					    struct vcap_admin *admin,
 					    struct vcap_rule *rule)
@@ -351,6 +375,9 @@ static void lan966x_vcap_add_default_fields(struct net_device *dev,
 	case VCAP_TYPE_IS2:
 		lan966x_vcap_is2_add_default_fields(port, admin, rule);
 		break;
+	case VCAP_TYPE_ES0:
+		lan966x_vcap_es0_add_default_fields(port, admin, rule);
+		break;
 	default:
 		pr_err("vcap type: %s not supported\n",
 		       lan966x_vcaps[admin->vtype].name);
@@ -366,6 +393,40 @@ static void lan966x_vcap_cache_erase(struct vcap_admin *admin)
 	memset(&admin->cache.counter, 0, sizeof(admin->cache.counter));
 }
 
+/* The ESDX counter is only used/incremented if the frame has been classified
+ * with an ISDX > 0 (e.g by a rule in IS0).  This is not mentioned in the
+ * datasheet.
+ */
+static void lan966x_es0_read_esdx_counter(struct lan966x *lan966x,
+					  struct vcap_admin *admin, u32 id)
+{
+	u32 counter;
+
+	id = id & 0xff; /* counter limit */
+	mutex_lock(&lan966x->stats_lock);
+	lan_wr(SYS_STAT_CFG_STAT_VIEW_SET(id), lan966x, SYS_STAT_CFG);
+	counter = lan_rd(lan966x, SYS_CNT(LAN966X_STAT_ESDX_GRN_PKTS)) +
+		  lan_rd(lan966x, SYS_CNT(LAN966X_STAT_ESDX_YEL_PKTS));
+	mutex_unlock(&lan966x->stats_lock);
+	if (counter)
+		admin->cache.counter = counter;
+}
+
+static void lan966x_es0_write_esdx_counter(struct lan966x *lan966x,
+					   struct vcap_admin *admin, u32 id)
+{
+	id = id & 0xff; /* counter limit */
+
+	mutex_lock(&lan966x->stats_lock);
+	lan_wr(SYS_STAT_CFG_STAT_VIEW_SET(id), lan966x, SYS_STAT_CFG);
+	lan_wr(0, lan966x, SYS_CNT(LAN966X_STAT_ESDX_GRN_BYTES));
+	lan_wr(admin->cache.counter, lan966x,
+	       SYS_CNT(LAN966X_STAT_ESDX_GRN_PKTS));
+	lan_wr(0, lan966x, SYS_CNT(LAN966X_STAT_ESDX_YEL_BYTES));
+	lan_wr(0, lan966x, SYS_CNT(LAN966X_STAT_ESDX_YEL_PKTS));
+	mutex_unlock(&lan966x->stats_lock);
+}
+
 static void lan966x_vcap_cache_write(struct net_device *dev,
 				     struct vcap_admin *admin,
 				     enum vcap_selection sel,
@@ -398,6 +459,9 @@ static void lan966x_vcap_cache_write(struct net_device *dev,
 		admin->cache.sticky = admin->cache.counter > 0;
 		lan_wr(admin->cache.counter, lan966x,
 		       VCAP_CNT_DAT(admin->tgt_inst, 0));
+
+		if (admin->vtype == VCAP_TYPE_ES0)
+			lan966x_es0_write_esdx_counter(lan966x, admin, start);
 		break;
 	default:
 		break;
@@ -437,6 +501,9 @@ static void lan966x_vcap_cache_read(struct net_device *dev,
 		admin->cache.counter =
 			lan_rd(lan966x, VCAP_CNT_DAT(instance, 0));
 		admin->cache.sticky = admin->cache.counter > 0;
+
+		if (admin->vtype == VCAP_TYPE_ES0)
+			lan966x_es0_read_esdx_counter(lan966x, admin, start);
 	}
 }
 
@@ -625,6 +692,12 @@ static void lan966x_vcap_port_key_deselection(struct lan966x *lan966x,
 			lan_wr(0, lan966x, ANA_VCAP_S2_CFG(p));
 
 		break;
+	case VCAP_TYPE_ES0:
+		for (int p = 0; p < lan966x->num_phys_ports; ++p)
+			lan_rmw(REW_PORT_CFG_ES0_EN_SET(false),
+				REW_PORT_CFG_ES0_EN, lan966x,
+				REW_PORT_CFG(p));
+		break;
 	default:
 		pr_err("vcap type: %s not supported\n",
 		       lan966x_vcaps[admin->vtype].name);
@@ -674,9 +747,18 @@ int lan966x_vcap_init(struct lan966x *lan966x)
 			lan_rmw(ANA_VCAP_CFG_S1_ENA_SET(true),
 				ANA_VCAP_CFG_S1_ENA, lan966x,
 				ANA_VCAP_CFG(lan966x->ports[p]->chip_port));
+
+			lan_rmw(REW_PORT_CFG_ES0_EN_SET(true),
+				REW_PORT_CFG_ES0_EN, lan966x,
+				REW_PORT_CFG(lan966x->ports[p]->chip_port));
 		}
 	}
 
+	/* Statistics: Use ESDX from ES0 if hit, otherwise no counting */
+	lan_rmw(REW_STAT_CFG_STAT_MODE_SET(1),
+		REW_STAT_CFG_STAT_MODE, lan966x,
+		REW_STAT_CFG);
+
 	lan966x->vcap_ctrl = ctrl;
 
 	return 0;
-- 
2.38.0


