Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E35195897
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 15:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgC0OIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 10:08:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:41020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgC0OIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 10:08:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DDE1EADDA;
        Fri, 27 Mar 2020 14:08:02 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 8B94DE009C; Fri, 27 Mar 2020 15:08:02 +0100 (CET)
Message-Id: <d9573a59a6dbebce1f03dbb4ac0a8fe802fa07d2.1585316159.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585316159.git.mkubecek@suse.cz>
References: <cover.1585316159.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 09/12] ethtool: set EEE settings with EEE_SET
 request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Mar 2020 15:08:02 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement EEE_SET netlink request to set EEE settings of a network device.
These are traditionally set with ETHTOOL_SEEE ioctl request.

The netlink interface allows setting the EEE status for all link modes
supported by kernel but only first 32 link modes can be set at the moment
as only those are supported by the ethtool_ops callback.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 25 ++++++-
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/eee.c                            | 73 ++++++++++++++++++++
 net/ethtool/netlink.c                        |  5 ++
 net/ethtool/netlink.h                        |  1 +
 5 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 1d067f6e9d8a..856c4b5bcd6a 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -202,6 +202,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PAUSE_GET``             get pause parameters
   ``ETHTOOL_MSG_PAUSE_SET``             set pause parameters
   ``ETHTOOL_MSG_EEE_GET``               get EEE settings
+  ``ETHTOOL_MSG_EEE_SET``               set EEE settings
   ===================================== ================================
 
 Kernel to userspace:
@@ -904,6 +905,28 @@ netlink interface allows reporting EEE status for all link modes but only
 first 32 are provided by the ``ethtool_ops`` callback.
 
 
+EEE_SET
+=======
+
+Sets pause parameters like ``ETHTOOL_GEEEPARAM`` ioctl request.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_EEE_HEADER``               nested  request header
+  ``ETHTOOL_A_EEE_MODES_OURS``           bool    advertised modes
+  ``ETHTOOL_A_EEE_ENABLED``              bool    EEE is enabled
+  ``ETHTOOL_A_EEE_TX_LPI_ENABLED``       bool    Tx lpi enabled
+  ``ETHTOOL_A_EEE_TX_LPI_TIMER``         u32     Tx lpi timeout (in us)
+  =====================================  ======  ==========================
+
+``ETHTOOL_A_EEE_MODES_OURS`` is used to either list link modes to advertise
+EEE for (if there is no mask) or specify changes to the list (if there is
+a mask). The netlink interface allows reporting EEE status for all link modes
+but only first 32 can be set at the moment as that is what the ``ethtool_ops``
+callback supports.
+
+
 Request translation
 ===================
 
@@ -983,7 +1006,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GMODULEINFO``             n/a
   ``ETHTOOL_GMODULEEEPROM``           n/a
   ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
-  ``ETHTOOL_SEEE``                    n/a
+  ``ETHTOOL_SEEE``                    ``ETHTOOL_MSG_EEE_SET``
   ``ETHTOOL_GRSSH``                   n/a
   ``ETHTOOL_SRSSH``                   n/a
   ``ETHTOOL_GTUNABLE``                n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 2231dc779c3e..8959bc899f3c 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -37,6 +37,7 @@ enum {
 	ETHTOOL_MSG_PAUSE_GET,
 	ETHTOOL_MSG_PAUSE_SET,
 	ETHTOOL_MSG_EEE_GET,
+	ETHTOOL_MSG_EEE_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index 46244045319e..ded092d1b2b9 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -128,3 +128,76 @@ const struct ethnl_request_ops ethnl_eee_request_ops = {
 	.reply_size		= eee_reply_size,
 	.fill_reply		= eee_fill_reply,
 };
+
+/* EEE_SET */
+
+static const struct nla_policy
+eee_set_policy[ETHTOOL_A_EEE_MAX + 1] = {
+	[ETHTOOL_A_EEE_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_EEE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_EEE_MODES_OURS]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_EEE_MODES_PEER]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_EEE_ACTIVE]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_EEE_ENABLED]		= { .type = NLA_U8 },
+	[ETHTOOL_A_EEE_TX_LPI_ENABLED]	= { .type = NLA_U8 },
+	[ETHTOOL_A_EEE_TX_LPI_TIMER]	= { .type = NLA_U32 },
+};
+
+int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_EEE_MAX + 1];
+	struct ethtool_eee eee = {};
+	struct ethnl_req_info req_info = {};
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb, ETHTOOL_A_EEE_MAX,
+			  eee_set_policy, info->extack);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_EEE_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+	ret = -EOPNOTSUPP;
+	if (!ops->get_eee || !ops->set_eee)
+		goto out_dev;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+	ret = ops->get_eee(dev, &eee);
+	if (ret < 0)
+		goto out_ops;
+
+	ret = ethnl_update_bitset32(&eee.advertised, EEE_MODES_COUNT,
+				    tb[ETHTOOL_A_EEE_MODES_OURS],
+				    link_mode_names, info->extack, &mod);
+	if (ret < 0)
+		goto out_ops;
+	ethnl_update_bool32(&eee.eee_enabled, tb[ETHTOOL_A_EEE_ENABLED], &mod);
+	ethnl_update_bool32(&eee.tx_lpi_enabled,
+			    tb[ETHTOOL_A_EEE_TX_LPI_ENABLED], &mod);
+	ethnl_update_bool32(&eee.tx_lpi_timer, tb[ETHTOOL_A_EEE_TX_LPI_TIMER],
+			    &mod);
+	ret = 0;
+	if (!mod)
+		goto out_ops;
+
+	ret = dev->ethtool_ops->set_eee(dev, &eee);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index f9396d2a96f6..4630206837e0 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -824,6 +824,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_EEE_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_eee,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 8ad26d93590d..a251957d535e 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -355,5 +355,6 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.25.1

