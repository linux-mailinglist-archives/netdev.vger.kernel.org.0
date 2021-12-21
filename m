Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E164247C5D7
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240923AbhLUSJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:09:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:9404 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240892AbhLUSJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:09:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110144; x=1671646144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1QiDi+aBwCGbjmfmFl5iqEffKs4ieoQ87L8p8o04Skw=;
  b=Q0MmPoYBe7HmVcVuyUHsp64KMRBAvDYumbqeNIEQWjO/irpHqve1P7sB
   qzXvFWtneevPMBAnRWJ/g1U8L8x3EEvljE9KQxaXPt2Ghnn2fqT8DQm6H
   tiKLVSPeW4CUpvgHts5l8Rmzlwcl6gk5oG1Qm4VRbTqIwL4SymsEqA7r8
   KGTBM5IT4EjkYtaDcf3hXAEJGoBK+aX7UB0vS9RCdcvsRXWjbVJTnW/QM
   1H0TC+947k+H38+H3ukLR8Jz9n9w2Wkj8UvPP0bv3q7NXwKnujPvAzTJ/
   bcJ1L4ixqE73AuWy9hiChOLqMjatyeycCvW56IB71R4+uDjvGAspWYDPz
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240264834"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240264834"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 09:49:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="521342482"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 21 Dec 2021 09:49:36 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 02/10] ice: introduce ice_base_incval function
Date:   Tue, 21 Dec 2021 09:48:37 -0800
Message-Id: <20211221174845.3063640-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
References: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

A future change will add additional possible increment values for the
E822 device support. To handle this, we want to look up the increment
value to use instead of hard coding it to the nominal value for E810
devices. Introduce ice_base_incval as a function to get the best nominal
increment value to use.

For now, it just returns the E810 value, but will be refactored in the
future to look up the value based on the device type and configured
clock frequency.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 4d9e122837fa..0afdcda2c8d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -681,6 +681,20 @@ static int ice_ptp_write_adj(struct ice_pf *pf, s32 adj)
 	return ice_ptp_adj_clock(hw, adj);
 }
 
+/**
+ * ice_base_incval - Get base timer increment value
+ * @pf: Board private structure
+ *
+ * Look up the base timer increment value for this device. The base increment
+ * value is used to define the nominal clock tick rate. This increment value
+ * is programmed during device initialization. It is also used as the basis
+ * for calculating adjustments using scaled_ppm.
+ */
+static u64 ice_base_incval(struct ice_pf *pf)
+{
+	return ICE_PTP_NOMINAL_INCVAL_E810;
+}
+
 /**
  * ice_ptp_adjfine - Adjust clock increment rate
  * @info: the driver's PTP info structure
@@ -698,7 +712,7 @@ static int ice_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 	int neg_adj = 0;
 	int err;
 
-	incval = ICE_PTP_NOMINAL_INCVAL_E810;
+	incval = ice_base_incval(pf);
 
 	if (scaled_ppm < 0) {
 		neg_adj = 1;
@@ -1814,7 +1828,7 @@ void ice_ptp_reset(struct ice_pf *pf)
 	}
 
 	/* Write the increment time value to PHY and LAN */
-	err = ice_ptp_write_incval(hw, ICE_PTP_NOMINAL_INCVAL_E810);
+	err = ice_ptp_write_incval(hw, ice_base_incval(pf));
 	if (err) {
 		ice_ptp_unlock(hw);
 		goto err;
@@ -1930,7 +1944,7 @@ static int ice_ptp_init_owner(struct ice_pf *pf)
 	}
 
 	/* Write the increment time value to PHY and LAN */
-	err = ice_ptp_write_incval(hw, ICE_PTP_NOMINAL_INCVAL_E810);
+	err = ice_ptp_write_incval(hw, ice_base_incval(pf));
 	if (err) {
 		ice_ptp_unlock(hw);
 		goto err_exit;
-- 
2.31.1

