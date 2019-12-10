Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D155118932
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfLJNIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:08:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:49344 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727633AbfLJNIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 08:08:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C0BC3AE5C;
        Tue, 10 Dec 2019 13:08:13 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 6D3BCE00E0; Tue, 10 Dec 2019 14:08:13 +0100 (CET)
Message-Id: <fe689865e1e8cda85dd0ca259c820c473bd9576c.1575982069.git.mkubecek@suse.cz>
In-Reply-To: <cover.1575982069.git.mkubecek@suse.cz>
References: <cover.1575982069.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 5/5] ethtool: provide link mode names as a string
 set
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Dec 2019 14:08:13 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike e.g. netdev features, the ethtool ioctl interface requires link mode
table to be in sync between kernel and userspace for userspace to be able
to display and set all link modes supported by kernel. The way arbitrary
length bitsets are implemented in netlink interface, this will be no longer
needed.

To allow userspace to access all link modes running kernel supports, add
table of ethernet link mode names and make it available as a string set to
userspace GET_STRSET requests. Add build time check to make sure names
are defined for all modes declared in enum ethtool_link_mode_bit_indices.

Once the string set is available, make it also accessible via ioctl.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/uapi/linux/ethtool.h |  2 +
 net/ethtool/common.c         | 86 ++++++++++++++++++++++++++++++++++++
 net/ethtool/common.h         |  5 +++
 net/ethtool/ioctl.c          |  6 +++
 4 files changed, 99 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index d4591792f0b4..f44155840b07 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -593,6 +593,7 @@ struct ethtool_pauseparam {
  * @ETH_SS_RSS_HASH_FUNCS: RSS hush function names
  * @ETH_SS_PHY_STATS: Statistic names, for use with %ETHTOOL_GPHYSTATS
  * @ETH_SS_PHY_TUNABLES: PHY tunable names
+ * @ETH_SS_LINK_MODES: link mode names
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -604,6 +605,7 @@ enum ethtool_stringset {
 	ETH_SS_TUNABLES,
 	ETH_SS_PHY_STATS,
 	ETH_SS_PHY_TUNABLES,
+	ETH_SS_LINK_MODES,
 };
 
 /**
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 220d6b539180..e0ba47c6e470 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -83,3 +83,89 @@ phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_PHY_FAST_LINK_DOWN] = "phy-fast-link-down",
 	[ETHTOOL_PHY_EDPD]	= "phy-energy-detect-power-down",
 };
+
+#define __LINK_MODE_NAME(speed, type, duplex) \
+	#speed "base" #type "/" #duplex
+#define __DEFINE_LINK_MODE_NAME(speed, type, duplex) \
+	[ETHTOOL_LINK_MODE(speed, type, duplex)] = \
+	__LINK_MODE_NAME(speed, type, duplex)
+#define __DEFINE_SPECIAL_MODE_NAME(_mode, _name) \
+	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] = _name
+
+const char link_mode_names[][ETH_GSTRING_LEN] = {
+	__DEFINE_LINK_MODE_NAME(10, T, Half),
+	__DEFINE_LINK_MODE_NAME(10, T, Full),
+	__DEFINE_LINK_MODE_NAME(100, T, Half),
+	__DEFINE_LINK_MODE_NAME(100, T, Full),
+	__DEFINE_LINK_MODE_NAME(1000, T, Half),
+	__DEFINE_LINK_MODE_NAME(1000, T, Full),
+	__DEFINE_SPECIAL_MODE_NAME(Autoneg, "Autoneg"),
+	__DEFINE_SPECIAL_MODE_NAME(TP, "TP"),
+	__DEFINE_SPECIAL_MODE_NAME(AUI, "AUI"),
+	__DEFINE_SPECIAL_MODE_NAME(MII, "MII"),
+	__DEFINE_SPECIAL_MODE_NAME(FIBRE, "FIBRE"),
+	__DEFINE_SPECIAL_MODE_NAME(BNC, "BNC"),
+	__DEFINE_LINK_MODE_NAME(10000, T, Full),
+	__DEFINE_SPECIAL_MODE_NAME(Pause, "Pause"),
+	__DEFINE_SPECIAL_MODE_NAME(Asym_Pause, "Asym_Pause"),
+	__DEFINE_LINK_MODE_NAME(2500, X, Full),
+	__DEFINE_SPECIAL_MODE_NAME(Backplane, "Backplane"),
+	__DEFINE_LINK_MODE_NAME(1000, KX, Full),
+	__DEFINE_LINK_MODE_NAME(10000, KX4, Full),
+	__DEFINE_LINK_MODE_NAME(10000, KR, Full),
+	__DEFINE_SPECIAL_MODE_NAME(10000baseR_FEC, "10000baseR_FEC"),
+	__DEFINE_LINK_MODE_NAME(20000, MLD2, Full),
+	__DEFINE_LINK_MODE_NAME(20000, KR2, Full),
+	__DEFINE_LINK_MODE_NAME(40000, KR4, Full),
+	__DEFINE_LINK_MODE_NAME(40000, CR4, Full),
+	__DEFINE_LINK_MODE_NAME(40000, SR4, Full),
+	__DEFINE_LINK_MODE_NAME(40000, LR4, Full),
+	__DEFINE_LINK_MODE_NAME(56000, KR4, Full),
+	__DEFINE_LINK_MODE_NAME(56000, CR4, Full),
+	__DEFINE_LINK_MODE_NAME(56000, SR4, Full),
+	__DEFINE_LINK_MODE_NAME(56000, LR4, Full),
+	__DEFINE_LINK_MODE_NAME(25000, CR, Full),
+	__DEFINE_LINK_MODE_NAME(25000, KR, Full),
+	__DEFINE_LINK_MODE_NAME(25000, SR, Full),
+	__DEFINE_LINK_MODE_NAME(50000, CR2, Full),
+	__DEFINE_LINK_MODE_NAME(50000, KR2, Full),
+	__DEFINE_LINK_MODE_NAME(100000, KR4, Full),
+	__DEFINE_LINK_MODE_NAME(100000, SR4, Full),
+	__DEFINE_LINK_MODE_NAME(100000, CR4, Full),
+	__DEFINE_LINK_MODE_NAME(100000, LR4_ER4, Full),
+	__DEFINE_LINK_MODE_NAME(50000, SR2, Full),
+	__DEFINE_LINK_MODE_NAME(1000, X, Full),
+	__DEFINE_LINK_MODE_NAME(10000, CR, Full),
+	__DEFINE_LINK_MODE_NAME(10000, SR, Full),
+	__DEFINE_LINK_MODE_NAME(10000, LR, Full),
+	__DEFINE_LINK_MODE_NAME(10000, LRM, Full),
+	__DEFINE_LINK_MODE_NAME(10000, ER, Full),
+	__DEFINE_LINK_MODE_NAME(2500, T, Full),
+	__DEFINE_LINK_MODE_NAME(5000, T, Full),
+	__DEFINE_SPECIAL_MODE_NAME(FEC_NONE, "None"),
+	__DEFINE_SPECIAL_MODE_NAME(FEC_RS, "RS"),
+	__DEFINE_SPECIAL_MODE_NAME(FEC_BASER, "BASER"),
+	__DEFINE_LINK_MODE_NAME(50000, KR, Full),
+	__DEFINE_LINK_MODE_NAME(50000, SR, Full),
+	__DEFINE_LINK_MODE_NAME(50000, CR, Full),
+	__DEFINE_LINK_MODE_NAME(50000, LR_ER_FR, Full),
+	__DEFINE_LINK_MODE_NAME(50000, DR, Full),
+	__DEFINE_LINK_MODE_NAME(100000, KR2, Full),
+	__DEFINE_LINK_MODE_NAME(100000, SR2, Full),
+	__DEFINE_LINK_MODE_NAME(100000, CR2, Full),
+	__DEFINE_LINK_MODE_NAME(100000, LR2_ER2_FR2, Full),
+	__DEFINE_LINK_MODE_NAME(100000, DR2, Full),
+	__DEFINE_LINK_MODE_NAME(200000, KR4, Full),
+	__DEFINE_LINK_MODE_NAME(200000, SR4, Full),
+	__DEFINE_LINK_MODE_NAME(200000, LR4_ER4_FR4, Full),
+	__DEFINE_LINK_MODE_NAME(200000, DR4, Full),
+	__DEFINE_LINK_MODE_NAME(200000, CR4, Full),
+	__DEFINE_LINK_MODE_NAME(100, T1, Full),
+	__DEFINE_LINK_MODE_NAME(1000, T1, Full),
+	__DEFINE_LINK_MODE_NAME(400000, KR8, Full),
+	__DEFINE_LINK_MODE_NAME(400000, SR8, Full),
+	__DEFINE_LINK_MODE_NAME(400000, LR8_ER8_FR8, Full),
+	__DEFINE_LINK_MODE_NAME(400000, DR8, Full),
+	__DEFINE_LINK_MODE_NAME(400000, CR8, Full),
+};
+static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 41b2efc1e4e1..3fe09c236145 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -5,6 +5,10 @@
 
 #include <linux/ethtool.h>
 
+/* compose link mode index from speed, type and duplex */
+#define ETHTOOL_LINK_MODE(speed, type, duplex) \
+	ETHTOOL_LINK_MODE_ ## speed ## base ## type ## _ ## duplex ## _BIT
+
 extern const char
 netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN];
 extern const char
