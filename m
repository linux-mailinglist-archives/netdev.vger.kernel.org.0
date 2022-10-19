Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94BD604494
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiJSMIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbiJSMHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:07:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3E915A23;
        Wed, 19 Oct 2022 04:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666179851; x=1697715851;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XgUTLbcuUijPqh2oxc2Gwq4RHmTcaK2Rck6DhC8llCc=;
  b=Q0Gtm7atilbXywxecyzYwCyMN958D0nQ0SwF8Kesp0bhyUPHE+1SZzgy
   KEVWwghRM7+n1YDXwTH35O9fzoWi2pw0ZASC19/AlQOJujsluVKPTs05l
   HD0EeMuFP49nEz3ZX6YhIS3rQDkh87syYSE+7tKg6v3qsRJ4POrlcBZVE
   klBA7Mit1zoesvHRLmwofVmadGuYXnQ5K0hLyMe51myZs7OxMktFjahLm
   2aEMtw1hBU/F4NMAaSVvjDzkp5mKp1kOcJWy32mWG9po+JIdXY2LfJPLy
   Urgau2H5LBqz+bfRGDeLGC/hsZSLLGWaE5K/0VgVCbaG/AVuS+E8OnjWT
   g==;
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="179533662"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 04:42:39 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 04:42:35 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 19 Oct 2022 04:42:32 -0700
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
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next v2 4/9] net: microchip: sparx5: Adding initial tc flower support for VCAP API
Date:   Wed, 19 Oct 2022 13:42:10 +0200
Message-ID: <20221019114215.620969-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221019114215.620969-1-steen.hegelund@microchip.com>
References: <20221019114215.620969-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds initial TC flower filter support to Sparx5 for the IS2 VCAP.

The support consists of the source and destination MAC addresses,
and the trap and pass actions.

This is how you can create a rule that test the functionality:

tc qdisc add dev eth0 clsact
tc filter add dev eth0 ingress chain 8000000 prio 10 handle 10 \
      protocol all flower skip_sw \
      dst_mac 0a:0b:0c:0d:0e:0f \
      src_mac 2:0:0:0:0:1 \
      action trap

The IS2 chains in Sparx5 are assigned like this:

- chain 8000000: IS2 Lookup 0
- chain 8100000: IS2 Lookup 1
- chain 8200000: IS2 Lookup 2
- chain 8300000: IS2 Lookup 3

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/Makefile       |   1 +
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../net/ethernet/microchip/sparx5/sparx5_tc.c |  46 +++
 .../net/ethernet/microchip/sparx5/sparx5_tc.h |  14 +
 .../microchip/sparx5/sparx5_tc_flower.c       | 256 ++++++++++++++
 .../microchip/sparx5/sparx5_vcap_impl.c       | 142 +++++++-
 .../microchip/sparx5/sparx5_vcap_impl.h       |  20 ++
 drivers/net/ethernet/microchip/vcap/Makefile  |   8 +
 .../net/ethernet/microchip/vcap/vcap_api.c    | 331 ++++++++++++++++++
 .../ethernet/microchip/vcap/vcap_api_client.h | 187 ++++++++++
 10 files changed, 1003 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/Makefile
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_client.h

diff --git a/drivers/net/ethernet/microchip/Makefile b/drivers/net/ethernet/microchip/Makefile
index 9faa41436198..bbd349264e6f 100644
--- a/drivers/net/ethernet/microchip/Makefile
+++ b/drivers/net/ethernet/microchip/Makefile
@@ -11,3 +11,4 @@ lan743x-objs := lan743x_main.o lan743x_ethtool.o lan743x_ptp.o
 
 obj-$(CONFIG_LAN966X_SWITCH) += lan966x/
 obj-$(CONFIG_SPARX5_SWITCH) += sparx5/
+obj-$(CONFIG_VCAP) += vcap/
diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index b9c6831c2d92..ee2c42f66742 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -9,7 +9,7 @@ sparx5-switch-y  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_phylink.o sparx5_port.o sparx5_mactable.o sparx5_vlan.o \
  sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
  sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o \
- sparx5_vcap_impl.o sparx5_vcap_ag_api.o
+ sparx5_vcap_impl.o sparx5_vcap_ag_api.o sparx5_tc_flower.o
 
 # Provide include files
 ccflags-y += -I$(srctree)/drivers/net/ethernet/microchip/vcap
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
index e05429c751ee..9432251b8322 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
@@ -10,6 +10,50 @@
 #include "sparx5_main.h"
 #include "sparx5_qos.h"
 
