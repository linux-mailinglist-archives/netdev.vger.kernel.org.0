Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9C066D8DF
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbjAQI4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbjAQI4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:56:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D931816D;
        Tue, 17 Jan 2023 00:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673945768; x=1705481768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GZcHBZbu5HtMonOR5Xd9wzrrmhkAZmUisdDYlTfIN/Q=;
  b=hRBUmQ8H6LpXSLw4Kv+zv/Z8cn0k4RKLXhcqWQHbMDxMMdhYiAty+nF6
   8ahAHP9LGW03PtFeAbEvd/zrYUvITdyFXOnAWSQwWdOyr78veL+6eEKZg
   GbzLJ40xJ+w0lgp4Djy3ERlp/Avg0g3nFCNxE9hE3oe72CCUgum2Q9N7E
   vGNnH6ia+wyFd20Rep0idxdE86EEPWNgIoemCnW534o3DQWhoXF/k2JWN
   +QHZqsghh+gdCOmLEV987uTKW3Cdd3LRNjlXpF6nljlXPf/k+CWEmSUU/
   ZzybWbrfj2N+7lBbvDAN3P0LCHDaUnc7iUppDdK4YuL5ZynFNDuu5asTb
   g==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669100400"; 
   d="scan'208";a="197113715"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 01:56:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 01:56:02 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 01:55:58 -0700
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
Subject: [PATCH net-next 3/5] net: microchip: sparx5: Add VCAP admin locking in debugFS
Date:   Tue, 17 Jan 2023 09:55:42 +0100
Message-ID: <20230117085544.591523-4-steen.hegelund@microchip.com>
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

This ensures that the admin lock is taken before the debugFS functions
starts iterating the VCAP rules.
It also adds a separate function to decode a rule, which expects the lock
to have been taken before it is called.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 60 ++++++++++---------
 .../microchip/vcap/vcap_api_debugfs.c         | 14 ++++-
 .../microchip/vcap/vcap_api_private.h         |  3 +
 3 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index f1dc4fd6bb96..198c36627ba1 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -2170,47 +2170,53 @@ void vcap_free_rule(struct vcap_rule *rule)
 }
 EXPORT_SYMBOL_GPL(vcap_free_rule);
 
-struct vcap_rule *vcap_get_rule(struct vcap_control *vctrl, u32 id)
+/* Decode a rule from the VCAP cache and return a copy */
+struct vcap_rule *vcap_decode_rule(struct vcap_rule_internal *elem)
 {
-	struct vcap_rule_internal *elem;
 	struct vcap_rule_internal *ri;
 	int err;
 
-	ri = NULL;
-
-	err = vcap_api_check(vctrl);
-	if (err)
-		return ERR_PTR(err);
-	elem = vcap_lookup_rule(vctrl, id);
-	if (!elem)
-		return NULL;
-	mutex_lock(&elem->admin->lock);
 	ri = vcap_dup_rule(elem, elem->state == VCAP_RS_DISABLED);
 	if (IS_ERR(ri))
-		goto unlock;
+		return ERR_PTR(PTR_ERR(ri));
 
 	if (ri->state == VCAP_RS_DISABLED)
-		goto unlock;
+		goto out;
 
 	err = vcap_read_rule(ri);
-	if (err) {
-		ri = ERR_PTR(err);
-		goto unlock;
-	}
+	if (err)
+		return ERR_PTR(err);
+
 	err = vcap_decode_keyset(ri);
-	if (err) {
-		ri = ERR_PTR(err);
-		goto unlock;
-	}
+	if (err)
+		return ERR_PTR(err);
+
 	err = vcap_decode_actionset(ri);
-	if (err) {
-		ri = ERR_PTR(err);
-		goto unlock;
-	}
+	if (err)
+		return ERR_PTR(err);
 
-unlock:
+out:
+	return &ri->data;
+}
+
+struct vcap_rule *vcap_get_rule(struct vcap_control *vctrl, u32 id)
+{
+	struct vcap_rule_internal *elem;
+	struct vcap_rule *rule;
+	int err;
+
+	err = vcap_api_check(vctrl);
+	if (err)
+		return ERR_PTR(err);
+
+	elem = vcap_lookup_rule(vctrl, id);
+	if (!elem)
+		return NULL;
+
+	mutex_lock(&elem->admin->lock);
+	rule = vcap_decode_rule(elem);
 	mutex_unlock(&elem->admin->lock);
-	return (struct vcap_rule *)ri;
+	return rule;
 }
 EXPORT_SYMBOL_GPL(vcap_get_rule);
 
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index dc06f6d4f513..d49b1cf7712f 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -295,7 +295,7 @@ static int vcap_show_admin(struct vcap_control *vctrl,
 
 	vcap_show_admin_info(vctrl, admin, out);
 	list_for_each_entry(elem, &admin->rules, list) {
-		vrule = vcap_get_rule(vctrl, elem->data.id);
+		vrule = vcap_decode_rule(elem);
 		if (IS_ERR_OR_NULL(vrule)) {
 			ret = PTR_ERR(vrule);
 			break;
@@ -404,8 +404,12 @@ static int vcap_debugfs_show(struct seq_file *m, void *unused)
 		.prf = (void *)seq_printf,
 		.dst = m,
 	};
+	int ret;
 
-	return vcap_show_admin(info->vctrl, info->admin, &out);
+	mutex_lock(&info->admin->lock);
+	ret = vcap_show_admin(info->vctrl, info->admin, &out);
+	mutex_unlock(&info->admin->lock);
+	return ret;
 }
 DEFINE_SHOW_ATTRIBUTE(vcap_debugfs);
 
@@ -417,8 +421,12 @@ static int vcap_raw_debugfs_show(struct seq_file *m, void *unused)
 		.prf = (void *)seq_printf,
 		.dst = m,
 	};
+	int ret;
 
-	return vcap_show_admin_raw(info->vctrl, info->admin, &out);
+	mutex_lock(&info->admin->lock);
+	ret = vcap_show_admin_raw(info->vctrl, info->admin, &out);
+	mutex_unlock(&info->admin->lock);
+	return ret;
 }
 DEFINE_SHOW_ATTRIBUTE(vcap_raw_debugfs);
 
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
index 86542accffe6..df81d9ff502b 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
@@ -118,4 +118,7 @@ int vcap_find_keystream_keysets(struct vcap_control *vctrl, enum vcap_type vt,
 /* Get the keysets that matches the rule key type/mask */
 int vcap_rule_get_keysets(struct vcap_rule_internal *ri,
 			  struct vcap_keyset_list *matches);
+/* Decode a rule from the VCAP cache and return a copy */
+struct vcap_rule *vcap_decode_rule(struct vcap_rule_internal *elem);
+
 #endif /* __VCAP_API_PRIVATE__ */
-- 
2.39.0

