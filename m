Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D76462CEB0
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiKPX1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKPX1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:27:31 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7B85BD6A
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 15:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668641250; x=1700177250;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6SYQXJtckHXWdGzRDIUebBBXoei5BpsYSOfFSEPX4Dw=;
  b=lSMSL01rO2kUp7eqtvmxBoEm+2UG1NmO/3Pk7a40kB2X2hbadw/taTL3
   rBDg9vdSS5PsB8jEVE47xdAgjEGb1V44j2CleqgsCW+9/IewCZpCgIVd4
   LfZurlu6XkS33+Uwt8+JZXYB+0N76DWt6IhPAcyvmh1IFeAkq33kFCmNJ
   UpJe05Rf2o0TG8JRhk6WHnJowdFbUyi/HG+Vcs+nNofB3LnC9WW2OQQKq
   15Z6Ejfqa5Y4Cc34hHxohZo5eIvCMiYU9fBz7JL0bNtKXHWSSXrihIxvB
   h5orvNrAorl0XmW6JEVFo4kOLNmHbcOUsocPaf2r7iKFUdACGXLEK6LMR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="339517308"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="339517308"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:27:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="590380507"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="590380507"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga003.jf.intel.com with ESMTP; 16 Nov 2022 15:27:25 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, andrew@lunn.ch, corbet@lwn.net,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v3] ethtool: add netlink based get rss support
Date:   Wed, 16 Nov 2022 15:25:54 -0800
Message-Id: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add netlink based support for "ethtool -x <dev> [context x]"
command by implementing ETHTOOL_MSG_RSS_GET netlink message.
This is equivalent to functionality provided via ETHTOOL_GRSSH
in ioctl path. It fetches RSS table, hash key and hash function
of an interface to user space.

This patch implements existing functionality available
in ioctl path and enables addition of new RSS context
based parameters in future.

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
v3:
-Define parse_request and make use of ethnl_default_parse.
-Have indir table and hask hey as seprate attributes.
-Remove dumpit op for RSS_GET.
-Use RSS instead of RXFH.

v2: Fix cleanup in error path instead of returning.
---
 Documentation/networking/ethtool-netlink.rst |  27 +++-
 include/uapi/linux/ethtool_netlink.h         |  14 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/netlink.c                        |   9 ++
 net/ethtool/netlink.h                        |   2 +
 net/ethtool/rss.c                            | 157 +++++++++++++++++++
 6 files changed, 209 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/rss.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index bede24ef44fd..84c9471c3d64 100644
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
@@ -1687,6 +1689,29 @@ to control PoDL PSE Admin functions. This option is implementing
 ``IEEE 802.3-2018`` 30.15.1.2.1 acPoDLPSEAdminControl. See
 ``ETHTOOL_A_PODL_PSE_ADMIN_STATE`` for supported values.
 
+RSS_GET
+========
+
+Get indirection table, hash key and hash function info associated with a
+RSS context of an interface similar to ``ETHTOOL_GRSSH`` ioctl request.
+
+Request contents:
+
+=====================================  ======  ==========================
+  ``ETHTOOL_A_RSS_HEADER``             nested  request header
+  ``ETHTOOL_A_RSS_CONTEXT``            u32     context number
+ ====================================  ======  ==========================
+
+Kernel response contents:
+
+=====================================  ======  ==========================
+  ``ETHTOOL_A_RSS_HEADER``             nested  reply header
+  ``ETHTOOL_A_RSS_CONTEXT``            u32     RSS context number
+  ``ETHTOOL_A_RSS_HFUNC``              u32     RSS hash func
+  ``ETHTOOL_A_RSS_INDIR``              binary  Indir table bytes
+  ``ETHTOOL_A_RSS_HKEY``               binary  Hash key bytes
+ ====================================  ======  ==========================
+
 Request translation
 ===================
 
@@ -1768,7 +1793,7 @@ are netlink only.
   ``ETHTOOL_GMODULEEEPROM``           ``ETHTOOL_MSG_MODULE_EEPROM_GET``
   ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
   ``ETHTOOL_SEEE``                    ``ETHTOOL_MSG_EEE_SET``
-  ``ETHTOOL_GRSSH``                   n/a
+  ``ETHTOOL_GRSSH``                   ``ETHTOOL_MSG_RSS_GET``
   ``ETHTOOL_SRSSH``                   n/a
   ``ETHTOOL_GTUNABLE``                n/a
   ``ETHTOOL_STUNABLE``                n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index aaf7c6963d61..ad837f034ac3 100644
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
+	ETHTOOL_A_RSS_INDIR,		/* array */
+	ETHTOOL_A_RSS_HKEY,		/* array */
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
index 1a4c11356c96..ad6bdf0d10a9 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -287,6 +287,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
 	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
 	[ETHTOOL_MSG_PSE_GET]		= &ethnl_pse_request_ops,
+	[ETHTOOL_MSG_RSS_GET]		= &ethnl_rss_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -1040,6 +1041,14 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_pse_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_pse_set_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_RSS_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.done	= ethnl_default_done,
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
index 000000000000..f4a700db3e9b
--- /dev/null
+++ b/net/ethtool/rss.c
@@ -0,0 +1,157 @@
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
+	u32				rss_context;
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
+	if (!tb[ETHTOOL_A_RSS_CONTEXT])
+		return -EINVAL;
+
+	request->rss_context = nla_get_u32(tb[ETHTOOL_A_RSS_CONTEXT]);
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
+	data->rss_context = request->rss_context;
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
+	if (data->rss_context)
+		ret = ops->get_rxfh_context(dev, data->indir_table, data->hkey,
+					    &dev_hfunc, data->rss_context);
+	else
+		ret = ops->get_rxfh(dev, data->indir_table, data->hkey,
+				    &dev_hfunc);
+
+	data->hfunc = dev_hfunc;
+
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
+	len =  nla_total_size(sizeof(u32)) +	/* _RSS_CONTEXT */
+	       nla_total_size(sizeof(u32)) +	/* _RSS_HFUNC */
+	       nla_total_size(sizeof(u32)) * data->indir_size + /* _RSS_INDIR */
+	       data->hkey_size;			/* _RSS_HKEY */
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
+	if (nla_put_u32(skb, ETHTOOL_A_RSS_CONTEXT, data->rss_context) ||
+	    nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc) ||
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

