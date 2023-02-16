Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4688B699805
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjBPO4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjBPO4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:56:11 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AD15454D;
        Thu, 16 Feb 2023 06:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676559363; x=1708095363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M7bCw9YBvd+whohCI1z9/R8TgpQAstWxF8zfxUADeKg=;
  b=DUWtrc0+Ckzr5kymXHnLzun3pIm3hwT7nkFh1amt+/c8AsQfF/xbVHOc
   scn/g8qCZjaiL6XpS6rA++ypZ2Fawb0tJ1FQOdk0n8/iio4wmpFq8AGJp
   FS6Vdh7b9afpsiihKO3xeXNB4yyJZeAuRdGg738dgN/MceszpvpzHDwMJ
   U7T2qax95lU9R3hPoOr+lHcMZbDrTw/PMiyOoKLB4Jo4WlmC6IcVuiSFC
   +YtET/abqUh6R9bIc6JKpvhM1VRAwXAQnRiV8ECPnEkBH19s3keimhz24
   ORICC3R1vfnEo0kLIW7DkcYBVtVqr9OY3seAWN/FdgZudAKjkb9nO+Lxg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="312094412"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="312094412"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 06:56:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="733895702"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="733895702"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2023 06:55:57 -0800
Received: from baltimore.igk.intel.com (baltimore.igk.intel.com [10.102.21.1])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id AB1E9365A7;
        Thu, 16 Feb 2023 14:55:54 +0000 (GMT)
From:   Pawel Chmielewski <pawel.chmielewski@intel.com>
To:     pawel.chmielewski@intel.com
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
        vschneid@redhat.com, yury.norov@gmail.com
Subject: [PATCH v2 1/1] ice: Change assigning method of the CPU affinity masks
Date:   Thu, 16 Feb 2023 15:54:55 +0100
Message-Id: <20230216145455.661709-1-pawel.chmielewski@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230208153905.109912-1-pawel.chmielewski@intel.com>
References: <20230208153905.109912-1-pawel.chmielewski@intel.com>
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

Changes since v1:
 * Removed obsolete comment
 * Inverted condition for loop escape
 * Incrementing v_idx only in case of available cpu
---
 drivers/net/ethernet/intel/ice/ice_base.c | 24 +++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 9e36f01dfa4f..27b00d224c5d 100644
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
@@ -659,8 +656,10 @@ int ice_vsi_wait_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
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
@@ -674,6 +673,23 @@ int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
 			goto err_out;
 	}
 
+	v_idx = 0;
+
+	for_each_numa_hop_mask(aff_mask, numa_node) {
+		for_each_cpu_andnot(cpu, aff_mask, last_aff_mask) {
+			if (v_idx >= vsi->num_q_vectors)
+				goto out;
+
+			if (cpu_online(cpu)) {
+				cpumask_set_cpu(cpu, &vsi->q_vectors[v_idx]->affinity_mask);
+				v_idx++;
+			}
+		}
+
+		last_aff_mask = aff_mask;
+	}
+
+out:
 	return 0;
 
 err_out:
-- 
2.37.3

