Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74AC266D8E5
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbjAQI4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbjAQI4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:56:25 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0541A96A;
        Tue, 17 Jan 2023 00:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673945771; x=1705481771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W98pjnf4ANO3DD+DNkbIvqiBKdIWDg5rmKA7LNbwvO0=;
  b=na7vQqEvnO+M6BSeDrDdNeB0bRnRqvXfT1saZb/3Tgyz+XtWl47hpvF5
   gijl0/36rMnqDlrVGyCxg76E2MG0iiLLFUIwqagwCgEEy61QuPeKnOwbe
   z0XzivQgEeMxuNgb5YgoBZImbR4HY746bRbiP2GndJVr3+WTSuZUXEqk8
   j7iN5AMJPsFaTrX4XTZeoy9OraZeb1LAlUqNTHbHK9ZlDk6Sb4MTIwlMA
   1wBALUNNQYYJnM+Us/724ud0k0qI6RRXg9efMQk10Xvl0E8g+QP26tffv
   dxcQ8dWjzJEOlEa3Z4Yc7g3SVu/ilc/iHiOjD8DDuS8h0124q5FZmPdnr
   A==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669100400"; 
   d="scan'208";a="197113729"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 01:56:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 01:56:06 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 01:56:02 -0700
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
Subject: [PATCH net-next 4/5] net: microchip: sparx5: Improve VCAP admin locking in the VCAP API
Date:   Tue, 17 Jan 2023 09:55:43 +0100
Message-ID: <20230117085544.591523-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230117085544.591523-1-steen.hegelund@microchip.com>
References: <20230117085544.591523-1-steen.hegelund@microchip.com>
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

This improves the VCAP cache and the VCAP rule list protection against
access from different sources.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 97 +++++++++++++------
 1 file changed, 67 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 198c36627ba1..71f787a78295 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -934,18 +934,21 @@ static bool vcap_rule_exists(struct vcap_control *vctrl, u32 id)
 	return false;
 }
 
-/* Find a rule with a provided rule id */
-static struct vcap_rule_internal *vcap_lookup_rule(struct vcap_control *vctrl,
-						   u32 id)
+/* Find a rule with a provided rule id return a locked vcap */
+static struct vcap_rule_internal *
+vcap_get_locked_rule(struct vcap_control *vctrl, u32 id)
 {
 	struct vcap_rule_internal *ri;
 	struct vcap_admin *admin;
 
 	/* Look for the rule id in all vcaps */
-	list_for_each_entry(admin, &vctrl->list, list)
+	list_for_each_entry(admin, &vctrl->list, list) {
+		mutex_lock(&admin->lock);
 		list_for_each_entry(ri, &admin->rules, list)
 			if (ri->data.id == id)
 				return ri;
+		mutex_unlock(&admin->lock);
+	}
 	return NULL;
 }
 
@@ -954,12 +957,21 @@ int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie)
 {
 	struct vcap_rule_internal *ri;
 	struct vcap_admin *admin;
+	int id = 0;
 
 	/* Look for the rule id in all vcaps */
-	list_for_each_entry(admin, &vctrl->list, list)
-		list_for_each_entry(ri, &admin->rules, list)
-			if (ri->data.cookie == cookie)
-				return ri->data.id;
+	list_for_each_entry(admin, &vctrl->list, list) {
+		mutex_lock(&admin->lock);
+		list_for_each_entry(ri, &admin->rules, list) {
+			if (ri->data.cookie == cookie) {
+				id = ri->data.id;
+				break;
+			}
+		}
+		mutex_unlock(&admin->lock);
+		if (id)
+			return id;
+	}
 	return -ENOENT;
 }
 EXPORT_SYMBOL_GPL(vcap_lookup_rule_by_cookie);
@@ -2116,17 +2128,28 @@ struct vcap_rule *vcap_alloc_rule(struct vcap_control *vctrl,
 	/* Sanity check that this VCAP is supported on this platform */
 	if (vctrl->vcaps[admin->vtype].rows == 0)
 		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&admin->lock);
 	/* Check if a rule with this id already exists */
-	if (vcap_rule_exists(vctrl, id))
-		return ERR_PTR(-EEXIST);
+	if (vcap_rule_exists(vctrl, id)) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	/* Check if there is room for the rule in the block(s) of the VCAP */
 	maxsize = vctrl->vcaps[admin->vtype].sw_count; /* worst case rule size */
-	if (vcap_rule_space(admin, maxsize))
-		return ERR_PTR(-ENOSPC);
+	if (vcap_rule_space(admin, maxsize)) {
+		err = -ENOSPC;
+		goto out_unlock;
+	}
+
 	/* Create a container for the rule and return it */
 	ri = kzalloc(sizeof(*ri), GFP_KERNEL);
