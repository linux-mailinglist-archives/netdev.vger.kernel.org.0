Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4525E45A89F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhKWQod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:44:33 -0500
Received: from mga12.intel.com ([192.55.52.136]:26556 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233787AbhKWQo2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:44:28 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="215086256"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="215086256"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="509475650"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 23 Nov 2021 08:41:10 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wd016784;
        Tue, 23 Nov 2021 16:41:07 GMT
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
Subject: [PATCH v2 net-next 01/26] rtnetlink: introduce generic XDP statistics
Date:   Tue, 23 Nov 2021 17:39:30 +0100
Message-Id: <20211123163955.154512-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lots of the driver-side XDP enabled drivers provide some statistics
on XDP programs runs and different actions taken (number of passes,
drops, redirects etc.). Regarding that it's quite similar across all
the drivers (which is obvious), we can implement some sort of
generic statistics using rtnetlink xstats infra to provide a way for
exposing XDP/XSK statistics without code and stringsets duplication
inside drivers' Ethtool callbacks.
These 15 fields provided by the standard XDP stats should cover most
stats that might be interesting for collecting and tracking.
Note that most NIC drivers keep XDP statistics on a per-channel
basis, so this also introduces a new callback for getting a number
of channels which a driver will provide stats for. If it's not
implemented, we assume the driver stats are shared across channels.
If it's here, it should return either the number of channels, or 0
if stats for this type (XDP or XSK) is shared, or -EOPNOTSUPP if it
doesn't store such type of statistics, or -ENODATA if it does, but
can't provide them right now for any reason (purely for better code
readability, acts the same as -EOPNOTSUPP).
Stats are provided as nested attrs to be able to expand them later
on.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 include/linux/if_link.h      |  39 +++++-
 include/linux/netdevice.h    |  12 ++
 include/uapi/linux/if_link.h |  67 +++++++++
 net/core/rtnetlink.c         | 264 +++++++++++++++++++++++++++++++++++
 4 files changed, 381 insertions(+), 1 deletion(-)

diff --git a/include/linux/if_link.h b/include/linux/if_link.h
index 622658dfbf0a..a0dac6cb3e6a 100644
--- a/include/linux/if_link.h
+++ b/include/linux/if_link.h
@@ -4,8 +4,8 @@

 #include <uapi/linux/if_link.h>

+/* We don't want these structures exposed to user space */

