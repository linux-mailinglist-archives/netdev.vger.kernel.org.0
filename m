Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C35F62B5DC
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 10:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238695AbiKPJBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 04:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbiKPI7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:59:09 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60651E3F3;
        Wed, 16 Nov 2022 00:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668589103; x=1700125103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Yw+pa883dIGWnpvOyWPcMOqzFHQUZ9gUAbIwkNSn8g=;
  b=CE7dRocZOTkCmFPMn6TRh3ftX2e0JKGUmYMwwKlAEsIfO8xs6iLb69C0
   a/VNkNLyhqIjfviaSFvDX+9ak40C0AcQf8arRMTlrBurGmsk+rwmZzU0L
   dHu2bWHM9r9JuQZFy5tGmMZHGaJQm7qbAjvusAA1z1pV/fTlfgAu8nvS6
   jtmKA9nRTMSSVA51qvZu+87S6OaxVT0mJJIDBzDzdQ7YZo+yzkLLI5IRZ
   Zqj3ahnkgrtBRxhNsfiJjlEbOt/Z4Uvu7Z35bt5pXywSAjHN7IFvgt+Ay
   EuZQGaAB+Z70MRCm8JEIGchFje6wA8vGj4RcphAYbxgMOLlpOqoVk6pGl
   g==;
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="123662824"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Nov 2022 01:58:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 16 Nov 2022 01:58:13 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 16 Nov 2022 01:58:10 -0700
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
Subject: [PATCH net-next 5/8] net: microchip: sparx5: Add VCAP rule debugFS support for the VCAP API
Date:   Wed, 16 Nov 2022 09:57:44 +0100
Message-ID: <20221116085747.3810427-6-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116085747.3810427-1-steen.hegelund@microchip.com>
References: <20221116085747.3810427-1-steen.hegelund@microchip.com>
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

This add support to show all rules in a VCAP instance. The information
shown is:

 - rule id
 - address range
 - size
 - chain id
 - keyset name, subword size, register span
 - actionset name, subword size, register span
 - counter value
 - sticky bit (one bit width counter)

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    |  15 ++-
 .../microchip/vcap/vcap_api_debugfs.c         | 115 ++++++++++++++++++
 .../microchip/vcap/vcap_api_private.h         |  14 +++
 3 files changed, 140 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 153e28e124bc..3da714e9639c 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -502,7 +502,7 @@ int vcap_api_check(struct vcap_control *ctrl)
 	return 0;
 }
 
-static void vcap_erase_cache(struct vcap_rule_internal *ri)
+void vcap_erase_cache(struct vcap_rule_internal *ri)
 {
 	ri->vctrl->ops->cache_erase(ri->admin);
 }
@@ -578,7 +578,7 @@ int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie)
 EXPORT_SYMBOL_GPL(vcap_lookup_rule_by_cookie);
 
 /* Make a shallow copy of the rule without the fields */
-static struct vcap_rule_internal *vcap_dup_rule(struct vcap_rule_internal *ri)
+struct vcap_rule_internal *vcap_dup_rule(struct vcap_rule_internal *ri)
 {
 	struct vcap_rule_internal *duprule;
 
@@ -782,9 +782,16 @@ const char *vcap_keyfield_name(struct vcap_control *vctrl,
 }
 EXPORT_SYMBOL_GPL(vcap_keyfield_name);
 
+/* map actionset id to a string with the actionset name */
+const char *vcap_actionset_name(struct vcap_control *vctrl,
+				enum vcap_actionfield_set actionset)
+{
+	return vctrl->stats->actionfield_set_names[actionset];
+}
+
 /* map action field id to a string with the action name */
-static const char *vcap_actionfield_name(struct vcap_control *vctrl,
-					 enum vcap_action_field action)
+const char *vcap_actionfield_name(struct vcap_control *vctrl,
+				  enum vcap_action_field action)
 {
 	return vctrl->stats->actionfield_names[action];
 }
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index 5df160b24d95..a2d66a36db1c 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -232,6 +232,105 @@ static int vcap_addr_keyset(struct vcap_control *vctrl,
 					  admin->cache.maskstream, false, 0);
 }
 
