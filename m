Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A75A618A6A
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiKCVRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiKCVRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:17:19 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46AA1A04C
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 14:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667510237; x=1699046237;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=noJZMuVnLEhFVq0D/5JdwEM7Iry0dOdpWmguoZymCqQ=;
  b=YGfo9yGrn79YMKjx16wQBYRhmQBnoTY/wmYEIQjrki0a33j/qXysXH/e
   XxGn2srWhT+NJygeW3lKvpeiDCQv9e+ZTBHvN11ZMwO83QVA37S18X0jp
   96PoTQsusD0PwhFqTuVwl5UvjrVfRt2Q78Qp9SJ0SRJwt6PLBSGRkn3LM
   JNVw0yv+z3pMNQjlE/Pw4A8u0Y+O1NGcAwPvKh8aF8nxhi8N9RnZ/tIul
   yq2eAPWgQz/fYAnemjVT5N6mgz2P6GycLTc/Semw5QT3sOGWuBGVGZIDI
   sOKVZFjwhisy+A5uvdKS2DIqqcvn5yu5E7SAF7Vq0pRNm7GJLkBhdm6sa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="310926576"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="310926576"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 14:17:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="666124875"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="666124875"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga008.jf.intel.com with ESMTP; 03 Nov 2022 14:17:16 -0700
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, corbet@lwn.net, mkubecek@suse.cz,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next] ethtool: add netlink based get rxfh support
Date:   Thu,  3 Nov 2022 14:14:19 -0700
Message-Id: <20221103211419.2615321-1-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement RXFH_GET request to get RSS table, hash key
and hash function of an interface. This is netlink
equivalent implementation of ETHTOOL_GRSSH ioctl request.

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
 Documentation/networking/ethtool-netlink.rst |  28 +++-
 include/uapi/linux/ethtool_netlink.h         |  15 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/netlink.c                        |  10 ++
 net/ethtool/netlink.h                        |   2 +
 net/ethtool/rxfh.c                           | 151 +++++++++++++++++++
 6 files changed, 206 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/rxfh.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d578b8bcd8a4..4420a2dc952e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -222,6 +222,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_MODULE_GET``            get transceiver module parameters
   ``ETHTOOL_MSG_PSE_SET``               set PSE parameters
   ``ETHTOOL_MSG_PSE_GET``               get PSE parameters
+  ``ETHTOOL_MSG_RXFH_GET``              get RSS settings
   ===================================== =================================
 
 Kernel to userspace:
@@ -263,6 +264,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY``    PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
   ``ETHTOOL_MSG_PSE_GET_REPLY``            PSE parameters
+  ``ETHTOOL_MSG_RXFH_GET_REPLY``           RSS settings
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1686,6 +1688,30 @@ to control PoDL PSE Admin functions. This option is implementing
 ``IEEE 802.3-2018`` 30.15.1.2.1 acPoDLPSEAdminControl. See
 ``ETHTOOL_A_PODL_PSE_ADMIN_STATE`` for supported values.
 
+RXFH_GET
+========
+
+Get RSS table, hash key and hash function info like ``ETHTOOL_GRSSH``
+ioctl request.
+
+Request contents:
+
+=====================================  ======  ==========================
+  ``ETHTOOL_A_RXFH_HEADER``            nested  request header
+  ``ETHTOOL_A_RXFH_RSS_CONTEXT``       u32     context number
+ ====================================  ======  ==========================
+
+Kernel response contents:
+
+=====================================  ======  ==========================
+  ``ETHTOOL_A_RXFH_HEADER``            nested  reply header
+  ``ETHTOOL_A_RXFH_RSS_CONTEXT``       u32     RSS context number
+  ``ETHTOOL_A_RXFH_INDIR_SIZE``        u32     RSS Indirection table size
+  ``ETHTOOL_A_RXFH_KEY_SIZE``          u32     RSS hash key size
+  ``ETHTOOL_A_RXFH_HFUNC``             u32     RSS hash func
+  ``ETHTOOL_A_RXFH_RSS_CONFIG``        u32     Indir table and hkey bytes
+ ====================================  ======  ==========================
+
 Request translation
 ===================
 
@@ -1738,7 +1764,7 @@ are netlink only.
   ``ETHTOOL_SFLAGS``                  ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GPFLAGS``                 ``ETHTOOL_MSG_PRIVFLAGS_GET``
   ``ETHTOOL_SPFLAGS``                 ``ETHTOOL_MSG_PRIVFLAGS_SET``
