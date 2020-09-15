Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A0F269B0E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgIOB1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:27:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:19913 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgIOB1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 21:27:04 -0400
IronPort-SDR: EWjanF5wLKklF24WYHB/xiPndjDfV3Z9r8gIqZd7O1UteisGP96w+IzE5nSUa+9+y7fCmWUD+0
 LkN9gmwH7axQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="139195474"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="139195474"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:27:03 -0700
IronPort-SDR: tZVelu4X/niBIzR5mobsMcwKMUVbm7vWUpqZa86Y1XfGcpPU/xI+T1FnV+fdQchIMN39qtLbNF
 3By/B/C53Z1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="345632631"
Received: from glass.png.intel.com ([172.30.181.92])
  by orsmga007.jf.intel.com with ESMTP; 14 Sep 2020 18:26:59 -0700
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Rusell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Vijaya Balan Sadhishkhanna 
        <sadhishkhanna.vijaya.balan@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>
Subject: [PATCH net-next 2/3] net: stmmac: Fix incorrect location to set real_num_rx|tx_queues
Date:   Tue, 15 Sep 2020 09:28:39 +0800
Message-Id: <20200915012840.31841-3-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20200915012840.31841-1-vee.khee.wong@intel.com>
References: <20200915012840.31841-1-vee.khee.wong@intel.com>
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

