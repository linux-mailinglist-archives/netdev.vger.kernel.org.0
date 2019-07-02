Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F1D5CEDE
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfGBLu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:50:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:39392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726803AbfGBLu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:50:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C4347B0DA;
        Tue,  2 Jul 2019 11:50:54 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 722EBE0159; Tue,  2 Jul 2019 13:50:54 +0200 (CEST)
Message-Id: <36d63bbef88eb5e93a932d21b36bb3dd2441cf02.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 15/15] ethtool: provide link state in SETTINGS_GET
 request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:50:54 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add information about device link state (as provided by ETHTOOL_GLINK ioctl
command) into the SETTINGS_GET reply when ETHTOOL_IM_SETTINGS_LINKSTATE
bit is set in the request info mask.

We cannot use NLA_FLAG for link state as we need three states: off, on and
unknown. The attribute is encapsulated in a nest to allow future extensions
(e.g. link down reason or more detailed link state information).

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.txt |  5 ++-
 include/uapi/linux/ethtool_netlink.h         | 14 +++++++-
 net/ethtool/common.c                         |  8 +++++
 net/ethtool/common.h                         |  3 ++
 net/ethtool/ioctl.c                          |  8 ++---
 net/ethtool/settings.c                       | 37 ++++++++++++++++++++
 6 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.txt b/Documentation/networking/ethtool-netlink.txt
index 05bc8f5f8654..dc06e33329a4 100644
--- a/Documentation/networking/ethtool-netlink.txt
+++ b/Documentation/networking/ethtool-netlink.txt
@@ -250,6 +250,7 @@ Info mask bits meaning:
 
     ETHTOOL_IM_SETTINGS_LINKINFO	link settings
     ETHTOOL_IM_SETTINGS_LINKMODES	link modes and related
+    ETHTOOL_IM_SETTINGS_LINKSTATE	link state
 
 Response contents:
 
@@ -266,6 +267,8 @@ Response contents:
         ETHTOOL_A_LINKMODES_PEER	    (bitset)	    partner link modes
         ETHTOOL_A_LINKMODES_SPEED	    (u32)	    link speed (Mb/s)
         ETHTOOL_A_LINKMODES_DUPLEX	    (u8)	    duplex mode
+    ETHTOOL_A_SETTINGS_LINK_STATE	(nested)	link state
+        ETHTOOL_A_LINKSTATE_LINK	    (u8)	    link on/off/unknown
 
 Most of the attributes and their values have the same meaning as matching
 members of the corresponding ioctl structures. For ETHTOOL_A_LINKMODES_OURS,
@@ -323,7 +326,7 @@ ETHTOOL_SWOL			n/a
 ETHTOOL_GMSGLVL			n/a
 ETHTOOL_SMSGLVL			n/a
 ETHTOOL_NWAY_RST		n/a
-ETHTOOL_GLINK			n/a
+ETHTOOL_GLINK			ETHNL_CMD_GET_SETTINGS
 ETHTOOL_GEEPROM			n/a
 ETHTOOL_SEEPROM			n/a
 ETHTOOL_GCOALESCE		n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 8ccf66ed3f58..46c13455246f 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -158,6 +158,7 @@ enum {
 	ETHTOOL_A_SETTINGS_HEADER,		/* nest - _A_HEADER_* */
 	ETHTOOL_A_SETTINGS_LINK_INFO,		/* nest - _A_LINKINFO_* */
 	ETHTOOL_A_SETTINGS_LINK_MODES,		/* nest - _A_LINKMODES_* */
+	ETHTOOL_A_SETTINGS_LINK_STATE,		/* nest - _A_LINKSTATE_* */
 
 	/* add new constants above here */
 	__ETHTOOL_A_SETTINGS_CNT,
@@ -166,9 +167,11 @@ enum {
 
 #define ETHTOOL_IM_SETTINGS_LINKINFO		(1U << 0)
 #define ETHTOOL_IM_SETTINGS_LINKMODES		(1U << 1)
+#define ETHTOOL_IM_SETTINGS_LINKSTATE		(1U << 2)
 
 #define ETHTOOL_IM_SETTINGS_ALL (ETHTOOL_IM_SETTINGS_LINKINFO | \
-				 ETHTOOL_IM_SETTINGS_LINKMODES)
+				 ETHTOOL_IM_SETTINGS_LINKMODES | \
+				 ETHTOOL_IM_SETTINGS_LINKSTATE)
 
 #define ETHTOOL_RF_SETTINGS_ALL 0
 
@@ -198,6 +201,15 @@ enum {
 	ETHTOOL_A_LINKMODES_MAX = (__ETHTOOL_A_LINKMODES_CNT - 1)
 };
 
