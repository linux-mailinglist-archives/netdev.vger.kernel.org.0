Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249351E7506
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgE2EkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:40323 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgE2EkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:08 -0400
IronPort-SDR: 5j+mNjG49uC7MHUC8BaCsYu8Z04GMj3u3WC9VY03Ji5WrP7bRk90tO7T2EJsUZr+29jQe5cOth
 JIg9o5Lkd57A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:05 -0700
IronPort-SDR: Jdx1VlI/fGFAh3NoMuNf4ZHGEW+ZVOwdJn7PlpHWsGpIoq2Z6mi97f1vw2d77Ua0ij5yfDHBNT
 UcCVr4YsP3VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850911"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     YueHaibing <yuehaibing@huawei.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/17] ixgbe: Remove unused inline function ixgbe_irq_disable_queues
Date:   Thu, 28 May 2020 21:39:53 -0700
Message-Id: <20200529044004.3725307-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
References: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit b5f69ccf6765 ("ixgbe: avoid bringing rings up/down as macvlans are added/removed")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 29 -------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 45fc7ce1a543..a59c166f794f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2973,35 +2973,6 @@ static inline void ixgbe_irq_enable_queues(struct ixgbe_adapter *adapter,
 	/* skip the flush */
 }
 
-static inline void ixgbe_irq_disable_queues(struct ixgbe_adapter *adapter,
-					    u64 qmask)
-{
-	u32 mask;
-	struct ixgbe_hw *hw = &adapter->hw;
-
-	switch (hw->mac.type) {
-	case ixgbe_mac_82598EB:
-		mask = (IXGBE_EIMS_RTX_QUEUE & qmask);
-		IXGBE_WRITE_REG(hw, IXGBE_EIMC, mask);
-		break;
-	case ixgbe_mac_82599EB:
-	case ixgbe_mac_X540:
-	case ixgbe_mac_X550:
-	case ixgbe_mac_X550EM_x:
-	case ixgbe_mac_x550em_a:
-		mask = (qmask & 0xFFFFFFFF);
-		if (mask)
-			IXGBE_WRITE_REG(hw, IXGBE_EIMC_EX(0), mask);
-		mask = (qmask >> 32);
-		if (mask)
-			IXGBE_WRITE_REG(hw, IXGBE_EIMC_EX(1), mask);
-		break;
-	default:
-		break;
-	}
-	/* skip the flush */
-}
-
 /**
  * ixgbe_irq_enable - Enable default interrupt generation settings
  * @adapter: board private structure
-- 
2.26.2

