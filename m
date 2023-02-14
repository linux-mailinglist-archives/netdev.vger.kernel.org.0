Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C11696FBE
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjBNVcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbjBNVcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:32:22 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9386C83EA
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676410316; x=1707946316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ypxLoy+UwF08AzpSKchm+BenWC7vHu7TJxkhtDxQwkY=;
  b=VhTSVAHC9fr00umS+dPMIJmj/YI5EOTE3abrRa+5bdfEgQQQZ5q/Tgz6
   gusijfiLc11mdrU/9kb1KYTIPy6HsVfqdQ5e0NCBDureG9MxFhjpQJKoM
   r1YC0i5NrCmkDPS0qG1+ofkXTr7CuW1Ngk+f/KAPln/SmGFRCtk56MmmH
   1BpSt+RAHLM8lhxucdkIcJ51ECBvc+8rSpqlDKuAcvFImZJjHWZYadi1s
   4uW5TcmrcVtegzFqLZ6a5soAadvPCYfGLz8q/cD0lPWFljPfPPYGqQWBC
   SGf+mC689Hw2fXClvtwY3aOB+Fk4BXuRjQenvQgbJAReyM6ndB1uEgHBL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="331274590"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="331274590"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:30:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="733025281"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="733025281"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 13:30:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/5] ice: Change ice_vsi_realloc_stat_arrays() to void
Date:   Tue, 14 Feb 2023 13:30:02 -0800
Message-Id: <20230214213003.2117125-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
References: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
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

smatch reports:

smatch warnings:
drivers/net/ethernet/intel/ice/ice_lib.c:3612 ice_vsi_rebuild() warn: missing error code 'ret'

If an error is encountered for ice_vsi_realloc_stat_arrays(), ret is not
assigned an error value so the goto error path would return success. The
function, however, only returns 0 so an error will never be reported; due
to this, change the function to return void.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 37fe639712e6..8cfc30fc9840 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3426,7 +3426,7 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
  * @prev_txq: Number of Tx rings before ring reallocation
  * @prev_rxq: Number of Rx rings before ring reallocation
  */
-static int
+static void
 ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi, int prev_txq, int prev_rxq)
 {
 	struct ice_vsi_stats *vsi_stat;
@@ -3434,9 +3434,9 @@ ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi, int prev_txq, int prev_rxq)
 	int i;
 
 	if (!prev_txq || !prev_rxq)
-		return 0;
+		return;
 	if (vsi->type == ICE_VSI_CHNL)
-		return 0;
+		return;
 
 	vsi_stat = pf->vsi_stats[vsi->idx];
 
@@ -3457,8 +3457,6 @@ ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi, int prev_txq, int prev_rxq)
 			}
 		}
 	}
-
-	return 0;
 }
 
 /**
@@ -3515,8 +3513,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, u32 vsi_flags)
 		}
 	}
 
-	if (ice_vsi_realloc_stat_arrays(vsi, prev_txq, prev_rxq))
-		goto err_vsi_cfg_tc_lan;
+	ice_vsi_realloc_stat_arrays(vsi, prev_txq, prev_rxq);
 
 	ice_vsi_rebuild_set_coalesce(vsi, coalesce, prev_num_q_vectors);
 	kfree(coalesce);
-- 
2.38.1

