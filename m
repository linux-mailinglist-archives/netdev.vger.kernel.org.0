Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264D76114FF
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 16:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiJ1Oq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 10:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiJ1OqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 10:46:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109B21CC3FC;
        Fri, 28 Oct 2022 07:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666968365; x=1698504365;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NZVj8CsVcZYf/Kxg8SpnWLE0+k4rDuZWfdOpNBE1/p0=;
  b=BU+sbFVItFGdgqLSSl8cYeIVrNkCLuq1/0wrLtkI+db2yuUS6+li/KOE
   AD4+YHcvE6RhQ4mq7bi6xR1XNvIwJjjvAaO+qXGOqFL09qkYymmrYnK8o
   R4Wy2vtgbjt0230MTmn5WTBnaB2YJmYFMywueRh6U9qY+RVRaVEZRO+Fa
   Cijh1gGmHZLWBSgJ2VY2LNcKN+avaXDgo95ij9oTnyrrq9ge0s9xBNp0Q
   HhX3Utkei6Cq3QTKBP2XM3oJyTpGDl+Jc+qNRDYwhnh6wwb3/JIjCFQnB
   I3epq9sDSXuFLmllB1Je1Tg3Q6T0OCKFLTqGN4CHzU7Q/208tMrKgQBUk
   A==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="186791982"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2022 07:46:03 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 28 Oct 2022 07:46:01 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 28 Oct 2022 07:45:58 -0700
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
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v2 3/5] net: microchip: sparx5: Match keys in configured port keysets
Date:   Fri, 28 Oct 2022 16:45:38 +0200
Message-ID: <20221028144540.3344995-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028144540.3344995-1-steen.hegelund@microchip.com>
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tries to match the keys in a rule with the keysets supported by the
VCAP instance, and generate a list of keysets.

This list is then validated against the list of keysets that is currently
selected for the lookups (per port) in the VCAP configuration.

The Sparx5 IS2 only has one actionset, so there is no actionset matching
performed for now.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       |  26 ++--
 .../microchip/sparx5/sparx5_vcap_impl.c       | 147 +++++++++++++++++-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 137 ++++++++++++++--
 .../ethernet/microchip/vcap/vcap_api_client.h |  11 ++
 4 files changed, 298 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 13bc6bff4c1e..9b90e7d5517b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -443,11 +443,13 @@ static int (*sparx5_tc_flower_usage_handlers[])(struct sparx5_tc_flower_parse_us
 
 static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
 				    struct vcap_admin *admin,
-				    struct vcap_rule *vrule)
+				    struct vcap_rule *vrule,
+				    u16 *l3_proto)
 {
 	struct sparx5_tc_flower_parse_usage state = {
 		.fco = fco,
 		.vrule = vrule,
+		.l3_proto = ETH_P_ALL,
 	};
 	int idx, err = 0;
 
@@ -461,6 +463,15 @@ static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
 		if (err)
 			return err;
 	}
+
+	if (state.frule->match.dissector->used_keys ^ state.used_keys) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Unsupported match item");
+		return -ENOENT;
+	}
+
+	if (l3_proto)
+		*l3_proto = state.l3_proto;
 	return err;
 }
 
@@ -473,6 +484,7 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 	struct vcap_control *vctrl;
 	struct flow_rule *frule;
 	struct vcap_rule *vrule;
+	u16 l3_proto;
 	int err, idx;
 
 	frule = flow_cls_offload_flow_rule(fco);
@@ -491,7 +503,7 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 		return PTR_ERR(vrule);
 
 	vrule->cookie = fco->cookie;
-	sparx5_tc_use_dissectors(fco, admin, vrule);
+	sparx5_tc_use_dissectors(fco, admin, vrule, &l3_proto);
 	flow_action_for_each(idx, act, &frule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_TRAP:
@@ -528,14 +540,8 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 			goto out;
 		}
 	}
