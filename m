Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9203B4907
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhFYS5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:57:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:14426 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhFYS5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 14:57:05 -0400
IronPort-SDR: U1VIfka2rR9QVIM7jtYSgihAzFR5NcHg9/hFmZGzlCQidA3B4SuYuLu0xIpip8V3ia30PGjVuX
 k/QFG+JUub0Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="229326800"
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="229326800"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 11:54:43 -0700
IronPort-SDR: iU7G5kvERDJyWV+c/vxAHUtvHwQqLKvZjrXzQIwRHrwzu8cJ+iZMbcS/IcP+j7gw4JThfV2cih
 7aSpT0B2Yssw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="491655931"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jun 2021 11:54:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Victor Raj <victor.raj@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 3/5] ice: remove the VSI info from previous agg
Date:   Fri, 25 Jun 2021 11:57:31 -0700
Message-Id: <20210625185733.1848704-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
References: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Victor Raj <victor.raj@intel.com>

Remove the VSI info from previous aggregator after moving the VSI to a
new aggregator.

Signed-off-by: Victor Raj <victor.raj@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 24 ++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index a17e24e54cf3..9f07b6641705 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -2745,8 +2745,8 @@ static enum ice_status
 ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 			   u16 vsi_handle, unsigned long *tc_bitmap)
 {
-	struct ice_sched_agg_vsi_info *agg_vsi_info;
-	struct ice_sched_agg_info *agg_info;
+	struct ice_sched_agg_vsi_info *agg_vsi_info, *old_agg_vsi_info = NULL;
+	struct ice_sched_agg_info *agg_info, *old_agg_info;
 	enum ice_status status = 0;
 	struct ice_hw *hw = pi->hw;
 	u8 tc;
@@ -2756,6 +2756,20 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 	agg_info = ice_get_agg_info(hw, agg_id);
 	if (!agg_info)
 		return ICE_ERR_PARAM;
+	/* If the VSI is already part of another aggregator then update
+	 * its VSI info list
+	 */
+	old_agg_info = ice_get_vsi_agg_info(hw, vsi_handle);
+	if (old_agg_info && old_agg_info != agg_info) {
+		struct ice_sched_agg_vsi_info *vtmp;
+
+		list_for_each_entry_safe(old_agg_vsi_info, vtmp,
+					 &old_agg_info->agg_vsi_list,
+					 list_entry)
+			if (old_agg_vsi_info->vsi_handle == vsi_handle)
+				break;
+	}
+
 	/* check if entry already exist */
 	agg_vsi_info = ice_get_agg_vsi_info(agg_info, vsi_handle);
 	if (!agg_vsi_info) {
@@ -2780,6 +2794,12 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 			break;
 
 		set_bit(tc, agg_vsi_info->tc_bitmap);
+		if (old_agg_vsi_info)
+			clear_bit(tc, old_agg_vsi_info->tc_bitmap);
+	}
+	if (old_agg_vsi_info && !old_agg_vsi_info->tc_bitmap[0]) {
+		list_del(&old_agg_vsi_info->list_entry);
+		devm_kfree(ice_hw_to_dev(pi->hw), old_agg_vsi_info);
 	}
 	return status;
 }
-- 
2.26.2

