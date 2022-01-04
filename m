Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99F64846CD
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiADRPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:15:09 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233884AbiADROq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNCTyZ+iwWutsdoMDOeml8FC+UZqopNULNlScELxQYupawIVAYPzltHrSeOXwosluldxki/YlMverC4+ewMAoicmI7DGkVs967He6lz9wn8tgT6mzM6KY7ckFeV0n/q2WpOtDziKhiT7/dryA73vogyXkTbbXs8lFcCQ40CyFMyMCPLMhOn2T2E705zTmICrKQ1wP4UnHov2WhLnDWJflAovVxdP/g7CmDxp6e6NmphBP5ss027ZHXqokmvJEaCbsXvETqPpDe4kmzFjE7z4kzkYO22na1dax9GtzkoaDvduV7jJIy9XZV8dFOgtArL07ZjukfUEGCEZBcVKGO/Xtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UKrwzzw3/o7/9morQIfzIY9KE+aQwy1TqbbcCH/VCuM=;
 b=drypHfgfkUQannvKHLsKg/o5krzYuOM0iJMrz1iwiaWVHhaNK4iDIldAZMVG+Uwbu+n9YKMPQVmN4CmpPII+Z996qKM+L2IhAfvffZyu6OQKDJKQkAg+fX759/++vWypY67sHn/ohXbjE8vKuar8XCz/PKT3tzijPImCHkXq3bdG1o/81V2VO4QY/i8/yO3z+sHFXngR05WM+QtBURLRA7VVRixeEnxRvsbnn39C7KAbYqB67430LTLEpO0eRTWSOCaLaW4ITjyWw916otqSQrlKFBCdc4+u1wlOv+6FCq1W+j1jiPWYY11AdWTfzD8zjeJddZ1TiiSWQtrNUUjqwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKrwzzw3/o7/9morQIfzIY9KE+aQwy1TqbbcCH/VCuM=;
 b=TK/G0im89K+llim2nVVZQV0R+exkd5VmOjR/JzckO2HIG8ez7BMmkha4/4AFyGebbuAWmnGfPh2pp8wDp/X9mQY/bWnrmqyLdm6LmjxKETYw/51W1gf6MZmqKRkJfMvoUFZse6GcZ/9AQNXIV0h8XRLt8JT6AJKKUkioufEvwG0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 13/15] net: dsa: make dsa_switch :: num_ports an unsigned int
