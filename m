Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785E642D868
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 13:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhJNLqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 07:46:10 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:28940 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhJNLqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 07:46:08 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HVS9b3PWVzbn4G;
        Thu, 14 Oct 2021 19:39:31 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 19:44:00 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 19:43:58 +0800
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
Subject: [PATCH V4 net-next 3/6] ethtool: add support to set/get rx buf len via ethtool
Date:   Thu, 14 Oct 2021 19:39:40 +0800
Message-ID: <20211014113943.16231-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014113943.16231-1-huangguangbin2@huawei.com>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
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
 Documentation/networking/ethtool-netlink.rst | 10 +++++----
 include/linux/ethtool.h                      | 18 +++++++++++++++
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/netlink.h                        |  2 +-
 net/ethtool/rings.c                          | 23 ++++++++++++++++++--
 5 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 7b598c7e3912..9d98e0511249 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -849,7 +849,7 @@ Request contents:
 
 Kernel response contents:
 
-  ====================================  ======  ==========================
+  ====================================  ======  ===========================
   ``ETHTOOL_A_RINGS_HEADER``            nested  reply header
   ``ETHTOOL_A_RINGS_RX_MAX``            u32     max size of RX ring
   ``ETHTOOL_A_RINGS_RX_MINI_MAX``       u32     max size of RX mini ring
@@ -859,7 +859,8 @@ Kernel response contents:
   ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
   ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
   ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
-  ====================================  ======  ==========================
+  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
+  ====================================  ======  ===========================
 
 
 RINGS_SET
@@ -869,13 +870,14 @@ Sets ring sizes like ``ETHTOOL_SRINGPARAM`` ioctl request.
 
 Request contents:
 
-  ====================================  ======  ==========================
+  ====================================  ======  ===========================
   ``ETHTOOL_A_RINGS_HEADER``            nested  reply header
   ``ETHTOOL_A_RINGS_RX``                u32     size of RX ring
   ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
   ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
   ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
-  ====================================  ======  ==========================
+  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
+  ====================================  ======  ===========================
 
 Kernel checks that requested ring sizes do not exceed limits reported by
 driver. Driver may impose additional constraints and may not suspport all
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 845a0ffc16ee..2e1111804014 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -67,6 +67,22 @@ enum {
 	ETH_RSS_HASH_FUNCS_COUNT
 };
 
+/**
+ * struct ethtool_ringparam_ext - RX/TX ring configuration
+ * @rx_buf_len: Current length of buffers on the rx ring.
+ */
+struct ethtool_ringparam_ext {
+	__u32	rx_buf_len;
+};
+
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
 
@@ -432,6 +448,7 @@ struct ethtool_module_power_mode_params {
  * @cap_link_lanes_supported: indicates if the driver supports lanes
  *	parameter.
  * @supported_coalesce_params: supported types of interrupt coalescing.
+ * @supported_ring_params: supported ring params.
  * @get_drvinfo: Report driver/device information.  Should only set the
  *	@driver, @version, @fw_version and @bus_info fields.  If not
  *	implemented, the @driver and @bus_info fields will be filled in
@@ -613,6 +630,7 @@ struct ethtool_module_power_mode_params {
 struct ethtool_ops {
 	u32     cap_link_lanes_supported:1;
 	u32	supported_coalesce_params;
+	u32	supported_ring_params;
 	void	(*get_drvinfo)(struct net_device *, struct ethtool_drvinfo *);
 	int	(*get_regs_len)(struct net_device *);
 	void	(*get_regs)(struct net_device *, struct ethtool_regs *, void *);
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index ca5fbb59fa42..f31d66d636b2 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -329,6 +329,7 @@ enum {
 	ETHTOOL_A_RINGS_RX_MINI,			/* u32 */
 	ETHTOOL_A_RINGS_RX_JUMBO,			/* u32 */
 	ETHTOOL_A_RINGS_TX,				/* u32 */
+	ETHTOOL_A_RINGS_RX_BUF_LEN,                     /* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_RINGS_CNT,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 836ee7157848..490598e5eedd 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -356,7 +356,7 @@ extern const struct nla_policy ethnl_features_set_policy[ETHTOOL_A_FEATURES_WANT
 extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_HEADER + 1];
 extern const struct nla_policy ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_FLAGS + 1];
 extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_HEADER + 1];
-extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_TX + 1];
+extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_RX_BUF_LEN + 1];
 extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 4e097812a967..b9ed6af34d3c 100644
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
@@ -57,6 +59,7 @@ static int rings_fill_reply(struct sk_buff *skb,
 			    const struct ethnl_reply_data *reply_base)
 {
 	const struct rings_reply_data *data = RINGS_REPDATA(reply_base);
+	const struct ethtool_ringparam_ext *ringparam_ext = &data->ringparam_ext;
 	const struct ethtool_ringparam *ringparam = &data->ringparam;
 
 	if ((ringparam->rx_max_pending &&
@@ -78,7 +81,10 @@ static int rings_fill_reply(struct sk_buff *skb,
 	     (nla_put_u32(skb, ETHTOOL_A_RINGS_TX_MAX,
 			  ringparam->tx_max_pending) ||
 	      nla_put_u32(skb, ETHTOOL_A_RINGS_TX,
-			  ringparam->tx_pending))))
+			  ringparam->tx_pending)))  ||
+	    (ringparam_ext->rx_buf_len &&
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN,
+			  ringparam_ext->rx_buf_len))))
 		return -EMSGSIZE;
 
 	return 0;
@@ -105,10 +111,12 @@ const struct nla_policy ethnl_rings_set_policy[] = {
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
@@ -142,6 +150,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 	ethnl_update_u32(&ringparam.rx_jumbo_pending,
 			 tb[ETHTOOL_A_RINGS_RX_JUMBO], &mod);
 	ethnl_update_u32(&ringparam.tx_pending, tb[ETHTOOL_A_RINGS_TX], &mod);
+	ethnl_update_u32(&ringparam_ext.rx_buf_len,
+			 tb[ETHTOOL_A_RINGS_RX_BUF_LEN], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
@@ -164,6 +174,15 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
+	if (ringparam_ext.rx_buf_len != 0 &&
+	    !(ops->supported_ring_params & ETHTOOL_RING_USE_RX_BUF_LEN)) {
+		ret = -EOPNOTSUPP;
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_RINGS_RX_BUF_LEN],
+				    "setting rx buf len not supported");
+		goto out_ops;
+	}
+
 	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
 	if (ret < 0)
 		goto out_ops;
-- 
2.33.0

