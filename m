Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAAB62E702
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241000AbiKQVc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240997AbiKQVcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:32:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A179061520;
        Thu, 17 Nov 2022 13:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668720712; x=1700256712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=daU/1NauHUHLkSJsDhAoxGxvrqsIoO4bsGuUOZCnFtc=;
  b=2dV/WTyPancHgyOKWe3tIBr0KL5xilHYmktGCliSAkTOlGvGuPTpmB+g
   /DXNzGb/flbEL8gvLi6ZumenZave65oB7alsF3AOruAu9aKf6hYE+66Kn
   2jy4TPlM0I2fkKQXk7SBR/C/oAXGKF74TJnLDSEl4h53kmHVvw3HgI6ah
   WL1X5fdHANcc7SHPpURmFttab4q3U3jnNpRQazZejn5neArl2zgfRckTO
   rf/bKGnjYg32+oSwQ1tjTYCLULnXVbMiAkxrCrR/BpHAaDeUUOb4GS01H
   /x344sLHBr1xFLLANzGEQIHvNdUmnbE2a15rGW16/0usZcte3fYDdGSZ9
   w==;
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="123980093"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2022 14:31:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 17 Nov 2022 14:31:47 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 17 Nov 2022 14:31:44 -0700
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
Subject: [PATCH net-next v2 7/8] net: microchip: sparx5: Add VCAP locking to protect rules
Date:   Thu, 17 Nov 2022 22:31:13 +0100
Message-ID: <20221117213114.699375-8-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221117213114.699375-1-steen.hegelund@microchip.com>
References: <20221117213114.699375-1-steen.hegelund@microchip.com>
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

This ensures that the VCAP cache and the lists maintained in the VCAP
instance is protected when accessed by different clients.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/sparx5/sparx5_vcap_impl.c   |  2 ++
 drivers/net/ethernet/microchip/vcap/vcap_api.c         | 10 ++++++++++
 drivers/net/ethernet/microchip/vcap/vcap_api.h         |  1 +
 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c |  2 ++
 4 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index e70ff1aa6d57..0c4d4e6d51e6 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -579,6 +579,7 @@ static void sparx5_vcap_admin_free(struct vcap_admin *admin)
 {
 	if (!admin)
 		return;
+	mutex_destroy(&admin->lock);
 	kfree(admin->cache.keystream);
 	kfree(admin->cache.maskstream);
 	kfree(admin->cache.actionstream);
@@ -598,6 +599,7 @@ sparx5_vcap_admin_alloc(struct sparx5 *sparx5, struct vcap_control *ctrl,
 	INIT_LIST_HEAD(&admin->list);
 	INIT_LIST_HEAD(&admin->rules);
 	INIT_LIST_HEAD(&admin->enabled);
+	mutex_init(&admin->lock);
 	admin->vtype = cfg->vtype;
 	admin->vinst = cfg->vinst;
 	admin->lookups = cfg->lookups;
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 3415605350c9..ac7a32ff755e 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1054,6 +1054,7 @@ int vcap_add_rule(struct vcap_rule *rule)
 	if (ret)
 		return ret;
 	/* Insert the new rule in the list of vcap rules */
+	mutex_lock(&ri->admin->lock);
 	ret = vcap_insert_rule(ri, &move);
 	if (ret < 0) {
 		pr_err("%s:%d: could not insert rule in vcap list: %d\n",
@@ -1072,6 +1073,7 @@ int vcap_add_rule(struct vcap_rule *rule)
 	if (ret)
 		pr_err("%s:%d: rule write error: %d\n", __func__, __LINE__, ret);
 out:
+	mutex_unlock(&ri->admin->lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vcap_add_rule);
@@ -1221,9 +1223,11 @@ int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id)
 		gap = vcap_fill_rule_gap(ri);
 
 	/* Delete the rule from the list of rules and the cache */
+	mutex_lock(&admin->lock);
 	list_del(&ri->list);
 	vctrl->ops->init(ndev, admin, admin->last_used_addr, ri->size + gap);
 	kfree(ri);
+	mutex_unlock(&admin->lock);
 
 	/* Update the last used address, set to default when no rules */
 	if (list_empty(&admin->rules)) {
@@ -1246,6 +1250,8 @@ int vcap_del_rules(struct vcap_control *vctrl, struct vcap_admin *admin)
 
 	if (ret)
 		return ret;
+
+	mutex_lock(&admin->lock);
 	list_for_each_entry_safe(ri, next_ri, &admin->rules, list) {
 		vctrl->ops->init(ri->ndev, admin, ri->addr, ri->size);
 		list_del(&ri->list);
@@ -1258,6 +1264,7 @@ int vcap_del_rules(struct vcap_control *vctrl, struct vcap_admin *admin)
 		list_del(&eport->list);
 		kfree(eport);
 	}
+	mutex_unlock(&admin->lock);
 
 	return 0;
 }
@@ -1687,10 +1694,13 @@ int vcap_enable_lookups(struct vcap_control *vctrl, struct net_device *ndev,
 	if (chain_id) {
 		if (vcap_is_enabled(admin, ndev, cookie))
 			return -EADDRINUSE;
+		mutex_lock(&admin->lock);
 		vcap_enable(admin, ndev, cookie);
 	} else {
+		mutex_lock(&admin->lock);
 		vcap_disable(admin, ndev, cookie);
 	}
+	mutex_unlock(&admin->lock);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.h b/drivers/net/ethernet/microchip/vcap/vcap_api.h
index e71e7d3d79c2..f4a5ba5ffa87 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.h
@@ -167,6 +167,7 @@ struct vcap_admin {
 	struct list_head list; /* for insertion in vcap_control */
 	struct list_head rules; /* list of rules */
 	struct list_head enabled; /* list of enabled ports */
+	struct mutex lock; /* control access to rules */
 	enum vcap_type vtype;  /* type of vcap */
 	int vinst; /* instance number within the same type */
 	int first_cid; /* first chain id in this vcap */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index 981c4ed6ad7d..891034e349de 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -625,6 +625,7 @@ static int vcap_show_admin(struct vcap_control *vctrl,
 	int ret = 0;
 
 	vcap_show_admin_info(vctrl, admin, out);
+	mutex_lock(&admin->lock);
 	list_for_each_entry(elem, &admin->rules, list) {
 		ri = vcap_dup_rule(elem);
 		if (IS_ERR(ri))
@@ -638,6 +639,7 @@ static int vcap_show_admin(struct vcap_control *vctrl,
 free_rule:
 		vcap_free_rule((struct vcap_rule *)ri);
 	}
+	mutex_unlock(&admin->lock);
 	return ret;
 }
 
-- 
2.38.1

