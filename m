Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41996625AEC
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 14:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbiKKNFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 08:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbiKKNFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 08:05:45 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30346275E5;
        Fri, 11 Nov 2022 05:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668171945; x=1699707945;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SOHnGIhnQ7MsnOmlSCy+bgSFKgeTg1oB8GLr2mkHikw=;
  b=mGEdJLrULSmdx3n9NN1vKTyPPMtQFV/tb2Ee4v1KHxLrGc8wFdUUVcs+
   sG4Sv8yPUKGTovI+BqKC2CrF/aKoBaffvYlIAepZjPnO3mXuENdptWVPF
   5lgXUHalpycrNOUO1MKNAM5+RYIcbI4tZsKx9y9+q8Yho3vNEehh+7IuT
   UZV+/gwbTEa+63/wos4h0eSBsZIIhjjbHVV+rxdPrCv9EWuGfR+wiF2iZ
   R+J4Kd9dVOvEPC6Q3rJ7TeZaRDUZP8n16Yj+z9Bl/VOkcF8fPKkT9cpaK
   H1VxlGKWgo9evUOiioHIjJmjhWZJpKLfNmgld5G7soXmjCqGCVqEQZA7O
   A==;
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="188613198"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2022 06:05:43 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 11 Nov 2022 06:05:42 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 11 Nov 2022 06:05:38 -0700
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
        Simon Horman <simon.horman@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        "Wojciech Drewek" <wojciech.drewek@intel.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 3/6] net: microchip: sparx5: Add/delete rules in sorted order
Date:   Fri, 11 Nov 2022 14:05:16 +0100
Message-ID: <20221111130519.1459549-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111130519.1459549-1-steen.hegelund@microchip.com>
References: <20221111130519.1459549-1-steen.hegelund@microchip.com>
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

This adds a sorting criteria to rule insertion and deletion.

The criteria is (in the listed order):

- Rule size (largest size first)
- User (based on an enumerated user value)
- Priority (highest priority first, aka lowest value)

When a rule is deleted the other rules may need to be moved to fill the gap
to use the available VCAP address space in the best possible way.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_vcap_impl.c       |  27 +++-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 137 ++++++++++++++++--
 2 files changed, 151 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index db73e2b19dc5..b62c48a3fc45 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -477,7 +477,32 @@ static void sparx5_vcap_update(struct net_device *ndev,
 static void sparx5_vcap_move(struct net_device *ndev, struct vcap_admin *admin,
 			     u32 addr, int offset, int count)
 {
-	/* this will be added later */
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	enum vcap_command cmd;
+	u16 mv_num_pos;
+	u16 mv_size;
+
+	mv_size = count - 1;
+	if (offset > 0) {
+		mv_num_pos = offset - 1;
+		cmd = VCAP_CMD_MOVE_DOWN;
+	} else {
+		mv_num_pos = -offset - 1;
+		cmd = VCAP_CMD_MOVE_UP;
+	}
+	spx5_wr(VCAP_SUPER_CFG_MV_NUM_POS_SET(mv_num_pos) |
+		VCAP_SUPER_CFG_MV_SIZE_SET(mv_size),
+		sparx5, VCAP_SUPER_CFG);
+	spx5_wr(VCAP_SUPER_CTRL_UPDATE_CMD_SET(cmd) |
+		VCAP_SUPER_CTRL_UPDATE_ENTRY_DIS_SET(0) |
+		VCAP_SUPER_CTRL_UPDATE_ACTION_DIS_SET(0) |
+		VCAP_SUPER_CTRL_UPDATE_CNT_DIS_SET(0) |
+		VCAP_SUPER_CTRL_UPDATE_ADDR_SET(addr) |
+		VCAP_SUPER_CTRL_CLEAR_CACHE_SET(false) |
+		VCAP_SUPER_CTRL_UPDATE_SHOT_SET(true),
+		sparx5, VCAP_SUPER_CTRL);
+	sparx5_vcap_wait_super_update(sparx5);
 }
 
 /* Provide port information via a callback interface */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index b6ab6bae28c0..62b675a37a96 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -941,6 +941,16 @@ int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
 }
 EXPORT_SYMBOL_GPL(vcap_val_rule);
 
