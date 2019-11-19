Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC5010257A
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfKSNfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:35:05 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:49337 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSNfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:35:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1574170502; x=1605706502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=+DoxksEFGBbcbOdL10O0v1NJnXSNaSBSSX61+gy8/F8=;
  b=npUKIRy77ofW/Tom2M2VaDy013vzg30TiUmMLwvKyMEqziK29TMkm436
   beCuyhOuZZXO0KZzmuPJlk97rI7lSW2zc+WJhAVrHPSzp8SpbIYGS+wJL
   JAuNq7dwMiDxQdje9HbM8u1P1dpgDllaUJdbN9WF4eEGxg+azEusp5NZO
   E=;
IronPort-SDR: vL4f68yUXQfbtbL74VgReeCLKGJtq+qXKa6gpR2HRK0f7PMSWU4HsjRmJ0r8ldeLwx86F+eXQj
 ZCT3JGzQlaIw==
X-IronPort-AV: E=Sophos;i="5.68,324,1569283200"; 
   d="scan'208";a="4720091"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 19 Nov 2019 13:35:01 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 3E11DA21FF;
        Tue, 19 Nov 2019 13:34:59 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 19 Nov 2019 13:34:39 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 19 Nov 2019 13:34:38 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 19 Nov 2019 13:34:36 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next v2 2/3] net: ena: Implement XDP_TX action
