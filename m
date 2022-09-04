Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C425AC5F5
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 21:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiIDTAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 15:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiIDTAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 15:00:49 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00086.outbound.protection.outlook.com [40.107.0.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA3C28E1D
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 12:00:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bE/MhAKMuEfRAVCjTV8Hx0Ksv3ROvNftwkriH6Sxo/avI2Z9yI7fs7ygM3r7Cx0GGxa8HukiejPdVrN5EmsC1X+/bZnTEw9+VeBXtypzHuAY+tf1ZJSpxsXgaKvRnWbvI0tBY5YwRTQRyOPHgcj/2ogh0p4K6Fj4FEFGEF05IjhugA2FwtD8Qj7ko94qN3xUv+XdHrF6e8fjJyh4UKrsgNGIiCMkrDbkh9gX4hmmzzYTtQcT59KxBsj/Nf1+sbEdgi5HeS0z+rMmR6LL7am4KtNw6iyXvvhzMiI2W7YsDdiAFbON3F7arCssSb21I7xyCXbhrEVTI+pV1L6xFw6aNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjhRh1PDTZ850v6hy/Udcf14QoNtJ+x+EYhJyIsSq1s=;
 b=dva3mBmeiWA/w+y1TNUbzXIADr66DZ/jXwn4br9i8l96duETRYO+tRQf6C9MgzGw/v6NL0gE/AhBvkBUhJnZw9Meh59rwfi1r06z2JIlxX2tsDSBrsTtnU5scpv0KxifuYVB6+isyyfO5dBpg8TA1UCquxBwbIayqlAorXOiNcqwxe0+MUDioMfqihnIRc82A/6SLDkTo5L2r5RFVn/d0CLhUZCI/bcEXL75RwrTFjQcoMZB1oONCLoc3v/QVEr/Qf2dLSHRgG04K7426Ag83xtm5zmI65Dmw94TkKZIyBUsTYQQhzjiHfdqQZGFHtiJb9khTvo7Ck91/M8e11ZWNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjhRh1PDTZ850v6hy/Udcf14QoNtJ+x+EYhJyIsSq1s=;
 b=dtARwZuicpq+/4WJ4V1M3sdBruE5jvNwc/4A6WC0WD8euaUdn/jiqnJ66cRIBGYVTCVZ6jZZL8zUHwhsBcCehQKD3bK6kaZF96R4jQuplNMPg39uxAnR4Fg7vlkA0QLa1iBF3v40ivP+CeNvTiZS8f9oozxJRXsmLl8saHi1iDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8932.eurprd04.prod.outlook.com (2603:10a6:20b:42f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Sun, 4 Sep
 2022 19:00:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Sun, 4 Sep 2022
 19:00:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] ip link: add sub-command to view and change DSA master
Date:   Sun,  4 Sep 2022 22:00:25 +0300
Message-Id: <20220904190025.813574-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0048.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c47270a-9961-4882-3ba7-08da8ea7c4cb
X-MS-TrafficTypeDiagnostic: AS8PR04MB8932:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eMD/r4ZuCmNvdgNtZZKv4JNvtkl0buVQTT/VcEfvBELzJhuCgr9AnushYgBTcQ2bbfdRdO2MCkAgSFfy59qcaLHvpjGMqNdsjn2JZCunUJ+KqY9vp1Sz74KrQZxJYSqa1zFqa1FXRT8eIUgfudIo2u/TZq7lrdD7dnQiqBvIXIQ8n481FjkS9ZcQJeVjorlEvgCLFXFEYHOUUhYcs572mG27bCHU6OzHsuu6GHUMz7GT2S1VloglCbxqvCMbp9ZbpTfLzPL9s5ZYNEzu+3G11EFGptac6QjmW2B7RK9wYLOtw70oK+z5g/DqPPSsYVzfZVmloQ55zvOqi4o1woyrDcuiNPfLUmslqN9DgvWkfMS+o6n7QhoCL8hfoofZJlzzujl+Py6k1F3A0IvXm/J7my77UtUI3Ami3WHOwc8gS8sRRdW6nVmidTOTFp71Uf5Gee7bHI+gdD4balSvNsxmjqLtgmH7yeD+MkDqCxx+Ncz+H1RVjrzbn8t9umgC7Vm0kcPsQRTpnLY5Wj6FmHDb/VNSp75Ijf6e6KYD3hdjjqnxPPZBg9UwV9PaSebLryzYdo/de5ZqZQda+5Eu+APTa/QifndEIyrp5+a7AEBhMdvFDNrxHYheT884Cc/BK3p08DjRgejb1EwajUbXfqXCVgq0d3wjXGSsJ0VHLh80VQP0Lxorc4XzUOMyLoOxFPTXlipjymzC0lmynFhQQBL0mp9zmOTixG/dxRs8iyqtf0VXzJiBuHMGRIPzVPzB/+U/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(36756003)(5660300002)(6512007)(41300700001)(8936002)(2906002)(26005)(6486002)(38350700002)(38100700002)(44832011)(478600001)(66556008)(6666004)(66946007)(66476007)(86362001)(6506007)(8676002)(4326008)(52116002)(1076003)(54906003)(6916009)(186003)(316002)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TQdBsqxp9w1ASCXzJxh7xhurZSHULOsYb63WP/zzAgOiqV4cNoYySBI2pCkx?=
 =?us-ascii?Q?JQoLDe0Be5XlZCpS1NYiF/RUjI0hV+s3KlAbuPTCOkHwvK4U8LywrKONZIXG?=
 =?us-ascii?Q?yAx+/FiQF7C1C7ZT6AJd7NjoPEiwrjQ0C+MhRpvBSmzm4SDE64EYvX9IEn1P?=
 =?us-ascii?Q?fPEzixoZPJyHj0iP2RLQG0z56fwNe19ymv/ETe+azHhzrykI9KaYr7ihEbas?=
 =?us-ascii?Q?qGJVAR68ceFDIFN7TJZPxBvWsJRcdHBJQsTtfAmTvb5LsxObIasb00JHU2g1?=
 =?us-ascii?Q?4vs6q5KuqPR2x5BeQQI43EDaOqbmkdmQm3KZcPLrd4jLqyXaGA6fw9iV60CN?=
 =?us-ascii?Q?Ep/TEY7H2vO74k1iq0mH7uDYgaAx01XyUO6GOCfb4GAMrmloGloq28Mlp5+O?=
 =?us-ascii?Q?NUOem8dzklYWg3dhIFr2Mrux31J7XssLVnZKVEMAbFs8MeN3X1nLwIoSCLL1?=
 =?us-ascii?Q?vWmP8Qxt8X5racqSTFQISVX9sF3mac0hmw5HJ319iWiKCwsyx3NkC6POEEKS?=
 =?us-ascii?Q?TTKKPOv3p8Ynv8PwCqn9PVvHm4KOW4Vv5tGhr6V5ArotNqqFF5OTCPLtgUXn?=
 =?us-ascii?Q?N3fMPjSISm4HGtBbPWQfec3joH5xKFwVPw3njp3cbSnfXxdetf+qKSL1wt3m?=
 =?us-ascii?Q?DNOKljemSTBrPP5PtK+EDThYVwX7ghB20eKDModsz96NQgJdz9ds+G/lI7gT?=
 =?us-ascii?Q?QLmxymORvBWmhTaS6hAC9zlxe+6cgfG4tQcV0oi8bvAGJ3uTQvRKpyZx2jsA?=
 =?us-ascii?Q?IMF2CwYCo34WeNJp5E/x9w7oUqK6DIqEBPszvWsHHMYA/jCjD5kz6BMTsuaP?=
 =?us-ascii?Q?KSbukmJoLdpsaYHL+3u4HchbsUVLM58IipIkVOrU1XMgiZJJA6a+IF9OIgAp?=
 =?us-ascii?Q?STUfSSHEVIFxdzreIb7A+AeMi5P8IFBvNKiA0yHRBL23nO3hu9SfgFq5393F?=
 =?us-ascii?Q?lodnFcH6BsCYE0tEc9XR24JJdrGffNwwqjcQHNa3sFjwrhcTu3OS3ZO9Sjc3?=
 =?us-ascii?Q?va/T6nglxtpmBvWZOfUP7uM27JilfIeC/nBAn2HQxMI6UCNhgqrpApHvwR+Q?=
 =?us-ascii?Q?2qur5jvD6fr3eHmuBVE1h67Q+ToHuIknpEujnLLBi6rfAHt/bstthQwA+wVN?=
 =?us-ascii?Q?uJYIQ3B/mJTunyhCsRlz1n0rKXaMoAnv/3f851CTpERz+gJTb+edp5XPekgj?=
 =?us-ascii?Q?mRgESllRQjQPQgTrWzkVe2h/PfZHzRlJ3FLtK2XITMGXB06ms7mVJNHY8gFV?=
 =?us-ascii?Q?yR/sTPKsdRTCJDKNxDTPgI3yVL775URHKg3KPea2T7SKObv0yWF//yIHAhcB?=
 =?us-ascii?Q?fZH7Yu5CUHvhQdWBYG19kcATWwf1DEHpv40lLEelqnnl+aiUAoL+rj2+zN2f?=
 =?us-ascii?Q?fqn40kpFUUvlQ/3DFjGONb66BnFqRzRwQfNAFe8p0U4eTnRTLK03pu/WiPr9?=
 =?us-ascii?Q?sCCV1lllc4vTDxLO2EuzzIvFdFaKKBi1MsQtgSdjFQurNkfBx2Fa24fI8t/2?=
 =?us-ascii?Q?QT0IvHsNAwP+F69Ge3Zixd5YfAd+pANSg1eP9YDDd4FrYeYyAA+3ww2VFQsb?=
 =?us-ascii?Q?4HZjN1hGh9MdJf5CRy92L5AZ6Yoh0i7pb3Wh6zgAct521/3VD+k7Su/VSNOc?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c47270a-9961-4882-3ba7-08da8ea7c4cb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2022 19:00:44.0557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mENISLC2naGBm67B4iB8V6e0ynD6G/HSu9lqdz1+L0lbpgZAmNPdjj3g1RrQruLXIbbl7J2ZExL9uLic+Iibyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8932
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
This is semi-RFC, as in: pls don't apply yet, because the kernel patches
weren't merged yet (according to feedback so far, it's likely that the
proposed UAPI won't change, but still).

 include/uapi/linux/if_link.h | 10 ++++++
 ip/Makefile                  |  2 +-
 ip/iplink_dsa.c              | 67 ++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 1 deletion(-)
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
-- 
2.34.1

