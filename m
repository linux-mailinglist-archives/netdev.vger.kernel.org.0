Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA151FEAB6
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgFRFOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:14:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:25340 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgFRFOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:14:00 -0400
IronPort-SDR: JUgpbx7EdxhDzVaVO+AcW256LdU+uKYj1lPwggUUrw7Df0NR0znphROW3lV7pODGPcFOy3bc6y
 a6dfUBaRssQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="142378052"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="142378052"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:51 -0700
IronPort-SDR: KLFGwplpSnSKZmP8oMIAy3SZyjRg2HYeNdjC9yua+uEIuwiqLBnQJgQ4Mq//1mdcbXTwx+YymX
 mS4ttNso1bTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495596"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] iecm: Implement virtchnl commands
Date:   Wed, 17 Jun 2020 22:13:36 -0700
Message-Id: <20200618051344.516587-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

Implement various virtchnl commands that enable
communication with hardware.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   | 1171 ++++++++++++++++-
 1 file changed, 1144 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
index 0fdf87d6e98f..57862fbfdb9b 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
@@ -442,7 +442,13 @@ EXPORT_SYMBOL(iecm_recv_mb_msg);
 static enum iecm_status
 iecm_send_ver_msg(struct iecm_adapter *adapter)
 {
-	/* stub */
+	struct virtchnl_version_info vvi;
+
+	vvi.major = VIRTCHNL_VERSION_MAJOR;
+	vvi.minor = VIRTCHNL_VERSION_MINOR;
+
+	return iecm_send_mb_msg(adapter, VIRTCHNL_OP_VERSION, sizeof(vvi),
+				(u8 *)&vvi);
 }
 
 /**
@@ -454,7 +460,19 @@ iecm_send_ver_msg(struct iecm_adapter *adapter)
 static enum iecm_status
 iecm_recv_ver_msg(struct iecm_adapter *adapter)
 {
-	/* stub */
+	enum iecm_status err = 0;
+	struct virtchnl_version_info vvi;
+
+	err = iecm_recv_mb_msg(adapter, VIRTCHNL_OP_VERSION, &vvi, sizeof(vvi));
+	if (err)
+		goto error;
+
+	if (vvi.major > VIRTCHNL_VERSION_MAJOR ||
+	    (vvi.major == VIRTCHNL_VERSION_MAJOR &&
+	     vvi.minor > VIRTCHNL_VERSION_MINOR))
+		dev_warn(&adapter->pdev->dev, "Virtchnl version not matched\n");
+error:
+	return err;
 }
 
 /**
@@ -466,7 +484,25 @@ iecm_recv_ver_msg(struct iecm_adapter *adapter)
 enum iecm_status
 iecm_send_get_caps_msg(struct iecm_adapter *adapter)
 {
-	/* stub */
+	struct virtchnl_get_capabilities caps = {0};
+	int buf_size;
+
+	buf_size = sizeof(struct virtchnl_get_capabilities);
+	adapter->caps = kzalloc(buf_size, GFP_KERNEL);
+	if (!adapter->caps)
+		return IECM_ERR_NO_MEMORY;
+
+	caps.cap_flags = VIRTCHNL_CAP_STATELESS_OFFLOADS |
+	       VIRTCHNL_CAP_UDP_SEG_OFFLOAD |
+	       VIRTCHNL_CAP_RSS |
+	       VIRTCHNL_CAP_TCP_RSC |
+	       VIRTCHNL_CAP_HEADER_SPLIT |
+	       VIRTCHNL_CAP_RDMA |
+	       VIRTCHNL_CAP_SRIOV |
+	       VIRTCHNL_CAP_EDT;
+
+	return iecm_send_mb_msg(adapter, VIRTCHNL_OP_GET_CAPS, sizeof(caps),
+				(u8 *)&caps);
 }
 EXPORT_SYMBOL(iecm_send_get_caps_msg);
 
