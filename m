Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFFC2913B9
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 20:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438737AbgJQSpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 14:45:46 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:10740
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438712AbgJQSpp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 14:45:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GOZidVpFuOq7sVHzOKryxj5yPNcDJ5RXWuC3DhAqKp+dWxgMnV5Q7xqo34RhEHW/keQwOIhiGtPOerAz3iyNnHHgV9om2t0RobnaTMb50tYPyRhvNZB9Jm+u2k5fSbW9A9TY1Pe7GA5VCIiHTdtr7bGbpPe6swW74C4vGnK2CfkVLw1onRYszggFzcU8xBHL6KsXzC5Eg5oG32vU7IOlpQyO64imdIz8xhbJKDNdAeUndMu2uObS1OIlmmErjukEOwpf2VFhMoca4jZ6G3TKDA8HYIlbIqrsIbl3k6HuAvC1K/dRpPspu/qj5qo3sqImHz2Wss1xV4fSwYY/lB9N2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uphQ8c1bpQF8v9/MA3eAA9rKY6e/8TWw6lk6SPdpqqk=;
 b=f4TUHZkq85Z5YCqIdWH3ZV9nSyPAhf9pn8VjMEToZj3Gegyd9L3Wx3n/Qt38IGKpQBS5rkMYIzL3iI6WP7wcEmXTiBxPCCtxogLxv/hjxbiHENi3Ly9bLc6G3Lo6QI2mMytkbMjSql1KF2gH+Y1pEXVAYhn+o4BLbRHnjJXiM06yuOvGeT8eIxnQ9yz58Im//79sMKF/lOtc9Dqw8xCXsEogXIULXrlFdDATYOG4dlEcUQmfomn2ErzO8wnvNoCldUhc68bqcAhketKBE248wrn9L3/Qz42axxTUHptb83BonaaitAYjkh2lL0XhA3e+k3fKysAm419h5bx8ie7YIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uphQ8c1bpQF8v9/MA3eAA9rKY6e/8TWw6lk6SPdpqqk=;
 b=W+QZkQ+B3jxPquIauH3yiag4ItlihTn6WxdsVOBqysZLCqmMzwKMxDi7WtvcTuyfrjri5Zrx8/YVU+kRKOKaghwKad7f7QxbUHK/uZMMXoZxQP68nUJjYAgsq/j3TxVgXORsLpbCIVL/YICfyjjWuH+EgpstnAb6xkdD7x5UWmA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Sat, 17 Oct
 2020 18:45:40 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 18:45:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     David Ahern <dsahern@gmail.com>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@mellanox.com, idosch@idosch.org
