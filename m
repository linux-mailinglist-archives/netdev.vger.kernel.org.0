Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EC86B3030
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCIWHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCIWHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:07:19 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321EEF4D80
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 14:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678399638; x=1709935638;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pvrs6gN6tQUWzpTy9Ky0/oYeg5Bla85SOnReqc4ODwk=;
  b=ZEmsnEDCQDN/hEtbqKrZEFfNtxSyf5OfxVBmlgVHtYrYOh+QKZOPDxYf
   +YsQTfAE7G4hUIGpdk3xbO4Oz2JiH/A/V1ctzw7z/2w1V2SE7Q0BjZCMk
   PFLzDupe+/t38dq2cqW385XTocjEDn86bj5tnQQLKbI4Da/9yZnUxwedN
   Bxx2nQ9jrztxTmUzmJ/tpC6VUgFwNdbAi+cxGz/hpfoNXVdEmPaxrKifB
   NQYOZWPKe7bpkkjpOPnFVrgRIL7WZk0obTy8RUaMFP3s3jVFtMvVQkk2C
   B4WiSMsHl2DFayP669x1uIsb6Ty+qh3u8lwZAGRFzmk3U0yMOZucZoTwa
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="316978136"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="316978136"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 14:07:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="851678115"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="851678115"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga005.jf.intel.com with ESMTP; 09 Mar 2023 14:07:17 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next] ethtool: add netlink support for rss set
Date:   Thu,  9 Mar 2023 14:05:44 -0800
Message-Id: <20230309220544.177248-1-sudheer.mogilappagari@intel.com>
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

Add netlink based support for "ethtool -X <dev>" command by
implementing ETHTOOL_MSG_RSS_SET netlink message. This is
equivalent to functionality provided via ETHTOOL_SRSSH in
ioctl path. It allows creation and deletion of RSS context
and modifying RSS table, hash key and hash function of an
interface.

Functionality is backward compatible with the one available
in ioctl path but enables addition of new RSS context based
parameters in future.

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
 Documentation/networking/ethtool-netlink.rst |  31 ++++
 include/uapi/linux/ethtool_netlink.h         |   3 +
 net/ethtool/netlink.c                        |   7 +
 net/ethtool/netlink.h                        |   2 +
 net/ethtool/rss.c                            | 155 +++++++++++++++++++
 5 files changed, 198 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index e1bc6186d7ea..e03228978d1a 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -223,6 +223,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PSE_SET``               set PSE parameters
   ``ETHTOOL_MSG_PSE_GET``               get PSE parameters
   ``ETHTOOL_MSG_RSS_GET``               get RSS settings
+  ``ETHTOOL_MSG_RSS_SET``               set RSS settings
   ``ETHTOOL_MSG_MM_GET``                get MAC merge layer state
   ``ETHTOOL_MSG_MM_SET``                set MAC merge layer parameters
   ===================================== =================================
@@ -1756,6 +1757,36 @@ being used. Current supported options are toeplitz, xor or crc32.
 ETHTOOL_A_RSS_INDIR attribute returns RSS indrection table where each byte
 indicates queue number.
 
