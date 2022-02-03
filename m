Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952F24A9038
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355524AbiBCVv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:51:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:63987 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355312AbiBCVvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 16:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643925112; x=1675461112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V8ynDIzwgT6QM+pa7C5mbSFmWEf5XYW8F0m3ICOPZaw=;
  b=XpKtzJdtF4cpJ1f+xWvfoNkpUNcsQl7IC69rqA1lLZxM3BAXvoFJEJ6z
   gMnk/X7TnIzsFNV0PHTwNuORe9dGtg3lJ6D6pJHU4MPmLogaMF+iddXso
   HPcv2NCMkNY0FlO/0WPj2pFnKqGZdoTweaXqq2Sc72aIHZorNM9STpP4x
   925Zs0T7G3/DU1F4X1G6V1auNC/SVgFZCaWOLC9P8E0DVxj5Mp6eP7PRu
   DF3kMJBRjVqZ67mPA9WKg/Pr0bAXl4v1X5hBDIm9t24DLyhTy1v+TRjku
   CeRszuwfOOWFVPwAqtOHh4L480w3LYeUV1MNDSnR++eFz9mKGyFzyr+Qw
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="272760135"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="272760135"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 13:51:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="498295212"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2022 13:51:51 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 6/7] i40e: Add new version of i40e_aq_add_macvlan function
Date:   Thu,  3 Feb 2022 13:51:39 -0800
Message-Id: <20220203215140.969227-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
References: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

ASQ send command functions are returning only i40e status codes
yet some calling functions also need Admin Queue status
that is stored in hw->aq.asq_last_status. Since hw object
is stored on a heap it introduces a possibility for
a race condition in access to hw if calling function is not
fast enough to read hw->aq.asq_last_status before next
send ASQ command is executed.

Add new _v2 version of i40e_aq_add_macvlan that is using
new _v2 versions of ASQ send command functions and returns
the Admin Queue status on the stack.

Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 92 +++++++++++++++----
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  5 +
 2 files changed, 77 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index d3e2b3005f86..6aefffd83615 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -2634,33 +2634,28 @@ i40e_status i40e_aq_get_veb_parameters(struct i40e_hw *hw,
 }
 
 /**
- * i40e_aq_add_macvlan
- * @hw: pointer to the hw struct
- * @seid: VSI for the mac address
+ * i40e_prepare_add_macvlan
  * @mv_list: list of macvlans to be added
+ * @desc: pointer to AQ descriptor structure
  * @count: length of the list
- * @cmd_details: pointer to command details structure or NULL
+ * @seid: VSI for the mac address
  *
- * Add MAC/VLAN addresses to the HW filtering
+ * Internal helper function that prepares the add macvlan request
+ * and returns the buffer size.
  **/
-i40e_status i40e_aq_add_macvlan(struct i40e_hw *hw, u16 seid,
-			struct i40e_aqc_add_macvlan_element_data *mv_list,
-			u16 count, struct i40e_asq_cmd_details *cmd_details)
+static u16
+i40e_prepare_add_macvlan(struct i40e_aqc_add_macvlan_element_data *mv_list,
+			 struct i40e_aq_desc *desc, u16 count, u16 seid)
 {
-	struct i40e_aq_desc desc;
 	struct i40e_aqc_macvlan *cmd =
-		(struct i40e_aqc_macvlan *)&desc.params.raw;
-	i40e_status status;
+		(struct i40e_aqc_macvlan *)&desc->params.raw;
 	u16 buf_size;
 	int i;
 
-	if (count == 0 || !mv_list || !hw)
-		return I40E_ERR_PARAM;
-
 	buf_size = count * sizeof(*mv_list);
 
 	/* prep the rest of the request */
-	i40e_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_add_macvlan);
+	i40e_fill_default_direct_cmd_desc(desc, i40e_aqc_opc_add_macvlan);
 	cmd->num_addresses = cpu_to_le16(count);
 	cmd->seid[0] = cpu_to_le16(I40E_AQC_MACVLAN_CMD_SEID_VALID | seid);
 	cmd->seid[1] = 0;
