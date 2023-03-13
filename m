Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9976B8069
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCMSZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjCMSZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB478091D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731919; x=1710267919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NS+4rfGsrp7n/ksVRg9rrxSJlNMgUKSHZuMdnlEknbs=;
  b=AuGnUmTGSc7HXVLfHjF0YkBfgLsp3M5AqL643EDi30rcgYVJ6dwh7gbL
   k/NDkpmS9t8wXhNcEX8zNFG+FSjrPYffV+P58H8vASYZtTt7ppP6dZZ1I
   98lzb12TWEHEEQk+j4+r9SU3mJ8HZgQfkZgjBLayWxzWCIXu2+Pw3La8p
   KQWptSTSTY8+iZ7EW4Grm6cUj83HIDAsjWF0xTI/8P464wUUS9aKeoTrt
   n8jbHUmOmYMz51EFeXc11qXYiT9vhziwV2YZWaZhwz9znnmxqGik6oICq
   dM7bdD5NRu1A8iBzszivJjeVTSxsDk6HBjiWSra0/eBt/ouyw3GtAyYOh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772361"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772361"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:23:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809047"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809047"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:22:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 05/14] ice: remove ice_mbx_deinit_snapshot
Date:   Mon, 13 Mar 2023 11:21:14 -0700
Message-Id: <20230313182123.483057-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
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

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_mbx_deinit_snapshot function's only remaining job is to clear the
previous snapshot data. This snapshot data is initialized when SR-IOV adds
VFs, so it is not necessary to clear this data when removing VFs. Since no
allocation occurs we no longer need to free anything and we can safely
remove this function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c  |  5 +----
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c | 14 --------------
 drivers/net/ethernet/intel/ice/ice_vf_mbx.h |  1 -
 3 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 8820f269bfdf..b65025b51526 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1014,7 +1014,6 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	if (!num_vfs) {
 		if (!pci_vfs_assigned(pdev)) {
 			ice_free_vfs(pf);
-			ice_mbx_deinit_snapshot(&pf->hw);
 			if (pf->lag)
 				ice_enable_lag(pf->lag);
 			return 0;
@@ -1027,10 +1026,8 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	ice_mbx_init_snapshot(&pf->hw);
 
 	err = ice_pci_sriov_ena(pf, num_vfs);
-	if (err) {
-		ice_mbx_deinit_snapshot(&pf->hw);
+	if (err)
 		return err;
-	}
 
 	if (pf->lag)
 		ice_disable_lag(pf->lag);
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
index 4bfed5fb3a88..1f332ab43b00 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
@@ -399,17 +399,3 @@ void ice_mbx_init_snapshot(struct ice_hw *hw)
 	INIT_LIST_HEAD(&snap->mbx_vf);
 	ice_mbx_reset_snapshot(snap);
 }
-
-/**
- * ice_mbx_deinit_snapshot - Free mailbox snapshot structure
- * @hw: pointer to the hardware structure
- *
- * Clear the mailbox snapshot structure and free the VF counter array.
- */
-void ice_mbx_deinit_snapshot(struct ice_hw *hw)
-{
-	struct ice_mbx_snapshot *snap = &hw->mbx_snapshot;
-
-	/* Clear mbx_buf in the mailbox snaphot structure */
-	memset(&snap->mbx_buf, 0, sizeof(snap->mbx_buf));
-}
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.h b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
index a6d42f467dc5..e4bdd93ccef1 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
@@ -25,7 +25,6 @@ ice_mbx_vf_state_handler(struct ice_hw *hw, struct ice_mbx_data *mbx_data,
 void ice_mbx_clear_malvf(struct ice_mbx_vf_info *vf_info);
 void ice_mbx_init_vf_info(struct ice_hw *hw, struct ice_mbx_vf_info *vf_info);
 void ice_mbx_init_snapshot(struct ice_hw *hw);
-void ice_mbx_deinit_snapshot(struct ice_hw *hw);
 int
 ice_mbx_report_malvf(struct ice_hw *hw, struct ice_mbx_vf_info *vf_info,
 		     bool *report_malvf);
-- 
2.38.1

