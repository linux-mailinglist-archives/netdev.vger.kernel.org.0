Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68D03F3046
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbhHTP43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:56:29 -0400
Received: from mga17.intel.com ([192.55.52.151]:53677 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241230AbhHTP4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:56:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10082"; a="197050452"
X-IronPort-AV: E=Sophos;i="5.84,338,1620716400"; 
   d="scan'208";a="197050452"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2021 08:55:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,338,1620716400"; 
   d="scan'208";a="680126969"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 20 Aug 2021 08:55:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Aaron Ma <aaron.ma@canonical.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net 1/4] igc: fix page fault when thunderbolt is unplugged
Date:   Fri, 20 Aug 2021 08:59:12 -0700
Message-Id: <20210820155915.1119889-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210820155915.1119889-1-anthony.l.nguyen@intel.com>
References: <20210820155915.1119889-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

After unplug thunderbolt dock with i225, pciehp interrupt is triggered,
remove call will read/write mmio address which is already disconnected,
then cause page fault and make system hang.

Check PCI state to remove device safely.

Trace:
BUG: unable to handle page fault for address: 000000000000b604
Oops: 0000 [#1] SMP NOPTI
RIP: 0010:igc_rd32+0x1c/0x90 [igc]
Call Trace:
igc_ptp_suspend+0x6c/0xa0 [igc]
igc_ptp_stop+0x12/0x50 [igc]
igc_remove+0x7f/0x1c0 [igc]
pci_device_remove+0x3e/0xb0
__device_release_driver+0x181/0x240

Fixes: 13b5b7fd6a4a ("igc: Add support for Tx/Rx rings")
Fixes: b03c49cde61f ("igc: Save PTP time before a reset")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 32 ++++++++++++++---------
 drivers/net/ethernet/intel/igc/igc_ptp.c  |  3 ++-
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e29aadbc6744..5e9c86ea3a5a 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -149,6 +149,9 @@ static void igc_release_hw_control(struct igc_adapter *adapter)
 	struct igc_hw *hw = &adapter->hw;
 	u32 ctrl_ext;
 
+	if (!pci_device_is_present(adapter->pdev))
+		return;
+
 	/* Let firmware take over control of h/w */
 	ctrl_ext = rd32(IGC_CTRL_EXT);
 	wr32(IGC_CTRL_EXT,
@@ -4449,26 +4452,29 @@ void igc_down(struct igc_adapter *adapter)
 
 	igc_ptp_suspend(adapter);
 
-	/* disable receives in the hardware */
-	rctl = rd32(IGC_RCTL);
-	wr32(IGC_RCTL, rctl & ~IGC_RCTL_EN);
-	/* flush and sleep below */
-
+	if (pci_device_is_present(adapter->pdev)) {
+		/* disable receives in the hardware */
+		rctl = rd32(IGC_RCTL);
+		wr32(IGC_RCTL, rctl & ~IGC_RCTL_EN);
+		/* flush and sleep below */
+	}
 	/* set trans_start so we don't get spurious watchdogs during reset */
 	netif_trans_update(netdev);
 
 	netif_carrier_off(netdev);
 	netif_tx_stop_all_queues(netdev);
 
-	/* disable transmits in the hardware */
-	tctl = rd32(IGC_TCTL);
-	tctl &= ~IGC_TCTL_EN;
-	wr32(IGC_TCTL, tctl);
-	/* flush both disables and wait for them to finish */
-	wrfl();
-	usleep_range(10000, 20000);
+	if (pci_device_is_present(adapter->pdev)) {
+		/* disable transmits in the hardware */
+		tctl = rd32(IGC_TCTL);
+		tctl &= ~IGC_TCTL_EN;
+		wr32(IGC_TCTL, tctl);
+		/* flush both disables and wait for them to finish */
+		wrfl();
+		usleep_range(10000, 20000);
 
-	igc_irq_disable(adapter);
+		igc_irq_disable(adapter);
+	}
 
 	adapter->flags &= ~IGC_FLAG_NEED_LINK_UPDATE;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 69617d2c1be2..4ae19c6a3247 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -849,7 +849,8 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
 	adapter->ptp_tx_skb = NULL;
 	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
 
-	igc_ptp_time_save(adapter);
+	if (pci_device_is_present(adapter->pdev))
+		igc_ptp_time_save(adapter);
 }
 
 /**
-- 
2.26.2

