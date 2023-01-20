Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FFA675042
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjATJJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjATJJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:09:14 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011158CE5D;
        Fri, 20 Jan 2023 01:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674205742; x=1705741742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jt+Q5oJjGwTG35LoAKov6X1DYM7Jg5xpkdiyvJfC/PY=;
  b=NGMrN8yp7H/we2mtA5NQWVK7sKCRKyM4VQ6uJvqsDvo9sTvfMrecqcqh
   TK6rEL8lJiDcvUqfjOAzG5ms0M8cMfFZMSsnZ0Kg8G9tLL/nuJ1Y89c6S
   HK1djgrmo1gINj5PtsZQNgBITWiMMq71gwNvIw0Hf+qdxMLDXxUiMX1p6
   TFC7QOSrLzCLYyXpFlJS12sYWhlqF5okB7KT5JdVI5v7yeXg1tVNn3c+K
   +yykoEkOhn8fAl40Td+NMN6WnfnQs6zMjx6hXhY9+y+Tw8yImlrTwBssD
   JwmOiXyjbt7umJvt2MTC6GQKKaGDW//TIJudc1jIZjSM/Gh7tJASWdB5u
   w==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="197598551"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 02:09:01 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 02:08:58 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 02:08:55 -0700
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
Subject: [PATCH net-next 5/8] net: microchip: sparx5: Add TC filter chaining support for IS0 and IS2 VCAPs
Date:   Fri, 20 Jan 2023 10:08:28 +0100
Message-ID: <20230120090831.20032-6-steen.hegelund@microchip.com>
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

This allows rules to be chained between VCAP instances, e.g. from IS0
Lookup 0 to IS0 Lookup 1, or from one of the IS0 Lookups to one of the IS2
Lookups.

Chaining from an IS2 Lookup to another IS2 Lookup is not supported in the
hardware.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 93 ++++++++++++++++++-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 43 ++++++++-
 .../ethernet/microchip/vcap/vcap_api_client.h |  2 +
 3 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index e69b9a85f0f2..54c79c316dd5 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -850,6 +850,84 @@ static int sparx5_tc_set_actionset(struct vcap_admin *admin,
 	return err;
 }
 
+/* Add the VCAP key to match on for a rule target value */
+static int sparx5_tc_add_rule_link_target(struct vcap_admin *admin,
+					  struct vcap_rule *vrule,
+					  int target_cid)
+{
+	int link_val = target_cid % VCAP_CID_LOOKUP_SIZE;
+	int err;
+
+	if (!link_val)
+		return 0;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		/* Add NXT_IDX key for chaining rules between IS0 instances */
+		err = vcap_rule_add_key_u32(vrule, VCAP_KF_LOOKUP_GEN_IDX_SEL,
+					    1, /* enable */
+					    ~0);
+		if (err)
+			return err;
+		return vcap_rule_add_key_u32(vrule, VCAP_KF_LOOKUP_GEN_IDX,
+					     link_val, /* target */
+					     ~0);
+	case VCAP_TYPE_IS2:
+		/* Add PAG key for chaining rules from IS0 */
+		return vcap_rule_add_key_u32(vrule, VCAP_KF_LOOKUP_PAG,
+					     link_val, /* target */
+					     ~0);
+	default:
+		break;
+	}
+	return 0;
+}
+
+/* Add the VCAP action that adds a target value to a rule */
+static int sparx5_tc_add_rule_link(struct vcap_control *vctrl,
+				   struct vcap_admin *admin,
+				   struct vcap_rule *vrule,
+				   int from_cid, int to_cid)
+{
+	struct vcap_admin *to_admin = vcap_find_admin(vctrl, to_cid);
+	int diff, err = 0;
+
+	diff = vcap_chain_offset(vctrl, from_cid, to_cid);
+	if (!(to_admin && diff > 0)) {
+		pr_err("%s:%d: unsupported chain direction: %d\n",
+		       __func__, __LINE__, to_cid);
+		return -EINVAL;
+	}
+	if (admin->vtype == VCAP_TYPE_IS0 &&
+	    to_admin->vtype == VCAP_TYPE_IS0) {
+		/* Between IS0 instances the G_IDX value is used */
+		err = vcap_rule_add_action_u32(vrule, VCAP_AF_NXT_IDX, diff);
+		if (err)
+			goto out;
+		err = vcap_rule_add_action_u32(vrule, VCAP_AF_NXT_IDX_CTRL,
+					       1); /* Replace */
+		if (err)
+			goto out;
+	} else if (admin->vtype == VCAP_TYPE_IS0 &&
+		   to_admin->vtype == VCAP_TYPE_IS2) {
+		/* Between IS0 and IS2 the PAG value is used */
+		err = vcap_rule_add_action_u32(vrule, VCAP_AF_PAG_VAL, diff);
+		if (err)
+			goto out;
+		err = vcap_rule_add_action_u32(vrule,
+					       VCAP_AF_PAG_OVERRIDE_MASK,
+					       0xff);
+		if (err)
+			goto out;
+	} else {
+		pr_err("%s:%d: unsupported chain destination: %d\n",
+		       __func__, __LINE__, to_cid);
+		err = -EOPNOTSUPP;
+	}
+out:
+	return err;
+}
+
 static int sparx5_tc_flower_replace(struct net_device *ndev,
 				    struct flow_cls_offload *fco,
 				    struct vcap_admin *admin)
