Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9A127DD4C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgI3AQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:16:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:41608 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgI3AQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 20:16:08 -0400
IronPort-SDR: O63RLkQz5DxFVd/Se2VF2mwbJh5TcMIwwHtmuTmPWxBywdy/1cr6oCXqjfNOYB2F0b9gZYbSnK
 tQu6dtGa54Eg==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="180482222"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="180482222"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 17:16:07 -0700
IronPort-SDR: vdi2jKIYzv8FGuflhcB9QiIUqGigzEjcnYS1Nn8dAgvwCUhXs5jj9VyGina9kIMMFsifoMhRvv
 ygQmvr/91krA==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="514086700"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 17:16:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Brijesh Behera <brijeshx.behera@intel.com>
Subject: [PATCH net 2/2] ice: preserve NVM capabilities in safe mode
Date:   Tue, 29 Sep 2020 17:15:48 -0700
Message-Id: <20200930001548.1927323-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200930001548.1927323-1-anthony.l.nguyen@intel.com>
References: <20200930001548.1927323-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

If the driver initializes in safe mode, it will call
ice_set_safe_mode_caps. This results in clearing the capabilities
structures, in order to set them up for operating in safe mode, ensuring
many features are disabled.

This has a side effect of also clearing the capability bits that relate
to NVM update. The result is that the device driver will not indicate
support for unified update, even if the firmware is capable.

Fix this by adding the relevant capability fields to the list of values
we preserve. To simplify the code, use a common_cap structure instead of
a handful of local variables. To reduce some duplication of the
capability name, introduce a couple of macros used to restore the
capabilities values from the cached copy.

Fixes: de9b277ee032 ("ice: Add support for unified NVM update flow capability")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Brijesh Behera <brijeshx.behera@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 49 ++++++++++++---------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 34abfcea9858..7db5fd977367 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2288,26 +2288,28 @@ void ice_set_safe_mode_caps(struct ice_hw *hw)
 {
 	struct ice_hw_func_caps *func_caps = &hw->func_caps;
 	struct ice_hw_dev_caps *dev_caps = &hw->dev_caps;
-	u32 valid_func, rxq_first_id, txq_first_id;
-	u32 msix_vector_first_id, max_mtu;
+	struct ice_hw_common_caps cached_caps;
 	u32 num_funcs;
 
 	/* cache some func_caps values that should be restored after memset */
-	valid_func = func_caps->common_cap.valid_functions;
-	txq_first_id = func_caps->common_cap.txq_first_id;
-	rxq_first_id = func_caps->common_cap.rxq_first_id;
-	msix_vector_first_id = func_caps->common_cap.msix_vector_first_id;
-	max_mtu = func_caps->common_cap.max_mtu;
+	cached_caps = func_caps->common_cap;
 
 	/* unset func capabilities */
 	memset(func_caps, 0, sizeof(*func_caps));
 
+#define ICE_RESTORE_FUNC_CAP(name) \
+	func_caps->common_cap.name = cached_caps.name
+
 	/* restore cached values */
-	func_caps->common_cap.valid_functions = valid_func;
-	func_caps->common_cap.txq_first_id = txq_first_id;
-	func_caps->common_cap.rxq_first_id = rxq_first_id;
-	func_caps->common_cap.msix_vector_first_id = msix_vector_first_id;
-	func_caps->common_cap.max_mtu = max_mtu;
+	ICE_RESTORE_FUNC_CAP(valid_functions);
+	ICE_RESTORE_FUNC_CAP(txq_first_id);
+	ICE_RESTORE_FUNC_CAP(rxq_first_id);
+	ICE_RESTORE_FUNC_CAP(msix_vector_first_id);
+	ICE_RESTORE_FUNC_CAP(max_mtu);
+	ICE_RESTORE_FUNC_CAP(nvm_unified_update);
+	ICE_RESTORE_FUNC_CAP(nvm_update_pending_nvm);
+	ICE_RESTORE_FUNC_CAP(nvm_update_pending_orom);
+	ICE_RESTORE_FUNC_CAP(nvm_update_pending_netlist);
 
 	/* one Tx and one Rx queue in safe mode */
 	func_caps->common_cap.num_rxq = 1;
@@ -2318,22 +2320,25 @@ void ice_set_safe_mode_caps(struct ice_hw *hw)
 	func_caps->guar_num_vsi = 1;
 
 	/* cache some dev_caps values that should be restored after memset */
-	valid_func = dev_caps->common_cap.valid_functions;
-	txq_first_id = dev_caps->common_cap.txq_first_id;
-	rxq_first_id = dev_caps->common_cap.rxq_first_id;
-	msix_vector_first_id = dev_caps->common_cap.msix_vector_first_id;
-	max_mtu = dev_caps->common_cap.max_mtu;
+	cached_caps = dev_caps->common_cap;
 	num_funcs = dev_caps->num_funcs;
 
 	/* unset dev capabilities */
 	memset(dev_caps, 0, sizeof(*dev_caps));
 
+#define ICE_RESTORE_DEV_CAP(name) \
+	dev_caps->common_cap.name = cached_caps.name
+
 	/* restore cached values */
-	dev_caps->common_cap.valid_functions = valid_func;
-	dev_caps->common_cap.txq_first_id = txq_first_id;
-	dev_caps->common_cap.rxq_first_id = rxq_first_id;
-	dev_caps->common_cap.msix_vector_first_id = msix_vector_first_id;
-	dev_caps->common_cap.max_mtu = max_mtu;
+	ICE_RESTORE_DEV_CAP(valid_functions);
+	ICE_RESTORE_DEV_CAP(txq_first_id);
+	ICE_RESTORE_DEV_CAP(rxq_first_id);
+	ICE_RESTORE_DEV_CAP(msix_vector_first_id);
+	ICE_RESTORE_DEV_CAP(max_mtu);
+	ICE_RESTORE_DEV_CAP(nvm_unified_update);
+	ICE_RESTORE_DEV_CAP(nvm_update_pending_nvm);
+	ICE_RESTORE_DEV_CAP(nvm_update_pending_orom);
+	ICE_RESTORE_DEV_CAP(nvm_update_pending_netlist);
 	dev_caps->num_funcs = num_funcs;
 
 	/* one Tx and one Rx queue per function in safe mode */
-- 
2.26.2

