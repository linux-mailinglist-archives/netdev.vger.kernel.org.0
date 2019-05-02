Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DE0115FF
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfEBJG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:47595 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbfEBJGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615337"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:22 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] ice: Resolve static analysis reported issue
Date:   Thu,  2 May 2019 02:06:08 -0700
Message-Id: <20190502090620.21281-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Static analysis points out the default case in the switch statement in
ice_get_itr_intrl_gran() is an infeasible condition causing the default
case statement to be unreachable.  Remove it and since the function no
longer returns anything but success, change it to just return void and
update the only call to it accordingly.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 1d25a4230308..0f1c2267c9d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -647,7 +647,7 @@ void ice_output_fw_log(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf)
  * Determines the itr/intrl granularities based on the maximum aggregate
  * bandwidth according to the device's configuration during power-on.
  */
-static enum ice_status ice_get_itr_intrl_gran(struct ice_hw *hw)
+static void ice_get_itr_intrl_gran(struct ice_hw *hw)
 {
 	u8 max_agg_bw = (rd32(hw, GL_PWR_MODE_CTL) &
 			 GL_PWR_MODE_CTL_CAR_MAX_BW_M) >>
@@ -664,13 +664,7 @@ static enum ice_status ice_get_itr_intrl_gran(struct ice_hw *hw)
 		hw->itr_gran = ICE_ITR_GRAN_MAX_25;
 		hw->intrl_gran = ICE_INTRL_GRAN_MAX_25;
 		break;
-	default:
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Failed to determine itr/intrl granularity\n");
-		return ICE_ERR_CFG;
 	}
-
-	return 0;
 }
 
 /**
@@ -697,9 +691,7 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 	if (status)
 		return status;
 
-	status = ice_get_itr_intrl_gran(hw);
-	if (status)
-		return status;
+	ice_get_itr_intrl_gran(hw);
 
 	status = ice_init_all_ctrlq(hw);
 	if (status)
-- 
2.20.1

