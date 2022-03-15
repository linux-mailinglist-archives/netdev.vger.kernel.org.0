Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54694DA54B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352210AbiCOWXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352162AbiCOWXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:23:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6256A5C66B
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647382921; x=1678918921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=303pLXjqGnbNv5BYacaMwKCi3qUynPavnvTcN8UTCyg=;
  b=XbKCrUz3JMXRo1UqsYquapa835YblIkeQvToihkI6GZg5jTiLqMniFgV
   IbYgGgWwq4r7NXdyNfLhFK84QFJZwysKJ7EsUq26qwvZSv2hSw9gyW75g
   sLd+nyUzYelkc1Y/bP+QBrh7YCv/VPKZ0Fkoyaey0xCiKvda+hKZta674
   Lxw/bV8c9NjwerOPnr1ssx6fYeWe5hqXXGeiw6mIgQwbQ1RbcbYpNDWn4
   OdCMmkUMqQS1L9YOYbtYjGq1pgKyjPBZjWFgWiCNrcoQcxXeQaW7xiawm
   tEwewPhWeXE4edalgq2M790/P4DW9lNrh19hpA9SNBatBmmNgsqpfYQ+w
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255264553"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="255264553"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:21:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="690362221"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2022 15:21:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 06/14] ice: drop is_vflr parameter from ice_reset_all_vfs
Date:   Tue, 15 Mar 2022 15:22:12 -0700
Message-Id: <20220315222220.2925324-7-anthony.l.nguyen@intel.com>
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

