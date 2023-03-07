Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECBD6AE0F3
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjCGNm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbjCGNmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:42:09 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D361F58C1C;
        Tue,  7 Mar 2023 05:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678196500; x=1709732500;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VCZYVPWTpYIthRDpRzPvQJ5YjZk4hP1f2XCh2XaN/I4=;
  b=mXjy85rHdFQVHMIFb556ys+wE6Kx5GH6dG7QA0b7zp+unAl07R1t0KGo
   7S0J2RRoU9hwu57Gf25xc1hSuhaXTTQO45YRPdF7fZxmGEnRvhCDl2/8S
   1TZs+/CBT9xO7hL97xWp9fbUNmCQdK86ODCPllYMwsM8QvR7aBAmKe9P1
   8vpGQ6WpxQ6VgpcxKJ9nPG0OtRSbFvAMGdnuNiX2Ub0Pl/t9bVvUM8ui0
   akCpIbodXvluBX3AhW69zxAcMS8GG65VTwyEQsIMaYlpa2vn09a0O7I3W
   PONyK0iKzvBpxnxAzwG9mgA/3Hr2H2Bot8tjmfyYQTkATTza6lSd6nnU4
   w==;
X-IronPort-AV: E=Sophos;i="5.98,241,1673938800"; 
   d="scan'208";a="215163113"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 06:41:39 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 06:41:35 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 06:41:31 -0700
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
Subject: [PATCH net-next 5/5] net: microchip: sparx5: Add TC template support
Date:   Tue, 7 Mar 2023 14:41:03 +0100
Message-ID: <20230307134103.2042975-6-steen.hegelund@microchip.com>
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

This adds support for using the "template add" and "template destroy"
functionality to change the port keyset configuration.

If the VCAP lookup already contains rules, the port keyset is left
unchanged, as a change would make these rules unusable.

When the template is destroyed the port keyset configuration is restored.
The filters using the template chain will automatically be deleted by the
TC framework.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 209 +++++++++++++++++-
 1 file changed, 202 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index b36819aafaca..3f87a5285a6d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -28,6 +28,14 @@ struct sparx5_multiple_rules {
 	struct sparx5_wildcard_rule rule[SPX5_MAX_RULE_SIZE];
 };
 