-	/* For now the keyset is hardcoded */
-	err = vcap_set_rule_set_keyset(vrule, VCAP_KFS_MAC_ETYPE);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(fco->common.extack,
-				   "No matching port keyset for filter protocol and keys");
-		goto out;
-	}
-	err = vcap_val_rule(vrule, ETH_P_ALL);
+	/* provide the l3 protocol to guide the keyset selection */
+	err = vcap_val_rule(vrule, l3_proto);
 	if (err) {
 		vcap_set_tc_exterr(fco, vrule);
 		goto out;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index e4428d55af2b..642c27299e22 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -160,7 +160,7 @@ static const char *sparx5_vcap_keyset_name(struct net_device *ndev,
 {
 	struct sparx5_port *port = netdev_priv(ndev);
 
-	return port->sparx5->vcap_ctrl->stats->keyfield_set_names[keyset];
+	return vcap_keyset_name(port->sparx5->vcap_ctrl, keyset);
 }
 
 /* Check if this is the first lookup of IS2 */
@@ -204,6 +204,127 @@ static void sparx5_vcap_add_wide_port_mask(struct vcap_rule *rule,
 	vcap_rule_add_key_u72(rule, VCAP_KF_IF_IGR_PORT_MASK, &port_mask);
 }
 
+/* Convert chain id to vcap lookup id */
+static int sparx5_vcap_cid_to_lookup(int cid)
+{
+	int lookup = 0;
+
+	/* For now only handle IS2 */
+	if (cid >= SPARX5_VCAP_CID_IS2_L1 && cid < SPARX5_VCAP_CID_IS2_L2)
+		lookup = 1;
+	else if (cid >= SPARX5_VCAP_CID_IS2_L2 && cid < SPARX5_VCAP_CID_IS2_L3)
+		lookup = 2;
+	else if (cid >= SPARX5_VCAP_CID_IS2_L3 && cid < SPARX5_VCAP_CID_IS2_MAX)
+		lookup = 3;
+
+	return lookup;
+}
+
+/* Return the list of keysets for the vcap port configuration */
+static int sparx5_vcap_is2_get_port_keysets(struct net_device *ndev,
+					    int lookup,
+					    struct vcap_keyset_list *keysetlist,
+					    u16 l3_proto)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	u32 value;
+
+	/* Check if the port keyset selection is enabled */
+	value = spx5_rd(sparx5, ANA_ACL_VCAP_S2_KEY_SEL(portno, lookup));
+	if (!ANA_ACL_VCAP_S2_KEY_SEL_KEY_SEL_ENA_GET(value))
+		return -ENOENT;
+
+	/* Collect all keysets for the port in a list */
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_ARP) {
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_ARP_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_ARP_MAC_ETYPE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+			break;
+		case VCAP_IS2_PS_ARP_ARP:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_ARP);
+			break;
+		}
+	}
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_IP) {
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_IP4_UC_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_IPV4_UC_MAC_ETYPE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+			break;
+		case VCAP_IS2_PS_IPV4_UC_IP4_TCP_UDP_OTHER:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_TCP_UDP);
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_OTHER);
+			break;
+		case VCAP_IS2_PS_IPV4_UC_IP_7TUPLE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP_7TUPLE);
+			break;
+		}
+
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_IP4_MC_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_IPV4_MC_MAC_ETYPE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+			break;
+		case VCAP_IS2_PS_IPV4_MC_IP4_TCP_UDP_OTHER:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_TCP_UDP);
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_OTHER);
+			break;
+		case VCAP_IS2_PS_IPV4_MC_IP_7TUPLE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP_7TUPLE);
+			break;
+		}
+	}
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_IPV6) {
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_IP6_UC_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_IPV6_UC_MAC_ETYPE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+			break;
+		case VCAP_IS2_PS_IPV6_UC_IP_7TUPLE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP_7TUPLE);
+			break;
+		case VCAP_IS2_PS_IPV6_UC_IP6_STD:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP6_STD);
+			break;
+		case VCAP_IS2_PS_IPV6_UC_IP4_TCP_UDP_OTHER:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_TCP_UDP);
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_OTHER);
+			break;
+		}
+
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_IP6_MC_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_IPV6_MC_MAC_ETYPE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+			break;
+		case VCAP_IS2_PS_IPV6_MC_IP_7TUPLE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP_7TUPLE);
+			break;
+		case VCAP_IS2_PS_IPV6_MC_IP6_STD:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP6_STD);
+			break;
+		case VCAP_IS2_PS_IPV6_MC_IP4_TCP_UDP_OTHER:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_TCP_UDP);
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_OTHER);
+			break;
+		case VCAP_IS2_PS_IPV6_MC_IP6_VID:
+			/* Not used */
+			break;
+		}
+	}
+
+	if (l3_proto != ETH_P_ARP && l3_proto != ETH_P_IP &&
+	    l3_proto != ETH_P_IPV6) {
+		switch (ANA_ACL_VCAP_S2_KEY_SEL_NON_ETH_KEY_SEL_GET(value)) {
+		case VCAP_IS2_PS_NONETH_MAC_ETYPE:
+			/* IS2 non-classified frames generate MAC_ETYPE */
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+			break;
+		}
+	}
+	return 0;
+}
+
 /* API callback used for validating a field keyset (check the port keysets) */
 static enum vcap_keyfield_set
 sparx5_vcap_validate_keyset(struct net_device *ndev,
@@ -212,10 +333,30 @@ sparx5_vcap_validate_keyset(struct net_device *ndev,
 			    struct vcap_keyset_list *kslist,
 			    u16 l3_proto)
 {
+	struct vcap_keyset_list keysetlist = {};
+	enum vcap_keyfield_set keysets[10] = {};
+	int idx, jdx, lookup;
+
 	if (!kslist || kslist->cnt == 0)
 		return VCAP_KFS_NO_VALUE;
-	/* for now just return whatever the API suggests */
-	return kslist->keysets[0];
+
+	/* Get a list of currently configured keysets in the lookups */
+	lookup = sparx5_vcap_cid_to_lookup(rule->vcap_chain_id);
+	keysetlist.max = ARRAY_SIZE(keysets);
+	keysetlist.keysets = keysets;
+	sparx5_vcap_is2_get_port_keysets(ndev, lookup, &keysetlist, l3_proto);
+
+	/* Check if there is a match and return the match */
+	for (idx = 0; idx < kslist->cnt; ++idx)
+		for (jdx = 0; jdx < keysetlist.cnt; ++jdx)
+			if (kslist->keysets[idx] == keysets[jdx])
+				return kslist->keysets[idx];
+
+	pr_err("%s:%d: %s not supported in port key selection\n",
+	       __func__, __LINE__,
+	       sparx5_vcap_keyset_name(ndev, kslist->keysets[0]));
+
+	return -ENOENT;
 }
 
 /* API callback used for adding default fields to a rule */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index ace2582d8552..9e67ea814768 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -704,15 +704,115 @@ static int vcap_add_type_keyfield(struct vcap_rule *rule)
 	return 0;
 }
 
