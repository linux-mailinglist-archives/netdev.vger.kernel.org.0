Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B94836071
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfFEPk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:40:59 -0400
Received: from gateway36.websitewelcome.com ([50.116.127.2]:21947 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728570AbfFEPk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 11:40:56 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id D1D8A400C5A3C
        for <netdev@vger.kernel.org>; Wed,  5 Jun 2019 10:01:47 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id YY23hEO6kYTGMYY23hCWJe; Wed, 05 Jun 2019 10:40:55 -0500
X-Authority-Reason: nr=8
Received: from [189.250.127.120] (port=54884 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hYY21-001MOH-RR; Wed, 05 Jun 2019 10:40:54 -0500
Date:   Wed, 5 Jun 2019 10:40:52 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] i40e/i40e_virtchnl_pf: Use struct_size() in kzalloc()
Message-ID: <20190605154052.GA7571@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.127.120
X-Source-L: No
X-Exim-ID: 1hYY21-001MOH-RR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.127.120]:54884
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 .../net/ethernet/intel/i40e/i40e_virtchnl_pf.c    | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 479bc60c8f71..1d6e65fc8a7e 100644
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
@@ -1845,7 +1844,7 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 	i40e_status aq_ret = 0;
 	struct i40e_vsi *vsi;
 	int num_vsis = 1;
-	int len = 0;
+	size_t len = 0;
 	int ret;
 
 	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
@@ -1853,9 +1852,7 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
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

