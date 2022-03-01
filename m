Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A2B4C93B9
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 20:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235654AbiCATAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbiCATAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:00:33 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181596661E
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646161186; x=1677697186;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wRxX9bJ3j+l9RLCka/crysKi67ECQY4eSr53TtNqDTs=;
  b=cg/cn1DYATw+NM5NuKPx7e/l0BFvK4jY6nfobo2cz/x1/xmbtATeGd+4
   h4PvdxZB+1VHRstk0CqOgw8d2OSNtRPos04E4mlHpFXCuzsmoc6i0TUXa
   os6VWBQeZVxpsYV63j/AQELQrVYh4nzbk8warRRq5D/liQRJLDep0vjwD
   g2l+hQa1HdFfYOhAbgulFpKAn/XLx4DPHYmp60D3z5ZjpPEDQj8UkAWHB
   4HNCB0UVkQXG8kLFAnWa4p/lklHMg8H91UExhWvaFX73cuV1BQYRQ0M68
   fHUE/10xelqC7z30zVQeO+nWhux6d+t/1z8IAKdWnzmMuBMNAYlG6OXrg
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="250793231"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="250793231"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 10:59:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="507908274"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2022 10:59:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Brett Creeley <brett.creeley@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 6/7] iavf: Fix incorrect use of assigning iavf_status to int
Date:   Tue,  1 Mar 2022 10:59:38 -0800
Message-Id: <20220301185939.3005116-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
References: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Currently there are functions in iavf_virtchnl.c for polling specific
virtchnl receive events. These are all assigning iavf_status values to
int values. Fix this and explicitly assign int values if iavf_status
is not IAVF_SUCCESS.

Also, refactor a small amount of duplicated code that can be reused by
all of the previously mentioned functions.

Finally, fix some spacing errors for variable assignment and get rid of
all the goto statements in the refactored functions for clarity.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 160 ++++++++----------
 1 file changed, 68 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 995c5055bc12..814c62e0851a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -54,6 +54,41 @@ int iavf_send_api_ver(struct iavf_adapter *adapter)
 				sizeof(vvi));
 }
 