-	if (!ri)
-		return ERR_PTR(-ENOMEM);
+	if (!ri) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+
 	ri->data.vcap_chain_id = vcap_chain_id;
 	ri->data.user = user;
 	ri->data.priority = priority;
@@ -2139,13 +2162,21 @@ struct vcap_rule *vcap_alloc_rule(struct vcap_control *vctrl,
 	ri->ndev = ndev;
 	ri->admin = admin; /* refer to the vcap instance */
 	ri->vctrl = vctrl; /* refer to the client */
-	if (vcap_set_rule_id(ri) == 0)
+
+	if (vcap_set_rule_id(ri) == 0) {
+		err = -EINVAL;
 		goto out_free;
+	}
+
+	mutex_unlock(&admin->lock);
 	return (struct vcap_rule *)ri;
 
 out_free:
 	kfree(ri);
-	return ERR_PTR(-EINVAL);
+out_unlock:
+	mutex_unlock(&admin->lock);
+	return ERR_PTR(err);
+
 }
 EXPORT_SYMBOL_GPL(vcap_alloc_rule);
 
@@ -2209,11 +2240,10 @@ struct vcap_rule *vcap_get_rule(struct vcap_control *vctrl, u32 id)
 	if (err)
 		return ERR_PTR(err);
 
-	elem = vcap_lookup_rule(vctrl, id);
+	elem = vcap_get_locked_rule(vctrl, id);
 	if (!elem)
 		return NULL;
 
-	mutex_lock(&elem->admin->lock);
 	rule = vcap_decode_rule(elem);
 	mutex_unlock(&elem->admin->lock);
 	return rule;
@@ -2231,11 +2261,9 @@ int vcap_mod_rule(struct vcap_rule *rule)
 	if (err)
 		return err;
 
-	if (!vcap_lookup_rule(ri->vctrl, ri->data.id))
+	if (!vcap_get_locked_rule(ri->vctrl, ri->data.id))
 		return -ENOENT;
 
-	mutex_lock(&ri->admin->lock);
-
 	vcap_rule_set_state(ri);
 	if (ri->state == VCAP_RS_DISABLED)
 		goto out;
@@ -2252,8 +2280,6 @@ int vcap_mod_rule(struct vcap_rule *rule)
 
 	memset(&ctr, 0, sizeof(ctr));
 	err =  vcap_write_counter(ri, &ctr);
-	if (err)
-		goto out;
 
 out:
 	mutex_unlock(&ri->admin->lock);
@@ -2320,20 +2346,19 @@ int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id)
 	if (err)
 		return err;
 	/* Look for the rule id in all vcaps */
-	ri = vcap_lookup_rule(vctrl, id);
+	ri = vcap_get_locked_rule(vctrl, id);
 	if (!ri)
-		return -EINVAL;
+		return -ENOENT;
+
 	admin = ri->admin;
 
 	if (ri->addr > admin->last_used_addr)
 		gap = vcap_fill_rule_gap(ri);
 
 	/* Delete the rule from the list of rules and the cache */
-	mutex_lock(&admin->lock);
 	list_del(&ri->list);
 	vctrl->ops->init(ndev, admin, admin->last_used_addr, ri->size + gap);
 	vcap_free_rule(&ri->data);
-	mutex_unlock(&admin->lock);
 
 	/* Update the last used address, set to default when no rules */
 	if (list_empty(&admin->rules)) {
@@ -2343,7 +2368,9 @@ int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id)
 				       list);
 		admin->last_used_addr = elem->addr;
 	}
-	return 0;
+
+	mutex_unlock(&admin->lock);
+	return err;
 }
 EXPORT_SYMBOL_GPL(vcap_del_rule);
 
@@ -3021,7 +3048,12 @@ int vcap_rule_set_counter(struct vcap_rule *rule, struct vcap_counter *ctr)
 		pr_err("%s:%d: counter is missing\n", __func__, __LINE__);
 		return -EINVAL;
 	}
-	return vcap_write_counter(ri, ctr);
+
+	mutex_lock(&ri->admin->lock);
+	err = vcap_write_counter(ri, ctr);
+	mutex_unlock(&ri->admin->lock);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(vcap_rule_set_counter);
 
@@ -3037,7 +3069,12 @@ int vcap_rule_get_counter(struct vcap_rule *rule, struct vcap_counter *ctr)
 		pr_err("%s:%d: counter is missing\n", __func__, __LINE__);
 		return -EINVAL;
 	}
-	return vcap_read_counter(ri, ctr);
+
+	mutex_lock(&ri->admin->lock);
+	err = vcap_read_counter(ri, ctr);
+	mutex_unlock(&ri->admin->lock);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(vcap_rule_get_counter);
 
-- 
2.39.0

