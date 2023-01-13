Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F1D66A53E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 22:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjAMVmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 16:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjAMVmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 16:42:21 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FD310B5D
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 13:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673646140; x=1705182140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v2T2QhvMEAvvNiTWWHKC3mDqpCY5hVG9AX7jUK+UBIE=;
  b=R8F7oFmpXF1K5YWBWOvhLDMeedVFvCmr/dE2ai4ufCtQLA6Wkg1N7MpE
   H4NvGDkvYgaDv+OOL4aLyKGcmrtxDXLv2T35Fz6IJnsb/KNTyQeJA2+xv
   /2Q3OKaJmCdpWmNTWFPOMUAIRg+7BiduMEEbXh2zgvkA5cmQzmW5I46Lm
   FpyndKFrpOgb1fY20xHMknkOyEwE/jb82hePHbjIytWxVYDpXitI14wDf
   AsGPwmW5qNSYynDQEodowzj5i7EX5405Z5UqoRO5W3u2xI9WV7pfv4B4j
   4WCuVp6QFviE565N6P5AADxpv9EH8BWe7slNr4EaGMILtmc0+VswCmSEI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="351341465"
X-IronPort-AV: E=Sophos;i="5.97,214,1669104000"; 
   d="scan'208";a="351341465"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 13:42:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="690629644"
X-IronPort-AV: E=Sophos;i="5.97,214,1669104000"; 
   d="scan'208";a="690629644"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 13 Jan 2023 13:42:20 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sebastian Czapla <sebastianx.czapla@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 2/2] ixgbe: Filter out spurious link up indication
Date:   Fri, 13 Jan 2023 13:42:48 -0800
Message-Id: <20230113214248.970670-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113214248.970670-1-anthony.l.nguyen@intel.com>
References: <20230113214248.970670-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Czapla <sebastianx.czapla@intel.com>

Add delayed link state recheck to filter false link up indication
caused by transceiver with no fiber cable attached.

Signed-off-by: Sebastian Czapla <sebastianx.czapla@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ixgbe/ixgbe_common.c   | 21 ++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 38c4609bd429..878dd8dff528 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -3292,13 +3292,14 @@ static bool ixgbe_need_crosstalk_fix(struct ixgbe_hw *hw)
 s32 ixgbe_check_mac_link_generic(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
 				 bool *link_up, bool link_up_wait_to_complete)
 {
+	bool crosstalk_fix_active = ixgbe_need_crosstalk_fix(hw);
 	u32 links_reg, links_orig;
 	u32 i;
 
 	/* If Crosstalk fix enabled do the sanity check of making sure
 	 * the SFP+ cage is full.
 	 */
-	if (ixgbe_need_crosstalk_fix(hw)) {
+	if (crosstalk_fix_active) {
 		u32 sfp_cage_full;
 
 		switch (hw->mac.type) {
@@ -3346,10 +3347,24 @@ s32 ixgbe_check_mac_link_generic(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
 			links_reg = IXGBE_READ_REG(hw, IXGBE_LINKS);
 		}
 	} else {
-		if (links_reg & IXGBE_LINKS_UP)
+		if (links_reg & IXGBE_LINKS_UP) {
+			if (crosstalk_fix_active) {
+				/* Check the link state again after a delay
+				 * to filter out spurious link up
+				 * notifications.
+				 */
+				mdelay(5);
+				links_reg = IXGBE_READ_REG(hw, IXGBE_LINKS);
+				if (!(links_reg & IXGBE_LINKS_UP)) {
+					*link_up = false;
+					*speed = IXGBE_LINK_SPEED_UNKNOWN;
+					return 0;
+				}
+			}
 			*link_up = true;
-		else
+		} else {
 			*link_up = false;
+		}
 	}
 
 	switch (links_reg & IXGBE_LINKS_SPEED_82599) {
-- 
2.38.1

