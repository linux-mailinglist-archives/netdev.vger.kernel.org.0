Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A231B183A43
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgCLUID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:08:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:45230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbgCLUIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:08:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DA9F6AC51;
        Thu, 12 Mar 2020 20:07:58 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 8941CE0C79; Thu, 12 Mar 2020 21:07:58 +0100 (CET)
Message-Id: <82d8d976acc0039df90313d1835821f987ebef4f.1584043144.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 05/15] ethtool: set netdev features with
 FEATURES_SET request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:07:58 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement FEATURES_SET netlink request to set network device features.
These are traditionally set using ETHTOOL_SFEATURES ioctl request.

Actual change is subject to netdev_change_features() sanity checks so that
it can differ from what was requested. Unlike with most other SET requests,
in addition to error code and optional extack, kernel provides an optional
reply message (ETHTOOL_MSG_FEATURES_SET_REPLY) in the same format but with
different semantics: information about difference between user request and
actual result and difference between old and new state of dev->features.
This reply message can be suppressed by setting ETHTOOL_FLAG_OMIT_REPLY
flag in request header.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  56 +++++-
 include/uapi/linux/ethtool_netlink.h         |   2 +
 net/ethtool/features.c                       | 169 +++++++++++++++++++
 net/ethtool/netlink.c                        |   5 +
 net/ethtool/netlink.h                        |   1 +
 5 files changed, 224 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 5713abf98534..d6706c4aa972 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -190,6 +190,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_WOL_GET``               get wake-on-lan settings
   ``ETHTOOL_MSG_WOL_SET``               set wake-on-lan settings
   ``ETHTOOL_MSG_FEATURES_GET``          get device features
+  ``ETHTOOL_MSG_FEATURES_SET``          set device features
   ===================================== ================================
 
 Kernel to userspace:
@@ -206,6 +207,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_WOL_GET_REPLY``         wake-on-lan settings
   ``ETHTOOL_MSG_WOL_NTF``               wake-on-lan settings notification
   ``ETHTOOL_MSG_FEATURES_GET_REPLY``    device features
+  ``ETHTOOL_MSG_FEATURES_SET_REPLY``    optional reply to FEATURES_SET
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -554,6 +556,42 @@ provide all names when using verbose bitmap format), the other three use no
 mask (simple bit lists).
 
 
+FEATURES_SET
+============
+
+Request to set netdev features like ``ETHTOOL_SFEATURES`` ioctl request.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_FEATURES_HEADER``         nested  request header
+  ``ETHTOOL_A_FEATURES_WANTED``         bitset  requested features
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_FEATURES_HEADER``         nested  reply header
+  ``ETHTOOL_A_FEATURES_WANTED``         bitset  diff wanted vs. result
+  ``ETHTOOL_A_FEATURES_ACTIVE``         bitset  diff old vs. new active
+  ====================================  ======  ==========================
+
+Request constains only one bitset which can be either value/mask pair (request
+to change specific feature bits and leave the rest) or only a value (request
+to set all features to specified set).
+
+As request is subject to netdev_change_features() sanity checks, optional
+kernel reply (can be suppressed by ``ETHTOOL_FLAG_OMIT_REPLY`` flag in request
+header) informs client about the actual result. ``ETHTOOL_A_FEATURES_WANTED``
+reports the difference between client request and actual result: mask consists
+of bits which differ between requested features and result (dev->features
+after the operation), value consists of values of these bits in the request
+(i.e. negated values from resulting features). ``ETHTOOL_A_FEATURES_ACTIVE``
+reports the difference between old and new dev->features: mask consists of
+bits which have changed, values are their values in new dev->features (after
+the operation).
+
+
 Request translation
 ===================
 
@@ -585,30 +623,30 @@ have their netlink replacement yet.
   ``ETHTOOL_GPAUSEPARAM``             n/a
   ``ETHTOOL_SPAUSEPARAM``             n/a
   ``ETHTOOL_GRXCSUM``                 ``ETHTOOL_MSG_FEATURES_GET``
-  ``ETHTOOL_SRXCSUM``                 n/a
+  ``ETHTOOL_SRXCSUM``                 ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GTXCSUM``                 ``ETHTOOL_MSG_FEATURES_GET``
-  ``ETHTOOL_STXCSUM``                 n/a
+  ``ETHTOOL_STXCSUM``                 ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GSG``                     ``ETHTOOL_MSG_FEATURES_GET``
-  ``ETHTOOL_SSG``                     n/a
+  ``ETHTOOL_SSG``                     ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_TEST``                    n/a
   ``ETHTOOL_GSTRINGS``                ``ETHTOOL_MSG_STRSET_GET``
   ``ETHTOOL_PHYS_ID``                 n/a
   ``ETHTOOL_GSTATS``                  n/a
   ``ETHTOOL_GTSO``                    ``ETHTOOL_MSG_FEATURES_GET``
