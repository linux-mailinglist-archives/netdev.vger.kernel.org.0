Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF24F6CC92D
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 19:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjC1RW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 13:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjC1RW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 13:22:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DBA9EC4
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 10:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680024177; x=1711560177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XYIjfQ0VJAG1n5iF8rp5YDtkli3QxnBIqFUMjb1HIJ0=;
  b=VFf5NC6gOchDCFOsMjO1PRSqKhZusnVT+noLDPLclY1A8Syq7WZyoMsH
   ziV3Rtxck8znUpNmoYKAs/m47SKWGvhTXjFLLGccPNCiZCl32XKMYjQln
   kz2o2mlP5HCB/Zx6IGuQ7XLQWT8L+0ve+5g0C3+HyJF8WgTN8uGt+Py94
   MzDYVhD855otvsv0KlBHss4H6Z0W1a0+ctKy4CDQvbQ+xX/QhDuwYZysL
   EtSixHG8zgDOrsW3YkAZWY4J1nFmiG2eHV1I8fBf2bbouENXCVKMMSQtp
   +BExR/YKwLphGGdBR2eYK8QAn8rQOuqaU9Q2T03wesPgeV6LnsDB4L1Pa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="340658924"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="340658924"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 10:22:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="807906254"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="807906254"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga004.jf.intel.com with ESMTP; 28 Mar 2023 10:22:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>,
        anthony.l.nguyen@intel.com, Robert Malz <robertx.malz@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        Jakub Andrysiak <jakub.andrysiak@intel.com>
Subject: [PATCH net 2/4] ice: Fix ice_cfg_rdma_fltr() to only update relevant fields
Date:   Tue, 28 Mar 2023 10:20:33 -0700
Message-Id: <20230328172035.3904953-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230328172035.3904953-1-anthony.l.nguyen@intel.com>
References: <20230328172035.3904953-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

The current implementation causes ice_vsi_update() to update all VSI
fields based on the cached VSI context. This also assumes that the
ICE_AQ_VSI_PROP_Q_OPT_VALID bit is set. This can cause problems if the
VSI context is not correctly synced by the driver. Fix this by only
updating the fields that correspond to ICE_AQ_VSI_PROP_Q_OPT_VALID.
Also, make sure to save the updated result in the cached VSI context
on success.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Co-developed-by: Robert Malz <robertx.malz@intel.com>
Signed-off-by: Robert Malz <robertx.malz@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Tested-by: Jakub Andrysiak <jakub.andrysiak@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 26 +++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 61f844d22512..46b36851af46 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1780,18 +1780,36 @@ ice_update_vsi(struct ice_hw *hw, u16 vsi_handle, struct ice_vsi_ctx *vsi_ctx,
 int
 ice_cfg_rdma_fltr(struct ice_hw *hw, u16 vsi_handle, bool enable)
 {
-	struct ice_vsi_ctx *ctx;
+	struct ice_vsi_ctx *ctx, *cached_ctx;
+	int status;
+
+	cached_ctx = ice_get_vsi_ctx(hw, vsi_handle);
+	if (!cached_ctx)
+		return -ENOENT;
 
-	ctx = ice_get_vsi_ctx(hw, vsi_handle);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
-		return -EIO;
+		return -ENOMEM;
+
+	ctx->info.q_opt_rss = cached_ctx->info.q_opt_rss;
+	ctx->info.q_opt_tc = cached_ctx->info.q_opt_tc;
+	ctx->info.q_opt_flags = cached_ctx->info.q_opt_flags;
+
+	ctx->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_Q_OPT_VALID);
 
 	if (enable)
 		ctx->info.q_opt_flags |= ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
 	else
 		ctx->info.q_opt_flags &= ~ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
 
-	return ice_update_vsi(hw, vsi_handle, ctx, NULL);
+	status = ice_update_vsi(hw, vsi_handle, ctx, NULL);
+	if (!status) {
+		cached_ctx->info.q_opt_flags = ctx->info.q_opt_flags;
+		cached_ctx->info.valid_sections |= ctx->info.valid_sections;
+	}
+
+	kfree(ctx);
+	return status;
 }
 
 /**
-- 
2.38.1

