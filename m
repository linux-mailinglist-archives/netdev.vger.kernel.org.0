Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485223F27BA
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbhHTHkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:40:11 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8898 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238802AbhHTHjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 03:39:52 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GrYLz6QrWz8srh;
        Fri, 20 Aug 2021 15:35:07 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 15:39:12 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 15:39:12 +0800
From:   Yufeng Mo <moyufeng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <shenjian15@huawei.com>,
        <lipeng321@huawei.com>, <yisen.zhuang@huawei.com>,
        <linyunsheng@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>, <salil.mehta@huawei.com>,
        <moyufeng@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH V3 net-next 1/4] ethtool: add two coalesce attributes for CQE mode
Date:   Fri, 20 Aug 2021 15:35:17 +0800
Message-ID: <1629444920-25437-2-git-send-email-moyufeng@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629444920-25437-1-git-send-email-moyufeng@huawei.com>
References: <1629444920-25437-1-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there are many drivers who support CQE mode configuration,
some configure it as a fixed when initialized, some provide an
interface to change it by ethtool private flags. In order to make it
more generic, add two new 'ETHTOOL_A_COALESCE_USE_CQE_TX' and
'ETHTOOL_A_COALESCE_USE_CQE_RX' coalesce attributes, then these
parameters can be accessed by ethtool netlink coalesce uAPI.

Also add an new structure kernel_ethtool_coalesce, then the
new parameter can be added into this struct.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst | 15 +++++++++++++++
 include/linux/ethtool.h                      | 11 ++++++++++-
 include/uapi/linux/ethtool_netlink.h         |  2 ++
 net/ethtool/coalesce.c                       | 19 +++++++++++++++++--
 net/ethtool/netlink.h                        |  2 +-
 5 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index c690bb3..d9b55b7 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -947,12 +947,25 @@ Kernel response contents:
   ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
   ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
+  ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
   ===========================================  ======  =======================
 
 Attributes are only included in reply if their value is not zero or the
 corresponding bit in ``ethtool_ops::supported_coalesce_params`` is set (i.e.
 they are declared as supported by driver).
 
+Timer reset mode (``ETHTOOL_A_COALESCE_USE_CQE_TX`` and
+``ETHTOOL_A_COALESCE_USE_CQE_RX``) controls the interaction between packet
+arrival and the various time based delay parameters. By default timers are
+expected to limit the max delay between any packet arrival/departure and a
+corresponding interrupt. In this mode timer should be started by packet
+arrival (sometimes delivery of previous interrupt) and reset when interrupt
+is delivered.
+Setting the appropriate attribute to 1 will enable ``CQE`` mode, where
+each packet event resets the timer. In this mode timer is used to force
+the interrupt if queue goes idle, while busy queues depend on the packet
+limit to trigger interrupts.
 
 COALESCE_SET
 ============
@@ -985,6 +998,8 @@ Request contents:
   ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
   ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
+  ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
   ===========================================  ======  =======================
 
 Request is rejected if it attributes declared as unsupported by driver (i.e.
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 4711b96..a9d77a6 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -172,6 +172,11 @@ extern int
 __ethtool_get_link_ksettings(struct net_device *dev,
 			     struct ethtool_link_ksettings *link_ksettings);
 
+struct kernel_ethtool_coalesce {
+	u8 use_cqe_mode_tx;
+	u8 use_cqe_mode_rx;
+};
+
 /**
  * ethtool_intersect_link_masks - Given two link masks, AND them together
  * @dst: first mask and where result is stored
@@ -211,7 +216,9 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 #define ETHTOOL_COALESCE_TX_USECS_HIGH		BIT(19)
 #define ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH	BIT(20)
 #define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
-#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(21, 0)
+#define ETHTOOL_COALESCE_USE_CQE_RX		BIT(22)
+#define ETHTOOL_COALESCE_USE_CQE_TX		BIT(23)
+#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(23, 0)
 
 #define ETHTOOL_COALESCE_USECS						\
 	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
@@ -237,6 +244,8 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_RX_USECS_LOW | ETHTOOL_COALESCE_RX_USECS_HIGH | \
 	 ETHTOOL_COALESCE_PKT_RATE_LOW | ETHTOOL_COALESCE_PKT_RATE_HIGH | \
 	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
+#define ETHTOOL_COALESCE_USE_CQE					\
+	(ETHTOOL_COALESCE_USE_CQE_RX | ETHTOOL_COALESCE_USE_CQE_TX)
 
 #define ETHTOOL_STAT_NOT_SET	(~0ULL)
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index b3b9371..5545f1c 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -377,6 +377,8 @@ enum {
 	ETHTOOL_A_COALESCE_TX_USECS_HIGH,		/* u32 */
 	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,		/* u32 */
 	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
+	ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,		/* u8 */
+	ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,		/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_COALESCE_CNT,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 1d6bc13..e6bc536 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -10,6 +10,7 @@ struct coalesce_req_info {
 struct coalesce_reply_data {
 	struct ethnl_reply_data		base;
 	struct ethtool_coalesce		coalesce;
+	struct kernel_ethtool_coalesce	kernel_coalesce;
 	u32				supported_params;
 };
 
@@ -100,7 +101,9 @@ static int coalesce_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _RX_MAX_FRAMES_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _TX_USECS_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES_HIGH */
-	       nla_total_size(sizeof(u32));	/* _RATE_SAMPLE_INTERVAL */
+	       nla_total_size(sizeof(u32)) +	/* _RATE_SAMPLE_INTERVAL */
+	       nla_total_size(sizeof(u8)) +	/* _USE_CQE_MODE_TX */
+	       nla_total_size(sizeof(u8));	/* _USE_CQE_MODE_RX */
 }
 
 static bool coalesce_put_u32(struct sk_buff *skb, u16 attr_type, u32 val,
@@ -124,6 +127,7 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 			       const struct ethnl_reply_data *reply_base)
 {
 	const struct coalesce_reply_data *data = COALESCE_REPDATA(reply_base);
+	const struct kernel_ethtool_coalesce *kcoal = &data->kernel_coalesce;
 	const struct ethtool_coalesce *coal = &data->coalesce;
 	u32 supported = data->supported_params;
 
@@ -170,7 +174,11 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,
 			     coal->tx_max_coalesced_frames_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,
-			     coal->rate_sample_interval, supported))
+			     coal->rate_sample_interval, supported) ||
+	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,
+			      kcoal->use_cqe_mode_tx, supported) ||
+	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,
+			      kcoal->use_cqe_mode_rx, supported))
 		return -EMSGSIZE;
 
 	return 0;
@@ -215,10 +223,13 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
 	[ETHTOOL_A_COALESCE_TX_USECS_HIGH]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]	= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]	= NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 {
+	struct kernel_ethtool_coalesce kernel_coalesce = {};
 	struct ethtool_coalesce coalesce = {};
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
@@ -303,6 +314,10 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], &mod);
 	ethnl_update_u32(&coalesce.rate_sample_interval,
 			 tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL], &mod);
+	ethnl_update_u8(&kernel_coalesce.use_cqe_mode_tx,
+			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX], &mod);
+	ethnl_update_u8(&kernel_coalesce.use_cqe_mode_rx,
+			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 077aac3..e8987e2 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -359,7 +359,7 @@ extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_TX + 1];
 extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
-extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL + 1];
+extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1];
 extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_HEADER + 1];
 extern const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_TX + 1];
 extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_HEADER + 1];
-- 
2.8.1

