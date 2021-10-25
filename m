Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091E043A555
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhJYVAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:00:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:2993 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232467AbhJYVAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 17:00:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10148"; a="209846552"
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="209846552"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 13:58:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="446799560"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 25 Oct 2021 13:58:03 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Yongxin Liu <yongxin.liu@windriver.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 2/2] ice: check whether PTP is initialized in ice_ptp_release()
Date:   Mon, 25 Oct 2021 13:56:22 -0700
Message-Id: <20211025205622.1967785-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205622.1967785-1-anthony.l.nguyen@intel.com>
References: <20211025205622.1967785-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yongxin Liu <yongxin.liu@windriver.com>

PTP is currently only supported on E810 devices, it is checked
in ice_ptp_init(). However, there is no check in ice_ptp_release().
For other E800 series devices, ice_ptp_release() will be wrongly executed.

Fix the following calltrace.

  INFO: trying to register non-static key.
  The code is fine but needs lockdep annotation, or maybe
  you didn't initialize this object before use?
  turning off the locking correctness validator.
  Workqueue: ice ice_service_task [ice]
  Call Trace:
   dump_stack_lvl+0x5b/0x82
   dump_stack+0x10/0x12
   register_lock_class+0x495/0x4a0
   ? find_held_lock+0x3c/0xb0
   __lock_acquire+0x71/0x1830
   lock_acquire+0x1e6/0x330
   ? ice_ptp_release+0x3c/0x1e0 [ice]
   ? _raw_spin_lock+0x19/0x70
   ? ice_ptp_release+0x3c/0x1e0 [ice]
   _raw_spin_lock+0x38/0x70
   ? ice_ptp_release+0x3c/0x1e0 [ice]
   ice_ptp_release+0x3c/0x1e0 [ice]
   ice_prepare_for_reset+0xcb/0xe0 [ice]
   ice_do_reset+0x38/0x110 [ice]
   ice_service_task+0x138/0xf10 [ice]
   ? __this_cpu_preempt_check+0x13/0x20
   process_one_work+0x26a/0x650
   worker_thread+0x3f/0x3b0
   ? __kthread_parkme+0x51/0xb0
   ? process_one_work+0x650/0x650
   kthread+0x161/0x190
   ? set_kthread_struct+0x40/0x40
   ret_from_fork+0x1f/0x30

Fixes: 4dd0d5c33c3e ("ice: add lock around Tx timestamp tracker flush")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 80380aed8882..d1ef3d48a4b0 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1571,6 +1571,9 @@ void ice_ptp_init(struct ice_pf *pf)
  */
 void ice_ptp_release(struct ice_pf *pf)
 {
+	if (!test_bit(ICE_FLAG_PTP, pf->flags))
+		return;
+
 	/* Disable timestamping for both Tx and Rx */
 	ice_ptp_cfg_timestamp(pf, false);
 
-- 
2.31.1

