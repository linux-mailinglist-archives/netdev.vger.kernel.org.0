Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B1B10CC60
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 17:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfK1QCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 11:02:05 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:25451 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfK1QCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 11:02:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1574956921; x=1606492921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=sFhRIxOVSh+VaSPMV/I28t1zI8oj53gPdj70cOaCbdk=;
  b=ciqeox5WZ2TjrPHmNPRR3g28wrLEyOtXPzye+UvAFPpr2x+MSIypNdE4
   wraQWYQVAmNveWZGe/QpH/iXdhZrKn/p72BWgLqf3Jp7rTx9AX/n8Wfx3
   4+GBdgqFhjESNLIxUQKxro6LuoRi+QmNy0fbuCWrO/9VYRZ/u18XNII+I
   4=;
IronPort-SDR: CFqxZQWFnJP9upV3WIc8DzZ4sENKLENKmAXvpe76clWpRqNQ7TvNGA29T1/0gsx7kc7SYKmIeB
 0iZiHYGifd4w==
X-IronPort-AV: E=Sophos;i="5.69,253,1571702400"; 
   d="scan'208";a="6763622"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 28 Nov 2019 16:02:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 8C0D2A2BB4;
        Thu, 28 Nov 2019 16:01:59 +0000 (UTC)
Received: from EX13D10UWB003.ant.amazon.com (10.43.161.106) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 28 Nov 2019 16:01:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB003.ant.amazon.com (10.43.161.106) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 28 Nov 2019 16:01:56 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 28 Nov 2019 16:01:52 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net-next v3 1/3] net: ena: implement XDP drop support
Date:   Thu, 28 Nov 2019 18:01:44 +0200
Message-ID: <20191128160146.16109-2-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128160146.16109-1-sameehj@amazon.com>
References: <20191128160146.16109-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This commit implements the basic functionality of drop/pass logic in the
ena driver.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 213 ++++++++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  31 +++
 2 files changed, 233 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d46a91200..81fe37829 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -36,7 +36,6 @@
 #include <linux/cpu_rmap.h>
 #endif /* CONFIG_RFS_ACCEL */
 #include <linux/ethtool.h>
-#include <linux/if_vlan.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/numa.h>
@@ -47,6 +46,7 @@
 #include <net/ip.h>
 
 #include "ena_netdev.h"
+#include <linux/bpf_trace.h>
 #include "ena_pci_id_tbl.h"
 
 static char version[] = DEVICE_NAME " v" DRV_MODULE_VERSION "\n";
@@ -77,6 +77,8 @@ static int ena_rss_init_default(struct ena_adapter *adapter);
 static void check_for_admin_com_state(struct ena_adapter *adapter);
 static void ena_destroy_device(struct ena_adapter *adapter, bool graceful);
 static int ena_restore_device(struct ena_adapter *adapter);
+static void ena_down(struct ena_adapter *adapter);
+static int ena_up(struct ena_adapter *adapter);
 
 static void ena_tx_timeout(struct net_device *dev)
 {
@@ -123,6 +125,115 @@ static int ena_change_mtu(struct net_device *dev, int new_mtu)
 	return ret;
 }
 