@@ -479,7 +515,8 @@ EXPORT_SYMBOL(iecm_send_get_caps_msg);
 static enum iecm_status
 iecm_recv_get_caps_msg(struct iecm_adapter *adapter)
 {
-	/* stub */
+	return iecm_recv_mb_msg(adapter, VIRTCHNL_OP_GET_CAPS, adapter->caps,
+			       sizeof(struct virtchnl_get_capabilities));
 }
 
 /**
@@ -493,7 +530,30 @@ iecm_recv_get_caps_msg(struct iecm_adapter *adapter)
 static enum iecm_status
 iecm_send_create_vport_msg(struct iecm_adapter *adapter)
 {
-	/* stub */
+	struct virtchnl_create_vport *vport_msg;
+	enum iecm_status err = 0;
+	int buf_size;
+
+	buf_size = sizeof(struct virtchnl_create_vport);
+	if (!adapter->vport_params_reqd[0]) {
+		adapter->vport_params_reqd[0] = kzalloc(buf_size, GFP_KERNEL);
+		if (!adapter->vport_params_reqd[0]) {
+			err = IECM_ERR_NO_MEMORY;
+			goto error;
+		}
+	}
+
+	vport_msg = (struct virtchnl_create_vport *)
+			adapter->vport_params_reqd[0];
+	vport_msg->vport_type = VIRTCHNL_VPORT_TYPE_DEFAULT;
+	vport_msg->txq_model = VIRTCHNL_QUEUE_MODEL_SPLIT;
+	vport_msg->rxq_model = VIRTCHNL_QUEUE_MODEL_SPLIT;
+	iecm_vport_calc_total_qs(vport_msg, 0);
+
+	err = iecm_send_mb_msg(adapter, VIRTCHNL_OP_CREATE_VPORT, buf_size,
+			       (u8 *)vport_msg);
+error:
+	return err;
 }
 
 /**
@@ -509,7 +569,26 @@ static enum iecm_status
 iecm_recv_create_vport_msg(struct iecm_adapter *adapter,
 			   int *vport_id)
 {
-	/* stub */
+	struct virtchnl_create_vport *vport_msg;
+	enum iecm_status err = 0;
+
+	if (!adapter->vport_params_recvd[0]) {
+		adapter->vport_params_recvd[0] = kzalloc(IECM_DFLT_MBX_BUF_SIZE,
+							 GFP_KERNEL);
+		if (!adapter->vport_params_recvd[0]) {
+			err = IECM_ERR_NO_MEMORY;
+			goto error;
+		}
+	}
+
+	vport_msg = (struct virtchnl_create_vport *)
+			adapter->vport_params_recvd[0];
+
+	err = iecm_recv_mb_msg(adapter, VIRTCHNL_OP_CREATE_VPORT, vport_msg,
+			       IECM_DFLT_MBX_BUF_SIZE);
+	*vport_id = vport_msg->vport_id;
+error:
+	return err;
 }
 
 /**
@@ -560,7 +639,20 @@ EXPORT_SYMBOL(iecm_wait_for_event);
 enum iecm_status
 iecm_send_destroy_vport_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	struct virtchnl_vport v_id;
+	enum iecm_status err;
+
+	v_id.vport_id = vport->vport_id;
+
+	err = iecm_send_mb_msg(adapter, VIRTCHNL_OP_DESTROY_VPORT,
+			       sizeof(v_id), (u8 *)&v_id);
+
+	if (!err)
+		err = iecm_wait_for_event(adapter, IECM_VC_DESTROY_VPORT,
+					  IECM_VC_DESTROY_VPORT_ERR);
+
+	return err;
 }
 
 /**
@@ -598,7 +690,121 @@ iecm_send_disable_vport_msg(struct iecm_vport *vport)
 enum iecm_status
 iecm_send_config_tx_queues_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	struct virtchnl_config_tx_queues *ctq = NULL;
+	struct virtchnl_txq_info_v2 *qi;
+	enum iecm_status err = 0;
+	int totqs, num_msgs;
+	int i, k = 0;
+	int num_qs;
+
+	totqs = vport->num_txq + vport->num_complq;
+	qi = kcalloc(totqs, sizeof(struct virtchnl_txq_info_v2), GFP_KERNEL);
+	if (!qi) {
+		err = IECM_ERR_NO_MEMORY;
+		goto error;
+	}
+
+	/* Populate the queue info buffer with all queue context info */
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		struct iecm_txq_group *tx_qgrp = &vport->txq_grps[i];
+		int j;
+
+		for (j = 0; j < tx_qgrp->num_txq; j++, k++) {
+			qi[k].queue_id = tx_qgrp->txqs[j].q_id;
+			qi[k].model = vport->txq_model;
+			qi[k].type = tx_qgrp->txqs[j].q_type;
+			qi[k].ring_len = tx_qgrp->txqs[j].desc_count;
+			qi[k].dma_ring_addr = tx_qgrp->txqs[j].dma;
+			if (iecm_is_queue_model_split(vport->txq_model)) {
+				struct iecm_queue *q = &tx_qgrp->txqs[j];
+
+				qi[k].tx_compl_queue_id = tx_qgrp->complq->q_id;
+				qi[k].desc_profile =
+					VIRTCHNL_TXQ_DESC_PROFILE_NATIVE;
+
+				if (test_bit(__IECM_Q_FLOW_SCH_EN, q->flags))
+					qi[k].sched_mode =
+						VIRTCHNL_TXQ_SCHED_MODE_FLOW;
+				else
+					qi[k].sched_mode =
+						VIRTCHNL_TXQ_SCHED_MODE_QUEUE;
+			} else {
+				qi[k].sched_mode =
+					VIRTCHNL_TXQ_SCHED_MODE_QUEUE;
+				qi[k].desc_profile =
+					VIRTCHNL_TXQ_DESC_PROFILE_BASE;
+			}
+		}
+
+		if (iecm_is_queue_model_split(vport->txq_model)) {
+			qi[k].queue_id = tx_qgrp->complq->q_id;
+			qi[k].model = vport->txq_model;
+			qi[k].type = tx_qgrp->complq->q_type;
+			qi[k].desc_profile = VIRTCHNL_TXQ_DESC_PROFILE_NATIVE;
+			qi[k].ring_len = tx_qgrp->complq->desc_count;
+			qi[k].dma_ring_addr = tx_qgrp->complq->dma;
+			k++;
+		}
+	}
+
+	if (k != totqs) {
+		err = IECM_ERR_CFG;
+		goto error;
+	}
+
+	/* Chunk up the queue contexts into multiple messages to avoid
+	 * sending a control queue message buffer that is too large
+	 */
+	if (totqs < IECM_NUM_QCTX_PER_MSG)
+		num_qs = totqs;
+	else
+		num_qs = IECM_NUM_QCTX_PER_MSG;
+
+	num_msgs = totqs / IECM_NUM_QCTX_PER_MSG;
+	if (totqs % IECM_NUM_QCTX_PER_MSG)
+		num_msgs++;
+
+	for (i = 0, k = 0; i < num_msgs || num_qs; i++) {
+		int buf_size = sizeof(struct virtchnl_config_tx_queues) +
+			   (sizeof(struct virtchnl_txq_info_v2) * (num_qs - 1));
+		if (!ctq || num_qs != IECM_NUM_QCTX_PER_MSG) {
+			kfree(ctq);
+			ctq = kzalloc(buf_size, GFP_KERNEL);
+			if (!ctq) {
+				err = IECM_ERR_NO_MEMORY;
+				goto error;
+			}
+		} else {
+			memset(ctq, 0, buf_size);
+		}
+
+		ctq->vport_id = vport->vport_id;
+		ctq->num_qinfo = num_qs;
+		memcpy(ctq->qinfo, &qi[k],
+		       sizeof(struct virtchnl_txq_info_v2) * num_qs);
+
+		err = iecm_send_mb_msg(vport->adapter,
+				       VIRTCHNL_OP_CONFIG_TX_QUEUES,
+				       buf_size, (u8 *)ctq);
+
+		if (!err)
+			err = iecm_wait_for_event(vport->adapter,
+						  IECM_VC_CONFIG_TXQ,
+						  IECM_VC_CONFIG_TXQ_ERR);
+		if (err)
+			goto mbx_error;
+
+		k += num_qs;
+		totqs -= num_qs;
+		if (totqs < IECM_NUM_QCTX_PER_MSG)
+			num_qs = totqs;
+	}
+
+mbx_error:
+	kfree(ctq);
+error:
+	kfree(qi);
+	return err;
 }
 
 /**
@@ -612,7 +818,148 @@ iecm_send_config_tx_queues_msg(struct iecm_vport *vport)
 enum iecm_status
 iecm_send_config_rx_queues_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	struct virtchnl_config_rx_queues *crq = NULL;
+	struct virtchnl_rxq_info_v2 *qi;
+	enum iecm_status err = 0;
+	int totqs, num_msgs;
+	int i, k = 0;
+	int num_qs;
+
+	totqs = vport->num_rxq + vport->num_bufq;
+	qi = kcalloc(totqs, sizeof(struct virtchnl_rxq_info_v2), GFP_KERNEL);
+	if (!qi) {
+		err = IECM_ERR_NO_MEMORY;
+		goto error;
+	}
+
+	/* Populate the queue info buffer with all queue context info */
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct iecm_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+		int num_rxq;
+		int j;
+
+		if (iecm_is_queue_model_split(vport->rxq_model))
+			num_rxq = rx_qgrp->splitq.num_rxq_sets;
+		else
+			num_rxq = rx_qgrp->singleq.num_rxq;
+
+		for (j = 0; j < num_rxq; j++, k++) {
+			struct iecm_queue *rxq;
+
+			if (iecm_is_queue_model_split(vport->rxq_model)) {
+				rxq = &rx_qgrp->splitq.rxq_sets[j].rxq;
+				qi[k].rx_bufq1_id =
+				  rxq->rxq_grp->splitq.bufq_sets[0].bufq.q_id;
+				qi[k].rx_bufq2_id =
+				  rxq->rxq_grp->splitq.bufq_sets[1].bufq.q_id;
+				qi[k].hdr_buffer_size = rxq->rx_hbuf_size;
+				qi[k].rsc_low_watermark =
+					rxq->rsc_low_watermark;
+
+				if (rxq->rx_hsplit_en) {
+					qi[k].queue_flags =
+						VIRTCHNL_RXQ_HDR_SPLIT;
+					qi[k].hdr_buffer_size =
+						rxq->rx_hbuf_size;
+				}
+				if (iecm_is_feature_ena(vport, NETIF_F_GRO_HW))
+					qi[k].queue_flags |= VIRTCHNL_RXQ_RSC;
+			} else {
+				rxq = &rx_qgrp->singleq.rxqs[j];
+			}
+
+			qi[k].queue_id = rxq->q_id;
+			qi[k].model = vport->rxq_model;
+			qi[k].type = rxq->q_type;
+			qi[k].desc_profile = VIRTCHNL_TXQ_DESC_PROFILE_BASE;
+			qi[k].desc_size = VIRTCHNL_RXQ_DESC_SIZE_32BYTE;
+			qi[k].ring_len = rxq->desc_count;
+			qi[k].dma_ring_addr = rxq->dma;
+			qi[k].max_pkt_size = rxq->rx_max_pkt_size;
+			qi[k].data_buffer_size = rxq->rx_buf_size;
+		}
+
+		if (iecm_is_queue_model_split(vport->rxq_model)) {
+			for (j = 0; j < IECM_BUFQS_PER_RXQ_SET; j++, k++) {
+				struct iecm_queue *bufq =
+					&rx_qgrp->splitq.bufq_sets[j].bufq;
+
+				qi[k].queue_id = bufq->q_id;
+				qi[k].model = vport->rxq_model;
+				qi[k].type = bufq->q_type;
+				qi[k].desc_profile =
+					VIRTCHNL_TXQ_DESC_PROFILE_NATIVE;
+				qi[k].desc_size =
+					VIRTCHNL_RXQ_DESC_SIZE_32BYTE;
+				qi[k].ring_len = bufq->desc_count;
+				qi[k].dma_ring_addr = bufq->dma;
+				qi[k].data_buffer_size = bufq->rx_buf_size;
+				qi[k].buffer_notif_stride =
+					bufq->rx_buf_stride;
+				qi[k].rsc_low_watermark =
+					bufq->rsc_low_watermark;
+			}
+		}
+	}
+
+	if (k != totqs) {
+		err = IECM_ERR_CFG;
+		goto error;
+	}
+
+	/* Chunk up the queue contexts into multiple messages to avoid
+	 * sending a control queue message buffer that is too large
+	 */
+	if (totqs < IECM_NUM_QCTX_PER_MSG)
+		num_qs = totqs;
+	else
+		num_qs = IECM_NUM_QCTX_PER_MSG;
+
+	num_msgs = totqs / IECM_NUM_QCTX_PER_MSG;
+	if (totqs % IECM_NUM_QCTX_PER_MSG)
+		num_msgs++;
+
+	for (i = 0, k = 0; i < num_msgs || num_qs; i++) {
+		int buf_size = sizeof(struct virtchnl_config_rx_queues) +
+			   (sizeof(struct virtchnl_rxq_info_v2) * (num_qs - 1));
+		if (!crq || num_qs != IECM_NUM_QCTX_PER_MSG) {
+			kfree(crq);
+			crq = kzalloc(buf_size, GFP_KERNEL);
+			if (!crq) {
+				err = IECM_ERR_NO_MEMORY;
+				goto error;
+			}
+		} else {
+			memset(crq, 0, buf_size);
+		}
+
+		crq->vport_id = vport->vport_id;
+		crq->num_qinfo = num_qs;
+		memcpy(crq->qinfo, &qi[k],
+		       sizeof(struct virtchnl_rxq_info_v2) * num_qs);
+
+		err = iecm_send_mb_msg(vport->adapter,
+				       VIRTCHNL_OP_CONFIG_RX_QUEUES,
+				       buf_size, (u8 *)crq);
+
+		if (!err)
+			err = iecm_wait_for_event(vport->adapter,
+						  IECM_VC_CONFIG_RXQ,
+						  IECM_VC_CONFIG_RXQ_ERR);
+		if (err)
+			goto mbx_error;
+
+		k += num_qs;
+		totqs -= num_qs;
+		if (totqs < IECM_NUM_QCTX_PER_MSG)
+			num_qs = totqs;
+	}
+
+mbx_error:
+	kfree(crq);
+error:
+	kfree(qi);
+	return err;
 }
 
 /**
@@ -629,7 +976,118 @@ static enum iecm_status
 iecm_send_ena_dis_queues_msg(struct iecm_vport *vport,
 			     enum virtchnl_ops vc_op)
 {
-	/* stub */
+	struct virtchnl_del_ena_dis_queues *eq;
+	struct virtchnl_queue_chunk *qc;
+	int num_txq, num_rxq, num_q;
+	int i, j, k = 0, buf_size;
+	enum iecm_status err = 0;
+
+	/* validate virtchnl op */
+	switch (vc_op) {
+	case VIRTCHNL_OP_ENABLE_QUEUES_V2:
+	case VIRTCHNL_OP_DISABLE_QUEUES_V2:
+		break;
+	default:
+		err = IECM_ERR_CFG;
+		goto error;
+	}
+
+	num_txq = vport->num_txq + vport->num_complq;
+	num_rxq = vport->num_rxq + vport->num_bufq;
+	num_q = num_txq + num_rxq;
+	buf_size = sizeof(struct virtchnl_del_ena_dis_queues) +
+		       (sizeof(struct virtchnl_queue_chunk) * (num_q - 1));
+	eq = kzalloc(buf_size, GFP_KERNEL);
+	if (!eq) {
+		err = IECM_ERR_NO_MEMORY;
+		goto error;
+	}
+
+	eq->vport_id = vport->vport_id;
+	eq->chunks.num_chunks = num_q;
+	qc = eq->chunks.chunks;
+
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		struct iecm_txq_group *tx_qgrp = &vport->txq_grps[i];
+
+		for (j = 0; j < tx_qgrp->num_txq; j++, k++) {
+			qc[k].type = tx_qgrp->txqs[j].q_type;
+			qc[k].start_queue_id = tx_qgrp->txqs[j].q_id;
+			qc[k].num_queues = 1;
+		}
+	}
+	if (vport->num_txq != k) {
+		err = IECM_ERR_CFG;
+		goto err_cfg;
+	}
+
+	if (iecm_is_queue_model_split(vport->txq_model)) {
+		for (i = 0; i < vport->num_txq_grp; i++, k++) {
+			struct iecm_txq_group *tx_qgrp = &vport->txq_grps[i];
+
+			qc[k].type = tx_qgrp->complq->q_type;
+			qc[k].start_queue_id = tx_qgrp->complq->q_id;
+			qc[k].num_queues = 1;
+		}
+		if (vport->num_complq != (k - vport->num_txq)) {
+			err = IECM_ERR_CFG;
+			goto err_cfg;
+		}
+	}
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct iecm_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+
+		if (iecm_is_queue_model_split(vport->rxq_model))
+			num_rxq = rx_qgrp->splitq.num_rxq_sets;
+		else
+			num_rxq = rx_qgrp->singleq.num_rxq;
+
+		for (j = 0; j < num_rxq; j++, k++) {
+			if (iecm_is_queue_model_split(vport->rxq_model)) {
+				qc[k].start_queue_id =
+					rx_qgrp->splitq.rxq_sets[j].rxq.q_id;
+				qc[k].type =
+					rx_qgrp->splitq.rxq_sets[j].rxq.q_type;
+			} else {
+				qc[k].start_queue_id =
+					rx_qgrp->singleq.rxqs[j].q_id;
+				qc[k].type =
+					rx_qgrp->singleq.rxqs[j].q_type;
+			}
+			qc[k].num_queues = 1;
+		}
+	}
+	if (vport->num_rxq != k - (vport->num_txq + vport->num_complq)) {
+		err = IECM_ERR_CFG;
+		goto err_cfg;
+	}
+
+	if (iecm_is_queue_model_split(vport->rxq_model)) {
+		for (i = 0; i < vport->num_rxq_grp; i++) {
+			struct iecm_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+			struct iecm_queue *q;
+
+			for (j = 0; j < IECM_BUFQS_PER_RXQ_SET; j++, k++) {
+				q = &rx_qgrp->splitq.bufq_sets[j].bufq;
+				qc[k].type = q->q_type;
+				qc[k].start_queue_id = q->q_id;
+				qc[k].num_queues = 1;
+			}
+		}
+		if (vport->num_bufq != k - (vport->num_txq +
+					    vport->num_complq +
+					    vport->num_rxq)) {
+			err = IECM_ERR_CFG;
+			goto err_cfg;
+		}
+	}
+
+	err = iecm_send_mb_msg(vport->adapter, vc_op, buf_size, (u8 *)eq);
+err_cfg:
+	kfree(eq);
+error:
+	return err;
 }
 
 /**
@@ -646,7 +1104,107 @@ static enum iecm_status
 iecm_send_map_unmap_queue_vector_msg(struct iecm_vport *vport,
 				     bool map)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	struct virtchnl_queue_vector_maps *vqvm;
+	struct virtchnl_queue_vector *vqv;
+	int buf_size, num_q, i, j, k = 0;
+	enum iecm_status err = 0;
+
+	num_q = vport->num_txq + vport->num_rxq;
+
+	buf_size = sizeof(struct virtchnl_queue_vector_maps) +
+		   (sizeof(struct virtchnl_queue_vector) * (num_q - 1));
+	vqvm = kzalloc(buf_size, GFP_KERNEL);
+	if (!vqvm) {
+		err = IECM_ERR_NO_MEMORY;
+		goto error;
+	}
+
+	vqvm->vport_id = vport->vport_id;
+	vqvm->num_maps = num_q;
+	vqv = vqvm->qv_maps;
+
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		struct iecm_txq_group *tx_qgrp = &vport->txq_grps[i];
+
+		for (j = 0; j < tx_qgrp->num_txq; j++, k++) {
+			vqv[k].queue_type = tx_qgrp->txqs[j].q_type;
+			vqv[k].queue_id = tx_qgrp->txqs[j].q_id;
+
+			if (iecm_is_queue_model_split(vport->txq_model)) {
+				vqv[k].vector_id =
+					tx_qgrp->complq->q_vector->v_idx;
+				vqv[k].itr_idx =
+					tx_qgrp->complq->itr.itr_idx;
+			} else {
+				vqv[k].vector_id =
+					tx_qgrp->txqs[j].q_vector->v_idx;
+				vqv[k].itr_idx =
+					tx_qgrp->txqs[j].itr.itr_idx;
+			}
+		}
+	}
+
+	if (vport->num_txq != k) {
+		err = IECM_ERR_CFG;
+		goto err_cfg;
+	}
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct iecm_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+		int num_rxq;
+
+		if (iecm_is_queue_model_split(vport->rxq_model))
+			num_rxq = rx_qgrp->splitq.num_rxq_sets;
+		else
+			num_rxq = rx_qgrp->singleq.num_rxq;
+
+		for (j = 0; j < num_rxq; j++, k++) {
+			struct iecm_queue *rxq;
+
+			if (iecm_is_queue_model_split(vport->rxq_model))
+				rxq = &rx_qgrp->splitq.rxq_sets[j].rxq;
+			else
+				rxq = &rx_qgrp->singleq.rxqs[j];
+
+			vqv[k].queue_type = rxq->q_type;
+			vqv[k].queue_id = rxq->q_id;
+			vqv[k].vector_id = rxq->q_vector->v_idx;
+			vqv[k].itr_idx = rxq->itr.itr_idx;
+		}
+	}
+
+	if (iecm_is_queue_model_split(vport->txq_model)) {
+		if (vport->num_rxq != k - vport->num_complq) {
+			err = IECM_ERR_CFG;
+			goto err_cfg;
+		}
+	} else {
+		if (vport->num_rxq != k - vport->num_txq) {
+			err = IECM_ERR_CFG;
+			goto err_cfg;
+		}
+	}
+
+	if (map) {
+		err = iecm_send_mb_msg(adapter,
+				       VIRTCHNL_OP_MAP_QUEUE_VECTOR,
+				       buf_size, (u8 *)vqvm);
+		if (!err)
+			err = iecm_wait_for_event(adapter, IECM_VC_MAP_IRQ,
+						  IECM_VC_MAP_IRQ_ERR);
+	} else {
+		err = iecm_send_mb_msg(adapter,
+				       VIRTCHNL_OP_UNMAP_QUEUE_VECTOR,
+				       buf_size, (u8 *)vqvm);
+		if (!err)
+			err = iecm_wait_for_event(adapter, IECM_VC_UNMAP_IRQ,
+						  IECM_VC_UNMAP_IRQ_ERR);
+	}
+err_cfg:
+	kfree(vqvm);
+error:
+	return err;
 }
 
 /**
@@ -658,7 +1216,16 @@ iecm_send_map_unmap_queue_vector_msg(struct iecm_vport *vport,
 static enum iecm_status
 iecm_send_enable_queues_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	enum iecm_status err;
+
+	err = iecm_send_ena_dis_queues_msg(vport,
+					   VIRTCHNL_OP_ENABLE_QUEUES_V2);
+	if (!err)
+		err = iecm_wait_for_event(adapter, IECM_VC_ENA_QUEUES,
+					  IECM_VC_ENA_QUEUES_ERR);
+
+	return err;
 }
 
 /**
@@ -670,7 +1237,15 @@ iecm_send_enable_queues_msg(struct iecm_vport *vport)
 static enum iecm_status
 iecm_send_disable_queues_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	enum iecm_status err;
+
+	err = iecm_send_ena_dis_queues_msg(vport,
+					   VIRTCHNL_OP_DISABLE_QUEUES_V2);
+	if (!err)
+		err = iecm_wait_for_event(adapter, IECM_VC_DIS_QUEUES,
+					  IECM_VC_DIS_QUEUES_ERR);
+	return err;
 }
 
 /**
@@ -682,7 +1257,48 @@ iecm_send_disable_queues_msg(struct iecm_vport *vport)
 enum iecm_status
 iecm_send_delete_queues_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	struct virtchnl_create_vport *vport_params;
+	struct virtchnl_del_ena_dis_queues *eq;
+	struct virtchnl_queue_chunks *chunks;
+	int buf_size, num_chunks;
+	enum iecm_status err;
+
+	if (vport->adapter->config_data.req_qs_chunks) {
+		struct virtchnl_add_queues *vc_aq =
+			(struct virtchnl_add_queues *)
+			vport->adapter->config_data.req_qs_chunks;
+		chunks = &vc_aq->chunks;
+	} else {
+		vport_params = (struct virtchnl_create_vport *)
+				vport->adapter->vport_params_recvd[0];
+		 chunks = &vport_params->chunks;
+	}
+
+	num_chunks = chunks->num_chunks;
+	buf_size = sizeof(struct virtchnl_del_ena_dis_queues) +
+		   (sizeof(struct virtchnl_queue_chunk) *
+		    (num_chunks - 1));
+
+	eq = kzalloc(buf_size, GFP_KERNEL);
+	if (!eq) {
+		err = IECM_ERR_NO_MEMORY;
+		return err;
+	}
+	eq->vport_id = vport->vport_id;
+	eq->chunks.num_chunks = num_chunks;
+
+	memcpy(eq->chunks.chunks, chunks->chunks, num_chunks *
+	       sizeof(struct virtchnl_queue_chunk));
+
+	err = iecm_send_mb_msg(vport->adapter, VIRTCHNL_OP_DEL_QUEUES,
+			       buf_size, (u8 *)eq);
+	if (!err)
+		err = iecm_wait_for_event(adapter, IECM_VC_DEL_QUEUES,
+					  IECM_VC_DEL_QUEUES_ERR);
+
+	kfree(eq);
+	return err;
 }
 
 /**
@@ -694,7 +1310,14 @@ iecm_send_delete_queues_msg(struct iecm_vport *vport)
 static enum iecm_status
 iecm_send_config_queues_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	enum iecm_status err;
+
+	err = iecm_send_config_tx_queues_msg(vport);
+
+	if (!err)
+		err = iecm_send_config_rx_queues_msg(vport);
+
+	return err;
 }
 
 /**
@@ -711,7 +1334,55 @@ enum iecm_status
 iecm_send_add_queues_msg(struct iecm_vport *vport, u16 num_tx_q,
 			 u16 num_complq, u16 num_rx_q, u16 num_rx_bufq)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	struct virtchnl_add_queues aq = {0};
+	enum iecm_status err;
+	int size;
+
+	aq.vport_id = vport->vport_id;
+	aq.num_tx_q = num_tx_q;
+	aq.num_tx_complq = num_complq;
+	aq.num_rx_q = num_rx_q;
+	aq.num_rx_bufq = num_rx_bufq;
+
+	err = iecm_send_mb_msg(adapter,
+			       VIRTCHNL_OP_ADD_QUEUES,
+			       sizeof(struct virtchnl_add_queues), (u8 *)&aq);
+
+	if (!err)
+		err = iecm_wait_for_event(adapter, IECM_VC_ADD_QUEUES,
+					  IECM_VC_ADD_QUEUES_ERR);
+
+	if (!err) {
+		struct virtchnl_add_queues *vc_msg =
+			(struct virtchnl_add_queues *)adapter->vc_msg;
+
+		kfree(adapter->config_data.req_qs_chunks);
+		adapter->config_data.req_qs_chunks = NULL;
+
+		/* compare vc_msg num queues with vport num queues */
+		if (vc_msg->num_tx_q != num_tx_q ||
+		    vc_msg->num_rx_q != num_rx_q ||
+		    vc_msg->num_tx_complq != num_complq ||
+		    vc_msg->num_rx_bufq != num_rx_bufq)
+			return IECM_ERR_CFG;
+
+		size = sizeof(struct virtchnl_add_queues) +
+				((vc_msg->chunks.num_chunks - 1) *
+				sizeof(struct virtchnl_queue_chunk));
+		adapter->config_data.req_qs_chunks =
+			kzalloc(size, GFP_KERNEL);
+		if (!adapter->config_data.req_qs_chunks) {
+			err = IECM_ERR_NO_MEMORY;
+			mutex_unlock(&adapter->vc_msg_lock);
+			goto mem_err;
+		}
+		memcpy(adapter->config_data.req_qs_chunks,
+		       adapter->vc_msg, size);
+		mutex_unlock(&adapter->vc_msg_lock);
+	}
+mem_err:
+	return err;
 }
 
 /**
@@ -723,7 +1394,44 @@ iecm_send_add_queues_msg(struct iecm_vport *vport, u16 num_tx_q,
 enum iecm_status
 iecm_send_get_stats_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	struct virtchnl_queue_select vqs;
+	enum iecm_status err;
+
+	/* Don't send get_stats message if one is pending or the
+	 * link is down
+	 */
+	if (test_bit(IECM_VC_GET_STATS, adapter->vc_state) ||
+	    adapter->state <= __IECM_DOWN)
+		return 0;
+
+	vqs.vsi_id = vport->vport_id;
+
+	err = iecm_send_mb_msg(adapter, VIRTCHNL_OP_GET_STATS,
+			       sizeof(vqs), (u8 *)&vqs);
+
+	if (!err)
+		err = iecm_wait_for_event(adapter, IECM_VC_GET_STATS,
+					  IECM_VC_GET_STATS_ERR);
+
+	if (!err) {
+		struct virtchnl_eth_stats *stats =
+			(struct virtchnl_eth_stats *)adapter->vc_msg;
+		vport->netstats.rx_packets = stats->rx_unicast +
+						 stats->rx_multicast +
+						 stats->rx_broadcast;
+		vport->netstats.tx_packets = stats->tx_unicast +
+						 stats->tx_multicast +
+						 stats->tx_broadcast;
+		vport->netstats.rx_bytes = stats->rx_bytes;
+		vport->netstats.tx_bytes = stats->tx_bytes;
+		vport->netstats.tx_errors = stats->tx_errors;
+		vport->netstats.rx_dropped = stats->rx_discards;
+		vport->netstats.tx_dropped = stats->tx_discards;
+		mutex_unlock(&adapter->vc_msg_lock);
+	}
+
+	return err;
 }
 
 /**
@@ -736,7 +1444,36 @@ iecm_send_get_stats_msg(struct iecm_vport *vport)
 enum iecm_status
 iecm_send_get_set_rss_hash_msg(struct iecm_vport *vport, bool get)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	struct virtchnl_rss_hash rh = {0};
+	enum iecm_status err;
+
+	rh.vport_id = vport->vport_id;
+	rh.hash = adapter->rss_data.rss_hash;
+
+	if (get) {
+		err = iecm_send_mb_msg(adapter, VIRTCHNL_OP_GET_RSS_HASH,
+				       sizeof(rh), (u8 *)&rh);
+		if (!err) {
+			err = iecm_wait_for_event(adapter, IECM_VC_GET_RSS_HASH,
+						  IECM_VC_GET_RSS_HASH_ERR);
+			if (!err) {
+				memcpy(&rh, adapter->vc_msg, sizeof(rh));
+				adapter->rss_data.rss_hash = rh.hash;
+				/* Leave the buffer clean for next message */
+				memset(adapter->vc_msg, 0,
+				       IECM_DFLT_MBX_BUF_SIZE);
+				mutex_unlock(&adapter->vc_msg_lock);
+			}
+		}
+	} else {
+		err = iecm_send_mb_msg(adapter, VIRTCHNL_OP_SET_RSS_HASH,
+				       sizeof(rh), (u8 *)&rh);
+		if (!err)
+			err = iecm_wait_for_event(adapter, IECM_VC_SET_RSS_HASH,
+						  IECM_VC_SET_RSS_HASH_ERR);
+	}
+	return err;
 }
 
 /**
@@ -749,7 +1486,72 @@ iecm_send_get_set_rss_hash_msg(struct iecm_vport *vport, bool get)
 enum iecm_status
 iecm_send_get_set_rss_lut_msg(struct iecm_vport *vport, bool get)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	struct virtchnl_rss_lut_v2 *recv_rl;
+	struct virtchnl_rss_lut_v2 *rl;
+	enum iecm_status err;
+	int i, buf_size;
+
+	buf_size = sizeof(struct virtchnl_rss_lut_v2) +
+		       (sizeof(u16) * (adapter->rss_data.rss_lut_size - 1));
+	rl = kzalloc(buf_size, GFP_KERNEL);
+	if (!rl) {
+		err = IECM_ERR_NO_MEMORY;
+		goto error;
+	}
+
+	if (!get) {
+		rl->lut_entries = adapter->rss_data.rss_lut_size;
+		for (i = 0; i < adapter->rss_data.rss_lut_size; i++)
+			rl->lut[i] = adapter->rss_data.rss_lut[i];
+	}
+	rl->vport_id = vport->vport_id;
+
+	if (get) {
+		err = iecm_send_mb_msg(vport->adapter, VIRTCHNL_OP_GET_RSS_LUT,
+				       buf_size, (u8 *)rl);
+		if (!err) {
+			err = iecm_wait_for_event(adapter, IECM_VC_GET_RSS_LUT,
+						  IECM_VC_GET_RSS_LUT_ERR);
+			if (err)
+				goto get_lut_err;
+			recv_rl = (struct virtchnl_rss_lut_v2 *)adapter->vc_msg;
+			if (adapter->rss_data.rss_lut_size !=
+			    recv_rl->lut_entries) {
+				adapter->rss_data.rss_lut_size =
+					recv_rl->lut_entries;
+				kfree(adapter->rss_data.rss_lut);
+				adapter->rss_data.rss_lut =
+					kzalloc(adapter->rss_data.rss_lut_size,
+						GFP_KERNEL);
+				if (!adapter->rss_data.rss_lut) {
+					adapter->rss_data.rss_lut_size = 0;
+					err = IECM_ERR_NO_MEMORY;
+					/* Leave the buffer clean */
+					memset(adapter->vc_msg, 0,
+					       IECM_DFLT_MBX_BUF_SIZE);
+					mutex_unlock(&adapter->vc_msg_lock);
+					goto mem_alloc_err;
+				}
+			}
+			memcpy(adapter->rss_data.rss_lut, adapter->vc_msg,
+			       adapter->rss_data.rss_lut_size);
+			/* Leave the buffer clean for next message */
+			memset(adapter->vc_msg, 0, IECM_DFLT_MBX_BUF_SIZE);
+			mutex_unlock(&adapter->vc_msg_lock);
+		}
+	} else {
+		err = iecm_send_mb_msg(adapter, VIRTCHNL_OP_SET_RSS_LUT,
+				       buf_size, (u8 *)rl);
+		if (!err)
+			err = iecm_wait_for_event(adapter, IECM_VC_SET_RSS_LUT,
+						  IECM_VC_SET_RSS_LUT_ERR);
+	}
+mem_alloc_err:
+get_lut_err:
+	kfree(rl);
+error:
+	return err;
 }
 
 /**
@@ -762,7 +1564,74 @@ iecm_send_get_set_rss_lut_msg(struct iecm_vport *vport, bool get)
 enum iecm_status
 iecm_send_get_set_rss_key_msg(struct iecm_vport *vport, bool get)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	struct virtchnl_rss_key *recv_rk;
+	struct virtchnl_rss_key *rk;
+	enum iecm_status err;
+	int i, buf_size;
+
+	buf_size = sizeof(struct virtchnl_rss_key) +
+		   (sizeof(u8) * (adapter->rss_data.rss_key_size - 1));
+	rk = kzalloc(buf_size, GFP_KERNEL);
+	if (!rk) {
+		err = IECM_ERR_NO_MEMORY;
+		goto error;
+	}
+
+	if (!get) {
+		rk->key_len = adapter->rss_data.rss_key_size;
+		for (i = 0; i < adapter->rss_data.rss_key_size; i++)
+			rk->key[i] = adapter->rss_data.rss_key[i];
+	}
+	rk->vsi_id = vport->vport_id;
+
+	if (get) {
+		err = iecm_send_mb_msg(adapter, VIRTCHNL_OP_GET_RSS_KEY,
+				       buf_size, (u8 *)rk);
+		if (!err) {
+			err = iecm_wait_for_event(adapter, IECM_VC_GET_RSS_KEY,
+						  IECM_VC_GET_RSS_KEY_ERR);
+			if (err)
+				goto get_key_err;
+			recv_rk = (struct virtchnl_rss_key *)adapter->vc_msg;
+			if (adapter->rss_data.rss_key_size !=
+			    recv_rk->key_len) {
+				adapter->rss_data.rss_key_size =
+					min_t(u16, NETDEV_RSS_KEY_LEN,
+					      recv_rk->key_len);
+				kfree(adapter->rss_data.rss_key);
+				adapter->rss_data.rss_key =
+					kzalloc(adapter->rss_data.rss_key_size,
+						GFP_KERNEL);
+				if (!adapter->rss_data.rss_key) {
+					adapter->rss_data.rss_key_size = 0;
+					err = IECM_ERR_NO_MEMORY;
+					/* Leave the buffer clean */
+					memset(adapter->vc_msg, 0,
+					       IECM_DFLT_MBX_BUF_SIZE);
+					mutex_unlock(&adapter->vc_msg_lock);
+					goto mem_alloc_err;
+				}
+			}
+			memcpy(adapter->rss_data.rss_key, adapter->vc_msg,
+			       adapter->rss_data.rss_key_size);
+			/* Leave the buffer clean for next message */
+			memset(adapter->vc_msg, 0, IECM_DFLT_MBX_BUF_SIZE);
+			mutex_unlock(&adapter->vc_msg_lock);
+		}
+	} else {
+		err = iecm_send_mb_msg(adapter, VIRTCHNL_OP_CONFIG_RSS_KEY,
+				       buf_size, (u8 *)rk);
+		if (!err)
+			err = iecm_wait_for_event(adapter,
+						  IECM_VC_CONFIG_RSS_KEY,
+						  IECM_VC_CONFIG_RSS_KEY_ERR);
+	}
+mem_alloc_err:
+get_key_err:
+	kfree(rk);
+error:
+	return err;
 }
 
 /**
@@ -773,7 +1642,24 @@ iecm_send_get_set_rss_key_msg(struct iecm_vport *vport, bool get)
  */
 enum iecm_status iecm_send_get_rx_ptype_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_rx_ptype_decoded *rx_ptype_lkup = vport->rx_ptype_lkup;
