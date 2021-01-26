Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731A0304DB2
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387790AbhAZXNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:62462 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728359AbhAZWOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 17:14:50 -0500
IronPort-SDR: DvJXrFtUeB4hQ8ptJ4mvAAxKEhVIoBEzMxVIOvlfBEFV+Grrf/cDu749Ge+HCn65nGhsKDnZVd
 ZQ8KH59wSsWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="179198683"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="179198683"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 14:10:02 -0800
IronPort-SDR: 9qzggDGK2nselNuxxEdyumpvztYBIXCavAgIQrtZGpHPZu9tT6xXzRas5EL70CeWLOc27nYJta
 ZCjBu1eq/8Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="472908334"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 26 Jan 2021 14:10:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net v2 6/7] i40e: acquire VSI pointer only after VF is initialized
Date:   Tue, 26 Jan 2021 14:10:34 -0800
Message-Id: <20210126221035.658124-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
References: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

This change simplifies the VF initialization check and also minimizes
the delay between acquiring the VSI pointer and using it. As known by
the commit being fixed, there is a risk of the VSI pointer getting
changed. Therefore minimize the delay between getting and using the
pointer.

Fixes: 9889707b06ac ("i40e: Fix crash caused by stress setting of VF MAC addresses")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 21ee56420c3a..7efc61aacb0a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -4046,20 +4046,16 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		goto error_param;
 
 	vf = &pf->vf[vf_id];
-	vsi = pf->vsi[vf->lan_vsi_idx];
 
 	/* When the VF is resetting wait until it is done.
 	 * It can take up to 200 milliseconds,
 	 * but wait for up to 300 milliseconds to be safe.
-	 * If the VF is indeed in reset, the vsi pointer has
-	 * to show on the newly loaded vsi under pf->vsi[id].
+	 * Acquire the VSI pointer only after the VF has been
+	 * properly initialized.
 	 */
 	for (i = 0; i < 15; i++) {
-		if (test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
-			if (i > 0)
-				vsi = pf->vsi[vf->lan_vsi_idx];
+		if (test_bit(I40E_VF_STATE_INIT, &vf->vf_states))
 			break;
-		}
 		msleep(20);
 	}
 	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
@@ -4068,6 +4064,7 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		ret = -EAGAIN;
 		goto error_param;
 	}
+	vsi = pf->vsi[vf->lan_vsi_idx];
 
 	if (is_multicast_ether_addr(mac)) {
 		dev_err(&pf->pdev->dev,
-- 
2.26.2

