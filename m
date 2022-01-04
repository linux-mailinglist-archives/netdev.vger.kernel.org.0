Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5684846CA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbiADRPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:15:04 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235597AbiADROo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPjRqHOHh47yPIe6k+FHno3hOW1aIDUfnSXjmYFlY5l2K6UG8DI6/hSh080v8dqLweIemwssZcSXzZAwWndrpxMBb6yGL+7gNEFwFAYCKwdHNuMBqKRWqsk8/N0yOBKE50hb84JDD4R9xJFlr+FVD3EilHc1UrWQ0dLsLDGn0iS5gvLS0aLSZfmBQXHYaCKm0PrCTMBSc/nZcatKz75czhTfxktoKsNDJTpiwk/qFXmfB95FJozflnotoXRMQCqpQLjODY5o+flPbvTKNY6R9kiOSs/OIx/0SszEJkW9Rvg2Au2iKndYA76ECOR24Wb/XGenTI9ui96gGJK1GwA+Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z26c5Hm9BM3R9Ri0xrzsaCOXV+PbNTah+U5ZyoIK0Ss=;
 b=NO5PK4YQtHiDTjqnDWzAn3THWho9BdrLgU6mQUo1Ot2ZRvRvm5YspgvuOylMBOMZRiF1SrTk9JS2bXu3yXQcjq7N5ZyZFnuGifbmKKHiJ9A9Zgy+ZGLCCaHUg7Rg8ErWLAjZcCyzK1rWarIoXL5cOd0qzzYtlbf2ZF9Dfe+xS4jf3GoF6VLxMtrSOAgH3DiNol+t4Yki1vK1LpAsuOXvwdfczWCvYKl7P8k0WSS17EFJRszStHC7zswIl9xLEmUeXJRgH+Er64gMlZA0BiDGuHn/NtvjLSjgp9QDRyjIS1O6UJL22gxLyTke1ZzChcbJkhSe/AA3y9ZEC9jpcSOR8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z26c5Hm9BM3R9Ri0xrzsaCOXV+PbNTah+U5ZyoIK0Ss=;
 b=CCYzJzIR4EG8w2EBdSnLkK7LmgHa+6x0kJRSm0SGrwbuFcwzEexf9rh9wt50qiArVsvESqp0kW0EznhMYE38VXTnfO82HRStnqVcb3lm4nM123ld3kX7zwvjBdmTb/ZozX1gElk/oiP/ePuLOe+OK33+CXwrDYksFQq7X3MPR4U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 10/15] net: dsa: merge all bools of struct dsa_port into a single u8
