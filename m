Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE0D6531AB
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 14:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiLUN0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 08:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbiLUN0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 08:26:07 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD931164A5;
        Wed, 21 Dec 2022 05:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671629146; x=1703165146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/RTwTLDrJMnyK/TWR8IfZ51x8eyC9HI65tXKkehf1xs=;
  b=bTtlIkqL+u94agaTZzWLk50/y/nQ1HUjK4WWaR0aWnzK6xFPFmWkbXaI
   p0VW4UHZBrlu/DPalfBxwn2EzcM2cBlET8iXIMP+ko62aRVwh3Awz9hk3
   EmIGrUhDjhlQi7KvT/e5GL3RiD/PAeTreBpL/iyx14ZCsCHFFvItcwQxT
   RVKxH0Br1LbepIdVyEKMT57q82t23yizQA/4iVWbiAWYIOYepsJB3uQdt
   +IOBbzRANSIineIM+qY+ihaRDyPvrwkWYN018M0XkfpYeyBgcdVI//phH
   VlXVaxzGZPfnwY/kILRnBdVEgjlZw/7kDib36jGbzOZlb2JW5NtyiN+df
   A==;
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="193916215"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2022 06:25:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 21 Dec 2022 06:25:45 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 21 Dec 2022 06:25:42 -0700
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
Subject: [PATCH net 5/8] net: microchip: vcap api: Use src and dst chain id to chain VCAP lookups
Date:   Wed, 21 Dec 2022 14:25:14 +0100
Message-ID: <20221221132517.2699698-6-steen.hegelund@microchip.com>
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

This adds both the source and destination chain id to the information kept
for enabled port lookups.
This allows enabling and disabling a chain of lookups by walking the chain
information for a port.

This changes the way that VCAP lookups are enabled from userspace: instead
of one matchall rule that enables all the 4 Sparx5 IS2 lookups, you need a
matchall rule per lookup.

In practice that is done by adding one matchall rule in chain 0 to goto IS2
Lookup 0, and then for each lookup you add a rule per lookup (low priority)
that does a goto to the next lookup chain.

Examples:

If you want IS2 Lookup 0 to be enabled you add the same matchall filter as
before:

tc filter add dev eth12 ingress chain 0 prio 1000 handle 1000 matchall \
       skip_sw action goto chain 8000000

If you also want to enable lookup 1 to 3 in IS2 and chain them you need
to add the following matchall filters:

tc filter add dev eth12 ingress chain 8000000 prio 1000 handle 1000 \
    matchall skip_sw action goto chain 8100000

tc filter add dev eth12 ingress chain 8100000 prio 1000 handle 1000 \
    matchall skip_sw action goto chain 8200000

tc filter add dev eth12 ingress chain 8200000 prio 1000 handle 1000 \
    matchall skip_sw action goto chain 8300000

Fixes: 4426b78c626d ("net: lan966x: Add port keyset config and callback interface")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_goto.c |  10 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |   3 +-
 .../microchip/lan966x/lan966x_tc_matchall.c   |  16 +--
 .../microchip/sparx5/sparx5_tc_matchall.c     |  16 +--
 .../net/ethernet/microchip/vcap/vcap_api.c    | 126 ++++++++++--------
 .../ethernet/microchip/vcap/vcap_api_client.h |   5 +-
 6 files changed, 92 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_goto.c b/drivers/net/ethernet/microchip/lan966x/lan966x_goto.c