Date:   Tue, 19 Nov 2019 15:34:18 +0200
Message-ID: <20191119133419.9734-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119133419.9734-1-sameehj@amazon.com>
References: <20191119133419.9734-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This commit implements the XDP_TX action in the ena driver. We allocate
separate tx queues for the XDP_TX. We currently allow xdp only when
there is enough queues to allocate for xdp.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 865 ++++++++++++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  45 +-
 3 files changed, 740 insertions(+), 174 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index a3250dcf7..745fffd42 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -744,7 +744,9 @@ static int ena_set_channels(struct net_device *netdev,
 	struct ena_adapter *adapter = netdev_priv(netdev);
 	u32 count = channels->combined_count;
 	/* The check for max value is already done in ethtool */
-	if (count < ENA_MIN_NUM_IO_QUEUES)
+	if (count < ENA_MIN_NUM_IO_QUEUES ||
+	    (ena_xdp_present(adapter) &&
+	    !ena_xdp_legal_queue_count(adapter, channels->combined_count)))
 		return -EINVAL;
 
 	return ena_update_queue_count(adapter, count);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 35f766d9c..087f132e0 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -35,7 +35,6 @@
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
 #endif /* CONFIG_RFS_ACCEL */
-#include <linux/bpf_trace.h>
 #include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -47,6 +46,7 @@
 #include <net/ip.h>
 
 #include "ena_netdev.h"
+#include <linux/bpf_trace.h>
 #include "ena_pci_id_tbl.h"
 
 static char version[] = DEVICE_NAME " v" DRV_MODULE_VERSION "\n";
@@ -78,6 +78,36 @@ static void check_for_admin_com_state(struct ena_adapter *adapter);
 static void ena_destroy_device(struct ena_adapter *adapter, bool graceful);
 static int ena_restore_device(struct ena_adapter *adapter);
 
+static void ena_init_io_rings(struct ena_adapter *adapter,
+			      int first_index, int count);
+static void ena_init_napi_in_range(struct ena_adapter *adapter,
+				   int first_index, int count);
+static void ena_del_napi_in_range(struct ena_adapter *adapter, int first_index,
+				  int count);
+static int ena_setup_tx_resources(struct ena_adapter *adapter, int qid);
+static int ena_setup_tx_resources_in_range(struct ena_adapter *adapter,
+					   int first_index,
+					   int count);
+static int ena_create_io_tx_queue(struct ena_adapter *adapter, int qid);
+static void ena_free_tx_resources(struct ena_adapter *adapter, int qid);
+static int ena_clean_xdp_irq(struct ena_ring *xdp_ring, u32 budget);
+static void ena_destroy_all_tx_queues(struct ena_adapter *adapter);
+static void ena_free_all_io_tx_resources(struct ena_adapter *adapter);
+static void ena_napi_disable_in_range(struct ena_adapter *adapter,
+				      int first_index, int count);
+static void ena_napi_enable_in_range(struct ena_adapter *adapter,
+				     int first_index, int count);
+static int ena_up(struct ena_adapter *adapter);
+static void ena_down(struct ena_adapter *adapter);
+static void ena_unmask_interrupt(struct ena_ring *tx_ring,
+				 struct ena_ring *rx_ring);
+static void ena_update_ring_numa_node(struct ena_ring *tx_ring,
+				      struct ena_ring *rx_ring);
+static void ena_unmap_tx_buff(struct ena_ring *tx_ring,
+			      struct ena_tx_buffer *tx_info);
+static int ena_create_io_tx_queues_in_range(struct ena_adapter *adapter,
+					    int first_index, int count);
+
 static void ena_tx_timeout(struct net_device *dev)
 {
 	struct ena_adapter *adapter = netdev_priv(dev);
@@ -123,7 +153,219 @@ static int ena_change_mtu(struct net_device *dev, int new_mtu)
 	return ret;
 }
 
-static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
+static int ena_xmit_common(struct net_device *dev,
+			   struct ena_ring *ring,
+			   struct ena_tx_buffer *tx_info,
+			   struct ena_com_tx_ctx *ena_tx_ctx,
+			   u16 next_to_use,
+			   u32 bytes)
+{
+	struct ena_adapter *adapter = netdev_priv(dev);
+	int rc, nb_hw_desc;
+
+	if (unlikely(ena_com_is_doorbell_needed(ring->ena_com_io_sq,
+						ena_tx_ctx))) {
+		netif_dbg(adapter, tx_queued, dev,
+			  "llq tx max burst size of queue %d achieved, writing doorbell to send burst\n",
+			  ring->qid);
+		ena_com_write_sq_doorbell(ring->ena_com_io_sq);
+	}
+
+	/* prepare the packet's descriptors to dma engine */
+	rc = ena_com_prepare_tx(ring->ena_com_io_sq, ena_tx_ctx,
+				&nb_hw_desc);
+
+	/* In case there isn't enough space in the queue for the packet,
+	 * we simply drop it. All other failure reasons of
+	 * ena_com_prepare_tx() are fatal and therefore require a device reset.
+	 */
+	if (unlikely(rc)) {
+		netif_err(adapter, tx_queued, dev,
+			  "failed to prepare tx bufs\n");
+		u64_stats_update_begin(&ring->syncp);
+		ring->tx_stats.prepare_ctx_err++;
+		u64_stats_update_end(&ring->syncp);
+		if (rc != -ENOMEM) {
+			adapter->reset_reason =
+				ENA_REGS_RESET_DRIVER_INVALID_STATE;
+			set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
+		}
+		return rc;
+	}
+
+	u64_stats_update_begin(&ring->syncp);
+	ring->tx_stats.cnt++;
+	ring->tx_stats.bytes += bytes;
+	u64_stats_update_end(&ring->syncp);
+
+	tx_info->tx_descs = nb_hw_desc;
+	tx_info->last_jiffies = jiffies;
+	tx_info->print_once = 0;
+
+	ring->next_to_use = ENA_TX_RING_IDX_NEXT(next_to_use,
+						 ring->ring_size);
+	return 0;
+}
+
+/* This is the XDP napi callback. XDP queues use a separate napi callback
+ * than Rx/Tx queues.
+ */
+static int ena_xdp_io_poll(struct napi_struct *napi, int budget)
+{
+	struct ena_napi *ena_napi = container_of(napi, struct ena_napi, napi);
+	u32 xdp_work_done, xdp_budget;
+	struct ena_ring *xdp_ring;
+	int napi_comp_call = 0;
+	int ret;
+
+	xdp_ring = ena_napi->xdp_ring;
+
+	xdp_budget = budget;
+
+	if (!test_bit(ENA_FLAG_DEV_UP, &xdp_ring->adapter->flags) ||
+	    test_bit(ENA_FLAG_TRIGGER_RESET, &xdp_ring->adapter->flags)) {
+		napi_complete_done(napi, 0);
+		return 0;
+	}
+
+	xdp_work_done = ena_clean_xdp_irq(xdp_ring, xdp_budget);
+
+	/* If the device is about to reset or down, avoid unmask
+	 * the interrupt and return 0 so NAPI won't reschedule
+	 */
+	if (unlikely(!test_bit(ENA_FLAG_DEV_UP, &xdp_ring->adapter->flags))) {
+		napi_complete_done(napi, 0);
+		ret = 0;
+	} else if (xdp_budget > xdp_work_done) {
+		napi_comp_call = 1;
+		if (napi_complete_done(napi, xdp_work_done))
+			ena_unmask_interrupt(xdp_ring, NULL);
+		ena_update_ring_numa_node(xdp_ring, NULL);
+		ret = xdp_work_done;
+	} else {
+		ret = xdp_budget;
+	}
+
+	u64_stats_update_begin(&xdp_ring->syncp);
+	xdp_ring->tx_stats.napi_comp += napi_comp_call;
+	xdp_ring->tx_stats.tx_poll++;
+	u64_stats_update_end(&xdp_ring->syncp);
+
+	return ret;
+}
+
+static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
+			       struct ena_tx_buffer *tx_info,
+			       struct xdp_buff *xdp,
+			       void **push_hdr,
+			       u32 *push_len)
+{
+	struct ena_adapter *adapter = xdp_ring->adapter;
+	struct ena_com_buf *ena_buf;
+	dma_addr_t dma = 0;
+	u32 size;
+
+	tx_info->xdp = xdp;
+	size = xdp->data_end - xdp->data;
+	ena_buf = tx_info->bufs;
+
+	/* llq push buffer */
+	*push_len = min_t(u32, size, xdp_ring->tx_max_header_size);
+	*push_hdr = xdp->data;
+
+	if (size - *push_len > 0) {
+		dma = dma_map_single(xdp_ring->dev,
+				     *push_hdr + *push_len,
+				     size - *push_len,
+				     DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(xdp_ring->dev, dma)))
+			goto error_report_dma_error;
+
+		tx_info->map_linear_data = 1;
+		tx_info->num_of_bufs = 1;
+	}
+
+	ena_buf->paddr = dma;
+	ena_buf->len = size;
+
+	return 0;
+
+error_report_dma_error:
+	u64_stats_update_begin(&xdp_ring->syncp);
+	xdp_ring->tx_stats.dma_mapping_err++;
+	u64_stats_update_end(&xdp_ring->syncp);
+	netdev_warn(adapter->netdev, "failed to map xdp buff\n");
+
+	tx_info->xdp = NULL;
+	tx_info->num_of_bufs = 0;
+
+	return -EINVAL;
+}
+
+static int ena_xdp_xmit_buff(struct net_device *dev,
+			     struct xdp_buff *xdp,
+			     int qid,
+			     struct ena_rx_buffer *rx_info)
+{
+	struct ena_adapter *adapter = netdev_priv(dev);
+	struct ena_com_tx_ctx ena_tx_ctx = {0};
+	struct ena_tx_buffer *tx_info;
+	struct ena_ring *xdp_ring;
+	struct ena_ring *rx_ring;
+	u16 next_to_use, req_id;
+	int rc;
+	void *push_hdr;
+	u32 push_len;
+
+	xdp_ring = &adapter->tx_ring[qid];
+	next_to_use = xdp_ring->next_to_use;
+	req_id = xdp_ring->free_ids[next_to_use];
+	tx_info = &xdp_ring->tx_buffer_info[req_id];
+	tx_info->num_of_bufs = 0;
+	rx_ring = &xdp_ring->adapter->rx_ring[qid -
+		  xdp_ring->adapter->xdp_first_ring];
+	page_ref_inc(rx_info->page);
+	tx_info->xdp_rx_page = rx_info->page;
+
+	rc = ena_xdp_tx_map_buff(xdp_ring, tx_info, xdp, &push_hdr, &push_len);
+	if (unlikely(rc))
+		goto error_drop_packet;
+
+	ena_tx_ctx.ena_bufs = tx_info->bufs;
+	ena_tx_ctx.push_header = push_hdr;
+	ena_tx_ctx.num_bufs = tx_info->num_of_bufs;
+	ena_tx_ctx.req_id = req_id;
+	ena_tx_ctx.header_len = push_len;
+
+	rc = ena_xmit_common(dev,
+			     xdp_ring,
+			     tx_info,
+			     &ena_tx_ctx,
+			     next_to_use,
+			     xdp->data_end - xdp->data);
+	if (rc)
+		goto error_unmap_dma;
+	/* trigger the dma engine. ena_com_write_sq_doorbell()
+	 * has a mb
+	 */
+	ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
+	u64_stats_update_begin(&xdp_ring->syncp);
+	xdp_ring->tx_stats.doorbells++;
+	u64_stats_update_end(&xdp_ring->syncp);
+
+	return NETDEV_TX_OK;
+
+error_unmap_dma:
+	ena_unmap_tx_buff(xdp_ring, tx_info);
+	tx_info->xdp = NULL;
+error_drop_packet:
+
+	return NETDEV_TX_OK;
+}
+
+static int ena_xdp_execute(struct ena_ring *rx_ring,
+			   struct xdp_buff *xdp,
+			   struct ena_rx_buffer *rx_info)
 {
 	struct bpf_prog *xdp_prog;
 	u32 verdict = XDP_PASS;
@@ -136,44 +378,199 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 
 	verdict = bpf_prog_run_xdp(xdp_prog, xdp);
 
-	if (unlikely(verdict == XDP_ABORTED))
+	if (verdict == XDP_TX)
+		ena_xdp_xmit_buff(rx_ring->netdev,
+				  xdp,
+				  rx_ring->qid + rx_ring->adapter->num_io_queues,
+				  rx_info);
+	else if (unlikely(verdict == XDP_ABORTED))
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
-	else if (unlikely(verdict >= XDP_TX))
+	else if (unlikely(verdict > XDP_TX))
 		bpf_warn_invalid_xdp_action(verdict);
 out:
 	rcu_read_unlock();
 	return verdict;
 }
 
