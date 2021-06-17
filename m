Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79FE3ABA1E
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhFQRBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:01:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:63638 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhFQRBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:01:17 -0400
IronPort-SDR: v0NFRe8hZ6DHHlBk2Ldsnx3RPa4A+zX9Md6Z+O8cXvsnwdrGG4Dm+Bfr9YnCIOddcmQxeQ0/D4
 Dr5KAC++XTFA==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="193723058"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="193723058"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 09:59:05 -0700
IronPort-SDR: 9JEAF+MzQ8/GelaM2wBKlDkefsQJlH7jlDLD97AG469jGxpTShqTN2l478oAJo9X/PKLGx627M
 FLPqiF79TOnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="404706810"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 17 Jun 2021 09:59:04 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 6/8] ice: remove unnecessary NULL checks before ptp_read_system_*
Date:   Thu, 17 Jun 2021 10:01:43 -0700
Message-Id: <20210617170145.4092904-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
References: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ptp_read_system_prets and ptp_read_system_postts functions already
check for the NULL value of the ptp_system_timestamp structure pointer.
There is no need to check this manually in the ice driver code. Remove
the checks.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
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
 
-- 
2.26.2