+static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
+{
+	struct bpf_prog *xdp_prog;
+	u32 verdict = XDP_PASS;
+
+	rcu_read_lock();
+	xdp_prog = READ_ONCE(rx_ring->xdp_bpf_prog);
+
+	if (!xdp_prog)
+		goto out;
+
+	verdict = bpf_prog_run_xdp(xdp_prog, xdp);
+
+	if (unlikely(verdict == XDP_ABORTED))
+		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
+	else if (unlikely(verdict >= XDP_TX))
+		bpf_warn_invalid_xdp_action(verdict);
+out:
+	rcu_read_unlock();
+	return verdict;
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
+			rx_ring->rx_headroom = XDP_PACKET_HEADROOM;
+		else
+			rx_ring->rx_headroom = 0;
+	}
+}
+
+void ena_xdp_exchange_program(struct ena_adapter *adapter,
+			      struct bpf_prog *prog)
+{
+	struct bpf_prog *old_bpf_prog = xchg(&adapter->xdp_bpf_prog, prog);
+
+	ena_xdp_exchange_program_rx_in_range(adapter,
+					     prog,
+					     0,
+					     adapter->num_io_queues);
+
+	if (old_bpf_prog)
+		bpf_prog_put(old_bpf_prog);
+}
+
+static int ena_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+	struct bpf_prog *prog = bpf->prog;
+	int rc, prev_mtu;
+	bool is_up;
+
+	is_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
+
+	if (ena_xdp_allowed(adapter)) {
+		if (is_up)
+			ena_down(adapter);
+
+		ena_xdp_exchange_program(adapter, prog);
+
+		prev_mtu = netdev->max_mtu;
+		netdev->max_mtu = prog ? ENA_XDP_MAX_MTU : adapter->max_mtu;
+		if (is_up) {
+			rc = ena_up(adapter);
+			if (rc)
+				return rc;
+		}
+		netif_info(adapter, drv, adapter->netdev, "xdp program set, changging the max_mtu from %d to %d",
+			   prev_mtu, netdev->max_mtu);
+
+	} else {
+		netif_err(adapter, drv, adapter->netdev, "Failed to set xdp program, the current MTU (%d) is larger than the maximum allowed MTU (%lu) while xdp is on",
+			  netdev->mtu, ENA_XDP_MAX_MTU);
+		NL_SET_ERR_MSG_MOD(bpf->extack, "Failed to set xdp program, the current MTU is larger than the maximum allowed MTU. Check the dmesg for more info");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* This is the main xdp callback, it's used by the kernel to set/unset the xdp
+ * program as well as to query the current xdp program id.
+ */
+static int ena_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		return ena_xdp_set(netdev, bpf);
+	case XDP_QUERY_PROG:
+		bpf->prog_id = adapter->xdp_bpf_prog ?
+			adapter->xdp_bpf_prog->aux->id : 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int ena_init_rx_cpu_rmap(struct ena_adapter *adapter)
 {
 #ifdef CONFIG_RFS_ACCEL
@@ -417,6 +528,9 @@ static void ena_free_rx_resources(struct ena_adapter *adapter,
 
 	vfree(rx_ring->free_ids);
 	rx_ring->free_ids = NULL;
+
+	xdp_rxq_info_unreg_mem_model(&rx_ring->xdp_rxq);
+	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 }
 
 /* ena_setup_all_rx_resources - allocate I/O Rx queues resources for all queues
@@ -495,7 +609,7 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 	rx_info->page = page;
 	rx_info->page_offset = 0;
 	ena_buf = &rx_info->ena_buf;
-	ena_buf->paddr = dma;
+	ena_buf->paddr = dma + rx_ring->rx_headroom;
 	ena_buf->len = ENA_PAGE_SIZE;
 
 	return 0;
@@ -1037,6 +1151,33 @@ static void ena_set_rx_hash(struct ena_ring *rx_ring,
 	}
 }
 
+int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
+{
+	struct ena_rx_buffer *rx_info;
+	int ret;
+
+	rx_info = &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
+	xdp->data = page_address(rx_info->page) +
+		rx_info->page_offset + rx_ring->rx_headroom;
+	xdp_set_data_meta_invalid(xdp);
+	xdp->data_hard_start = page_address(rx_info->page);
+	xdp->data_end = xdp->data + rx_ring->ena_bufs[0].len;
+	/* If for some reason we received a bigger packet than
+	 * we expect, then we simply drop it
+	 */
+	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
+		return XDP_DROP;
+
+	ret = ena_xdp_execute(rx_ring, xdp);
+
+	/* The xdp program might expand the headers */
+	if (ret == XDP_PASS) {
+		rx_info->page_offset = xdp->data - xdp->data_hard_start;
+		rx_ring->ena_bufs[0].len = xdp->data_end - xdp->data;
+	}
+
+	return ret;
+}
 /* ena_clean_rx_irq - Cleanup RX irq
  * @rx_ring: RX ring to clean
  * @napi: napi handler
@@ -1052,19 +1193,23 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 
 	struct ena_com_rx_ctx ena_rx_ctx;
 	struct ena_adapter *adapter;
+	int rx_copybreak_pkt = 0;
+	int refill_threshold;
 	struct sk_buff *skb;
 	int refill_required;
-	int refill_threshold;
-	int rc = 0;
+	struct xdp_buff xdp;
 	int total_len = 0;
-	int rx_copybreak_pkt = 0;
+	int xdp_verdict;
+	int rc = 0;
 	int i;
 
 	netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 		  "%s qid %d\n", __func__, rx_ring->qid);
 	res_budget = budget;
-
+	xdp.rxq = &rx_ring->xdp_rxq;
 	do {
+		xdp_verdict = XDP_PASS;
+		skb = NULL;
 		ena_rx_ctx.ena_bufs = rx_ring->ena_bufs;
 		ena_rx_ctx.max_bufs = rx_ring->sgl_size;
 		ena_rx_ctx.descs = 0;
@@ -1082,11 +1227,16 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 			  rx_ring->qid, ena_rx_ctx.descs, ena_rx_ctx.l3_proto,
 			  ena_rx_ctx.l4_proto, ena_rx_ctx.hash);
 
+		if (ena_xdp_present_ring(rx_ring))
+			xdp_verdict = ena_xdp_handle_buff(rx_ring, &xdp);
+
 		/* allocate skb and fill it */
-		skb = ena_rx_skb(rx_ring, rx_ring->ena_bufs, ena_rx_ctx.descs,
-				 &next_to_clean);
+		if (xdp_verdict == XDP_PASS)
+			skb = ena_rx_skb(rx_ring,
+					 rx_ring->ena_bufs,
+					 ena_rx_ctx.descs,
+					 &next_to_clean);
 
-		/* exit if we failed to retrieve a buffer */
 		if (unlikely(!skb)) {
 			for (i = 0; i < ena_rx_ctx.descs; i++) {
 				rx_ring->free_ids[next_to_clean] =
@@ -1095,6 +1245,8 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 					ENA_RX_RING_IDX_NEXT(next_to_clean,
 							     rx_ring->ring_size);
 			}
+			if (xdp_verdict == XDP_DROP)
+				continue;
 			break;
 		}
 
@@ -1727,12 +1879,34 @@ static int ena_create_io_rx_queue(struct ena_adapter *adapter, int qid)
 		netif_err(adapter, ifup, adapter->netdev,
 			  "Failed to get RX queue handlers. RX queue num %d rc: %d\n",
 			  qid, rc);
-		ena_com_destroy_io_queue(ena_dev, ena_qid);
-		return rc;
+		goto err;
 	}
 
 	ena_com_update_numa_node(rx_ring->ena_com_io_cq, ctx.numa_node);
 
