Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A914176D3
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 16:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346787AbhIXOfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 10:35:48 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:16412 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346670AbhIXOfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 10:35:47 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HGDvV0mRyzRGbp;
        Fri, 24 Sep 2021 22:29:58 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 22:34:11 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 22:34:10 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <jdike@addtoit.com>,
        <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
        <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <chris.snook@gmail.com>,
        <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <jeroendb@google.com>, <csully@google.com>,
        <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>,
        <linux-s390@vger.kernel.org>
Subject: [PATCH V2 net-next 3/6] ethtool: add support to set/get rx buf len via ethtool
Date:   Fri, 24 Sep 2021 22:29:56 +0800
Message-ID: <20210924142959.7798-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924142959.7798-1-huangguangbin2@huawei.com>
References: <20210924142959.7798-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Add support to set rx buf len via ethtool -G parameter and get
rx buf len via ethtool -g parameter.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 Documentation/networking/ethtool-netlink.rst |  2 ++
 include/linux/ethtool.h                      | 18 ++++++++++++++++--
 include/uapi/linux/ethtool.h                 |  8 ++++++++
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/netlink.h                        |  2 +-
 net/ethtool/rings.c                          | 17 ++++++++++++++++-
 6 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index a47b0255aaf9..9734b7c1e05d 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -841,6 +841,7 @@ Kernel response contents:
   ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
   ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
   ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
+  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
   ====================================  ======  ==========================
 
 
@@ -857,6 +858,7 @@ Request contents:
   ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
   ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
   ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
+  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
   ====================================  ======  ==========================
 
 Kernel checks that requested ring sizes do not exceed limits reported by
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 849524b55d89..61e42a0b60d3 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -67,6 +67,14 @@ enum {
 	ETH_RSS_HASH_FUNCS_COUNT
 };
 
+/**
+ * enum ethtool_supported_ring_param - indicator caps for setting ring params
+ * @ETHTOOL_RING_USE_RX_BUF_LEN: capture for setting rx_buf_len
+ */
+enum ethtool_supported_ring_param {
+	ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
+};
+
 #define __ETH_RSS_HASH_BIT(bit)	((u32)1 << (bit))
 #define __ETH_RSS_HASH(name)	__ETH_RSS_HASH_BIT(ETH_RSS_HASH_##name##_BIT)
 
@@ -420,6 +428,7 @@ struct ethtool_module_eeprom {
  * @cap_link_lanes_supported: indicates if the driver supports lanes
  *	parameter.
  * @supported_coalesce_params: supported types of interrupt coalescing.
+ * @supported_ring_params: supported ring params.
  * @get_drvinfo: Report driver/device information.  Should only set the
  *	@driver, @version, @fw_version and @bus_info fields.  If not
  *	implemented, the @driver and @bus_info fields will be filled in
@@ -596,6 +605,7 @@ struct ethtool_module_eeprom {
 struct ethtool_ops {
 	u32     cap_link_lanes_supported:1;
 	u32	supported_coalesce_params;
+	u32	supported_ring_params;
 	void	(*get_drvinfo)(struct net_device *, struct ethtool_drvinfo *);
 	int	(*get_regs_len)(struct net_device *);
 	void	(*get_regs)(struct net_device *, struct ethtool_regs *, void *);
@@ -621,9 +631,13 @@ struct ethtool_ops {
 				struct kernel_ethtool_coalesce *,
 				struct netlink_ext_ack *);
 	void	(*get_ringparam)(struct net_device *,
-				 struct ethtool_ringparam *);
+				 struct ethtool_ringparam *,
+				 struct ethtool_ringparam_ext *,
+				 struct netlink_ext_ack *);
 	int	(*set_ringparam)(struct net_device *,
-				 struct ethtool_ringparam *);
+				 struct ethtool_ringparam *,
+				 struct ethtool_ringparam_ext *,
+				 struct netlink_ext_ack *);
 	void	(*get_pause_stats)(struct net_device *dev,
 				   struct ethtool_pause_stats *pause_stats);
 	void	(*get_pauseparam)(struct net_device *,
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 266e95e4fb33..83544186cbb5 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -535,6 +535,14 @@ struct ethtool_ringparam {
 	__u32	tx_pending;
 };
 
+/**
+ * struct ethtool_ringparam_ext - RX/TX ring configuration
+ * @rx_buf_len: Current length of buffers on the rx ring.
+ */
+struct ethtool_ringparam_ext {
+	__u32	rx_buf_len;
+};
+
 /**
  * struct ethtool_channels - configuring number of network channel
  * @cmd: ETHTOOL_{G,S}CHANNELS
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 5545f1ca9237..3883fa4168e9 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -325,6 +325,7 @@ enum {
 	ETHTOOL_A_RINGS_RX_MINI,			/* u32 */
 	ETHTOOL_A_RINGS_RX_JUMBO,			/* u32 */
 	ETHTOOL_A_RINGS_TX,				/* u32 */
+	ETHTOOL_A_RINGS_RX_BUF_LEN,                     /* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_RINGS_CNT,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index e8987e28036f..3183f1fc6990 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -355,7 +355,7 @@ extern const struct nla_policy ethnl_features_set_policy[ETHTOOL_A_FEATURES_WANT
 extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_HEADER + 1];
 extern const struct nla_policy ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_FLAGS + 1];
 extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_HEADER + 1];
-extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_TX + 1];
+extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_RX_BUF_LEN + 1];
 extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 4e097812a967..dd645d1334be 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -10,6 +10,7 @@ struct rings_req_info {
 struct rings_reply_data {
 	struct ethnl_reply_data		base;
 	struct ethtool_ringparam	ringparam;
+	struct ethtool_ringparam_ext	ringparam_ext;
 };
 
 #define RINGS_REPDATA(__reply_base) \
@@ -49,7 +50,8 @@ static int rings_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX */
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_MINI */
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_JUMBO */
-	       nla_total_size(sizeof(u32));	/* _RINGS_TX */
+	       nla_total_size(sizeof(u32)) +	/* _RINGS_TX */
+	       nla_total_size(sizeof(u32));     /* _RINGS_RX_BUF_LEN */
 }
 
 static int rings_fill_reply(struct sk_buff *skb,
@@ -105,10 +107,12 @@ const struct nla_policy ethnl_rings_set_policy[] = {
 	[ETHTOOL_A_RINGS_RX_MINI]		= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_U32 },
+	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = NLA_POLICY_MIN(NLA_U32, 1),
 };
 
 int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 {
+	struct ethtool_ringparam_ext ringparam_ext = {};
 	struct ethtool_ringparam ringparam = {};
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
@@ -142,6 +146,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 	ethnl_update_u32(&ringparam.rx_jumbo_pending,
 			 tb[ETHTOOL_A_RINGS_RX_JUMBO], &mod);
 	ethnl_update_u32(&ringparam.tx_pending, tb[ETHTOOL_A_RINGS_TX], &mod);
+	ethnl_update_u32(&ringparam_ext.rx_buf_len,
+			 tb[ETHTOOL_A_RINGS_RX_BUF_LEN], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
@@ -164,6 +170,15 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
+	if (ringparam_ext.rx_buf_len != 0 &&
+	    !(ops->supported_ring_params & ETHTOOL_RING_USE_RX_BUF_LEN)) {
+		ret = -EOPNOTSUPP;
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_RINGS_RX_BUF_LEN],
+				    "not supported setting rx buf len");
+		goto out_ops;
+	}
+
 	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
 	if (ret < 0)
 		goto out_ops;
-- 
2.33.0

