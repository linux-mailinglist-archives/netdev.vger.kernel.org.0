Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B8B625AEF
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 14:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbiKKNGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 08:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiKKNF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 08:05:57 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633687BE7C;
        Fri, 11 Nov 2022 05:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668171949; x=1699707949;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mYwmrTNOjBARIZVykxkW5XIgwCztK/JLX3qnOVaXM3E=;
  b=Fyn/7GhR5sUOlkg++9KarY6dyb+D7wbvdtcx0IjU797VRwB/LNK0wd8f
   SjmLqh86QZB9ikgvsM2fnC6mLMrQmOHdmNSe090mifajEEY5Zy7xcYj23
   cG93Xf9nK2Q3ejFfSQa0n9CbTmqjsBhf6YPiUky6njqfkmDD8z3S3Sswb
   4woi7GZag/S+Kt3sUV6s/ck32llTFxmTvLoIf5Y0EwEofNXfET7YjHoF3
   GX3ZgXxVXRL19qR+jk5FQbRJG8K8HtvGRIwfc8SeNDjPhHLQA1CYtNBO2
   uYoSpUjlTd9LsP6C3mSnuETE/kKQQiNLsEga8OOsnhfrC3vD2pA1n5csQ
   w==;
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="183107393"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2022 06:05:47 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 11 Nov 2022 06:05:46 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 11 Nov 2022 06:05:42 -0700
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
Subject: [PATCH net-next 4/6] net: microchip: sparx5: Add support for IS2 VCAP rule counters
Date:   Fri, 11 Nov 2022 14:05:17 +0100
Message-ID: <20221111130519.1459549-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111130519.1459549-1-steen.hegelund@microchip.com>
References: <20221111130519.1459549-1-steen.hegelund@microchip.com>
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

This adds API methods to set and get a rule counter.

A VCAP instance may contain the counter as part of the VCAP cache area, and
this counter may be one or more bits in width.  This type of counter
automatically increments it value when the rule is hit.

Other VCAP instances have a dedicated counter area outside of the VCAP and
in this case the rule must contain the counter id to be able to locate the
counter value.  In this case there must also be a rule action that updates
the counter using the rule id when the rule is hit.

The Sparx5 IS2 VCAP uses a dedicated counter area.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_vcap_impl.c       | 47 +++++++++++-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 71 +++++++++++++++++++
 .../ethernet/microchip/vcap/vcap_api_client.h | 11 +++
 3 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index b62c48a3fc45..e8f3d030eba2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -428,15 +428,58 @@ static void sparx5_vcap_cache_write(struct net_device *ndev,
 	default:
 		break;
 	}
+	if (sel & VCAP_SEL_COUNTER) {
+		start = start & 0xfff; /* counter limit */
+		if (admin->vinst == 0)
+			spx5_wr(admin->cache.counter, sparx5,
+				ANA_ACL_CNT_A(start));
+		else
+			spx5_wr(admin->cache.counter, sparx5,
+				ANA_ACL_CNT_B(start));
+		spx5_wr(admin->cache.sticky, sparx5,
+			VCAP_SUPER_VCAP_CNT_DAT(0));
+	}
 }
 
 /* API callback used for reading from the VCAP into the VCAP cache */
 static void sparx5_vcap_cache_read(struct net_device *ndev,
 				   struct vcap_admin *admin,
-				   enum vcap_selection sel, u32 start,
+				   enum vcap_selection sel,
+				   u32 start,
 				   u32 count)
 {
-	/* this will be added later */
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	u32 *keystr, *mskstr, *actstr;
+	int idx;
+
+	keystr = &admin->cache.keystream[start];
+	mskstr = &admin->cache.maskstream[start];
+	actstr = &admin->cache.actionstream[start];
+	if (sel & VCAP_SEL_ENTRY) {
+		for (idx = 0; idx < count; ++idx) {
+			keystr[idx] = spx5_rd(sparx5,
+					      VCAP_SUPER_VCAP_ENTRY_DAT(idx));
+			mskstr[idx] = ~spx5_rd(sparx5,
+					       VCAP_SUPER_VCAP_MASK_DAT(idx));
+		}
+	}
+	if (sel & VCAP_SEL_ACTION) {
+		for (idx = 0; idx < count; ++idx)
+			actstr[idx] = spx5_rd(sparx5,
+					      VCAP_SUPER_VCAP_ACTION_DAT(idx));
+	}
+	if (sel & VCAP_SEL_COUNTER) {
+		start = start & 0xfff; /* counter limit */
+		if (admin->vinst == 0)
+			admin->cache.counter =
+				spx5_rd(sparx5, ANA_ACL_CNT_A(start));
+		else
+			admin->cache.counter =
+				spx5_rd(sparx5, ANA_ACL_CNT_B(start));
+		admin->cache.sticky =
+			spx5_rd(sparx5, VCAP_SUPER_VCAP_CNT_DAT(0));
+	}
 }
 
 /* API callback used for initializing a VCAP address range */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 62b675a37a96..9c660e718526 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -25,6 +25,8 @@ struct vcap_rule_internal {
 	int actionset_sw_regs;  /* registers in a subword in an actionset */
 	int size; /* the size of the rule: max(entry, action) */
 	u32 addr; /* address in the VCAP at insertion */
+	u32 counter_id; /* counter id (if a dedicated counter is available) */
+	struct vcap_counter counter; /* last read counter value */
 };
 
 /* Moving a rule in the VCAP address space */
