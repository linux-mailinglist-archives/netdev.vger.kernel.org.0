Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1713D69B537
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjBQWFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBQWFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:05:13 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F2764B23
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676671505; x=1708207505;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kPLci2mPN5adOlpycF82Cz5uAugMGWK5mPO9s8BQBCc=;
  b=KQBytPBBjGKJVcPEhU9lj9pz88YacPwotaoS/PdjkkgNUlp0DsLl+GfH
   1hRPhIi/3zN0Sqgdc4I/QJcxgd4v/6KB+5gmLUf1VF6wCASCmjxmFyyQM
   dmElOhfrWiqZVOnMznQ9BjpFhVZZlMY56wmn0zSFEtNTbpAr4xSdMOsIi
   wO+jxzv82yVepyJsIlwaFP/WE3e3C2GsMO2YdfSnaVePmN/c10m66Rb9g
   eSDzbQQXY56d7jI3qfihFWrBw4X8RWAri97WwMyTdl5PRiIHEQLWNsfiH
   6WTofhiEboQU7JvXIPWL/UcfgxZNVma9m/SH2Ufi1+NQNdHg/PdCX/TNX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="418323017"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="418323017"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 14:05:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="664011441"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="664011441"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga007.jf.intel.com with ESMTP; 17 Feb 2023 14:05:03 -0800
Received: from baltimore.igk.intel.com (baltimore.igk.intel.com [10.102.21.1])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 06B8C37E3E;
        Fri, 17 Feb 2023 22:05:02 +0000 (GMT)
From:   Pawel Chmielewski <pawel.chmielewski@intel.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@osuosl.org,
        Pawel Chmielewski <pawel.chmielewski@intel.com>
Subject: [PATCH net-next v3 1/1] ice: Change assigning method of the CPU affinity masks
Date:   Fri, 17 Feb 2023 23:03:59 +0100
Message-Id: <20230217220359.987004-1-pawel.chmielewski@intel.com>
X-Mailer: git-send-email 2.37.3
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

With the introduction of sched_numa_hop_mask() and for_each_numa_hop_mask(),
the affinity masks for queue vectors can be conveniently set by preferring the
CPUs that are closest to the NUMA node of the parent PCI device.

Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
---
Changes since v2:
 * Pointers for cpumasks point to const struct cpumask
 * Removed unnecessary label
 * Removed redundant blank lines

Changes since v1:
 * Removed obsolete comment
 * Inverted condition for loop escape
 * Incrementing v_idx only in case of available cpu
---
 drivers/net/ethernet/intel/ice/ice_base.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 1911d644dfa8..30dc1c3c290f 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -121,9 +121,6 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
 
 	if (vsi->type == ICE_VSI_VF)
 		goto out;
-	/* only set affinity_mask if the CPU is online */
-	if (cpu_online(v_idx))
-		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
 
 	/* This will not be called in the driver load path because the netdev
 	 * will not be created yet. All other cases with register the NAPI
@@ -662,8 +659,10 @@ int ice_vsi_wait_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
  */
 int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
 {
+	const struct cpumask *aff_mask, *last_aff_mask = cpu_none_mask;
 	struct device *dev = ice_pf_to_dev(vsi->back);
-	u16 v_idx;
+	int numa_node = dev->numa_node;
+	u16 v_idx, cpu = 0;
 	int err;
 
 	if (vsi->q_vectors[0]) {
@@ -677,7 +676,19 @@ int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
 			goto err_out;
 	}
 
-	return 0;
+	v_idx = 0;
+	for_each_numa_hop_mask(aff_mask, numa_node) {
+		for_each_cpu_andnot(cpu, aff_mask, last_aff_mask) {
+			if (v_idx >= vsi->num_q_vectors)
+				return 0;
+
+			if (cpu_online(cpu)) {
+				cpumask_set_cpu(cpu, &vsi->q_vectors[v_idx]->affinity_mask);
+				v_idx++;
+			}
+		}
+		last_aff_mask = aff_mask;
+	}
 
 err_out:
 	while (v_idx--)
-- 
2.37.3