+RSS_SET
+=======
+
+Update indirection table, hash key and hash function of a RSS context.
+similar to ``ETHTOOL_SRSSH`` ioctl request.
+
+Request contents:
+
+=====================================  ======  ==========================
+  ``ETHTOOL_A_RSS_HEADER``             nested  request header
+  ``ETHTOOL_A_RSS_CONTEXT``            u32     context number
+  ``ETHTOOL_A_RSS_HFUNC``              u32     RSS hash func
+  ``ETHTOOL_A_RSS_INDIR``              binary  Indir table bytes
+  ``ETHTOOL_A_RSS_HKEY``               binary  Hash key bytes
+  ``ETHTOOL_A_RSS_DELETE``             u8      context delete flag
+=====================================  ======  ==========================
+
+Kernel response contents:
+
+=====================================  ======  ==========================
+  ``ETHTOOL_A_RSS_HEADER``             nested  reply header
+  ``ETHTOOL_A_RSS_CONTEXT``            u32     context number created
+=====================================  ======  ==========================
+
+RSS context value of ETH_RXFH_CONTEXT_ALLOC indicates creation of new
+context. Response contains newly created context number or same context
+number as request. ETHTOOL_A_RSS_HFUNC attribute is bitmap indicating
+the hash function being used. Current supported options are toeplitz,
+xor or crc32.
+
 PLCA_GET_CFG
 ============
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d39ce21381c5..56c4e8570dc6 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -52,6 +52,7 @@ enum {
 	ETHTOOL_MSG_PSE_GET,
 	ETHTOOL_MSG_PSE_SET,
 	ETHTOOL_MSG_RSS_GET,
+	ETHTOOL_MSG_RSS_SET,
 	ETHTOOL_MSG_PLCA_GET_CFG,
 	ETHTOOL_MSG_PLCA_SET_CFG,
 	ETHTOOL_MSG_PLCA_GET_STATUS,
@@ -104,6 +105,7 @@ enum {
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_PSE_GET_REPLY,
 	ETHTOOL_MSG_RSS_GET_REPLY,
+	ETHTOOL_MSG_RSS_SET_REPLY,
 	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
 	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
 	ETHTOOL_MSG_PLCA_NTF,
@@ -906,6 +908,7 @@ enum {
 	ETHTOOL_A_RSS_HFUNC,		/* u32 */
 	ETHTOOL_A_RSS_INDIR,		/* binary */
 	ETHTOOL_A_RSS_HKEY,		/* binary */
+	ETHTOOL_A_RSS_DELETE,		/* u8 */
 
 	__ETHTOOL_A_RSS_CNT,
 	ETHTOOL_A_RSS_MAX = (__ETHTOOL_A_RSS_CNT - 1),
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 08120095cc68..22177883438b 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -1115,6 +1115,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_rss_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_rss_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_RSS_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_rss,
+		.policy = ethnl_rss_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_rss_set_policy) - 1,
+	},
 	{
 		.cmd	= ETHTOOL_MSG_PLCA_GET_CFG,
 		.doit	= ethnl_default_doit,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index f7b189ed96b2..67d7e4e5b916 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -436,6 +436,7 @@ extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MO
 extern const struct nla_policy ethnl_pse_get_policy[ETHTOOL_A_PSE_HEADER + 1];
 extern const struct nla_policy ethnl_pse_set_policy[ETHTOOL_A_PSE_MAX + 1];
 extern const struct nla_policy ethnl_rss_get_policy[ETHTOOL_A_RSS_CONTEXT + 1];
+extern const struct nla_policy ethnl_rss_set_policy[ETHTOOL_A_RSS_MAX + 1];
 extern const struct nla_policy ethnl_plca_get_cfg_policy[ETHTOOL_A_PLCA_HEADER + 1];
 extern const struct nla_policy ethnl_plca_set_cfg_policy[ETHTOOL_A_PLCA_MAX + 1];
 extern const struct nla_policy ethnl_plca_get_status_policy[ETHTOOL_A_PLCA_HEADER + 1];
@@ -443,6 +444,7 @@ extern const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1];
 extern const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1];
 
 int ethnl_set_features(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_rss(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info);
 int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index be260ab34e58..f19e4baa83e2 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -154,3 +154,158 @@ const struct ethnl_request_ops ethnl_rss_request_ops = {
 	.fill_reply		= rss_fill_reply,
 	.cleanup_data		= rss_cleanup_data,
 };
+
+/* RSS_SET */
+
+const struct nla_policy ethnl_rss_set_policy[] = {
+	[ETHTOOL_A_RSS_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_RSS_CONTEXT] = { .type = NLA_U32 },
+	[ETHTOOL_A_RSS_HFUNC]	= { .type = NLA_U32 },
+	[ETHTOOL_A_RSS_INDIR]	= { .type = NLA_BINARY },
+	[ETHTOOL_A_RSS_HKEY]	= { .type = NLA_BINARY },
+	[ETHTOOL_A_RSS_DELETE]	= { .type = NLA_U8 },
+};
+
+static int srss_send_reply(struct net_device *dev, struct genl_info *info,
+			   u32 rss_context)
+{
+	struct sk_buff *rskb;
+	void *reply_payload;
+	int reply_len;
+	int ret;
+
+	reply_len = ethnl_reply_header_size() +
+		    nla_total_size(sizeof(u32)); /* RSS_CONTEXT */
+
+	rskb = ethnl_reply_init(reply_len, dev, ETHTOOL_MSG_RSS_SET_REPLY,
+				ETHTOOL_A_RSS_HEADER, info, &reply_payload);
+
+	ret = nla_put_u32(rskb, ETHTOOL_A_RSS_CONTEXT, rss_context);
+	if (ret < 0)
+		goto nla_put_failure;
+
+	genlmsg_end(rskb, reply_payload);
+	ret = genlmsg_reply(rskb, info);
+	return ret;
+
+nla_put_failure:
+	nlmsg_free(rskb);
+	WARN_ONCE(1, "calculated message payload length (%d) not sufficient\n",
+		  reply_len);
+	GENL_SET_ERR_MSG(info, "failed to send reply message");
+	return ret;
+}
+
+int ethnl_set_rss(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethnl_req_info req_info = {};
+	u32 rss_hfunc = 0, rss_context = 0;
+	u32 hkey_bytes = 0, indir_size = 0;
+	struct nlattr **tb = info->attrs;
+	const struct ethtool_ops *ops;
+	struct ethtool_rxnfc rx_rings;
+	struct net_device *dev;
+	u32 *rss_indir = NULL;
+	u8 *rss_hkey = NULL;
+	u32 delete = false;
+	bool mod = false;
+	int ret, i;
+
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_RSS_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+	if (!ops->get_rxnfc || !ops->set_rxfh) {
+		ret = -EOPNOTSUPP;
+		goto out_dev;
+	}
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ethnl_update_u32(&rss_context, tb[ETHTOOL_A_RSS_CONTEXT], &mod);
+	if (rss_context && !ops->set_rxfh_context) {
+		ret = -EOPNOTSUPP;
+		goto out_ops;
+	}
+
+	ethnl_update_bool32(&delete, tb[ETHTOOL_A_RSS_DELETE], &mod);
+	ethnl_update_u32(&rss_hfunc, tb[ETHTOOL_A_RSS_HFUNC], &mod);
+
+	if (tb[ETHTOOL_A_RSS_HKEY]) {
+		if (ops->get_rxfh_key_size)
+			hkey_bytes = ops->get_rxfh_key_size(dev);
+
+		if (!hkey_bytes ||
+		    nla_len(tb[ETHTOOL_A_RSS_HKEY]) != hkey_bytes) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+
+		rss_hkey = kzalloc(hkey_bytes, GFP_KERNEL);
+		if (!rss_hkey) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+		ethnl_update_binary(rss_hkey, hkey_bytes,
+				    tb[ETHTOOL_A_RSS_HKEY], &mod);
+	}
+
+	if (tb[ETHTOOL_A_RSS_INDIR]) {
+		u32 indir_bytes;
+
+		if (ops->get_rxfh_indir_size)
+			indir_size = ops->get_rxfh_indir_size(dev);
+
+		indir_bytes = indir_size * sizeof(u32);
+		if (!indir_bytes ||
+		    nla_len(tb[ETHTOOL_A_RSS_INDIR]) != indir_bytes) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+
+		rss_indir = kzalloc(indir_bytes, GFP_KERNEL);
+		if (!rss_indir) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+		ethnl_update_binary(rss_indir, indir_bytes,
+				    tb[ETHTOOL_A_RSS_INDIR], &mod);
+
+		/* Validate ring indices */
+		rx_rings.cmd = ETHTOOL_GRXRINGS;
+		ret = ops->get_rxnfc(dev, &rx_rings, NULL);
+		if (ret)
+			goto out_free;
+
+		for (i = 0; i < indir_size; i++)
+			if (rss_indir[i] >= rx_rings.data)
+				goto out_free;
+	}
+
+	if (rss_context)
+		ret = ops->set_rxfh_context(dev, rss_indir, rss_hkey, rss_hfunc,
+					    &rss_context, delete);
+	else
+		ret = ops->set_rxfh(dev, rss_indir, rss_hkey, rss_hfunc);
+
+	srss_send_reply(dev, info, rss_context);
+
+out_free:
+	kfree(rss_hkey);
+	kfree(rss_indir);
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	ethnl_parse_header_dev_put(&req_info);
+	return ret;
+}
-- 
2.31.1

