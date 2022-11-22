Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E72633FAF
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiKVPBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234224AbiKVPAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:00:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4475D716CD;
        Tue, 22 Nov 2022 06:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669129191; x=1700665191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=13nnEeD5/sqn4Q5vO902YKQTR+lPJMkEUpXmaLS9Ryc=;
  b=zRcnnaz+F/QRPxmHY8L1jxjwP5VuXSM7IA8BnIlm10moS42YwGZqJGXZ
   yA/94aM6j4uKRqRgdW/E72NiNcfZbeMOjXLmk/10iYOsFsAr65K4dMRmV
   Ygq8SEVUKcjotCFoead/YirhF8rlF0T2+IyvYKLtn2y0nW5qITmmcrgMR
   i/PHTTYQxdVijf9Qao590UEXytWj76N9DPprg773I+lVG0jHLjYA6BTtC
   QMH6xbx2FoyBL80Evjxt8+eW3bViAPofZBqEIX50d9S6xU11jDueXuEyy
   uSqTyyL0xEY8Lea23W9+JmJlRehzSv13wlFtzEJxF1u+kqvgKjqXnMqGF
   g==;
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="200931719"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 07:59:50 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 07:59:50 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 22 Nov 2022 07:59:47 -0700
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
Subject: [PATCH net-next 2/4] net: microchip: sparx5: Support for TC protocol all
Date:   Tue, 22 Nov 2022 15:59:36 +0100
Message-ID: <20221122145938.1775954-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122145938.1775954-1-steen.hegelund@microchip.com>
References: <20221122145938.1775954-1-steen.hegelund@microchip.com>
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

This allows support of TC protocol all for the Sparx5 IS2 VCAP.

This is done by creating multiple rules that covers the rule size and
traffic types in the IS2.
Each rule size (e.g X16 and X6) may have multiple keysets and if there are
more than one the type field in the VCAP rule will be wildcarded to support
these keysets.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 209 +++++++++++++++++-
 .../microchip/sparx5/sparx5_vcap_impl.c       |  18 +-
 .../microchip/sparx5/sparx5_vcap_impl.h       |  13 ++
 3 files changed, 234 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index bd6bd380ba34..1ed304a816cc 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -12,6 +12,20 @@
 #include "sparx5_main.h"
 #include "sparx5_vcap_impl.h"
 
