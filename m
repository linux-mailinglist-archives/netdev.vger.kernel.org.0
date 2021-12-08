Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF7346DE66
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbhLHWgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:36:22 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:31041
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237299AbhLHWgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:36:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n648H9OB2vunok80iTyTGrJvqWgU4NXgkW+iPwiSjbxp0KgkYlWLvEGE9uzRjC9ugvlnFEOwaIjG7+93GRaKFTZcM++GsrgYrTNXr6XaxKkcgcJZsdJyaUYaAm/L7rw8v0Hp3Xx4gTx183697/hVqVqlg5rnW94vepy/ttrLxKCSIl251kcdx8NajzrIRpTMdIxQZHMAYFDZI2klpxFXRH/O1sUnCr4dsA6MzMU33vwuupkKuCpbeTj5fXqhTQAZdZyrHueSP/cOJtpkttf8nsxTEdIptDJvmAVuZh1DgSdMP8jaMmL++0msRNCZtcdDmqo66+/nmdrTNK4hlbDKpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4O+80PD0bP/niRIAtUFqFX1dRh1ME2+spWLwt09PY+I=;
 b=lsNwISMc45yYvi34mFmauTLlpbH2xTUP24QBM9boYuBWsliHRr9RYIpF+Y+0zZkl/4YlPjwmlIb7VEp21wJLOn+3flIcOazs0Ka95b+v3lHaOnI+2IjQ2REYGHVRBFV3PDUlKghQ63spCdyFdpwZKGi1tcpTe0XUVscRsb88H12e96uxsVBVFNWDjILOLh6Jb6MaU7GQbcHJTWeIkBRISs1jWvmbtNF/jx10zWeVKGiEzddrlQ3veORhY/EeGfB+iZBtrAFCCVnEGzJJqM7e2xjG5scmtbVjBvowr/9iPxpFXi34fu5nAqAplakT3i/5bPQFRUXFH05lC9NoYYXzsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4O+80PD0bP/niRIAtUFqFX1dRh1ME2+spWLwt09PY+I=;
 b=ibosRDdXr+bqhqcsB3aq6WweBM/ixlzBR6skV3FC/79kNzWkjUK76kg2NJg2nAVO0kBPdTyqpxW9VO/CGB8OuGP1yXezxYFm6hgjMQrwr4YqsmyUOIkF4zv71Nyz7bsal9C92DoLhDpNz+V9t4JTouavoMOvfNGIn8i06gcgs+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Wed, 8 Dec
 2021 22:32:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 22:32:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next 1/7] net: dsa: only bring down user ports assigned to a given DSA master
