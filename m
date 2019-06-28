Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A63E5A728
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfF1WtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:49:08 -0400
Received: from mga05.intel.com ([192.55.52.43]:51494 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbfF1WtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:49:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 15:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="338039130"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2019 15:49:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Colin Ian King <colin.king@canonical.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] ixgbe: fix potential u32 overflow on shift
Date:   Fri, 28 Jun 2019 15:49:21 -0700
Message-Id: <20190628224932.3389-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
References: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The u32 variable rem is being shifted using u32 arithmetic however
it is being passed to div_u64 that expects the expression to be a u64.
The 32 bit shift may potentially overflow, so cast rem to a u64 before
shifting to avoid this.  Also remove comment about overflow.

Addresses-Coverity: ("Unintentional integer overflow")
Fixes: cd4583206990 ("ixgbe: implement support for SDP/PPS output on X550 hardware")
Fixes: 68d9676fc04e ("ixgbe: fix PTP SDP pin setup on X540 hardware")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 2c4d327fcc2e..0be13a90ff79 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -205,11 +205,8 @@ static void ixgbe_ptp_setup_sdp_X540(struct ixgbe_adapter *adapter)
 	 */
 	rem = (NS_PER_SEC - rem);
 
-	/* Adjust the clock edge to align with the next full second. This
-	 * assumes that the cycle counter shift is small enough to avoid
-	 * overflowing when shifting the remainder.
-	 */
-	clock_edge += div_u64((rem << cc->shift), cc->mult);
+	/* Adjust the clock edge to align with the next full second. */
+	clock_edge += div_u64(((u64)rem << cc->shift), cc->mult);
 	trgttiml = (u32)clock_edge;
 	trgttimh = (u32)(clock_edge >> 32);
 
@@ -291,11 +288,8 @@ static void ixgbe_ptp_setup_sdp_X550(struct ixgbe_adapter *adapter)
 	 */
 	rem = (NS_PER_SEC - rem);
 
-	/* Adjust the clock edge to align with the next full second. This
-	 * assumes that the cycle counter shift is small enough to avoid
-	 * overflowing when shifting the remainder.
-	 */
-	clock_edge += div_u64((rem << cc->shift), cc->mult);
+	/* Adjust the clock edge to align with the next full second. */
+	clock_edge += div_u64(((u64)rem << cc->shift), cc->mult);
 
 	/* X550 hardware stores the time in 32bits of 'billions of cycles' and
 	 * 32bits of 'cycles'. There's no guarantee that cycles represents
-- 
2.21.0

