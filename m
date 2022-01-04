Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2446F4846CB
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbiADRPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:15:07 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235660AbiADROp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzNw0BrQWFU6Z1Uh4oexBQ7AXyEeTwfRzbxEtkTM6ZHbbIZuEw7PwvEn/PnU7pcMGmKOaqabMRR0dRf1kgtrsvrO8PtCW9HjThwOqCtwRtt3/kWUbLgYslYnh/zVbnUN/1qnkQsG05NU1HLBUnNO+7a25tZo7oiPKdb4z6gjAuMmAs3Xq9F9Qmo3KpJb3FnW4cTO4QbtAJe2aLzwWn7aFRjT9ys8g2eUpkFooihAtgpoV0Qp9JJ0m0oHpY5+KN9BrFLw9Rh4yl6w8oaCHEUlGH8JLMCMVP2hA/iRrrUXtCVCC4MnLHP5G+LSmXHUIG0ICMqM/9oXPY0T9VcgQe3sDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v78TTxDRv5KP48eXVu+ERE5yLA062w4etMoW1ObC4v4=;
 b=Rfpwjd9RAE5gBFseOAb8UApzZJAgnSjY7pVHD+3liEr4eWMX0nTdIfE+GEgV5wkbwyBMNxwK5D2wt+59gFhMT802Qfw/Xl+XXbh4Fx4tLVZHSvZEMDSugRIjsfYczLqkhtGWHmIwqNnKaj0G2nkK9aZv3ddMt32fxUH99gfat2oQNFvufaODr/9Rm1OnWmTcgtKQqEaucoSlVzJVfVRcVh5wji6BtCrYMqkvMsKzIs38+cTnnBfNBTBL/wNvXUYc0bvxyXM6r/j6A7VTUnmto4wRwWG81MM4WNtOUJoZ73Tl/8kaNCQ60jjJ5jw9zEnKaILtDHbyODvwqVWd6C+5Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v78TTxDRv5KP48eXVu+ERE5yLA062w4etMoW1ObC4v4=;
 b=QdYYK+7s29gx52TVqsuKS5tV8CLk4WzwaQn5n4T7oY4utrAWK1htddvdUk4BRmPiy6l6p5hIylq5P7DGQzPZNv1XB/N/mqq4KDcqOND9Koxji5XoKsZ68Ca93G9Vjtkbv3Dc68OPvlTWzWQ+3WokNMCKKXAuhbIZRFrg7zzDrDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 11/15] net: dsa: move dsa_port :: type near dsa_port :: index
