Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C0347E0A8
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 10:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347349AbhLWJDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 04:03:44 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:60854 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbhLWJDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 04:03:43 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 0K0hniYVYS9NT0K0hnoUUg; Thu, 23 Dec 2021 10:03:41 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 23 Dec 2021 10:03:41 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ice: Optimize a few bitmap operations
Date:   Thu, 23 Dec 2021 10:03:37 +0100
Message-Id: <b0cf67c12895e40b403a435192d47b0ac1a00def.1640250120.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a bitmap is local to a function, it is safe to use the non-atomic
__[set|clear]_bit(). No concurrent accesses can occur.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
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
2.32.0

