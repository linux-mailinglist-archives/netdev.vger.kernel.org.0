Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C89485377
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240259AbiAENV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:21:57 -0500
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:53697
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234458AbiAENV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:21:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwVqeWSvaTKIQDncjlDNxj4OkYbMPtV2pFAshP3OVP+J443ijiQgqT4v26tLyCvBDAL3iCLAZqaE7v27p638oH/kYuyOP1rbPpquLOCLjdhk0HcUrpz4Zl6zJwGRlD7hcRCNcWftPgpmP+vXeXtZJeKoPKBTCIJpVA2BLBAUx0PFsOxn89EQHm6ZJiTp+AwRoPHTzp1OBx1I2C3RuBt4A1Vipq8T5M3SjHiXlzcCyVnnWjuE0RlRdHAEhBqcTEFGw/TvQvsEy4R/JYuzRCXjeoWzxr/Lv68w0YfZIcMr2s0yLxKubk6dOUgzpHsxZJvuY2nCmP0XYtnBJkPLurPr4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z26c5Hm9BM3R9Ri0xrzsaCOXV+PbNTah+U5ZyoIK0Ss=;
 b=X5V5ACjtINKJkAkS3d/XvJOl8mctJsR5fWoB7567UyrjxaHJqDW+ia1JQ6eL0XM08bvnCywUFDTUL0q/en14yxySUo13Z37qjoC/kgBaDvZmEhw/AnqRtbFFwm5ili0T8O0P24oczgTgA5owlU0TAjGf03leDdlUm4g7d7eFCDhJ5xYa3IZTPPxSJ4py3flR11BEO/B2uwhS4khZwayaFs/ujinMT5XtPobwJVDUzCKfX4FXUvT0vVBkU3HCXuU9hoJvVAPOw52IIehabFWLHk1PLX8xU8RAl2SmFUXGaNvuLIb8RJ5pjj8cQlZ7UUzuAoCRPd9VtieP07Jv8yMTMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z26c5Hm9BM3R9Ri0xrzsaCOXV+PbNTah+U5ZyoIK0Ss=;
 b=bB52zRtrOVOYlhMUicxn6Uz10uhAZhNqWcPV0scE1j4e3nCkG1KByhopET/uv2KoJ5X9v8k0RfYN64z5/vk0ajs/qnC8GD4VfnOH6grpgJbcXqkpX+8NcQcadtEgdwzPUNGrQvE7tvMhgYCKJceDfUNcCZsMyy7prPYdkiY6eZw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 13:21:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 13:21:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 2/7] net: dsa: merge all bools of struct dsa_port into a single u8