-/* We don't want this structure exposed to user space */
 struct ifla_vf_stats {
 	__u64 rx_packets;
 	__u64 tx_packets;
@@ -30,4 +30,41 @@ struct ifla_vf_info {
 	__u32 trusted;
 	__be16 vlan_proto;
 };
+
+/**
+ * struct ifla_xdp_stats - driver-side XDP statistics
+ * @packets: number of frames passed to bpf_prog_run_xdp().
+ * @bytes: number of bytes went through bpf_prog_run_xdp().
+ * @errors: number of general XDP errors, if driver has one unified counter.
+ * @aborted: number of %XDP_ABORTED returns.
+ * @drop: number of %XDP_DROP returns.
+ * @invalid: number of returns of unallowed values (i.e. not XDP_*).
+ * @pass: number of %XDP_PASS returns.
+ * @redirect: number of successfully performed %XDP_REDIRECT requests.
+ * @redirect_errors: number of failed %XDP_REDIRECT requests.
+ * @tx: number of successfully performed %XDP_TX requests.
+ * @tx_errors: number of failed %XDP_TX requests.
+ * @xmit_packets: number of successfully transmitted XDP/XSK frames.
+ * @xmit_bytes: number of successfully transmitted XDP/XSK frames.
+ * @xmit_errors: of XDP/XSK frames failed to transmit.
+ * @xmit_full: number of XDP/XSK queue being full at the moment of transmission.
+ */
+struct ifla_xdp_stats {
+	__u64	packets;
+	__u64	bytes;
+	__u64	errors;
+	__u64	aborted;
+	__u64	drop;
+	__u64	invalid;
+	__u64	pass;
+	__u64	redirect;
+	__u64	redirect_errors;
+	__u64	tx;
+	__u64	tx_errors;
+	__u64	xmit_packets;
+	__u64	xmit_bytes;
+	__u64	xmit_errors;
+	__u64	xmit_full;
+};
+
 #endif /* _LINUX_IF_LINK_H */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index db3bff1ae7fd..058a00c2d19a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1327,6 +1327,13 @@ struct netdev_net_notifier {
  *	queue id bound to an AF_XDP socket. The flags field specifies if
  *	only RX, only Tx, or both should be woken up using the flags
  *	XDP_WAKEUP_RX and XDP_WAKEUP_TX.
+ * int (*ndo_get_xdp_stats_nch)(const struct net_device *dev, u32 attr_id);
+ *	Get the number of channels which ndo_get_xdp_stats will return
+ *	statistics for.
+ *
+ * int (*ndo_get_xdp_stats)(const struct net_device *dev, u32 attr_id,
+ *			    void *attr_data);
+ *	Get attr_id XDP statistics into the attr_data pointer.
  * struct devlink_port *(*ndo_get_devlink_port)(struct net_device *dev);
  *	Get devlink port instance associated with a given netdev.
  *	Called with a reference on the netdevice and devlink locks only,
@@ -1550,6 +1557,11 @@ struct net_device_ops {
 							  struct xdp_buff *xdp);
 	int			(*ndo_xsk_wakeup)(struct net_device *dev,
 						  u32 queue_id, u32 flags);
+	int			(*ndo_get_xdp_stats_nch)(const struct net_device *dev,
+							 u32 attr_id);
+	int			(*ndo_get_xdp_stats)(const struct net_device *dev,
+						     u32 attr_id,
+						     void *attr_data);
 	struct devlink_port *	(*ndo_get_devlink_port)(struct net_device *dev);
 	int			(*ndo_tunnel_ctl)(struct net_device *dev,
 						  struct ip_tunnel_parm *p, int cmd);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index eebd3894fe89..dc1dd31e8274 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1147,6 +1147,7 @@ enum {
 	IFLA_STATS_LINK_XSTATS_SLAVE,
 	IFLA_STATS_LINK_OFFLOAD_XSTATS,
 	IFLA_STATS_AF_SPEC,
+	IFLA_STATS_LINK_XDP_XSTATS,
 	__IFLA_STATS_MAX,
 };

@@ -1175,6 +1176,72 @@ enum {
 };
 #define IFLA_OFFLOAD_XSTATS_MAX (__IFLA_OFFLOAD_XSTATS_MAX - 1)

+/* These are embedded into IFLA_STATS_LINK_XDP_XSTATS */
+enum {
+	IFLA_XDP_XSTATS_TYPE_UNSPEC,
+	/* Stats collected on a "regular" channel(s) */
+	IFLA_XDP_XSTATS_TYPE_XDP,
+	/* Stats collected on an XSK channel(s) */
+	IFLA_XDP_XSTATS_TYPE_XSK,
+
+	__IFLA_XDP_XSTATS_TYPE_CNT,
+};
+
+#define IFLA_XDP_XSTATS_TYPE_START	(IFLA_XDP_XSTATS_TYPE_UNSPEC + 1)
+#define IFLA_XDP_XSTATS_TYPE_MAX	(__IFLA_XDP_XSTATS_TYPE_CNT - 1)
+
+/* Embedded into IFLA_XDP_XSTATS_TYPE_XDP or IFLA_XDP_XSTATS_TYPE_XSK */
+enum {
+	IFLA_XDP_XSTATS_SCOPE_UNSPEC,
+	/* netdev-wide stats */
+	IFLA_XDP_XSTATS_SCOPE_SHARED,
+	/* Per-channel stats */
+	IFLA_XDP_XSTATS_SCOPE_CHANNEL,
+
+	__IFLA_XDP_XSTATS_SCOPE_CNT,
+};
+
+/* Embedded into IFLA_XDP_XSTATS_SCOPE_SHARED/IFLA_XDP_XSTATS_SCOPE_CHANNEL */
+enum {
+	/* Padding for 64-bit alignment */
+	IFLA_XDP_XSTATS_UNSPEC,
+	/* Number of frames passed to bpf_prog_run_xdp() */
+	IFLA_XDP_XSTATS_PACKETS,
+	/* Number of bytes went through bpf_prog_run_xdp() */
+	IFLA_XDP_XSTATS_BYTES,
+	/* Number of general XDP errors if driver counts them together */
+	IFLA_XDP_XSTATS_ERRORS,
+	/* Number of %XDP_ABORTED returns */
+	IFLA_XDP_XSTATS_ABORTED,
+	/* Number of %XDP_DROP returns */
+	IFLA_XDP_XSTATS_DROP,
+	/* Number of returns of unallowed values (i.e. not XDP_*) */
+	IFLA_XDP_XSTATS_INVALID,
+	/* Number of %XDP_PASS returns */
+	IFLA_XDP_XSTATS_PASS,
+	/* Number of successfully performed %XDP_REDIRECT requests */
+	IFLA_XDP_XSTATS_REDIRECT,
+	/* Number of failed %XDP_REDIRECT requests */
+	IFLA_XDP_XSTATS_REDIRECT_ERRORS,
+	/* Number of successfully performed %XDP_TX requests */
+	IFLA_XDP_XSTATS_TX,
+	/* Number of failed %XDP_TX requests */
+	IFLA_XDP_XSTATS_TX_ERRORS,
+	/* Number of successfully transmitted XDP/XSK frames */
+	IFLA_XDP_XSTATS_XMIT_PACKETS,
+	/* Number of successfully transmitted XDP/XSK bytes */
+	IFLA_XDP_XSTATS_XMIT_BYTES,
+	/* Number of XDP/XSK frames failed to transmit */
+	IFLA_XDP_XSTATS_XMIT_ERRORS,
+	/* Number of XDP/XSK queue being full at the moment of transmission */
+	IFLA_XDP_XSTATS_XMIT_FULL,
+
+	__IFLA_XDP_XSTATS_CNT,
+};
+
+#define IFLA_XDP_XSTATS_START		(IFLA_XDP_XSTATS_UNSPEC + 1)
+#define IFLA_XDP_XSTATS_MAX		(__IFLA_XDP_XSTATS_CNT - 1)
+
 /* XDP section */

 #define XDP_FLAGS_UPDATE_IF_NOEXIST	(1U << 0)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 6f25c0a8aebe..b7db68fb0879 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5107,6 +5107,262 @@ static int rtnl_get_offload_stats_size(const struct net_device *dev)
 	return nla_size;
 }

