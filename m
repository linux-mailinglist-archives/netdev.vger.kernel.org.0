Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E97265449
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgIJVmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:42:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:31863 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgIJNCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 09:02:23 -0400
IronPort-SDR: zwKpcClAf3U2obN8Ddkyb51KU1fQn5EYV3mmJFJUTdbpDY/v7y/MrsT2tZD6w18j6Yfc6rHOxR
 Kcd60y59uWRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="243341152"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="243341152"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 06:02:03 -0700
IronPort-SDR: S1rFM1mUOCY51KMgy45KFAjTbE4MlcEArsGaQgoirdTTKovsol6uIHM3WlHOHti9ElPTdIxOoR
 ocpbwya6fPmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="505828973"
Received: from glass.png.intel.com ([172.30.181.92])
  by fmsmga005.fm.intel.com with ESMTP; 10 Sep 2020 06:02:00 -0700
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net-next 2/3] net: stmmac: Fix incorrect location to set real_num_rx|tx_queues
Date:   Thu, 10 Sep 2020 21:03:44 +0800
Message-Id: <20200910130344.15013-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aashish Verma <aashishx.verma@intel.com>

netif_set_real_num_tx_queues() & netif_set_real_num_rx_queues() should be
used to inform network stack about the real Tx & Rx queue (active) number
in both stmmac_open() and stmmac_resume(), therefore, we move the code
from stmmac_dvr_probe() to stmmac_hw_setup().

Fixes: c02b7a914551 net: stmmac: use netif_set_real_num_{rx,tx}_queues

Signed-off-by: Aashish Verma <aashishx.verma@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9302d8012a10..fea3b77892ab 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2733,6 +2733,10 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 		stmmac_enable_tbs(priv, priv->ioaddr, enable, chan);
 	}
 
+	/* Configure real RX and TX queues */
+	netif_set_real_num_rx_queues(dev, priv->plat->rx_queues_to_use);
+	netif_set_real_num_tx_queues(dev, priv->plat->tx_queues_to_use);
+
 	/* Start the ball rolling... */
 	stmmac_start_all_dma(priv);
 
@@ -4883,10 +4887,6 @@ int stmmac_dvr_probe(struct device *device,
 
 	stmmac_check_ether_addr(priv);
 
-	/* Configure real RX and TX queues */
-	netif_set_real_num_rx_queues(ndev, priv->plat->rx_queues_to_use);
-	netif_set_real_num_tx_queues(ndev, priv->plat->tx_queues_to_use);
-
 	ndev->netdev_ops = &stmmac_netdev_ops;
 
 	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-- 
2.17.0