-  ``ETHTOOL_STSO``                    n/a
+  ``ETHTOOL_STSO``                    ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GPERMADDR``               rtnetlink ``RTM_GETLINK``
   ``ETHTOOL_GUFO``                    ``ETHTOOL_MSG_FEATURES_GET``
-  ``ETHTOOL_SUFO``                    n/a
+  ``ETHTOOL_SUFO``                    ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GGSO``                    ``ETHTOOL_MSG_FEATURES_GET``
-  ``ETHTOOL_SGSO``                    n/a
+  ``ETHTOOL_SGSO``                    ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GFLAGS``                  ``ETHTOOL_MSG_FEATURES_GET``
-  ``ETHTOOL_SFLAGS``                  n/a
+  ``ETHTOOL_SFLAGS``                  ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GPFLAGS``                 n/a
   ``ETHTOOL_SPFLAGS``                 n/a
   ``ETHTOOL_GRXFH``                   n/a
   ``ETHTOOL_SRXFH``                   n/a
   ``ETHTOOL_GGRO``                    ``ETHTOOL_MSG_FEATURES_GET``
-  ``ETHTOOL_SGRO``                    n/a
+  ``ETHTOOL_SGRO``                    ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GRXRINGS``                n/a
   ``ETHTOOL_GRXCLSRLCNT``             n/a
   ``ETHTOOL_GRXCLSRULE``              n/a
@@ -623,7 +661,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GRXFHINDIR``              n/a
   ``ETHTOOL_SRXFHINDIR``              n/a
   ``ETHTOOL_GFEATURES``               ``ETHTOOL_MSG_FEATURES_GET``
