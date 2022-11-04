Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B136F619946
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiKDOTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiKDOTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:19:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE8C2FC30;
        Fri,  4 Nov 2022 07:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667571545; x=1699107545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NO+FpIZlOCYQdnJnZ1KupBVNxYh+d/SE9S0ygZwEpd8=;
  b=Sha20havviYwdjkZQ2A84CwhjHmLlpIa8KJq38+MVaouE9NOXY/vt8oE
   ej6FkZidd8wHkE53uXSeUo5FXAp/2QKkrtyiBUq21GS8FmBphRDV43EHt
   VakLz9gIdzs4oHAqAzjrnXw4/ByeEGe1Bs9EQIqvzwELWcdnu6Y0M1/55
   GQs+ELpxk6eSZ7Vl9xx8InmNYtepc4bSdAc1pB1z+/mS+hMTbA1X410qS
   G0iu8XAYfnsbNEHbmo89dCqctIE9KZdUNOKsu9/l166IMYEDC+fKl3Qnz
   oYcu9kkG1w7yD5aYXesOsbgbYp+E9pAeHXFbh466BPLc0JJEVitV7uIHI
   w==;
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="185411594"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Nov 2022 07:19:04 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 4 Nov 2022 07:19:02 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 4 Nov 2022 07:18:59 -0700
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
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v5 7/8] net: microchip: sparx5: Add tc matchall filter and enable VCAP lookups
Date:   Fri, 4 Nov 2022 15:18:29 +0100
Message-ID: <20221104141830.1527159-8-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104141830.1527159-1-steen.hegelund@microchip.com>
References: <20221104141830.1527159-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a tc matchall rule with a goto action to the VCAP specific chain to
enable the VCAP lookups.
If the matchall rule is removed the VCAP lookups will be disabled
again using its cookie as lookup to find the VCAP instance.

To enable the Sparx5 IS2 VCAP on eth0 you would use this command:

    tc filter add dev eth0 ingress prio 5 handle 5 matchall \
        skip_sw action goto chain 8000000

as the first lookup in IS2 has chain id 8000000

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../net/ethernet/microchip/sparx5/sparx5_tc.c |   9 +-
 .../net/ethernet/microchip/sparx5/sparx5_tc.h |   5 +
 .../microchip/sparx5/sparx5_tc_matchall.c     |  97 ++++++++++++++
 .../microchip/sparx5/sparx5_vcap_impl.c       |  29 ++++-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 120 +++++++++++++++++-
 .../net/ethernet/microchip/vcap/vcap_api.h    |   6 +
 .../ethernet/microchip/vcap/vcap_api_client.h |   4 +
 8 files changed, 263 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index ee2c42f66742..9348e171b990 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -9,7 +9,7 @@ sparx5-switch-y  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_phylink.o sparx5_port.o sparx5_mactable.o sparx5_vlan.o \
  sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
  sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o \
