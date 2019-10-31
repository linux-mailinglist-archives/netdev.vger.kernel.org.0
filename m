Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF6BEB4C5
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfJaQfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:35:53 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:19398 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfJaQfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1572539752; x=1604075752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=gwOo77XwgQRwQW3SEYkkI31NDh8ENCjBNVAt4TAmNLI=;
  b=YpvZeiEIgFGXLooHg94HOrQpiy5pkS/IpaqVLQXVSLy5DCfiwwNnp/zz
   8clWK/Kd7XnxXGht/5SvkbCLfe8rCdnkO1uB21nO63E96Hv1pQiu7FzqU
   x7FkQUifgsLs7LUPiC4Qis8yVIBMCZIsQ2iMbt/lOz5/t+0wzXQbnrgMr
   w=;
IronPort-SDR: ACBdJ0N9wFvVBj2baNoBSiMXM9qCfooBAvh4RQxIf180KEOiOVpop2Dsz3xBaRmC8Verz32zmW
 4rTJ66qMt3UQ==
X-IronPort-AV: E=Sophos;i="5.68,252,1569283200"; 
   d="scan'208";a="2701017"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 31 Oct 2019 16:35:50 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 43B96A2E3A;
        Thu, 31 Oct 2019 16:35:48 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 31 Oct 2019 16:35:48 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 31 Oct 2019 16:35:48 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 31 Oct 2019 16:35:45 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [RFC V2 net-next v2 1/3] net: ena: implement XDP drop support
Date:   Thu, 31 Oct 2019 18:35:37 +0200
Message-ID: <20191031163539.12539-2-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191031163539.12539-1-sameehj@amazon.com>
References: <20191031163539.12539-1-sameehj@amazon.com>
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
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 132 +++++++++++++++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  29 ++++
 2 files changed, 152 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d46a91200..f3f042031 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -33,10 +33,10 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #ifdef CONFIG_RFS_ACCEL
+#include <linux/bpf_trace.h>
 #include <linux/cpu_rmap.h>
 #endif /* CONFIG_RFS_ACCEL */
 #include <linux/ethtool.h>
-#include <linux/if_vlan.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/numa.h>
@@ -105,6 +105,79 @@ static void update_rx_ring_mtu(struct ena_adapter *adapter, int mtu)
 		adapter->rx_ring[i].mtu = mtu;
 }
 
+static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
+{
+	struct bpf_prog *xdp_prog = rx_ring->xdp_bpf_prog;
+	u32 verdict = XDP_PASS;
+
+	rcu_read_lock();
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
+		netif_err(adapter, drv, adapter->netdev, "Failed to set xdp program, the current MTU (%d) is larger than the maximal allowed MTU (%lu) while xdp is on",
+			  netdev->mtu, ENA_XDP_MAX_MTU);
+		NL_SET_ERR_MSG_MOD(bpf->extack, "Failed to set xdp program, the current MTU is larger than the maximal allowed MTU. Check the dmesg for more info");
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
 static int ena_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct ena_adapter *adapter = netdev_priv(dev);
@@ -417,6 +490,9 @@ static void ena_free_rx_resources(struct ena_adapter *adapter,
 
 	vfree(rx_ring->free_ids);
 	rx_ring->free_ids = NULL;
+
+	xdp_rxq_info_unreg_mem_model(&rx_ring->xdp_rxq);
+	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 }
 
 /* ena_setup_all_rx_resources - allocate I/O Rx queues resources for all queues
@@ -1051,13 +1127,16 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	u32 res_budget, work_done;
 
 	struct ena_com_rx_ctx ena_rx_ctx;
+	struct ena_rx_buffer *rx_info;
 	struct ena_adapter *adapter;
-	struct sk_buff *skb;
+	int xdp_verdict = XDP_PASS;
+	struct sk_buff *skb = NULL;
 	int refill_required;
 	int refill_threshold;
-	int rc = 0;
-	int total_len = 0;
+	struct xdp_buff xdp;
 	int rx_copybreak_pkt = 0;
+	int total_len = 0;
+	int rc = 0;
 	int i;
 
 	netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
@@ -1082,12 +1161,24 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 			  rx_ring->qid, ena_rx_ctx.descs, ena_rx_ctx.l3_proto,
 			  ena_rx_ctx.l4_proto, ena_rx_ctx.hash);
 
+		if (ena_xdp_present_ring(rx_ring)) {
+			rx_info = &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
+			xdp.data = page_address(rx_info->page) +
+				rx_info->page_offset;
+			xdp.data_meta = xdp.data;
+			xdp.data_hard_start = xdp.data -
+				rx_info->page_offset;
+			xdp.data_end = xdp.data + rx_ring->ena_bufs[0].len;
+			xdp_verdict = ena_xdp_execute(rx_ring, &xdp);
+		}
+
 		/* allocate skb and fill it */
-		skb = ena_rx_skb(rx_ring, rx_ring->ena_bufs, ena_rx_ctx.descs,
-				 &next_to_clean);
+		if (xdp_verdict == XDP_PASS)
+			skb = ena_rx_skb(rx_ring, rx_ring->ena_bufs,
+					 ena_rx_ctx.descs, &next_to_clean);
 
 		/* exit if we failed to retrieve a buffer */
-		if (unlikely(!skb)) {
+		if (!skb) {
 			for (i = 0; i < ena_rx_ctx.descs; i++) {
 				rx_ring->free_ids[next_to_clean] =
 					rx_ring->ena_bufs[i].req_id;
@@ -1727,12 +1818,34 @@ static int ena_create_io_rx_queue(struct ena_adapter *adapter, int qid)
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
 
@@ -2568,6 +2681,7 @@ static const struct net_device_ops ena_netdev_ops = {
 	.ndo_change_mtu		= ena_change_mtu,
 	.ndo_set_mac_address	= NULL,
 	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_bpf		= ena_xdp,
 };
 
 static int ena_device_validate_params(struct ena_adapter *adapter,
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index bffd778f2..baaeeeeb0 100644
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
@@ -142,6 +143,14 @@
 
 #define ENA_MMIO_DISABLE_REG_READ	BIT(0)
 
+/* The max MTU size is configured to be the ethernet frame without the overhead
+ * of the ethernet header, which can have VLAN header, and the frame check
+ * sequence (FCS).
+ * The buffer sizes we share with the device are defined to be ENA_PAGE_SIZE
+ */
+#define ENA_XDP_MAX_MTU (ENA_PAGE_SIZE - ETH_HLEN - ETH_FCS_LEN - \
+				VLAN_HLEN - XDP_PACKET_HEADROOM)
+
 struct ena_irq {
 	irq_handler_t handler;
 	void *data;
@@ -291,6 +300,8 @@ struct ena_ring {
 
 	u8 *push_buf_intermediate_buf;
 	int empty_rx_queue;
+	struct bpf_prog *xdp_bpf_prog;
+	struct xdp_rxq_info xdp_rxq;
 } ____cacheline_aligned;
 
 struct ena_stats_dev {
@@ -379,6 +390,9 @@ struct ena_adapter {
 	u32 last_monitored_tx_qid;
 
 	enum ena_regs_reset_reason_types reset_reason;
+
+	/* XDP structures */
+	struct bpf_prog *xdp_bpf_prog;
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev);
@@ -394,4 +408,19 @@ int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count);
 
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

