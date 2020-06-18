Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79EB1FEABA
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgFRFOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:14:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:25340 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbgFRFOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:14:02 -0400
IronPort-SDR: Oj3WhqSQtaZbAlOkkW3qe9yXtn8YswKMC8quT8i96+dhcH9s3UpR4sAvM8BuALTQq2/G+4hE5G
 ycg6aNLX6gFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="142378054"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="142378054"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:51 -0700
IronPort-SDR: vbuyyBOjtkg9NXJ2gILq8QL3eoIZWSGnGYJUUYhp0gWfEmROamQGlM/HjibYlEod7LQtNEYRgM
 xoO9dxhoi6QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495600"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:51 -0700
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
Subject: [net-next 08/15] iecm: Implement vector allocation
Date:   Wed, 17 Jun 2020 22:13:37 -0700
Message-Id: <20200618051344.516587-9-jeffrey.t.kirsher@intel.com>
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

This allocates PCI vectors and maps to interrupt
routines.

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
 drivers/net/ethernet/intel/iecm/iecm_lib.c    |  63 +-
 drivers/net/ethernet/intel/iecm/iecm_txrx.c   | 606 +++++++++++++++++-
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   |  24 +-
 3 files changed, 669 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c b/drivers/net/ethernet/intel/iecm/iecm_lib.c
