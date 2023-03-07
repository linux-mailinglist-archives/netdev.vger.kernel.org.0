Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166ED6AEFCA
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbjCGS0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbjCGSY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0124B9E07F;
        Tue,  7 Mar 2023 10:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3189B819CA;
        Tue,  7 Mar 2023 18:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA27C4339B;
        Tue,  7 Mar 2023 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213215;
        bh=93zuo2kl6zHOilprDZc5m0GhVopCd4gNUJYuchTiEY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ko+uUQc94uPwcEVpwuRsVJiAbkjor+5PSV+nzZXkf3hxd9/IZOQcAlg8MTrFnC5yj
         aR07D0LlmHcMbENz1E9G3tMu3T2wwVAlqiyOE6UXiaXQrsKcsqeo4O1wtRK6UBhxav
         8IA6KOPQ4sgDctnHyKQbx0f7KAOm9sA+iE0LlyQYjn3Ne7n8suhLI6QKb81DZxFFmV
         qsjxjhlbiEb6BeFBPPbAhTItlq3vgkh44cKDbmkekcTlQ6+sVoYd0GLow1xfNwch8K
         nTd7UQywXajTfcubGcLM85HEBX2EKQ91T1i51N/5fyLAJ72x3GQmAJka/uwqU6h/Yy
         6E9XDYSrpiOtA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Veerasenareddy Burru <vburru@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>
Subject: [PATCH 10/28] octeon_ep: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:21 -0600
Message-Id: <20230307181940.868828-11-helgaas@kernel.org>
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
Cc: Veerasenareddy Burru <vburru@marvell.com>
Cc: Abhijit Ayarekar <aayarekar@marvell.com>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 5a898fb88e37..fdce78ceea87 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -8,7 +8,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/aer.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
@@ -1050,7 +1049,6 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_pci_regions;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 
 	netdev = alloc_etherdev_mq(sizeof(struct octep_device),
@@ -1106,7 +1104,6 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_octep_config:
 	free_netdev(netdev);
 err_alloc_netdev:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_regions:
 err_dma_mask:
@@ -1139,7 +1136,6 @@ static void octep_remove(struct pci_dev *pdev)
 	octep_device_cleanup(oct);
 	pci_release_mem_regions(pdev);
 	free_netdev(netdev);
-	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.25.1

