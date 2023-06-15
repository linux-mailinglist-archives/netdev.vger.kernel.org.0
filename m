Return-Path: <netdev+bounces-11119-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E7473196A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66C7D28182A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8854115AEB;
	Thu, 15 Jun 2023 12:59:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E04C15AEA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:59:30 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039541BC9
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686833967; x=1718369967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yzCU2VNh38sIH0/rOX1pVivilw142Zhz0Ua5gQ8KupY=;
  b=bUE7TC5ujfoNe/VWNdp+28OuJMk0ol4gwNYA7LfNFSVBNaecFjfZfW8X
   SXc1Hg2jtNM3PwHrvmaIYvcGc082geGzUGVADFSRD0590d8tWs+OFrA0Z
   aU/w00gFt+oLFuY/d6V+TMHXGz70XLl1S5YNq/qc6U2GcO1spni5QD2/8
   MijBZrtm8Iq8UwjzkRjgFKH07gtciuj1KAOe/cZhxUfSal33r6G0agoDY
   /5LOtBtgPhnCk7sejaino4M03K1RyGPKWgBPakfr6Ti5NqEN5UpoxEMDU
   Mu9W0wzoUpRGuAGV7kqCj4wirqs8VvU0HBmBfaDYQvKdNVB2x9jqlET3Q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="424794824"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="424794824"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 05:59:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="825259740"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="825259740"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga002.fm.intel.com with ESMTP; 15 Jun 2023 05:59:26 -0700
From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	jacob.e.keller@intel.com,
	przemyslaw.kitszel@intel.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH iwl-next v1 2/4] ice: add bitmap to track VF MSI-X usage
Date: Thu, 15 Jun 2023 14:38:28 +0200
Message-Id: <20230615123830.155927-3-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
References: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Create a bitamp to track MSI-X usage for VFs. The bitmap has the size of
total MSI-X amount on device, because at init time the amount of MSI-X
used by VFs isn't known.

The bitmap is used in follow up patchset to provide a block of
continuous block of MSI-X indexes for each created VF.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h       | 2 ++
 drivers/net/ethernet/intel/ice/ice_sriov.c | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 176e281dfa24..98d2e70a719d 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -541,6 +541,8 @@ struct ice_pf {
 	 * MSIX vectors allowed on this PF.
 	 */
 	u16 sriov_base_vector;
+	unsigned long *sriov_irq_bm;	/* bitmap to track irq usage */
+	u16 sriov_irq_size;		/* size of the irq_bm bitmap */
 
 	u16 ctrl_vsi_idx;		/* control VSI index in pf->vsi array */
 
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 3137e772a64b..da0f1deef89b 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -138,6 +138,8 @@ static int ice_sriov_free_msix_res(struct ice_pf *pf)
 	if (!pf)
 		return -EINVAL;
 
+	bitmap_free(pf->sriov_irq_bm);
+	pf->sriov_irq_size = 0;
 	pf->sriov_base_vector = 0;
 
 	return 0;
@@ -836,10 +838,16 @@ static int ice_create_vf_entries(struct ice_pf *pf, u16 num_vfs)
  */
 static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 {
+	int total_vectors = pf->hw.func_caps.common_cap.num_msix_vectors;
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	int ret;
 
+	pf->sriov_irq_bm = bitmap_zalloc(total_vectors, GFP_KERNEL);
+	if (!pf->sriov_irq_bm)
+		return -ENOMEM;
+	pf->sriov_irq_size = total_vectors;
+
 	/* Disable global interrupt 0 so we don't try to handle the VFLR. */
 	wr32(hw, GLINT_DYN_CTL(pf->oicr_irq.index),
 	     ICE_ITR_NONE << GLINT_DYN_CTL_ITR_INDX_S);
@@ -898,6 +906,7 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 	/* rearm interrupts here */
 	ice_irq_dynamic_ena(hw, NULL, NULL);
 	clear_bit(ICE_OICR_INTR_DIS, pf->state);
+	bitmap_free(pf->sriov_irq_bm);
 	return ret;
 }
 
-- 
2.40.1