@@ -651,6 +653,20 @@ static int vcap_write_rule(struct vcap_rule_internal *ri)
 	return 0;
 }
 
+static int vcap_write_counter(struct vcap_rule_internal *ri,
+			      struct vcap_counter *ctr)
+{
+	struct vcap_admin *admin = ri->admin;
+
+	admin->cache.counter = ctr->value;
+	admin->cache.sticky = ctr->sticky;
+	ri->vctrl->ops->cache_write(ri->ndev, admin, VCAP_SEL_COUNTER,
+				    ri->counter_id, 0);
+	ri->vctrl->ops->update(ri->ndev, admin, VCAP_CMD_WRITE,
+			       VCAP_SEL_COUNTER, ri->addr);
+	return 0;
+}
+
 /* Convert a chain id to a VCAP lookup index */
 int vcap_chain_id_to_lookup(struct vcap_admin *admin, int cur_cid)
 {
@@ -1547,6 +1563,20 @@ int vcap_rule_add_action_u32(struct vcap_rule *rule,
 }
 EXPORT_SYMBOL_GPL(vcap_rule_add_action_u32);
 
+static int vcap_read_counter(struct vcap_rule_internal *ri,
+			     struct vcap_counter *ctr)
+{
+	struct vcap_admin *admin = ri->admin;
+
+	ri->vctrl->ops->update(ri->ndev, admin, VCAP_CMD_READ, VCAP_SEL_COUNTER,
+			       ri->addr);
+	ri->vctrl->ops->cache_read(ri->ndev, admin, VCAP_SEL_COUNTER,
+				   ri->counter_id, 0);
+	ctr->value = admin->cache.counter;
+	ctr->sticky = admin->cache.sticky;
+	return 0;
+}
+
 /* Copy to host byte order */
 void vcap_netbytes_copy(u8 *dst, u8 *src, int count)
 {
@@ -1690,6 +1720,47 @@ int vcap_enable_lookups(struct vcap_control *vctrl, struct net_device *ndev,
 }
 EXPORT_SYMBOL_GPL(vcap_enable_lookups);
 
+/* Set a rule counter id (for certain vcaps only) */
+void vcap_rule_set_counter_id(struct vcap_rule *rule, u32 counter_id)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+
+	ri->counter_id = counter_id;
+}
+EXPORT_SYMBOL_GPL(vcap_rule_set_counter_id);
+
+int vcap_rule_set_counter(struct vcap_rule *rule, struct vcap_counter *ctr)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	int err;
+
+	err = vcap_api_check(ri->vctrl);
+	if (err)
+		return err;
+	if (!ctr) {
+		pr_err("%s:%d: counter is missing\n", __func__, __LINE__);
+		return -EINVAL;
+	}
+	return vcap_write_counter(ri, ctr);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_set_counter);
+
+int vcap_rule_get_counter(struct vcap_rule *rule, struct vcap_counter *ctr)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	int err;
+
+	err = vcap_api_check(ri->vctrl);
+	if (err)
+		return err;
+	if (!ctr) {
+		pr_err("%s:%d: counter is missing\n", __func__, __LINE__);
+		return -EINVAL;
+	}
+	return vcap_read_counter(ri, ctr);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_get_counter);
+
 #ifdef CONFIG_VCAP_KUNIT_TEST
 #include "vcap_api_kunit.c"
 #endif
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 0ea5ec96adc8..c2655045d6d4 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -143,6 +143,11 @@ enum vcap_bit {
 	VCAP_BIT_1
 };
 
+struct vcap_counter {
+	u32 value;
+	bool sticky;
+};
+
 /* Enable/Disable the VCAP instance lookups. Chain id 0 means disable */
 int vcap_enable_lookups(struct vcap_control *vctrl, struct net_device *ndev,
 			int chain_id, unsigned long cookie, bool enable);
@@ -170,6 +175,8 @@ int vcap_set_rule_set_keyset(struct vcap_rule *rule,
 /* Update the actionset for the rule */
 int vcap_set_rule_set_actionset(struct vcap_rule *rule,
 				enum vcap_actionfield_set actionset);
+/* Set a rule counter id (for certain VCAPs only) */
+void vcap_rule_set_counter_id(struct vcap_rule *rule, u32 counter_id);
 
 /* VCAP rule field operations */
 int vcap_rule_add_key_bit(struct vcap_rule *rule, enum vcap_key_field key,
@@ -187,6 +194,10 @@ int vcap_rule_add_action_bit(struct vcap_rule *rule,
 int vcap_rule_add_action_u32(struct vcap_rule *rule,
 			     enum vcap_action_field action, u32 value);
 
+/* VCAP rule counter operations */
+int vcap_rule_set_counter(struct vcap_rule *rule, struct vcap_counter *ctr);
+int vcap_rule_get_counter(struct vcap_rule *rule, struct vcap_counter *ctr);
+
 /* VCAP lookup operations */
 /* Convert a chain id to a VCAP lookup index */
 int vcap_chain_id_to_lookup(struct vcap_admin *admin, int cur_cid);
-- 
2.38.1

