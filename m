Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FD9138EB8
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgAMKNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:13:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:10161 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728773AbgAMKNi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 05:13:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 02:13:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,428,1571727600"; 
   d="scan'208";a="397116812"
Received: from bong5-hp-z440.png.intel.com ([10.221.118.136])
  by orsmga005.jf.intel.com with ESMTP; 13 Jan 2020 02:13:35 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 4/7] net: stmmac: Fix priority steering for tx/rx queue >3
Date:   Tue, 14 Jan 2020 10:01:13 +0800
Message-Id: <1578967276-55956-5-git-send-email-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578967276-55956-1-git-send-email-boon.leong.ong@intel.com>
References: <1578967276-55956-1-git-send-email-boon.leong.ong@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

Fix MACRO function define for TX and RX user priority queue steering for
register masking and shifting.

Fixes: a8f5102af2a7 ("net: stmmac: TX and RX queue priority configuration")

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 2dc70d1..798a53a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -97,12 +97,14 @@
 #define GMAC_RX_FLOW_CTRL_RFE		BIT(0)
 
 /* RX Queues Priorities */
-#define GMAC_RXQCTRL_PSRQX_MASK(x)	GENMASK(7 + ((x) * 8), 0 + ((x) * 8))
-#define GMAC_RXQCTRL_PSRQX_SHIFT(x)	((x) * 8)
+#define GMAC_RXQCTRL_PSRQX_MASK(x)	GENMASK(7 + (((x) % 4) * 8), \
+						0 + (((x) % 4) * 8))
+#define GMAC_RXQCTRL_PSRQX_SHIFT(x)	(((x) % 4) * 8)
 
 /* TX Queues Priorities */
-#define GMAC_TXQCTRL_PSTQX_MASK(x)	GENMASK(7 + ((x) * 8), 0 + ((x) * 8))
-#define GMAC_TXQCTRL_PSTQX_SHIFT(x)	((x) * 8)
+#define GMAC_TXQCTRL_PSTQX_MASK(x)	GENMASK(7 + (((x) % 4) * 8), \
+						0 + (((x) % 4) * 8))
+#define GMAC_TXQCTRL_PSTQX_SHIFT(x)	(((x) % 4) * 8)
 
 /* MAC Flow Control TX */
 #define GMAC_TX_FLOW_CTRL_TFE		BIT(1)
-- 
2.7.4

