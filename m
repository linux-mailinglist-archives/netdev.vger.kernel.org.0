Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0F42B8A83
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgKSDyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:54:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8114 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgKSDx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:53:59 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cc5Ps2cMFzLqhG;
        Thu, 19 Nov 2020 11:53:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Thu, 19 Nov 2020 11:53:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 1/2] ethtool: add support for controling the type of adaptive coalescing
Date:   Thu, 19 Nov 2020 11:54:09 +0800
Message-ID: <1605758050-21061-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
References: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the information whether the adaptive behavior is implemented
by DIM or driver custom is useful, so add new attribute to
ETHTOOL_MSG_COALESCE_GET/ETHTOOL_MSG_COALESCE_SET commands to control
the type of adaptive coalescing.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 include/linux/ethtool.h              |  1 +
 include/uapi/linux/ethtool.h         |  2 ++
 include/uapi/linux/ethtool_netlink.h |  1 +
 net/ethtool/coalesce.c               | 11 +++++++++--
 net/ethtool/netlink.h                |  2 +-
 5 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 6408b44..f57cb92 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -215,6 +215,7 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 #define ETHTOOL_COALESCE_TX_USECS_HIGH		BIT(19)
 #define ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH	BIT(20)
 #define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
+#define ETHTOOL_COALESCE_USE_DIM		BIT(22)
 
 #define ETHTOOL_COALESCE_USECS						\
 	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 9ca87bc..afd8de2 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -433,6 +433,7 @@ struct ethtool_modinfo {
  *	a TX interrupt, when the packet rate is above @pkt_rate_high.
  * @rate_sample_interval: How often to do adaptive coalescing packet rate
  *	sampling, measured in seconds.  Must not be zero.
+ * @use_dim: Use DIM for IRQ coalescing, if adaptive coalescing is enabled.
  *
  * Each pair of (usecs, max_frames) fields specifies that interrupts
  * should be coalesced until
@@ -483,6 +484,7 @@ struct ethtool_coalesce {
 	__u32	tx_coalesce_usecs_high;
 	__u32	tx_max_coalesced_frames_high;
 	__u32	rate_sample_interval;
+	__u32	use_dim;
 };
 
 /**
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index e2bf36e..e3458d9 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -366,6 +366,7 @@ enum {
 	ETHTOOL_A_COALESCE_TX_USECS_HIGH,		/* u32 */
 	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,		/* u32 */
 	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
+	ETHTOOL_A_COALESCE_USE_DIM,			/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_COALESCE_CNT,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 1d6bc13..f12e5de 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -50,6 +50,7 @@ __CHECK_SUPPORTED_OFFSET(COALESCE_RX_MAX_FRAMES_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_TX_USECS_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_TX_MAX_FRAMES_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_RATE_SAMPLE_INTERVAL);
+__CHECK_SUPPORTED_OFFSET(COALESCE_USE_DIM);
 
 const struct nla_policy ethnl_coalesce_get_policy[] = {
 	[ETHTOOL_A_COALESCE_HEADER]		=
@@ -100,7 +101,8 @@ static int coalesce_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _RX_MAX_FRAMES_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _TX_USECS_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES_HIGH */
-	       nla_total_size(sizeof(u32));	/* _RATE_SAMPLE_INTERVAL */
+	       nla_total_size(sizeof(u32)) +	/* _RATE_SAMPLE_INTERVAL */
+	       nla_total_size(sizeof(u8));	/* _USE_DIM */
 }
 
 static bool coalesce_put_u32(struct sk_buff *skb, u16 attr_type, u32 val,
@@ -170,7 +172,9 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,
 			     coal->tx_max_coalesced_frames_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,
-			     coal->rate_sample_interval, supported))
+			     coal->rate_sample_interval, supported) ||
+	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_DIM,
+			      coal->use_dim, supported))
 		return -EMSGSIZE;
 
 	return 0;
@@ -215,6 +219,7 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
 	[ETHTOOL_A_COALESCE_TX_USECS_HIGH]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_USE_DIM]		= { .type = NLA_U8 },
 };
 
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
@@ -303,6 +308,8 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], &mod);
 	ethnl_update_u32(&coalesce.rate_sample_interval,
 			 tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL], &mod);
+	ethnl_update_bool32(&coalesce.use_dim,
+			    tb[ETHTOOL_A_COALESCE_USE_DIM], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index d8efec5..e63f44a 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -366,7 +366,7 @@ extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_TX + 1];
 extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
-extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL + 1];
+extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_USE_DIM + 1];
 extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_HEADER + 1];
 extern const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_TX + 1];
 extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_HEADER + 1];
-- 
2.7.4

