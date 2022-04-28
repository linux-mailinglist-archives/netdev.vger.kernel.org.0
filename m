Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5084513D81
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352190AbiD1V1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352099AbiD1V0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:26:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26943B89A1
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:23:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8D4B61F49
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 21:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF52BC385B0;
        Thu, 28 Apr 2022 21:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651181019;
        bh=o6rasBaGW/HsnBAQYPwFrGwmBDc7kj47pVcOYUVphmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6KFaJQw1oRYVmLc0Mdzci2eakFxis+0pImvAEZY0SrrAvKRIbhU0PFTnTKP12LCR
         51drqNGSDNSjcsyhOUpSoCULkerYIxmq26zr5kBO+ZZC+778MJcRJuwN1OiWQKZcDk
         K0wJ84a5UMlh5QDFxMfvjGJ2GJPJhqtEE4HohIgbg7/16VURIFPCf/MD043dA29OWr
         4wE/rRMr9J4NI768aaLrqbc1lkQTvHV5SMMCizUP6TMgFd1d6AD0ij2k3MmeVy2lo7
         5ADzaX8XXK1obbT1qNO2acFwi6uCKTNBvxX6xNB3GcHjqkNWgKMvHr5AIWhvHa97x6
         0WF6SLXX7CGIg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net-next v2 04/15] eth: pch_gbe: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Thu, 28 Apr 2022 14:23:12 -0700
Message-Id: <20220428212323.104417-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220428212323.104417-1-kuba@kernel.org>
References: <20220428212323.104417-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defining local versions of NAPI_POLL_WEIGHT with the same
values in the drivers just makes refactoring harder.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 1dc40c537281..46da937ad27f 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -32,8 +32,6 @@
 #define PCI_DEVICE_ID_ROHM_ML7223_GBE		0x8013
 #define PCI_DEVICE_ID_ROHM_ML7831_GBE		0x8802
 
-#define PCH_GBE_TX_WEIGHT         64
-#define PCH_GBE_RX_WEIGHT         64
 #define PCH_GBE_RX_BUFFER_WRITE   16
 
 /* Initialize the wake-on-LAN settings */
@@ -1469,7 +1467,7 @@ pch_gbe_clean_tx(struct pch_gbe_adapter *adapter,
 		   tx_desc->gbec_status, tx_desc->dma_status);
 
 	unused = PCH_GBE_DESC_UNUSED(tx_ring);
-	thresh = tx_ring->count - PCH_GBE_TX_WEIGHT;
+	thresh = tx_ring->count - NAPI_POLL_WEIGHT;
 	if ((tx_desc->gbec_status == DSC_INIT16) && (unused < thresh))
 	{  /* current marked clean, tx queue filling up, do extra clean */
 		int j, k;
@@ -1482,13 +1480,13 @@ pch_gbe_clean_tx(struct pch_gbe_adapter *adapter,
 
 		/* current marked clean, scan for more that need cleaning. */
 		k = i;
-		for (j = 0; j < PCH_GBE_TX_WEIGHT; j++)
+		for (j = 0; j < NAPI_POLL_WEIGHT; j++)
 		{
 			tx_desc = PCH_GBE_TX_DESC(*tx_ring, k);
 			if (tx_desc->gbec_status != DSC_INIT16) break; /*found*/
 			if (++k >= tx_ring->count) k = 0;  /*increment, wrap*/
 		}
-		if (j < PCH_GBE_TX_WEIGHT) {
+		if (j < NAPI_POLL_WEIGHT) {
 			netdev_dbg(adapter->netdev,
 				   "clean_tx: unused=%d loops=%d found tx_desc[%x,%x:%x].gbec_status=%04x\n",
 				   unused, j, i, k, tx_ring->next_to_use,
@@ -1547,7 +1545,7 @@ pch_gbe_clean_tx(struct pch_gbe_adapter *adapter,
 		tx_desc = PCH_GBE_TX_DESC(*tx_ring, i);
 
 		/* weight of a sort for tx, to avoid endless transmit cleanup */
-		if (cleaned_count++ == PCH_GBE_TX_WEIGHT) {
+		if (cleaned_count++ == NAPI_POLL_WEIGHT) {
 			cleaned = false;
 			break;
 		}
@@ -2519,7 +2517,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	netdev->netdev_ops = &pch_gbe_netdev_ops;
 	netdev->watchdog_timeo = PCH_GBE_WATCHDOG_PERIOD;
 	netif_napi_add(netdev, &adapter->napi,
-		       pch_gbe_napi_poll, PCH_GBE_RX_WEIGHT);
+		       pch_gbe_napi_poll, NAPI_POLL_WEIGHT);
 	netdev->hw_features = NETIF_F_RXCSUM |
 		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	netdev->features = netdev->hw_features;
-- 
2.34.1

