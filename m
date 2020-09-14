Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA1326937B
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgINRdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:33:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:61353 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgINRcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 13:32:31 -0400
IronPort-SDR: 7J2yT+i2F6J7RsYX5E+O3ay9FvtvrCgc9RCPXCPay9cqTUOJx8BFMFRu8tGenae/N3DX4jfxvN
 WfgjtvsLVqQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160056111"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="160056111"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 10:32:31 -0700
IronPort-SDR: gGD8QZRyomqc9u1p+8HiWYx8UgppjAEGR02dQVmCXmjJCqSv+01wZb7Ji5Op6TUIVybfOmFvBs
 wMkWWSzCyYrQ==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="319137311"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 10:32:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next v2 1/5] i40e: not compute affinity_mask for IRQ
Date:   Mon, 14 Sep 2020 10:32:20 -0700
Message-Id: <20200914173224.692707-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200914173224.692707-1-anthony.l.nguyen@intel.com>
References: <20200914173224.692707-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

After commit 759dc4a7e605 ("i40e: initialize our affinity_mask
based on cpu_possible_mask"), NAPI IRQ affinity_mask is bind to
all possible CPUs, not a fixed CPU

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 05c6d3ea11e6..9cfaa99da4e6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11186,11 +11186,10 @@ static int i40e_init_msix(struct i40e_pf *pf)
  * i40e_vsi_alloc_q_vector - Allocate memory for a single interrupt vector
  * @vsi: the VSI being configured
  * @v_idx: index of the vector in the vsi struct
- * @cpu: cpu to be used on affinity_mask
  *
  * We allocate one q_vector.  If allocation fails we return -ENOMEM.
  **/
-static int i40e_vsi_alloc_q_vector(struct i40e_vsi *vsi, int v_idx, int cpu)
+static int i40e_vsi_alloc_q_vector(struct i40e_vsi *vsi, int v_idx)
 {
 	struct i40e_q_vector *q_vector;
 
@@ -11223,7 +11222,7 @@ static int i40e_vsi_alloc_q_vector(struct i40e_vsi *vsi, int v_idx, int cpu)
 static int i40e_vsi_alloc_q_vectors(struct i40e_vsi *vsi)
 {
 	struct i40e_pf *pf = vsi->back;
-	int err, v_idx, num_q_vectors, current_cpu;
+	int err, v_idx, num_q_vectors;
 
 	/* if not MSIX, give the one vector only to the LAN VSI */
 	if (pf->flags & I40E_FLAG_MSIX_ENABLED)
@@ -11233,15 +11232,10 @@ static int i40e_vsi_alloc_q_vectors(struct i40e_vsi *vsi)
 	else
 		return -EINVAL;
 
-	current_cpu = cpumask_first(cpu_online_mask);
-
 	for (v_idx = 0; v_idx < num_q_vectors; v_idx++) {
-		err = i40e_vsi_alloc_q_vector(vsi, v_idx, current_cpu);
+		err = i40e_vsi_alloc_q_vector(vsi, v_idx);
 		if (err)
 			goto err_out;
-		current_cpu = cpumask_next(current_cpu, cpu_online_mask);
-		if (unlikely(current_cpu >= nr_cpu_ids))
-			current_cpu = cpumask_first(cpu_online_mask);
 	}
 
 	return 0;
-- 
2.26.2