+static void ena_init_all_xdp_queues(struct ena_adapter *adapter)
+{
+	adapter->xdp_first_ring = adapter->num_io_queues;
+	adapter->xdp_num_queues = adapter->num_io_queues;
+
+	ena_init_io_rings(adapter,
+			  adapter->xdp_first_ring,
+			  adapter->xdp_num_queues);
+}
+
+static int ena_setup_and_create_all_xdp_queues(struct ena_adapter *adapter)
+{
+	int rc = 0;
+
+	rc = ena_setup_tx_resources_in_range(adapter, adapter->xdp_first_ring,
+					     adapter->xdp_num_queues);
+	if (rc)
+		goto setup_err;
+
+	rc = ena_create_io_tx_queues_in_range(adapter,
+					      adapter->xdp_first_ring,
+					      adapter->xdp_num_queues);
+	if (rc)
+		goto create_err;
+
+	return 0;
+
+create_err:
+	ena_free_all_io_tx_resources(adapter);
+setup_err:
+	return rc;
+}
+
+static void ena_xdp_napi_enable(struct ena_adapter *adapter)
+{
+	ena_init_napi_in_range(adapter, adapter->xdp_first_ring,
+			       adapter->xdp_num_queues);
+	ena_napi_enable_in_range(adapter, adapter->xdp_first_ring,
+				 adapter->xdp_num_queues);
+}
+
+/* Provides a way for both kernel and bpf-prog to know
+ * more about the RX-queue a given XDP frame have arrived on.
+ */
+static int ena_xdp_register_rxq_info(struct ena_ring *rx_ring)
+{
+	int rc;
+
+	rc = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev, rx_ring->qid);
+
+	if (rc) {
+		netif_err(rx_ring->adapter, ifup, rx_ring->netdev,
+			  "Failed to register xdp rx queue info. RX queue num %d rc: %d\n",
+			  rx_ring->qid, rc);
+		goto err;
+	}
+
+	rc = xdp_rxq_info_reg_mem_model(&rx_ring->xdp_rxq, MEM_TYPE_PAGE_SHARED,
+					NULL);
+
+	if (rc) {
+		netif_err(rx_ring->adapter, ifup, rx_ring->netdev,
+			  "Failed to register xdp rx queue info memory model. RX queue num %d rc: %d\n",
+			  rx_ring->qid, rc);
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+	}
+
+err:
+	return rc;
+}
+
+static void ena_xdp_unregister_rxq_info(struct ena_ring *rx_ring)
+{
+	xdp_rxq_info_unreg_mem_model(&rx_ring->xdp_rxq);
+	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+}
+
+void ena_xdp_exchange_program_rx_in_range(struct ena_adapter *adapter,
+					  struct bpf_prog *prog,
+					  int first,
+					  int count)
+{
+	struct ena_ring *rx_ring;
+	int i = 0;
+
+	for (i = first; i < count; i++) {
+		rx_ring = &adapter->rx_ring[i];
+		xchg(&rx_ring->xdp_bpf_prog, prog);
+		if (prog)
+			ena_xdp_register_rxq_info(rx_ring);
+		else
+			ena_xdp_unregister_rxq_info(rx_ring);
+	}
+}
+
+void ena_xdp_exchange_program(struct ena_adapter *adapter,
+			      struct bpf_prog *prog)
+{
+	struct bpf_prog *old_bpf_prog = xchg(&adapter->xdp_bpf_prog, prog);
+
+	ena_xdp_exchange_program_rx_in_range(adapter, prog, 0,
+					     adapter->num_io_queues);
+
+	if (old_bpf_prog)
+		bpf_prog_put(old_bpf_prog);
+}
+
+static void ena_destroy_and_free_all_xdp_queues(struct ena_adapter *adapter)
+{
+	bool was_up;
+
+	was_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
+
+	if (was_up)
+		ena_down(adapter);
+	adapter->xdp_first_ring = 0;
+	adapter->xdp_num_queues = 0;
+	ena_xdp_exchange_program(adapter, NULL);
+	if (was_up)
+		ena_up(adapter);
+}
+
 static int ena_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 	struct bpf_prog *prog = bpf->prog;
 	struct bpf_prog *old_bpf_prog;
-	int i, prev_mtu;
-
-	if (ena_xdp_allowed(adapter)) {
-		old_bpf_prog = xchg(&adapter->xdp_bpf_prog, prog);
-
-		for (i = 0; i < adapter->num_io_queues; i++)
-			xchg(&adapter->rx_ring[i].xdp_bpf_prog, prog);
-
-		if (old_bpf_prog)
-			bpf_prog_put(old_bpf_prog);
+	int rc, prev_mtu;
+	bool is_up;
+
+	is_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
+	rc = ena_xdp_allowed(adapter);
+	if (rc == ENA_XDP_ALLOWED) {
+		old_bpf_prog = adapter->xdp_bpf_prog;
+		if (prog) {
+			if (!is_up) {
+				ena_init_all_xdp_queues(adapter);
+			} else if ((!old_bpf_prog)) {
+				ena_init_all_xdp_queues(adapter);
+				rc = ena_setup_and_create_all_xdp_queues(adapter);
+				if (rc)
+					goto destroy_xdp_queues;
+
+				ena_xdp_napi_enable(adapter);
+			}
+			ena_xdp_exchange_program(adapter, prog);
+		} else if (old_bpf_prog) {
+			ena_destroy_and_free_all_xdp_queues(adapter);
+		}
 
 		prev_mtu = netdev->max_mtu;
 		netdev->max_mtu = prog ? ENA_XDP_MAX_MTU : adapter->max_mtu;
-		netif_info(adapter, drv, adapter->netdev, "xdp program set, changging the max_mtu from %d to %d",
-			   prev_mtu, netdev->max_mtu);
 
-	} else {
-		netif_err(adapter, drv, adapter->netdev, "Failed to set xdp program, the current MTU (%d) is larger than the maximum allowed MTU (%lu) while xdp is on",
+		if (!old_bpf_prog)
+			netif_info(adapter, drv, adapter->netdev,
+				   "xdp program set, changing the max_mtu from %d to %d",
+				   prev_mtu, netdev->max_mtu);
+
+	} else if (rc == ENA_XDP_CURRENT_MTU_TOO_LARGE) {
+		netif_err(adapter, drv, adapter->netdev,
+			  "Failed to set xdp program, the current MTU (%d) is larger than the maximum allowed MTU (%lu) while xdp is on",
 			  netdev->mtu, ENA_XDP_MAX_MTU);
-		NL_SET_ERR_MSG_MOD(bpf->extack, "Failed to set xdp program, the current MTU is larger than the maximum allowed MTU. Check the dmesg for more info");
+		NL_SET_ERR_MSG_MOD(bpf->extack,
+				   "Failed to set xdp program, the current MTU is larger than the maximum allowed MTU. Check the dmesg for more info");
+		return -EINVAL;
+	} else if (rc == ENA_XDP_NO_ENOUGH_QUEUES) {
+		netif_err(adapter, drv, adapter->netdev,
+			  "Failed to set xdp program, the Rx/Tx channel count should be at most half of the maximum allowed channel count. The current queue count (%d), the maximal queue count (%d)\n",
+			  adapter->num_io_queues, adapter->max_num_io_queues);
+		NL_SET_ERR_MSG_MOD(bpf->extack,
+				   "Failed to set xdp program, there is no enough space for allocating XDP queues, Check the dmesg for more info");
 		return -EINVAL;
 	}
 
 	return 0;
+
+destroy_xdp_queues:
+	ena_destroy_and_free_all_xdp_queues(adapter);
+	return rc;
 }
 
 /* This is the main xdp callback, it's used by the kernel to set/unset the xdp
@@ -238,7 +635,8 @@ static void ena_init_io_rings_common(struct ena_adapter *adapter,
 	u64_stats_init(&ring->syncp);
 }
 
-static void ena_init_io_rings(struct ena_adapter *adapter)
+static void ena_init_io_rings(struct ena_adapter *adapter,
+			      int first_index, int count)
 {
 	struct ena_com_dev *ena_dev;
 	struct ena_ring *txr, *rxr;
@@ -246,13 +644,12 @@ static void ena_init_io_rings(struct ena_adapter *adapter)
 
 	ena_dev = adapter->ena_dev;
 
-	for (i = 0; i < adapter->num_io_queues; i++) {
+	for (i = first_index; i < first_index + count; i++) {
 		txr = &adapter->tx_ring[i];
 		rxr = &adapter->rx_ring[i];
 
-		/* TX/RX common ring state */
+		/* TX common ring state */
 		ena_init_io_rings_common(adapter, txr, i);
-		ena_init_io_rings_common(adapter, rxr, i);
 
 		/* TX specific ring state */
 		txr->ring_size = adapter->requested_tx_ring_size;
@@ -262,14 +659,20 @@ static void ena_init_io_rings(struct ena_adapter *adapter)
 		txr->smoothed_interval =
 			ena_com_get_nonadaptive_moderation_interval_tx(ena_dev);
 
-		/* RX specific ring state */
-		rxr->ring_size = adapter->requested_rx_ring_size;
-		rxr->rx_copybreak = adapter->rx_copybreak;
-		rxr->sgl_size = adapter->max_rx_sgl_size;
-		rxr->smoothed_interval =
-			ena_com_get_nonadaptive_moderation_interval_rx(ena_dev);
-		rxr->empty_rx_queue = 0;
-		adapter->ena_napi[i].dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+		/* Don't init RX queues for xdp queues */
+		if (!ENA_IS_XDP_INDEX(adapter, i)) {
+			/* RX common ring state */
+			ena_init_io_rings_common(adapter, rxr, i);
+
+			/* RX specific ring state */
+			rxr->ring_size = adapter->requested_rx_ring_size;
+			rxr->rx_copybreak = adapter->rx_copybreak;
+			rxr->sgl_size = adapter->max_rx_sgl_size;
+			rxr->smoothed_interval =
+				ena_com_get_nonadaptive_moderation_interval_rx(ena_dev);
+			rxr->empty_rx_queue = 0;
+			adapter->ena_napi[i].dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+		}
 	}
 }
 
