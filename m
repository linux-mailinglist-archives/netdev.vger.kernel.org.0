Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162EB5CEDB
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfGBLuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:50:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:39314 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726803AbfGBLuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:50:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1EE7B136;
        Tue,  2 Jul 2019 11:50:49 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 6BC67E0159; Tue,  2 Jul 2019 13:50:49 +0200 (CEST)
Message-Id: <6979c8d00ddd7491330c55c6178632b853547d61.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 14/15] ethtool: set link settings and link modes
 with SETTINGS_SET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:50:49 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement SETTINGS_SET netlink request allowing to set link settings and
advertised link modes as an alternative to ETHTOOL_SLINKSETTINGS and
ETHTOOL_SSET ioctl commands.

Only values which are intended to be set are to be included in the request.
Omitted attributes will be left at current values.

ETHTOOL_A_SETTINGS_LINK_MODES nested attribute is used to set (or modify)
advertised link modes and related settings (autonegotiation, speed and
duplex). Kernel implements logic which was already partially implemented in
ethtool for ioctl interface: if autonegotiation is on (either it was on
already or the request turns it on), no link mode change is requested (no
ETHTOOL_A_LINKMODES_OURS attribute) and speed or duplex are provided,
advertised link modes are set to supported modes matching requested speed
and/or duplex.

ETHTOOL_A_SETTINGS_LINK_INFO nested attribute is used to set physical port,
phy MDIO address and MDI(-X) control. An attempt to modify other attributes
provided by corresponding GET request is rejected.

When any data is modified, ETHTOOL_MSG_SETTINGS_NTF message in the same
format as a reply to GET request is sent to notify userspace about the
changes. The same notification is also sent when these settings are
modified using the ioctl interface.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.txt |  34 +-
 include/uapi/linux/ethtool_netlink.h         |   2 +
 net/ethtool/ioctl.c                          |  18 +-
 net/ethtool/netlink.c                        |  11 +
 net/ethtool/netlink.h                        |   2 +
 net/ethtool/settings.c                       | 332 +++++++++++++++++++
 6 files changed, 395 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.txt b/Documentation/networking/ethtool-netlink.txt
index 1d803488e02c..05bc8f5f8654 100644
--- a/Documentation/networking/ethtool-netlink.txt
+++ b/Documentation/networking/ethtool-netlink.txt
@@ -152,11 +152,13 @@ Userspace to kernel:
 
     ETHTOOL_MSG_STRSET_GET		get string set
     ETHTOOL_MSG_SETTINGS_GET		get device settings
+    ETHTOOL_MSG_SETTINGS_SET		set device settings
 
 Kernel to userspace:
 
     ETHTOOL_MSG_STRSET_GET_REPLY	string set contents
     ETHTOOL_MSG_SETTINGS_GET_REPLY	device settings
+    ETHTOOL_MSG_SETTINGS_NTF		device settings notification
 
 "GET" requests are sent by userspace applications to retrieve device
 information. They usually do not contain any message specific attributes.
@@ -275,6 +277,34 @@ to them are broadcasted as notifications on change of these settings using
 netlink or ioctl ethtool interface.
 
 
+SETTINGS_SET
+------------
+
+SETTINGS_SET request allows setting some of the data reported by SETTINGS_GET.
+Request flags, info_mask and index are ignored. These attributes are allowed
+to be passed with SETTINGS_SET request:
+
+    ETHTOOL_A_SETTINGS_HEADER		(nested)	request header
+    ETHTOOL_A_SETTINGS_LINK_INFO	(nested)	link settings
+        ETHTOOL_A_LINKINFO_PORT		    (u8)	    physical port
+        ETHTOOL_A_LINKINFO_PHYADDR	    (u8)	    MDIO address of phy
+        ETHTOOL_A_LINKINFO_TP_MDIX_CTRL	    (u8)	    MDI(-X) control
+    ETHTOOL_A_SETTINGS_LINK_MODES	(nested)	link modes
+        ETHTOOL_A_LINKMODES_AUTONEG	    (u8)	    autonegotiation
+        ETHTOOL_A_LINKMODES_OURS	    (bitset)	    advertised link modes
+        ETHTOOL_A_LINKMODES_SPEED	    (u32)	    link speed (Mb/s)
+        ETHTOOL_A_LINKMODES_DUPLEX	    (u8)	    duplex mode
+
+ETHTOOL_A_LINKMODES_OURS bit set allows setting advertised link modes. If
+autonegotiation is on (either set now or kept from before), advertised modes
+are not changed (no ETHTOOL_A_LINKMODES_OURS attribute) and at least one of
+speed and duplex is specified, kernel adjusts advertised modes to all
+supported modes matching speed, duplex or both (whatever is specified). This
+autoselection is done on ethtool side with ioctl interface, netlink interface
+is supposed to allow requesting changes without knowing what exactly kernel
+supports.
+
+
 Request translation
 -------------------
 