+#define IFLA_XDP_XSTATS_NUM		(__IFLA_XDP_XSTATS_CNT - \
+					 IFLA_XDP_XSTATS_START)
+
+static_assert(sizeof(struct ifla_xdp_stats) / sizeof(__u64) ==
+	      IFLA_XDP_XSTATS_NUM);
+
+static u32 rtnl_get_xdp_stats_num(u32 attr_id)
+{
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+	case IFLA_XDP_XSTATS_TYPE_XSK:
+		return IFLA_XDP_XSTATS_NUM;
+	default:
+		return 0;
+	}
+}
+
+static bool rtnl_get_xdp_stats_xdpxsk(struct sk_buff *skb, u32 ch,
+				      const void *attr_data)
+{
+	const struct ifla_xdp_stats *xstats = attr_data;
+
+	xstats += ch;
+
+	if (nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_PACKETS, xstats->packets,
+			      IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_BYTES, xstats->bytes,
+			      IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_ERRORS, xstats->errors,
+			      IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_ABORTED, xstats->aborted,
+			      IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_DROP, xstats->drop,
+			      IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_INVALID, xstats->invalid,
+			      IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_PASS, xstats->pass,
+			      IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_REDIRECT, xstats->redirect,
+			      IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_REDIRECT_ERRORS,
+			      xstats->redirect_errors,
+			      IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_TX, xstats->tx,
+			      IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_TX_ERRORS,
+			      xstats->tx_errors, IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_XMIT_PACKETS,
+			      xstats->xmit_packets, IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_XMIT_BYTES,
+			      xstats->xmit_bytes, IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_XMIT_ERRORS,
+			      xstats->xmit_errors, IFLA_XDP_XSTATS_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_XMIT_FULL,
+			      xstats->xmit_full, IFLA_XDP_XSTATS_UNSPEC))
+		return false;
+
+	return true;
+}
+
+static bool rtnl_get_xdp_stats_one(struct sk_buff *skb, u32 attr_id,
+				   u32 scope_id, u32 ch, const void *attr_data)
+{
+	struct nlattr *scope;
+
+	scope = nla_nest_start_noflag(skb, scope_id);
+	if (!scope)
+		return false;
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+	case IFLA_XDP_XSTATS_TYPE_XSK:
+		if (!rtnl_get_xdp_stats_xdpxsk(skb, ch, attr_data))
+			goto fail;
+
+		break;
+	default:
+fail:
+		nla_nest_cancel(skb, scope);
+
+		return false;
+	}
+
+	nla_nest_end(skb, scope);
+
+	return true;
+}
+
+static bool rtnl_get_xdp_stats(struct sk_buff *skb,
+			       const struct net_device *dev,
+			       int *idxattr, int *prividx)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct nlattr *xstats, *type = NULL;
+	u32 saved_ch = *prividx & U16_MAX;
+	u32 saved_attr = *prividx >> 16;
+	bool nuke_xstats = true;
+	u32 attr_id, ch = 0;
+	int ret;
+
+	if (!ops || !ops->ndo_get_xdp_stats)
+		goto nodata;
+
+	*idxattr = IFLA_STATS_LINK_XDP_XSTATS;
+
+	xstats = nla_nest_start_noflag(skb, IFLA_STATS_LINK_XDP_XSTATS);
+	if (!xstats)
+		return false;
+
+	for (attr_id = IFLA_XDP_XSTATS_TYPE_START;
+	     attr_id < __IFLA_XDP_XSTATS_TYPE_CNT;
+	     attr_id++) {
+		u32 nstat, scope_id, nch;
+		bool nuke_type = true;
+		void *attr_data;
+		size_t size;
+
+		if (attr_id > saved_attr)
+			saved_ch = 0;
+		if (attr_id < saved_attr)
+			continue;
+
+		nstat = rtnl_get_xdp_stats_num(attr_id);
+		if (!nstat)
+			continue;
+
+		scope_id = IFLA_XDP_XSTATS_SCOPE_SHARED;
+		nch = 1;
+
+		if (!ops->ndo_get_xdp_stats_nch)
+			goto shared;
+
+		ret = ops->ndo_get_xdp_stats_nch(dev, attr_id);
+		if (ret == -EOPNOTSUPP || ret == -ENODATA)
+			continue;
+		if (ret < 0)
+			goto out;
+		if (!ret)
+			goto shared;
+
+		scope_id = IFLA_XDP_XSTATS_SCOPE_CHANNEL;
+		nch = ret;
+
+shared:
+		size = array3_size(nch, nstat, sizeof(__u64));
+		if (unlikely(size == SIZE_MAX)) {
+			ret = -EOVERFLOW;
+			goto out;
+		}
+
+		attr_data = kzalloc(size, GFP_KERNEL);
+		if (!attr_data) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = ops->ndo_get_xdp_stats(dev, attr_id, attr_data);
+		if (ret == -EOPNOTSUPP || ret == -ENODATA)
+			goto kfree_cont;
+		if (ret) {
+kfree_out:
+			kfree(attr_data);
+			goto out;
+		}
+
+		ret = -EMSGSIZE;
+
+		type = nla_nest_start_noflag(skb, attr_id);
+		if (!type)
+			goto kfree_out;
+
+		for (ch = saved_ch; ch < nch; ch++)
+			if (!rtnl_get_xdp_stats_one(skb, attr_id, scope_id,
+						    ch, attr_data)) {
+				if (nuke_type)
+					nla_nest_cancel(skb, type);
+				else
+					nla_nest_end(skb, type);
+
+				goto kfree_out;
+			} else {
+				nuke_xstats = false;
+				nuke_type = false;
+			}
+
+		nla_nest_end(skb, type);
+kfree_cont:
+		kfree(attr_data);
+	}
+
+	ret = 0;
+
+out:
+	if (nuke_xstats)
+		nla_nest_cancel(skb, xstats);
+	else
+		nla_nest_end(skb, xstats);
+
+	if (ret && ret != -EOPNOTSUPP && ret != -ENODATA) {
+		/* If the driver has 60+ queues, we can run out of skb
+		 * tailroom even when putting stats for one type. Save
+		 * channel number in prividx to resume from it next time
+		 * rather than restaring the whole type and running into
+		 * the same problem again.
+		 */
+		*prividx = (attr_id << 16) | ch;
+		return false;
+	}
+
+	*prividx = 0;
+nodata:
+	*idxattr = 0;
+
+	return true;
+}
+
+static size_t rtnl_get_xdp_stats_size(const struct net_device *dev)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	size_t size = 0;
+	u32 attr_id;
+
+	if (!ops || !ops->ndo_get_xdp_stats)
+		return 0;
+
+	for (attr_id = IFLA_XDP_XSTATS_TYPE_START;
+	     attr_id < __IFLA_XDP_XSTATS_TYPE_CNT;
+	     attr_id++) {
+		u32 nstat = rtnl_get_xdp_stats_num(attr_id);
+		u32 nch = 1;
+		int ret;
+
+		if (!nstat)
+			continue;
+
+		if (!ops->ndo_get_xdp_stats_nch)
+			goto shared;
+
+		ret = ops->ndo_get_xdp_stats_nch(dev, attr_id);
+		if (ret < 0)
+			continue;
+		if (ret > 0)
+			nch = ret;
+
+shared:
+		size += nla_total_size(0) +	/* IFLA_XDP_XSTATS_TYPE_* */
+			(nla_total_size(0) +	/* IFLA_XDP_XSTATS_SCOPE_* */
+			 nla_total_size_64bit(sizeof(__u64)) * nstat) * nch;
+	}
+
+	if (size)
+		size += nla_total_size(0);	/* IFLA_STATS_LINK_XDP_XSTATS */
+
+	return size;
+}
+
 static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			       int type, u32 pid, u32 seq, u32 change,
 			       unsigned int flags, unsigned int filter_mask,
@@ -5243,6 +5499,11 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 		*idxattr = 0;
 	}

+	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_XDP_XSTATS,
+			     *idxattr) &&
+	    !rtnl_get_xdp_stats(skb, dev, idxattr, prividx))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);

 	return 0;
@@ -5318,6 +5579,9 @@ static size_t if_nlmsg_stats_size(const struct net_device *dev,
 		rcu_read_unlock();
 	}

+	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_XDP_XSTATS, 0))
+		size += rtnl_get_xdp_stats_size(dev);
+
 	return size;
 }

--
2.33.1