Date:   Tue,  4 Jan 2022 19:14:11 +0200
Message-Id: <20220104171413.2293847-14-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d1b68fe5-b007-4502-9596-08d9cfa5b279
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104DB17227C4C9D6005A7F0E04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OelnH+CeqJ/7fnSXzobgztFY/aRKyf0Ro6hnlKNkD0I9H3pEJHHBirbC39t3mIKE4W0iGEnlYpD3ycVLr1K6bE2dEhVeD1f2ejvpctYcr1uR3I4Oto1EcB9nJQ50VzwMYMKaVbaUemAV2OoSDaswjZp0FPX8aUpJctq4AgDKTjdWmiaYDJxTdlv4E6agvt7r9IwsBeTXeJxi8e2rtsFNHb0wHUDIT3hDzt37RzE28lpuU/4QtNGybwlcan8aBBOUU0RgAv+8sW8g0rpMq0uLyS6W1x5cM1MfXVo9i0zgL2s2hEdxcqK9JeSDntiuOmuEK7oEaDCyXXlp32LSHBiMiUsm9x2RnDMnbmvLqUT3U5PFDCiqz18oVBe35fGrZccovT40E5HO3sP9EXyqszvMfqsxeLl6ClH4whNGL5gt7SdtVGlLiuiLCIqhRn8/Dir2bTGUJk8uAMqLIQLEvmRj1nLKDeAYLiGtNBGzL0rSa4tkWqGdBV0LNzrXCMBwpGVl0zQ2jM/8cREY5SEvZNVtgKpWyHmcyc8qt3PMqsWUV9kiN5aw738YZ9cP88KK7CeXP1uajD6Pmhvx9puu0CVJR3L8ZkR/tpDbXfvP0H0NnEItrq4I4HqT5tcGhFc4HERVeMq4OIcYZOwtPRfO6iDZW0JH+E23eeijQmuCJXAl2Y0S/jV5PvcE8FIDFBfNGX7mvu3M3qtMuYxtubIKtvihRZx0KOwi0JBMFSyawyPipHs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3eD4mhT+gMaPkuKzHjEUq7NoH1Q9C+x/jDTjIA10KZ/gGEIFarWfXdPh1k6j?=
 =?us-ascii?Q?zoplOPEdsbQaPGntpYqPkf5OlVi1nsxE7hahACmW4QBwoDl63y9O1rDx35XX?=
 =?us-ascii?Q?8fvuw1SuXCoDNrtiok4X2AjOUqCCsPYH5z5pXCqFG0dwsWOJ1w/TP5gvSRnH?=
 =?us-ascii?Q?Pa3ykwA1lFbBPPkzFcLj7fHBhheeglxnLCWm6zfWX/+cTaKmItAYSx/OU/pt?=
 =?us-ascii?Q?fBIfUcntv7VJ05aoiREyTklwzZkhyyp0BGJqgjssk9z1tZb2A8mfX+DgSTfL?=
 =?us-ascii?Q?vQEiyTnTMrQV3ZWlXz7PegJaCAYTbOWVW9b7gFYlFBsT7HIT9op6GK1jM81N?=
 =?us-ascii?Q?Sg859xGW2gGbLeqgPa1lZZL1wVezJRXvI+5bg3nn0kedy0nDNY0SdlA894E3?=
 =?us-ascii?Q?Do13YjerLb4CpB/xbsbE2PSEi6nuEondXDlXf/g3dYCjUf3J2F0OKjeAg4Ma?=
 =?us-ascii?Q?FFO+eNLwtRllhtl95zt/TeQilQo2V1ktrJ5anOZ5viP0qVnG5IzZN8jcmNfJ?=
 =?us-ascii?Q?VOMUCofJfJVnCrPhqa5EQlWpzqm6tOgWfQjmOIJmKjYkN+MgUzj0/6F0lpPx?=
 =?us-ascii?Q?CxOuu3l8TXsjZidX6X1lDO+k6lvrfkM0Um0q/GmdzHe2BBKwSdEi925DqBKc?=
 =?us-ascii?Q?wnW7Eq77njbMQztLmgQ1L/bKqcp+wBzgz9g0c4tvnCp/QMu3Osk/RQxbN1kg?=
 =?us-ascii?Q?eBIM2SQ2PEFUw7QYHkrEc40lSeJpYfsuZGE808nSVHWO1RpXecRUvPU4/ze8?=
 =?us-ascii?Q?UzVyYbv7XU60RjujZ1YAhH0WVdGVRbGLXLowlAbmY6OiwXsUL7DSbD1eGMFi?=
 =?us-ascii?Q?/GA1SwoKBhhZv8GZ6qGSZYUK/+ysXsFvufvLGjmRYo4cFeEH3qRUYYbQKkAN?=
 =?us-ascii?Q?PTmwtlPeK75GHg4RMynt1PkYeTkVIFdMj7ZSV+6S7DubQm4KqsL/GPV12v8Z?=
 =?us-ascii?Q?SRV1F1Lp6a7qlSDkpuvsf1MVxZRMyzQt8p3RSnjL4IVG/oovWUgO6C74YJhV?=
 =?us-ascii?Q?IVekC+ybfDChcmZHYhpGFGiWKKxOnGA6hm6VKVAxfx7eGNLDQt+xrelTRtS8?=
 =?us-ascii?Q?fh4eRqHNiNs3lpLcN6I++bbnI0Ygjx+kzewldZcuL9vrJfzmQ6UmJsqxR4OJ?=
 =?us-ascii?Q?p8m/8TUpF0hYE8902VwpaHw4+A8vo886V42Rsp9Mjuxj5VHH3tj1wi1mlUkD?=
 =?us-ascii?Q?pT+i8IvkyOh7mXxlv++pQNNReP5msbvzNBOFX0y4cqKh8A36qI6Rc0ubLH3y?=
 =?us-ascii?Q?8dTgda0TdO2r8pZctkjUvKiBFYePNad/E9/cRYMi6cUPWd/zVPdZZ+x04FsA?=
 =?us-ascii?Q?MQ0/CmV3EOSSkdkKEAbvdOosqA2GFCnYF7BOIEl2LLSZtS5sJ21BONHz4qln?=
 =?us-ascii?Q?GGtQnzQ0WoH9QiYoMbWHRs7qhcjXjcFX+gN5fJMphBhTNcIPdIeulSZNMg+0?=
 =?us-ascii?Q?Mqaa9Cfc7RzbWsn128jeuTiX4SrsnVDK1K2wDYUmSSFSKAyOt7gDIeylhebm?=
 =?us-ascii?Q?C6qhPhbzLYplj1Oir+7w2AyffjOWgXWymIhdlghpbC1+l5a5hrOiHmltyupy?=
 =?us-ascii?Q?NKHfT0MOiG0vQmr5LeMGpG4uREq5snsi+4esb+8JYqBWVIf+NK3hlCxAAYt0?=
 =?us-ascii?Q?3FmuZIUjkieTGNmaCJQPlWo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b68fe5-b007-4502-9596-08d9cfa5b279
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:42.1908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96JhQHnbAMN8ahPVonL94zeWfveEi1N5a6prkaKWORdss02/xilqvQm0eu2LQUQqO8AnbG2iVFfCyI5PPlylNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, num_ports is declared as size_t, which is defined as
__kernel_ulong_t, therefore it occupies 8 bytes of memory.