Date:   Wed,  5 Jan 2022 15:21:36 +0200
Message-Id: <20220105132141.2648876-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0150.eurprd06.prod.outlook.com
 (2603:10a6:20b:467::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93ffef7b-1c42-4c51-909a-08d9d04e5704
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB7408AF27DE7476185AB066FBE04B9@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Tx46F0QKyjYgsRmYPq0/dGlBy6/IgYF0HEXWkg+t8OsXtxV24m2hIOFIDlds08wwxFsd/FZ3YeO1asgY7mjVUKvG1mn7I4om/XVS7dWgMucaKp6+eAQkaNgrKyQDfSfuqS2rRYKG7fXKKBvJVKX/uQoLAOCt2tNfx+vlena3eECN753C2orq0u6pOSD2bdPAretASUk1F7nLiAziHBNf9wTf5NJrTIi5L1mY7qoLxM44S8TKJZmXapFz/cudOJB8fDSr1Pc73N3AN/x7HBCl79e8g8ST02SHiOYrefXIFljfrqcUhXQQaWLjrAN/9EB1qUjUb1+zlBmiKqMjLRcJ6Ca7xS1fYXISOuM26sBuIfBxrQBYpG64EfYwLIxGR35ACozh7cEDb/a1+hI4c8/dSJt09jg3D64Uv9dLoMBydxQnNhmHyxcTT5ro9APGO70bLnDYzFlMJVagdN17iy/xxBkC7ryDEfQ8RQJjITeSSp3rKyUCYHiYXv6vcQSytfl0pNrf4DVMlRBt7REJRwctAM7S9mp3dXQqYp/pl8UzLcurATpF3MQDRWrydlTkLtuP721WXTqu4bHYfTT403xCa0tBU36HlONPVrhEt5lv7RH0JZw0hIZSXRx656O/QgydxTKbng3csf2qoKVuO0aXhptbEgMuE94xIdfGfZ4cqPxrVGQI4ckGeH4fmSDHblBCr3oBOsT/9Z9N1c5mnHjrOs6jr9mRSt5RBqEjiFzknc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(66476007)(8936002)(38100700002)(38350700002)(316002)(36756003)(2616005)(2906002)(6486002)(66556008)(66946007)(6916009)(5660300002)(44832011)(83380400001)(6512007)(508600001)(86362001)(54906003)(4326008)(8676002)(1076003)(186003)(26005)(6666004)(52116002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?atK+Ea7ij3F1bFvF+QV9VURxt5/0t6miqueR7YtJ7GYoHmbcrdVNBkSPas6n?=
 =?us-ascii?Q?Hs0KC6Ccy1Uk13ZSe6TW0HUfpgmxTYzD3qDLHxswwVAvM27dHz+8DyWB4iEJ?=
 =?us-ascii?Q?HpL2B/8m/+EJcugo+UN7IvpYgeyZZLTaYSmUL2vugyQPncphZ15KfeqntkLv?=
 =?us-ascii?Q?Pq+dsefeCQSBwbXXOGXg0RfsT9NrbRd3N+ofvx147KS2YBsnieXX881iwf6+?=
 =?us-ascii?Q?zwIx2ZTkRdNNLUGMau1c6t8/znRxdQzmbxPU7ELflONjsGsgsr6LQdCNVyNn?=
 =?us-ascii?Q?1nuZLdHfgTTLzI/Jt2wHsfJvShGSheqFqexzeCCAKjRk2NQj5yESW2eSJCOe?=
 =?us-ascii?Q?caGIepSpq3JiFkp8qI8v+xdHfDcorj7WKnjgAso1YjwPoCMQfLkfd6rzGYNl?=
 =?us-ascii?Q?Omy7+SVQhxBJQMQaEiKRFwIiDfR7CE7GLvURBstmEfyo1OJFi4VQBRWtalu1?=
 =?us-ascii?Q?2z/DJJWgZzMvHhIEyGz9QLHNAHt3cay7BuEMFOx1DrhWZ+ktPzvGMZ9zNHpN?=
 =?us-ascii?Q?ju2Sbod7A18je1qvusaeAzt2VbvlSrnqCUhYI0tBCLJNz2s64Zy5EPqSi21v?=
 =?us-ascii?Q?umI/jkbewry2MtNEyRzVCJIye3di1QbM9FaYnZjq2qW+0s/GtH6wkhW2R3It?=
 =?us-ascii?Q?o7+7sJXuW7IwJucnu7bCvvSe/ISP1X9+SecKcYQxfUycp3cPFxf9nXlotw5w?=
 =?us-ascii?Q?4dPoA7pksw3OJ04lwLGo5Y6G9OAItJk93mTeL+AqBNH6GsOgbyZ8v1W4g7EK?=
 =?us-ascii?Q?inQs07ktBc0G7+QRoq72atMk28+qdtZDYUWRRGMMkYfp4dU0TXQm5R0ZZ53l?=
 =?us-ascii?Q?OtS7XOBa3VeF6sI5x+JxFskmvmyN9RsAxP2Y3YEHNpKYEf2+dvHJ2DSW6srT?=
 =?us-ascii?Q?wpwIJ2iSniqZW40swEKwtbfBvjnEkvFtkv65VCeNBeZ92GqQYzEswK3uCtXZ?=
 =?us-ascii?Q?x2Sq7gy/trjCG4Xnql3zrKUSff1cOXWJ0aa+W/oApYrCdvgdXI2TQ6vzDFrf?=
 =?us-ascii?Q?A8xX5A2t7ujmSSSxyQ3RjJ7IqJl9sRbbCpKgiovEq0kjXF/HQ7K66cKBzh58?=
 =?us-ascii?Q?N3bVGZo6t0pNAF3+NetyhngHfR+jRILvr/aX9QTjsHiiZuvxewQs8u+z7Ynf?=
 =?us-ascii?Q?vyDicXEiNex0vmz6H/Dh2eiEZ9FvkCNNq4GHKDI8aXXnSbosaqSRyRQg5QZR?=
 =?us-ascii?Q?Xkl6ve+klgwhBg2vLyCiqeM3JyJ1mwbDvdrAn1iMnHzWp5PsslXuVVjgI8vU?=
 =?us-ascii?Q?DkEizpeBRpVxZZ/yB/WQZvWREu2n3W7S/wfU43+5wPsmKm5Rbz5qjK6ktJ7y?=
 =?us-ascii?Q?ydDwL2d/8lAlJMcEn43TM1udmcX0tDzQyTmQYI7I4i7CIJt3fDDQouEjJHLp?=
 =?us-ascii?Q?sohBoc6o+t92RkQuydasHrJ2aF0y64bHtBJY40CwXlzIXZeE+3fty6/9O23s?=
 =?us-ascii?Q?2xMAEjAyC6FUA2rQuhs+IxVsdeykIlIoAYPXXyIfPhSLbsu6V2Qmuui16kjF?=
 =?us-ascii?Q?wwjG8ACVOze3RSOEDEWjEsaB9tLYFsUh2pVkDPnGOaUvImP3+IxnYCiTCpeh?=
 =?us-ascii?Q?Yvz42/mpO47+NPnSTZSzd23vfpDG51Pq9dCOgRumg1jMfaDwLeBth/mpe5Qg?=
 =?us-ascii?Q?3h+7pEoWxZcVHFeT6fIoevU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ffef7b-1c42-4c51-909a-08d9d04e5704
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:21:53.7297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x71JlRdcHzO56qt2je3w0h5jivH4l033xnStmlD0mhy7JXg6jPKPcwvHhqvXI9B0lhzo+KeOk1qNheMsjlZkcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct dsa_port has 5 bool members which create quite a number of 7 byte
holes in the structure layout. By merging them all into bitfields of an
u8, and placing that u8 in the 1-byte hole after dp->mac and dp->stp_state,
we can reduce the structure size from 576 bytes to 552 bytes on arm64.

Before:

pahole -C dsa_port net/dsa/slave.o
struct dsa_port {
        union {
                struct net_device * master;              /*     0     8 */
                struct net_device * slave;               /*     0     8 */
        };                                               /*     0     8 */
        const struct dsa_device_ops  * tag_ops;          /*     8     8 */
        struct dsa_switch_tree *   dst;                  /*    16     8 */
        struct sk_buff *           (*rcv)(struct sk_buff *, struct net_device *); /*    24     8 */
        enum {
                DSA_PORT_TYPE_UNUSED = 0,
                DSA_PORT_TYPE_CPU    = 1,
                DSA_PORT_TYPE_DSA    = 2,
                DSA_PORT_TYPE_USER   = 3,
        } type;                                          /*    32     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_switch *        ds;                   /*    40     8 */
        unsigned int               index;                /*    48     4 */

        /* XXX 4 bytes hole, try to pack */

        const char  *              name;                 /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct dsa_port *          cpu_dp;               /*    64     8 */
        u8                         mac[6];               /*    72     6 */
        u8                         stp_state;            /*    78     1 */

        /* XXX 1 byte hole, try to pack */

        struct device_node *       dn;                   /*    80     8 */
        unsigned int               ageing_time;          /*    88     4 */
        bool                       vlan_filtering;       /*    92     1 */
        bool                       learning;             /*    93     1 */

        /* XXX 2 bytes hole, try to pack */

        struct dsa_bridge *        bridge;               /*    96     8 */
        struct devlink_port        devlink_port;         /*   104   288 */
        /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
        bool                       devlink_port_setup;   /*   392     1 */

        /* XXX 7 bytes hole, try to pack */

        struct phylink *           pl;                   /*   400     8 */
        struct phylink_config      pl_config;            /*   408    40 */
        /* --- cacheline 7 boundary (448 bytes) --- */
        struct net_device *        lag_dev;              /*   448     8 */
        bool                       lag_tx_enabled;       /*   456     1 */

        /* XXX 7 bytes hole, try to pack */

        struct net_device *        hsr_dev;              /*   464     8 */
        struct list_head           list;                 /*   472    16 */
        const struct ethtool_ops  * orig_ethtool_ops;    /*   488     8 */
        const struct dsa_netdevice_ops  * netdev_ops;    /*   496     8 */
        struct mutex               addr_lists_lock;      /*   504    32 */
        /* --- cacheline 8 boundary (512 bytes) was 24 bytes ago --- */
        struct list_head           fdbs;                 /*   536    16 */
        struct list_head           mdbs;                 /*   552    16 */
        bool                       setup;                /*   568     1 */

        /* size: 576, cachelines: 9, members: 30 */
        /* sum members: 544, holes: 6, sum holes: 25 */
        /* padding: 7 */
};

After:

pahole -C dsa_port net/dsa/slave.o
struct dsa_port {
        union {
                struct net_device * master;              /*     0     8 */
                struct net_device * slave;               /*     0     8 */
        };                                               /*     0     8 */
        const struct dsa_device_ops  * tag_ops;          /*     8     8 */
        struct dsa_switch_tree *   dst;                  /*    16     8 */
        struct sk_buff *           (*rcv)(struct sk_buff *, struct net_device *); /*    24     8 */
        enum {
                DSA_PORT_TYPE_UNUSED = 0,
                DSA_PORT_TYPE_CPU    = 1,
                DSA_PORT_TYPE_DSA    = 2,
                DSA_PORT_TYPE_USER   = 3,
        } type;                                          /*    32     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_switch *        ds;                   /*    40     8 */
        unsigned int               index;                /*    48     4 */

        /* XXX 4 bytes hole, try to pack */

        const char  *              name;                 /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct dsa_port *          cpu_dp;               /*    64     8 */
        u8                         mac[6];               /*    72     6 */
        u8                         stp_state;            /*    78     1 */
        u8                         vlan_filtering:1;     /*    79: 0  1 */
        u8                         learning:1;           /*    79: 1  1 */
        u8                         lag_tx_enabled:1;     /*    79: 2  1 */
        u8                         devlink_port_setup:1; /*    79: 3  1 */
        u8                         setup:1;              /*    79: 4  1 */

        /* XXX 3 bits hole, try to pack */

        struct device_node *       dn;                   /*    80     8 */
        unsigned int               ageing_time;          /*    88     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_bridge *        bridge;               /*    96     8 */
        struct devlink_port        devlink_port;         /*   104   288 */
        /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
        struct phylink *           pl;                   /*   392     8 */
        struct phylink_config      pl_config;            /*   400    40 */
        struct net_device *        lag_dev;              /*   440     8 */
        /* --- cacheline 7 boundary (448 bytes) --- */
        struct net_device *        hsr_dev;              /*   448     8 */
        struct list_head           list;                 /*   456    16 */
        const struct ethtool_ops  * orig_ethtool_ops;    /*   472     8 */
        const struct dsa_netdevice_ops  * netdev_ops;    /*   480     8 */
        struct mutex               addr_lists_lock;      /*   488    32 */
        /* --- cacheline 8 boundary (512 bytes) was 8 bytes ago --- */
        struct list_head           fdbs;                 /*   520    16 */
        struct list_head           mdbs;                 /*   536    16 */

        /* size: 552, cachelines: 9, members: 30 */
        /* sum members: 539, holes: 3, sum holes: 12 */
        /* sum bitfield members: 5 bits, bit holes: 1, sum bit holes: 3 bits */
        /* last cacheline: 40 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8878f9ce251b..a8f0037b58e2 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -261,18 +261,23 @@ struct dsa_port {
 
 	u8			stp_state;
 
+	u8			vlan_filtering:1,
+				/* Managed by DSA on user ports and by
+				 * drivers on CPU and DSA ports
+				 */
+				learning:1,
+				lag_tx_enabled:1,
+				devlink_port_setup:1,
+				setup:1;
+
 	struct device_node	*dn;
 	unsigned int		ageing_time;
-	bool			vlan_filtering;
-	/* Managed by DSA on user ports and by drivers on CPU and DSA ports */
-	bool			learning;
+
 	struct dsa_bridge	*bridge;
 	struct devlink_port	devlink_port;
-	bool			devlink_port_setup;
 	struct phylink		*pl;
 	struct phylink_config	pl_config;
 	struct net_device	*lag_dev;
-	bool			lag_tx_enabled;
 	struct net_device	*hsr_dev;
 
 	struct list_head list;
@@ -293,8 +298,6 @@ struct dsa_port {
 	struct mutex		addr_lists_lock;
 	struct list_head	fdbs;
 	struct list_head	mdbs;
-
-	bool setup;
 };
 
 /* TODO: ideally DSA ports would have a single dp->link_dp member,
-- 
2.25.1

