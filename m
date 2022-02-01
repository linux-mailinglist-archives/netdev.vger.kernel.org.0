Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A5D4A53B9
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiBAAFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:05:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:8412 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbiBAAFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 19:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643673938; x=1675209938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b1ekPsjQ8T1ginKITxL+KF1t3aY6L2kATiH1QZWne8U=;
  b=d8KE3tXN6jmJQkNtkOoILEIzaFFhOiRArrBMggAKy407lr0YmF08QWh3
   4YN0HeOBmyTG2UpCiaBKhaet90X7kyXGAcq2K7ZYUTWvm6t+fuwwUwV2m
   eCxHlq5oohIebZMlAx4Ofn1xFSbI4Bzrs5H1yUKOw7viJLwIRSn+0Z+fL
   CIALrIsjuTI3UL/NO7VTeZSPVXowhscCVi0vwEbsB+5XRdKvsvC4Yraaa
   FOr9CyRkx6PyPrMpCBAwsolm8aCdqA1lIZRHWexefPQZbtlNhGVNPdO3L
   xBwjHDNp3m/sOgM46gOt2G3/IknKJb53yI8/CW6yiwZ9L8Bdn+OVw8EST
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="234975876"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="234975876"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 16:05:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="698209561"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 31 Jan 2022 16:05:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Slawomir Laba <slawomirx.laba@intel.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 2/2] i40e: Fix reset path while removing the driver
Date:   Mon, 31 Jan 2022 16:05:22 -0800
Message-Id: <20220201000522.505909-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220201000522.505909-1-anthony.l.nguyen@intel.com>
References: <20220201000522.505909-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

Fix the crash in kernel while dereferencing the NULL pointer,
when the driver is unloaded and simultaneously the VSI rings
are being stopped.

The hardware requires 50msec in order to finish RX queues
disable. For this purpose the driver spins in mdelay function
for the operation to be completed.

For example changing number of queues which requires reset would
fail in the following call stack:

1) i40e_prep_for_reset
2) i40e_pf_quiesce_all_vsi
3) i40e_quiesce_vsi
4) i40e_vsi_close
5) i40e_down
6) i40e_vsi_stop_rings
7) i40e_vsi_control_rx -> disable requires the delay of 50msecs
8) continue back in i40e_down function where
   i40e_clean_tx_ring(vsi->tx_rings[i]) is going to crash

When the driver was spinning vsi_release called
i40e_vsi_free_arrays where the vsi->tx_rings resources
were freed and the pointer was set to NULL.

Fixes: 5b6d4a7f20b0 ("i40e: Fix crash during removing i40e driver")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 2e02cc68cd3f..80c5cecaf2b5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -144,6 +144,7 @@ enum i40e_state_t {
 	__I40E_VIRTCHNL_OP_PENDING,
 	__I40E_RECOVERY_MODE,
 	__I40E_VF_RESETS_DISABLED,	/* disable resets during i40e_remove */
+	__I40E_IN_REMOVE,
 	__I40E_VFS_RELEASING,
 	/* This must be last as it determines the size of the BITMAP */
 	__I40E_STATE_SIZE__,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5cb4dc69fe87..0c4b7dfb3b35 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10863,6 +10863,9 @@ static void i40e_reset_and_rebuild(struct i40e_pf *pf, bool reinit,
 				   bool lock_acquired)
 {
 	int ret;
+
+	if (test_bit(__I40E_IN_REMOVE, pf->state))
+		return;
 	/* Now we wait for GRST to settle out.
 	 * We don't have to delete the VEBs or VSIs from the hw switch
 	 * because the reset will make them disappear.
@@ -12222,6 +12225,8 @@ int i40e_reconfig_rss_queues(struct i40e_pf *pf, int queue_count)
 
 		vsi->req_queue_pairs = queue_count;
 		i40e_prep_for_reset(pf);
+		if (test_bit(__I40E_IN_REMOVE, pf->state))
+			return pf->alloc_rss_size;
 
 		pf->alloc_rss_size = new_rss_size;
 
@@ -13048,6 +13053,10 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 	if (need_reset)
 		i40e_prep_for_reset(pf);
 
+	/* VSI shall be deleted in a moment, just return EINVAL */
+	if (test_bit(__I40E_IN_REMOVE, pf->state))
+		return -EINVAL;
+
 	old_prog = xchg(&vsi->xdp_prog, prog);
 
 	if (need_reset) {
@@ -15938,8 +15947,13 @@ static void i40e_remove(struct pci_dev *pdev)
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(0), 0);
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(1), 0);
 
-	while (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state))
+	/* Grab __I40E_RESET_RECOVERY_PENDING and set __I40E_IN_REMOVE
+	 * flags, once they are set, i40e_rebuild should not be called as
+	 * i40e_prep_for_reset always returns early.
+	 */
+	while (test_and_set_bit(__I40E_RESET_RECOVERY_PENDING, pf->state))
 		usleep_range(1000, 2000);
+	set_bit(__I40E_IN_REMOVE, pf->state);
 
 	if (pf->flags & I40E_FLAG_SRIOV_ENABLED) {
 		set_bit(__I40E_VF_RESETS_DISABLED, pf->state);
@@ -16138,6 +16152,9 @@ static void i40e_pci_error_reset_done(struct pci_dev *pdev)
 {
 	struct i40e_pf *pf = pci_get_drvdata(pdev);
 
+	if (test_bit(__I40E_IN_REMOVE, pf->state))
+		return;
+
 	i40e_reset_and_rebuild(pf, false, false);
 }
 
-- 
2.31.1

