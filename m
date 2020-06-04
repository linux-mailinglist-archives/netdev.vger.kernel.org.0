Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563A91EDE75
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 09:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgFDHe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 03:34:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:31576 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbgFDHe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 03:34:27 -0400
IronPort-SDR: waWFv/0ckFmxFHYKYn6YbR4k/dKKAyRni69NLdmBgCYQmDCr1jN8oU8yuG2BGZJjHJ+q9UN0PQ
 8d4U8noIgD1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 00:34:26 -0700
IronPort-SDR: fsVuR090uk8ysQYBdRKxnsIdfGHB/7r6f6R1TV7D6noOLvvkN57zEonofvVy2gPQ4dn+4B8IyG
 ftSQIgC9dIMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,471,1583222400"; 
   d="scan'208";a="348021438"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga001.jf.intel.com with ESMTP; 04 Jun 2020 00:34:22 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>
Subject: [PATCH v3 02/10] net: eth: altera: set rx and tx ring size before init_dma call
Date:   Thu,  4 Jun 2020 15:32:48 +0800
Message-Id: <20200604073256.25702-3-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200604073256.25702-1-joyce.ooi@intel.com>
References: <20200604073256.25702-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@intel.com>

It is more appropriate to set the rx and tx ring size before calling
the init function for the dma.

Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
---
v2: no change
v3: no change
---
 drivers/net/ethernet/altera/altera_tse_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 2a9e6157a8a1..539e744e23f7 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1154,6 +1154,10 @@ static int tse_open(struct net_device *dev)
 	int i;
 	unsigned long int flags;
 
+	/* set tx and rx ring size */
+	priv->rx_ring_size = dma_rx_num;
+	priv->tx_ring_size = dma_tx_num;
+
 	/* Reset and configure TSE MAC and probe associated PHY */
 	ret = priv->dmaops->init_dma(priv);
 	if (ret != 0) {
@@ -1196,8 +1200,6 @@ static int tse_open(struct net_device *dev)
 	priv->dmaops->reset_dma(priv);
 
 	/* Create and initialize the TX/RX descriptors chains. */
-	priv->rx_ring_size = dma_rx_num;
-	priv->tx_ring_size = dma_tx_num;
 	ret = alloc_init_skbufs(priv);
 	if (ret) {
 		netdev_err(dev, "DMA descriptors initialization failed\n");
-- 
2.13.0

