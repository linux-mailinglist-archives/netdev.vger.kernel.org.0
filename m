Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54B06531AE
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 14:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiLUN0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 08:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbiLUN0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 08:26:09 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B0F2189C;
        Wed, 21 Dec 2022 05:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671629152; x=1703165152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4DU/b9R3AaK8sEFgLtyckm5fo5agE5gpjqsqXbgkQUY=;
  b=Ldv4vxmUWBx2Rv9lXvpws+/d1D/JEVBQLPQTYAkF4ic5E4X6OBqeK5Vm
   2O3zvQWsFlqhcqLPLdOYMaB49adidYK3UUlJtqwFjfE4SDCkBusyO/98s
   Lxhcm1ZJEnYF+8310/4PyhX/2lkKIw4J4zR6xDzjgtx/i2b2veSKsZTpe
   JVcYgumTqc9rdZqOJR//HzK7p/oc4+Asj2DrPgPF4F6ovjBrqHDNfYC15
   bo9K5KaUeNJFV2EuySG1Ul1YxZ3lPtPvFNSM9DzWq0Tu1U8uEnQywuCsa
   lKHM8OfJonm8PmksSNCOlXPe9LgoxUXyOukVxYscPXDgA4mH1jbGccuTs
   w==;
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="189168656"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2022 06:25:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 21 Dec 2022 06:25:38 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 21 Dec 2022 06:25:35 -0700
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
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH net 3/8] net: microchip: vcap api: Always enable VCAP lookups
Date:   Wed, 21 Dec 2022 14:25:12 +0100
Message-ID: <20221221132517.2699698-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221221132517.2699698-1-steen.hegelund@microchip.com>
References: <20221221132517.2699698-1-steen.hegelund@microchip.com>
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

This changes the VCAP lookups state to always be enabled so that it is
possible to add "internal" VCAP rules that must be available even though
the user has not yet enabled the VCAP chains via a TC matchall filter.

The API callback to enable and disable VCAP lookups is therefore removed.

Fixes: 4426b78c626d ("net: lan966x: Add port keyset config and callback interface")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/lan966x/lan966x_vcap_impl.c     | 24 ++++-----------
 .../microchip/sparx5/sparx5_vcap_debugfs.c    |  2 +-
 .../microchip/sparx5/sparx5_vcap_impl.c       | 29 ++++---------------
 .../net/ethernet/microchip/vcap/vcap_api.c    |  6 +---
 .../net/ethernet/microchip/vcap/vcap_api.h    |  5 ----
 .../microchip/vcap/vcap_api_debugfs_kunit.c   |  9 +-----
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |  9 +-----
 7 files changed, 16 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
