Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D27448537A
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbiAENWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:22:04 -0500
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:53697
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234666AbiAENWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:22:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejutLAZVNXQxtkXp3mEvK1qi/QxxRc+g4olyGfr7MPpq40zfHkBT7qU/TLWq0CMUs/1RrgdKzkC+EPPPLJcxz5wEJhb9Sktj2IWeR0pB+Yi5HmIWNO9Z/0TyWxIuOlEj7+bDJGklohAESSWGHMEj7yZeQV4qQdoSWrbvTWndJvGBqZpB0b7ALHd/MThe4uPynylsm8NjDBtysvF/8BjpJvjYKUK1f3/Arh18z7SbSMC//wFhA5beTciqaBuq/PD1JMgZYq7gU92eyyjHCR6t5bU/xkP5XL4aXWRAgo195f2PiDiCRl4KxGIjm2dVauU52bKvGwF1rIzKfYy2Ewr7yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UKrwzzw3/o7/9morQIfzIY9KE+aQwy1TqbbcCH/VCuM=;
 b=G4wrS4y0dfFRkPrhLeVJFy4XF/owTaDAKb6SdOJYatMWfSQtgFw3wz6cUWRpKuy34XMUXyYxPBjSPDa4eUy8FHrfVRryXWsOxGgAfg+S99Beg41V5yHolfrvw59tnxtA+OAFOE4vgXpWMfLPQR37xGgBBji9lfDHu/Qw2PHmo+ZmHteCqi0Qu3LVWibn8tWduG8FZKTeHoYACS+pSyWXilWwcYcDzTSeQWVURKhZzvNUlvjhqTQYaM6F6D/E5MuMy7Vr67y3SYeYf2rCaH2g1vmTE6UN85a2sXzsWVh5MXRWF0SpO+mekEfnBYyUJTmYPlzkijZMO9CJADv85mVG5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKrwzzw3/o7/9morQIfzIY9KE+aQwy1TqbbcCH/VCuM=;
 b=TxiwWoNWxpy4dKTJIkNRppVVB6gvEsTGn2fhtiI5TlMH39p78e8tDMrC3wdRECb7qTUF/Qcehbf5r6EbiXJK83H3PuBpsCqnSlYp/U4LUedeEZHv5PcAq8qHQuJ8QbnGmqD8u0psVWRydMj+J8lqKTc/PVf+ubrzs3EJbPpWgXk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 13:21:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 13:21:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 5/7] net: dsa: make dsa_switch :: num_ports an unsigned int
