Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEEF226ACA
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbfEVTVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:21:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbfEVTVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:21:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 697A92177E;
        Wed, 22 May 2019 19:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552893;
        bh=NXduDLUHcBO0fbGKsSX8fKnqa2uju3P2hEwKRHBKAU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiqyCYp4VY2/g4I69CeS1P0k8+vLFdDwpA1mrt2uq1WGhV9P0BpgXQSvl+WWgYrYH
         BkSF+h1PLN6JWv0ygtJ13avVvdIoOf+xTB1IaoeXuuo07Jw7UAGFgXNxRl6TkNOsSh
         H3GZSZbieAfqgoD8FQ5+R1oFuKSqacK38isqKw20=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martyna Szapar <martyna.szapar@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 013/375] i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c
Date:   Wed, 22 May 2019 15:15:13 -0400
Message-Id: <20190522192115.22666-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martyna Szapar <martyna.szapar@intel.com>

[ Upstream commit 24474f2709af6729b9b1da1c5e160ab62e25e3a4 ]

Fixed possible memory leak in i40e_vc_add_cloud_filter function:
cfilter is being allocated and in some error conditions
the function returns without freeing the memory.

Fix of integer truncation from u16 (type of queue_id value) to u8
when calling i40e_vc_isvalid_queue_id function.

Signed-off-by: Martyna Szapar <martyna.szapar@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/i40e/i40e_virtchnl_pf.c   | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 831d52bc3c9ae..0b5b867c9fbcb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -181,7 +181,7 @@ static inline bool i40e_vc_isvalid_vsi_id(struct i40e_vf *vf, u16 vsi_id)
  * check for the valid queue id
  **/
 static inline bool i40e_vc_isvalid_queue_id(struct i40e_vf *vf, u16 vsi_id,
-					    u8 qid)
+					    u16 qid)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = i40e_find_vsi_from_id(pf, vsi_id);
@@ -3374,7 +3374,7 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
 		aq_ret = I40E_ERR_PARAM;
-		goto err;
+		goto err_out;
 	}
 
 	if (!vf->adq_enabled) {
@@ -3382,7 +3382,7 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 			 "VF %d: ADq is not enabled, can't apply cloud filter\n",
 			 vf->vf_id);
 		aq_ret = I40E_ERR_PARAM;
-		goto err;
+		goto err_out;
 	}
 
 	if (i40e_validate_cloud_filter(vf, vcf)) {
@@ -3390,7 +3390,7 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 			 "VF %d: Invalid input/s, can't apply cloud filter\n",
 			 vf->vf_id);
 		aq_ret = I40E_ERR_PARAM;
-		goto err;
+		goto err_out;
 	}
 
 	cfilter = kzalloc(sizeof(*cfilter), GFP_KERNEL);
@@ -3451,13 +3451,17 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 			"VF %d: Failed to add cloud filter, err %s aq_err %s\n",
 			vf->vf_id, i40e_stat_str(&pf->hw, ret),
 			i40e_aq_str(&pf->hw, pf->hw.aq.asq_last_status));
-		goto err;
+		goto err_free;
 	}
 
 	INIT_HLIST_NODE(&cfilter->cloud_node);
 	hlist_add_head(&cfilter->cloud_node, &vf->cloud_filter_list);
+	/* release the pointer passing it to the collection */
+	cfilter = NULL;
 	vf->num_cloud_filters++;
-err:
+err_free:
+	kfree(cfilter);
+err_out:
 	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_ADD_CLOUD_FILTER,
 				       aq_ret);
 }
-- 
2.20.1