@@ -285,7 +315,7 @@ have their netlink replacement yet.
 ioctl command			netlink command
 ---------------------------------------------------------------------
 ETHTOOL_GSET			ETHTOOL_MSG_SETTINGS_GET
-ETHTOOL_SSET			n/a
+ETHTOOL_SSET			ETHTOOL_MSG_SETTINGS_SET
 ETHTOOL_GDRVINFO		n/a
 ETHTOOL_GREGS			n/a
 ETHTOOL_GWOL			n/a
@@ -359,7 +389,7 @@ ETHTOOL_STUNABLE		n/a
 ETHTOOL_GPHYSTATS		n/a
 ETHTOOL_PERQUEUE		n/a
 ETHTOOL_GLINKSETTINGS		ETHTOOL_MSG_SETTINGS_GET
-ETHTOOL_SLINKSETTINGS		n/a
+ETHTOOL_SLINKSETTINGS		ETHTOOL_MSG_SETTINGS_SET
 ETHTOOL_PHY_GTUNABLE		n/a
 ETHTOOL_PHY_STUNABLE		n/a
 ETHTOOL_GFECPARAM		n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index a046dd8da50e..8ccf66ed3f58 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -16,6 +16,7 @@ enum {
 	ETHTOOL_MSG_USER_NONE,
 	ETHTOOL_MSG_STRSET_GET,
 	ETHTOOL_MSG_SETTINGS_GET,
+	ETHTOOL_MSG_SETTINGS_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -27,6 +28,7 @@ enum {
 	ETHTOOL_MSG_KERNEL_NONE,
 	ETHTOOL_MSG_STRSET_GET_REPLY,
 	ETHTOOL_MSG_SETTINGS_GET_REPLY,
+	ETHTOOL_MSG_SETTINGS_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index ed53e07d619e..504ab2f7009c 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -26,6 +26,7 @@
 #include <net/devlink.h>
 #include <net/xdp_sock.h>
 #include <net/flow_offload.h>
+#include <linux/ethtool_netlink.h>
 
 #include "common.h"
 
@@ -565,7 +566,13 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
 	    != link_ksettings.base.link_mode_masks_nwords)
 		return -EINVAL;
 
-	return dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	err = dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	if (err >= 0)
+		ethtool_notify(dev, NULL, ETHTOOL_MSG_SETTINGS_NTF,
+			       ETHTOOL_IM_SETTINGS_LINKINFO |
+			       ETHTOOL_IM_SETTINGS_LINKMODES,
+			       NULL);
+	return err;
 }
 
 /* Query device for its ethtool_cmd settings.
@@ -614,6 +621,7 @@ static int ethtool_set_settings(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_link_ksettings link_ksettings;
 	struct ethtool_cmd cmd;
+	int ret;
 
 	ASSERT_RTNL();
 
@@ -626,7 +634,13 @@ static int ethtool_set_settings(struct net_device *dev, void __user *useraddr)
 		return -EINVAL;
 	link_ksettings.base.link_mode_masks_nwords =
 		__ETHTOOL_LINK_MODE_MASK_NU32;
-	return dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	ret = dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	if (ret >= 0)
+		ethtool_notify(dev, NULL, ETHTOOL_MSG_SETTINGS_NTF,
+			       ETHTOOL_IM_SETTINGS_LINKINFO |
+			       ETHTOOL_IM_SETTINGS_LINKMODES,
+			       NULL);
+	return ret;
 }
 
 static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 9ff17ef05023..69b6dfe2a1c8 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -612,6 +612,11 @@ static int ethnl_get_done(struct netlink_callback *cb)
 
 static const struct get_request_ops *ethnl_std_notify_to_ops(unsigned int cmd)
 {
+	switch (cmd) {
+	case ETHTOOL_MSG_SETTINGS_NTF:
+		return &settings_request_ops;
+	};
+
 	WARN_ONCE(1, "unexpected notification type %u\n", cmd);
 	return NULL;
 }
@@ -679,6 +684,7 @@ typedef void (*ethnl_notify_handler_t)(struct net_device *dev,
 				       const void *data);
 
 static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
+	[ETHTOOL_MSG_SETTINGS_NTF]	= ethnl_std_notify,
 };
 
 void ethtool_notify(struct net_device *dev, struct netlink_ext_ack *extack,
@@ -714,6 +720,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_get_dumpit,
 		.done	= ethnl_get_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_SETTINGS_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_settings,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 6512d9d508bf..43fdf11cfc6d 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -297,4 +297,6 @@ struct get_request_ops {
 extern const struct get_request_ops strset_request_ops;
 extern const struct get_request_ops settings_request_ops;
 
+int ethnl_set_settings(struct sk_buff *skb, struct genl_info *info);
+
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/settings.c b/net/ethtool/settings.c
index 11ec30b9d48b..2fc961297076 100644
--- a/net/ethtool/settings.c
+++ b/net/ethtool/settings.c
@@ -14,6 +14,99 @@ struct settings_data {
 	bool				lpm_empty;
 };
 
+struct link_mode_info {
+	int				speed;
+	u8				duplex;
+};
+
+#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex) \
+	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] = { \
+		.speed	= SPEED_ ## _speed, \
+		.duplex	= __DUPLEX_ ## _duplex \
+	}
+#define __DUPLEX_Half DUPLEX_HALF
+#define __DUPLEX_Full DUPLEX_FULL
+#define __DEFINE_SPECIAL_MODE_PARAMS(_mode) \
+	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] = { \
+		.speed	= SPEED_UNKNOWN, \
+		.duplex	= DUPLEX_UNKNOWN, \
+	}
+
+static const struct link_mode_info link_mode_params[] = {
+	__DEFINE_LINK_MODE_PARAMS(10, T, Half),
+	__DEFINE_LINK_MODE_PARAMS(10, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, T, Half),
+	__DEFINE_LINK_MODE_PARAMS(100, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, Half),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(Autoneg),
+	__DEFINE_SPECIAL_MODE_PARAMS(TP),
+	__DEFINE_SPECIAL_MODE_PARAMS(AUI),
+	__DEFINE_SPECIAL_MODE_PARAMS(MII),
+	__DEFINE_SPECIAL_MODE_PARAMS(FIBRE),
+	__DEFINE_SPECIAL_MODE_PARAMS(BNC),
+	__DEFINE_LINK_MODE_PARAMS(10000, T, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(Pause),
+	__DEFINE_SPECIAL_MODE_PARAMS(Asym_Pause),
+	__DEFINE_LINK_MODE_PARAMS(2500, X, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(Backplane),
+	__DEFINE_LINK_MODE_PARAMS(1000, KX, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KX4, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KR, Full),
+	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] = {
+		.speed	= SPEED_10000,
+		.duplex = DUPLEX_FULL,
+	},
+	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, Full),
+	__DEFINE_LINK_MODE_PARAMS(20000, KR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, KR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, CR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, SR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, LR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, KR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, CR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, SR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, LR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, CR, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, KR, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, SR, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, CR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, KR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, SR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, X, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, CR, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, SR, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, LR, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, LRM, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, ER, Full),
+	__DEFINE_LINK_MODE_PARAMS(2500, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(5000, T, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_NONE),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_RS),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_BASER),
+	__DEFINE_LINK_MODE_PARAMS(50000, KR, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, SR, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, CR, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, DR, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, DR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, KR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, SR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, DR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, CR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, T1, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, T1, Full),
+};
+
 static const struct nla_policy
 settings_get_policy[ETHTOOL_A_SETTINGS_MAX + 1] = {
 	[ETHTOOL_A_SETTINGS_UNSPEC]	= { .type = NLA_REJECT },
@@ -257,3 +350,242 @@ const struct get_request_ops settings_request_ops = {
 	.reply_size		= settings_size,
 	.fill_reply		= settings_fill,
 };
+
+/* SET_SETTINGS */
+
+static const struct nla_policy settings_hdr_policy[ETHTOOL_A_HEADER_MAX + 1] = {
+	[ETHTOOL_A_HEADER_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_HEADER_DEV_INDEX]		= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_DEV_NAME]		= { .type = NLA_NUL_STRING,
+						    .len = IFNAMSIZ - 1 },
+	[ETHTOOL_A_HEADER_INFOMASK]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_HEADER_GFLAGS]		= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_RFLAGS]		= { .type = NLA_REJECT },
+};
+
+static const struct nla_policy
+linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
+	[ETHTOOL_A_LINKINFO_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKINFO_PHYADDR]		= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKINFO_TP_MDIX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]	= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKINFO_TRANSCEIVER]	= { .type = NLA_REJECT },
+};
+
+static const struct nla_policy
+linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
+	[ETHTOOL_A_LINKMODES_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_AUTONEG]		= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKMODES_OURS]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
+	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
+};
+
+static const struct nla_policy
+settings_set_policy[ETHTOOL_A_SETTINGS_MAX + 1] = {
+	[ETHTOOL_A_SETTINGS_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_SETTINGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_SETTINGS_LINK_INFO]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_SETTINGS_LINK_MODES]		= { .type = NLA_NESTED },
+};
+
+static int ethnl_set_link_ksettings(struct genl_info *info,
+				    struct net_device *dev,
+				    struct ethtool_link_ksettings *ksettings)
+{
+	int ret = dev->ethtool_ops->set_link_ksettings(dev, ksettings);
+
+	if (ret < 0)
+		GENL_SET_ERR_MSG(info, "link settings update failed");
+	return ret;
+}
+
+/* Set advertised link modes to all supported modes matching requested speed
+ * and duplex values. Called when autonegotiation is on, speed or duplex is
+ * requested but no link mode change. This is done in userspace with ioctl()
+ * interface, move it into kernel for netlink.
+ * Returns true if advertised modes bitmap was modified.
+ */
+static bool settings_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
+				    bool req_speed, bool req_duplex)
+{
+	unsigned long *advertising = ksettings->link_modes.advertising;
+	unsigned long *supported = ksettings->link_modes.supported;
+	DECLARE_BITMAP(old_adv, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	unsigned int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(link_mode_params) !=
+		     __ETHTOOL_LINK_MODE_MASK_NBITS);
+
+	bitmap_copy(old_adv, advertising, __ETHTOOL_LINK_MODE_MASK_NBITS);
+
+	for (i = 0; i < __ETHTOOL_LINK_MODE_MASK_NBITS; i++) {
+		const struct link_mode_info *info = &link_mode_params[i];
+
+		if (info->speed == SPEED_UNKNOWN)
+			continue;
+		if (test_bit(i, supported) &&
+		    (!req_speed || info->speed == ksettings->base.speed) &&
+		    (!req_duplex || info->duplex == ksettings->base.duplex))
+			set_bit(i, advertising);
+		else
+			clear_bit(i, advertising);
+	}
+
+	return !bitmap_equal(old_adv, advertising,
+			     __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static int settings_update_linkinfo(struct genl_info *info, struct nlattr *nest,
+				    struct ethtool_link_settings *lsettings)
+{
+	struct nlattr *tb[ETHTOOL_A_LINKINFO_MAX + 1];
+	int ret;
+
+	if (!nest)
+		return 0;
+	ret = nla_parse_nested(tb, ETHTOOL_A_LINKINFO_MAX, nest,
+			       linkinfo_set_policy, info->extack);
+	if (ret < 0)
+		return ret;
+
+	ret = 0;
+	if (ethnl_update_u8(&lsettings->port, tb[ETHTOOL_A_LINKINFO_PORT]))
+		ret = 1;
+	if (ethnl_update_u8(&lsettings->phy_address,
+			    tb[ETHTOOL_A_LINKINFO_PHYADDR]))
+		ret = 1;
+	if (ethnl_update_u8(&lsettings->eth_tp_mdix_ctrl,
+			    tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]))
+		ret = 1;
+
+	return ret;
+}
+
+static int settings_update_linkmodes(struct genl_info *info,
+				     const struct nlattr *nest,
+				     struct ethtool_link_ksettings *ksettings)
+{
+	struct ethtool_link_settings *lsettings = &ksettings->base;
+	struct nlattr *tb[ETHTOOL_A_LINKMODES_MAX + 1];
+	bool req_speed, req_duplex;
+	bool mod = false;
+	int ret;
+
+	if (!nest)
+		return 0;
+	ret = nla_parse_nested(tb, ETHTOOL_A_LINKMODES_MAX, nest,
+			       linkmodes_set_policy, info->extack);
+	if (ret < 0)
+		return ret;
+	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
+	req_duplex = tb[ETHTOOL_A_LINKMODES_DUPLEX];
+
+	if (ethnl_update_u8(&lsettings->autoneg,
+			    tb[ETHTOOL_A_LINKMODES_AUTONEG]))
+		mod = true;
+	if (ethnl_update_bitset(ksettings->link_modes.advertising, NULL,
+				__ETHTOOL_LINK_MODE_MASK_NBITS,
+				tb[ETHTOOL_A_LINKMODES_OURS],
+				&ret, link_mode_names, false, info))
+		mod = true;
+	if (ret < 0)
+		return ret;
+	if (ethnl_update_u32(&lsettings->speed, tb[ETHTOOL_A_LINKMODES_SPEED]))
+		mod = true;
+	if (ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX]))
+		mod = true;
+
+	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
+	    (req_speed || req_duplex) &&
+	    settings_auto_linkmodes(ksettings, req_speed, req_duplex))
+		mod = true;
+
+	return mod;
+}
+
+/* Update device settings using ->set_link_ksettings() callback */
+static int ethnl_update_ksettings(struct genl_info *info, struct nlattr **tb,
+				  struct net_device *dev, u32 *req_mask)
+{
+	struct ethtool_link_ksettings ksettings = {};
+	struct ethtool_link_settings *lsettings;
+	u32 mod_mask = 0;
+	int ret;
+
+	ret = ethnl_get_link_ksettings(info, dev, &ksettings);
+	if (ret < 0)
+		return ret;
+	lsettings = &ksettings.base;
+
+	ret = settings_update_linkinfo(info, tb[ETHTOOL_A_SETTINGS_LINK_INFO],
+				       lsettings);
+	if (ret < 0)
+		return ret;
+	if (ret)
+		mod_mask |= ETHTOOL_IM_SETTINGS_LINKINFO;
+
+	ret = settings_update_linkmodes(info, tb[ETHTOOL_A_SETTINGS_LINK_MODES],
+					&ksettings);
+	if (ret < 0)
+		return ret;
+	if (ret)
+		mod_mask |= ETHTOOL_IM_SETTINGS_LINKMODES;
+
+	if (mod_mask) {
+		ret = ethnl_set_link_ksettings(info, dev, &ksettings);
+		if (ret < 0)
+			return ret;
+		*req_mask |= mod_mask;
+	}
+
+	return 0;
+}
+
+int ethnl_set_settings(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_SETTINGS_MAX + 1];
+	struct ethnl_req_info req_info = {};
+	struct net_device *dev;
+	u32 req_mask = 0;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_SETTINGS_MAX, settings_set_policy,
+			  info->extack);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_SETTINGS_HEADER],
+				 genl_info_net(info), info->extack,
+				 settings_hdr_policy, true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+
+	rtnl_lock();
+	ret = ethnl_before_ops(dev);
+	if (ret < 0)
+		goto out_rtnl;
+	if (tb[ETHTOOL_A_SETTINGS_LINK_INFO] ||
+	    tb[ETHTOOL_A_SETTINGS_LINK_MODES]) {
+		ret = -EOPNOTSUPP;
+		if (!dev->ethtool_ops->get_link_ksettings)
+			goto out_ops;
+		ret = ethnl_update_ksettings(info, tb, dev, &req_mask);
+		if (ret < 0)
+			goto out_ops;
+	}
+	ret = 0;
+
+out_ops:
+	if (req_mask)
+		ethtool_notify(dev, NULL, ETHTOOL_MSG_SETTINGS_NTF, req_mask,
+			       NULL);
+	ethnl_after_ops(dev);
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
-- 
2.22.0

