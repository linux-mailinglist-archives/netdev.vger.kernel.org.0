Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79FE23229A
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgG2QYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:42161 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgG2QYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:16 -0400
IronPort-SDR: I24Xyi5clwdYVxcgBpD+Y3ytgoK98sFClPFuunmbqAXuxPhyXMEFdM2Xxt//O4+JtxDaQWzo9/
 saIA9snjy3uQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982333"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982333"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:14 -0700
IronPort-SDR: ZdoQYX8z4Mqh9nNlbKtvOXIxFa8cpGeSrvYunWXq/MBZquAEPoKLqFRjikLabNRKUIRpAl4tEA
 fsJiabMU6S9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087572"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:14 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tarun Singh <tarun.k.singh@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 07/15] ice: Add RL profile bit mask check
Date:   Wed, 29 Jul 2020 09:23:57 -0700
Message-Id: <20200729162405.1596435-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tarun Singh <tarun.k.singh@intel.com>

Mask bits before accessing the profile type field.

Signed-off-by: Tarun Singh <tarun.k.singh@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 1c29cfa1cf33..ac5b05bb978f 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -2153,8 +2153,8 @@ ice_sched_add_rl_profile(struct ice_port_info *pi,
 	hw = pi->hw;
 	list_for_each_entry(rl_prof_elem, &pi->rl_prof_list[layer_num],
 			    list_entry)
-		if (rl_prof_elem->profile.flags == profile_type &&
-		    rl_prof_elem->bw == bw)
+		if ((rl_prof_elem->profile.flags & ICE_AQC_RL_PROFILE_TYPE_M) ==
+		    profile_type && rl_prof_elem->bw == bw)
 			/* Return existing profile ID info */
 			return rl_prof_elem;
 
@@ -2384,7 +2384,8 @@ ice_sched_rm_rl_profile(struct ice_port_info *pi, u8 layer_num, u8 profile_type,
 	/* Check the existing list for RL profile */
 	list_for_each_entry(rl_prof_elem, &pi->rl_prof_list[layer_num],
 			    list_entry)
-		if (rl_prof_elem->profile.flags == profile_type &&
+		if ((rl_prof_elem->profile.flags & ICE_AQC_RL_PROFILE_TYPE_M) ==
+		    profile_type &&
 		    le16_to_cpu(rl_prof_elem->profile.profile_id) ==
 		    profile_id) {
 			if (rl_prof_elem->prof_id_ref)
@@ -2546,8 +2547,8 @@ ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
 		return 0;
 
 	return ice_sched_rm_rl_profile(pi, layer_num,
-				       rl_prof_info->profile.flags,
-				       old_id);
+				       rl_prof_info->profile.flags &
+				       ICE_AQC_RL_PROFILE_TYPE_M, old_id);
 }
 
 /**
-- 
2.26.2

