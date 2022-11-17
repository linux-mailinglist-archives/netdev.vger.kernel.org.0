Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BF062E6FC
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbiKQVcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240741AbiKQVbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:31:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E745DB8B;
        Thu, 17 Nov 2022 13:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668720700; x=1700256700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5j6HmY0ad3ohq65uxfU6bIbeP7dbA6ysZGRS8MaCMeo=;
  b=iuBnHTnf9RB0A94dlw6Y1lqxWqfCfsGFFUrXRGj1AA6JpnVvMkdJlY6r
   nte3G0JaNtSwW9Lrxn2IxRzjLX5dYbwlrNNj6qdslnr7EOCj0lDngApTR
   /pxY0SVXfoDqkGtM+OqpOZ8HYHns+7wx64sC2goOEI0rpW1tv3pHdaA4X
   L4HzJHhqeJfOiZOZj2CZaVZj6OnSEecnpGzE0WIlKZsfWalbGj50CoquM
   pWhGSZ72JPupr4KO6qeq2c7dPRrJEIMFdRdLG3WdgjYPQy+2Otb+PXnUM
   kxUcIijtY4Tt8OXuNLvW09Jd8bq0Z3O8Wo8ei+RDedbS5JOKJ5cwRhHTn
   g==;
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="187539452"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2022 14:31:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 17 Nov 2022 14:31:36 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 17 Nov 2022 14:31:33 -0700
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
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v2 4/8] net: microchip: sparx5: Add raw VCAP debugFS support for the VCAP API
Date:   Thu, 17 Nov 2022 22:31:10 +0100
Message-ID: <20221117213114.699375-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221117213114.699375-1-steen.hegelund@microchip.com>
References: <20221117213114.699375-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for decoding VCAP rules with a minimum number of
attributes: address, rule size and keyset.

This allows for a quick inspection of a VCAP instance to determine if the
rule are present and in the correct order.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_vcap_debugfs.c    | 179 +++++++++++-
 .../net/ethernet/microchip/vcap/vcap_api.c    |  65 ++---
 .../microchip/vcap/vcap_api_debugfs.c         | 274 +++++++++++++++++-
 .../microchip/vcap/vcap_api_private.h         |  73 +++++
 4 files changed, 535 insertions(+), 56 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_private.h

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
index 2cb061e891c5..b91e05ffe2f4 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
@@ -13,11 +13,188 @@
 #include "sparx5_vcap_impl.h"
 #include "sparx5_vcap_ag_api.h"
 
