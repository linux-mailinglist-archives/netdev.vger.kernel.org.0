Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94BF46DE68
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbhLHWgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:36:23 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:31041
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237412AbhLHWgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:36:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbI97YC7NCvdAqkSSBVi6Y8jYysSLBrSddvQkC+xeERsZnbyMyg7dWZsl+9fHTLIvlhXF5SO5iKYcZXZxv2n2+JgKs6RLsvfIV4QBLtB6w2C7wYFTa+5XsArwcyIdaQGgxAkIA8wYCjMH3SgZPMHTb4+bL7tfBXMK2VfP5+m79kVcFqmrO7pFNjGC6sxmBR06N7TORfmEWdM9T4lI0uiueT2E4aEoPOix3PofXBZEM1EVTmP+BFo+BI2g20gl6ayWizeAZY6tZ4LKmhIXM2/r49N3NAovy0a16pzkOaHIlJ58igVlIEXUhoDbZtm7qjI+6Jt77Uwwr8KUuX1CKecWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9U+s/vg39JdezaDx5DtCHRRdpQNAyfi6ueP1h7siMNo=;
 b=fXVxNgeBN51AO82NqQMq9e7F4k5aCkHhRRmNkMulX9/J8sFM8iVj4Su8sQC8eLh0Z7XD4YOlzlB4kYMBtkLNWexOCb4HBH4cV69ujXMgIV8R9bXvM4PD38WeUQabZJ7rYY+/0lJQbJqAd8db8Cd4L5Xjq16SPKEE7AO1U1MijhGSSO08ZuWDKynKrrO0QgB8w8JZwLW4pqCtvOv939lSY6GTQDJmBTS6pMhIm+NAFcXGEIhKt2AV4FqW9VrVORJvqhngEMTrbvuOPnUgqChlCIJKP7Epw/O47wjh9XcvSGtTw4rWrKTFNnTd7MkJ2MYAgN3RoXE72uQgh20Gp04P8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U+s/vg39JdezaDx5DtCHRRdpQNAyfi6ueP1h7siMNo=;
 b=lXNtdeAb3VJJ5NZOP5IHDSAk9eGJYPisx7b7o7EKRl4GOkrDBeSQAwjdd1NUVTPDQ6lJ0hirJ6Y8K94KmEbxvOifVwfTtO2Pf2pEaVuQ6X19W7/mBms/ZyaLJy4GH14+FX4dF8Ls0InZXgFQnaMs+SjL05+sBDnbU6PPqkzqLL0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Wed, 8 Dec
 2021 22:32:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 22:32:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next 3/7] net: dsa: use dsa_tree_for_each_user_port in dsa_tree_master_going_down()
