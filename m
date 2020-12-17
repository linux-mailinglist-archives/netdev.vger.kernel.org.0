Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88342DCDF3
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 09:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgLQI6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 03:58:32 -0500
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:50264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726533AbgLQI6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 03:58:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPwUMj2di53fkbtamH+QLIpkh69iNxNZwjLO51OGcIHXT96e+A/Fr8poc7wOq5Hf8JQh633dPblsMxrwfHpe1wj7KrkG/4fQjUVG2yuCJbUY3/Gnvkv67CJzmqGtq7rnN5g0GBVa2tg1O9GF5OYNIjXpka2Omg2p3vh0bqkuWJsdR++AtD2hNeCYABGWWWY9xlbqjbTYm7vaT4iBYfOYMZqbxNospXpbAyGyNuld97CSp9oaV67BIwjw9DS0np7i+V+F+nhPGM1Mj2AtMYjOLjPk3z1m6rAclVMD/CAtoyxSu584TTn2x+qQn0nCdu+RYotux3VLJ8LZstF3kzkKCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBEAkpHyrb+S/PSdtb5++eWcdwIp+tWlgpPRy3neM5w=;
 b=d9dy1UD9+lRD7X30MC6nlJtBCNae+uGaL5Do/UraGeebuk305qX57xzRdvgKjWWjIrEMQi0hhwSBG3BfI0U4VtMSFxXlldpizIwgHck0KF7f7jQhjQlxJ3lGsfCXuzOT9KWpBHAZBcB3cixK14HCXa0PPTi9zgB9dz6w8zfJM+gHb3WfDdpkNEJqJ8Sc5RWueDJ27zFyd7WxUQ7QDj0XNWv1jeAoq4flcQwBDJ9W909OEH1adafJy1gvQVxRnurT/KvIpzzpD1tohMNHUSM2OtPSgZRmCezqRxBEvgLjsYca+DJVEq/fNr1BQvcgEiOJ3s4ofc9KE0dowgzkYwvyWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBEAkpHyrb+S/PSdtb5++eWcdwIp+tWlgpPRy3neM5w=;
 b=rwveGyhJxPWy7AfWtbZqfro+iPUtN1EB8FrwmjAHtKzzMsBmhH9XDqlWYFBXzJeLiO4SSXEMdt3IHTMy1wgkiQs+b+XjE7ETE8VytpYsboj676zBl/V2TviIAXjYyvPYof69yOEGyb9eZO1TbSrE1fWaHL8b+bV3GG1lLxbUwW4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6674.eurprd05.prod.outlook.com (2603:10a6:20b:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Thu, 17 Dec
 2020 08:57:31 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be%7]) with mapi id 15.20.3654.021; Thu, 17 Dec 2020
 08:57:31 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v2 1/7] ethtool: Extend link modes settings uAPI with lanes
