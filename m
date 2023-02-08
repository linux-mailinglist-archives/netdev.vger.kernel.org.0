Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD5368F23F
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 16:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjBHPl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 10:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjBHPlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 10:41:22 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B075049001;
        Wed,  8 Feb 2023 07:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675870880; x=1707406880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CMviFYN8WaZJ3J3sp7VBjtnbhJB9FGlUbTZgSmraYhs=;
  b=ehqv4EnTYE3HGq6ttBryt5Lkig5eNPTJhmH/cImvi12Kr5z30wGTHBNN
   66g9F0b9lXZJ4JEgBSznIl2BTL4bondRfBzQ565oAQr5zaLbaiTpRYrNl
   G1TilVjeGC9ON2HX+E+9YIAN4CxgoxkVzGS8Ms19Queaayj6wii3ja6b6
   qaLANf7dElBIC+0smSG9X4aTfD1B36H87j4RDKSo7RU9Vwz15FkBMKn83
   5dOwUTfS7NGEQA6HTa9TF1mpjGnkw5N7a5l/C2GOaO4wf1T0GEo0kr2jt
   oL+7eRNZyOuwFxFGFvZkF/Ep5psgVk6/OtTe5NZyfZq7sAmfBT5GjwSUs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="317834817"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="317834817"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 07:41:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="669227604"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="669227604"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga007.fm.intel.com with ESMTP; 08 Feb 2023 07:41:12 -0800
Received: from baltimore.igk.intel.com (baltimore.igk.intel.com [10.102.21.1])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 673E133EB8;
        Wed,  8 Feb 2023 15:41:10 +0000 (GMT)
From:   Pawel Chmielewski <pawel.chmielewski@intel.com>
To:     yury.norov@gmail.com
Cc:     Jonathan.Cameron@huawei.com, andriy.shevchenko@linux.intel.com,
        baohua@kernel.org, bristot@redhat.com, bsegall@google.com,
        davem@davemloft.net, dietmar.eggemann@arm.com, gal@nvidia.com,
        gregkh@linuxfoundation.org, hca@linux.ibm.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        jgg@nvidia.com, juri.lelli@redhat.com, kuba@kernel.org,
        leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@redhat.com,
        netdev@vger.kernel.org, peter@n8pjl.ca, peterz@infradead.org,
        rostedt@goodmis.org, saeedm@nvidia.com, tariqt@nvidia.com,
        tony.luck@intel.com, torvalds@linux-foundation.org,
        ttoukan.linux@gmail.com, vincent.guittot@linaro.org,
        vschneid@redhat.com,
        Pawel Chmielewski <pawel.chmielewski@intel.com>
Subject: [PATCH 1/1] ice: Change assigning method of the CPU affinity masks
Date:   Wed,  8 Feb 2023 16:39:05 +0100
Message-Id: <20230208153905.109912-1-pawel.chmielewski@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230121042436.2661843-1-yury.norov@gmail.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
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

With the introduction of sched_numa_hop_mask() and
for_each_numa_hop_mask(), the affinity masks for queue vectors can be
conveniently set by preferring the CPUs that are closest to the NUMA node
of the parent PCI device.

Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index e864634d66bc..fd3550d15c9e 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -122,8 +122,6 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
 	if (vsi->type == ICE_VSI_VF)
 		goto out;
 	/* only set affinity_mask if the CPU is online */
-	if (cpu_online(v_idx))
-		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
 
 	/* This will not be called in the driver load path because the netdev
 	 * will not be created yet. All other cases with register the NAPI
@@ -659,8 +657,10 @@ int ice_vsi_wait_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
  */
 int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
 {
+	cpumask_t *aff_mask, *last_aff_mask = cpu_none_mask;
 	struct device *dev = ice_pf_to_dev(vsi->back);
-	u16 v_idx;
+	int numa_node = dev->numa_node;
+	u16 v_idx, cpu = 0;
 	int err;
 
 	if (vsi->q_vectors[0]) {
@@ -674,6 +674,17 @@ int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
 			goto err_out;
 	}
 
+	v_idx = 0;
+	for_each_numa_hop_mask(aff_mask, numa_node) {
+		for_each_cpu_andnot(cpu, aff_mask, last_aff_mask)
+			if (v_idx < vsi->num_q_vectors) {
+				if (cpu_online(cpu))
+					cpumask_set_cpu(cpu, &vsi->q_vectors[v_idx]->affinity_mask);
+				v_idx++;
+			}
+		last_aff_mask = aff_mask;
+	}
+
 	return 0;
 
 err_out:
-- 
2.37.3

