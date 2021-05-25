Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022AB390C9F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 01:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhEYXDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 19:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhEYXDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 19:03:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A217961284;
        Tue, 25 May 2021 23:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621983734;
        bh=XWQ4QbZ7knDZ4l/rQ3FBmjdjFtATkZb/gO19aGuRZyo=;
        h=Date:From:To:Cc:Subject:From;
        b=abSDXGtKRnADXc7Beo8LuS7RCy66yWKLG4p5KUQSopJm3jKk669zkjJ61yJDsxiY9
         Zbr2FFe3tfQw4FCnhUPac5D/8nF6+mWsK86t5E8TrVyKD3oL+rzXkp4t8Dw6W3z1dv
         P3/4AKQhHxFJRa7Nb2jnW4yt5FFn6D3T8e/Ph+z5UvEyW8TIbLplQZyKAQORIrrnfK
         hn44wUVHUpDGE4UqvyEs/Eep42pxDHHUd0DFb85Sem8cBkf1NnPGj1efrQTZ3DOdOg
         EaC81G82Apae2x3Msy1Du8pEGBKaxSAIteR/jmkv4gc/DBO6fQ7IVrPQwQgy6mRVOm
         2Y4yxbyq6pQiA==
Date:   Tue, 25 May 2021 18:03:10 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] iavf: Replace one-element array in struct
 virtchnl_vf_resource
Message-ID: <20210525230310.GA175595@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having a
dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in struct
virtchnl_vf_resource instead of one-element array, and use the struct_size()
helper.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 ++---
 drivers/net/ethernet/intel/iavf/iavf.h             | 5 ++---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    | 9 ++++-----
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   | 4 ++--
 include/linux/avf/virtchnl.h                       | 4 ++--
 5 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index eff0a30790dd..c0afac8cf33b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1978,7 +1978,6 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 	struct i40e_pf *pf = vf->pf;
 	i40e_status aq_ret = 0;
 	struct i40e_vsi *vsi;
-	int num_vsis = 1;
 	size_t len = 0;
 	int ret;
 
@@ -1987,7 +1986,7 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 		goto err;
 	}
 
-	len = struct_size(vfres, vsi_res, num_vsis);
+	len = struct_size(vfres, vsi_res, 1);
 	vfres = kzalloc(len, GFP_KERNEL);
 	if (!vfres) {
 		aq_ret = I40E_ERR_NO_MEMORY;
@@ -2061,7 +2060,7 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_ADQ)
 		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_ADQ;
 
-	vfres->num_vsis = num_vsis;
+	vfres->num_vsis = 1;
 	vfres->num_queue_pairs = vf->num_queue_pairs;
 	vfres->max_vectors = pf->hw.func_caps.num_msix_vectors_vf;
 	vfres->rss_key_size = I40E_HKEY_ARRAY_SIZE;
diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index e8bd04100ecd..2c212727c50d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -89,9 +89,8 @@ struct iavf_vsi {
 #define IAVF_HLUT_ARRAY_SIZE ((IAVF_VFQF_HLUT_MAX_INDEX + 1) * 4)
 #define IAVF_MBPS_DIVISOR	125000 /* divisor to convert to Mbps */
 
-#define IAVF_VIRTCHNL_VF_RESOURCE_SIZE (sizeof(struct virtchnl_vf_resource) + \
-					(IAVF_MAX_VF_VSI * \
-					 sizeof(struct virtchnl_vsi_resource)))
+#define IAVF_VIRTCHNL_VF_RESOURCE_SIZE (struct_size((struct virtchnl_vf_resource *)0, \
+					vsi_res, IAVF_MAX_VF_VSI))
 
 /* MAX_MSIX_Q_VECTORS of these are allocated,
  * but we only use one per queue-specific vector.
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 0eab3c43bdc5..b2392af4e048 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -198,8 +198,8 @@ int iavf_get_vf_config(struct iavf_adapter *adapter)
 	enum iavf_status err;
 	u16 len;
 
-	len =  sizeof(struct virtchnl_vf_resource) +
-		IAVF_MAX_VF_VSI * sizeof(struct virtchnl_vsi_resource);
+	len = struct_size((struct virtchnl_vf_resource *)0, vsi_res,
+			  IAVF_MAX_VF_VSI);
 	event.buf_len = len;
 	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
 	if (!event.msg_buf) {
@@ -1662,9 +1662,8 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		}
 		break;
 	case VIRTCHNL_OP_GET_VF_RESOURCES: {
-		u16 len = sizeof(struct virtchnl_vf_resource) +
-			  IAVF_MAX_VF_VSI *
-			  sizeof(struct virtchnl_vsi_resource);
+		u16 len = struct_size((struct virtchnl_vf_resource *)0,
+				      vsi_res, IAVF_MAX_VF_VSI);
 		memcpy(adapter->vf_res, msg, min(msglen, len));
 		iavf_validate_num_queues(adapter);
 		iavf_vf_parse_hw_config(&adapter->hw, adapter->vf_res);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a1d22d2aa0bd..5f1e0b45b8f5 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2295,7 +2295,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	struct virtchnl_vf_resource *vfres = NULL;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
-	int len = 0;
+	size_t len = 0;
 	int ret;
 
 	if (ice_check_vf_init(pf, vf)) {
@@ -2303,7 +2303,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 		goto err;
 	}
 
-	len = sizeof(struct virtchnl_vf_resource);
+	len = struct_size(vfres, vsi_res, 1);
 
 	vfres = kzalloc(len, GFP_KERNEL);
 	if (!vfres) {
diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 565deea6ffe8..85a687bc6096 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -273,10 +273,10 @@ struct virtchnl_vf_resource {
 	u32 rss_key_size;
 	u32 rss_lut_size;
 
-	struct virtchnl_vsi_resource vsi_res[1];
+	struct virtchnl_vsi_resource vsi_res[];
 };
 
-VIRTCHNL_CHECK_STRUCT_LEN(36, virtchnl_vf_resource);
+VIRTCHNL_CHECK_STRUCT_LEN(20, virtchnl_vf_resource);
 
 /* VIRTCHNL_OP_CONFIG_TX_QUEUE
  * VF sends this message to set up parameters for one TX queue.
-- 
2.27.0

