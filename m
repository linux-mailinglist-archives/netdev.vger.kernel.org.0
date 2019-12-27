Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A7612B572
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 15:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfL0O4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 09:56:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:43008 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfL0O4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 09:56:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B447FAFB5;
        Fri, 27 Dec 2019 14:56:13 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 62EA2E008A; Fri, 27 Dec 2019 15:56:13 +0100 (CET)
Message-Id: <7db628c205242dc249c2d8468b458495bb43f8bb.1577457846.git.mkubecek@suse.cz>
In-Reply-To: <cover.1577457846.git.mkubecek@suse.cz>
References: <cover.1577457846.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v9 12/14] ethtool: set link modes related data with
 LINKMODES_SET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Dec 2019 15:56:13 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement LINKMODES_SET netlink request to set advertised linkmodes and
related attributes as ETHTOOL_SLINKSETTINGS and ETHTOOL_SSET commands do.

The request allows setting autonegotiation flag, speed, duplex and
advertised link modes.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst |  27 +++
 include/uapi/linux/ethtool_netlink.h         |   1 +
 net/ethtool/linkmodes.c                      | 235 +++++++++++++++++++
 net/ethtool/netlink.c                        |   5 +
 net/ethtool/netlink.h                        |   1 +
 5 files changed, 269 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 04c55be0264c..625c80183563 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -183,6 +183,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_LINKINFO_GET``          get link settings
   ``ETHTOOL_MSG_LINKINFO_SET``          set link settings
   ``ETHTOOL_MSG_LINKMODES_GET``         get link modes info
+  ``ETHTOOL_MSG_LINKMODES_SET``         set link modes info
   ===================================== ================================
 
 Kernel to userspace:
@@ -366,6 +367,30 @@ list.
 devices supporting the request).
 
 
+LINKMODES_SET
+=============
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_LINKMODES_HEADER``        nested  request header
+  ``ETHTOOL_A_LINKMODES_AUTONEG``       u8      autonegotiation status
+  ``ETHTOOL_A_LINKMODES_OURS``          bitset  advertised link modes
+  ``ETHTOOL_A_LINKMODES_PEER``          bitset  partner link modes
+  ``ETHTOOL_A_LINKMODES_SPEED``         u32     link speed (Mb/s)
+  ``ETHTOOL_A_LINKMODES_DUPLEX``        u8      duplex mode
+  ====================================  ======  ==========================
+
+``ETHTOOL_A_LINKMODES_OURS`` bit set allows setting advertised link modes. If
+autonegotiation is on (either set now or kept from before), advertised modes
+are not changed (no ``ETHTOOL_A_LINKMODES_OURS`` attribute) and at least one
+of speed and duplex is specified, kernel adjusts advertised modes to all
+supported modes matching speed, duplex or both (whatever is specified). This
+autoselection is done on ethtool side with ioctl interface, netlink interface
+is supposed to allow requesting changes without knowing what exactly kernel
+supports.
+
+
 Request translation
 ===================
 
@@ -379,6 +404,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GSET``                    ``ETHTOOL_MSG_LINKINFO_GET``
                                       ``ETHTOOL_MSG_LINKMODES_GET``
   ``ETHTOOL_SSET``                    ``ETHTOOL_MSG_LINKINFO_SET``
+                                      ``ETHTOOL_MSG_LINKMODES_SET``
   ``ETHTOOL_GDRVINFO``                n/a
   ``ETHTOOL_GREGS``                   n/a
   ``ETHTOOL_GWOL``                    n/a
@@ -454,6 +480,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_GET``
                                       ``ETHTOOL_MSG_LINKMODES_GET``
   ``ETHTOOL_SLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_SET``
