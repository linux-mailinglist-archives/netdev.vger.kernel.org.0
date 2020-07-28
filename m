Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A50231232
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbgG1TJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:09:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:43602 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728978AbgG1TIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 15:08:51 -0400
IronPort-SDR: MVyZNGokTDT9bI7ymBwL8Qr9PjklCGAVvPbdqf2xJUdgrPU3daql+EghJsDwpU2WWjN1Qb5Yi5
 FUkfE6tlOddg==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="236163823"
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="236163823"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 12:08:50 -0700
IronPort-SDR: Sbh7jBXu510kRcR2POiBDssc1X+E7wcPw43YkI6OUuIDihAmmTCOq7gVAN1A8z2r/GMKIyikJP
 eoAOkSpgoYkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="490006223"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jul 2020 12:08:48 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 1/6] i40e: not compute affinity_mask for IRQ
Date:   Tue, 28 Jul 2020 12:08:37 -0700
Message-Id: <20200728190842.1284145-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
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
index dadbfb3d2a2b..523c07961b4b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11185,11 +11185,10 @@ static int i40e_init_msix(struct i40e_pf *pf)
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
 
@@ -11222,7 +11221,7 @@ static int i40e_vsi_alloc_q_vector(struct i40e_vsi *vsi, int v_idx, int cpu)
 static int i40e_vsi_alloc_q_vectors(struct i40e_vsi *vsi)
 {
 	struct i40e_pf *pf = vsi->back;
-	int err, v_idx, num_q_vectors, current_cpu;
+	int err, v_idx, num_q_vectors;
 
 	/* if not MSIX, give the one vector only to the LAN VSI */
 	if (pf->flags & I40E_FLAG_MSIX_ENABLED)
@@ -11232,15 +11231,10 @@ static int i40e_vsi_alloc_q_vectors(struct i40e_vsi *vsi)
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

