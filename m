Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C8445A8A7
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbhKWQoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:44:38 -0500
Received: from mga17.intel.com ([192.55.52.151]:39357 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233864AbhKWQoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:44:32 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="215767227"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="215767227"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="474813269"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 23 Nov 2021 08:41:12 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4We016784;
        Tue, 23 Nov 2021 16:41:09 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 net-next 02/26] xdp: provide common driver helpers for implementing XDP stats
Date:   Tue, 23 Nov 2021 17:39:31 +0100
Message-Id: <20211123163955.154512-3-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add several shorthands to reduce driver boilerplates and unify
storing and accessing generic XDP statistics in the drivers.
If the driver has one of xdp_{rx,tx}_drv_stats embedded into
a ring structure, it can reuse pretty much everything, but needs
to implement its own .ndo_xdp_stats() and .ndo_xdp_stats_nch()
if needed. If the driver stores a separate array of xdp_drv_stats,
it can then export it as net_device::xstats, implement only
.ndo_xdp_stats_nch() and wire up xdp_get_drv_stats_generic()
as .ndo_xdp_stats().
Both XDP and XSK blocks of xdp_drv_stats are cacheline-aligned
to avoid false-sharing, only extremely unlikely 'aborted' and
'invalid' falls out of a 64-byte CL. xdp_rx_drv_stats_local is
provided to put it on stack and collect the stats on hotpath,
with accessing a real container and its atomic/seqcount sync
points just once when exiting Rx NAPI polling.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 include/linux/netdevice.h |   1 +
 include/net/xdp.h         | 162 ++++++++++++++++++++++++++++++++++++++
 net/core/xdp.c            | 124 +++++++++++++++++++++++++++++
 3 files changed, 287 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 058a00c2d19a..728c650d290e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2225,6 +2225,7 @@ struct net_device {
 		struct pcpu_lstats __percpu		*lstats;
 		struct pcpu_sw_netstats __percpu	*tstats;
 		struct pcpu_dstats __percpu		*dstats;
+		struct xdp_drv_stats /* per-channel */	*xstats;
 	};

 #if IS_ENABLED(CONFIG_GARP)
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 447f9b1578f3..e4f06a34d462 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -7,6 +7,7 @@
 #define __LINUX_NET_XDP_H__

 #include <linux/skbuff.h> /* skb_shared_info */
