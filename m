Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1DE602A3C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 13:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiJRLdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 07:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiJRLcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 07:32:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5942EB97A2;
        Tue, 18 Oct 2022 04:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666092757; x=1697628757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K5DgQrBrss2cbC17yB9DXnyMb4btsqETKXF2LDbPfJA=;
  b=B+Z1C3vfnUSHzAYiAd/7WZal+YLWevw2QF0s4oqCugDtKG1zMp5rFE+w
   fx3NorMJE7RBjUGSQffmYyKLmVNLglSMhECOakrFRv50mKme2YlImoW95
   LhzHbX55diWXVCv3aQYdhOsd5t0qvVyLx6OAR2Ssz7j7m3Iou7+2ZW7Pv
   9YMyGUwYtj66PZbj8tjar/5XawdfXvTJS5cfWP5xQ4p8p4kQWJwpr1z0F
   uvBhXAauRG1T3tDvjDYUf7D/Ngg0zCJythkOJtetP8/M5/giOtkgD6u0t
   dBB/ATLmWcQP7LYt0UdsHr5FiuVJCys0j+E0RxSbnQrbp8fzN9TO+vpwk
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="179327398"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Oct 2022 04:32:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 18 Oct 2022 04:32:30 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 18 Oct 2022 04:32:28 -0700
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
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next 6/9] net: microchip: sparx5: Adding basic rule management in VCAP API
Date:   Tue, 18 Oct 2022 13:31:53 +0200
Message-ID: <20221018113156.2364533-7-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221018113156.2364533-1-steen.hegelund@microchip.com>
References: <20221018113156.2364533-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides most of the rule handling needed to add a new rule to a VCAP.
To add a rule a client must follow these steps:

1) Allocate a new rule (provide an id or get one automatically assigned)
2) Add keys to the rule
3) Add actions to the rule
4) Optionally set a keyset on the rule
5) Optionally set an actionset on the rule
6) Validate the rule (this will add keyset and actionset if not specified
   in the previous steps)
7) Add the rule (if the validation was successful)
8) Free the rule instance (a copy has been added to the VCAP)

The validation step will fail if there are no keysets with the requested
keys, or there are no actionsets with the requested actions.
The validation will also fail if the keyset is not configured for the port
for the requested protocol).

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_vcap_impl.c       |   1 +
 .../net/ethernet/microchip/vcap/vcap_api.c    | 320 +++++++++++++++++-
 .../ethernet/microchip/vcap/vcap_api_client.h |   3 +
 3 files changed, 316 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index dbd2c2c4d346..50153264179e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -519,6 +519,7 @@ void sparx5_vcap_destroy(struct sparx5 *sparx5)
 
 	list_for_each_entry_safe(admin, admin_next, &ctrl->list, list) {
 		sparx5_vcap_port_key_deselection(sparx5, admin);
+		vcap_del_rules(ctrl, admin);
 		list_del(&admin->list);
 		sparx5_vcap_admin_free(admin);
 	}
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index d929d2d00b6c..7f5ec072681c 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -18,9 +18,22 @@ struct vcap_rule_internal {
 	struct vcap_admin *admin; /* vcap hw instance */
 	struct net_device *ndev;  /* the interface that the rule applies to */
 	struct vcap_control *vctrl; /* the client control */
+	u32 sort_key;  /* defines the position in the VCAP */
+	int keyset_sw;  /* subwords in a keyset */
+	int actionset_sw;  /* subwords in an actionset */
+	int keyset_sw_regs;  /* registers in a subword in an keyset */
+	int actionset_sw_regs;  /* registers in a subword in an actionset */
+	int size; /* the size of the rule: max(entry, action) */
 	u32 addr; /* address in the VCAP at insertion */
 };
 
