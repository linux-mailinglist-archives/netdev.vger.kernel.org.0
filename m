Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9F5613B9D
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiJaQqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiJaQqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:46:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA55DFFD
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 09:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667234773; x=1698770773;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nhSouzbrR031lTI8PtEdLzUltFGdhGxt77jzZWnbAWU=;
  b=ZLN347b8Mvhmp1tJLkg5jolOvxFKV+PxgpstLTxikxG5dFr5MmmEv2pQ
   VwzY2shs65HPQxctnpAC3iVPZfrkPXcligDx8J28/RsPYzgSz3WwwBAjJ
   yy6+SJwC8j/Hs7djFcAoMBiv3vCsx061Atn+eKHffyKXcrqZWLe/nOqPR
   +zB3eliDWVtVfXK6qZpvfy/0/olKxY/Bg0yPDa90QIPdAQyyE90guVJtQ
   IOPZeYJj2fJE77egGoYFY3nEiOLSbYka/HvpWUxZ35CzHpnusVwHjautf
   6kJBy5oOdNnzUP5jY57Zuv+qlUrYez/+T1PGY8BZ/os8SQ1jWt16fBqHF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="292241361"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="292241361"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 09:46:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="702583336"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="702583336"
Received: from bswcg005.iind.intel.com ([10.224.174.25])
  by fmsmga004.fm.intel.com with ESMTP; 31 Oct 2022 09:46:10 -0700
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        linuxwwan@intel.com,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH net 2/3] net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled
Date:   Mon, 31 Oct 2022 22:15:47 +0530
Message-Id: <20221031164547.1886851-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

With INTEL_IOMMU disable config or by forcing intel_iommu=off from
grub some of the features of IOSM driver like browsing, flashing &
coredump collection is not working.

When driver calls DMA API - dma_map_single() for tx transfers. It is
resulting in dma mapping error.

Set the device DMA addressing capabilities using dma_set_mask() and
remove the INTEL_IOMMU dependency in kconfig so that driver follows
the platform config either INTEL_IOMMU enable or disable.

Fixes: f7af616c632e ("net: iosm: infrastructure")
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/Kconfig              | 1 -
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 3486ffe94ac4..58e1eb4cf45c 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -94,7 +94,6 @@ config RPMSG_WWAN_CTRL
 
 config IOSM
 	tristate "IOSM Driver for Intel M.2 WWAN Device"
-	depends on INTEL_IOMMU
 	select NET_DEVLINK
 	select RELAY if WWAN_DEBUGFS
 	help
diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 97cb6846c6ae..d3d34d1c4704 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -259,6 +259,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
 			  const struct pci_device_id *pci_id)
 {
 	struct iosm_pcie *ipc_pcie = kzalloc(sizeof(*ipc_pcie), GFP_KERNEL);
+	int ret;
 
 	pr_debug("Probing device 0x%X from the vendor 0x%X", pci_id->device,
 		 pci_id->vendor);
@@ -291,6 +292,12 @@ static int ipc_pcie_probe(struct pci_dev *pci,
 		goto pci_enable_fail;
 	}
 
+	ret = dma_set_mask(ipc_pcie->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(ipc_pcie->dev, "Could not set PCI DMA mask: %d", ret);
+		return ret;
+	}
+
 	ipc_pcie_config_aspm(ipc_pcie);
 	dev_dbg(ipc_pcie->dev, "PCIe device enabled.");
 
-- 
2.34.1

