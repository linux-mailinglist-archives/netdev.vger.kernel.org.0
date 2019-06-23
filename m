Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6804FA95
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 09:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfFWHHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 03:07:08 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:50872 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFWHHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 03:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561273627; x=1592809627;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=aXwuNSj5N6jxn6mQNiuefzyDRLTkBmc+rS8UBhgvXeM=;
  b=iKdc2tNpq5NUb3Ec9KkUUwpItm5S0kC7BDP9Fr0zqRmll0HNSp1bO6cd
   GeACs1VhK5TLyvzHEQknblMHLpjN9JhKM1BC/jo3IoPCfQZrgzNOy0dwa
   OJLGSsLEuZYZnssztlDat2rLwR9PdrcUFrJZxafitQusJq3ymVdypWjAP
   4=;
X-IronPort-AV: E=Sophos;i="5.62,407,1554768000"; 
   d="scan'208";a="807089467"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 23 Jun 2019 07:07:02 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 865A1A227E;
        Sun, 23 Jun 2019 07:07:01 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 23 Jun 2019 07:07:01 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 23 Jun 2019 07:07:00 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 23 Jun 2019 07:06:58 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [RFC V1 net-next 1/1] net: ena: implement XDP drop support
Date:   Sun, 23 Jun 2019 10:06:49 +0300
Message-ID: <20190623070649.18447-2-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190623070649.18447-1-sameehj@amazon.com>
References: <20190623070649.18447-1-sameehj@amazon.com>
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
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 83 +++++++++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 29 +++++++
 2 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 20ec8ff03..3d65c0771 100644
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
@@ -105,11 +105,82 @@ static void update_rx_ring_mtu(struct ena_adapter *adapter, int mtu)
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
+	else if (unlikely(verdict > XDP_REDIRECT))
+		bpf_warn_invalid_xdp_action(verdict);
+out:
+	rcu_read_unlock();
+	return verdict;
+}
+
+static int ena_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+	struct bpf_prog *old_bpf_prog;
+	int i;
+
+	if (ena_xdp_allowed(adapter)) {
+		old_bpf_prog = xchg(&adapter->xdp_bpf_prog, prog);
+
+		for (i = 0; i < adapter->num_queues; i++)
+			xchg(&adapter->rx_ring[i].xdp_bpf_prog, prog);
+
+		if (old_bpf_prog)
+			bpf_prog_put(old_bpf_prog);
+
+	} else {
+		netif_err(adapter, drv, adapter->netdev, "Failed to set xdp program, the current MTU (%d) is larger than the maximal allowed MTU (%lu) while xdp is on",
+			  netdev->mtu, ENA_XDP_MAX_MTU);
+		return -EFAULT;
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
+		return ena_xdp_set(netdev, bpf->prog);
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
 static int ena_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct ena_adapter *adapter = netdev_priv(dev);
 	int ret;
 
+	if (new_mtu > ENA_XDP_MAX_MTU && ena_xdp_present(adapter)) {
+		netif_err(adapter, drv, dev,
+			  "Requested MTU value is not valid while xdp is enabled new_mtu: %d max mtu: %lu min mtu: %d\n",
+			  new_mtu, ENA_XDP_MAX_MTU, ENA_MIN_MTU);
+		return -EINVAL;
+	}
 	ret = ena_com_set_dev_mtu(adapter->ena_dev, new_mtu);
 	if (!ret) {
 		netif_dbg(adapter, drv, dev, "set MTU to %d\n", new_mtu);
@@ -888,6 +959,15 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	va = page_address(rx_info->page) + rx_info->page_offset;
 	prefetch(va + NET_IP_ALIGN);
 
+	if (ena_xdp_present_ring(rx_ring)) {
+		rx_ring->xdp.data = va;
+		rx_ring->xdp.data_meta = rx_ring->xdp.data;
+		rx_ring->xdp.data_hard_start = rx_ring->xdp.data -
+			rx_info->page_offset;
+		rx_ring->xdp.data_end = rx_ring->xdp.data + len;
+		if (ena_xdp_execute(rx_ring, &rx_ring->xdp) != XDP_PASS)
+			return NULL;
+	}
 	if (len <= rx_ring->rx_copybreak) {
 		skb = ena_alloc_skb(rx_ring, false);
 		if (unlikely(!skb))
@@ -2549,6 +2629,7 @@ static const struct net_device_ops ena_netdev_ops = {
 	.ndo_change_mtu		= ena_change_mtu,
 	.ndo_set_mac_address	= NULL,
 	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_bpf		= ena_xdp,
 };
 
 static int ena_device_validate_params(struct ena_adapter *adapter,
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index f2b6e2e05..e17965f7a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -35,6 +35,7 @@
 
 #include <linux/bitops.h>
 #include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/inetdevice.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
@@ -139,6 +140,14 @@
 
 #define ENA_MMIO_DISABLE_REG_READ	BIT(0)
 
+/* The max MTU size is configured to be the ethernet frame without the overhead
+ * of the ethernet header, which can have VLAN header, and the frame check
+ * sequence (FCS).
+ * The buffer sizes we share with the device are defined to be ENA_PAGE_SIZE
+ */
+#define ENA_XDP_MAX_MTU (ENA_PAGE_SIZE - ETH_HLEN - ETH_FCS_LEN - \
+				VLAN_HLEN)
+
 struct ena_irq {
 	irq_handler_t handler;
 	void *data;
@@ -288,6 +297,8 @@ struct ena_ring {
 
 	u8 *push_buf_intermediate_buf;
 	int empty_rx_queue;
+	struct bpf_prog *xdp_bpf_prog;
+	struct xdp_buff xdp;
 } ____cacheline_aligned;
 
 struct ena_stats_dev {
@@ -380,6 +391,9 @@ struct ena_adapter {
 	enum ena_regs_reset_reason_types reset_reason;
 
 	u8 ena_extra_properties_count;
+
+	/* XDP structures */
+	struct bpf_prog *xdp_bpf_prog;
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev);
@@ -394,4 +408,19 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
 
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

