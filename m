Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F8117BE6A
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgCFN3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:29:05 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34217 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgCFN3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:29:05 -0500
Received: by mail-wr1-f68.google.com with SMTP id z15so2388165wrl.1
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A+xIyyEn/dgm09itwnEz9Whra3slf7CrDH5N9RRBVME=;
        b=CBIQzXlDh5RfzZbpVUVuxKStJqITIJ83VV3hO0LDpSpKlYbkh/VgSFz9i24XbL1RwQ
         s4hAqxRn3VJn4JSOWMYJ1QEl34VYmSPLO9fPnxsq33mesqXgQF83ggcSqf6pHegOE44k
         3ElyVBY3BG77v4w79zdDPlrdcxpCeNldfMmuch/rDWDK+w04H3ipxCiMFK6cVo7agQVX
         Lf5DdT6yfvCvkzVxdSCUGoq5bN87d9lbKNNwKZcCAWqwpkc6IhjlS+ResxPnBBMMfE9K
         iPD3RgFfw9ywN/L0iHeu9U7gKrSH6S6KZrVTTt3Qd0OoJbG2Z2/I6jy8U2x5EZf3uh0+
         EmNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A+xIyyEn/dgm09itwnEz9Whra3slf7CrDH5N9RRBVME=;
        b=YnGXVf3UxUJvyq8Hf8F55gkiy8Kxl+qLTaRmFCiSQ5VCJuVdLmN6/ZfRKhS+3vpcrP
         vWtFgBhNW+OYjORB1Ik1NGAGBD8XiaF0vYu4ZYnhBWS2A2Sj5lY8zxu5yRxxkjxPQhTk
         EdtEMsx9B6j4NI6g7tvapRworMCReS0GDu7G4Jncr0u7hZqicgrnKRFAKRQC46hL1AJv
         6DvPywfQtHb5EVPd12nQCuPjOW4O5op+5XtqHW5RWsJjlUu3Yd3Eq9K4Crfr4dPSNzhy
         EfwcErB7KnQNKH02bZJyhCOhpwA349QFnOd2jN7DlefXgwxVoURMvJTj8r7YN+PUOYvt
         6Y9w==
X-Gm-Message-State: ANhLgQ1StWVKoiOqRGkOU+49AjBJZ9fJjhcOLApyAnpk/JUYexOEFbuV
        lcPJ0BUp3IWfqgYLzQcr4kpm6SrKeFM=
X-Google-Smtp-Source: ADFU+vt5CsPQQEkTHnV8SPi6e5RyUGVudzDKMDRej8DRNF0prhYvA0TiqrauB15evIOjGRhsa62tNQ==
X-Received: by 2002:adf:f7c9:: with SMTP id a9mr4092643wrq.225.1583501341940;
        Fri, 06 Mar 2020 05:29:01 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b203sm467555wme.32.2020.03.06.05.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:29:01 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v3 03/10] flow_offload: check for basic action hw stats type
