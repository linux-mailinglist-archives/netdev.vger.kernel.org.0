Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B687D6AEFA1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjCGSY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbjCGSYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C639CBF7;
        Tue,  7 Mar 2023 10:19:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EFAD6150F;
        Tue,  7 Mar 2023 18:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D34C433EF;
        Tue,  7 Mar 2023 18:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213198;
        bh=5kyhbiBEtsJwMz5HCmxLv5VbTa4UdxUccaqPgY32uh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cS8ss2GpmOsDF5I8H1FALF4fgvR6vvWwMqBHwvoV3rPKwozyXYj68u9hukliqEYYf
         5jliPnkvObXjJfS9jAbwiRZjSo4uSmwl51bZ/MscD5jUX2OfIO8ZHO5oiycrusfGas
         8LKp++6SWDThELLs28W4YQzIGNrONDflbIdpmjGHzgshsK+3W+xLQXtAu6mGTr7A4t
         uHlbk0k5/nkXIo2TBpUQCp8bWwVSV2xaBjoX1OjXzCiky4nA2m1zO/T7XCmnSyvnaM
         RfeBDqkSsq4v/LKL5eUXGNKXXUdUMnfZhQEPQcqcYOyEGEOdMoK1yWGAzpKgAGcWW2
         FpzmLQ4AyAT4w==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Chris Snook <chris.snook@gmail.com>
Subject: [PATCH 01/28] alx: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:12 -0600
Message-Id: <20230307181940.868828-2-helgaas@kernel.org>
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
Cc: Chris Snook <chris.snook@gmail.com>
---
 drivers/net/ethernet/atheros/alx/main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 306393f8eeca..49bb9a8f00e6 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -39,7 +39,6 @@
 #include <linux/ipv6.h>
 #include <linux/if_vlan.h>
 #include <linux/mdio.h>
-#include <linux/aer.h>
 #include <linux/bitops.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
@@ -1745,7 +1744,6 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_pci_disable;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 
 	if (!pdev->pm_cap) {
@@ -1879,7 +1877,6 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	free_netdev(netdev);
 out_pci_release:
 	pci_release_mem_regions(pdev);
-	pci_disable_pcie_error_reporting(pdev);
 out_pci_disable:
 	pci_disable_device(pdev);
 	return err;
@@ -1897,7 +1894,6 @@ static void alx_remove(struct pci_dev *pdev)
 	iounmap(hw->hw_addr);
 	pci_release_mem_regions(pdev);
 
-	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 
 	mutex_destroy(&alx->mtx);
-- 
2.25.1