+/* Moving a rule in the VCAP address space */
+struct vcap_rule_move {
+	int addr; /* address to move */
+	int offset; /* change in address */
+	int count; /* blocksize of addresses to move */
+};
+
 /* Return the list of keyfields for the keyset */
 static const struct vcap_field *vcap_keyfields(struct vcap_control *vctrl,
 					       enum vcap_type vt,
@@ -32,12 +45,82 @@ static const struct vcap_field *vcap_keyfields(struct vcap_control *vctrl,
 	return vctrl->vcaps[vt].keyfield_set_map[keyset];
 }
 
+/* Return the keyset information for the keyset */
+static const struct vcap_set *vcap_keyfieldset(struct vcap_control *vctrl,
+					       enum vcap_type vt,
+					       enum vcap_keyfield_set keyset)
+{
+	const struct vcap_set *kset;
+
+	/* Check that the keyset exists in the vcap keyset list */
+	if (keyset >= vctrl->vcaps[vt].keyfield_set_size)
+		return NULL;
+	kset = &vctrl->vcaps[vt].keyfield_set[keyset];
+	if (kset->sw_per_item == 0 || kset->sw_per_item > vctrl->vcaps[vt].sw_count)
+		return NULL;
+	return kset;
+}
+
+static const struct vcap_set *
+vcap_actionfieldset(struct vcap_control *vctrl,
+		    enum vcap_type vt, enum vcap_actionfield_set actionset)
+{
+	const struct vcap_set *aset;
+
+	/* Check that the actionset exists in the vcap actionset list */
+	if (actionset >= vctrl->vcaps[vt].actionfield_set_size)
+		return NULL;
+	aset = &vctrl->vcaps[vt].actionfield_set[actionset];
+	if (aset->sw_per_item == 0 || aset->sw_per_item > vctrl->vcaps[vt].sw_count)
+		return NULL;
+	return aset;
+}
+
+static int vcap_encode_rule(struct vcap_rule_internal *ri)
+{
+	/* Encoding of keyset and actionsets will be added later */
+	return 0;
+}
+
+static int vcap_api_check(struct vcap_control *ctrl)
+{
+	if (!ctrl) {
+		pr_err("%s:%d: vcap control is missing\n", __func__, __LINE__);
+		return -EINVAL;
+	}
+	if (!ctrl->ops || !ctrl->ops->validate_keyset ||
+	    !ctrl->ops->add_default_fields || !ctrl->ops->cache_erase ||
+	    !ctrl->ops->cache_write || !ctrl->ops->cache_read ||
+	    !ctrl->ops->init || !ctrl->ops->update || !ctrl->ops->move ||
+	    !ctrl->ops->port_info) {
+		pr_err("%s:%d: client operations are missing\n",
+		       __func__, __LINE__);
+		return -ENOENT;
+	}
+	return 0;
+}
+
+static void vcap_erase_cache(struct vcap_rule_internal *ri)
+{
+	ri->vctrl->ops->cache_erase(ri->admin);
+}
+
 /* Update the keyset for the rule */
 int vcap_set_rule_set_keyset(struct vcap_rule *rule,
 			     enum vcap_keyfield_set keyset)
 {
-	/* This will be expanded with more information later */
-	rule->keyset = keyset;
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	const struct vcap_set *kset;
+	int sw_width;
+
+	kset = vcap_keyfieldset(ri->vctrl, ri->admin->vtype, keyset);
+	/* Check that the keyset is valid */
+	if (!kset)
+		return -EINVAL;
+	ri->keyset_sw = kset->sw_per_item;
+	sw_width = ri->vctrl->vcaps[ri->admin->vtype].sw_width;
+	ri->keyset_sw_regs = DIV_ROUND_UP(sw_width, 32);
+	ri->data.keyset = keyset;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vcap_set_rule_set_keyset);
@@ -46,8 +129,18 @@ EXPORT_SYMBOL_GPL(vcap_set_rule_set_keyset);
 int vcap_set_rule_set_actionset(struct vcap_rule *rule,
 				enum vcap_actionfield_set actionset)
 {
-	/* This will be expanded with more information later */
-	rule->actionset = actionset;
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	const struct vcap_set *aset;
+	int act_width;
+
+	aset = vcap_actionfieldset(ri->vctrl, ri->admin->vtype, actionset);
+	/* Check that the actionset is valid */
+	if (!aset)
+		return -EINVAL;
+	ri->actionset_sw = aset->sw_per_item;
+	act_width = ri->vctrl->vcaps[ri->admin->vtype].act_width;
+	ri->actionset_sw_regs = DIV_ROUND_UP(act_width, 32);
+	ri->data.actionset = actionset;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vcap_set_rule_set_actionset);
@@ -82,11 +175,59 @@ int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie)
 }
 EXPORT_SYMBOL_GPL(vcap_lookup_rule_by_cookie);
 
