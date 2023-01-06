Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA70665FD2A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 09:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbjAFIzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 03:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjAFIy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 03:54:57 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5096F944;
        Fri,  6 Jan 2023 00:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672995236; x=1704531236;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZnOu0sD1u1nN6UilL4C+YFt71fxsv2RM0zKR2zAD53U=;
  b=S4uDDKEp2QM/Htwi5b9y4kc/SVSqC1iQmC5XaczAzi0AUoYPlEbT2Q5E
   b0HDPjufHx3XteJvhiy8x6dAlgG2Put/BoPfJAQCc2NqXpH/vsYIS/qXX
   jdZe2i8cR7Vr7L0mVGuq/9p+cy9c3S6EXNbBOxGSKtpMaf0WQ1sNiIggJ
   obsGmC/NgoXLDl1QrvCvKqx1rlp3b5kUbFX6H6F6G2faTAiuEKmYRs0th
   Mw0ptmmXg/XGbbUyU5hn2Ulk2s/ddpvam5b4QrPHkXDE5ES4YBYpOmiaj
   enQh8tQMphWeQftj9dWjbuCgpznLf0LYbBfMizDUILmutuU2DYxuBMoum
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="206646911"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jan 2023 01:53:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 01:53:55 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 01:53:51 -0700
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
Subject: [PATCH net-next v2 7/8] net: microchip: vcap api: Add a storage state to a VCAP rule
Date:   Fri, 6 Jan 2023 09:53:16 +0100
Message-ID: <20230106085317.1720282-8-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230106085317.1720282-1-steen.hegelund@microchip.com>
References: <20230106085317.1720282-1-steen.hegelund@microchip.com>
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

This allows a VCAP rule to be in one of 3 states:

- permanently stored in the VCAP HW (for rules that must always be present)
- enabled (stored in HW) when the corresponding lookup has been enabled
- disabled (stored in SW) when the lookup is disabled

This way important VCAP rules can be added even before the user enables the
VCAP lookups using a TC matchall filter.

Fixes: 4426b78c626d ("net: lan966x: Add port keyset config and callback interface")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 126 ++++++++++++++++--
 .../microchip/vcap/vcap_api_debugfs.c         |  52 +++++---
 .../microchip/vcap/vcap_api_debugfs_kunit.c   |   1 +
 .../microchip/vcap/vcap_api_private.h         |   9 +-
 4 files changed, 161 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 2cc6e94077a4..9226968d32dc 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -950,9 +950,12 @@ int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie)
 }
 EXPORT_SYMBOL_GPL(vcap_lookup_rule_by_cookie);
 
-/* Make a shallow copy of the rule without the fields */
-struct vcap_rule_internal *vcap_dup_rule(struct vcap_rule_internal *ri)
+/* Make a copy of the rule, shallow or full */
+static struct vcap_rule_internal *vcap_dup_rule(struct vcap_rule_internal *ri,
+						bool full)
 {
+	struct vcap_client_actionfield *caf, *newcaf;
+	struct vcap_client_keyfield *ckf, *newckf;
 	struct vcap_rule_internal *duprule;
 
 	/* Allocate the client part */
@@ -965,6 +968,27 @@ struct vcap_rule_internal *vcap_dup_rule(struct vcap_rule_internal *ri)
 	/* No elements in these lists */
 	INIT_LIST_HEAD(&duprule->data.keyfields);
 	INIT_LIST_HEAD(&duprule->data.actionfields);
+
+	/* A full rule copy includes keys and actions */
+	if (!full)
+		return duprule;
+
+	list_for_each_entry(ckf, &ri->data.keyfields, ctrl.list) {
+		newckf = kzalloc(sizeof(*newckf), GFP_KERNEL);
+		if (!newckf)
+			return ERR_PTR(-ENOMEM);
+		memcpy(newckf, ckf, sizeof(*newckf));
+		list_add_tail(&newckf->ctrl.list, &duprule->data.keyfields);
+	}
+
+	list_for_each_entry(caf, &ri->data.actionfields, ctrl.list) {
+		newcaf = kzalloc(sizeof(*newcaf), GFP_KERNEL);
+		if (!newcaf)
+			return ERR_PTR(-ENOMEM);
+		memcpy(newcaf, caf, sizeof(*newcaf));
+		list_add_tail(&newcaf->ctrl.list, &duprule->data.actionfields);
+	}
+
 	return duprule;
 }
 
