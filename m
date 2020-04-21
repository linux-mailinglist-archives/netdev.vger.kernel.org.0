Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8E21B20F1
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgDUIDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:03:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:28643 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728473AbgDUICw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 04:02:52 -0400
IronPort-SDR: ChuvdoPoFNpF81Yth0NtWYXKXx8mJs8BsCePCz4Y5QpXQqy7rBoPmwx60yTa83m+504YtN5vAM
 ghrOTUXTFpPw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 01:02:39 -0700
IronPort-SDR: UEYKrQM6/ecaCRf71IZJO+HYTaU5d6amQEMG+WWrEa/vQDe+xO00UXFwgfX1dermfriBdhATSv
 8jtdRKWd8tlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,409,1580803200"; 
   d="scan'208";a="429443791"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 21 Apr 2020 01:02:38 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 7/9] ice: Pass through communications to VF
Date:   Tue, 21 Apr 2020 01:02:33 -0700
Message-Id: <20200421080235.6515-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Allow for forwarding of RDMA and VF virt channel messages. The driver will
forward messages from the RDMA driver to the VF via the vc_send operation
and invoke the peer's vc_receive() call when receiving a virt channel
message destined for the peer driver.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 34 +++++++++++++++++++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 34 +++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 624190eaea47..107404eaac91 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -393,6 +393,7 @@ struct ice_pf {
 	u32 msg_enable;
 	u32 num_rdma_msix;	/* Total MSIX vectors for RDMA driver */
 	u32 rdma_base_vector;
+	struct iidc_peer_dev *rdma_peer;
 	u32 hw_csum_rx_error;
 	u32 oicr_idx;		/* Other interrupt cause MSIX vector index */
 	u32 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 5e1877772245..c8b6f0ea45fb 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -1070,6 +1070,38 @@ ice_peer_update_vsi_filter(struct iidc_peer_dev *peer_dev,
 	return ret;
 }
 
+/**
+ * ice_peer_vc_send - send a virt channel message from RDMA peer
+ * @peer_dev: pointer to RDMA peer dev
+ * @vf_id: the absolute VF ID of recipient of message
+ * @msg: pointer to message contents
+ * @len: len of message
+ */
+static int
+ice_peer_vc_send(struct iidc_peer_dev *peer_dev, u32 vf_id, u8 *msg, u16 len)
+{
+	struct ice_pf *pf;
+	int err;
+
+	if (!ice_validate_peer_dev(peer_dev))
+		return -EINVAL;
+	if (!msg || !len)
+		return -ENOMEM;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	if (vf_id >= pf->num_alloc_vfs || len > ICE_AQ_MAX_BUF_LEN)
+		return -EINVAL;
+
+	/* VIRTCHNL_OP_IWARP is being used for RoCEv2 msg also */
+	err = ice_aq_send_msg_to_vf(&pf->hw, vf_id, VIRTCHNL_OP_IWARP, 0, msg,
+				    len, NULL);
+	if (err)
+		dev_err(ice_pf_to_dev(pf), "Unable to send RDMA msg to VF, error %d\n",
+			err);
+
+	return err;
+}
+
 /* Initialize the ice_ops struct, which is used in 'ice_init_peer_devices' */
 static const struct iidc_ops ops = {
 	.alloc_res			= ice_peer_alloc_res,
@@ -1082,6 +1114,7 @@ static const struct iidc_ops ops = {
 	.peer_register			= ice_peer_register,
 	.peer_unregister		= ice_peer_unregister,
 	.update_vsi_filter		= ice_peer_update_vsi_filter,
+	.vc_send			= ice_peer_vc_send,
 };
 
 /**
@@ -1263,6 +1296,7 @@ int ice_init_peer_devices(struct ice_pf *pf)
 		switch (ice_peers[i].id) {
 		case IIDC_PEER_RDMA_ID:
 			if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+				pf->rdma_peer = peer_dev;
 				peer_dev->msix_count = pf->num_rdma_msix;
 				entry = &pf->msix_entries[pf->rdma_base_vector];
 			}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 07f3d4b456c7..95e39fef0a26 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3170,6 +3170,37 @@ static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
 				     v_ret, NULL, 0);
 }
 
+/**
+ * ice_vc_rdma_msg - send msg to RDMA PF from VF
+ * @vf: pointer to VF info
+ * @msg: pointer to msg buffer
+ * @len: length of the message
+ *
+ * This function is called indirectly from the AQ clean function.
+ */
+static int ice_vc_rdma_msg(struct ice_vf *vf, u8 *msg, u16 len)
+{
+	struct iidc_peer_dev *rdma_peer;
+	int ret;
+
+	rdma_peer = vf->pf->rdma_peer;
+	if (!rdma_peer) {
+		pr_err("Invalid RDMA peer attempted to send message to peer\n");
+		return -EIO;
+	}
+
+	if (!rdma_peer->peer_ops || !rdma_peer->peer_ops->vc_receive) {
+		pr_err("Incomplete RMDA peer attempting to send msg\n");
+		return -EINVAL;
+	}
+
+	ret = rdma_peer->peer_ops->vc_receive(rdma_peer, vf->vf_id, msg, len);
+	if (ret)
+		pr_err("Failed to send message to RDMA peer, error %d\n", ret);
+
+	return ret;
+}
+
 /**
  * ice_vf_init_vlan_stripping - enable/disable VLAN stripping on initialization
  * @vf: VF to enable/disable VLAN stripping for on initialization
@@ -3304,6 +3335,9 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
 		err = ice_vc_dis_vlan_stripping(vf);
 		break;
+	case VIRTCHNL_OP_IWARP:
+		err = ice_vc_rdma_msg(vf, msg, msglen);
+		break;
 	case VIRTCHNL_OP_UNKNOWN:
 	default:
 		dev_err(dev, "Unsupported opcode %d from VF %d\n", v_opcode,
-- 
2.25.3