+/* Make a shallow copy of the rule without the fields */
+static struct vcap_rule_internal *vcap_dup_rule(struct vcap_rule_internal *ri)
+{
+	struct vcap_rule_internal *duprule;
+
+	/* Allocate the client part */
+	duprule = kzalloc(sizeof(*duprule), GFP_KERNEL);
+	if (!duprule)
+		return ERR_PTR(-ENOMEM);
+	*duprule = *ri;
+	/* Not inserted in the VCAP */
+	INIT_LIST_HEAD(&duprule->list);
+	/* No elements in these lists */
+	INIT_LIST_HEAD(&duprule->data.keyfields);
+	INIT_LIST_HEAD(&duprule->data.actionfields);
+	return duprule;
+}
+
+/* Write VCAP cache content to the VCAP HW instance */
+static int vcap_write_rule(struct vcap_rule_internal *ri)
+{
+	struct vcap_admin *admin = ri->admin;
+	int sw_idx, ent_idx = 0, act_idx = 0;
+	u32 addr = ri->addr;
+
+	if (!ri->size || !ri->keyset_sw_regs || !ri->actionset_sw_regs) {
+		pr_err("%s:%d: rule is empty\n", __func__, __LINE__);
+		return -EINVAL;
+	}
+	/* Use the values in the streams to write the VCAP cache */
+	for (sw_idx = 0; sw_idx < ri->size; sw_idx++, addr++) {
+		ri->vctrl->ops->cache_write(ri->ndev, admin,
+					VCAP_SEL_ENTRY, ent_idx,
+					ri->keyset_sw_regs);
+		ri->vctrl->ops->cache_write(ri->ndev, admin,
+					VCAP_SEL_ACTION, act_idx,
+					ri->actionset_sw_regs);
+		ri->vctrl->ops->update(ri->ndev, admin, VCAP_CMD_WRITE,
+				   VCAP_SEL_ALL, addr);
+		ent_idx += ri->keyset_sw_regs;
+		act_idx += ri->actionset_sw_regs;
+	}
+	return 0;
+}
+
 /* Lookup a vcap instance using chain id */
 struct vcap_admin *vcap_find_admin(struct vcap_control *vctrl, int cid)
 {
 	struct vcap_admin *admin;
 
+	if (vcap_api_check(vctrl))
+		return NULL;
+
 	list_for_each_entry(admin, &vctrl->list, list) {
 		if (cid >= admin->first_cid && cid <= admin->last_cid)
 			return admin;
@@ -95,12 +236,62 @@ struct vcap_admin *vcap_find_admin(struct vcap_control *vctrl, int cid)
 }
 EXPORT_SYMBOL_GPL(vcap_find_admin);
 
+/* Check if there is room for a new rule */
+static int vcap_rule_space(struct vcap_admin *admin, int size)
+{
+	if (admin->last_used_addr - size < admin->first_valid_addr) {
+		pr_err("%s:%d: No room for rule size: %u, %u\n",
+		       __func__, __LINE__, size, admin->first_valid_addr);
+		return -ENOSPC;
+	}
+	return 0;
+}
+
+/* Add the keyset typefield to the list of rule keyfields */
+static int vcap_add_type_keyfield(struct vcap_rule *rule)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	enum vcap_keyfield_set keyset = rule->keyset;
+	enum vcap_type vt = ri->admin->vtype;
+	const struct vcap_field *fields;
+	const struct vcap_set *kset;
+	int ret = -EINVAL;
+
+	kset = vcap_keyfieldset(ri->vctrl, vt, keyset);
+	if (!kset)
+		return ret;
+	if (kset->type_id == (u8)-1)  /* No type field is needed */
+		return 0;
+
+	fields = vcap_keyfields(ri->vctrl, vt, keyset);
+	if (!fields)
+		return -EINVAL;
+	if (fields[VCAP_KF_TYPE].width > 1) {
+		ret = vcap_rule_add_key_u32(rule, VCAP_KF_TYPE,
+					    kset->type_id, 0xff);
+	} else {
+		if (kset->type_id)
+			ret = vcap_rule_add_key_bit(rule, VCAP_KF_TYPE,
+						    VCAP_BIT_1);
+		else
+			ret = vcap_rule_add_key_bit(rule, VCAP_KF_TYPE,
+						    VCAP_BIT_0);
+	}
+	return 0;
+}
+
 /* Validate a rule with respect to available port keys */
 int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
 {
 	struct vcap_rule_internal *ri = to_intrule(rule);
+	enum vcap_keyfield_set keysets[10];
+	struct vcap_keyset_list kslist;
+	int ret;
 
 	/* This validation will be much expanded later */
+	ret = vcap_api_check(ri->vctrl);
+	if (ret)
+		return ret;
 	if (!ri->admin) {
 		ri->data.exterr = VCAP_ERR_NO_ADMIN;
 		return -EINVAL;
@@ -113,14 +304,41 @@ int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
 		ri->data.exterr = VCAP_ERR_NO_KEYSET_MATCH;
 		return -EINVAL;
 	}
+	/* prepare for keyset validation */
+	keysets[0] = ri->data.keyset;
+	kslist.keysets = keysets;
+	kslist.cnt = 1;
+	/* Pick a keyset that is supported in the port lookups */
+	ret = ri->vctrl->ops->validate_keyset(ri->ndev, ri->admin, rule, &kslist,
+					      l3_proto);
+	if (ret < 0) {
+		pr_err("%s:%d: keyset validation failed: %d\n",
+		       __func__, __LINE__, ret);
+		ri->data.exterr = VCAP_ERR_NO_PORT_KEYSET_MATCH;
+		return ret;
+	}
 	if (ri->data.actionset == VCAP_AFS_NO_VALUE) {
 		ri->data.exterr = VCAP_ERR_NO_ACTIONSET_MATCH;
 		return -EINVAL;
 	}
-	return 0;
+	vcap_add_type_keyfield(rule);
+	/* Add default fields to this rule */
+	ri->vctrl->ops->add_default_fields(ri->ndev, ri->admin, rule);
+
+	/* Rule size is the maximum of the entry and action subword count */
+	ri->size = max(ri->keyset_sw, ri->actionset_sw);
+
+	/* Finally check if there is room for the rule in the VCAP */
+	return vcap_rule_space(ri->admin, ri->size);
 }
 EXPORT_SYMBOL_GPL(vcap_val_rule);
 
