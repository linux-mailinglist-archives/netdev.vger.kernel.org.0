Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4092B102578
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfKSNel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:34:41 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:49231 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSNek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:34:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1574170479; x=1605706479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=i20KQklNtch1tb/xgg3B4Kv9SxQJGnOOR4dhKtUFkjw=;
  b=ZXeKm2njJaAoz1Qjy9n11US5NMoJURPsenhkG4FEwKRnx62giTqEPSOh
   UOjIQdFZfftSlWddwMW8pI+bBXJKgPzRhxMIfScXEwqjEsjOD4EWnF2N1
   G2Hk8q0IpfZtBlyPmGWon+sATgF/fHiYq5jbjFehK2EH8++f2ZQ2XM/WF
   E=;
IronPort-SDR: IrOY/GeFj5HSILoyPhSj2QvOwXmhyGSIqW8xBLF3EALBERBbo5vDIV/QPkuC9QbTmt6+InOmKv
 qD2mMQ0cEcRA==
X-IronPort-AV: E=Sophos;i="5.68,324,1569283200"; 
   d="scan'208";a="4719962"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 19 Nov 2019 13:34:38 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 78F1BA1E19;
        Tue, 19 Nov 2019 13:34:36 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 19 Nov 2019 13:34:36 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 19 Nov 2019 13:34:35 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 19 Nov 2019 13:34:33 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next v2 1/3] net: ena: implement XDP drop support
Date:   Tue, 19 Nov 2019 15:34:17 +0200
Message-ID: <20191119133419.9734-2-sameehj@amazon.com>
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

This commit implements the basic functionality of drop/pass logic in the
ena driver.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 148 +++++++++++++++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  30 ++++
 2 files changed, 168 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d46a91200..35f766d9c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -35,8 +35,8 @@
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
 #endif /* CONFIG_RFS_ACCEL */
+#include <linux/bpf_trace.h>
 #include <linux/ethtool.h>
-#include <linux/if_vlan.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/numa.h>
@@ -123,6 +123,80 @@ static int ena_change_mtu(struct net_device *dev, int new_mtu)
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
+static int ena_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+	struct bpf_prog *prog = bpf->prog;
+	struct bpf_prog *old_bpf_prog;
+	int i, prev_mtu;
+
+	if (ena_xdp_allowed(adapter)) {
+		old_bpf_prog = xchg(&adapter->xdp_bpf_prog, prog);
+
+		for (i = 0; i < adapter->num_io_queues; i++)
+			xchg(&adapter->rx_ring[i].xdp_bpf_prog, prog);
+
+		if (old_bpf_prog)
+			bpf_prog_put(old_bpf_prog);
+
+		prev_mtu = netdev->max_mtu;
+		netdev->max_mtu = prog ? ENA_XDP_MAX_MTU : adapter->max_mtu;
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
+		NL_SET_ERR_MSG_MOD(bpf->extack, "Unsupported XDP command");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int ena_init_rx_cpu_rmap(struct ena_adapter *adapter)
 {
 #ifdef CONFIG_RFS_ACCEL
@@ -417,6 +491,9 @@ static void ena_free_rx_resources(struct ena_adapter *adapter,
 
 	vfree(rx_ring->free_ids);
 	rx_ring->free_ids = NULL;
+
+	xdp_rxq_info_unreg_mem_model(&rx_ring->xdp_rxq);
+	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 }
 
 /* ena_setup_all_rx_resources - allocate I/O Rx queues resources for all queues
@@ -1037,6 +1114,23 @@ static void ena_set_rx_hash(struct ena_ring *rx_ring,
 	}
 }
 
+int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
+{
+	struct ena_rx_buffer *rx_info =
+		&rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
+	xdp->data = page_address(rx_info->page) +
+		rx_info->page_offset;
+	xdp->data_meta = xdp->data;
+	xdp->data_hard_start = page_address(rx_info->page);
+	xdp->data_end = xdp->data + rx_ring->ena_bufs[0].len;
+	/* If for some reason we received a bigger packet than
+	 * we expect, then we simply drop it
+	 */
+	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
+		return XDP_DROP;
+	else
+		return ena_xdp_execute(rx_ring, xdp);
+}
 /* ena_clean_rx_irq - Cleanup RX irq
  * @rx_ring: RX ring to clean
  * @napi: napi handler
@@ -1052,19 +1146,23 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 
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
@@ -1082,11 +1180,16 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
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
@@ -1095,6 +1198,8 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 					ENA_RX_RING_IDX_NEXT(next_to_clean,
 							     rx_ring->ring_size);
 			}
+			if (xdp_verdict == XDP_DROP)
+				continue;
 			break;
 		}
 
@@ -1727,12 +1832,34 @@ static int ena_create_io_rx_queue(struct ena_adapter *adapter, int qid)
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
 
@@ -2568,6 +2695,7 @@ static const struct net_device_ops ena_netdev_ops = {
 	.ndo_change_mtu		= ena_change_mtu,
 	.ndo_set_mac_address	= NULL,
 	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_bpf		= ena_xdp,
 };
 
 static int ena_device_validate_params(struct ena_adapter *adapter,
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index bffd778f2..e0dd7dbb6 100644
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
@@ -258,6 +268,8 @@ struct ena_ring {
 	struct ena_adapter *adapter;
 	struct ena_com_io_cq *ena_com_io_cq;
 	struct ena_com_io_sq *ena_com_io_sq;
+	struct bpf_prog *xdp_bpf_prog;
+	struct xdp_rxq_info xdp_rxq;
 
 	u16 next_to_use;
 	u16 next_to_clean;
@@ -379,6 +391,8 @@ struct ena_adapter {
 	u32 last_monitored_tx_qid;
 
 	enum ena_regs_reset_reason_types reset_reason;
+
+	struct bpf_prog *xdp_bpf_prog;
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev);
@@ -390,8 +404,24 @@ void ena_dump_stats_to_buf(struct ena_adapter *adapter, u8 *buf);
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

