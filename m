Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BAD31E5FE
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhBRFul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:50:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:58031 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231388AbhBRFqq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 00:46:46 -0500
IronPort-SDR: pHucEEVWfKKC7RFNElsYNaDzzWcuLYY3hNAcPh6OCA0TUbVG5IeL63Fmk7hIORtF/x2U+/UfhU
 dsbThVrJAbDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9898"; a="247477606"
X-IronPort-AV: E=Sophos;i="5.81,186,1610438400"; 
   d="scan'208";a="247477606"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2021 21:45:14 -0800
IronPort-SDR: 6KtFZd6YYDrNte8uKj3D5WEvS5GCUEtB1bob9HGjlT49/TS5TPigfZfCY5dNMk0QJYPWAnw3Ni
 xvVbwiXkEY4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,186,1610438400"; 
   d="scan'208";a="378290130"
Received: from ssid-ilbpg3.png.intel.com ([10.88.227.36])
  by orsmga002.jf.intel.com with ESMTP; 17 Feb 2021 21:45:10 -0800
From:   Song Yoong Siang <yoong.siang.song@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net 1/1] net: stmmac: fix CBS idleslope and sendslope calculation
Date:   Thu, 18 Feb 2021 21:40:53 +0800
Message-Id: <1613655653-11755-1-git-send-email-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Song, Yoong Siang" <yoong.siang.song@intel.com>

When link speed is not 100 Mbps, port transmit rate and speed divider
are set to 8 and 1000000 respectively. These values are incorrect for
CBS idleslope and sendslope HW values calculation if the link speed is
not 1 Gbps.

This patch adds switch statement to set the values of port transmit rate
and speed divider for 10 Gbps, 5 Gbps, 2.5 Gbps, 1 Gbps, and 100 Mbps.
Note that CBS is not supported at 10 Mbps.

Fixes: bc41a6689b30 ("net: stmmac: tc: Remove the speed dependency")
Fixes: 1f705bc61aee ("net: stmmac: Add support for CBS QDISC")
Signed-off-by: Song, Yoong Siang <yoong.siang.song@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 30 +++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 5698554..44bb133 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -316,6 +316,32 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 	if (!priv->dma_cap.av)
 		return -EOPNOTSUPP;
 
+	/* Port Transmit Rate and Speed Divider */
+	switch (priv->speed) {
+	case SPEED_10000:
+		ptr = 32;
+		speed_div = 10000000;
+		break;
+	case SPEED_5000:
+		ptr = 32;
+		speed_div = 5000000;
+		break;
+	case SPEED_2500:
+		ptr = 8;
+		speed_div = 2500000;
+		break;
+	case SPEED_1000:
+		ptr = 8;
+		speed_div = 1000000;
+		break;
+	case SPEED_100:
+		ptr = 4;
+		speed_div = 100000;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
 	mode_to_use = priv->plat->tx_queues_cfg[queue].mode_to_use;
 	if (mode_to_use == MTL_QUEUE_DCB && qopt->enable) {
 		ret = stmmac_dma_qmode(priv, priv->ioaddr, queue, MTL_QUEUE_AVB);
@@ -332,10 +358,6 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 		priv->plat->tx_queues_cfg[queue].mode_to_use = MTL_QUEUE_DCB;
 	}
 
-	/* Port Transmit Rate and Speed Divider */
-	ptr = (priv->speed == SPEED_100) ? 4 : 8;
-	speed_div = (priv->speed == SPEED_100) ? 100000 : 1000000;
-
 	/* Final adjustments for HW */
 	value = div_s64(qopt->idleslope * 1024ll * ptr, speed_div);
 	priv->plat->tx_queues_cfg[queue].idle_slope = value & GENMASK(31, 0);
-- 
2.7.4