+/* calculate the address of the next rule after this (lower address and prio) */
+static u32 vcap_next_rule_addr(u32 addr, struct vcap_rule_internal *ri)
+{
+	return ((addr - ri->size) /  ri->size) * ri->size;
+}
+
 /* Assign a unique rule id and autogenerate one if id == 0 */
 static u32 vcap_set_rule_id(struct vcap_rule_internal *ri)
 {
@@ -141,11 +359,60 @@ static u32 vcap_set_rule_id(struct vcap_rule_internal *ri)
 	return ri->data.id;
 }
 
+static int vcap_insert_rule(struct vcap_rule_internal *ri,
+			    struct vcap_rule_move *move)
+{
+	struct vcap_admin *admin = ri->admin;
+	struct vcap_rule_internal *duprule;
+
+	/* Only support appending rules for now */
+	ri->addr = vcap_next_rule_addr(admin->last_used_addr, ri);
+	admin->last_used_addr = ri->addr;
+	/* Add a shallow copy of the rule to the VCAP list */
+	duprule = vcap_dup_rule(ri);
+	if (IS_ERR(duprule))
+		return PTR_ERR(duprule);
+	list_add_tail(&duprule->list, &admin->rules);
+	return 0;
+}
+
+static void vcap_move_rules(struct vcap_rule_internal *ri,
+			    struct vcap_rule_move *move)
+{
+	ri->vctrl->ops->move(ri->ndev, ri->admin, move->addr,
+			 move->offset, move->count);
+}
+
 /* Encode and write a validated rule to the VCAP */
 int vcap_add_rule(struct vcap_rule *rule)
 {
-	/* This will later handling the encode and writing of the rule */
-	return 0;
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	struct vcap_rule_move move = {0};
+	int ret;
+
+	ret = vcap_api_check(ri->vctrl);
+	if (ret)
+		return ret;
+	/* Insert the new rule in the list of vcap rules */
+	ret = vcap_insert_rule(ri, &move);
+	if (ret < 0) {
+		pr_err("%s:%d: could not insert rule in vcap list: %d\n",
+		       __func__, __LINE__, ret);
+		goto out;
+	}
+	if (move.count > 0)
+		vcap_move_rules(ri, &move);
+	ret = vcap_encode_rule(ri);
+	if (ret) {
+		pr_err("%s:%d: rule encoding error: %d\n", __func__, __LINE__, ret);
+		goto out;
+	}
+
+	ret = vcap_write_rule(ri);
+	if (ret)
+		pr_err("%s:%d: rule write error: %d\n", __func__, __LINE__, ret);
+out:
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vcap_add_rule);
 
