Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26505E6F5D
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiIVWHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiIVWHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:07:17 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2071.outbound.protection.outlook.com [40.107.105.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBB7ABF33
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:07:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJblYxdX6TwSm1QUf5h8eIH+MAE6fOC7aQGIdIzqTzDjHxbCNTjDubc59VppjGHkXqpnKdlF509m22MTtTcOJtE5LN0uQpmxP2UHLjshMvYSHrVx2dk8GFIXTIO5qPHqaPeOq8ZWifxahOl1Qv+nqbD72cK2AIkaV+ISxfY8+HEVIw8tc9FNoajZHaCIPXlDsJRcvhB/j5vx0xcx9l0JhtA01zvbZ/h6RiSsH0t+jUYsCIMp++RXQwFhbOh0SZgef5m+C1UiTirfG+uDCi9+Tzsz+4LLAuClToYfDhIkYVhnsbOO/7ALaQYTr4ocx5ciPln2nu0XcXK/pkCubH4G3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYwKBa2O2vxhj2qQx27eDMXs85MtSk0lRam6h72k5Xc=;
 b=TYFngqO7/zxDl6PIkRrrF+L9wD4GD5oppoCowjPV8L1wiFIZ+wS3KBA+a8JanzqmB0smu4t3Z74aLswTFAGC7I1dHMl3+pXNIYaIfmtIvytvgdUTDMeyXN08MHqcZeYDKJFEgm5qHIKpqZSIcxDK77k25HBkqsAIPvP3OyxRmXOXMVHgCORBrdSqydeGECnLqzzt9MChkEfjHvzY/sZ5m+sV3dwk0H5p+5CZj20hB/UMLMu3O0UAFFRyhcQo5up+rV6ecWg2SVniWPxP/mYfN8XVB3CJh467pB1Gqvv7KdEC9c7ZLl+lgGaKNaYPrrMfszOOu+5re0jQ960Za7dhUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYwKBa2O2vxhj2qQx27eDMXs85MtSk0lRam6h72k5Xc=;
 b=ed9Eg9cTRMVpU9Dbqg4okm+/Y6LFHgG60EsDOmlMbEXO3BsLhTR064AQdhNe/MvZJ+VcUkAxaYUcGAgAUdLiliqsEyUW24okSJ9sd4ckUgBGuIwziOIpoE17PdwDyvT9rkwZc9D2IngGpKX90DKfUudRWulPiyGFtm6pr2xXxEY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8980.eurprd04.prod.outlook.com (2603:10a6:20b:42f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 22:07:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 22:07:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 iproute2-next] ip link: add sub-command to view and change DSA conduit interface
Date:   Fri, 23 Sep 2022 01:06:55 +0300
Message-Id: <20220922220655.2183524-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0020.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8980:EE_
X-MS-Office365-Filtering-Correlation-Id: 601a5c42-8931-46be-bfe9-08da9ce6cdc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4jj6cpLh4dsu93du/gv0IRyGZtCIjpw8Swc/hmBL2nerVW5wZjWwhXOWzD+YrwQ4RkFtlsUhQf+e64mCXW881BR7gLPFH1YoqK22h6NLFHc6Vjqd/OwiA5rImovgxUNUv0KnqoiPAti3fwFKl5u4exiURM4J8FY4YjsXOsH81Uay1F7UKFrjj+9BXnYfAXQu8kYFKomEixSrKwkbIP/4Tx30J/OVhKGM6LGFP285J48RIKgnRtmOoS7QiG4rMjXS9LMR2NkJXMGCbVMcRrsub6zypCgfxVomZNBrvIc2LVu4DYnXUe0/1vq5O5H0ZOnLX1U+H/c0Vf40qrNNLqPLEwhfN3uILmAkSZ03JC8hGT0AcRZXc5dbvji4qfvwpUj50nL1cj5BDYHuMtOAlpypUHzTR1KsPlKhZj6oh5ZD/9MN6n9On0cT61v0RDeo1F7vC11kAh2IVgngeFE7RcEBgOXissJ2eDsEuc9UVABINJ5mri2sBS/v1+7C/dlYHb/tBB7bB61VUMaSALYUVc8P6ys5z3NGyWLU3GgWpS3/aWgoxwdx9F/R3Y91xw9K5xCLT15tYBmc33RWhXL1WW50vFWq2QnxZJGRVri0xEjM9EDQ2kZ5WEeWJUtNYzEOlRJ+zNC3xTrYQo4tCKkEZHaPlA9Gc6BruZgx4mCIo4G2VythAE+KC3yCuW61EgHfBZmSJM4rTHIUZYtcfa+vnhZQzg6mIxonMrEs5YiB3Ju7kvCMb8OKavX5sQU9k4PpY5C26AzkKZqTbtsFWdq2NKj2qSNImtwX00ZIqOePY5t9vpU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(451199015)(86362001)(8936002)(38100700002)(38350700002)(2906002)(83380400001)(6486002)(52116002)(44832011)(41300700001)(6666004)(66476007)(66556008)(26005)(6506007)(4326008)(66946007)(6512007)(478600001)(8676002)(5660300002)(1076003)(6916009)(2616005)(54906003)(186003)(36756003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FfUgmO9RypZy+mWNX/CLrl+FgAfBQGNWgpBT/cFFu/7Us7bnpGKiTzNxj1Lx?=
 =?us-ascii?Q?HI72MOdM2mnxf1kJQ+5bf7dFOf3CP7wRkRH/rFfoGaljj952af+U1pQGVStg?=
 =?us-ascii?Q?0TzC+H3NxTylfH3oqnq+s6Oyi6XqbK5NK5AikHiOLH1FwMoSNXNHMBcccwVf?=
 =?us-ascii?Q?vexJs+eLL2fST3cQG42/HbybOHpWhIN3QrM0gCAQCZzkClnw2MyYV31rsfEF?=
 =?us-ascii?Q?OrumSI/m9pC+w0QZzngcvgBenryQjEei4QhglP9TYYSJGBbgBdkpF32cafZz?=
 =?us-ascii?Q?ZvXrA0YUaKMy5YzuxFAeyAiPzPP3RV3kdx9FRzkhy4zq+fVWCBmGdR6tKq6N?=
 =?us-ascii?Q?7/ktjEKHPKS0iWq0GVcQc9iHAiGhGyjOGIVf5+JBI3r6xfM+EHMmUJhqIz+b?=
 =?us-ascii?Q?EjHYB4qN1h1/b6Co3pap3GlcOlak4yakLwNk8EOfV34J5Lltzz7J98oQWf5U?=
 =?us-ascii?Q?bMIc7/AzJP9ZsjBSaUX+MEGVzP3eDgJEpmHSmFy3bHzYO1huUjEepzQHxocg?=
 =?us-ascii?Q?zV7QTQAzvCRoOM9y4gFhpmKZnHOn+H0ZXWHTIndae1oe9VZ3qPoaPV5RDzn8?=
 =?us-ascii?Q?2bztlUa4dKDZye0YLD5nNeGywJOdzYo/Z/z/GrrdtFySgEGRJZPYgu62Xksq?=
 =?us-ascii?Q?IP8xqxCYomx2NVz/NO9Rp5nbgeL4te/VZ4MrDKTMjZGE1/XQ2nCH6UofNvT8?=
 =?us-ascii?Q?jurn6eR8H3+3tJZdgPOo6aJeX8dsDv9K1E6WvR0I7TW0wWEKgBNAduWGt5e6?=
 =?us-ascii?Q?83WCwY1gGuJ3BKWtgz/ChQYSP48yHI7xXn1UH0ySAWwXzv4LVwjSMqce4ATP?=
 =?us-ascii?Q?McJph1H+3QFDCB5MOthsAp7ULmKIOnRLohvKCtDqdFmHBIe7C8gTffE+SGq7?=
 =?us-ascii?Q?69uixmUaCLPWKYngv/hGbj2qGFxKiFsc+phSlunnNeuk/rWO3eipZn9E8iPB?=
 =?us-ascii?Q?BrIQUymouHeCrYwKIHTZKixBZoYgPf0r3jNccem3BjDqIpOUxrDBc64o4fSy?=
 =?us-ascii?Q?G9q31pc15cQJO5pbQvAZ5MW2wlLy7a6w2Gsh6/4E0NjU3e4qhSZkKk+FKCmu?=
 =?us-ascii?Q?MxcQI/RfmoP84am6Wk1kbkZ9Zi0XWbIFXRZUFIL9qwDEu6RpXJO+tFhjuRj1?=
 =?us-ascii?Q?qh0HBYp4uedhb7aMtnUSzgBpE0jcAycf52BLffOIADqF53sjGMwI3DBNvVQk?=
 =?us-ascii?Q?44rNtfRMTnWPsdSO89GaKo+GVxfgT0iKFdU5HZUcxLgnt4U9R8BY9L6z8LhS?=
 =?us-ascii?Q?tcgniYC6V77NKg7ciYp0yKbQaN0QW5cxpZqzDlDn4xgtYtVzIUolQCC2C2hL?=
 =?us-ascii?Q?XSyqJtq5OERC+u14V84kDpEC97YYl3DrmFDDpXfJF6+XyI0dMeChmK6IYUDG?=
 =?us-ascii?Q?43XQDtf7DVu9nGp+n0Nx+zpHaieIUfaLTIDV4ouNeiYibO4pZqrZQ8Wtt9bW?=
 =?us-ascii?Q?w2LqR9QYc3aaViuiYJDzBsOdAN2KOCFNLUsnqc2zEuW0t3KXX1gYHMIfxFR1?=
 =?us-ascii?Q?2CZbuv/fO/yBt/2oieR/i5YNmTphyHz/EIyefKIBYSVKI6g+FoUA3lBazJnt?=
 =?us-ascii?Q?PQ3PhVU+t4Zx2mzoTDVbG+7RIwBiYv2S41+Cx5PSRhLdH9K5zwGwV/hbIdmu?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 601a5c42-8931-46be-bfe9-08da9ce6cdc2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 22:07:13.7037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +R3Djsbo+tfpCemI+FhQaFO+zQvh5fDL4Aa5I0FczQX3eMParmGpbwBQ+KJuNJSJNA3x+aWw432YXpyr0GVPag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8980
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the "dsa" kind of rtnl_link_ops exported by the kernel, and
export reads/writes to IFLA_DSA_MASTER.

Examples:

$ ip link set swp0 type dsa conduit eth1

$ ip -d link show dev swp0
    (...)
    dsa conduit eth0

$ ip -d -j link show swp0
[
	{
		"link": "eth1",
		"linkinfo": {
			"info_kind": "dsa",
			"info_data": {
				"conduit": "eth1"
			}
		},
	}
]

Note that by construction and as shown in the example, the IFLA_LINK
reported by a DSA user port is identical to what is reported through
IFLA_DSA_MASTER. However IFLA_LINK is not writable, and overloading its
meaning to make it writable would clash with other users of IFLA_LINK
(vlan etc) for which writing this property does not make sense.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- update man page
v2->v3:
- update main ip-link help text to print the new 'dsa' link type
- rename the 'master' keyword to 'conduit' and keep 'master' as a
  fallback
- to avoid using the 'DSA master' term in the man page, stop explaining
  which interfaces are eligible for this operation, and just refer to
  the kernel documentation. Note that since the support was added in
  net-next, the htmldocs have not been regenerated yet.

 include/uapi/linux/if_link.h | 10 ++++++
 ip/Makefile                  |  2 +-
 ip/iplink.c                  |  2 +-
 ip/iplink_dsa.c              | 68 ++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        | 35 +++++++++++++++++++
 5 files changed, 115 insertions(+), 2 deletions(-)
 create mode 100644 ip/iplink_dsa.c

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e0fbbfeeb3a1..6f4d7b1ff9fb 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1372,4 +1372,14 @@ enum {
 
 #define IFLA_MCTP_MAX (__IFLA_MCTP_MAX - 1)
 
+/* DSA section */
+
+enum {
+	IFLA_DSA_UNSPEC,
+	IFLA_DSA_MASTER,
+	__IFLA_DSA_MAX,
+};
+
+#define IFLA_DSA_MAX	(__IFLA_DSA_MAX - 1)
+
 #endif /* _LINUX_IF_LINK_H */
diff --git a/ip/Makefile b/ip/Makefile
index 6c2e072049a2..8fd9e295f344 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -8,7 +8,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_macvlan.o ipl2tp.o link_vti.o link_vti6.o link_xfrm.o \
     iplink_vxlan.o tcp_metrics.o iplink_ipoib.o ipnetconf.o link_ip6tnl.o \
     link_iptnl.o link_gre6.o iplink_bond.o iplink_bond_slave.o iplink_hsr.o \
-    iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
+    iplink_bridge.o iplink_bridge_slave.o iplink_dsa.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
     ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o ipioam6.o \
diff --git a/ip/iplink.c b/ip/iplink.c
index b98c1694991e..c7c36f12c470 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -48,7 +48,7 @@ void iplink_types_usage(void)
 	/* Remember to add new entry here if new type is added. */
 	fprintf(stderr,
 		"TYPE := { amt | bareudp | bond | bond_slave | bridge | bridge_slave |\n"
-		"          dummy | erspan | geneve | gre | gretap | gtp | ifb |\n"
+		"          dsa | dummy | erspan | geneve | gre | gretap | gtp | ifb |\n"
 		"          ip6erspan | ip6gre | ip6gretap | ip6tnl |\n"
 		"          ipip | ipoib | ipvlan | ipvtap |\n"
 		"          macsec | macvlan | macvtap |\n"
diff --git a/ip/iplink_dsa.c b/ip/iplink_dsa.c
new file mode 100644
index 000000000000..e3f3f8aca13c
--- /dev/null
+++ b/ip/iplink_dsa.c
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * iplink_dsa.c		DSA switch support
+ */
+
+#include "utils.h"
+#include "ip_common.h"
+
+static void print_usage(FILE *f)
+{
+	fprintf(f, "Usage: ... dsa [ conduit DEVICE ]\n");
+}
+
+static int dsa_parse_opt(struct link_util *lu, int argc, char **argv,
+			 struct nlmsghdr *n)
+{
+	while (argc > 0) {
+		if (strcmp(*argv, "conduit") == 0 ||
+		    strcmp(*argv, "master") == 0) {
+			__u32 ifindex;
+
+			NEXT_ARG();
+			ifindex = ll_name_to_index(*argv);
+			if (!ifindex)
+				invarg("Device does not exist\n", *argv);
+			addattr_l(n, 1024, IFLA_DSA_MASTER, &ifindex, 4);
+		} else if (strcmp(*argv, "help") == 0) {
+			print_usage(stderr);
+			return -1;
+		} else {
+			fprintf(stderr, "dsa: unknown command \"%s\"?\n", *argv);
+			print_usage(stderr);
+			return -1;
+		}
+		argc--;
+		argv++;
+	}
+
+	return 0;
+}
+
+static void dsa_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
+{
+	if (!tb)
+		return;
+
+	if (tb[IFLA_DSA_MASTER]) {
+		__u32 conduit = rta_getattr_u32(tb[IFLA_DSA_MASTER]);
+
+		print_string(PRINT_ANY,
+			     "conduit", "conduit %s ",
+			     ll_index_to_name(conduit));
+	}
+}
+
+static void dsa_print_help(struct link_util *lu, int argc, char **argv,
+			   FILE *f)
+{
+	print_usage(f);
+}
+
+struct link_util dsa_link_util = {
+	.id		= "dsa",
+	.maxattr	= IFLA_DSA_MAX,
+	.parse_opt	= dsa_parse_opt,
+	.print_opt	= dsa_print_opt,
+	.print_help     = dsa_print_help,
+};
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index c45c10622251..fc9d62fc5767 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -213,6 +213,7 @@ ip-link \- network device configuration
 .BR bond " | "
 .BR bridge " | "
 .BR can " | "
+.BR dsa " | "
 .BR dummy " | "
 .BR erspan " |"
 .BR geneve " |"
@@ -304,6 +305,9 @@ Link types:
 .B can
 - Controller Area Network
 .sp
+.B dsa
+- Distributed Switch Architecture
+.sp
 .B dummy
 - Dummy network interface
 .sp
@@ -2637,6 +2641,32 @@ as well as the actual used bcqueuelen are listed to better help
 the user understand the setting.
 .in -8
 
+.TP
+DSA user port support
+For a link having the DSA user port type, the following additional arguments
+are supported:
+
+.B "ip link set type dsa "
+[
+.BI conduit " DEVICE"
+]
+
+.in +8
+.sp
+.BI conduit " DEVICE"
+- change the DSA conduit (host network interface) responsible for handling the
+locally terminated traffic for the given DSA switch user port. For a
+description of which network interfaces are suitable for serving as conduit
+interfaces of this user port, please see
+https://www.kernel.org/doc/html/latest/networking/dsa/configuration.html#affinity-of-user-ports-to-cpu-ports
+as well as what is supported by the driver in use.
+
+.sp
+.BI master " DEVICE"
+- this is a synonym for "conduit".
+
+.in -8
+
 .SS  ip link show - display device attributes
 
 .TP
@@ -2793,6 +2823,11 @@ erspan_ver 2 erspan_dir ingress erspan_hwid 17
 .RS 4
 Creates a IP6ERSPAN version 2 interface named ip6erspan00.
 .RE
+.PP
+ip link set dev swp0 type dsa conduit eth1
+.RS 4
+Changes the conduit interface of the swp0 user port to eth1.
+.RE
 
 .SH SEE ALSO
 .br
-- 
2.34.1