+/* Add a keyset to a keyset list */
+bool vcap_keyset_list_add(struct vcap_keyset_list *keysetlist,
+			  enum vcap_keyfield_set keyset)
+{
+	int idx;
+
+	if (keysetlist->cnt < keysetlist->max) {
+		/* Avoid duplicates */
+		for (idx = 0; idx < keysetlist->cnt; ++idx)
+			if (keysetlist->keysets[idx] == keyset)
+				return keysetlist->cnt < keysetlist->max;
+		keysetlist->keysets[keysetlist->cnt++] = keyset;
+	}
+	return keysetlist->cnt < keysetlist->max;
+}
+EXPORT_SYMBOL_GPL(vcap_keyset_list_add);
+
+/* map keyset id to a string with the keyset name */
+const char *vcap_keyset_name(struct vcap_control *vctrl,
+			     enum vcap_keyfield_set keyset)
+{
+	return vctrl->stats->keyfield_set_names[keyset];
+}
+EXPORT_SYMBOL_GPL(vcap_keyset_name);
+
+/* map key field id to a string with the key name */
+const char *vcap_keyfield_name(struct vcap_control *vctrl,
+			       enum vcap_key_field key)
+{
+	return vctrl->stats->keyfield_names[key];
+}
+EXPORT_SYMBOL_GPL(vcap_keyfield_name);
+
+/* Return the keyfield that matches a key in a keyset */
+static const struct vcap_field *
+vcap_find_keyset_keyfield(struct vcap_control *vctrl,
+			  enum vcap_type vtype,
+			  enum vcap_keyfield_set keyset,
+			  enum vcap_key_field key)
+{
+	const struct vcap_field *fields;
+	int idx, count;
+
+	fields = vcap_keyfields(vctrl, vtype, keyset);
+	if (!fields)
+		return NULL;
+
+	/* Iterate the keyfields of the keyset */
+	count = vcap_keyfield_count(vctrl, vtype, keyset);
+	for (idx = 0; idx < count; ++idx) {
+		if (fields[idx].width == 0)
+			continue;
+
+		if (key == idx)
+			return &fields[idx];
+	}
+
+	return NULL;
+}
+
+/* Match a list of keys against the keysets available in a vcap type */
+static bool vcap_rule_find_keysets(struct vcap_rule_internal *ri,
+				   struct vcap_keyset_list *matches)
+{
+	const struct vcap_client_keyfield *ckf;
+	int keyset, found, keycount, map_size;
+	const struct vcap_field **map;
+	enum vcap_type vtype;
+
+	vtype = ri->admin->vtype;
+	map = ri->vctrl->vcaps[vtype].keyfield_set_map;
+	map_size = ri->vctrl->vcaps[vtype].keyfield_set_size;
+
+	/* Get a count of the keyfields we want to match */
+	keycount = 0;
+	list_for_each_entry(ckf, &ri->data.keyfields, ctrl.list)
+		++keycount;
+
+	matches->cnt = 0;
+	/* Iterate the keysets of the VCAP */
+	for (keyset = 0; keyset < map_size; ++keyset) {
+		if (!map[keyset])
+			continue;
+
+		/* Iterate the keys in the rule */
+		found = 0;
+		list_for_each_entry(ckf, &ri->data.keyfields, ctrl.list)
+			if (vcap_find_keyset_keyfield(ri->vctrl, vtype,
+						      keyset, ckf->ctrl.key))
+				++found;
+
+		/* Save the keyset if all keyfields were found */
+		if (found == keycount)
+			if (!vcap_keyset_list_add(matches, keyset))
+				/* bail out when the quota is filled */
+				break;
+	}
+
+	return matches->cnt > 0;
+}
+
 /* Validate a rule with respect to available port keys */
 int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
 {
 	struct vcap_rule_internal *ri = to_intrule(rule);
+	struct vcap_keyset_list matches = {};
 	enum vcap_keyfield_set keysets[10];
-	struct vcap_keyset_list kslist;
 	int ret;
 
-	/* This validation will be much expanded later */
 	ret = vcap_api_check(ri->vctrl);
 	if (ret)
 		return ret;
@@ -724,24 +824,41 @@ int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
 		ri->data.exterr = VCAP_ERR_NO_NETDEV;
 		return -EINVAL;
 	}
