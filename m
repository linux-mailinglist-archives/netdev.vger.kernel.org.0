Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDF867E62D
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbjA0NKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbjA0NJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:09:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F317F689;
        Fri, 27 Jan 2023 05:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674824962; x=1706360962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dTkPiHVPnTT7pGbCjAQmkYW9T8O46/aTlQY8W+XAwXA=;
  b=o+cZYRuvlzEE8UpP8XJtNI03BTBZDMP+tSReBMMIOc336qj4KVpswLvu
   luDVbkbqr/6KYpoAEiqrefYG0/uebyPFTrVbIor1u1duEqVqPpOtoYFsU
   j+6ykUv4SqQmu8vgqWLFWH9PcxSk9cIrZuk/OWp0K+QDljwkXo2hEiHQ6
   RaXRP8eW6BwdPglajR5ZwPpNWjM4olraUhFNvroFbCe7U8vH213ipSfte
   2DSHqDFNDxAcFtHyoSp0kQ2HNh14j5M09Nz5HJKOAvoKmRaJq/kQZy4gz
   1H/dTBjv2A9B+w3MwsF7NosdshGoCYLUTSnrU5M1wNuTqHSEepPEvQEQd
   A==;
X-IronPort-AV: E=Sophos;i="5.97,251,1669100400"; 
   d="scan'208";a="194150575"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2023 06:09:16 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 06:09:15 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 06:09:08 -0700
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
Subject: [PATCH net-next 6/8] net: microchip: sparx5: Add ingress information to VCAP instance
Date:   Fri, 27 Jan 2023 14:08:28 +0100
Message-ID: <20230127130830.1481526-7-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127130830.1481526-1-steen.hegelund@microchip.com>
References: <20230127130830.1481526-1-steen.hegelund@microchip.com>
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

This allows the check of the goto action to be specific to the ingress and
egress VCAP instances.