@@ -13,5 +17,6 @@ extern const char
 tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN];
 extern const char
 phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
+extern const char link_mode_names[][ETH_GSTRING_LEN];
 
 #endif /* _ETHTOOL_COMMON_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b262db5a1d91..aed2c2cf1623 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -154,6 +154,9 @@ static int __ethtool_get_sset_count(struct net_device *dev, int sset)
 	    !ops->get_ethtool_phy_stats)
 		return phy_ethtool_get_sset_count(dev->phydev);
 
+	if (sset == ETH_SS_LINK_MODES)
+		return __ETHTOOL_LINK_MODE_MASK_NBITS;
+
 	if (ops->get_sset_count && ops->get_strings)
 		return ops->get_sset_count(dev, sset);
 	else
@@ -178,6 +181,9 @@ static void __ethtool_get_strings(struct net_device *dev,
 	else if (stringset == ETH_SS_PHY_STATS && dev->phydev &&
 		 !ops->get_ethtool_phy_stats)
 		phy_ethtool_get_strings(dev->phydev, data);
+	else if (stringset == ETH_SS_LINK_MODES)
+		memcpy(data, link_mode_names,
+		       __ETHTOOL_LINK_MODE_MASK_NBITS * ETH_GSTRING_LEN);
 	else
 		/* ops->get_strings is valid because checked earlier */
 		ops->get_strings(dev, stringset, data);
-- 
2.24.0