@@ -1877,8 +1901,8 @@ static int vcap_insert_rule(struct vcap_rule_internal *ri,
 		ri->addr = vcap_next_rule_addr(admin->last_used_addr, ri);
 		admin->last_used_addr = ri->addr;
 
-		/* Add a shallow copy of the rule to the VCAP list */
-		duprule = vcap_dup_rule(ri);
+		/* Add a copy of the rule to the VCAP list */
+		duprule = vcap_dup_rule(ri, ri->state == VCAP_RS_DISABLED);
 		if (IS_ERR(duprule))
 			return PTR_ERR(duprule);
 
@@ -1891,8 +1915,8 @@ static int vcap_insert_rule(struct vcap_rule_internal *ri,
 	ri->addr = vcap_next_rule_addr(addr, ri);
 	addr = ri->addr;
 
-	/* Add a shallow copy of the rule to the VCAP list */
-	duprule = vcap_dup_rule(ri);
+	/* Add a copy of the rule to the VCAP list */
+	duprule = vcap_dup_rule(ri, ri->state == VCAP_RS_DISABLED);
 	if (IS_ERR(duprule))
 		return PTR_ERR(duprule);
 
@@ -1939,6 +1963,72 @@ static bool vcap_is_chain_used(struct vcap_control *vctrl,
 	return false;
 }
 
+/* Fetch the next chain in the enabled list for the port */
+static int vcap_get_next_chain(struct vcap_control *vctrl,
+			       struct net_device *ndev,
+			       int dst_cid)
+{
+	struct vcap_enabled_port *eport;
+	struct vcap_admin *admin;
+
+	list_for_each_entry(admin, &vctrl->list, list) {
+		list_for_each_entry(eport, &admin->enabled, list) {
+			if (eport->ndev != ndev)
+				continue;
+			if (eport->src_cid == dst_cid)
+				return eport->dst_cid;
+		}
+	}
+
+	return 0;
+}
+
+static bool vcap_path_exist(struct vcap_control *vctrl, struct net_device *ndev,
+			    int dst_cid)
+{
+	struct vcap_enabled_port *eport, *elem;
+	struct vcap_admin *admin;
+	int tmp;
+
+	/* Find first entry that starts from chain 0*/
+	list_for_each_entry(admin, &vctrl->list, list) {
+		list_for_each_entry(elem, &admin->enabled, list) {
+			if (elem->src_cid == 0 && elem->ndev == ndev) {
+				eport = elem;
+				break;
+			}
+		}
+		if (eport)
+			break;
+	}
+
+	if (!eport)
+		return false;
+
+	tmp = eport->dst_cid;
+	while (tmp != dst_cid && tmp != 0)
+		tmp = vcap_get_next_chain(vctrl, ndev, tmp);
+
+	return !!tmp;
+}
+
+/* Internal clients can always store their rules in HW
+ * External clients can store their rules if the chain is enabled all
+ * the way from chain 0, otherwise the rule will be cached until
+ * the chain is enabled.
+ */
+static void vcap_rule_set_state(struct vcap_rule_internal *ri)
+{
+	if (ri->data.user <= VCAP_USER_QOS)
+		ri->state = VCAP_RS_PERMANENT;
+	else if (vcap_path_exist(ri->vctrl, ri->ndev, ri->data.vcap_chain_id))
+		ri->state = VCAP_RS_ENABLED;
+	else
+		ri->state = VCAP_RS_DISABLED;
+	/* For now always store directly in HW */
+	ri->state = VCAP_RS_PERMANENT;
+}
+
 /* Encode and write a validated rule to the VCAP */
 int vcap_add_rule(struct vcap_rule *rule)
 {
@@ -1952,6 +2042,8 @@ int vcap_add_rule(struct vcap_rule *rule)
 		return ret;
 	/* Insert the new rule in the list of vcap rules */
 	mutex_lock(&ri->admin->lock);
+
+	vcap_rule_set_state(ri);
 	ret = vcap_insert_rule(ri, &move);
 	if (ret < 0) {
 		pr_err("%s:%d: could not insert rule in vcap list: %d\n",
@@ -1960,6 +2052,13 @@ int vcap_add_rule(struct vcap_rule *rule)
 	}
 	if (move.count > 0)
 		vcap_move_rules(ri, &move);
+
+	if (ri->state == VCAP_RS_DISABLED) {
+		/* Erase the rule area */
+		ri->vctrl->ops->init(ri->ndev, ri->admin, ri->addr, ri->size);
+		goto out;
+	}
+
 	vcap_erase_cache(ri);
 	ret = vcap_encode_rule(ri);
 	if (ret) {
@@ -2071,9 +2170,13 @@ struct vcap_rule *vcap_get_rule(struct vcap_control *vctrl, u32 id)
 	if (!elem)
 		return NULL;
 	mutex_lock(&elem->admin->lock);
-	ri = vcap_dup_rule(elem);
+	ri = vcap_dup_rule(elem, elem->state == VCAP_RS_DISABLED);
 	if (IS_ERR(ri))
 		goto unlock;
+
+	if (ri->state == VCAP_RS_DISABLED)
+		goto unlock;
+
 	err = vcap_read_rule(ri);
 	if (err) {
 		ri = ERR_PTR(err);
@@ -2111,6 +2214,11 @@ int vcap_mod_rule(struct vcap_rule *rule)
 		return -ENOENT;
 
 	mutex_lock(&ri->admin->lock);
+
+	vcap_rule_set_state(ri);
+	if (ri->state == VCAP_RS_DISABLED)
+		goto out;
+
 	/* Encode the bitstreams to the VCAP cache */
 	vcap_erase_cache(ri);
 	err = vcap_encode_rule(ri);
@@ -2203,7 +2311,7 @@ int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id)
 	mutex_lock(&admin->lock);
 	list_del(&ri->list);
 	vctrl->ops->init(ndev, admin, admin->last_used_addr, ri->size + gap);
-	kfree(ri);
+	vcap_free_rule(&ri->data);
 	mutex_unlock(&admin->lock);
 
 	/* Update the last used address, set to default when no rules */
@@ -2232,7 +2340,7 @@ int vcap_del_rules(struct vcap_control *vctrl, struct vcap_admin *admin)
 	list_for_each_entry_safe(ri, next_ri, &admin->rules, list) {
 		vctrl->ops->init(ri->ndev, admin, ri->addr, ri->size);
 		list_del(&ri->list);
-		kfree(ri);
+		vcap_free_rule(&ri->data);
 	}
 	admin->last_used_addr = admin->last_valid_addr;
 
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index e0b206247f2e..d6a09ce75e4f 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -152,37 +152,45 @@ vcap_debugfs_show_rule_actionfield(struct vcap_control *vctrl,
 	out->prf(out->dst, "\n");
 }
 
-static int vcap_debugfs_show_rule_keyset(struct vcap_rule_internal *ri,
-					 struct vcap_output_print *out)
+static int vcap_debugfs_show_keysets(struct vcap_rule_internal *ri,
+				     struct vcap_output_print *out)
 {
-	struct vcap_control *vctrl = ri->vctrl;
 	struct vcap_admin *admin = ri->admin;
 	enum vcap_keyfield_set keysets[10];
-	const struct vcap_field *keyfield;
-	enum vcap_type vt = admin->vtype;
-	struct vcap_client_keyfield *ckf;
 	struct vcap_keyset_list matches;
-	u32 *maskstream;
-	u32 *keystream;
-	int res;
+	int err;
 
-	keystream = admin->cache.keystream;
-	maskstream = admin->cache.maskstream;
 	matches.keysets = keysets;
 	matches.cnt = 0;
 	matches.max = ARRAY_SIZE(keysets);
-	res = vcap_find_keystream_keysets(vctrl, vt, keystream, maskstream,
+
+	err = vcap_find_keystream_keysets(ri->vctrl, admin->vtype,
+					  admin->cache.keystream,
+					  admin->cache.maskstream,
 					  false, 0, &matches);
-	if (res < 0) {
+	if (err) {
 		pr_err("%s:%d: could not find valid keysets: %d\n",
-		       __func__, __LINE__, res);
-		return -EINVAL;
+		       __func__, __LINE__, err);
+		return err;
 	}
+
 	out->prf(out->dst, "  keysets:");
 	for (int idx = 0; idx < matches.cnt; ++idx)
 		out->prf(out->dst, " %s",
-			 vcap_keyset_name(vctrl, matches.keysets[idx]));
+			 vcap_keyset_name(ri->vctrl, matches.keysets[idx]));
 	out->prf(out->dst, "\n");
+	return 0;
+}
+
+static int vcap_debugfs_show_rule_keyset(struct vcap_rule_internal *ri,
+					 struct vcap_output_print *out)
+{
+	struct vcap_control *vctrl = ri->vctrl;
+	struct vcap_admin *admin = ri->admin;
+	const struct vcap_field *keyfield;
+	struct vcap_client_keyfield *ckf;
+
+	vcap_debugfs_show_keysets(ri, out);
 	out->prf(out->dst, "  keyset_sw: %d\n", ri->keyset_sw);
 	out->prf(out->dst, "  keyset_sw_regs: %d\n", ri->keyset_sw_regs);
 
@@ -233,6 +241,18 @@ static void vcap_show_admin_rule(struct vcap_control *vctrl,
 	out->prf(out->dst, "  chain_id: %d\n", ri->data.vcap_chain_id);
 	out->prf(out->dst, "  user: %d\n", ri->data.user);
 	out->prf(out->dst, "  priority: %d\n", ri->data.priority);
+	out->prf(out->dst, "  state: ");
+	switch (ri->state) {
+	case VCAP_RS_PERMANENT:
+		out->prf(out->dst, "permanent\n");
+		break;
+	case VCAP_RS_DISABLED:
+		out->prf(out->dst, "disabled\n");
+		break;
+	case VCAP_RS_ENABLED:
+		out->prf(out->dst, "enabled\n");
+		break;
+	}
 	vcap_debugfs_show_rule_keyset(ri, out);
 	vcap_debugfs_show_rule_actionset(ri, out);
 }
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
index bef0b28a4a50..9211cb453a3d 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
@@ -445,6 +445,7 @@ static const char * const test_admin_expect[] = {
 	"  chain_id: 0\n",
 	"  user: 0\n",
 	"  priority: 0\n",
+	"  state: permanent\n",
 	"  keysets: VCAP_KFS_MAC_ETYPE\n",
 	"  keyset_sw: 6\n",
 	"  keyset_sw_regs: 2\n",
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
index 4fd21da97679..ce35af9a853d 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
@@ -13,6 +13,12 @@
 
 #define to_intrule(rule) container_of((rule), struct vcap_rule_internal, data)
 
+enum vcap_rule_state {
+	VCAP_RS_PERMANENT, /* the rule is always stored in HW */
+	VCAP_RS_ENABLED, /* enabled in HW but can be disabled */
+	VCAP_RS_DISABLED, /* disabled (stored in SW) and can be enabled */
+};
+
 /* Private VCAP API rule data */
 struct vcap_rule_internal {
 	struct vcap_rule data; /* provided by the client */
@@ -29,6 +35,7 @@ struct vcap_rule_internal {
 	u32 addr; /* address in the VCAP at insertion */
 	u32 counter_id; /* counter id (if a dedicated counter is available) */
 	struct vcap_counter counter; /* last read counter value */
+	enum vcap_rule_state state;  /* rule storage state */
 };
 
 /* Bit iterator for the VCAP cache streams */
@@ -43,8 +50,6 @@ struct vcap_stream_iter {
 
 /* Check that the control has a valid set of callbacks */
 int vcap_api_check(struct vcap_control *ctrl);
-/* Make a shallow copy of the rule without the fields */
-struct vcap_rule_internal *vcap_dup_rule(struct vcap_rule_internal *ri);
 /* Erase the VCAP cache area used or encoding and decoding */
 void vcap_erase_cache(struct vcap_rule_internal *ri);
 
-- 
2.39.0

