Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 643974A268
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbfFRNga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:36:30 -0400
Received: from mga07.intel.com ([134.134.136.100]:21689 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729253AbfFRNgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:36:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 06:36:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,389,1557212400"; 
   d="scan'208";a="164705654"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga006.jf.intel.com with ESMTP; 18 Jun 2019 06:36:21 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [RFC net-next 5/5] net: stmmac: Set TSN HW tunable after tsn setup
Date:   Wed, 19 Jun 2019 05:36:18 +0800
Message-Id: <1560893778-6838-6-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
References: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TSN HW tunable data for PTP Time Offset Value(PTOV),
Current Time Offset Value(CTOV) and Time Interval Shift
Amount(TILS) are added as platform data. These platform
data are set after tsn setup.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 16 ++++++++++++++++
 include/linux/stmmac.h                            |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a443c42fa58b..d3ce86abdc69 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2533,6 +2533,22 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	/* Setup for TSN capability */
 	dwmac_tsn_setup(priv->ioaddr);
 
+	/* Set TSN HW tunable */
+	if (priv->plat->ptov)
+		stmmac_set_tsn_hwtunable(priv, priv->ioaddr,
+					 TSN_HWTUNA_TX_EST_PTOV,
+					 &priv->plat->ptov);
+
+	if (priv->plat->ctov)
+		stmmac_set_tsn_hwtunable(priv, priv->ioaddr,
+					 TSN_HWTUNA_TX_EST_CTOV,
+					 &priv->plat->ctov);
+
+	if (priv->plat->tils)
+		stmmac_set_tsn_hwtunable(priv, priv->ioaddr,
+					 TSN_HWTUNA_TX_EST_TILS,
+					 &priv->plat->tils);
+
 	return 0;
 }
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index d4a90f48e49b..792aa8b3e138 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -176,5 +176,8 @@ struct plat_stmmacenet_data {
 	int mac_port_sel_speed;
 	bool en_tx_lpi_clockgating;
 	int has_xgmac;
+	unsigned int ptov;
+	unsigned int ctov;
+	unsigned int tils;
 };
 #endif
-- 
1.9.1

