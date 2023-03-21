Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AE16C3949
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCUSih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjCUSid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:38:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD70CC22
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679423912; x=1710959912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sFgW2NRAsdEHRlmsh72AKJpZqKrn0zK9cXiWRykbQ5g=;
  b=m/yxarZkJnVnfpXS1WdW3FJq8sY3gvYgrwS0FIBHVK/AlYIwwTSGiDoJ
   J/8834giG/T4xYFXkHhKRxdicPxA4pL0kgfdJYJXPdM4b+hxWfLQa1bYB
   2HdaczvK5XyxcilP0QFSjXY5zcg+E7xgUHM8ZulvIVtysoCe0t3wYB32+
   PBL9oWq9WK6OO9zCqwKHe/wjfsyypPbGDNnPnx46q6h867mp7rThiYCms
   GEVxraR7GGWvwRdCoGh5kjGtHOpJNoXpRwCwLbOMs+q5ulKxrM4f9weWz
   hPTaAJ0l7/EZ5LGh5yqYiUOvugAVUioK9FCvNtf1GcSigHP3cgYL0o9St
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="339067636"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="339067636"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 11:38:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="684001768"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="684001768"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 21 Mar 2023 11:38:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        anthony.l.nguyen@intel.com,
        Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net 3/3] ice: remove filters only if VSI is deleted
Date:   Tue, 21 Mar 2023 11:36:41 -0700
Message-Id: <20230321183641.2849726-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230321183641.2849726-1-anthony.l.nguyen@intel.com>
References: <20230321183641.2849726-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Filters shouldn't be removed in VSI rebuild path. Removing them on PF
VSI results in no rule for PF MAC after changing for example queues
amount.

Remove all filters only in the VSI remove flow. As unload should also
cause the filter to be removed introduce, a new function ice_stop_eth().
It will unroll ice_start_eth(), so remove filters and close VSI.

Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 0f52ea38b6f3..450317dfcca7 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -291,6 +291,7 @@ static void ice_vsi_delete_from_hw(struct ice_vsi *vsi)
 	struct ice_vsi_ctx *ctxt;
 	int status;
 
+	ice_fltr_remove_all(vsi);
 	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
 	if (!ctxt)
 		return;
@@ -2892,7 +2893,6 @@ void ice_vsi_decfg(struct ice_vsi *vsi)
 	    !test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
 		ice_cfg_sw_lldp(vsi, false, false);
 
-	ice_fltr_remove_all(vsi);
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
 	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
 	if (err)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c233464b8f6b..0d8b8c6f9bd3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4641,6 +4641,12 @@ static int ice_start_eth(struct ice_vsi *vsi)
 	return err;
 }
 
+static void ice_stop_eth(struct ice_vsi *vsi)
+{
+	ice_fltr_remove_all(vsi);
+	ice_vsi_close(vsi);
+}
+
 static int ice_init_eth(struct ice_pf *pf)
 {
 	struct ice_vsi *vsi = ice_get_main_vsi(pf);
@@ -5129,7 +5135,7 @@ void ice_unload(struct ice_pf *pf)
 {
 	ice_deinit_features(pf);
 	ice_deinit_rdma(pf);
-	ice_vsi_close(ice_get_main_vsi(pf));
+	ice_stop_eth(ice_get_main_vsi(pf));
 	ice_vsi_decfg(ice_get_main_vsi(pf));
 	ice_deinit_dev(pf);
 }
-- 
2.38.1

