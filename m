Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254CE349C43
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 23:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhCYWaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 18:30:20 -0400
Received: from mga03.intel.com ([134.134.136.65]:49802 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231191AbhCYW3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 18:29:53 -0400
IronPort-SDR: C17JVsiLBndxqO5eUBVvV5UEm1tnSQ8b74Dm6CsNwzluR3JcI6AaVCPNLTtJedaXLGEJ/nW9FM
 JdQWwVTcWXGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191063403"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="191063403"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 15:29:51 -0700
IronPort-SDR: ECCunQ80bUiLKJyZ+I+tYYZGf+SpXlZE+c9R0iyf8zJjy5QCJ4x4h/PW1WCJxlPpfs/hpgcahH
 tUX4dQxlhXQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="375246726"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 25 Mar 2021 15:29:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Eryk Rybak <eryk.roch.rybak@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/4] i40e: Fix kernel oops when i40e driver removes VF's
Date:   Thu, 25 Mar 2021 15:31:18 -0700
Message-Id: <20210325223119.3991796-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
References: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eryk Rybak <eryk.roch.rybak@intel.com>

Fix the reason of kernel oops when i40e driver removed VFs.
Added new __I40E_VFS_RELEASING state to signalize releasing
process by PF, that it makes possible to exit of reset VF procedure.
Without this patch, it is possible to suspend the VFs reset by
releasing VFs resources procedure. Retrying the reset after the
timeout works on the freed VF memory causing a kernel oops.

Fixes: d43d60e5eb95("i40e: ensure reset occurs when disabling VF")
Signed-off-by: Eryk Rybak <eryk.roch.rybak@intel.com>
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h             | 1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index cd53981fa5e0..15f93b355099 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -142,6 +142,7 @@ enum i40e_state_t {
 	__I40E_VIRTCHNL_OP_PENDING,
 	__I40E_RECOVERY_MODE,
 	__I40E_VF_RESETS_DISABLED,	/* disable resets during i40e_remove */
+	__I40E_VFS_RELEASING,
 	/* This must be last as it determines the size of the BITMAP */
 	__I40E_STATE_SIZE__,
 };
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 1b6ec9be155a..5d301a466f5c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -137,6 +137,7 @@ void i40e_vc_notify_vf_reset(struct i40e_vf *vf)
  **/
 static inline void i40e_vc_disable_vf(struct i40e_vf *vf)
 {
+	struct i40e_pf *pf = vf->pf;
 	int i;
 
 	i40e_vc_notify_vf_reset(vf);
@@ -147,6 +148,11 @@ static inline void i40e_vc_disable_vf(struct i40e_vf *vf)
 	 * ensure a reset.
 	 */
 	for (i = 0; i < 20; i++) {
+		/* If PF is in VFs releasing state reset VF is impossible,
+		 * so leave it.
+		 */
+		if (test_bit(__I40E_VFS_RELEASING, pf->state))
+			return;
 		if (i40e_reset_vf(vf, false))
 			return;
 		usleep_range(10000, 20000);
@@ -1574,6 +1580,8 @@ void i40e_free_vfs(struct i40e_pf *pf)
 
 	if (!pf->vf)
 		return;
+
+	set_bit(__I40E_VFS_RELEASING, pf->state);
 	while (test_and_set_bit(__I40E_VF_DISABLE, pf->state))
 		usleep_range(1000, 2000);
 
@@ -1631,6 +1639,7 @@ void i40e_free_vfs(struct i40e_pf *pf)
 		}
 	}
 	clear_bit(__I40E_VF_DISABLE, pf->state);
+	clear_bit(__I40E_VFS_RELEASING, pf->state);
 }
 
 #ifdef CONFIG_PCI_IOV
-- 
2.26.2