Date:   Thu,  9 Dec 2021 00:32:26 +0200
Message-Id: <20211208223230.3324822-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0129.eurprd05.prod.outlook.com
 (2603:10a6:207:2::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM3PR05CA0129.eurprd05.prod.outlook.com (2603:10a6:207:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 22:32:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f0337c8-cd86-476f-0448-08d9ba9aa905
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB340867D8DD3EEA56AEBD3B0EE06F9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E4wTmUxD2LB79L+yWsgZS67/P31JO2rtpOAPhymwOPdB7B1ESmGMcS1/Oe+SRxmdk/k0diYsvDEiXTRiDbPN2crnyk/KsKE7jXG+20tf3+5fdY4AYSxKmQfvRd+YPeNNFhHCdlPAYWO/OpA0iB2q3hQ2yAhIlaDSFsPQdE+m8Z+9/f5SoQthLpqgiKAOmrJq17azERTPPm+AGS4FLBIVQsdBlr4T92N8oDqiSKo4i6UcXMK7VCNJpKmjVuP41FmvIxbq5+qh+d60EpfpewuNqfjtUtd+wECIlKEjOS0ohcdPJwbkTe+PvhyOsWJVWEXjn6zwiQEkwPl+iz7rQmhRPkrJ2ctK1RYGmjfWBuPlmXMnsrJVfg6/mWVayOQHwG/bS//6rPnxAbDKG9QoP6zMYeVyoBqb2Zg9YMvACm3sS8TQxxoVI2o8dqSyUeEBSTE55hKhrHqOK8+ndgOB/aQjSfUpMNrmdql0YFMx0+Ip0k5CGLEXClG0dmEbWJ5i/JZqmzwbzP1w/PBBL07GjnaszPlTpvjDFBN6xw+9R2lRylCNYAWLZYudeCu68UHtPR9Ib9sEftK7kd0LzxlOTSgqYrCDdE6pA7i98CvIi+xmbDsc5282iquGyvXUe/k3c1I/3VWnhzO93I+8B921FshJ8HLVsxuk5FMP7z/R2eAX5MkivJ0IOjxAK+Ch4YNglv1Y6Fb7yy7yA5i1gSQniy/5Gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(66946007)(4744005)(83380400001)(86362001)(66476007)(1076003)(44832011)(956004)(2616005)(36756003)(6666004)(38350700002)(6486002)(66556008)(6916009)(26005)(5660300002)(186003)(38100700002)(8676002)(4326008)(8936002)(52116002)(54906003)(6506007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q4REQInXSMEzbihZ5nD9b+U+HKP4xuu4iuLy1kz4gXwb24+yrumLIZwXvJ1Z?=
 =?us-ascii?Q?Ftpm+Q88FODfGeNTCyU/h158P8iW555dETOyIe3U9Aprp/uCBFXpJwGD+Ayk?=
 =?us-ascii?Q?mfVrxRqvP1wYxkBSTfCfPuRIxS2fkZC8MOxTno96B4C0DVfwWHogCTocdIrf?=
 =?us-ascii?Q?GJzh/xPfOtYBftwQamqAP+PL2V2f6I+pMfZ6fnrtEZW+7AIZNtfD724idU6z?=
 =?us-ascii?Q?y1+uD+xBFUDyRt8lS2tGzikDBLmqxA7fMGfxbcnCPD4wKZ8AQPPMJWiyIrw+?=
 =?us-ascii?Q?5k2o0KZi1/lVYz8sYqoplr/5pl7vQge6c16/frvIgR95J7lEF55sHf7ufms1?=
 =?us-ascii?Q?pakkfT7aL679lV0FvpZSqY30rgCiAvy2uReoHrfo8JkU/LiG6Uexe2tS7lhb?=
 =?us-ascii?Q?Qq0Bi7C/f4H/P21DVcZ4x9RkjB9ErXkhZpBB9DrfFKevXPt5tYt2nQkTvRgP?=
 =?us-ascii?Q?P2KdmZkVEQOfbmoQr4S/KHUWRUT4t9ugkPeLVzJd1R1QSuh3Jrnjk+1YRDSo?=
 =?us-ascii?Q?QWC+scvWQZ8y+shBEMylZr8uywpLhntCvqHosLR37sePVPUvxKpJ+hQ+Mn5h?=
 =?us-ascii?Q?tij9WO3E4V+HYc1G7GbEscbUK6nbR3lcpLJaxcfLK8QXTRHsoOJHYBiAKM8Q?=
 =?us-ascii?Q?5mDqWDfJ2SKGBsJTQZpSTtUTbcd9X0DGd3pEGlpdT/U+scroHLhmdG8yjYIk?=
 =?us-ascii?Q?zzbNa11j9qfdULuQT2HEL2kWHMduMnYwxvgJAhetnwUQMUgAP0i73Va5gmLV?=
 =?us-ascii?Q?Z3UF83QX8zr7g81FUjAWIQFnztCGGXBmkLOAvwZUMQXCzscqoyDtAgYbM9Wz?=
 =?us-ascii?Q?9Z4enp/gvUl5vCujGWhtBWZTyCGcH9suTRjsxVVZEGopsZTku1tRF8fPlx8l?=
 =?us-ascii?Q?HStbGlkhzhIvCuN8yuE4SDgwrX5AaKmafkIplNn8+VYceO8z77C3BC3kcd9m?=
 =?us-ascii?Q?7j6UrJUQi8/C0/jo2OXEu7nvRUZCRPwjmv3xQpT8DxeSqLf0EsMFZ3hQiuhe?=
 =?us-ascii?Q?OQGCRpUHhk8ryImqnF6ni7QYGFd2OcKgKautjnSbYTjrTYaCAJtT7r5jam5s?=
 =?us-ascii?Q?adjGOHKFWxT3Ib1ByqvQ8JdUMLHCeluzH1bPotEXoNL0XUTlzjs6JA4SHgLI?=
 =?us-ascii?Q?ylzMmJqjwxFWJP6ZQpJGdak/ZKUF/RVwfAPzkG4CWHDWVsxJhJg4IumfBACt?=
 =?us-ascii?Q?BzyX6kF+8lSA2QfxB0STMF7N543Sre2U/a3xxJA97NLp3hJGszMHr3VXeDbX?=
 =?us-ascii?Q?UkRA9S8PLkZCcyGC41JRs3UvM+klsrHwDJ4zng3Zv7OxKXD4ayOarx0aM0fA?=
 =?us-ascii?Q?FfXTLcw7STba17DGn5bYGfSYZtHFS/LseMzk0+NgbEH0yHCyihMTgMRqd/I7?=
 =?us-ascii?Q?6IYFGvq6gpTYzefylj4rwex6eRcWrU8+ipqukAYch6SApHhs8SKN5MwTBlLP?=
 =?us-ascii?Q?UxI9xAWTkpRUGckCeb95mJQMxOqLNZevc1nDIca7m5pzHdGwRlo857Pm8jv4?=
 =?us-ascii?Q?vM8bESVmRoRy/I4JtBrAjT1/4iJj2Pzb1bhCywbnY7sCmbbINgWugTbq9RQK?=
 =?us-ascii?Q?kK1FHrB8xogfGmjqP2gYKwjYzDCf/1AUDUJK7xmTWgVPDQgpSB7qgCwzIm0Z?=
 =?us-ascii?Q?V8d8qmBpD5pQsL9K3ZQDTeQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0337c8-cd86-476f-0448-08d9ba9aa905
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 22:32:47.5231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXlIr06pjyLrQa50+E1ENicEMF2HqAFcjTY/ZWzZx/3cYtfSDO33wmo1EJYoEBJuJZJTXt9TmfhR4BzlGgexFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consume 3 lines of code by using the dedicated iterator over the user
ports of a DSA switch tree.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 438304a22e0f..9c490a326e6f 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1193,10 +1193,7 @@ void dsa_tree_master_going_down(struct dsa_switch_tree *dst,
 	struct dsa_port *dp, *cpu_dp = master->dsa_ptr;
 	LIST_HEAD(close_list);
 
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (!dsa_port_is_user(dp))
-			continue;
-
+	dsa_tree_for_each_user_port(dp, dst) {
 		if (dp->cpu_dp != cpu_dp)
 			continue;
 
-- 
2.25.1

