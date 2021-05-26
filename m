Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968C83913A1
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 11:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhEZJ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 05:29:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3949 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbhEZJ31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 05:29:27 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FqlsV0Y5FzCxBy;
        Wed, 26 May 2021 17:25:02 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 17:27:54 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 17:27:53 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jesse.brandeburg@intel.com>,
        <jacob.e.keller@intel.com>, <ioana.ciornei@nxp.com>,
        <vladimir.oltean@nxp.com>, <sgoutham@marvell.com>,
        <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: [RFC net-next 2/4] ethtool: extend coalesce setting uAPI with CQE mode
Date:   Wed, 26 May 2021 17:27:40 +0800
Message-ID: <1622021262-8881-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622021262-8881-1-git-send-email-tanhuazhong@huawei.com>
References: <1622021262-8881-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there many drivers who support CQE mode configuration,
some configure it as a fixed when initialized, some provide an
interface to change it by ethtool private flags. In order make it
more generic, add 'ETHTOOL_A_COALESCE_USE_CQE_TX' and
'ETHTOOL_A_COALESCE_USE_CQE_RX' attribute and expand struct
kernel_ethtool_coalesce with use_cqe_mode_tx and use_cqe_mode_rx,
then these parameters can be accessed by ethtool netlink coalesce
uAPI.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 Documentation/networking/ethtool-netlink.rst |  4 ++++
 include/linux/ethtool.h                      |  6 +++++-
 include/uapi/linux/ethtool_netlink.h         |  2 ++
 net/ethtool/coalesce.c                       | 19 ++++++++++++++++---
 net/ethtool/netlink.h                        |  2 +-
 5 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 25131df..975394e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -937,6 +937,8 @@ Kernel response contents:
   ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
   ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    Tx CQE mode
+  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    Rx CQE mode
   ===========================================  ======  =======================
 
 Attributes are only included in reply if their value is not zero or the
@@ -975,6 +977,8 @@ Request contents:
   ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
   ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    Tx CQE mode
+  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    Rx CQE mode
   ===========================================  ======  =======================
 
 Request is rejected if it attributes declared as unsupported by driver (i.e.
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 1030540..9d0a386 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -179,6 +179,8 @@ __ethtool_get_link_ksettings(struct net_device *dev,
 
 struct kernel_ethtool_coalesce {
 	struct ethtool_coalesce	base;
+	__u32	use_cqe_mode_tx;
+	__u32	use_cqe_mode_rx;
 };
 
 /**
@@ -220,7 +222,9 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 #define ETHTOOL_COALESCE_TX_USECS_HIGH		BIT(19)
 #define ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH	BIT(20)
 #define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
-#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(21, 0)
+#define ETHTOOL_COALESCE_USE_CQE_RX		BIT(22)
+#define ETHTOOL_COALESCE_USE_CQE_TX		BIT(23)
+#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(23, 0)
 
 #define ETHTOOL_COALESCE_USECS						\
 	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 825cfda..1ad32a4 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -375,6 +375,8 @@ enum {
 	ETHTOOL_A_COALESCE_TX_USECS_HIGH,		/* u32 */
 	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,		/* u32 */
 	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
+	ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,		/* u8 */
+	ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,		/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_COALESCE_CNT,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 70e6331..2000c56 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -101,7 +101,9 @@ static int coalesce_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _RX_MAX_FRAMES_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _TX_USECS_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES_HIGH */
-	       nla_total_size(sizeof(u32));	/* _RATE_SAMPLE_INTERVAL */
+	       nla_total_size(sizeof(u32)) +	/* _RATE_SAMPLE_INTERVAL */
+	       nla_total_size(sizeof(u8)) +	/* _USE_CQE_MODE_TX */
+	       nla_total_size(sizeof(u8));	/* _USE_CQE_MODE_RX */
 }
 
 static bool coalesce_put_u32(struct sk_buff *skb, u16 attr_type, u32 val,
@@ -125,7 +127,8 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 			       const struct ethnl_reply_data *reply_base)
 {
 	const struct coalesce_reply_data *data = COALESCE_REPDATA(reply_base);
-	const struct ethtool_coalesce *cbase = &data->coalesce.base;
+	const struct kernel_ethtool_coalesce *coalesce = &data->coalesce;
+	const struct ethtool_coalesce *cbase = &coalesce->base;
 	u32 supported = data->supported_params;
 
 	if (coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS,
@@ -171,7 +174,11 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,
 			     cbase->tx_max_coalesced_frames_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,
-			     cbase->rate_sample_interval, supported))
+			     cbase->rate_sample_interval, supported) ||
+	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,
+			      coalesce->use_cqe_mode_tx, supported) ||
+	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,
+			      coalesce->use_cqe_mode_rx, supported))
 		return -EMSGSIZE;
 
 	return 0;
@@ -216,6 +223,8 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
 	[ETHTOOL_A_COALESCE_TX_USECS_HIGH]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]	= { .type = NLA_U8 },
+	[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]	= { .type = NLA_U8 },
 };
 
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
@@ -305,6 +314,10 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], &mod);
 	ethnl_update_u32(&cbase->rate_sample_interval,
 			 tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL], &mod);
+	ethnl_update_bool32(&coalesce.use_cqe_mode_tx,
+			    tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX], &mod);
+	ethnl_update_bool32(&coalesce.use_cqe_mode_rx,
+			    tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 8abcbc1..868e33e 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -369,7 +369,7 @@ extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_TX + 1];
 extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
-extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL + 1];
+extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1];
 extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_HEADER + 1];
 extern const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_TX + 1];
 extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_HEADER + 1];
-- 
2.7.4

