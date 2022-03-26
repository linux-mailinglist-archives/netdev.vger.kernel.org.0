Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738304E8020
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 09:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiCZI6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 04:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiCZI6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 04:58:15 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43729133669
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 01:56:38 -0700 (PDT)
Received: from kwepemi100005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KQXpX3wpPzfZj7;
        Sat, 26 Mar 2022 16:55:00 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100005.china.huawei.com (7.221.188.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 16:56:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 16:56:35 +0800
From:   Jie Wang <wangjie125@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
Subject: [RFCv2 PATCH net-next 1/2] net-next: ethtool: extend ringparam set/get APIs for tx_push
Date:   Sat, 26 Mar 2022 16:51:01 +0800
Message-ID: <20220326085102.14111-2-wangjie125@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220326085102.14111-1-wangjie125@huawei.com>
References: <20220326085102.14111-1-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tx push is a standard driver feature which controls use of a fast
path descriptor push. So this patch extends the ringparam APIs and data
structures to support set/get tx push by ethtool -G/g.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 include/linux/ethtool.h              | 3 +++
 include/uapi/linux/ethtool_netlink.h | 1 +
 net/ethtool/netlink.h                | 2 +-
 net/ethtool/rings.c                  | 9 +++++++--
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 4af58459a1e7..096771ee8586 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -72,11 +72,13 @@ enum {
  * @rx_buf_len: Current length of buffers on the rx ring.
  * @tcp_data_split: Scatter packet headers and data to separate buffers
  * @cqe_size: Size of TX/RX completion queue event
+ * @tx_push: The flag of tx push mode
  */
 struct kernel_ethtool_ringparam {
 	u32	rx_buf_len;
 	u8	tcp_data_split;
 	u32	cqe_size;
+	u32	tx_push;
 };
 
 /**
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
index 9f33c9689b56..10f8c99ff17e 100644
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
+	[ETHTOOL_A_RINGS_TX_PUSH]		= { .type = NLA_U8 },
 };
 
 int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
@@ -165,6 +168,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 			 tb[ETHTOOL_A_RINGS_RX_BUF_LEN], &mod);
 	ethnl_update_u32(&kernel_ringparam.cqe_size,
 			 tb[ETHTOOL_A_RINGS_CQE_SIZE], &mod);
+	ethnl_update_bool32(&kernel_ringparam.tx_push,
+			    tb[ETHTOOL_A_RINGS_TX_PUSH], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
-- 
2.33.0