+/* Entries are sorted with increasing values of sort_key.
+ * I.e. Lowest numerical sort_key is first in list.
+ * In order to locate largest keys first in list we negate the key size with
+ * (max_size - size).
+ */
+static u32 vcap_sort_key(u32 max_size, u32 size, u8 user, u16 prio)
+{
+	return ((max_size - size) << 24) | (user << 16) | prio;
+}
+
 /* calculate the address of the next rule after this (lower address and prio) */
 static u32 vcap_next_rule_addr(u32 addr, struct vcap_rule_internal *ri)
 {
@@ -970,17 +980,67 @@ static u32 vcap_set_rule_id(struct vcap_rule_internal *ri)
 static int vcap_insert_rule(struct vcap_rule_internal *ri,
 			    struct vcap_rule_move *move)
 {
+	int sw_count = ri->vctrl->vcaps[ri->admin->vtype].sw_count;
+	struct vcap_rule_internal *duprule, *iter, *elem = NULL;
 	struct vcap_admin *admin = ri->admin;
-	struct vcap_rule_internal *duprule;
+	u32 addr;
+
+	ri->sort_key = vcap_sort_key(sw_count, ri->size, ri->data.user,
+				     ri->data.priority);
+
+	/* Insert the new rule in the list of rule based on the sort key
+	 * If the rule needs to be  inserted between existing rules then move
+	 * these rules to make room for the new rule and update their start
+	 * address.
+	 */
+	list_for_each_entry(iter, &admin->rules, list) {
+		if (ri->sort_key < iter->sort_key) {
+			elem = iter;
+			break;
+		}
+	}
+
+	if (!elem) {
+		ri->addr = vcap_next_rule_addr(admin->last_used_addr, ri);
+		admin->last_used_addr = ri->addr;
+
+		/* Add a shallow copy of the rule to the VCAP list */
+		duprule = vcap_dup_rule(ri);
+		if (IS_ERR(duprule))
+			return PTR_ERR(duprule);
+
+		list_add_tail(&duprule->list, &admin->rules);
+		return 0;
+	}
+
+	/* Reuse the space of the current rule */
+	addr = elem->addr + elem->size;
+	ri->addr = vcap_next_rule_addr(addr, ri);
+	addr = ri->addr;
 
-	/* Only support appending rules for now */
-	ri->addr = vcap_next_rule_addr(admin->last_used_addr, ri);
-	admin->last_used_addr = ri->addr;
 	/* Add a shallow copy of the rule to the VCAP list */
 	duprule = vcap_dup_rule(ri);
 	if (IS_ERR(duprule))
 		return PTR_ERR(duprule);
-	list_add_tail(&duprule->list, &admin->rules);
+
+	/* Add before the current entry */
+	list_add_tail(&duprule->list, &elem->list);
+
+	/* Update the current rule */
+	elem->addr = vcap_next_rule_addr(addr, elem);
+	addr = elem->addr;
+
+	/* Update the address in the remaining rules in the list */
+	list_for_each_entry_continue(elem, &admin->rules, list) {
+		elem->addr = vcap_next_rule_addr(addr, elem);
+		addr = elem->addr;
+	}
+
+	/* Update the move info */
+	move->addr = admin->last_used_addr;
+	move->count = ri->addr - addr;
+	move->offset = admin->last_used_addr - addr;
+	admin->last_used_addr = addr;
 	return 0;
 }
 
@@ -1032,8 +1092,11 @@ struct vcap_rule *vcap_alloc_rule(struct vcap_control *vctrl,
 {
 	struct vcap_rule_internal *ri;
 	struct vcap_admin *admin;
-	int maxsize;
+	int err, maxsize;
 
+	err = vcap_api_check(vctrl);
+	if (err)
+		return ERR_PTR(err);
 	if (!ndev)
 		return ERR_PTR(-ENODEV);
 	/* Get the VCAP instance */
@@ -1098,12 +1161,57 @@ void vcap_free_rule(struct vcap_rule *rule)
 }
 EXPORT_SYMBOL_GPL(vcap_free_rule);
 
+/* Return the alignment offset for a new rule address */
+static int vcap_valid_rule_move(struct vcap_rule_internal *el, int offset)
+{
+	return (el->addr + offset) % el->size;
+}
+
+/* Update the rule address with an offset */
+static void vcap_adjust_rule_addr(struct vcap_rule_internal *el, int offset)
+{
+	el->addr += offset;
+}
+
+/* Rules needs to be moved to fill the gap of the deleted rule */
+static int vcap_fill_rule_gap(struct vcap_rule_internal *ri)
+{
+	struct vcap_admin *admin = ri->admin;
+	struct vcap_rule_internal *elem;
+	struct vcap_rule_move move;
+	int gap = 0, offset = 0;
+
+	/* If the first rule is deleted: Move other rules to the top */
+	if (list_is_first(&ri->list, &admin->rules))
+		offset = admin->last_valid_addr + 1 - ri->addr - ri->size;
+
+	/* Locate gaps between odd size rules and adjust the move */
+	elem = ri;
+	list_for_each_entry_continue(elem, &admin->rules, list)
+		gap += vcap_valid_rule_move(elem, ri->size);
+
+	/* Update the address in the remaining rules in the list */
+	elem = ri;
+	list_for_each_entry_continue(elem, &admin->rules, list)
+		vcap_adjust_rule_addr(elem, ri->size + gap + offset);
+
+	/* Update the move info */
+	move.addr = admin->last_used_addr;
+	move.count = ri->addr - admin->last_used_addr - gap;
+	move.offset = -(ri->size + gap + offset);
+
+	/* Do the actual move operation */
+	vcap_move_rules(ri, &move);
+
+	return gap + offset;
+}
+
 /* Delete rule in a VCAP instance */
 int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id)
 {
 	struct vcap_rule_internal *ri, *elem;
 	struct vcap_admin *admin;
-	int err;
+	int gap = 0, err;
 
 	/* This will later also handle rule moving */
 	if (!ndev)
@@ -1116,18 +1224,23 @@ int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id)
 	if (!ri)
 		return -EINVAL;
 	admin = ri->admin;
+
+	if (ri->addr > admin->last_used_addr)
+		gap = vcap_fill_rule_gap(ri);
+
+	/* Delete the rule from the list of rules and the cache */
 	list_del(&ri->list);
+	vctrl->ops->init(ndev, admin, admin->last_used_addr, ri->size + gap);
+	kfree(ri);
 
-	/* delete the rule in the cache */
-	vctrl->ops->init(ndev, admin, ri->addr, ri->size);
+	/* Update the last used address */
 	if (list_empty(&admin->rules)) {
 		admin->last_used_addr = admin->last_valid_addr;
 	} else {
-		/* update the address range end marker from the last rule in the list */
-		elem = list_last_entry(&admin->rules, struct vcap_rule_internal, list);
+		elem = list_last_entry(&admin->rules, struct vcap_rule_internal,
+				       list);
 		admin->last_used_addr = elem->addr;
 	}
-	kfree(ri);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vcap_del_rule);
-- 
2.38.1

