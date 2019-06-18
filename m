Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F8A49FDA
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 13:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbfFRLzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 07:55:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:63085 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729689AbfFRLzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 07:55:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 04:55:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,389,1557212400"; 
   d="scan'208";a="150241715"
Received: from powerlab.fi.intel.com (HELO powerlab.backendnet) ([10.237.71.25])
  by orsmga007.jf.intel.com with ESMTP; 18 Jun 2019 04:55:16 -0700
From:   Artem Bityutskiy <dedekind1@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Todd Fujinaka <todd.fujinaka@intel.com>
Subject: [PATCH 2/2] net: intel: igb: add RR2DCDELAY to ethtool registers dump
Date:   Tue, 18 Jun 2019 14:55:13 +0300
Message-Id: <20190618115513.99661-2-dedekind1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618115513.99661-1-dedekind1@gmail.com>
References: <20190618115513.99661-1-dedekind1@gmail.com>
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
2.20.1