@@ -359,16 +762,13 @@ static void ena_free_tx_resources(struct ena_adapter *adapter, int qid)
 	tx_ring->push_buf_intermediate_buf = NULL;
 }
 
-/* ena_setup_all_tx_resources - allocate I/O Tx queues resources for All queues
- * @adapter: private structure
- *
- * Return 0 on success, negative on failure
- */
-static int ena_setup_all_tx_resources(struct ena_adapter *adapter)
+static int ena_setup_tx_resources_in_range(struct ena_adapter *adapter,
+					   int first_index,
+					   int count)
 {
 	int i, rc = 0;
 
-	for (i = 0; i < adapter->num_io_queues; i++) {
+	for (i = first_index; i < first_index + count; i++) {
 		rc = ena_setup_tx_resources(adapter, i);
 		if (rc)
 			goto err_setup_tx;
@@ -382,11 +782,20 @@ err_setup_tx:
 		  "Tx queue %d: allocation failed\n", i);
 
 	/* rewind the index freeing the rings as we go */
-	while (i--)
+	while (first_index < i--)
 		ena_free_tx_resources(adapter, i);
 	return rc;
 }
 
+static void ena_free_all_io_tx_resources_in_range(struct ena_adapter *adapter,
+						  int first_index, int count)
+{
+	int i;
+
+	for (i = first_index; i < first_index + count; i++)
+		ena_free_tx_resources(adapter, i);
+}
+
 /* ena_free_all_io_tx_resources - Free I/O Tx Resources for All Queues
  * @adapter: board private structure
  *
@@ -394,10 +803,10 @@ err_setup_tx:
  */
 static void ena_free_all_io_tx_resources(struct ena_adapter *adapter)
 {
-	int i;
-
-	for (i = 0; i < adapter->num_io_queues; i++)
-		ena_free_tx_resources(adapter, i);
+	ena_free_all_io_tx_resources_in_range(adapter,
+					      0,
+					      adapter->xdp_num_queues +
+					      adapter->num_io_queues);
 }
 
 static int validate_rx_req_id(struct ena_ring *rx_ring, u16 req_id)
@@ -491,9 +900,6 @@ static void ena_free_rx_resources(struct ena_adapter *adapter,
 
 	vfree(rx_ring->free_ids);
 	rx_ring->free_ids = NULL;
-
-	xdp_rxq_info_unreg_mem_model(&rx_ring->xdp_rxq);
-	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 }
 
 /* ena_setup_all_rx_resources - allocate I/O Rx queues resources for all queues
@@ -697,8 +1103,8 @@ static void ena_free_all_rx_bufs(struct ena_adapter *adapter)
 		ena_free_rx_bufs(adapter, i);
 }
 
-static void ena_unmap_tx_skb(struct ena_ring *tx_ring,
-				    struct ena_tx_buffer *tx_info)
+static void ena_unmap_tx_buff(struct ena_ring *tx_ring,
+			      struct ena_tx_buffer *tx_info)
 {
 	struct ena_com_buf *ena_buf;
 	u32 cnt;
@@ -752,7 +1158,7 @@ static void ena_free_tx_bufs(struct ena_ring *tx_ring)
 				   tx_ring->qid, i);
 		}
 
-		ena_unmap_tx_skb(tx_ring, tx_info);
+		ena_unmap_tx_buff(tx_ring, tx_info);
 
 		dev_kfree_skb_any(tx_info->skb);
 	}
@@ -765,7 +1171,7 @@ static void ena_free_all_tx_bufs(struct ena_adapter *adapter)
 	struct ena_ring *tx_ring;
 	int i;
 
-	for (i = 0; i < adapter->num_io_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues + adapter->xdp_num_queues; i++) {
 		tx_ring = &adapter->tx_ring[i];
 		ena_free_tx_bufs(tx_ring);
 	}
@@ -776,7 +1182,7 @@ static void ena_destroy_all_tx_queues(struct ena_adapter *adapter)
 	u16 ena_qid;
 	int i;
 
-	for (i = 0; i < adapter->num_io_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues + adapter->xdp_num_queues; i++) {
 		ena_qid = ENA_IO_TXQ_IDX(i);
 		ena_com_destroy_io_queue(adapter->ena_dev, ena_qid);
 	}
@@ -800,6 +1206,32 @@ static void ena_destroy_all_io_queues(struct ena_adapter *adapter)
 	ena_destroy_all_rx_queues(adapter);
 }
 
+static int handle_invalid_req_id(struct ena_ring *ring, u16 req_id,
+				 struct ena_tx_buffer *tx_info, bool is_xdp)
+{
+	if (tx_info)
+		netif_err(ring->adapter,
+			  tx_done,
+			  ring->netdev,
+			  "tx_info doesn't have valid %s",
+			   is_xdp ? "xdp buff" : "skb");
+	else
+		netif_err(ring->adapter,
+			  tx_done,
+			  ring->netdev,
+			  "Invalid req_id: %hu\n",
+			  req_id);
+
+	u64_stats_update_begin(&ring->syncp);
+	ring->tx_stats.bad_req_id++;
+	u64_stats_update_end(&ring->syncp);
+
+	/* Trigger device reset */
+	ring->adapter->reset_reason = ENA_REGS_RESET_INV_TX_REQ_ID;
+	set_bit(ENA_FLAG_TRIGGER_RESET, &ring->adapter->flags);
+	return -EFAULT;
+}
+
 static int validate_tx_req_id(struct ena_ring *tx_ring, u16 req_id)
 {
 	struct ena_tx_buffer *tx_info = NULL;
@@ -810,21 +1242,20 @@ static int validate_tx_req_id(struct ena_ring *tx_ring, u16 req_id)
 			return 0;
 	}
 