@@ -885,10 +963,21 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 	if (err)
 		goto out;
 
+	err = sparx5_tc_add_rule_link_target(admin, vrule,
+					     fco->common.chain_index);
+	if (err)
+		goto out;
+
 	frule = flow_cls_offload_flow_rule(fco);
 	flow_action_for_each(idx, act, &frule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_TRAP:
+			if (admin->vtype != VCAP_TYPE_IS2) {
+				NL_SET_ERR_MSG_MOD(fco->common.extack,
+						   "Trap action not supported in this VCAP");
+				err = -EOPNOTSUPP;
+				goto out;
+			}
 			err = vcap_rule_add_action_bit(vrule,
 						       VCAP_AF_CPU_COPY_ENA,
 						       VCAP_BIT_1);
@@ -917,7 +1006,9 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 			err = sparx5_tc_set_actionset(admin, vrule);
 			if (err)
 				goto out;
-			/* Links between VCAPs will be added later */
+			sparx5_tc_add_rule_link(vctrl, admin, vrule,
+						fco->common.chain_index,
+						act->chain_index);
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(fco->common.extack,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 26fa58d4a0cd..e7152cf91680 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1603,6 +1603,40 @@ struct vcap_admin *vcap_find_admin(struct vcap_control *vctrl, int cid)
 }
 EXPORT_SYMBOL_GPL(vcap_find_admin);
 
+/* Is this the last admin instance ordered by chain id */
+static bool vcap_admin_is_last(struct vcap_control *vctrl,
+			       struct vcap_admin *admin)
+{
+	struct vcap_admin *iter, *last = NULL;
+	int max_cid = 0;
+
+	list_for_each_entry(iter, &vctrl->list, list) {
+		if (iter->first_cid > max_cid) {
+			last = iter;
+			max_cid = iter->first_cid;
+		}
+	}
+	if (!last)
+		return false;
+
+	return admin == last;
+}
+
+/* Calculate the value used for chaining VCAP rules */
+int vcap_chain_offset(struct vcap_control *vctrl, int from_cid, int to_cid)
+{
+	int diff = to_cid - from_cid;
+
+	if (diff < 0) /* Wrong direction */
+		return diff;
+	to_cid %= VCAP_CID_LOOKUP_SIZE;
+	if (to_cid == 0)  /* Destination aligned to a lookup == no chaining */
+		return 0;
+	diff %= VCAP_CID_LOOKUP_SIZE;  /* Limit to a value within a lookup */
+	return diff;
+}
+EXPORT_SYMBOL_GPL(vcap_chain_offset);
+
 /* Is the next chain id in one of the following lookups
  * For now this does not support filters linked to other filters using
  * keys and actions. That will be added later.
@@ -2826,6 +2860,7 @@ static int vcap_enable_rule(struct vcap_rule_internal *ri)
 static int vcap_enable_rules(struct vcap_control *vctrl,
 			     struct net_device *ndev, int chain)
 {
+	int next_chain = chain + VCAP_CID_LOOKUP_SIZE;
 	struct vcap_rule_internal *ri;
 	struct vcap_admin *admin;
 	int err = 0;
@@ -2837,8 +2872,11 @@ static int vcap_enable_rules(struct vcap_control *vctrl,
 		/* Found the admin, now find the offloadable rules */
 		mutex_lock(&admin->lock);
 		list_for_each_entry(ri, &admin->rules, list) {
-			if (ri->data.vcap_chain_id != chain)
+			/* Is the rule in the lookup defined by the chain */
+			if (!(ri->data.vcap_chain_id >= chain &&
+			      ri->data.vcap_chain_id < next_chain)) {
 				continue;
+			}
 
 			if (ri->ndev != ndev)
 				continue;
@@ -3055,6 +3093,9 @@ bool vcap_is_last_chain(struct vcap_control *vctrl, int cid)
 	if (!admin)
 		return false;
 
+	if (!vcap_admin_is_last(vctrl, admin))
+		return false;
+
 	/* This must be the last lookup in this VCAP type */
 	lookup = vcap_chain_id_to_lookup(admin, cid);
 	return lookup == admin->lookups - 1;
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 2cdcd3b56b30..69ea230ba8a1 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -217,6 +217,8 @@ const struct vcap_field *vcap_lookup_keyfield(struct vcap_rule *rule,
 					      enum vcap_key_field key);
 /* Find a rule id with a provided cookie */
 int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie);
+/* Calculate the value used for chaining VCAP rules */
+int vcap_chain_offset(struct vcap_control *vctrl, int from_cid, int to_cid);
 /* Is the next chain id in the following lookup, possible in another VCAP */
 bool vcap_is_next_lookup(struct vcap_control *vctrl, int cur_cid, int next_cid);
 /* Is this chain id the last lookup of all VCAPs */
-- 
2.39.1

