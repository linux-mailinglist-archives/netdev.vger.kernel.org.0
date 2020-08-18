Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44DB248ABE
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgHRP4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:56:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:35749 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbgHRPrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 11:47:18 -0400
IronPort-SDR: vL9FBaH0TqzJ0GQ11erL/qDWNu9Gl8TR5nz21tju0VQIm3AwwVgBUukPSIDWhddBmSi9LHVFUz
 yQLkUoymPlUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="152563263"
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="152563263"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 08:47:18 -0700
IronPort-SDR: V2LwCJFKDxgzQb5hV91A5IeYw3Ero92nPQ+4CXQK6uEQjJ72/c3Ds8RnGIRtPtb0AlwJEGbUzw
 4zaYKZhNRABg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="400530265"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by fmsmga001.fm.intel.com with ESMTP; 18 Aug 2020 08:47:15 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>
Subject: [PATCH v6 04/10] net: eth: altera: add optional function to start tx dma
Date:   Tue, 18 Aug 2020 23:46:07 +0800
Message-Id: <20200818154613.148921-5-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200818154613.148921-1-joyce.ooi@intel.com>
References: <20200818154613.148921-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@intel.com>

Allow for optional start up of tx dma if the start_txdma
function is defined in altera_dmaops.

Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
---
v2: no change
v3: no change
v4: no change
v5: no change
v6: no change
---
 drivers/net/ethernet/altera/altera_tse.h      | 1 +
 drivers/net/ethernet/altera/altera_tse_main.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
index 7d0c98fc103e..26c5541fda27 100644
--- a/drivers/net/ethernet/altera/altera_tse.h
+++ b/drivers/net/ethernet/altera/altera_tse.h
@@ -401,6 +401,7 @@ struct altera_dmaops {
 	int (*init_dma)(struct altera_tse_private *priv);
 	void (*uninit_dma)(struct altera_tse_private *priv);
 	void (*start_rxdma)(struct altera_tse_private *priv);
+	void (*start_txdma)(struct altera_tse_private *priv);
 };
 
 /* This structure is private to each device.
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index a3749ffdcac9..0a724e4d2c8c 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1244,6 +1244,9 @@ static int tse_open(struct net_device *dev)
 
 	priv->dmaops->start_rxdma(priv);
 
+	if (priv->dmaops->start_txdma)
+		priv->dmaops->start_txdma(priv);
+
 	/* Start MAC Rx/Tx */
 	spin_lock(&priv->mac_cfg_lock);
 	tse_set_mac(priv, true);
@@ -1646,6 +1649,7 @@ static const struct altera_dmaops altera_dtype_sgdma = {
 	.init_dma = sgdma_initialize,
 	.uninit_dma = sgdma_uninitialize,
 	.start_rxdma = sgdma_start_rxdma,
+	.start_txdma = NULL,
 };
 
 static const struct altera_dmaops altera_dtype_msgdma = {
@@ -1665,6 +1669,7 @@ static const struct altera_dmaops altera_dtype_msgdma = {
 	.init_dma = msgdma_initialize,
 	.uninit_dma = msgdma_uninitialize,
 	.start_rxdma = msgdma_start_rxdma,
+	.start_txdma = NULL,
 };
 
 static const struct of_device_id altera_tse_ids[] = {
-- 
2.13.0