Date:   Thu, 17 Dec 2020 10:57:11 +0200
Message-Id: <20201217085717.4081793-2-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217085717.4081793-1-danieller@mellanox.com>
References: <20201217085717.4081793-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0601CA0024.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::34) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by VI1PR0601CA0024.eurprd06.prod.outlook.com (2603:10a6:800:1e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 08:57:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 130659fa-f5e4-483a-9ac8-08d8a269ca0b
X-MS-TrafficTypeDiagnostic: AM0PR05MB6674:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB66749A186A4ED9E8F0E36D1FD5C40@AM0PR05MB6674.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h5kW0qv5Z/s7/34PlCHKw9HcatLieO2J7xaZgYlZvONky81c18UrFv228UKbwkVVlmRqqRSDaItcLdGhZyVLUYkBiXgtszs5SCFSg6yB3LpcXkGQ3MjfIcxScooQijWlqXE8Wq5TconI+TOhQofMXXi414lf2GXGg9gpc08MULksLCoOsE1F/svZGmD2A2ApWSlTLreDMCd3bq+a9FgcA3LxiupJRqXcEi2XQ7w7QeOtw7rkVmeesqgK8Y6R+ZtAd1gRqlWX83ajtIhW84NnTkbF4Yw1hzNtC2MAhj/K9/1fAH5NvV/pNT/Eh2HrSeRsSLvmQqikxTWbvCICQDWW0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(6916009)(316002)(30864003)(86362001)(66476007)(2906002)(8936002)(5660300002)(2616005)(6512007)(6486002)(1076003)(4326008)(7416002)(6666004)(6506007)(36756003)(66556008)(26005)(8676002)(956004)(83380400001)(186003)(16526019)(66946007)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Lc0HVNzcpmKFC/xR1w4BKXz92qns3SQDd2F2k+y+ipkhVdHpH1ozTIiuwOc7?=
 =?us-ascii?Q?t7g9e0zWyqo4V5+TkTZtNLwkOZULz6XS2+YuAABEPjh3Y8PRnFd5sEPwldZP?=
 =?us-ascii?Q?5Yy9mTraxk+0k/0bJ75Js8GTc03jIbSYjHW9xnR9ixEKb1CSA5AqsBAenOWE?=
 =?us-ascii?Q?uh9BjCZrbz/0Dw/jqLIWRqkgHqZfCG7fE8Y4rrrP9eQ6HKXV5B5qCA222U4H?=
 =?us-ascii?Q?swewJArDkiONmf5zJmvuShTsU6bfjoIBiVfrvOAowX2risPvtMv5l5K0R46h?=
 =?us-ascii?Q?LKpdyGXAUFcdeDBnhbRrUmnXBuEMMKFmIwUWRdKXwHLm+4xnqVkiNNNgZpBt?=
 =?us-ascii?Q?BmKscZ48IGI+4lgM2sgcz7xKPJSAqMjS/YiMPlHuotw1iKKmKwu81g33hVgY?=
 =?us-ascii?Q?NesThtAS3OBmIsmixbbtfQd7EIROSMO0DK9PACOoYxf5D+Z1UyMhth5Fjjhj?=
 =?us-ascii?Q?l0n+h0YqHHjluErhhgZCKBrVjn19/5K++LjRm7iYhl3ky+SKovG07GgJxv3x?=
 =?us-ascii?Q?xaBsb6mZ5g7k1SlmjX4y2aE9mbgPSdONe4ERyFZHUeMPT/jkn08XOoKhQE6x?=
 =?us-ascii?Q?oI16bIhFLCkrGqQH9ifT7KiUIWLmzJwcPDPbKYJwf+PwtvJAKi2C8OQXUhNy?=
 =?us-ascii?Q?N9uotX0YB0otqvQpzcf6fnuYdSkEUxdiwacA368ZcxC1WimcJjqEZYwIcHXi?=
 =?us-ascii?Q?IZ4/MhTdEnvq7JK4fc3aYLGd52m3RXkgZ/W+qGd+5OFlC8zQBKH0+zA8hDeg?=
 =?us-ascii?Q?N+m+K+H2+2iP1uwitmUQeYkaFFWCn1TiCDOuJ6cuH8Krwv4DnkBP1P76LZzW?=
 =?us-ascii?Q?lC2PgIHbZMBFOfh+2eKTbNPmmhyN5kVqPLq1rd0MH2q158ReInzgIPPeicPW?=
 =?us-ascii?Q?2mzkwQB6QhvXhxShKFg//ehZFE6olnHxBjx7ntqtLRU2Y/7txXGwuugP8fYr?=
 =?us-ascii?Q?MLSntruYuCv8CYi0nJH2g0fBhBb4Md5B+1SsIxSpoywIFVlhcmxwOub/4vFq?=
 =?us-ascii?Q?dUV8?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 08:57:31.7409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 130659fa-f5e4-483a-9ac8-08d8a269ca0b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jdp9mZUbypAvYD1Y16Mr/8P6x9Hqjb5ZQoOPrZ+fBTSv2wa1zx5AP7tCfgdAC93YajydBHVTFb9JomboVi+OLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

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
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v2:
    	* Remove ETHTOOL_LANES defines and simply use a number instead.

 Documentation/networking/ethtool-netlink.rst |  11 +-
 include/linux/ethtool.h                      |   4 +
 include/uapi/linux/ethtool.h                 |   2 +
 include/uapi/linux/ethtool_netlink.h         |   1 +
 net/ethtool/linkmodes.c                      | 227 +++++++++++--------
 net/ethtool/netlink.h                        |   2 +-
 6 files changed, 152 insertions(+), 95 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 30b98245979f..05073482db05 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -431,16 +431,17 @@ Request contents:
   ``ETHTOOL_A_LINKMODES_SPEED``               u32     link speed (Mb/s)
   ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
+  ``ETHTOOL_A_LINKMODES_LANES``               u32     lanes
   ==========================================  ======  ==========================
 
 ``ETHTOOL_A_LINKMODES_OURS`` bit set allows setting advertised link modes. If
 autonegotiation is on (either set now or kept from before), advertised modes
 are not changed (no ``ETHTOOL_A_LINKMODES_OURS`` attribute) and at least one
-of speed and duplex is specified, kernel adjusts advertised modes to all
-supported modes matching speed, duplex or both (whatever is specified). This
-autoselection is done on ethtool side with ioctl interface, netlink interface
-is supposed to allow requesting changes without knowing what exactly kernel
-supports.
+of speed, duplex and lanes is specified, kernel adjusts advertised modes to all
+supported modes matching speed, duplex, lanes or all (whatever is specified).
+This autoselection is done on ethtool side with ioctl interface, netlink
+interface is supposed to allow requesting changes without knowing what exactly
+kernel supports.
 
 
 LINKSTATE_GET
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e3da25b51ae4..afae2beacbc3 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -128,6 +128,7 @@ struct ethtool_link_ksettings {
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	} link_modes;
+	u32	lanes;
 };
 
 /**
@@ -242,6 +243,8 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_PKT_RATE_LOW | ETHTOOL_COALESCE_PKT_RATE_HIGH | \
 	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
 
+#define ETHTOOL_CAP_LINK_LANES_SUPPORTED BIT(0)
+
 #define ETHTOOL_STAT_NOT_SET	(~0ULL)
 
 /**
@@ -420,6 +423,7 @@ struct ethtool_pause_stats {
  * of the generic netdev features interface.
  */
 struct ethtool_ops {
+	u32     capabilities;
 	u32	supported_coalesce_params;
 	void	(*get_drvinfo)(struct net_device *, struct ethtool_drvinfo *);
 	int	(*get_regs_len)(struct net_device *);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index cde753bb2093..80edae2c24f7 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1738,6 +1738,8 @@ static inline int ethtool_validate_speed(__u32 speed)
 	return speed <= INT_MAX || speed == (__u32)SPEED_UNKNOWN;
 }
 
