Return-Path: <netdev+bounces-3064-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C77705531
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E32E028169A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E46D125C9;
	Tue, 16 May 2023 17:44:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371DF11C92
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:44:05 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C80A76B9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684259043; x=1715795043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zsPgzXA6fUEELy1cIrEDS20HKLyAys/isyuEIZeTJjU=;
  b=SJb+bBq0gBq01f0RyD5fg1Y3zT3IAAIW19RD01L+r4PxfLoZxaaoQDjP
   aoW5FfOHAwR8q5Ha/TM7TadUEA1npSflw2Ulu6PQZwlEbJqYRHr4WvUK/
   O0nhz0rcbBSKtQqbFzFRqsdCnZUFoni9R4FMP6IDfCZFj5yqc9hivZBdY
   FDZ+pHw8lC9cOMIzk55+8kovZ/E1jgt2Yt/aIEjTwSQ2SXFln6rzm5lb0
   HM8QldiAsHykEwb3QohokXJG5dF5MzRt2k1YjxJrKGov4CymEmP0nHl2F
   c0m/h7k+uUu09gKTHmbnTqpWgQMyga+Kvl/vbm8qCBpuQzTa9cYEtw+Ak
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="353831929"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="353831929"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 10:44:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="875733043"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="875733043"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2023 10:44:00 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Piotr Raczynski <piotr.raczynski@intel.com>,
	anthony.l.nguyen@intel.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net-next v2 3/8] ice: use preferred MSIX allocation api
Date: Tue, 16 May 2023 10:40:16 -0700
Message-Id: <20230516174021.2707029-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230516174021.2707029-1-anthony.l.nguyen@intel.com>
References: <20230516174021.2707029-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Piotr Raczynski <piotr.raczynski@intel.com>

Move away from using pci_enable_msix_range/pci_disable_msix and use
pci_alloc_irq_vectors/pci_free_irq_vectors instead.

As a result stop tracking msix_entries since with newer API entries are
handled by MSIX core. However, due to current design of communication
with RDMA driver which accesses ice_pf::msix_entries directly, keep
using the array just for RDMA driver use.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_idc.c  | 29 ++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_irq.c  | 40 +++++------------------
 drivers/net/ethernet/intel/ice/ice_main.c |  6 ++--
 3 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index e6bc2285071e..1000759505d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -235,14 +235,33 @@ EXPORT_SYMBOL_GPL(ice_get_qos_params);
 static int ice_reserve_rdma_qvector(struct ice_pf *pf)
 {
 	if (ice_is_rdma_ena(pf)) {
-		int index;
+		int index, i;
 
 		index = ice_get_res(pf, pf->irq_tracker, pf->num_rdma_msix,
 				    ICE_RES_RDMA_VEC_ID);
 		if (index < 0)
 			return index;
+
+		pf->msix_entries = kcalloc(pf->num_rdma_msix,
+					   sizeof(*pf->msix_entries),
+						  GFP_KERNEL);
+		if (!pf->msix_entries) {
+			ice_free_res(pf->irq_tracker, pf->rdma_base_vector,
+				     ICE_RES_RDMA_VEC_ID);
+			return -ENOMEM;
+		}
+
 		pf->num_avail_sw_msix -= pf->num_rdma_msix;
-		pf->rdma_base_vector = (u16)index;
+
+		/* RDMA is the only user of pf->msix_entries array */
+		pf->rdma_base_vector = 0;
+
+		for (i = 0; i < pf->num_rdma_msix; i++, index++) {
+			struct msix_entry *entry = &pf->msix_entries[i];
+
+			entry->entry = index;
+			entry->vector = pci_irq_vector(pf->pdev, index);
+		}
 	}
 	return 0;
 }
