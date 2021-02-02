Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00ED30C932
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238310AbhBBSMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:12:49 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2678 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238071AbhBBSHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:07:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601994aa0000>; Tue, 02 Feb 2021 10:06:34 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:06:31 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v4 2/8] ethtool: Extend link modes settings uAPI with lanes
Date:   Tue, 2 Feb 2021 20:06:06 +0200
Message-ID: <20210202180612.325099-3-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202180612.325099-1-danieller@nvidia.com>
References: <20210202180612.325099-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612289194; bh=lgiM6fHFgmhFiqnec9eG45olXtVno939tJXOMyt5CCI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=NOp/CpUEVzVWDo5c6xjrpDIEx2Sz7qB98XusKqyVqWQQe8nEJLhiozLIViprZcCXo
         rvg1EaxZLSxK5IYHSAfab/khZ4qp2DaCBjHHaJgGecchXoCOBkDBWXqzqtk8sMOeB6
         tHFnSh1N8oRmRhoMSkFAOa72Z9Cu94QD9M8oDs/s5oRddGfkd35oQER22xnd1onBO/
         5Czq1rKuCTFUuONUcXTlYq0Lr5dzYfCAsECJXdj6AHciBgxVc1NMtEEj2m0vUNmrov
         iPlgQaWXBd9jmdehLHuCuiC1PlO2cGpeBmiHjSOaybvWbpBJXXXPRPAUGtjnwb6vK1
         9y/1hKbfFFO1A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when auto negotiation is on, the user can advertise all the
linkmodes which correspond to a specific speed, but does not have a
similar selector for the number of lanes. This is significant when a
specific speed can be achieved using different number of lanes.  For
example, 2x50 or 4x25.

Add 'ETHTOOL_A_LINKMODES_LANES' attribute and expand 'struct
ethtool_link_settings' with lanes field in order to implement a new
lanes-selector that will enable the user to advertise a specific number
of lanes as well.

When auto negotiation is off, lanes parameter can be forced only if the
driver supports it. Add a capability bit in 'struct ethtool_ops' that
allows ethtool know if the driver can handle the lanes parameter when
auto negotiation is off, so if it does not, an error message will be
returned when trying to set lanes.

Example:

$ ethtool -s swp1 lanes 4
$ ethtool swp1
  Settings for swp1:
	Supported ports: [ FIBRE ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                40000baseCR4/Full
				40000baseSR4/Full
				40000baseLR4/Full
                                25000baseCR/Full
                                25000baseSR/Full
				50000baseCR2/Full
                                100000baseSR4/Full
				100000baseCR4/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  40000baseCR4/Full
				40000baseSR4/Full
				40000baseLR4/Full
                                100000baseSR4/Full
				100000baseCR4/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: Unknown!
        Duplex: Unknown! (255)
        Auto-negotiation: on
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Link detected: no

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v4:
    	* Change the way specifying lanes param in link_mode_params.
    	* Remove ETHTOOL_LANES_UNKNOWN uAPI constant and don't report
    	  nlattr if the parameter is unknown.
    	* Make lanes u8 in link_mode_info.
    	* Add nlattr for lanes_cfg and move one lanes validation to the new
    	  function from the last patch.
   =20
    v3:
    	* Change ethtool_ops.capabilities to be a bitfield and rename it.
    	* Add an according kdoc.
    	* Set min and max for the lanes policy.
    	* Change the lanes validation to be the power of two, now that the
    	  min and max are set.
   =20
    v2:
    	* Remove ETHTOOL_LANES defines and simply use a number instead.

 Documentation/networking/ethtool-netlink.rst | 11 ++-
 include/linux/ethtool.h                      |  4 +
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/linkmodes.c                      | 96 +++++++++++++++++---
 net/ethtool/netlink.h                        |  2 +-
 5 files changed, 93 insertions(+), 21 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/n=
etworking/ethtool-netlink.rst
index 30b98245979f..05073482db05 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -431,16 +431,17 @@ Request contents:
   ``ETHTOOL_A_LINKMODES_SPEED``               u32     link speed (Mb/s)
   ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mo=
de
+  ``ETHTOOL_A_LINKMODES_LANES``               u32     lanes
   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=20
 ``ETHTOOL_A_LINKMODES_OURS`` bit set allows setting advertised link modes.=
 If
 autonegotiation is on (either set now or kept from before), advertised mod=
es
 are not changed (no ``ETHTOOL_A_LINKMODES_OURS`` attribute) and at least o=
ne
-of speed and duplex is specified, kernel adjusts advertised modes to all
-supported modes matching speed, duplex or both (whatever is specified). Th=
is
-autoselection is done on ethtool side with ioctl interface, netlink interf=
ace
-is supposed to allow requesting changes without knowing what exactly kerne=
l
-supports.
+of speed, duplex and lanes is specified, kernel adjusts advertised modes t=
o all
+supported modes matching speed, duplex, lanes or all (whatever is specifie=
d).
+This autoselection is done on ethtool side with ioctl interface, netlink
+interface is supposed to allow requesting changes without knowing what exa=
ctly
+kernel supports.
=20
=20
 LINKSTATE_GET
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e3da25b51ae4..1ab13c5dfb2f 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -128,6 +128,7 @@ struct ethtool_link_ksettings {
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	} link_modes;
+	u32	lanes;
 };
