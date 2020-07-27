Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD20422E8CA
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgG0JW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:22:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:22631 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727847AbgG0JW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 05:22:56 -0400
IronPort-SDR: p5u6qSfsOHVuSe0uEAjFD5kb9IiG1SKg7bnWqigipAl8x1FPtfZOFpYTCAg5CTgkih8gL1keda
 1AKa/NZFlklA==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="235843537"
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="235843537"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 02:22:54 -0700
IronPort-SDR: vZprshVY3CuE5BhRYOp8kgqTnq0zXhi/sFKu7aVPj49RhvMhBaqctSI+zRfw3aWGE+yt18Tz+A
 tUgz/PGgdruA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="303393782"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 02:22:51 -0700
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
Subject: [PATCH v5 02/10] net: eth: altera: set rx and tx ring size before init_dma call
Date:   Mon, 27 Jul 2020 17:21:49 +0800
Message-Id: <20200727092157.115937-3-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200727092157.115937-1-joyce.ooi@intel.com>
References: <20200727092157.115937-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@intel.com>

It is more appropriate to set the rx and tx ring size before calling
the init function for the dma.

Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
---
v2: no change
v3: no change
v4: no change
v5: no change
---
 drivers/net/ethernet/altera/altera_tse_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index ec2b36e05c3f..a3749ffdcac9 100644
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