+#define ETHTOOL_LANES_UNKNOWN		0
+
 /* Duplex, half or full. */
 #define DUPLEX_HALF		0x00
 #define DUPLEX_FULL		0x01
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index e2bf36e6964b..a286635ac9b8 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -227,6 +227,7 @@ enum {
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
+	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index c5bcb9abc8b9..f41f9327436c 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -152,12 +152,14 @@ const struct ethnl_request_ops ethnl_linkmodes_request_ops = {
 
 struct link_mode_info {
 	int				speed;
+	u32				lanes;
 	u8				duplex;
 };
 
-#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex) \
+#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _lanes, _duplex) \
 	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] = { \
 		.speed	= SPEED_ ## _speed, \
+		.lanes	= _lanes, \
 		.duplex	= __DUPLEX_ ## _duplex \
 	}
 #define __DUPLEX_Half DUPLEX_HALF
@@ -165,105 +167,106 @@ struct link_mode_info {
 #define __DEFINE_SPECIAL_MODE_PARAMS(_mode) \
 	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] = { \
 		.speed	= SPEED_UNKNOWN, \
+		.lanes	= ETHTOOL_LANES_UNKNOWN, \
 		.duplex	= DUPLEX_UNKNOWN, \
 	}
 
 static const struct link_mode_info link_mode_params[] = {
-	__DEFINE_LINK_MODE_PARAMS(10, T, Half),
-	__DEFINE_LINK_MODE_PARAMS(10, T, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, T, Half),
-	__DEFINE_LINK_MODE_PARAMS(100, T, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, T, Half),
-	__DEFINE_LINK_MODE_PARAMS(1000, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(Autoneg),
 	__DEFINE_SPECIAL_MODE_PARAMS(TP),
 	__DEFINE_SPECIAL_MODE_PARAMS(AUI),
 	__DEFINE_SPECIAL_MODE_PARAMS(MII),
 	__DEFINE_SPECIAL_MODE_PARAMS(FIBRE),
 	__DEFINE_SPECIAL_MODE_PARAMS(BNC),
-	__DEFINE_LINK_MODE_PARAMS(10000, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, T, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(Pause),
 	__DEFINE_SPECIAL_MODE_PARAMS(Asym_Pause),
-	__DEFINE_LINK_MODE_PARAMS(2500, X, Full),
+	__DEFINE_LINK_MODE_PARAMS(2500, X, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(Backplane),
-	__DEFINE_LINK_MODE_PARAMS(1000, KX, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, KX4, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, KR, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, KX, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KX4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KR, 1, Full),
 	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] = {
 		.speed	= SPEED_10000,
 		.duplex = DUPLEX_FULL,
 	},
-	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, Full),
-	__DEFINE_LINK_MODE_PARAMS(20000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, LR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, LR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, KR, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, CR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, SR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, X, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, LR, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, LRM, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, ER, Full),
-	__DEFINE_LINK_MODE_PARAMS(2500, T, Full),
-	__DEFINE_LINK_MODE_PARAMS(5000, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(20000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, LR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, LR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, X, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, LR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, LRM, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, ER, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(2500, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(5000, T, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_NONE),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_RS),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_BASER),
-	__DEFINE_LINK_MODE_PARAMS(50000, KR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, DR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, DR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, DR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, T1, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, T1, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, KR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, SR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, DR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, DR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, DR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, T1, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, T1, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, KR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, SR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, DR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, CR8, 8, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, DR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, SR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, DR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, CR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, DR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, FX, Half),
-	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, DR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, DR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, DR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Full),
 };
 
 const struct nla_policy ethnl_linkmodes_set_policy[] = {
@@ -274,16 +277,17 @@ const struct nla_policy ethnl_linkmodes_set_policy[] = {
 	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
 	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKMODES_LANES]		= { .type = NLA_U32 },
 };
 
-/* Set advertised link modes to all supported modes matching requested speed
- * and duplex values. Called when autonegotiation is on, speed or duplex is
- * requested but no link mode change. This is done in userspace with ioctl()
- * interface, move it into kernel for netlink.
+/* Set advertised link modes to all supported modes matching requested speed,
+ * lanes and duplex values. Called when autonegotiation is on, speed, lanes or
+ * duplex is requested but no link mode change. This is done in userspace with
+ * ioctl() interface, move it into kernel for netlink.
  * Returns true if advertised modes bitmap was modified.
  */
 static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
-				 bool req_speed, bool req_duplex)
+				 bool req_speed, bool req_lanes, bool req_duplex)
 {
 	unsigned long *advertising = ksettings->link_modes.advertising;
 	unsigned long *supported = ksettings->link_modes.supported;
@@ -302,6 +306,7 @@ static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
 			continue;
 		if (test_bit(i, supported) &&
 		    (!req_speed || info->speed == ksettings->base.speed) &&
+		    (!req_lanes || info->lanes == ksettings->lanes) &&
 		    (!req_duplex || info->duplex == ksettings->base.duplex))
 			set_bit(i, advertising);
 		else
@@ -325,12 +330,25 @@ static bool ethnl_validate_master_slave_cfg(u8 cfg)
 	return false;
 }
 
