Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF9A69612A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbjBNKmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbjBNKlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:41:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E58425E01;
        Tue, 14 Feb 2023 02:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676371289; x=1707907289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4V20nbRZaSCIiFZ97/HysSTVBnt4EaD5aXkHCx+QQqM=;
  b=Z9wJKgPY4v62Hm/47YNmNhcyHBnnsqY3MyxuDBLp2xl/70/cQjV5TBd6
   HzO84b/158Hc59Wl8BofMh5157O6fsJXnK6U6Xid2Q/6IvwepQ7jiNpcX
   uE4deL6z0vv9MpdLSDAM76OVQ8dm0H7RqyGJyEgDf1uOikrpsqxRfmoma
   RAGBERXc25vrpmNABcJkY9aJB0eDhZ7RxWlZu589v4etdU3j+TWTifwyw
   /jhxHU75VtG2J9iQxNBHAqPebi1QabQzUls4rEOBf5bPrJZcAci6XY31j
   BYC/6WbTgb9gFOcH4NXLV79OqmWJuYrKCiht2W3XNL8zxfCg3mmje5f5h
   w==;
X-IronPort-AV: E=Sophos;i="5.97,296,1669100400"; 
   d="scan'208";a="196825319"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Feb 2023 03:41:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 03:41:26 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 03:41:23 -0700
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
Subject: [PATCH net-next v2 08/10] net: microchip: sparx5: Add ES0 VCAP keyset configuration for Sparx5
Date:   Tue, 14 Feb 2023 11:40:47 +0100
Message-ID: <20230214104049.1553059-9-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214104049.1553059-1-steen.hegelund@microchip.com>
References: <20230214104049.1553059-1-steen.hegelund@microchip.com>
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

