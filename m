Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98594485376
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240219AbiAENV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:21:57 -0500
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:53697
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234666AbiAENVy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:21:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHv60I6CANtXhl8n8tuUm8TzQZalahCdxjUBaHtwrwI6fHSk4aEw2RsG0qVBaC+11DsflSo3hDba7jPFdW0hJxywz0grgkT2E3QeAL/n80bE8PFVBsKuDN0Rt90D7pWVO3bSDkYAgBGd9wPd7iSWPV8vE474ayIjiFgNXQQtvp6+xlXSH44n5P8bV+rsLCQr4eLHUBeGF8AC+TEsoZgym2m5xwwz9Um4BKsmoAG4ARyenzWEOXwztvKJR8VtWECL3iZNDj0WTFrP4GvS8ugiScRLkhgzl3FJIvB6yIJJapal5l3VU/uvZE1SJh7ZGgMoTkqBOP7PkbmJLEZOtqMeOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZPMTKyZaWhnzT8T/b+FyyuwxuT/r+Fxoyhrc/77PkA=;
 b=U3K9hwfAh7j9BMgI63UELWWu0DzuaMg2AbrrkdrSTzyDszv0bMH0+MVbGTTrAeldZeexWl5WYcPcn2Rwm1lRy4Xe3fbaDCvbohsIKtY9n1bJoaFC4Ak7fX4Pvd89RU7CjLcjoO2O7Gvsm6yI/sEWqA9I1nmG0XrfR1H3m4kruEWf3Ate+ORwHP9Qpaia/rdRlr+XJvK/livYBp7cXcCNL3hmpNdIhZY/Spetbueac0BrA5UFeBgblM5BwD6ZcGTCY+1GCIDKA+i5hj6sr+bHrSzyiHmmsQKAwNK3gUkpa60xVjP8zR9X5Mxwf7zlX0EnQ24sLU9DpwoQBMxO45yVww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZPMTKyZaWhnzT8T/b+FyyuwxuT/r+Fxoyhrc/77PkA=;
 b=Veq5kXFFjXAUYbIOadwbBF9Zepq5HRj4BnEh+Vd10LUUg/jI5YUxmMUCpyWnZXzj30AhV9oaQDZOVvOq1QEfE7jpcWRc5HDdicXqdtov6zPecNKiuOwRR+GZQSds1jsw/IZ/4jxAWbeCK2JC6/QutMfrgmMCfPDAxt56J6RPtbA=
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
 13:21:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 1/7] net: dsa: move dsa_port :: stp_state near dsa_port :: mac
