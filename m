Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247FE28CB46
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 11:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391449AbgJMJ4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 05:56:48 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:16689 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgJMJ4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 05:56:48 -0400
X-Greylist: delayed 1509 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2020 05:56:47 EDT
Received: from punakha.blr.asicdesigners.com (trongsa.asicdesigners.com [10.193.187.15] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09D9VX16012549;
        Tue, 13 Oct 2020 02:31:34 -0700
From:   Herat Ramani <herat@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     rahul@chelsio.com, dt@chelsio.com, herat@chelsio.com
Subject: [PATCH net-next] cxgb4: handle 4-tuple PEDIT to NAT mode translation
Date:   Tue, 13 Oct 2020 15:01:29 +0530
Message-Id: <20201013093129.321-1-herat@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 4-tuple NAT offload via PEDIT always overwrites all the 4-tuple
fields even if they had not been explicitly enabled. If any fields in
the 4-tuple are not enabled, then the hardware overwrites the
disabled fields with zeros, instead of ignoring them.

So, add a parser that can translate the enabled 4-tuple PEDIT fields
to one of the NAT mode combinations supported by the hardware and
hence avoid overwriting disabled fields to 0. Any rule with
unsupported NAT mode combination is rejected.

Signed-off-by: Herat Ramani <herat@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  | 175 ++++++++++++++++--
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |  15 ++
 2 files changed, 177 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index f642c1b475c4..1b88bd1c2dbe 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -60,6 +60,89 @@ static struct ch_tc_pedit_fields pedits[] = {
 	PEDIT_FIELDS(IP6_, DST_127_96, 4, nat_lip, 12),
 };
 
+static const struct cxgb4_natmode_config cxgb4_natmode_config_array[] = {
+	/* Default supported NAT modes */
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_NONE,
+		.natmode = NAT_MODE_NONE,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP,
+		.natmode = NAT_MODE_DIP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_DPORT,
+		.natmode = NAT_MODE_DIP_DP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_DPORT |
+			 CXGB4_ACTION_NATMODE_SIP,
+		.natmode = NAT_MODE_DIP_DP_SIP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_DPORT |
+			 CXGB4_ACTION_NATMODE_SPORT,
+		.natmode = NAT_MODE_DIP_DP_SP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_SIP | CXGB4_ACTION_NATMODE_SPORT,
+		.natmode = NAT_MODE_SIP_SP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_SIP |
+			 CXGB4_ACTION_NATMODE_SPORT,
+		.natmode = NAT_MODE_DIP_SIP_SP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_SIP |
+			 CXGB4_ACTION_NATMODE_DPORT |
+			 CXGB4_ACTION_NATMODE_SPORT,
+		.natmode = NAT_MODE_ALL,
+	},
+	/* T6+ can ignore L4 ports when they're disabled. */
+	{
+		.chip = CHELSIO_T6,
+		.flags = CXGB4_ACTION_NATMODE_SIP,
+		.natmode = NAT_MODE_SIP_SP,
+	},
+	{
+		.chip = CHELSIO_T6,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_SPORT,
+		.natmode = NAT_MODE_DIP_DP_SP,
+	},
+	{
+		.chip = CHELSIO_T6,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_SIP,
+		.natmode = NAT_MODE_ALL,
+	},
+};
+
+static void cxgb4_action_natmode_tweak(struct ch_filter_specification *fs,
+				       u8 natmode_flags)
+{
+	u8 i = 0;
+
+	/* Translate the enabled NAT 4-tuple fields to one of the
+	 * hardware supported NAT mode configurations. This ensures
+	 * that we pick a valid combination, where the disabled fields
+	 * do not get overwritten to 0.
+	 */
+	for (i = 0; i < ARRAY_SIZE(cxgb4_natmode_config_array); i++) {
+		if (cxgb4_natmode_config_array[i].flags == natmode_flags) {
+			fs->nat_mode = cxgb4_natmode_config_array[i].natmode;
+			return;
+		}
+	}
+}
+
 static struct ch_tc_flower_entry *allocate_flower_entry(void)
 {
 	struct ch_tc_flower_entry *new = kzalloc(sizeof(*new), GFP_KERNEL);
@@ -289,7 +372,8 @@ static void offload_pedit(struct ch_filter_specification *fs, u32 val, u32 mask,
 }
 
 static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
-				u32 mask, u32 offset, u8 htype)
+				u32 mask, u32 offset, u8 htype,
+				u8 *natmode_flags)
 {
 	switch (htype) {
 	case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
@@ -314,60 +398,94 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 		switch (offset) {
 		case PEDIT_IP4_SRC:
 			offload_pedit(fs, val, mask, IP4_SRC);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
 			break;
 		case PEDIT_IP4_DST:
 			offload_pedit(fs, val, mask, IP4_DST);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 		}
-		fs->nat_mode = NAT_MODE_ALL;
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
 		switch (offset) {
 		case PEDIT_IP6_SRC_31_0:
 			offload_pedit(fs, val, mask, IP6_SRC_31_0);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
 			break;
 		case PEDIT_IP6_SRC_63_32:
 			offload_pedit(fs, val, mask, IP6_SRC_63_32);
+			*natmode_flags |=  CXGB4_ACTION_NATMODE_SIP;
 			break;
 		case PEDIT_IP6_SRC_95_64:
 			offload_pedit(fs, val, mask, IP6_SRC_95_64);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
 			break;
 		case PEDIT_IP6_SRC_127_96:
 			offload_pedit(fs, val, mask, IP6_SRC_127_96);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
 			break;
 		case PEDIT_IP6_DST_31_0:
 			offload_pedit(fs, val, mask, IP6_DST_31_0);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 			break;
 		case PEDIT_IP6_DST_63_32:
 			offload_pedit(fs, val, mask, IP6_DST_63_32);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 			break;
 		case PEDIT_IP6_DST_95_64:
 			offload_pedit(fs, val, mask, IP6_DST_95_64);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 			break;
 		case PEDIT_IP6_DST_127_96:
 			offload_pedit(fs, val, mask, IP6_DST_127_96);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 		}
-		fs->nat_mode = NAT_MODE_ALL;
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
 		switch (offset) {
 		case PEDIT_TCP_SPORT_DPORT:
-			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
+			if (~mask & PEDIT_TCP_UDP_SPORT_MASK) {
 				fs->nat_fport = val;
-			else
+				*natmode_flags |= CXGB4_ACTION_NATMODE_SPORT;
+			} else {
 				fs->nat_lport = val >> 16;
+				*natmode_flags |= CXGB4_ACTION_NATMODE_DPORT;
+			}
 		}
-		fs->nat_mode = NAT_MODE_ALL;
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
 		switch (offset) {
 		case PEDIT_UDP_SPORT_DPORT:
-			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
+			if (~mask & PEDIT_TCP_UDP_SPORT_MASK) {
 				fs->nat_fport = val;
-			else
+				*natmode_flags |= CXGB4_ACTION_NATMODE_SPORT;
+			} else {
 				fs->nat_lport = val >> 16;
+				*natmode_flags |= CXGB4_ACTION_NATMODE_DPORT;
+			}
 		}
-		fs->nat_mode = NAT_MODE_ALL;
+		break;
+	}
+}
+
+static int cxgb4_action_natmode_validate(struct adapter *adap, u8 natmode_flags,
+					 struct netlink_ext_ack *extack)
+{
+	u8 i = 0;
+
+	/* Extract the NAT mode to enable based on what 4-tuple fields
+	 * are enabled to be overwritten. This ensures that the
+	 * disabled fields don't get overwritten to 0.
+	 */
+	for (i = 0; i < ARRAY_SIZE(cxgb4_natmode_config_array); i++) {
+		const struct cxgb4_natmode_config *c;
+
+		c = &cxgb4_natmode_config_array[i];
+		if (CHELSIO_CHIP_VERSION(adap->params.chip) >= c->chip &&
+		    natmode_flags == c->flags)
+			return 0;
 	}
+	NL_SET_ERR_MSG_MOD(extack, "Unsupported NAT mode 4-tuple combination");
+	return -EOPNOTSUPP;
 }
 
 void cxgb4_process_flow_actions(struct net_device *in,
@@ -375,6 +493,7 @@ void cxgb4_process_flow_actions(struct net_device *in,
 				struct ch_filter_specification *fs)
 {
 	struct flow_action_entry *act;
+	u8 natmode_flags = 0;
 	int i;
 
 	flow_action_for_each(i, act, actions) {
@@ -426,7 +545,8 @@ void cxgb4_process_flow_actions(struct net_device *in,
 			val = act->mangle.val;
 			offset = act->mangle.offset;
 
-			process_pedit_field(fs, val, mask, offset, htype);
+			process_pedit_field(fs, val, mask, offset, htype,
+					    &natmode_flags);
 			}
 			break;
 		case FLOW_ACTION_QUEUE:
@@ -438,6 +558,9 @@ void cxgb4_process_flow_actions(struct net_device *in,
 			break;
 		}
 	}
+	if (natmode_flags)
+		cxgb4_action_natmode_tweak(fs, natmode_flags);
+
 }
 
 static bool valid_l4_mask(u32 mask)
@@ -454,7 +577,8 @@ static bool valid_l4_mask(u32 mask)
 }
 
 static bool valid_pedit_action(struct net_device *dev,
-			       const struct flow_action_entry *act)
+			       const struct flow_action_entry *act,
+			       u8 *natmode_flags)
 {
 	u32 mask, offset;
 	u8 htype;
@@ -479,7 +603,10 @@ static bool valid_pedit_action(struct net_device *dev,
 	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
 		switch (offset) {
 		case PEDIT_IP4_SRC:
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
+			break;
 		case PEDIT_IP4_DST:
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
@@ -493,10 +620,13 @@ static bool valid_pedit_action(struct net_device *dev,
 		case PEDIT_IP6_SRC_63_32:
 		case PEDIT_IP6_SRC_95_64:
 		case PEDIT_IP6_SRC_127_96:
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
+			break;
 		case PEDIT_IP6_DST_31_0:
 		case PEDIT_IP6_DST_63_32:
 		case PEDIT_IP6_DST_95_64:
 		case PEDIT_IP6_DST_127_96:
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
@@ -512,6 +642,10 @@ static bool valid_pedit_action(struct net_device *dev,
 					   __func__);
 				return false;
 			}
+			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
+				*natmode_flags |= CXGB4_ACTION_NATMODE_SPORT;
+			else
+				*natmode_flags |= CXGB4_ACTION_NATMODE_DPORT;
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
@@ -527,6 +661,10 @@ static bool valid_pedit_action(struct net_device *dev,
 					   __func__);
 				return false;
 			}
+			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
+				*natmode_flags |= CXGB4_ACTION_NATMODE_SPORT;
+			else
+				*natmode_flags |= CXGB4_ACTION_NATMODE_DPORT;
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
@@ -546,10 +684,12 @@ int cxgb4_validate_flow_actions(struct net_device *dev,
 				struct netlink_ext_ack *extack,
 				u8 matchall_filter)
 {
+	struct adapter *adap = netdev2adap(dev);
 	struct flow_action_entry *act;
 	bool act_redir = false;
 	bool act_pedit = false;
 	bool act_vlan = false;
+	u8 natmode_flags = 0;
 	int i;
 
 	if (!flow_action_basic_hw_stats_check(actions, extack))
@@ -563,7 +703,6 @@ int cxgb4_validate_flow_actions(struct net_device *dev,
 			break;
 		case FLOW_ACTION_MIRRED:
 		case FLOW_ACTION_REDIRECT: {
-			struct adapter *adap = netdev2adap(dev);
 			struct net_device *n_dev, *target_dev;
 			bool found = false;
 			unsigned int i;
@@ -620,7 +759,8 @@ int cxgb4_validate_flow_actions(struct net_device *dev,
 			}
 			break;
 		case FLOW_ACTION_MANGLE: {
-			bool pedit_valid = valid_pedit_action(dev, act);
+			bool pedit_valid = valid_pedit_action(dev, act,
+							      &natmode_flags);
 
 			if (!pedit_valid)
 				return -EOPNOTSUPP;
@@ -642,6 +782,15 @@ int cxgb4_validate_flow_actions(struct net_device *dev,
 		return -EINVAL;
 	}
 
+	if (act_pedit) {
+		int ret;
+
+		ret = cxgb4_action_natmode_validate(adap, natmode_flags,
+						    extack);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
index 6296e1d5a12b..3a2fa00c8cde 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
@@ -108,6 +108,21 @@ struct ch_tc_pedit_fields {
 #define PEDIT_TCP_SPORT_DPORT		0x0
 #define PEDIT_UDP_SPORT_DPORT		0x0
 
+enum cxgb4_action_natmode_flags {
+	CXGB4_ACTION_NATMODE_NONE = 0,
+	CXGB4_ACTION_NATMODE_DIP = (1 << 0),
+	CXGB4_ACTION_NATMODE_SIP = (1 << 1),
+	CXGB4_ACTION_NATMODE_DPORT = (1 << 2),
+	CXGB4_ACTION_NATMODE_SPORT = (1 << 3),
+};
+
+/* TC PEDIT action to NATMODE translation entry */
+struct cxgb4_natmode_config {
+	enum chip_type chip;
+	u8 flags;
+	u8 natmode;
+};
+
 void cxgb4_process_flow_actions(struct net_device *in,
 				struct flow_action *actions,
 				struct ch_filter_specification *fs);
-- 
2.18.1

