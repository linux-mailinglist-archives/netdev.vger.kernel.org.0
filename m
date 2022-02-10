Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D8C4B13D3
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245014AbiBJRFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:05:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245025AbiBJRFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:05:38 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B25C17
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644512739; x=1676048739;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DXYogNjpk8nH7s/SDjBWSANUqXtuh5fEV3qBNVB6INA=;
  b=d9pShlf5ypwSpWblKJLc7g1mZOcz/MdzT7GQEqiRN9wWAiHPBxcDEgZK
   ex2g6iB+5H7V05y4SPh1d6zNhqU7dUwd5wgbGiqooFJbPs7/Skwmu0HFs
   506ht1KMZVqAM3ilZRpZ3ppbj2m66S+llqR6Otyypc9e2d5UeL8XZk1Kx
   WWnAQ5MsyKGaXNT5/6YJhsgLuWlXcDY9JLl21oxrUQzU4S4IY4suf+JNU
   KuSKv3esaNQCiaYpXCu8oM33y5VNHBq2jt4w5oMAzwuva+qD0lEL0uoYn
   BYbymMl9W0NQnxatKn2c+b8mUd/JtFkHsAjuB7zk/sDHs5asxNhivcOr1
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="274091954"
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="274091954"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 09:05:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="622742945"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Feb 2022 09:05:21 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Jonathan Toppins <jtoppins@redhat.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 4/4] ice: Avoid RTNL lock when re-creating auxiliary device
Date:   Thu, 10 Feb 2022 09:05:15 -0800
Message-Id: <20220210170515.2609656-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220210170515.2609656-1-anthony.l.nguyen@intel.com>
References: <20220210170515.2609656-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

If a call to re-create the auxiliary device happens in a context that has
already taken the RTNL lock, then the call flow that recreates auxiliary
device can hang if there is another attempt to claim the RTNL lock by the
auxiliary driver.

To avoid this, any call to re-create auxiliary devices that comes from
an source that is holding the RTNL lock (e.g. netdev notifier when
interface exits a bond) should execute in a separate thread.  To
accomplish this, add a flag to the PF that will be evaluated in the
service task and dealt with there.

Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 3 ++-
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 4e16d185077d..a9fa701aaa95 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -483,6 +483,7 @@ enum ice_pf_flags {
 	ICE_FLAG_VF_TRUE_PROMISC_ENA,
 	ICE_FLAG_MDD_AUTO_RESET_VF,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
+	ICE_FLAG_PLUG_AUX_DEV,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
@@ -887,7 +888,7 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
 	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
 		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
-		ice_plug_aux_dev(pf);
+		set_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 3b751d8b4056..17a9bb461dc3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2253,6 +2253,9 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
+	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+		ice_plug_aux_dev(pf);
+
 	ice_clean_adminq_subtask(pf);
 	ice_check_media_subtask(pf);
 	ice_check_for_hang_subtask(pf);
-- 
2.31.1

