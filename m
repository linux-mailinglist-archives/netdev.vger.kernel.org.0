Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98FC5A729
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfF1WtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:49:16 -0400
Received: from mga12.intel.com ([192.55.52.136]:42186 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbfF1WtI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:49:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 15:49:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="338039164"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2019 15:49:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Vitaly Lifshits <vitaly.lifshits@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] e1000e: PCIm function state support
Date:   Fri, 28 Jun 2019 15:49:32 -0700
Message-Id: <20190628224932.3389-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
References: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

Due to commit: 5d8682588605 ("[misc] mei: me: allow runtime
pm for platform with D0i3")
When disconnecting the cable and reconnecting it the NIC
enters DMoff state. This caused wrong link indication
and duplex mismatch. This bug is described in:
https://bugzilla.redhat.com/show_bug.cgi?id=1689436

Checking PCIm function state and performing PHY reset after a
timeout in watchdog task solves this issue.

Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/defines.h |  3 +++
 drivers/net/ethernet/intel/e1000e/netdev.c  | 18 +++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/defines.h b/drivers/net/ethernet/intel/e1000e/defines.h
index fd550dee4982..63c3c79380a1 100644
--- a/drivers/net/ethernet/intel/e1000e/defines.h
+++ b/drivers/net/ethernet/intel/e1000e/defines.h
@@ -222,6 +222,9 @@
 #define E1000_STATUS_PHYRA      0x00000400      /* PHY Reset Asserted */
 #define E1000_STATUS_GIO_MASTER_ENABLE	0x00080000	/* Master Req status */
 
+/* PCIm function state */
+#define E1000_STATUS_PCIM_STATE	0x40000000
+
 #define HALF_DUPLEX 1
 #define FULL_DUPLEX 2
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index b5fed6177ad6..e4baa13b3cda 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5161,8 +5161,9 @@ static void e1000_watchdog_task(struct work_struct *work)
 	struct e1000_mac_info *mac = &adapter->hw.mac;
 	struct e1000_phy_info *phy = &adapter->hw.phy;
 	struct e1000_ring *tx_ring = adapter->tx_ring;
+	u32 dmoff_exit_timeout = 100, tries = 0;
 	struct e1000_hw *hw = &adapter->hw;
-	u32 link, tctl;
+	u32 link, tctl, pcim_state;
 
 	if (test_bit(__E1000_DOWN, &adapter->state))
 		return;
@@ -5187,6 +5188,21 @@ static void e1000_watchdog_task(struct work_struct *work)
 			/* Cancel scheduled suspend requests. */
 			pm_runtime_resume(netdev->dev.parent);
 
+			/* Checking if MAC is in DMoff state*/
+			pcim_state = er32(STATUS);
+			while (pcim_state & E1000_STATUS_PCIM_STATE) {
+				if (tries++ == dmoff_exit_timeout) {
+					e_dbg("Error in exiting dmoff\n");
+					break;
+				}
+				usleep_range(10000, 20000);
+				pcim_state = er32(STATUS);
+
+				/* Checking if MAC exited DMoff state */
+				if (!(pcim_state & E1000_STATUS_PCIM_STATE))
+					e1000_phy_hw_reset(&adapter->hw);
+			}
+
 			/* update snapshot of PHY registers on LSC */
 			e1000_phy_read_status(adapter);
 			mac->ops.get_link_up_info(&adapter->hw,
-- 
2.21.0