-  ``ETHTOOL_GRXFH``                   n/a
+  ``ETHTOOL_GRXFH``                   ``ETHTOOL_MSG_RXFH_GET``
   ``ETHTOOL_SRXFH``                   n/a
   ``ETHTOOL_GGRO``                    ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SGRO``                    ``ETHTOOL_MSG_FEATURES_SET``
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index bb57084ac524..a5ce6fadcd05 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -51,6 +51,7 @@ enum {
 	ETHTOOL_MSG_MODULE_SET,
 	ETHTOOL_MSG_PSE_GET,
 	ETHTOOL_MSG_PSE_SET,
+	ETHTOOL_MSG_RXFH_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -97,6 +98,7 @@ enum {
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_PSE_GET_REPLY,
+	ETHTOOL_MSG_RXFH_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -879,6 +881,19 @@ enum {
 	ETHTOOL_A_PSE_MAX = (__ETHTOOL_A_PSE_CNT - 1)
 };
 
+enum {
+	ETHTOOL_A_RXFH_UNSPEC,
+	ETHTOOL_A_RXFH_HEADER,
+	ETHTOOL_A_RXFH_RSS_CONTEXT,		/* u32 */
+	ETHTOOL_A_RXFH_INDIR_SIZE,		/* u32 */
+	ETHTOOL_A_RXFH_KEY_SIZE,		/* u32 */
+	ETHTOOL_A_RXFH_HFUNC,			/* u8 */
+	ETHTOOL_A_RXFH_RSS_CONFIG,
+
+	__ETHTOOL_A_RXFH_CNT,
+	ETHTOOL_A_RXFH_MAX = (__ETHTOOL_A_RXFH_CNT - 1),
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 72ab0944262a..234a063008e6 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,7 +4,7 @@ obj-y				+= ioctl.o common.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
+ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o rxfh.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
 		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 1a4c11356c96..2265a835330b 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -287,6 +287,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
 	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
 	[ETHTOOL_MSG_PSE_GET]		= &ethnl_pse_request_ops,
+	[ETHTOOL_MSG_RXFH_GET]		= &ethnl_rxfh_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -1040,6 +1041,15 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_pse_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_pse_set_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_RXFH_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_rxfh_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_rxfh_get_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 1bfd374f9718..1ec92da7b173 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -346,6 +346,7 @@ extern const struct ethnl_request_ops ethnl_stats_request_ops;
 extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
 extern const struct ethnl_request_ops ethnl_module_request_ops;
 extern const struct ethnl_request_ops ethnl_pse_request_ops;
+extern const struct ethnl_request_ops ethnl_rxfh_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -386,6 +387,7 @@ extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER +
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
 extern const struct nla_policy ethnl_pse_get_policy[ETHTOOL_A_PSE_HEADER + 1];
 extern const struct nla_policy ethnl_pse_set_policy[ETHTOOL_A_PSE_MAX + 1];
+extern const struct nla_policy ethnl_rxfh_get_policy[ETHTOOL_A_RXFH_RSS_CONTEXT + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/rxfh.c b/net/ethtool/rxfh.c
new file mode 100644
index 000000000000..fcd515dc4345
--- /dev/null
+++ b/net/ethtool/rxfh.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+
+struct rxfh_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct rxfh_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_rxfh		rxfh;
+	u32				*rss_config;
+};
+
+#define RXFH_REPDATA(__reply_base) \
+	container_of(__reply_base, struct rxfh_reply_data, base)
+
+const struct nla_policy ethnl_rxfh_get_policy[] = {
+	[ETHTOOL_A_RXFH_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_RXFH_RSS_CONTEXT] = { .type = NLA_U32 },
+};
+
+static int rxfh_prepare_data(const struct ethnl_req_info *req_base,
+			     struct ethnl_reply_data *reply_base,
+			     struct genl_info *info)
+{
+	struct rxfh_reply_data *data = RXFH_REPDATA(reply_base);
+	u32 indir_size, hkey_size, total_size, indir_bytes;
+	struct net_device *dev = reply_base->dev;
+	struct ethtool_rxfh *rxfh = &data->rxfh;
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	const struct ethtool_ops *ops;
+	bool mod = false;
+	u8 dev_hfunc = 0;
+	u8 *hkey = NULL;
+	u8 *rss_config;
+	int ret;
+
+	ops = dev->ethtool_ops;
+	if (!ops->get_rxfh)
+		return -EOPNOTSUPP;
+
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_RXFH_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+
+	ethnl_update_u32(&rxfh->rss_context, tb[ETHTOOL_A_RXFH_RSS_CONTEXT],
+			 &mod);
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Some drivers don't handle rss_context */
+	if (rxfh->rss_context && !ops->get_rxfh_context)
+		return -EOPNOTSUPP;
+
+	if (ops->get_rxfh_indir_size)
+		indir_size = ops->get_rxfh_indir_size(dev);
+	if (ops->get_rxfh_key_size)
+		hkey_size = ops->get_rxfh_key_size(dev);
+
+	indir_bytes = indir_size * sizeof(rxfh->rss_config[0]);
+	total_size = indir_bytes + hkey_size;
+	rss_config = kzalloc(total_size, GFP_USER);
+	if (!rss_config)
+		return -ENOMEM;
+
+	if (indir_size) {
+		data->rss_config = (u32 *)rss_config;
+		rxfh->indir_size = indir_size;
+	}
+
+	if (hkey_size) {
+		hkey = rss_config + indir_bytes;
+		rxfh->key_size = hkey_size;
+	}
+
+	if (rxfh->rss_context)
+		ret = ops->get_rxfh_context(dev, data->rss_config, hkey,
+					    &dev_hfunc, rxfh->rss_context);
+	else
+		ret = ops->get_rxfh(dev, data->rss_config, hkey, &dev_hfunc);
+
+	rxfh->hfunc = dev_hfunc;
+
+	ethnl_ops_complete(dev);
+	ethnl_parse_header_dev_put(&req_info);
+	return ret;
+}
+
+static int rxfh_reply_size(const struct ethnl_req_info *req_base,
+			   const struct ethnl_reply_data *reply_base)
+{
+	const struct rxfh_reply_data *data = RXFH_REPDATA(reply_base);
+	const struct ethtool_rxfh *rxfh = &data->rxfh;
+	int len;
+
+	len =  nla_total_size(sizeof(u32)) +	/* _RSS_CONTEXT */
+	       nla_total_size(sizeof(u32)) +	/* _RXFH_INDIR_SIZE */
+	       nla_total_size(sizeof(u32)) +	/* _RXFH_KEY_SIZE */
+	       nla_total_size(sizeof(u8));	/* _RXFH_HFUNC */
+	len += nla_total_size(sizeof(u32)) * rxfh->indir_size +
+	       rxfh->key_size;
+
+	return len;
+}
+
+static int rxfh_fill_reply(struct sk_buff *skb,
+			   const struct ethnl_req_info *req_base,
+			   const struct ethnl_reply_data *reply_base)
+{
+	const struct rxfh_reply_data *data = RXFH_REPDATA(reply_base);
+	const struct ethtool_rxfh *rxfh = &data->rxfh;
+
+	if (nla_put_u32(skb, ETHTOOL_A_RXFH_RSS_CONTEXT, rxfh->rss_context) ||
+	    nla_put_u32(skb, ETHTOOL_A_RXFH_INDIR_SIZE, rxfh->indir_size) ||
+	    nla_put_u32(skb, ETHTOOL_A_RXFH_KEY_SIZE, rxfh->key_size) ||
+	    nla_put_u8(skb, ETHTOOL_A_RXFH_HFUNC, rxfh->hfunc) ||
+	    nla_put(skb, ETHTOOL_A_RXFH_RSS_CONFIG,
+		    sizeof(u32) * rxfh->indir_size + rxfh->key_size,
+		    data->rss_config))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static void rxfh_cleanup_data(struct ethnl_reply_data *reply_base)
+{
+	const struct rxfh_reply_data *data = RXFH_REPDATA(reply_base);
+
+	kfree(data->rss_config);
+}
+
+const struct ethnl_request_ops ethnl_rxfh_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_RXFH_GET,
+	.reply_cmd		= ETHTOOL_MSG_RXFH_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_RXFH_HEADER,
+	.req_info_size		= sizeof(struct rxfh_req_info),
+	.reply_data_size	= sizeof(struct rxfh_reply_data),
+
+	.prepare_data		= rxfh_prepare_data,
+	.reply_size		= rxfh_reply_size,
+	.fill_reply		= rxfh_fill_reply,
+	.cleanup_data		= rxfh_cleanup_data,
+};
-- 
2.31.1

