Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B8A32D9D1
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 19:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbhCDS62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 13:58:28 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12334 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbhCDS6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 13:58:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60412d990001>; Thu, 04 Mar 2021 10:57:29 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar
 2021 18:57:28 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 4 Mar 2021 18:57:26 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V2 net-next 1/5] ethtool: Allow network drivers to dump arbitrary EEPROM data
Date:   Thu, 4 Mar 2021 20:57:04 +0200
Message-ID: <1614884228-8542-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614884249; bh=Ts3VHwRsHPD9uhCGDoqA+WkDZBXHhdxxMJ7rCbYL5+E=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type;
        b=h58USd7Vy5PaTtDcVwn3AA2+vXcYJt9T4i3gHryRud6+F+q745yPEnwlCJ29Nj6wN
         PM5JwTJ3iRgm2Qmivrn57eEHaV04JDyBWnw1GqtADC/YwpMIsg67XLOBccBsnVoiDI
         VT2rxWazx8ilyz26T8euiGnK15KCmsynF+AyaN6Hy0MvcfOvGkV5pMHSyyVOU6SWE6
         RcekN5NfsNKQN2W1mlsrwcXz92pO8oJ023E3bfhsDFx7QdDGQKEn57RVpjaTto9Bam
         Cs6v9g6U7uf0ZD6Hj7gwTCbfne0K7beDncGIY9E8tkf5OVif0/6raociYUzMADu8Gl
         EE+UsC3LakXiw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Define get_module_eeprom_data_by_page() ethtool callback and implement
netlink infrastructure.

