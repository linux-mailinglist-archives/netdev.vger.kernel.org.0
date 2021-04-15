Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5EB35FEE1
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhDOA3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:05 -0400
Received: from mga12.intel.com ([192.55.52.136]:27426 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhDOA2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:49 -0400
IronPort-SDR: DpRsJl7fgk89+Ro8KkwcZvuGnlu3DJALZUliTGTw5o81oZdpTXaSByCHSQi0hoMW11yhpr0CXB
 0gS7LSsZMQiQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262241"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262241"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:26 -0700
IronPort-SDR: GX9S0pqzuz3H1XTK+A4VcpFUVRyKJm7/gyyDHxzENRqGsW0oGPSk5CGrZAXzFdjFRpx6kv7LjT
 DxXid8IPNOZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379528"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 10/15] ice: use local for consistency
Date:   Wed, 14 Apr 2021 17:30:08 -0700
Message-Id: <20210415003013.19717-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Do a minor refactor on ice_vsi_rebuild to use a local
variable to store vsi->type.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 45837e9eee86..0443338f9eaf 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3014,6 +3014,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 	struct ice_coalesce_stored *coalesce;
 	int prev_num_q_vectors = 0;
 	struct ice_vf *vf = NULL;
+	enum ice_vsi_type vtype;
 	enum ice_status status;
 	struct ice_pf *pf;
 	int ret, i;
@@ -3022,7 +3023,8 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 		return -EINVAL;
 
 	pf = vsi->back;
-	if (vsi->type == ICE_VSI_VF)
+	vtype = vsi->type;
+	if (vtype == ICE_VSI_VF)
 		vf = &pf->vf[vsi->vf_id];
 
 	coalesce = kcalloc(vsi->num_q_vectors,
@@ -3040,7 +3042,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 	 * many interrupts each VF needs. SR-IOV MSIX resources are also
 	 * cleared in the same manner.
 	 */
-	if (vsi->type != ICE_VSI_VF) {
+	if (vtype != ICE_VSI_VF) {
 		/* reclaim SW interrupts back to the common pool */
 		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
 		pf->num_avail_sw_msix += vsi->num_q_vectors;
@@ -3055,7 +3057,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 	ice_vsi_put_qs(vsi);
 	ice_vsi_clear_rings(vsi);
 	ice_vsi_free_arrays(vsi);
-	if (vsi->type == ICE_VSI_VF)
+	if (vtype == ICE_VSI_VF)
 		ice_vsi_set_num_qs(vsi, vf->vf_id);
 	else
 		ice_vsi_set_num_qs(vsi, ICE_INVAL_VFID);
@@ -3074,7 +3076,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 	if (ret < 0)
 		goto err_vsi;
 
-	switch (vsi->type) {
+	switch (vtype) {
 	case ICE_VSI_CTRL:
 	case ICE_VSI_PF:
 		ret = ice_vsi_alloc_q_vectors(vsi);
@@ -3101,7 +3103,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 				goto err_vectors;
 		}
 		/* ICE_VSI_CTRL does not need RSS so skip RSS processing */
-		if (vsi->type != ICE_VSI_CTRL)
+		if (vtype != ICE_VSI_CTRL)
 			/* Do not exit if configuring RSS had an issue, at
 			 * least receive traffic on first queue. Hence no
 			 * need to capture return value
-- 
2.26.2

