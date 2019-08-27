Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6316B9F05F
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730390AbfH0Qin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:38:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:10368 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730306AbfH0Qig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:38:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:38:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331876366"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 09:38:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/15] ice: Rework ice_ena_msix_range
Date:   Tue, 27 Aug 2019 09:38:31 -0700
Message-Id: <20190827163832.8362-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

The current implementation of ice_ena_msix_range is difficult to read
and has subtle issues. This patch reworks the said function for
clarity and correctness.

More specifically,

1. Add more checks to bail out of 'needed' is greater than 'v_left'.

2. Simplify fallback logic

3. Do not set pf->num_avail_sw_msix in ice_ena_msix_range as it
   gets overwritten by ice_init_interrupt_scheme.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 32 +++++++++++++++--------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2499c7ee5038..9371148dc489 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2281,13 +2281,18 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 
 	/* reserve one vector for miscellaneous handler */
 	needed = 1;
+	if (v_left < needed)
+		goto no_hw_vecs_left_err;
 	v_budget += needed;
 	v_left -= needed;
 
 	/* reserve vectors for LAN traffic */
-	pf->num_lan_msix = min_t(int, num_online_cpus(), v_left);
-	v_budget += pf->num_lan_msix;
-	v_left -= pf->num_lan_msix;
+	needed = min_t(int, num_online_cpus(), v_left);
+	if (v_left < needed)
+		goto no_hw_vecs_left_err;
+	pf->num_lan_msix = needed;
+	v_budget += needed;
+	v_left -= needed;
 
 	pf->msix_entries = devm_kcalloc(&pf->pdev->dev, v_budget,
 					sizeof(*pf->msix_entries), GFP_KERNEL);
@@ -2312,18 +2317,18 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 
 	if (v_actual < v_budget) {
 		dev_warn(&pf->pdev->dev,
-			 "not enough vectors. requested = %d, obtained = %d\n",
+			 "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
 			 v_budget, v_actual);
-		if (v_actual >= (pf->num_lan_msix + 1)) {
-			pf->num_avail_sw_msix = v_actual -
-						(pf->num_lan_msix + 1);
-		} else if (v_actual >= 2) {
-			pf->num_lan_msix = 1;
-			pf->num_avail_sw_msix = v_actual - 2;
-		} else {
+/* 2 vectors for LAN (traffic + OICR) */
+#define ICE_MIN_LAN_VECS 2
+
+		if (v_actual < ICE_MIN_LAN_VECS) {
+			/* error if we can't get minimum vectors */
 			pci_disable_msix(pf->pdev);
 			err = -ERANGE;
 			goto msix_err;
+		} else {
+			pf->num_lan_msix = ICE_MIN_LAN_VECS;
 		}
 	}
 
@@ -2333,6 +2338,11 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	devm_kfree(&pf->pdev->dev, pf->msix_entries);
 	goto exit_err;
 
+no_hw_vecs_left_err:
+	dev_err(&pf->pdev->dev,
+		"not enough device MSI-X vectors. requested = %d, available = %d\n",
+		needed, v_left);
+	err = -ERANGE;
 exit_err:
 	pf->num_lan_msix = 0;
 	return err;
-- 
2.21.0