index d8dc9fbb81e1..76a9fb113f50 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -95,10 +95,7 @@ lan966x_vcap_is2_get_port_keysets(struct net_device *dev, int lookup,
 	bool found = false;
 	u32 val;
 
-	/* Check if the port keyset selection is enabled */
 	val = lan_rd(lan966x, ANA_VCAP_S2_CFG(port->chip_port));
-	if (!ANA_VCAP_S2_CFG_ENA_GET(val))
-		return -ENOENT;
 
 	/* Collect all keysets for the port in a list */
 	if (l3_proto == ETH_P_ALL)
@@ -393,20 +390,6 @@ static int lan966x_vcap_port_info(struct net_device *dev,
 	return 0;
 }
 
-static int lan966x_vcap_enable(struct net_device *dev,
-			       struct vcap_admin *admin,
-			       bool enable)
-{
-	struct lan966x_port *port = netdev_priv(dev);
-	struct lan966x *lan966x = port->lan966x;
-
-	lan_rmw(ANA_VCAP_S2_CFG_ENA_SET(enable),
-		ANA_VCAP_S2_CFG_ENA,
-		lan966x, ANA_VCAP_S2_CFG(port->chip_port));
-
-	return 0;
-}
-
 static struct vcap_operations lan966x_vcap_ops = {
 	.validate_keyset = lan966x_vcap_validate_keyset,
 	.add_default_fields = lan966x_vcap_add_default_fields,
@@ -417,7 +400,6 @@ static struct vcap_operations lan966x_vcap_ops = {
 	.update = lan966x_vcap_update,
 	.move = lan966x_vcap_move,
 	.port_info = lan966x_vcap_port_info,
-	.enable = lan966x_vcap_enable,
 };
 
 static void lan966x_vcap_admin_free(struct vcap_admin *admin)
@@ -524,6 +506,12 @@ int lan966x_vcap_init(struct lan966x *lan966x)
 		list_add_tail(&admin->list, &ctrl->list);
 	}
 
+	for (int p = 0; p < lan966x->num_phys_ports; ++p)
+		if (lan966x->ports[p])
+			lan_rmw(ANA_VCAP_S2_CFG_ENA_SET(true),
+				ANA_VCAP_S2_CFG_ENA, lan966x,
+				ANA_VCAP_S2_CFG(lan966x->ports[p]->chip_port));
+
 	lan966x->vcap_ctrl = ctrl;
 
 	return 0;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
index b91e05ffe2f4..c9423adc92ce 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
@@ -29,7 +29,7 @@ static void sparx5_vcap_port_keys(struct sparx5 *sparx5,
 		/* Get lookup state */
 		value = spx5_rd(sparx5, ANA_ACL_VCAP_S2_CFG(port->portno));
 		out->prf(out->dst, "\n      state: ");
-		if (ANA_ACL_VCAP_S2_CFG_SEC_ENA_GET(value))
+		if (ANA_ACL_VCAP_S2_CFG_SEC_ENA_GET(value) & BIT(lookup))
 			out->prf(out->dst, "on");
 		else
 			out->prf(out->dst, "off");
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index a0c126ba9a87..0d4b40997bb4 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -510,28 +510,6 @@ static void sparx5_vcap_move(struct net_device *ndev, struct vcap_admin *admin,
 	sparx5_vcap_wait_super_update(sparx5);
 }
 
-/* Enable all lookups in the VCAP instance */
-static int sparx5_vcap_enable(struct net_device *ndev,
-			      struct vcap_admin *admin,
-			      bool enable)
-{
-	struct sparx5_port *port = netdev_priv(ndev);
-	struct sparx5 *sparx5;
-	int portno;
-
-	sparx5 = port->sparx5;
-	portno = port->portno;
-
-	/* For now we only consider IS2 */
-	if (enable)
-		spx5_wr(ANA_ACL_VCAP_S2_CFG_SEC_ENA_SET(0xf), sparx5,
-			ANA_ACL_VCAP_S2_CFG(portno));
-	else
-		spx5_wr(ANA_ACL_VCAP_S2_CFG_SEC_ENA_SET(0), sparx5,
-			ANA_ACL_VCAP_S2_CFG(portno));
-	return 0;
-}
-
 /* API callback operations: only IS2 is supported for now */
 static struct vcap_operations sparx5_vcap_ops = {
 	.validate_keyset = sparx5_vcap_validate_keyset,
@@ -543,7 +521,6 @@ static struct vcap_operations sparx5_vcap_ops = {
 	.update = sparx5_vcap_update,
 	.move = sparx5_vcap_move,
 	.port_info = sparx5_port_info,
-	.enable = sparx5_vcap_enable,
 };
 
 /* Enable lookups per port and set the keyset generation: only IS2 for now */
@@ -568,6 +545,12 @@ static void sparx5_vcap_port_key_selection(struct sparx5 *sparx5,
 				ANA_ACL_VCAP_S2_KEY_SEL(portno, lookup));
 		}
 	}
+	/* IS2 lookups are in bit 0:3 */
+	for (portno = 0; portno < SPX5_PORTS; ++portno)
+		spx5_rmw(ANA_ACL_VCAP_S2_CFG_SEC_ENA_SET(0xf),
+			 ANA_ACL_VCAP_S2_CFG_SEC_ENA,
+			 sparx5,
+			 ANA_ACL_VCAP_S2_CFG(portno));
 }
 
 /* Disable lookups per port and set the keyset generation: only IS2 for now */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 67e0a3d9103a..9de5367fde42 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -738,7 +738,7 @@ int vcap_api_check(struct vcap_control *ctrl)
 	    !ctrl->ops->add_default_fields || !ctrl->ops->cache_erase ||
 	    !ctrl->ops->cache_write || !ctrl->ops->cache_read ||
 	    !ctrl->ops->init || !ctrl->ops->update || !ctrl->ops->move ||
