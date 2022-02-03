Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECE94A903C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355523AbiBCVv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:51:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:63985 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355310AbiBCVvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 16:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643925112; x=1675461112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ChqKG/3qNZHFQ1pO/cbSNK9pMoCS9ZR8GYrDnpt5JQk=;
  b=d4BlglyKlqzStG3SSz8u51sZPIlbUcmDBr5xbvHOhaGRuMI24ypwT18v
   OSgFEGc9K21tjW3YbB98Y90ijeSpIySQzhjHmEnDqgT78Z4mFv0Vj7Uw3
   zpSDtauCJI1gYbXVF+289GmxR4M6+oz/HQmMbgyuANsM/zu/c1FUr71cS
   2/KOrVE5TzGBgmRjGLKE9TWveqirBjyjPQj4i54909eLsCG+kU3OxMgS6
   bJBfdkrSPt1RJvtRx+oKpRGjXcmtsPZQ9IJGVfAvY9+iDDd6Pbt+J4yqN
   nunDJdXt14kPHHm/y1p3XOqG9yzJcwG28iVybysL8MBRez4aWJGyVJ1x7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="272760134"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="272760134"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 13:51:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="498295208"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2022 13:51:51 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 5/7] i40e: Add new versions of send ASQ command functions
Date:   Thu,  3 Feb 2022 13:51:38 -0800
Message-Id: <20220203215140.969227-6-anthony.l.nguyen@intel.com>
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

Add new versions of send ASQ command functions that return
Admin Queue status on the stack to avoid race conditions
in access to hw->aq.asq_last_status.
Add new _v2 version of i40e_aq_remove_macvlan that is using
new _v2 versions of ASQ send command functions and returns
the Admin Queue status on the stack.

Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c | 92 +++++++++++++++++--
 drivers/net/ethernet/intel/i40e/i40e_common.c | 46 ++++++++++
 .../net/ethernet/intel/i40e/i40e_prototype.h  | 20 ++++
 3 files changed, 150 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 7abef88801fb..42439f725aa4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -769,7 +769,7 @@ static bool i40e_asq_done(struct i40e_hw *hw)
 }
 
 /**
- *  i40e_asq_send_command_atomic - send command to Admin Queue
+ *  i40e_asq_send_command_atomic_exec - send command to Admin Queue
  *  @hw: pointer to the hw struct
  *  @desc: prefilled descriptor describing the command (non DMA mem)
  *  @buff: buffer to use for indirect commands
@@ -780,11 +780,13 @@ static bool i40e_asq_done(struct i40e_hw *hw)
  *  This is the main send command driver routine for the Admin Queue send
  *  queue.  It runs the queue, cleans the queue, etc
  **/
