Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BF84846CF
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbiADRPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:15:12 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234323AbiADROv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvDw7pl9QbcybvLboSXNMC/E4YZEUgUo8a5e5Jh6HxN29pVM0zW749ZcrC+WdKWGE8zjq6UtzlAXnxYkRrS/ddYCF4TbBgMwsKySm5LQga75I3GUof0ScDVBTSEYqTWHF48Ra3b1aWregJgTqey1zBE84U7By6iGjY4/trNNKHfJAJBW3T0NrUuKsfeI3RiqZuuSeyu5lSDChZFop/eAvRiBZ1FV2hN1NVrqqKWpifg6VLgCSRh9Sxi/yaHVGy/xzxSQ0I5oOXprzBgK3//mhpBfAvpEOl1vh+2tKO6xthJ2hHMUiE2XMFm9EvYdl0vX3bLT/N5plWO9kF1BZ3aa0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mavQUYFYXwhcIFmdkles8ujxVOHZYvjvkNhUq/6aKME=;
 b=chRCHamcbgz1Pd1HmjJJnke9aVByXqRwUYeo7c/rMcIzrm0QpgEq36Hh6OD0zhEyb1eVpjz0RfKEFgZnQuzsgo/3IZnNrGWebtio+ho0G2AcY8tR0NSBjlCcUqYFvaokBAfXuVus2gtYWFQNzs6n2te/SDWmbsDv76ZL7a/D5jwpI9WD43/1hiO0mPVLP6FpPG78gf1etJgfWUizCw/c1dmSVk+0ZMFH28ndlbVqR2RBog5q+16RVEaf8pMopNKEKNsNqgF9pq/LUNdJKhT+iSMhVkEWY84zbBnI3HVmb4IhBDk9+G+q/eFMQzin/+8ryS+bH9kdbhNFWrUEKZ/TCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mavQUYFYXwhcIFmdkles8ujxVOHZYvjvkNhUq/6aKME=;
 b=QyL1KTrFVE6CjikZ4KwcyvEmPXuM7ldh0mKYQH1ATI4v8UY6ErLVtiZUxqXrFZpxFKJJn89KDMXbeWceo3LFst+nZ708gV3dtJ4bQUqrTTzxvg4y3Io5ICqVPWycB6DCxBIpChU5ZTO+LT/Ph8K3Bzjs82wQVgXI6+kGiHan+IE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 15/15] net: dsa: combine two holes in struct dsa_switch_tree