+static bool ethnl_validate_lanes_cfg(u32 cfg)
+{
+	switch (cfg) {
+	case 1:
+	case 2:
+	case 4:
+	case 8:
+		return true;
+	}
+
+	return false;
+}
+
 static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 				  struct ethtool_link_ksettings *ksettings,
-				  bool *mod)
+				  bool *mod, const struct net_device *dev)
 {
 	struct ethtool_link_settings *lsettings = &ksettings->base;
-	bool req_speed, req_duplex;
+	bool req_speed, req_lanes, req_duplex;
 	const struct nlattr *master_slave_cfg;
 	int ret;
 
@@ -353,10 +371,39 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 
 	*mod = false;
 	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
+	req_lanes = tb[ETHTOOL_A_LINKMODES_LANES];
 	req_duplex = tb[ETHTOOL_A_LINKMODES_DUPLEX];
 
 	ethnl_update_u8(&lsettings->autoneg, tb[ETHTOOL_A_LINKMODES_AUTONEG],
 			mod);
+
+	if (req_lanes) {
+		u32 lanes_cfg = nla_get_u32(tb[ETHTOOL_A_LINKMODES_LANES]);
+
+		if (!ethnl_validate_lanes_cfg(lanes_cfg)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[ETHTOOL_A_LINKMODES_LANES],
+					    "lanes value is invalid");
+			return -EINVAL;
+		}
+
+		/* If autoneg is off and lanes parameter is not supported by the
+		 * driver, return an error.
+		 */
+		if (!lsettings->autoneg &&
+		    !(dev->ethtool_ops->capabilities & ETHTOOL_CAP_LINK_LANES_SUPPORTED)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[ETHTOOL_A_LINKMODES_LANES],
+					    "lanes configuration not supported by device");
+			return -EOPNOTSUPP;
+		}
+	} else if (!lsettings->autoneg) {
+		/* If autoneg is off and lanes parameter is not passed from user,
+		 * set the lanes parameter to UNKNOWN.
+		 */
+		ksettings->lanes = ETHTOOL_LANES_UNKNOWN;
+	}
+
 	ret = ethnl_update_bitset(ksettings->link_modes.advertising,
 				  __ETHTOOL_LINK_MODE_MASK_NBITS,
 				  tb[ETHTOOL_A_LINKMODES_OURS], link_mode_names,
@@ -365,13 +412,15 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 		return ret;
 	ethnl_update_u32(&lsettings->speed, tb[ETHTOOL_A_LINKMODES_SPEED],
 			 mod);
+	ethnl_update_u32(&ksettings->lanes, tb[ETHTOOL_A_LINKMODES_LANES],
+			 mod);
 	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
 			mod);
 	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
 
 	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
-	    (req_speed || req_duplex) &&
-	    ethnl_auto_linkmodes(ksettings, req_speed, req_duplex))
+	    (req_speed || req_lanes || req_duplex) &&
+	    ethnl_auto_linkmodes(ksettings, req_speed, req_lanes, req_duplex))
 		*mod = true;
 
 	return 0;
@@ -409,7 +458,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
-	ret = ethnl_update_linkmodes(info, tb, &ksettings, &mod);
+	ret = ethnl_update_linkmodes(info, tb, &ksettings, &mod, dev);
 	if (ret < 0)
 		goto out_ops;
 
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index d8efec516d86..6eabd58d81bf 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -351,7 +351,7 @@ extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_COUNTS_O
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_HEADER + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL + 1];
 extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_HEADER + 1];
-extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG + 1];
+extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_LANES + 1];
 extern const struct nla_policy ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_HEADER + 1];
 extern const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_HEADER + 1];
 extern const struct nla_policy ethnl_debug_set_policy[ETHTOOL_A_DEBUG_MSGMASK + 1];
-- 
2.26.2

