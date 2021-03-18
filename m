Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60B8340B8E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 18:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhCRRSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 13:18:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:22332 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230353AbhCRRSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 13:18:10 -0400
IronPort-SDR: jX8YIgpg4/CMMwNMAiHFP65eFPwHj+sCt8OJfogCWvza2qVTbddFqARgk7h6k6Wwiijo8fF16p
 VC9xMPuRHT+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="253740889"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="253740889"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 10:18:09 -0700
IronPort-SDR: CJre4EnGzJ8VFqHnYRuGkXzZH0qKYDFIwr/japVA0/UFaptXhsAttTOKHEwZR9q4Qyor9/7kTZ
 6hOWLUoC4R6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="374641163"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2021 10:18:07 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 2/2] net: stmmac: add RX frame steering based on VLAN priority in tc flower
Date:   Fri, 19 Mar 2021 01:22:04 +0800
Message-Id: <20210318172204.23766-3-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318172204.23766-1-boon.leong.ong@intel.com>
References: <20210318172204.23766-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We extend tc flower to support configuration of VLAN priority-based RX
frame steering hardware offloading.

To map VLAN <PCP> to Traffic Class <TC>:
  $ tc filter add dev <IFNAME> parent ffff: protocol 802.1Q flower \
       vlan_prio <PCP> hw_tc <TC>

  Note: <TC> < N whereby "tc qdisc ... num_tc N ..."

To delete all tc flower configurations:
  $ tc qdisc delete dev <IFNAME> ingress

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 65 ++++++++++++++++++-
 1 file changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index f4d8d7980ec5..b80cb2985b39 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -598,14 +598,73 @@ static int tc_del_flow(struct stmmac_priv *priv,
 	return ret;
 }
 
+#define VLAN_PRIO_FULL_MASK (0x07)
+
+static int tc_add_vlan_flow(struct stmmac_priv *priv,
+			    struct flow_cls_offload *cls)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	int tc = tc_classid_to_hwtc(priv->dev, cls->classid);
+	struct flow_match_vlan match;
+
+	/* Nothing to do here */
+	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_VLAN))
+		return -EINVAL;
+
+	if (tc < 0) {
+		netdev_err(priv->dev, "Invalid traffic class\n");
+		return -EINVAL;
+	}
+
+	flow_rule_match_vlan(rule, &match);
+
+	if (match.mask->vlan_priority) {
+		u32 prio;
+
+		if (match.mask->vlan_priority != VLAN_PRIO_FULL_MASK) {
+			netdev_err(priv->dev, "Only full mask is supported for VLAN priority");
+			return -EINVAL;
+		}
+
+		prio = BIT(match.key->vlan_priority);
+		stmmac_rx_queue_prio(priv, priv->hw, prio, tc);
+	}
+
+	return 0;
+}
+
+static int tc_del_vlan_flow(struct stmmac_priv *priv,
+			    struct flow_cls_offload *cls)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	int tc = tc_classid_to_hwtc(priv->dev, cls->classid);
+
+	/* Nothing to do here */
+	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_VLAN))
+		return -EINVAL;
+
+	if (tc < 0) {
+		netdev_err(priv->dev, "Invalid traffic class\n");
+		return -EINVAL;
+	}
+
+	stmmac_rx_queue_prio(priv, priv->hw, 0, tc);
+
+	return 0;
+}
+
 static int tc_add_flow_cls(struct stmmac_priv *priv,
 			   struct flow_cls_offload *cls)
 {
 	int ret;
 
 	ret = tc_add_flow(priv, cls);
+	if (!ret)
+		return ret;
 
-	return ret;
+	return tc_add_vlan_flow(priv, cls);
 }
 
 static int tc_del_flow_cls(struct stmmac_priv *priv,
@@ -614,8 +673,10 @@ static int tc_del_flow_cls(struct stmmac_priv *priv,
 	int ret;
 
 	ret = tc_del_flow(priv, cls);
+	if (!ret)
+		return ret;
 
-	return ret;
+	return tc_del_vlan_flow(priv, cls);
 }
 
 static int tc_setup_cls(struct stmmac_priv *priv,
-- 
2.25.1

