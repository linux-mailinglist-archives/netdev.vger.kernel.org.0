Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B39674511
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjASVme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjASVji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B84E9F3A4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163687; x=1705699687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xv0xf3LBw7YFLR1HyampHitjJj/K+BcM09TKB9BZOaY=;
  b=TLQ8WBPbFejce+CEXyjCWrCPpexM2zxrrecKFqURglCHhKbReufgYd2h
   2gTLFa8nBs4Pgs/621+aGy8C6gCigAxF/7aC2l6iHv4GXKk5Tyq94ee//
   1P+L5Ptqq33gx7sci1C4gXJb8kGWwddSEz8i68RCp1nqNuvkcnu/R5xJm
   /ENzbzmKUhJenRHq6sENUZAtu/jjMk20NwRO7xaFVRHRF48tRvV6JWeS5
   6Z5MXGf+c1wK0g/GfteSv19im5LqTMP94FIZFwWR2dGzUzT2HVtSer6wE
   OHj8j0zc5IDdkK7rOtV+h0JWfAnMiInXtr4wx/7gZhfhmx1Iwbt/grGHI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120624"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120624"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589883"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589883"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 06/15] ice: add missing checks for PF vsi type
Date:   Thu, 19 Jan 2023 13:27:33 -0800
Message-Id: <20230119212742.2106833-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

There were a few places we had missed checking the VSI type to make sure
it was definitely a PF VSI, before calling setup functions intended only
for the PF VSI.

This doesn't fix any explicit bugs but cleans up the code in a few
places and removes one explicit != vsi->type check that can be
superseded by this code (it's a super set)

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d3ebfaf5a04b..c6d57f316429 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6144,15 +6144,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
 {
 	int err;
 
-	if (vsi->netdev) {
+	if (vsi->netdev && vsi->type == ICE_VSI_PF) {
 		ice_set_rx_mode(vsi->netdev);
 
-		if (vsi->type != ICE_VSI_LB) {
-			err = ice_vsi_vlan_setup(vsi);
-
-			if (err)
-				return err;
-		}
+		err = ice_vsi_vlan_setup(vsi);
+		if (err)
+			return err;
 	}
 	ice_vsi_cfg_dcb_rings(vsi);
 
@@ -6333,7 +6330,7 @@ static int ice_up_complete(struct ice_vsi *vsi)
 
 	if (vsi->port_info &&
 	    (vsi->port_info->phy.link_info.link_info & ICE_AQ_LINK_UP) &&
-	    vsi->netdev) {
+	    vsi->netdev && vsi->type == ICE_VSI_PF) {
 		ice_print_link_msg(vsi, true);
 		netif_tx_start_all_queues(vsi->netdev);
 		netif_carrier_on(vsi->netdev);
@@ -6344,7 +6341,9 @@ static int ice_up_complete(struct ice_vsi *vsi)
 	 * set the baseline so counters are ready when interface is up
 	 */
 	ice_update_eth_stats(vsi);
-	ice_service_task_schedule(pf);
+
+	if (vsi->type == ICE_VSI_PF)
+		ice_service_task_schedule(pf);
 
 	return 0;
 }
-- 
2.38.1

