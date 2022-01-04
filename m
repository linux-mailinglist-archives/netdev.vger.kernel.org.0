Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910514846CE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiADRPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:15:11 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234215AbiADROs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpFpVlSKvLyb20liMZSh7dRmYyfQd5OIt6CSq6mPuXpCPkjrmrR0NQuJG2Ot1AZV714Wpf7U+27uTyC+B9nIkOh5iyQYh2ZcSVD5DOcv7eEAl5ZNzU4VmB97znxyqxvfguLUYJkc5KyiA6gMvtEBMDZEjeU/+/QxKFv4EVFMadM8+MNK2a6+lOSCplU0axdXHpgwkuhLvvMJOq+aY9pK8v8XU27nGpk6f9KpF5St/xkCvjlIGAnm6/773IDpwjS5isjzxXIZTMq5d8zwyD6TRiREJqWY3pn7KjCrhHcjdLnZXx8kuRBjnQ6/e4G0TaGtB/V+Hy0IL7luK9k2oarhBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVes2I22LqyvIMkv7l6UANxjhDHISZ2RgZXPj5KUsgw=;
 b=OycatTFnjBZOR/zi0p2zn0WrHvmQfNqzpFqtBo0s06Lq/mxlYLWcoHlCFqel1jwHS5pvkahGthwG17prHmVrnFuJvUTYIx+lxSQdwZqLzafixJLgjG+/7rEe6pmyByfTahJTI//YE0jgZGN0NESPH/5jd1hDeslNpl58Ep762uBv8EKoCkjCCIuuJrbVIKTAmTNZCNcapYfiNnuvewCduNypZMGQTbAlm/OIAi/d2XSImDs6vrBHu+p5dgUimGwoBM92jHIKEAvmNH0LRqvumDNB92fOyBzNJfaVBQ4HwklwFa8iWHqfcy/HUBGSXD/M97SANkubyNwGmcDbylQKrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVes2I22LqyvIMkv7l6UANxjhDHISZ2RgZXPj5KUsgw=;
 b=BUNtWG+TXDrVUxuWZW7oWVVqFVGBj0/VvWIUJhcHyv7X+Kf3dfjF4ncAQizz40E3gjzVJ8JhmQflueRfkn50qGhVeZzRlOkDCFu1C5ePy+9qlI/Ilo+s9M8bhFNvPTxbI8btr1jqivD6eHkd3F0wTVuM0H+Fj2tO3f1xju6x9ck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 14/15] net: dsa: move dsa_switch_tree :: ports and lags to first cache line
