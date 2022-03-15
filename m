Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0CE4DA53C
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244824AbiCOWXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235668AbiCOWXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:23:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FC85C65D
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647382919; x=1678918919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BXOXQyDR4nuz6yLVve9ZwmKD57om3oidLdTRhzKj92U=;
  b=boHnKXpK99RAMVxdF6TxSQ8PMVzSv/kYs4E7qFlPMmpmZDjFMse9TNm7
   s+1ahfMcUF/MSq75su3duinpOfDl17tGZMs+SRDsSKMBq9cZ+mwM58abw
   iGVdXwwv2YJwTWOt609eXmIJZ0KDrZJ5VubypLh6uh2rlhxDLJFHSIRJa
   H5sB1v/IZLExoYwBz6xQaPiwHD606ITfV7d5JuxprXK3tdA1GKA2olUQM
   KV1TgUMkKqLo4mK+pN8Hb5ZcTxp1+k8VCHZ2tjGbis995bjGkdsnwR91R
   CvKWMHXQpxyh4nTtwQHeZGbqHmsVAY1qDI10rIk/k/h2krQt4DqiQdsWO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255264546"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="255264546"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:21:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="690362205"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2022 15:21:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 02/14] ice: fix incorrect dev_dbg print mistaking 'i' for vf->vf_id
Date:   Tue, 15 Mar 2022 15:22:08 -0700
Message-Id: <20220315222220.2925324-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
References: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

If we fail to clear the malicious VF indication after a VF reset, the
dev_dbg message which is printed uses the local variable 'i' when it
meant to use vf->vf_id. Fix this.

Fixes: 0891c89674e8 ("ice: warn about potentially malicious VFs")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 2f74fcf51c2c..91d106528b66 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1381,7 +1381,8 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	/* if the VF has been reset allow it to come up again */
 	if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
 				ICE_MAX_SRIOV_VFS, vf->vf_id))
-		dev_dbg(dev, "failed to clear malicious VF state for VF %u\n", i);
+		dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
+			vf->vf_id);
 
 	return true;
 }
-- 
2.31.1

