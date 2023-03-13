Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1DD6B82D7
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjCMUg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjCMUgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:36:21 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6093E6287B
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678739780; x=1710275780;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VCPTPiyABYid1thuFeQbZUz9ZVLBNEdSttuKCZK3BXE=;
  b=LhRndVM15p6fiP5TBnEYCuffwu8yRa0SPly9Fo7P6GBds8sYAzXHSd30
   G3ivQgqM7d+pOzCWFxQHF6ELMdvHIkG0M97P52L+AwPhqSvrLyJJgqZ2m
   ylJ4eJirKzpuz0gIcF8zDS4X+kGL84dXp4nYdJVAUPedsVJAfpPQgnFR0
   qwDa/Pcpb4TWnldRrvkHbvbtKR/taXttH1+IQIL9tgAw5AF2jU8pvuH/5
   SaeEHS6l+dNrx2IOWmSIj9UhogcVxZRE3EADALXhpUYrv6HQ0QbEXJ6Po
   EadviH8mejTegql6t5yjXz8YWFkI2vLrO6wndzLKpG5UzQyr46WUhTHh9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="364913224"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="364913224"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 13:36:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="747732603"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="747732603"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.102])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 13:36:17 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Robert Malz <robertx.malz@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Piotr Raczynski <piotr.raczynski@intel.com>
Subject: [PATCH net v1 2/2] ice: Fix ice_cfg_rdma_fltr() to only update relevant fields
Date:   Mon, 13 Mar 2023 13:36:08 -0700
Message-Id: <20230313203608.1680781-3-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313203608.1680781-1-jesse.brandeburg@intel.com>
References: <20230313203608.1680781-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
2.39.2