Date:   Tue,  4 Jan 2022 19:14:09 +0200
Message-Id: <20220104171413.2293847-12-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 62b36f5b-f646-4b18-6c23-08d9cfa5b167
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104B62EE02851265A7ADD6FE04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IzQW4sHCajlrUvsVSzybOWl03js6VFy0FW+LQrI2fCqlke7xc9EPsO3m4aQnsRpKyp6gd3rUf3cCPL9POyxvA3WF7e7MfcZ5fcNuYLK8t1VWX77oJuq40SfKhnKDJwEVtBZI8M08Ma1tZPvhhoRpuvgepHaL16RlDv607K5mrUqDiSzQW3DXKXzPKYO3NTRMoGBl5XoxZiSWu9Z3IGAS+DTE1n73WeNwXh3VRZKQoQ5qZbGL4T29nem0VuEfw4/jfM9/G6d7tzYL+mSsKjsMnzETQBLgMa/Z7bMOFq+A0EQADTQJuMUmCCqdCsyGAOmh7h8NZPoNUpG+K0zHe1fRWC2XKQ9m+EYWtoCSH4N38GbZ9IIxvReBCoFXPDlRUJV0MS+393sbtZCoFwJTqcEeA8UGc4gfNdGk05jwCGq2QZQPZf6yP11VO+cJGEGFPEIpV/0sN8M82RMLFnqp7ywvvdHqHW6xKPBUhDpwdhfqgVq+2EQEZSaJs3V6ANIF6lkmEh/FKonF8nPUgcWkZT6efwC3aO0jrDeuQHYTt37bJPUaqNOGx+gcq7F1Zc8c9WZp+gZWTrJZCrF0K3ctcoTXcvGhEjJFOYChrRh9N6vTlV4EblH2nMH+CYO+YTB2GaZ7oq+M4Wa7Q27D0XCX+XJOFT3ujvWzolZQKnRLRKzzdXi3eyXl2c8dObeG0Yzj8SpYGZJh8b3ySAoUaklImITriPnW7KY+42zEcfJZSDbakgs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DJVxX772UOYcwRb3GTzguqX3FmtO8LjunIOn5KIf+eUCPZJJTcCY3nc99Qz3?=
 =?us-ascii?Q?q9XX827uCZSz+K4nPsa27CoSwZHFkTu3DbBNF2mQZ9ZmWXU+0JURpVGIssT9?=
 =?us-ascii?Q?1YxxeD/xZKsz4WAKVDzncdZOO7t+ZCo385jdMasuzwgRUVclEs6C7n1TwWM5?=
 =?us-ascii?Q?MEDXhu8PK8fTJipQZrOZEmEg+TQmTsCqhxg0C9CT4v6czXP+8c2/H4Hq6E8y?=
 =?us-ascii?Q?7F9vdn+k5/7HtWPX1a5ET2kQrNDkc7KN9i3ghwKUBgVns1tA7hCYDpFRwMJM?=
 =?us-ascii?Q?2NUGMlq6gSDn3xTODeH/ynvSChS6ANHPUY0Fn3NR7y2oxxGzAzC8b7Ygsd2V?=
 =?us-ascii?Q?KHm8lqh+2jmW0Y+A760OhAmKDCbjy6XDlZivAMSplLhMbXw/SOpRjYa3jjhj?=
 =?us-ascii?Q?FjvTR2fycaHnyqXNbVrUnzvKBjkdXanEK7ibxLpm7APBarFGLZlgKbnvaSIk?=
 =?us-ascii?Q?xCtu1i5rvJn6ehdrVu/KiBNOXDmA/wjIRxo84xqARMby1neG4jAUQ1LxNMdH?=
 =?us-ascii?Q?vQLtPRNafTOSPzO2eHYKJgGo8e1waTNqydfw8vvY74Td/hAKc0TJYMvmk9WM?=
 =?us-ascii?Q?bpCZkxTBoX66llUVzLMze5p1M50Lix/6YcYzBvN/OYb+vrFyCm57+gt/5u4y?=
 =?us-ascii?Q?tyMaJu7PwwdJZQ8m0YUCzPyc7I3vJEOAB4Pk1la0uq23VscFcb98hympNBVH?=
 =?us-ascii?Q?+1yxb3Yh4oePsesT1MZtczwSZozS7x17wNNIeHQENIEYLpwbw8CzaoOPFflU?=
 =?us-ascii?Q?vkL4qGHk33u38fj3GD8ubKEjaBNBpvADQLQI8iJCj98wUAy12EZ2gSK5YUq1?=
 =?us-ascii?Q?C8AxKBH0tKq73f7X1fQsUT8sgqOKHSL/ZsAx1VCIfWDCdH86WnCBzstVMdVB?=
 =?us-ascii?Q?nnaSlsdygK+VDNEXe+II6fp4Gsr3peBgzLl6YKQyOE3bedx6FDiF8AYU25br?=
 =?us-ascii?Q?D4gn4G1LMaKYgJWtQmOHvfcxZe4JNZlhm4ZuNzimoXDfhYnR35eNZEy/uEhX?=
 =?us-ascii?Q?K49jqCy3tPah7fBtE5FfdFjj29PTwVfeCK+tMdV3r6bUOmRMDQooZ/C3JRBe?=
 =?us-ascii?Q?glJJh8h2tykIiycOxdsNWG4eEpKE7gWithGck3VP7qnFleApYYk+WmgU2Pj6?=
 =?us-ascii?Q?IXgvxZqhsOZ5KRHbWE6AWvo2qBqodynhncciO1ChN5MpDqEvdHer/y9cjG8Q?=
 =?us-ascii?Q?3djJj+2T07txkWsL119G2tGLQwzOaeyxCGsbp28oxUTjrkUV3RDovKWF8T3H?=
 =?us-ascii?Q?3fKxpf6eUe3QL07A2ZQ7Ba0sopUSTm6XYyvpi8etWDU8ZlbCgGy4gnTEEnet?=
 =?us-ascii?Q?0JPora/Nxkt0e1p3ACVPHe03nemxMKk2VUmFzRQZqBQT5NHhIQ+34Cu1pydN?=
 =?us-ascii?Q?vDfh6ranLoS4bNYoR2n1dyixcOirup/0TfaZDPSitgQJfLE6WK1cmz4+Pf/3?=
 =?us-ascii?Q?CR6aQJFAKQoCeKyRr1UCOPT48DLv6JDxzyOs4ETgz/9VU+IYJR1HhkCaneu4?=
 =?us-ascii?Q?7ls1JXh6gO+6AuVvPZ161bZk54Bw5pcEZAiL9OUZvftAdVcAx6fgqAOlgilY?=
 =?us-ascii?Q?mYghp5hGVNvV2gCLcjE52eMG8CINUgTVAcgFTNirw/PhFpodv7mQxd2JW3m3?=
 =?us-ascii?Q?LTWYLTSbU/vqAIUvjf+uQ2g=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b36f5b-f646-4b18-6c23-08d9cfa5b167
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:40.4096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kl33WaMWYbZ4hL3SsmkNS3ZRz9KmZCVboFqLLtUStNbPN3AmYRyG4ObbYnjzkV5Haa1uIFfu69c8H9xUsEeM4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both dsa_port :: type and dsa_port :: index introduce a 4 octet hole
after them, so we can group them together and the holes would be
eliminated, turning 16 octets of storage into just 8. This makes the
cpu_dp pointer fit in the first cache line, which is good, because
dsa_slave_to_master(), called by dsa_enqueue_skb(), uses it.

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
        struct dsa_switch *        ds;                   /*    32     8 */
        unsigned int               index;                /*    40     4 */
        enum {
                DSA_PORT_TYPE_UNUSED = 0,
                DSA_PORT_TYPE_CPU    = 1,
                DSA_PORT_TYPE_DSA    = 2,
                DSA_PORT_TYPE_USER   = 3,
        } type;                                          /*    44     4 */
        const char  *              name;                 /*    48     8 */
        struct dsa_port *          cpu_dp;               /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        u8                         mac[6];               /*    64     6 */
        u8                         stp_state;            /*    70     1 */
        u8                         vlan_filtering:1;     /*    71: 0  1 */
        u8                         learning:1;           /*    71: 1  1 */
        u8                         lag_tx_enabled:1;     /*    71: 2  1 */
        u8                         devlink_port_setup:1; /*    71: 3  1 */
        u8                         setup:1;              /*    71: 4  1 */

        /* XXX 3 bits hole, try to pack */

        struct device_node *       dn;                   /*    72     8 */
        unsigned int               ageing_time;          /*    80     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_bridge *        bridge;               /*    88     8 */
        struct devlink_port        devlink_port;         /*    96   288 */
        /* --- cacheline 6 boundary (384 bytes) --- */
        struct phylink *           pl;                   /*   384     8 */
        struct phylink_config      pl_config;            /*   392    40 */
        struct net_device *        lag_dev;              /*   432     8 */
        struct net_device *        hsr_dev;              /*   440     8 */
        /* --- cacheline 7 boundary (448 bytes) --- */
        struct list_head           list;                 /*   448    16 */
        const struct ethtool_ops  * orig_ethtool_ops;    /*   464     8 */
        const struct dsa_netdevice_ops  * netdev_ops;    /*   472     8 */
        struct mutex               addr_lists_lock;      /*   480    32 */
        /* --- cacheline 8 boundary (512 bytes) --- */
        struct list_head           fdbs;                 /*   512    16 */
        struct list_head           mdbs;                 /*   528    16 */

        /* size: 544, cachelines: 9, members: 30 */
        /* sum members: 539, holes: 1, sum holes: 4 */
        /* sum bitfield members: 5 bits, bit holes: 1, sum bit holes: 3 bits */
        /* last cacheline: 32 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index a8f0037b58e2..5e42fa7ea377 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -246,6 +246,10 @@ struct dsa_port {
 	struct dsa_switch_tree *dst;
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
 
+	struct dsa_switch	*ds;
+
+	unsigned int		index;
+
 	enum {
 		DSA_PORT_TYPE_UNUSED = 0,
 		DSA_PORT_TYPE_CPU,
@@ -253,8 +257,6 @@ struct dsa_port {
 		DSA_PORT_TYPE_USER,
 	} type;
 
-	struct dsa_switch	*ds;
-	unsigned int		index;
 	const char		*name;
 	struct dsa_port		*cpu_dp;
 	u8			mac[ETH_ALEN];
-- 
2.25.1

