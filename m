Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60F24869F5
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242890AbiAFSbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 13:31:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:21739 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242864AbiAFSbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 13:31:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641493867; x=1673029867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6k11PvOvOL11/U4VdkdqO86ii4P8cCaure3VsGoBOVg=;
  b=TlsvxYkwbGXsJIMNOGoJHlOe2DS71JyoKli6M86RXShVSGGnN9AYWtv/
   qgR+24CRcNLk1s4heOt7zUlUjUdca+xz3ahbSwibtdlVCjkStytCnPKou
   0F5FUcgRTMt7ZCWGEU6WYzSCJXszvSWeScAHysSK04vxApoxDsoX+kjGb
   C72lvloCtnRqkk0jJZJgBJLC2SeWDoYoQyDXAsvhcBbKbR/z4Q8h7nRKB
   87eOnUKHRzYmmTvtRcCg2evuL9N1XCG85wGTuHazdjYXukujWY7qenqJR
   k//ZB+POBOD68B0pie9u40uGkS0VSbAQgwGXAxviEruxwT2xMB/1J/aQd
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242666614"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="242666614"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 10:30:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="489024743"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 06 Jan 2022 10:30:50 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/5] ice: Optimize a few bitmap operations
Date:   Thu,  6 Jan 2022 10:30:12 -0800
Message-Id: <20220106183013.3777622-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220106183013.3777622-1-anthony.l.nguyen@intel.com>
References: <20220106183013.3777622-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

When a bitmap is local to a function, it is safe to use the non-atomic
__[set|clear]_bit(). No concurrent accesses can occur.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index d29197ab3d02..4deb2c9446ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -4440,7 +4440,7 @@ ice_update_fd_swap(struct ice_hw *hw, u16 prof_id, struct ice_fv_word *es)
 		for (j = 0; j < ICE_FD_SRC_DST_PAIR_COUNT; j++)
 			if (es[i].prot_id == ice_fd_pairs[j].prot_id &&
 			    es[i].off == ice_fd_pairs[j].off) {
-				set_bit(j, pair_list);
+				__set_bit(j, pair_list);
 				pair_start[j] = i;
 			}
 	}
@@ -4710,7 +4710,7 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 			if (test_bit(ptg, ptgs_used))
 				continue;
 
-			set_bit(ptg, ptgs_used);
+			__set_bit(ptg, ptgs_used);
 			/* Check to see there are any attributes for
 			 * this PTYPE, and add them if found.
 			 */
@@ -5339,7 +5339,7 @@ ice_adj_prof_priorities(struct ice_hw *hw, enum ice_block blk, u16 vsig,
 			}
 
 			/* keep track of used ptgs */
-			set_bit(t->tcam[i].ptg, ptgs_used);
+			__set_bit(t->tcam[i].ptg, ptgs_used);
 		}
 	}
 
-- 
2.31.1

