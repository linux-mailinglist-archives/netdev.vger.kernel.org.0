Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DE2484AD6
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 23:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbiADWjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 17:39:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:28280 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235654AbiADWjW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 17:39:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641335962; x=1672871962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s+pfsWr6sz4fkYx3mrHHOB4lyjNCvPgCyfmjj4CwKW4=;
  b=V014us5h3OJuFe/VyQZePLbz0+hg3MmYdLh6EgjN2ziWTyNaaZaGqq8/
   CjCHL++zU/Y4nqzTkdm3YUQgUza6QkEheRW8LLS8ZYs+ZDnNiXwFCSTCf
   4zF1P6ScUHgUzdQKrH8WJESPpuc7iuwGYIQiW8QBpMINGct1yXqJa0QZY
   rIir3qaZMpwFgbR8z9mm2JtdKXfOV1vj39Q6rYVxevZ1nUORP/DM+hHY3
   BHa1+cJSpPfqVA+ZKWFRBa5s35Y+WpL6HKkNMGLe+djue+4rPXeEbJweh
   cO1p28BlHqJrTJp1TR04vILCr78XJgk1wVCHvvLrX0x8C2Bi6RfD4aBUl
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222305229"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="222305229"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 14:39:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="470312797"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2022 14:39:20 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 1/5] i40e: Fix to not show opcode msg on unsuccessful VF MAC change
Date:   Tue,  4 Jan 2022 14:38:38 -0800
Message-Id: <20220104223842.2325297-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220104223842.2325297-1-anthony.l.nguyen@intel.com>
References: <20220104223842.2325297-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Hide i40e opcode information sent during response to VF in case when
untrusted VF tried to change MAC on the VF interface.

This is implemented by adding an additional parameter 'hide' to the
response sent to VF function that hides the display of error
information, but forwards the error code to VF.

Previously it was not possible to send response with some error code
to VF without displaying opcode information.

Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 40 +++++++++++++++----
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 2ea4deb8fc44..048f1678ab8a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1877,17 +1877,19 @@ int i40e_pci_sriov_configure(struct pci_dev *pdev, int num_vfs)
 /***********************virtual channel routines******************/
 
 /**
- * i40e_vc_send_msg_to_vf
+ * i40e_vc_send_msg_to_vf_ex
  * @vf: pointer to the VF info
  * @v_opcode: virtual channel opcode
  * @v_retval: virtual channel return value
  * @msg: pointer to the msg buffer
  * @msglen: msg length
+ * @is_quiet: true for not printing unsuccessful return values, false otherwise
  *
  * send msg to VF
  **/
-static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
-				  u32 v_retval, u8 *msg, u16 msglen)
+static int i40e_vc_send_msg_to_vf_ex(struct i40e_vf *vf, u32 v_opcode,
+				     u32 v_retval, u8 *msg, u16 msglen,
+				     bool is_quiet)
 {
 	struct i40e_pf *pf;
 	struct i40e_hw *hw;
@@ -1903,7 +1905,7 @@ static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
 	abs_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
 
 	/* single place to detect unsuccessful return values */
-	if (v_retval) {
+	if (v_retval && !is_quiet) {
 		vf->num_invalid_msgs++;
 		dev_info(&pf->pdev->dev, "VF %d failed opcode %d, retval: %d\n",
 			 vf->vf_id, v_opcode, v_retval);
@@ -1933,6 +1935,23 @@ static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
 	return 0;
 }
 
+/**
+ * i40e_vc_send_msg_to_vf
+ * @vf: pointer to the VF info
+ * @v_opcode: virtual channel opcode
+ * @v_retval: virtual channel return value
+ * @msg: pointer to the msg buffer
+ * @msglen: msg length
+ *
+ * send msg to VF
+ **/
+static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
+				  u32 v_retval, u8 *msg, u16 msglen)
+{
+	return i40e_vc_send_msg_to_vf_ex(vf, v_opcode, v_retval,
+					 msg, msglen, false);
+}
+
 /**
  * i40e_vc_send_resp_to_vf
  * @vf: pointer to the VF info
@@ -2695,6 +2714,7 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
  * i40e_check_vf_permission
  * @vf: pointer to the VF info
  * @al: MAC address list from virtchnl
+ * @is_quiet: set true for printing msg without opcode info, false otherwise
  *
  * Check that the given list of MAC addresses is allowed. Will return -EPERM
  * if any address in the list is not valid. Checks the following conditions:
@@ -2709,13 +2729,15 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
  * addresses might not be accurate.
  **/
 static inline int i40e_check_vf_permission(struct i40e_vf *vf,
-					   struct virtchnl_ether_addr_list *al)
+					   struct virtchnl_ether_addr_list *al,
+					   bool *is_quiet)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = pf->vsi[vf->lan_vsi_idx];
 	int mac2add_cnt = 0;
 	int i;
 
+	*is_quiet = false;
 	for (i = 0; i < al->num_elements; i++) {
 		struct i40e_mac_filter *f;
 		u8 *addr = al->list[i].addr;
@@ -2739,6 +2761,7 @@ static inline int i40e_check_vf_permission(struct i40e_vf *vf,
 		    !ether_addr_equal(addr, vf->default_lan_addr.addr)) {
 			dev_err(&pf->pdev->dev,
 				"VF attempting to override administratively set MAC address, bring down and up the VF interface to resume normal operation\n");
+			*is_quiet = true;
 			return -EPERM;
 		}
 
@@ -2775,6 +2798,7 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	    (struct virtchnl_ether_addr_list *)msg;
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = NULL;
+	bool is_quiet = false;
 	i40e_status ret = 0;
 	int i;
 
@@ -2791,7 +2815,7 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	 */
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
 
-	ret = i40e_check_vf_permission(vf, al);
+	ret = i40e_check_vf_permission(vf, al, &is_quiet);
 	if (ret) {
 		spin_unlock_bh(&vsi->mac_filter_hash_lock);
 		goto error_param;
@@ -2829,8 +2853,8 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
-				       ret);
+	return i40e_vc_send_msg_to_vf_ex(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
+				       ret, NULL, 0, is_quiet);
 }
 
 /**
-- 
2.31.1