+/**
+ * iavf_poll_virtchnl_msg
+ * @hw: HW configuration structure
+ * @event: event to populate on success
+ * @op_to_poll: requested virtchnl op to poll for
+ *
+ * Initialize poll for virtchnl msg matching the requested_op. Returns 0
+ * if a message of the correct opcode is in the queue or an error code
+ * if no message matching the op code is waiting and other failures.
+ */
+static int
+iavf_poll_virtchnl_msg(struct iavf_hw *hw, struct iavf_arq_event_info *event,
+		       enum virtchnl_ops op_to_poll)
+{
+	enum virtchnl_ops received_op;
+	enum iavf_status status;
+	u32 v_retval;
+
+	while (1) {
+		/* When the AQ is empty, iavf_clean_arq_element will return
+		 * nonzero and this loop will terminate.
+		 */
+		status = iavf_clean_arq_element(hw, event, NULL);
+		if (status != IAVF_SUCCESS)
+			return iavf_status_to_errno(status);
+		received_op =
+		    (enum virtchnl_ops)le32_to_cpu(event->desc.cookie_high);
+		if (op_to_poll == received_op)
+			break;
+	}
+
+	v_retval = le32_to_cpu(event->desc.cookie_low);
+	return virtchnl_status_to_errno((enum virtchnl_status_code)v_retval);
+}
+
 /**
  * iavf_verify_api_ver
  * @adapter: adapter structure
@@ -65,55 +100,28 @@ int iavf_send_api_ver(struct iavf_adapter *adapter)
  **/
 int iavf_verify_api_ver(struct iavf_adapter *adapter)
 {
-	struct virtchnl_version_info *pf_vvi;
-	struct iavf_hw *hw = &adapter->hw;
 	struct iavf_arq_event_info event;
-	enum virtchnl_ops op;
-	enum iavf_status err;
+	int err;
 
 	event.buf_len = IAVF_MAX_AQ_BUF_SIZE;
-	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
-	if (!event.msg_buf) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	while (1) {
-		err = iavf_clean_arq_element(hw, &event, NULL);
-		/* When the AQ is empty, iavf_clean_arq_element will return
-		 * nonzero and this loop will terminate.
-		 */
-		if (err)
-			goto out_alloc;
-		op =
-		    (enum virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
-		if (op == VIRTCHNL_OP_VERSION)
-			break;
-	}
-
+	event.msg_buf = kzalloc(IAVF_MAX_AQ_BUF_SIZE, GFP_KERNEL);
+	if (!event.msg_buf)
+		return -ENOMEM;
 
-	err = (enum iavf_status)le32_to_cpu(event.desc.cookie_low);
-	if (err)
-		goto out_alloc;
+	err = iavf_poll_virtchnl_msg(&adapter->hw, &event, VIRTCHNL_OP_VERSION);
+	if (!err) {
+		struct virtchnl_version_info *pf_vvi =
+			(struct virtchnl_version_info *)event.msg_buf;
+		adapter->pf_version = *pf_vvi;
 
-	if (op != VIRTCHNL_OP_VERSION) {
-		dev_info(&adapter->pdev->dev, "Invalid reply type %d from PF\n",
-			op);
-		err = -EIO;
-		goto out_alloc;
+		if (pf_vvi->major > VIRTCHNL_VERSION_MAJOR ||
+		    (pf_vvi->major == VIRTCHNL_VERSION_MAJOR &&
+		     pf_vvi->minor > VIRTCHNL_VERSION_MINOR))
+			err = -EIO;
 	}
 
-	pf_vvi = (struct virtchnl_version_info *)event.msg_buf;
-	adapter->pf_version = *pf_vvi;
-
-	if ((pf_vvi->major > VIRTCHNL_VERSION_MAJOR) ||
-	    ((pf_vvi->major == VIRTCHNL_VERSION_MAJOR) &&
-	     (pf_vvi->minor > VIRTCHNL_VERSION_MINOR)))
-		err = -EIO;
-
-out_alloc:
 	kfree(event.msg_buf);
-out:
+
 	return err;
 }
 
@@ -208,33 +216,17 @@ int iavf_get_vf_config(struct iavf_adapter *adapter)
 {
 	struct iavf_hw *hw = &adapter->hw;
 	struct iavf_arq_event_info event;
-	enum virtchnl_ops op;
-	enum iavf_status err;
 	u16 len;
+	int err;
 
-	len =  sizeof(struct virtchnl_vf_resource) +
+	len = sizeof(struct virtchnl_vf_resource) +
 		IAVF_MAX_VF_VSI * sizeof(struct virtchnl_vsi_resource);
 	event.buf_len = len;
-	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
-	if (!event.msg_buf) {
-		err = -ENOMEM;
-		goto out;
-	}
+	event.msg_buf = kzalloc(len, GFP_KERNEL);
+	if (!event.msg_buf)
+		return -ENOMEM;
 
-	while (1) {
-		/* When the AQ is empty, iavf_clean_arq_element will return
-		 * nonzero and this loop will terminate.
-		 */
-		err = iavf_clean_arq_element(hw, &event, NULL);
-		if (err)
-			goto out_alloc;
-		op =
-		    (enum virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
-		if (op == VIRTCHNL_OP_GET_VF_RESOURCES)
-			break;
-	}
-
-	err = (enum iavf_status)le32_to_cpu(event.desc.cookie_low);
+	err = iavf_poll_virtchnl_msg(hw, &event, VIRTCHNL_OP_GET_VF_RESOURCES);
 	memcpy(adapter->vf_res, event.msg_buf, min(event.msg_len, len));
 
 	/* some PFs send more queues than we should have so validate that
@@ -243,48 +235,32 @@ int iavf_get_vf_config(struct iavf_adapter *adapter)
 	if (!err)
 		iavf_validate_num_queues(adapter);
 	iavf_vf_parse_hw_config(hw, adapter->vf_res);
-out_alloc:
+
 	kfree(event.msg_buf);
-out:
+
 	return err;
 }
 
 int iavf_get_vf_vlan_v2_caps(struct iavf_adapter *adapter)
 {
-	struct iavf_hw *hw = &adapter->hw;
 	struct iavf_arq_event_info event;
-	enum virtchnl_ops op;
-	enum iavf_status err;
+	int err;
 	u16 len;
 
-	len =  sizeof(struct virtchnl_vlan_caps);
+	len = sizeof(struct virtchnl_vlan_caps);
 	event.buf_len = len;
-	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
-	if (!event.msg_buf) {
-		err = -ENOMEM;
-		goto out;
-	}
+	event.msg_buf = kzalloc(len, GFP_KERNEL);
+	if (!event.msg_buf)
+		return -ENOMEM;
 
-	while (1) {
-		/* When the AQ is empty, iavf_clean_arq_element will return
-		 * nonzero and this loop will terminate.
-		 */
-		err = iavf_clean_arq_element(hw, &event, NULL);
-		if (err)
-			goto out_alloc;
-		op = (enum virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
-		if (op == VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS)
-			break;
-	}
-
-	err = (enum iavf_status)le32_to_cpu(event.desc.cookie_low);
-	if (err)
-		goto out_alloc;
+	err = iavf_poll_virtchnl_msg(&adapter->hw, &event,
+				     VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS);
+	if (!err)
+		memcpy(&adapter->vlan_v2_caps, event.msg_buf,
+		       min(event.msg_len, len));
 
-	memcpy(&adapter->vlan_v2_caps, event.msg_buf, min(event.msg_len, len));
-out_alloc:
 	kfree(event.msg_buf);
-out:
+
 	return err;
 }
 
-- 
2.31.1

