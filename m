Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999664D9210
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344196AbiCOBNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344153AbiCOBMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:12:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8686246678
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647306700; x=1678842700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4T8x1QHFs36vFGrhTNhXTxGSd/Z8B8DYiR5pHiHjKQU=;
  b=aoSMholMFycQFUK8Xhr96GWKrGHK1yRHi3nUNCNdJejSHB3NrJvLJDF5
   NOtqq8uJ/qB0j3u1f5sqwjHUkVo8lj0c5f8Twq56v+BnmJoiRKKhQdarS
   /S10O6CueQTR5ugnkLBLh1b0ydQDnhFGGYFfMN5khMNxD+bABKGzVdXeb
   ZBKSpuynOHOrBjq3hp74tks91S0A33sL2YWS3EXf9o+hy+UMYGdrgsvaW
   HQLo95moqXtgw6vaiR2ADS4mZ8r/qvuIS6n/xaRcnGngNj3UAKB65HgU8
   UuWmrih1Al+Baz+jms3+ZDVM2Mkuo+DPb/pplNvs4rIeqB2jQ0diFTAmA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236790471"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="236790471"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:11:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="540222905"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2022 18:11:33 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next v2 10/11] ice: log an error message when eswitch fails to configure
Date:   Mon, 14 Mar 2022 18:11:54 -0700
Message-Id: <20220315011155.2166817-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
References: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
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

When ice_eswitch_configure fails, print an error message to make it more
obvious why VF initialization did not succeed.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index b695d479dfb1..d41fce16ddfb 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -2087,8 +2087,10 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 	clear_bit(ICE_VF_DIS, pf->state);
 
 	ret = ice_eswitch_configure(pf);
-	if (ret)
+	if (ret) {
+		dev_err(dev, "Failed to configure eswitch, err %d\n", ret);
 		goto err_unroll_sriov;
+	}
 
 	/* rearm global interrupts */
 	if (test_and_clear_bit(ICE_OICR_INTR_DIS, pf->state))
-- 
2.31.1

