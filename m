Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AADA5C04C8
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 18:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbiIUQzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 12:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiIUQyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 12:54:53 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2044.outbound.protection.outlook.com [40.107.20.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB339A9F7
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 09:51:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cC9pYjrqtR5gmkkxmCnXUHd0XEREsAhig6cU2c2Yt05dd+sN3LG6wcw5KMEauvhL5zcz9s2LPkPiRv7KI/63lTsmoPJd4PPnLeMqn19coSSS9MiVLloO8LiILFsZ4pYSl+tg8GwKmW6kr7s7V3tmLpAr+fmLzNyXDk4d+eLtCOcUq01JVav+yUKaaXtMOYLZ52evxjBti8pRHyy2Fpnw50cUinYmyzaLmfn3hPQTw7ABq/+hAbyAs1+OTArfGBJ69PY+u4TuwNq0wTuoKxQ32YJGOShso1zMZvxOdG8dKLW7HL72RHWCAIfEiIvkQ2NJXxcJzkTB++LJkS8MRg435A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3Y0zTrkDfi7A6FOP294YKlfa7w2Pp5kTV/4Lg7gdDg=;
 b=lwi4ljPGg6gP42NoqzpfKK7IWJtKIe5Eh7DXkmKWP5KmYfpo/8bw2rZLrvVQqssZ8zuzGLW8jWs8IoJ2ezwPdCU1N9xHlwNnbndSLvAyMNabGZbc8NPfzLvVqlEdLNdYHYCRcITIXxPwveQZafcXWbUOjGcYtPHlRCWOm/UM98NhxhNgL/U4KJuS9UpwLEkaBjNSp0rUpDXzmG236R8nKPYRPpaTmqeznWpV6gyKMIfIZ43nmWHp1I9i7mxTCVZeKfpHBHe7kEcOEnNYxV+FtvqZJhApRKuTRD/AOvaDK7I1T1z2dcyzC0J6KgqDNOqLxdSZIPDJ+CINkJWNkCGofg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3Y0zTrkDfi7A6FOP294YKlfa7w2Pp5kTV/4Lg7gdDg=;
 b=iIw1ntqt4oPAYr2gCMjWMbTju9BfSEly85wSBVhY3XokrY5er3ppOH/27s9mdlmDJ2n3JX55tzRk0tmd6zn3tIZjw7CX/rMFKvtt1SI8hUF0cwXF2AwtyHI0AOd226RgwJfx9SEdlcjpb62NfZMGMmspGaN3xd+en14+hiyZxiQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7227.eurprd04.prod.outlook.com (2603:10a6:102:82::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 16:51:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 16:51:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 iproute2-next] ip link: add sub-command to view and change DSA master
Date:   Wed, 21 Sep 2022 19:51:05 +0300
Message-Id: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0005.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7227:EE_
X-MS-Office365-Filtering-Correlation-Id: c0f062ee-6a85-4091-cf1f-08da9bf181f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7I7XtWBBRvUCGPac5PsH67GC4cVlLg4PO7bmh9f1oJ48U5pOlPqKv3u7sKH/ITNLtgCDE9YKX5blzGSCRDXEBuECJSab4rUZttDZiJgIKveBIEJAn1h3SaT/1p5Y9WMTmHdEm+Es6iEp/Z2yZVvLYSmYGTbA0S+a3IR/AButRmHETVmwehKHimrpo+4SYYyqVZuyh/ka5faxS+5RWiEWAN85PZOwUl8NQNCG+TOsmoBA6gfNfZaQ4i2Nn/2GF/MpY1GaqY37QwZtv6hxOebf4AIpy/f+HNWoGwKMNne4/EJVFJ+ej5n+usQRr+N7YIHk/c4W6j0BGOTJSrxKIQKLBZ1x8eLgPm46kCPNDvq8sZE67Cnz3+66hhqQSFbux2LdNH+RWwSMGG0RMc7tFT17jqvo9NdjfyBxY5a4DMHW4ha1MFvvuqt//tm7Vftp3k3LNaqEl3BYJMlOdqoZ7OpfOcAS8ZikP4l1TQzK+JNMfZXidObWO//Ee74h8+SUqTyIWpRLfgNnCj/SA4eVksu5fDdIaas0kZ3BMyrar5mbdKmhoSYXFFrebpyrCmt4Q+ahdx7DSqk2oi8wcF7cQv665/+9xB564VV4KUbJALyei8J+1dvMZpsK2TfaRzDM6jsX9Det7XmXSsCRqS/aZxWZ9hjXXABTgVWEzO41CdEcqKNN5/w0Lv3QUf9+9NkwR7eZoCmIXtE2d/NX/K3nvD9iJDAt/1JvD6wQEMGAZ0FwmzkSE/zNHVjGJqYDTkYqtK+3b4QsEks8ODpalOr5Vpd9IkiYuIZNP2vc8LbfgPJhWGA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(2906002)(86362001)(38100700002)(38350700002)(966005)(6486002)(478600001)(41300700001)(83380400001)(54906003)(316002)(6916009)(8676002)(66476007)(66556008)(4326008)(44832011)(8936002)(66946007)(6512007)(26005)(52116002)(5660300002)(6666004)(6506007)(2616005)(186003)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ju2aw0M2rmpWyEfu7E6uyKL3cWrlAi1o/CcuVbXcl7hj3bW8rCs/LPjIf7sS?=
 =?us-ascii?Q?Unuzl62eFnj9yOEtfykdZPiLWT3+9EOo4WTFLH/omqqN15bWpvO7dgmipjff?=
 =?us-ascii?Q?nE6gqKruStApxhXzSOnCVP7/ku/4EqlmiYdbZZAgh7ew2dr2ePZXLzKqH7JV?=
 =?us-ascii?Q?UxkYSO0pf7TpviPdG8Nv6qsRqXEzCR3/gTQl44i9ZWLCYGtbdxcAHyi+Ya0n?=
 =?us-ascii?Q?+32kU+0ZV1hzG7LJveQFXJakG/O0i+CJtBymUUN8n21l54NNPWt9AXzLlSvx?=
 =?us-ascii?Q?eJ4TkcCVk3NJTpQ/TzVdVd2XJliE1VsPi5K+pXlx+ZQrh+QvJerjjl3qTee5?=
 =?us-ascii?Q?l/RUUWVBMnleaFKPZMoTFFECl4xQ17GrsH0QqFub6b3Rz5XYKvY23Tgf1tjf?=
 =?us-ascii?Q?gpxuBBb1r9Axg69U4eQFcLBMYWmUdhRcUwCz2xddocmihknSAzFh/00PERZI?=
 =?us-ascii?Q?L3eq5+FYwSmJg55zISd0GCWVATHwSpUMj7/+IvTKOn+uu8uob3t746kjqZCg?=
 =?us-ascii?Q?ESMVldtkvEdHv8oUfy5RPV2LpoPJqUY9sIyT2s5o9t6Y9Hc0qJM+S4/16DXh?=
 =?us-ascii?Q?jN6+hcWOOoV6LkQ9bv+F9Ytn5UcfEny8l/VnhjXrRCOZY+AWNgKT84rl1Brg?=
 =?us-ascii?Q?v6vJ4sGm6YjvYpNoHjwtsQI2baUcLkorQIOcNgN6NlIk1tpfzwqJvMTrUnGW?=
 =?us-ascii?Q?8puSyFel0w4j8qKVx0O92GanpO9rMXL6OCGa1WbM5yTZoqQL84viRoqmVyZ1?=
 =?us-ascii?Q?7Fg78DFwLycFxAwRnWrYlRb+ZR+psOBhHLMw7WU8JPhhkis1o0kNHQYRMAsW?=
 =?us-ascii?Q?48vX0IYqC3qkdBKfk7lkFqO3xxgdwXfR4uCER+3Bkp0cU/efYwKSRcb7ik6N?=
 =?us-ascii?Q?33DFxdGNkgTOdq5POO7c3g5n7BeCffgHoGil13OCQioODhj+KAth2G8gK5he?=
 =?us-ascii?Q?cXU7DON6VrxtmIkqj1lLdF70zcA6TSublYRNW4FANQNQfteXS0wsLYxI70Ob?=
 =?us-ascii?Q?5M+UqR3ufyuhd36HNjY2zPpUnDnqw5f6FSwFZYQl4xzJgKo5OgYBQLhYbE0u?=
 =?us-ascii?Q?JLrvXTw1okkT+245Z14EP9H6fThZf0phXocGZVq2WPq8UQaIrFUCyWKd9vA1?=
 =?us-ascii?Q?RboyNwmlx6As6VotjMd76bwex5LYOHE5q39PKawBwktVJnlxuEWpDDu9A35P?=
 =?us-ascii?Q?yzWa3lnm5EsMdBUTnJPF5bPY0LO4Uu4wWQwOfNM7raNVYh5G8+ModRYSj85y?=
 =?us-ascii?Q?bymkpj/cIsw8WFJQjvYOIxvnRkVPKMr2ArpTTd3ZU2IaVPrW519hHs77u2Yv?=
 =?us-ascii?Q?er6I746BcoIXgEb7p377MqX268bX9WwmagCRseU0xUpPYa/Vi6UdCdPFCYKz?=
 =?us-ascii?Q?v9Q0CEWKk4f28xU2FeK89LpHIg2/RIcSCc6shAr8R8nrTi2SeLTg4rxZMR+e?=
 =?us-ascii?Q?frWcqhOAFID/i24wsUoA/voQjBq/Qv4DCZUIhGyaIeaESzir2E1kuYX7z27q?=
 =?us-ascii?Q?DkQJ/dUUFJMwcxCU265dneifa2ai4otyCo99B1ldwA2jGYFRGU3XXQEXRxSk?=
 =?us-ascii?Q?dTL89bZo1BHJ9YC5B3XbNzOV6ZHKvzhm6pF/2OGVyzar01n12joxAeRajFxA?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f062ee-6a85-4091-cf1f-08da9bf181f7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 16:51:20.0958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2+SxihT+s4v8xifJ0kcqFuWl4/o8GV6+qRR5ry8F7l7UjG4QCLeMdeGzIOSXgo5NpTQEhCuCWVyIN/gznvy7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7227
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

$ ip link set swp0 type dsa master eth1

$ ip -d link show dev swp0
    (...)
    dsa master eth0

$ ip -d -j link show swp0
[
	{
		"link": "eth1",
		"linkinfo": {
			"info_kind": "dsa",
			"info_data": {
				"master": "eth1"
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
v1->v2: update man page

The kernel side patches have been merged, so this should be good to go!
https://patchwork.kernel.org/project/netdevbpf/cover/20220911010706.2137967-1-vladimir.oltean@nxp.com/

 include/uapi/linux/if_link.h | 10 ++++++
 ip/Makefile                  |  2 +-
 ip/iplink_dsa.c              | 67 ++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        | 32 +++++++++++++++++
 4 files changed, 110 insertions(+), 1 deletion(-)
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
diff --git a/ip/iplink_dsa.c b/ip/iplink_dsa.c
new file mode 100644
index 000000000000..d984e8b3b534
--- /dev/null
+++ b/ip/iplink_dsa.c
@@ -0,0 +1,67 @@
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
+	fprintf(f, "Usage: ... dsa [ master DEVICE ]\n");
+}
+
+static int dsa_parse_opt(struct link_util *lu, int argc, char **argv,
+			 struct nlmsghdr *n)
+{
+	while (argc > 0) {
+		if (strcmp(*argv, "master") == 0) {
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
+		__u32 master = rta_getattr_u32(tb[IFLA_DSA_MASTER]);
+
+		print_string(PRINT_ANY,
+			     "master", "master %s ",
+			     ll_index_to_name(master));
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
index c45c10622251..cb0504793e06 100644
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
@@ -2637,6 +2641,29 @@ as well as the actual used bcqueuelen are listed to better help
 the user understand the setting.
 .in -8
 
+.TP
+DSA user port support
+For a link having the DSA user port type, the following additional arguments
+are supported:
+
+.B "ip link set type dsa "
+[
+.BI master " DEVICE"
+]
+
+.in +8
+.sp
+.BI master " DEVICE"
+- change the DSA master (host network interface) responsible for handling the
+local traffic termination of the given DSA switch user port. The selected
+interface must be eligible for operating as a DSA master of the switch tree
+which the DSA user port is a part of. Eligible DSA masters are those interfaces
+which have an "ethernet" reference towards their firmware node in the firmware
+description of the platform, or LAG (bond, team) interfaces which contain only
+such interfaces as their ports.
+
+.in -8
+
 .SS  ip link show - display device attributes
 
 .TP
@@ -2793,6 +2820,11 @@ erspan_ver 2 erspan_dir ingress erspan_hwid 17
 .RS 4
 Creates a IP6ERSPAN version 2 interface named ip6erspan00.
 .RE
+.PP
+ip link set dev swp0 type dsa master eth1
+.RS 4
+Changes the DSA master of the swp0 user port to eth1.
+.RE
 
 .SH SEE ALSO
 .br
-- 
2.34.1

