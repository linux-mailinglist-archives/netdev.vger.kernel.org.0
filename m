Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA62AAD17
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732051AbfIEUe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:45336 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391669AbfIEUeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136572"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/16] ice: change default number of receive descriptors
Date:   Thu,  5 Sep 2019 13:34:05 -0700
Message-Id: <20190905203406.4152-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
References: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver should start out with a reasonable number of descriptors that
can prevent drops due to a CPU being in a power management state.
Change the default number of descriptors to 2048.
The user can always change the value at runtime.  Transmit descriptor
counts are not modified because they don't need to change due to the
speed of the interface, or for power managed CPUs, but the code is
simplified to a fixed value for the transmit default.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 6c4faf7551f6..b36e1cf0e461 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -47,23 +47,8 @@ extern const char ice_drv_ver[];
 #define ICE_MIN_NUM_DESC	64
 #define ICE_MAX_NUM_DESC	8160
 #define ICE_DFLT_MIN_RX_DESC	512
-/* if the default number of Rx descriptors between ICE_MAX_NUM_DESC and the
- * number of descriptors to fill up an entire page is greater than or equal to
- * ICE_DFLT_MIN_RX_DESC set it based on page size, otherwise set it to
- * ICE_DFLT_MIN_RX_DESC
- */
-#define ICE_DFLT_NUM_RX_DESC \
-	min_t(u16, ICE_MAX_NUM_DESC, \
-	      max_t(u16, ALIGN(PAGE_SIZE / sizeof(union ice_32byte_rx_desc), \
-			       ICE_REQ_DESC_MULTIPLE), \
-		    ICE_DFLT_MIN_RX_DESC))
-/* set default number of Tx descriptors to the minimum between ICE_MAX_NUM_DESC
- * and the number of descriptors to fill up an entire page
- */
-#define ICE_DFLT_NUM_TX_DESC	min_t(u16, ICE_MAX_NUM_DESC, \
-				      ALIGN(PAGE_SIZE / \
-					    sizeof(struct ice_tx_desc), \
-					    ICE_REQ_DESC_MULTIPLE))
+#define ICE_DFLT_NUM_TX_DESC	256
+#define ICE_DFLT_NUM_RX_DESC	2048
 
 #define ICE_DFLT_TRAFFIC_CLASS	BIT(0)
 #define ICE_INT_NAME_STR_LEN	(IFNAMSIZ + 16)
-- 
2.21.0

