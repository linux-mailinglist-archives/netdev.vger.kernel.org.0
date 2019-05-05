Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED2713C8A
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 03:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfEEBTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 21:19:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:33073 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbfEEBTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 21:19:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 18:14:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="297102571"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2019 18:14:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Martyna Szapar <martyna.szapar@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/12] i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c
Date:   Sat,  4 May 2019 18:14:08 -0700
Message-Id: <20190505011409.6771-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
References: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martyna Szapar <martyna.szapar@intel.com>

Fixed possible memory leak in i40e_vc_add_cloud_filter function:
cfilter is being allocated and in some error conditions
the function returns without freeing the memory.

Fix of integer truncation from u16 (type of queue_id value) to u8
when calling i40e_vc_isvalid_queue_id function.

Signed-off-by: Martyna Szapar <martyna.szapar@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_virtchnl_pf.c   | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 6a812eeaba8d..ebe18276cea1 100644
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
@@ -3421,7 +3421,7 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
 		aq_ret = I40E_ERR_PARAM;
-		goto err;
+		goto err_out;
 	}
 
 	if (!vf->adq_enabled) {
@@ -3429,7 +3429,7 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 			 "VF %d: ADq is not enabled, can't apply cloud filter\n",
 			 vf->vf_id);
 		aq_ret = I40E_ERR_PARAM;
-		goto err;
+		goto err_out;
 	}
 
 	if (i40e_validate_cloud_filter(vf, vcf)) {
@@ -3437,7 +3437,7 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 			 "VF %d: Invalid input/s, can't apply cloud filter\n",
 			 vf->vf_id);
 		aq_ret = I40E_ERR_PARAM;
-		goto err;
+		goto err_out;
 	}
 
 	cfilter = kzalloc(sizeof(*cfilter), GFP_KERNEL);
@@ -3498,13 +3498,17 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
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