Date:   Tue,  4 Jan 2022 19:14:13 +0200
Message-Id: <20220104171413.2293847-16-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8969788e-1d1e-4d5f-7153-08d9cfa5b37d
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104D8BAAF88D143AF1F1DA0E04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3LjFV6H0B7MKEanxhPWczsrbL/HeE3V3HiA6Ho6iNy0376yrI0QYTftVKKVBbkmnA2HXwR0VSGk4Vr2HnBO7egyAzbxJ7ZiX3ziqdQ/eKAgviSEXeOqaxJ5cgbIHrh+Uo5MqCHxAZBwN7vonaGTE4u7aggkZJ1av0/X11VcgztopZYUpqLncy8YrBgJzN5t39Y3qRl1IC78f0UvBZSyQ8OCTzAQT0wDxT3s08aIeIPSWyNH1JFUPlh4wicsJRRFb4efTHT/ttosRH0ukFoOs96Eri2FNhE+1DSGyBuD9ekOYr2rasRZSOQEnNIFDPvp0za0trVU/iwfefrjKgzaiBHoqutrRL8245rmn/BNgPgeokZLjovikGfdgedSEyywSg3eFtmw2G5o6tHMUtdiJ/Vh072ANLB3hvoG2F0P0ww6hVFi2yFnukOV/vdCFxbLah5sLKv29VjvoB52CoiZpluGO7PJbX1oYorelbLUd45JKdD0LlnaqL3zd7FwczE1tlydwuqbvvDLO5nROGl5fu5ZxWbtALqFi6SFCSn9n2MBJ9pqCLXYR6cn5IFE0X7YdkvuJxJrouq9zU6bvPfS/Sqem8S8ex8382PeytjIdSvskScP2EGDlzqn8WlelAgJgCQoAETGB0z+Lbckg98uOJJV4fFceIJgt+xMnt6GoiTpAIj981R/mYOxgGFh/J7aqyYbqoHWljOl7E+4M08HUfzAQOA/mYYFR+LcPROsZA1s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F6RUXcIe/vEgZb9ScCxUb8Ul9a7TXXCL/iJ211hDaBSS7j72P4yO6Tj/F0ye?=
 =?us-ascii?Q?bpVZGE4cTkIj65rxFDoDe/zrQUfLEa3l6IISq4A7d7BcLld/w1fha0F4Ukx5?=
 =?us-ascii?Q?T3OGvx0SE4WTw8iwa4xrw3w3s6rEHLuySfjUJsKhjK+npL6wcWww1U/PpvNu?=
 =?us-ascii?Q?/M99gas5XYjDMPcu3NbnWythXC8DMkB9tbQW2qJ1o70WDayQWTQxY0skSnxg?=
 =?us-ascii?Q?BeSgdL/0K5Bp6nzOQGWw0iQJUcScl6yrVqBfuo1x8WN/KTJK2qxIXQAi1or4?=
 =?us-ascii?Q?jwZj5cZf1DSlLLX066nzLm/S5ggKhdXFcWLL2orRmf8Vj/RqzobHFjjsYQFT?=
 =?us-ascii?Q?x/WHT+zQ8fUyBiJomdIRxPLjBH5U5BezOlLdteulPBRUJHy0EjUCfNKAHhHk?=
 =?us-ascii?Q?0vSlvo7K+rciRXzXhiqwHBi4VrsRPfMAtr/7K42vYxYJZN7igjnR3GIH4re1?=
 =?us-ascii?Q?dkC7d9NNDRwe5E/P/HYOEDI1hVhXCxzCz6YAOBJx7Gih/l3FySttYt1MbmxQ?=
 =?us-ascii?Q?RDicZajsO7dWc9yX4L+WDPJW2doQgf6VA554TrmWBK3GAcRChMuYjJ+Blg0B?=
 =?us-ascii?Q?NdTnhnji/cOLNTf2iR3pzHW+1Pic985J3ffT6oMvu9xNd/XX0/49n20NLrws?=
 =?us-ascii?Q?YPrHxKkOxgjvr5GZQAD+V8iZHRHeGlXfwjTM8sXpo05KuOVayAka8OKY8UhW?=
 =?us-ascii?Q?Ux/PsqdWWj29QjgOGe4muTXam5WSktLqCZsN8GlMKEJN9ZMOQSRzgwgVlhIF?=
 =?us-ascii?Q?HD8ur3162C3PiovyNmRjbMw6wg1eRcXCT7h38eLCOl56Si2wNQ6AqCNi/4gm?=
 =?us-ascii?Q?r4gzSLDDe3EjmdgcG2SoFe0zLLfYC8F00zf0Bniv5Z1cl3waSYt5ObCvPUR6?=
 =?us-ascii?Q?kslL8Zn8nf/UHq04P/U9/QpYlHBPOloqq4dE0IbSub/4DUjbfxubQQnTEoNe?=
 =?us-ascii?Q?C9Bg0dVenNAy+1Y4RUms7kFVVW6bvC9+AZGZN3SVbRupR24ErhWjlByiaxuL?=
 =?us-ascii?Q?mrWEfqhuTmOzovzJarYcYr6lNb+Bui2U3+GqNnmlhsi2/8iM8aizHSxN8RH0?=
 =?us-ascii?Q?dNG9aK+1g9FWD5puYH95s6tHfpvAcOV9XDKLity6hy5hKmHInD0qsYgeFiIr?=
 =?us-ascii?Q?SKorasQiJw2l9Lj9jWjbvNdN1dB7sSRz6hnXsusXPGcLDnJz1dAXrlLUyuqR?=
 =?us-ascii?Q?DHZCWuTl5J5RwSKSB4pAxGhHLA0ofQcT+X/rbjBS8w7tbHdNwEc0vBKrizzW?=
 =?us-ascii?Q?gtGqFhWanBqR6pmuulai+Qgh9bmD0+ufdivl75q6z01CETqY5IA6jGQMqeZ7?=
 =?us-ascii?Q?oU04fpyyh/WZElMbm32jACw8HN/i4NKHUDXOUtHKKgn9fCs90tqoIrhMuqca?=
 =?us-ascii?Q?3iXM74YWqZom5G5B7sc65bNKvfKF/Sahl2isfdnXRfudkhoU2PmG2LlmwwXh?=
 =?us-ascii?Q?3O9ibEmsMXY885ZVWKkjCwDWaaq7vs2wtwXZ/SuxOSmFCp15HPJxQU7+y3j6?=
 =?us-ascii?Q?hh+4Hhl3jAo+2UnwMhkIls7GA3LldbPan59pJ1fEzRhUCq8Ruj60wRZdWm1/?=
 =?us-ascii?Q?N+y3eJ+uYVh54eyiLc9tqw6SoRPL2eDnyUEELSEKxkNlFpuBHbnGgjlcBIxG?=
 =?us-ascii?Q?6C7Wh7uEVKXDe2XtF2mcUfk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8969788e-1d1e-4d5f-7153-08d9cfa5b37d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:43.9094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TB7y3XaxXWPF7JBfKI2G+IfZ9LSvM3l1OAp04MuwudIAEdB4lwSlKsoh1xvWgWHT0w+LVAlbh+zMpGC1J42o5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a 7 byte hole after dst->setup and a 4 byte hole after
dst->default_proto. Combining them, we have a single hole of just 3
bytes on 64 bit machines.

Before:

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

After:

pahole -C dsa_switch_tree net/dsa/slave.o
struct dsa_switch_tree {
        struct list_head           list;                 /*     0    16 */
        struct list_head           ports;                /*    16    16 */
        struct raw_notifier_head   nh;                   /*    32     8 */
        unsigned int               index;                /*    40     4 */
        struct kref                refcount;             /*    44     4 */
        struct net_device * *      lags;                 /*    48     8 */
        const struct dsa_device_ops  * tag_ops;          /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        enum dsa_tag_protocol      default_proto;        /*    64     4 */
        bool                       setup;                /*    68     1 */

        /* XXX 3 bytes hole, try to pack */

        struct dsa_platform_data * pd;                   /*    72     8 */
        struct list_head           rtable;               /*    80    16 */
        unsigned int               lags_len;             /*    96     4 */
        unsigned int               last_switch;          /*   100     4 */

        /* size: 104, cachelines: 2, members: 13 */
        /* sum members: 101, holes: 1, sum holes: 3 */
        /* last cacheline: 40 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index cbbac75138d9..5d0fec6db3ae 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -136,9 +136,6 @@ struct dsa_switch_tree {
 	 */
 	struct net_device **lags;
 
-	/* Has this tree been applied to the hardware? */
-	bool setup;
-
 	/* Tagging protocol operations */
 	const struct dsa_device_ops *tag_ops;
 
@@ -147,6 +144,9 @@ struct dsa_switch_tree {
 	 */
 	enum dsa_tag_protocol default_proto;
 
+	/* Has this tree been applied to the hardware? */
+	bool setup;
+
 	/*
 	 * Configuration data for the platform device that owns
 	 * this dsa switch tree instance.
-- 
2.25.1

