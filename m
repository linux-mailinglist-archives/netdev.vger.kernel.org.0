Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67ECA30115B
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbhAWADf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:03:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:38839 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726789AbhAWACE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 19:02:04 -0500
IronPort-SDR: s9/zc1zf8bo0Qr1GlCliDWhfseIjD7bjzl2PgcuCCAfsdpi+8xXAVko253dZEmt5JnvPhLbR0y
 XJUmo2MzDXKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="179670517"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="179670517"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:57:02 -0800
IronPort-SDR: vnaukxOy58g8+rCmMhmQH7JBA4MBrlPTCbCzYS5zg1gpJjM60BsvuTMWJznUi/lkRo0ZJqB7YB
 UcOOJYvAshZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="428258695"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 22 Jan 2021 15:57:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 7/7] i40e: acquire VSI pointer only after VF is initialized
Date:   Fri, 22 Jan 2021 15:57:34 -0800
Message-Id: <20210122235734.447240-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
References: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
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

