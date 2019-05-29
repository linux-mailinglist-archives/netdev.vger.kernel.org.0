Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A933C2D2BF
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfE2ARh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:17:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:59372 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727400AbfE2AR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 20:17:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 17:17:27 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2019 17:17:27 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/10] igc: Add flow control support
Date:   Tue, 28 May 2019 17:17:25 -0700
Message-Id: <20190529001726.26097-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
References: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

This change adds flow control settings. This is required to
enable the legacy flow control support.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  3 +++
 drivers/net/ethernet/intel/igc/igc_main.c    | 21 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 5f6bc67cb33b..fc0ccfe38a20 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -66,6 +66,9 @@
 
 #define IGC_CONNSW_AUTOSENSE_EN	0x1
 
+/* As per the EAS the maximum supported size is 9.5KB (9728 bytes) */
+#define MAX_JUMBO_FRAME_SIZE	0x2600
+
 /* PBA constants */
 #define IGC_PBA_34K		0x0022
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 28072b9aa932..93f3b4e6185b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -72,6 +72,27 @@ void igc_reset(struct igc_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct igc_hw *hw = &adapter->hw;
+	struct igc_fc_info *fc = &hw->fc;
+	u32 pba, hwm;
+
+	/* Repartition PBA for greater than 9k MTU if required */
+	pba = IGC_PBA_34K;
+
+	/* flow control settings
+	 * The high water mark must be low enough to fit one full frame
+	 * after transmitting the pause frame.  As such we must have enough
+	 * space to allow for us to complete our current transmit and then
+	 * receive the frame that is in progress from the link partner.
+	 * Set it to:
+	 * - the full Rx FIFO size minus one full Tx plus one full Rx frame
+	 */
+	hwm = (pba << 10) - (adapter->max_frame_size + MAX_JUMBO_FRAME_SIZE);
+
+	fc->high_water = hwm & 0xFFFFFFF0;	/* 16-byte granularity */
+	fc->low_water = fc->high_water - 16;
+	fc->pause_time = 0xFFFF;
+	fc->send_xon = 1;
+	fc->current_mode = fc->requested_mode;
 
 	hw->mac.ops.reset_hw(hw);
 
-- 
2.21.0

