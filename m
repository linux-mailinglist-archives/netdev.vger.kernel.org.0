Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DFE486BF5
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 22:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244290AbiAFVdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 16:33:42 -0500
Received: from mga06.intel.com ([134.134.136.31]:26402 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244286AbiAFVdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 16:33:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641504821; x=1673040821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KzaBHtXbhhvDr3iKvrl2p87HtFyT/52W69B1JLQxIjs=;
  b=eg/WbGXU/nKwrDvOMXr9FFyHJhYZCgQkMUFsUbF530BFXommVUvjoZTz
   CK2mlgqHFNTCo52mXKM4Cw8o8F9pvGI7L5YFmaq87YCM+wfTsbhwxuHh3
   ehsRR/+R7XljMnXQC54sbzI1/BuHDZJzMWEGElV0sZqdFTT6uvQCW16DE
   jjhxWJhQTau7BoRoY1iWARLIHN9YEGiV3WmENOu+E0ThY7qENf0rvLosz
   ydoFpqECB3ZE6V1QDQUaZ87JyvXBCTowOby7Z5S/vAj+GHNaW7I39bXNI
   7C7kLp3DcfS2b5sE49x1PyhedF+1BURfiSOLbbGhulquJEHHpN5Uf5zOv
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="303490341"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="303490341"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 13:33:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="611972886"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jan 2022 13:33:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 1/7] i40e: Add ensurance of MacVlan resources for every trusted VF
Date:   Thu,  6 Jan 2022 13:32:55 -0800
Message-Id: <20220106213301.11392-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
References: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

Trusted VF can use up every resource available, leaving nothing
to other trusted VFs.
Introduce define, which calculates MacVlan resources available based
on maximum available MacVlan resources, bare minimum for each VF and
number of currently allocated VFs.

Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 34 ++++++++++++++++---
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 048f1678ab8a..b785d09c19f8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2704,12 +2704,21 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
 				      (u8 *)&stats, sizeof(stats));
 }
 
+#define I40E_MAX_MACVLAN_PER_HW 3072
+#define I40E_MAX_MACVLAN_PER_PF(num_ports) (I40E_MAX_MACVLAN_PER_HW /	\
+	(num_ports))
 /* If the VF is not trusted restrict the number of MAC/VLAN it can program
  * MAC filters: 16 for multicast, 1 for MAC, 1 for broadcast
  */
 #define I40E_VC_MAX_MAC_ADDR_PER_VF (16 + 1 + 1)
 #define I40E_VC_MAX_VLAN_PER_VF 16
 
+#define I40E_VC_MAX_MACVLAN_PER_TRUSTED_VF(vf_num, num_ports)		\
+({	typeof(vf_num) vf_num_ = (vf_num);				\
+	typeof(num_ports) num_ports_ = (num_ports);			\
+	((I40E_MAX_MACVLAN_PER_PF(num_ports_) - vf_num_ *		\
+	I40E_VC_MAX_MAC_ADDR_PER_VF) / vf_num_) +			\
+	I40E_VC_MAX_MAC_ADDR_PER_VF; })
 /**
  * i40e_check_vf_permission
  * @vf: pointer to the VF info
@@ -2734,6 +2743,7 @@ static inline int i40e_check_vf_permission(struct i40e_vf *vf,
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = pf->vsi[vf->lan_vsi_idx];
+	struct i40e_hw *hw = &pf->hw;
 	int mac2add_cnt = 0;
 	int i;
 
@@ -2775,12 +2785,26 @@ static inline int i40e_check_vf_permission(struct i40e_vf *vf,
 	 * number of addresses. Check to make sure that the additions do not
 	 * push us over the limit.
 	 */
-	if (!test_bit(I40E_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps) &&
-	    (i40e_count_filters(vsi) + mac2add_cnt) >
+	if (!test_bit(I40E_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps)) {
+		if ((i40e_count_filters(vsi) + mac2add_cnt) >
 		    I40E_VC_MAX_MAC_ADDR_PER_VF) {
-		dev_err(&pf->pdev->dev,
-			"Cannot add more MAC addresses, VF is not trusted, switch the VF to trusted to add more functionality\n");
-		return -EPERM;
+			dev_err(&pf->pdev->dev,
+				"Cannot add more MAC addresses, VF is not trusted, switch the VF to trusted to add more functionality\n");
+			return -EPERM;
+		}
+	/* If this VF is trusted, it can use more resources than untrusted.
+	 * However to ensure that every trusted VF has appropriate number of
+	 * resources, divide whole pool of resources per port and then across
+	 * all VFs.
+	 */
+	} else {
+		if ((i40e_count_filters(vsi) + mac2add_cnt) >
+		    I40E_VC_MAX_MACVLAN_PER_TRUSTED_VF(pf->num_alloc_vfs,
+						       hw->num_ports)) {
+			dev_err(&pf->pdev->dev,
+				"Cannot add more MAC addresses, trusted VF exhausted it's resources\n");
+			return -EPERM;
+		}
 	}
 	return 0;
 }
-- 
2.31.1

