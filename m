Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDEC4F8F5F
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiDHHUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 03:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiDHHU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 03:20:28 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160F821FF4D;
        Fri,  8 Apr 2022 00:18:24 -0700 (PDT)
Received: from kwepemi500010.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KZV111GJNzgY89;
        Fri,  8 Apr 2022 15:16:37 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500010.china.huawei.com (7.221.188.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Apr 2022 15:18:22 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 8 Apr 2022 15:18:22 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>, <wangjie125@huawei.com>
Subject: [PATCH net-next 1/3] net: ethtool: extend ringparam set/get APIs for tx_push
Date:   Fri, 8 Apr 2022 15:12:43 +0800
Message-ID: <20220408071245.40554-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220408071245.40554-1-huangguangbin2@huawei.com>
References: <20220408071245.40554-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently tx push is a standard driver feature which controls use of a fast
path descriptor push. So this patch extends the ringparam APIs and data
structures to support set/get tx push by ethtool -G/g.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 Documentation/networking/ethtool-netlink.rst |  8 ++++++++
 include/linux/ethtool.h                      |  3 +++
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/netlink.h                        |  2 +-
 net/ethtool/rings.c                          | 18 ++++++++++++++++--
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 24d9be69065d..fcd4fdf96c8e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -862,6 +862,7 @@ Kernel response contents:
   ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
   ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``    u8      TCP header / data split
   ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
+  ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
   ====================================  ======  ===========================
 
 ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT`` indicates whether the device is usable with
@@ -871,6 +872,12 @@ separate buffers. The device configuration must make it possible to receive
 full memory pages of data, for example because MTU is high enough or through
 HW-GRO.
 
+``ETHTOOL_A_RINGS_TX_PUSH`` flag is used to choose the ordinary path or the fast
+path to send packets. In ordinary path, driver fills BDs to DDR memory and
+notifies NIC hardware. In fast path, driver pushes BDs to the device memory
+directly and thus reducing the sending latencies. Setting tx push attribute "on"
+will enable tx push mode and send packets in fast path if packet size matches.
+For those not supported hardwares, this attributes is "off" by default settings.
 
 RINGS_SET
 =========
@@ -887,6 +894,7 @@ Request contents:
   ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
   ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
   ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
+  ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
   ====================================  ======  ===========================
 
 Kernel checks that requested ring sizes do not exceed limits reported by
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 4af58459a1e7..ede4f9154cd2 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -71,11 +71,13 @@ enum {
  * struct kernel_ethtool_ringparam - RX/TX ring configuration
  * @rx_buf_len: Current length of buffers on the rx ring.
  * @tcp_data_split: Scatter packet headers and data to separate buffers
+ * @tx_push: The flag of tx push mode
  * @cqe_size: Size of TX/RX completion queue event
  */
 struct kernel_ethtool_ringparam {
 	u32	rx_buf_len;
 	u8	tcp_data_split;
+	u8	tx_push;
 	u32	cqe_size;
 };
 
@@ -87,6 +89,7 @@ struct kernel_ethtool_ringparam {
 enum ethtool_supported_ring_param {
 	ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
 	ETHTOOL_RING_USE_CQE_SIZE   = BIT(1),
+	ETHTOOL_RING_USE_TX_PUSH    = BIT(2),
 };
 
 #define __ETH_RSS_HASH_BIT(bit)	((u32)1 << (bit))
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 979850221b8d..d2fb4f7be61b 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -338,6 +338,7 @@ enum {
 	ETHTOOL_A_RINGS_RX_BUF_LEN,                     /* u32 */
 	ETHTOOL_A_RINGS_TCP_DATA_SPLIT,			/* u8 */
 	ETHTOOL_A_RINGS_CQE_SIZE,			/* u32 */
+	ETHTOOL_A_RINGS_TX_PUSH,			/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_RINGS_CNT,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 29d01662a48b..7919ddb2371c 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -363,7 +363,7 @@ extern const struct nla_policy ethnl_features_set_policy[ETHTOOL_A_FEATURES_WANT
 extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_HEADER + 1];
 extern const struct nla_policy ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_FLAGS + 1];
 extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_HEADER + 1];
-extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_CQE_SIZE + 1];
+extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_TX_PUSH + 1];
 extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 9f33c9689b56..9ed60c507d97 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -55,7 +55,8 @@ static int rings_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_TX */
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_BUF_LEN */
 	       nla_total_size(sizeof(u8))  +	/* _RINGS_TCP_DATA_SPLIT */
-	       nla_total_size(sizeof(u32));	/* _RINGS_CQE_SIZE */
+	       nla_total_size(sizeof(u32)  +	/* _RINGS_CQE_SIZE */
+	       nla_total_size(sizeof(u8)));	/* _RINGS_TX_PUSH */
 }
 
 static int rings_fill_reply(struct sk_buff *skb,
@@ -94,7 +95,8 @@ static int rings_fill_reply(struct sk_buff *skb,
 	     (nla_put_u8(skb, ETHTOOL_A_RINGS_TCP_DATA_SPLIT,
 			 kr->tcp_data_split))) ||
 	    (kr->cqe_size &&
-	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CQE_SIZE, kr->cqe_size))))
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CQE_SIZE, kr->cqe_size))) ||
+	    nla_put_u8(skb, ETHTOOL_A_RINGS_TX_PUSH, !!kr->tx_push))
 		return -EMSGSIZE;
 
 	return 0;
@@ -123,6 +125,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
 	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = NLA_POLICY_MIN(NLA_U32, 1),
 	[ETHTOOL_A_RINGS_CQE_SIZE]		= NLA_POLICY_MIN(NLA_U32, 1),
+	[ETHTOOL_A_RINGS_TX_PUSH]		= NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
@@ -149,6 +152,15 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 	if (!ops->get_ringparam || !ops->set_ringparam)
 		goto out_dev;
 
+	if (tb[ETHTOOL_A_RINGS_TX_PUSH] &&
+	    !(ops->supported_ring_params & ETHTOOL_RING_USE_TX_PUSH)) {
+		ret = -EOPNOTSUPP;
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_RINGS_TX_PUSH],
+				    "setting tx push not supported");
+		goto out_dev;
+	}
+
 	rtnl_lock();
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
@@ -165,6 +177,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 			 tb[ETHTOOL_A_RINGS_RX_BUF_LEN], &mod);
 	ethnl_update_u32(&kernel_ringparam.cqe_size,
 			 tb[ETHTOOL_A_RINGS_CQE_SIZE], &mod);
+	ethnl_update_u8(&kernel_ringparam.tx_push,
+			tb[ETHTOOL_A_RINGS_TX_PUSH], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
-- 
2.33.0

