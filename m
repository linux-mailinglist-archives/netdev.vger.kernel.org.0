Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA20A6386A1
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiKYJtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiKYJsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:48:06 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6BE3E0B8;
        Fri, 25 Nov 2022 01:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669369584; x=1700905584;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kov2mxU5DjYbNCzly47F20cdNnrN2Goj9jzLvzVK0hQ=;
  b=abauJP+UKqsELHBWfjC+penurgotZSdISxcWKShKgAU8HTYbgYAU+pnM
   XvCsUo87EH2nu9hNb2bLv2t4drW3gB9QtTQi2tFtf3YF4bK9q30zo1IVk
   zBrHk3O5TYh12VZP7Bz2sjySm9gkdCU7T9d6PnQb+hRY4arFRZwkL6AzR
   EcYnHF7gvvpZNlRbGZiv32tOnBwtzRNpcELBAju5Q7X2DADijJPbkchUZ
   ImH/fmGM68jrurGDGYUbz8cAAyEru3PvYF3c6uor8YXfVRcskbS4QlxPn
   GTLi0fvSy4cmU0FrqD4I+hhfm9MkidAnXEnI9Tpm/GSOrUGT59BGrWguM
   g==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="125075008"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 02:46:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 02:46:22 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 25 Nov 2022 02:46:19 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 6/9] net: lan966x: add tc flower support for VCAP API
Date:   Fri, 25 Nov 2022 10:50:07 +0100
Message-ID: <20221125095010.124458-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221125095010.124458-1-horatiu.vultur@microchip.com>
References: <20221125095010.124458-1-horatiu.vultur@microchip.com>
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

Currently the only supported action is ACTION_TRAP and the only
dissector is ETH_ADDRS. Others will be added in future patches.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |   3 +
 .../ethernet/microchip/lan966x/lan966x_tc.c   |   2 +
 .../microchip/lan966x/lan966x_tc_flower.c     | 262 ++++++++++++++++++
 .../microchip/lan966x/lan966x_vcap_impl.c     | 152 ++++++++++
 5 files changed, 421 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 053a174f09f32..23781149f7a9b 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -12,7 +12,8 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_tc.o lan966x_mqprio.o lan966x_taprio.o \
 			lan966x_tbf.o lan966x_cbs.o lan966x_ets.o \
 			lan966x_tc_matchall.o lan966x_police.o lan966x_mirror.o \
-			lan966x_xdp.o lan966x_vcap_impl.o lan966x_vcap_ag_api.o
+			lan966x_xdp.o lan966x_vcap_impl.o lan966x_vcap_ag_api.o \
+			lan966x_tc_flower.o
 
 # Provide include files
 ccflags-y += -I$(srctree)/drivers/net/ethernet/microchip/vcap
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index eecb1a2bf9a72..0820b96b75ab1 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -566,6 +566,9 @@ static inline bool lan966x_xdp_port_present(struct lan966x_port *port)
 int lan966x_vcap_init(struct lan966x *lan966x);
 void lan966x_vcap_deinit(struct lan966x *lan966x);
 