index 3f6878704b3e..a4fd04fd0500 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_lib.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_lib.c
@@ -15,7 +15,11 @@ extern int debug;
  */
 static void iecm_mb_intr_rel_irq(struct iecm_adapter *adapter)
 {
-	/* stub */
+	int irq_num;
+
+	irq_num = adapter->msix_entries[0].vector;
+	synchronize_irq(irq_num);
+	free_irq(irq_num, adapter);
 }
 
 /**
@@ -44,7 +48,12 @@ static void iecm_intr_rel(struct iecm_adapter *adapter)
  */
 irqreturn_t iecm_mb_intr_clean(int __always_unused irq, void *data)
 {
-	/* stub */
+	struct iecm_adapter *adapter = (struct iecm_adapter *)data;
+
+	set_bit(__IECM_MB_INTR_TRIGGER, adapter->flags);
+	queue_delayed_work(adapter->serv_wq, &adapter->serv_task,
+			   msecs_to_jiffies(0));
+	return IRQ_HANDLED;
 }
 
 /**
@@ -53,7 +62,12 @@ irqreturn_t iecm_mb_intr_clean(int __always_unused irq, void *data)
  */
 void iecm_mb_irq_enable(struct iecm_adapter *adapter)
 {
-	/* stub */
+	struct iecm_hw *hw = &adapter->hw;
+	struct iecm_intr_reg *intr = &adapter->mb_vector.intr_reg;
+	u32 val;
+
+	val = intr->dyn_ctl_intena_m | intr->dyn_ctl_itridx_m;
+	writel_relaxed(val, (u8 *)(hw->hw_addr + intr->dyn_ctl));
 }
 
 /**
@@ -62,7 +76,22 @@ void iecm_mb_irq_enable(struct iecm_adapter *adapter)
  */
 int iecm_mb_intr_req_irq(struct iecm_adapter *adapter)
 {
-	/* stub */
+	struct iecm_q_vector *mb_vector = &adapter->mb_vector;
+	int irq_num, mb_vidx = 0, err;
+
+	irq_num = adapter->msix_entries[mb_vidx].vector;
+	snprintf(mb_vector->name, sizeof(mb_vector->name) - 1,
+		 "%s-%s-%d", dev_driver_string(&adapter->pdev->dev),
+		 "Mailbox", mb_vidx);
+	err = request_irq(irq_num, adapter->irq_mb_handler, 0,
+			  mb_vector->name, adapter);
+	if (err) {
+		dev_err(&adapter->pdev->dev,
+			"Request_irq for mailbox failed, error: %d\n", err);
+		return err;
+	}
+	set_bit(__IECM_MB_INTR_MODE, adapter->flags);
+	return 0;
 }
 
 /**
@@ -74,7 +103,16 @@ int iecm_mb_intr_req_irq(struct iecm_adapter *adapter)
  */
 void iecm_get_mb_vec_id(struct iecm_adapter *adapter)
 {
-	/* stub */
+	struct virtchnl_vector_chunks *vchunks;
+	struct virtchnl_vector_chunk *chunk;
+
+	if (adapter->req_vec_chunks) {
+		vchunks = &adapter->req_vec_chunks->vchunks;
+		chunk = &vchunks->num_vchunk[0];
+		adapter->mb_vector.v_idx = chunk->start_vector_id;
+	} else {
+		adapter->mb_vector.v_idx = 0;
+	}
 }
 
 /**
@@ -83,7 +121,13 @@ void iecm_get_mb_vec_id(struct iecm_adapter *adapter)
  */
 int iecm_mb_intr_init(struct iecm_adapter *adapter)
 {
-	/* stub */
+	int err = 0;
+
+	iecm_get_mb_vec_id(adapter);
+	adapter->dev_ops.reg_ops.mb_intr_reg_init(adapter);
+	adapter->irq_mb_handler = iecm_mb_intr_clean;
+	err = iecm_mb_intr_req_irq(adapter);
+	return err;
 }
 
 /**
@@ -95,7 +139,12 @@ int iecm_mb_intr_init(struct iecm_adapter *adapter)
  */
 void iecm_intr_distribute(struct iecm_adapter *adapter)
 {
-	/* stub */
+	struct iecm_vport *vport;
+
+	vport = adapter->vports[0];
+	if (adapter->num_msix_entries != adapter->num_req_msix)
+		vport->num_q_vectors = adapter->num_msix_entries -
+				       IECM_MAX_NONQ_VEC - IECM_MIN_RDMA_VEC;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iecm/iecm_txrx.c b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
index 0d684adc15e5..da3065a87c2c 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_txrx.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
@@ -1002,7 +1002,16 @@ iecm_vport_intr_clean_queues(int __always_unused irq, void *data)
  */
 static void iecm_vport_intr_napi_dis_all(struct iecm_vport *vport)
 {
-	/* stub */
+	int q_idx;
+
+	if (!vport->netdev)
+		return;
+
+	for (q_idx = 0; q_idx < vport->num_q_vectors; q_idx++) {
+		struct iecm_q_vector *q_vector = &vport->q_vectors[q_idx];
+
+		napi_disable(&q_vector->napi);
+	}
 }
 
 /**
@@ -1013,7 +1022,44 @@ static void iecm_vport_intr_napi_dis_all(struct iecm_vport *vport)
  */
 static void iecm_vport_intr_rel(struct iecm_vport *vport)
 {
-	/* stub */
+	int i, j, v_idx;
+
+	if (!vport->netdev)
+		return;
+
+	for (v_idx = 0; v_idx < vport->num_q_vectors; v_idx++) {
+		struct iecm_q_vector *q_vector = &vport->q_vectors[v_idx];
+
+		if (q_vector)
+			netif_napi_del(&q_vector->napi);
+	}
+
+	/* Clean up the mapping of queues to vectors */
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct iecm_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+
+		if (iecm_is_queue_model_split(vport->rxq_model)) {
+			for (j = 0; j < rx_qgrp->splitq.num_rxq_sets; j++)
+				rx_qgrp->splitq.rxq_sets[j].rxq.q_vector =
+									   NULL;
+		} else {
+			for (j = 0; j < rx_qgrp->singleq.num_rxq; j++)
+				rx_qgrp->singleq.rxqs[j].q_vector = NULL;
+		}
+	}
+
+	if (iecm_is_queue_model_split(vport->txq_model)) {
+		for (i = 0; i < vport->num_txq_grp; i++)
+			vport->txq_grps[i].complq->q_vector = NULL;
+	} else {
+		for (i = 0; i < vport->num_txq_grp; i++) {
+			for (j = 0; j < vport->txq_grps[i].num_txq; j++)
+				vport->txq_grps[i].txqs[j].q_vector = NULL;
+		}
+	}
+
+	kfree(vport->q_vectors);
+	vport->q_vectors = NULL;
 }
 
 /**
@@ -1022,7 +1068,25 @@ static void iecm_vport_intr_rel(struct iecm_vport *vport)
  */
 static void iecm_vport_intr_rel_irq(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	int vector;
+
+	for (vector = 0; vector < vport->num_q_vectors; vector++) {
+		struct iecm_q_vector *q_vector = &vport->q_vectors[vector];
+		int irq_num, vidx;
+
+		/* free only the IRQs that were actually requested */
+		if (!q_vector)
+			continue;
+
+		vidx = vector + vport->q_vector_base;
+		irq_num = adapter->msix_entries[vidx].vector;
+
+		/* clear the affinity_mask in the IRQ descriptor */
+		irq_set_affinity_hint(irq_num, NULL);
+		synchronize_irq(irq_num);
+		free_irq(irq_num, q_vector);
+	}
 }
 
 /**
@@ -1031,7 +1095,13 @@ static void iecm_vport_intr_rel_irq(struct iecm_vport *vport)
  */
 void iecm_vport_intr_dis_irq_all(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_q_vector *q_vector = vport->q_vectors;
+	struct iecm_hw *hw = &vport->adapter->hw;
+	int q_idx;
+
+	for (q_idx = 0; q_idx < vport->num_q_vectors; q_idx++)
+		writel_relaxed(0, (u8 *)(hw->hw_addr +
+					 q_vector[q_idx].intr_reg.dyn_ctl));
 }
 
 /**
@@ -1043,12 +1113,42 @@ void iecm_vport_intr_dis_irq_all(struct iecm_vport *vport)
 static u32 iecm_vport_intr_buildreg_itr(struct iecm_q_vector *q_vector,
 					const int type, u16 itr)
 {
-	/* stub */
+	u32 itr_val;
+
+	itr &= IECM_ITR_MASK;
+	/* Don't clear PBA because that can cause lost interrupts that
+	 * came in while we were cleaning/polling
+	 */
+	itr_val = q_vector->intr_reg.dyn_ctl_intena_m |
+		  (type << q_vector->intr_reg.dyn_ctl_itridx_s) |
+		  (itr << (q_vector->intr_reg.dyn_ctl_intrvl_s - 1));
+
+	return itr_val;
 }
 
 static inline unsigned int iecm_itr_divisor(struct iecm_q_vector *q_vector)
 {
-	/* stub */
+	unsigned int divisor;
+
+	switch (q_vector->vport->adapter->link_speed) {
+	case VIRTCHNL_LINK_SPEED_40GB:
+		divisor = IECM_ITR_ADAPTIVE_MIN_INC * 1024;
+		break;
+	case VIRTCHNL_LINK_SPEED_25GB:
+	case VIRTCHNL_LINK_SPEED_20GB:
+		divisor = IECM_ITR_ADAPTIVE_MIN_INC * 512;
+		break;
+	default:
+	case VIRTCHNL_LINK_SPEED_10GB:
+		divisor = IECM_ITR_ADAPTIVE_MIN_INC * 256;
+		break;
+	case VIRTCHNL_LINK_SPEED_1GB:
+	case VIRTCHNL_LINK_SPEED_100MB:
+		divisor = IECM_ITR_ADAPTIVE_MIN_INC * 32;
+		break;
+	}
+
+	return divisor;
 }
 
 /**
@@ -1069,7 +1169,206 @@ static void iecm_vport_intr_set_new_itr(struct iecm_q_vector *q_vector,
 					struct iecm_itr *itr,
 					enum virtchnl_queue_type q_type)
 {
-	/* stub */
+	unsigned int avg_wire_size, packets = 0, bytes = 0, new_itr;
+	unsigned long next_update = jiffies;
+
+	/* If we don't have any queues just leave ourselves set for maximum
+	 * possible latency so we take ourselves out of the equation.
+	 */
+	if (!IECM_ITR_IS_DYNAMIC(itr->target_itr))
+		return;
+
+	/* For Rx we want to push the delay up and default to low latency.
+	 * for Tx we want to pull the delay down and default to high latency.
+	 */
+	new_itr = q_type == VIRTCHNL_QUEUE_TYPE_RX ?
+	      IECM_ITR_ADAPTIVE_MIN_USECS | IECM_ITR_ADAPTIVE_LATENCY :
+	      IECM_ITR_ADAPTIVE_MAX_USECS | IECM_ITR_ADAPTIVE_LATENCY;
+
+	/* If we didn't update within up to 1 - 2 jiffies we can assume
+	 * that either packets are coming in so slow there hasn't been
+	 * any work, or that there is so much work that NAPI is dealing
+	 * with interrupt moderation and we don't need to do anything.
+	 */
+	if (time_after(next_update, itr->next_update))
+		goto clear_counts;
+
+	/* If itr_countdown is set it means we programmed an ITR within
+	 * the last 4 interrupt cycles. This has a side effect of us
+	 * potentially firing an early interrupt. In order to work around
+	 * this we need to throw out any data received for a few
+	 * interrupts following the update.
+	 */
+	if (q_vector->itr_countdown) {
+		new_itr = itr->target_itr;
+		goto clear_counts;
+	}
+
+	if (q_type == VIRTCHNL_QUEUE_TYPE_TX) {
+		packets = itr->stats.tx.packets;
+		bytes = itr->stats.tx.bytes;
+	}
+
+	if (q_type == VIRTCHNL_QUEUE_TYPE_RX) {
+		packets = itr->stats.rx.packets;
+		bytes = itr->stats.rx.bytes;
+
+		/* If there are 1 to 4 RX packets and bytes are less than
+		 * 9000 assume insufficient data to use bulk rate limiting
+		 * approach unless Tx is already in bulk rate limiting. We
+		 * are likely latency driven.
+		 */
+		if (packets && packets < 4 && bytes < 9000 &&
+		    (q_vector->tx[0]->itr.target_itr &
+		     IECM_ITR_ADAPTIVE_LATENCY)) {
+			new_itr = IECM_ITR_ADAPTIVE_LATENCY;
+			goto adjust_by_size;
+		}
+	} else if (packets < 4) {
+		/* If we have Tx and Rx ITR maxed and Tx ITR is running in
+		 * bulk mode and we are receiving 4 or fewer packets just
+		 * reset the ITR_ADAPTIVE_LATENCY bit for latency mode so
+		 * that the Rx can relax.
+		 */
+		if (itr->target_itr == IECM_ITR_ADAPTIVE_MAX_USECS &&
+		    ((q_vector->rx[0]->itr.target_itr & IECM_ITR_MASK) ==
+		     IECM_ITR_ADAPTIVE_MAX_USECS))
+			goto clear_counts;
+	} else if (packets > 32) {
+		/* If we have processed over 32 packets in a single interrupt
+		 * for Tx assume we need to switch over to "bulk" mode.
+		 */
+		itr->target_itr &= ~IECM_ITR_ADAPTIVE_LATENCY;
+	}
+
+	/* We have no packets to actually measure against. This means
+	 * either one of the other queues on this vector is active or
+	 * we are a Tx queue doing TSO with too high of an interrupt rate.
+	 *
+	 * Between 4 and 56 we can assume that our current interrupt delay
+	 * is only slightly too low. As such we should increase it by a small
+	 * fixed amount.
+	 */
+	if (packets < 56) {
+		new_itr = itr->target_itr + IECM_ITR_ADAPTIVE_MIN_INC;
+		if ((new_itr & IECM_ITR_MASK) > IECM_ITR_ADAPTIVE_MAX_USECS) {
+			new_itr &= IECM_ITR_ADAPTIVE_LATENCY;
+			new_itr += IECM_ITR_ADAPTIVE_MAX_USECS;
+		}
+		goto clear_counts;
+	}
+
+	if (packets <= 256) {
+		new_itr = min(q_vector->tx[0]->itr.current_itr,
+			      q_vector->rx[0]->itr.current_itr);
+		new_itr &= IECM_ITR_MASK;
+
+		/* Between 56 and 112 is our "goldilocks" zone where we are
+		 * working out "just right". Just report that our current
+		 * ITR is good for us.
+		 */
+		if (packets <= 112)
+			goto clear_counts;
+
+		/* If packet count is 128 or greater we are likely looking
+		 * at a slight overrun of the delay we want. Try halving
+		 * our delay to see if that will cut the number of packets
+		 * in half per interrupt.
+		 */
+		new_itr /= 2;
+		new_itr &= IECM_ITR_MASK;
+		if (new_itr < IECM_ITR_ADAPTIVE_MIN_USECS)
+			new_itr = IECM_ITR_ADAPTIVE_MIN_USECS;
+
+		goto clear_counts;
+	}
+
+	/* The paths below assume we are dealing with a bulk ITR since
+	 * number of packets is greater than 256. We are just going to have
+	 * to compute a value and try to bring the count under control,
+	 * though for smaller packet sizes there isn't much we can do as
+	 * NAPI polling will likely be kicking in sooner rather than later.
+	 */
+	new_itr = IECM_ITR_ADAPTIVE_BULK;
+
+adjust_by_size:
+	/* If packet counts are 256 or greater we can assume we have a gross
+	 * overestimation of what the rate should be. Instead of trying to fine
+	 * tune it just use the formula below to try and dial in an exact value
+	 * give the current packet size of the frame.
+	 */
+	avg_wire_size = bytes / packets;
+
+	/* The following is a crude approximation of:
+	 *  wmem_default / (size + overhead) = desired_pkts_per_int
+	 *  rate / bits_per_byte / (size + Ethernet overhead) = pkt_rate
+	 *  (desired_pkt_rate / pkt_rate) * usecs_per_sec = ITR value
+	 *
+	 * Assuming wmem_default is 212992 and overhead is 640 bytes per
+	 * packet, (256 skb, 64 headroom, 320 shared info), we can reduce the
+	 * formula down to
+	 *
+	 *  (170 * (size + 24)) / (size + 640) = ITR
+	 *
+	 * We first do some math on the packet size and then finally bit shift
+	 * by 8 after rounding up. We also have to account for PCIe link speed
+	 * difference as ITR scales based on this.
+	 */
+	if (avg_wire_size <= 60) {
+		/* Start at 250k ints/sec */
+		avg_wire_size = 4096;
+	} else if (avg_wire_size <= 380) {
+		/* 250K ints/sec to 60K ints/sec */
+		avg_wire_size *= 40;
+		avg_wire_size += 1696;
+	} else if (avg_wire_size <= 1084) {
+		/* 60K ints/sec to 36K ints/sec */
+		avg_wire_size *= 15;
+		avg_wire_size += 11452;
+	} else if (avg_wire_size <= 1980) {
+		/* 36K ints/sec to 30K ints/sec */
+		avg_wire_size *= 5;
+		avg_wire_size += 22420;
+	} else {
+		/* plateau at a limit of 30K ints/sec */
+		avg_wire_size = 32256;
+	}
+
+	/* If we are in low latency mode halve our delay which doubles the
+	 * rate to somewhere between 100K to 16K ints/sec
+	 */
+	if (new_itr & IECM_ITR_ADAPTIVE_LATENCY)
+		avg_wire_size /= 2;
+
+	/* Resultant value is 256 times larger than it needs to be. This
+	 * gives us room to adjust the value as needed to either increase
+	 * or decrease the value based on link speeds of 10G, 2.5G, 1G, etc.
+	 *
+	 * Use addition as we have already recorded the new latency flag
+	 * for the ITR value.
+	 */
+	new_itr += DIV_ROUND_UP(avg_wire_size, iecm_itr_divisor(q_vector)) *
+		   IECM_ITR_ADAPTIVE_MIN_INC;
+
+	if ((new_itr & IECM_ITR_MASK) > IECM_ITR_ADAPTIVE_MAX_USECS) {
+		new_itr &= IECM_ITR_ADAPTIVE_LATENCY;
+		new_itr += IECM_ITR_ADAPTIVE_MAX_USECS;
+	}
+
+clear_counts:
+	/* write back value */
+	itr->target_itr = new_itr;
+
+	/* next update should occur within next jiffy */
+	itr->next_update = next_update + 1;
+
+	if (q_type == VIRTCHNL_QUEUE_TYPE_RX) {
+		itr->stats.rx.bytes = 0;
+		itr->stats.rx.packets = 0;
+	} else if (q_type == VIRTCHNL_QUEUE_TYPE_TX) {
+		itr->stats.tx.bytes = 0;
+		itr->stats.tx.packets = 0;
+	}
 }
 
 /**
@@ -1078,7 +1377,59 @@ static void iecm_vport_intr_set_new_itr(struct iecm_q_vector *q_vector,
  */
 void iecm_vport_intr_update_itr_ena_irq(struct iecm_q_vector *q_vector)
 {
-	/* stub */
+	struct iecm_hw *hw = &q_vector->vport->adapter->hw;
+	struct iecm_itr *tx_itr = &q_vector->tx[0]->itr;
+	struct iecm_itr *rx_itr = &q_vector->rx[0]->itr;
+	u32 intval;
+
+	/* These will do nothing if dynamic updates are not enabled */
+	iecm_vport_intr_set_new_itr(q_vector, tx_itr, q_vector->tx[0]->q_type);
+	iecm_vport_intr_set_new_itr(q_vector, rx_itr, q_vector->rx[0]->q_type);
+
+	/* This block of logic allows us to get away with only updating
+	 * one ITR value with each interrupt. The idea is to perform a
+	 * pseudo-lazy update with the following criteria.
+	 *
+	 * 1. Rx is given higher priority than Tx if both are in same state
+	 * 2. If we must reduce an ITR that is given highest priority.
+	 * 3. We then give priority to increasing ITR based on amount.
+	 */
+	if (rx_itr->target_itr < rx_itr->current_itr) {
+		/* Rx ITR needs to be reduced, this is highest priority */
+		intval = iecm_vport_intr_buildreg_itr(q_vector,
+						      rx_itr->itr_idx,
+						      rx_itr->target_itr);
+		rx_itr->current_itr = rx_itr->target_itr;
+		q_vector->itr_countdown = ITR_COUNTDOWN_START;
+	} else if ((tx_itr->target_itr < tx_itr->current_itr) ||
+		   ((rx_itr->target_itr - rx_itr->current_itr) <
+		    (tx_itr->target_itr - tx_itr->current_itr))) {
+		/* Tx ITR needs to be reduced, this is second priority
+		 * Tx ITR needs to be increased more than Rx, fourth priority
+		 */
+		intval = iecm_vport_intr_buildreg_itr(q_vector,
+						      tx_itr->itr_idx,
+						      tx_itr->target_itr);
+		tx_itr->current_itr = tx_itr->target_itr;
+		q_vector->itr_countdown = ITR_COUNTDOWN_START;
+	} else if (rx_itr->current_itr != rx_itr->target_itr) {
+		/* Rx ITR needs to be increased, third priority */
+		intval = iecm_vport_intr_buildreg_itr(q_vector,
+						      rx_itr->itr_idx,
+						      rx_itr->target_itr);
+		rx_itr->current_itr = rx_itr->target_itr;
+		q_vector->itr_countdown = ITR_COUNTDOWN_START;
+	} else {
+		/* No ITR update, lowest priority */
+		intval = iecm_vport_intr_buildreg_itr(q_vector,
+						      VIRTCHNL_ITR_IDX_NO_ITR,
+						      0);
+		if (q_vector->itr_countdown)
+			q_vector->itr_countdown--;
+	}
+
+	writel_relaxed(intval, (u8 *)(hw->hw_addr +
+				      q_vector->intr_reg.dyn_ctl));
 }
 
 /**
@@ -1089,7 +1440,40 @@ void iecm_vport_intr_update_itr_ena_irq(struct iecm_q_vector *q_vector)
 static int
 iecm_vport_intr_req_irq(struct iecm_vport *vport, char *basename)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	int vector, err, irq_num, vidx;
+
+	for (vector = 0; vector < vport->num_q_vectors; vector++) {
+		struct iecm_q_vector *q_vector = &vport->q_vectors[vector];
+
+		vidx = vector + vport->q_vector_base;
+		irq_num = adapter->msix_entries[vidx].vector;
+
+		snprintf(q_vector->name, sizeof(q_vector->name) - 1,
+			 "%s-%s-%d", basename, "TxRx", vidx);
+
+		err = request_irq(irq_num, vport->irq_q_handler, 0,
+				  q_vector->name, q_vector);
+		if (err) {
+			netdev_err(vport->netdev,
+				   "Request_irq failed, error: %d\n", err);
+			goto free_q_irqs;
+		}
+		/* assign the mask for this IRQ */
+		irq_set_affinity_hint(irq_num, &q_vector->affinity_mask);
+	}
+
+	return 0;
+
+free_q_irqs:
+	while (vector) {
+		vector--;
+		vidx = vector + vport->q_vector_base;
+		irq_num = adapter->msix_entries[vidx].vector,
+		free_irq(irq_num,
+			 &vport->q_vectors[vector]);
+	}
+	return err;
 }
 
 /**
@@ -1098,7 +1482,14 @@ iecm_vport_intr_req_irq(struct iecm_vport *vport, char *basename)
  */
 void iecm_vport_intr_ena_irq_all(struct iecm_vport *vport)
 {
-	/* stub */
+	int q_idx;
+
+	for (q_idx = 0; q_idx < vport->num_q_vectors; q_idx++) {
+		struct iecm_q_vector *q_vector = &vport->q_vectors[q_idx];
+
+		if (q_vector->num_txq || q_vector->num_rxq)
+			iecm_vport_intr_update_itr_ena_irq(q_vector);
+	}
 }
 
 /**
@@ -1107,7 +1498,10 @@ void iecm_vport_intr_ena_irq_all(struct iecm_vport *vport)
  */
 void iecm_vport_intr_deinit(struct iecm_vport *vport)
 {
-	/* stub */
+	iecm_vport_intr_napi_dis_all(vport);
+	iecm_vport_intr_dis_irq_all(vport);
+	iecm_vport_intr_rel_irq(vport);
+	iecm_vport_intr_rel(vport);
 }
 
 /**
@@ -1117,7 +1511,16 @@ void iecm_vport_intr_deinit(struct iecm_vport *vport)
 static void
 iecm_vport_intr_napi_ena_all(struct iecm_vport *vport)
 {
-	/* stub */
+	int q_idx;
+
+	if (!vport->netdev)
+		return;
+
+	for (q_idx = 0; q_idx < vport->num_q_vectors; q_idx++) {
+		struct iecm_q_vector *q_vector = &vport->q_vectors[q_idx];
+
+		napi_enable(&q_vector->napi);
+	}
 }
 
 /**
@@ -1166,7 +1569,65 @@ int iecm_vport_splitq_napi_poll(struct napi_struct *napi, int budget)
  */
 void iecm_vport_intr_map_vector_to_qs(struct iecm_vport *vport)
 {
-	/* stub */
+	int i, j, k = 0, num_rxq, num_txq;
+	struct iecm_rxq_group *rx_qgrp;
+	struct iecm_txq_group *tx_qgrp;
+	struct iecm_queue *q;
+	int q_index;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		rx_qgrp = &vport->rxq_grps[i];
+		if (iecm_is_queue_model_split(vport->rxq_model))
+			num_rxq = rx_qgrp->splitq.num_rxq_sets;
+		else
+			num_rxq = rx_qgrp->singleq.num_rxq;
+
+		for (j = 0; j < num_rxq; j++) {
+			if (k >= vport->num_q_vectors)
+				k = k % vport->num_q_vectors;
+
+			if (iecm_is_queue_model_split(vport->rxq_model))
+				q = &rx_qgrp->splitq.rxq_sets[j].rxq;
+			else
+				q = &rx_qgrp->singleq.rxqs[j];
+			q->q_vector = &vport->q_vectors[k];
+			q_index = q->q_vector->num_rxq;
+			q->q_vector->rx[q_index] = q;
+			q->q_vector->num_rxq++;
+
+			k++;
+		}
+	}
+	k = 0;
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		tx_qgrp = &vport->txq_grps[i];
+		num_txq = tx_qgrp->num_txq;
+
+		if (iecm_is_queue_model_split(vport->txq_model)) {
+			if (k >= vport->num_q_vectors)
+				k = k % vport->num_q_vectors;
+
+			q = tx_qgrp->complq;
+			q->q_vector = &vport->q_vectors[k];
+			q_index = q->q_vector->num_txq;
+			q->q_vector->tx[q_index] = q;
+			q->q_vector->num_txq++;
+			k++;
+		} else {
+			for (j = 0; j < num_txq; j++) {
+				if (k >= vport->num_q_vectors)
+					k = k % vport->num_q_vectors;
+
+				q = &tx_qgrp->txqs[j];
+				q->q_vector = &vport->q_vectors[k];
+				q_index = q->q_vector->num_txq;
+				q->q_vector->tx[q_index] = q;
+				q->q_vector->num_txq++;
+
+				k++;
+			}
+		}
+	}
 }
 
 /**
@@ -1177,7 +1638,38 @@ void iecm_vport_intr_map_vector_to_qs(struct iecm_vport *vport)
  */
 static int iecm_vport_intr_init_vec_idx(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	struct iecm_q_vector *q_vector;
+	int i;
+
+	if (adapter->req_vec_chunks) {
+		struct virtchnl_vector_chunks *vchunks;
+		struct virtchnl_alloc_vectors *ac;
+		/* We may never deal with more that 256 same type of vectors */
+#define IECM_MAX_VECIDS	256
+		u16 vecids[IECM_MAX_VECIDS];
+		int num_ids;
+
+		ac = adapter->req_vec_chunks;
+		vchunks = &ac->vchunks;
+
+		num_ids = iecm_vport_get_vec_ids(vecids, IECM_MAX_VECIDS,
+						 vchunks);
+		if (num_ids != adapter->num_msix_entries)
+			return -EFAULT;
+
+		for (i = 0; i < vport->num_q_vectors; i++) {
+			q_vector = &vport->q_vectors[i];
+			q_vector->v_idx = vecids[i + vport->q_vector_base];
+		}
+	} else {
+		for (i = 0; i < vport->num_q_vectors; i++) {
+			q_vector = &vport->q_vectors[i];
+			q_vector->v_idx = i + vport->q_vector_base;
+		}
+	}
+
+	return 0;
 }
 
 /**
@@ -1189,7 +1681,65 @@ static int iecm_vport_intr_init_vec_idx(struct iecm_vport *vport)
  */
 int iecm_vport_intr_alloc(struct iecm_vport *vport)
 {
-	/* stub */
+	int txqs_per_vector, rxqs_per_vector;
+	struct iecm_q_vector *q_vector;
+	int v_idx, err = 0;
+
+	vport->q_vectors = kcalloc(vport->num_q_vectors,
+				   sizeof(struct iecm_q_vector), GFP_KERNEL);
+
+	if (!vport->q_vectors)
+		return -ENOMEM;
+
+	txqs_per_vector = DIV_ROUND_UP(vport->num_txq, vport->num_q_vectors);
+	rxqs_per_vector = DIV_ROUND_UP(vport->num_rxq, vport->num_q_vectors);
+
+	for (v_idx = 0; v_idx < vport->num_q_vectors; v_idx++) {
+		q_vector = &vport->q_vectors[v_idx];
+		q_vector->vport = vport;
+		q_vector->itr_countdown = ITR_COUNTDOWN_START;
+
+		q_vector->tx = kcalloc(txqs_per_vector,
+				       sizeof(struct iecm_queue *),
+				       GFP_KERNEL);
+		if (!q_vector->tx) {
+			err = -ENOMEM;
+			goto free_vport_q_vec;
+		}
+
+		q_vector->rx = kcalloc(rxqs_per_vector,
+				       sizeof(struct iecm_queue *),
+				       GFP_KERNEL);
+		if (!q_vector->rx) {
+			err = -ENOMEM;
+			goto free_vport_q_vec_tx;
+		}
+
+		/* only set affinity_mask if the CPU is online */
+		if (cpu_online(v_idx))
+			cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
+
+		/* Register the NAPI handler */
+		if (vport->netdev) {
+			if (iecm_is_queue_model_split(vport->txq_model))
+				netif_napi_add(vport->netdev, &q_vector->napi,
+					       iecm_vport_splitq_napi_poll,
+					       NAPI_POLL_WEIGHT);
+			else
+				netif_napi_add(vport->netdev, &q_vector->napi,
+					       iecm_vport_singleq_napi_poll,
+					       NAPI_POLL_WEIGHT);
+		}
+	}
+
+	err = iecm_vport_intr_init_vec_idx(vport);
+	goto handle_err;
+free_vport_q_vec_tx:
+	kfree(q_vector->tx);
+free_vport_q_vec:
+	kfree(vport->q_vectors);
+handle_err:
+	return err;
 }
 
 /**
@@ -1200,7 +1750,31 @@ int iecm_vport_intr_alloc(struct iecm_vport *vport)
  */
 int iecm_vport_intr_init(struct iecm_vport *vport)
 {
-	/* stub */
+	char int_name[IECM_INT_NAME_STR_LEN];
+	int err = 0;
+
+	if (iecm_vport_intr_alloc(vport))
+		return -ENOMEM;
+
+	iecm_vport_intr_map_vector_to_qs(vport);
+	iecm_vport_intr_napi_ena_all(vport);
+
+	vport->adapter->dev_ops.reg_ops.intr_reg_init(vport);
+
+	snprintf(int_name, sizeof(int_name) - 1, "%s-%s",
+		 dev_driver_string(&vport->adapter->pdev->dev),
+		 vport->netdev->name);
+
+	err = iecm_vport_intr_req_irq(vport, int_name);
+	if (err)
+		goto unroll_vectors_alloc;
+
+	iecm_vport_intr_ena_irq_all(vport);
+	goto handle_err;
+unroll_vectors_alloc:
+	iecm_vport_intr_rel(vport);
+handle_err:
+	return err;
 }
 EXPORT_SYMBOL(iecm_vport_calc_num_q_vec);
 
diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
index 57862fbfdb9b..b1775cc38924 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
@@ -1874,7 +1874,29 @@ int
 iecm_vport_get_vec_ids(u16 *vecids, int num_vecids,
 		       struct virtchnl_vector_chunks *chunks)
 {
-	/* stub */
+	int num_chunks = chunks->num_vector_chunks;
+	struct virtchnl_vector_chunk *chunk;
+	int num_vecid_filled = 0;
+	int start_vecid;
+	int num_vec;
+	int i, j;
+
+	for (j = 0; j < num_chunks; j++) {
+		chunk = &chunks->num_vchunk[j];
+		num_vec = chunk->num_vectors;
+		start_vecid = chunk->start_vector_id;
+		for (i = 0; i < num_vec; i++) {
+			if ((num_vecid_filled + i) < num_vecids) {
+				vecids[num_vecid_filled + i] = start_vecid;
+				start_vecid++;
+			} else {
+				break;
+			}
+		}
+		num_vecid_filled = num_vecid_filled + i;
+	}
+
+	return num_vecid_filled;
 }
 
 /**
-- 
2.26.2

