Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3961313C8B
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 03:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfEEBTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 21:19:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:33075 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbfEEBTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 21:19:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 18:14:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="297102573"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2019 18:14:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Martyna Szapar <martyna.szapar@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/12] i40e: Memory leak in i40e_config_iwarp_qvlist
Date:   Sat,  4 May 2019 18:14:09 -0700
Message-Id: <20190505011409.6771-13-jeffrey.t.kirsher@intel.com>
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

Added freeing the old allocation of vf->qvlist_info in function
i40e_config_iwarp_qvlist before overwriting it with
the new allocation.

Signed-off-by: Martyna Szapar <martyna.szapar@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 23 ++++++++++++-------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index ebe18276cea1..479bc60c8f71 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -441,6 +441,7 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 	u32 v_idx, i, reg_idx, reg;
 	u32 next_q_idx, next_q_type;
 	u32 msix_vf, size;
+	int ret = 0;
 
 	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
 
@@ -449,16 +450,19 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 			 "Incorrect number of iwarp vectors %u. Maximum %u allowed.\n",
 			 qvlist_info->num_vectors,
 			 msix_vf);
-		goto err;
+		ret = -EINVAL;
+		goto err_out;
 	}
 
 	size = sizeof(struct virtchnl_iwarp_qvlist_info) +
 	       (sizeof(struct virtchnl_iwarp_qv_info) *
 						(qvlist_info->num_vectors - 1));
+	kfree(vf->qvlist_info);
 	vf->qvlist_info = kzalloc(size, GFP_KERNEL);
-	if (!vf->qvlist_info)
-		return -ENOMEM;
-
+	if (!vf->qvlist_info) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
 	vf->qvlist_info->num_vectors = qvlist_info->num_vectors;
 
 	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
@@ -469,8 +473,10 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 		v_idx = qv_info->v_idx;
 
 		/* Validate vector id belongs to this vf */
-		if (!i40e_vc_isvalid_vector_id(vf, v_idx))
-			goto err;
+		if (!i40e_vc_isvalid_vector_id(vf, v_idx)) {
+			ret = -EINVAL;
+			goto err_free;
+		}
 
 		vf->qvlist_info->qv_info[i] = *qv_info;
 
@@ -512,10 +518,11 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 	}
 
 	return 0;
-err:
+err_free:
 	kfree(vf->qvlist_info);
 	vf->qvlist_info = NULL;
-	return -EINVAL;
+err_out:
+	return ret;
 }
 
 /**
-- 
2.20.1

