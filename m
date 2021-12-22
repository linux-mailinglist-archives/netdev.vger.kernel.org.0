Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55E347D3EB
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 15:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343570AbhLVOqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 09:46:50 -0500
Received: from mga12.intel.com ([192.55.52.136]:11998 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343551AbhLVOqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 09:46:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640184409; x=1671720409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SxugfGzm1xGeWRqS7cscJGvOizpK9lIAjCHS0r+XbqU=;
  b=AKZQoFFvu5kp0fK/m7esaYtCJD9giyi0TryGxf+OvHsbG/YCoqWBErlO
   +pUdlOja2cCENcz73EnaZICG9NXCYJcGobT7dUE2kgXF6Hn0eOA3lOy4D
   wecOLALNVE62e10RNwIQ3yAsOiGb5AUp7aLLzMdM1Pr7tLodXjUHBF2OA
   /96RmYHn58Tb6TpWNgISzVgLQvba287trVc7hlx7GS4CBPsE37wdTkKWR
   quM8jDGU3GFm8A5InylUYxkzrLzLHkO5vAQ+IATC3OwAJBmt50zve3LDk
   aR0oBptcYfMatNxmcdVGxINO0pz+dz+0j0MrD72RPc4WxN8FN+lehbe4i
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="220641737"
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="220641737"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 06:46:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="522121010"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by fmsmga007.fm.intel.com with ESMTP; 22 Dec 2021 06:46:46 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v2 1/1] net: stmmac: add tc flower filter for EtherType matching
Date:   Wed, 22 Dec 2021 22:43:10 +0800
Message-Id: <20211222144310.2761661-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211222144310.2761661-1-boon.leong.ong@intel.com>
References: <20211222144310.2761661-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds basic support for EtherType RX frame steering for
LLDP and PTP using the hardware offload capabilities.

Example steps for setting up RX frame steering for LLDP and PTP:
$ IFDEVNAME=eth0
$ tc qdisc add dev $IFDEVNAME ingress
$ tc qdisc add dev $IFDEVNAME root mqprio num_tc 8 \
     map 0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0 \
     queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0

For LLDP
$ tc filter add dev $IFDEVNAME parent ffff: protocol 0x88cc \
     flower hw_tc 5
OR
$ tc filter add dev $IFDEVNAME parent ffff: protocol LLDP \
     flower hw_tc 5

For PTP
$ tc filter add dev $IFDEVNAME parent ffff: protocol 0x88f7 \
     flower hw_tc 6

Show tc ingress filter
$ tc filter show dev $IFDEVNAME ingress