Date:   Wed,  5 Jan 2022 15:21:35 +0200
Message-Id: <20220105132141.2648876-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 281d31f3-f323-4969-d3f7-08d9d04e5683
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB74083B541E6BED028C61CD36E04B9@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r4Un6uvD6DrENWt/5cev020YBBzIYFa3j9GeGMQqcsfKBW6zun5zTRF1NTtZ6QBaHISJV/vwAldS4Ef5XnDQsqGzHsv19p0v2YYIuVKOka8N/SxXvTybD/WrbtGYSJHtocz5TNVht/POYFP7fyYnnRx1Rf3FCa5juRE/30skw7A9QecrxKZa9SvYhdF9UcH3AQqxu/BPBXhP4kcMAy3WKHMAQRSmRECHQshWtaW+H1RN3R6GiFUlPLtRG28O63rG/L7ZeOPw7+oXUJaKho+JkTVzPi2aBHQlTiXBjah3DD/HA0M2v1iMKyPdcGKE7eDwbpAKjGMtHGlTd0n0VhOBJwg1ZBX8mf236VS0QkD0gT+azEBaCdX4b2Mm9BybV3l3AWYSVvGuVb1DAqjSs/ef5YhXAQ239FUnBqlYroxCTqm3IlUssSXc96laSIMHxycz2rBEnOCoZG4KgW68zbVHP8gAFIBPf+1jDESZYRpkfrEn//k5qiXYDUwVS82ykPietISoMLW3Arb9ywpl1A9bhN5dlqwIsgI+4SHjmjTHcF4ltoCI019fFmrkuDZh/AgKudH3V+nDdWq78n+ietI5Vd7zIB8w2SLWb01rtnO7WUGhR9yIFisHN+mZb8Ak94WTeYzCbEW2Zx6Dcq9Zk8XNrUK2zKJ31erQApRvvuoRRSLyQ8K9NRziEFLFElx8Zg/D5iIg02tw86VYZJkGTGDZQOTcRXRzLMkq5QYZsww6X9A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(66476007)(8936002)(38100700002)(38350700002)(316002)(36756003)(2616005)(2906002)(6486002)(66556008)(66946007)(6916009)(5660300002)(44832011)(83380400001)(6512007)(508600001)(86362001)(54906003)(4326008)(8676002)(1076003)(186003)(26005)(6666004)(52116002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dy1QWuYOYvFdc0ky6Cslu6eLPTJ5Bj2aEQH0ZznNEYHol0n3kjb9zBkZJ7ME?=
 =?us-ascii?Q?qiCxiUABD7MjoS/X8qn8BUawaIlHVxghHNCkd9U4jhNk8XEAW161LR3DxYnO?=
 =?us-ascii?Q?ZBnJ6smweSCVQ0sHqUunGRNKMUH1Bs2Sd4EWxaZ6gcM9O9y9pqFHEHBHPo6g?=
 =?us-ascii?Q?yn82pJSck+fwc2PqTrEz3jAuRjumqL7JCaZWo8iSCFTDt/ZNfP6H/7nyEdkp?=
 =?us-ascii?Q?kqFdezX1jSK3TK5Y6MHelDFqUCeL5z9dbIKeRfe6ENNDyb99iHnlGEBJYCxN?=
 =?us-ascii?Q?qkQhl2agYF0UJovGKI0OTacC4Pe9PeaJhX4zsSOwDfsQRs7XMXwOjZg9nTdp?=
 =?us-ascii?Q?3vBTTXn0c9KNOcfxZ934M5fzwOZQH1hsKgAn7myym0fubHhQ1HIa9yH/qVc6?=
 =?us-ascii?Q?b+SUaEUIXAtX+zbHlSiotoONiPK+VZ9gInr/bC0jkH01SnOZ+dxZNQIAh7Dk?=
 =?us-ascii?Q?LJK3SKEGZbB80k3UDSjOAX2bT+5i2Lb7LMyKbvzI4WOvxfXb6O0xx+MXpUDk?=
 =?us-ascii?Q?up0crysKh+2Q8qBgAhVuGfWGys7Y+pnVdYCRlgBxZLZMG4ifkt65z9vgJGP6?=
 =?us-ascii?Q?2lfVMpZzmWkTAAay6w72JX8mbbWWWlC8DPJMjIRUGAf9u0c5tA8dc3QqobP7?=
 =?us-ascii?Q?Haikt8f2/bS9tFiMtP6a1mWv92SCsoS2nsn9IOHurQK2AztcEH/axxwc83ln?=
 =?us-ascii?Q?DIaUpLyR6/VQWRSaxshEYhNMt5PAfbZc9Ca/NOCw1eFExdS6SQini910ANrK?=
 =?us-ascii?Q?5ICcZlUGkLOotYR+i3sknWs6ooQvy3bRJCHOZBvvJaYJxbCzuA8j5w3NphGO?=
 =?us-ascii?Q?I74IdASJeabeok+OsUCh31INB/hberDWW5HpJt7FXlJa63sBW5BWIWXJKDIo?=
 =?us-ascii?Q?fyhiUCgjCoH4Gd1YBPTyNVUGFIRzqPev3JRS1n8BgRDrQAJ2SvhWq8KuRRue?=
 =?us-ascii?Q?lmvY72FD6np4gd6C9OhYAsZ4hkabYqDqQQCJ4v3KWOmxko4ONPQ35YuQ/FOz?=
 =?us-ascii?Q?iXfyD/hACCwvnOufWBNxpSX/jiXthVYyIKSoBW9Mj1wcnvN6YASPSrbHbHg4?=
 =?us-ascii?Q?J6hX1x4aRCLRs+dtRIIKwMuYDnG+NhCiTvAmWDIwq2yNjlIS+4pDlM5eZBTr?=
 =?us-ascii?Q?D7YojC9ng+aGG52TA1Qy/juEmUwvLAV9ujEUwZad+LUsnkm2ycnGw9jAh0US?=
 =?us-ascii?Q?wh3N205phvcHNyjLWF+RLgxNr3ueggsJZ9X3ivB4hD2skA7KV+7bsNP+MzSL?=
 =?us-ascii?Q?b3vv7Yoh2mO3JW4LWd/zJdGnXMd7UYH+PveQweBiMZuICNvQFIqAl9j+MDx2?=
 =?us-ascii?Q?PTxMvYlTjwbWmWyCGu4aT2AYTCN8ZgK2s5FkPnc2jErmGCRgij91VjGIzb+O?=
 =?us-ascii?Q?j0apCeXsk4YsilETkuyyZczgfCWH7+7cmTCnsEFL90r8dYgNwTQN8khORz1S?=
 =?us-ascii?Q?zQda2vQzeDTLzT0Oot5DbL/i3sUvbkP/YPU/2Zx7KGaEXZxkbdt10LzpW62b?=
 =?us-ascii?Q?VC3YCg3wMQUYm6jekS0Y3npttslBu5YZuVIgAuXD9Kjwpix0H/WIx3ZXtOF3?=
 =?us-ascii?Q?SzrSzD2SFWoL5raCbJiraiOzL9AmGjpx5v2cibCMeux7M0MIWFy+gdHZG6E0?=
 =?us-ascii?Q?8qeSCaiUUnVdWtLJ/CeKmxc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 281d31f3-f323-4969-d3f7-08d9d04e5683
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:21:52.8704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: frcUlzsEUNlSPMBA0Wjn3RMA/767lnw9d14qNo3KgEnhVM/hky6nP6ZZRNqv1HtDoleVBeK1UdvTHlRzN3jcmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC address of a port is 6 octets in size, and this creates a 2
octet hole after it. There are some other u8 members of struct dsa_port
that we can put in that hole. One such member is the stp_state.

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

        /* XXX 2 bytes hole, try to pack */

        struct device_node *       dn;                   /*    80     8 */
        unsigned int               ageing_time;          /*    88     4 */
        bool                       vlan_filtering;       /*    92     1 */
        bool                       learning;             /*    93     1 */
        u8                         stp_state;            /*    94     1 */

        /* XXX 1 byte hole, try to pack */

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

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f16959444ae1..8878f9ce251b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -258,12 +258,14 @@ struct dsa_port {
 	const char		*name;
 	struct dsa_port		*cpu_dp;
 	u8			mac[ETH_ALEN];
+
+	u8			stp_state;
+
 	struct device_node	*dn;
 	unsigned int		ageing_time;
 	bool			vlan_filtering;
 	/* Managed by DSA on user ports and by drivers on CPU and DSA ports */
 	bool			learning;
-	u8			stp_state;
 	struct dsa_bridge	*bridge;
 	struct devlink_port	devlink_port;
 	bool			devlink_port_setup;
-- 
2.25.1

