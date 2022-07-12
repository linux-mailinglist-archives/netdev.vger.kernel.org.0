Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98D0572165
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiGLQvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbiGLQvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:51:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A869BF552
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657644693; x=1689180693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kJi8aAMAotAWXuQy6rVp2Txlg2/KYX6xS4j77gRu2jI=;
  b=RNigCeYkFVAWRI9tHoFbpx3thgE9+ZkvI9VCjNKwF80P4aoDOHFAkEbo
   qQ1g4MtBB7uwGaXVZfIKIqS0IuKAntR7U11Gb+M/QjMwWn03wKWw4BrcH
   QT0WW0Q686PlLWSCX+AoBr16fVvsFQguOITjkyCaU2PvmwhQz8GwbhxZO
   8xKPbLNEAqsri8W23ZH53QWUr+b0YioZob0SHQtYWV0xMVOTINAxKHI6Z
   2FVvdtQ9XU/KQCNhqa/+ADM/aMMGUSnh9Gm2YlQ4qhHkd6v6jE5RBQEvk
   LlCzwkUSwYO8oxsvQcwOxB0Ajm4M9T3FYwj7oijfALXKN0fJjgBf/Epqt
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="285014501"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="285014501"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 09:51:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="841447056"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jul 2022 09:51:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jiri@mellanox.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 2/2] ice: change devlink code to read NVM in blocks
Date:   Tue, 12 Jul 2022 09:48:29 -0700
Message-Id: <20220712164829.7275-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220712164829.7275-1-anthony.l.nguyen@intel.com>
References: <20220712164829.7275-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

When creating a snapshot of the NVM the driver needs to read the entire
contents from the NVM and store it. The NVM reads are protected by a lock
that is shared between the driver and the firmware.

If the driver takes too long to read the entire NVM (which can happen on
some systems) then the firmware could reclaim the lock and cause subsequent
reads from the driver to fail.

We could fix this by increasing the timeout that we pass to the firmware,
but we could end up in the same situation again if the system is slow.
Instead have the driver break the reading of the NVM into blocks that are
small enough that we have confidence that the read will complete within the
timeout time, but large enough not to cause significant AQ overhead.

Fixes: dce730f17825 ("ice: add a devlink region for dumping NVM contents")
Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 59 +++++++++++++-------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 3991d62473bf..3337314a7b35 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -814,6 +814,8 @@ void ice_devlink_destroy_vf_port(struct ice_vf *vf)
 	devlink_port_unregister(devlink_port);
 }
 
+#define ICE_DEVLINK_READ_BLK_SIZE (1024 * 1024)
+
 /**
  * ice_devlink_nvm_snapshot - Capture a snapshot of the NVM flash contents
  * @devlink: the devlink instance
@@ -840,8 +842,9 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
 	struct ice_pf *pf = devlink_priv(devlink);
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
-	void *nvm_data;
-	u32 nvm_size;
+	u8 *nvm_data, *tmp, i;
+	u32 nvm_size, left;
+	s8 num_blks;
 	int status;
 
 	nvm_size = hw->flash.flash_size;
@@ -849,26 +852,44 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
 	if (!nvm_data)
 		return -ENOMEM;
 
-	status = ice_acquire_nvm(hw, ICE_RES_READ);
-	if (status) {
-		dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
-			status, hw->adminq.sq_last_status);
-		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
-		vfree(nvm_data);
-		return status;
-	}
 
-	status = ice_read_flat_nvm(hw, 0, &nvm_size, nvm_data, false);
-	if (status) {
-		dev_dbg(dev, "ice_read_flat_nvm failed after reading %u bytes, err %d aq_err %d\n",
-			nvm_size, status, hw->adminq.sq_last_status);
-		NL_SET_ERR_MSG_MOD(extack, "Failed to read NVM contents");
+	num_blks = DIV_ROUND_UP(nvm_size, ICE_DEVLINK_READ_BLK_SIZE);
+	tmp = nvm_data;
+	left = nvm_size;
+
+	/* Some systems take longer to read the NVM than others which causes the
+	 * FW to reclaim the NVM lock before the entire NVM has been read. Fix
+	 * this by breaking the reads of the NVM into smaller chunks that will
+	 * probably not take as long. This has some overhead since we are
+	 * increasing the number of AQ commands, but it should always work
+	 */
+	for (i = 0; i < num_blks; i++) {
+		u32 read_sz = min_t(u32, ICE_DEVLINK_READ_BLK_SIZE, left);
+
+		status = ice_acquire_nvm(hw, ICE_RES_READ);
+		if (status) {
+			dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
+				status, hw->adminq.sq_last_status);
+			NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
+			vfree(nvm_data);
+			return -EIO;
+		}
+
+		status = ice_read_flat_nvm(hw, i * ICE_DEVLINK_READ_BLK_SIZE,
+					   &read_sz, tmp, false);
+		if (status) {
+			dev_dbg(dev, "ice_read_flat_nvm failed after reading %u bytes, err %d aq_err %d\n",
+				read_sz, status, hw->adminq.sq_last_status);
+			NL_SET_ERR_MSG_MOD(extack, "Failed to read NVM contents");
+			ice_release_nvm(hw);
+			vfree(nvm_data);
+			return -EIO;
+		}
 		ice_release_nvm(hw);
-		vfree(nvm_data);
-		return status;
-	}
 
-	ice_release_nvm(hw);
+		tmp += read_sz;
+		left -= read_sz;
+	}
 
 	*data = nvm_data;
 
-- 
2.35.1