Even switches with port numbers in the range of tens are exotic, so
there is no need for this amount of storage.

Additionally, because the max_num_bridges member right above it is also
4 bytes, it means the compiler needs to add padding between the last 2
fields. By reducing the size, we don't need that padding and can reduce
the struct size.

Before:

pahole -C dsa_switch net/dsa/slave.o
struct dsa_switch {
        struct device *            dev;                  /*     0     8 */
        struct dsa_switch_tree *   dst;                  /*     8     8 */
        unsigned int               index;                /*    16     4 */
        u32                        setup:1;              /*    20: 0  4 */
        u32                        vlan_filtering_is_global:1; /*    20: 1  4 */
        u32                        needs_standalone_vlan_filtering:1; /*    20: 2  4 */
        u32                        configure_vlan_while_not_filtering:1; /*    20: 3  4 */
        u32                        untag_bridge_pvid:1;  /*    20: 4  4 */
        u32                        assisted_learning_on_cpu_port:1; /*    20: 5  4 */
        u32                        vlan_filtering:1;     /*    20: 6  4 */
        u32                        pcs_poll:1;           /*    20: 7  4 */
        u32                        mtu_enforcement_ingress:1; /*    20: 8  4 */

        /* XXX 23 bits hole, try to pack */

        struct notifier_block      nb;                   /*    24    24 */

        /* XXX last struct has 4 bytes of padding */

        void *                     priv;                 /*    48     8 */
        void *                     tagger_data;          /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct dsa_chip_data *     cd;                   /*    64     8 */
        const struct dsa_switch_ops  * ops;              /*    72     8 */
        u32                        phys_mii_mask;        /*    80     4 */

        /* XXX 4 bytes hole, try to pack */