+/* tc block handling */
+static LIST_HEAD(sparx5_block_cb_list);
+
+static int sparx5_tc_block_cb(enum tc_setup_type type,
+			      void *type_data,
+			      void *cb_priv, bool ingress)
+{
+	struct net_device *ndev = cb_priv;
+
+	if (type == TC_SETUP_CLSFLOWER)
+		return sparx5_tc_flower(ndev, type_data, ingress);
+	return -EOPNOTSUPP;
+}
+
+static int sparx5_tc_block_cb_ingress(enum tc_setup_type type,
+				      void *type_data,
+				      void *cb_priv)
+{
+	return sparx5_tc_block_cb(type, type_data, cb_priv, true);
+}
+
+static int sparx5_tc_block_cb_egress(enum tc_setup_type type,
+				     void *type_data,
+				     void *cb_priv)
+{
+	return sparx5_tc_block_cb(type, type_data, cb_priv, false);
+}
+
+static int sparx5_tc_setup_block(struct net_device *ndev,
+				 struct flow_block_offload *fbo)
+{
+	flow_setup_cb_t *cb;
+
+	if (fbo->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		cb = sparx5_tc_block_cb_ingress;
+	else if (fbo->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+		cb = sparx5_tc_block_cb_egress;
+	else
+		return -EOPNOTSUPP;
+
+	return flow_block_cb_setup_simple(fbo, &sparx5_block_cb_list,
+					  cb, ndev, ndev, false);
+}
+
 static void sparx5_tc_get_layer_and_idx(u32 parent, u32 portno, u32 *layer,
 					u32 *idx)
 {
@@ -111,6 +155,8 @@ int sparx5_port_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			 void *type_data)
 {
 	switch (type) {
+	case TC_SETUP_BLOCK:
+		return sparx5_tc_setup_block(ndev, type_data);
 	case TC_SETUP_QDISC_MQPRIO:
 		return sparx5_tc_setup_qdisc_mqprio(ndev, type_data);
 	case TC_SETUP_QDISC_TBF:
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
index 5b55e11b77e1..2b07a93fc9b7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
@@ -7,9 +7,23 @@
 #ifndef __SPARX5_TC_H__
 #define __SPARX5_TC_H__
 
+#include <net/flow_offload.h>
 #include <linux/netdevice.h>
 
+/* Controls how PORT_MASK is applied */
+enum SPX5_PORT_MASK_MODE {
+	SPX5_PMM_OR_DSTMASK,
+	SPX5_PMM_AND_VLANMASK,
+	SPX5_PMM_REPLACE_PGID,
+	SPX5_PMM_REPLACE_ALL,
+	SPX5_PMM_REDIR_PGID,
+	SPX5_PMM_OR_PGID_MASK,
+};
+
 int sparx5_port_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			 void *type_data);
 
+int sparx5_tc_flower(struct net_device *ndev, struct flow_cls_offload *fco,
+		     bool ingress);
+
 #endif	/* __SPARX5_TC_H__ */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
new file mode 100644
index 000000000000..fa2e5c078c0e
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -0,0 +1,256 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip VCAP API
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <net/tcp.h>
+
+#include "sparx5_tc.h"
+#include "vcap_api.h"
+#include "vcap_api_client.h"
+#include "sparx5_main.h"
+#include "sparx5_vcap_impl.h"
+
+struct sparx5_tc_flower_parse_usage {
+	struct flow_cls_offload *fco;
+	struct flow_rule *frule;
+	struct vcap_rule *vrule;
+	unsigned int used_keys;
+};
+
+/* Copy to host byte order */
+static void sparx5_netbytes_copy(u8 *dst, u8 *src, int count)
+{
+	int idx;
+
+	for (idx = 0; idx < count; ++idx, ++dst)
+		*dst = src[count - idx - 1];
+}
+
+static int sparx5_tc_flower_handler_ethaddr_usage(struct sparx5_tc_flower_parse_usage *st)
+{
+	enum vcap_key_field smac_key = VCAP_KF_L2_SMAC;
+	enum vcap_key_field dmac_key = VCAP_KF_L2_DMAC;
+	struct flow_match_eth_addrs match;
+	struct vcap_u48_key smac, dmac;
+	int err = 0;
+
+	flow_rule_match_eth_addrs(st->frule, &match);
+
+	if (!is_zero_ether_addr(match.mask->src)) {
+		sparx5_netbytes_copy(smac.value, match.key->src, ETH_ALEN);
+		sparx5_netbytes_copy(smac.mask, match.mask->src, ETH_ALEN);
+		err = vcap_rule_add_key_u48(st->vrule, smac_key, &smac);
+		if (err)
+			goto out;
+	}
+
+	if (!is_zero_ether_addr(match.mask->dst)) {
+		sparx5_netbytes_copy(dmac.value, match.key->dst, ETH_ALEN);
+		sparx5_netbytes_copy(dmac.mask, match.mask->dst, ETH_ALEN);
+		err = vcap_rule_add_key_u48(st->vrule, dmac_key, &dmac);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "eth_addr parse error");
+	return err;
+}
+
+static int (*sparx5_tc_flower_usage_handlers[])(struct sparx5_tc_flower_parse_usage *st) = {
+	/* More dissector handlers will be added here later */
+	[FLOW_DISSECTOR_KEY_ETH_ADDRS] = sparx5_tc_flower_handler_ethaddr_usage,
+};
+
+static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
+				    struct vcap_admin *admin,
+				    struct vcap_rule *vrule)
+{
+	struct sparx5_tc_flower_parse_usage state = {
+		.fco = fco,
+		.vrule = vrule,
+	};
+	int idx, err = 0;
+
+	state.frule = flow_cls_offload_flow_rule(fco);
+	for (idx = 0; idx < ARRAY_SIZE(sparx5_tc_flower_usage_handlers); ++idx) {
+		if (!flow_rule_match_key(state.frule, idx))
+			continue;
+		if (!sparx5_tc_flower_usage_handlers[idx])
+			continue;
+		err = sparx5_tc_flower_usage_handlers[idx](&state);
+		if (err)
+			return err;
+	}
+	return err;
+}
+
+static void sparx5_tc_flower_set_exterr(struct net_device *ndev,
+					struct flow_cls_offload *fco,
+					struct vcap_rule *vrule)
+{
+	switch (vrule->exterr) {
+	case VCAP_ERR_NONE:
+		break;
+	case VCAP_ERR_NO_ADMIN:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Missing VCAP instance");
+		break;
+	case VCAP_ERR_NO_NETDEV:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Missing network interface");
+		break;
+	case VCAP_ERR_NO_KEYSET_MATCH:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "No keyset matched the filter keys");
+		break;
+	case VCAP_ERR_NO_ACTIONSET_MATCH:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "No actionset matched the filter actions");
+		break;
+	case VCAP_ERR_NO_PORT_KEYSET_MATCH:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "No port keyset matched the filter keys");
+		break;
+	}
+}
+
+static int sparx5_tc_flower_replace(struct net_device *ndev,
+				    struct flow_cls_offload *fco,
+				    struct vcap_admin *admin)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct flow_action_entry *act;
+	struct vcap_control *vctrl;
+	struct flow_rule *frule;
+	struct vcap_rule *vrule;
+	int err, idx;
+
+	frule = flow_cls_offload_flow_rule(fco);
+	if (!flow_action_has_entries(&frule->action)) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack, "No actions");
+		return -EINVAL;
+	}
+
+	if (!flow_action_basic_hw_stats_check(&frule->action, fco->common.extack))
+		return -EOPNOTSUPP;
+
+	vctrl = port->sparx5->vcap_ctrl;
+	vrule = vcap_alloc_rule(vctrl, ndev, fco->common.chain_index, VCAP_USER_TC,
+				fco->common.prio, 0);
+	if (IS_ERR(vrule))
+		return PTR_ERR(vrule);
+
+	vrule->cookie = fco->cookie;
+	sparx5_tc_use_dissectors(fco, admin, vrule);
+	flow_action_for_each(idx, act, &frule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_TRAP:
+			err = vcap_rule_add_action_bit(vrule,
+						       VCAP_AF_CPU_COPY_ENA,
+						       VCAP_BIT_1);
+			if (err)
+				goto out;
+			err = vcap_rule_add_action_u32(vrule,
+						       VCAP_AF_CPU_QUEUE_NUM, 0);
+			if (err)
+				goto out;
+			err = vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE,
+						       SPX5_PMM_REPLACE_ALL);
+			if (err)
+				goto out;
+			/* For now the actionset is hardcoded */
+			err = vcap_set_rule_set_actionset(vrule,
+							  VCAP_AFS_BASE_TYPE);
+			if (err)
+				goto out;
+			break;
+		case FLOW_ACTION_ACCEPT:
+			/* For now the actionset is hardcoded */
+			err = vcap_set_rule_set_actionset(vrule,
+							  VCAP_AFS_BASE_TYPE);
+			if (err)
+				goto out;
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(fco->common.extack,
+					   "Unsupported TC action");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+	}
+	/* For now the keyset is hardcoded */
+	err = vcap_set_rule_set_keyset(vrule, VCAP_KFS_MAC_ETYPE);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "No matching port keyset for filter protocol and keys");
+		goto out;
+	}
+	err = vcap_val_rule(vrule, ETH_P_ALL);
+	if (err) {
+		sparx5_tc_flower_set_exterr(ndev, fco, vrule);
+		goto out;
+	}
+	err = vcap_add_rule(vrule);
+	if (err)
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Could not add the filter");
+out:
+	vcap_free_rule(vrule);
+	return err;
+}
+
+static int sparx5_tc_flower_destroy(struct net_device *ndev,
+				    struct flow_cls_offload *fco,
+				    struct vcap_admin *admin)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct vcap_control *vctrl;
+	int err = -ENOENT, rule_id;
+
+	vctrl = port->sparx5->vcap_ctrl;
+	while (true) {
+		rule_id = vcap_lookup_rule_by_cookie(vctrl, fco->cookie);
+		if (rule_id <= 0)
+			break;
+		err = vcap_del_rule(vctrl, ndev, rule_id);
+		if (err) {
+			pr_err("%s:%d: could not delete rule %d\n",
+			       __func__, __LINE__, rule_id);
+			break;
+		}
+	}
+	return err;
+}
+
+int sparx5_tc_flower(struct net_device *ndev, struct flow_cls_offload *fco,
+		     bool ingress)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct vcap_control *vctrl;
+	struct vcap_admin *admin;
+	int err = -EINVAL;
+
+	/* Get vcap instance from the chain id */
+	vctrl = port->sparx5->vcap_ctrl;
+	admin = vcap_find_admin(vctrl, fco->common.chain_index);
+	if (!admin) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack, "Invalid chain");
+		return err;
+	}
+
+	switch (fco->command) {
+	case FLOW_CLS_REPLACE:
+		return sparx5_tc_flower_replace(ndev, fco, admin);
+	case FLOW_CLS_DESTROY:
+		return sparx5_tc_flower_destroy(ndev, fco, admin);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index 68f6fed80556..5ec005e636aa 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -11,18 +11,133 @@
 #include <linux/list.h>
 
 #include "vcap_api.h"
+#include "vcap_api_client.h"
 #include "sparx5_main_regs.h"
 #include "sparx5_main.h"
+#include "sparx5_vcap_impl.h"
 #include "sparx5_vcap_ag_api.h"
 
+#define SUPER_VCAP_BLK_SIZE 3072 /* addresses per Super VCAP block */
+#define STREAMSIZE (64 * 4)  /* bytes in the VCAP cache area */
+
+#define SPARX5_IS2_LOOKUPS 4
+
+static struct sparx5_vcap_inst {
+	enum vcap_type vtype; /* type of vcap */
+	int vinst; /* instance number within the same type */
+	int lookups; /* number of lookups in this vcap type */
+	int lookups_per_instance; /* number of lookups in this instance */
+	int first_cid; /* first chain id in this vcap */
+	int last_cid; /* last chain id in this vcap */
+	int count; /* number of available addresses, not in super vcap */
+	int map_id; /* id in the super vcap block mapping (if applicable) */
+	int blockno; /* starting block in super vcap (if applicable) */
+	int blocks; /* number of blocks in super vcap (if applicable) */
+} sparx5_vcap_inst_cfg[] = {
+	{
+		.vtype = VCAP_TYPE_IS2, /* IS2-0 */
+		.vinst = 0,
+		.map_id = 4,
+		.lookups = SPARX5_IS2_LOOKUPS,
+		.lookups_per_instance = SPARX5_IS2_LOOKUPS / 2,
+		.first_cid = SPARX5_VCAP_CID_IS2_L0,
+		.last_cid = SPARX5_VCAP_CID_IS2_L2 - 1,
+		.blockno = 0, /* Maps block 0-1 */
+		.blocks = 2,
+	},
+	{
+		.vtype = VCAP_TYPE_IS2, /* IS2-1 */
+		.vinst = 1,
+		.map_id = 5,
+		.lookups = SPARX5_IS2_LOOKUPS,
+		.lookups_per_instance = SPARX5_IS2_LOOKUPS / 2,
+		.first_cid = SPARX5_VCAP_CID_IS2_L2,
+		.last_cid = SPARX5_VCAP_CID_IS2_MAX,
+		.blockno = 2, /* Maps block 2-3 */
+		.blocks = 2,
+	},
+};
+
+static void sparx5_vcap_admin_free(struct vcap_admin *admin)
+{
+	if (!admin)
+		return;
+	kfree(admin->cache.keystream);
+	kfree(admin->cache.maskstream);
+	kfree(admin->cache.actionstream);
+	kfree(admin);
+}
+
+/* Allocate a vcap instance with a rule list and a cache area */
+static struct vcap_admin *
+sparx5_vcap_admin_alloc(struct sparx5 *sparx5, struct vcap_control *ctrl,
+			const struct sparx5_vcap_inst *cfg)
+{
+	struct vcap_admin *admin;
+
+	admin = kzalloc(sizeof(*admin), GFP_KERNEL);
+	if (!admin)
+		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&admin->list);
+	INIT_LIST_HEAD(&admin->rules);
+	admin->vtype = cfg->vtype;
+	admin->vinst = cfg->vinst;
+	admin->lookups = cfg->lookups;
+	admin->lookups_per_instance = cfg->lookups_per_instance;
+	admin->first_cid = cfg->first_cid;
+	admin->last_cid = cfg->last_cid;
+	admin->cache.keystream =
+		kzalloc(STREAMSIZE, GFP_KERNEL);
+	admin->cache.maskstream =
+		kzalloc(STREAMSIZE, GFP_KERNEL);
+	admin->cache.actionstream =
+		kzalloc(STREAMSIZE, GFP_KERNEL);
+	if (!admin->cache.keystream || !admin->cache.maskstream ||
+	    !admin->cache.actionstream) {
+		sparx5_vcap_admin_free(admin);
+		return ERR_PTR(-ENOMEM);
+	}
+	return admin;
+}
+
+/* Do block allocations and provide addresses for VCAP instances */
+static void sparx5_vcap_block_alloc(struct sparx5 *sparx5,
+				    struct vcap_admin *admin,
+				    const struct sparx5_vcap_inst *cfg)
+{
+	int idx;
+
+	/* Super VCAP block mapping and address configuration. Block 0
+	 * is assigned addresses 0 through 3071, block 1 is assigned
+	 * addresses 3072 though 6143, and so on.
+	 */
+	for (idx = cfg->blockno; idx < cfg->blockno + cfg->blocks; ++idx) {
+		spx5_wr(VCAP_SUPER_IDX_CORE_IDX_SET(idx), sparx5,
+			VCAP_SUPER_IDX);
+		spx5_wr(VCAP_SUPER_MAP_CORE_MAP_SET(cfg->map_id), sparx5,
+			VCAP_SUPER_MAP);
+	}
+	admin->first_valid_addr = cfg->blockno * SUPER_VCAP_BLK_SIZE;
+	admin->last_used_addr = admin->first_valid_addr +
+		cfg->blocks * SUPER_VCAP_BLK_SIZE;
+	admin->last_valid_addr = admin->last_used_addr - 1;
+}
+
 /* Allocate a vcap control and vcap instances and configure the system */
 int sparx5_vcap_init(struct sparx5 *sparx5)
 {
+	const struct sparx5_vcap_inst *cfg;
 	struct vcap_control *ctrl;
+	struct vcap_admin *admin;
+	int err = 0, idx;
 
 	/* Create a VCAP control instance that owns the platform specific VCAP
 	 * model with VCAP instances and information about keysets, keys,
 	 * actionsets and actions
+	 * - Create administrative state for each available VCAP
+	 *   - Lists of rules
+	 *   - Address information
+	 *   - Initialize VCAP blocks
 	 */
 	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
 	if (!ctrl)
@@ -33,13 +148,34 @@ int sparx5_vcap_init(struct sparx5 *sparx5)
 	ctrl->vcaps = sparx5_vcaps;
 	ctrl->stats = &sparx5_vcap_stats;
 
-	return 0;
+	INIT_LIST_HEAD(&ctrl->list);
+	for (idx = 0; idx < ARRAY_SIZE(sparx5_vcap_inst_cfg); ++idx) {
+		cfg = &sparx5_vcap_inst_cfg[idx];
+		admin = sparx5_vcap_admin_alloc(sparx5, ctrl, cfg);
+		if (IS_ERR(admin)) {
+			err = PTR_ERR(admin);
+			pr_err("%s:%d: vcap allocation failed: %d\n",
+			       __func__, __LINE__, err);
+			return err;
+		}
+		sparx5_vcap_block_alloc(sparx5, admin, cfg);
+		list_add_tail(&admin->list, &ctrl->list);
+	}
+
+	return err;
 }
 
 void sparx5_vcap_destroy(struct sparx5 *sparx5)
 {
-	if (!sparx5->vcap_ctrl)
+	struct vcap_control *ctrl = sparx5->vcap_ctrl;
+	struct vcap_admin *admin, *admin_next;
+
+	if (!ctrl)
 		return;
 
-	kfree(sparx5->vcap_ctrl);
+	list_for_each_entry_safe(admin, admin_next, &ctrl->list, list) {
+		list_del(&admin->list);
+		sparx5_vcap_admin_free(admin);
+	}
+	kfree(ctrl);
 }
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
new file mode 100644
index 000000000000..8e44ebd76b41
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Microchip Sparx5 Switch driver VCAP implementation
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ *
+ * The Sparx5 Chip Register Model can be browsed at this location:
+ * https://github.com/microchip-ung/sparx-5_reginfo
+ */
+
+#ifndef __SPARX5_VCAP_IMPL_H__
+#define __SPARX5_VCAP_IMPL_H__
+
+#define SPARX5_VCAP_CID_IS2_L0 VCAP_CID_INGRESS_STAGE2_L0 /* IS2 lookup 0 */
+#define SPARX5_VCAP_CID_IS2_L1 VCAP_CID_INGRESS_STAGE2_L1 /* IS2 lookup 1 */
+#define SPARX5_VCAP_CID_IS2_L2 VCAP_CID_INGRESS_STAGE2_L2 /* IS2 lookup 2 */
+#define SPARX5_VCAP_CID_IS2_L3 VCAP_CID_INGRESS_STAGE2_L3 /* IS2 lookup 3 */
+#define SPARX5_VCAP_CID_IS2_MAX \
+	(VCAP_CID_INGRESS_STAGE2_L3 + VCAP_CID_LOOKUP_SIZE - 1) /* IS2 Max */
+
+#endif /* __SPARX5_VCAP_IMPL_H__ */
diff --git a/drivers/net/ethernet/microchip/vcap/Makefile b/drivers/net/ethernet/microchip/vcap/Makefile
new file mode 100644
index 000000000000..598d1c296f38
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the Microchip VCAP API
+#
+
+obj-$(CONFIG_VCAP) += vcap.o
+
+vcap-y += vcap_api.o
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
new file mode 100644
index 000000000000..aa6b451d79a6
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -0,0 +1,331 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip VCAP API
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/types.h>
+
+#include "vcap_api.h"
+#include "vcap_api_client.h"
+
+#define to_intrule(rule) container_of((rule), struct vcap_rule_internal, data)
+
+/* Private VCAP API rule data */
+struct vcap_rule_internal {
+	struct vcap_rule data; /* provided by the client */
+	struct list_head list; /* for insertion in the vcap admin list of rules */
+	struct vcap_admin *admin; /* vcap hw instance */
+	struct net_device *ndev;  /* the interface that the rule applies to */
+	struct vcap_control *vctrl; /* the client control */
+	u32 addr; /* address in the VCAP at insertion */
+};
+
+/* Update the keyset for the rule */
+int vcap_set_rule_set_keyset(struct vcap_rule *rule,
+			     enum vcap_keyfield_set keyset)
+{
+	/* This will be expanded with more information later */
+	rule->keyset = keyset;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vcap_set_rule_set_keyset);
+
+/* Update the actionset for the rule */
+int vcap_set_rule_set_actionset(struct vcap_rule *rule,
+				enum vcap_actionfield_set actionset)
+{
+	/* This will be expanded with more information later */
+	rule->actionset = actionset;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vcap_set_rule_set_actionset);
+
+/* Find a rule with a provided rule id */
+static struct vcap_rule_internal *vcap_lookup_rule(struct vcap_control *vctrl,
+						   u32 id)
+{
+	struct vcap_rule_internal *ri;
+	struct vcap_admin *admin;
+
+	/* Look for the rule id in all vcaps */
+	list_for_each_entry(admin, &vctrl->list, list)
+		list_for_each_entry(ri, &admin->rules, list)
+			if (ri->data.id == id)
+				return ri;
+	return NULL;
+}
+
+/* Find a rule id with a provided cookie */
+int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie)
+{
+	struct vcap_rule_internal *ri;
+	struct vcap_admin *admin;
+
+	/* Look for the rule id in all vcaps */
+	list_for_each_entry(admin, &vctrl->list, list)
+		list_for_each_entry(ri, &admin->rules, list)
+			if (ri->data.cookie == cookie)
+				return ri->data.id;
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(vcap_lookup_rule_by_cookie);
+
+/* Lookup a vcap instance using chain id */
+struct vcap_admin *vcap_find_admin(struct vcap_control *vctrl, int cid)
+{
+	struct vcap_admin *admin;
+
+	list_for_each_entry(admin, &vctrl->list, list) {
+		if (cid >= admin->first_cid && cid <= admin->last_cid)
+			return admin;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(vcap_find_admin);
+
+/* Validate a rule with respect to available port keys */
+int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+
+	/* This validation will be much expanded later */
+	if (!ri->admin) {
+		ri->data.exterr = VCAP_ERR_NO_ADMIN;
+		return -EINVAL;
+	}
+	if (!ri->ndev) {
+		ri->data.exterr = VCAP_ERR_NO_NETDEV;
+		return -EINVAL;
+	}
+	if (ri->data.keyset == VCAP_KFS_NO_VALUE) {
+		ri->data.exterr = VCAP_ERR_NO_KEYSET_MATCH;
+		return -EINVAL;
+	}
+	if (ri->data.actionset == VCAP_AFS_NO_VALUE) {
+		ri->data.exterr = VCAP_ERR_NO_ACTIONSET_MATCH;
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vcap_val_rule);
+
+/* Assign a unique rule id and autogenerate one if id == 0 */
+static u32 vcap_set_rule_id(struct vcap_rule_internal *ri)
+{
+	u32 next_id;
+
+	if (ri->data.id != 0)
+		return ri->data.id;
+
+	next_id = ri->vctrl->rule_id + 1;
+
+	for (next_id = ri->vctrl->rule_id + 1; next_id < ~0; ++next_id) {
+		if (!vcap_lookup_rule(ri->vctrl, next_id)) {
+			ri->data.id = next_id;
+			ri->vctrl->rule_id = next_id;
+			break;
+		}
+	}
+	return ri->data.id;
+}
+
+/* Encode and write a validated rule to the VCAP */
+int vcap_add_rule(struct vcap_rule *rule)
+{
+	/* This will later handling the encode and writing of the rule */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vcap_add_rule);
+
+/* Allocate a new rule with the provided arguments */
+struct vcap_rule *vcap_alloc_rule(struct vcap_control *vctrl,
+				  struct net_device *ndev, int vcap_chain_id,
+				  enum vcap_user user, u16 priority,
+				  u32 id)
+{
+	struct vcap_rule_internal *ri;
+	struct vcap_admin *admin;
+
+	if (!ndev)
+		return ERR_PTR(-ENODEV);
+	/* Get the VCAP instance */
+	admin = vcap_find_admin(vctrl, vcap_chain_id);
+	if (!admin)
+		return ERR_PTR(-ENOENT);
+	/* Create a container for the rule and return it */
+	ri = kzalloc(sizeof(*ri), GFP_KERNEL);
+	if (!ri)
+		return ERR_PTR(-ENOMEM);
+	ri->data.vcap_chain_id = vcap_chain_id;
+	ri->data.user = user;
+	ri->data.priority = priority;
+	ri->data.id = id;
+	ri->data.keyset = VCAP_KFS_NO_VALUE;
+	ri->data.actionset = VCAP_AFS_NO_VALUE;
+	INIT_LIST_HEAD(&ri->list);
+	INIT_LIST_HEAD(&ri->data.keyfields);
+	INIT_LIST_HEAD(&ri->data.actionfields);
+	ri->ndev = ndev;
+	ri->admin = admin; /* refer to the vcap instance */
+	ri->vctrl = vctrl; /* refer to the client */
+	if (vcap_set_rule_id(ri) == 0)
+		goto out_free;
+	return (struct vcap_rule *)ri;
+
+out_free:
+	kfree(ri);
+	return ERR_PTR(-EINVAL);
+}
+EXPORT_SYMBOL_GPL(vcap_alloc_rule);
+
+/* Free mem of a rule owned by client after the rule as been added to the VCAP */
+void vcap_free_rule(struct vcap_rule *rule)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	struct vcap_client_actionfield *caf, *next_caf;
+	struct vcap_client_keyfield *ckf, *next_ckf;
+
+	/* Deallocate the list of keys and actions */
+	list_for_each_entry_safe(ckf, next_ckf, &ri->data.keyfields, ctrl.list) {
+		list_del(&ckf->ctrl.list);
+		kfree(ckf);
+	}
+	list_for_each_entry_safe(caf, next_caf, &ri->data.actionfields, ctrl.list) {
+		list_del(&caf->ctrl.list);
+		kfree(caf);
+	}
+	/* Deallocate the rule */
+	kfree(rule);
+}
+EXPORT_SYMBOL_GPL(vcap_free_rule);
+
+/* Delete rule in a VCAP instance */
+int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id)
+{
+	struct vcap_rule_internal *ri, *elem;
+	struct vcap_admin *admin;
+
+	/* This will later also handle rule moving */
+	if (!ndev)
+		return -ENODEV;
+	/* Look for the rule id in all vcaps */
+	ri = vcap_lookup_rule(vctrl, id);
+	if (!ri)
+		return -EINVAL;
+	admin = ri->admin;
+	list_del(&ri->list);
+	if (list_empty(&admin->rules)) {
+		admin->last_used_addr = admin->last_valid_addr;
+	} else {
+		/* update the address range end marker from the last rule in the list */
+		elem = list_last_entry(&admin->rules, struct vcap_rule_internal, list);
+		admin->last_used_addr = elem->addr;
+	}
+	kfree(ri);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vcap_del_rule);
+
+static void vcap_copy_from_client_keyfield(struct vcap_rule *rule,
+					   struct vcap_client_keyfield *field,
+					   struct vcap_client_keyfield_data *data)
+{
+	/* This will be expanded later to handle different vcap memory layouts */
+	memcpy(&field->data, data, sizeof(field->data));
+}
+
+static int vcap_rule_add_key(struct vcap_rule *rule,
+			     enum vcap_key_field key,
+			     enum vcap_field_type ftype,
+			     struct vcap_client_keyfield_data *data)
+{
+	struct vcap_client_keyfield *field;
+
+	/* More validation will be added here later */
+	field = kzalloc(sizeof(*field), GFP_KERNEL);
+	if (!field)
+		return -ENOMEM;
+	field->ctrl.key = key;
+	field->ctrl.type = ftype;
+	vcap_copy_from_client_keyfield(rule, field, data);
+	list_add_tail(&field->ctrl.list, &rule->keyfields);
+	return 0;
+}
+
+/* Add a 48 bit key with value and mask to the rule */
+int vcap_rule_add_key_u48(struct vcap_rule *rule, enum vcap_key_field key,
+			  struct vcap_u48_key *fieldval)
+{
+	struct vcap_client_keyfield_data data;
+
+	memcpy(&data.u48, fieldval, sizeof(data.u48));
+	return vcap_rule_add_key(rule, key, VCAP_FIELD_U48, &data);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_add_key_u48);
+
+static void vcap_copy_from_client_actionfield(struct vcap_rule *rule,
+					      struct vcap_client_actionfield *field,
+					      struct vcap_client_actionfield_data *data)
+{
+	/* This will be expanded later to handle different vcap memory layouts */
+	memcpy(&field->data, data, sizeof(field->data));
+}
+
+static int vcap_rule_add_action(struct vcap_rule *rule,
+				enum vcap_action_field action,
+				enum vcap_field_type ftype,
+				struct vcap_client_actionfield_data *data)
+{
+	struct vcap_client_actionfield *field;
+
+	/* More validation will be added here later */
+	field = kzalloc(sizeof(*field), GFP_KERNEL);
+	if (!field)
+		return -ENOMEM;
+	field->ctrl.action = action;
+	field->ctrl.type = ftype;
+	vcap_copy_from_client_actionfield(rule, field, data);
+	list_add_tail(&field->ctrl.list, &rule->actionfields);
+	return 0;
+}
+
+static void vcap_rule_set_action_bitsize(struct vcap_u1_action *u1,
+					 enum vcap_bit val)
+{
+	switch (val) {
+	case VCAP_BIT_0:
+		u1->value = 0;
+		break;
+	case VCAP_BIT_1:
+		u1->value = 1;
+		break;
+	case VCAP_BIT_ANY:
+		u1->value = 0;
+		break;
+	}
+}
+
+/* Add a bit action with value to the rule */
+int vcap_rule_add_action_bit(struct vcap_rule *rule,
+			     enum vcap_action_field action,
+			     enum vcap_bit val)
+{
+	struct vcap_client_actionfield_data data;
+
+	vcap_rule_set_action_bitsize(&data.u1, val);
+	return vcap_rule_add_action(rule, action, VCAP_FIELD_BIT, &data);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_add_action_bit);
+
+/* Add a 32 bit action field with value to the rule */
+int vcap_rule_add_action_u32(struct vcap_rule *rule,
+			     enum vcap_action_field action,
+			     u32 value)
+{
+	struct vcap_client_actionfield_data data;
+
+	data.u32.value = value;
+	return vcap_rule_add_action(rule, action, VCAP_FIELD_U32, &data);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_add_action_u32);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
new file mode 100644
index 000000000000..2c4fd9d022f9
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -0,0 +1,187 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
+ * Microchip VCAP API
+ */
+
+#ifndef __VCAP_API_CLIENT__
+#define __VCAP_API_CLIENT__
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+
+#include "vcap_api.h"
+
+/* Client supplied VCAP rule key control part */
+struct vcap_client_keyfield_ctrl {
+	struct list_head list;  /* For insertion into a rule */
+	enum vcap_key_field key;
+	enum vcap_field_type type;
+};
+
+struct vcap_u1_key {
+	u8 value;
+	u8 mask;
+};
+
+struct vcap_u32_key {
+	u32 value;
+	u32 mask;
+};
+
+struct vcap_u48_key {
+	u8 value[6];
+	u8 mask[6];
+};
+
+struct vcap_u56_key {
+	u8 value[7];
+	u8 mask[7];
+};
+
+struct vcap_u64_key {
+	u8 value[8];
+	u8 mask[8];
+};
+
+struct vcap_u72_key {
+	u8 value[9];
+	u8 mask[9];
+};
+
+struct vcap_u112_key {
+	u8 value[14];
+	u8 mask[14];
+};
+
+struct vcap_u128_key {
+	u8 value[16];
+	u8 mask[16];
+};
+
+/* Client supplied VCAP rule field data */
+struct vcap_client_keyfield_data {
+	union {
+		struct vcap_u1_key u1;
+		struct vcap_u32_key u32;
+		struct vcap_u48_key u48;
+		struct vcap_u56_key u56;
+		struct vcap_u64_key u64;
+		struct vcap_u72_key u72;
+		struct vcap_u112_key u112;
+		struct vcap_u128_key u128;
+	};
+};
+
+/* Client supplied VCAP rule key (value, mask) */
+struct vcap_client_keyfield {
+	struct vcap_client_keyfield_ctrl ctrl;
+	struct vcap_client_keyfield_data data;
+};
+
+/* Client supplied VCAP rule action control part */
+struct vcap_client_actionfield_ctrl {
+	struct list_head list;  /* For insertion into a rule */
+	enum vcap_action_field action;
+	enum vcap_field_type type;
+};
+
+struct vcap_u1_action {
+	u8 value;
+};
+
+struct vcap_u32_action {
+	u32 value;
+};
+
+struct vcap_u48_action {
+	u8 value[6];
+};
+
+struct vcap_u56_action {
+	u8 value[7];
+};
+
+struct vcap_u64_action {
+	u8 value[8];
+};
+
+struct vcap_u72_action {
+	u8 value[9];
+};
+
+struct vcap_u112_action {
+	u8 value[14];
+};
+
+struct vcap_u128_action {
+	u8 value[16];
+};
+
+struct vcap_client_actionfield_data {
+	union {
+		struct vcap_u1_action u1;
+		struct vcap_u32_action u32;
+		struct vcap_u48_action u48;
+		struct vcap_u56_action u56;
+		struct vcap_u64_action u64;
+		struct vcap_u72_action u72;
+		struct vcap_u112_action u112;
+		struct vcap_u128_action u128;
+	};
+};
+
+struct vcap_client_actionfield {
+	struct vcap_client_actionfield_ctrl ctrl;
+	struct vcap_client_actionfield_data data;
+};
+
+enum vcap_bit {
+	VCAP_BIT_ANY,
+	VCAP_BIT_0,
+	VCAP_BIT_1
+};
+
+/* VCAP rule operations */
+/* Allocate a rule and fill in the basic information */
+struct vcap_rule *vcap_alloc_rule(struct vcap_control *vctrl,
+				  struct net_device *ndev,
+				  int vcap_chain_id,
+				  enum vcap_user user,
+				  u16 priority,
+				  u32 id);
+/* Free mem of a rule owned by client */
+void vcap_free_rule(struct vcap_rule *rule);
+/* Validate a rule before adding it to the VCAP */
+int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto);
+/* Add rule to a VCAP instance */
+int vcap_add_rule(struct vcap_rule *rule);
+/* Delete rule in a VCAP instance */
+int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id);
+
+/* Update the keyset for the rule */
+int vcap_set_rule_set_keyset(struct vcap_rule *rule,
+			     enum vcap_keyfield_set keyset);
+/* Update the actionset for the rule */
+int vcap_set_rule_set_actionset(struct vcap_rule *rule,
+				enum vcap_actionfield_set actionset);
+
+/* VCAP rule field operations */
+int vcap_rule_add_key_bit(struct vcap_rule *rule, enum vcap_key_field key,
+			  enum vcap_bit val);
+int vcap_rule_add_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
+			  u32 value, u32 mask);
+int vcap_rule_add_key_u48(struct vcap_rule *rule, enum vcap_key_field key,
+			  struct vcap_u48_key *fieldval);
+int vcap_rule_add_action_bit(struct vcap_rule *rule,
+			     enum vcap_action_field action, enum vcap_bit val);
+int vcap_rule_add_action_u32(struct vcap_rule *rule,
+			     enum vcap_action_field action, u32 value);
+
+/* VCAP lookup operations */
+/* Lookup a vcap instance using chain id */
+struct vcap_admin *vcap_find_admin(struct vcap_control *vctrl, int cid);
+/* Find a rule id with a provided cookie */
+int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie);
+
+#endif /* __VCAP_API_CLIENT__ */
-- 
2.38.1

