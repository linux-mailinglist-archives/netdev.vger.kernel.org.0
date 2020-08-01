Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72D8235348
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgHAQSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:19604 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgHAQSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:10 -0400
IronPort-SDR: tNny+zuBFlvJdubsl+6EetpxRnr3eZ3SN3Vj8+CjuynZnSKRRhLvC0kxsd4ik6cKUeDiQE++7c
 dCkJfOFg6aVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810848"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810848"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:07 -0700
IronPort-SDR: v4KROE2nEOo2EadpsXsiH4IRLi9I0FuT1ghJYADeYZZpSHdtRD4vGImDLJbeJYnUaoOaUBjn1+
 7fZ3fxIWNPrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457699"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vignesh Sridhar <vignesh.sridhar@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 04/14] ice: Fix RSS profile locks
Date:   Sat,  1 Aug 2020 09:17:52 -0700
Message-Id: <20200801161802.867645-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vignesh Sridhar <vignesh.sridhar@intel.com>

Replacing flow profile locks with RSS profile locks in the function to
remove all RSS rules for a given VSI. This is to align the locks used
for RSS rule addition to VSI and removal during VSI teardown to avoid
a race condition owing to several iterations of the above operations.
In function to get RSS rules for given VSI and protocol header replacing
the pointer reference of the RSS entry with a copy of hash value to
ensure thread safety.

Signed-off-by: Vignesh Sridhar <vignesh.sridhar@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flow.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index d74e5290677f..fe677621dd51 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -1187,7 +1187,7 @@ enum ice_status ice_rem_vsi_rss_cfg(struct ice_hw *hw, u16 vsi_handle)
 	if (list_empty(&hw->fl_profs[blk]))
 		return 0;
 
-	mutex_lock(&hw->fl_profs_locks[blk]);
+	mutex_lock(&hw->rss_locks);
 	list_for_each_entry_safe(p, t, &hw->fl_profs[blk], l_entry)
 		if (test_bit(vsi_handle, p->vsis)) {
 			status = ice_flow_disassoc_prof(hw, blk, p, vsi_handle);
@@ -1195,12 +1195,12 @@ enum ice_status ice_rem_vsi_rss_cfg(struct ice_hw *hw, u16 vsi_handle)
 				break;
 
 			if (bitmap_empty(p->vsis, ICE_MAX_VSI)) {
-				status = ice_flow_rem_prof_sync(hw, blk, p);
+				status = ice_flow_rem_prof(hw, blk, p->id);
 				if (status)
 					break;
 			}
 		}
-	mutex_unlock(&hw->fl_profs_locks[blk]);
+	mutex_unlock(&hw->rss_locks);
 
 	return status;
 }
@@ -1597,7 +1597,8 @@ enum ice_status ice_replay_rss_cfg(struct ice_hw *hw, u16 vsi_handle)
  */
 u64 ice_get_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u32 hdrs)
 {
-	struct ice_rss_cfg *r, *rss_cfg = NULL;
+	u64 rss_hash = ICE_HASH_INVALID;
+	struct ice_rss_cfg *r;
 
 	/* verify if the protocol header is non zero and VSI is valid */
 	if (hdrs == ICE_FLOW_SEG_HDR_NONE || !ice_is_vsi_valid(hw, vsi_handle))
@@ -1607,10 +1608,10 @@ u64 ice_get_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u32 hdrs)
 	list_for_each_entry(r, &hw->rss_list_head, l_entry)
 		if (test_bit(vsi_handle, r->vsis) &&
 		    r->packet_hdr == hdrs) {
-			rss_cfg = r;
+			rss_hash = r->hashed_flds;
 			break;
 		}
 	mutex_unlock(&hw->rss_locks);
 
-	return rss_cfg ? rss_cfg->hashed_flds : ICE_HASH_INVALID;
+	return rss_hash;
 }
-- 
2.26.2

