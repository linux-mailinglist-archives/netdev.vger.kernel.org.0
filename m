Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595633A6C8D
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 18:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbhFNRBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 13:01:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:64907 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233606AbhFNRBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 13:01:30 -0400
IronPort-SDR: ErHoNXL0X6P7JUr1bOtHlsmYBUovRXGBFAcapMVPvpIYavlKuywr3OtzYajU3GYHcRpdRXcSBJ
 RpqBdu5wnf5A==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="205662780"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="205662780"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 09:59:26 -0700
IronPort-SDR: Hb0QNbkD4TYfSdvYZN4sBTvGWaIgOK3TUlo+2C7zP5HOwRm4Gx3SbB3EmDEZNTIKei4oCO4qty
 gvHbmIL6TTMQ==
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="403707909"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 09:59:25 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] ice: remove unnecessary NULL checks before ptp_read_system_*
Date:   Mon, 14 Jun 2021 09:59:16 -0700
Message-Id: <20210614165916.1403027-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ptp_read_system_prets and ptp_read_system_postts functions already
check for the NULL value of the ptp_system_timestamp structure pointer.
There is no need to check this manually in the ice driver code. Remove
the checks.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index e14f81321768..609f433a4b96 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -219,14 +219,12 @@ ice_ptp_read_src_clk_reg(struct ice_pf *pf, struct ptp_system_timestamp *sts)
 
 	tmr_idx = ice_get_ptp_src_clock_index(hw);
 	/* Read the system timestamp pre PHC read */
-	if (sts)
-		ptp_read_system_prets(sts);
+	ptp_read_system_prets(sts);
 
 	lo = rd32(hw, GLTSYN_TIME_L(tmr_idx));
 
 	/* Read the system timestamp post PHC read */
-	if (sts)
-		ptp_read_system_postts(sts);
+	ptp_read_system_postts(sts);
 
 	hi = rd32(hw, GLTSYN_TIME_H(tmr_idx));
 	lo2 = rd32(hw, GLTSYN_TIME_L(tmr_idx));
@@ -235,11 +233,9 @@ ice_ptp_read_src_clk_reg(struct ice_pf *pf, struct ptp_system_timestamp *sts)
 		/* if TIME_L rolled over read TIME_L again and update
 		 * system timestamps
 		 */
-		if (sts)
-			ptp_read_system_prets(sts);
+		ptp_read_system_prets(sts);
 		lo = rd32(hw, GLTSYN_TIME_L(tmr_idx));
-		if (sts)
-			ptp_read_system_postts(sts);
+		ptp_read_system_postts(sts);
 		hi = rd32(hw, GLTSYN_TIME_H(tmr_idx));
 	}
 

base-commit: a212d9f33ed0b8399bd9829a779c4024068742a2
-- 
2.31.1.331.gb0c09ab8796f