v1->v2:
 Thanks to Kurt's and Sebastian's suggestion.
 - change from __be16 to u16 etype
 - change ETHER_TYPE_FULL_MASK to use cpu_to_be16() macro

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   3 +
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 121 ++++++++++++++++++
 2 files changed, 124 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 18a262ef17f..aca3c3f0f0a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -174,11 +174,14 @@ struct stmmac_flow_entry {
 /* Rx Frame Steering */
 enum stmmac_rfs_type {
 	STMMAC_RFS_T_VLAN,
+	STMMAC_RFS_T_LLDP,
+	STMMAC_RFS_T_1588,
 	STMMAC_RFS_T_MAX,
 };
 
 struct stmmac_rfs_entry {
 	unsigned long cookie;
+	u16 etype;
 	int in_use;
 	int type;
 	int tc;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index d0a2b289f46..d61766eeac6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -237,6 +237,8 @@ static int tc_rfs_init(struct stmmac_priv *priv)
 	int i;
 
 	priv->rfs_entries_max[STMMAC_RFS_T_VLAN] = 8;
+	priv->rfs_entries_max[STMMAC_RFS_T_LLDP] = 1;
+	priv->rfs_entries_max[STMMAC_RFS_T_1588] = 1;
 
 	for (i = 0; i < STMMAC_RFS_T_MAX; i++)
 		priv->rfs_entries_total += priv->rfs_entries_max[i];
@@ -451,6 +453,8 @@ static int tc_parse_flow_actions(struct stmmac_priv *priv,
 	return 0;
 }
 
+#define ETHER_TYPE_FULL_MASK	cpu_to_be16(~0)
+
 static int tc_add_basic_flow(struct stmmac_priv *priv,
 			     struct flow_cls_offload *cls,
 			     struct stmmac_flow_entry *entry)
@@ -464,6 +468,7 @@ static int tc_add_basic_flow(struct stmmac_priv *priv,
 		return -EINVAL;
 
 	flow_rule_match_basic(rule, &match);
+
 	entry->ip_proto = match.key->ip_proto;
 	return 0;
 }
@@ -724,6 +729,114 @@ static int tc_del_vlan_flow(struct stmmac_priv *priv,
 	return 0;
 }
 
+static int tc_add_ethtype_flow(struct stmmac_priv *priv,
+			       struct flow_cls_offload *cls)
+{
+	struct stmmac_rfs_entry *entry = tc_find_rfs(priv, cls, false);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	int tc = tc_classid_to_hwtc(priv->dev, cls->classid);
+	struct flow_match_basic match;
+
+	if (!entry) {
+		entry = tc_find_rfs(priv, cls, true);
+		if (!entry)
+			return -ENOENT;
+	}
+
+	/* Nothing to do here */
+	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_BASIC))
+		return -EINVAL;
+
+	if (tc < 0) {
+		netdev_err(priv->dev, "Invalid traffic class\n");
+		return -EINVAL;
+	}
+
+	flow_rule_match_basic(rule, &match);
+
+	if (match.mask->n_proto) {
+		u16 etype = ntohs(match.key->n_proto);
+
+		if (match.mask->n_proto != ETHER_TYPE_FULL_MASK) {
+			netdev_err(priv->dev, "Only full mask is supported for EthType filter");
+			return -EINVAL;
+		}
+		switch (etype) {
+		case ETH_P_LLDP:
+			if (priv->rfs_entries_cnt[STMMAC_RFS_T_LLDP] >=
+			    priv->rfs_entries_max[STMMAC_RFS_T_LLDP])
+				return -ENOENT;
+
+			entry->type = STMMAC_RFS_T_LLDP;
+			priv->rfs_entries_cnt[STMMAC_RFS_T_LLDP]++;
+
+			stmmac_rx_queue_routing(priv, priv->hw,
+						PACKET_DCBCPQ, tc);
+			break;
+		case ETH_P_1588:
+			if (priv->rfs_entries_cnt[STMMAC_RFS_T_1588] >=
+			    priv->rfs_entries_max[STMMAC_RFS_T_1588])
+				return -ENOENT;
+
+			entry->type = STMMAC_RFS_T_1588;
+			priv->rfs_entries_cnt[STMMAC_RFS_T_1588]++;
+
+			stmmac_rx_queue_routing(priv, priv->hw,
+						PACKET_PTPQ, tc);
+			break;
+		default:
+			netdev_err(priv->dev, "EthType(0x%x) is not supported", etype);
+			return -EINVAL;
+		}
+
+		entry->in_use = true;
+		entry->cookie = cls->cookie;
+		entry->tc = tc;
+		entry->etype = etype;
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int tc_del_ethtype_flow(struct stmmac_priv *priv,
+			       struct flow_cls_offload *cls)
+{
+	struct stmmac_rfs_entry *entry = tc_find_rfs(priv, cls, false);
+
+	if (!entry || !entry->in_use ||
+	    entry->type < STMMAC_RFS_T_LLDP ||
+	    entry->type > STMMAC_RFS_T_1588)
+		return -ENOENT;
+
+	switch (entry->etype) {
+	case ETH_P_LLDP:
+		stmmac_rx_queue_routing(priv, priv->hw,
+					PACKET_DCBCPQ, 0);
+		priv->rfs_entries_cnt[STMMAC_RFS_T_LLDP]--;
+		break;
+	case ETH_P_1588:
+		stmmac_rx_queue_routing(priv, priv->hw,
+					PACKET_PTPQ, 0);
+		priv->rfs_entries_cnt[STMMAC_RFS_T_1588]--;
+		break;
+	default:
+		netdev_err(priv->dev, "EthType(0x%x) is not supported",
+			   entry->etype);
+		return -EINVAL;
+	}
+
+	entry->in_use = false;
+	entry->cookie = 0;
+	entry->tc = 0;
+	entry->etype = 0;
+	entry->type = 0;
+
+	return 0;
+}
+
 static int tc_add_flow_cls(struct stmmac_priv *priv,
 			   struct flow_cls_offload *cls)
 {
@@ -733,6 +846,10 @@ static int tc_add_flow_cls(struct stmmac_priv *priv,
 	if (!ret)
 		return ret;
 
+	ret = tc_add_ethtype_flow(priv, cls);
+	if (!ret)
+		return ret;
+
 	return tc_add_vlan_flow(priv, cls);
 }
 
@@ -745,6 +862,10 @@ static int tc_del_flow_cls(struct stmmac_priv *priv,
 	if (!ret)
 		return ret;
 
+	ret = tc_del_ethtype_flow(priv, cls);
+	if (!ret)
+		return ret;
+
 	return tc_del_vlan_flow(priv, cls);
 }
 
-- 
2.25.1

