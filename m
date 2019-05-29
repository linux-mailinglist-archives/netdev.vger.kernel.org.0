Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C952D2C1
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfE2ARk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:17:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:59374 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727182AbfE2AR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 20:17:27 -0400
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
Subject: [net-next 06/10] igc: Remove the obsolete workaround
Date:   Tue, 28 May 2019 17:17:22 -0700
Message-Id: <20190529001726.26097-7-jeffrey.t.kirsher@intel.com>
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

Enables a resend request after the completion timeout workaround is not
relevant for i225 device. This patch is clean code relevant this
workaround.
Minor cosmetic fixes, replace the 'spaces' with 'tabs'

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c    | 49 --------------------
 drivers/net/ethernet/intel/igc/igc_defines.h | 12 ++---
 2 files changed, 3 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index 51a8b8769c67..59258d791106 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -9,50 +9,6 @@
 #include "igc_base.h"
 #include "igc.h"
 
-/**
- * igc_set_pcie_completion_timeout - set pci-e completion timeout
- * @hw: pointer to the HW structure
- */
-static s32 igc_set_pcie_completion_timeout(struct igc_hw *hw)
-{
-	u32 gcr = rd32(IGC_GCR);
-	u16 pcie_devctl2;
-	s32 ret_val = 0;
-
-	/* only take action if timeout value is defaulted to 0 */
-	if (gcr & IGC_GCR_CMPL_TMOUT_MASK)
-		goto out;
-
-	/* if capabilities version is type 1 we can write the
-	 * timeout of 10ms to 200ms through the GCR register
-	 */
-	if (!(gcr & IGC_GCR_CAP_VER2)) {
-		gcr |= IGC_GCR_CMPL_TMOUT_10ms;
-		goto out;
-	}
-
-	/* for version 2 capabilities we need to write the config space
-	 * directly in order to set the completion timeout value for
-	 * 16ms to 55ms
-	 */
-	ret_val = igc_read_pcie_cap_reg(hw, PCIE_DEVICE_CONTROL2,
-					&pcie_devctl2);
-	if (ret_val)
-		goto out;
-
-	pcie_devctl2 |= PCIE_DEVICE_CONTROL2_16ms;
-
-	ret_val = igc_write_pcie_cap_reg(hw, PCIE_DEVICE_CONTROL2,
-					 &pcie_devctl2);
-out:
-	/* disable completion timeout resend */
-	gcr &= ~IGC_GCR_CMPL_TMOUT_RESEND;
-
-	wr32(IGC_GCR, gcr);
-
-	return ret_val;
-}
-
 /**
  * igc_reset_hw_base - Reset hardware
  * @hw: pointer to the HW structure
@@ -72,11 +28,6 @@ static s32 igc_reset_hw_base(struct igc_hw *hw)
 	if (ret_val)
 		hw_dbg("PCI-E Master disable polling has failed.\n");
 
-	/* set the completion timeout for interface */
-	ret_val = igc_set_pcie_completion_timeout(hw);
-	if (ret_val)
-		hw_dbg("PCI-E Set completion timeout has failed.\n");
-
 	hw_dbg("Masking off all interrupts\n");
 	wr32(IGC_IMC, 0xffffffff);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 6f17ed3de995..5f6bc67cb33b 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -5,8 +5,8 @@
 #define _IGC_DEFINES_H_
 
 /* Number of Transmit and Receive Descriptors must be a multiple of 8 */
-#define REQ_TX_DESCRIPTOR_MULTIPLE  8
-#define REQ_RX_DESCRIPTOR_MULTIPLE  8
+#define REQ_TX_DESCRIPTOR_MULTIPLE	8
+#define REQ_RX_DESCRIPTOR_MULTIPLE	8
 
 #define IGC_CTRL_EXT_DRV_LOAD	0x10000000 /* Drv loaded bit for FW */
 
@@ -29,12 +29,6 @@
 /* Status of Master requests. */
 #define IGC_STATUS_GIO_MASTER_ENABLE	0x00080000
 
-/* PCI Express Control */
-#define IGC_GCR_CMPL_TMOUT_MASK		0x0000F000
-#define IGC_GCR_CMPL_TMOUT_10ms		0x00001000
-#define IGC_GCR_CMPL_TMOUT_RESEND	0x00010000
-#define IGC_GCR_CAP_VER2		0x00040000
-
 /* Receive Address
  * Number of high/low register pairs in the RAR. The RAR (Receive Address
  * Registers) holds the directed and multicast addresses that we monitor.
@@ -395,7 +389,7 @@
 #define IGC_MDIC_ERROR		0x40000000
 #define IGC_MDIC_DEST		0x80000000
 
-#define IGC_N0_QUEUE -1
+#define IGC_N0_QUEUE		-1
 
 #define IGC_MAX_MAC_HDR_LEN	127
 #define IGC_MAX_NETWORK_HDR_LEN	511
-- 
2.21.0