+static int vcap_read_rule(struct vcap_rule_internal *ri)
+{
+	struct vcap_admin *admin = ri->admin;
+	int sw_idx, ent_idx = 0, act_idx = 0;
+	u32 addr = ri->addr;
+
+	if (!ri->size || !ri->keyset_sw_regs || !ri->actionset_sw_regs) {
+		pr_err("%s:%d: rule is empty\n", __func__, __LINE__);
+		return -EINVAL;
+	}
+	vcap_erase_cache(ri);
+	/* Use the values in the streams to read the VCAP cache */
+	for (sw_idx = 0; sw_idx < ri->size; sw_idx++, addr++) {
+		ri->vctrl->ops->update(ri->ndev, admin, VCAP_CMD_READ,
+				       VCAP_SEL_ALL, addr);
+		ri->vctrl->ops->cache_read(ri->ndev, admin,
+					   VCAP_SEL_ENTRY, ent_idx,
+					   ri->keyset_sw_regs);
+		ri->vctrl->ops->cache_read(ri->ndev, admin,
+					   VCAP_SEL_ACTION, act_idx,
+					   ri->actionset_sw_regs);
+		if (sw_idx == 0)
+			ri->vctrl->ops->cache_read(ri->ndev, admin,
+						   VCAP_SEL_COUNTER,
+						   ri->counter_id, 0);
+		ent_idx += ri->keyset_sw_regs;
+		act_idx += ri->actionset_sw_regs;
+	}
+	return 0;
+}
+
+static void vcap_show_admin_rule(struct vcap_control *vctrl,
+				 struct vcap_admin *admin,
+				 struct vcap_output_print *out,
+				 struct vcap_rule_internal *ri)
+{
+	ri->counter.value = admin->cache.counter;
+	ri->counter.sticky = admin->cache.sticky;
+	out->prf(out->dst, "rule: %u, addr: [%d,%d], X%d, ctr[%d]: %d, hit: %d\n",
+	   ri->data.id, ri->addr, ri->addr + ri->size - 1, ri->size,
+	   ri->counter_id, ri->counter.value, ri->counter.sticky);
+	out->prf(out->dst, "  chain_id: %d\n", ri->data.vcap_chain_id);
+	out->prf(out->dst, "  user: %d\n", ri->data.user);
+	out->prf(out->dst, "  priority: %d\n", ri->data.priority);
+	out->prf(out->dst, "  keyset: %s\n",
+		 vcap_keyset_name(vctrl, ri->data.keyset));
+	out->prf(out->dst, "  actionset: %s\n",
+		 vcap_actionset_name(vctrl, ri->data.actionset));
+}
+
+static void vcap_show_admin_info(struct vcap_control *vctrl,
+				 struct vcap_admin *admin,
+				 struct vcap_output_print *out)
+{
+	const struct vcap_info *vcap = &vctrl->vcaps[admin->vtype];
+
+	out->prf(out->dst, "name: %s\n", vcap->name);
+	out->prf(out->dst, "rows: %d\n", vcap->rows);
+	out->prf(out->dst, "sw_count: %d\n", vcap->sw_count);
+	out->prf(out->dst, "sw_width: %d\n", vcap->sw_width);
+	out->prf(out->dst, "sticky_width: %d\n", vcap->sticky_width);
+	out->prf(out->dst, "act_width: %d\n", vcap->act_width);
+	out->prf(out->dst, "default_cnt: %d\n", vcap->default_cnt);
+	out->prf(out->dst, "require_cnt_dis: %d\n", vcap->require_cnt_dis);
+	out->prf(out->dst, "version: %d\n", vcap->version);
+	out->prf(out->dst, "vtype: %d\n", admin->vtype);
+	out->prf(out->dst, "vinst: %d\n", admin->vinst);
+	out->prf(out->dst, "first_cid: %d\n", admin->first_cid);
+	out->prf(out->dst, "last_cid: %d\n", admin->last_cid);
+	out->prf(out->dst, "lookups: %d\n", admin->lookups);
+	out->prf(out->dst, "first_valid_addr: %d\n", admin->first_valid_addr);
+	out->prf(out->dst, "last_valid_addr: %d\n", admin->last_valid_addr);
+	out->prf(out->dst, "last_used_addr: %d\n", admin->last_used_addr);
+}
+
+static int vcap_show_admin(struct vcap_control *vctrl,
+			   struct vcap_admin *admin,
+			   struct vcap_output_print *out)
+{
+	struct vcap_rule_internal *elem, *ri;
+	int ret = 0;
+
+	vcap_show_admin_info(vctrl, admin, out);
+	list_for_each_entry(elem, &admin->rules, list) {
+		ri = vcap_dup_rule(elem);
+		if (IS_ERR(ri))
+			goto free_rule;
+		/* Read data from VCAP */
+		ret = vcap_read_rule(ri);
+		if (ret)
+			goto free_rule;
+		out->prf(out->dst, "\n");
+		vcap_show_admin_rule(vctrl, admin, out, ri);
+free_rule:
+		vcap_free_rule((struct vcap_rule *)ri);
+	}
+	return ret;
+}
+
 static int vcap_show_admin_raw(struct vcap_control *vctrl,
 			       struct vcap_admin *admin,
 			       struct vcap_output_print *out)
