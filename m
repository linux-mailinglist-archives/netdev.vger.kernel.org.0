Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7D65A726
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfF1WtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:49:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:42188 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfF1WtI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:49:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 15:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="338039150"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2019 15:49:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/15] igb: add RR2DCDELAY to ethtool registers dump
Date:   Fri, 28 Jun 2019 15:49:27 -0700
Message-Id: <20190628224932.3389-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
References: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch adds the RR2DCDELAY register to the ethtool registers dump.
RR2DCDELAY exists on I210 and I211 Intel Gigabit Ethernet chips and it stands
for "Read Request To Data Completion Delay". Here is how this register is
described in the I210 datasheet:

"This field captures the maximum PCIe split time in 16 ns units, which is the
maximum delay between the read request to the first data completion. This is
giving an estimation of the PCIe round trip time."

In other words, whenever I210 reads from the host memory (e.g., fetches a
descriptor from the ring), the chip measures every PCI DMA read transaction and
captures the maximum value. So it ends up containing the longest DMA
transaction time.

This register is very useful for troubleshooting and research purposes. If you
are dealing with time-sensitive networks, this register can help you get
an idea of your "I210-to-ring" latency. This helps answering questions like
"should I have PCIe ASPM enabled?" or "should I enable deep C-states?" on
my system.

It is safe to read this register at any point, reading it has no effect on
the I210 chip functionality.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igb/e1000_regs.h  | 2 ++
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_regs.h b/drivers/net/ethernet/intel/igb/e1000_regs.h
index 0ad737d2f289..9cb49980ec2d 100644
--- a/drivers/net/ethernet/intel/igb/e1000_regs.h
+++ b/drivers/net/ethernet/intel/igb/e1000_regs.h
@@ -409,6 +409,8 @@ do { \
 #define E1000_I210_TQAVCC(_n)	(0x3004 + ((_n) * 0x40))
 #define E1000_I210_TQAVHC(_n)	(0x300C + ((_n) * 0x40))
 
+#define E1000_I210_RR2DCDELAY	0x5BF4
+
 #define E1000_INVM_DATA_REG(_n)	(0x12120 + 4*(_n))
 #define E1000_INVM_SIZE		64 /* Number of INVM Data Registers */
 
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 401bc2bd6b21..3182b059bf55 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -448,7 +448,7 @@ static void igb_set_msglevel(struct net_device *netdev, u32 data)
 
 static int igb_get_regs_len(struct net_device *netdev)
 {
-#define IGB_REGS_LEN 739
+#define IGB_REGS_LEN 740
 	return IGB_REGS_LEN * sizeof(u32);
 }
 
@@ -710,6 +710,9 @@ static void igb_get_regs(struct net_device *netdev,
 		for (i = 0; i < 12; i++)
 			regs_buff[727 + i] = rd32(E1000_TDWBAH(i + 4));
 	}
+
+	if (hw->mac.type == e1000_i210 || hw->mac.type == e1000_i211)
+		regs_buff[739] = rd32(E1000_I210_RR2DCDELAY);
 }
 
 static int igb_get_eeprom_len(struct net_device *netdev)
-- 
2.21.0

