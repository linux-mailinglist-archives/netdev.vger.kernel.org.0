Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD384A903E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355517AbiBCVvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:51:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:10070 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355186AbiBCVvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 16:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643925112; x=1675461112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cy2I2J0oORWagRnINtp0JNIiYG/8r3cSqLQ5g+exfaQ=;
  b=TWUy/H9H2XIwyilmz6qu1Vnr+CGtQ2cQgRQCziLj64MqYKowSVDYUXpB
   kVTfTlF+VC8BYzDK+IRo9b37IvTe6FlKavldKQXqbGPrw5kOaQy6i/Kqm
   /3fxUCwoUcAM1LW2EmVc26y3xyogK0iE2TqvTXqibZi8UeZce9uU/yD7t
   pXq7hviZqzXQ/SKhOgaWgn1SRdN1aCJa1KBZeO6YJXJP2VaITsyz8CnAT
   fUyTbll/UpyZUiKsiVgQKNwczJgm18XST1w94LQ5J91bnwNGrFDLOLRUZ
   HFOKBEwsldf4FU+WB7wwE51Fp/XVQRCU6w5zm2U9CHXxQR6Uy6rjyTYgH
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="248025357"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="248025357"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 13:51:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="498295214"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2022 13:51:51 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 7/7] i40e: Fix race condition while adding/deleting MAC/VLAN filters
Date:   Thu,  3 Feb 2022 13:51:40 -0800
Message-Id: <20220203215140.969227-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
References: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

There was a race condition in access to hw->aq.asq_last_status
while adding and deleting  MAC/VLAN filters causing
incorrect error status to be printed as ERROR OK instead of
the correct error.

Change calls to i40e_aq_add_macvlan in i40e_aqc_add_filters
and i40e_aq_remove_macvlan in i40e_aqc_del_filters
to  _v2 versions that return Admin Queue status on the stack
to avoid race conditions in access to hw->aq.asq_last_status.

Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 24 +++++++++++----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 748806cfc441..b2c18615d6cd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2143,19 +2143,19 @@ void i40e_aqc_del_filters(struct i40e_vsi *vsi, const char *vsi_name,
 			  int num_del, int *retval)
 {
 	struct i40e_hw *hw = &vsi->back->hw;
+	enum i40e_admin_queue_err aq_status;
 	i40e_status aq_ret;
-	int aq_err;
 
-	aq_ret = i40e_aq_remove_macvlan(hw, vsi->seid, list, num_del, NULL);
-	aq_err = hw->aq.asq_last_status;
+	aq_ret = i40e_aq_remove_macvlan_v2(hw, vsi->seid, list, num_del, NULL,
+					   &aq_status);
 
 	/* Explicitly ignore and do not report when firmware returns ENOENT */
-	if (aq_ret && !(aq_err == I40E_AQ_RC_ENOENT)) {
+	if (aq_ret && !(aq_status == I40E_AQ_RC_ENOENT)) {
 		*retval = -EIO;
 		dev_info(&vsi->back->pdev->dev,
 			 "ignoring delete macvlan error on %s, err %s, aq_err %s\n",
 			 vsi_name, i40e_stat_str(hw, aq_ret),
-			 i40e_aq_str(hw, aq_err));
+			 i40e_aq_str(hw, aq_status));
 	}
 }
 
@@ -2178,10 +2178,10 @@ void i40e_aqc_add_filters(struct i40e_vsi *vsi, const char *vsi_name,
 			  int num_add)
 {
 	struct i40e_hw *hw = &vsi->back->hw;
-	int aq_err, fcnt;
+	enum i40e_admin_queue_err aq_status;
+	int fcnt;
 
-	i40e_aq_add_macvlan(hw, vsi->seid, list, num_add, NULL);
-	aq_err = hw->aq.asq_last_status;
+	i40e_aq_add_macvlan_v2(hw, vsi->seid, list, num_add, NULL, &aq_status);
 	fcnt = i40e_update_filter_state(num_add, list, add_head);
 
 	if (fcnt != num_add) {
@@ -2189,17 +2189,19 @@ void i40e_aqc_add_filters(struct i40e_vsi *vsi, const char *vsi_name,
 			set_bit(__I40E_VSI_OVERFLOW_PROMISC, vsi->state);
 			dev_warn(&vsi->back->pdev->dev,
 				 "Error %s adding RX filters on %s, promiscuous mode forced on\n",
-				 i40e_aq_str(hw, aq_err), vsi_name);
+				 i40e_aq_str(hw, aq_status), vsi_name);
 		} else if (vsi->type == I40E_VSI_SRIOV ||
 			   vsi->type == I40E_VSI_VMDQ1 ||
 			   vsi->type == I40E_VSI_VMDQ2) {
 			dev_warn(&vsi->back->pdev->dev,
 				 "Error %s adding RX filters on %s, please set promiscuous on manually for %s\n",
-				 i40e_aq_str(hw, aq_err), vsi_name, vsi_name);
+				 i40e_aq_str(hw, aq_status), vsi_name,
+					     vsi_name);
 		} else {
 			dev_warn(&vsi->back->pdev->dev,
 				 "Error %s adding RX filters on %s, incorrect VSI type: %i.\n",
-				 i40e_aq_str(hw, aq_err), vsi_name, vsi->type);
+				 i40e_aq_str(hw, aq_status), vsi_name,
+					     vsi->type);
 		}
 	}
 }
-- 
2.31.1

