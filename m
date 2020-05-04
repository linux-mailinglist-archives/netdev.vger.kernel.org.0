Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C2E1C346B
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgEDI2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:28:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:41838 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgEDI2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 04:28:22 -0400
IronPort-SDR: Ohq/psjAR35C+51axythSRzKxAV4+gjt8xC71gOjW2Iq2xmTe837WveRH3o9UHilxTddfyHXsp
 uU0TVsGzBu+A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 01:28:21 -0700
IronPort-SDR: WgM8V4w0X8z+/n+TqQX+1ywYpC0JK8hZM1n6SyW+64bro91NX6CPmR/ST+6EJNVnskeSip1otI
 DFZztNtGuX4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,351,1583222400"; 
   d="scan'208";a="295436068"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2020 01:28:18 -0700
From:   Joyce Ooi <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>
Subject: [PATCHv2 04/10] net: eth: altera: add optional function to start tx dma
Date:   Mon,  4 May 2020 16:25:52 +0800
Message-Id: <20200504082558.112627-5-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200504082558.112627-1-joyce.ooi@intel.com>
References: <20200504082558.112627-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@intel.com>

Allow for optional start up of tx dma if the start_txdma
function is defined in altera_dmaops.

Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
---
v2: no change
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
index 539e744e23f7..3c756afd0d39 100644
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