The debugfs support is also updated to show this information.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.h    |  3 ++-
 .../net/ethernet/microchip/lan966x/lan966x_tc.c  |  2 +-
 .../microchip/lan966x/lan966x_tc_flower.c        | 16 ++++++++++------
 .../microchip/lan966x/lan966x_vcap_impl.c        |  3 +++
 .../ethernet/microchip/sparx5/sparx5_tc_flower.c | 13 ++++++++-----
 .../ethernet/microchip/sparx5/sparx5_vcap_impl.c |  8 ++++++++
 drivers/net/ethernet/microchip/vcap/vcap_api.c   | 12 +++++++-----
 drivers/net/ethernet/microchip/vcap/vcap_api.h   |  1 +
 .../ethernet/microchip/vcap/vcap_api_client.h    |  2 +-
 .../ethernet/microchip/vcap/vcap_api_debugfs.c   |  1 +
 .../microchip/vcap/vcap_api_debugfs_kunit.c      |  4 ++++
 11 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 0106f9487cbe..26646ca5929d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -603,7 +603,8 @@ int lan966x_vcap_init(struct lan966x *lan966x);
 void lan966x_vcap_deinit(struct lan966x *lan966x);
 
 int lan966x_tc_flower(struct lan966x_port *port,
-		      struct flow_cls_offload *f);
+		      struct flow_cls_offload *f,
+		      bool ingress);
 
 int lan966x_goto_port_add(struct lan966x_port *port,
 			  int from_cid, int to_cid,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
index 01072121c999..80625ba0b354 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
@@ -70,7 +70,7 @@ static int lan966x_tc_block_cb(enum tc_setup_type type, void *type_data,
 	case TC_SETUP_CLSMATCHALL:
 		return lan966x_tc_matchall(port, type_data, ingress);
 	case TC_SETUP_CLSFLOWER:
-		return lan966x_tc_flower(port, type_data);
+		return lan966x_tc_flower(port, type_data, ingress);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
index b66a8725a071..88c655d6318f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -83,7 +83,8 @@ static int lan966x_tc_flower_use_dissectors(struct flow_cls_offload *f,
 
 static int lan966x_tc_flower_action_check(struct vcap_control *vctrl,
 					  struct net_device *dev,
-					  struct flow_cls_offload *fco)
+					  struct flow_cls_offload *fco,
+					  bool ingress)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(fco);
 	struct flow_action_entry *actent, *last_actent = NULL;
@@ -120,7 +121,8 @@ static int lan966x_tc_flower_action_check(struct vcap_control *vctrl,
 					   "Invalid goto chain");
 			return -EINVAL;
 		}
-	} else if (!vcap_is_last_chain(vctrl, fco->common.chain_index)) {
+	} else if (!vcap_is_last_chain(vctrl, fco->common.chain_index,
+				       ingress)) {
 		NL_SET_ERR_MSG_MOD(fco->common.extack,
 				   "Last action must be 'goto'");
 		return -EINVAL;
@@ -139,7 +141,8 @@ static int lan966x_tc_flower_action_check(struct vcap_control *vctrl,
 
 static int lan966x_tc_flower_add(struct lan966x_port *port,
 				 struct flow_cls_offload *f,
-				 struct vcap_admin *admin)
+				 struct vcap_admin *admin,
+				 bool ingress)
 {
 	struct flow_action_entry *act;
 	u16 l3_proto = ETH_P_ALL;
@@ -148,7 +151,7 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
 	int err, idx;
 
 	err = lan966x_tc_flower_action_check(port->lan966x->vcap_ctrl,
-					     port->dev, f);
+					     port->dev, f, ingress);
 	if (err)
 		return err;
 
@@ -232,7 +235,8 @@ static int lan966x_tc_flower_del(struct lan966x_port *port,
 }
 
 int lan966x_tc_flower(struct lan966x_port *port,
-		      struct flow_cls_offload *f)
+		      struct flow_cls_offload *f,
+		      bool ingress)
 {
 	struct vcap_admin *admin;
 
@@ -245,7 +249,7 @@ int lan966x_tc_flower(struct lan966x_port *port,
 
 	switch (f->command) {
 	case FLOW_CLS_REPLACE:
-		return lan966x_tc_flower_add(port, f, admin);
+		return lan966x_tc_flower_add(port, f, admin, ingress);
 	case FLOW_CLS_DESTROY:
 		return lan966x_tc_flower_del(port, f, admin);
 	default:
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
index 76a9fb113f50..72fbbf49a4a7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -23,6 +23,7 @@ static struct lan966x_vcap_inst {
 	int first_cid; /* first chain id in this vcap */
 	int last_cid; /* last chain id in this vcap */
 	int count; /* number of available addresses */
+	bool ingress; /* is vcap in the ingress path */
 } lan966x_vcap_inst_cfg[] = {
 	{
 		.vtype = VCAP_TYPE_IS2, /* IS2-0 */
@@ -31,6 +32,7 @@ static struct lan966x_vcap_inst {
 		.first_cid = LAN966X_VCAP_CID_IS2_L0,
 		.last_cid = LAN966X_VCAP_CID_IS2_MAX,
 		.count = 256,
+		.ingress = true,
 	},
 };
 
@@ -431,6 +433,7 @@ lan966x_vcap_admin_alloc(struct lan966x *lan966x, struct vcap_control *ctrl,
 
 	admin->vtype = cfg->vtype;
 	admin->vinst = 0;
+	admin->ingress = cfg->ingress;
 	admin->w32be = true;
 	admin->tgt_inst = cfg->tgt_inst;
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index f9922b35ee33..96f82612cc4a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -618,7 +618,8 @@ static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
 
 static int sparx5_tc_flower_action_check(struct vcap_control *vctrl,
 					 struct net_device *ndev,
-					 struct flow_cls_offload *fco)
+					 struct flow_cls_offload *fco,
+					 bool ingress)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(fco);
 	struct flow_action_entry *actent, *last_actent = NULL;
@@ -655,7 +656,8 @@ static int sparx5_tc_flower_action_check(struct vcap_control *vctrl,
 					   "Invalid goto chain");
 			return -EINVAL;
 		}
-	} else if (!vcap_is_last_chain(vctrl, fco->common.chain_index)) {
+	} else if (!vcap_is_last_chain(vctrl, fco->common.chain_index,
+				       ingress)) {
 		NL_SET_ERR_MSG_MOD(fco->common.extack,
 				   "Last action must be 'goto'");
 		return -EINVAL;
@@ -970,7 +972,8 @@ static int sparx5_tc_add_rule_link(struct vcap_control *vctrl,
 
 static int sparx5_tc_flower_replace(struct net_device *ndev,
 				    struct flow_cls_offload *fco,
-				    struct vcap_admin *admin)
+				    struct vcap_admin *admin,
+				    bool ingress)
 {
 	struct sparx5_port *port = netdev_priv(ndev);
 	struct sparx5_multiple_rules multi = {};
@@ -983,7 +986,7 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 
 	vctrl = port->sparx5->vcap_ctrl;
 
-	err = sparx5_tc_flower_action_check(vctrl, ndev, fco);
+	err = sparx5_tc_flower_action_check(vctrl, ndev, fco, ingress);
 	if (err)
 		return err;
 
@@ -1141,7 +1144,7 @@ int sparx5_tc_flower(struct net_device *ndev, struct flow_cls_offload *fco,
 
 	switch (fco->command) {
 	case FLOW_CLS_REPLACE:
-		return sparx5_tc_flower_replace(ndev, fco, admin);
+		return sparx5_tc_flower_replace(ndev, fco, admin, ingress);
 	case FLOW_CLS_DESTROY:
 		return sparx5_tc_flower_destroy(ndev, fco, admin);
 	case FLOW_CLS_STATS:
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index 05e365d67e5a..ccb993bbd614 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -55,6 +55,7 @@ static struct sparx5_vcap_inst {
 	int map_id; /* id in the super vcap block mapping (if applicable) */
 	int blockno; /* starting block in super vcap (if applicable) */
 	int blocks; /* number of blocks in super vcap (if applicable) */
+	bool ingress; /* is vcap in the ingress path */
 } sparx5_vcap_inst_cfg[] = {
 	{
 		.vtype = VCAP_TYPE_IS0, /* CLM-0 */
@@ -66,6 +67,7 @@ static struct sparx5_vcap_inst {
 		.last_cid = SPARX5_VCAP_CID_IS0_L2 - 1,
 		.blockno = 8, /* Maps block 8-9 */
 		.blocks = 2,
+		.ingress = true,
 	},
 	{
 		.vtype = VCAP_TYPE_IS0, /* CLM-1 */
@@ -77,6 +79,7 @@ static struct sparx5_vcap_inst {
 		.last_cid = SPARX5_VCAP_CID_IS0_L4 - 1,
 		.blockno = 6, /* Maps block 6-7 */
 		.blocks = 2,
+		.ingress = true,
 	},
 	{
 		.vtype = VCAP_TYPE_IS0, /* CLM-2 */
@@ -88,6 +91,7 @@ static struct sparx5_vcap_inst {
 		.last_cid = SPARX5_VCAP_CID_IS0_MAX,
 		.blockno = 4, /* Maps block 4-5 */
 		.blocks = 2,
+		.ingress = true,
 	},
 	{
 		.vtype = VCAP_TYPE_IS2, /* IS2-0 */
@@ -99,6 +103,7 @@ static struct sparx5_vcap_inst {
 		.last_cid = SPARX5_VCAP_CID_IS2_L2 - 1,
 		.blockno = 0, /* Maps block 0-1 */
 		.blocks = 2,
+		.ingress = true,
 	},
 	{
 		.vtype = VCAP_TYPE_IS2, /* IS2-1 */
@@ -110,6 +115,7 @@ static struct sparx5_vcap_inst {
 		.last_cid = SPARX5_VCAP_CID_IS2_MAX,
 		.blockno = 2, /* Maps block 2-3 */
 		.blocks = 2,
+		.ingress = true,
 	},
 	{
 		.vtype = VCAP_TYPE_ES2,
@@ -118,6 +124,7 @@ static struct sparx5_vcap_inst {
 		.first_cid = SPARX5_VCAP_CID_ES2_L0,
 		.last_cid = SPARX5_VCAP_CID_ES2_MAX,
 		.count = 12288, /* Addresses according to datasheet */
+		.ingress = false,
 	},
 };
 
@@ -1413,6 +1420,7 @@ sparx5_vcap_admin_alloc(struct sparx5 *sparx5, struct vcap_control *ctrl,
 	mutex_init(&admin->lock);
 	admin->vtype = cfg->vtype;
 	admin->vinst = cfg->vinst;
+	admin->ingress = cfg->ingress;
 	admin->lookups = cfg->lookups;
 	admin->lookups_per_instance = cfg->lookups_per_instance;
 	admin->first_cid = cfg->first_cid;
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 2402126d87c2..660d7cd92fcc 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1601,15 +1601,17 @@ struct vcap_admin *vcap_find_admin(struct vcap_control *vctrl, int cid)
 }
 EXPORT_SYMBOL_GPL(vcap_find_admin);
 
-/* Is this the last admin instance ordered by chain id */
+/* Is this the last admin instance ordered by chain id and direction */
 static bool vcap_admin_is_last(struct vcap_control *vctrl,
-			       struct vcap_admin *admin)
+			       struct vcap_admin *admin,
+			       bool ingress)
 {
 	struct vcap_admin *iter, *last = NULL;
 	int max_cid = 0;
 
 	list_for_each_entry(iter, &vctrl->list, list) {
-		if (iter->first_cid > max_cid) {
+		if (iter->first_cid > max_cid &&
+		    iter->ingress == ingress) {
 			last = iter;
 			max_cid = iter->first_cid;
 		}
@@ -3177,7 +3179,7 @@ int vcap_enable_lookups(struct vcap_control *vctrl, struct net_device *ndev,
 EXPORT_SYMBOL_GPL(vcap_enable_lookups);
 
 /* Is this chain id the last lookup of all VCAPs */
-bool vcap_is_last_chain(struct vcap_control *vctrl, int cid)
+bool vcap_is_last_chain(struct vcap_control *vctrl, int cid, bool ingress)
 {
 	struct vcap_admin *admin;
 	int lookup;
@@ -3189,7 +3191,7 @@ bool vcap_is_last_chain(struct vcap_control *vctrl, int cid)
 	if (!admin)
 		return false;
 
-	if (!vcap_admin_is_last(vctrl, admin))
+	if (!vcap_admin_is_last(vctrl, admin, ingress))
 		return false;
 
 	/* This must be the last lookup in this VCAP type */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.h b/drivers/net/ethernet/microchip/vcap/vcap_api.h
index 40491116b0a9..62db270f65af 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.h
@@ -176,6 +176,7 @@ struct vcap_admin {
 	int first_valid_addr; /* bottom of address range to be used */
 	int last_used_addr;  /* address of lowest added rule */
 	bool w32be; /* vcap uses "32bit-word big-endian" encoding */
+	bool ingress; /* chain traffic direction */
 	struct vcap_cache_data cache; /* encoded rule data */
 };
 
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 69ea230ba8a1..de29540fd190 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -222,7 +222,7 @@ int vcap_chain_offset(struct vcap_control *vctrl, int from_cid, int to_cid);
 /* Is the next chain id in the following lookup, possible in another VCAP */
 bool vcap_is_next_lookup(struct vcap_control *vctrl, int cur_cid, int next_cid);
 /* Is this chain id the last lookup of all VCAPs */
-bool vcap_is_last_chain(struct vcap_control *vctrl, int cid);
+bool vcap_is_last_chain(struct vcap_control *vctrl, int cid, bool ingress);
 /* Provide all rules via a callback interface */
 int vcap_rule_iter(struct vcap_control *vctrl,
 		   int (*callback)(void *, struct vcap_rule *), void *arg);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index 08b18c9360f2..c2c3397c5898 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -280,6 +280,7 @@ static void vcap_show_admin_info(struct vcap_control *vctrl,
 	out->prf(out->dst, "version: %d\n", vcap->version);
 	out->prf(out->dst, "vtype: %d\n", admin->vtype);
 	out->prf(out->dst, "vinst: %d\n", admin->vinst);
+	out->prf(out->dst, "ingress: %d\n", admin->ingress);
 	out->prf(out->dst, "first_cid: %d\n", admin->first_cid);
 	out->prf(out->dst, "last_cid: %d\n", admin->last_cid);
 	out->prf(out->dst, "lookups: %d\n", admin->lookups);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
index cbf7e0f110b8..b9c1c9d5eee8 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
@@ -389,6 +389,7 @@ static const char * const test_admin_info_expect[] = {
 	"version: 1\n",
 	"vtype: 2\n",
 	"vinst: 0\n",
+	"ingress: 1\n",
 	"first_cid: 10000\n",
 	"last_cid: 19999\n",
 	"lookups: 4\n",
@@ -407,6 +408,7 @@ static void vcap_api_show_admin_test(struct kunit *test)
 		.last_valid_addr = 3071,
 		.first_valid_addr = 0,
 		.last_used_addr = 794,
+		.ingress = true,
 	};
 	struct vcap_output_print out = {
 		.prf = (void *)test_prf,
@@ -435,6 +437,7 @@ static const char * const test_admin_expect[] = {
 	"version: 1\n",
 	"vtype: 2\n",
 	"vinst: 0\n",
+	"ingress: 1\n",
 	"first_cid: 8000000\n",
 	"last_cid: 8199999\n",
 	"lookups: 4\n",
@@ -496,6 +499,7 @@ static void vcap_api_show_admin_rule_test(struct kunit *test)
 		.last_valid_addr = 3071,
 		.first_valid_addr = 0,
 		.last_used_addr = 794,
+		.ingress = true,
 		.cache = {
 			.keystream = keydata,
 			.maskstream = mskdata,
-- 
2.39.1

