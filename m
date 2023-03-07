Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F45F6AEFA9
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbjCGSZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbjCGSYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCE39F230;
        Tue,  7 Mar 2023 10:20:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2546B61501;
        Tue,  7 Mar 2023 18:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9F9C4339B;
        Tue,  7 Mar 2023 18:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213202;
        bh=gyAIiE+ZKIR9obu+1KTy/40lPs3yvZTMSEbedscpsvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKSnXDxrYqcm+9W1g2vCqvRqRSNH1I2Rw2s/rXg/QlZTV197yJLGV9jB3m96UNT9V
         ii7nhEChM/lBK4ZpvoZygFd8qW89tkLA/FSJVw0xekI7Ayh6ynfUSYX2app24FjcBb
         ksVnOUWMc4Sc7GUwMJktiqams1nI956RCbcfyk9L3TbVg3HTKqSweLa3StBA2MuRwl
         tSnZMvKjkHT41b6Lq75JE/5lnVkvvRJFeUZL/Ec2mOKVLb0w3cJZicvrzbFgiVrF/m
         M8iHkYt99ckHEnZHcoCHtI858pdhcYuV6UpzOLWhzJTxOHn6TA0Ci9MBN9BL/u4SyX
         N9oK60FRDOybw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH 03/28] bnx2: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:14 -0600
Message-Id: <20230307181940.868828-4-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
References: <20230307181940.868828-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

pci_enable_pcie_error_reporting() enables the device to send ERR_*
Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
native"), the PCI core does this for all devices during enumeration, so the
driver doesn't need to do it itself.

Remove the redundant pci_enable_pcie_error_reporting() call from the
driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
from the driver .remove() path.

Note that this only controls ERR_* Messages from the device.  An ERR_*
Message may cause the Root Port to generate an interrupt, depending on the
AER Root Error Command register managed by the AER service driver.

cd709aa90648 ("bnx2: Add PCI Advanced Error Reporting support.") added
pci_enable_pcie_error_reporting() for all devices, and c239f279e571 ("bnx2:
Enable AER on PCIE devices only") restricted it to BNX2_CHIP_5709 devices
to avoid an error message when it failed on non-PCIe devices.  The PCI core
only enables PCIe error reporting on PCIe devices, which I assume means
BNX2_CHIP_5709.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rasesh Mody <rmody@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Cc: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnx2.c | 21 ---------------------
 drivers/net/ethernet/broadcom/bnx2.h |  1 -
 2 files changed, 22 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 9f473854b0f4..a66137b8d1a6 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -48,7 +48,6 @@
 #include <linux/cache.h>
 #include <linux/firmware.h>
 #include <linux/log2.h>
-#include <linux/aer.h>
 #include <linux/crash_dump.h>
 
 #if IS_ENABLED(CONFIG_CNIC)
@@ -8093,7 +8092,6 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 	int rc, i, j;
 	u32 reg;
 	u64 dma_mask, persist_dma_mask;
-	int err;
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	bp = netdev_priv(dev);
@@ -8176,12 +8174,6 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 		bp->flags |= BNX2_FLAG_PCIE;
 		if (BNX2_CHIP_REV(bp) == BNX2_CHIP_REV_Ax)
 			bp->flags |= BNX2_FLAG_JUMBO_BROKEN;
-
-		/* AER (Advanced Error Reporting) hooks */
-		err = pci_enable_pcie_error_reporting(pdev);
-		if (!err)
-			bp->flags |= BNX2_FLAG_AER_ENABLED;
-
 	} else {
 		bp->pcix_cap = pci_find_capability(pdev, PCI_CAP_ID_PCIX);
 		if (bp->pcix_cap == 0) {
@@ -8460,11 +8452,6 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 	return 0;
 
 err_out_unmap:
-	if (bp->flags & BNX2_FLAG_AER_ENABLED) {
-		pci_disable_pcie_error_reporting(pdev);
-		bp->flags &= ~BNX2_FLAG_AER_ENABLED;
-	}
-
 	pci_iounmap(pdev, bp->regview);
 	bp->regview = NULL;
 
@@ -8638,11 +8625,6 @@ bnx2_remove_one(struct pci_dev *pdev)
 	bnx2_free_stats_blk(dev);
 	kfree(bp->temp_stats_blk);
 
-	if (bp->flags & BNX2_FLAG_AER_ENABLED) {
-		pci_disable_pcie_error_reporting(pdev);
-		bp->flags &= ~BNX2_FLAG_AER_ENABLED;
-	}
-
 	bnx2_release_firmware(bp);
 
 	free_netdev(dev);
@@ -8766,9 +8748,6 @@ static pci_ers_result_t bnx2_io_slot_reset(struct pci_dev *pdev)
 	}
 	rtnl_unlock();
 
-	if (!(bp->flags & BNX2_FLAG_AER_ENABLED))
-		return result;
-
 	return result;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnx2.h b/drivers/net/ethernet/broadcom/bnx2.h
index a09ec47461c9..315b08c64edd 100644
--- a/drivers/net/ethernet/broadcom/bnx2.h
+++ b/drivers/net/ethernet/broadcom/bnx2.h
@@ -6808,7 +6808,6 @@ struct bnx2 {
 #define BNX2_FLAG_JUMBO_BROKEN		0x00000800
 #define BNX2_FLAG_CAN_KEEP_VLAN		0x00001000
 #define BNX2_FLAG_BROKEN_STATS		0x00002000
-#define BNX2_FLAG_AER_ENABLED		0x00004000
 
 	struct bnx2_napi	bnx2_napi[BNX2_MAX_MSIX_VEC];
 
-- 
2.25.1