-	if (tx_info)
-		netif_err(tx_ring->adapter, tx_done, tx_ring->netdev,
-			  "tx_info doesn't have valid skb\n");
-	else
-		netif_err(tx_ring->adapter, tx_done, tx_ring->netdev,
-			  "Invalid req_id: %hu\n", req_id);
+	return handle_invalid_req_id(tx_ring, req_id, tx_info, false);
+}
 
-	u64_stats_update_begin(&tx_ring->syncp);
-	tx_ring->tx_stats.bad_req_id++;
-	u64_stats_update_end(&tx_ring->syncp);
+static int validate_xdp_req_id(struct ena_ring *xdp_ring, u16 req_id)
+{
+	struct ena_tx_buffer *tx_info = NULL;
 
-	/* Trigger device reset */
-	tx_ring->adapter->reset_reason = ENA_REGS_RESET_INV_TX_REQ_ID;
-	set_bit(ENA_FLAG_TRIGGER_RESET, &tx_ring->adapter->flags);
-	return -EFAULT;
+	if (likely(req_id < xdp_ring->ring_size)) {
+		tx_info = &xdp_ring->tx_buffer_info[req_id];
+		if (likely(tx_info->xdp))
+			return 0;
+	}
+
+	return handle_invalid_req_id(xdp_ring, req_id, tx_info, true);
 }
 
 static int ena_clean_tx_irq(struct ena_ring *tx_ring, u32 budget)
@@ -863,7 +1294,7 @@ static int ena_clean_tx_irq(struct ena_ring *tx_ring, u32 budget)
 		tx_info->skb = NULL;
 		tx_info->last_jiffies = 0;
 
-		ena_unmap_tx_skb(tx_ring, tx_info);
+		ena_unmap_tx_buff(tx_ring, tx_info);
 
 		netif_dbg(tx_ring->adapter, tx_done, tx_ring->netdev,
 			  "tx_poll: q %d skb %p completed\n", tx_ring->qid,
@@ -1129,7 +1560,9 @@ int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
 		return XDP_DROP;
 	else
-		return ena_xdp_execute(rx_ring, xdp);
+		return ena_xdp_execute(rx_ring,
+				       xdp,
+				       rx_info);
 }
 /* ena_clean_rx_irq - Cleanup RX irq
  * @rx_ring: RX ring to clean
@@ -1142,10 +1575,9 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 			    u32 budget)
 {
 	u16 next_to_clean = rx_ring->next_to_clean;
-	u32 res_budget, work_done;
-
 	struct ena_com_rx_ctx ena_rx_ctx;
 	struct ena_adapter *adapter;
+	u32 res_budget, work_done;
 	int rx_copybreak_pkt = 0;
 	int refill_threshold;
 	struct sk_buff *skb;
@@ -1160,6 +1592,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		  "%s qid %d\n", __func__, rx_ring->qid);
 	res_budget = budget;
 	xdp.rxq = &rx_ring->xdp_rxq;
+
 	do {
 		xdp_verdict = XDP_PASS;
 		skb = NULL;
@@ -1191,6 +1624,11 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 					 &next_to_clean);
 
 		if (unlikely(!skb)) {
+			if (xdp_verdict == XDP_TX) {
+				ena_free_rx_page(rx_ring,
+						 &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id]);
+				res_budget--;
+			}
 			for (i = 0; i < ena_rx_ctx.descs; i++) {
 				rx_ring->free_ids[next_to_clean] =
 					rx_ring->ena_bufs[i].req_id;
@@ -1198,7 +1636,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 					ENA_RX_RING_IDX_NEXT(next_to_clean,
 							     rx_ring->ring_size);
 			}
-			if (xdp_verdict == XDP_DROP)
+			if (xdp_verdict == XDP_TX || xdp_verdict == XDP_DROP)
 				continue;
 			break;
 		}
@@ -1293,9 +1731,14 @@ static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 					struct ena_ring *rx_ring)
 {
 	struct ena_eth_io_intr_reg intr_reg;
-	u32 rx_interval = ena_com_get_adaptive_moderation_enabled(rx_ring->ena_dev) ?
-		rx_ring->smoothed_interval :
-		ena_com_get_nonadaptive_moderation_interval_rx(rx_ring->ena_dev);
+	u32 rx_interval = 0;
+	/* Rx ring can be NULL when for XDP tx queues which don't have an accompanying
+	 * rx_ring pair.
+	 */
+	if (rx_ring)
+		rx_interval = ena_com_get_adaptive_moderation_enabled(rx_ring->ena_dev) ?
+			rx_ring->smoothed_interval :
+			ena_com_get_nonadaptive_moderation_interval_rx(rx_ring->ena_dev);
 
 	/* Update intr register: rx intr delay,
 	 * tx intr delay and interrupt unmask
@@ -1308,8 +1751,9 @@ static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 	/* It is a shared MSI-X.
 	 * Tx and Rx CQ have pointer to it.
 	 * So we use one of them to reach the intr reg
+	 * The Tx ring is used because the rx_ring is NULL for XDP queues
 	 */