+                                      ``ETHTOOL_MSG_LINKMODES_SET``
   ``ETHTOOL_PHY_GTUNABLE``            n/a
   ``ETHTOOL_PHY_STUNABLE``            n/a
   ``ETHTOOL_GFECPARAM``               n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index dc1cae052eee..cddf978b98df 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -18,6 +18,7 @@ enum {
 	ETHTOOL_MSG_LINKINFO_GET,
 	ETHTOOL_MSG_LINKINFO_SET,
 	ETHTOOL_MSG_LINKMODES_GET,
+	ETHTOOL_MSG_LINKMODES_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 81856fa1e632..790b60771d0e 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -138,3 +138,238 @@ const struct ethnl_request_ops ethnl_linkmodes_request_ops = {
 	.reply_size		= linkmodes_reply_size,
 	.fill_reply		= linkmodes_fill_reply,
 };
+
+/* LINKMODES_SET */
+
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
+	__DEFINE_LINK_MODE_PARAMS(400000, KR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, SR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
+};
+
+static const struct nla_policy
+linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
+	[ETHTOOL_A_LINKMODES_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKMODES_AUTONEG]		= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKMODES_OURS]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
+	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
+};
+
+/* Set advertised link modes to all supported modes matching requested speed
+ * and duplex values. Called when autonegotiation is on, speed or duplex is
+ * requested but no link mode change. This is done in userspace with ioctl()
+ * interface, move it into kernel for netlink.
+ * Returns true if advertised modes bitmap was modified.
+ */
+static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
+				 bool req_speed, bool req_duplex)
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
+static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
+				  struct ethtool_link_ksettings *ksettings,
+				  bool *mod)
+{
+	struct ethtool_link_settings *lsettings = &ksettings->base;
+	bool req_speed, req_duplex;
+	int ret;
+
+	*mod = false;
+	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
+	req_duplex = tb[ETHTOOL_A_LINKMODES_DUPLEX];
+
+	ethnl_update_u8(&lsettings->autoneg, tb[ETHTOOL_A_LINKMODES_AUTONEG],
+			mod);
+	ret = ethnl_update_bitset(ksettings->link_modes.advertising,
+				  __ETHTOOL_LINK_MODE_MASK_NBITS,
+				  tb[ETHTOOL_A_LINKMODES_OURS], link_mode_names,
+				  info->extack, mod);
+	if (ret < 0)
+		return ret;
+	ethnl_update_u32(&lsettings->speed, tb[ETHTOOL_A_LINKMODES_SPEED],
+			 mod);
+	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
+			mod);
+
+	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
+	    (req_speed || req_duplex) &&
+	    ethnl_auto_linkmodes(ksettings, req_speed, req_duplex))
+		*mod = true;
+
+	return 0;
+}
+
+int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_LINKMODES_MAX + 1];
+	struct ethtool_link_ksettings ksettings = {};
+	struct ethtool_link_settings *lsettings;
+	struct ethnl_req_info req_info = {};
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_LINKMODES_MAX, linkmodes_set_policy,
+			  info->extack);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_LINKMODES_HEADER],
+				 genl_info_net(info), info->extack, true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	if (!dev->ethtool_ops->get_link_ksettings ||
+	    !dev->ethtool_ops->set_link_ksettings)
+		return -EOPNOTSUPP;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = __ethtool_get_link_ksettings(dev, &ksettings);
+	if (ret < 0) {
+		if (info)
+			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
+		goto out_ops;
+	}
+	lsettings = &ksettings.base;
+
+	ret = ethnl_update_linkmodes(info, tb, &ksettings, &mod);
+	if (ret < 0)
+		goto out_ops;
+
+	if (mod) {
+		ret = dev->ethtool_ops->set_link_ksettings(dev, &ksettings);
+		if (ret < 0)
+			GENL_SET_ERR_MSG(info, "link settings update failed");
+	}
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 703ff3a227a4..5f28f3cb022d 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -638,6 +638,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_LINKMODES_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_linkmodes,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 256d38972d1e..1269cca8a002 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -335,5 +335,6 @@ extern const struct ethnl_request_ops ethnl_linkinfo_request_ops;
 extern const struct ethnl_request_ops ethnl_linkmodes_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.24.1