+#include <linux/u64_stats_sync.h> /* u64_stats_* */

 /**
  * DOC: XDP RX-queue information
@@ -292,4 +293,165 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,

 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE

+/* Suggested XDP/XSK driver stats, mirror &ifla_xdp_stats except
+ * for generic errors, refer to its documentation for the details.
+ * The intended usage is to either have them as a standalone array
+ * of xdp_drv_stats, or embed &xdp_{rx,tx}_drv_stats into a ring
+ * structure. Having separate XDP and XSK counters is recommended.
+ */
+
+struct ifla_xdp_stats;
+
+struct xdp_rx_drv_stats {
+	struct u64_stats_sync syncp;
+	u64_stats_t packets;
+	u64_stats_t bytes;
+	u64_stats_t pass;
+	u64_stats_t drop;
+	u64_stats_t redirect;
+	u64_stats_t tx;
+	u64_stats_t redirect_errors;
+	u64_stats_t tx_errors;
+	u64_stats_t aborted;
+	u64_stats_t invalid;
+};
+
+struct xdp_tx_drv_stats {
+	struct u64_stats_sync syncp;
+	u64_stats_t packets;
+	u64_stats_t bytes;
+	u64_stats_t errors;
+	u64_stats_t full;
+};
+
+struct xdp_drv_stats {
+	struct xdp_rx_drv_stats xdp_rx;
+	struct xdp_tx_drv_stats xdp_tx;
+	struct xdp_rx_drv_stats xsk_rx ____cacheline_aligned;
+	struct xdp_tx_drv_stats xsk_tx;
+} ____cacheline_aligned;
+
+/* Shortened copy of Rx stats to put on stack */
+struct xdp_rx_drv_stats_local {
+	u32 bytes;
+	u32 packets;
+	u32 pass;
+	u32 drop;
+	u32 tx;
+	u32 tx_errors;
+	u32 redirect;
+	u32 redirect_errors;
+	u32 aborted;
+	u32 invalid;
+};
+
+#define xdp_init_rx_drv_stats(rstats) u64_stats_init(&(rstats)->syncp)
+#define xdp_init_tx_drv_stats(tstats) u64_stats_init(&(tstats)->syncp)
+
+/**
+ * xdp_init_drv_stats - initialize driver XDP stats
+ * @xdp_stats: driver container if it uses generic xdp_drv_stats
+ *
+ * Initializes atomic/seqcount sync points inside the containers.
+ */
+static inline void xdp_init_drv_stats(struct xdp_drv_stats *xdp_stats)
+{
+	xdp_init_rx_drv_stats(&xdp_stats->xdp_rx);
+	xdp_init_tx_drv_stats(&xdp_stats->xdp_tx);
+	xdp_init_rx_drv_stats(&xdp_stats->xsk_rx);
+	xdp_init_tx_drv_stats(&xdp_stats->xsk_tx);
+}
+
+/**
+ * xdp_update_rx_drv_stats - update driver XDP stats
+ * @rstats: target driver container
+ * @lrstats: filled onstack structure
+ *
+ * Fetches Rx path XDP statistics from the onstack structure to the
+ * driver container, respecting atomic/seqcount synchronization.
+ * Typical usage is to call it at the end of Rx NAPI polling.
+ */
+static inline void
+xdp_update_rx_drv_stats(struct xdp_rx_drv_stats *rstats,
+			const struct xdp_rx_drv_stats_local *lrstats)
+{
+	if (!lrstats->packets)
+		return;
+
+	u64_stats_update_begin(&rstats->syncp);
+	u64_stats_add(&rstats->packets, lrstats->packets);
+	u64_stats_add(&rstats->bytes, lrstats->bytes);
+	u64_stats_add(&rstats->pass, lrstats->pass);
+	u64_stats_add(&rstats->drop, lrstats->drop);
+	u64_stats_add(&rstats->redirect, lrstats->redirect);
+	u64_stats_add(&rstats->tx, lrstats->tx);
+	u64_stats_add(&rstats->redirect_errors, lrstats->redirect_errors);
+	u64_stats_add(&rstats->tx_errors, lrstats->tx_errors);
+	u64_stats_add(&rstats->aborted, lrstats->aborted);
+	u64_stats_add(&rstats->invalid, lrstats->invalid);
+	u64_stats_update_end(&rstats->syncp);
+}
+
+/**
+ * xdp_update_tx_drv_stats - update driver XDP stats
+ * @tstats: target driver container
+ * @packets: onstack packet counter
+ * @bytes: onstack octete counter
+ *
+ * Adds onstack packet/byte Tx XDP counter values from the current session
+ * to the driver container. Typical usage is to call it on completion path /
+ * Tx NAPI polling.
+ */
+static inline void xdp_update_tx_drv_stats(struct xdp_tx_drv_stats *tstats,
+					   u32 packets, u32 bytes)
+{
+	if (!packets)
+		return;
+
+	u64_stats_update_begin(&tstats->syncp);
+	u64_stats_add(&tstats->packets, packets);
+	u64_stats_add(&tstats->bytes, bytes);
+	u64_stats_update_end(&tstats->syncp);
+}
+
+/**
+ * xdp_update_tx_drv_err - update driver Tx XDP errors counter
+ * @tstats: target driver container
+ * @num: onstack error counter / number of non-xmitted frames
+ *
+ * Adds onstack error Tx XDP counter value from the current session
+ * to the driver container. Typical usage is to call it at on error
+ * path of .ndo_xdp_xmit() / XSK zerocopy xmit.
+ */
+static inline void xdp_update_tx_drv_err(struct xdp_tx_drv_stats *tstats,
+					 u32 num)
+{
+	u64_stats_update_begin(&tstats->syncp);
+	u64_stats_add(&tstats->errors, num);
+	u64_stats_update_end(&tstats->syncp);
+}
+
+/**
+ * xdp_update_tx_drv_full - update driver Tx XDP ring full counter
+ * @tstats: target driver container
+ *
+ * Adds onstack error Tx XDP counter value from the current session
+ * to the driver container. Typical usage is to call it at in case
+ * of no free descs available on a ring in .ndo_xdp_xmit() / XSK
+ * zerocopy xmit.
+ */
+static inline void xdp_update_tx_drv_full(struct xdp_tx_drv_stats *tstats)
+{
+	u64_stats_update_begin(&tstats->syncp);
+	u64_stats_inc(&tstats->full);
+	u64_stats_update_end(&tstats->syncp);
+}
+
+void xdp_fetch_rx_drv_stats(struct ifla_xdp_stats *if_stats,
+			    const struct xdp_rx_drv_stats *rstats);
+void xdp_fetch_tx_drv_stats(struct ifla_xdp_stats *if_stats,
+			    const struct xdp_tx_drv_stats *tstats);
+int xdp_get_drv_stats_generic(const struct net_device *dev, u32 attr_id,
+			      void *attr_data);
+
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 5ddc29f29bad..24980207303c 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -611,3 +611,127 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)

 	return nxdpf;
 }
