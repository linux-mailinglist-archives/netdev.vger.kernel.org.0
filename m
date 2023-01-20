Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BC5675046
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjATJJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjATJJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:09:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12D68C92E;
        Fri, 20 Jan 2023 01:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674205752; x=1705741752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8lCPPz7hDN1kRShpGAVgRQOxdgiEW3gmijidfBXGoIY=;
  b=YgyBZ0wic7kVTzWO01OHn3Z31TqJqw5NOSEKwSOHPhzJVJvQBndDYpN6
   16MsU8N3VbbeE9r4Yn/Xw3/vrLUOjb7RM7PzE7S5Fo/DUWm/JxQ29htMV
   07s2jFHdpxaGsWQ/piPl+zQmsnSUOGVa0jiMN+i3QXkG2BKB9ZfhxaCNg
   N6BFcLn+wIVxjwErsqD2t31cCpVVxEdcHUFuR+D7oOWS0S7jqP1cpMrxl
   o/IJHg0bOGpd+xMfTsTm68r4sTu/kWXTETil/3uEOlN/K9jEU6rl0Kwsl
   MHe8iEF8YDSgTUqiM33U6nSN/vUwH+DBUrJDO/zrFj8OvSkRGhvnPSJNz
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="193122601"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 02:09:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 02:09:06 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 02:09:02 -0700
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
Subject: [PATCH net-next 7/8] net: microchip: sparx5: Add support for IS0 VCAP ethernet protocol types
Date:   Fri, 20 Jan 2023 10:08:30 +0100
Message-ID: <20230120090831.20032-8-steen.hegelund@microchip.com>
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

This allows the IS0 VCAP to have its own list of supported ethernet
protocol types matching what is supported by the VCAPs port lookup
classification.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 24 +---------
 .../microchip/sparx5/sparx5_vcap_impl.c       | 46 ++++++++++++++++---
 .../microchip/sparx5/sparx5_vcap_impl.h       |  3 ++
 3 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 3875b5bc984f..9e613dc5b868 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -36,16 +36,6 @@ struct sparx5_tc_flower_parse_usage {
 	unsigned int used_keys;
 };
 
-/* These protocols have dedicated keysets in IS2 and a TC dissector
- * ETH_P_ARP does not have a TC dissector
- */
-static u16 sparx5_tc_known_etypes[] = {
-	ETH_P_ALL,
-	ETH_P_ARP,
-	ETH_P_IP,
-	ETH_P_IPV6,
-};
-
 enum sparx5_is2_arp_opcode {
 	SPX5_IS2_ARP_REQUEST,
 	SPX5_IS2_ARP_REPLY,
@@ -59,18 +49,6 @@ enum tc_arp_opcode {
 	TC_ARP_OP_REPLY,
 };
 
-static bool sparx5_tc_is_known_etype(u16 etype)
-{
-	int idx;
-
-	/* For now this only knows about IS2 traffic classification */
-	for (idx = 0; idx < ARRAY_SIZE(sparx5_tc_known_etypes); ++idx)
-		if (sparx5_tc_known_etypes[idx] == etype)
-			return true;
-
-	return false;
-}
-
 static int sparx5_tc_flower_handler_ethaddr_usage(struct sparx5_tc_flower_parse_usage *st)
 {
 	enum vcap_key_field smac_key = VCAP_KF_L2_SMAC;
@@ -273,7 +251,7 @@ sparx5_tc_flower_handler_basic_usage(struct sparx5_tc_flower_parse_usage *st)
 
 	if (mt.mask->n_proto) {
 		st->l3_proto = be16_to_cpu(mt.key->n_proto);
-		if (!sparx5_tc_is_known_etype(st->l3_proto)) {
+		if (!sparx5_vcap_is_known_etype(st->admin, st->l3_proto)) {
 			err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_ETYPE,
 						    st->l3_proto, ~0);
 			if (err)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index cceb4301103b..6165518ed0f2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -106,6 +106,21 @@ static struct sparx5_vcap_inst {
 	},
 };
 
+/* These protocols have dedicated keysets in IS0 and a TC dissector */
+static u16 sparx5_vcap_is0_known_etypes[] = {
+	ETH_P_ALL,
+	ETH_P_IP,
+	ETH_P_IPV6,
+};
+
+/* These protocols have dedicated keysets in IS2 and a TC dissector */
+static u16 sparx5_vcap_is2_known_etypes[] = {
+	ETH_P_ALL,
+	ETH_P_ARP,
+	ETH_P_IP,
+	ETH_P_IPV6,
+};
+
 static void sparx5_vcap_type_err(struct sparx5 *sparx5,
 				 struct vcap_admin *admin,
 				 const char *fname)
@@ -277,10 +292,6 @@ static int sparx5_vcap_is0_get_port_keysets(struct net_device *ndev,
 
 	value = spx5_rd(sparx5, ANA_CL_ADV_CL_CFG(portno, lookup));
 
-	/* Check if the port keyset selection is enabled */
-	if (!ANA_CL_ADV_CL_CFG_LOOKUP_ENA_GET(value))
-		return -ENOENT;
-
 	/* Collect all keysets for the port in a list */
 	if (l3_proto == ETH_P_ALL)
 		sparx5_vcap_is0_get_port_etype_keysets(keysetlist, value);
@@ -333,10 +344,7 @@ static int sparx5_vcap_is2_get_port_keysets(struct net_device *ndev,
 	int portno = port->portno;
 	u32 value;
 
-	/* Check if the port keyset selection is enabled */
 	value = spx5_rd(sparx5, ANA_ACL_VCAP_S2_KEY_SEL(portno, lookup));
-	if (!ANA_ACL_VCAP_S2_KEY_SEL_KEY_SEL_ENA_GET(value))
-		return -ENOENT;
 
 	/* Collect all keysets for the port in a list */
 	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_ARP) {
@@ -456,6 +464,30 @@ int sparx5_vcap_get_port_keyset(struct net_device *ndev,
 	return err;
 }
 
+/* Check if the ethertype is supported by the vcap port classification */
+bool sparx5_vcap_is_known_etype(struct vcap_admin *admin, u16 etype)
+{
+	const u16 *known_etypes;
+	int size, idx;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		known_etypes = sparx5_vcap_is0_known_etypes;
+		size = ARRAY_SIZE(sparx5_vcap_is0_known_etypes);
+		break;
+	case VCAP_TYPE_IS2:
+		known_etypes = sparx5_vcap_is2_known_etypes;
+		size = ARRAY_SIZE(sparx5_vcap_is2_known_etypes);
+		break;
+	default:
+		break;
+	}
+	for (idx = 0; idx < size; ++idx)
+		if (known_etypes[idx] == etype)
+			return true;
+	return false;
+}
+
 /* API callback used for validating a field keyset (check the port keysets) */
 static enum vcap_keyfield_set
 sparx5_vcap_validate_keyset(struct net_device *ndev,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
index 80c99b0d50e7..aabdf4355103 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
@@ -136,4 +136,7 @@ int sparx5_vcap_get_port_keyset(struct net_device *ndev,
 				u16 l3_proto,
 				struct vcap_keyset_list *kslist);
 
+/* Check if the ethertype is supported by the vcap port classification */
+bool sparx5_vcap_is_known_etype(struct vcap_admin *admin, u16 etype);
+
 #endif /* __SPARX5_VCAP_IMPL_H__ */
-- 
2.39.1

