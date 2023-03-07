Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9137F6AEFE7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbjCGS1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbjCGS0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA2DACBB2;
        Tue,  7 Mar 2023 10:20:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7904F6154D;
        Tue,  7 Mar 2023 18:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE61DC433D2;
        Tue,  7 Mar 2023 18:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213233;
        bh=MunmSilf1uIvYwkUne62rZ2OB+MTJPaCa6o/fBaY2ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OL7VNPNRmW497PB7a+2AZN+2qDuYEp2t6VwUwfrSnPlxUH9CH8RIfXh3QIn1tFtsc
         4IXPWVzGdx0Q4cw84ny1sEEgnA734DOVvoxC99FDPZ4hz21SYxobqRORsY131PUaGS
         Mx4a2gOJ1zFs6UiR3c9RXP6WWw5hKso9cKjTawtZobVlHLGiTUcnrJMRq9UJ+wgcb7
         7MSvm87neFbyoQwvOZXFfxSWTgirSoERrJ+vtPqwq/iiyfrvsQMUMeJmZ7YgJa08kF
         kxg5D3zHX4+Jxjh+3OscgiXT+h/pCvQLda3Jl/p/4S62PcEc80eyfX7BOpDQP+aUmr
         +EGoDvfy/avJA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>,
        Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH 20/28] net: txgbe: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:31 -0600
Message-Id: <20230307181940.868828-21-helgaas@kernel.org>
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
Cc: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 6c0a98230557..859feaafd350 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -6,7 +6,6 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/string.h>
-#include <linux/aer.h>
 #include <linux/etherdevice.h>
 #include <net/ip.h>
 
@@ -538,7 +537,6 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_pci_disable_dev;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 
 	netdev = devm_alloc_etherdev_mqs(&pdev->dev,
@@ -698,7 +696,6 @@ static int txgbe_probe(struct pci_dev *pdev,
 err_free_mac_table:
 	kfree(wx->mac_table);
 err_pci_release_regions:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 err_pci_disable_dev:
@@ -729,8 +726,6 @@ static void txgbe_remove(struct pci_dev *pdev)
 	kfree(wx->mac_table);
 	wx_clear_interrupt_scheme(wx);
 
-	pci_disable_pcie_error_reporting(pdev);
-
 	pci_disable_device(pdev);
 }
 
-- 
2.25.1