+#define SPX5_MAX_RULE_SIZE 13 /* allows X1, X2, X4, X6 and X12 rules */
+
+/* Collect keysets and type ids for multiple rules per size */
+struct sparx5_wildcard_rule {
+	bool selected;
+	u8 value;
+	u8 mask;
+	enum vcap_keyfield_set keyset;
+};
+
+struct sparx5_multiple_rules {
+	struct sparx5_wildcard_rule rule[SPX5_MAX_RULE_SIZE];
+};
+
 struct sparx5_tc_flower_parse_usage {
 	struct flow_cls_offload *fco;
 	struct flow_rule *frule;
@@ -618,7 +632,7 @@ static int sparx5_tc_add_rule_counter(struct vcap_admin *admin,
 {
 	int err;
 
-	err = vcap_rule_add_action_u32(vrule, VCAP_AF_CNT_ID, vrule->id);
+	err = vcap_rule_mod_action_u32(vrule, VCAP_AF_CNT_ID, vrule->id);
 	if (err)
 		return err;
 
@@ -626,11 +640,190 @@ static int sparx5_tc_add_rule_counter(struct vcap_admin *admin,
 	return err;
 }
 
+/* Collect all port keysets and apply the first of them, possibly wildcarded */
+static int sparx5_tc_select_protocol_keyset(struct net_device *ndev,
+					    struct vcap_rule *vrule,
+					    struct vcap_admin *admin,
+					    u16 l3_proto,
+					    struct sparx5_multiple_rules *multi)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct vcap_keyset_list portkeysetlist = {};
+	enum vcap_keyfield_set portkeysets[10] = {};
+	struct vcap_keyset_list matches = {};
+	enum vcap_keyfield_set keysets[10];
+	int idx, jdx, err = 0, count = 0;
+	struct sparx5_wildcard_rule *mru;
+	const struct vcap_set *kinfo;
+	struct vcap_control *vctrl;
+
+	vctrl = port->sparx5->vcap_ctrl;
+
+	/* Find the keysets that the rule can use */
+	matches.keysets = keysets;
+	matches.max = ARRAY_SIZE(keysets);
+	if (vcap_rule_find_keysets(vrule, &matches) == 0)
+		return -EINVAL;
+
+	/* Find the keysets that the port configuration supports */
+	portkeysetlist.max = ARRAY_SIZE(portkeysets);
+	portkeysetlist.keysets = portkeysets;
+	err = sparx5_vcap_get_port_keyset(ndev,
+					  admin, vrule->vcap_chain_id,
+					  l3_proto,
+					  &portkeysetlist);
+	if (err)
+		return err;
+
+	/* Find the intersection of the two sets of keyset */
+	for (idx = 0; idx < portkeysetlist.cnt; ++idx) {
+		kinfo = vcap_keyfieldset(vctrl, admin->vtype,
+					 portkeysetlist.keysets[idx]);
+		if (!kinfo)
+			continue;
+
+		/* Find a port keyset that matches the required keys
+		 * If there are multiple keysets then compose a type id mask
+		 */
+		for (jdx = 0; jdx < matches.cnt; ++jdx) {
+			if (portkeysetlist.keysets[idx] != matches.keysets[jdx])
+				continue;
+
+			mru = &multi->rule[kinfo->sw_per_item];
+			if (!mru->selected) {
+				mru->selected = true;
+				mru->keyset = portkeysetlist.keysets[idx];
+				mru->value = kinfo->type_id;
+			}
+			mru->value &= kinfo->type_id;
+			mru->mask |= kinfo->type_id;
+			++count;
+		}
+	}
+	if (count == 0)
+		return -EPROTO;
+
+	if (l3_proto == ETH_P_ALL && count < portkeysetlist.cnt)
+		return -ENOENT;
+
+	for (idx = 0; idx < SPX5_MAX_RULE_SIZE; ++idx) {
+		mru = &multi->rule[idx];
+		if (!mru->selected)
+			continue;
+
+		/* Align the mask to the combined value */
+		mru->mask ^= mru->value;
+	}
+
+	/* Set the chosen keyset on the rule and set a wildcarded type if there
+	 * are more than one keyset
+	 */
+	for (idx = 0; idx < SPX5_MAX_RULE_SIZE; ++idx) {
+		mru = &multi->rule[idx];
+		if (!mru->selected)
+			continue;
+
+		vcap_set_rule_set_keyset(vrule, mru->keyset);
+		if (count > 1)
+			/* Some keysets do not have a type field */
+			vcap_rule_mod_key_u32(vrule, VCAP_KF_TYPE,
+					      mru->value,
+					      ~mru->mask);
+		mru->selected = false; /* mark as done */
+		break; /* Stop here and add more rules later */
+	}
+	return err;
+}
+
+static int sparx5_tc_add_rule_copy(struct vcap_control *vctrl,
+				   struct flow_cls_offload *fco,
+				   struct vcap_rule *erule,
+				   struct vcap_admin *admin,
+				   struct sparx5_wildcard_rule *rule)
+{
+	enum vcap_key_field keylist[] = {
+		VCAP_KF_IF_IGR_PORT_MASK,
+		VCAP_KF_IF_IGR_PORT_MASK_SEL,
+		VCAP_KF_IF_IGR_PORT_MASK_RNG,
+		VCAP_KF_LOOKUP_FIRST_IS,
+		VCAP_KF_TYPE,
+	};
+	struct vcap_rule *vrule;
+	int err;
+
+	/* Add an extra rule with a special user and the new keyset */
+	erule->user = VCAP_USER_TC_EXTRA;
+	vrule = vcap_copy_rule(erule);
+	if (IS_ERR(vrule))
+		return PTR_ERR(vrule);
+
+	/* Link the new rule to the existing rule with the cookie */
+	vrule->cookie = erule->cookie;
+	vcap_filter_rule_keys(vrule, keylist, ARRAY_SIZE(keylist), true);
+	err = vcap_set_rule_set_keyset(vrule, rule->keyset);
+	if (err) {
+		pr_err("%s:%d: could not set keyset %s in rule: %u\n",
+		       __func__, __LINE__,
+		       vcap_keyset_name(vctrl, rule->keyset),
+		       vrule->id);
+		goto out;
+	}
+
+	/* Some keysets do not have a type field, so ignore return value */
+	vcap_rule_mod_key_u32(vrule, VCAP_KF_TYPE, rule->value, ~rule->mask);
+
+	err = vcap_set_rule_set_actionset(vrule, erule->actionset);
+	if (err)
+		goto out;
+
+	err = sparx5_tc_add_rule_counter(admin, vrule);
+	if (err)
+		goto out;
+
+	err = vcap_val_rule(vrule, ETH_P_ALL);
+	if (err) {
+		pr_err("%s:%d: could not validate rule: %u\n",
+		       __func__, __LINE__, vrule->id);
+		vcap_set_tc_exterr(fco, vrule);
+		goto out;
+	}
+	err = vcap_add_rule(vrule);
+	if (err) {
+		pr_err("%s:%d: could not add rule: %u\n",
+		       __func__, __LINE__, vrule->id);
+		goto out;
+	}
+out:
+	vcap_free_rule(vrule);
+	return err;
+}
+
+static int sparx5_tc_add_remaining_rules(struct vcap_control *vctrl,
+					 struct flow_cls_offload *fco,
+					 struct vcap_rule *erule,
+					 struct vcap_admin *admin,
+					 struct sparx5_multiple_rules *multi)
+{
+	int idx, err = 0;
+
+	for (idx = 0; idx < SPX5_MAX_RULE_SIZE; ++idx) {
+		if (!multi->rule[idx].selected)
+			continue;
+
+		err = sparx5_tc_add_rule_copy(vctrl, fco, erule, admin,
+					      &multi->rule[idx]);
+		if (err)
+			break;
+	}
+	return err;
+}
+
 static int sparx5_tc_flower_replace(struct net_device *ndev,
 				    struct flow_cls_offload *fco,
 				    struct vcap_admin *admin)
 {
 	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5_multiple_rules multi = {};
 	struct flow_action_entry *act;
 	struct vcap_control *vctrl;
 	struct flow_rule *frule;
@@ -700,6 +893,15 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 			goto out;
 		}
 	}
+
+	err = sparx5_tc_select_protocol_keyset(ndev, vrule, admin, l3_proto,
+					       &multi);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "No matching port keyset for filter protocol and keys");
+		goto out;
+	}
+
 	/* provide the l3 protocol to guide the keyset selection */
 	err = vcap_val_rule(vrule, l3_proto);
 	if (err) {
@@ -710,6 +912,11 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 	if (err)
 		NL_SET_ERR_MSG_MOD(fco->common.extack,
 				   "Could not add the filter");
+
+	if (l3_proto == ETH_P_ALL)
+		err = sparx5_tc_add_remaining_rules(vctrl, fco, vrule, admin,
+						    &multi);
+
 out:
 	vcap_free_rule(vrule);
 	return err;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index 0c4d4e6d51e6..a0c126ba9a87 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -7,11 +7,6 @@
  * https://github.com/microchip-ung/sparx-5_reginfo
  */
 
-#include <linux/types.h>
-#include <linux/list.h>
-
-#include "vcap_api.h"
-#include "vcap_api_client.h"
 #include "vcap_api_debugfs.h"
 #include "sparx5_main_regs.h"
 #include "sparx5_main.h"
@@ -279,6 +274,19 @@ static int sparx5_vcap_is2_get_port_keysets(struct net_device *ndev,
 	return 0;
 }
 
+/* Get the port keyset for the vcap lookup */
+int sparx5_vcap_get_port_keyset(struct net_device *ndev,
+				struct vcap_admin *admin,
+				int cid,
+				u16 l3_proto,
+				struct vcap_keyset_list *kslist)
+{
+	int lookup;
+
+	lookup = sparx5_vcap_cid_to_lookup(cid);
+	return sparx5_vcap_is2_get_port_keysets(ndev, lookup, kslist, l3_proto);
+}
+
 /* API callback used for validating a field keyset (check the port keysets) */
 static enum vcap_keyfield_set
 sparx5_vcap_validate_keyset(struct net_device *ndev,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
index 8a6b7e3d2618..0a0f2412c980 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
@@ -10,6 +10,12 @@
 #ifndef __SPARX5_VCAP_IMPL_H__
 #define __SPARX5_VCAP_IMPL_H__
 
+#include <linux/types.h>
+#include <linux/list.h>
+
+#include "vcap_api.h"
+#include "vcap_api_client.h"
+
 #define SPARX5_VCAP_CID_IS2_L0 VCAP_CID_INGRESS_STAGE2_L0 /* IS2 lookup 0 */
 #define SPARX5_VCAP_CID_IS2_L1 VCAP_CID_INGRESS_STAGE2_L1 /* IS2 lookup 1 */
 #define SPARX5_VCAP_CID_IS2_L2 VCAP_CID_INGRESS_STAGE2_L2 /* IS2 lookup 2 */
@@ -65,4 +71,11 @@ enum vcap_is2_port_sel_arp {
 	VCAP_IS2_PS_ARP_ARP,
 };
 
+/* Get the port keyset for the vcap lookup */
+int sparx5_vcap_get_port_keyset(struct net_device *ndev,
+				struct vcap_admin *admin,
+				int cid,
+				u16 l3_proto,
+				struct vcap_keyset_list *kslist);
+
 #endif /* __SPARX5_VCAP_IMPL_H__ */
-- 
2.38.1