Date:   Tue,  4 Jan 2022 19:14:08 +0200
Message-Id: <20220104171413.2293847-11-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 558a4b68-2f47-42bb-4d3d-08d9cfa5b0e4
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB710477C0622F9E98E6DCC52FE04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7vlLIdrMpm9Z4BojvPSjSHo5ulTd4ZHbTW9rKDA+h/sxvjuCAWKrUdz+9bFcFQWFyGqbjjoFm6VboxpleNQWrLOF/cXLTqveVqnsAzM0H/mGUAuXqNcqYeBo0tv/Y6E8kEixy5lv9Txv3C9E9qxJE8oR7aGFq8K2Sy5f1v/Z7460gFInwnX1fs7xETVxnZfwG4bDYYH3D5zLE/XTQFlkQufSGUlm5fLtC/WEtSIN9YJg3J/aeU6/UCyFTnIFpVRkxScObloI29HVJYkJ4l2pCjIRA0fScogj1UNcy09701JURUpQOJ/Gv+JSvOeB24gJZ/Nu4XQFXwpQ8XuGH/Rbxwau5WYWSTtjeziZP1qHsAp3S9AhbKKyrD9pQbmZY2bkGoUgpoP5KwmfzuIcqiH1EDe6PX3OhCwfGWmnKIeLi2DstsgrIsIloVIwLhKm50CcGtun5Q1K3DjJznDKL8xGxzG+CipbwSqrXR5uTzeuIKLGk5av7/vM5HHsyY3x3DoV5Ocei6EfSW+h2gl4Wcp7d/Legl42REZz1mpjvFGjaDdzrN77b+LzxfznAONVs15PPZpL5S4a5uKNO7GODOxheJBmRjmPSy/hXq8bEYqPS1xPeIeGAISxhB883WB1+fgtQqpmpQpNzgBOHC9eINWXxlLMxKeeaKDZvMBgEk0k50gn+Y4kr8WzJ1H3UvGAZoxuiE0qLZDc7JyijCUn6ut4CEJCv4N590bGRasdFAdb+4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w7NFfkBsohOKfscBpBM/m6yIKqINsnAxjpVulC/fvcNJxpnWiUirpcwK52L0?=
 =?us-ascii?Q?MYEVQLwZDYIgYmD3wtl/aSBoxLEuxjUw/uNqUXu0gALvHqLq5A3EYTmBr2BC?=
 =?us-ascii?Q?DdRU/q6Bxo2rVFwyspSXB7yFpFlTo2rECUaGDzvsyt+QnLRqQ09mGHKGL/gp?=
 =?us-ascii?Q?czc3UI2YcjrZCf2qfa+PT5ycFVdkUlkRYSt6aorOwVuc4ydfCZ0OnQLFvYhi?=
 =?us-ascii?Q?9lnUtF6gGOT3gsI+/BR9JlLyymugkYidvYQKhrdhDf+HmHRVW8V00XdiCFz8?=
 =?us-ascii?Q?w4+umFMqNJICQ9Ah8q+AwNf1nkpV6MMj0bIyIYeJcwiCI2y/07P+5f6sJI4g?=
 =?us-ascii?Q?LL4zIZsditia4pzaLcWbSumavPZ83bkuW1Rl6mkIedeq4oXrpSuyFs+OGdQQ?=
 =?us-ascii?Q?Sg0Ze5LQk2YyjOHvGqhXqyQe9m+wU9SIyWBSxYSeKpQezZCZFKpOGawKctFF?=
 =?us-ascii?Q?PrN/gedGQE3GKZAo4FsYN/4GVlmciqJ3XCd7iiqus5oWa54Ax6wmQvWvDrUR?=
 =?us-ascii?Q?Y8V81jm1r/4sRm6D1pudxM5g0aP4QNNDpQejfwtVRoyxGUvbgj56JbjiR+Dq?=
 =?us-ascii?Q?ZFLAy99b+PfPk9PeVB3P8mjuu9BLKD8Wul+6pfsKAiESeBCZ3b65WQNXegI2?=
 =?us-ascii?Q?5XdFJ3tWmo7ZadD3aLlB2W2u0vQoJOX/AQs6GOzHvjfZ7RhwawT8Qo0t5LnE?=
 =?us-ascii?Q?s8OoCABPeiBBpzWio2r6GDFWmgq11QOd4LOmaBTGZ1NNStq5Lv6vXbFyBU9W?=
 =?us-ascii?Q?4mpjBPech2sLTso6ITI+C6nH5L7VbUBC/Y2DAY4tgOJbB0yt0gY2ommp9Ipb?=
 =?us-ascii?Q?Bzvf1VP2eb+hn85Kakj6VZzQF/d/xDz1EPJ8JesZqUB2BjIsRKp+9rLbAIbL?=
 =?us-ascii?Q?MQnGKNQEbMHIJC2avG63VPsPVCuL4B1BB9bqhJdJXX44hTKaBReov0l1GUR9?=
 =?us-ascii?Q?xyS4nz9ZfICBdiLtCa7sqGSrOP/2Q+epwzObSWxL/rsh7Mhqj1NlInaKTwoY?=
 =?us-ascii?Q?k2HfmUBLuKxKQmAnRsoc63m9y+NzKZbApYqf6bUDnE5mblH8lmVT0BL4dwPi?=
 =?us-ascii?Q?RKqx8GJChPBNZtCloaEDHpxt5lKNTuLo/v0YcRqzbfdVqjQx8rKdVOEF/aHY?=
 =?us-ascii?Q?f8uk/VHTiRlIckG6uGDQ6OK5qirnSfk9LAcIOeZzxwWFGQhbCUPMSzX3BlSG?=
 =?us-ascii?Q?e7/sneB4vH5YzCUKCW+Wnvd4N21SnA5fY6paIX1r//3VNm0JMPY1xBT+JKdG?=
 =?us-ascii?Q?qeOL0LkuHhGVOJtsM+t3NMqRYVjXKCLJV4MGC/gDSO0t12eYQfSj7lxtjcqz?=
 =?us-ascii?Q?WAUCbpESZTUts+MCvOlNfzP9Ocs3l2Voi3PWMs8C8kjGXwna6+ZRu/l6BD2/?=
 =?us-ascii?Q?Gvk99k/NSNKsNhGF27hD6K9pTgzpZa6Bqs66to2ixMvRc7L7OWpHeVzZI0dc?=
 =?us-ascii?Q?BYePr/1Q7BWHuoAR6I8s/WboT7c6kKK8bPOUza7yWTZo7jSanIT7EY/XI1M6?=
 =?us-ascii?Q?LgoaGwZxP14ienKfMMErJb3aOr6sdMIBUC5VWkDZRz9MTNYDQ8zPyk7JCuja?=
 =?us-ascii?Q?QQ44ddte+p6A/sAorI4IEKHAEPG6Jea6AqPtd63YZL0X03yZJg3aytSjRGgs?=
 =?us-ascii?Q?sAhZ2nx3/uxx1cHUlq9qD60=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 558a4b68-2f47-42bb-4d3d-08d9cfa5b0e4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:39.5347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drpuqwZL64QhYmMZkegNgIoDJIh45FDEltJSeYDFPhdEWqta8sGa/HyByzr8vlyq47eyPT90dUE/ta5lrh6Ymw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
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

