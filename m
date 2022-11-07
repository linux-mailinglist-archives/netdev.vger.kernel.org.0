Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD0661EC25
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiKGHfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiKGHfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:35:40 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B57D5FB4
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667806539; x=1699342539;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8kawSVDkbfcBgrFdvOzOhUDkcdm2cKaY6bTMZJ+ESrc=;
  b=eT32b/r5qIr0Ip1HIsolPTQQUjSFXF50GiTsCn4/GSXo6/KTgESHxC6D
   z4v107joC9jKh6Bxe1ulZ3Em3iDuSfPX9s8ylr+Shu9m0FPveON+AI2EF
   zondz+lfeuGjdJUqBcxowbRT6R9UnC1Mkj+SYKqiNMWXzmAQK6czy2v7f
   P7zfbEvmf0J8CwvBEZBBkog+cmIncFk8dkXRxdtcrApfFdtPK35UxkHM+
   jM6drWsRqlOWFQSOO8BgssPBUYXXuII33RIVWaVZqWYYu/SyFrNZuBcsv
   4YVEjWA7kHROSpoQHlz+CEGGhRsd+kcZK/1TkmMzyLHCgr/s4I0YjF6zc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="372465633"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="372465633"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 23:35:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="638268595"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="638268595"
Received: from bswcg005.iind.intel.com ([10.224.174.25])
  by fmsmga007.fm.intel.com with ESMTP; 06 Nov 2022 23:35:36 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, edumazet@google.com, pabeni@redhat.com,
        linuxwwan@intel.com,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH net V2 2/4] net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled
Date:   Mon,  7 Nov 2022 13:05:02 +0530
Message-Id: <20221107073502.1978194-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
--
v2:
 * Add dependency on PCI in kconfig file to resolve kernel test robot
   reported errors.
---
 drivers/net/wwan/Kconfig              | 2 +-
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 3486ffe94ac4..ac4d73b5626f 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -94,7 +94,7 @@ config RPMSG_WWAN_CTRL
 
 config IOSM
 	tristate "IOSM Driver for Intel M.2 WWAN Device"
-	depends on INTEL_IOMMU
+	depends on PCI
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