+struct sparx5_tc_flower_template {
+	struct list_head list; /* for insertion in the list of templates */
+	int cid; /* chain id */
+	enum vcap_keyfield_set orig; /* keyset used before the template */
+	enum vcap_keyfield_set keyset; /* new keyset used by template */
+	u16 l3_proto; /* protocol specified in the template */
+};
+
 static int
 sparx5_tc_flower_es0_tpid(struct vcap_tc_flower_parse_usage *st)
 {
@@ -382,7 +390,7 @@ static int sparx5_tc_select_protocol_keyset(struct net_device *ndev,
 	/* Find the keysets that the rule can use */
 	matches.keysets = keysets;
 	matches.max = ARRAY_SIZE(keysets);
-	if (vcap_rule_find_keysets(vrule, &matches) == 0)
+	if (!vcap_rule_find_keysets(vrule, &matches))
 		return -EINVAL;
 
 	/* Find the keysets that the port configuration supports */
@@ -996,6 +1004,73 @@ static int sparx5_tc_action_vlan_push(struct vcap_admin *admin,
 	return err;
 }
 
+/* Remove rule keys that may prevent templates from matching a keyset */
+static void sparx5_tc_flower_simplify_rule(struct vcap_admin *admin,
+					   struct vcap_rule *vrule,
+					   u16 l3_proto)
+{
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		vcap_rule_rem_key(vrule, VCAP_KF_ETYPE);
+		switch (l3_proto) {
+		case ETH_P_IP:
+			break;
+		case ETH_P_IPV6:
+			vcap_rule_rem_key(vrule, VCAP_KF_IP_SNAP_IS);
+			break;
+		default:
+			break;
+		}
+		break;
+	case VCAP_TYPE_ES2:
+		switch (l3_proto) {
+		case ETH_P_IP:
+			if (vrule->keyset == VCAP_KFS_IP4_OTHER)
+				vcap_rule_rem_key(vrule, VCAP_KF_TCP_IS);
+			break;
+		case ETH_P_IPV6:
+			if (vrule->keyset == VCAP_KFS_IP6_STD)
+				vcap_rule_rem_key(vrule, VCAP_KF_TCP_IS);
+			vcap_rule_rem_key(vrule, VCAP_KF_IP4_IS);
+			break;
+		default:
+			break;
+		}
+		break;
+	case VCAP_TYPE_IS2:
+		switch (l3_proto) {
+		case ETH_P_IP:
+		case ETH_P_IPV6:
+			vcap_rule_rem_key(vrule, VCAP_KF_IP4_IS);
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static bool sparx5_tc_flower_use_template(struct net_device *ndev,
+					  struct flow_cls_offload *fco,
+					  struct vcap_admin *admin,
+					  struct vcap_rule *vrule)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5_tc_flower_template *ftp;
+
+	list_for_each_entry(ftp, &port->tc_templates, list) {
+		if (ftp->cid != fco->common.chain_index)
+			continue;
+
+		vcap_set_rule_set_keyset(vrule, ftp->keyset);
+		sparx5_tc_flower_simplify_rule(admin, vrule, ftp->l3_proto);
+		return true;
+	}
+	return false;
+}
+
 static int sparx5_tc_flower_replace(struct net_device *ndev,
 				    struct flow_cls_offload *fco,
 				    struct vcap_admin *admin,
@@ -1122,12 +1197,14 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 			goto out;
 	}
 
-	err = sparx5_tc_select_protocol_keyset(ndev, vrule, admin,
-					       state.l3_proto, &multi);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(fco->common.extack,
-				   "No matching port keyset for filter protocol and keys");
-		goto out;
+	if (!sparx5_tc_flower_use_template(ndev, fco, admin, vrule)) {
+		err = sparx5_tc_select_protocol_keyset(ndev, vrule, admin,
+						       state.l3_proto, &multi);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(fco->common.extack,
+					   "No matching port keyset for filter protocol and keys");
+			goto out;
+		}
 	}
 
 	/* provide the l3 protocol to guide the keyset selection */
@@ -1259,6 +1336,120 @@ static int sparx5_tc_flower_stats(struct net_device *ndev,
 	return err;
 }
 
+static int sparx5_tc_flower_template_create(struct net_device *ndev,
+					    struct flow_cls_offload *fco,
+					    struct vcap_admin *admin)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct vcap_tc_flower_parse_usage state = {
+		.fco = fco,
+		.l3_proto = ETH_P_ALL,
+		.admin = admin,
+	};
+	struct sparx5_tc_flower_template *ftp;
+	struct vcap_keyset_list kslist = {};
+	enum vcap_keyfield_set keysets[10];
+	struct vcap_control *vctrl;
+	struct vcap_rule *vrule;
+	int count, err;
+
+	if (admin->vtype == VCAP_TYPE_ES0) {
+		pr_err("%s:%d: %s\n", __func__, __LINE__,
+		       "VCAP does not support templates");
+		return -EINVAL;
+	}
+
+	count = vcap_admin_rule_count(admin, fco->common.chain_index);
+	if (count > 0) {
+		pr_err("%s:%d: %s\n", __func__, __LINE__,
+		       "Filters are already present");
+		return -EBUSY;
+	}
+
+	ftp = kzalloc(sizeof(*ftp), GFP_KERNEL);
+	if (!ftp)
+		return -ENOMEM;
+
+	ftp->cid = fco->common.chain_index;
+	ftp->orig = VCAP_KFS_NO_VALUE;
+	ftp->keyset = VCAP_KFS_NO_VALUE;
+
+	vctrl = port->sparx5->vcap_ctrl;
+	vrule = vcap_alloc_rule(vctrl, ndev, fco->common.chain_index,
+				VCAP_USER_TC, fco->common.prio, 0);
+	if (IS_ERR(vrule)) {
+		err = PTR_ERR(vrule);
+		goto err_rule;
+	}
+
+	state.vrule = vrule;
+	state.frule = flow_cls_offload_flow_rule(fco);
+	err = sparx5_tc_use_dissectors(&state, admin, vrule);
+	if (err) {
+		pr_err("%s:%d: key error: %d\n", __func__, __LINE__, err);
+		goto out;
+	}
+
+	ftp->l3_proto = state.l3_proto;
+
+	sparx5_tc_flower_simplify_rule(admin, vrule, state.l3_proto);
+
+	/* Find the keysets that the rule can use */
+	kslist.keysets = keysets;
+	kslist.max = ARRAY_SIZE(keysets);
+	if (!vcap_rule_find_keysets(vrule, &kslist)) {
+		pr_err("%s:%d: %s\n", __func__, __LINE__,
+		       "Could not find a suitable keyset");
+		err = -ENOENT;
+		goto out;
+	}
+
+	ftp->keyset = vcap_select_min_rule_keyset(vctrl, admin->vtype, &kslist);
+	kslist.cnt = 0;
+	sparx5_vcap_set_port_keyset(ndev, admin, fco->common.chain_index,
+				    state.l3_proto,
+				    ftp->keyset,
+				    &kslist);
+
+	if (kslist.cnt > 0)
+		ftp->orig = kslist.keysets[0];
+
+	/* Store new template */
+	list_add_tail(&ftp->list, &port->tc_templates);
+	vcap_free_rule(vrule);
+	return 0;
+
+out:
+	vcap_free_rule(vrule);
+err_rule:
+	kfree(ftp);
+	return err;
+}
+
+static int sparx5_tc_flower_template_destroy(struct net_device *ndev,
+					     struct flow_cls_offload *fco,
+					     struct vcap_admin *admin)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5_tc_flower_template *ftp, *tmp;
+	int err = -ENOENT;
+
+	/* Rules using the template are removed by the tc framework */
+	list_for_each_entry_safe(ftp, tmp, &port->tc_templates, list) {
+		if (ftp->cid != fco->common.chain_index)
+			continue;
+
+		sparx5_vcap_set_port_keyset(ndev, admin,
+					    fco->common.chain_index,
+					    ftp->l3_proto, ftp->orig,
+					    NULL);
+		list_del(&ftp->list);
+		kfree(ftp);
+		break;
+	}
+	return err;
+}
+
 int sparx5_tc_flower(struct net_device *ndev, struct flow_cls_offload *fco,
 		     bool ingress)
 {
@@ -1282,6 +1473,10 @@ int sparx5_tc_flower(struct net_device *ndev, struct flow_cls_offload *fco,
 		return sparx5_tc_flower_destroy(ndev, fco, admin);
 	case FLOW_CLS_STATS:
 		return sparx5_tc_flower_stats(ndev, fco, admin);
+	case FLOW_CLS_TMPLT_CREATE:
+		return sparx5_tc_flower_template_create(ndev, fco, admin);
+	case FLOW_CLS_TMPLT_DESTROY:
+		return sparx5_tc_flower_template_destroy(ndev, fco, admin);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.39.2

