Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63C16795A5
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbjAXKq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbjAXKqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:46:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A91A43444;
        Tue, 24 Jan 2023 02:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674557150; x=1706093150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i+G/VVjJRmYIbJhvHt+NrJ4UIj3oX1h6OzL5RMTboko=;
  b=kstx7sCKT7EY9hAnMbsH2keH54DdJxIkDObzfBcKJ+VeaLzBVyoF7Xqf
   8bvgiDeNfrRrUDXw00rBxfOo7iYh1eByk+ubC/TmEIZj3KZwXqigctixc
   9FjNVLOwDY2UHrbc1HesLnDBIX7HiTRI5kbeJvpzq3Eh1ESBi2z2k94BQ
   RhylM/QSqTFbR+72P2FpmKedH82h5vrx0DVMCSHH15FDlAlqXBvPtnb6J
   JXkz0ZKu+DeBz7JqeMjogVdvYmj1gxh/lvYQc6mw1xZBHc3amP0ovkyUA
   ukM4wyNtVlaf1iPNRbJZb+gTHG32ToU0BtuggAwW2EhlBl/OqHtXNONwb
   w==;
X-IronPort-AV: E=Sophos;i="5.97,242,1669100400"; 
   d="scan'208";a="133744308"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jan 2023 03:45:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 03:45:41 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 03:45:37 -0700
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
Subject: [PATCH net-next v2 6/8] net: microchip: sparx5: Add automatic selection of VCAP rule actionset
Date:   Tue, 24 Jan 2023 11:45:09 +0100
Message-ID: <20230124104511.293938-7-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124104511.293938-1-steen.hegelund@microchip.com>
References: <20230124104511.293938-1-steen.hegelund@microchip.com>
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

With more than one possible actionset in a VCAP instance, the VCAP API will
now use the actions in a VCAP rule to select the actionset that fits these
actions the best possible way.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       |   5 -
 .../net/ethernet/microchip/vcap/vcap_api.c    | 107 +++++++++++++++++-
 .../net/ethernet/microchip/vcap/vcap_api.h    |   7 ++
 3 files changed, 109 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index b32ea01ff935..725762bb4475 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -991,11 +991,6 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 						       SPX5_PMM_REPLACE_ALL);
 			if (err)
 				goto out;
-			/* For now the actionset is hardcoded */
-			err = vcap_set_rule_set_actionset(vrule,
-							  VCAP_AFS_BASE_TYPE);
-			if (err)
-				goto out;
 			break;
 		case FLOW_ACTION_ACCEPT:
 			err = sparx5_tc_set_actionset(admin, vrule);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 258b0a397d37..83223c4770f2 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1757,6 +1757,22 @@ bool vcap_keyset_list_add(struct vcap_keyset_list *keysetlist,
 }
 EXPORT_SYMBOL_GPL(vcap_keyset_list_add);
 
+/* Add a actionset to a actionset list */
+static bool vcap_actionset_list_add(struct vcap_actionset_list *actionsetlist,
+				    enum vcap_actionfield_set actionset)
+{
+	int idx;
+
+	if (actionsetlist->cnt < actionsetlist->max) {
+		/* Avoid duplicates */
+		for (idx = 0; idx < actionsetlist->cnt; ++idx)
+			if (actionsetlist->actionsets[idx] == actionset)
+				return actionsetlist->cnt < actionsetlist->max;
+		actionsetlist->actionsets[actionsetlist->cnt++] = actionset;
+	}
+	return actionsetlist->cnt < actionsetlist->max;
+}
+
 /* map keyset id to a string with the keyset name */
 const char *vcap_keyset_name(struct vcap_control *vctrl,
 			     enum vcap_keyfield_set keyset)
@@ -1865,6 +1881,75 @@ bool vcap_rule_find_keysets(struct vcap_rule *rule,
 }
 EXPORT_SYMBOL_GPL(vcap_rule_find_keysets);
 
