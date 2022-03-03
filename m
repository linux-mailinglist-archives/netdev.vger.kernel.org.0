Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC704CC7B6
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 22:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbiCCVPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 16:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236440AbiCCVP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 16:15:28 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B7C580CE
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 13:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646342082; x=1677878082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HXXqZ+zmnMoKPHpCRVBnma1qlCSNi/v7tLI1ZhU19Qk=;
  b=SsYviR2aVlvokmygmc7kgBJgU5kpC5E4B5ENXuOZYtbU75aK36z84Jxi
   4SxI0p8lWqsqVowjM42GBpa9Pdb1Z5kmfeP9miHwbKE3/ZyyQlZf9w/m/
   nPT4Cdtp/dhaKqR1MZ04f5kzuJ8WL+htg7l89Xbz5eS12s9Quu8OscvOX
   uvH4H1/rusuNQcBXo5OEXd227xDCA4uDw0GzAZyOipBNx9SmmyCBlUSAP
   LgAxbWzIYeBCqOxXseJKLRTasMku8duleg0JaGhexQPNvTHNd6TpcEhSz
   MtyV3qb1pa8opgfghnNUk5Zf0f7JUPraCTEOd2inuAHkOfQnH52UaDGpi
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="340245728"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="340245728"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 13:14:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="640347716"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 13:14:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 07/11] ice: use ice_for_each_vf for iteration during removal
Date:   Thu,  3 Mar 2022 13:14:45 -0800
Message-Id: <20220303211449.899956-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
References: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

When removing VFs, the driver takes a weird approach of assigning
pf->num_alloc_vfs to 0 before iterating over the VFs using a temporary
variable.

This logic has been in the driver for a long time, and seems to have
been carried forward from i40e.

We want to refactor the way VFs are stored, and iterating over the data
structure without the ice_for_each_vf interface impedes this work.

The logic relies on implicitly using the num_alloc_vfs as a sort of
"safe guard" for accessing VF data.

While this sort of guard makes sense for Single Root IOV where all VFs
are added at once, the data structures don't work for VFs which can be
added and removed dynamically. We also have a separate state flag,
ICE_VF_DEINIT_IN_PROGRESS which is a stronger protection against
concurrent removal and access.

Avoid the custom tmp iteration and replace it with the standard
ice_for_each_vf iterator. Delay the assignment of num_alloc_vfs until
after this loop finishes.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index c8f2473684ce..d72a748870c9 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -500,7 +500,7 @@ void ice_free_vfs(struct ice_pf *pf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
-	unsigned int tmp, i;
+	unsigned int i;
 
 	if (!pf->vf)
 		return;
@@ -519,10 +519,7 @@ void ice_free_vfs(struct ice_pf *pf)
 	else
 		dev_warn(dev, "VFs are assigned - not disabling SR-IOV\n");
 
-	tmp = pf->num_alloc_vfs;
-	pf->num_qps_per_vf = 0;
-	pf->num_alloc_vfs = 0;
-	for (i = 0; i < tmp; i++) {
+	ice_for_each_vf(pf, i) {
 		struct ice_vf *vf = &pf->vf[i];
 
 		mutex_lock(&vf->cfg_lock);
@@ -558,6 +555,8 @@ void ice_free_vfs(struct ice_pf *pf)
 	if (ice_sriov_free_msix_res(pf))
 		dev_err(dev, "Failed to free MSIX resources used by SR-IOV\n");
 
+	pf->num_qps_per_vf = 0;
+	pf->num_alloc_vfs = 0;
 	devm_kfree(dev, pf->vf);
 	pf->vf = NULL;
 
-- 
2.31.1

