Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A891F391E01
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhEZRYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:24:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:18184 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234330AbhEZRX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 13:23:59 -0400
IronPort-SDR: P9BEGqidWN7rDeqnHxlXE3/oyMgNK924Wtspi2TQPwGRGIsFuOVNpo+39RgLZEvz7ZhOiNHSqn
 NqX1gDjxlMEA==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="266415787"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="266415787"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 10:21:27 -0700
IronPort-SDR: FGF+5FwDIuJAJkedrTh9mWfohChPXFhZRZCnB8lA4ORlw033jUe5hi6JUgHIIDJWEKckU1KlQj
 ewrbYDPJuWwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="443149203"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 26 May 2021 10:21:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 04/11] igb/igc: use strongly typed pointer
Date:   Wed, 26 May 2021 10:23:39 -0700
Message-Id: <20210526172346.3515587-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
References: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The igb and igc driver both use a trick of creating a local type
pointer on the stack to ease dealing with a receive descriptor in
64 bit chunks for printing.  Sparse however was not taken into
account and receive descriptors are always in little endian
order, so just make the unions use __le64 instead of u64.

No functional change.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Warning Detail:
  CHECK   .../igb/igb_main.c
.../igb/igb_main.c:442:25: warning: cast to restricted __le64
.../igb/igb_main.c:442:25: warning: cast to restricted __le64
.../igb/igb_main.c:522:33: warning: cast to restricted __le64
.../igb/igb_main.c:522:33: warning: cast to restricted __le64
.../igb/igb_main.c:528:33: warning: cast to restricted __le64
.../igb/igb_main.c:528:33: warning: cast to restricted __le64
  CHECK   .../igc/igc_dump.c
.../igc/igc_dump.c:192:40: warning: cast to restricted __le64
.../igc/igc_dump.c:193:37: warning: cast to restricted __le64
.../igc/igc_dump.c:275:45: warning: cast to restricted __le64
.../igc/igc_dump.c:276:45: warning: cast to restricted __le64
.../igc/igc_dump.c:281:45: warning: cast to restricted __le64
.../igc/igc_dump.c:282:45: warning: cast to restricted __le64
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 drivers/net/ethernet/intel/igc/igc_dump.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 038a9fd1af44..cf91e3624a89 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -356,7 +356,7 @@ static void igb_dump(struct igb_adapter *adapter)
 	struct igb_reg_info *reginfo;
 	struct igb_ring *tx_ring;
 	union e1000_adv_tx_desc *tx_desc;
-	struct my_u0 { u64 a; u64 b; } *u0;
+	struct my_u0 { __le64 a; __le64 b; } *u0;
 	struct igb_ring *rx_ring;
 	union e1000_adv_rx_desc *rx_desc;
 	u32 staterr;
diff --git a/drivers/net/ethernet/intel/igc/igc_dump.c b/drivers/net/ethernet/intel/igc/igc_dump.c
index 495bed47ed0a..c09c95cc5f70 100644
--- a/drivers/net/ethernet/intel/igc/igc_dump.c
+++ b/drivers/net/ethernet/intel/igc/igc_dump.c
@@ -112,7 +112,7 @@ static void igc_regdump(struct igc_hw *hw, struct igc_reg_info *reginfo)
 void igc_rings_dump(struct igc_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	struct my_u0 { u64 a; u64 b; } *u0;
+	struct my_u0 { __le64 a; __le64 b; } *u0;
 	union igc_adv_tx_desc *tx_desc;
 	union igc_adv_rx_desc *rx_desc;
 	struct igc_ring *tx_ring;
-- 
2.26.2

