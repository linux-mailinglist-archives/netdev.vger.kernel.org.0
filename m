Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C4A6AE0E6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCGNmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjCGNlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:41:47 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912FD8C940;
        Tue,  7 Mar 2023 05:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678196484; x=1709732484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F+3Zg9F1bICYM3YH1kFtL3Wm1Mck5R3cuhQLjOKAcZM=;
  b=ek6I+TdZzx/3HcgJnwT1JwyIzKLam+vgYKLlRwNnxEIbfH8sKVn2dFg/
   wFsbJn+awQpD6dKXjFTMD1s0JWJGWEd649BWSRyWcjUMqoAtNS/fvFIFG
   Ik7rU3rAlUzbCvOgO9529OLbfHeXN2jhT5nGJGJUVqf5l3V3DbCDnxFgU
   DRlahmQCxgHF/TawHJBNZEegNcpZdrW5G8nztex7RWFuXliKSzLjW+K42
   PMRfpl4XF7E1BURo3KULJvnWFCYaOcei9fbWSpyhCXb+JmRe2Uj6btpya
   rGDu0gGP0kv+gam/ka31W4D9ITZ/1dqiY4xWpOrKHf6EhfHx8Tl1DSswq
   w==;
X-IronPort-AV: E=Sophos;i="5.98,241,1673938800"; 
   d="scan'208";a="215163089"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 06:41:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 06:41:22 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 06:41:18 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Qiheng Lin <linqiheng@huawei.com>,
        "Shang XiaoJing" <shangxiaojing@huawei.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 2/5] net: microchip: sparx5: Provide rule count, key removal and keyset select
Date:   Tue, 7 Mar 2023 14:41:00 +0100
Message-ID: <20230307134103.2042975-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307134103.2042975-1-steen.hegelund@microchip.com>
References: <20230307134103.2042975-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides these 3 functions in the VCAP API:

- Count the number of rules in a VCAP lookup (chain)
- Remove a key from a VCAP rule
- Find the keyset that gives the smallest rule list from a list of keysets

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 61 +++++++++++++++++++
 .../ethernet/microchip/vcap/vcap_api_client.h | 11 ++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 4847d0d99ec9..5675b0962bc3 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -976,6 +976,25 @@ int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie)
 }
 EXPORT_SYMBOL_GPL(vcap_lookup_rule_by_cookie);
 
+/* Get number of rules in a vcap instance lookup chain id range */
+int vcap_admin_rule_count(struct vcap_admin *admin, int cid)
+{
+	int max_cid = roundup(cid + 1, VCAP_CID_LOOKUP_SIZE);
+	int min_cid = rounddown(cid, VCAP_CID_LOOKUP_SIZE);
+	struct vcap_rule_internal *elem;
+	int count = 0;
+
+	list_for_each_entry(elem, &admin->rules, list) {
+		mutex_lock(&admin->lock);
+		if (elem->data.vcap_chain_id >= min_cid &&
+		    elem->data.vcap_chain_id < max_cid)
+			++count;
+		mutex_unlock(&admin->lock);
+	}
+	return count;
+}
+EXPORT_SYMBOL_GPL(vcap_admin_rule_count);
+
 /* Make a copy of the rule, shallow or full */
 static struct vcap_rule_internal *vcap_dup_rule(struct vcap_rule_internal *ri,
 						bool full)
@@ -3403,6 +3422,25 @@ int vcap_rule_mod_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
 }
 EXPORT_SYMBOL_GPL(vcap_rule_mod_key_u32);
 
+/* Remove a key field with value and mask in the rule */
+int vcap_rule_rem_key(struct vcap_rule *rule, enum vcap_key_field key)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	struct vcap_client_keyfield *field;
+
+	field = vcap_find_keyfield(rule, key);
+	if (!field) {
+		pr_err("%s:%d: key %s is not in the rule\n",
+		       __func__, __LINE__, vcap_keyfield_name(ri->vctrl, key));
+		return -EINVAL;
+	}
+	/* Deallocate the key field */
+	list_del(&field->ctrl.list);
+	kfree(field);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vcap_rule_rem_key);
+
 static int vcap_rule_mod_action(struct vcap_rule *rule,
 				enum vcap_action_field action,
 				enum vcap_field_type ftype,
@@ -3475,6 +3513,29 @@ int vcap_filter_rule_keys(struct vcap_rule *rule,
 }
 EXPORT_SYMBOL_GPL(vcap_filter_rule_keys);
 
+/* Select the keyset from the list that results in the smallest rule size */
+enum vcap_keyfield_set
+vcap_select_min_rule_keyset(struct vcap_control *vctrl,
+			    enum vcap_type vtype,
+			    struct vcap_keyset_list *kslist)
+{
+	enum vcap_keyfield_set ret = VCAP_KFS_NO_VALUE;
+	const struct vcap_set *kset;
+	int max = 100, idx;
+
+	for (idx = 0; idx < kslist->cnt; ++idx) {
+		kset = vcap_keyfieldset(vctrl, vtype, kslist->keysets[idx]);
+		if (!kset)
+			continue;
+		if (kset->sw_per_item >= max)
+			continue;
+		max = kset->sw_per_item;
+		ret = kslist->keysets[idx];
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vcap_select_min_rule_keyset);
+
 /* Make a full copy of an existing rule with a new rule id */
 struct vcap_rule *vcap_copy_rule(struct vcap_rule *erule)
 {
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 417af9754bcc..d9d1f7c9d762 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -201,6 +201,9 @@ int vcap_rule_add_action_bit(struct vcap_rule *rule,
 int vcap_rule_add_action_u32(struct vcap_rule *rule,
 			     enum vcap_action_field action, u32 value);
 
+/* Get number of rules in a vcap instance lookup chain id range */
+int vcap_admin_rule_count(struct vcap_admin *admin, int cid);
+
 /* VCAP rule counter operations */
 int vcap_get_rule_count_by_cookie(struct vcap_control *vctrl,
 				  struct vcap_counter *ctr, u64 cookie);
@@ -269,6 +272,14 @@ int vcap_rule_mod_action_u32(struct vcap_rule *rule,
 int vcap_rule_get_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
 			  u32 *value, u32 *mask);
 
+/* Remove a key field with value and mask in the rule */
+int vcap_rule_rem_key(struct vcap_rule *rule, enum vcap_key_field key);
+
+/* Select the keyset from the list that results in the smallest rule size */
+enum vcap_keyfield_set
+vcap_select_min_rule_keyset(struct vcap_control *vctrl, enum vcap_type vtype,
+			    struct vcap_keyset_list *kslist);
+
 struct vcap_client_actionfield *
 vcap_find_actionfield(struct vcap_rule *rule, enum vcap_action_field act);
 #endif /* __VCAP_API_CLIENT__ */
-- 
2.39.2

