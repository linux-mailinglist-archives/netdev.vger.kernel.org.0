Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08085314579
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhBIBRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:17:12 -0500
Received: from mga04.intel.com ([192.55.52.120]:52204 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230139AbhBIBRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 20:17:03 -0500
IronPort-SDR: ahFWnzuXzue6y0/CvJ6lFhP/+bsKQ+96p01chqP6u0H0phTZUFCGyEvkfKsz/InU5oxKnwimvd
 USTNRHhidXrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="179250877"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="179250877"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 17:15:49 -0800
IronPort-SDR: W4dou8mL4ywExYj31DJ3/3qLsNrHSVxC31BUmTN/cf3Gf1MeZCupginiC9aSLzkfqNGz6q5oH8
 05+2vePWkjaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="487669629"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2021 17:15:48 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 11/12] ice: Improve MSI-X fallback logic
Date:   Mon,  8 Feb 2021 17:16:35 -0800
Message-Id: <20210209011636.1989093-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
References: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently if the driver is unable to get all the MSI-X vectors it wants, it
falls back to the minimum configuration which equates to a single Tx/Rx
traffic queue pair. Instead of using the minimum configuration, if given
more vectors than the minimum, utilize those vectors for additional traffic
queues after accounting for other interrupts.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 40 ++++++++++++++---------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0bc0cd9ba188..813ec6b8ac23 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3391,28 +3391,20 @@ static int ice_init_pf(struct ice_pf *pf)
  */
 static int ice_ena_msix_range(struct ice_pf *pf)
 {
+	int v_left, v_actual, v_other, v_budget = 0;
 	struct device *dev = ice_pf_to_dev(pf);
-	int v_left, v_actual, v_budget = 0;
 	int needed, err, i;
 
 	v_left = pf->hw.func_caps.common_cap.num_msix_vectors;
 
-	/* reserve one vector for miscellaneous handler */
-	needed = 1;
+	/* reserve for LAN miscellaneous handler */
+	needed = ICE_MIN_LAN_OICR_MSIX;
 	if (v_left < needed)
 		goto no_hw_vecs_left_err;
 	v_budget += needed;
 	v_left -= needed;
 
-	/* reserve vectors for LAN traffic */
-	needed = min_t(int, num_online_cpus(), v_left);
-	if (v_left < needed)
-		goto no_hw_vecs_left_err;
-	pf->num_lan_msix = needed;
-	v_budget += needed;
-	v_left -= needed;
-
-	/* reserve one vector for flow director */
+	/* reserve for flow director */
 	if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
 		needed = ICE_FDIR_MSIX;
 		if (v_left < needed)
@@ -3421,9 +3413,19 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 		v_left -= needed;
 	}
 
+	/* total used for non-traffic vectors */
+	v_other = v_budget;
+
+	/* reserve vectors for LAN traffic */
+	needed = min_t(int, num_online_cpus(), v_left);
+	if (v_left < needed)
+		goto no_hw_vecs_left_err;
+	pf->num_lan_msix = needed;
+	v_budget += needed;
+	v_left -= needed;
+
 	pf->msix_entries = devm_kcalloc(dev, v_budget,
 					sizeof(*pf->msix_entries), GFP_KERNEL);
-
 	if (!pf->msix_entries) {
 		err = -ENOMEM;
 		goto exit_err;
@@ -3435,7 +3437,6 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	/* actually reserve the vectors */
 	v_actual = pci_enable_msix_range(pf->pdev, pf->msix_entries,
 					 ICE_MIN_MSIX, v_budget);
-
 	if (v_actual < 0) {
 		dev_err(dev, "unable to reserve MSI-X vectors\n");
 		err = v_actual;
@@ -3452,7 +3453,16 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 			err = -ERANGE;
 			goto msix_err;
 		} else {
-			pf->num_lan_msix = ICE_MIN_LAN_TXRX_MSIX;
+			int v_traffic = v_actual - v_other;
+
+			if (v_actual == ICE_MIN_MSIX ||
+			    v_traffic < ICE_MIN_LAN_TXRX_MSIX)
+				pf->num_lan_msix = ICE_MIN_LAN_TXRX_MSIX;
+			else
+				pf->num_lan_msix = v_traffic;
+
+			dev_notice(dev, "Enabled %d MSI-X vectors for LAN traffic.\n",
+				   pf->num_lan_msix);
 		}
 	}
 
-- 
2.26.2

