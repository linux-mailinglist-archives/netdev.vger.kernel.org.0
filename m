Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A160D4DA461
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 22:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343516AbiCOVNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 17:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351880AbiCOVNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 17:13:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8155B3E4
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 14:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647378722; x=1678914722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8PgYKHlLZqQxXxjKCcUpVXINScXFg/XQ6ZqY9CRDYcY=;
  b=lS2C0s4enE+Bn7BxjzHkx2Cbr5z0gUkqMMboXB6clfVvAssJk+aRPZmd
   6M8UaMfF8bCGEOyGWp7rrHhlONzrZMSCMt3vxyNQeSeqenQYgBVXOumAj
   JQBwpw/MqXAMKyfvdlFdDB3SN2ZxdisMwHRCJusC6z4IGvuobLZGe7eEz
   iMZ8qz9r75iGxGEG1/HjTLj15T1pMswsCcNH1el3nj3Q86tIXXGcGzG4n
   4dWT9ZQDrV13AqrzJUxTPcfiTImhHNixLSnZdmjLQOl7g7MHFtMdYgp7C
   z3RagAmA6t1OtndUQckO6EbjdBcBC//LlBlfOr0GtKoX91UjVZsap4Q9v
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236370470"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="236370470"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 14:12:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="820113210"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2022 14:12:01 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net 2/3] ice: destroy flow director filter mutex after releasing VSIs
Date:   Tue, 15 Mar 2022 14:12:24 -0700
Message-Id: <20220315211225.2923496-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
References: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>

Currently fdir_fltr_lock is accessed in ice_vsi_release_all() function
after it is destroyed. Instead destroy mutex after ice_vsi_release_all.

Fixes: 40319796b732 ("ice: Add flow director support for channel mode")
Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d4a7c39fd078..b7e8744b0c0a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4880,7 +4880,6 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_devlink_unregister_params(pf);
 	set_bit(ICE_DOWN, pf->state);
 
-	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
 	ice_deinit_lag(pf);
 	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
 		ice_ptp_release(pf);
@@ -4888,6 +4887,7 @@ static void ice_remove(struct pci_dev *pdev)
 		ice_remove_arfs(pf);
 	ice_setup_mc_magic_wake(pf);
 	ice_vsi_release_all(pf);
+	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
 	ice_set_wake(pf);
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
-- 
2.31.1

