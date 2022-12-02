Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5187C63FD18
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiLBAcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbiLBAbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:31:31 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB765447C
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669940847; x=1701476847;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2pIOhp8ZGn8NXvnEBDXlDvmduqKh94lx9oc5E5tfIds=;
  b=lxyR4h00S4CegJiCgGpJvS6tN9Do+XSTf6Jh5zSbzvpZGtVuKv+FNe5E
   5Xw30PvCxRtlI4i2gsN1VPVx0x1j8Hh8SCy5BBKOUYR9T6B4Y2SKUX6wf
   uJsRYjrVmXmxVRHRZHlO+C9vVJj9oQZHVbA63L4RPVbA4ZreTrERdFxde
   ecRw4WOtqOPbMgv19qlhsjPB5pLr3mCjDiafhJg7MskDegJMf9Nd3b4O0
   PFsPx/mcgnf0LIbIndFbkg3udQDPsaexA2ybekNuK6+7QkOOmc/YgzLxK
   t8kF0gz09bOyracBhOxT+3evlge2y+rQph6l0GjtbvhWHYOOHturLF5u1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="314536897"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="314536897"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 16:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="787089740"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="787089740"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by fmsmga001.fm.intel.com with ESMTP; 01 Dec 2022 16:27:26 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, andrew@lunn.ch, corbet@lwn.net,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v7] ethtool: add netlink based get rss support
Date:   Thu,  1 Dec 2022 16:25:55 -0800
Message-Id: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add netlink based support for "ethtool -x <dev> [context x]"
command by implementing ETHTOOL_MSG_RSS_GET netlink message.
This is equivalent to functionality provided via ETHTOOL_GRSSH
in ioctl path. It sends RSS table, hash key and hash function
of an interface to user space.

This patch implements existing functionality available
in ioctl path and enables addition of new RSS context
based parameters in future.

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
v7:
- Fix alignment in documentation.
- Fix double space in reply_size.
v6:
- Removed rings attribute.
- Removed returning of rss context attribute back to userspace.
- Fix length returned in reply_size. Other review comments.

v5:
-Updated documentation about ETHTOOL_A_RSS_RINGS attribute.

v4:
-Don't make context parameter mandatory.
-Remove start/done ethtool_genl_ops for RSS_GET.
-Add rings attribute to RSS_GET netlink message.
-Fix documentation.

v3:
-Define parse_request and make use of ethnl_default_parse.
-Have indir table and hask hey as seprate attributes.
-Remove dumpit op for RSS_GET.
-Use RSS instead of RXFH.

v2: Fix cleanup in error path instead of returning.
---
 Documentation/networking/ethtool-netlink.rst |  31 +++-
 include/uapi/linux/ethtool_netlink.h         |  14 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/netlink.c                        |   7 +
 net/ethtool/netlink.h                        |   2 +
 net/ethtool/rss.c                            | 153 +++++++++++++++++++
 6 files changed, 207 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/rss.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index bede24ef44fd..f10f8eb44255 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -222,6 +222,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_MODULE_GET``            get transceiver module parameters
   ``ETHTOOL_MSG_PSE_SET``               set PSE parameters
   ``ETHTOOL_MSG_PSE_GET``               get PSE parameters
+  ``ETHTOOL_MSG_RSS_GET``               get RSS settings
   ===================================== =================================
 
 Kernel to userspace:
@@ -263,6 +264,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY``    PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
   ``ETHTOOL_MSG_PSE_GET_REPLY``            PSE parameters
+  ``ETHTOOL_MSG_RSS_GET_REPLY``            RSS settings
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1687,6 +1689,33 @@ to control PoDL PSE Admin functions. This option is implementing
 ``IEEE 802.3-2018`` 30.15.1.2.1 acPoDLPSEAdminControl. See
 ``ETHTOOL_A_PODL_PSE_ADMIN_STATE`` for supported values.
 
+RSS_GET
+=======
+
+Get indirection table, hash key and hash function info associated with a
+RSS context of an interface similar to ``ETHTOOL_GRSSH`` ioctl request.
+
+Request contents:
+
+=====================================  ======  ==========================
+  ``ETHTOOL_A_RSS_HEADER``             nested  request header
+  ``ETHTOOL_A_RSS_CONTEXT``            u32     context number
+=====================================  ======  ==========================
+
+Kernel response contents:
+
+=====================================  ======  ==========================
+  ``ETHTOOL_A_RSS_HEADER``             nested  reply header
+  ``ETHTOOL_A_RSS_HFUNC``              u32     RSS hash func
+  ``ETHTOOL_A_RSS_INDIR``              binary  Indir table bytes
+  ``ETHTOOL_A_RSS_HKEY``               binary  Hash key bytes
+=====================================  ======  ==========================
+
+ETHTOOL_A_RSS_HFUNC attribute is bitmap indicating the hash function
+being used. Current supported options are toeplitz, xor or crc32.
+ETHTOOL_A_RSS_INDIR attribute returns RSS indrection table where each byte
+indicates queue number.
+
 Request translation
 ===================
 
