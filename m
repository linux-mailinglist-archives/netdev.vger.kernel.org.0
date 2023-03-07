Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9EFE6AEFBF
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbjCGS0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbjCGSYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE37A80C4;
        Tue,  7 Mar 2023 10:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E2661501;
        Tue,  7 Mar 2023 18:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C344C433EF;
        Tue,  7 Mar 2023 18:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213213;
        bh=f2vDXDF6d70nczotU5xFMm8fkVvPCcrdAaiTn10Iyl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRnUrsPuNk+5S46oLbNEqQe9aTovqlD45J+8hXGeZDlNrPkHEsr/i6cBUHzO/A+yp
         CpboaFpgpThprgVtfS970fS7spbUwedUzYIW+MdqLwNCGa7gUShcfuZo+VzcCM7siz
         fL3bFEvFjDN6bKah7zK1qrXXgXZG/zbpAwQPr1Jz/5ZYcnKc13So5WRVO33OnjFlxr
         6IgFl1Ov1Q94ls+5blZ7VetzcaFyHcISVsNwKV86KGAljoFfUnRUycAHPZDB0RCd2Y
         eeqnzI04lr7XL0l1vwMRKiUEj7Ijp+CelZuTwsSvRARqUPplZBxNGiQKNrLwPeGDhq
         oiZRzU7O9O72g==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com
Subject: [PATCH 09/28] netxen_nic: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:20 -0600
Message-Id: <20230307181940.868828-10-helgaas@kernel.org>
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

Also note that the driver only called these for NX_IS_REVISION_P3 devices,
so since f26e58bf6f54, error reporting has been enabled for devices other
than NX_IS_REVISION_P3.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Manish Chopra <manishc@marvell.com>
Cc: Rahul Verma <rahulv@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index de8d54b23f73..59d0dd862fd1 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -18,7 +18,6 @@
 #include <linux/ipv6.h>
 #include <linux/inetdevice.h>
 #include <linux/sysfs.h>
-#include <linux/aer.h>
 
 MODULE_DESCRIPTION("QLogic/NetXen (1/10) GbE Intelligent Ethernet Driver");
 MODULE_LICENSE("GPL");
@@ -1464,9 +1463,6 @@ netxen_nic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if ((err = pci_request_regions(pdev, netxen_nic_driver_name)))
 		goto err_out_disable_pdev;
 
-	if (NX_IS_REVISION_P3(pdev->revision))
-		pci_enable_pcie_error_reporting(pdev);
-
 	pci_set_master(pdev);
 
 	netdev = alloc_etherdev(sizeof(struct netxen_adapter));
@@ -1603,8 +1599,6 @@ netxen_nic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	free_netdev(netdev);
 
 err_out_free_res:
-	if (NX_IS_REVISION_P3(pdev->revision))
-		pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
@@ -1659,10 +1653,8 @@ static void netxen_nic_remove(struct pci_dev *pdev)
 
 	netxen_release_firmware(adapter);
 
-	if (NX_IS_REVISION_P3(pdev->revision)) {
+	if (NX_IS_REVISION_P3(pdev->revision))
 		netxen_cleanup_minidump(adapter);
-		pci_disable_pcie_error_reporting(pdev);
-	}
 
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
2.25.1

