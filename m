Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006EC5AF6AE
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiIFVNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiIFVNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:13:08 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC598B8A5F
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662498787; x=1694034787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F8uSvx2SeilTbqHkBRfqYLBRRiglrlFvLXLm4so9MFk=;
  b=TJqZn9lgBlBmETYqeudqu8Shz0BPSgbww1yZ4SkllIyk/Uei4cs0nKz6
   LX1+0uqFk+35aKjqHokkfGt6d8AONBnzFo5hxvnE4QznIZ+Hnmt302EhV
   e3IXEGqKrQcemjumQoIgn2pt2dHAdtZmtvmIo09BpHq580Oh98D0VlHqh
   wKnhERpw5HqiixxiyzViQ4Hjn8C8qXLY9kMs6V1561JNwfw8jJk0qV0iY
   OGIP2Hrm3uW9XINK0qbWEBCx4kODXh5EjdtFq+CzYhdz0kB9e8Vlk0Cn8
   Z7DQ0a8URPpa6TO8zrqUiLAoiot0BqQBnobhY1dC8oP5vgqxH529Tzxbr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="295441846"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="295441846"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:13:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="591421358"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Sep 2022 14:13:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        Petr Oros <poros@redhat.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/5] ice: Allow operation with reduced device MSI-X
Date:   Tue,  6 Sep 2022 14:12:58 -0700
Message-Id: <20220906211302.3501186-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
References: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
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

