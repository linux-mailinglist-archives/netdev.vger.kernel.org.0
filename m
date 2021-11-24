Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF41945B955
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241529AbhKXLps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:45:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:10469 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229923AbhKXLpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 06:45:47 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="235079884"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="235079884"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 03:42:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="554153649"
Received: from sashimi-thinkstation-p920.png.intel.com ([10.158.65.178])
  by fmsmga008.fm.intel.com with ESMTP; 24 Nov 2021 03:42:33 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com, Kurt Kanzenbach <kurt@linutronix.de>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 1/1] net: stmmac: perserve TX and RX coalesce value during XDP setup
Date:   Wed, 24 Nov 2021 19:40:19 +0800
Message-Id: <20211124114019.3949125-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When XDP program is loaded, it is desirable that the previous TX and RX
coalesce values are not re-inited to its default value. This prevents
unnecessary re-configurig the coalesce values that were working fine
before.

Fixes: ac746c8520d9 ("net: stmmac: enhance XDP ZC driver level switching performance")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 21111df7371..a122a161872 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6527,6 +6527,9 @@ int stmmac_xdp_open(struct net_device *dev)
 		tx_q->tx_tail_addr = tx_q->dma_tx_phy;
 		stmmac_set_tx_tail_ptr(priv, priv->ioaddr,
 				       tx_q->tx_tail_addr, chan);
+
+		hrtimer_init(&tx_q->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		tx_q->txtimer.function = stmmac_tx_timer;
 	}
 
 	/* Enable the MAC Rx/Tx */
@@ -6535,8 +6538,6 @@ int stmmac_xdp_open(struct net_device *dev)
 	/* Start Rx & Tx DMA Channels */
 	stmmac_start_all_dma(priv);
 
-	stmmac_init_coalesce(priv);
-
 	ret = stmmac_request_irq(dev);
 	if (ret)
 		goto irq_error;
-- 
2.25.1