+
+/**
+ * xdp_fetch_rx_drv_stats - helper for implementing .ndo_get_xdp_stats()
+ * @if_stats: target container passed from rtnetlink core
+ * @rstats: driver container if it uses generic xdp_rx_drv_stats
+ *
+ * Fetches Rx path XDP statistics from a suggested driver structure to
+ * the one used by rtnetlink, respecting atomic/seqcount synchronization.
+ */
+void xdp_fetch_rx_drv_stats(struct ifla_xdp_stats *if_stats,
+			    const struct xdp_rx_drv_stats *rstats)
+{
+	u32 start;
+
+	do {
+		start = u64_stats_fetch_begin_irq(&rstats->syncp);
+
+		if_stats->packets = u64_stats_read(&rstats->packets);
+		if_stats->bytes = u64_stats_read(&rstats->bytes);
+		if_stats->pass = u64_stats_read(&rstats->pass);
+		if_stats->drop = u64_stats_read(&rstats->drop);
+		if_stats->tx = u64_stats_read(&rstats->tx);
+		if_stats->tx_errors = u64_stats_read(&rstats->tx_errors);
+		if_stats->redirect = u64_stats_read(&rstats->redirect);
+		if_stats->redirect_errors =
+			u64_stats_read(&rstats->redirect_errors);
+		if_stats->aborted = u64_stats_read(&rstats->aborted);
+		if_stats->invalid = u64_stats_read(&rstats->invalid);
+	} while (u64_stats_fetch_retry_irq(&rstats->syncp, start));
+}
+EXPORT_SYMBOL_GPL(xdp_fetch_rx_drv_stats);
+
+/**
+ * xdp_fetch_tx_drv_stats - helper for implementing .ndo_get_xdp_stats()
+ * @if_stats: target container passed from rtnetlink core
+ * @tstats: driver container if it uses generic xdp_tx_drv_stats
+ *
+ * Fetches Tx path XDP statistics from a suggested driver structure to
+ * the one used by rtnetlink, respecting atomic/seqcount synchronization.
+ */
+void xdp_fetch_tx_drv_stats(struct ifla_xdp_stats *if_stats,
+			    const struct xdp_tx_drv_stats *tstats)
+{
+	u32 start;
+
+	do {
+		start = u64_stats_fetch_begin_irq(&tstats->syncp);
+
+		if_stats->xmit_packets = u64_stats_read(&tstats->packets);
+		if_stats->xmit_bytes = u64_stats_read(&tstats->bytes);
+		if_stats->xmit_errors = u64_stats_read(&tstats->errors);
+		if_stats->xmit_full = u64_stats_read(&tstats->full);
+	} while (u64_stats_fetch_retry_irq(&tstats->syncp, start));
+}
+EXPORT_SYMBOL_GPL(xdp_fetch_tx_drv_stats);
+
+/**
+ * xdp_get_drv_stats_generic - generic implementation of .ndo_get_xdp_stats()
+ * @dev: network interface device structure
+ * @attr_id: type of statistics (XDP, XSK, ...)
+ * @attr_data: target stats container
+ *
+ * Returns 0 on success, -%EOPNOTSUPP if either driver or this function doesn't
+ * support this attr_id, -%ENODATA if the driver supports attr_id, but can't
+ * provide anything right now, and -%EINVAL if driver configuration is invalid.
+ */
+int xdp_get_drv_stats_generic(const struct net_device *dev, u32 attr_id,
+			      void *attr_data)
+{
+	const bool xsk = attr_id == IFLA_XDP_XSTATS_TYPE_XSK;
+	const struct xdp_drv_stats *drv_iter = dev->xstats;
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct ifla_xdp_stats *iter = attr_data;
+	int nch;
+	u32 i;
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		if (unlikely(!ops->ndo_bpf))
+			return -EINVAL;
+
+		break;
+	case IFLA_XDP_XSTATS_TYPE_XSK:
+		if (!ops->ndo_xsk_wakeup)
+			return -EOPNOTSUPP;
+
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (unlikely(!drv_iter || !ops->ndo_get_xdp_stats_nch))
+		return -EINVAL;
+
+	nch = ops->ndo_get_xdp_stats_nch(dev, attr_id);
+	switch (nch) {
+	case 0:
+		/* Stats are shared across the netdev */
+		nch = 1;
+		break;
+	case 1 ... INT_MAX:
+		/* Stats are per-channel */
+		break;
+	default:
+		return nch;
+	}
+
+	for (i = 0; i < nch; i++) {
+		const struct xdp_rx_drv_stats *rstats;
+		const struct xdp_tx_drv_stats *tstats;
+
+		rstats = xsk ? &drv_iter->xsk_rx : &drv_iter->xdp_rx;
+		xdp_fetch_rx_drv_stats(iter, rstats);
+
+		tstats = xsk ? &drv_iter->xsk_tx : &drv_iter->xdp_tx;
+		xdp_fetch_tx_drv_stats(iter, tstats);
+
+		drv_iter++;
+		iter++;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xdp_get_drv_stats_generic);
--
2.33.1

