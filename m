Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0B961EC21
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiKGHfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiKGHfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:35:31 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0D438BB
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667806528; x=1699342528;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=A3q9YR+y9h1VgbsvrXPlSicbf70nTtfbkGCgrH+7dA4=;
  b=P9irU0mn9zR/QKs67iIhgrs37tw4R8Fbx7vQngyjhzy2WUW14iEqRCSR
   oSHfttDJ2Q0TH1zQxDfSWyTsPdHNp52Odb2kdEEJTZAWuNSGTuMdcX82q
   HzyVnsVh30Oz0/l0+6GLCOwyg/jQZTk/AIreQ9MvkPLpWVCH455ann/1r
   ixf8p5UAZsXTqCvOzclTGvLz4sgoDpYRgxlT31ChiRyAPYQp7loljZoH+
   Kr8PBNAnc4kKvBlvTB543WASEJtgp2mo/Oi7RKWvQ7fyv8Sl0fK9crjMJ
   dNPrcWfAHhwUkbgRUbY9/eSI2nMgJr1B9DTuRbrtYaPwoED8MB+a3JYF6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="297838564"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="297838564"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 23:35:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="638268561"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="638268561"
Received: from bswcg005.iind.intel.com ([10.224.174.25])
  by fmsmga007.fm.intel.com with ESMTP; 06 Nov 2022 23:35:25 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, edumazet@google.com, pabeni@redhat.com,
        linuxwwan@intel.com,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH net V2 1/4] net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg
Date:   Mon,  7 Nov 2022 13:04:49 +0530
Message-Id: <20221107073449.1978178-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

ipc_pcie_read_bios_cfg() is using the acpi_evaluate_dsm() to
obtain the wwan power state configuration from BIOS but is
not freeing the acpi_object. The acpi_evaluate_dsm() returned
acpi_object to be freed.

Free the acpi_object after use.

Fixes: 7e98d785ae61 ("net: iosm: entry point")
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
--
v2:
 * No Change.
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 31f57b986df2..97cb6846c6ae 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -232,6 +232,7 @@ static void ipc_pcie_config_init(struct iosm_pcie *ipc_pcie)
  */
 static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 {
+	enum ipc_pcie_sleep_state sleep_state = IPC_PCIE_D0L12;
 	union acpi_object *object;
 	acpi_handle handle_acpi;
 
@@ -242,12 +243,16 @@ static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 	}
 
 	object = acpi_evaluate_dsm(handle_acpi, &wwan_acpi_guid, 0, 3, NULL);
+	if (!object)
+		goto default_ret;
+
+	if (object->integer.value == 3)
+		sleep_state = IPC_PCIE_D3L2;
 
-	if (object && object->integer.value == 3)
-		return IPC_PCIE_D3L2;
+	kfree(object);
 
 default_ret:
-	return IPC_PCIE_D0L12;
+	return sleep_state;
 }
 
 static int ipc_pcie_probe(struct pci_dev *pci,
-- 
2.34.1