=20
 /**
@@ -265,6 +266,8 @@ struct ethtool_pause_stats {
=20
 /**
  * struct ethtool_ops - optional netdev operations
+ * @cap_link_lanes_supported: indicates if the driver supports lanes
+ *	parameter.
  * @supported_coalesce_params: supported types of interrupt coalescing.
  * @get_drvinfo: Report driver/device information.  Should only set the
  *	@driver, @version, @fw_version and @bus_info fields.  If not
@@ -420,6 +423,7 @@ struct ethtool_pause_stats {
  * of the generic netdev features interface.
  */
 struct ethtool_ops {
+	u32     cap_link_lanes_supported:1;
 	u32	supported_coalesce_params;
 	void	(*get_drvinfo)(struct net_device *, struct ethtool_drvinfo *);
 	int	(*get_regs_len)(struct net_device *);
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/etht=
ool_netlink.h
index e2bf36e6964b..a286635ac9b8 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -227,6 +227,7 @@ enum {
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
+	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
=20
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index bb8a3351fb72..db3e31fc6709 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -152,12 +152,47 @@ const struct ethnl_request_ops ethnl_linkmodes_reques=
t_ops =3D {
=20
 struct link_mode_info {
 	int				speed;
+	u8				lanes;
 	u8				duplex;
 };
=20
-#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex) \
-	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] =3D { \
-		.speed	=3D SPEED_ ## _speed, \
+#define __LINK_MODE_LANES_CR		1
+#define __LINK_MODE_LANES_CR2		2
+#define __LINK_MODE_LANES_CR4		4
+#define __LINK_MODE_LANES_CR8		8
+#define __LINK_MODE_LANES_DR		1
+#define __LINK_MODE_LANES_DR2		2
+#define __LINK_MODE_LANES_DR4		4
+#define __LINK_MODE_LANES_DR8		8
+#define __LINK_MODE_LANES_KR		1
+#define __LINK_MODE_LANES_KR2		2
+#define __LINK_MODE_LANES_KR4		4
+#define __LINK_MODE_LANES_KR8		8
+#define __LINK_MODE_LANES_SR		1
+#define __LINK_MODE_LANES_SR2		2
+#define __LINK_MODE_LANES_SR4		4
+#define __LINK_MODE_LANES_SR8		8
+#define __LINK_MODE_LANES_ER		1
+#define __LINK_MODE_LANES_KX		1
+#define __LINK_MODE_LANES_KX4		4
+#define __LINK_MODE_LANES_LR		1
+#define __LINK_MODE_LANES_LR4		4
+#define __LINK_MODE_LANES_LR4_ER4	4
+#define __LINK_MODE_LANES_LR_ER_FR	1
+#define __LINK_MODE_LANES_LR2_ER2_FR2	2
+#define __LINK_MODE_LANES_LR4_ER4_FR4	4
+#define __LINK_MODE_LANES_LR8_ER8_FR8	8
+#define __LINK_MODE_LANES_LRM		1
+#define __LINK_MODE_LANES_MLD2		2
+#define __LINK_MODE_LANES_T		1
+#define __LINK_MODE_LANES_T1		1
+#define __LINK_MODE_LANES_X		1
+#define __LINK_MODE_LANES_FX		1
+
+#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex)	\
+	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] =3D {		\
+		.speed  =3D SPEED_ ## _speed, \
+		.lanes  =3D __LINK_MODE_LANES_ ## _type, \
 		.duplex	=3D __DUPLEX_ ## _duplex \
 	}
 #define __DUPLEX_Half DUPLEX_HALF
@@ -165,6 +200,7 @@ struct link_mode_info {
 #define __DEFINE_SPECIAL_MODE_PARAMS(_mode) \
 	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] =3D { \
 		.speed	=3D SPEED_UNKNOWN, \
+		.lanes	=3D 0, \
 		.duplex	=3D DUPLEX_UNKNOWN, \
 	}
=20
@@ -274,16 +310,17 @@ const struct nla_policy ethnl_linkmodes_set_policy[] =
=3D {
 	[ETHTOOL_A_LINKMODES_SPEED]		=3D { .type =3D NLA_U32 },
 	[ETHTOOL_A_LINKMODES_DUPLEX]		=3D { .type =3D NLA_U8 },
 	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	=3D { .type =3D NLA_U8 },
+	[ETHTOOL_A_LINKMODES_LANES]		=3D NLA_POLICY_RANGE(NLA_U32, 1, 8),
 };
=20
-/* Set advertised link modes to all supported modes matching requested spe=
ed
- * and duplex values. Called when autonegotiation is on, speed or duplex i=
s
- * requested but no link mode change. This is done in userspace with ioctl=
()
- * interface, move it into kernel for netlink.
+/* Set advertised link modes to all supported modes matching requested spe=
ed,
+ * lanes and duplex values. Called when autonegotiation is on, speed, lane=
s or
+ * duplex is requested but no link mode change. This is done in userspace =
with
+ * ioctl() interface, move it into kernel for netlink.
  * Returns true if advertised modes bitmap was modified.
  */
 static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
-				 bool req_speed, bool req_duplex)
+				 bool req_speed, bool req_lanes, bool req_duplex)
 {
 	unsigned long *advertising =3D ksettings->link_modes.advertising;
 	unsigned long *supported =3D ksettings->link_modes.supported;
@@ -302,6 +339,7 @@ static bool ethnl_auto_linkmodes(struct ethtool_link_ks=
ettings *ksettings,
 			continue;
 		if (test_bit(i, supported) &&
 		    (!req_speed || info->speed =3D=3D ksettings->base.speed) &&
+		    (!req_lanes || info->lanes =3D=3D ksettings->lanes) &&
 		    (!req_duplex || info->duplex =3D=3D ksettings->base.duplex))
 			set_bit(i, advertising);
 		else
@@ -327,7 +365,7 @@ static bool ethnl_validate_master_slave_cfg(u8 cfg)
=20
 static int ethnl_check_linkmodes(struct genl_info *info, struct nlattr **t=
b)
 {
-	const struct nlattr *master_slave_cfg;
+	const struct nlattr *master_slave_cfg, *lanes_cfg;
=20
 	master_slave_cfg =3D tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
 	if (master_slave_cfg &&
@@ -337,16 +375,23 @@ static int ethnl_check_linkmodes(struct genl_info *in=
fo, struct nlattr **tb)
 		return -EOPNOTSUPP;
 	}
=20
+	lanes_cfg =3D tb[ETHTOOL_A_LINKMODES_LANES];
+	if (lanes_cfg && !is_power_of_2(nla_get_u32(lanes_cfg))) {
+		NL_SET_ERR_MSG_ATTR(info->extack, lanes_cfg,
+				    "lanes value is invalid");
+		return -EINVAL;
+	}
+
 	return 0;
 }
=20
 static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **=
tb,
 				  struct ethtool_link_ksettings *ksettings,
-				  bool *mod)
+				  bool *mod, const struct net_device *dev)
 {
 	struct ethtool_link_settings *lsettings =3D &ksettings->base;
-	bool req_speed, req_duplex;
-	const struct nlattr *master_slave_cfg;
+	bool req_speed, req_lanes, req_duplex;
+	const struct nlattr *master_slave_cfg, *lanes_cfg;
 	int ret;
=20
 	master_slave_cfg =3D tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
@@ -360,10 +405,30 @@ static int ethnl_update_linkmodes(struct genl_info *i=
nfo, struct nlattr **tb,
=20
 	*mod =3D false;
 	req_speed =3D tb[ETHTOOL_A_LINKMODES_SPEED];
+	req_lanes =3D tb[ETHTOOL_A_LINKMODES_LANES];
 	req_duplex =3D tb[ETHTOOL_A_LINKMODES_DUPLEX];
=20
 	ethnl_update_u8(&lsettings->autoneg, tb[ETHTOOL_A_LINKMODES_AUTONEG],
 			mod);
+
+	lanes_cfg =3D tb[ETHTOOL_A_LINKMODES_LANES];
+	if (lanes_cfg) {
+		/* If autoneg is off and lanes parameter is not supported by the
+		 * driver, return an error.
+		 */
+		if (!lsettings->autoneg &&
+		    !dev->ethtool_ops->cap_link_lanes_supported) {
+			NL_SET_ERR_MSG_ATTR(info->extack, lanes_cfg,
+					    "lanes configuration not supported by device");
+			return -EOPNOTSUPP;
+		}
+	} else if (!lsettings->autoneg) {
+		/* If autoneg is off and lanes parameter is not passed from user,
+		 * set the lanes parameter to 0.
+		 */
+		ksettings->lanes =3D 0;
+	}
+
 	ret =3D ethnl_update_bitset(ksettings->link_modes.advertising,
 				  __ETHTOOL_LINK_MODE_MASK_NBITS,
 				  tb[ETHTOOL_A_LINKMODES_OURS], link_mode_names,
@@ -372,13 +437,14 @@ static int ethnl_update_linkmodes(struct genl_info *i=
nfo, struct nlattr **tb,
 		return ret;
 	ethnl_update_u32(&lsettings->speed, tb[ETHTOOL_A_LINKMODES_SPEED],
 			 mod);
+	ethnl_update_u32(&ksettings->lanes, lanes_cfg, mod);
 	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
 			mod);
 	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
=20
 	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
-	    (req_speed || req_duplex) &&
-	    ethnl_auto_linkmodes(ksettings, req_speed, req_duplex))
+	    (req_speed || req_lanes || req_duplex) &&
+	    ethnl_auto_linkmodes(ksettings, req_speed, req_lanes, req_duplex))
 		*mod =3D true;
=20
 	return 0;
@@ -420,7 +486,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct gen=
l_info *info)
 		goto out_ops;
 	}
=20
-	ret =3D ethnl_update_linkmodes(info, tb, &ksettings, &mod);
+	ret =3D ethnl_update_linkmodes(info, tb, &ksettings, &mod, dev);
 	if (ret < 0)
 		goto out_ops;
=20
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index d8efec516d86..6eabd58d81bf 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -351,7 +351,7 @@ extern const struct nla_policy ethnl_strset_get_policy[=
ETHTOOL_A_STRSET_COUNTS_O
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINF=
O_HEADER + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINF=
O_TP_MDIX_CTRL + 1];
 extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMO=
DES_HEADER + 1];
-extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMO=
DES_MASTER_SLAVE_CFG + 1];
+extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMO=
DES_LANES + 1];
 extern const struct nla_policy ethnl_linkstate_get_policy[ETHTOOL_A_LINKST=
ATE_HEADER + 1];
 extern const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_HEAD=
ER + 1];
 extern const struct nla_policy ethnl_debug_set_policy[ETHTOOL_A_DEBUG_MSGM=
ASK + 1];
--=20
2.26.2