-  ``ETHTOOL_SFEATURES``               n/a
+  ``ETHTOOL_SFEATURES``               ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GCHANNELS``               n/a
   ``ETHTOOL_SCHANNELS``               n/a
   ``ETHTOOL_SET_DUMP``                n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d0cc7a0334c8..6f7aaa6b7f42 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -25,6 +25,7 @@ enum {
 	ETHTOOL_MSG_WOL_GET,
 	ETHTOOL_MSG_WOL_SET,
 	ETHTOOL_MSG_FEATURES_GET,
+	ETHTOOL_MSG_FEATURES_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -45,6 +46,7 @@ enum {
 	ETHTOOL_MSG_WOL_GET_REPLY,
 	ETHTOOL_MSG_WOL_NTF,
 	ETHTOOL_MSG_FEATURES_GET_REPLY,
+	ETHTOOL_MSG_FEATURES_SET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index a0cc2b969053..4ac1e05684ce 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -129,3 +129,172 @@ const struct ethnl_request_ops ethnl_features_request_ops = {
 	.reply_size		= features_reply_size,
 	.fill_reply		= features_fill_reply,
 };
+
+/* FEATURES_SET */
+
+static const struct nla_policy
+features_set_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
+	[ETHTOOL_A_FEATURES_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_FEATURES_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_FEATURES_HW]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_FEATURES_WANTED]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_FEATURES_ACTIVE]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_FEATURES_NOCHANGE]	= { .type = NLA_REJECT },
+};
+
+static void ethnl_features_to_bitmap(unsigned long *dest, netdev_features_t val)
+{
+	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
+	unsigned int i;
+
+	bitmap_zero(dest, NETDEV_FEATURE_COUNT);
+	for (i = 0; i < words; i++)
+		dest[i] = (unsigned long)(val >> (i * BITS_PER_LONG));
+}
+
+static netdev_features_t ethnl_bitmap_to_features(unsigned long *src)
+{
+	const unsigned int nft_bits = sizeof(netdev_features_t) * BITS_PER_BYTE;
+	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
+	netdev_features_t ret = 0;
+	unsigned int i;
+
+	for (i = 0; i < words; i++)
+		ret |= (netdev_features_t)(src[i]) << (i * BITS_PER_LONG);
+	ret &= ~(netdev_features_t)0 >> (nft_bits - NETDEV_FEATURE_COUNT);
+	return ret;
+}
+
+static int features_send_reply(struct net_device *dev, struct genl_info *info,
+			       const unsigned long *wanted,
+			       const unsigned long *wanted_mask,
+			       const unsigned long *active,
+			       const unsigned long *active_mask, bool compact)
+{
+	struct sk_buff *rskb;
+	void *reply_payload;
+	int reply_len = 0;
+	int ret;
+
+	reply_len = ethnl_reply_header_size();
+	ret = ethnl_bitset_size(wanted, wanted_mask, NETDEV_FEATURE_COUNT,
+				netdev_features_strings, compact);
+	if (ret < 0)
+		goto err;
+	reply_len += ret;
+	ret = ethnl_bitset_size(active, active_mask, NETDEV_FEATURE_COUNT,
+				netdev_features_strings, compact);
+	if (ret < 0)
+		goto err;
+	reply_len += ret;
+
+	ret = -ENOMEM;
+	rskb = ethnl_reply_init(reply_len, dev, ETHTOOL_MSG_FEATURES_SET_REPLY,
+				ETHTOOL_A_FEATURES_HEADER, info,
+				&reply_payload);
+	if (!rskb)
+		goto err;
+
+	ret = ethnl_put_bitset(rskb, ETHTOOL_A_FEATURES_WANTED, wanted,
+			       wanted_mask, NETDEV_FEATURE_COUNT,
+			       netdev_features_strings, compact);
+	if (ret < 0)
+		goto nla_put_failure;
+	ret = ethnl_put_bitset(rskb, ETHTOOL_A_FEATURES_ACTIVE, active,
+			       active_mask, NETDEV_FEATURE_COUNT,
+			       netdev_features_strings, compact);
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
+err:
+	GENL_SET_ERR_MSG(info, "failed to send reply message");
+	return ret;
+}
+
+int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
+{
+	DECLARE_BITMAP(wanted_diff_mask, NETDEV_FEATURE_COUNT);
+	DECLARE_BITMAP(active_diff_mask, NETDEV_FEATURE_COUNT);
+	DECLARE_BITMAP(old_active, NETDEV_FEATURE_COUNT);
+	DECLARE_BITMAP(new_active, NETDEV_FEATURE_COUNT);
+	DECLARE_BITMAP(req_wanted, NETDEV_FEATURE_COUNT);
+	DECLARE_BITMAP(req_mask, NETDEV_FEATURE_COUNT);
+	struct nlattr *tb[ETHTOOL_A_FEATURES_MAX + 1];
+	struct ethnl_req_info req_info = {};
+	struct net_device *dev;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_FEATURES_MAX, features_set_policy,
+			  info->extack);
+	if (ret < 0)
+		return ret;
+	if (!tb[ETHTOOL_A_FEATURES_WANTED])
+		return -EINVAL;
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_FEATURES_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+
+	rtnl_lock();
+	ethnl_features_to_bitmap(old_active, dev->features);
+	ret = ethnl_parse_bitset(req_wanted, req_mask, NETDEV_FEATURE_COUNT,
+				 tb[ETHTOOL_A_FEATURES_WANTED],
+				 netdev_features_strings, info->extack);
+	if (ret < 0)
+		goto out_rtnl;
+	if (ethnl_bitmap_to_features(req_mask) & ~NETIF_F_ETHTOOL_BITS) {
+		GENL_SET_ERR_MSG(info, "attempt to change non-ethtool features");
+		ret = -EINVAL;
+		goto out_rtnl;
+	}
+
+	/* set req_wanted bits not in req_mask from old_active */
+	bitmap_and(req_wanted, req_wanted, req_mask, NETDEV_FEATURE_COUNT);
+	bitmap_andnot(new_active, old_active, req_mask, NETDEV_FEATURE_COUNT);
+	bitmap_or(req_wanted, new_active, req_wanted, NETDEV_FEATURE_COUNT);
+	if (bitmap_equal(req_wanted, old_active, NETDEV_FEATURE_COUNT)) {
+		ret = 0;
+		goto out_rtnl;
+	}
+
+	dev->wanted_features = ethnl_bitmap_to_features(req_wanted);
+	__netdev_update_features(dev);
+	ethnl_features_to_bitmap(new_active, dev->features);
+
+	ret = 0;
+	if (!(req_info.flags & ETHTOOL_FLAG_OMIT_REPLY)) {
+		bool compact = req_info.flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+
+		bitmap_xor(wanted_diff_mask, req_wanted, new_active,
+			   NETDEV_FEATURE_COUNT);
+		bitmap_xor(active_diff_mask, old_active, new_active,
+			   NETDEV_FEATURE_COUNT);
+		bitmap_and(wanted_diff_mask, wanted_diff_mask, req_mask,
+			   NETDEV_FEATURE_COUNT);
+		bitmap_and(req_wanted, req_wanted, wanted_diff_mask,
+			   NETDEV_FEATURE_COUNT);
+		bitmap_and(new_active, new_active, active_diff_mask,
+			   NETDEV_FEATURE_COUNT);
+
+		ret = features_send_reply(dev, info, req_wanted,
+					  wanted_diff_mask, new_active,
+					  active_diff_mask, compact);
+	}
+
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index e451a75e9577..757ea3fc98a0 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -703,6 +703,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_FEATURES_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_features,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index be2325ea8493..135836201e89 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -343,5 +343,6 @@ int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_features(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.25.1