        struct mii_bus *           slave_mii_bus;        /*    88     8 */
        unsigned int               ageing_time_min;      /*    96     4 */
        unsigned int               ageing_time_max;      /*   100     4 */
        struct dsa_8021q_context * tag_8021q_ctx;        /*   104     8 */
        struct devlink *           devlink;              /*   112     8 */
        unsigned int               num_tx_queues;        /*   120     4 */
        unsigned int               num_lag_ids;          /*   124     4 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        unsigned int               max_num_bridges;      /*   128     4 */

        /* XXX 4 bytes hole, try to pack */

        size_t                     num_ports;            /*   136     8 */

        /* size: 144, cachelines: 3, members: 27 */
        /* sum members: 132, holes: 2, sum holes: 8 */
        /* sum bitfield members: 9 bits, bit holes: 1, sum bit holes: 23 bits */
        /* paddings: 1, sum paddings: 4 */
        /* last cacheline: 16 bytes */
};

After:

pahole -C dsa_switch net/dsa/slave.o
struct dsa_switch {
        struct device *            dev;                  /*     0     8 */
        struct dsa_switch_tree *   dst;                  /*     8     8 */
        unsigned int               index;                /*    16     4 */
        u32                        setup:1;              /*    20: 0  4 */
        u32                        vlan_filtering_is_global:1; /*    20: 1  4 */
        u32                        needs_standalone_vlan_filtering:1; /*    20: 2  4 */
        u32                        configure_vlan_while_not_filtering:1; /*    20: 3  4 */
        u32                        untag_bridge_pvid:1;  /*    20: 4  4 */
        u32                        assisted_learning_on_cpu_port:1; /*    20: 5  4 */
        u32                        vlan_filtering:1;     /*    20: 6  4 */
        u32                        pcs_poll:1;           /*    20: 7  4 */
        u32                        mtu_enforcement_ingress:1; /*    20: 8  4 */

        /* XXX 23 bits hole, try to pack */

        struct notifier_block      nb;                   /*    24    24 */

        /* XXX last struct has 4 bytes of padding */

        void *                     priv;                 /*    48     8 */
        void *                     tagger_data;          /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct dsa_chip_data *     cd;                   /*    64     8 */
        const struct dsa_switch_ops  * ops;              /*    72     8 */
        u32                        phys_mii_mask;        /*    80     4 */

        /* XXX 4 bytes hole, try to pack */

        struct mii_bus *           slave_mii_bus;        /*    88     8 */
        unsigned int               ageing_time_min;      /*    96     4 */
        unsigned int               ageing_time_max;      /*   100     4 */
        struct dsa_8021q_context * tag_8021q_ctx;        /*   104     8 */
        struct devlink *           devlink;              /*   112     8 */
        unsigned int               num_tx_queues;        /*   120     4 */
        unsigned int               num_lag_ids;          /*   124     4 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        unsigned int               max_num_bridges;      /*   128     4 */
        unsigned int               num_ports;            /*   132     4 */

        /* size: 136, cachelines: 3, members: 27 */
        /* sum members: 128, holes: 1, sum holes: 4 */
        /* sum bitfield members: 9 bits, bit holes: 1, sum bit holes: 23 bits */
        /* paddings: 1, sum paddings: 4 */
        /* last cacheline: 8 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 2 +-
 net/dsa/dsa2.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index a8a586039033..fef9d8bb5190 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -435,7 +435,7 @@ struct dsa_switch {
 	 */
 	unsigned int		max_num_bridges;
 
-	size_t num_ports;
+	unsigned int		num_ports;
 };
 
 static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c1da813786a4..3d21521453fe 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1475,7 +1475,7 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 		}
 
 		if (reg >= ds->num_ports) {
-			dev_err(ds->dev, "port %pOF index %u exceeds num_ports (%zu)\n",
+			dev_err(ds->dev, "port %pOF index %u exceeds num_ports (%u)\n",
 				port, reg, ds->num_ports);
 			of_node_put(port);
 			err = -EINVAL;
-- 
2.25.1