-	ena_com_unmask_intr(rx_ring->ena_com_io_cq, &intr_reg);
+	ena_com_unmask_intr(tx_ring->ena_com_io_cq, &intr_reg);
 }
 
 static void ena_update_ring_numa_node(struct ena_ring *tx_ring,
@@ -1327,22 +1771,84 @@ static void ena_update_ring_numa_node(struct ena_ring *tx_ring,
 
 	if (numa_node != NUMA_NO_NODE) {
 		ena_com_update_numa_node(tx_ring->ena_com_io_cq, numa_node);
-		ena_com_update_numa_node(rx_ring->ena_com_io_cq, numa_node);
+		if (rx_ring)
+			ena_com_update_numa_node(rx_ring->ena_com_io_cq,
+						 numa_node);
 	}
 
 	tx_ring->cpu = cpu;
-	rx_ring->cpu = cpu;
+	if (rx_ring)
+		rx_ring->cpu = cpu;
 
 	return;
 out:
 	put_cpu();
 }
 
+static int ena_clean_xdp_irq(struct ena_ring *xdp_ring, u32 budget)
+{
+	u32 total_done = 0;
+	u16 next_to_clean;
+	u32 tx_bytes = 0;
+	int tx_pkts = 0;
+	u16 req_id;
+	int rc;
+
+	if (unlikely(!xdp_ring))
+		return 0;
+	next_to_clean = xdp_ring->next_to_clean;
+
+	while (tx_pkts < budget) {
+		struct ena_tx_buffer *tx_info;
+		struct xdp_buff *xdp;
+
+		rc = ena_com_tx_comp_req_id_get(xdp_ring->ena_com_io_cq,
+						&req_id);
+		if (rc)
+			break;
+
+		rc = validate_xdp_req_id(xdp_ring, req_id);
+		if (rc)
+			break;
+
+		tx_info = &xdp_ring->tx_buffer_info[req_id];
+		xdp = tx_info->xdp;
+
+		tx_info->xdp = NULL;
+		tx_info->last_jiffies = 0;
+		ena_unmap_tx_buff(xdp_ring, tx_info);
+
+		netif_dbg(xdp_ring->adapter, tx_done, xdp_ring->netdev,
+			  "tx_poll: q %d skb %p completed\n", xdp_ring->qid,
+			  xdp);
+		/* Pointer arithmetic isn't allowed by the C standard on void*
+		 * yet gcc allows it as an extension and thus we cast to (u8 *)
+		 */
+		tx_bytes += (u8 *)xdp->data_end - (u8 *)xdp->data;
+		tx_pkts++;
+		total_done += tx_info->tx_descs;
+
+		__free_page(tx_info->xdp_rx_page);
+		xdp_ring->free_ids[next_to_clean] = req_id;
+		next_to_clean = ENA_TX_RING_IDX_NEXT(next_to_clean,
+						     xdp_ring->ring_size);
+	}
+
+	xdp_ring->next_to_clean = next_to_clean;
+	ena_com_comp_ack(xdp_ring->ena_com_io_sq, total_done);
+	ena_com_update_dev_comp_head(xdp_ring->ena_com_io_cq);
+
+	netif_dbg(xdp_ring->adapter, tx_done, xdp_ring->netdev,
+		  "tx_poll: q %d done. total pkts: %d\n",
+		  xdp_ring->qid, tx_pkts);
+
+	return tx_pkts;
+}
+
 static int ena_io_poll(struct napi_struct *napi, int budget)
 {
 	struct ena_napi *ena_napi = container_of(napi, struct ena_napi, napi);
 	struct ena_ring *tx_ring, *rx_ring;
-
 	u32 tx_work_done;
 	u32 rx_work_done;
 	int tx_budget;
@@ -1499,10 +2005,12 @@ static void ena_setup_io_intr(struct ena_adapter *adapter)
 {
 	struct net_device *netdev;
 	int irq_idx, i, cpu;
+	int io_queue_count;
 
 	netdev = adapter->netdev;
+	io_queue_count = adapter->num_io_queues + adapter->xdp_num_queues;
 
-	for (i = 0; i < adapter->num_io_queues; i++) {
+	for (i = 0; i < io_queue_count; i++) {
 		irq_idx = ENA_IO_IRQ_IDX(i);
 		cpu = i % num_online_cpus();
 
@@ -1630,45 +2138,64 @@ static void ena_disable_io_intr_sync(struct ena_adapter *adapter)
 		synchronize_irq(adapter->irq_tbl[i].vector);
 }
 
-static void ena_del_napi(struct ena_adapter *adapter)
+static void ena_del_napi_in_range(struct ena_adapter *adapter,
+				  int first_index,
+				  int count)
 {
 	int i;
 
-	for (i = 0; i < adapter->num_io_queues; i++)
-		netif_napi_del(&adapter->ena_napi[i].napi);
+	for (i = first_index; i < first_index + count; i++) {
+		/* Check if napi was initialized before */
+		if (!ENA_IS_XDP_INDEX(adapter, i) ||
+		    adapter->ena_napi[i].xdp_ring)
+			netif_napi_del(&adapter->ena_napi[i].napi);
+		else
+			WARN_ON(ENA_IS_XDP_INDEX(adapter, i) &&
+				adapter->ena_napi[i].xdp_ring);
+	}
 }
 
-static void ena_init_napi(struct ena_adapter *adapter)
+static void ena_init_napi_in_range(struct ena_adapter *adapter,
+				   int first_index, int count)
 {
-	struct ena_napi *napi;
+	struct ena_napi *napi = {0};
 	int i;
 
-	for (i = 0; i < adapter->num_io_queues; i++) {
+	for (i = first_index; i < first_index + count; i++) {
 		napi = &adapter->ena_napi[i];
 
 		netif_napi_add(adapter->netdev,
 			       &adapter->ena_napi[i].napi,
-			       ena_io_poll,
+			       ENA_IS_XDP_INDEX(adapter, i) ? ena_xdp_io_poll : ena_io_poll,
 			       ENA_NAPI_BUDGET);
-		napi->rx_ring = &adapter->rx_ring[i];
-		napi->tx_ring = &adapter->tx_ring[i];
+
+		if (!ENA_IS_XDP_INDEX(adapter, i)) {
+			napi->rx_ring = &adapter->rx_ring[i];
+			napi->tx_ring = &adapter->tx_ring[i];
+		} else {
+			napi->xdp_ring = &adapter->tx_ring[i];
+		}
 		napi->qid = i;
 	}
 }
 
-static void ena_napi_disable_all(struct ena_adapter *adapter)
+static void ena_napi_disable_in_range(struct ena_adapter *adapter,
+				      int first_index,
+				      int count)
 {
 	int i;
 
-	for (i = 0; i < adapter->num_io_queues; i++)
+	for (i = first_index; i < first_index + count; i++)
 		napi_disable(&adapter->ena_napi[i].napi);
 }
 
-static void ena_napi_enable_all(struct ena_adapter *adapter)
+static void ena_napi_enable_in_range(struct ena_adapter *adapter,
+				     int first_index,
+				     int count)
 {
 	int i;
 
-	for (i = 0; i < adapter->num_io_queues; i++)
+	for (i = first_index; i < first_index + count; i++)
 		napi_enable(&adapter->ena_napi[i].napi);
 }
 
@@ -1721,7 +2248,9 @@ static int ena_up_complete(struct ena_adapter *adapter)
 	/* enable transmits */
 	netif_tx_start_all_queues(adapter->netdev);
 
-	ena_napi_enable_all(adapter);
+	ena_napi_enable_in_range(adapter, 0,
+				 adapter->xdp_num_queues +
+				 adapter->num_io_queues);
 
 	return 0;
 }
@@ -1773,12 +2302,13 @@ static int ena_create_io_tx_queue(struct ena_adapter *adapter, int qid)
 	return rc;
 }
 
-static int ena_create_all_io_tx_queues(struct ena_adapter *adapter)
+static int ena_create_io_tx_queues_in_range(struct ena_adapter *adapter,
+					    int first_index, int count)
 {
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	int rc, i;
 
-	for (i = 0; i < adapter->num_io_queues; i++) {
+	for (i = first_index; i < first_index + count; i++) {
 		rc = ena_create_io_tx_queue(adapter, i);
 		if (rc)
 			goto create_err;
@@ -1787,7 +2317,7 @@ static int ena_create_all_io_tx_queues(struct ena_adapter *adapter)
 	return 0;
 
 create_err:
-	while (i--)
+	while (i-- > first_index)
 		ena_com_destroy_io_queue(ena_dev, ENA_IO_TXQ_IDX(i));
 
 	return rc;
@@ -1837,26 +2367,6 @@ static int ena_create_io_rx_queue(struct ena_adapter *adapter, int qid)
 
 	ena_com_update_numa_node(rx_ring->ena_com_io_cq, ctx.numa_node);
 
-	rc = xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev, qid);
-
-	if (rc) {
-		netif_err(adapter, ifup, adapter->netdev,
-			  "Failed to register xdp rx queue info. RX queue num %d rc: %d\n",
-			  qid, rc);
-		goto err;
-	}
-
-	rc = xdp_rxq_info_reg_mem_model(&rx_ring->xdp_rxq, MEM_TYPE_PAGE_SHARED,
-					NULL);
-
-	if (rc) {
-		netif_err(adapter, ifup, adapter->netdev,
-			  "Failed to register xdp rx queue info memory model. RX queue num %d rc: %d\n",
-			  qid, rc);
-		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
-		goto err;
-	}
-
 	return rc;
 err:
 	ena_com_destroy_io_queue(ena_dev, ena_qid);
@@ -1924,11 +2434,21 @@ static int create_queues_with_size_backoff(struct ena_adapter *adapter)
 			  adapter->requested_rx_ring_size);
 
 	while (1) {
-		rc = ena_setup_all_tx_resources(adapter);
+		if (ena_xdp_present(adapter)) {
+			rc = ena_setup_and_create_all_xdp_queues(adapter);
+
+			if (rc)
+				goto err_setup_tx;
+		}
+		rc = ena_setup_tx_resources_in_range(adapter,
+						     0,
+						     adapter->num_io_queues);
 		if (rc)
 			goto err_setup_tx;
 
-		rc = ena_create_all_io_tx_queues(adapter);
+		rc = ena_create_io_tx_queues_in_range(adapter,
+						      0,
+						      adapter->num_io_queues);
 		if (rc)
 			goto err_create_tx_queues;
 
@@ -1994,10 +2514,11 @@ err_setup_tx:
 
 static int ena_up(struct ena_adapter *adapter)
 {
-	int rc, i;
+	int io_queue_count, rc, i;
 
 	netdev_dbg(adapter->netdev, "%s\n", __func__);
 
+	io_queue_count = adapter->num_io_queues + adapter->xdp_num_queues;
 	ena_setup_io_intr(adapter);
 
 	/* napi poll functions should be initialized before running
@@ -2005,7 +2526,7 @@ static int ena_up(struct ena_adapter *adapter)
 	 * interrupt, causing the ISR to fire immediately while the poll
 	 * function wasn't set yet, causing a null dereference
 	 */
-	ena_init_napi(adapter);
+	ena_init_napi_in_range(adapter, 0, io_queue_count);
 
 	rc = ena_request_io_irq(adapter);
 	if (rc)
@@ -2036,7 +2557,7 @@ static int ena_up(struct ena_adapter *adapter)
 	/* schedule napi in case we had pending packets
 	 * from the last time we disable napi
 	 */
-	for (i = 0; i < adapter->num_io_queues; i++)
+	for (i = 0; i < io_queue_count; i++)
 		napi_schedule(&adapter->ena_napi[i].napi);
 
 	return rc;
@@ -2049,13 +2570,15 @@ err_up:
 err_create_queues_with_backoff:
 	ena_free_io_irq(adapter);
 err_req_irq:
-	ena_del_napi(adapter);
+	ena_del_napi_in_range(adapter, 0, io_queue_count);
 
 	return rc;
 }
 
 static void ena_down(struct ena_adapter *adapter)
 {
+	int io_queue_count = adapter->num_io_queues + adapter->xdp_num_queues;
+
 	netif_info(adapter, ifdown, adapter->netdev, "%s\n", __func__);
 
 	clear_bit(ENA_FLAG_DEV_UP, &adapter->flags);
@@ -2068,7 +2591,7 @@ static void ena_down(struct ena_adapter *adapter)
 	netif_tx_disable(adapter->netdev);
 
 	/* After this point the napi handler won't enable the tx queue */
-	ena_napi_disable_all(adapter);
+	ena_napi_disable_in_range(adapter, 0, io_queue_count);
 
 	/* After destroy the queue there won't be any new interrupts */
 
@@ -2086,7 +2609,7 @@ static void ena_down(struct ena_adapter *adapter)
 
 	ena_disable_io_intr_sync(adapter);
 	ena_free_io_irq(adapter);
-	ena_del_napi(adapter);
+	ena_del_napi_in_range(adapter, 0, io_queue_count);
 
 	ena_free_all_tx_bufs(adapter);
 	ena_free_all_rx_bufs(adapter);
@@ -2176,23 +2699,47 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
 	ena_close(adapter->netdev);
 	adapter->requested_tx_ring_size = new_tx_size;
 	adapter->requested_rx_ring_size = new_rx_size;
-	ena_init_io_rings(adapter);
+	ena_init_io_rings(adapter,
+			  0,
+			  adapter->xdp_num_queues +
+			  adapter->num_io_queues);
 	return dev_was_up ? ena_up(adapter) : 0;
 }
 
 int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count)
 {
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
+	int prev_channel_count;
 	bool dev_was_up;
 
 	dev_was_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
 	ena_close(adapter->netdev);
+	prev_channel_count = adapter->num_io_queues;
 	adapter->num_io_queues = new_channel_count;
+	if (ena_xdp_present(adapter) &&
+	    ena_xdp_allowed(adapter) == ENA_XDP_ALLOWED) {
+		adapter->xdp_first_ring = new_channel_count;
+		adapter->xdp_num_queues = new_channel_count;
+		if (prev_channel_count > new_channel_count)
+			ena_xdp_exchange_program_rx_in_range(adapter,
+							     NULL,
+							     new_channel_count,
+							     prev_channel_count);
+		else
+			ena_xdp_exchange_program_rx_in_range(adapter,
+							     adapter->xdp_bpf_prog,
+							     prev_channel_count,
+							     new_channel_count);
+	}
+
 	/* We need to destroy the rss table so that the indirection
 	 * table will be reinitialized by ena_up()
 	 */
 	ena_com_rss_destroy(ena_dev);
-	ena_init_io_rings(adapter);
+	ena_init_io_rings(adapter,
+			  0,
+			  adapter->xdp_num_queues +
+			  adapter->num_io_queues);
 	return dev_was_up ? ena_open(adapter->netdev) : 0;
 }
 
@@ -2376,7 +2923,7 @@ error_report_dma_error:
 	tx_info->skb = NULL;
 
 	tx_info->num_of_bufs += i;
-	ena_unmap_tx_skb(tx_ring, tx_info);
+	ena_unmap_tx_buff(tx_ring, tx_info);
 
 	return -EINVAL;
 }
@@ -2391,7 +2938,7 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netdev_queue *txq;
 	void *push_hdr;
 	u16 next_to_use, req_id, header_len;
-	int qid, rc, nb_hw_desc;
+	int qid, rc;
 
 	netif_dbg(adapter, tx_queued, dev, "%s skb %p\n", __func__, skb);
 	/*  Determine which tx ring we will be placed on */
@@ -2426,50 +2973,17 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* set flags and meta data */
 	ena_tx_csum(&ena_tx_ctx, skb);
 
-	if (unlikely(ena_com_is_doorbell_needed(tx_ring->ena_com_io_sq, &ena_tx_ctx))) {
-		netif_dbg(adapter, tx_queued, dev,
-			  "llq tx max burst size of queue %d achieved, writing doorbell to send burst\n",
-			  qid);
-		ena_com_write_sq_doorbell(tx_ring->ena_com_io_sq);
-	}
-
-	/* prepare the packet's descriptors to dma engine */
-	rc = ena_com_prepare_tx(tx_ring->ena_com_io_sq, &ena_tx_ctx,
-				&nb_hw_desc);
-
-	/* ena_com_prepare_tx() can't fail due to overflow of tx queue,
-	 * since the number of free descriptors in the queue is checked
-	 * after sending the previous packet. In case there isn't enough
-	 * space in the queue for the next packet, it is stopped
-	 * until there is again enough available space in the queue.
-	 * All other failure reasons of ena_com_prepare_tx() are fatal
-	 * and therefore require a device reset.
-	 */
-	if (unlikely(rc)) {
-		netif_err(adapter, tx_queued, dev,
-			  "failed to prepare tx bufs\n");
-		u64_stats_update_begin(&tx_ring->syncp);
-		tx_ring->tx_stats.prepare_ctx_err++;
-		u64_stats_update_end(&tx_ring->syncp);
-		adapter->reset_reason = ENA_REGS_RESET_DRIVER_INVALID_STATE;
-		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
+	rc = ena_xmit_common(dev,
+			     tx_ring,
+			     tx_info,
+			     &ena_tx_ctx,
+			     next_to_use,
+			     skb->len);
+	if (rc)
 		goto error_unmap_dma;
-	}
 
 	netdev_tx_sent_queue(txq, skb->len);
 
-	u64_stats_update_begin(&tx_ring->syncp);
-	tx_ring->tx_stats.cnt++;
-	tx_ring->tx_stats.bytes += skb->len;
-	u64_stats_update_end(&tx_ring->syncp);
-
-	tx_info->tx_descs = nb_hw_desc;
-	tx_info->last_jiffies = jiffies;
-	tx_info->print_once = 0;
-
-	tx_ring->next_to_use = ENA_TX_RING_IDX_NEXT(next_to_use,
-		tx_ring->ring_size);
-
 	/* stop the queue when no more space available, the packet can have up
 	 * to sgl_size + 2. one for the meta descriptor and one for header
 	 * (if the header is larger than tx_max_header_size).
@@ -2516,7 +3030,7 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 error_unmap_dma:
-	ena_unmap_tx_skb(tx_ring, tx_info);
+	ena_unmap_tx_buff(tx_ring, tx_info);
 	tx_info->skb = NULL;
 
 error_drop_packet:
@@ -3075,7 +3589,9 @@ static void check_for_missing_completions(struct ena_adapter *adapter)
 	struct ena_ring *tx_ring;
 	struct ena_ring *rx_ring;
 	int i, budget, rc;
+	int io_queue_count;
 
+	io_queue_count = adapter->xdp_num_queues + adapter->num_io_queues;
 	/* Make sure the driver doesn't turn the device in other process */
 	smp_rmb();
 
@@ -3090,7 +3606,7 @@ static void check_for_missing_completions(struct ena_adapter *adapter)
 
 	budget = ENA_MONITORED_TX_QUEUES;
 
-	for (i = adapter->last_monitored_tx_qid; i < adapter->num_io_queues; i++) {
+	for (i = adapter->last_monitored_tx_qid; i < io_queue_count; i++) {
 		tx_ring = &adapter->tx_ring[i];
 		rx_ring = &adapter->rx_ring[i];
 
@@ -3098,7 +3614,8 @@ static void check_for_missing_completions(struct ena_adapter *adapter)
 		if (unlikely(rc))
 			return;
 
-		rc = check_for_rx_interrupt_queue(adapter, rx_ring);
+		rc =  !ENA_IS_XDP_INDEX(adapter, i) ?
+			check_for_rx_interrupt_queue(adapter, rx_ring) : 0;
 		if (unlikely(rc))
 			return;
 
@@ -3107,7 +3624,7 @@ static void check_for_missing_completions(struct ena_adapter *adapter)
 			break;
 	}
 
-	adapter->last_monitored_tx_qid = i % adapter->num_io_queues;
+	adapter->last_monitored_tx_qid = i % io_queue_count;
 }
 
 /* trigger napi schedule after 2 consecutive detections */
@@ -3684,6 +4201,9 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->num_io_queues = max_num_io_queues;
 	adapter->max_num_io_queues = max_num_io_queues;
 
+	adapter->xdp_first_ring = 0;
+	adapter->xdp_num_queues = 0;
+
 	adapter->last_monitored_tx_qid = 0;
 
 	adapter->rx_copybreak = ENA_DEFAULT_RX_COPYBREAK;
@@ -3697,7 +4217,10 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			"Failed to query interrupt moderation feature\n");
 		goto err_netdev_destroy;
 	}
-	ena_init_io_rings(adapter);
+	ena_init_io_rings(adapter,
+			  0,
+			  adapter->xdp_num_queues +
+			  adapter->num_io_queues);
 
 	netdev->netdev_ops = &ena_netdev_ops;
 	netdev->watchdog_timeo = TX_TIMEOUT;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index e0dd7dbb6..504aab9af 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -152,6 +152,9 @@
 #define ENA_XDP_MAX_MTU (ENA_PAGE_SIZE - ETH_HLEN - ETH_FCS_LEN - \
 				VLAN_HLEN - XDP_PACKET_HEADROOM)
 