+	rc = xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev, qid);
+
+	if (rc) {
+		netif_err(adapter, ifup, adapter->netdev,
+			  "Failed to register xdp rx queue info. RX queue num %d rc: %d\n",
+			  qid, rc);
+		goto err;
+	}
+
+	rc = xdp_rxq_info_reg_mem_model(&rx_ring->xdp_rxq, MEM_TYPE_PAGE_SHARED,
+					NULL);
+
+	if (rc) {
+		netif_err(adapter, ifup, adapter->netdev,
+			  "Failed to register xdp rx queue info memory model. RX queue num %d rc: %d\n",
+			  qid, rc);
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+		goto err;
+	}
+
+	return rc;
+err:
+	ena_com_destroy_io_queue(ena_dev, ena_qid);
 	return rc;
 }
 
@@ -2056,11 +2230,27 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
 int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count)
 {
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
+	int prev_channel_count;
 	bool dev_was_up;
 
 	dev_was_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
 	ena_close(adapter->netdev);
+	prev_channel_count = adapter->num_io_queues;
 	adapter->num_io_queues = new_channel_count;
+
+	if (ena_xdp_present(adapter) && ena_xdp_allowed(adapter)) {
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
@@ -2568,6 +2758,7 @@ static const struct net_device_ops ena_netdev_ops = {
 	.ndo_change_mtu		= ena_change_mtu,
 	.ndo_set_mac_address	= NULL,
 	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_bpf		= ena_xdp,
 };
 
 static int ena_device_validate_params(struct ena_adapter *adapter,
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index bffd778f2..c9016014b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -36,6 +36,7 @@
 #include <linux/bitops.h>
 #include <linux/dim.h>
 #include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/inetdevice.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
@@ -142,6 +143,15 @@
 
 #define ENA_MMIO_DISABLE_REG_READ	BIT(0)
 
+/* The max MTU size is configured to be the ethernet frame size without
+ * the overhead of the ethernet header, which can have a VLAN header, and
+ * a frame check sequence (FCS).
+ * The buffer size we share with the device is defined to be ENA_PAGE_SIZE
+ */
+
+#define ENA_XDP_MAX_MTU (ENA_PAGE_SIZE - ETH_HLEN - ETH_FCS_LEN - \
+				VLAN_HLEN - XDP_PACKET_HEADROOM)
+
 struct ena_irq {
 	irq_handler_t handler;
 	void *data;
@@ -258,10 +268,13 @@ struct ena_ring {
 	struct ena_adapter *adapter;
 	struct ena_com_io_cq *ena_com_io_cq;
 	struct ena_com_io_sq *ena_com_io_sq;
+	struct bpf_prog *xdp_bpf_prog;
+	struct xdp_rxq_info xdp_rxq;
 
 	u16 next_to_use;
 	u16 next_to_clean;
 	u16 rx_copybreak;
+	u16 rx_headroom;
 	u16 qid;
 	u16 mtu;
 	u16 sgl_size;
@@ -379,6 +392,8 @@ struct ena_adapter {
 	u32 last_monitored_tx_qid;
 
 	enum ena_regs_reset_reason_types reset_reason;
+
+	struct bpf_prog *xdp_bpf_prog;
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev);
@@ -390,8 +405,24 @@ void ena_dump_stats_to_buf(struct ena_adapter *adapter, u8 *buf);
 int ena_update_queue_sizes(struct ena_adapter *adapter,
 			   u32 new_tx_size,
 			   u32 new_rx_size);
+
 int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count);
 
 int ena_get_sset_count(struct net_device *netdev, int sset);
 
+static inline bool ena_xdp_present(struct ena_adapter *adapter)
+{
+	return !!adapter->xdp_bpf_prog;
+}
+
+static inline bool ena_xdp_present_ring(struct ena_ring *ring)
+{
+	return !!ring->xdp_bpf_prog;
+}
+
+static inline bool ena_xdp_allowed(struct ena_adapter *adapter)
+{
+	return adapter->netdev->mtu <= ENA_XDP_MAX_MTU;
+}
+
 #endif /* !(ENA_H) */
-- 
2.17.1