index bf0cfe24a8fc..9b18156eea1a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_goto.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_goto.c
@@ -4,7 +4,7 @@
 #include "vcap_api_client.h"
 
 int lan966x_goto_port_add(struct lan966x_port *port,
-			  struct flow_action_entry *act,
+			  int from_cid, int to_cid,
 			  unsigned long goto_id,
 			  struct netlink_ext_ack *extack)
 {
@@ -12,7 +12,7 @@ int lan966x_goto_port_add(struct lan966x_port *port,
 	int err;
 
 	err = vcap_enable_lookups(lan966x->vcap_ctrl, port->dev,
-				  act->chain_index, goto_id,
+				  from_cid, to_cid, goto_id,
 				  true);
 	if (err == -EFAULT) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported goto chain");
@@ -29,8 +29,6 @@ int lan966x_goto_port_add(struct lan966x_port *port,
 		return err;
 	}
 
-	port->tc.goto_id = goto_id;
-
 	return 0;
 }
 
@@ -41,14 +39,12 @@ int lan966x_goto_port_del(struct lan966x_port *port,
 	struct lan966x *lan966x = port->lan966x;
 	int err;
 
-	err = vcap_enable_lookups(lan966x->vcap_ctrl, port->dev, 0,
+	err = vcap_enable_lookups(lan966x->vcap_ctrl, port->dev, 0, 0,
 				  goto_id, false);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Could not disable VCAP lookups");
 		return err;
 	}
 
-	port->tc.goto_id = 0;
-
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 3491f1961835..0106f9487cbe 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -332,7 +332,6 @@ struct lan966x_port_tc {
 	unsigned long police_id;
 	unsigned long ingress_mirror_id;
 	unsigned long egress_mirror_id;
-	unsigned long goto_id;
 	struct flow_stats police_stat;
 	struct flow_stats mirror_stat;
 };
@@ -607,7 +606,7 @@ int lan966x_tc_flower(struct lan966x_port *port,
 		      struct flow_cls_offload *f);
 
 int lan966x_goto_port_add(struct lan966x_port *port,
-			  struct flow_action_entry *act,
+			  int from_cid, int to_cid,
 			  unsigned long goto_id,
 			  struct netlink_ext_ack *extack);
 int lan966x_goto_port_del(struct lan966x_port *port,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
index a539abaad9b6..20627323d656 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
@@ -24,7 +24,8 @@ static int lan966x_tc_matchall_add(struct lan966x_port *port,
 		return lan966x_mirror_port_add(port, act, f->cookie,
 					       ingress, f->common.extack);
 	case FLOW_ACTION_GOTO:
-		return lan966x_goto_port_add(port, act, f->cookie,
+		return lan966x_goto_port_add(port, f->common.chain_index,
+					     act->chain_index, f->cookie,
 					     f->common.extack);
 	default:
 		NL_SET_ERR_MSG_MOD(f->common.extack,
@@ -46,13 +47,8 @@ static int lan966x_tc_matchall_del(struct lan966x_port *port,
 		   f->cookie == port->tc.egress_mirror_id) {
 		return lan966x_mirror_port_del(port, ingress,
 					       f->common.extack);
-	} else if (f->cookie == port->tc.goto_id) {
-		return lan966x_goto_port_del(port, f->cookie,
-					     f->common.extack);
 	} else {
-		NL_SET_ERR_MSG_MOD(f->common.extack,
-				   "Unsupported action");
-		return -EOPNOTSUPP;
+		return lan966x_goto_port_del(port, f->cookie, f->common.extack);
 	}
 
 	return 0;
@@ -80,12 +76,6 @@ int lan966x_tc_matchall(struct lan966x_port *port,
 			struct tc_cls_matchall_offload *f,
 			bool ingress)
 {
-	if (!tc_cls_can_offload_and_chain0(port->dev, &f->common)) {
-		NL_SET_ERR_MSG_MOD(f->common.extack,
-				   "Only chain zero is supported");
-		return -EOPNOTSUPP;
-	}
-
 	switch (f->command) {
 	case TC_CLSMATCHALL_REPLACE:
 		return lan966x_tc_matchall_add(port, f, ingress);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c
index 30dd61e5d150..d88a93f22606 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c
@@ -31,6 +31,7 @@ static int sparx5_tc_matchall_replace(struct net_device *ndev,
 	switch (action->id) {
 	case FLOW_ACTION_GOTO:
 		err = vcap_enable_lookups(sparx5->vcap_ctrl, ndev,
+					  tmo->common.chain_index,
 					  action->chain_index, tmo->cookie,
 					  true);
 		if (err == -EFAULT) {
@@ -43,6 +44,11 @@ static int sparx5_tc_matchall_replace(struct net_device *ndev,
 					   "VCAP already enabled");
 			return -EOPNOTSUPP;
 		}
+		if (err == -EADDRNOTAVAIL) {
+			NL_SET_ERR_MSG_MOD(tmo->common.extack,
+					   "Already matching this chain");
+			return -EOPNOTSUPP;
+		}
 		if (err) {
 			NL_SET_ERR_MSG_MOD(tmo->common.extack,
 					   "Could not enable VCAP lookups");
@@ -66,8 +72,8 @@ static int sparx5_tc_matchall_destroy(struct net_device *ndev,
 
 	sparx5 = port->sparx5;
 	if (!tmo->rule && tmo->cookie) {
-		err = vcap_enable_lookups(sparx5->vcap_ctrl, ndev, 0,
-					  tmo->cookie, false);
+		err = vcap_enable_lookups(sparx5->vcap_ctrl, ndev,
+					  0, 0, tmo->cookie, false);
 		if (err)
 			return err;
 		return 0;
@@ -80,12 +86,6 @@ int sparx5_tc_matchall(struct net_device *ndev,
 		       struct tc_cls_matchall_offload *tmo,
 		       bool ingress)
 {
-	if (!tc_cls_can_offload_and_chain0(ndev, &tmo->common)) {
-		NL_SET_ERR_MSG_MOD(tmo->common.extack,
-				   "Only chain zero is supported");
-		return -EOPNOTSUPP;
-	}
-
 	switch (tmo->command) {
 	case TC_CLSMATCHALL_REPLACE:
 		return sparx5_tc_matchall_replace(ndev, tmo, ingress);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 486ab2c2baaa..12807bc0d385 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -37,11 +37,13 @@ struct vcap_rule_move {
 	int count; /* blocksize of addresses to move */
 };
 
-/* Stores the filter cookie that enabled the port */
+/* Stores the filter cookie and chain id that enabled the port */
 struct vcap_enabled_port {
 	struct list_head list; /* for insertion in enabled ports list */
 	struct net_device *ndev;  /* the enabled port */
 	unsigned long cookie; /* filter that enabled the port */
+	int src_cid; /* source chain id */
+	int dst_cid; /* destination chain id */
 };
 
 void vcap_iter_set(struct vcap_stream_iter *itr, int sw_width,
@@ -1930,6 +1932,21 @@ static void vcap_move_rules(struct vcap_rule_internal *ri,
 			 move->offset, move->count);
 }
 
+/* Check if the chain is already used to enable a VCAP lookup for this port */
+static bool vcap_is_chain_used(struct vcap_control *vctrl,
+			       struct net_device *ndev, int src_cid)
+{
+	struct vcap_enabled_port *eport;
+	struct vcap_admin *admin;
+
+	list_for_each_entry(admin, &vctrl->list, list)
+		list_for_each_entry(eport, &admin->enabled, list)
+			if (eport->src_cid == src_cid && eport->ndev == ndev)
+				return true;
+
+	return false;
+}
+
 /* Encode and write a validated rule to the VCAP */
 int vcap_add_rule(struct vcap_rule *rule)
 {
@@ -2593,23 +2610,33 @@ void vcap_set_tc_exterr(struct flow_cls_offload *fco, struct vcap_rule *vrule)
 EXPORT_SYMBOL_GPL(vcap_set_tc_exterr);
 
 /* Check if this port is already enabled for this VCAP instance */
-static bool vcap_is_enabled(struct vcap_admin *admin, struct net_device *ndev,
-			    unsigned long cookie)
+static bool vcap_is_enabled(struct vcap_control *vctrl, struct net_device *ndev,
+			    int dst_cid)
 {
 	struct vcap_enabled_port *eport;
+	struct vcap_admin *admin;
 
-	list_for_each_entry(eport, &admin->enabled, list)
-		if (eport->cookie == cookie || eport->ndev == ndev)
-			return true;
+	list_for_each_entry(admin, &vctrl->list, list)
+		list_for_each_entry(eport, &admin->enabled, list)
+			if (eport->dst_cid == dst_cid && eport->ndev == ndev)
+				return true;
 
 	return false;
 }
 
-/* Enable this port for this VCAP instance */
-static int vcap_enable(struct vcap_admin *admin, struct net_device *ndev,
-		       unsigned long cookie)
+/* Enable this port and chain id in a VCAP instance */
+static int vcap_enable(struct vcap_control *vctrl, struct net_device *ndev,
+		       unsigned long cookie, int src_cid, int dst_cid)
 {
 	struct vcap_enabled_port *eport;
+	struct vcap_admin *admin;
+
+	if (src_cid >= dst_cid)
+		return -EFAULT;
+
+	admin = vcap_find_admin(vctrl, dst_cid);
+	if (!admin)
+		return -ENOENT;
 
 	eport = kzalloc(sizeof(*eport), GFP_KERNEL);
 	if (!eport)
@@ -2617,48 +2644,49 @@ static int vcap_enable(struct vcap_admin *admin, struct net_device *ndev,
 
 	eport->ndev = ndev;
 	eport->cookie = cookie;
+	eport->src_cid = src_cid;
+	eport->dst_cid = dst_cid;
+	mutex_lock(&admin->lock);
 	list_add_tail(&eport->list, &admin->enabled);
+	mutex_unlock(&admin->lock);
 
 	return 0;
 }
 
-/* Disable this port for this VCAP instance */
-static int vcap_disable(struct vcap_admin *admin, struct net_device *ndev,
+/* Disable this port and chain id for a VCAP instance */
+static int vcap_disable(struct vcap_control *vctrl, struct net_device *ndev,
 			unsigned long cookie)
 {
-	struct vcap_enabled_port *eport;
+	struct vcap_enabled_port *elem, *eport = NULL;
+	struct vcap_admin *found = NULL, *admin;
 
-	list_for_each_entry(eport, &admin->enabled, list) {
-		if (eport->cookie == cookie && eport->ndev == ndev) {
-			list_del(&eport->list);
-			kfree(eport);
-			return 0;
+	list_for_each_entry(admin, &vctrl->list, list) {
+		list_for_each_entry(elem, &admin->enabled, list) {
+			if (elem->cookie == cookie && elem->ndev == ndev) {
+				eport = elem;
+				found = admin;
+				break;
+			}
 		}
+		if (eport)
+			break;
 	}
 
-	return -ENOENT;
-}
-
-/* Find the VCAP instance that enabled the port using a specific filter */
-static struct vcap_admin *vcap_find_admin_by_cookie(struct vcap_control *vctrl,
-						    unsigned long cookie)
-{
-	struct vcap_enabled_port *eport;
-	struct vcap_admin *admin;
-
-	list_for_each_entry(admin, &vctrl->list, list)
-		list_for_each_entry(eport, &admin->enabled, list)
-			if (eport->cookie == cookie)
-				return admin;
+	if (!eport)
+		return -ENOENT;
 
-	return NULL;
+	mutex_lock(&found->lock);
+	list_del(&eport->list);
+	mutex_unlock(&found->lock);
+	kfree(eport);
+	return 0;
 }
 
-/* Enable/Disable the VCAP instance lookups. Chain id 0 means disable */
+/* Enable/Disable the VCAP instance lookups */
 int vcap_enable_lookups(struct vcap_control *vctrl, struct net_device *ndev,
-			int chain_id, unsigned long cookie, bool enable)
+			int src_cid, int dst_cid, unsigned long cookie,
+			bool enable)
 {
-	struct vcap_admin *admin;
 	int err;
 
 	err = vcap_api_check(vctrl);
@@ -2668,29 +2696,23 @@ int vcap_enable_lookups(struct vcap_control *vctrl, struct net_device *ndev,
 	if (!ndev)
 		return -ENODEV;
 
-	if (chain_id)
-		admin = vcap_find_admin(vctrl, chain_id);
-	else
-		admin = vcap_find_admin_by_cookie(vctrl, cookie);
-	if (!admin)
-		return -ENOENT;
-
-	/* first instance and first chain */
-	if (admin->vinst || chain_id > admin->first_cid)
+	/* Source and destination must be the first chain in a lookup */
+	if (src_cid % VCAP_CID_LOOKUP_SIZE)
+		return -EFAULT;
+	if (dst_cid % VCAP_CID_LOOKUP_SIZE)
 		return -EFAULT;
 
-	if (chain_id) {
-		if (vcap_is_enabled(admin, ndev, cookie))
+	if (enable) {
+		if (vcap_is_enabled(vctrl, ndev, dst_cid))
 			return -EADDRINUSE;
-		mutex_lock(&admin->lock);
-		vcap_enable(admin, ndev, cookie);
+		if (vcap_is_chain_used(vctrl, ndev, src_cid))
+			return -EADDRNOTAVAIL;
+		err = vcap_enable(vctrl, ndev, cookie, src_cid, dst_cid);
 	} else {
-		mutex_lock(&admin->lock);
-		vcap_disable(admin, ndev, cookie);
+		err = vcap_disable(vctrl, ndev, cookie);
 	}
-	mutex_unlock(&admin->lock);
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(vcap_enable_lookups);
 
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 0319866f9c94..e07dc8d3c639 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -148,9 +148,10 @@ struct vcap_counter {
 	bool sticky;
 };
 
-/* Enable/Disable the VCAP instance lookups. Chain id 0 means disable */
+/* Enable/Disable the VCAP instance lookups */
 int vcap_enable_lookups(struct vcap_control *vctrl, struct net_device *ndev,
-			int chain_id, unsigned long cookie, bool enable);
+			int from_cid, int to_cid, unsigned long cookie,
+			bool enable);
 
 /* VCAP rule operations */
 /* Allocate a rule and fill in the basic information */
-- 
2.39.0