-i40e_status
-i40e_asq_send_command_atomic(struct i40e_hw *hw, struct i40e_aq_desc *desc,
-			     void *buff, /* can be NULL */ u16  buff_size,
-			     struct i40e_asq_cmd_details *cmd_details,
-			     bool is_atomic_context)
+static i40e_status
+i40e_asq_send_command_atomic_exec(struct i40e_hw *hw,
+				  struct i40e_aq_desc *desc,
+				  void *buff, /* can be NULL */
+				  u16  buff_size,
+				  struct i40e_asq_cmd_details *cmd_details,
+				  bool is_atomic_context)
 {
 	i40e_status status = 0;
 	struct i40e_dma_mem *dma_buff = NULL;
@@ -794,8 +796,6 @@ i40e_asq_send_command_atomic(struct i40e_hw *hw, struct i40e_aq_desc *desc,
 	u16  retval = 0;
 	u32  val = 0;
 
-	mutex_lock(&hw->aq.asq_mutex);
-
 	if (hw->aq.asq.count == 0) {
 		i40e_debug(hw, I40E_DEBUG_AQ_MESSAGE,
 			   "AQTX: Admin queue not initialized.\n");
@@ -969,6 +969,36 @@ i40e_asq_send_command_atomic(struct i40e_hw *hw, struct i40e_aq_desc *desc,
 	}
 
 asq_send_command_error:
+	return status;
+}
+
+/**
+ *  i40e_asq_send_command_atomic - send command to Admin Queue
+ *  @hw: pointer to the hw struct
+ *  @desc: prefilled descriptor describing the command (non DMA mem)
+ *  @buff: buffer to use for indirect commands
+ *  @buff_size: size of buffer for indirect commands
+ *  @cmd_details: pointer to command details structure
+ *  @is_atomic_context: is the function called in an atomic context?
+ *
+ *  Acquires the lock and calls the main send command execution
+ *  routine.
+ **/
+i40e_status
+i40e_asq_send_command_atomic(struct i40e_hw *hw,
+			     struct i40e_aq_desc *desc,
+			     void *buff, /* can be NULL */
+			     u16  buff_size,
+			     struct i40e_asq_cmd_details *cmd_details,
+			     bool is_atomic_context)
+{
+	i40e_status status;
+
+	mutex_lock(&hw->aq.asq_mutex);
+	status = i40e_asq_send_command_atomic_exec(hw, desc, buff, buff_size,
+						   cmd_details,
+						   is_atomic_context);
+
 	mutex_unlock(&hw->aq.asq_mutex);
 	return status;
 }
@@ -982,6 +1012,52 @@ i40e_asq_send_command(struct i40e_hw *hw, struct i40e_aq_desc *desc,
 					    cmd_details, false);
 }
 
+/**
+ *  i40e_asq_send_command_atomic_v2 - send command to Admin Queue
+ *  @hw: pointer to the hw struct
+ *  @desc: prefilled descriptor describing the command (non DMA mem)
+ *  @buff: buffer to use for indirect commands
+ *  @buff_size: size of buffer for indirect commands
+ *  @cmd_details: pointer to command details structure
+ *  @is_atomic_context: is the function called in an atomic context?
+ *  @aq_status: pointer to Admin Queue status return value
+ *
+ *  Acquires the lock and calls the main send command execution
+ *  routine. Returns the last Admin Queue status in aq_status
+ *  to avoid race conditions in access to hw->aq.asq_last_status.
+ **/
+i40e_status
+i40e_asq_send_command_atomic_v2(struct i40e_hw *hw,
+				struct i40e_aq_desc *desc,
+				void *buff, /* can be NULL */
+				u16  buff_size,
+				struct i40e_asq_cmd_details *cmd_details,
+				bool is_atomic_context,
+				enum i40e_admin_queue_err *aq_status)
+{
+	i40e_status status;
+
+	mutex_lock(&hw->aq.asq_mutex);
+	status = i40e_asq_send_command_atomic_exec(hw, desc, buff,
+						   buff_size,
+						   cmd_details,
+						   is_atomic_context);
+	if (aq_status)
+		*aq_status = hw->aq.asq_last_status;
+	mutex_unlock(&hw->aq.asq_mutex);
+	return status;
+}
+
+i40e_status
+i40e_asq_send_command_v2(struct i40e_hw *hw, struct i40e_aq_desc *desc,
+			 void *buff, /* can be NULL */ u16  buff_size,
+			 struct i40e_asq_cmd_details *cmd_details,
+			 enum i40e_admin_queue_err *aq_status)
+{
+	return i40e_asq_send_command_atomic_v2(hw, desc, buff, buff_size,
+					       cmd_details, true, aq_status);
+}
+
 /**
  *  i40e_fill_default_direct_cmd_desc - AQ descriptor helper function
  *  @desc:     pointer to the temp descriptor (non DMA mem)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index e830987a8c6d..d3e2b3005f86 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -2723,6 +2723,52 @@ i40e_status i40e_aq_remove_macvlan(struct i40e_hw *hw, u16 seid,
 	return status;
 }
 
+/**
+ * i40e_aq_remove_macvlan_v2
+ * @hw: pointer to the hw struct
+ * @seid: VSI for the mac address
+ * @mv_list: list of macvlans to be removed
+ * @count: length of the list
+ * @cmd_details: pointer to command details structure or NULL
+ * @aq_status: pointer to Admin Queue status return value
+ *
+ * Remove MAC/VLAN addresses from the HW filtering.
+ * The _v2 version returns the last Admin Queue status in aq_status
+ * to avoid race conditions in access to hw->aq.asq_last_status.
+ * It also calls _v2 versions of asq_send_command functions to
+ * get the aq_status on the stack.
+ **/
+i40e_status
+i40e_aq_remove_macvlan_v2(struct i40e_hw *hw, u16 seid,
+			  struct i40e_aqc_remove_macvlan_element_data *mv_list,
+			  u16 count, struct i40e_asq_cmd_details *cmd_details,
+			  enum i40e_admin_queue_err *aq_status)
+{
+	struct i40e_aqc_macvlan *cmd;
+	struct i40e_aq_desc desc;
+	u16 buf_size;
+
+	if (count == 0 || !mv_list || !hw)
+		return I40E_ERR_PARAM;
+
+	buf_size = count * sizeof(*mv_list);
+
+	/* prep the rest of the request */
+	i40e_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_remove_macvlan);
+	cmd = (struct i40e_aqc_macvlan *)&desc.params.raw;
+	cmd->num_addresses = cpu_to_le16(count);
+	cmd->seid[0] = cpu_to_le16(I40E_AQC_MACVLAN_CMD_SEID_VALID | seid);
+	cmd->seid[1] = 0;
+	cmd->seid[2] = 0;
+
+	desc.flags |= cpu_to_le16((u16)(I40E_AQ_FLAG_BUF | I40E_AQ_FLAG_RD));
+	if (buf_size > I40E_AQ_LARGE_BUF)
+		desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_LB);
+
+	return i40e_asq_send_command_atomic_v2(hw, &desc, mv_list, buf_size,
+						 cmd_details, true, aq_status);
+}
+
 /**
  * i40e_mirrorrule_op - Internal helper function to add/delete mirror rule
  * @hw: pointer to the hw struct
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index 9241b6005ad3..4ace56a911d9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -27,10 +27,25 @@ i40e_asq_send_command(struct i40e_hw *hw, struct i40e_aq_desc *desc,
 		      void *buff, /* can be NULL */ u16  buff_size,
 		      struct i40e_asq_cmd_details *cmd_details);
 i40e_status