This adds the ES0 VCAP port keyset configuration for Sparx5.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.c   |   1 +
 .../microchip/sparx5/sparx5_tc_flower.c       |  19 +-
 .../microchip/sparx5/sparx5_vcap_debugfs.c    |  41 +++
 .../microchip/sparx5/sparx5_vcap_impl.c       | 269 ++++++++++++++++++
 .../microchip/sparx5/sparx5_vcap_impl.h       |  13 +
 5 files changed, 341 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index c213a4414e65..42b77ba9b572 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -199,6 +199,7 @@ static const struct sparx5_main_io_resource sparx5_main_iomap[] =  {
 	{ TARGET_QFWD,               0x110b0000, 2 }, /* 0x6110b0000 */
 	{ TARGET_XQS,                0x110c0000, 2 }, /* 0x6110c0000 */
 	{ TARGET_VCAP_ES2,           0x110d0000, 2 }, /* 0x6110d0000 */
+	{ TARGET_VCAP_ES0,           0x110e0000, 2 }, /* 0x6110e0000 */
 	{ TARGET_CLKGEN,             0x11100000, 2 }, /* 0x611100000 */
 	{ TARGET_ANA_AC_POL,         0x11200000, 2 }, /* 0x611200000 */
 	{ TARGET_QRES,               0x11280000, 2 }, /* 0x611280000 */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 82d5138f149e..3e29180b41a6 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -290,14 +290,29 @@ static int sparx5_tc_add_rule_counter(struct vcap_admin *admin,
 {
 	int err;
 
-	if (admin->vtype == VCAP_TYPE_IS2 || admin->vtype == VCAP_TYPE_ES2) {
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		break;
+	case VCAP_TYPE_ES0:
+		err = vcap_rule_mod_action_u32(vrule, VCAP_AF_ESDX,
+					       vrule->id);
+		if (err)
+			return err;
+		vcap_rule_set_counter_id(vrule, vrule->id);
+		break;
+	case VCAP_TYPE_IS2:
+	case VCAP_TYPE_ES2:
 		err = vcap_rule_mod_action_u32(vrule, VCAP_AF_CNT_ID,
 					       vrule->id);
 		if (err)
 			return err;
 		vcap_rule_set_counter_id(vrule, vrule->id);
+		break;
+	default:
+		pr_err("%s:%d: vcap type: %d not supported\n",
+		       __func__, __LINE__, admin->vtype);
+		break;
 	}
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
index f3b2e58af212..07b472c84a47 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
@@ -284,6 +284,44 @@ static void sparx5_vcap_is2_port_stickies(struct sparx5 *sparx5,
 	out->prf(out->dst, "\n");
 }
 
+static void sparx5_vcap_es0_port_keys(struct sparx5 *sparx5,
+				      struct vcap_admin *admin,
+				      struct sparx5_port *port,
+				      struct vcap_output_print *out)
+{
+	u32 value;
+
+	out->prf(out->dst, "  port[%02d] (%s): ", port->portno,
+		 netdev_name(port->ndev));
+	out->prf(out->dst, "\n    Lookup 0: ");
+
+	/* Get lookup state */
+	value = spx5_rd(sparx5, REW_ES0_CTRL);
+	out->prf(out->dst, "\n      state: ");
+	if (REW_ES0_CTRL_ES0_LU_ENA_GET(value))
+		out->prf(out->dst, "on");
+	else
+		out->prf(out->dst, "off");
+
+	out->prf(out->dst, "\n      keyset: ");
+	value = spx5_rd(sparx5, REW_RTAG_ETAG_CTRL(port->portno));
+	switch (REW_RTAG_ETAG_CTRL_ES0_ISDX_KEY_ENA_GET(value)) {
+	case VCAP_ES0_PS_NORMAL_SELECTION:
+		out->prf(out->dst, "normal");
+		break;
+	case VCAP_ES0_PS_FORCE_ISDX_LOOKUPS:
+		out->prf(out->dst, "isdx");
+		break;
+	case VCAP_ES0_PS_FORCE_VID_LOOKUPS:
+		out->prf(out->dst, "vid");
+		break;
+	case VCAP_ES0_PS_RESERVED:
+		out->prf(out->dst, "reserved");
+		break;
+	}
+	out->prf(out->dst, "\n");
+}
+
 static void sparx5_vcap_es2_port_keys(struct sparx5 *sparx5,
 				      struct vcap_admin *admin,
 				      struct sparx5_port *port,
@@ -418,6 +456,9 @@ int sparx5_port_info(struct net_device *ndev,
 		sparx5_vcap_is2_port_keys(sparx5, admin, port, out);
 		sparx5_vcap_is2_port_stickies(sparx5, admin, out);
 		break;
+	case VCAP_TYPE_ES0:
+		sparx5_vcap_es0_port_keys(sparx5, admin, port, out);
+		break;
 	case VCAP_TYPE_ES2:
 		sparx5_vcap_es2_port_keys(sparx5, admin, port, out);
 		sparx5_vcap_es2_port_stickies(sparx5, admin, out);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index cadc4926d550..72b563590873 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -37,6 +37,11 @@
 	ANA_CL_ADV_CL_CFG_MPLS_MC_CLM_KEY_SEL_SET(_mpls_mc) | \
 	ANA_CL_ADV_CL_CFG_MLBS_CLM_KEY_SEL_SET(_mlbs))
 
+#define SPARX5_ES0_LOOKUPS 1
+#define VCAP_ES0_KEYSEL(_key) (REW_RTAG_ETAG_CTRL_ES0_ISDX_KEY_ENA_SET(_key))
+#define SPARX5_STAT_ESDX_GRN_PKTS  0x300
+#define SPARX5_STAT_ESDX_YEL_PKTS  0x301
+
 #define SPARX5_ES2_LOOKUPS 2
 #define VCAP_ES2_KEYSEL(_ena, _arp, _ipv4, _ipv6) \
 	(EACL_VCAP_ES2_KEY_SEL_KEY_ENA_SET(_ena) | \
@@ -117,6 +122,15 @@ static struct sparx5_vcap_inst {
 		.blocks = 2,
 		.ingress = true,
 	},
+	{
+		.vtype = VCAP_TYPE_ES0,
+		.lookups = SPARX5_ES0_LOOKUPS,
+		.lookups_per_instance = SPARX5_ES0_LOOKUPS,
+		.first_cid = SPARX5_VCAP_CID_ES0_L0,
+		.last_cid = SPARX5_VCAP_CID_ES0_MAX,
+		.count = 4096, /* Addresses according to datasheet */
+		.ingress = false,
+	},
 	{
 		.vtype = VCAP_TYPE_ES2,
 		.lookups = SPARX5_ES2_LOOKUPS,
@@ -169,6 +183,16 @@ static void sparx5_vcap_wait_super_update(struct sparx5 *sparx5)
 			  false, sparx5, VCAP_SUPER_CTRL);
 }
 
+/* Await the ES0 VCAP completion of the current operation */
+static void sparx5_vcap_wait_es0_update(struct sparx5 *sparx5)
+{
+	u32 value;
+
+	read_poll_timeout(spx5_rd, value,
+			  !VCAP_ES0_CTRL_UPDATE_SHOT_GET(value), 500, 10000,
+			  false, sparx5, VCAP_ES0_CTRL);
+}
+
 /* Await the ES2 VCAP completion of the current operation */
 static void sparx5_vcap_wait_es2_update(struct sparx5 *sparx5)
 {
@@ -202,6 +226,20 @@ static void _sparx5_vcap_range_init(struct sparx5 *sparx5,
 			sparx5, VCAP_SUPER_CTRL);
 		sparx5_vcap_wait_super_update(sparx5);
 		break;
+	case VCAP_TYPE_ES0:
+		spx5_wr(VCAP_ES0_CFG_MV_NUM_POS_SET(0) |
+				VCAP_ES0_CFG_MV_SIZE_SET(size),
+			sparx5, VCAP_ES0_CFG);
+		spx5_wr(VCAP_ES0_CTRL_UPDATE_CMD_SET(VCAP_CMD_INITIALIZE) |
+				VCAP_ES0_CTRL_UPDATE_ENTRY_DIS_SET(0) |
+				VCAP_ES0_CTRL_UPDATE_ACTION_DIS_SET(0) |
+				VCAP_ES0_CTRL_UPDATE_CNT_DIS_SET(0) |
+				VCAP_ES0_CTRL_UPDATE_ADDR_SET(addr) |
+				VCAP_ES0_CTRL_CLEAR_CACHE_SET(true) |
+				VCAP_ES0_CTRL_UPDATE_SHOT_SET(true),
+			sparx5, VCAP_ES0_CTRL);
+		sparx5_vcap_wait_es0_update(sparx5);
+		break;
 	case VCAP_TYPE_ES2:
 		spx5_wr(VCAP_ES2_CFG_MV_NUM_POS_SET(0) |
 			VCAP_ES2_CFG_MV_SIZE_SET(size),
@@ -563,6 +601,30 @@ sparx5_vcap_es2_get_port_ipv4_keysets(struct vcap_keyset_list *keysetlist,
 	}
 }
 
+/* Return the list of keysets for the vcap port configuration */
+static int sparx5_vcap_es0_get_port_keysets(struct net_device *ndev,
+					    struct vcap_keyset_list *keysetlist,
+					    u16 l3_proto)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	u32 value;
+
+	value = spx5_rd(sparx5, REW_RTAG_ETAG_CTRL(portno));
+
+	/* Collect all keysets for the port in a list */
+	switch (REW_RTAG_ETAG_CTRL_ES0_ISDX_KEY_ENA_GET(value)) {
+	case VCAP_ES0_PS_NORMAL_SELECTION:
+	case VCAP_ES0_PS_FORCE_ISDX_LOOKUPS:
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_ISDX);
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
 /* Return the list of keysets for the vcap port configuration */
 static int sparx5_vcap_es2_get_port_keysets(struct net_device *ndev,
 					    int lookup,
@@ -647,6 +709,9 @@ int sparx5_vcap_get_port_keyset(struct net_device *ndev,
 		err = sparx5_vcap_is2_get_port_keysets(ndev, lookup, kslist,
 						       l3_proto);
 		break;
+	case VCAP_TYPE_ES0:
+		err = sparx5_vcap_es0_get_port_keysets(ndev, kslist, l3_proto);
+		break;
 	case VCAP_TYPE_ES2:
 		lookup = sparx5_vcap_es2_cid_to_lookup(cid);
 		err = sparx5_vcap_es2_get_port_keysets(ndev, lookup, kslist,
@@ -719,6 +784,9 @@ sparx5_vcap_validate_keyset(struct net_device *ndev,
 		sparx5_vcap_is2_get_port_keysets(ndev, lookup, &keysetlist,
 						 l3_proto);
 		break;
+	case VCAP_TYPE_ES0:
+		sparx5_vcap_es0_get_port_keysets(ndev, &keysetlist, l3_proto);
+		break;
 	case VCAP_TYPE_ES2:
 		lookup = sparx5_vcap_es2_cid_to_lookup(rule->vcap_chain_id);
 		sparx5_vcap_es2_get_port_keysets(ndev, lookup, &keysetlist,
@@ -775,6 +843,15 @@ static void sparx5_vcap_ingress_add_default_fields(struct net_device *ndev,
 				      VCAP_BIT_0);
 }
 
+static void sparx5_vcap_es0_add_default_fields(struct net_device *ndev,
+					       struct vcap_admin *admin,
+					       struct vcap_rule *rule)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+
+	vcap_rule_add_key_u32(rule, VCAP_KF_IF_EGR_PORT_NO, port->portno, ~0);
+}
+
 static void sparx5_vcap_es2_add_default_fields(struct net_device *ndev,
 					       struct vcap_admin *admin,
 					       struct vcap_rule *rule)
@@ -811,6 +888,9 @@ static void sparx5_vcap_add_default_fields(struct net_device *ndev,
 	case VCAP_TYPE_IS2:
 		sparx5_vcap_ingress_add_default_fields(ndev, admin, rule);
 		break;
+	case VCAP_TYPE_ES0:
+		sparx5_vcap_es0_add_default_fields(ndev, admin, rule);
+		break;
 	case VCAP_TYPE_ES2:
 		sparx5_vcap_es2_add_default_fields(ndev, admin, rule);
 		break;
@@ -919,6 +999,59 @@ static void sparx5_vcap_is2_cache_write(struct sparx5 *sparx5,
 	}
 }
 
+/* Use ESDX counters located in the XQS */
+static void sparx5_es0_write_esdx_counter(struct sparx5 *sparx5,
+					  struct vcap_admin *admin, u32 id)
+{
+	mutex_lock(&sparx5->queue_stats_lock);
+	spx5_wr(XQS_STAT_CFG_STAT_VIEW_SET(id), sparx5, XQS_STAT_CFG);
+	spx5_wr(admin->cache.counter, sparx5,
+		XQS_CNT(SPARX5_STAT_ESDX_GRN_PKTS));
+	spx5_wr(0, sparx5, XQS_CNT(SPARX5_STAT_ESDX_YEL_PKTS));
+	mutex_unlock(&sparx5->queue_stats_lock);
+}
+
+static void sparx5_vcap_es0_cache_write(struct sparx5 *sparx5,
+					struct vcap_admin *admin,
+					enum vcap_selection sel,
+					u32 start,
+					u32 count)
+{
+	u32 *keystr, *mskstr, *actstr;
+	int idx;
+
+	keystr = &admin->cache.keystream[start];
+	mskstr = &admin->cache.maskstream[start];
+	actstr = &admin->cache.actionstream[start];
+
+	switch (sel) {
+	case VCAP_SEL_ENTRY:
+		for (idx = 0; idx < count; ++idx) {
+			/* Avoid 'match-off' by setting value & mask */
+			spx5_wr(keystr[idx] & mskstr[idx], sparx5,
+				VCAP_ES0_VCAP_ENTRY_DAT(idx));
+			spx5_wr(~mskstr[idx], sparx5,
+				VCAP_ES0_VCAP_MASK_DAT(idx));
+		}
+		break;
+	case VCAP_SEL_ACTION:
+		for (idx = 0; idx < count; ++idx)
+			spx5_wr(actstr[idx], sparx5,
+				VCAP_ES0_VCAP_ACTION_DAT(idx));
+		break;
+	case VCAP_SEL_ALL:
+		pr_err("%s:%d: cannot write all streams at once\n",
+		       __func__, __LINE__);
+		break;
+	default:
+		break;
+	}
+	if (sel & VCAP_SEL_COUNTER) {
+		spx5_wr(admin->cache.counter, sparx5, VCAP_ES0_VCAP_CNT_DAT(0));
+		sparx5_es0_write_esdx_counter(sparx5, admin, start);
+	}
+}
+
 static void sparx5_vcap_es2_cache_write(struct sparx5 *sparx5,
 					struct vcap_admin *admin,
 					enum vcap_selection sel,
@@ -978,6 +1111,9 @@ static void sparx5_vcap_cache_write(struct net_device *ndev,
 	case VCAP_TYPE_IS2:
 		sparx5_vcap_is2_cache_write(sparx5, admin, sel, start, count);
 		break;
+	case VCAP_TYPE_ES0:
+		sparx5_vcap_es0_cache_write(sparx5, admin, sel, start, count);
+		break;
 	case VCAP_TYPE_ES2:
 		sparx5_vcap_es2_cache_write(sparx5, admin, sel, start, count);
 		break;
@@ -1062,6 +1198,56 @@ static void sparx5_vcap_is2_cache_read(struct sparx5 *sparx5,
 	}
 }
 
+/* Use ESDX counters located in the XQS */
+static void sparx5_es0_read_esdx_counter(struct sparx5 *sparx5,
+					 struct vcap_admin *admin, u32 id)
+{
+	u32 counter;
+
+	mutex_lock(&sparx5->queue_stats_lock);
+	spx5_wr(XQS_STAT_CFG_STAT_VIEW_SET(id), sparx5, XQS_STAT_CFG);
+	counter = spx5_rd(sparx5, XQS_CNT(SPARX5_STAT_ESDX_GRN_PKTS)) +
+		spx5_rd(sparx5, XQS_CNT(SPARX5_STAT_ESDX_YEL_PKTS));
+	mutex_unlock(&sparx5->queue_stats_lock);
+	if (counter)
+		admin->cache.counter = counter;
+}
+
+static void sparx5_vcap_es0_cache_read(struct sparx5 *sparx5,
+				       struct vcap_admin *admin,
+				       enum vcap_selection sel,
+				       u32 start,
+				       u32 count)
+{
+	u32 *keystr, *mskstr, *actstr;
+	int idx;
+
+	keystr = &admin->cache.keystream[start];
+	mskstr = &admin->cache.maskstream[start];
+	actstr = &admin->cache.actionstream[start];
+
+	if (sel & VCAP_SEL_ENTRY) {
+		for (idx = 0; idx < count; ++idx) {
+			keystr[idx] =
+				spx5_rd(sparx5, VCAP_ES0_VCAP_ENTRY_DAT(idx));
+			mskstr[idx] =
+				~spx5_rd(sparx5, VCAP_ES0_VCAP_MASK_DAT(idx));
+		}
+	}
+
+	if (sel & VCAP_SEL_ACTION)
+		for (idx = 0; idx < count; ++idx)
+			actstr[idx] =
+				spx5_rd(sparx5, VCAP_ES0_VCAP_ACTION_DAT(idx));
+
+	if (sel & VCAP_SEL_COUNTER) {
+		admin->cache.counter =
+			spx5_rd(sparx5, VCAP_ES0_VCAP_CNT_DAT(0));
+		admin->cache.sticky = admin->cache.counter;
+		sparx5_es0_read_esdx_counter(sparx5, admin, start);
+	}
+}
+
 static void sparx5_vcap_es2_cache_read(struct sparx5 *sparx5,
 				       struct vcap_admin *admin,
 				       enum vcap_selection sel,
@@ -1115,6 +1301,9 @@ static void sparx5_vcap_cache_read(struct net_device *ndev,
 	case VCAP_TYPE_IS2:
 		sparx5_vcap_is2_cache_read(sparx5, admin, sel, start, count);
 		break;
+	case VCAP_TYPE_ES0:
+		sparx5_vcap_es0_cache_read(sparx5, admin, sel, start, count);
+		break;
 	case VCAP_TYPE_ES2:
 		sparx5_vcap_es2_cache_read(sparx5, admin, sel, start, count);
 		break;
@@ -1154,6 +1343,25 @@ static void sparx5_vcap_super_update(struct sparx5 *sparx5,
 	sparx5_vcap_wait_super_update(sparx5);
 }
 
+static void sparx5_vcap_es0_update(struct sparx5 *sparx5,
+				   enum vcap_command cmd,
+				   enum vcap_selection sel, u32 addr)
+{
+	bool clear = (cmd == VCAP_CMD_INITIALIZE);
+
+	spx5_wr(VCAP_ES0_CFG_MV_NUM_POS_SET(0) |
+		VCAP_ES0_CFG_MV_SIZE_SET(0), sparx5, VCAP_ES0_CFG);
+	spx5_wr(VCAP_ES0_CTRL_UPDATE_CMD_SET(cmd) |
+		VCAP_ES0_CTRL_UPDATE_ENTRY_DIS_SET((VCAP_SEL_ENTRY & sel) == 0) |
+		VCAP_ES0_CTRL_UPDATE_ACTION_DIS_SET((VCAP_SEL_ACTION & sel) == 0) |
+		VCAP_ES0_CTRL_UPDATE_CNT_DIS_SET((VCAP_SEL_COUNTER & sel) == 0) |
+		VCAP_ES0_CTRL_UPDATE_ADDR_SET(addr) |
+		VCAP_ES0_CTRL_CLEAR_CACHE_SET(clear) |
+		VCAP_ES0_CTRL_UPDATE_SHOT_SET(true),
+		sparx5, VCAP_ES0_CTRL);
+	sparx5_vcap_wait_es0_update(sparx5);
+}
+
 static void sparx5_vcap_es2_update(struct sparx5 *sparx5,
 				   enum vcap_command cmd,
 				   enum vcap_selection sel, u32 addr)
@@ -1186,6 +1394,9 @@ static void sparx5_vcap_update(struct net_device *ndev,
 	case VCAP_TYPE_IS2:
 		sparx5_vcap_super_update(sparx5, cmd, sel, addr);
 		break;
+	case VCAP_TYPE_ES0:
+		sparx5_vcap_es0_update(sparx5, cmd, sel, addr);
+		break;
 	case VCAP_TYPE_ES2:
 		sparx5_vcap_es2_update(sparx5, cmd, sel, addr);
 		break;
@@ -1215,6 +1426,26 @@ static void sparx5_vcap_super_move(struct sparx5 *sparx5,
 	sparx5_vcap_wait_super_update(sparx5);
 }
 
+static void sparx5_vcap_es0_move(struct sparx5 *sparx5,
+				 u32 addr,
+				 enum vcap_command cmd,
+				 u16 mv_num_pos,
+				 u16 mv_size)
+{
+	spx5_wr(VCAP_ES0_CFG_MV_NUM_POS_SET(mv_num_pos) |
+		VCAP_ES0_CFG_MV_SIZE_SET(mv_size),
+		sparx5, VCAP_ES0_CFG);
+	spx5_wr(VCAP_ES0_CTRL_UPDATE_CMD_SET(cmd) |
+		VCAP_ES0_CTRL_UPDATE_ENTRY_DIS_SET(0) |
+		VCAP_ES0_CTRL_UPDATE_ACTION_DIS_SET(0) |
+		VCAP_ES0_CTRL_UPDATE_CNT_DIS_SET(0) |
+		VCAP_ES0_CTRL_UPDATE_ADDR_SET(addr) |
+		VCAP_ES0_CTRL_CLEAR_CACHE_SET(false) |
+		VCAP_ES0_CTRL_UPDATE_SHOT_SET(true),
+		sparx5, VCAP_ES0_CTRL);
+	sparx5_vcap_wait_es0_update(sparx5);
+}
+
 static void sparx5_vcap_es2_move(struct sparx5 *sparx5,
 				 u32 addr,
 				 enum vcap_command cmd,
@@ -1259,6 +1490,9 @@ static void sparx5_vcap_move(struct net_device *ndev, struct vcap_admin *admin,
 	case VCAP_TYPE_IS2:
 		sparx5_vcap_super_move(sparx5, addr, cmd, mv_num_pos, mv_size);
 		break;
+	case VCAP_TYPE_ES0:
+		sparx5_vcap_es0_move(sparx5, addr, cmd, mv_num_pos, mv_size);
+		break;
 	case VCAP_TYPE_ES2:
 		sparx5_vcap_es2_move(sparx5, addr, cmd, mv_num_pos, mv_size);
 		break;
@@ -1333,6 +1567,22 @@ static void sparx5_vcap_is2_port_key_selection(struct sparx5 *sparx5,
 			 ANA_ACL_VCAP_S2_CFG(portno));
 }
 
+/* Enable ES0 lookups per port and set the keyset generation */
+static void sparx5_vcap_es0_port_key_selection(struct sparx5 *sparx5,
+					       struct vcap_admin *admin)
+{
+	int portno;
+	u32 keysel;
+
+	keysel = VCAP_ES0_KEYSEL(VCAP_ES0_PS_FORCE_ISDX_LOOKUPS);
+	for (portno = 0; portno < SPX5_PORTS; ++portno)
+		spx5_rmw(keysel, REW_RTAG_ETAG_CTRL_ES0_ISDX_KEY_ENA,
+			 sparx5, REW_RTAG_ETAG_CTRL(portno));
+
+	spx5_rmw(REW_ES0_CTRL_ES0_LU_ENA_SET(1), REW_ES0_CTRL_ES0_LU_ENA,
+		 sparx5, REW_ES0_CTRL);
+}
+
 /* Enable ES2 lookups per port and set the keyset generation */
 static void sparx5_vcap_es2_port_key_selection(struct sparx5 *sparx5,
 					       struct vcap_admin *admin)
@@ -1360,6 +1610,9 @@ static void sparx5_vcap_port_key_selection(struct sparx5 *sparx5,
 	case VCAP_TYPE_IS2:
 		sparx5_vcap_is2_port_key_selection(sparx5, admin);
 		break;
+	case VCAP_TYPE_ES0:
+		sparx5_vcap_es0_port_key_selection(sparx5, admin);
+		break;
 	case VCAP_TYPE_ES2:
 		sparx5_vcap_es2_port_key_selection(sparx5, admin);
 		break;
@@ -1391,6 +1644,10 @@ static void sparx5_vcap_port_key_deselection(struct sparx5 *sparx5,
 				 sparx5,
 				 ANA_ACL_VCAP_S2_CFG(portno));
 		break;
+	case VCAP_TYPE_ES0:
+		spx5_rmw(REW_ES0_CTRL_ES0_LU_ENA_SET(0),
+			 REW_ES0_CTRL_ES0_LU_ENA, sparx5, REW_ES0_CTRL);
+		break;
 	case VCAP_TYPE_ES2:
 		for (lookup = 0; lookup < admin->lookups; ++lookup)
 			for (portno = 0; portno < SPX5_PORTS; ++portno)
@@ -1477,6 +1734,18 @@ static void sparx5_vcap_block_alloc(struct sparx5 *sparx5,
 			cfg->blocks * SUPER_VCAP_BLK_SIZE;
 		admin->last_valid_addr = admin->last_used_addr - 1;
 		break;
+	case VCAP_TYPE_ES0:
+		admin->first_valid_addr = 0;
+		admin->last_used_addr = cfg->count;
+		admin->last_valid_addr = cfg->count - 1;
+		cores = spx5_rd(sparx5, VCAP_ES0_CORE_CNT);
+		for (idx = 0; idx < cores; ++idx) {
+			spx5_wr(VCAP_ES0_IDX_CORE_IDX_SET(idx), sparx5,
+				VCAP_ES0_IDX);
+			spx5_wr(VCAP_ES0_MAP_CORE_MAP_SET(1), sparx5,
+				VCAP_ES0_MAP);
+		}
+		break;
 	case VCAP_TYPE_ES2:
 		admin->first_valid_addr = 0;
 		admin->last_used_addr = cfg->count;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
index 46a08d5aff3d..4b0ad1aecec9 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
@@ -32,6 +32,9 @@
 #define SPARX5_VCAP_CID_IS2_MAX \
 	(VCAP_CID_INGRESS_STAGE2_L3 + VCAP_CID_LOOKUP_SIZE - 1) /* IS2 Max */
 
+#define SPARX5_VCAP_CID_ES0_L0 VCAP_CID_EGRESS_L0 /* ES0 lookup 0 */
+#define SPARX5_VCAP_CID_ES0_MAX (VCAP_CID_EGRESS_L1 - 1) /* ES0 Max */
+
 #define SPARX5_VCAP_CID_ES2_L0 VCAP_CID_EGRESS_STAGE2_L0 /* ES2 lookup 0 */
 #define SPARX5_VCAP_CID_ES2_L1 VCAP_CID_EGRESS_STAGE2_L1 /* ES2 lookup 1 */
 #define SPARX5_VCAP_CID_ES2_MAX \
@@ -134,6 +137,16 @@ enum vcap_is2_port_sel_arp {
 	VCAP_IS2_PS_ARP_ARP,
 };
 
+/* ES0 port keyset selection control */
+
+/* ES0 Egress port traffic type classification */
+enum vcap_es0_port_sel {
+	VCAP_ES0_PS_NORMAL_SELECTION,
+	VCAP_ES0_PS_FORCE_ISDX_LOOKUPS,
+	VCAP_ES0_PS_FORCE_VID_LOOKUPS,
+	VCAP_ES0_PS_RESERVED,
+};
+
 /* ES2 port keyset selection control */
 
 /* ES2 IPv4 traffic type keyset generation */
-- 
2.39.1

