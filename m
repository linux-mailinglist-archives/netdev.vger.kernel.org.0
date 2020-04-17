Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9861AE507
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbgDQSnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:43:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:31355 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbgDQSm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 14:42:56 -0400
IronPort-SDR: 2XYJP4Ott7gsmday+HVbGafdN8lnV4/nEUsxHYgBi2x1Ad/yDS78hWT+usptLMSc/VzgHZi/Wa
 bBz1J0PezYYg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 11:42:53 -0700
IronPort-SDR: 5AAE3dLN3BKf2wOiKg3Wx5nEmUzk/w0r8eZsXoUTt3kswEUgTgyIp2N0f8TYp6R+PipwxP4gvG
 wI5x7wu5DLBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="254294392"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2020 11:42:52 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/14] igc: Fix NFC queue redirection support
Date:   Fri, 17 Apr 2020 11:42:49 -0700
Message-Id: <20200417184251.1962762-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
References: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The support for ethtool Network Flow Classification (NFC) queue
redirection based on destination MAC address is currently broken in IGC.
For instance, if we add the following rule, matching frames aren't
enqueued on the expected rx queue.

$ ethtool -N IFNAME flow-type ether dst 3c:fd:fe:9e:7f:71 queue 2

The issue here is due to the fact that igc_rar_set_index() is missing
code to enable the queue selection feature from Receive Address High
(RAH) register. This patch adds the missing code and fixes the issue.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  5 ++++-
 drivers/net/ethernet/intel/igc/igc_main.c    | 11 ++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 42fe4d75cc0d..af0c03d77a39 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -63,8 +63,11 @@
  * (RAR[15]) for our directed address used by controllers with
  * manageability enabled, allowing us room for 15 multicast addresses.
  */
+#define IGC_RAH_QSEL_MASK	0x000C0000
+#define IGC_RAH_QSEL_SHIFT	18
+#define IGC_RAH_QSEL_ENABLE	BIT(28)
 #define IGC_RAH_AV		0x80000000 /* Receive descriptor valid */
-#define IGC_RAH_POOL_1		0x00040000
+
 #define IGC_RAL_MAC_ADDR_LEN	4
 #define IGC_RAH_MAC_ADDR_LEN	2
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 44366c1bec19..85df9366e172 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -780,13 +780,18 @@ static void igc_rar_set_index(struct igc_adapter *adapter, u32 index)
 	rar_low = le32_to_cpup((__le32 *)(addr));
 	rar_high = le16_to_cpup((__le16 *)(addr + 4));
 
+	if (adapter->mac_table[index].state & IGC_MAC_STATE_QUEUE_STEERING) {
+		u8 queue = adapter->mac_table[index].queue;
+		u32 qsel = IGC_RAH_QSEL_MASK & (queue << IGC_RAH_QSEL_SHIFT);
+
+		rar_high |= qsel;
+		rar_high |= IGC_RAH_QSEL_ENABLE;
+	}
+
 	/* Indicate to hardware the Address is Valid. */
 	if (adapter->mac_table[index].state & IGC_MAC_STATE_IN_USE) {
 		if (is_valid_ether_addr(addr))
 			rar_high |= IGC_RAH_AV;
-
-		rar_high |= IGC_RAH_POOL_1 <<
-			adapter->mac_table[index].queue;
 	}
 
 	wr32(IGC_RAL(index), rar_low);
-- 
2.25.2

