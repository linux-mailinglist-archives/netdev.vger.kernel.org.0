Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBC5104CD1
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKUHqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:46:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:4522 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbfKUHqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 02:46:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 23:46:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,224,1571727600"; 
   d="scan'208";a="216077522"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga001.fm.intel.com with ESMTP; 20 Nov 2019 23:46:13 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Kevin Scott <kevin.c.scott@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] ice: Store number of functions for the device
Date:   Wed, 20 Nov 2019 23:45:58 -0800
Message-Id: <20191121074612.3055661-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Store the number of functions the device has and use this number when
setting safe mode capabilities instead of calculating it.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Co-developed-by: Kevin Scott <kevin.c.scott@intel.com>
Signed-off-by: Kevin Scott <kevin.c.scott@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 21 ++++++++++-----------
 drivers/net/ethernet/intel/ice/ice_type.h   |  1 +
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 36be501ae623..e92eaec19c83 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1673,6 +1673,10 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 			ice_debug(hw, ICE_DBG_INIT,
 				  "%s: valid_functions (bitmap) = %d\n", prefix,
 				  caps->valid_functions);
+
+			/* store func count for resource management purposes */
+			if (dev_p)
+				dev_p->num_funcs = hweight32(number);
 			break;
 		case ICE_AQC_CAPS_SRIOV:
 			caps->sr_iov_1_1 = (number == 1);
@@ -1875,8 +1879,7 @@ void ice_set_safe_mode_caps(struct ice_hw *hw)
 	struct ice_hw_dev_caps *dev_caps = &hw->dev_caps;
 	u32 valid_func, rxq_first_id, txq_first_id;
 	u32 msix_vector_first_id, max_mtu;
-	u32 num_func = 0;
-	u8 i;
+	u32 num_funcs;
 
 	/* cache some func_caps values that should be restored after memset */
 	valid_func = func_caps->common_cap.valid_functions;
@@ -1909,6 +1912,7 @@ void ice_set_safe_mode_caps(struct ice_hw *hw)
 	rxq_first_id = dev_caps->common_cap.rxq_first_id;
 	msix_vector_first_id = dev_caps->common_cap.msix_vector_first_id;
 	max_mtu = dev_caps->common_cap.max_mtu;
+	num_funcs = dev_caps->num_funcs;
 
 	/* unset dev capabilities */
 	memset(dev_caps, 0, sizeof(*dev_caps));
@@ -1919,19 +1923,14 @@ void ice_set_safe_mode_caps(struct ice_hw *hw)
 	dev_caps->common_cap.rxq_first_id = rxq_first_id;
 	dev_caps->common_cap.msix_vector_first_id = msix_vector_first_id;
 	dev_caps->common_cap.max_mtu = max_mtu;
-
-	/* valid_func is a bitmap. get number of functions */
-#define ICE_MAX_FUNCS 8
-	for (i = 0; i < ICE_MAX_FUNCS; i++)
-		if (valid_func & BIT(i))
-			num_func++;
+	dev_caps->num_funcs = num_funcs;
 
 	/* one Tx and one Rx queue per function in safe mode */
-	dev_caps->common_cap.num_rxq = num_func;
-	dev_caps->common_cap.num_txq = num_func;
+	dev_caps->common_cap.num_rxq = num_funcs;
+	dev_caps->common_cap.num_txq = num_funcs;
 
 	/* two MSIX vectors per function */
-	dev_caps->common_cap.num_msix_vectors = 2 * num_func;
+	dev_caps->common_cap.num_msix_vectors = 2 * num_funcs;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index eba8b04b8cbd..c4854a987130 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -202,6 +202,7 @@ struct ice_hw_dev_caps {
 	struct ice_hw_common_caps common_cap;
 	u32 num_vfs_exposed;		/* Total number of VFs exposed */
 	u32 num_vsi_allocd_to_host;	/* Excluding EMP VSI */
+	u32 num_funcs;
 };
 
 /* MAC info */
-- 
2.23.0

