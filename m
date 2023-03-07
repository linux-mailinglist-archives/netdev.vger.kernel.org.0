Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AB26AEFAA
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjCGSZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbjCGSYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733F4960A4;
        Tue,  7 Mar 2023 10:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 030C56153E;
        Tue,  7 Mar 2023 18:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383BBC433D2;
        Tue,  7 Mar 2023 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213204;
        bh=GFoO0oJn14FI99xGEuLIehsG9zk7o7c2DkNHWJzWB+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/3da3zWVpPbxUf6yK383AW4n7voT7UkVrzUBG1yePxcG71xF+bZWqbxVYKFa/zER
         co4JB2E6RO7gucVXCoz7RX+3jS5rjC6yCEql6bEMYs2och0iCRje1SXAOXbfOFoCbN
         KlEpJIrisGullr47AMhNaa4D17cChRSmJ2bbTRcsvwTlUIWBTgKY+VNEPpl0/Z4sQG
         HgDy5agjCxq0oFAbQ0NNJUvtKVLAACl2frduZg30qoz65225gzDQk2a8x14Q6pA1JB
         x+z7oZohHNX4qRK041xosrZWP7+xqg3eANx3QUloouXwchHy9cUwNlGHh298qQdtam
         j29u4lgi4qmiA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>
Subject: [PATCH 04/28] bnx2x: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:15 -0600
Message-Id: <20230307181940.868828-5-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
References: <20230307181940.868828-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  1 -
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 19 -------------------
 2 files changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index dd5945c4bfec..8bcde0a6e011 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1486,7 +1486,6 @@ struct bnx2x {
 #define IS_VF_FLAG			(1 << 22)
 #define BC_SUPPORTS_RMMOD_CMD		(1 << 23)
 #define HAS_PHYS_PORT_ID		(1 << 24)
-#define AER_ENABLED			(1 << 25)
 #define PTP_SUPPORTED			(1 << 26)
 #define TX_TIMESTAMPING_EN		(1 << 27)
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 5d1e4fe335aa..3bb5ea570c87 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
-#include <linux/aer.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
@@ -13037,14 +13036,6 @@ static const struct net_device_ops bnx2x_netdev_ops = {
 	.ndo_features_check	= bnx2x_features_check,
 };
 
-static void bnx2x_disable_pcie_error_reporting(struct bnx2x *bp)
-{
-	if (bp->flags & AER_ENABLED) {
-		pci_disable_pcie_error_reporting(bp->pdev);
-		bp->flags &= ~AER_ENABLED;
-	}
-}
-
 static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 			  struct net_device *dev, unsigned long board_type)
 {
@@ -13157,13 +13148,6 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 	/* Set PCIe reset type to fundamental for EEH recovery */
 	pdev->needs_freset = 1;
 
-	/* AER (Advanced Error reporting) configuration */
-	rc = pci_enable_pcie_error_reporting(pdev);
-	if (!rc)
-		bp->flags |= AER_ENABLED;
-	else
-		BNX2X_DEV_INFO("Failed To configure PCIe AER [%d]\n", rc);
-
 	/*
 	 * Clean the following indirect addresses for all functions since it
 	 * is not used by the driver.
@@ -14020,8 +14004,6 @@ static int bnx2x_init_one(struct pci_dev *pdev,
 	bnx2x_free_mem_bp(bp);
 
 init_one_exit:
-	bnx2x_disable_pcie_error_reporting(bp);
-
 	if (bp->regview)
 		iounmap(bp->regview);
 
@@ -14102,7 +14084,6 @@ static void __bnx2x_remove(struct pci_dev *pdev,
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
 
-	bnx2x_disable_pcie_error_reporting(bp);
 	if (remove_netdev) {
 		if (bp->regview)
 			iounmap(bp->regview);
-- 
2.25.1

