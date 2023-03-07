Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF216AEFE0
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjCGS1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbjCGS0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B44EA92F4;
        Tue,  7 Mar 2023 10:20:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F1386154C;
        Tue,  7 Mar 2023 18:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA61C4339C;
        Tue,  7 Mar 2023 18:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213232;
        bh=rAktUskhPO1ybz9A1n3ZxmMrMb2ek7EimkMYj7ZSxHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhQzKHoZbVHMkFOXq35GSopr3Xw6Ebqdt2NFeKsF0uGBvJ0hUziTwRIJ6nGujaiKr
         gvTSyF1x4v3NboSWZsHM0WKjfHoiz0eBzO8NHRoAPV7ZIPjI2kxnBMHhBit0sgiNN7
         UH2ElbegdHpdtMoghcTN0m7bPDoq/7unJ8PqK+j77YC7pg8YR30O0jJFzdQECzdBu7
         i0q0XMxxrZtrDjsHQzAA7HVpN+T8NsPuTfbk6ZfX6lZ1Rd+5hZmrTm+s+zbUkCKbFD
         IZ/FUTLLMHAdvhIdh71n0By9jT6FjNCfSdJizy2/ZUhrk3ZYehMxkbe+PRmNbAfpUe
         gqfxJ0lCugAtw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>,
        Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH 19/28] net: ngbe: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:30 -0600
Message-Id: <20230307181940.868828-20-helgaas@kernel.org>
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

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 5b564d348c09..0e4163e1106f 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -6,7 +6,6 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/string.h>
-#include <linux/aer.h>
 #include <linux/etherdevice.h>
 #include <net/ip.h>
 #include <linux/phy.h>
@@ -520,7 +519,6 @@ static int ngbe_probe(struct pci_dev *pdev,
 		goto err_pci_disable_dev;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 
 	netdev = devm_alloc_etherdev_mqs(&pdev->dev,
@@ -669,7 +667,6 @@ static int ngbe_probe(struct pci_dev *pdev,
 err_free_mac_table:
 	kfree(wx->mac_table);
 err_pci_release_regions:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 err_pci_disable_dev:
@@ -698,7 +695,6 @@ static void ngbe_remove(struct pci_dev *pdev)
 
 	kfree(wx->mac_table);
 	wx_clear_interrupt_scheme(wx);
-	pci_disable_pcie_error_reporting(pdev);
 
 	pci_disable_device(pdev);
 }
-- 
2.25.1

