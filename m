Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA728F0B34
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 01:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbfKFAqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 19:46:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:56513 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730613AbfKFAqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 19:46:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 16:46:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="403554747"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 05 Nov 2019 16:46:23 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] ice: Adjust DCB INIT for SW mode
Date:   Tue,  5 Nov 2019 16:46:12 -0800
Message-Id: <20191106004620.10416-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191106004620.10416-1-jeffrey.t.kirsher@intel.com>
References: <20191106004620.10416-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Adjust ice_init_dcb to set the is_sw_lldp boolean
in the case where the FW has been detected to be
in an untenable state such that the driver
should forcibly make sure it is off.

This will ensure that the FW is in a known state.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index dd7efff121bd..713e8a892e14 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -965,9 +965,9 @@ enum ice_status ice_init_dcb(struct ice_hw *hw, bool enable_mib_change)
 	    pi->dcbx_status == ICE_DCBX_STATUS_NOT_STARTED) {
 		/* Get current DCBX configuration */
 		ret = ice_get_dcb_cfg(pi);
-		pi->is_sw_lldp = (hw->adminq.sq_last_status == ICE_AQ_RC_EPERM);
 		if (ret)
 			return ret;
+		pi->is_sw_lldp = false;
 	} else if (pi->dcbx_status == ICE_DCBX_STATUS_DIS) {
 		return ICE_ERR_NOT_READY;
 	}
@@ -975,8 +975,8 @@ enum ice_status ice_init_dcb(struct ice_hw *hw, bool enable_mib_change)
 	/* Configure the LLDP MIB change event */
 	if (enable_mib_change) {
 		ret = ice_aq_cfg_lldp_mib_change(hw, true, NULL);
-		if (!ret)
-			pi->is_sw_lldp = false;
+		if (ret)
+			pi->is_sw_lldp = true;
 	}
 
 	return ret;
-- 
2.21.0