@@ -2671,14 +2666,71 @@ i40e_status i40e_aq_add_macvlan(struct i40e_hw *hw, u16 seid,
 			mv_list[i].flags |=
 			       cpu_to_le16(I40E_AQC_MACVLAN_ADD_USE_SHARED_MAC);
 
-	desc.flags |= cpu_to_le16((u16)(I40E_AQ_FLAG_BUF | I40E_AQ_FLAG_RD));
+	desc->flags |= cpu_to_le16((u16)(I40E_AQ_FLAG_BUF | I40E_AQ_FLAG_RD));
 	if (buf_size > I40E_AQ_LARGE_BUF)
-		desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_LB);
+		desc->flags |= cpu_to_le16((u16)I40E_AQ_FLAG_LB);
 
-	status = i40e_asq_send_command_atomic(hw, &desc, mv_list, buf_size,
-					      cmd_details, true);
+	return buf_size;
+}
 
-	return status;
+/**
+ * i40e_aq_add_macvlan
+ * @hw: pointer to the hw struct
+ * @seid: VSI for the mac address
+ * @mv_list: list of macvlans to be added
+ * @count: length of the list
+ * @cmd_details: pointer to command details structure or NULL
+ *
+ * Add MAC/VLAN addresses to the HW filtering
+ **/
+i40e_status
+i40e_aq_add_macvlan(struct i40e_hw *hw, u16 seid,
+		    struct i40e_aqc_add_macvlan_element_data *mv_list,
+		    u16 count, struct i40e_asq_cmd_details *cmd_details)
+{
+	struct i40e_aq_desc desc;
+	u16 buf_size;
+
+	if (count == 0 || !mv_list || !hw)
+		return I40E_ERR_PARAM;
+
+	buf_size = i40e_prepare_add_macvlan(mv_list, &desc, count, seid);
+
+	return i40e_asq_send_command_atomic(hw, &desc, mv_list, buf_size,
+					    cmd_details, true);
+}
+
+/**
+ * i40e_aq_add_macvlan_v2
+ * @hw: pointer to the hw struct
+ * @seid: VSI for the mac address
+ * @mv_list: list of macvlans to be added
+ * @count: length of the list
+ * @cmd_details: pointer to command details structure or NULL
+ * @aq_status: pointer to Admin Queue status return value
+ *
+ * Add MAC/VLAN addresses to the HW filtering.
+ * The _v2 version returns the last Admin Queue status in aq_status
+ * to avoid race conditions in access to hw->aq.asq_last_status.
+ * It also calls _v2 versions of asq_send_command functions to
+ * get the aq_status on the stack.
+ **/
+i40e_status
+i40e_aq_add_macvlan_v2(struct i40e_hw *hw, u16 seid,
+		       struct i40e_aqc_add_macvlan_element_data *mv_list,
+		       u16 count, struct i40e_asq_cmd_details *cmd_details,
+		       enum i40e_admin_queue_err *aq_status)
+{
+	struct i40e_aq_desc desc;
+	u16 buf_size;
+
+	if (count == 0 || !mv_list || !hw)
+		return I40E_ERR_PARAM;
+
+	buf_size = i40e_prepare_add_macvlan(mv_list, &desc, count, seid);
+
+	return i40e_asq_send_command_atomic_v2(hw, &desc, mv_list, buf_size,
+					       cmd_details, true, aq_status);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index 4ace56a911d9..ebdcde6f1aeb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -165,6 +165,11 @@ i40e_status i40e_aq_get_veb_parameters(struct i40e_hw *hw,
 i40e_status i40e_aq_add_macvlan(struct i40e_hw *hw, u16 vsi_id,
 			struct i40e_aqc_add_macvlan_element_data *mv_list,
 			u16 count, struct i40e_asq_cmd_details *cmd_details);
+i40e_status
+i40e_aq_add_macvlan_v2(struct i40e_hw *hw, u16 seid,
+		       struct i40e_aqc_add_macvlan_element_data *mv_list,
+		       u16 count, struct i40e_asq_cmd_details *cmd_details,
+		       enum i40e_admin_queue_err *aq_status);
 i40e_status i40e_aq_remove_macvlan(struct i40e_hw *hw, u16 vsi_id,
 			struct i40e_aqc_remove_macvlan_element_data *mv_list,
 			u16 count, struct i40e_asq_cmd_details *cmd_details);
-- 
2.31.1