Date:   Tue,  4 Jan 2022 19:14:12 +0200
Message-Id: <20220104171413.2293847-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
References: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0192.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 813a96f0-7f00-4917-b48d-08d9cfa5b2fc
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104FE85D4DF775251D574B4E04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A4r/fGW5aAznRx3bHHStUmmwg4eZi/4jdMztvQmReVItH2BFPNLv3SFDFbvbfR5Xp+8icchcwET3m4s29bDzMd/PodCWzLMVWmVcGMVsvSwH7BjWpYKtmZNv6Hr/Tqjgw4bulUsJMQ/txIwFFI6DQh1Uu1/GI1PSXdGDJXd7QUJgnZSskLN7NykD0n33pVII0DWj1YOJe0beIPSN7x95Ezea11+bFMgfphUrSNM8JnpJAeaBl5oYk/ffhWV5X7pwNKaB3UFxxTReOMRUjbhOzUownW5Ea1ZHiboVC04hmoj3hrtFebB7sn+7GFN2sU3Zm94taU3IaIKVXHEUQA5i6zyrdScMzmnxwj2QHzq0M81OLP1jQMZV0zYzj+sNAKie2MgaxdI+wkXaDaUlcyxU8Gexwyfc3bmkeOFU1ELmrYF8LChOngpw5Y6Jv0VBUpDXAOH7nyRpMAs2nQ8zc+7WnH1+eE1Ps1+PN8GuOci9t+2JcavNUonQqEhiR4bp8uPRSnvB/9TtmDBMcx2o5T2H9lzSFNIpI6Pyu09zaVOr39YYDkzdz43PzKP1lFxwQ//lzoeC8KRNhxEnOz0OaFmYOjljA73eQ0aZz6EnPVlxqoc6yrHB1ExBBd0zs4jEtEZaR+UOkroKdXJuHEkQKS6atIbIYuYuKDO1XzvyAX5aAHJOypaaF7eugHeh7niZyuSBcsIcYIAVHgN0RFjtJELG8sTF95Vbp/dR6P8aqsGpdso=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QkZzz+QJy0pUlbc/Apr3dZG94/Oo9JbPuXKKfa2csGt5AxD2dJrw4is4gUju?=
 =?us-ascii?Q?GR8x7KpfTSlxxx8om5amBISaL/PY9Y7s+e8AOLUYLbHcx4nJhV0LAzPORAWv?=
 =?us-ascii?Q?uUq2+3ciiyAaXAg2b9jbQx6Cd4eIfJDUCr2zp6triJOl0f96mZS/ZFvoRCCj?=
 =?us-ascii?Q?Gd+yYWBflJ0i6jrjNBkafWJalaVV9UQltji7eF6xpTIpxxA0Kp+uc/LWVwUU?=
 =?us-ascii?Q?J3cwXkcvBRg+ty0pzi2h3J0CLGN7MM0GHPImAxKaMtrH1Wbk9GzrsY/svKbB?=
 =?us-ascii?Q?IMu4qDDFDxOGhr7lV1Wnt/aW1k83RSvbbF7zdG+ioYq17Cm6bikmAg9maVRH?=
 =?us-ascii?Q?ZUTk22Ap9IhRoSqcGOJhYgM7bIkvwdHE1Utzj0OKkzap9fBlFqbvY5tozRlt?=
 =?us-ascii?Q?nJ7HJQYt8qLda4e7tWQMvmEme1GCHHFnEJ+5eax/GzV1D1KoOKTxphf13XfZ?=
 =?us-ascii?Q?U7LI7cRmi0c7K1m4GnHHnUnQDVbcNnHNWb+tZdhIEBmXh2sge5jAvQ/NspbU?=
 =?us-ascii?Q?rJXlg5cIQo1xt06dd90BkC9SB4gF9yVMorKJZwJqDCE3IxWXUne387zq21sB?=
 =?us-ascii?Q?cr3Q7DM29pA0E0pwO9DAoTklbFaeLUl27nYJklBt5Me8cTM/vrvDnMcxWoBP?=
 =?us-ascii?Q?6kXVllnfLO8JP9YM+pNBNzYRxMuMvE1yle0v2GyFLqhdL3DjjmZBe2aSvuLC?=
 =?us-ascii?Q?uazM4q6v+uP8x5gpEJxYDEzQtVxzDg9dIIDLlbYE85YQxBUzIQnafYRubUVi?=
 =?us-ascii?Q?s5MCojtUs9/c8MzYBoGHsfF05GyVocKGz3fUvNgLZ9DKQSxjekmJGgrWsyi/?=
 =?us-ascii?Q?T6EjaVGfbKRPrs60QlnAr6n3yGkuhxnBJDOR/CqA8EreMuvjYVVYmvTH8rqb?=
 =?us-ascii?Q?E/OHJhgV1TKianPr/YUUlL2/mO4yRk5NOJiPfCwz3pmn4l7iB1EAC0XrT37u?=
 =?us-ascii?Q?63nao/DYLe7M1VShZncNloswcP1WoRS/Qvrv+vpGAtOCjmWTj2JkUeVi4Bq9?=
 =?us-ascii?Q?DRr/xe5h7U30q9NvvWgzBC+8ne0LKeTuQzNtpdvMLeFh+usQJNer2bVA7RYi?=
 =?us-ascii?Q?7mpYTZB56GSpvoA2lBx5DvEimTmyDlkBOwClpHjxjpAV5v29EKERzJaOZWJn?=
 =?us-ascii?Q?Rfk4nTt/rnvOhSJgSffbBOYr7lun/Cv3ActaHZs3WazqxAfgDG4Nmmtj3X/o?=
 =?us-ascii?Q?swERs468QqAzKjN7FA5CVxFGdy2kNp49CDwscXZfeSzYiSeJID7lDGwwwPk7?=
 =?us-ascii?Q?BB2TgcGH9YgoFzalnpIbXbBIshtJRhsgp6h3twZkTwUA5Nv5Awn5uVLCb1ig?=
 =?us-ascii?Q?873bFAUdZNqV3kNU6kkR8fznIIshx/jqHmPUwB95fldaWV9SHwC6VFRFEtvP?=
 =?us-ascii?Q?+yWoplJH5JGbxcCi+T+khso4e3ZAdRsvrlNIoBbMt0s5KI2LJKR8daRAJPsp?=
 =?us-ascii?Q?kRDy3np2bb1wOHqFYh7316WzoU8nGhq0kS+CJZN9OdgVhRcrP0nGK5HGJZbu?=
 =?us-ascii?Q?D6PqP3wAGrz0CCJzWI/HEy8GYOj6CQ2FcQGRypBf295KVliD/JcKnJIhzYJ4?=
 =?us-ascii?Q?n4ZGwxcnq6aHTQ+aXJ/voJo9ArswIkfPaijNK0mMkxaE4ymP3/Yho1H4vauw?=
 =?us-ascii?Q?BiGga21Yp2CwOUMA4CnIJLg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 813a96f0-7f00-4917-b48d-08d9cfa5b2fc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:43.0501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XNvGluvtTk9jYcez04dcE8MR3tVosdO3fWrfzbfsRwNyPPOz5H/I9KJGXIckUfU8xJQBPOm24uANWsNQbTbLKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dst->ports is accessed most notably by dsa_master_find_slave(), which is
