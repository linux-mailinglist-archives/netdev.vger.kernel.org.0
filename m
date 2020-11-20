Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026072BA244
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 07:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgKTGYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 01:24:51 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8008 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgKTGYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 01:24:50 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CcmjR1ZgXzhY7J;
        Fri, 20 Nov 2020 14:24:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Nov 2020 14:24:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <mkubecek@suse.cz>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC V2 net-next 1/2] ethtool: add support for controling the type of adaptive coalescing
Date:   Fri, 20 Nov 2020 14:24:38 +0800
Message-ID: <1605853479-4483-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605853479-4483-1-git-send-email-tanhuazhong@huawei.com>
References: <1605853479-4483-1-git-send-email-tanhuazhong@huawei.com>
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

In order to compatible with ioctl code, add a extended coalescing
handler to deal with it in the netlink API, then other new extended
coalescing parameters can utiliaze it as well.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 Documentation/networking/ethtool-netlink.rst |  1 +
 include/linux/ethtool.h                      | 14 +++++++++++
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/coalesce.c                       | 35 ++++++++++++++++++++++++++--
 net/ethtool/netlink.h                        |  2 +-
 5 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 30b9824..dae7145 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -928,6 +928,7 @@ Kernel response contents:
   ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
   ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ``ETHTOOL_A_COALESCE_USE_DIM``               bool    using DIM adaptive
   ===========================================  ======  =======================
 
 Attributes are only included in reply if their value is not zero or the
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 6408b44..4426d65 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -215,6 +215,7 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 #define ETHTOOL_COALESCE_TX_USECS_HIGH		BIT(19)
 #define ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH	BIT(20)
 #define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
+#define ETHTOOL_COALESCE_USE_DIM		BIT(22)
 
 #define ETHTOOL_COALESCE_USECS						\
 	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
@@ -241,6 +242,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_PKT_RATE_LOW | ETHTOOL_COALESCE_PKT_RATE_HIGH | \
 	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
 
