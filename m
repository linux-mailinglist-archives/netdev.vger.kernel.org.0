Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF986AEFAE
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbjCGSZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjCGSYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BF59FE51;
        Tue,  7 Mar 2023 10:20:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C14F61546;
        Tue,  7 Mar 2023 18:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4513C4339C;
        Tue,  7 Mar 2023 18:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213208;
        bh=pFPJ8Gf/UKoAjq3MFpPQ7R9lpnJErmcP6SLaIvSooH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iURIuRfsXJMsXQrZ4QCQUds072j/cgGQfquLTdhMQstz7xlhx2Zide0H8KZmYc6ub
         k+lwuRDfJ97HKLzcWEMRt8a20On+a2FOUPBBMTNx4h8wlZOjpP+Dc+N9Pt6qxIFdck
         2m80egoZjIif/CC9ZMNGsXnE7oq33ST4hz9CYj+NsE/KK/TzdZ9+ZW+zszzv/1fIpP
         N+yC75cd9xY8iQLEKiN62Yom0AsoRNpMijy1CNgvYeXkbHi8v1rrkrSQfeofMbxlOF
         znLThsDmQOryFf/GGPIbcW139M51iH1OLFGqk/gn4lv7/q2dUuFnONGTXHAz53MsV4
         Qzjl0qJfPGFNg==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH 06/28] cxgb4: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:17 -0600
Message-Id: <20230307181940.868828-7-helgaas@kernel.org>
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
Cc: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7db2403c4c9c..f0bc7396ce2b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -51,7 +51,6 @@
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
-#include <linux/aer.h>
 #include <linux/rtnetlink.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
@@ -6687,7 +6686,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_free_adapter;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 	pci_save_state(pdev);
 	adap_idx++;
@@ -7092,7 +7090,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
  out_unmap_bar0:
 	iounmap(regs);
  out_disable_device:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
  out_release_regions:
 	pci_release_regions(pdev);
@@ -7171,7 +7168,6 @@ static void remove_one(struct pci_dev *pdev)
 	}
 #endif
 	iounmap(adapter->regs);
-	pci_disable_pcie_error_reporting(pdev);
 	if ((adapter->flags & CXGB4_DEV_ENABLED)) {
 		pci_disable_device(pdev);
 		adapter->flags &= ~CXGB4_DEV_ENABLED;
-- 
2.25.1