+	int ptype_list[IECM_RX_SUPP_PTYPE] = { 0, 1, 11, 12, 22, 23, 24, 25, 26,
+					      27, 28, 88, 89, 90, 91, 92, 93,
+					      94 };
+	enum iecm_status err = 0;
+	int i;
+
+	for (i = 0; i < IECM_RX_MAX_PTYPE; i++)
+		rx_ptype_lkup[i] = iecm_rx_ptype_lkup[0];
+
+	for (i = 0; i < IECM_RX_SUPP_PTYPE; i++) {
+		int j = ptype_list[i];
+
+		rx_ptype_lkup[j] = iecm_rx_ptype_lkup[i];
+		rx_ptype_lkup[j].ptype = ptype_list[i];
+	};
+
+	return err;
 }
 
 /**
@@ -912,7 +1798,54 @@ void iecm_vport_params_buf_rel(struct iecm_adapter *adapter)
  */
 int iecm_vc_core_init(struct iecm_adapter *adapter, int *vport_id)
 {
-	/* stub */
+	switch (adapter->state) {
+	case __IECM_STARTUP:
+		if (iecm_send_ver_msg(adapter))
+			goto init_failed;
+		adapter->state = __IECM_VER_CHECK;
+		goto restart;
+	case __IECM_VER_CHECK:
+		if (iecm_recv_ver_msg(adapter))
+			goto init_failed;
+		adapter->state = __IECM_GET_CAPS;
+		if (adapter->dev_ops.vc_ops.get_caps(adapter))
+			goto init_failed;
+		goto restart;
+	case __IECM_GET_CAPS:
+		if (iecm_recv_get_caps_msg(adapter))
+			goto init_failed;
+		if (iecm_send_create_vport_msg(adapter))
+			goto init_failed;
+		adapter->state = __IECM_GET_DFLT_VPORT_PARAMS;
+		goto restart;
+	case __IECM_GET_DFLT_VPORT_PARAMS:
+		if (iecm_recv_create_vport_msg(adapter, vport_id))
+			goto init_failed;
+		adapter->state = __IECM_INIT_SW;
+		break;
+	case __IECM_INIT_SW:
+		break;
+	default:
+		dev_err(&adapter->pdev->dev, "Device is in bad state: %d\n",
+			adapter->state);
+		goto init_failed;
+	}
+
+	return 0;
+
+restart:
+	queue_delayed_work(adapter->init_wq, &adapter->init_task,
+			   msecs_to_jiffies(30));
+	/* Not an error. Using try again to continue with state machine */
+	return -EAGAIN;
+init_failed:
+	if (++adapter->mb_wait_count > IECM_MB_MAX_ERR) {
+		dev_err(&adapter->pdev->dev, "Failed to establish mailbox communications with hardware\n");
+		return -EFAULT;
+	}
+	adapter->state = __IECM_STARTUP;
+	queue_delayed_work(adapter->init_wq, &adapter->init_task, HZ);
+	return -EAGAIN;
 }
 EXPORT_SYMBOL(iecm_vc_core_init);
 
