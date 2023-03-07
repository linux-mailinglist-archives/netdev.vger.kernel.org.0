Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6226AEFA3
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjCGSY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbjCGSY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D219F22D;
        Tue,  7 Mar 2023 10:20:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B39EB819C8;
        Tue,  7 Mar 2023 18:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0A3C433EF;
        Tue,  7 Mar 2023 18:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213200;
        bh=uTSSQxN9Ng89FUpnr+qHDi5OyXYmSr64uBuRSG1WJSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbpnB4++dC2O5b7l/RR11xhePxpzE7uV9WOux3IBs5PRDdEqsIcBIpPzAlMjXEmh7
         bt+R34c2CM4D0fLxRhk5mhqxWOH3CW5rL3Zcrl/8okxDnZEztLGOUACTmX+3cBgc7c
         s3/QXb2hOWYjmHvnFpRRg6g+1IpTKItbJ+DImYpou7I++PYWNlFKKodlpFAoe4Sqjl
         s0h1sg0p1VaZZlSv8KMKs204F9qp98dcbK1gyKNtPjeDY+yqDtbD/K29TDnbd3AvtX
         +xIwxrE6riRQVGm+EtwRsfzR3dE/6eXKcOcFtY6ULL8e7Q0v70ZsOjLy/C5ULg1aNX
         CmbNtwUaAcPBw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>
Subject: [PATCH 02/28] be2net: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:13 -0600
Message-Id: <20230307181940.868828-3-helgaas@kernel.org>
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
native"), the PCI core does this for all devices during enumeration,  so the
driver doesn't need to do it itself.

Remove the redundant pci_enable_pcie_error_reporting() call from the
driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
from the driver .remove() path.

Note that this only controls ERR_* Messages from the device.  An ERR_*
Message may cause the Root Port to generate an interrupt, depending on the
AER Root Error Command register managed by the AER service driver.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: Somnath Kotur <somnath.kotur@broadcom.com>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 46fe3d74e2e9..aed1b622f51f 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -16,7 +16,6 @@
 #include "be.h"
 #include "be_cmds.h"
 #include <asm/div64.h>
-#include <linux/aer.h>
 #include <linux/if_bridge.h>
 #include <net/busy_poll.h>
 #include <net/vxlan.h>
@@ -5726,8 +5725,6 @@ static void be_remove(struct pci_dev *pdev)
 	be_unmap_pci_bars(adapter);
 	be_drv_cleanup(adapter);
 
-	pci_disable_pcie_error_reporting(pdev);
-
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 
@@ -5845,10 +5842,6 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 		goto free_netdev;
 	}
 
-	status = pci_enable_pcie_error_reporting(pdev);
-	if (!status)
-		dev_info(&pdev->dev, "PCIe error reporting enabled\n");
-
 	status = be_map_pci_bars(adapter);
 	if (status)
 		goto free_netdev;
@@ -5893,7 +5886,6 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 unmap_bars:
 	be_unmap_pci_bars(adapter);
 free_netdev:
-	pci_disable_pcie_error_reporting(pdev);
 	free_netdev(netdev);
 rel_reg:
 	pci_release_regions(pdev);
-- 
2.25.1

