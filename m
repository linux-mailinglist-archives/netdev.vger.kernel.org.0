Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3D55CED5
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfGBLug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:50:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:39092 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbfGBLug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:50:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AA1A8B118;
        Tue,  2 Jul 2019 11:50:34 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 583CCE0159; Tue,  2 Jul 2019 13:50:34 +0200 (CEST)
Message-Id: <1e1bf53de26780ecc0e448aa07dc429ef590798a.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 11/15] ethtool: provide link mode names as a
 string set
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:50:34 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike e.g. netdev features, the ethtool ioctl interface requires link mode
table to be in sync between kernel and userspace for userspace to be able
to display and set all link modes supported by kernel. The way arbitrary
length bitsets are implemented in netlink interface, this is no longer
needed.

To allow userspace to access all link modes running kernel supports, add
table of ethernet link mode names and make it available as a string set to
userspace GET_STRSET requests. Add build time check to make sure names
are defined for all modes declared in enum ethtool_link_mode_bit_indices.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/linux/ethtool.h      |  4 ++
 include/uapi/linux/ethtool.h |  2 +
 net/ethtool/netlink.c        | 83 ++++++++++++++++++++++++++++++++++++
 net/ethtool/netlink.h        |  2 +
 net/ethtool/strset.c         |  6 +++
 5 files changed, 97 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 95991e4300bf..5caef65d93d6 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -102,6 +102,10 @@ static inline u32 ethtool_rxfh_indir_default(u32 index, u32 n_rx_rings)
 #define __ETHTOOL_DECLARE_LINK_MODE_MASK(name)		\
 	DECLARE_BITMAP(name, __ETHTOOL_LINK_MODE_MASK_NBITS)
 
+/* compose link mode index from speed, type and duplex */
+#define ETHTOOL_LINK_MODE(speed, type, duplex) \
+	ETHTOOL_LINK_MODE_ ## speed ## base ## type ## _ ## duplex ## _BIT
+
 /* drivers must ignore base.cmd and base.link_mode_masks_nwords
  * fields, but they are allowed to overwrite them (will be ignored).
  */
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 4e4e28e77c7a..6ad298224352 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -571,6 +571,7 @@ struct ethtool_pauseparam {
  * @ETH_SS_RSS_HASH_FUNCS: RSS hush function names
  * @ETH_SS_PHY_STATS: Statistic names, for use with %ETHTOOL_GPHYSTATS
  * @ETH_SS_PHY_TUNABLES: PHY tunable names
+ * @ETH_SS_LINK_MODES: link mode names
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -582,6 +583,7 @@ enum ethtool_stringset {
 	ETH_SS_TUNABLES,
 	ETH_SS_PHY_STATS,
 	ETH_SS_PHY_TUNABLES,
+	ETH_SS_LINK_MODES,
 
 	ETH_SS_COUNT
 };
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 41d7fedd3dd6..cba1f2259248 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -8,6 +8,86 @@ static struct genl_family ethtool_genl_family;
 
 static bool ethnl_ok __read_mostly;
 
+#define __LINK_MODE_NAME(speed, type, duplex) \
+	#speed "base" #type "/" #duplex
+#define __DEFINE_LINK_MODE_NAME(speed, type, duplex) \
+	[ETHTOOL_LINK_MODE(speed, type, duplex)] = \
+	__LINK_MODE_NAME(speed, type, duplex)
+#define __DEFINE_SPECIAL_MODE_NAME(_mode, _name) \
+	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] = _name
+
+const char *const link_mode_names[] = {
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
+	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] = "10000baseR_FEC",
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
+};
+
 static const struct nla_policy dflt_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
 	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
@@ -575,6 +655,9 @@ static int __init ethnl_init(void)
 {
 	int ret;
 
+	BUILD_BUG_ON(ARRAY_SIZE(link_mode_names) !=
+		     __ETHTOOL_LINK_MODE_MASK_NBITS);
+
 	ret = genl_register_family(&ethtool_genl_family);
 	if (WARN(ret < 0, "ethtool: genetlink family registration failed"))
 		return ret;
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 2352fd9c17c3..d85b1edc1b91 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -10,6 +10,8 @@
 
 struct ethnl_req_info;
 
+extern const char *const link_mode_names[];
+
 int ethnl_parse_header(struct ethnl_req_info *req_info,
 		       const struct nlattr *nest, struct net *net,
 		       struct netlink_ext_ack *extack,
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index fd7229379158..514ef04709d3 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -67,6 +67,12 @@ static const struct strset_info info_template[] = {
 		.count		= ARRAY_SIZE(phy_tunable_strings),
 		.data		= { .legacy = phy_tunable_strings },
 	},
+	[ETH_SS_LINK_MODES] = {
+		.type		= ETH_SS_TYPE_SIMPLE,
+		.per_dev	= false,
+		.count		= __ETHTOOL_LINK_MODE_MASK_NBITS,
+		.data		= { .simple = link_mode_names },
+	},
 };
 
 struct strset_data {
-- 
2.22.0

