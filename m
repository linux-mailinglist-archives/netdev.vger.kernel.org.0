Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B1E2C423E
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 15:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgKYOg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 09:36:56 -0500
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:6761
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725836AbgKYOgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 09:36:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgOL16yGKnEZiiWI70oxulo28mCHi2SPmCwnabY7GkEsckBETaUYlo74vMyM6qGXkzsejoG5Y9RpENP2rvFQWNzhbbzWBq0HtS+CBpE0aUzmKXEa8c5RhsayFpLqQdziv7Ev48lN27lvUN6zsP8GODU+KOt/qbUsavAzK1XhACt4HqjHrvIiRPTuQ/vKu0cY2WguC5SpcZwPq7qGvP0rCc5TghI9l7eKLC+FP+FOEsVVChKPevYeuubGbO8dQ5LKNK4I9sEOQ62QrkeOVZQeRPaXkZtqTlEIjUVBYXNv1JXdAAf1FIdPQOXV+QC8BO8Pwhadbd24cvYCOYKMtWnd/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEYeE04XSSyB8Pa/l5qZbweShqnDyFelr/81qnQIwuo=;
 b=BS4LGPmGXkBbD63GVm7mEFsfAE8wOjvTbzXdGyc2rn0OSaWl/hWb58AEf5fMRYaKn/o5MiG8EjdBhbtbUiNHWV/LLBV2DcwE04X4MP6PvR3tCtBT2oDtojWcrwgGaN6lwiAlVC4tQQRYxkgpesjg9uZiDIl0PE0bpukDVvTHJy2q0UF8i2gaiYwGAa+shtB5rvSL3Vh2SzA/CMaQcKh8fDUQkHziGhn7WXFldEOhK5kPVEKbjq3vh5tLmQS2yvG73MyC5614/CZQqrYqoU2zbkthPVC9BFeI32Pzy8HRe3esTMl+XzlEwQ/Qn9/Xt4EM/zGrAj8oqz3Aj7e8ZDvdnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEYeE04XSSyB8Pa/l5qZbweShqnDyFelr/81qnQIwuo=;
 b=Rz1s6bx6WwEYmDv6sodZRRt7wsdJ4KKg/31JhE7wx6PanAr8xeP6mGFMT5f8CXPo9NDfuuSUZAO9KRmbJrWJyFyVvzlOVUErg43RJLYVINLCKYE3X3YTqNIbWffdm+tUz9sZosbc0I8OFWfEEfOGdOB0/5hpiVK4AafgzEgIBrM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5296.eurprd04.prod.outlook.com (2603:10a6:803:55::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.30; Wed, 25 Nov
 2020 14:36:52 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3589.030; Wed, 25 Nov 2020
 14:36:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     David Ahern <dsahern@gmail.com>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@resnulli.us,
        idosch@idosch.org
Subject: [PATCH v3 iproute2] bridge: add support for L2 multicast groups
Date:   Wed, 25 Nov 2020 16:36:39 +0200
Message-Id: <20201125143639.3587854-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM4PR0302CA0027.eurprd03.prod.outlook.com
 (2603:10a6:205:2::40) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM4PR0302CA0027.eurprd03.prod.outlook.com (2603:10a6:205:2::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Wed, 25 Nov 2020 14:36:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f79cd0c-a985-4a99-2a58-08d8914f8c90
X-MS-TrafficTypeDiagnostic: VI1PR04MB5296:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52962E1E2003991FA0A9B23BE0FA0@VI1PR04MB5296.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zl8Yudenp38KgWJ9nMy5XW8CzxRcuRyRYV23IiyKMLSdZJbhZfQ33zz+7IXtGLBX3xpfajhY6oR8nEzyBKzvAmbqL0Ae46UzOwiHwy6/HJ4NNA/dTswZkC/ywT61pc43v8Sk/8TLJ8G47dhu7XdqlHMz9mXD6rqZDFLE9SrFRBI9x2Lwjj9PHwQtQLOB9z8s9w1yZUOLIOrk0blR2Jot72y6thxkTfNA8JCY6HRrA4C/SyVAakiOKRrgjBrfle9y7QUm/mTnWJrZuqblCeMIqgMZUAAaz84jLxQ3jWtxNYEpUWMpI5SmtN/Tuv5Whj/P3+bDOSKpIvUy89IQgtcrzUr9vBfQm3BaC0SupocH/SdiDmI8oxWUY1nk56xXi2w4L4XoaprfAJC4QiFSQpyYjrNu2mfRjl64ZFfzoFmEbc7hgqmY6deR2lle1yvVT2IbnniLKJpUT/TkD0zcH7bKxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(8676002)(8936002)(44832011)(69590400008)(2906002)(186003)(16526019)(7416002)(956004)(2616005)(26005)(6506007)(52116002)(83380400001)(6512007)(316002)(110136005)(6486002)(36756003)(86362001)(66946007)(66476007)(4326008)(66556008)(478600001)(1076003)(5660300002)(966005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fvAoPWrTC6zbjuHLLf3DZdQAIKHRUk6pAj4ofBmDPrHElI4CqdrAl+JROSYa?=
 =?us-ascii?Q?a/mSLEKmGQcL5HR4aK4qEl/caAhEEcqkEXiCeuSJvwVJnCeXCLxGbp4Tjpa5?=
 =?us-ascii?Q?aRTLtiOXb4kJLgVU1c8ronfGRwg0PObXIwc5U5clDxpU33P9Swv74gLYw0u4?=
 =?us-ascii?Q?KEGRj4f2RVOLz9F1BtI2oTv8QTTBU6gLK0PT4+Qz1LT2OPE5CyW3jzNcUZOs?=
 =?us-ascii?Q?hiljL+pCLrj2l2vzYtzUnwrAhr6uwdxqmigqHi/GlEk74o0U0rSJjKWDJlVW?=
 =?us-ascii?Q?0nDMNYTB7dn4lqrGANWqd9jplJkhF6HAOCMNcRwab0WhMjczAEASm6A9MxfU?=
 =?us-ascii?Q?VeqZeqJytME2mp4BHMIaEv+5FPQIfZrjjB5ZhU2GtV5pITnxqOaFXs/qK0Zk?=
 =?us-ascii?Q?rxG2fVDlz0Nlt6B8N33ICsrQ9BuGCr1uwLNzdkG1g49sdwHku9lSm8n2WV+O?=
 =?us-ascii?Q?/lEfhTB4tzbfvmWXkmgNpevNuCltfLhO6b6l0x8WKDN0KJ0+b38H9z7dtyy7?=
 =?us-ascii?Q?lUnL7xT5Hg2aSc4Zai+n3Bm0N9hs7srEqBzFb7qMnnU3UODSwQf6atIWSmvA?=
 =?us-ascii?Q?uxqC9G4/yLcEMhWaGJ+PfUEupzkv77tzJtvZsay/fLWS4vdu52Pot6kDpohB?=
 =?us-ascii?Q?LfK6xE0DKK0LZNQYMdhO8ZVWQHrlSp1bie6YSYHUGK23W/nM4X2VeueY1DWD?=
 =?us-ascii?Q?+0sNBUZEr2Bwxkh5BjmmogaaIugUlbwNEvdmWUh3GhRdwAjPc36O99IXBs4m?=
 =?us-ascii?Q?HXqNFlBG4dK0nwiqSb/GnS75/2zRstKZ7qydXuRFh9Vi67BzyuO48ahawotZ?=
 =?us-ascii?Q?jFPI2sBIM74bLdsFlTMM83RWXReLu7y0yHNLbLc1hsXDppLniH0vF2t5C3l6?=
 =?us-ascii?Q?8trRGGna+87gGEgI7hNBSPiqqSoIsCPizc0CnDTKPRF/GO1L1mubmiqqkYSB?=
 =?us-ascii?Q?6mRuCfqDtqApEBK3k6/t24roS56YSpKnDx+vXhFfe5eoR2ZYojcR4XEKsqmf?=
 =?us-ascii?Q?eZee?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f79cd0c-a985-4a99-2a58-08d8914f8c90
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2020 14:36:52.1946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYtjyJ3PKTg3yPXeOWuJqQT6X3LTANQJmhLKDiR/zL5GcJkhmjfD+PLYxYyHiGO2s0rbIbVde4nj4Mj8kF1Zsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5296
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the 'bridge mdb' command for the following syntax:
bridge mdb add dev br0 port swp0 grp 01:02:03:04:05:06 permanent

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Using rt_addr_n2a_r instead of inet_ntop/ll_addr_n2a directly.
- Updated the bridge manpage.

Changes in v2:
- Removed the const void casts.
- Removed MDB_FLAGS_L2 from the UAPI to be in sync with the latest
  kernel patch:
  https://patchwork.ozlabs.org/project/netdev/patch/20201028233831.610076-1-vladimir.oltean@nxp.com/

 bridge/mdb.c                   | 54 ++++++++++++++++++++++++++--------
 include/uapi/linux/if_bridge.h |  1 +
 man/man8/bridge.8              |  8 ++---
 3 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 4cd7ca762b78..ef89258bc5c3 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -149,6 +149,7 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 			    struct nlmsghdr *n, struct rtattr **tb)
 {
 	const void *grp, *src;
+	const char *addr;
 	SPRINT_BUF(abuf);
 	const char *dev;
 	int af;
@@ -156,9 +157,16 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 	if (filter_vlan && e->vid != filter_vlan)
 		return;
 
-	af = e->addr.proto == htons(ETH_P_IP) ? AF_INET : AF_INET6;
-	grp = af == AF_INET ? (const void *)&e->addr.u.ip4 :
-			      (const void *)&e->addr.u.ip6;
+	if (!e->addr.proto) {
+		af = AF_PACKET;
+		grp = &e->addr.u.mac_addr;
+	} else if (e->addr.proto == htons(ETH_P_IP)) {
+		af = AF_INET;
+		grp = &e->addr.u.ip4;
+	} else {
+		af = AF_INET6;
+		grp = &e->addr.u.ip6;
+	}
 	dev = ll_index_to_name(ifindex);
 
 	open_json_object(NULL);
@@ -168,9 +176,14 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 	print_string(PRINT_ANY, "port", " port %s",
 		     ll_index_to_name(e->ifindex));
 
+	/* The ETH_ALEN argument is ignored for all cases but AF_PACKET */
+	addr = rt_addr_n2a_r(af, ETH_ALEN, grp, abuf, sizeof(abuf));
+	if (!addr)
+		return;
+
 	print_color_string(PRINT_ANY, ifa_family_color(af),
-			    "grp", " grp %s",
-			    inet_ntop(af, grp, abuf, sizeof(abuf)));
+			    "grp", " grp %s", addr);
+
 	if (tb && tb[MDBA_MDB_EATTR_SOURCE]) {
 		src = (const void *)RTA_DATA(tb[MDBA_MDB_EATTR_SOURCE]);
 		print_color_string(PRINT_ANY, ifa_family_color(af),
@@ -440,6 +453,25 @@ static int mdb_show(int argc, char **argv)
 	return 0;
 }
 
+static int mdb_parse_grp(const char *grp, struct br_mdb_entry *e)
+{
+	if (inet_pton(AF_INET, grp, &e->addr.u.ip4)) {
+		e->addr.proto = htons(ETH_P_IP);
+		return 0;
+	}
+	if (inet_pton(AF_INET6, grp, &e->addr.u.ip6)) {
+		e->addr.proto = htons(ETH_P_IPV6);
+		return 0;
+	}
+	if (ll_addr_a2n((char *)e->addr.u.mac_addr, sizeof(e->addr.u.mac_addr),
+			grp) == ETH_ALEN) {
+		e->addr.proto = 0;
+		return 0;
+	}
+
+	return -1;
+}
+
 static int mdb_modify(int cmd, int flags, int argc, char **argv)
 {
 	struct {
@@ -497,14 +529,10 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 	if (!entry.ifindex)
 		return nodev(p);
 
-	if (!inet_pton(AF_INET, grp, &entry.addr.u.ip4)) {
-		if (!inet_pton(AF_INET6, grp, &entry.addr.u.ip6)) {
-			fprintf(stderr, "Invalid address \"%s\"\n", grp);
-			return -1;
-		} else
-			entry.addr.proto = htons(ETH_P_IPV6);
-	} else
-		entry.addr.proto = htons(ETH_P_IP);
+	if (mdb_parse_grp(grp, &entry)) {
+		fprintf(stderr, "Invalid address \"%s\"\n", grp);
+		return -1;
+	}
 
 	entry.vid = vid;
 	addattr_l(&req.n, sizeof(req), MDBA_SET_ENTRY, &entry, sizeof(entry));
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 69b99901fc5a..db41a5ff34af 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -526,6 +526,7 @@ struct br_mdb_entry {
 		union {
 			__be32	ip4;
 			struct in6_addr ip6;
+			unsigned char mac_addr[ETH_ALEN];
 		} u;
 		__be16		proto;
 	} addr;
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 84b9b70c7dea..b3414ae31faf 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -665,7 +665,7 @@ the bridge to which this address is associated.
 .SH bridge mdb - multicast group database management
 
 .B mdb
-objects contain known IP multicast group addresses on a link.
+objects contain known IP or L2 multicast group addresses on a link.
 
 .P
 The corresponding commands display mdb entries, add new entries,
@@ -685,11 +685,11 @@ the port whose link is known to have members of this multicast group.
 
 .TP
 .BI grp " GROUP"
-the IP multicast group address whose members reside on the link connected to
-the port.
+the multicast group address (IPv4, IPv6 or L2 multicast) whose members reside
+on the link connected to the port.
 
 .B permanent
-- the mdb entry is permanent
+- the mdb entry is permanent. Optional for IPv4 and IPv6, mandatory for L2.
 .sp
 
 .B temp
-- 
2.25.1