invoked in the RX path.

dst->lags is accessed by dsa_lag_dev(), which is invoked in the RX path
of tag_dsa.c.

dst->tag_ops, dst->default_proto and dst->pd don't need to be in the
first cache line, so they are moved out by this change.

Before:

pahole -C dsa_switch_tree net/dsa/slave.o
struct dsa_switch_tree {
        struct list_head           list;                 /*     0    16 */
        struct raw_notifier_head   nh;                   /*    16     8 */
        unsigned int               index;                /*    24     4 */
        struct kref                refcount;             /*    28     4 */
        bool                       setup;                /*    32     1 */

        /* XXX 7 bytes hole, try to pack */

        const struct dsa_device_ops  * tag_ops;          /*    40     8 */
        enum dsa_tag_protocol      default_proto;        /*    48     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_platform_data * pd;                   /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct list_head           ports;                /*    64    16 */
        struct list_head           rtable;               /*    80    16 */
        struct net_device * *      lags;                 /*    96     8 */
        unsigned int               lags_len;             /*   104     4 */
        unsigned int               last_switch;          /*   108     4 */

        /* size: 112, cachelines: 2, members: 13 */
        /* sum members: 101, holes: 2, sum holes: 11 */
        /* last cacheline: 48 bytes */
};

After:

pahole -C dsa_switch_tree net/dsa/slave.o
struct dsa_switch_tree {
        struct list_head           list;                 /*     0    16 */
        struct list_head           ports;                /*    16    16 */
        struct raw_notifier_head   nh;                   /*    32     8 */
        unsigned int               index;                /*    40     4 */
        struct kref                refcount;             /*    44     4 */
        struct net_device * *      lags;                 /*    48     8 */
        bool                       setup;                /*    56     1 */

        /* XXX 7 bytes hole, try to pack */

        /* --- cacheline 1 boundary (64 bytes) --- */
        const struct dsa_device_ops  * tag_ops;          /*    64     8 */
        enum dsa_tag_protocol      default_proto;        /*    72     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_platform_data * pd;                   /*    80     8 */
        struct list_head           rtable;               /*    88    16 */
        unsigned int               lags_len;             /*   104     4 */
        unsigned int               last_switch;          /*   108     4 */

        /* size: 112, cachelines: 2, members: 13 */
        /* sum members: 101, holes: 2, sum holes: 11 */
        /* last cacheline: 48 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index fef9d8bb5190..cbbac75138d9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -119,6 +119,9 @@ struct dsa_netdevice_ops {
 struct dsa_switch_tree {
 	struct list_head	list;
 
+	/* List of switch ports */
+	struct list_head ports;
+
 	/* Notifier chain for switch-wide events */
 	struct raw_notifier_head	nh;
 
@@ -128,6 +131,11 @@ struct dsa_switch_tree {
 	/* Number of switches attached to this tree */
 	struct kref refcount;
 
+	/* Maps offloaded LAG netdevs to a zero-based linear ID for
+	 * drivers that need it.
+	 */
+	struct net_device **lags;
+
 	/* Has this tree been applied to the hardware? */
 	bool setup;
 
@@ -145,16 +153,10 @@ struct dsa_switch_tree {
 	 */
 	struct dsa_platform_data	*pd;
 
-	/* List of switch ports */
-	struct list_head ports;
-
 	/* List of DSA links composing the routing table */
 	struct list_head rtable;
 
-	/* Maps offloaded LAG netdevs to a zero-based linear ID for
-	 * drivers that need it.
-	 */
-	struct net_device **lags;
+	/* Length of "lags" array */
 	unsigned int lags_len;
 
 	/* Track the largest switch index within a tree */
-- 
2.25.1

