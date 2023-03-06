Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58486ABC82
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 11:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjCFK1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 05:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjCFK1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 05:27:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BEC22A14;
        Mon,  6 Mar 2023 02:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2CF560DD8;
        Mon,  6 Mar 2023 10:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18B8C433D2;
        Mon,  6 Mar 2023 10:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678098390;
        bh=Z6XUi8HThtUC/7ITH8z0uSvGHNIyG1szAZbUsttvsrI=;
        h=From:To:Cc:Subject:Date:From;
        b=I9TmZ/jWUNxwfwxW1LEGhpNd2lkkmg3iR1bCKME4+GzhHr/6iNt1qlK7nEMT8hsQw
         nVQAypuM2JoCODxZv4obd38G5dLVg9XwonALpWxqc0A7Lq/z3ev8DD17Dkvr0AiUR4
         DfRQpoK/s/JXegsGtr+04mwtC27iCBr+A1CnmKL3bEj1v5PFJbBSfi3gbGEfW/JH+d
         I9QST+Lu9toN0gLXhjT+KP3Ffek9pqsFOgdkjYRwmzIN9sb0Jx0iH/q9D6w7Jhq4oZ
         3QF4iBsbbmpqraYA1taCbOe/TgmOkHmulNVw1iaHz/0FzfEjMnontMory7wTO4l/Ha
         pilCpgJ3kNZ0g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, hawk@kernel.org,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        lorenzo.bianconi@redhat.com
Subject: [RFC net-next] ethtool: provide XDP information with XDP_FEATURES_GET
Date:   Mon,  6 Mar 2023 11:26:10 +0100
Message-Id: <ced8d727138d487332e32739b392ec7554e7a241.1678098067.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement XDP_FEATURES_GET request to get network device information
about supported xdp functionalities through ethtool.

Tested-by: Matteo Croce <teknoraver@meta.com>
Co-developed-by: Marek Majtyka <alardam@gmail.com>
Signed-off-by: Marek Majtyka <alardam@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 Documentation/netlink/specs/netdev.yaml | 12 +++++
 include/uapi/linux/ethtool.h            | 15 ++++++
 include/uapi/linux/ethtool_netlink.h    | 14 +++++
 include/uapi/linux/netdev.h             | 13 +++++
 net/ethtool/Makefile                    |  2 +-
 net/ethtool/common.c                    | 11 ++++
 net/ethtool/common.h                    |  2 +
 net/ethtool/ioctl.c                     | 40 ++++++++++++++
 net/ethtool/netlink.c                   | 10 ++++
 net/ethtool/netlink.h                   |  2 +
 net/ethtool/strset.c                    |  5 ++
 net/ethtool/xdp.c                       | 69 +++++++++++++++++++++++++
 tools/include/uapi/linux/netdev.h       | 13 +++++
 13 files changed, 207 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/xdp.c

diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index 7e4a5b4e7162..b33604cccd23 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -40,6 +40,18 @@ definitions:
         doc:
           This feature informs if netdev implements non-linear XDP buffer
           support in ndo_xdp_xmit callback.