+#define ENA_IS_XDP_INDEX(adapter, index) (((index) >= (adapter)->xdp_first_ring) && \
+	((index) < (adapter)->xdp_first_ring + (adapter)->xdp_num_queues))
+
 struct ena_irq {
 	irq_handler_t handler;
 	void *data;
@@ -165,6 +168,7 @@ struct ena_napi {
 	struct napi_struct napi ____cacheline_aligned;
 	struct ena_ring *tx_ring;
 	struct ena_ring *rx_ring;
+	struct ena_ring *xdp_ring;
 	u32 qid;
 	struct dim dim;
 };
@@ -190,6 +194,17 @@ struct ena_tx_buffer {
 	/* num of buffers used by this skb */
 	u32 num_of_bufs;
 
+	/* XDP buffer structure which is used for sending packets in
+	 * the xdp queues
+	 */
+	struct xdp_buff *xdp;
+	/* The rx page for the rx buffer that was received in rx and
+	 * re transmitted on xdp tx queues as a result of XDP_TX action.
+	 * We need to free the page once we finished cleaning the buffer in
+	 * clean_xdp_irq()
+	 */
+	struct page *xdp_rx_page;
+
 	/* Indicate if bufs[0] map the linear data of the skb. */
 	u8 map_linear_data;
 
@@ -393,6 +408,8 @@ struct ena_adapter {
 	enum ena_regs_reset_reason_types reset_reason;
 
 	struct bpf_prog *xdp_bpf_prog;
+	u32 xdp_first_ring;
+	u32 xdp_num_queues;
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev);
@@ -409,6 +426,17 @@ int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count);
 
 int ena_get_sset_count(struct net_device *netdev, int sset);
 
+enum ena_xdp_errors_t {
+	ENA_XDP_ALLOWED = 0,
+	ENA_XDP_CURRENT_MTU_TOO_LARGE,
+	ENA_XDP_NO_ENOUGH_QUEUES,
+};
+
+static inline bool ena_xdp_queues_present(struct ena_adapter *adapter)
+{
+	return adapter->xdp_first_ring != 0;
+}
+
 static inline bool ena_xdp_present(struct ena_adapter *adapter)
 {
 	return !!adapter->xdp_bpf_prog;
@@ -419,9 +447,22 @@ static inline bool ena_xdp_present_ring(struct ena_ring *ring)
 	return !!ring->xdp_bpf_prog;
 }
 
-static inline bool ena_xdp_allowed(struct ena_adapter *adapter)
+static inline int ena_xdp_legal_queue_count(struct ena_adapter *adapter,
+					    u32 queues)
 {
-	return adapter->netdev->mtu <= ENA_XDP_MAX_MTU;
+	return 2 * queues <= adapter->max_num_io_queues;
+}
+
+static inline enum ena_xdp_errors_t ena_xdp_allowed(struct ena_adapter *adapter)
+{
+	enum ena_xdp_errors_t rc = ENA_XDP_ALLOWED;
+
+	if (adapter->netdev->mtu > ENA_XDP_MAX_MTU)
+		rc = ENA_XDP_CURRENT_MTU_TOO_LARGE;
+	else if (!ena_xdp_legal_queue_count(adapter, adapter->num_io_queues))
+		rc = ENA_XDP_NO_ENOUGH_QUEUES;
+
+	return rc;
 }
 
 #endif /* !(ENA_H) */
-- 
2.17.1