+int lan966x_tc_flower(struct lan966x_port *port,
+		      struct flow_cls_offload *f);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
index 651d5493ae55b..01072121c999e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
@@ -69,6 +69,8 @@ static int lan966x_tc_block_cb(enum tc_setup_type type, void *type_data,
 	switch (type) {
 	case TC_SETUP_CLSMATCHALL:
 		return lan966x_tc_matchall(port, type_data, ingress);
+	case TC_SETUP_CLSFLOWER:
+		return lan966x_tc_flower(port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
new file mode 100644
index 0000000000000..04a2afd683cca
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -0,0 +1,262 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+#include "vcap_api.h"
+#include "vcap_api_client.h"
+
+/* Controls how PORT_MASK is applied */
+enum LAN966X_PORT_MASK_MODE {
+	LAN966X_PMM_NO_ACTION,
+	LAN966X_PMM_REPLACE,
+	LAN966X_PMM_FORWARDING,
+	LAN966X_PMM_REDIRECT,
+};
+
+struct lan966x_tc_flower_parse_usage {
+	struct flow_cls_offload *f;
+	struct flow_rule *frule;
+	struct vcap_rule *vrule;
+	unsigned int used_keys;
+	u16 l3_proto;
+};
+
+static int lan966x_tc_flower_handler_ethaddr_usage(struct lan966x_tc_flower_parse_usage *st)
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
+		vcap_netbytes_copy(smac.value, match.key->src, ETH_ALEN);
+		vcap_netbytes_copy(smac.mask, match.mask->src, ETH_ALEN);
+		err = vcap_rule_add_key_u48(st->vrule, smac_key, &smac);
+		if (err)
+			goto out;
+	}
+
+	if (!is_zero_ether_addr(match.mask->dst)) {
+		vcap_netbytes_copy(dmac.value, match.key->dst, ETH_ALEN);
+		vcap_netbytes_copy(dmac.mask, match.mask->dst, ETH_ALEN);
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
+	NL_SET_ERR_MSG_MOD(st->f->common.extack, "eth_addr parse error");
+	return err;
+}
+
+static int
+(*lan966x_tc_flower_handlers_usage[])(struct lan966x_tc_flower_parse_usage *st) = {
+	[FLOW_DISSECTOR_KEY_ETH_ADDRS] = lan966x_tc_flower_handler_ethaddr_usage,
+};
+
+static int lan966x_tc_flower_use_dissectors(struct flow_cls_offload *f,
+					    struct vcap_admin *admin,
+					    struct vcap_rule *vrule,
+					    u16 *l3_proto)
+{
+	struct lan966x_tc_flower_parse_usage state = {
+		.f = f,
+		.vrule = vrule,
+		.l3_proto = ETH_P_ALL,
+	};
+	int err = 0;
+
+	state.frule = flow_cls_offload_flow_rule(f);
+	for (int i = 0; i < ARRAY_SIZE(lan966x_tc_flower_handlers_usage); ++i) {
+		if (!flow_rule_match_key(state.frule, i) ||
+		    !lan966x_tc_flower_handlers_usage[i])
+			continue;
+
+		err = lan966x_tc_flower_handlers_usage[i](&state);
+		if (err)
+			return err;
+	}
+
+	if (l3_proto)
+		*l3_proto = state.l3_proto;
+
+	return err;
+}
+
+static int lan966x_tc_flower_action_check(struct vcap_control *vctrl,
+					  struct flow_cls_offload *fco,
+					  struct vcap_admin *admin)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(fco);
+	struct flow_action_entry *actent, *last_actent = NULL;
+	struct flow_action *act = &rule->action;
+	u64 action_mask = 0;
+	int idx;
+
+	if (!flow_action_has_entries(act)) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack, "No actions");
+		return -EINVAL;
+	}
+
+	if (!flow_action_basic_hw_stats_check(act, fco->common.extack))
+		return -EOPNOTSUPP;
+
+	flow_action_for_each(idx, actent, act) {
+		if (action_mask & BIT(actent->id)) {
+			NL_SET_ERR_MSG_MOD(fco->common.extack,
+					   "More actions of the same type");
+			return -EINVAL;
+		}
+		action_mask |= BIT(actent->id);
+		last_actent = actent; /* Save last action for later check */
+	}
+
+	/* Check that last action is a goto */
+	if (last_actent->id != FLOW_ACTION_GOTO) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Last action must be 'goto'");
+		return -EINVAL;
+	}
+
+	/* Check if the goto chain is in the next lookup */
+	if (!vcap_is_next_lookup(vctrl, fco->common.chain_index,
+				 last_actent->chain_index)) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Invalid goto chain");
+		return -EINVAL;
+	}
+
+	/* Catch unsupported combinations of actions */
+	if (action_mask & BIT(FLOW_ACTION_TRAP) &&
+	    action_mask & BIT(FLOW_ACTION_ACCEPT)) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Cannot combine pass and trap action");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int lan966x_tc_flower_add(struct lan966x_port *port,
+				 struct flow_cls_offload *f,
+				 struct vcap_admin *admin)
+{
+	struct flow_action_entry *act;
+	u16 l3_proto = ETH_P_ALL;
+	struct flow_rule *frule;
+	struct vcap_rule *vrule;
+	int err, idx;
+
+	err = lan966x_tc_flower_action_check(port->lan966x->vcap_ctrl, f,
+					     admin);
+	if (err)
+		return err;
+
+	vrule = vcap_alloc_rule(port->lan966x->vcap_ctrl, port->dev,
+				f->common.chain_index, VCAP_USER_TC,
+				f->common.prio, 0);
+	if (IS_ERR(vrule))
+		return PTR_ERR(vrule);
+
+	vrule->cookie = f->cookie;
+	err = lan966x_tc_flower_use_dissectors(f, admin, vrule, &l3_proto);
+	if (err)
+		goto out;
+
+	frule = flow_cls_offload_flow_rule(f);
+
+	flow_action_for_each(idx, act, &frule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_TRAP:
+			err = vcap_rule_add_action_bit(vrule,
+						       VCAP_AF_CPU_COPY_ENA,
+						       VCAP_BIT_1);
+			err |= vcap_rule_add_action_u32(vrule,
+							VCAP_AF_CPU_QUEUE_NUM,
+							0);
+			err |= vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE,
+							LAN966X_PMM_REPLACE);
+			err |= vcap_set_rule_set_actionset(vrule,
+							   VCAP_AFS_BASE_TYPE);
+			if (err)
+				goto out;
+
+			break;
+		case FLOW_ACTION_GOTO:
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(f->common.extack,
+					   "Unsupported TC action");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+	}
+
+	err = vcap_val_rule(vrule, l3_proto);
+	if (err) {
+		vcap_set_tc_exterr(f, vrule);
+		goto out;
+	}
+
+	err = vcap_add_rule(vrule);
+	if (err)
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Could not add the filter");
+out:
+	vcap_free_rule(vrule);
+	return err;
+}
+
+static int lan966x_tc_flower_del(struct lan966x_port *port,
+				 struct flow_cls_offload *f,
+				 struct vcap_admin *admin)
+{
+	struct vcap_control *vctrl;
+	int err = -ENOENT, rule_id;
+
+	vctrl = port->lan966x->vcap_ctrl;
+	while (true) {
+		rule_id = vcap_lookup_rule_by_cookie(vctrl, f->cookie);
+		if (rule_id <= 0)
+			break;
+
+		err = vcap_del_rule(vctrl, port->dev, rule_id);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(f->common.extack,
+					   "Cannot delete rule");
+			break;
+		}
+	}
+
+	return err;
+}
+
+int lan966x_tc_flower(struct lan966x_port *port,
+		      struct flow_cls_offload *f)
+{
+	struct vcap_admin *admin;
+
+	admin = vcap_find_admin(port->lan966x->vcap_ctrl,
+				f->common.chain_index);
+	if (!admin) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Invalid chain");
+		return -EINVAL;
+	}
+
+	switch (f->command) {
+	case FLOW_CLS_REPLACE:
+		return lan966x_tc_flower_add(port, f, admin);
+	case FLOW_CLS_DESTROY:
+		return lan966x_tc_flower_del(port, f, admin);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
index aac821cd611e8..08253dd4a306f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -3,10 +3,143 @@
 #include "lan966x_main.h"
 #include "lan966x_vcap_ag_api.h"
 #include "vcap_api.h"
+#include "vcap_api_client.h"
+
+#define LAN966X_VCAP_CID_IS2_L0 VCAP_CID_INGRESS_STAGE2_L0 /* IS2 lookup 0 */
+#define LAN966X_VCAP_CID_IS2_L1 VCAP_CID_INGRESS_STAGE2_L1 /* IS2 lookup 1 */
+#define LAN966X_VCAP_CID_IS2_MAX (VCAP_CID_INGRESS_STAGE2_L2 - 1) /* IS2 Max */
+
+#define STREAMSIZE (64 * 4)
+
+#define LAN966X_IS2_LOOKUPS 2
+
+static struct lan966x_vcap_inst {
+	enum vcap_type vtype; /* type of vcap */
+	int tgt_inst; /* hardware instance number */
+	int lookups; /* number of lookups in this vcap type */
+	int first_cid; /* first chain id in this vcap */
+	int last_cid; /* last chain id in this vcap */
+	int count; /* number of available addresses */
+} lan966x_vcap_inst_cfg[] = {
+	{
+		.vtype = VCAP_TYPE_IS2, /* IS2-0 */
+		.tgt_inst = 2,
+		.lookups = LAN966X_IS2_LOOKUPS,
+		.first_cid = LAN966X_VCAP_CID_IS2_L0,
+		.last_cid = LAN966X_VCAP_CID_IS2_MAX,
+		.count = 256,
+	},
+};
+
+struct lan966x_vcap_cmd_cb {
+	struct lan966x *lan966x;
+	u32 instance;
+};
+
+static u32 lan966x_vcap_read_update_ctrl(const struct lan966x_vcap_cmd_cb *cb)
+{
+	return lan_rd(cb->lan966x, VCAP_UPDATE_CTRL(cb->instance));
+}
+
+static void lan966x_vcap_wait_update(struct lan966x *lan966x, int instance)
+{
+	const struct lan966x_vcap_cmd_cb cb = { .lan966x = lan966x,
+						.instance = instance };
+	u32 val;
+
+	readx_poll_timeout(lan966x_vcap_read_update_ctrl, &cb, val,
+			   (val & VCAP_UPDATE_CTRL_UPDATE_SHOT) == 0, 10,
+			   100000);
+}
+
+static void __lan966x_vcap_range_init(struct lan966x *lan966x,
+				      struct vcap_admin *admin,
+				      u32 addr,
+				      u32 count)
+{
+	lan_wr(VCAP_MV_CFG_MV_NUM_POS_SET(0) |
+	       VCAP_MV_CFG_MV_SIZE_SET(count - 1),
+	       lan966x, VCAP_MV_CFG(admin->tgt_inst));
+
+	lan_wr(VCAP_UPDATE_CTRL_UPDATE_CMD_SET(VCAP_CMD_INITIALIZE) |
+	       VCAP_UPDATE_CTRL_UPDATE_ENTRY_DIS_SET(0) |
+	       VCAP_UPDATE_CTRL_UPDATE_ACTION_DIS_SET(0) |
+	       VCAP_UPDATE_CTRL_UPDATE_CNT_DIS_SET(0) |
+	       VCAP_UPDATE_CTRL_UPDATE_ADDR_SET(addr) |
+	       VCAP_UPDATE_CTRL_CLEAR_CACHE_SET(true) |
+	       VCAP_UPDATE_CTRL_UPDATE_SHOT_SET(1),
+	       lan966x, VCAP_UPDATE_CTRL(admin->tgt_inst));
+
+	lan966x_vcap_wait_update(lan966x, admin->tgt_inst);
+}
+
+static void lan966x_vcap_admin_free(struct vcap_admin *admin)
+{
+	if (!admin)
+		return;
+
+	kfree(admin->cache.keystream);
+	kfree(admin->cache.maskstream);
+	kfree(admin->cache.actionstream);
+	mutex_destroy(&admin->lock);
+	kfree(admin);
+}
+
+static struct vcap_admin *
+lan966x_vcap_admin_alloc(struct lan966x *lan966x, struct vcap_control *ctrl,
+			 const struct lan966x_vcap_inst *cfg)
+{
+	struct vcap_admin *admin;
+
+	admin = kzalloc(sizeof(*admin), GFP_KERNEL);
+	if (!admin)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&admin->lock);
+	INIT_LIST_HEAD(&admin->list);
+	INIT_LIST_HEAD(&admin->rules);
+	admin->vtype = cfg->vtype;
+	admin->vinst = 0;
+	admin->lookups = cfg->lookups;
+	admin->lookups_per_instance = cfg->lookups;
+	admin->first_cid = cfg->first_cid;
+	admin->last_cid = cfg->last_cid;
+	admin->cache.keystream = kzalloc(STREAMSIZE, GFP_KERNEL);
+	admin->cache.maskstream = kzalloc(STREAMSIZE, GFP_KERNEL);
+	admin->cache.actionstream = kzalloc(STREAMSIZE, GFP_KERNEL);
+	if (!admin->cache.keystream ||
+	    !admin->cache.maskstream ||
+	    !admin->cache.actionstream) {
+		lan966x_vcap_admin_free(admin);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return admin;
+}
+
+static void lan966x_vcap_block_init(struct lan966x *lan966x,
+				    struct vcap_admin *admin,
+				    struct lan966x_vcap_inst *cfg)
+{
+	admin->first_valid_addr = 0;
+	admin->last_used_addr = cfg->count;
+	admin->last_valid_addr = cfg->count - 1;
+
+	lan_wr(VCAP_CORE_IDX_CORE_IDX_SET(0),
+	       lan966x, VCAP_CORE_IDX(admin->tgt_inst));
+	lan_wr(VCAP_CORE_MAP_CORE_MAP_SET(1),
+	       lan966x, VCAP_CORE_MAP(admin->tgt_inst));
+
+	__lan966x_vcap_range_init(lan966x, admin, admin->first_valid_addr,
+				  admin->last_valid_addr -
+					admin->first_valid_addr);
+}
 
 int lan966x_vcap_init(struct lan966x *lan966x)
 {
+	struct lan966x_vcap_inst *cfg;
 	struct vcap_control *ctrl;
+	struct vcap_admin *admin;
 
 	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
 	if (!ctrl)
@@ -15,6 +148,18 @@ int lan966x_vcap_init(struct lan966x *lan966x)
 	ctrl->vcaps = lan966x_vcaps;
 	ctrl->stats = &lan966x_vcap_stats;
 
+	INIT_LIST_HEAD(&ctrl->list);
+	for (int i = 0; i < ARRAY_SIZE(lan966x_vcap_inst_cfg); ++i) {
+		cfg = &lan966x_vcap_inst_cfg[i];
+
+		admin = lan966x_vcap_admin_alloc(lan966x, ctrl, cfg);
+		if (IS_ERR(admin))
+			return PTR_ERR(admin);
+
+		lan966x_vcap_block_init(lan966x, admin, cfg);
+		list_add_tail(&admin->list, &ctrl->list);
+	}
+
 	lan966x->vcap_ctrl = ctrl;
 
 	return 0;
@@ -22,11 +167,18 @@ int lan966x_vcap_init(struct lan966x *lan966x)
 
 void lan966x_vcap_deinit(struct lan966x *lan966x)
 {
+	struct vcap_admin *admin, *admin_next;
 	struct vcap_control *ctrl;
 
 	ctrl = lan966x->vcap_ctrl;
 	if (!ctrl)
 		return;
 
+	list_for_each_entry_safe(admin, admin_next, &ctrl->list, list) {
+		vcap_del_rules(ctrl, admin);
+		list_del(&admin->list);
+		lan966x_vcap_admin_free(admin);
+	}
+
 	kfree(ctrl);
 }
-- 
2.38.0

