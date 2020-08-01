Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EE223533D
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgHAQSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:19610 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgHAQSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:08 -0400
IronPort-SDR: 4Gu0jqXm1BhrTDwRP0awhG/VOrDTtsuXrP0ryDsE71jtSejm8rXQYT2b+n4icJjNaa/hJLUz8c
 J+Ua3ZBoILIg==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810843"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810843"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:07 -0700
IronPort-SDR: Jgo05PbHH0jjWtRw5ywWI//2gfrhkU4QqB2pO3/i3+UIWC4HraTe2oT4KAKdGKI0IXL66ksvb8
 AoRdZB1QMttA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457692"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Nick Nunley <nicholas.d.nunley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 02/14] ice: rename misleading grst_delay variable
Date:   Sat,  1 Aug 2020 09:17:50 -0700
Message-Id: <20200801161802.867645-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Nunley <nicholas.d.nunley@intel.com>

The grst_delay variable in ice_check_reset contains the maximum time
(in 100 msec units) that the driver will wait for a reset event to
transition to the Device Active state. The value is the sum of three
separate components:
1) The maximum time it may take for the firmware to process its
outstanding command before handling the reset request.
2) The value in RSTCTL.GRSTDEL (the delay firmware inserts between first
seeing the driver reset request and the actual hardware assertion).
3) The maximum expected reset processing time in hardware.

Referring to this total time as "grst_delay" is misleading and
potentially confusing to someone checking the code and cross-referencing
the hardware specification.

Fix this by renaming the variable to "grst_timeout", which is more
descriptive of its actual use.

Signed-off-by: Nick Nunley <nicholas.d.nunley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index ad5941ec7b11..8a93fbd6f1be 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1027,23 +1027,23 @@ void ice_deinit_hw(struct ice_hw *hw)
  */
 enum ice_status ice_check_reset(struct ice_hw *hw)
 {
-	u32 cnt, reg = 0, grst_delay, uld_mask;
+	u32 cnt, reg = 0, grst_timeout, uld_mask;
 
 	/* Poll for Device Active state in case a recent CORER, GLOBR,
 	 * or EMPR has occurred. The grst delay value is in 100ms units.
 	 * Add 1sec for outstanding AQ commands that can take a long time.
 	 */
-	grst_delay = ((rd32(hw, GLGEN_RSTCTL) & GLGEN_RSTCTL_GRSTDEL_M) >>
-		      GLGEN_RSTCTL_GRSTDEL_S) + 10;
+	grst_timeout = ((rd32(hw, GLGEN_RSTCTL) & GLGEN_RSTCTL_GRSTDEL_M) >>
+			GLGEN_RSTCTL_GRSTDEL_S) + 10;
 
-	for (cnt = 0; cnt < grst_delay; cnt++) {
+	for (cnt = 0; cnt < grst_timeout; cnt++) {
 		mdelay(100);
 		reg = rd32(hw, GLGEN_RSTAT);
 		if (!(reg & GLGEN_RSTAT_DEVSTATE_M))
 			break;
 	}
 
-	if (cnt == grst_delay) {
+	if (cnt == grst_timeout) {
 		ice_debug(hw, ICE_DBG_INIT,
 			  "Global reset polling failed to complete.\n");
 		return ICE_ERR_RESET_FAILED;
-- 
2.26.2