@@ -310,6 +409,19 @@ void vcap_port_debugfs(struct device *dev, struct dentry *parent,
 }
 EXPORT_SYMBOL_GPL(vcap_port_debugfs);
 
+/* Show the full VCAP instance data (rules with all fields) */
+static int vcap_debugfs_show(struct seq_file *m, void *unused)
+{
+	struct vcap_admin_debugfs_info *info = m->private;
+	struct vcap_output_print out = {
+		.prf = (void *)seq_printf,
+		.dst = m,
+	};
+
+	return vcap_show_admin(info->vctrl, info->admin, &out);
+}
+DEFINE_SHOW_ATTRIBUTE(vcap_debugfs);
+
 /* Show the raw VCAP instance data (rules with address info) */
 static int vcap_raw_debugfs_show(struct seq_file *m, void *unused)
 {
@@ -343,6 +455,9 @@ struct dentry *vcap_debugfs(struct device *dev, struct dentry *parent,
 		info->admin = admin;
 		debugfs_create_file(name, 0444, dir, info,
 				    &vcap_raw_debugfs_fops);
+		sprintf(name, "%s_%d", vctrl->vcaps[admin->vtype].name,
+			admin->vinst);
+		debugfs_create_file(name, 0444, dir, info, &vcap_debugfs_fops);
 	}
 	return dir;
 }
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
index 02447a4fd76d..b13e1c000c30 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
@@ -43,6 +43,10 @@ struct vcap_stream_iter {
 
 /* Check that the control has a valid set of callbacks */
 int vcap_api_check(struct vcap_control *ctrl);
+/* Make a shallow copy of the rule without the fields */
+struct vcap_rule_internal *vcap_dup_rule(struct vcap_rule_internal *ri);
+/* Erase the VCAP cache area used or encoding and decoding */
+void vcap_erase_cache(struct vcap_rule_internal *ri);
 
 /* Iterator functionality */
 
@@ -70,4 +74,14 @@ vcap_keyfield_typegroup(struct vcap_control *vctrl,
 const struct vcap_field *vcap_keyfields(struct vcap_control *vctrl,
 					enum vcap_type vt,
 					enum vcap_keyfield_set keyset);
+
+/* Actionset and actionfield functionality */
+
+/* Map actionset id to a string with the actionset name */
+const char *vcap_actionset_name(struct vcap_control *vctrl,
+				enum vcap_actionfield_set actionset);
+/* Map key field id to a string with the key name */
+const char *vcap_actionfield_name(struct vcap_control *vctrl,
+				  enum vcap_action_field action);
+
 #endif /* __VCAP_API_PRIVATE__ */
-- 
2.38.1