get_module_eeprom_data_by_page() allows network drivers to dump a part
of module's EEPROM specified by page and bank numbers along with offset
and length. It is effectively a netlink replacement for
get_module_info() and get_module_eeprom() pair, which is needed due to
emergence of complex non-linear EEPROM layouts.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 include/linux/ethtool.h              |   7 +-
 include/uapi/linux/ethtool.h         |  26 +++++
 include/uapi/linux/ethtool_netlink.h |  19 ++++
 net/ethtool/Makefile                 |   2 +-
 net/ethtool/eeprom.c                 | 157 +++++++++++++++++++++++++++
 net/ethtool/netlink.c                |  10 ++
 net/ethtool/netlink.h                |   2 +
 7 files changed, 221 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/eeprom.c

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index ec4cd3921c67..2f65aae5f492 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -81,6 +81,7 @@ enum {
 #define ETH_RSS_HASH_NO_CHANGE	0
 
 struct net_device;
+struct netlink_ext_ack;
 
 /* Some generic methods drivers may use in their ethtool_ops */
 u32 ethtool_op_get_link(struct net_device *dev);
@@ -410,6 +411,8 @@ struct ethtool_pause_stats {
  * @get_ethtool_phy_stats: Return extended statistics about the PHY device.
  *	This is only useful if the device maintains PHY statistics and
  *	cannot use the standard PHY library helpers.
+ * @get_module_eeprom_data_by_page: Get a region of plug-in module EEPROM data
+ *	from specified page. Returns a negative error code or zero.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -515,6 +518,9 @@ struct ethtool_ops {
 				   const struct ethtool_tunable *, void *);
 	int	(*set_phy_tunable)(struct net_device *,
 				   const struct ethtool_tunable *, const void *);
+	int	(*get_module_eeprom_data_by_page)(struct net_device *dev,
+						  const struct ethtool_eeprom_data *page,
+						  struct netlink_ext_ack *extack);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
@@ -538,7 +544,6 @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
 				       const struct ethtool_link_ksettings *cmd,
 				       u32 *dev_speed, u8 *dev_duplex);
 
-struct netlink_ext_ack;
 struct phy_device;
 struct phy_tdr_config;
 
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index cde753bb2093..2459571fc1d1 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -340,6 +340,28 @@ struct ethtool_eeprom {
 	__u8	data[0];
 };
 
+/**
+ * struct ethtool_eeprom_data - EEPROM dump from specified page
+ * @offset: Offset within the specified EEPROM page to begin read, in bytes.
+ * @length: Number of bytes to read.
+ * @page: Page number to read from.
+ * @bank: Page bank number to read from, if applicable by EEPROM spec.
+ * @i2c_address: I2C address of a page. Value less than 0x7f expected. Most
+ *	EEPROMs use 0x50 or 0x51.
+ * @data: Pointer to buffer with EEPROM data of @length size.
+ *
+ * This can be used to manage pages during EEPROM dump in ethtool and pass
+ * required information to the driver.
+ */
+struct ethtool_eeprom_data {
+	__u32	offset;
+	__u32	length;
+	__u32	page;
+	__u32	bank;
+	__u32	i2c_address;
+	__u8	*data;
+};
+
 /**
  * struct ethtool_eee - Energy Efficient Ethernet information
  * @cmd: ETHTOOL_{G,S}EEE
@@ -1865,6 +1887,10 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 #define ETH_MODULE_SFF_8636_MAX_LEN     640
 #define ETH_MODULE_SFF_8436_MAX_LEN     640
 
+#define ETH_MODULE_EEPROM_MAX_LEN	640
+#define ETH_MODULE_EEPROM_PAGE_LEN	256
+#define ETH_MODULE_MAX_I2C_ADDRESS	0x7f
+
 /* Reset flags */
 /* The reset() operation must clear the flags for the components which
  * were actually reset.  On successful return, the flags indicate the
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index a286635ac9b8..60dd848d0b54 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -42,6 +42,7 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_ACT,
 	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 	ETHTOOL_MSG_TUNNEL_INFO_GET,
+	ETHTOOL_MSG_EEPROM_DATA_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -80,6 +81,7 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_NTF,
 	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
+	ETHTOOL_MSG_EEPROM_DATA_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -629,6 +631,23 @@ enum {
 	ETHTOOL_A_TUNNEL_INFO_MAX = (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)
 };
 
+/* MODULE EEPROM DATA */
+
+enum {
+	ETHTOOL_A_EEPROM_DATA_UNSPEC,
+	ETHTOOL_A_EEPROM_DATA_HEADER,
+
+	ETHTOOL_A_EEPROM_DATA_OFFSET,
+	ETHTOOL_A_EEPROM_DATA_LENGTH,
+	ETHTOOL_A_EEPROM_DATA_PAGE,
+	ETHTOOL_A_EEPROM_DATA_BANK,
+	ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS,
+	ETHTOOL_A_EEPROM_DATA,
+
+	__ETHTOOL_A_EEPROM_DATA_CNT,
+	ETHTOOL_A_EEPROM_DATA_MAX = (__ETHTOOL_A_EEPROM_DATA_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 7a849ff22dad..d604346bc074 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o
+		   tunnels.o eeprom.o
diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
new file mode 100644
index 000000000000..2618a55b9a40
--- /dev/null
+++ b/net/ethtool/eeprom.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/ethtool.h>
+#include "netlink.h"
+#include "common.h"
+
+struct eeprom_data_req_info {
+	struct ethnl_req_info	base;
+	u32			offset;
+	u32			length;
+	u32			page;
+	u32			bank;
+	u32			i2c_address;
+};
+
+struct eeprom_data_reply_data {
+	struct ethnl_reply_data base;
+	u32			length;
+	u32			i2c_address;
+	u8			*data;
+};
+
+#define EEPROM_DATA_REQINFO(__req_base) \
+	container_of(__req_base, struct eeprom_data_req_info, base)
+
+#define EEPROM_DATA_REPDATA(__reply_base) \
+	container_of(__reply_base, struct eeprom_data_reply_data, base)
+
+static int eeprom_data_prepare_data(const struct ethnl_req_info *req_base,
+				    struct ethnl_reply_data *reply_base,
+				    struct genl_info *info)
+{
+	struct eeprom_data_reply_data *reply = EEPROM_DATA_REPDATA(reply_base);
+	struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_base);
+	struct ethtool_eeprom_data page_data = {0};
+	struct net_device *dev = reply_base->dev;
+	int err;
+
+	if (!dev->ethtool_ops->get_module_eeprom_data_by_page)
+		return -EOPNOTSUPP;
+
+	page_data.offset = request->offset;
+	page_data.length = request->length;
+	page_data.i2c_address = request->i2c_address;
+	page_data.page = request->page;
+	page_data.bank = request->bank;
+	page_data.data = kmalloc(page_data.length, GFP_KERNEL);
+	if (!page_data.data)
+		return -ENOMEM;
+	err = ethnl_ops_begin(dev);
+	if (err)
+		goto err_free;
+
+	err = dev->ethtool_ops->get_module_eeprom_data_by_page(dev, &page_data,
+							       info->extack);
+	if (err)
+		goto err_ops;
+
+	reply->length = page_data.length;
+	reply->i2c_address = page_data.i2c_address;
+	reply->data = page_data.data;
+
+	ethnl_ops_complete(dev);
+	return 0;
+
+err_ops:
+	ethnl_ops_complete(dev);
+err_free:
+	kfree(page_data.data);
+	return err;
+}
+
+static int eeprom_data_parse_request(struct ethnl_req_info *req_info, struct nlattr **tb,
+				     struct netlink_ext_ack *extack)
+{
+	struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_info);
+
+	if (!tb[ETHTOOL_A_EEPROM_DATA_OFFSET] ||
+	    !tb[ETHTOOL_A_EEPROM_DATA_LENGTH] ||
+	    !tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS])
+		return -EINVAL;
+
+	request->i2c_address = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]);
+	if (request->i2c_address > ETH_MODULE_MAX_I2C_ADDRESS)
+		return -EINVAL;
+
+	request->offset = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
+	request->length = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
+	if (request->length > ETH_MODULE_EEPROM_MAX_LEN)
+		return -EINVAL;
+	if (tb[ETHTOOL_A_EEPROM_DATA_PAGE] &&
+	    request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN)
+		return -EINVAL;
+
+	if (tb[ETHTOOL_A_EEPROM_DATA_PAGE])
+		request->page = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_PAGE]);
+	if (tb[ETHTOOL_A_EEPROM_DATA_BANK])
+		request->bank = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_BANK]);
+
+	return 0;
+}
+
+static int eeprom_data_reply_size(const struct ethnl_req_info *req_base,
+				  const struct ethnl_reply_data *reply_base)
+{
+	const struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_base);
+
+	return nla_total_size(sizeof(u32)) + /* _EEPROM_DATA_LENGTH */
+	       nla_total_size(sizeof(u32)) + /* _EEPROM_DATA_I2C_ADDRESS */
+	       nla_total_size(sizeof(u8) * request->length); /* _EEPROM_DATA */
+}
+
+static int eeprom_data_fill_reply(struct sk_buff *skb,
+				  const struct ethnl_req_info *req_base,
+				  const struct ethnl_reply_data *reply_base)
+{
+	struct eeprom_data_reply_data *reply = EEPROM_DATA_REPDATA(reply_base);
+
+	if (nla_put_u32(skb, ETHTOOL_A_EEPROM_DATA_LENGTH, reply->length) ||
+	    nla_put_u32(skb, ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS, reply->i2c_address) ||
+	    nla_put(skb, ETHTOOL_A_EEPROM_DATA, reply->length, reply->data))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static void eeprom_data_cleanup_data(struct ethnl_reply_data *reply_base)
+{
+	struct eeprom_data_reply_data *reply = EEPROM_DATA_REPDATA(reply_base);
+
+	kfree(reply->data);
+}
+
+const struct ethnl_request_ops ethnl_eeprom_data_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_EEPROM_DATA_GET,
+	.reply_cmd		= ETHTOOL_MSG_EEPROM_DATA_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_EEPROM_DATA_HEADER,
+	.req_info_size		= sizeof(struct eeprom_data_req_info),
+	.reply_data_size	= sizeof(struct eeprom_data_reply_data),
+
+	.parse_request		= eeprom_data_parse_request,
+	.prepare_data		= eeprom_data_prepare_data,
+	.reply_size		= eeprom_data_reply_size,
+	.fill_reply		= eeprom_data_fill_reply,
+	.cleanup_data		= eeprom_data_cleanup_data,
+};
+
+const struct nla_policy ethnl_eeprom_data_get_policy[] = {
+	[ETHTOOL_A_EEPROM_DATA_HEADER]		= NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_EEPROM_DATA_OFFSET]		= { .type = NLA_U32 },
+	[ETHTOOL_A_EEPROM_DATA_LENGTH]		= { .type = NLA_U32 },
+	[ETHTOOL_A_EEPROM_DATA_PAGE]		= { .type = NLA_U32 },
+	[ETHTOOL_A_EEPROM_DATA_BANK]		= { .type = NLA_U32 },
+	[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]	= { .type = NLA_U32 },
+	[ETHTOOL_A_EEPROM_DATA]			= { .type = NLA_BINARY },
+};
+
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 50d3c8896f91..ff2528bee192 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -245,6 +245,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PAUSE_GET]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
+	[ETHTOOL_MSG_EEPROM_DATA_GET]	= &ethnl_eeprom_data_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -912,6 +913,15 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_tunnel_info_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_tunnel_info_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_EEPROM_DATA_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_eeprom_data_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_eeprom_data_get_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 6eabd58d81bf..60954c7b4dfe 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -344,6 +344,7 @@ extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
 extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
+extern const struct ethnl_request_ops ethnl_eeprom_data_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -375,6 +376,7 @@ extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_HEADER +
 extern const struct nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_HEADER + 1];
 extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG + 1];
 extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
+extern const struct nla_policy ethnl_eeprom_data_get_policy[ETHTOOL_A_EEPROM_DATA + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-- 
2.18.2