-	    !ctrl->ops->port_info || !ctrl->ops->enable) {
+	    !ctrl->ops->port_info) {
 		pr_err("%s:%d: client operations are missing\n",
 		       __func__, __LINE__);
 		return -ENOENT;
@@ -2654,10 +2654,6 @@ int vcap_enable_lookups(struct vcap_control *vctrl, struct net_device *ndev,
 	if (admin->vinst || chain_id > admin->first_cid)
 		return -EFAULT;
 
-	err = vctrl->ops->enable(ndev, admin, enable);
-	if (err)
-		return err;
-
 	if (chain_id) {
 		if (vcap_is_enabled(admin, ndev, cookie))
 			return -EADDRINUSE;
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.h b/drivers/net/ethernet/microchip/vcap/vcap_api.h
index 689c7270f2a8..c61f13a65030 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.h
@@ -259,11 +259,6 @@ struct vcap_operations {
 		(struct net_device *ndev,
 		 struct vcap_admin *admin,
 		 struct vcap_output_print *out);
-	/* enable/disable the lookups in a vcap instance */
-	int (*enable)
-		(struct net_device *ndev,
-		 struct vcap_admin *admin,
-		 bool enable);
 };
 
 /* VCAP API Client control interface */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
index cf594668d5d9..bef0b28a4a50 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
@@ -221,13 +221,6 @@ static int vcap_test_port_info(struct net_device *ndev,
 	return 0;
 }
 
-static int vcap_test_enable(struct net_device *ndev,
-			    struct vcap_admin *admin,
-			    bool enable)
-{
-	return 0;
-}
-
 static struct vcap_operations test_callbacks = {
 	.validate_keyset = test_val_keyset,
 	.add_default_fields = test_add_def_fields,
@@ -238,7 +231,6 @@ static struct vcap_operations test_callbacks = {
 	.update = test_cache_update,
 	.move = test_cache_move,
 	.port_info = vcap_test_port_info,
-	.enable = vcap_test_enable,
 };
 
 static struct vcap_control test_vctrl = {
@@ -253,6 +245,7 @@ static void vcap_test_api_init(struct vcap_admin *admin)
 	INIT_LIST_HEAD(&test_vctrl.list);
 	INIT_LIST_HEAD(&admin->list);
 	INIT_LIST_HEAD(&admin->rules);
+	INIT_LIST_HEAD(&admin->enabled);
 	list_add_tail(&admin->list, &test_vctrl.list);
 	memset(test_updateaddr, 0, sizeof(test_updateaddr));
 	test_updateaddridx = 0;
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index 944de5cb9114..cc6a62338162 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -211,13 +211,6 @@ static int vcap_test_port_info(struct net_device *ndev,
 	return 0;
 }
 
-static int vcap_test_enable(struct net_device *ndev,
-			    struct vcap_admin *admin,
-			    bool enable)
-{
-	return 0;
-}
-
 static struct vcap_operations test_callbacks = {
 	.validate_keyset = test_val_keyset,
 	.add_default_fields = test_add_def_fields,
@@ -228,7 +221,6 @@ static struct vcap_operations test_callbacks = {
 	.update = test_cache_update,
 	.move = test_cache_move,
 	.port_info = vcap_test_port_info,
-	.enable = vcap_test_enable,
 };
 
 static struct vcap_control test_vctrl = {
@@ -243,6 +235,7 @@ static void vcap_test_api_init(struct vcap_admin *admin)
 	INIT_LIST_HEAD(&test_vctrl.list);
 	INIT_LIST_HEAD(&admin->list);
 	INIT_LIST_HEAD(&admin->rules);
+	INIT_LIST_HEAD(&admin->enabled);
 	list_add_tail(&admin->list, &test_vctrl.list);
 	memset(test_updateaddr, 0, sizeof(test_updateaddr));
 	test_updateaddridx = 0;
-- 
2.39.0

