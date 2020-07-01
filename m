Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3402106C2
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 10:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgGAIzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 04:55:08 -0400
Received: from mx134-tc.baidu.com ([61.135.168.134]:51059 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726009AbgGAIzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 04:55:07 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 8DBA52040061;
        Wed,  1 Jul 2020 16:54:53 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Subject: [PATCH] i40e: not compute affinity_mask for IRQ
Date:   Wed,  1 Jul 2020 16:54:53 +0800
Message-Id: <1593593693-31299-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 759dc4a7e605 ("i40e: initialize our affinity_mask
based on cpu_possible_mask"), NAPI IRQ affinity_mask is bind to
all possible cpus, not a fixed cpu

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5d807c8004f8..a63548cb022d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11156,11 +11156,10 @@ static int i40e_init_msix(struct i40e_pf *pf)
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
 
@@ -11193,7 +11192,7 @@ static int i40e_vsi_alloc_q_vector(struct i40e_vsi *vsi, int v_idx, int cpu)
 static int i40e_vsi_alloc_q_vectors(struct i40e_vsi *vsi)
 {
 	struct i40e_pf *pf = vsi->back;
-	int err, v_idx, num_q_vectors, current_cpu;
+	int err, v_idx, num_q_vectors;
 
 	/* if not MSIX, give the one vector only to the LAN VSI */
 	if (pf->flags & I40E_FLAG_MSIX_ENABLED)
@@ -11203,15 +11202,10 @@ static int i40e_vsi_alloc_q_vectors(struct i40e_vsi *vsi)
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
2.16.2