Date:   Thu,  9 Dec 2021 00:32:24 +0200
Message-Id: <20211208223230.3324822-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0129.eurprd05.prod.outlook.com
 (2603:10a6:207:2::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM3PR05CA0129.eurprd05.prod.outlook.com (2603:10a6:207:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 22:32:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 270042ab-3df9-41bb-f334-08d9ba9aa7a8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408A695DE2DD567BBF6029EE06F9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YDkmfemBL3DmLyTlJQ+lIaftaCAaOoBEqZ12GSJQidn6yGY8MZv08o3YLqd3BqaJ9YOp8EP2EALnbaPuTIig6EBJfxmxlcD7p55qzw56Y9GzEspscsyoJCU63IJf308mnzdJXTRqEk0yApjViAI++26tUtB1pcrC3yDiG/ogDS9UgKAb1SmXtaalUydcprQXB8BUjDmgB1IiDdUEs8b42cgqC4RToIFwfXufh5oA/13JRN2DDpQUVM3JNoOU06a5JCXozgBOcKQWLes0mGKlA8Db+driZT4Z3fTDKWsOP8Rca4lty5ZRdXRBxvRyGHyoCz0hdo7K0kZACQC5btAf6XDwdIrCJMZpHxe6rW8rZBF/SWYRUv9bSx3NF9NWqYcz4p7lF4+rggjcr1tYSfHxRy9jKnX4v3aN73yHOvVeVLw4ONCyBRIm0ZvKt4MeOdtSWYNczUQpZhvRJTqgkQUhCe/iFHH8u4CtBSPqFNRj+8/4nimrlX0vwHPATZBpx5r7r62wal6nTcWJ0DDVOEfYP7q6wRjX/MkoBST9uI3rUL1/wY1yH3tmC6YsgBRGCbAzzMof+xcgDC7HK2UyxKCNgTe9aZQiywZ8DCMyesiTp9UFVn5KyjsHHXThqNrtAULgRFAGqnnf0z0U8OjIvJcCIQMEno1oAk2XvCItwneWNpN5RkYDBtLwvBTW7traK1T+BIMseHjN1DhboTcuN2m6Fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(66946007)(4744005)(83380400001)(86362001)(66476007)(1076003)(44832011)(956004)(2616005)(36756003)(6666004)(38350700002)(6486002)(66556008)(6916009)(26005)(5660300002)(186003)(38100700002)(8676002)(4326008)(8936002)(52116002)(54906003)(6506007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pAyXJHUd50P0Wsaxo2aFPqvjPs/XW37Pa53/dL9Xn0yO6edlLeV77191wG1s?=
 =?us-ascii?Q?6U6B874gl7aaYMvzvxiN13qty1Wu5VrfxrOLq6RbivedRsqlEOdUMsvdrLxE?=
 =?us-ascii?Q?gPLcrvMbG+BEvEDvJcZVz6jr863+gQfzKFtLRswBy/ey9SvYV6EXvTU4Igrx?=
 =?us-ascii?Q?F0QLB+8RUJ/jCuPuzyaORVOPKz0qwb0miKnVSnhqKm+PIgvu42Yji+JNevGF?=
 =?us-ascii?Q?kZr1GexgQXq0y1iaAHfQTj6pA3r+Bd/3YiuPjpwRMTY7B8EUzkwjpmD79RQj?=
 =?us-ascii?Q?2SACLgtfOym4ZJVmDZIrqYthqbcfpSkxy+P86eArBHUcK7SzoZNMixtgTulP?=
 =?us-ascii?Q?OwikZ94lfwnh3JqfQWHXXp6s4FjhcLQ4Zckavj6BgBWj231Aw5jQmmjy8umL?=
 =?us-ascii?Q?kAS2rNjQnwQBBASNCC91ZxDYBwQgedNVn2ruBNK9W4YRNcj6KgUd8sHXvhVs?=
 =?us-ascii?Q?p8cH6DQGJePx1H5E4R5JN3H6wuyJEs6F0S0BAQM2Wt0Jm2AzbTP7L+EqkGiV?=
 =?us-ascii?Q?9rcWtFVs525pS5p1SWOe+iDxMdb+SeRrNbGVQQfoKNIRtLuE9OENpLNDvyE6?=
 =?us-ascii?Q?mn4xIjr7y1xevz8ucf7LNqp89zy9uWEjqmQtOpeFvkMmy5qH5ZQpGnaYNZu6?=
 =?us-ascii?Q?b4qF2zgyo6/bbNFKGJqun9p1YYWBnhAkFtRVTb3IilNpYU9y1jZMfZtjS3uN?=
 =?us-ascii?Q?UpDzp/4Su87rSMIzG8XpZyDOBJOy9O7pZcrcjssrutkdR8TGEV4CjePlmAHQ?=
 =?us-ascii?Q?gT46Y8AJTN/xvSijsS9UiwNnyOri0rU0e+n36dp3FJ/KS/rxdMorG19WzWqt?=
 =?us-ascii?Q?dh6ZvU4V5TBnbvFbsAGQpr9MzvSZ23LbQlzhkqw1Agjaknm03COVfSMA0QpF?=
 =?us-ascii?Q?5+fXm/wFjDETA0XdL1mb5H5DqpKenyCn4Jyyb676QtVvdZ1Fh7LITRWPvlc3?=
 =?us-ascii?Q?iaJinJ1JEIYqqEJRWi/CDzTpO1vhmnOg8nstHN22kkWDhAeEWmvYqb+SK/tn?=
 =?us-ascii?Q?thVq8YcqrOwnyjlp8RIPHbIi7jk1svFSt6ySjF3N7TW9yr3Owd6lJbUvKt2c?=
 =?us-ascii?Q?ri1kucyi1rPCEfmxS5HGgwDlYBRLgHPuqVFip2z/20NOcGYGHp7/wM4t3Mde?=
 =?us-ascii?Q?HZ7SONd8CrGvYyeZCaBiYDlmi0SJzBcPRpaQFDDiBqk4YKAocyapIA6uD2KI?=
 =?us-ascii?Q?L+Cg1U41wpsWFdv6SFfqHzigKcBepwlE0JHA+3G1QzJcvxZn6Hg2Hm2hEbRI?=
 =?us-ascii?Q?CRWkmBA8ib18Xv1e6/z06B4sUJLjkXCZaB4kyuXKqh0UzF8RJc9+J8XJYGPt?=
 =?us-ascii?Q?pTPJMar1lbeN5NQAmSIOgU07qra8rbY00Pa/BajQB5w53jVNzEbvqmbnO4P0?=
 =?us-ascii?Q?oVsT9+raE2TdUzO4pOoMffoApjtsJv2DIBQZcz6/l7gp97dCFpDzs8Ti89EK?=
 =?us-ascii?Q?GMn+F1/CVXUEDKy/waITtXF7J/frOn4qRn5aDfK81anE6KP2BFVEMMtMjCym?=
 =?us-ascii?Q?NelR3K9EVxfEp+tTW0w2sxBuJdONLKJWl52Nz2xBEgL1mK0i6Cxs18JRgC0M?=
 =?us-ascii?Q?BcVrUrqnBP7Et+8nuNXyztguv/JerWBC1kpcM0JFXdaiINRfBfq3wltiCSxb?=
 =?us-ascii?Q?F72c1wp1QNvWgOH6lSHEytE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 270042ab-3df9-41bb-f334-08d9ba9aa7a8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 22:32:45.4451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PzYmcohCZDxNIGHigB++jCedaHTRGp0VXI6IY7GAcZaN38JQkpZBvNyCgEOpwjP8u1DQtR/hg0IV6ywGpRyAHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an adaptation of commit c0a8a9c27493 ("net: dsa: automatically
bring user ports down when master goes down") for multiple DSA masters.
When a DSA master goes down, only the user ports under its control
should go down too, the others can still send/receive traffic.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2b153b366118..f76c96e27868 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2364,6 +2364,9 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 			if (!dsa_port_is_user(dp))
 				continue;
 
+			if (dp->cpu_dp != cpu_dp)
+				continue;
+
 			list_add(&dp->slave->close_list, &close_list);
 		}
 
-- 
2.25.1