+struct ethtool_ext_coalesce {
+	__u32 use_dim;
+};
+
 #define ETHTOOL_STAT_NOT_SET	(~0ULL)
 
 /**
@@ -298,9 +303,14 @@ struct ethtool_pause_stats {
  *	or zero.
  * @get_coalesce: Get interrupt coalescing parameters.  Returns a negative
  *	error code or zero.
+ * @get_ext_coalesce: Get extended interrupt coalescing parameters.
+ *	Returns a negative error code or zero.
  * @set_coalesce: Set interrupt coalescing parameters.  Supported coalescing
  *	types should be set in @supported_coalesce_params.
  *	Returns a negative error code or zero.
+ * @set_ext_coalesce: Set extended interrupt coalescing parameters.  Supported
+ *	extended coalescing types should be set in @supported_coalesce_params.
+ *	Returns a negative error code or zero.
  * @get_ringparam: Report ring sizes
  * @set_ringparam: Set ring sizes.  Returns a negative error code or zero.
  * @get_pause_stats: Report pause frame statistics. Drivers must not zero
@@ -437,7 +447,11 @@ struct ethtool_ops {
 	int	(*set_eeprom)(struct net_device *,
 			      struct ethtool_eeprom *, u8 *);
 	int	(*get_coalesce)(struct net_device *, struct ethtool_coalesce *);
+	int	(*get_ext_coalesce)(struct net_device *,
+				    struct ethtool_ext_coalesce *);
 	int	(*set_coalesce)(struct net_device *, struct ethtool_coalesce *);
+	int	(*set_ext_coalesce)(struct net_device *,
+				    struct ethtool_ext_coalesce *);
 	void	(*get_ringparam)(struct net_device *,
 				 struct ethtool_ringparam *);
 	int	(*set_ringparam)(struct net_device *,
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
index 1d6bc13..d4d8901 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -11,6 +11,7 @@ struct coalesce_reply_data {
 	struct ethnl_reply_data		base;
 	struct ethtool_coalesce		coalesce;
 	u32				supported_params;
+	struct ethtool_ext_coalesce	ext_coalesce;
 };
 
 #define COALESCE_REPDATA(__reply_base) \
@@ -50,6 +51,7 @@ __CHECK_SUPPORTED_OFFSET(COALESCE_RX_MAX_FRAMES_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_TX_USECS_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_TX_MAX_FRAMES_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_RATE_SAMPLE_INTERVAL);
+__CHECK_SUPPORTED_OFFSET(COALESCE_USE_DIM);
 
 const struct nla_policy ethnl_coalesce_get_policy[] = {
 	[ETHTOOL_A_COALESCE_HEADER]		=
@@ -71,6 +73,14 @@ static int coalesce_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 	ret = dev->ethtool_ops->get_coalesce(dev, &data->coalesce);
+
+	if (dev->ethtool_ops->get_ext_coalesce) {
+		ret = dev->ethtool_ops->get_ext_coalesce(dev,
+			&data->ext_coalesce);
+		if (ret < 0)
+			return ret;
+	}
+
 	ethnl_ops_complete(dev);
 
 	return ret;
@@ -100,7 +110,8 @@ static int coalesce_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _RX_MAX_FRAMES_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _TX_USECS_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES_HIGH */
-	       nla_total_size(sizeof(u32));	/* _RATE_SAMPLE_INTERVAL */
+	       nla_total_size(sizeof(u32)) +	/* _RATE_SAMPLE_INTERVAL */
+	       nla_total_size(sizeof(u8));	/* _USE_DIM */
 }
 
 static bool coalesce_put_u32(struct sk_buff *skb, u16 attr_type, u32 val,
@@ -124,6 +135,7 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 			       const struct ethnl_reply_data *reply_base)
 {
 	const struct coalesce_reply_data *data = COALESCE_REPDATA(reply_base);
+	const struct ethtool_ext_coalesce *ext_coal = &data->ext_coalesce;
 	const struct ethtool_coalesce *coal = &data->coalesce;
 	u32 supported = data->supported_params;
 
@@ -170,7 +182,9 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,
 			     coal->tx_max_coalesced_frames_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,
-			     coal->rate_sample_interval, supported))
+			     coal->rate_sample_interval, supported) ||
+	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_DIM,
+			      ext_coal->use_dim, supported))
 		return -EMSGSIZE;
 
 	return 0;
@@ -215,10 +229,12 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
 	[ETHTOOL_A_COALESCE_TX_USECS_HIGH]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_USE_DIM]		= { .type = NLA_U8 },
 };
 
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 {
+	struct ethtool_ext_coalesce ext_coalesce = {};
 	struct ethtool_coalesce coalesce = {};
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
@@ -259,6 +275,12 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		goto out_ops;
 
+	if (ops->get_ext_coalesce) {
+		ret = ops->get_ext_coalesce(dev, &ext_coalesce);
+		if (ret < 0)
+			goto out_ops;
+	}
+
 	ethnl_update_u32(&coalesce.rx_coalesce_usecs,
 			 tb[ETHTOOL_A_COALESCE_RX_USECS], &mod);
 	ethnl_update_u32(&coalesce.rx_max_coalesced_frames,
@@ -303,6 +325,8 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], &mod);
 	ethnl_update_u32(&coalesce.rate_sample_interval,
 			 tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL], &mod);
+	ethnl_update_bool32(&ext_coalesce.use_dim,
+			    tb[ETHTOOL_A_COALESCE_USE_DIM], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
@@ -310,6 +334,13 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
 	if (ret < 0)
 		goto out_ops;
+
+	if (ops->set_ext_coalesce) {
+		ret = ops->set_ext_coalesce(dev, &ext_coalesce);
+		if (ret < 0)
+			goto out_ops;
+	}
+
 	ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
 
 out_ops:
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