Date:   Fri,  6 Mar 2020 14:28:49 +0100
Message-Id: <20200306132856.6041-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200306132856.6041-1-jiri@resnulli.us>
References: <20200306132856.6041-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce flow_action_basic_hw_stats_types_check() helper and use it
in drivers. That sanitizes the drivers which do not have support
for action HW stats types.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- added flow_action_hw_stats_types_check() to pass allowed types
- "mixed" bool got remove, iterate entries in check
- added mlx5 checking instead of separate patches (will be changed by
  later patch to flow_action_hw_stats_types_check()
v1->v2:
- new patch
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  9 ++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  8 ++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |  3 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |  3 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    |  6 ++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  9 +++
 drivers/net/ethernet/mscc/ocelot_flower.c     |  4 ++
 .../ethernet/netronome/nfp/flower/action.c    |  4 ++
 .../net/ethernet/qlogic/qede/qede_filter.c    | 10 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |  9 ++-
 include/net/flow_offload.h                    | 61 +++++++++++++++++++
 net/dsa/slave.c                               |  4 ++
 12 files changed, 119 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 9bec256b0934..523bf4be43cc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -279,7 +279,8 @@ bnxt_tc_parse_pedit(struct bnxt *bp, struct bnxt_tc_actions *actions,
 
 static int bnxt_tc_parse_actions(struct bnxt *bp,
 				 struct bnxt_tc_actions *actions,
-				 struct flow_action *flow_action)
+				 struct flow_action *flow_action,
+				 struct netlink_ext_ack *extack)
 {
 	/* Used to store the L2 rewrite mask for dmac (6 bytes) followed by
 	 * smac (6 bytes) if rewrite of both is specified, otherwise either
@@ -299,6 +300,9 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
 		return -EINVAL;
 	}
 
+	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
+		return -EOPNOTSUPP;
+
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_DROP:
@@ -491,7 +495,8 @@ static int bnxt_tc_parse_flow(struct bnxt *bp,
 		flow->tun_mask.tp_src = match.mask->src;
 	}
 
-	return bnxt_tc_parse_actions(bp, &flow->actions, &rule->action);
+	return bnxt_tc_parse_actions(bp, &flow->actions, &rule->action,
+				     tc_flow_cmd->common.extack);
 }
 
 static int bnxt_hwrm_cfa_flow_free(struct bnxt *bp,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index bb5513bdd293..cc46277e98de 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -544,7 +544,8 @@ static bool valid_pedit_action(struct net_device *dev,
 }
 
 int cxgb4_validate_flow_actions(struct net_device *dev,
-				struct flow_action *actions)
+				struct flow_action *actions,
+				struct netlink_ext_ack *extack)
 {
 	struct flow_action_entry *act;
 	bool act_redir = false;
@@ -552,6 +553,9 @@ int cxgb4_validate_flow_actions(struct net_device *dev,
 	bool act_vlan = false;
 	int i;
 
+	if (!flow_action_basic_hw_stats_types_check(actions, extack))
+		return -EOPNOTSUPP;
+
 	flow_action_for_each(i, act, actions) {
 		switch (act->id) {
 		case FLOW_ACTION_ACCEPT:
@@ -642,7 +646,7 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 	struct filter_ctx ctx;
 	int fidx, ret;
 
-	if (cxgb4_validate_flow_actions(dev, &rule->action))
+	if (cxgb4_validate_flow_actions(dev, &rule->action, extack))
 		return -EOPNOTSUPP;
 
 	if (cxgb4_validate_flow_match(dev, cls))
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
index e132516e9868..0a30c96b81ff 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
@@ -112,7 +112,8 @@ void cxgb4_process_flow_actions(struct net_device *in,
 				struct flow_action *actions,
 				struct ch_filter_specification *fs);
 int cxgb4_validate_flow_actions(struct net_device *dev,
-				struct flow_action *actions);
+				struct flow_action *actions,
+				struct netlink_ext_ack *extack);
 
 int cxgb4_tc_flower_replace(struct net_device *dev,
 			    struct flow_cls_offload *cls);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 1b7681a4eb32..d80dee4d316d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -286,7 +286,8 @@ int cxgb4_tc_matchall_replace(struct net_device *dev,
 		}
 
 		ret = cxgb4_validate_flow_actions(dev,
-						  &cls_matchall->rule->action);
+						  &cls_matchall->rule->action,
+						  extack);
 		if (ret)
 			return ret;
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 35478cba2aa5..0a0c6ec2336c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1082,6 +1082,9 @@ static int mvpp2_port_c2_tcam_rule_add(struct mvpp2_port *port,
 	u8 qh, ql, pmap;
 	int index, ctx;
 
+	if (!flow_action_basic_hw_stats_types_check(&rule->flow->action, NULL))
+		return -EOPNOTSUPP;
+
 	memset(&c2, 0, sizeof(c2));
 
 	index = mvpp2_cls_c2_port_flow_index(port, rule->loc);
@@ -1305,6 +1308,9 @@ static int mvpp2_cls_rfs_parse_rule(struct mvpp2_rfs_rule *rule)
 	struct flow_rule *flow = rule->flow;
 	struct flow_action_entry *act;
 
+	if (!flow_action_basic_hw_stats_types_check(&rule->flow->action, NULL))
+		return -EOPNOTSUPP;
+
 	act = &flow->action.entries[0];
 	if (act->id != FLOW_ACTION_QUEUE && act->id != FLOW_ACTION_DROP)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4eb2f2392d2d..cfe393cb4026 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2878,6 +2878,9 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
 
+	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
+		return -EOPNOTSUPP;
+
 	attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
 
 	flow_action_for_each(i, act, flow_action) {
@@ -3330,6 +3333,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
 
+	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
+		return -EOPNOTSUPP;
+
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_DROP:
@@ -4148,6 +4154,9 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
+		return -EOPNOTSUPP;
+
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 8986f209e981..6d84173373c7 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -17,6 +17,10 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 	if (!flow_offload_has_one_action(&f->rule->action))
 		return -EOPNOTSUPP;
 
+	if (!flow_action_basic_hw_stats_types_check(&f->rule->action,
+						    f->common.extack))
+		return -EOPNOTSUPP;
+
 	flow_action_for_each(i, a, &f->rule->action) {
 		switch (a->id) {
 		case FLOW_ACTION_DROP:
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index c06600fb47ff..4aa7346cb040 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -1207,6 +1207,10 @@ int nfp_flower_compile_action(struct nfp_app *app,
 	bool pkt_host = false;
 	u32 csum_updated = 0;
 
+	if (!flow_action_basic_hw_stats_types_check(&flow->rule->action,
+						    extack))
+		return -EOPNOTSUPP;
+
 	memset(nfp_flow->action_data, 0, NFP_FL_MAX_A_SIZ);
 	nfp_flow->meta.act_len = 0;
 	tun_type = NFP_FL_TUNNEL_NONE;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index d1ce4531d01a..6505f7e2d1db 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1746,7 +1746,8 @@ int qede_get_arfs_filter_count(struct qede_dev *edev)
 }
 
 static int qede_parse_actions(struct qede_dev *edev,
-			      struct flow_action *flow_action)
+			      struct flow_action *flow_action,
+			      struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry *act;
 	int i;
@@ -1756,6 +1757,9 @@ static int qede_parse_actions(struct qede_dev *edev,
 		return -EINVAL;
 	}
 
+	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
+		return -EOPNOTSUPP;
+
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_DROP:
@@ -1970,7 +1974,7 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 	}
 
 	/* parse tc actions and get the vf_id */
-	if (qede_parse_actions(edev, &f->rule->action))
+	if (qede_parse_actions(edev, &f->rule->action, f->common.extack))
 		goto unlock;
 
 	if (qede_flow_find_fltr(edev, &t)) {
@@ -2038,7 +2042,7 @@ static int qede_flow_spec_validate(struct qede_dev *edev,
 		return -EINVAL;
 	}
 
-	if (qede_parse_actions(edev, flow_action))
+	if (qede_parse_actions(edev, flow_action, NULL))
 		return -EINVAL;
 
 	return 0;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 7a01dee2f9a8..a0e6118444b0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -367,7 +367,8 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 
 static int tc_parse_flow_actions(struct stmmac_priv *priv,
 				 struct flow_action *action,
-				 struct stmmac_flow_entry *entry)
+				 struct stmmac_flow_entry *entry,
+				 struct netlink_ext_ack *extack)
 {
 	struct flow_action_entry *act;
 	int i;
@@ -375,6 +376,9 @@ static int tc_parse_flow_actions(struct stmmac_priv *priv,
 	if (!flow_action_has_entries(action))
 		return -EINVAL;
 
+	if (!flow_action_basic_hw_stats_types_check(action, extack))
+		return -EOPNOTSUPP;
+
 	flow_action_for_each(i, act, action) {
 		switch (act->id) {
 		case FLOW_ACTION_DROP:
@@ -530,7 +534,8 @@ static int tc_add_flow(struct stmmac_priv *priv,
 			return -ENOENT;
 	}
 
-	ret = tc_parse_flow_actions(priv, &rule->action, entry);
+	ret = tc_parse_flow_actions(priv, &rule->action, entry,
+				    cls->common.extack);
 	if (ret)
 		return ret;
 
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3afd270eb135..2dc0332a44c3 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/netlink.h>
 #include <net/flow_dissector.h>
 #include <linux/rhashtable.h>
 
@@ -251,6 +252,66 @@ static inline bool flow_offload_has_one_action(const struct flow_action *action)
 	return action->num_entries == 1;
 }
 
+static inline bool
+flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
+				       struct netlink_ext_ack *extack)
+{
+	const struct flow_action_entry *action_entry;
+	u8 uninitialized_var(last_hw_stats_type);
+	int i;
+
+	if (flow_offload_has_one_action(action))
+		return true;
+
+	for (i = 0; i < action->num_entries; i++) {
+		action_entry = &action->entries[0];
+		if (i && action_entry->hw_stats_type != last_hw_stats_type) {
+			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
+			return false;
+		}
+		last_hw_stats_type = action_entry->hw_stats_type;
+	}
+	return true;
+}
+
+static inline const struct flow_action_entry *
+flow_action_first_entry_get(const struct flow_action *action)
+{
+	WARN_ON(!flow_action_has_entries(action));
+	return &action->entries[0];
+}
+
+static inline bool
+flow_action_hw_stats_types_check(const struct flow_action *action,
+				 struct netlink_ext_ack *extack,
+				 u8 allowed_hw_stats_type)
+{
+	const struct flow_action_entry *action_entry;
+
+	if (!flow_action_has_entries(action))
+		return true;
+	if (!flow_action_mixed_hw_stats_types_check(action, extack))
+		return false;
+	action_entry = flow_action_first_entry_get(action);
+	if (!allowed_hw_stats_type &&
+	    action_entry->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
+		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
+		return false;
+	} else if (allowed_hw_stats_type &&
+		   action_entry->hw_stats_type != allowed_hw_stats_type) {
+		NL_SET_ERR_MSG_MOD(extack, "Driver does not support selected HW stats type");
+		return false;
+	}
+	return true;
+}
+
+static inline bool
+flow_action_basic_hw_stats_types_check(const struct flow_action *action,
+				       struct netlink_ext_ack *extack)
+{
+	return flow_action_hw_stats_types_check(action, extack, 0);
+}
+
 #define flow_action_for_each(__i, __act, __actions)			\
         for (__i = 0, __act = &(__actions)->entries[0]; __i < (__actions)->num_entries; __act = &(__actions)->entries[++__i])
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 79d9b4384d7b..fca9bfa8437e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -865,6 +865,10 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 	if (!flow_offload_has_one_action(&cls->rule->action))
 		return err;
 
+	if (!flow_action_basic_hw_stats_types_check(&cls->rule->action,
+						    cls->common.extack))
+		return err;
+
 	act = &cls->rule->action.entries[0];
 
 	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
-- 
2.21.1

