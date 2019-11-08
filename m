Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7024EF45F8
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732882AbfKHLiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:38:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732862AbfKHLit (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E752E21D6C;
        Fri,  8 Nov 2019 11:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213127;
        bh=IxqNtubm1ik/2pU1sDOhqVUVrkUUGyiic2eiJsNd5K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXHHGG3e0rAikKvRaLqLS9al7hwmtjQITZ+tWiL3uUaQ4f45tHMfBAGuzZhd8Gudp
         FsQnwQaRXRrytvtyxuV4keNdk6aye15yW7a3oirU5tIAa9AOBIAq85b6UmXFAJluLQ
         y0j41U0t55ZLebiy+aZiqdHhLz5ypFRZ/rucR0TU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 046/205] i40evf: Validate the number of queues a PF sends
Date:   Fri,  8 Nov 2019 06:35:13 -0500
Message-Id: <20191108113752.12502-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

[ Upstream commit 3c818910911c93bb5099c6637ec350f90c0e71fc ]

A PF can send any number of queues to the VF and the VF may not
be able to support that many. Check to see that the number of
queues is less than or equal to the max number of queues the
VF can have.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40evf/i40evf_virtchnl.c   | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c b/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c
index 565677de5ba37..94dabc9d89f73 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c
@@ -153,6 +153,32 @@ int i40evf_send_vf_config_msg(struct i40evf_adapter *adapter)
 					  NULL, 0);
 }
 
+/**
+ * i40evf_validate_num_queues
+ * @adapter: adapter structure
+ *
+ * Validate that the number of queues the PF has sent in
+ * VIRTCHNL_OP_GET_VF_RESOURCES is not larger than the VF can handle.
+ **/
+static void i40evf_validate_num_queues(struct i40evf_adapter *adapter)
+{
+	if (adapter->vf_res->num_queue_pairs > I40EVF_MAX_REQ_QUEUES) {
+		struct virtchnl_vsi_resource *vsi_res;
+		int i;
+
+		dev_info(&adapter->pdev->dev, "Received %d queues, but can only have a max of %d\n",
+			 adapter->vf_res->num_queue_pairs,
+			 I40EVF_MAX_REQ_QUEUES);
+		dev_info(&adapter->pdev->dev, "Fixing by reducing queues to %d\n",
+			 I40EVF_MAX_REQ_QUEUES);
+		adapter->vf_res->num_queue_pairs = I40EVF_MAX_REQ_QUEUES;
+		for (i = 0; i < adapter->vf_res->num_vsis; i++) {
+			vsi_res = &adapter->vf_res->vsi_res[i];
+			vsi_res->num_queue_pairs = I40EVF_MAX_REQ_QUEUES;
+		}
+	}
+}
+
 /**
  * i40evf_get_vf_config
  * @adapter: private adapter structure
@@ -195,6 +221,11 @@ int i40evf_get_vf_config(struct i40evf_adapter *adapter)
 	err = (i40e_status)le32_to_cpu(event.desc.cookie_low);
 	memcpy(adapter->vf_res, event.msg_buf, min(event.msg_len, len));
 
+	/* some PFs send more queues than we should have so validate that
+	 * we aren't getting too many queues
+	 */
+	if (!err)
+		i40evf_validate_num_queues(adapter);
 	i40e_vf_parse_hw_config(hw, adapter->vf_res);
 out_alloc:
 	kfree(event.msg_buf);
@@ -1329,6 +1360,7 @@ void i40evf_virtchnl_completion(struct i40evf_adapter *adapter,
 			  I40E_MAX_VF_VSI *
 			  sizeof(struct virtchnl_vsi_resource);
 		memcpy(adapter->vf_res, msg, min(msglen, len));
+		i40evf_validate_num_queues(adapter);
 		i40e_vf_parse_hw_config(&adapter->hw, adapter->vf_res);
 		/* restore current mac address */
 		ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
-- 
2.20.1

