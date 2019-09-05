Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB34AAD16
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391684AbfIEUeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:45343 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391663AbfIEUeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136557"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/16] ice: Check for DCB capability before initializing DCB
Date:   Thu,  5 Sep 2019 13:34:00 -0700
Message-Id: <20190905203406.4152-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
References: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Check the ICE_FLAG_DCB_CAPABLE before calling ice_init_pf_dcb.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  3 ---
 drivers/net/ethernet/intel/ice/ice_main.c    | 15 ++++++++-------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index e922adf1fa15..20f440a64650 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -474,7 +474,6 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 		}
 
 		pf->dcbx_cap = DCB_CAP_DCBX_HOST | DCB_CAP_DCBX_VER_IEEE;
-		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 		return 0;
 	}
 
@@ -483,8 +482,6 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 	/* DCBX in FW and LLDP enabled in FW */
 	pf->dcbx_cap = DCB_CAP_DCBX_LLD_MANAGED | DCB_CAP_DCBX_VER_IEEE;
 
-	set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
-
 	err = ice_dcb_init_cfg(pf, locked);
 	if (err)
 		goto dcb_init_err;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 703fc7bf2b31..8bb3b81876a9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2252,6 +2252,8 @@ static void ice_deinit_pf(struct ice_pf *pf)
 static int ice_init_pf(struct ice_pf *pf)
 {
 	bitmap_zero(pf->flags, ICE_PF_FLAGS_NBITS);
+	if (pf->hw.func_caps.common_cap.dcb)
+		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 #ifdef CONFIG_PCI_IOV
 	if (pf->hw.func_caps.common_cap.sr_iov_1_1) {
 		struct ice_hw *hw = &pf->hw;
@@ -2529,13 +2531,12 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_init_pf_unroll;
 	}
 
-	err = ice_init_pf_dcb(pf, false);
-	if (err) {
-		clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
-		clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
-
-		/* do not fail overall init if DCB init fails */
-		err = 0;
+	if (test_bit(ICE_FLAG_DCB_CAPABLE, pf->flags)) {
+		/* Note: DCB init failure is non-fatal to load */
+		if (ice_init_pf_dcb(pf, false)) {
+			clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
+			clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
+		}
 	}
 
 	ice_determine_q_usage(pf);
-- 
2.21.0