+/* Return the actionfield that matches a action in a actionset */
+static const struct vcap_field *
+vcap_find_actionset_actionfield(struct vcap_control *vctrl,
+				enum vcap_type vtype,
+				enum vcap_actionfield_set actionset,
+				enum vcap_action_field action)
+{
+	const struct vcap_field *fields;
+	int idx, count;
+
+	fields = vcap_actionfields(vctrl, vtype, actionset);
+	if (!fields)
+		return NULL;
+
+	/* Iterate the actionfields of the actionset */
+	count = vcap_actionfield_count(vctrl, vtype, actionset);
+	for (idx = 0; idx < count; ++idx) {
+		if (fields[idx].width == 0)
+			continue;
+
+		if (action == idx)
+			return &fields[idx];
+	}
+
+	return NULL;
+}
+
+/* Match a list of actions against the actionsets available in a vcap type */
+static bool vcap_rule_find_actionsets(struct vcap_rule_internal *ri,
+				      struct vcap_actionset_list *matches)
+{
+	int actionset, found, actioncount, map_size;
+	const struct vcap_client_actionfield *ckf;
+	const struct vcap_field **map;
+	enum vcap_type vtype;
+
+	vtype = ri->admin->vtype;
+	map = ri->vctrl->vcaps[vtype].actionfield_set_map;
+	map_size = ri->vctrl->vcaps[vtype].actionfield_set_size;
+
+	/* Get a count of the actionfields we want to match */
+	actioncount = 0;
+	list_for_each_entry(ckf, &ri->data.actionfields, ctrl.list)
+		++actioncount;
+
+	matches->cnt = 0;
+	/* Iterate the actionsets of the VCAP */
+	for (actionset = 0; actionset < map_size; ++actionset) {
+		if (!map[actionset])
+			continue;
+
+		/* Iterate the actions in the rule */
+		found = 0;
+		list_for_each_entry(ckf, &ri->data.actionfields, ctrl.list)
+			if (vcap_find_actionset_actionfield(ri->vctrl, vtype,
+							    actionset,
+							    ckf->ctrl.action))
+				++found;
+
+		/* Save the actionset if all actionfields were found */
+		if (found == actioncount)
+			if (!vcap_actionset_list_add(matches, actionset))
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
@@ -1916,11 +2001,23 @@ int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
 		return ret;
 	}
 	if (ri->data.actionset == VCAP_AFS_NO_VALUE) {
-		/* Later also actionsets will be matched against actions in
-		 * the rule, and the type will be set accordingly
-		 */
-		ri->data.exterr = VCAP_ERR_NO_ACTIONSET_MATCH;
-		return -EINVAL;
+		struct vcap_actionset_list matches = {};
+		enum vcap_actionfield_set actionsets[10];
+
+		matches.actionsets = actionsets;
+		matches.max = ARRAY_SIZE(actionsets);
+
+		/* Find an actionset that fits the rule actions */
+		if (!vcap_rule_find_actionsets(ri, &matches)) {
+			ri->data.exterr = VCAP_ERR_NO_ACTIONSET_MATCH;
+			return -EINVAL;
+		}
+		ret = vcap_set_rule_set_actionset(rule, actionsets[0]);
+		if (ret < 0) {
+			pr_err("%s:%d: actionset was not updated: %d\n",
+			       __func__, __LINE__, ret);
+			return ret;
+		}
 	}
 	vcap_add_type_keyfield(rule);
 	vcap_add_type_actionfield(rule);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.h b/drivers/net/ethernet/microchip/vcap/vcap_api.h
index c61f13a65030..40491116b0a9 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.h
@@ -201,6 +201,13 @@ struct vcap_keyset_list {
 	enum vcap_keyfield_set *keysets; /* the list of keysets */
 };
 
+/* List of actionsets */
+struct vcap_actionset_list {
+	int max; /* size of the actionset list */
+	int cnt; /* count of actionsets actually in the list */
+	enum vcap_actionfield_set *actionsets; /* the list of actionsets */
+};
+
 /* Client output printf-like function with destination */
 struct vcap_output_print {
 	__printf(2, 3)
-- 
2.39.1