- sparx5_vcap_impl.o sparx5_vcap_ag_api.o sparx5_tc_flower.o
+ sparx5_vcap_impl.o sparx5_vcap_ag_api.o sparx5_tc_flower.o sparx5_tc_matchall.o
 
 # Provide include files
 ccflags-y += -I$(srctree)/drivers/net/ethernet/microchip/vcap
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
index 9432251b8322..edd4c53dcce2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
@@ -19,9 +19,14 @@ static int sparx5_tc_block_cb(enum tc_setup_type type,
 {
 	struct net_device *ndev = cb_priv;
 
-	if (type == TC_SETUP_CLSFLOWER)
+	switch (type) {
+	case TC_SETUP_CLSMATCHALL:
+		return sparx5_tc_matchall(ndev, type_data, ingress);
+	case TC_SETUP_CLSFLOWER:
 		return sparx5_tc_flower(ndev, type_data, ingress);
-	return -EOPNOTSUPP;
+	default:
+		return -EOPNOTSUPP;
+	}
 }
 
 static int sparx5_tc_block_cb_ingress(enum tc_setup_type type,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
index 2b07a93fc9b7..adab88e6b21f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
@@ -8,6 +8,7 @@
 #define __SPARX5_TC_H__
 
 #include <net/flow_offload.h>
+#include <net/pkt_cls.h>
 #include <linux/netdevice.h>
 
 /* Controls how PORT_MASK is applied */
@@ -23,6 +24,10 @@ enum SPX5_PORT_MASK_MODE {
 int sparx5_port_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			 void *type_data);
 
+int sparx5_tc_matchall(struct net_device *ndev,
+		       struct tc_cls_matchall_offload *tmo,
+		       bool ingress);
+
 int sparx5_tc_flower(struct net_device *ndev, struct flow_cls_offload *fco,
 		     bool ingress);
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c
new file mode 100644
index 000000000000..30dd61e5d150
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip VCAP API
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_tc.h"
+#include "vcap_api.h"
+#include "vcap_api_client.h"
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+#include "sparx5_vcap_impl.h"
+
+static int sparx5_tc_matchall_replace(struct net_device *ndev,
+				      struct tc_cls_matchall_offload *tmo,
+				      bool ingress)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct flow_action_entry *action;
+	struct sparx5 *sparx5;
+	int err;
+
+	if (!flow_offload_has_one_action(&tmo->rule->action)) {
+		NL_SET_ERR_MSG_MOD(tmo->common.extack,
+				   "Only one action per filter is supported");
+		return -EOPNOTSUPP;
+	}
+	action = &tmo->rule->action.entries[0];
+
+	sparx5 = port->sparx5;
+	switch (action->id) {
+	case FLOW_ACTION_GOTO:
+		err = vcap_enable_lookups(sparx5->vcap_ctrl, ndev,
+					  action->chain_index, tmo->cookie,
+					  true);
+		if (err == -EFAULT) {
+			NL_SET_ERR_MSG_MOD(tmo->common.extack,
+					   "Unsupported goto chain");
+			return -EOPNOTSUPP;
+		}
+		if (err == -EADDRINUSE) {
+			NL_SET_ERR_MSG_MOD(tmo->common.extack,
+					   "VCAP already enabled");
+			return -EOPNOTSUPP;
+		}
+		if (err) {
+			NL_SET_ERR_MSG_MOD(tmo->common.extack,
+					   "Could not enable VCAP lookups");
+			return err;
+		}
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(tmo->common.extack, "Unsupported action");
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+static int sparx5_tc_matchall_destroy(struct net_device *ndev,
+				      struct tc_cls_matchall_offload *tmo,
+				      bool ingress)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5;
+	int err;
+
+	sparx5 = port->sparx5;
+	if (!tmo->rule && tmo->cookie) {
+		err = vcap_enable_lookups(sparx5->vcap_ctrl, ndev, 0,
+					  tmo->cookie, false);
+		if (err)
+			return err;
+		return 0;
+	}
+	NL_SET_ERR_MSG_MOD(tmo->common.extack, "Unsupported action");
+	return -EOPNOTSUPP;
+}
+
+int sparx5_tc_matchall(struct net_device *ndev,
+		       struct tc_cls_matchall_offload *tmo,
+		       bool ingress)
+{
+	if (!tc_cls_can_offload_and_chain0(ndev, &tmo->common)) {
+		NL_SET_ERR_MSG_MOD(tmo->common.extack,
+				   "Only chain zero is supported");
+		return -EOPNOTSUPP;
+	}
+
+	switch (tmo->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return sparx5_tc_matchall_replace(ndev, tmo, ingress);
+	case TC_CLSMATCHALL_DESTROY:
+		return sparx5_tc_matchall_destroy(ndev, tmo, ingress);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index 642c27299e22..10bc56cd0045 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -489,6 +489,28 @@ static int sparx5_port_info(struct net_device *ndev, enum vcap_type vtype,
 	return 0;
 }
 
+/* Enable all lookups in the VCAP instance */
+static int sparx5_vcap_enable(struct net_device *ndev,
+			      struct vcap_admin *admin,
+			      bool enable)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5;
+	int portno;
+
+	sparx5 = port->sparx5;
+	portno = port->portno;
+
+	/* For now we only consider IS2 */
+	if (enable)
+		spx5_wr(ANA_ACL_VCAP_S2_CFG_SEC_ENA_SET(0xf), sparx5,
+			ANA_ACL_VCAP_S2_CFG(portno));
+	else
+		spx5_wr(ANA_ACL_VCAP_S2_CFG_SEC_ENA_SET(0), sparx5,
+			ANA_ACL_VCAP_S2_CFG(portno));
+	return 0;
+}
+
 /* API callback operations: only IS2 is supported for now */
 static struct vcap_operations sparx5_vcap_ops = {
 	.validate_keyset = sparx5_vcap_validate_keyset,
@@ -500,6 +522,7 @@ static struct vcap_operations sparx5_vcap_ops = {
 	.update = sparx5_vcap_update,
 	.move = sparx5_vcap_move,
 	.port_info = sparx5_port_info,
+	.enable = sparx5_vcap_enable,
 };
 
 /* Enable lookups per port and set the keyset generation: only IS2 for now */
@@ -509,11 +532,6 @@ static void sparx5_vcap_port_key_selection(struct sparx5 *sparx5,
 	int portno, lookup;
 	u32 keysel;
 
-	/* enable all 4 lookups on all ports */
-	for (portno = 0; portno < SPX5_PORTS; ++portno)
-		spx5_wr(ANA_ACL_VCAP_S2_CFG_SEC_ENA_SET(0xf), sparx5,
-			ANA_ACL_VCAP_S2_CFG(portno));
-
 	/* all traffic types generate the MAC_ETYPE keyset for now in all
 	 * lookups on all ports
 	 */
@@ -566,6 +584,7 @@ sparx5_vcap_admin_alloc(struct sparx5 *sparx5, struct vcap_control *ctrl,
 		return ERR_PTR(-ENOMEM);
 	INIT_LIST_HEAD(&admin->list);
 	INIT_LIST_HEAD(&admin->rules);
+	INIT_LIST_HEAD(&admin->enabled);
 	admin->vtype = cfg->vtype;
 	admin->vinst = cfg->vinst;
 	admin->lookups = cfg->lookups;
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 73ec7744c21f..b6ab6bae28c0 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -44,6 +44,13 @@ struct vcap_stream_iter {
 	const struct vcap_typegroup *tg; /* current typegroup */
 };
 
+/* Stores the filter cookie that enabled the port */
+struct vcap_enabled_port {
+	struct list_head list; /* for insertion in enabled ports list */
+	struct net_device *ndev;  /* the enabled port */
+	unsigned long cookie; /* filter that enabled the port */
+};
+
 static void vcap_iter_set(struct vcap_stream_iter *itr, int sw_width,
 			  const struct vcap_typegroup *tg, u32 offset)
 {
@@ -516,7 +523,7 @@ static int vcap_api_check(struct vcap_control *ctrl)
 	    !ctrl->ops->add_default_fields || !ctrl->ops->cache_erase ||
 	    !ctrl->ops->cache_write || !ctrl->ops->cache_read ||
 	    !ctrl->ops->init || !ctrl->ops->update || !ctrl->ops->move ||
-	    !ctrl->ops->port_info) {
+	    !ctrl->ops->port_info || !ctrl->ops->enable) {
 		pr_err("%s:%d: client operations are missing\n",
 		       __func__, __LINE__);
 		return -ENOENT;
@@ -1128,6 +1135,7 @@ EXPORT_SYMBOL_GPL(vcap_del_rule);
 /* Delete all rules in the VCAP instance */
 int vcap_del_rules(struct vcap_control *vctrl, struct vcap_admin *admin)
 {
+	struct vcap_enabled_port *eport, *next_eport;
 	struct vcap_rule_internal *ri, *next_ri;
 	int ret = vcap_api_check(vctrl);
 
@@ -1139,6 +1147,13 @@ int vcap_del_rules(struct vcap_control *vctrl, struct vcap_admin *admin)
 		kfree(ri);
 	}
 	admin->last_used_addr = admin->last_valid_addr;
+
+	/* Remove list of enabled ports */
+	list_for_each_entry_safe(eport, next_eport, &admin->enabled, list) {
+		list_del(&eport->list);
+		kfree(eport);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vcap_del_rules);
@@ -1459,6 +1474,109 @@ void vcap_set_tc_exterr(struct flow_cls_offload *fco, struct vcap_rule *vrule)
 }
 EXPORT_SYMBOL_GPL(vcap_set_tc_exterr);
 
+/* Check if this port is already enabled for this VCAP instance */
+static bool vcap_is_enabled(struct vcap_admin *admin, struct net_device *ndev,
+			    unsigned long cookie)
+{
+	struct vcap_enabled_port *eport;
+
+	list_for_each_entry(eport, &admin->enabled, list)
+		if (eport->cookie == cookie || eport->ndev == ndev)
+			return true;
+
+	return false;
+}
+
+/* Enable this port for this VCAP instance */
+static int vcap_enable(struct vcap_admin *admin, struct net_device *ndev,
+		       unsigned long cookie)
+{
+	struct vcap_enabled_port *eport;
+
+	eport = kzalloc(sizeof(*eport), GFP_KERNEL);
+	if (!eport)
+		return -ENOMEM;
+
+	eport->ndev = ndev;
+	eport->cookie = cookie;
+	list_add_tail(&eport->list, &admin->enabled);
+
+	return 0;
+}
+
+/* Disable this port for this VCAP instance */
+static int vcap_disable(struct vcap_admin *admin, struct net_device *ndev,
+			unsigned long cookie)
+{
+	struct vcap_enabled_port *eport;
+
+	list_for_each_entry(eport, &admin->enabled, list) {
+		if (eport->cookie == cookie && eport->ndev == ndev) {
+			list_del(&eport->list);
+			kfree(eport);
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+/* Find the VCAP instance that enabled the port using a specific filter */
+static struct vcap_admin *vcap_find_admin_by_cookie(struct vcap_control *vctrl,
+						    unsigned long cookie)
+{
+	struct vcap_enabled_port *eport;
+	struct vcap_admin *admin;
+
+	list_for_each_entry(admin, &vctrl->list, list)
+		list_for_each_entry(eport, &admin->enabled, list)
+			if (eport->cookie == cookie)
+				return admin;
+
+	return NULL;
+}
+
+/* Enable/Disable the VCAP instance lookups. Chain id 0 means disable */
+int vcap_enable_lookups(struct vcap_control *vctrl, struct net_device *ndev,
+			int chain_id, unsigned long cookie, bool enable)
+{
+	struct vcap_admin *admin;
+	int err;
+
+	err = vcap_api_check(vctrl);
+	if (err)
+		return err;
+
+	if (!ndev)
+		return -ENODEV;
+
+	if (chain_id)
+		admin = vcap_find_admin(vctrl, chain_id);
+	else
+		admin = vcap_find_admin_by_cookie(vctrl, cookie);
+	if (!admin)
+		return -ENOENT;
+
+	/* first instance and first chain */
+	if (admin->vinst || chain_id > admin->first_cid)
+		return -EFAULT;
+
+	err = vctrl->ops->enable(ndev, admin, enable);
+	if (err)
+		return err;
+
+	if (chain_id) {
+		if (vcap_is_enabled(admin, ndev, cookie))
+			return -EADDRINUSE;
+		vcap_enable(admin, ndev, cookie);
+	} else {
+		vcap_disable(admin, ndev, cookie);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vcap_enable_lookups);
+
 #ifdef CONFIG_VCAP_KUNIT_TEST
 #include "vcap_api_kunit.c"
 #endif
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.h b/drivers/net/ethernet/microchip/vcap/vcap_api.h
index eb2eae75c7e8..bfb8ad535074 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.h
@@ -166,6 +166,7 @@ enum vcap_rule_error {
 struct vcap_admin {
 	struct list_head list; /* for insertion in vcap_control */
 	struct list_head rules; /* list of rules */
+	struct list_head enabled; /* list of enabled ports */
 	enum vcap_type vtype;  /* type of vcap */
 	int vinst; /* instance number within the same type */
 	int first_cid; /* first chain id in this vcap */
@@ -255,6 +256,11 @@ struct vcap_operations {
 		 int (*pf)(void *out, int arg, const char *fmt, ...),
 		 void *out,
 		 int arg);
+	/* enable/disable the lookups in a vcap instance */
+	int (*enable)
+		(struct net_device *ndev,
+		 struct vcap_admin *admin,
+		 bool enable);
 };
 
 /* VCAP API Client control interface */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 077e49c4f3be..0ea5ec96adc8 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -143,6 +143,10 @@ enum vcap_bit {
 	VCAP_BIT_1
 };
 
+/* Enable/Disable the VCAP instance lookups. Chain id 0 means disable */
+int vcap_enable_lookups(struct vcap_control *vctrl, struct net_device *ndev,
+			int chain_id, unsigned long cookie, bool enable);
+
 /* VCAP rule operations */
 /* Allocate a rule and fill in the basic information */
 struct vcap_rule *vcap_alloc_rule(struct vcap_control *vctrl,
-- 
2.38.1

