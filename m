Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F273628B65
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 22:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbiKNVhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 16:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiKNVhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 16:37:11 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2A565B0
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 13:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668461831; x=1699997831;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aV2tBslTABRq7tRYvLEkPSsDGyJiVtXP4Ua9gkWBJds=;
  b=U+dPtxZIaZTjmDxe5evYDOp2tog/oOe3V47R4m0GNzF3FpCqatbG8i8A
   +U1r5p2q26Ap0usgRNTn3eccbp4L85pvmsjs01QHDbEvl5rks1qChBPe/
   yymqc2mZYkyoEEkp3kELnwahX41OwDl+h6/OBIcvWNWP7u35jT702IuIL
   /GIT+DD+rCZ5mNBRj3k1AvBuy6iTC870PlcIF8puKGALbZrma6PvJPSGc
   Lg4aefwEoKlAXfV5f2IjhJAcYGzb/vJDLLxv66BGtjRofFnoAo2HD22y0
   DMHWOXQU6CRBkUCRIt4JWf3CJnRCJ2CTJzfEZ7KMicuqyZj97Y3U38FSR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="291801915"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="291801915"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 13:37:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="669829458"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="669829458"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 13:37:10 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next] mlxsw: update adjfine to use adjust_by_scaled_ppm
Date:   Mon, 14 Nov 2022 13:37:01 -0800
Message-Id: <20221114213701.815132-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlxsw adjfine implementation in the spectrum_ptp.c file converts
scaled_ppm into ppb before updating a cyclecounter multiplier using the
standard "base * ppb / 1billion" calculation.

This can be re-written to use adjust_by_scaled_ppm, directly using the
scaled parts per million and reducing the amount of code required to
express this calculation.

We still calculate the parts per billion for passing into
mlxsw_sp_ptp_phc_adjfreq because this function requires the input to be in
parts per billion.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Amit Cohen <amcohen@nvidia.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Petr Machata <petrm@nvidia.com>
---

Noticed this while investigating conversion of max_adj to scaled PPM format.
This was missed in the previous round of updates that modified drivers to
use the adjust_by_scaled_ppm interface.

 .../net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 7b01b9c20722..cbb6c75a6620 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -189,29 +189,17 @@ mlxsw_sp1_ptp_phc_settime(struct mlxsw_sp1_ptp_clock *clock, u64 nsec)
 static int mlxsw_sp1_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct mlxsw_sp1_ptp_clock *clock = mlxsw_sp1_ptp_clock(ptp);
-	int neg_adj = 0;
-	u32 diff;
-	u64 adj;
 	s32 ppb;
 
 	ppb = scaled_ppm_to_ppb(scaled_ppm);
 
-	if (ppb < 0) {
-		neg_adj = 1;
-		ppb = -ppb;
-	}
-
-	adj = clock->nominal_c_mult;
-	adj *= ppb;
-	diff = div_u64(adj, NSEC_PER_SEC);
-
 	spin_lock_bh(&clock->lock);
 	timecounter_read(&clock->tc);
-	clock->cycles.mult = neg_adj ? clock->nominal_c_mult - diff :
-				       clock->nominal_c_mult + diff;
+	clock->cycles.mult = adjust_by_scaled_ppm(clock->nominal_c_mult,
+						  scaled_ppm);
 	spin_unlock_bh(&clock->lock);
 
-	return mlxsw_sp_ptp_phc_adjfreq(&clock->common, neg_adj ? -ppb : ppb);
+	return mlxsw_sp_ptp_phc_adjfreq(&clock->common, ppb);
 }
 
 static int mlxsw_sp1_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)

base-commit: f12ed9c04804eec4f1819097a0fd0b4800adac2f
-- 
2.38.1.420.g319605f8f00e

