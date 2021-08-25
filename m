Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8F63F6FC2
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbhHYGpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:45:52 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8769 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239111AbhHYGpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:45:49 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gvc0F4FxTzYsZb;
        Wed, 25 Aug 2021 14:44:29 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:44:46 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:44:46 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/5] ethtool: add support to set/get rx buf len
Date:   Wed, 25 Aug 2021 14:40:53 +0800
Message-ID: <1629873655-51539-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
References: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
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
 include/uapi/linux/ethtool.h         |  2 ++
 include/uapi/linux/ethtool_netlink.h |  1 +
 net/ethtool/netlink.h                |  2 +-
 net/ethtool/rings.c                  | 11 +++++++++--
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 266e95e4fb33..6e26586274b3 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -516,6 +516,7 @@ struct ethtool_coalesce {
  *	jumbo ring
  * @tx_pending: Current maximum supported number of pending entries
  *	per TX ring
+ * @rx_buf_len: Current supported size of rx ring BD buffer.
  *
  * If the interface does not have separate RX mini and/or jumbo rings,
  * @rx_mini_max_pending and/or @rx_jumbo_max_pending will be 0.
@@ -533,6 +534,7 @@ struct ethtool_ringparam {
 	__u32	rx_mini_pending;
 	__u32	rx_jumbo_pending;
 	__u32	tx_pending;
+	__u32	rx_buf_len;
 };
 
 /**
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
index 4e097812a967..8847b1daf477 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -49,7 +49,8 @@ static int rings_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX */
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_MINI */
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_JUMBO */
-	       nla_total_size(sizeof(u32));	/* _RINGS_TX */
+	       nla_total_size(sizeof(u32)) +	/* _RINGS_TX */
+	       nla_total_size(sizeof(u32));     /* _RINGS_RX_BUF_LEN */
 }
 
 static int rings_fill_reply(struct sk_buff *skb,
@@ -78,7 +79,10 @@ static int rings_fill_reply(struct sk_buff *skb,
 	     (nla_put_u32(skb, ETHTOOL_A_RINGS_TX_MAX,
 			  ringparam->tx_max_pending) ||
 	      nla_put_u32(skb, ETHTOOL_A_RINGS_TX,
-			  ringparam->tx_pending))))
+			  ringparam->tx_pending)))  ||
+	    (ringparam->rx_buf_len &&
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN,
+			  ringparam->rx_buf_len))))
 		return -EMSGSIZE;
 
 	return 0;
@@ -105,6 +109,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
 	[ETHTOOL_A_RINGS_RX_MINI]		= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_U32 },
+	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = { .type = NLA_U32 },
 };
 
 int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
@@ -142,6 +147,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 	ethnl_update_u32(&ringparam.rx_jumbo_pending,
 			 tb[ETHTOOL_A_RINGS_RX_JUMBO], &mod);
 	ethnl_update_u32(&ringparam.tx_pending, tb[ETHTOOL_A_RINGS_TX], &mod);
+	ethnl_update_u32(&ringparam.rx_buf_len,
+			 tb[ETHTOOL_A_RINGS_RX_BUF_LEN], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
-- 
2.8.1