The driver currently takes an all or nothing approach for device MSI-X
vectors. Meaning if it does not get its full allocation, it will fail and
not load. There is no reason it can't work with a reduced number of MSI-X
vectors. Take a similar approach as commit 741106f7bd8d ("ice: Improve
MSI-X fallback logic") and, instead, adjust the MSI-X request to make use
of what is available.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Petr Oros <poros@redhat.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
---
 drivers/net/ethernet/intel/ice/ice_main.c | 185 ++++++++++++----------
 1 file changed, 100 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 14edf7614406..9d031271cfda 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3921,88 +3921,135 @@ static int ice_init_pf(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_reduce_msix_usage - Reduce usage of MSI-X vectors
+ * @pf: board private structure
+ * @v_remain: number of remaining MSI-X vectors to be distributed
+ *
+ * Reduce the usage of MSI-X vectors when entire request cannot be fulfilled.
+ * pf->num_lan_msix and pf->num_rdma_msix values are set based on number of
+ * remaining vectors.
+ */
+static void ice_reduce_msix_usage(struct ice_pf *pf, int v_remain)
+{
+	int v_rdma;
+
+	if (!ice_is_rdma_ena(pf)) {
+		pf->num_lan_msix = v_remain;
+		return;
+	}
+
+	/* RDMA needs at least 1 interrupt in addition to AEQ MSIX */
+	v_rdma = ICE_RDMA_NUM_AEQ_MSIX + 1;
+
+	if (v_remain < ICE_MIN_LAN_TXRX_MSIX + ICE_MIN_RDMA_MSIX) {
+		dev_warn(ice_pf_to_dev(pf), "Not enough MSI-X vectors to support RDMA.\n");
+		clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
+
+		pf->num_rdma_msix = 0;
+		pf->num_lan_msix = ICE_MIN_LAN_TXRX_MSIX;
+	} else if ((v_remain < ICE_MIN_LAN_TXRX_MSIX + v_rdma) ||
+		   (v_remain - v_rdma < v_rdma)) {
+		/* Support minimum RDMA and give remaining vectors to LAN MSIX */
+		pf->num_rdma_msix = ICE_MIN_RDMA_MSIX;
+		pf->num_lan_msix = v_remain - ICE_MIN_RDMA_MSIX;
+	} else {
+		/* Split remaining MSIX with RDMA after accounting for AEQ MSIX
+		 */
+		pf->num_rdma_msix = (v_remain - ICE_RDMA_NUM_AEQ_MSIX) / 2 +
+				    ICE_RDMA_NUM_AEQ_MSIX;
+		pf->num_lan_msix = v_remain - pf->num_rdma_msix;
+	}
+}
+
 /**
  * ice_ena_msix_range - Request a range of MSIX vectors from the OS
  * @pf: board private structure
  *
- * compute the number of MSIX vectors required (v_budget) and request from
- * the OS. Return the number of vectors reserved or negative on failure
+ * Compute the number of MSIX vectors wanted and request from the OS. Adjust
+ * device usage if there are not enough vectors. Return the number of vectors
+ * reserved or negative on failure.
  */
 static int ice_ena_msix_range(struct ice_pf *pf)
 {
-	int num_cpus, v_left, v_actual, v_other, v_budget = 0;
+	int num_cpus, hw_num_msix, v_other, v_wanted, v_actual;
 	struct device *dev = ice_pf_to_dev(pf);
-	int needed, err, i;
+	int err, i;
 
-	v_left = pf->hw.func_caps.common_cap.num_msix_vectors;
+	hw_num_msix = pf->hw.func_caps.common_cap.num_msix_vectors;
 	num_cpus = num_online_cpus();
 
-	/* reserve for LAN miscellaneous handler */
-	needed = ICE_MIN_LAN_OICR_MSIX;
-	if (v_left < needed)
-		goto no_hw_vecs_left_err;
-	v_budget += needed;
-	v_left -= needed;
+	/* LAN miscellaneous handler */
+	v_other = ICE_MIN_LAN_OICR_MSIX;
 
-	/* reserve for flow director */
-	if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
-		needed = ICE_FDIR_MSIX;
-		if (v_left < needed)
-			goto no_hw_vecs_left_err;
-		v_budget += needed;
-		v_left -= needed;
-	}
-
-	/* reserve for switchdev */
-	needed = ICE_ESWITCH_MSIX;
-	if (v_left < needed)
-		goto no_hw_vecs_left_err;
-	v_budget += needed;
-	v_left -= needed;
-
-	/* total used for non-traffic vectors */
-	v_other = v_budget;
-
-	/* reserve vectors for LAN traffic */
-	needed = num_cpus;
-	if (v_left < needed)
-		goto no_hw_vecs_left_err;
-	pf->num_lan_msix = needed;
-	v_budget += needed;
-	v_left -= needed;
-
-	/* reserve vectors for RDMA auxiliary driver */
+	/* Flow Director */
+	if (test_bit(ICE_FLAG_FD_ENA, pf->flags))
+		v_other += ICE_FDIR_MSIX;
+
+	/* switchdev */
+	v_other += ICE_ESWITCH_MSIX;
+
+	v_wanted = v_other;
+
+	/* LAN traffic */
+	pf->num_lan_msix = num_cpus;
+	v_wanted += pf->num_lan_msix;
+
+	/* RDMA auxiliary driver */
 	if (ice_is_rdma_ena(pf)) {
-		needed = num_cpus + ICE_RDMA_NUM_AEQ_MSIX;
-		if (v_left < needed)
-			goto no_hw_vecs_left_err;
-		pf->num_rdma_msix = needed;
-		v_budget += needed;
-		v_left -= needed;
+		pf->num_rdma_msix = num_cpus + ICE_RDMA_NUM_AEQ_MSIX;
+		v_wanted += pf->num_rdma_msix;
 	}
 
-	pf->msix_entries = devm_kcalloc(dev, v_budget,
+	if (v_wanted > hw_num_msix) {
+		int v_remain;
+
+		dev_warn(dev, "not enough device MSI-X vectors. wanted = %d, available = %d\n",
+			 v_wanted, hw_num_msix);
+
+		if (hw_num_msix < ICE_MIN_MSIX) {
+			err = -ERANGE;
+			goto exit_err;
+		}
+
+		v_remain = hw_num_msix - v_other;
+		if (v_remain < ICE_MIN_LAN_TXRX_MSIX) {
+			v_other = ICE_MIN_MSIX - ICE_MIN_LAN_TXRX_MSIX;
+			v_remain = ICE_MIN_LAN_TXRX_MSIX;
+		}
+
+		ice_reduce_msix_usage(pf, v_remain);
+		v_wanted = pf->num_lan_msix + pf->num_rdma_msix + v_other;
+
+		dev_notice(dev, "Reducing request to %d MSI-X vectors for LAN traffic.\n",
+			   pf->num_lan_msix);
+		if (ice_is_rdma_ena(pf))
+			dev_notice(dev, "Reducing request to %d MSI-X vectors for RDMA.\n",
+				   pf->num_rdma_msix);
+	}
+
+	pf->msix_entries = devm_kcalloc(dev, v_wanted,
 					sizeof(*pf->msix_entries), GFP_KERNEL);
 	if (!pf->msix_entries) {
 		err = -ENOMEM;
 		goto exit_err;
 	}
 
-	for (i = 0; i < v_budget; i++)
+	for (i = 0; i < v_wanted; i++)
 		pf->msix_entries[i].entry = i;
 
 	/* actually reserve the vectors */
 	v_actual = pci_enable_msix_range(pf->pdev, pf->msix_entries,
-					 ICE_MIN_MSIX, v_budget);
+					 ICE_MIN_MSIX, v_wanted);
 	if (v_actual < 0) {
 		dev_err(dev, "unable to reserve MSI-X vectors\n");
 		err = v_actual;
 		goto msix_err;
 	}
 
-	if (v_actual < v_budget) {
+	if (v_actual < v_wanted) {
 		dev_warn(dev, "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
-			 v_budget, v_actual);
+			 v_wanted, v_actual);
 
 		if (v_actual < ICE_MIN_MSIX) {
 			/* error if we can't get minimum vectors */
@@ -4011,38 +4058,11 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 			goto msix_err;
 		} else {
 			int v_remain = v_actual - v_other;
-			int v_rdma = 0, v_min_rdma = 0;
 
-			if (ice_is_rdma_ena(pf)) {
-				/* Need at least 1 interrupt in addition to
-				 * AEQ MSIX
-				 */
-				v_rdma = ICE_RDMA_NUM_AEQ_MSIX + 1;
-				v_min_rdma = ICE_MIN_RDMA_MSIX;
-			}
+			if (v_remain < ICE_MIN_LAN_TXRX_MSIX)
+				v_remain = ICE_MIN_LAN_TXRX_MSIX;
 
-			if (v_actual == ICE_MIN_MSIX ||
-			    v_remain < ICE_MIN_LAN_TXRX_MSIX + v_min_rdma) {
-				dev_warn(dev, "Not enough MSI-X vectors to support RDMA.\n");
-				clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
-
-				pf->num_rdma_msix = 0;
-				pf->num_lan_msix = ICE_MIN_LAN_TXRX_MSIX;
-			} else if ((v_remain < ICE_MIN_LAN_TXRX_MSIX + v_rdma) ||
-				   (v_remain - v_rdma < v_rdma)) {
-				/* Support minimum RDMA and give remaining
-				 * vectors to LAN MSIX
-				 */
-				pf->num_rdma_msix = v_min_rdma;
-				pf->num_lan_msix = v_remain - v_min_rdma;
-			} else {
-				/* Split remaining MSIX with RDMA after
-				 * accounting for AEQ MSIX
-				 */
-				pf->num_rdma_msix = (v_remain - ICE_RDMA_NUM_AEQ_MSIX) / 2 +
-						    ICE_RDMA_NUM_AEQ_MSIX;
-				pf->num_lan_msix = v_remain - pf->num_rdma_msix;
-			}
+			ice_reduce_msix_usage(pf, v_remain);
 
 			dev_notice(dev, "Enabled %d MSI-X vectors for LAN traffic.\n",
 				   pf->num_lan_msix);
@@ -4057,12 +4077,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 
 msix_err:
 	devm_kfree(dev, pf->msix_entries);
-	goto exit_err;
 
-no_hw_vecs_left_err:
-	dev_err(dev, "not enough device MSI-X vectors. requested = %d, available = %d\n",
-		needed, v_left);
-	err = -ERANGE;
 exit_err:
 	pf->num_rdma_msix = 0;
 	pf->num_lan_msix = 0;
-- 
2.35.1