+  -
+    type: enum
+    name: xdp-act-bit
+    render-max: true
+    entries:
+      - name: basic-bit
+      - name: redirect-bit
+      - name: ndo-xmit-bit
+      - name: xsk-zerocopy-bit
+      - name: hw-offload-bit
+      - name: rx-sg-bit
+      - name: ndo-xmit-sg-bit
 
 attribute-sets:
   -
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f7fba0dc87e5..2c52adf7cb69 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -681,6 +681,7 @@ enum ethtool_link_ext_substate_module {
  * @ETH_SS_STATS_ETH_MAC: names of IEEE 802.3 MAC statistics
  * @ETH_SS_STATS_ETH_CTRL: names of IEEE 802.3 MAC Control statistics
  * @ETH_SS_STATS_RMON: names of RMON statistics
+ * @ETH_SS_XDP_FEATURES: names of XDP supported features
  *
  * @ETH_SS_COUNT: number of defined string sets
  */
@@ -706,6 +707,7 @@ enum ethtool_stringset {
 	ETH_SS_STATS_ETH_MAC,
 	ETH_SS_STATS_ETH_CTRL,
 	ETH_SS_STATS_RMON,
+	ETH_SS_XDP_FEATURES,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
@@ -1429,6 +1431,18 @@ struct ethtool_sfeatures {
 	struct ethtool_set_features_block features[];
 };
 
+/**
+ * struct ethtool_xdp_gfeatures - command to get supported XDP features
+ * @cmd: command number = %ETHTOOL_XDP_GFEATURES
+ * size: array size of the features[] array
+ * @features: XDP feature masks
+ */
+struct ethtool_xdp_gfeatures {
+	__u32	cmd;
+	__u32	size;
+	__u32	features[];
+};
+
 /**
  * struct ethtool_ts_info - holds a device's timestamping and PHC association
  * @cmd: command number = %ETHTOOL_GET_TS_INFO
@@ -1670,6 +1684,7 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_PHY_STUNABLE	0x0000004f /* Set PHY tunable configuration */
 #define ETHTOOL_GFECPARAM	0x00000050 /* Get FEC settings */
 #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
+#define ETHTOOL_XDP_GFEATURES	0x00000052 /* Get XDP features */
 
 /* compatibility with older code */
 #define SPARC_ETH_GSET		ETHTOOL_GSET
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d39ce21381c5..cf859d774e91 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -57,6 +57,7 @@ enum {
 	ETHTOOL_MSG_PLCA_GET_STATUS,
 	ETHTOOL_MSG_MM_GET,
 	ETHTOOL_MSG_MM_SET,
+	ETHTOOL_MSG_XDP_FEATURES_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -109,6 +110,7 @@ enum {
 	ETHTOOL_MSG_PLCA_NTF,
 	ETHTOOL_MSG_MM_GET_REPLY,
 	ETHTOOL_MSG_MM_NTF,
+	ETHTOOL_MSG_XDP_FEATURES_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -973,6 +975,18 @@ enum {
 	ETHTOOL_A_MM_MAX = (__ETHTOOL_A_MM_CNT - 1)
 };
 
+/* XDP */
+
+enum {
+	ETHTOOL_A_XDP_FEATURES_UNSPEC,
+	ETHTOOL_A_XDP_FEATURES_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_XDP_FEATURES_DATA,		/* bitsets */
+
+	/* add new constants above here */
+	__ETHTOOL_A_XDP_FEATURES_CNT,
+	ETHTOOL_A_XDP_FEATURES_MAX = __ETHTOOL_A_XDP_FEATURES_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 497cfc93f2e3..ca7678e5f16f 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -37,6 +37,19 @@ enum netdev_xdp_act {
 	NETDEV_XDP_ACT_MASK = 127,
 };
 
+enum netdev_xdp_act_bit {
+	NETDEV_XDP_ACT_BIT_BASIC_BIT,
+	NETDEV_XDP_ACT_BIT_REDIRECT_BIT,
+	NETDEV_XDP_ACT_BIT_NDO_XMIT_BIT,
+	NETDEV_XDP_ACT_BIT_XSK_ZEROCOPY_BIT,
+	NETDEV_XDP_ACT_BIT_HW_OFFLOAD_BIT,
+	NETDEV_XDP_ACT_BIT_RX_SG_BIT,
+	NETDEV_XDP_ACT_BIT_NDO_XMIT_SG_BIT,
+
+	__NETDEV_XDP_ACT_BIT_MAX,
+	NETDEV_XDP_ACT_BIT_MAX = (__NETDEV_XDP_ACT_BIT_MAX - 1)
+};
+
 enum {
 	NETDEV_A_DEV_IFINDEX = 1,
 	NETDEV_A_DEV_PAD,
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 504f954a1b28..0c5463c07223 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -8,4 +8,4 @@ ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o rss.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
 		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o mm.o \
-		   module.o pse-pd.o plca.o mm.o
+		   module.o pse-pd.o plca.o mm.o xdp.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 5fb19050991e..2be672c601ad 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -465,6 +465,17 @@ const char udp_tunnel_type_names[][ETH_GSTRING_LEN] = {
 static_assert(ARRAY_SIZE(udp_tunnel_type_names) ==
 	      __ETHTOOL_UDP_TUNNEL_TYPE_CNT);
 
+const char xdp_features_strings[][ETH_GSTRING_LEN] = {
+	[NETDEV_XDP_ACT_BIT_BASIC_BIT] =	"xdp-basic",
+	[NETDEV_XDP_ACT_BIT_REDIRECT_BIT] =	"xdp-redirect",
+	[NETDEV_XDP_ACT_BIT_NDO_XMIT_BIT] =	"xdp-ndo-xmit",
+	[NETDEV_XDP_ACT_BIT_XSK_ZEROCOPY_BIT] =	"xdp-xsk-zerocopy",
+	[NETDEV_XDP_ACT_BIT_HW_OFFLOAD_BIT] =	"xdp-hw-offload",
+	[NETDEV_XDP_ACT_BIT_RX_SG_BIT] =	"xdp-rx-sg",
+	[NETDEV_XDP_ACT_BIT_NDO_XMIT_SG_BIT] =	"xdp-ndo-xmit-sg",
+};
+static_assert(ARRAY_SIZE(xdp_features_strings) == __NETDEV_XDP_ACT_BIT_MAX);
+
 /* return false if legacy contained non-0 deprecated fields
  * maxtxpkt/maxrxpkt. rest of ksettings always updated
  */
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 28b8aaaf9bcb..9c7fd25664cf 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -7,6 +7,7 @@
 #include <linux/ethtool.h>
 
 #define ETHTOOL_DEV_FEATURE_WORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 32)
+#define ETHTOOL_XDP_FEATURES_WORDS	DIV_ROUND_UP(__NETDEV_XDP_ACT_BIT_MAX, 32)
 
 /* compose link mode index from speed, type and duplex */
 #define ETHTOOL_LINK_MODE(speed, type, duplex) \
@@ -36,6 +37,7 @@ extern const char sof_timestamping_names[][ETH_GSTRING_LEN];
 extern const char ts_tx_type_names[][ETH_GSTRING_LEN];
 extern const char ts_rx_filter_names[][ETH_GSTRING_LEN];
 extern const char udp_tunnel_type_names[][ETH_GSTRING_LEN];
+extern const char xdp_features_strings[__NETDEV_XDP_ACT_BIT_MAX][ETH_GSTRING_LEN];
 
 int __ethtool_get_link(struct net_device *dev);
 
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 646b3e490c71..3d9c14d3ecc8 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -170,6 +170,9 @@ static int __ethtool_get_sset_count(struct net_device *dev, int sset)
 	if (sset == ETH_SS_PHY_TUNABLES)
 		return ARRAY_SIZE(phy_tunable_strings);
 
+	if (sset == ETH_SS_XDP_FEATURES)
+		return __NETDEV_XDP_ACT_BIT_MAX;
+
 	if (sset == ETH_SS_PHY_STATS && dev->phydev &&
 	    !ops->get_ethtool_phy_stats &&
 	    phy_ops && phy_ops->get_sset_count)
@@ -200,6 +203,8 @@ static void __ethtool_get_strings(struct net_device *dev,
 		memcpy(data, tunable_strings, sizeof(tunable_strings));
 	else if (stringset == ETH_SS_PHY_TUNABLES)
 		memcpy(data, phy_tunable_strings, sizeof(phy_tunable_strings));
+	else if (stringset == ETH_SS_XDP_FEATURES)
+		memcpy(data, xdp_features_strings, sizeof(xdp_features_strings));
 	else if (stringset == ETH_SS_PHY_STATS && dev->phydev &&
 		 !ops->get_ethtool_phy_stats && phy_ops &&
 		 phy_ops->get_strings)
@@ -2749,6 +2754,37 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 	return dev->ethtool_ops->set_fecparam(dev, &fecparam);
 }
 
+static int ethtool_get_xdp_features(struct net_device *dev,
+				    void __user *useraddr)
+{
+	u32 copy_size, features[ETHTOOL_XDP_FEATURES_WORDS];
+	struct ethtool_gfeatures cmd = {
+		.cmd = ETHTOOL_XDP_GFEATURES,
+		.size = ETHTOOL_XDP_FEATURES_WORDS,
+	};
+	u32 __user *sizeaddr;
+
+	BUILD_BUG_ON(ETHTOOL_XDP_FEATURES_WORDS != 1);
+	features[0] = dev->xdp_features;
+
+	sizeaddr = useraddr + offsetof(struct ethtool_xdp_gfeatures, size);
+	if (get_user(copy_size, sizeaddr))
+		return -EFAULT;
+
+	if (copy_size > ETHTOOL_XDP_FEATURES_WORDS)
+		copy_size = ETHTOOL_XDP_FEATURES_WORDS;
+
+	if (copy_to_user(useraddr, &cmd, sizeof(cmd)))
+		return -EFAULT;
+
+	useraddr += sizeof(cmd);
+	if (copy_to_user(useraddr, features,
+			 array_size(copy_size, sizeof(*features))))
+		return -EFAULT;
+
+	return 0;
+}
+
 /* The main entry point in this file.  Called from net/core/dev_ioctl.c */
 
 static int
@@ -2808,6 +2844,7 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 	case ETHTOOL_PHY_GTUNABLE:
 	case ETHTOOL_GLINKSETTINGS:
 	case ETHTOOL_GFECPARAM:
+	case ETHTOOL_XDP_GFEATURES:
 		break;
 	default:
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
@@ -3035,6 +3072,9 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 	case ETHTOOL_SFECPARAM:
 		rc = ethtool_set_fecparam(dev, useraddr);
 		break;
+	case ETHTOOL_XDP_GFEATURES:
+		rc = ethtool_get_xdp_features(dev, useraddr);
+		break;
 	default:
 		rc = -EOPNOTSUPP;
 	}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 08120095cc68..084927dc715e 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -306,6 +306,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PLCA_GET_STATUS]	= &ethnl_plca_status_request_ops,
 	[ETHTOOL_MSG_MM_GET]		= &ethnl_mm_request_ops,
 	[ETHTOOL_MSG_MM_SET]		= &ethnl_mm_request_ops,
+	[ETHTOOL_MSG_XDP_FEATURES_GET]	= &ethnl_xdp_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -1156,6 +1157,15 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_mm_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_mm_set_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_XDP_FEATURES_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_xdp_features_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_xdp_features_get_policy) - 1,
+	}
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index f7b189ed96b2..b04580a3b6f5 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -395,6 +395,7 @@ extern const struct ethnl_request_ops ethnl_rss_request_ops;
 extern const struct ethnl_request_ops ethnl_plca_cfg_request_ops;
 extern const struct ethnl_request_ops ethnl_plca_status_request_ops;
 extern const struct ethnl_request_ops ethnl_mm_request_ops;
+extern const struct ethnl_request_ops ethnl_xdp_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -441,6 +442,7 @@ extern const struct nla_policy ethnl_plca_set_cfg_policy[ETHTOOL_A_PLCA_MAX + 1]
 extern const struct nla_policy ethnl_plca_get_status_policy[ETHTOOL_A_PLCA_HEADER + 1];
 extern const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1];
 extern const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1];
+extern const struct nla_policy ethnl_xdp_features_get_policy[ETHTOOL_A_XDP_FEATURES_HEADER + 1];
 
 int ethnl_set_features(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 3f7de54d85fb..a148fe3301f1 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -105,6 +105,11 @@ static const struct strset_info info_template[] = {
 		.count		= __ETHTOOL_A_STATS_RMON_CNT,
 		.strings	= stats_rmon_names,
 	},
+	[ETH_SS_XDP_FEATURES] = {
+		.per_dev	= false,
+		.count		= ARRAY_SIZE(xdp_features_strings),
+		.strings	= xdp_features_strings,
+	},
 };
 
 struct strset_req_info {
diff --git a/net/ethtool/xdp.c b/net/ethtool/xdp.c
new file mode 100644
index 000000000000..fa11a03bb00d
--- /dev/null
+++ b/net/ethtool/xdp.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+const struct nla_policy ethnl_xdp_features_get_policy[] = {
+	[ETHTOOL_A_XDP_FEATURES_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+struct xdp_feature_req_info {
+	struct ethnl_req_info base;
+};
+
+#define XDP_FEATURES_REPDATA(__reply_base)	\
+	container_of(__reply_base, struct xdp_feature_reply_data, base)
+
+struct xdp_feature_reply_data {
+	struct ethnl_reply_data base;
+	u32 features[ETHTOOL_XDP_FEATURES_WORDS];
+};
+
+static int xdp_features_prepare_data(const struct ethnl_req_info *req_base,
+				     struct ethnl_reply_data *reply_base,
+				     struct genl_info *info)
+{
+	struct xdp_feature_reply_data *data = XDP_FEATURES_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+
+	BUILD_BUG_ON(ETHTOOL_XDP_FEATURES_WORDS != 1);
+	data->features[0] = dev->xdp_features;
+
+	return 0;
+}
+
+static int xdp_features_reply_size(const struct ethnl_req_info *req_base,
+				   const struct ethnl_reply_data *reply_base)
+{
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct xdp_feature_reply_data *data;
+
+	data = XDP_FEATURES_REPDATA(reply_base);
+	return ethnl_bitset32_size(data->features, NULL, __NETDEV_XDP_ACT_BIT_MAX,
+				   xdp_features_strings, compact);
+}
+
+static int xdp_features_fill_reply(struct sk_buff *skb,
+				   const struct ethnl_req_info *req_base,
+				   const struct ethnl_reply_data *reply_base)
+{
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct xdp_feature_reply_data *data;
+
+	data = XDP_FEATURES_REPDATA(reply_base);
+	return ethnl_put_bitset32(skb, ETHTOOL_A_XDP_FEATURES_DATA,
+				  data->features, NULL, __NETDEV_XDP_ACT_BIT_MAX,
+				  xdp_features_strings, compact);
+}
+
+const struct ethnl_request_ops ethnl_xdp_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_XDP_FEATURES_GET,
+	.reply_cmd		= ETHTOOL_MSG_XDP_FEATURES_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_XDP_FEATURES_HEADER,
+	.req_info_size		= sizeof(struct xdp_feature_req_info),
+	.reply_data_size	= sizeof(struct xdp_feature_reply_data),
+	.prepare_data		= xdp_features_prepare_data,
+	.reply_size		= xdp_features_reply_size,
+	.fill_reply		= xdp_features_fill_reply,
+};
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index 497cfc93f2e3..ca7678e5f16f 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -37,6 +37,19 @@ enum netdev_xdp_act {
 	NETDEV_XDP_ACT_MASK = 127,
 };
 
+enum netdev_xdp_act_bit {
+	NETDEV_XDP_ACT_BIT_BASIC_BIT,
+	NETDEV_XDP_ACT_BIT_REDIRECT_BIT,
+	NETDEV_XDP_ACT_BIT_NDO_XMIT_BIT,
+	NETDEV_XDP_ACT_BIT_XSK_ZEROCOPY_BIT,
+	NETDEV_XDP_ACT_BIT_HW_OFFLOAD_BIT,
+	NETDEV_XDP_ACT_BIT_RX_SG_BIT,
+	NETDEV_XDP_ACT_BIT_NDO_XMIT_SG_BIT,
+
+	__NETDEV_XDP_ACT_BIT_MAX,
+	NETDEV_XDP_ACT_BIT_MAX = (__NETDEV_XDP_ACT_BIT_MAX - 1)
+};
+
 enum {
 	NETDEV_A_DEV_IFINDEX = 1,
 	NETDEV_A_DEV_PAD,
-- 
2.39.2