@@ -1768,7 +1797,7 @@ are netlink only.
   ``ETHTOOL_GMODULEEEPROM``           ``ETHTOOL_MSG_MODULE_EEPROM_GET``
   ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
   ``ETHTOOL_SEEE``                    ``ETHTOOL_MSG_EEE_SET``
-  ``ETHTOOL_GRSSH``                   n/a
+  ``ETHTOOL_GRSSH``                   ``ETHTOOL_MSG_RSS_GET``
   ``ETHTOOL_SRSSH``                   n/a
   ``ETHTOOL_GTUNABLE``                n/a
   ``ETHTOOL_STUNABLE``                n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index aaf7c6963d61..5799a9db034e 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -51,6 +51,7 @@ enum {
 	ETHTOOL_MSG_MODULE_SET,
 	ETHTOOL_MSG_PSE_GET,
 	ETHTOOL_MSG_PSE_SET,
+	ETHTOOL_MSG_RSS_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -97,6 +98,7 @@ enum {
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_PSE_GET_REPLY,
+	ETHTOOL_MSG_RSS_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -880,6 +882,18 @@ enum {
 	ETHTOOL_A_PSE_MAX = (__ETHTOOL_A_PSE_CNT - 1)
 };
 
+enum {
+	ETHTOOL_A_RSS_UNSPEC,
+	ETHTOOL_A_RSS_HEADER,
+	ETHTOOL_A_RSS_CONTEXT,		/* u32 */
+	ETHTOOL_A_RSS_HFUNC,		/* u32 */
+	ETHTOOL_A_RSS_INDIR,		/* binary */
+	ETHTOOL_A_RSS_HKEY,		/* binary */
+
+	__ETHTOOL_A_RSS_CNT,
+	ETHTOOL_A_RSS_MAX = (__ETHTOOL_A_RSS_CNT - 1),
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 72ab0944262a..228f13df2e18 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,7 +4,7 @@ obj-y				+= ioctl.o common.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
+ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o rss.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
 		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 1a4c11356c96..aee98be6237f 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -287,6 +287,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
 	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
 	[ETHTOOL_MSG_PSE_GET]		= &ethnl_pse_request_ops,
+	[ETHTOOL_MSG_RSS_GET]		= &ethnl_rss_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -1040,6 +1041,12 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_pse_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_pse_set_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_RSS_GET,
+		.doit	= ethnl_default_doit,
+		.policy = ethnl_rss_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_rss_get_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 1bfd374f9718..3753787ba233 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -346,6 +346,7 @@ extern const struct ethnl_request_ops ethnl_stats_request_ops;
 extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
 extern const struct ethnl_request_ops ethnl_module_request_ops;
 extern const struct ethnl_request_ops ethnl_pse_request_ops;
+extern const struct ethnl_request_ops ethnl_rss_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -386,6 +387,7 @@ extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER +
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
 extern const struct nla_policy ethnl_pse_get_policy[ETHTOOL_A_PSE_HEADER + 1];
 extern const struct nla_policy ethnl_pse_set_policy[ETHTOOL_A_PSE_MAX + 1];
+extern const struct nla_policy ethnl_rss_get_policy[ETHTOOL_A_RSS_CONTEXT + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
new file mode 100644
index 000000000000..ebe6145aed3f
--- /dev/null
+++ b/net/ethtool/rss.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+
+struct rss_req_info {
+	struct ethnl_req_info		base;
+	u32				rss_context;
+};
+
+struct rss_reply_data {
+	struct ethnl_reply_data		base;
+	u32				indir_size;
+	u32				hkey_size;
+	u32				hfunc;
+	u32				*indir_table;
+	u8				*hkey;
+};
+
+#define RSS_REQINFO(__req_base) \
+	container_of(__req_base, struct rss_req_info, base)
+
+#define RSS_REPDATA(__reply_base) \
+	container_of(__reply_base, struct rss_reply_data, base)
+
+const struct nla_policy ethnl_rss_get_policy[] = {
+	[ETHTOOL_A_RSS_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_RSS_CONTEXT] = { .type = NLA_U32 },
+};
+
+static int
+rss_parse_request(struct ethnl_req_info *req_info, struct nlattr **tb,
+		  struct netlink_ext_ack *extack)
+{
+	struct rss_req_info *request = RSS_REQINFO(req_info);
+
+	if (tb[ETHTOOL_A_RSS_CONTEXT])
+		request->rss_context = nla_get_u32(tb[ETHTOOL_A_RSS_CONTEXT]);
+
+	return 0;
+}
+
+static int
+rss_prepare_data(const struct ethnl_req_info *req_base,
+		 struct ethnl_reply_data *reply_base, struct genl_info *info)
+{
+	struct rss_reply_data *data = RSS_REPDATA(reply_base);
+	struct rss_req_info *request = RSS_REQINFO(req_base);
+	struct net_device *dev = reply_base->dev;
+	const struct ethtool_ops *ops;
+	u32 total_size, indir_bytes;
+	u8 dev_hfunc = 0;
+	u8 *rss_config;
+	int ret;
+
+	ops = dev->ethtool_ops;
+	if (!ops->get_rxfh)
+		return -EOPNOTSUPP;
+
+	/* Some drivers don't handle rss_context */
+	if (request->rss_context && !ops->get_rxfh_context)
+		return -EOPNOTSUPP;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	data->indir_size = 0;
+	data->hkey_size = 0;
+	if (ops->get_rxfh_indir_size)
+		data->indir_size = ops->get_rxfh_indir_size(dev);
+	if (ops->get_rxfh_key_size)
+		data->hkey_size = ops->get_rxfh_key_size(dev);
+
+	indir_bytes = data->indir_size * sizeof(u32);
+	total_size = indir_bytes + data->hkey_size;
+	rss_config = kzalloc(total_size, GFP_KERNEL);
+	if (!rss_config) {
+		ret = -ENOMEM;
+		goto out_ops;
+	}
+
+	if (data->indir_size)
+		data->indir_table = (u32 *)rss_config;
+
+	if (data->hkey_size)
+		data->hkey = rss_config + indir_bytes;
+
+	if (request->rss_context)
+		ret = ops->get_rxfh_context(dev, data->indir_table, data->hkey,
+					    &dev_hfunc, request->rss_context);
+	else
+		ret = ops->get_rxfh(dev, data->indir_table, data->hkey,
+				    &dev_hfunc);
+
+	if (ret)
+		goto out_ops;
+
+	data->hfunc = dev_hfunc;
+out_ops:
+	ethnl_ops_complete(dev);
+	return ret;
+}
+
+static int
+rss_reply_size(const struct ethnl_req_info *req_base,
+	       const struct ethnl_reply_data *reply_base)
+{
+	const struct rss_reply_data *data = RSS_REPDATA(reply_base);
+	int len;
+
+	len = nla_total_size(sizeof(u32)) +	/* _RSS_HFUNC */
+	      nla_total_size(sizeof(u32) * data->indir_size) + /* _RSS_INDIR */
+	      nla_total_size(data->hkey_size);	/* _RSS_HKEY */
+
+	return len;
+}
+
+static int
+rss_fill_reply(struct sk_buff *skb, const struct ethnl_req_info *req_base,
+	       const struct ethnl_reply_data *reply_base)
+{
+	const struct rss_reply_data *data = RSS_REPDATA(reply_base);
+
+	if (nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc) ||
+	    nla_put(skb, ETHTOOL_A_RSS_INDIR,
+		    sizeof(u32) * data->indir_size, data->indir_table) ||
+	    nla_put(skb, ETHTOOL_A_RSS_HKEY, data->hkey_size, data->hkey))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static void rss_cleanup_data(struct ethnl_reply_data *reply_base)
+{
+	const struct rss_reply_data *data = RSS_REPDATA(reply_base);
+
+	kfree(data->indir_table);
+}
+
+const struct ethnl_request_ops ethnl_rss_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_RSS_GET,
+	.reply_cmd		= ETHTOOL_MSG_RSS_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_RSS_HEADER,
+	.req_info_size		= sizeof(struct rss_req_info),
+	.reply_data_size	= sizeof(struct rss_reply_data),
+
+	.parse_request		= rss_parse_request,
+	.prepare_data		= rss_prepare_data,
+	.reply_size		= rss_reply_size,
+	.fill_reply		= rss_fill_reply,
+	.cleanup_data		= rss_cleanup_data,
+};
-- 
2.31.1

