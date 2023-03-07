Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9B36AEFD3
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbjCGS0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjCGSZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:25:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642419FBE2;
        Tue,  7 Mar 2023 10:20:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C64ECCE1C83;
        Tue,  7 Mar 2023 18:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD57C433D2;
        Tue,  7 Mar 2023 18:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213221;
        bh=L40C2NsmiT5sjeEnSWj72p21BipE9CnM7NZNqckWFdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NotFv3R6nlW7TCPqWDdY++YMdVT5NNa6K3LpUqhjc9F15D09eae85fK2IH7rxRvOF
         EoIEWTJdKaQ1sD/+c9bz90rBjuM5AURrPtAM1s3eGbg0zWJyan4JLJR+k6Ds576KwR
         eTW1Qn5CFfp8cICZ9up6ubCga1a2/wAOs1TYYnrLM2lWxGHAAVtD0C/01BtTR1bH5H
         do5sH5r1gzpIFPT6N2YUFIIJAQkWfU9ZThVYwmWmjvdneE7blwmHfsLdRcLMkFqQF4
         WvrdReCZOFIftgVA+q1Ud/VrX+U38z4VAUSFS+GDejUSLKUBlePDNS/1RW+WVqjsOL
         KfC6hziMqAr/w==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com
Subject: [PATCH 13/28] qlcnic: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:24 -0600
Message-Id: <20230307181940.868828-14-helgaas@kernel.org>
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
Cc: Shahed Shaikh <shshaikh@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c  | 4 ----
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c | 1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 44dac3c0908e..90df4a0909fa 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -12,7 +12,6 @@
 #include <net/ip.h>
 #include <linux/ipv6.h>
 #include <linux/inetdevice.h>
-#include <linux/aer.h>
 #include <linux/log2.h>
 #include <linux/pci.h>
 #include <net/vxlan.h>
@@ -2445,7 +2444,6 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_disable_pdev;
 
 	pci_set_master(pdev);
-	pci_enable_pcie_error_reporting(pdev);
 
 	ahw = kzalloc(sizeof(struct qlcnic_hardware_context), GFP_KERNEL);
 	if (!ahw) {
@@ -2675,7 +2673,6 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	kfree(ahw);
 
 err_out_free_res:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
@@ -2757,7 +2754,6 @@ static void qlcnic_remove(struct pci_dev *pdev)
 
 	qlcnic_release_firmware(adapter);
 
-	pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
index 5c2edb715d3e..74125188beb8 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
@@ -12,7 +12,6 @@
 #include <linux/ipv6.h>
 #include <linux/inetdevice.h>
 #include <linux/sysfs.h>
-#include <linux/aer.h>
 #include <linux/log2.h>
 #ifdef CONFIG_QLCNIC_HWMON
 #include <linux/hwmon.h>
-- 
2.25.1

