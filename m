Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31C113C87
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 03:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfEEBTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 21:19:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:33073 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbfEEBTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 21:19:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 18:14:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="297102562"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2019 18:14:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Martyna Szapar <martyna.szapar@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/12] i40e: missing input validation on VF message handling by the PF
Date:   Sat,  4 May 2019 18:14:05 -0700
Message-Id: <20190505011409.6771-9-jeffrey.t.kirsher@intel.com>
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

Patch is adding missing input validation on VF message handling
by the PF to the functions with opcodes:
	VIRTCHNL_OP_CONFIG_VSI_QUEUES = 6
	VIRTCHNL_OP_CONFIG_IRQ_MAP = 7,
	VIRTCHNL_OP_DISABLE_QUEUES = 9,
	VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE = 14,

Signed-off-by: Martyna Szapar <martyna.szapar@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 58 ++++++++++++++-----
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  2 +
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index d0e3677b7dc8..6a812eeaba8d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2014,6 +2014,16 @@ static int i40e_vc_config_promiscuous_mode_msg(struct i40e_vf *vf, u8 *msg)
 		goto err_out;
 	}
 
+	if (info->flags > I40E_MAX_VF_PROMISC_FLAGS) {
+		aq_ret = I40E_ERR_PARAM;
+		goto err_out;
+	}
+
+	if (!i40e_vc_isvalid_vsi_id(vf, info->vsi_id)) {
+		aq_ret = I40E_ERR_PARAM;
+		goto err_out;
+	}
+
 	/* Multicast promiscuous handling*/
 	if (info->flags & FLAG_VF_MULTICAST_PROMISC)
 		allmulti = true;
@@ -2068,17 +2078,16 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 	struct virtchnl_queue_pair_info *qpi;
 	struct i40e_pf *pf = vf->pf;
 	u16 vsi_id, vsi_queue_id = 0;
+	u16 num_qps_all = 0;
 	i40e_status aq_ret = 0;
 	int i, j = 0, idx = 0;
 
-	vsi_id = qci->vsi_id;
-
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
 
-	if (!i40e_vc_isvalid_vsi_id(vf, vsi_id)) {
+	if (!i40e_vc_isvalid_vsi_id(vf, qci->vsi_id)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2088,10 +2097,27 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
+	if (vf->adq_enabled) {
+		for (i = 0; i < I40E_MAX_VF_VSI; i++)
+			num_qps_all += vf->ch[i].num_qps;
+		if (num_qps_all != qci->num_queue_pairs) {
+			aq_ret = I40E_ERR_PARAM;
+			goto error_param;
+		}
+	}
+
+	vsi_id = qci->vsi_id;
+
 	for (i = 0; i < qci->num_queue_pairs; i++) {
 		qpi = &qci->qpair[i];
 
 		if (!vf->adq_enabled) {
+			if (!i40e_vc_isvalid_queue_id(vf, vsi_id,
+						      qpi->txq.queue_id)) {
+				aq_ret = I40E_ERR_PARAM;
+				goto error_param;
+			}
+
 			vsi_queue_id = qpi->txq.queue_id;
 
 			if (qpi->txq.vsi_id != qci->vsi_id ||
@@ -2102,10 +2128,8 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 			}
 		}
 
-		if (!i40e_vc_isvalid_queue_id(vf, vsi_id, vsi_queue_id)) {
-			aq_ret = I40E_ERR_PARAM;
-			goto error_param;
-		}
+		if (vf->adq_enabled)
+			vsi_id = vf->ch[idx].vsi_id;
 
 		if (i40e_config_vsi_rx_queue(vf, vsi_id, vsi_queue_id,
 					     &qpi->rxq) ||
@@ -2129,7 +2153,6 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 				j++;
 				vsi_queue_id++;
 			}
-			vsi_id = vf->ch[idx].vsi_id;
 		}
 	}
 	/* set vsi num_queue_pairs in use to num configured by VF */
@@ -2188,7 +2211,7 @@ static int i40e_vc_config_irq_map_msg(struct i40e_vf *vf, u8 *msg)
 	struct virtchnl_irq_map_info *irqmap_info =
 	    (struct virtchnl_irq_map_info *)msg;
 	struct virtchnl_vector_map *map;
-	u16 vsi_id, vector_id;
+	u16 vsi_id;
 	i40e_status aq_ret = 0;
 	int i;
 
@@ -2197,16 +2220,21 @@ static int i40e_vc_config_irq_map_msg(struct i40e_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
+	if (irqmap_info->num_vectors >
+	    vf->pf->hw.func_caps.num_msix_vectors_vf) {
+		aq_ret = I40E_ERR_PARAM;
+		goto error_param;
+	}
+
 	for (i = 0; i < irqmap_info->num_vectors; i++) {
 		map = &irqmap_info->vecmap[i];
-		vector_id = map->vector_id;
-		vsi_id = map->vsi_id;
 		/* validate msg params */
-		if (!i40e_vc_isvalid_vector_id(vf, vector_id) ||
-		    !i40e_vc_isvalid_vsi_id(vf, vsi_id)) {
+		if (!i40e_vc_isvalid_vector_id(vf, map->vector_id) ||
+		    !i40e_vc_isvalid_vsi_id(vf, map->vsi_id)) {
 			aq_ret = I40E_ERR_PARAM;
 			goto error_param;
 		}
+		vsi_id = map->vsi_id;
 
 		if (i40e_validate_queue_map(vf, vsi_id, map->rxq_map)) {
 			aq_ret = I40E_ERR_PARAM;
@@ -2354,7 +2382,9 @@ static int i40e_vc_disable_queues_msg(struct i40e_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if ((0 == vqs->rx_queues) && (0 == vqs->tx_queues)) {
+	if ((vqs->rx_queues == 0 && vqs->tx_queues == 0) ||
+	    vqs->rx_queues > I40E_MAX_VF_QUEUES ||
+	    vqs->tx_queues > I40E_MAX_VF_QUEUES) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index f9621026beef..f65cc0c16550 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -17,6 +17,8 @@
 #define I40E_VLAN_MASK			0xFFF
 #define I40E_PRIORITY_MASK		0xE000
 
+#define I40E_MAX_VF_PROMISC_FLAGS	3
+
 /* Various queue ctrls */
 enum i40e_queue_ctrl {
 	I40E_QUEUE_CTRL_UNKNOWN = 0,
-- 
2.20.1