+i40e_asq_send_command_v2(struct i40e_hw *hw,
+			 struct i40e_aq_desc *desc,
+			 void *buff, /* can be NULL */
+			 u16  buff_size,
+			 struct i40e_asq_cmd_details *cmd_details,
+			 enum i40e_admin_queue_err *aq_status);
+i40e_status
 i40e_asq_send_command_atomic(struct i40e_hw *hw, struct i40e_aq_desc *desc,
 			     void *buff, /* can be NULL */ u16  buff_size,
 			     struct i40e_asq_cmd_details *cmd_details,
 			     bool is_atomic_context);
+i40e_status
+i40e_asq_send_command_atomic_v2(struct i40e_hw *hw,
+				struct i40e_aq_desc *desc,
+				void *buff, /* can be NULL */
+				u16  buff_size,
+				struct i40e_asq_cmd_details *cmd_details,
+				bool is_atomic_context,
+				enum i40e_admin_queue_err *aq_status);
 
 /* debug function for adminq */
 void i40e_debug_aq(struct i40e_hw *hw, enum i40e_debug_mask mask,
@@ -153,6 +168,11 @@ i40e_status i40e_aq_add_macvlan(struct i40e_hw *hw, u16 vsi_id,
 i40e_status i40e_aq_remove_macvlan(struct i40e_hw *hw, u16 vsi_id,
 			struct i40e_aqc_remove_macvlan_element_data *mv_list,
 			u16 count, struct i40e_asq_cmd_details *cmd_details);
+i40e_status
+i40e_aq_remove_macvlan_v2(struct i40e_hw *hw, u16 seid,
+			  struct i40e_aqc_remove_macvlan_element_data *mv_list,
+			  u16 count, struct i40e_asq_cmd_details *cmd_details,
+			  enum i40e_admin_queue_err *aq_status);
 i40e_status i40e_aq_add_mirrorrule(struct i40e_hw *hw, u16 sw_seid,
 			u16 rule_type, u16 dest_vsi, u16 count, __le16 *mr_list,
 			struct i40e_asq_cmd_details *cmd_details,
-- 
2.31.1