+
+	matches.keysets = keysets;
+	matches.max = ARRAY_SIZE(keysets);
 	if (ri->data.keyset == VCAP_KFS_NO_VALUE) {
-		ri->data.exterr = VCAP_ERR_NO_KEYSET_MATCH;
-		return -EINVAL;
+		/* Iterate over rule keyfields and select keysets that fits */
+		if (!vcap_rule_find_keysets(ri, &matches)) {
+			ri->data.exterr = VCAP_ERR_NO_KEYSET_MATCH;
+			return -EINVAL;
+		}
+	} else {
+		/* prepare for keyset validation */
+		keysets[0] = ri->data.keyset;
+		matches.cnt = 1;
 	}
-	/* prepare for keyset validation */
-	keysets[0] = ri->data.keyset;
-	kslist.keysets = keysets;
-	kslist.cnt = 1;
+
 	/* Pick a keyset that is supported in the port lookups */
-	ret = ri->vctrl->ops->validate_keyset(ri->ndev, ri->admin, rule, &kslist,
-					      l3_proto);
+	ret = ri->vctrl->ops->validate_keyset(ri->ndev, ri->admin, rule,
+					      &matches, l3_proto);
 	if (ret < 0) {
 		pr_err("%s:%d: keyset validation failed: %d\n",
 		       __func__, __LINE__, ret);
 		ri->data.exterr = VCAP_ERR_NO_PORT_KEYSET_MATCH;
 		return ret;
 	}
+	/* use the keyset that is supported in the port lookups */
+	ret = vcap_set_rule_set_keyset(rule, ret);
+	if (ret < 0) {
+		pr_err("%s:%d: keyset was not updated: %d\n",
+		       __func__, __LINE__, ret);
+		return ret;
+	}
 	if (ri->data.actionset == VCAP_AFS_NO_VALUE) {
+		/* Later also actionsets will be matched against actions in
+		 * the rule, and the type will be set accordingly
+		 */
 		ri->data.exterr = VCAP_ERR_NO_ACTIONSET_MATCH;
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 577395402a9a..959e125baa3f 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -201,4 +201,15 @@ void vcap_set_tc_exterr(struct flow_cls_offload *fco, struct vcap_rule *vrule);
 /* Cleanup a VCAP instance */
 int vcap_del_rules(struct vcap_control *vctrl, struct vcap_admin *admin);
 
+/* Add a keyset to a keyset list */
+bool vcap_keyset_list_add(struct vcap_keyset_list *keysetlist,
+			  enum vcap_keyfield_set keyset);
+
+/* map keyset id to a string with the keyset name */
+const char *vcap_keyset_name(struct vcap_control *vctrl,
+			     enum vcap_keyfield_set keyset);
+/* map key field id to a string with the key name */
+const char *vcap_keyfield_name(struct vcap_control *vctrl,
+			       enum vcap_key_field key);
+
 #endif /* __VCAP_API_CLIENT__ */
-- 
2.38.1

