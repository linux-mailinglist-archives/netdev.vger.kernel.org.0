Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D816F21DEED
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgGMRna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:43:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:39717 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730109AbgGMRn3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 13:43:29 -0400
IronPort-SDR: 5UL4CijsMlb+/52INU9Zxgmj7C/I6lm9hOA/fQbFqnZYejf6dVLmed+R0X6WZPhGzeyR84rshg
 3dp1V3IcoKDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="147810224"
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="147810224"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 10:43:27 -0700
IronPort-SDR: rdcfP+ATdmobwAcWIthTf20cxh0zvn3b8h/9JD+/TP755fUhAaSYtZLnLSOoo3fezUn5TqYc+F
 iEN9ZIo4eDqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="317450196"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jul 2020 10:43:27 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Beilei Xing <beilei.xing@intel.com>,
        Nannan Lu <nannan.lu@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 3/5] ice: support to get the VSI mapping
Date:   Mon, 13 Jul 2020 10:43:18 -0700
Message-Id: <20200713174320.3982049-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

The DCF needs the mapping information of the VF ID to logical hardware
VSI ID, so that it can create the switch flow rules for other VFs.

Signed-off-by: Beilei Xing <beilei.xing@intel.com>
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Nannan Lu <nannan.lu@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 61 +++++++++++++++++++
 include/linux/avf/virtchnl.h                  | 21 +++++++
 2 files changed, 82 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 86ca35d0942f..45050bf189d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3849,6 +3849,64 @@ static int ice_vc_dis_dcf_cap(struct ice_vf *vf)
 				     v_ret, NULL, 0);
 }
 
+/**
+ * ice_vc_dcf_get_vsi_map - get VSI mapping table
+ * @vf: pointer to the VF info
+ */
+static int ice_vc_dcf_get_vsi_map(struct ice_vf *vf)
+{
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_dcf_vsi_map *vsi_map = NULL;
+	struct ice_pf *pf = vf->pf;
+	struct ice_vsi *pf_vsi;
+	u16 len = 0;
+	int vf_id;
+	int ret;
+
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto err;
+	}
+
+	if (!ice_is_vf_dcf(vf) || ice_dcf_get_state(pf) != ICE_DCF_STATE_ON) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto err;
+	}
+
+	len = struct_size(vsi_map, vf_vsi, pf->num_alloc_vfs - 1);
+	vsi_map = kzalloc(len, GFP_KERNEL);
+	if (!vsi_map) {
+		v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
+		len = 0;
+		goto err;
+	}
+
+	pf_vsi = ice_get_main_vsi(pf);
+	if (!pf_vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		len = 0;
+		goto err;
+	}
+
+	vsi_map->pf_vsi = pf_vsi->vsi_num;
+	vsi_map->num_vfs = pf->num_alloc_vfs;
+
+	ice_for_each_vf(pf, vf_id) {
+		struct ice_vf *tmp_vf = &pf->vf[vf_id];
+
+		if (!ice_is_vf_disabled(tmp_vf) &&
+		    test_bit(ICE_VF_STATE_INIT, tmp_vf->vf_states))
+			vsi_map->vf_vsi[vf_id] = tmp_vf->lan_vsi_num |
+				VIRTCHNL_DCF_VF_VSI_VALID;
+	}
+
+err:
+	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DCF_GET_VSI_MAP, v_ret,
+				    (u8 *)vsi_map, len);
+	kfree(vsi_map);
+	return ret;
+}
+
 /**
  * ice_vc_process_vf_msg - Process request from VF
  * @pf: pointer to the PF structure
@@ -3968,6 +4026,9 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	case VIRTCHNL_OP_DCF_DISABLE:
 		err = ice_vc_dis_dcf_cap(vf);
 		break;
+	case VIRTCHNL_OP_DCF_GET_VSI_MAP:
+		err = ice_vc_dcf_get_vsi_map(vf);
+		break;
 	case VIRTCHNL_OP_UNKNOWN:
 	default:
 		dev_err(dev, "Unsupported opcode %d from VF %d\n", v_opcode,
diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 2ff8e31f3172..a34f0a529f0a 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -140,6 +140,7 @@ enum virtchnl_ops {
 	VIRTCHNL_OP_DCF_CMD_DESC = 39,
 	VIRTCHNL_OP_DCF_CMD_BUFF = 40,
 	VIRTCHNL_OP_DCF_DISABLE = 41,
+	VIRTCHNL_OP_DCF_GET_VSI_MAP = 42,
 };
 
 /* These macros are used to generate compilation errors if a structure/union
@@ -584,6 +585,25 @@ struct virtchnl_filter {
 
 VIRTCHNL_CHECK_STRUCT_LEN(272, virtchnl_filter);
 
+/* VIRTCHNL_OP_DCF_GET_VSI_MAP
+ * VF sends this message to get VSI mapping table.
+ * PF responds with an indirect message containing VF's
+ * HW VSI IDs.
+ * The index of vf_vsi array is the logical VF ID, the
+ * value of vf_vsi array is the VF's HW VSI ID with its
+ * valid configuration.
+ */
+struct virtchnl_dcf_vsi_map {
+	u16 pf_vsi;	/* PF's HW VSI ID */
+	u16 num_vfs;	/* The actual number of VFs allocated */
+#define VIRTCHNL_DCF_VF_VSI_ID_S	0
+#define VIRTCHNL_DCF_VF_VSI_ID_M	(0xFFF << VIRTCHNL_DCF_VF_VSI_ID_S)
+#define VIRTCHNL_DCF_VF_VSI_VALID	BIT(15)
+	u16 vf_vsi[1];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_dcf_vsi_map);
+
 /* VIRTCHNL_OP_EVENT
  * PF sends this message to inform the VF driver of events that may affect it.
  * No direct response is expected from the VF, though it may generate other
@@ -846,6 +866,7 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 		valid_len = msglen;
 		break;
 	case VIRTCHNL_OP_DCF_DISABLE:
+	case VIRTCHNL_OP_DCF_GET_VSI_MAP:
 		break;
 	/* These are always errors coming from the VF. */
 	case VIRTCHNL_OP_EVENT:
-- 
2.26.2

