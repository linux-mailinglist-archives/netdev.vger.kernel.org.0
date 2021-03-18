Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092CF340B91
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 18:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhCRRSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 13:18:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:22332 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230164AbhCRRSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 13:18:07 -0400
IronPort-SDR: hTG8kEC51yTdsYgWZfPnSFUnYv5N4VR0+RQpN/EcGprPOWOb/h+j2J//p54k6g4V7ATo8y8S29
 XbVYEccKGNow==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="253740872"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="253740872"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 10:18:06 -0700
IronPort-SDR: NTCwKiG8UD3PC+vw2mq0mbIrtnB+2yiitxdGi6AZM+FImSSAW2sFv7+ZMMLQDaNG9xNOgrJy7i
 TIiVHqkUXk5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="374641130"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2021 10:18:04 -0700
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
Subject: [PATCH net-next 1/2] net: stmmac: restructure tc implementation for RX VLAN Priority steering
Date:   Fri, 19 Mar 2021 01:22:03 +0800
Message-Id: <20210318172204.23766-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318172204.23766-1-boon.leong.ong@intel.com>
References: <20210318172204.23766-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current tc_add_flow() and tc_del_flow() use hardware L3 & L4 filters
as offloading. The number of L3/L4 filters is read from L3L4FNUM field
from MAC_HW_Feature1 register and is used to alloc priv->tc_entries[].

For RX frame steering based on VLAN priority offloading, we use
MAC_RXQ_CTRL2 & MAC_RXQ_CTRL3 registers and all VLAN priority level
can be configured independent from L3 & L4 filters.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 44bb133c3000..f4d8d7980ec5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -598,6 +598,26 @@ static int tc_del_flow(struct stmmac_priv *priv,
 	return ret;
 }
 
+static int tc_add_flow_cls(struct stmmac_priv *priv,
+			   struct flow_cls_offload *cls)
+{
+	int ret;
+
+	ret = tc_add_flow(priv, cls);
+
+	return ret;
+}
+
+static int tc_del_flow_cls(struct stmmac_priv *priv,
+			   struct flow_cls_offload *cls)
+{
+	int ret;
+
+	ret = tc_del_flow(priv, cls);
+
+	return ret;
+}
+
 static int tc_setup_cls(struct stmmac_priv *priv,
 			struct flow_cls_offload *cls)
 {
@@ -609,10 +629,10 @@ static int tc_setup_cls(struct stmmac_priv *priv,
 
 	switch (cls->command) {
 	case FLOW_CLS_REPLACE:
-		ret = tc_add_flow(priv, cls);
+		ret = tc_add_flow_cls(priv, cls);
 		break;
 	case FLOW_CLS_DESTROY:
-		ret = tc_del_flow(priv, cls);
+		ret = tc_del_flow_cls(priv, cls);
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.25.1

