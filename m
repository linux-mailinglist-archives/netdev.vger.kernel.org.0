Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688CF1E750B
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgE2Ek0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:40329 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgE2EkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:18 -0400
IronPort-SDR: pxBhs+unWE6UOtd1CYTBJqeJs9qSrkwf50yQiLvHvDLSMpCZw/Dp1Fvsmj55yvmd5EI2LR2OoG
 TMTV0Bof9F8Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:06 -0700
IronPort-SDR: XH+sXG0UjY1j54cyPfy8zT4XTadh/+8LOtWbXDJWmKcdt7DDNRP5rOzUruf+pUIF7vKtkQZXXM
 KjZROD+4jfdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850928"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        stable <stable@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/17] e1000e: Relax condition to trigger reset for ME workaround
Date:   Thu, 28 May 2020 21:39:58 -0700
Message-Id: <20200529044004.3725307-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
References: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Punit Agrawal <punit1.agrawal@toshiba.co.jp>

It's an error if the value of the RX/TX tail descriptor does not match
what was written. The error condition is true regardless the duration
of the interference from ME. But the driver only performs the reset if
E1000_ICH_FWSM_PCIM2PCI_COUNT (2000) iterations of 50us delay have
transpired. The extra condition can lead to inconsistency between the
state of hardware as expected by the driver.

Fix this by dropping the check for number of delay iterations.

While at it, also make __ew32_prepare() static as it's not used
anywhere else.

CC: stable <stable@vger.kernel.org>
Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/e1000.h  |  1 -
 drivers/net/ethernet/intel/e1000e/netdev.c | 12 +++++-------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 37a2314d3e6b..944abd5eae11 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -576,7 +576,6 @@ static inline u32 __er32(struct e1000_hw *hw, unsigned long reg)
 
 #define er32(reg)	__er32(hw, E1000_##reg)
 
-s32 __ew32_prepare(struct e1000_hw *hw);
 void __ew32(struct e1000_hw *hw, unsigned long reg, u32 val);
 
 #define ew32(reg, val)	__ew32(hw, E1000_##reg, (val))
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 32f23a15ff64..444532292588 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -158,14 +158,12 @@ static bool e1000e_check_me(u16 device_id)
  * has bit 24 set while ME is accessing MAC CSR registers, wait if it is set
  * and try again a number of times.
  **/
-s32 __ew32_prepare(struct e1000_hw *hw)
+static void __ew32_prepare(struct e1000_hw *hw)
 {
 	s32 i = E1000_ICH_FWSM_PCIM2PCI_COUNT;
 
 	while ((er32(FWSM) & E1000_ICH_FWSM_PCIM2PCI) && --i)
 		udelay(50);
-
-	return i;
 }
 
 void __ew32(struct e1000_hw *hw, unsigned long reg, u32 val)
@@ -646,11 +644,11 @@ static void e1000e_update_rdt_wa(struct e1000_ring *rx_ring, unsigned int i)
 {
 	struct e1000_adapter *adapter = rx_ring->adapter;
 	struct e1000_hw *hw = &adapter->hw;
-	s32 ret_val = __ew32_prepare(hw);
 
+	__ew32_prepare(hw);
 	writel(i, rx_ring->tail);
 
-	if (unlikely(!ret_val && (i != readl(rx_ring->tail)))) {
+	if (unlikely(i != readl(rx_ring->tail))) {
 		u32 rctl = er32(RCTL);
 
 		ew32(RCTL, rctl & ~E1000_RCTL_EN);
@@ -663,11 +661,11 @@ static void e1000e_update_tdt_wa(struct e1000_ring *tx_ring, unsigned int i)
 {
 	struct e1000_adapter *adapter = tx_ring->adapter;
 	struct e1000_hw *hw = &adapter->hw;
-	s32 ret_val = __ew32_prepare(hw);
 
+	__ew32_prepare(hw);
 	writel(i, tx_ring->tail);
 
-	if (unlikely(!ret_val && (i != readl(tx_ring->tail)))) {
+	if (unlikely(i != readl(tx_ring->tail))) {
 		u32 tctl = er32(TCTL);
 
 		ew32(TCTL, tctl & ~E1000_TCTL_EN);
-- 
2.26.2

