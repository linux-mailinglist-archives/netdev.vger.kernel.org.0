Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 274A7571C6
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFZTal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:30:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:41414 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbfFZTai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:30:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 12:30:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,420,1557212400"; 
   d="scan'208";a="188762490"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2019 12:30:36 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/10] i40e/i40e_virtchnl_pf: Use struct_size() in kzalloc()
Date:   Wed, 26 Jun 2019 12:31:03 -0700
Message-Id: <20190626193103.2169-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
References: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct virtchnl_iwarp_qvlist_info {
	...
        struct virtchnl_iwarp_qv_info qv_info[1];
};

size = sizeof(struct virtchnl_iwarp_qvlist_info) + (sizeof(struct virtchnl_iwarp_qv_info) * count;
instance = kzalloc(size, GFP_KERNEL);

and

struct virtchnl_vf_resource {
	...
        struct virtchnl_vsi_resource vsi_res[1];
};

size = sizeof(struct virtchnl_vf_resource) + sizeof(struct virtchnl_vsi_resource) * count;
instance = kzalloc(size, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kzalloc(struct_size(instance, qv_info, count), GFP_KERNEL);

and

instance = kzalloc(struct_size(instance, vsi_res, count), GFP_KERNEL);

Notice that, in the first case above, variable size is not necessary, hence it
is removed.

This code was detected with the help of Coccinelle.

Signed-off-by: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_virtchnl_pf.c    | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index ac3a130ee7d4..02b09a8ad54c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -440,7 +440,7 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 	struct virtchnl_iwarp_qv_info *qv_info;
 	u32 v_idx, i, reg_idx, reg;
 	u32 next_q_idx, next_q_type;
-	u32 msix_vf, size;
+	u32 msix_vf;
 	int ret = 0;
 
 	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
@@ -454,11 +454,10 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 		goto err_out;
 	}
 
-	size = sizeof(struct virtchnl_iwarp_qvlist_info) +
-	       (sizeof(struct virtchnl_iwarp_qv_info) *
-						(qvlist_info->num_vectors - 1));
 	kfree(vf->qvlist_info);
-	vf->qvlist_info = kzalloc(size, GFP_KERNEL);
+	vf->qvlist_info = kzalloc(struct_size(vf->qvlist_info, qv_info,
+					      qvlist_info->num_vectors - 1),
+				  GFP_KERNEL);
 	if (!vf->qvlist_info) {
 		ret = -ENOMEM;
 		goto err_out;
@@ -1846,7 +1845,7 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 	i40e_status aq_ret = 0;
 	struct i40e_vsi *vsi;
 	int num_vsis = 1;
-	int len = 0;
+	size_t len = 0;
 	int ret;
 
 	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
@@ -1854,9 +1853,7 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 		goto err;
 	}
 
-	len = (sizeof(struct virtchnl_vf_resource) +
-	       sizeof(struct virtchnl_vsi_resource) * num_vsis);
-
+	len = struct_size(vfres, vsi_res, num_vsis);
 	vfres = kzalloc(len, GFP_KERNEL);
 	if (!vfres) {
 		aq_ret = I40E_ERR_NO_MEMORY;
-- 
2.21.0