@@ -959,7 +1892,32 @@ iecm_vport_get_queue_ids(u16 *qids, int num_qids,
 			 enum virtchnl_queue_type q_type,
 			 struct virtchnl_queue_chunks *chunks)
 {
-	/* stub */
+	int num_chunks = chunks->num_chunks;
+	struct virtchnl_queue_chunk *chunk;
+	int num_q_id_filled = 0;
+	int start_q_id;
+	int num_q;
+	int i;
+
+	while (num_chunks) {
+		chunk = &chunks->chunks[num_chunks - 1];
+		if (chunk->type == q_type) {
+			num_q = chunk->num_queues;
+			start_q_id = chunk->start_queue_id;
+			for (i = 0; i < num_q; i++) {
+				if ((num_q_id_filled + i) < num_qids) {
+					qids[num_q_id_filled + i] = start_q_id;
+					start_q_id++;
+				} else {
+					break;
+				}
+			}
+			num_q_id_filled = num_q_id_filled + i;
+		}
+		num_chunks--;
+	}
+
+	return num_q_id_filled;
 }
 
 /**
@@ -976,7 +1934,80 @@ static int
 __iecm_vport_queue_ids_init(struct iecm_vport *vport, u16 *qids,
 			    int num_qids, enum virtchnl_queue_type q_type)
 {
-	/* stub */
+	struct iecm_queue *q;
+	int i, j, k = 0;
+
+	switch (q_type) {
+	case VIRTCHNL_QUEUE_TYPE_TX:
+		for (i = 0; i < vport->num_txq_grp; i++) {
+			struct iecm_txq_group *tx_qgrp = &vport->txq_grps[i];
+
+			for (j = 0; j < tx_qgrp->num_txq; j++) {
+				if (k < num_qids) {
+					tx_qgrp->txqs[j].q_id = qids[k];
+					tx_qgrp->txqs[j].q_type =
+						VIRTCHNL_QUEUE_TYPE_TX;
+					k++;
+				} else {
+					break;
+				}
+			}
+		}
+		break;
+	case VIRTCHNL_QUEUE_TYPE_RX:
+		for (i = 0; i < vport->num_rxq_grp; i++) {
+			struct iecm_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+			int num_rxq;
+
+			if (iecm_is_queue_model_split(vport->rxq_model))
+				num_rxq = rx_qgrp->splitq.num_rxq_sets;
+			else
+				num_rxq = rx_qgrp->singleq.num_rxq;
+
+			for (j = 0; j < num_rxq && k < num_qids; j++, k++) {
+				if (iecm_is_queue_model_split(vport->rxq_model))
+					q = &rx_qgrp->splitq.rxq_sets[j].rxq;
+				else
+					q = &rx_qgrp->singleq.rxqs[j];
+				q->q_id = qids[k];
+				q->q_type = VIRTCHNL_QUEUE_TYPE_RX;
+			}
+		}
+		break;
+	case VIRTCHNL_QUEUE_TYPE_TX_COMPLETION:
+		for (i = 0; i < vport->num_txq_grp; i++) {
+			struct iecm_txq_group *tx_qgrp = &vport->txq_grps[i];
+
+			if (k < num_qids) {
+				tx_qgrp->complq->q_id = qids[k];
+				tx_qgrp->complq->q_type =
+					VIRTCHNL_QUEUE_TYPE_TX_COMPLETION;
+				k++;
+			} else {
+				break;
+			}
+		}
+		break;
+	case VIRTCHNL_QUEUE_TYPE_RX_BUFFER:
+		for (i = 0; i < vport->num_rxq_grp; i++) {
+			struct iecm_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+
+			for (j = 0; j < IECM_BUFQS_PER_RXQ_SET; j++) {
+				if (k < num_qids) {
+					q = &rx_qgrp->splitq.bufq_sets[j].bufq;
+					q->q_id = qids[k];
+					q->q_type =
+						VIRTCHNL_QUEUE_TYPE_RX_BUFFER;
+					k++;
+				} else {
+					break;
+				}
+			}
+		}
+		break;
+	}
+
+	return k;
 }
 
 /**
@@ -989,7 +2020,76 @@ __iecm_vport_queue_ids_init(struct iecm_vport *vport, u16 *qids,
 static
 enum iecm_status iecm_vport_queue_ids_init(struct iecm_vport *vport)
 {
-	/* stub */
+	struct virtchnl_create_vport *vport_params;
+	struct virtchnl_queue_chunks *chunks;
+	enum virtchnl_queue_type q_type;
+	/* We may never deal with more that 256 same type of queues */
+#define IECM_MAX_QIDS	256
+	u16 qids[IECM_MAX_QIDS];
+	int num_ids;
+
+	if (vport->adapter->config_data.num_req_qs) {
+		struct virtchnl_add_queues *vc_aq =
+			(struct virtchnl_add_queues *)
+			vport->adapter->config_data.req_qs_chunks;
+		chunks = &vc_aq->chunks;
+	} else {
+		vport_params = (struct virtchnl_create_vport *)
+				vport->adapter->vport_params_recvd[0];
+		chunks = &vport_params->chunks;
+		/* compare vport_params num queues with vport num queues */
+		if (vport_params->num_tx_q != vport->num_txq ||
+		    vport_params->num_rx_q != vport->num_rxq ||
+		    vport_params->num_tx_complq != vport->num_complq ||
+		    vport_params->num_rx_bufq != vport->num_bufq)
+			return IECM_ERR_CFG;
+	}
+
+	num_ids = iecm_vport_get_queue_ids(qids, IECM_MAX_QIDS,
+					   VIRTCHNL_QUEUE_TYPE_TX,
+					   chunks);
+	if (num_ids != vport->num_txq)
+		return IECM_ERR_CFG;
+	num_ids = __iecm_vport_queue_ids_init(vport, qids, num_ids,
+					      VIRTCHNL_QUEUE_TYPE_TX);
+	if (num_ids != vport->num_txq)
+		return IECM_ERR_CFG;
+	num_ids = iecm_vport_get_queue_ids(qids, IECM_MAX_QIDS,
+					   VIRTCHNL_QUEUE_TYPE_RX,
+					   chunks);
+	if (num_ids != vport->num_rxq)
+		return IECM_ERR_CFG;
+	num_ids = __iecm_vport_queue_ids_init(vport, qids, num_ids,
+					      VIRTCHNL_QUEUE_TYPE_RX);
+	if (num_ids != vport->num_rxq)
+		return IECM_ERR_CFG;
+
+	if (iecm_is_queue_model_split(vport->txq_model)) {
+		q_type = VIRTCHNL_QUEUE_TYPE_TX_COMPLETION;
+		num_ids = iecm_vport_get_queue_ids(qids, IECM_MAX_QIDS, q_type,
+						   chunks);
+		if (num_ids != vport->num_complq)
+			return IECM_ERR_CFG;
+		num_ids = __iecm_vport_queue_ids_init(vport, qids,
+						      num_ids,
+						      q_type);
+		if (num_ids != vport->num_complq)
+			return IECM_ERR_CFG;
+	}
+
+	if (iecm_is_queue_model_split(vport->rxq_model)) {
+		q_type = VIRTCHNL_QUEUE_TYPE_RX_BUFFER;
+		num_ids = iecm_vport_get_queue_ids(qids, IECM_MAX_QIDS, q_type,
+						   chunks);
+		if (num_ids != vport->num_bufq)
+			return IECM_ERR_CFG;
+		num_ids = __iecm_vport_queue_ids_init(vport, qids, num_ids,
+						      q_type);
+		if (num_ids != vport->num_bufq)
+			return IECM_ERR_CFG;
+	}
+
+	return 0;
 }
 
 /**
@@ -1000,7 +2100,23 @@ enum iecm_status iecm_vport_queue_ids_init(struct iecm_vport *vport)
  */
 enum iecm_status iecm_vport_adjust_qs(struct iecm_vport *vport)
 {
-	/* stub */
+	struct virtchnl_create_vport vport_msg;
+	enum iecm_status err;
+
+	vport_msg.txq_model = vport->txq_model;
+	vport_msg.rxq_model = vport->rxq_model;
+	iecm_vport_calc_total_qs(&vport_msg,
+				 vport->adapter->config_data.num_req_qs);
+	err = iecm_send_add_queues_msg(vport, vport_msg.num_tx_q,
+				       vport_msg.num_tx_complq,
+				       vport_msg.num_rx_q,
+				       vport_msg.num_rx_bufq);
+	if (err)
+		goto failure;
+	iecm_vport_init_num_qs(vport, &vport_msg);
+	iecm_vport_calc_num_q_groups(vport);
+failure:
+	return err;
 }
 
 /**
@@ -1012,7 +2128,8 @@ enum iecm_status iecm_vport_adjust_qs(struct iecm_vport *vport)
  */
 static bool iecm_is_capability_ena(struct iecm_adapter *adapter, u64 flag)
 {
-	/* stub */
+	return ((struct virtchnl_get_capabilities *)adapter->caps)->cap_flags &
+	       flag;
 }
 
 /**
-- 
2.26.2