+static void sparx5_vcap_port_keys(struct sparx5 *sparx5,
+				  struct vcap_admin *admin,
+				  struct sparx5_port *port,
+				  struct vcap_output_print *out)
+{
+	int lookup;
+	u32 value;
+
+	out->prf(out->dst, "  port[%02d] (%s): ", port->portno,
+	   netdev_name(port->ndev));
+	for (lookup = 0; lookup < admin->lookups; ++lookup) {
+		out->prf(out->dst, "\n    Lookup %d: ", lookup);
+
+		/* Get lookup state */
+		value = spx5_rd(sparx5, ANA_ACL_VCAP_S2_CFG(port->portno));
+		out->prf(out->dst, "\n      state: ");
+		if (ANA_ACL_VCAP_S2_CFG_SEC_ENA_GET(value))
+			out->prf(out->dst, "on");
+		else
+			out->prf(out->dst, "off");
+
+		/* Get key selection state */
+		value = spx5_rd(sparx5,
+				ANA_ACL_VCAP_S2_KEY_SEL(port->portno, lookup));
+
+		out->prf(out->dst, "\n      noneth: ");
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_NON_ETH_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_NONETH_MAC_ETYPE:
+			out->prf(out->dst, "mac_etype");
+			break;
+		case VCAP_IS2_PS_NONETH_CUSTOM_1:
+			out->prf(out->dst, "custom1");
+			break;
+		case VCAP_IS2_PS_NONETH_CUSTOM_2:
+			out->prf(out->dst, "custom2");
+			break;
+		case VCAP_IS2_PS_NONETH_NO_LOOKUP:
+			out->prf(out->dst, "none");
+			break;
+		}
+		out->prf(out->dst, "\n      ipv4_mc: ");
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_IP4_MC_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_IPV4_MC_MAC_ETYPE:
+			out->prf(out->dst, "mac_etype");
+			break;
+		case VCAP_IS2_PS_IPV4_MC_IP4_TCP_UDP_OTHER:
+			out->prf(out->dst, "ip4_tcp_udp ip4_other");
+			break;
+		case VCAP_IS2_PS_IPV4_MC_IP_7TUPLE:
+			out->prf(out->dst, "ip_7tuple");
+			break;
+		case VCAP_IS2_PS_IPV4_MC_IP4_VID:
+			out->prf(out->dst, "ip4_vid");
+			break;
+		}
+		out->prf(out->dst, "\n      ipv4_uc: ");
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_IP4_UC_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_IPV4_UC_MAC_ETYPE:
+			out->prf(out->dst, "mac_etype");
+			break;
+		case VCAP_IS2_PS_IPV4_UC_IP4_TCP_UDP_OTHER:
+			out->prf(out->dst, "ip4_tcp_udp ip4_other");
+			break;
+		case VCAP_IS2_PS_IPV4_UC_IP_7TUPLE:
+			out->prf(out->dst, "ip_7tuple");
+			break;
+		}
+		out->prf(out->dst, "\n      ipv6_mc: ");
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_IP6_MC_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_IPV6_MC_MAC_ETYPE:
+			out->prf(out->dst, "mac_etype");
+			break;
+		case VCAP_IS2_PS_IPV6_MC_IP_7TUPLE:
+			out->prf(out->dst, "ip_7tuple");
+			break;
+		case VCAP_IS2_PS_IPV6_MC_IP6_VID:
+			out->prf(out->dst, "ip6_vid");
+			break;
+		case VCAP_IS2_PS_IPV6_MC_IP6_STD:
+			out->prf(out->dst, "ip6_std");
+			break;
+		case VCAP_IS2_PS_IPV6_MC_IP4_TCP_UDP_OTHER:
+			out->prf(out->dst, "ip4_tcp_udp ipv4_other");
+			break;
+		}
+		out->prf(out->dst, "\n      ipv6_uc: ");
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_IP6_UC_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_IPV6_UC_MAC_ETYPE:
+			out->prf(out->dst, "mac_etype");
+			break;
+		case VCAP_IS2_PS_IPV6_UC_IP_7TUPLE:
+			out->prf(out->dst, "ip_7tuple");
+			break;
+		case VCAP_IS2_PS_IPV6_UC_IP6_STD:
+			out->prf(out->dst, "ip6_std");
+			break;
+		case VCAP_IS2_PS_IPV6_UC_IP4_TCP_UDP_OTHER:
+			out->prf(out->dst, "ip4_tcp_udp ip4_other");
+			break;
+		}
+		out->prf(out->dst, "\n      arp: ");
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_ARP_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_ARP_MAC_ETYPE:
+			out->prf(out->dst, "mac_etype");
+			break;
+		case VCAP_IS2_PS_ARP_ARP:
+			out->prf(out->dst, "arp");
+			break;
+		}
+	}
+	out->prf(out->dst, "\n");
+}
+
+static void sparx5_vcap_port_stickies(struct sparx5 *sparx5,
+				      struct vcap_admin *admin,
+				      struct vcap_output_print *out)
+{
+	int lookup;
+	u32 value;
+
+	out->prf(out->dst, "  Sticky bits: ");
+	for (lookup = 0; lookup < admin->lookups; ++lookup) {
+		out->prf(out->dst, "\n    Lookup %d: ", lookup);
+		/* Get lookup sticky bits */
+		value = spx5_rd(sparx5, ANA_ACL_SEC_LOOKUP_STICKY(lookup));
+
+		if (ANA_ACL_SEC_LOOKUP_STICKY_KEY_SEL_CLM_STICKY_GET(value))
+			out->prf(out->dst, " sel_clm");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_KEY_SEL_IRLEG_STICKY_GET(value))
+			out->prf(out->dst, " sel_irleg");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_KEY_SEL_ERLEG_STICKY_GET(value))
+			out->prf(out->dst, " sel_erleg");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_KEY_SEL_PORT_STICKY_GET(value))
+			out->prf(out->dst, " sel_port");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_CUSTOM2_STICKY_GET(value))
+			out->prf(out->dst, " custom2");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_CUSTOM1_STICKY_GET(value))
+			out->prf(out->dst, " custom1");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_OAM_STICKY_GET(value))
+			out->prf(out->dst, " oam");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_VID_STICKY_GET(value))
+			out->prf(out->dst, " ip6_vid");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_STD_STICKY_GET(value))
+			out->prf(out->dst, " ip6_std");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_TCPUDP_STICKY_GET(value))
+			out->prf(out->dst, " ip6_tcpudp");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP_7TUPLE_STICKY_GET(value))
+			out->prf(out->dst, " ip_7tuple");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_VID_STICKY_GET(value))
+			out->prf(out->dst, " ip4_vid");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_TCPUDP_STICKY_GET(value))
+			out->prf(out->dst, " ip4_tcpudp");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_OTHER_STICKY_GET(value))
+			out->prf(out->dst, " ip4_other");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_ARP_STICKY_GET(value))
+			out->prf(out->dst, " arp");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_MAC_SNAP_STICKY_GET(value))
+			out->prf(out->dst, " mac_snap");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_MAC_LLC_STICKY_GET(value))
+			out->prf(out->dst, " mac_llc");
+		if (ANA_ACL_SEC_LOOKUP_STICKY_SEC_TYPE_MAC_ETYPE_STICKY_GET(value))
+			out->prf(out->dst, " mac_etype");
+		/* Clear stickies */
+		spx5_wr(value, sparx5, ANA_ACL_SEC_LOOKUP_STICKY(lookup));
+	}
+	out->prf(out->dst, "\n");
+}
+
 /* Provide port information via a callback interface */
 int sparx5_port_info(struct net_device *ndev,
 		     struct vcap_admin *admin,
 		     struct vcap_output_print *out)
 {
-	/* this will be added later */
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	const struct vcap_info *vcap;
+	struct vcap_control *vctrl;
+
+	vctrl = sparx5->vcap_ctrl;
+	vcap = &vctrl->vcaps[admin->vtype];
+	out->prf(out->dst, "%s:\n", vcap->name);
+	sparx5_vcap_port_keys(sparx5, admin, port, out);
+	sparx5_vcap_port_stickies(sparx5, admin, out);
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 24f4ea1eacb3..153e28e124bc 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -6,28 +6,7 @@
 
 #include <linux/types.h>
 
-#include "vcap_api.h"
-#include "vcap_api_client.h"
-
-#define to_intrule(rule) container_of((rule), struct vcap_rule_internal, data)
-
-/* Private VCAP API rule data */
-struct vcap_rule_internal {
-	struct vcap_rule data; /* provided by the client */
-	struct list_head list; /* for insertion in the vcap admin list of rules */
-	struct vcap_admin *admin; /* vcap hw instance */
-	struct net_device *ndev;  /* the interface that the rule applies to */
-	struct vcap_control *vctrl; /* the client control */
-	u32 sort_key;  /* defines the position in the VCAP */
-	int keyset_sw;  /* subwords in a keyset */
-	int actionset_sw;  /* subwords in an actionset */
-	int keyset_sw_regs;  /* registers in a subword in an keyset */
-	int actionset_sw_regs;  /* registers in a subword in an actionset */
-	int size; /* the size of the rule: max(entry, action) */
-	u32 addr; /* address in the VCAP at insertion */
-	u32 counter_id; /* counter id (if a dedicated counter is available) */
-	struct vcap_counter counter; /* last read counter value */
-};
+#include "vcap_api_private.h"
 
 /* Moving a rule in the VCAP address space */
 struct vcap_rule_move {
@@ -36,16 +15,6 @@ struct vcap_rule_move {
 	int count; /* blocksize of addresses to move */
 };
 
-/* Bit iterator for the VCAP cache streams */
-struct vcap_stream_iter {
-	u32 offset; /* bit offset from the stream start */
-	u32 sw_width; /* subword width in bits */
-	u32 regs_per_sw; /* registers per subword */
-	u32 reg_idx; /* current register index */
-	u32 reg_bitpos; /* bit offset in current register */
-	const struct vcap_typegroup *tg; /* current typegroup */
-};
-
 /* Stores the filter cookie that enabled the port */
 struct vcap_enabled_port {
 	struct list_head list; /* for insertion in enabled ports list */
@@ -53,8 +22,8 @@ struct vcap_enabled_port {
 	unsigned long cookie; /* filter that enabled the port */
 };
 
-static void vcap_iter_set(struct vcap_stream_iter *itr, int sw_width,
-			  const struct vcap_typegroup *tg, u32 offset)
+void vcap_iter_set(struct vcap_stream_iter *itr, int sw_width,
+		   const struct vcap_typegroup *tg, u32 offset)
 {
 	memset(itr, 0, sizeof(*itr));
 	itr->offset = offset;
@@ -74,7 +43,7 @@ static void vcap_iter_skip_tg(struct vcap_stream_iter *itr)
 	}
 }
 
-static void vcap_iter_update(struct vcap_stream_iter *itr)
+void vcap_iter_update(struct vcap_stream_iter *itr)
 {
 	int sw_idx, sw_bitpos;
 
@@ -86,15 +55,15 @@ static void vcap_iter_update(struct vcap_stream_iter *itr)
 	itr->reg_bitpos = sw_bitpos % 32;
 }
 
-static void vcap_iter_init(struct vcap_stream_iter *itr, int sw_width,
-			   const struct vcap_typegroup *tg, u32 offset)
+void vcap_iter_init(struct vcap_stream_iter *itr, int sw_width,
+		    const struct vcap_typegroup *tg, u32 offset)
 {
 	vcap_iter_set(itr, sw_width, tg, offset);
 	vcap_iter_skip_tg(itr);
 	vcap_iter_update(itr);
 }
 
-static void vcap_iter_next(struct vcap_stream_iter *itr)
+void vcap_iter_next(struct vcap_stream_iter *itr)
 {
 	itr->offset++;
 	vcap_iter_skip_tg(itr);
@@ -179,9 +148,9 @@ static void vcap_encode_typegroups(u32 *stream, int sw_width,
 }
 
 /* Return the list of keyfields for the keyset */
-static const struct vcap_field *vcap_keyfields(struct vcap_control *vctrl,
-					       enum vcap_type vt,
-					       enum vcap_keyfield_set keyset)
+const struct vcap_field *vcap_keyfields(struct vcap_control *vctrl,
+					enum vcap_type vt,
+					enum vcap_keyfield_set keyset)
 {
 	/* Check that the keyset exists in the vcap keyset list */
 	if (keyset >= vctrl->vcaps[vt].keyfield_set_size)
@@ -190,9 +159,9 @@ static const struct vcap_field *vcap_keyfields(struct vcap_control *vctrl,
 }
 
 /* Return the keyset information for the keyset */
-static const struct vcap_set *vcap_keyfieldset(struct vcap_control *vctrl,
-					       enum vcap_type vt,
-					       enum vcap_keyfield_set keyset)
+const struct vcap_set *vcap_keyfieldset(struct vcap_control *vctrl,
+					enum vcap_type vt,
+					enum vcap_keyfield_set keyset)
 {
 	const struct vcap_set *kset;
 
@@ -206,7 +175,7 @@ static const struct vcap_set *vcap_keyfieldset(struct vcap_control *vctrl,
 }
 
 /* Return the typegroup table for the matching keyset (using subword size) */
-static const struct vcap_typegroup *
+const struct vcap_typegroup *
 vcap_keyfield_typegroup(struct vcap_control *vctrl,
 			enum vcap_type vt, enum vcap_keyfield_set keyset)
 {
@@ -219,8 +188,8 @@ vcap_keyfield_typegroup(struct vcap_control *vctrl,
 }
 
 /* Return the number of keyfields in the keyset */
-static int vcap_keyfield_count(struct vcap_control *vctrl,
-			       enum vcap_type vt, enum vcap_keyfield_set keyset)
+int vcap_keyfield_count(struct vcap_control *vctrl,
+			enum vcap_type vt, enum vcap_keyfield_set keyset)
 {
 	/* Check that the keyset exists in the vcap keyset list */
 	if (keyset >= vctrl->vcaps[vt].keyfield_set_size)
@@ -515,7 +484,7 @@ static int vcap_encode_rule(struct vcap_rule_internal *ri)
 	return 0;
 }
 
-static int vcap_api_check(struct vcap_control *ctrl)
+int vcap_api_check(struct vcap_control *ctrl)
 {
 	if (!ctrl) {
 		pr_err("%s:%d: vcap control is missing\n", __func__, __LINE__);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index 0c7557b1ed81..4a1ca26be901 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -5,11 +5,7 @@
  *
  */
 
-#include <linux/types.h>
-#include <linux/debugfs.h>
-#include <linux/seq_file.h>
-#include <linux/netdevice.h>
-
+#include "vcap_api_private.h"
 #include "vcap_api_debugfs.h"
 
 struct vcap_admin_debugfs_info {
@@ -22,6 +18,265 @@ struct vcap_port_debugfs_info {
 	struct net_device *ndev;
 };
 
+static bool vcap_bitarray_zero(int width, u8 *value)
+{
+	int bytes = DIV_ROUND_UP(width, BITS_PER_BYTE);
+	u8 total = 0, bmask = 0xff;
+	int rwidth = width;
+	int idx;
+
+	for (idx = 0; idx < bytes; ++idx, rwidth -= BITS_PER_BYTE) {
+		if (rwidth && rwidth < BITS_PER_BYTE)
+			bmask = (1 << rwidth) - 1;
+		total += value[idx] & bmask;
+	}
+	return total == 0;
+}
+
+static bool vcap_get_bit(u32 *stream, struct vcap_stream_iter *itr)
+{
+	u32 mask = BIT(itr->reg_bitpos);
+	u32 *p = &stream[itr->reg_idx];
+
+	return !!(*p & mask);
+}
+
+static void vcap_decode_field(u32 *stream, struct vcap_stream_iter *itr,
+			      int width, u8 *value)
+{
+	int idx;
+
+	/* Loop over the field value bits and get the field bits and
+	 * set them in the output value byte array
+	 */
+	for (idx = 0; idx < width; idx++) {
+		u8 bidx = idx & 0x7;
+
+		/* Decode one field value bit */
+		if (vcap_get_bit(stream, itr))
+			*value |= 1 << bidx;
+		vcap_iter_next(itr);
+		if (bidx == 7)
+			value++;
+	}
+}
+
+/* Verify that the typegroup bits have the correct values */
+static int vcap_verify_typegroups(u32 *stream, int sw_width,
+				  const struct vcap_typegroup *tgt, bool mask,
+				  int sw_max)
+{
+	struct vcap_stream_iter iter;
+	int sw_cnt, idx;
+
+	vcap_iter_set(&iter, sw_width, tgt, 0);
+	sw_cnt = 0;
+	while (iter.tg->width) {
+		u32 value = 0;
+		u32 tg_value = iter.tg->value;
+
+		if (mask)
+			tg_value = (1 << iter.tg->width) - 1;
+		/* Set position to current typegroup bit */
+		iter.offset = iter.tg->offset;
+		vcap_iter_update(&iter);
+		for (idx = 0; idx < iter.tg->width; idx++) {
+			/* Decode one typegroup bit */
+			if (vcap_get_bit(stream, &iter))
+				value |= 1 << idx;
+			iter.offset++;
+			vcap_iter_update(&iter);
+		}
+		if (value != tg_value)
+			return -EINVAL;
+		iter.tg++; /* next typegroup */
+		sw_cnt++;
+		/* Stop checking more typegroups */
+		if (sw_max && sw_cnt >= sw_max)
+			break;
+	}
+	return 0;
+}
+
+/* Find the subword width of the key typegroup that matches the stream data */
+static int vcap_find_keystream_typegroup_sw(struct vcap_control *vctrl,
+					    enum vcap_type vt, u32 *stream,
+					    bool mask, int sw_max)
+{
+	const struct vcap_typegroup **tgt;
+	int sw_idx, res;
+
+	tgt = vctrl->vcaps[vt].keyfield_set_typegroups;
+	/* Try the longest subword match first */
+	for (sw_idx = vctrl->vcaps[vt].sw_count; sw_idx >= 0; sw_idx--) {
+		if (!tgt[sw_idx])
+			continue;
+
+		res = vcap_verify_typegroups(stream, vctrl->vcaps[vt].sw_width,
+					     tgt[sw_idx], mask, sw_max);
+		if (res == 0)
+			return sw_idx;
+	}
+	return -EINVAL;
+}
+
+/* Verify that the type id in the stream matches the type id of the keyset */
+static bool vcap_verify_keystream_keyset(struct vcap_control *vctrl,
+					 enum vcap_type vt,
+					 u32 *keystream,
+					 u32 *mskstream,
+					 enum vcap_keyfield_set keyset)
+{
+	const struct vcap_info *vcap = &vctrl->vcaps[vt];
+	const struct vcap_field *typefld;
+	const struct vcap_typegroup *tgt;
+	const struct vcap_field *fields;
+	struct vcap_stream_iter iter;
+	const struct vcap_set *info;
+	u32 value = 0;
+	u32 mask = 0;
+
+	if (vcap_keyfield_count(vctrl, vt, keyset) == 0)
+		return false;
+
+	info = vcap_keyfieldset(vctrl, vt, keyset);
+	/* Check that the keyset is valid */
+	if (!info)
+		return false;
+
+	/* a type_id of value -1 means that there is no type field */
+	if (info->type_id == (u8)-1)
+		return true;
+
+	/* Get a valid typegroup for the specific keyset */
+	tgt = vcap_keyfield_typegroup(vctrl, vt, keyset);
+	if (!tgt)
+		return false;
+
+	fields = vcap_keyfields(vctrl, vt, keyset);
+	if (!fields)
+		return false;
+
+	typefld = &fields[VCAP_KF_TYPE];
+	vcap_iter_init(&iter, vcap->sw_width, tgt, typefld->offset);
+	vcap_decode_field(mskstream, &iter, typefld->width, (u8 *)&mask);
+	/* no type info if there are no mask bits */
+	if (vcap_bitarray_zero(typefld->width, (u8 *)&mask))
+		return false;
+
+	/* Get the value of the type field in the stream and compare to the
+	 * one define in the vcap keyset
+	 */
+	vcap_iter_init(&iter, vcap->sw_width, tgt, typefld->offset);
+	vcap_decode_field(keystream, &iter, typefld->width, (u8 *)&value);
+
+	return (value == info->type_id);
+}
+
+/* Verify that the typegroup information, subword count, keyset and type id
+ * are in sync and correct, return the keyset
+ */
+static enum
+vcap_keyfield_set vcap_find_keystream_keyset(struct vcap_control *vctrl,
+					     enum vcap_type vt,
+					     u32 *keystream,
+					     u32 *mskstream,
+					     bool mask, int sw_max)
+{
+	const struct vcap_set *keyfield_set;
+	int sw_count, idx;
+	bool res;
+
+	sw_count = vcap_find_keystream_typegroup_sw(vctrl, vt, keystream, mask,
+						    sw_max);
+	if (sw_count < 0)
+		return sw_count;
+
+	keyfield_set = vctrl->vcaps[vt].keyfield_set;
+	for (idx = 0; idx < vctrl->vcaps[vt].keyfield_set_size; ++idx) {
+		if (keyfield_set[idx].sw_per_item != sw_count)
+			continue;
+
+		res = vcap_verify_keystream_keyset(vctrl, vt, keystream,
+						   mskstream, idx);
+		if (res)
+			return idx;
+	}
+	return -EINVAL;
+}
+
+/* Read key data from a VCAP address and discover if there is a rule keyset
+ * here
+ */
+static int vcap_addr_keyset(struct vcap_control *vctrl,
+			    struct net_device *ndev,
+			    struct vcap_admin *admin,
+			    int addr)
+{
+	enum vcap_type vt = admin->vtype;
+	int keyset_sw_regs, idx;
+	u32 key = 0, mask = 0;
+
+	/* Read the cache at the specified address */
+	keyset_sw_regs = DIV_ROUND_UP(vctrl->vcaps[vt].sw_width, 32);
+	vctrl->ops->update(ndev, admin, VCAP_CMD_READ, VCAP_SEL_ALL, addr);
+	vctrl->ops->cache_read(ndev, admin, VCAP_SEL_ENTRY, 0,
+			       keyset_sw_regs);
+	/* Skip uninitialized key/mask entries */
+	for (idx = 0; idx < keyset_sw_regs; ++idx) {
+		key |= ~admin->cache.keystream[idx];
+		mask |= admin->cache.maskstream[idx];
+	}
+	if (key == 0 && mask == 0)
+		return -EINVAL;
+	/* Decode and locate the keyset */
+	return vcap_find_keystream_keyset(vctrl, vt, admin->cache.keystream,
+					  admin->cache.maskstream, false, 0);
+}
+
+static int vcap_show_admin_raw(struct vcap_control *vctrl,
+			       struct vcap_admin *admin,
+			       struct vcap_output_print *out)
+{
+	enum vcap_type vt = admin->vtype;
+	struct vcap_rule_internal *ri;
+	const struct vcap_set *info;
+	int keyset;
+	int addr;
+	int ret;
+
+	if (list_empty(&admin->rules))
+		return 0;
+
+	ret = vcap_api_check(vctrl);
+	if (ret)
+		return ret;
+
+	ri = list_first_entry(&admin->rules, struct vcap_rule_internal, list);
+
+	/* Go from higher to lower addresses searching for a keyset */
+	for (addr = admin->last_valid_addr; addr >= admin->first_valid_addr;
+	     --addr) {
+		keyset = vcap_addr_keyset(vctrl, ri->ndev, admin,  addr);
+		if (keyset < 0)
+			continue;
+		info = vcap_keyfieldset(vctrl, vt, keyset);
+		if (!info)
+			continue;
+		if (addr % info->sw_per_item)
+			pr_info("addr: %d X%d error rule, keyset: %s\n",
+				addr,
+				info->sw_per_item,
+				vcap_keyset_name(vctrl, keyset));
+		else
+			out->prf(out->dst, "  addr: %d, X%d rule, keyset: %s\n",
+			   addr,
+			   info->sw_per_item,
+			   vcap_keyset_name(vctrl, keyset));
+	}
+	return 0;
+}
+
 /* Show the port configuration and status */
 static int vcap_port_debugfs_show(struct seq_file *m, void *unused)
 {
@@ -61,8 +316,13 @@ EXPORT_SYMBOL_GPL(vcap_port_debugfs);
 /* Show the raw VCAP instance data (rules with address info) */
 static int vcap_raw_debugfs_show(struct seq_file *m, void *unused)
 {
-	/* The output will be added later */
-	return 0;
+	struct vcap_admin_debugfs_info *info = m->private;
+	struct vcap_output_print out = {
+		.prf = (void *)seq_printf,
+		.dst = m,
+	};
+
+	return vcap_show_admin_raw(info->vctrl, info->admin, &out);
 }
 DEFINE_SHOW_ATTRIBUTE(vcap_raw_debugfs);
 
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
new file mode 100644
index 000000000000..1ea25c5d0ca7
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
+ * Microchip VCAP API
+ */
+
+#ifndef __VCAP_API_PRIVATE__
+#define __VCAP_API_PRIVATE__
+
+#include <linux/types.h>
+
+#include "vcap_api.h"
+#include "vcap_api_client.h"
+
+#define to_intrule(rule) container_of((rule), struct vcap_rule_internal, data)
+
+/* Private VCAP API rule data */
+struct vcap_rule_internal {
+	struct vcap_rule data; /* provided by the client */
+	struct list_head list; /* the vcap admin list of rules */
+	struct vcap_admin *admin; /* vcap hw instance */
+	struct net_device *ndev;  /* the interface that the rule applies to */
+	struct vcap_control *vctrl; /* the client control */
+	u32 sort_key;  /* defines the position in the VCAP */
+	int keyset_sw;  /* subwords in a keyset */
+	int actionset_sw;  /* subwords in an actionset */
+	int keyset_sw_regs;  /* registers in a subword in an keyset */
+	int actionset_sw_regs;  /* registers in a subword in an actionset */
+	int size; /* the size of the rule: max(entry, action) */
+	u32 addr; /* address in the VCAP at insertion */
+	u32 counter_id; /* counter id (if a dedicated counter is available) */
+	struct vcap_counter counter; /* last read counter value */
+};
+
+/* Bit iterator for the VCAP cache streams */
+struct vcap_stream_iter {
+	u32 offset; /* bit offset from the stream start */
+	u32 sw_width; /* subword width in bits */
+	u32 regs_per_sw; /* registers per subword */
+	u32 reg_idx; /* current register index */
+	u32 reg_bitpos; /* bit offset in current register */
+	const struct vcap_typegroup *tg; /* current typegroup */
+};
+
+/* Check that the control has a valid set of callbacks */
+int vcap_api_check(struct vcap_control *ctrl);
+
+/* Iterator functionality */
+
+void vcap_iter_init(struct vcap_stream_iter *itr, int sw_width,
+		    const struct vcap_typegroup *tg, u32 offset);
+void vcap_iter_next(struct vcap_stream_iter *itr);
+void vcap_iter_set(struct vcap_stream_iter *itr, int sw_width,
+		   const struct vcap_typegroup *tg, u32 offset);
+void vcap_iter_update(struct vcap_stream_iter *itr);
+
+/* Keyset and keyfield functionality */
+
+/* Return the keyset information for the keyset */
+const struct vcap_set *vcap_keyfieldset(struct vcap_control *vctrl,
+					enum vcap_type vt,
+					enum vcap_keyfield_set keyset);
+/* Return the number of keyfields in the keyset */
+int vcap_keyfield_count(struct vcap_control *vctrl,
+			enum vcap_type vt, enum vcap_keyfield_set keyset);
+/* Return the typegroup table for the matching keyset (using subword size) */
+const struct vcap_typegroup *
+vcap_keyfield_typegroup(struct vcap_control *vctrl,
+			enum vcap_type vt, enum vcap_keyfield_set keyset);
+/* Return the list of keyfields for the keyset */
+const struct vcap_field *vcap_keyfields(struct vcap_control *vctrl,
+					enum vcap_type vt,
+					enum vcap_keyfield_set keyset);
+#endif /* __VCAP_API_PRIVATE__ */
-- 
2.38.1

