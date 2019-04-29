Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A15EAB3
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfD2TOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:14:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:61549 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbfD2TOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:14:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 12:14:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="341867057"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2019 12:14:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/12] i40e: fix misleading message about promisc setting on un-trusted VF
Date:   Mon, 29 Apr 2019 12:16:26 -0700
Message-Id: <20190429191628.31212-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>

A refactor of the i40e_vc_config_promiscuous_mode_msg function moved
the check for un-trusted VF into another function. We have to lie to
an un-trusted VF that its request to set promiscuous mode is
successful even when it is not because we don't want the VF to find
out its trust status this way. With the refactor, we were running into
a case where even though we were not setting promiscuous mode for an
un-trusted VF, we still printed a misleading message that it was
successful.

This patch fixes that by ensuring that a success message is printed
on the host side only when the promiscuous mode change has been
successful.

Signed-off-by: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 28 +++++++++++--------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 925ca880bea3..8a6fb9c03955 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1112,15 +1112,6 @@ static i40e_status i40e_config_vf_promiscuous_mode(struct i40e_vf *vf,
 	if (!i40e_vc_isvalid_vsi_id(vf, vsi_id) || !vsi)
 		return I40E_ERR_PARAM;
 
-	if (!test_bit(I40E_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps) &&
-	    (allmulti || alluni)) {
-		dev_err(&pf->pdev->dev,
-			"Unprivileged VF %d is attempting to configure promiscuous mode\n",
-			vf->vf_id);
-		/* Lie to the VF on purpose. */
-		return 0;
-	}
-
 	if (vf->port_vlan_id) {
 		aq_ret = i40e_aq_set_vsi_mc_promisc_on_vlan(hw, vsi->seid,
 							    allmulti,
@@ -1997,8 +1988,21 @@ static int i40e_vc_config_promiscuous_mode_msg(struct i40e_vf *vf, u8 *msg)
 	bool allmulti = false;
 	bool alluni = false;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states))
-		return I40E_ERR_PARAM;
+	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+		aq_ret = I40E_ERR_PARAM;
+		goto err_out;
+	}
+	if (!test_bit(I40E_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps)) {
+		dev_err(&pf->pdev->dev,
+			"Unprivileged VF %d is attempting to configure promiscuous mode\n",
+			vf->vf_id);
+
+		/* Lie to the VF on purpose, because this is an error we can
+		 * ignore. Unprivileged VF is not a virtual channel error.
+		 */
+		aq_ret = 0;
+		goto err_out;
+	}
 
 	/* Multicast promiscuous handling*/
 	if (info->flags & FLAG_VF_MULTICAST_PROMISC)
@@ -2032,7 +2036,7 @@ static int i40e_vc_config_promiscuous_mode_msg(struct i40e_vf *vf, u8 *msg)
 			clear_bit(I40E_VF_STATE_UC_PROMISC, &vf->vf_states);
 		}
 	}
-
+err_out:
 	/* send the response to the VF */
 	return i40e_vc_send_resp_to_vf(vf,
 				       VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
-- 
2.20.1