@@ -253,6 +272,12 @@ static int ice_reserve_rdma_qvector(struct ice_pf *pf)
  */
 static void ice_free_rdma_qvector(struct ice_pf *pf)
 {
+	if (!pf->msix_entries)
+		return;
+
+	kfree(pf->msix_entries);
+	pf->msix_entries = NULL;
+
 	pf->num_avail_sw_msix -= pf->num_rdma_msix;
 	ice_free_res(pf->irq_tracker, pf->rdma_base_vector,
 		     ICE_RES_RDMA_VEC_ID);
diff --git a/drivers/net/ethernet/intel/ice/ice_irq.c b/drivers/net/ethernet/intel/ice/ice_irq.c
index 1fc7daec9732..f61be5d76373 100644
--- a/drivers/net/ethernet/intel/ice/ice_irq.c
+++ b/drivers/net/ethernet/intel/ice/ice_irq.c
@@ -59,7 +59,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 {
 	int num_cpus, hw_num_msix, v_other, v_wanted, v_actual;
 	struct device *dev = ice_pf_to_dev(pf);
-	int err, i;
+	int err;
 
 	hw_num_msix = pf->hw.func_caps.common_cap.num_msix_vectors;
 	num_cpus = num_online_cpus();
@@ -113,23 +113,13 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 				   pf->num_rdma_msix);
 	}
 
-	pf->msix_entries = devm_kcalloc(dev, v_wanted,
-					sizeof(*pf->msix_entries), GFP_KERNEL);
-	if (!pf->msix_entries) {
-		err = -ENOMEM;
-		goto exit_err;
-	}
-
-	for (i = 0; i < v_wanted; i++)
-		pf->msix_entries[i].entry = i;
-
 	/* actually reserve the vectors */
-	v_actual = pci_enable_msix_range(pf->pdev, pf->msix_entries,
-					 ICE_MIN_MSIX, v_wanted);
+	v_actual = pci_alloc_irq_vectors(pf->pdev, ICE_MIN_MSIX, v_wanted,
+					 PCI_IRQ_MSIX);
 	if (v_actual < 0) {
 		dev_err(dev, "unable to reserve MSI-X vectors\n");
 		err = v_actual;
-		goto msix_err;
+		goto exit_err;
 	}
 
 	if (v_actual < v_wanted) {
@@ -138,9 +128,9 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 
 		if (v_actual < ICE_MIN_MSIX) {
 			/* error if we can't get minimum vectors */
-			pci_disable_msix(pf->pdev);
+			pci_free_irq_vectors(pf->pdev);
 			err = -ERANGE;
-			goto msix_err;
+			goto exit_err;
 		} else {
 			int v_remain = v_actual - v_other;
 
@@ -160,33 +150,19 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 
 	return v_actual;
 
-msix_err:
-	devm_kfree(dev, pf->msix_entries);
-
 exit_err:
 	pf->num_rdma_msix = 0;
 	pf->num_lan_msix = 0;
 	return err;
 }
 
-/**
- * ice_dis_msix - Disable MSI-X interrupt setup in OS
- * @pf: board private structure
- */
-static void ice_dis_msix(struct ice_pf *pf)
-{
-	pci_disable_msix(pf->pdev);
-	devm_kfree(ice_pf_to_dev(pf), pf->msix_entries);
-	pf->msix_entries = NULL;
-}
-
 /**
  * ice_clear_interrupt_scheme - Undo things done by ice_init_interrupt_scheme
  * @pf: board private structure
  */
 void ice_clear_interrupt_scheme(struct ice_pf *pf)
 {
-	ice_dis_msix(pf);
+	pci_free_irq_vectors(pf->pdev);
 
 	if (pf->irq_tracker) {
 		devm_kfree(ice_pf_to_dev(pf), pf->irq_tracker);
@@ -213,7 +189,7 @@ int ice_init_interrupt_scheme(struct ice_pf *pf)
 						   vectors),
 				       GFP_KERNEL);
 	if (!pf->irq_tracker) {
-		ice_dis_msix(pf);
+		pci_free_irq_vectors(pf->pdev);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c103be660a9c..ce8cd49ae10c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3243,10 +3243,8 @@ static void ice_free_irq_msix_misc(struct ice_pf *pf)
 	wr32(hw, PFINT_OICR_ENA, 0);
 	ice_flush(hw);
 
-	if (pf->msix_entries) {
-		synchronize_irq(misc_irq_num);
-		devm_free_irq(ice_pf_to_dev(pf), misc_irq_num, pf);
-	}
+	synchronize_irq(misc_irq_num);
+	devm_free_irq(ice_pf_to_dev(pf), misc_irq_num, pf);
 
 	pf->num_avail_sw_msix += 1;
 	ice_free_res(pf->irq_tracker, pf->oicr_idx, ICE_RES_MISC_VEC_ID);
-- 
2.38.1