Date:   Wed,  5 Jan 2022 15:21:39 +0200
Message-Id: <20220105132141.2648876-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4c0ce31f-25ae-46d6-ed62-08d9d04e588d
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB74086B7454B2FD305C3BB9F3E04B9@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 89Lg+ELRX85SuPUPc5/ObIAQOiKNNh93t+vdzw9ZZ+4AXlih+k5cEUTVHFqCroqvk1MnTggRgIIJrVnR5KN4AQMmobDJC1GRwECr4+6LI4Oj/U/y0fD60BmOXiNR2vZCp319ba5a4F1AYQRUCjkEFxmvTgBIYmZtSJ5dkwtCea8toxhS2bsvpJ9UXNjqUC6O2aO3FiVrrrEY6ejngAS6utkQbSHcjZGTpYtN7tyBX6f/Os/Khh72Cs8rV3cFYMPN6+OpY8DpBF72ljUJ0D6Z7bqKdZk/mXl50702kkEqMgLyHXpyNuXU1g7OKtnpF003W3umUpQKNG7eN3Kwt/F4l0VpxX+2OVjf47vGTdEq3RqpwbvU6Tljb2Nr8Wpt8hPwXq0xTlr9KOziaUoW1xeE5O5AsR12U9znthX+g1RedUnCt7aHVplfpZppvZQcqq5CcJUftZJHSwT8JRqCyC8avpwraS4OtBzqMNDv1QHXHZdJ/LHguiF9ZhSXoph7jDK0SWEy9zzW9KXu7HgosDLQ+qDFRfHAKazpznlr0Euh17WdwU1bgIQPFEUqF57cZ9XQtuii34EP7VFAetpfc8bGu/QgmOA0wT7Kipn+SldJS+Y5mnwRxX4t66nwDeN1pwvUDrbh6FOmVZl/yol5q6coZEaq//WxjdpWXQi1Tkj4qiCZT1sMwtljttYtZl4vwt3F6f2N4bEGuFihN6vLAAig5xu8a0u3UfmXYAjaxOKJ2Lg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(66476007)(8936002)(38100700002)(38350700002)(316002)(36756003)(2616005)(2906002)(6486002)(66556008)(66946007)(6916009)(5660300002)(44832011)(83380400001)(6512007)(508600001)(86362001)(54906003)(4326008)(8676002)(1076003)(186003)(26005)(6666004)(52116002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XfWsJFawSjoC8VZG9rlk39jC+S0QAUXCAyBJoyhv3rsrnOhWMggOvbEOekTJ?=
 =?us-ascii?Q?zuvgbHP7jS8q/GkFAMh5yTjlfx4TEGsaB8nkwixXjvZardumqrWKkgmMBhQ8?=
 =?us-ascii?Q?rDSLZcLUk6c9NyB7XV3o8gNWpOuRhd4IIyO4rSeNADSEUCXCqH5nLKvD4syS?=
 =?us-ascii?Q?y8RNm+eS/P1x6ChMuSJCisEF60KSRFgUtlyR/5DJK+cDgNidCYt5/7m/Yxgx?=
 =?us-ascii?Q?/5wESyH/DkkDE1TQPJey/K39yo/sFW2lnlJ29ZUM7lHLR8Caq0YHXTOsSwIo?=
 =?us-ascii?Q?/nrQZsKfqN1qbZ9VKhIU+6LJkb/zsUn++zFHAeFDPKSS1ErgS+Kc6b2GJ62X?=
 =?us-ascii?Q?fC/eAipPmf9amO26GCcpeyXm4ua08uXx9Zq6vOilHB5BCYgfA89Rie7/+Qof?=
 =?us-ascii?Q?NbzGpYFvXoXd4bSjMwJr1Bfrj01zTIhibZANmDoMQ1C31ZSR2/7A01qAOPaR?=
 =?us-ascii?Q?bEy4nIiQJNkOZP1d44D1s77uQVJse/4sMALddNY6T6NgbPvqL28QJNl0o8Ea?=
 =?us-ascii?Q?t8Nd/6O0X1XQQy+1Z36DIWBnlDE50n5Nl0gG1T2EMPWk3Sq1cVKBq7HOZkLa?=
 =?us-ascii?Q?vu5oOrB9RD57BPFVMnhaQRYGeZgNkNDRHCCo5vkKATZnrYivvAmkwvT3gVr/?=
 =?us-ascii?Q?A3/CjYYYtdfVt7PlEDZ3xr5HijJd1QedKYSEVNYajYlngMoO/4ZkQ/zBuw8L?=
 =?us-ascii?Q?NLiec9UltkNWicCf9SqBP1Sgmly4rK973ZfATU6nhEC/FZCin99gNvfKcTeI?=
 =?us-ascii?Q?tZUXoSEv3TEF87v8cQroZ4jYalmd9XlgIQAvLccHUzOc0mcBnA5LHUB8ouLY?=
 =?us-ascii?Q?NtWZCOzx5vRL7t3tHrTgsCu3Ij8ecYrITnUKye4c/NuegjuuGeh0fLW+b11T?=
 =?us-ascii?Q?PJx3zW1gK2AHvClA2EXmOkH9NTCjrJuhQa975mFrlCIIw7mCY6/s14XoF01W?=
 =?us-ascii?Q?7Hzx9tkT6Cwb2qhX+CPeJX7i4Rt+8bPoCKhshO7U/TnFtqv1/Gv5tHLjdGWy?=
 =?us-ascii?Q?ZcFzjRDvAyAxlDAQ+ugDmgfJ1nS9mWB1s23FRVZYBZtv7iqJZIcSTi68sWZo?=
 =?us-ascii?Q?uMnj2L+v5sM2U2F2Z3U157TUoHDrNmnkgi1B6UjCKnY3hIAqovVy3skTjvzi?=
 =?us-ascii?Q?Ya0dXHLlvk0XALGSeH/ppR2iZg7MZV+zPCNoMG+AEDmDpy88k65xtIoO9ARw?=
 =?us-ascii?Q?I0tWub5dLvEY5qzppjr3d/rNahZjVpzSTOb9JwHN96tTC87CrXGHUhUf/JgM?=
 =?us-ascii?Q?JC6+272iwcDzWBh4gs7mNUEkH2y1qkYNv/6eFrf4GQdnaJKYLf97YlKkpPiK?=
 =?us-ascii?Q?oI4l6KWLarrVDF7IPm9Obx9QEDLSd4tfG6Qj+GQpvKBUbSAYXlvhOlETiQAa?=
 =?us-ascii?Q?1EDCv6QY7oLLL737mLvutSJavpuhQpwsJdvz7PcaErylhxOYt3pcRx1DVCFV?=
 =?us-ascii?Q?V1tQIzXU1NOVToAKH5G0IiYAr8EE0PUY5xYG0ZS+6dd+YumyNWdDmGSDrVbS?=
 =?us-ascii?Q?w4z1YhdL8IojYZfu1WdvXcH4NlpJPcvXo4Dgue/KWt05sTJeGsI/aZL6h/r0?=
 =?us-ascii?Q?uYzl2Xgqnim7rPL569IJ6jW+luGgaLpjhWX54M8tPbslUQyApQkLV/hx+VmR?=
 =?us-ascii?Q?+RQauiGIqtEIvnBix7ZqJPE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0ce31f-25ae-46d6-ed62-08d9d04e588d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:21:56.2921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xgdERrAwJjKSWFgv72jzkIFYsVUoz+V6JYTIVayTO1MK271invXEPXCDh/jPw+f9gYaKCJZXqPrgVWNkkqIybw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
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