Subject: [RFC PATCH iproute2] bridge: add support for L2 multicast groups
Date:   Sat, 17 Oct 2020 21:45:26 +0300
Message-Id: <20201017184526.2333840-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR03CA0049.eurprd03.prod.outlook.com (2603:10a6:208::26)
 To VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR03CA0049.eurprd03.prod.outlook.com (2603:10a6:208::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 18:45:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 331a89dd-56b5-4cce-39f9-08d872ccd868
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2304B4E484052748FFCA151EE0000@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:291;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tBVDeHbI7YOnj+kouY3CZNAiRI7fJ4GsJeBTnSi3gKhyPvyastu+snR871Wh7hb5LhBJXZJgTQQgfR1P6f6vgfIU4QfAFI5NIDBdG2qCf7mEFzGxaIr7mO9eppcVz8wLO2cmWo+Rkn1iDEshjozLWMJ85o/WWJK+dTwsThv/BwSAHzzLuve3LWSePURM8PCuA+RPEdxfR875mxNmWC7t18OTpqgLJJHlboe9u/zzCpMR/sZ2RiA213d7zPgP1bzwhx3q/57WmMrIey0i2Vv4xdx8axueXcRehu+dv794orYANyqQAuCs1v9/EVn2votbLpt0vGrctDZ9Mu3eROKRGmE7a2FLpPyed2XvboDWOg+e1A9JLOg/GHs/xq7vUFV+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(396003)(346002)(376002)(186003)(86362001)(6512007)(6506007)(66946007)(52116002)(66476007)(66556008)(69590400008)(83380400001)(16526019)(8676002)(26005)(478600001)(36756003)(7416002)(2616005)(44832011)(956004)(6486002)(5660300002)(6666004)(316002)(110136005)(4326008)(1076003)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rQOJIm6+paYkrQqMg8p1MuIdh3g6LXapYsHj4DrOVeyXXhpQQbxI0/2nKxi7v+6AJXm/KODTPcp0ZNBjKwNR5eBqpARN28yu1YGtnT67310PS0iae2IETwFpCFmlndTYDvXTnjbBiMnPt/QVnTnhuC+Nx6qX39UYoOgHTH640wjjU4jhzxTOmgMLziCdGmHRaN0Z0FC7Jx/lPyZoDkSHWeMIPzXPj4SrQUmwrWdzB8SuNV1Az+tJPxMBe7uefq8vlS7sJtCu6x9t1X2u7UZ+r/rQ+6QbSfe4t8ctHW/oQsrQ6oM/fQQSeF2FwqpvK4TNcsyW6JxuB+RlFlEYbigLQub1ItS3x5773KIeo5dKiBFsLCijZr/XLFHKZI2WkrCxz0Jod6usg5ChUz4m6xNmA6n5HCU+Lq6whKAMz8mMqtUErYFuHpTikZjjfZjEwvgaIMQUYtnrLQYZ3dOhQTSFA2cCCXMesMsVhepFfly2+Ab/Gg3l0vhDDdh/LFIUNE2uAFYoyRExUZ3VWfxgc1kuis9D6CeERBKSLgYMTJdNYDwxLhGBvXxLV8kC+DGJ5zvfmHK6lhVEDbRJY52frj+3haaG6jjtlIGpS82D/IHJZCNqz4QwsLbe7DHbzolxci3pgaHknF/ARCZwznqpo+r6Ew==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 331a89dd-56b5-4cce-39f9-08d872ccd868
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 18:45:40.4388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RM2clze+eQvs0L9xWbpyZlV2r6mmk0UlbdfSfsEHi/+USVpSdIWPhRLOVx6C70AXsF7bneDIRyK29Lim4OKdwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the 'bridge mdb' command for the following syntax:
bridge mdb add dev br0 port swp0 grp 01:02:03:04:05:06 permanent

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 bridge/mdb.c                   | 54 ++++++++++++++++++++++++++--------
 include/uapi/linux/if_bridge.h |  2 ++
 2 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 4cd7ca762b78..af160250928e 100644
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
+		grp = (const void *)&e->addr.u.mac_addr;
+	} else if (e->addr.proto == htons(ETH_P_IP)) {
+		af = AF_INET;
+		grp = (const void *)&e->addr.u.ip4;
+	} else {
+		af = AF_INET6;
+		grp = (const void *)&e->addr.u.ip6;
+	}
 	dev = ll_index_to_name(ifindex);
 
 	open_json_object(NULL);
@@ -168,9 +176,14 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 	print_string(PRINT_ANY, "port", " port %s",
 		     ll_index_to_name(e->ifindex));
 
+	if (!e->addr.proto)
+		addr = ll_addr_n2a(grp, ETH_ALEN, 0, abuf, sizeof(abuf));
+	else
+		addr = inet_ntop(af, grp, abuf, sizeof(abuf));
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
+		e->flags |= MDB_FLAGS_L2;
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
index 69b99901fc5a..0a45ae978a55 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -520,12 +520,14 @@ struct br_mdb_entry {
 #define MDB_FLAGS_FAST_LEAVE	(1 << 1)
 #define MDB_FLAGS_STAR_EXCL	(1 << 2)
 #define MDB_FLAGS_BLOCKED	(1 << 3)
+#define MDB_FLAGS_L2		(1 << 5)
 	__u8 flags;
 	__u16 vid;
 	struct {
 		union {
 			__be32	ip4;
 			struct in6_addr ip6;
+			unsigned char mac_addr[ETH_ALEN];
 		} u;
 		__be16		proto;
 	} addr;
-- 
2.25.1

