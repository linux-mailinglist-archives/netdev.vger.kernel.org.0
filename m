Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21EAC5A72C
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfF1WtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:49:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:42186 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbfF1WtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:49:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 15:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="338039134"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2019 15:49:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Venkatesh Srinivas <venkateshs@google.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] e1000: Use dma_wmb() instead of wmb() before doorbell writes
Date:   Fri, 28 Jun 2019 15:49:22 -0700
Message-Id: <20190628224932.3389-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
References: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Venkatesh Srinivas <venkateshs@google.com>

e1000 writes to doorbells to post transmit descriptors and fill the
receive ring. After writing descriptors to memory but before
writing to doorbells, use dma_wmb() rather than wmb(). wmb() is more
heavyweight than necessary for a device to see descriptor writes.

On x86, this avoids SFENCEs before doorbell writes in both the
Tx and Rx paths. On ARM, this converts DSB ST -> DMB OSHST.

Tested: 82576EB / x86; QEMU (qemu emulates an 8257x)

Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 551de8c2fef2..f703fa58458e 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -3019,7 +3019,7 @@ static void e1000_tx_queue(struct e1000_adapter *adapter,
 	 * applicable for weak-ordered memory model archs,
 	 * such as IA-64).
 	 */
-	wmb();
+	dma_wmb();
 
 	tx_ring->next_to_use = i;
 }
@@ -4540,7 +4540,7 @@ e1000_alloc_jumbo_rx_buffers(struct e1000_adapter *adapter,
 		 * applicable for weak-ordered memory model archs,
 		 * such as IA-64).
 		 */
-		wmb();
+		dma_wmb();
 		writel(i, adapter->hw.hw_addr + rx_ring->rdt);
 	}
 }
@@ -4655,7 +4655,7 @@ static void e1000_alloc_rx_buffers(struct e1000_adapter *adapter,
 		 * applicable for weak-ordered memory model archs,
 		 * such as IA-64).
 		 */
-		wmb();
+		dma_wmb();
 		writel(i, hw->hw_addr + rx_ring->rdt);
 	}
 }
-- 
2.21.0