+enum {
+	ETHTOOL_A_LINKSTATE_UNSPEC,
+	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_LINKSTATE_CNT,
+	ETHTOOL_A_LINKSTATE_MAX = (__ETHTOOL_A_LINKSTATE_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index abb00b3a7e77..b06635ad2620 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -130,3 +130,11 @@ convert_legacy_settings_to_link_ksettings(
 		= legacy_settings->eth_tp_mdix_ctrl;
 	return retval;
 }
+
+int __ethtool_get_link(struct net_device *dev)
+{
+	if (!dev->ethtool_ops->get_link)
+		return -EOPNOTSUPP;
+
+	return netif_running(dev) && dev->ethtool_ops->get_link(dev);
+}
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 0381936d8e1e..a2c1504576c2 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -3,6 +3,7 @@
 #ifndef _ETHTOOL_COMMON_H
 #define _ETHTOOL_COMMON_H
 
+#include <linux/netdevice.h>
 #include <linux/ethtool.h>
 
 extern const char
@@ -14,6 +15,8 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN];
 extern const char
 phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
 
+int __ethtool_get_link(struct net_device *dev);
+
 bool convert_legacy_settings_to_link_ksettings(
 	struct ethtool_link_ksettings *link_ksettings,
 	const struct ethtool_cmd *legacy_settings);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 504ab2f7009c..853b8c21a5e5 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1359,12 +1359,12 @@ static int ethtool_nway_reset(struct net_device *dev)
 static int ethtool_get_link(struct net_device *dev, char __user *useraddr)
 {
 	struct ethtool_value edata = { .cmd = ETHTOOL_GLINK };
+	int link = __ethtool_get_link(dev);
 
-	if (!dev->ethtool_ops->get_link)
-		return -EOPNOTSUPP;
-
-	edata.data = netif_running(dev) && dev->ethtool_ops->get_link(dev);
+	if (link < 0)
+		return link;
 
+	edata.data = link;
 	if (copy_to_user(useraddr, &edata, sizeof(edata)))
 		return -EFAULT;
 	return 0;
diff --git a/net/ethtool/settings.c b/net/ethtool/settings.c
index 2fc961297076..079d3776df71 100644
--- a/net/ethtool/settings.c
+++ b/net/ethtool/settings.c
@@ -11,6 +11,7 @@ struct settings_data {
 	struct ethnl_reply_data		repdata_base;
 	struct ethtool_link_ksettings	ksettings;
 	struct ethtool_link_settings	*lsettings;
+	int				link;
 	bool				lpm_empty;
 };
 
@@ -113,6 +114,7 @@ settings_get_policy[ETHTOOL_A_SETTINGS_MAX + 1] = {
 	[ETHTOOL_A_SETTINGS_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_SETTINGS_LINK_INFO]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_SETTINGS_LINK_MODES]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_SETTINGS_LINK_STATE]	= { .type = NLA_REJECT },
 };
 
 static int ethnl_get_link_ksettings(struct genl_info *info,
@@ -140,6 +142,7 @@ static int settings_prepare(struct ethnl_req_info *req_info,
 
 	data->lsettings = &data->ksettings.base;
 	data->lpm_empty = true;
+	data->link = -EOPNOTSUPP;
 
 	ret = ethnl_before_ops(dev);
 	if (ret < 0)
@@ -162,6 +165,8 @@ static int settings_prepare(struct ethnl_req_info *req_info,
 		ethnl_bitmap_to_u32(data->ksettings.link_modes.lp_advertising,
 				    __ETHTOOL_LINK_MODE_MASK_NWORDS);
 	}
+	if (req_mask & ETHTOOL_IM_SETTINGS_LINKSTATE)
+		data->link = __ethtool_get_link(dev);
 	ethnl_after_ops(dev);
 
 	data->repdata_base.info_mask = req_mask;
@@ -212,6 +217,13 @@ settings_linkmodes_size(const struct ethtool_link_ksettings *ksettings,
 	return nla_total_size(len);
 }
 
+static int settings_linkstate_size(int link)
+{
+	if (link < 0)
+		return nla_total_size(0);
+	return nla_total_size(nla_total_size(sizeof(u8)));
+}
+
 /* reply_size() handler
  *
  * To keep things simple, reserve space for some attributes which may not
@@ -235,6 +247,8 @@ static int settings_size(const struct ethnl_req_info *req_info)
 			return ret;
 		len += ret;
 	}
+	if (info_mask & ETHTOOL_IM_SETTINGS_LINKSTATE)
+		len += settings_linkstate_size(data->link);
 
 	return len;
 }
@@ -310,6 +324,23 @@ settings_fill_linkmodes(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static int settings_fill_linkstate(struct sk_buff *skb, int link)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, ETHTOOL_A_SETTINGS_LINK_STATE);
+	if (!nest)
+		return -EMSGSIZE;
+	if (link >= 0 && nla_put_u8(skb, ETHTOOL_A_LINKSTATE_LINK, !!link))
+		goto nla_put_failure;
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 /* fill_reply() handler */
 static int settings_fill(struct sk_buff *skb,
 			 const struct ethnl_req_info *req_info)
@@ -331,6 +362,11 @@ static int settings_fill(struct sk_buff *skb,
 		if (ret < 0)
 			return ret;
 	}
+	if (info_mask & ETHTOOL_IM_SETTINGS_LINKSTATE) {
+		ret = settings_fill_linkstate(skb, data->link);
+		if (ret < 0)
+			return ret;
+	}
 
 	return 0;
 }
@@ -389,6 +425,7 @@ settings_set_policy[ETHTOOL_A_SETTINGS_MAX + 1] = {
 	[ETHTOOL_A_SETTINGS_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_SETTINGS_LINK_INFO]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_SETTINGS_LINK_MODES]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_SETTINGS_LINK_STATE]		= { .type = NLA_REJECT },
 };
 
 static int ethnl_set_link_ksettings(struct genl_info *info,
-- 
2.22.0

