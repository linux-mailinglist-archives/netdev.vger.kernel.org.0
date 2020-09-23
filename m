Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19662753E1
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgIWI4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:56:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:30055 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbgIWI4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 04:56:18 -0400
IronPort-SDR: OhDDZKWBhmGrz4R4FECwCEvhn5fQa8NxHeyDJ+rvlZ5M4HUFQF/T1HKtndPljmD4dPbXwSpwGK
 nLMSQ2DtGWRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="148492030"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="148492030"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 01:56:17 -0700
IronPort-SDR: ANRFrIrOS1XqWbh5ONAWDEfN8VLGno0Z8I0+1k51QtiGq4RV1eWTMpCc570TtrxINW/3wFG4AF
 pw0IL5CEMvFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="338590656"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by orsmga008.jf.intel.com with ESMTP; 23 Sep 2020 01:56:15 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>
Subject: [PATCH v1 net] net: stmmac: removed enabling eee in EEE set callback
Date:   Wed, 23 Sep 2020 16:56:14 +0800
Message-Id: <20200923085614.8147-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EEE should be only be enabled during stmmac_mac_link_up() when the
link are up and being set up properly. set_eee should only do settings
configuration and disabling the eee.

Without this fix, turning on EEE using ethtool will return
"Operation not supported". This is due to the driver is in a dead loop
waiting for eee to be advertised in the for eee to be activated but the
driver will only configure the EEE advertisement after the eee is
activated.

Ethtool should only return "Operation not supported" if there is no EEE
capbility in the MAC controller.

Fixes: 8a7493e58ad6 ("net: stmmac: Fix a race in EEE enable callback")

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c  | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index ac5e8cc5fb9f..430a4b32ec1e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -675,23 +675,16 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
 
-	if (!edata->eee_enabled) {
+	if (!priv->dma_cap.eee)
+		return -EOPNOTSUPP;
+
+	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
-	} else {
-		/* We are asking for enabling the EEE but it is safe
-		 * to verify all by invoking the eee_init function.
-		 * In case of failure it will return an error.
-		 */
-		edata->eee_enabled = stmmac_eee_init(priv);
-		if (!edata->eee_enabled)
-			return -EOPNOTSUPP;
-	}
 
 	ret = phylink_ethtool_set_eee(priv->phylink, edata);
 	if (ret)
 		return ret;
 
-	priv->eee_enabled = edata->eee_enabled;
 	priv->tx_lpi_timer = edata->tx_lpi_timer;
 	return 0;
 }
-- 
2.17.1

