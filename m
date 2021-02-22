Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709873222DF
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 00:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhBVX6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 18:58:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:20988 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231928AbhBVX6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 18:58:35 -0500
IronPort-SDR: PNNCH7Jx3/xPiMKYG178o7lCNrcw7EJJv1l6kqqbBW1KrZU4yO6STvViOzP9Fbb1c3zY3FS98Z
 sOfiU/u+Acpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="184751843"
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="184751843"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 15:57:13 -0800
IronPort-SDR: hVEumrRS55f0z+rw8bRGJxDUBR6+wX55Rv2MgqaRM0SmhBlYZM1LLv6/ABLJWW6iAOWUKpH6j5
 GFDcBkOX54Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="592882905"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 22 Feb 2021 15:57:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 3/5] ice: Account for port VLAN in VF max packet size calculation
Date:   Mon, 22 Feb 2021 15:58:12 -0800
Message-Id: <20210222235814.834282-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210222235814.834282-1-anthony.l.nguyen@intel.com>
References: <20210222235814.834282-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently if an AVF driver doesn't account for the possibility of a
port VLAN when determining its max packet size then packets at MTU will
be dropped. It is not the VF driver's responsibility to account for a
port VLAN so fix this. To fix this, do the following:

1. Add a function that determines the max packet size a VF is allowed by
   using the port's max packet size and whether the VF is in a port
   VLAN. If a port VLAN is configured then a VF's max packet size will
   always be the port's max packet size minus VLAN_HLEN. Otherwise it
   will be the port's max packet size.

2. Use this function to verify the max packet size from the VF.

3. If there is a port VLAN configured then add 4 bytes (VLAN_HLEN) to
   the VF's max packet size configuration.

Also, the VIRTCHNL_OP_GET_VF_RESOURCES message provides the capability
to communicate a VF's max packet size. Use the new function for this
purpose.

Fixes: 1071a8358a28 ("ice: Implement virtchnl commands for AVF support")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 33 ++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 07fae37a78be..1f38a8d0c525 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1918,6 +1918,29 @@ static int ice_vc_get_ver_msg(struct ice_vf *vf, u8 *msg)
 				     sizeof(struct virtchnl_version_info));
 }
 
+/**
+ * ice_vc_get_max_frame_size - get max frame size allowed for VF
+ * @vf: VF used to determine max frame size
+ *
+ * Max frame size is determined based on the current port's max frame size and
+ * whether a port VLAN is configured on this VF. The VF is not aware whether
+ * it's in a port VLAN so the PF needs to account for this in max frame size
+ * checks and sending the max frame size to the VF.
+ */
+static u16 ice_vc_get_max_frame_size(struct ice_vf *vf)
+{
+	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
+	struct ice_port_info *pi = vsi->port_info;
+	u16 max_frame_size;
+
+	max_frame_size = pi->phy.link_info.max_frame_size;
+
+	if (vf->port_vlan_info)
+		max_frame_size -= VLAN_HLEN;
+
+	return max_frame_size;
+}
+
 /**
  * ice_vc_get_vf_res_msg
  * @vf: pointer to the VF info
@@ -2000,6 +2023,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	vfres->max_vectors = pf->num_msix_per_vf;
 	vfres->rss_key_size = ICE_VSIQF_HKEY_ARRAY_SIZE;
 	vfres->rss_lut_size = ICE_VSIQF_HLUT_ARRAY_SIZE;
+	vfres->max_mtu = ice_vc_get_max_frame_size(vf);
 
 	vfres->vsi_res[0].vsi_id = vf->lan_vsi_num;
 	vfres->vsi_res[0].vsi_type = VIRTCHNL_VSI_SRIOV;
@@ -2998,6 +3022,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 		/* copy Rx queue info from VF into VSI */
 		if (qpi->rxq.ring_len > 0) {
+			u16 max_frame_size = ice_vc_get_max_frame_size(vf);
+
 			num_rxq++;
 			vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
 			vsi->rx_rings[i]->count = qpi->rxq.ring_len;
@@ -3010,7 +3036,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			}
 			vsi->rx_buf_len = qpi->rxq.databuffer_size;
 			vsi->rx_rings[i]->rx_buf_len = vsi->rx_buf_len;
-			if (qpi->rxq.max_pkt_size >= (16 * 1024) ||
+			if (qpi->rxq.max_pkt_size > max_frame_size ||
 			    qpi->rxq.max_pkt_size < 64) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
@@ -3018,6 +3044,11 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		}
 
 		vsi->max_frame = qpi->rxq.max_pkt_size;
+		/* add space for the port VLAN since the VF driver is not
+		 * expected to account for it in the MTU calculation
+		 */
+		if (vf->port_vlan_info)
+			vsi->max_frame += VLAN_HLEN;
 	}
 
 	/* VF can request to configure less than allocated queues or default
-- 
2.26.2