@@ -157,6 +424,7 @@ struct vcap_rule *vcap_alloc_rule(struct vcap_control *vctrl,
 {
 	struct vcap_rule_internal *ri;
 	struct vcap_admin *admin;
+	int maxsize;
 
 	if (!ndev)
 		return ERR_PTR(-ENODEV);
@@ -164,6 +432,16 @@ struct vcap_rule *vcap_alloc_rule(struct vcap_control *vctrl,
 	admin = vcap_find_admin(vctrl, vcap_chain_id);
 	if (!admin)
 		return ERR_PTR(-ENOENT);
+	/* Sanity check that this VCAP is supported on this platform */
+	if (vctrl->vcaps[admin->vtype].rows == 0)
+		return ERR_PTR(-EINVAL);
+	/* Check if a rule with this id already exists */
+	if (vcap_lookup_rule(vctrl, id))
+		return ERR_PTR(-EEXIST);
+	/* Check if there is room for the rule in the block(s) of the VCAP */
+	maxsize = vctrl->vcaps[admin->vtype].sw_count; /* worst case rule size */
+	if (vcap_rule_space(admin, maxsize))
+		return ERR_PTR(-ENOSPC);
 	/* Create a container for the rule and return it */
 	ri = kzalloc(sizeof(*ri), GFP_KERNEL);
 	if (!ri)
@@ -182,6 +460,7 @@ struct vcap_rule *vcap_alloc_rule(struct vcap_control *vctrl,
 	ri->vctrl = vctrl; /* refer to the client */
 	if (vcap_set_rule_id(ri) == 0)
 		goto out_free;
+	vcap_erase_cache(ri);
 	return (struct vcap_rule *)ri;
 
 out_free:
@@ -216,16 +495,23 @@ int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id)
 {
 	struct vcap_rule_internal *ri, *elem;
 	struct vcap_admin *admin;
+	int err;
 
 	/* This will later also handle rule moving */
 	if (!ndev)
 		return -ENODEV;
+	err = vcap_api_check(vctrl);
+	if (err)
+		return err;
 	/* Look for the rule id in all vcaps */
 	ri = vcap_lookup_rule(vctrl, id);
 	if (!ri)
 		return -EINVAL;
 	admin = ri->admin;
 	list_del(&ri->list);
+
+	/* delete the rule in the cache */
+	vctrl->ops->init(ndev, admin, ri->addr, ri->size);
 	if (list_empty(&admin->rules)) {
 		admin->last_used_addr = admin->last_valid_addr;
 	} else {
@@ -238,11 +524,29 @@ int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id)
 }
 EXPORT_SYMBOL_GPL(vcap_del_rule);
 
+/* Delete all rules in the VCAP instance */
+int vcap_del_rules(struct vcap_control *vctrl, struct vcap_admin *admin)
+{
+	struct vcap_rule_internal *ri, *next_ri;
+	int ret = vcap_api_check(vctrl);
+
+	if (ret)
+		return ret;
+	list_for_each_entry_safe(ri, next_ri, &admin->rules, list) {
+		vctrl->ops->init(ri->ndev, admin, ri->addr, ri->size);
+		list_del(&ri->list);
+		kfree(ri);
+	}
+	admin->last_used_addr = admin->last_valid_addr;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vcap_del_rules);
+
 /* Find information on a key field in a rule */
 const struct vcap_field *vcap_lookup_keyfield(struct vcap_rule *rule,
 					      enum vcap_key_field key)
 {
-	struct vcap_rule_internal *ri = (struct vcap_rule_internal *)rule;
+	struct vcap_rule_internal *ri = to_intrule(rule);
 	enum vcap_keyfield_set keyset = rule->keyset;
 	enum vcap_type vt = ri->admin->vtype;
 	const struct vcap_field *fields;
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index b0a2eae81dbe..a8d5072cd6e2 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -189,4 +189,7 @@ const struct vcap_field *vcap_lookup_keyfield(struct vcap_rule *rule,
 /* Find a rule id with a provided cookie */
 int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie);
 
+/* Cleanup a VCAP instance */
+int vcap_del_rules(struct vcap_control *vctrl, struct vcap_admin *admin);
+
 #endif /* __VCAP_API_CLIENT__ */
-- 
2.38.0

