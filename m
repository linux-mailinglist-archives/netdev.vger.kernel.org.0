Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB2C4D8B72
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243656AbiCNSL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243625AbiCNSLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81F63F893
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281403; x=1678817403;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=303pLXjqGnbNv5BYacaMwKCi3qUynPavnvTcN8UTCyg=;
  b=ephAI9v1NZwRUEVtouCZRk6D+OAC24fOoKts7yjUyN/94YHePxhe5QrO
   ba+ZKorwaQMvwxTeEoFs6ZMceV7WTAwTq3WGxL5xuUHDwAlRWr29TNW8H
   eZdZ8cBxPm5oY/bLYofk2iR37PvNdD736Z6kQ9fVVsLoPCZO8RjRViBRW
   IzjtRIAFry8fxPjmoc/lLp7/mIyRQC2dHSuYU8LI664dtfW4ECBFV1n2/
   rAbQrQxlMK3TwRNvlT4QeO/CVhe3+yIHcfIwxBmquLh+R7kjBTt53scDN
   mBgJa1aFBLi/s+3EK9MdP3p7XYfUDLpjPXipoMlO7LFs/rxV5c973DsIG
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275396"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275396"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:10:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297682"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:10:01 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 17/25] ice: drop is_vflr parameter from ice_reset_all_vfs
Date:   Mon, 14 Mar 2022 11:10:08 -0700
Message-Id: <20220314181016.1690595-18-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
References: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_reset_all_vfs function takes a parameter to handle whether its
operating after a VFLR event or not. This is not necessary as every
caller always passes true. Simplify the interface by removing the
parameter.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c   | 4 ++--
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 5 ++---
 drivers/net/ethernet/intel/ice/ice_vf_lib.h | 4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 416914452ece..3cec52b09c6d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -634,7 +634,7 @@ static void ice_do_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 		clear_bit(ICE_PREPARED_FOR_RESET, pf->state);
 		clear_bit(ICE_PFR_REQ, pf->state);
 		wake_up(&pf->reset_wait_queue);
-		ice_reset_all_vfs(pf, true);
+		ice_reset_all_vfs(pf);
 	}
 }
 
@@ -685,7 +685,7 @@ static void ice_reset_subtask(struct ice_pf *pf)
 			clear_bit(ICE_CORER_REQ, pf->state);
 			clear_bit(ICE_GLOBR_REQ, pf->state);
 			wake_up(&pf->reset_wait_queue);
-			ice_reset_all_vfs(pf, true);
+			ice_reset_all_vfs(pf);
 		}
 
 		return;
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 282be49dbfed..996d84a3303d 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -356,7 +356,6 @@ ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
 /**
  * ice_reset_all_vfs - reset all allocated VFs in one go
  * @pf: pointer to the PF structure
- * @is_vflr: true if VFLR was issued, false if not
  *
  * First, tell the hardware to reset each VF, then do all the waiting in one
  * chunk, and finally finish restoring each VF after the wait. This is useful
@@ -365,7 +364,7 @@ ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
  *
  * Returns true if any VFs were reset, and false otherwise.
  */
-bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
+bool ice_reset_all_vfs(struct ice_pf *pf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
@@ -393,7 +392,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 
 	/* Begin reset on all VFs at once */
 	ice_for_each_vf(pf, bkt, vf)
-		ice_trigger_vf_reset(vf, is_vflr, true);
+		ice_trigger_vf_reset(vf, true, true);
 
 	/* HW requires some time to make sure it can flush the FIFO for a VF
 	 * when it resets it. Now that we've triggered all of the VFs, iterate
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index e3f4c3d88d27..69c6eba408f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -213,7 +213,7 @@ ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m);
 int
 ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m);
 bool ice_reset_vf(struct ice_vf *vf, bool is_vflr);
-bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr);
+bool ice_reset_all_vfs(struct ice_pf *pf);
 #else /* CONFIG_PCI_IOV */
 static inline struct ice_vf *ice_get_vf_by_id(struct ice_pf *pf, u16 vf_id)
 {
@@ -275,7 +275,7 @@ static inline bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	return true;
 }
 
-static inline bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
+static inline bool ice_reset_all_vfs(struct ice_pf *pf)
 {
 	return true;
 }
-- 
2.31.1

