Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A397D4C1A43
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243549AbiBWRyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242822AbiBWRyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:54:12 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B658218B
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645638824; x=1677174824;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EF8xPPnambgryatOi5RMgbvRpAyyA5E7wi9ZK9mqVsE=;
  b=GNAG33UET90UgJnf+1A3BdFiSR7/lZhm4wBRBTh159M6UpM/r8kzf+Az
   PBWb0onb01zggmjQz1ocLz9r/BVbiwA6ZPJDl5tShgto9mSKeG/nl653Q
   UtwF8h+DXEGGVLZ/SObK/Dp1gh4xOGZoXtAvZ0Dre2oZ8NyHsPTUwdX/B
   Re2OgGdWX5PQlCVcZBc6ePc3JmRIZj9ZVF77u++QlCWw6x+4xwd+nL8F7
   Z+q22rjvH8RVpDQiw3TagBKR3v+pfMWlWUrUv2VR0AINd2RHet616ZhXn
   7WuRatbXRIAAii/SkAkIA3eZCn9Fyi3sBP6TDU3nxtQnO/aWKOyIBiFwy
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="232661936"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="232661936"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 09:53:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="628176791"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Feb 2022 09:53:44 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com
Subject: [PATCH net 1/1] Revert "i40e: Fix reset bw limit when DCB enabled with 1 TC"
Date:   Wed, 23 Feb 2022 09:53:47 -0800
Message-Id: <20220223175347.1690692-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Revert of a patch that instead of fixing a AQ error when trying
to reset BW limit introduced several regressions related to
creation and managing TC. Currently there are errors when creating
a TC on both PF and VF.

Error log:
[17428.783095] i40e 0000:3b:00.1: AQ command Config VSI BW allocation per TC failed = 14
[17428.783107] i40e 0000:3b:00.1: Failed configuring TC map 0 for VSI 391
[17428.783254] i40e 0000:3b:00.1: AQ command Config VSI BW allocation per TC failed = 14
[17428.783259] i40e 0000:3b:00.1: Unable to  configure TC map 0 for VSI 391

This reverts commit 3d2504663c41104b4359a15f35670cfa82de1bbf.

Fixes: 3d2504663c41 (i40e: Fix reset bw limit when DCB enabled with 1 TC)
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 0c4b7dfb3b35..31b03fe78d3b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5372,15 +5372,7 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 	/* There is no need to reset BW when mqprio mode is on.  */
 	if (pf->flags & I40E_FLAG_TC_MQPRIO)
 		return 0;
-
-	if (!vsi->mqprio_qopt.qopt.hw) {
-		if (pf->flags & I40E_FLAG_DCB_ENABLED)
-			goto skip_reset;
-
-		if (IS_ENABLED(CONFIG_I40E_DCB) &&
-		    i40e_dcb_hw_get_num_tc(&pf->hw) == 1)
-			goto skip_reset;
-
+	if (!vsi->mqprio_qopt.qopt.hw && !(pf->flags & I40E_FLAG_DCB_ENABLED)) {
 		ret = i40e_set_bw_limit(vsi, vsi->seid, 0);
 		if (ret)
 			dev_info(&pf->pdev->dev,
@@ -5388,8 +5380,6 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 				 vsi->seid);
 		return ret;
 	}
-
-skip_reset:
 	memset(&bw_data, 0, sizeof(bw_data));
 	bw_data.tc_valid_bits = enabled_tc;
 	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)
-- 
2.31.1

