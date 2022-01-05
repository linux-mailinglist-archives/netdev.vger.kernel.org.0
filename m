Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4123485379
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240268AbiAENWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:22:03 -0500
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:53697
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240256AbiAENV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:21:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByH/fbOKuOVym89GNdt4UzZeefYYRRj0dmc8cpysVou1LM04nc6NK0FXduTr150ciaeInmDUlomdOKPkoDkplXxZt/WkRej6U8uqSMeYdCmqSHsGciKA3P6GyPvJhWrsUc4DA884H9vfD9fu1/YOmTqJraJ6vIaBxiBHcXs99ZY3twib0/rS0oKRg3wayEIig+PS/DBZOddVmPcavMrCj4okxWfs8Lst35p6Tggv6Znox7gDuN0H1M9sCGhq5iBUneYWwJMlY4sr5a0QnzQ0QwhgqL39iZg66IYeI3YK9DRsQSsBgdB396jpbBO4M/2rT3qqT3uohxhY9kzkM5/k1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4r/+JADHi7tHwdY3uObPHJE1fi4/O02LFgLf0E7kLao=;
 b=lH9U+OoS4600UchAFI+KeobWm0451N0g6hOsT/ohaiyWVeRCuaPhz5LhqdBX4lhtG2owRQl/r/AlLeT5e69Lcmpswk/DDq3SF8YVmBEM1i/GezjzPm0+YrhTU/ys8fd429YqXIgQtfrZ8FP1tTPVugl0b899TxPO1QKg2WohwUVoJ85nMUdPxqGC2QLLrB07fk/KZDPCXEjhBStU6vo/PWCEyegxAizYHOVN/n6fTlCi1qbJBCbZyu/n0MLYbbySUKgrSlTfJLK2wyFZptvk3XNLYt4GCXLiX45VFRkYvCnom3Dt/oxkRxS7+YZ2h48iuWCpazcJiqTu+fFuAzWf9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4r/+JADHi7tHwdY3uObPHJE1fi4/O02LFgLf0E7kLao=;
 b=Cbj/5M9k7fCpuoHbOtXsNJ+ho5zCH9/msRJlCgQq7puEcSc9LwV/HCGMXepkCwKi/Oh5YCbKbdkwVVQi8xnflUmhFv0/UgCl/6VpQwbvIuxldViXEDICSPIgoU/Ym8PrEfJRhIqpw2s1fP0ynhbBgHYggtZT/4UBPuLHbL58aMU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 13:21:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 13:21:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 4/7] net: dsa: merge all bools of struct dsa_switch into a single u32
Date:   Wed,  5 Jan 2022 15:21:38 +0200
Message-Id: <20220105132141.2648876-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: eafe07a3-1dda-40ee-6c2b-08d9d04e5808
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB7408C9DED4719D81F725BCB2E04B9@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4DGii3L7KdCQ6NdVi0cAvcvt+GmzRWePv7SBkMcepvp4EnCdVS1Q7ooy86tIGwlfBo1YWPExKeY9tu/zrj1GhSgS3F9C3OP6cJRSUo0UnHlEL+uxTkZxHCfiQNmZ6YwvF5r9OGHOv0qUgV9fjKka+VMuP12aKnFPsfi1DX2NGEIYAQqrQqplx3k/M2Fx4lR17SMvdY3KcNeNSKGgGFEHB5Z5tBbNRlb66ZkXKrC9owIPmYAWRE0F6S+J2y52AMOhiVWEMqJ7JIjokKm3wYrsgW8zdjX8KSPN9W4Wd6HOfy+llLZ8seSSlLp1GpKGb5b+z5GJCpksjP57S4XazCrSghH/7d0GamRVU0xXo6hOr7gS6kBrpGIT2trFhDzqe1LJdZUR3D8KQv8Ku9wKQVgMBA5QnPej8SDkthLylkMo0bTJxyzWEkAfjtGBeyQLov/KzAmXW8rl0mcB9aIIcett1U2Lo3NVqB86Q68HeKTQHn60eG9mEa2lwHTQawhh09Y+oQVUmJQbsRkcybNbNRa1EaZmZFM1vKIUjDNr0vDSvZIqwjAC5WshRIUlldRYdL9bJdms5ibrX7qIyW95bcmhNf3QH1TmGij2l11TmU7Td9RVl8/jd5cjzVOotJw6C6WtWeMWjFJaBwGugipqRlnJv5duPBEKZ4/0ehLWnJP1QLY+xlyr8w8BGzYSm1UJLtWu6MQ366IITGx/dHexwPMgHa+LsUfzCIl4wjGTkgb0lQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(66476007)(8936002)(38100700002)(38350700002)(316002)(36756003)(2616005)(2906002)(6486002)(66556008)(66946007)(6916009)(5660300002)(44832011)(83380400001)(6512007)(508600001)(86362001)(54906003)(4326008)(8676002)(1076003)(186003)(26005)(6666004)(52116002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WqRVrqCnBir4mZPcePdMUvvizuYfolOYgMiIaKJVxxuktdWpx515EyCQOBip?=
 =?us-ascii?Q?NIRsWcK8qb2qFW5l61K30KNc3UewjydXId1ccGttpA4US8vWeVBX6chxXLCQ?=
 =?us-ascii?Q?H2I1B0wWtOZyXsz3siaFvhXWxqJlrbOASs9Rdg8iQqXRL5QT2eFFHcPSbenE?=
 =?us-ascii?Q?5vUv36dLXbZ1c1dftiNy6zDBGYFI1+TFocvxdSuZDTfEunoGw3pH7matC0yh?=
 =?us-ascii?Q?6kHOXKjdRs/l0ywp3CW/JwTpznqEpOSLyP0lrmAykxaQInWbg9LrLdEIuq/z?=
 =?us-ascii?Q?cgfsF6AmiUHOZExOA+YOmt6BEcQfx8f+mV1a7eY8736Qk6QSddIHc9RR+7Kh?=
 =?us-ascii?Q?LD+CjwDk4FXcXf/82DNb0QO7aviiFkqcnhSb8lwIS7cg5/bKRNgXg0JHb2sg?=
 =?us-ascii?Q?KWI18znu3on7lX4Z61r+1Uwl3fz7WQmHONtHpPHEwYpmDDb4PciGt46BbrVD?=
 =?us-ascii?Q?+3pij7chS3y4ygNRJWkDRqX6eP7Mc+LUzCTVuw6wzhFYzV/bBde52o9Jp9WH?=
 =?us-ascii?Q?88KzTYRFyU7EfNsdeyQ1MkJVXRk+t/h8cR7X6kZfovzrl3TIHTYg6oGbUF/Z?=
 =?us-ascii?Q?L0R+QxE8K3d9R+FgvoRLDsSCWAXji2wuVtVOraZz4PeraNkWWZLLtjN3vom3?=
 =?us-ascii?Q?CclmAvXcBbc0iHxQ7Dyf8vwn0LsrgWkgtsGwrVrMd/oTIvOOjgLBNn6Y086l?=
 =?us-ascii?Q?lRaAR498cWhASG+4dd2tuw4o+eCQMaOEGAa+ByO0bScySuOo1tfPSloqisnT?=
 =?us-ascii?Q?YCVnPFqROhoLs/gk5/7RCwZrTMyUdrDsjLlnCS1NW76Qb7KkdIPGV/dsA0Cv?=
 =?us-ascii?Q?XGyQ7d8PpFIXydk2Bn6YT0mto0q7XFSVf2/9VtccE4ISlzEaiL8loS4BKw6M?=
 =?us-ascii?Q?Paalgl5Da9ZKacGRiLHuavPXmbfn6IUAq3vBJnausDsYZOEM/TK5aAVQtZqI?=
 =?us-ascii?Q?jmGIsJdwTv54pMH37Nm+axr6a92rolsquJRPfNFQlsSd2C6xRIZ5ruSoGdl0?=
 =?us-ascii?Q?Zf7mcrfkS5zAJM7Y+kBc/1zhDKL4BtUzdjsAeQ5BeQIKl3Kpv7pipwRo9yzX?=
 =?us-ascii?Q?o3kCIBtA3RIkIfr1wdTzqYMuA9mXARUPOXda6TzIYrUxCilq9NoodhuQ87ia?=
 =?us-ascii?Q?1NX6jsggT5tWhbcW9OmbYmXtFFRiN4A1SXBW5TOMLEt5EQytPtMkaxZjhdb/?=
 =?us-ascii?Q?lQ/dCAn5g3Ze3T365GcMeNG1elTJLebEKrITTrpIOWjb5HGpvzXSe1Pg4nfC?=
 =?us-ascii?Q?h0a/Ix8ZfHonJ0kHdnwhExwZK/EInOeie4NL8t0DnbK1pBZkp1IIFOWUuZTa?=
 =?us-ascii?Q?/OUzwmbRLzk+eX97kX4maU+XiztVjAxRK3dD4u237RBw15n9eWORMYqT3546?=
 =?us-ascii?Q?I5PjLNYqp+8PCKhW5B4HFZPLf8QGWkOnKCmIVwDILAABJ7gVnAzj2e490mUz?=
 =?us-ascii?Q?UetS4pkDBgeGtGkaSUcDo83qVF2sdS9xrFgJ7bkolEtBHoppKE/XXsZSxFC2?=
 =?us-ascii?Q?J5XwFv0HwP5T8dojH2voBA/AC4LD5lFV/R9qfsKFv82cZg+Wni+6nfeSscOb?=
 =?us-ascii?Q?I5zZTtufazziTJlycESaHMURJTOo04DhcIYXKqepWtdaHae6kc0k4DqaVAw2?=
 =?us-ascii?Q?pd9TkkWG05GPh3M5UTs4B5o=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eafe07a3-1dda-40ee-6c2b-08d9d04e5808
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:21:55.4327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TEVGfUobE/iT0BRo4SArR38eyCjzVNphdIq+FHHUieDIdDAEU08nWSZbrZv/pzlm4ev/bxE0CqzTv9D7ZpcAAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct dsa_switch has 9 boolean properties, many of which are in fact
set by drivers for custom behavior (vlan_filtering_is_global,
needs_standalone_vlan_filtering, etc etc). The binary layout of the
structure could be improved. For example, the "bool setup" at the
beginning introduces a gratuitous 7 byte hole in the first cache line.

The change merges all boolean properties into bitfields of an u32, and
places that u32 in the first cache line of the structure, since many
bools are accessed from the data path (untag_bridge_pvid, vlan_filtering,
vlan_filtering_is_global).

We place this u32 after the existing ds->index, which is also 4 bytes in
size. As a positive side effect, ds->tagger_data now fits into the first
cache line too, because 4 bytes are saved.

Before:

pahole -C dsa_switch net/dsa/slave.o
struct dsa_switch {
        bool                       setup;                /*     0     1 */

        /* XXX 7 bytes hole, try to pack */

        struct device *            dev;                  /*     8     8 */
        struct dsa_switch_tree *   dst;                  /*    16     8 */
        unsigned int               index;                /*    24     4 */

        /* XXX 4 bytes hole, try to pack */

        struct notifier_block      nb;                   /*    32    24 */

        /* XXX last struct has 4 bytes of padding */

        void *                     priv;                 /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        void *                     tagger_data;          /*    64     8 */
        struct dsa_chip_data *     cd;                   /*    72     8 */
        const struct dsa_switch_ops  * ops;              /*    80     8 */
        u32                        phys_mii_mask;        /*    88     4 */

        /* XXX 4 bytes hole, try to pack */

        struct mii_bus *           slave_mii_bus;        /*    96     8 */
        unsigned int               ageing_time_min;      /*   104     4 */
        unsigned int               ageing_time_max;      /*   108     4 */
        struct dsa_8021q_context * tag_8021q_ctx;        /*   112     8 */
        struct devlink *           devlink;              /*   120     8 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        unsigned int               num_tx_queues;        /*   128     4 */
        bool                       vlan_filtering_is_global; /*   132     1 */
        bool                       needs_standalone_vlan_filtering; /*   133     1 */
        bool                       configure_vlan_while_not_filtering; /*   134     1 */
        bool                       untag_bridge_pvid;    /*   135     1 */
        bool                       assisted_learning_on_cpu_port; /*   136     1 */
        bool                       vlan_filtering;       /*   137     1 */
        bool                       pcs_poll;             /*   138     1 */
        bool                       mtu_enforcement_ingress; /*   139     1 */
        unsigned int               num_lag_ids;          /*   140     4 */
        unsigned int               max_num_bridges;      /*   144     4 */

        /* XXX 4 bytes hole, try to pack */

        size_t                     num_ports;            /*   152     8 */

        /* size: 160, cachelines: 3, members: 27 */
        /* sum members: 141, holes: 4, sum holes: 19 */
        /* paddings: 1, sum paddings: 4 */
        /* last cacheline: 32 bytes */
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

        /* XXX 4 bytes hole, try to pack */

        size_t                     num_ports;            /*   136     8 */

        /* size: 144, cachelines: 3, members: 27 */
        /* sum members: 132, holes: 2, sum holes: 8 */
        /* sum bitfield members: 9 bits, bit holes: 1, sum bit holes: 23 bits */
        /* paddings: 1, sum paddings: 4 */
        /* last cacheline: 16 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 97 +++++++++++++++++++++++++----------------------
 1 file changed, 51 insertions(+), 46 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 5e42fa7ea377..a8a586039033 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -321,8 +321,6 @@ struct dsa_mac_addr {
 };
 
 struct dsa_switch {
-	bool setup;
-
 	struct device *dev;
 
 	/*
@@ -331,6 +329,57 @@ struct dsa_switch {
 	struct dsa_switch_tree	*dst;
 	unsigned int		index;
 
+	u32			setup:1,
+				/* Disallow bridge core from requesting
+				 * different VLAN awareness settings on ports
+				 * if not hardware-supported
+				 */
+				vlan_filtering_is_global:1,
+				/* Keep VLAN filtering enabled on ports not
+				 * offloading any upper
+				 */
+				needs_standalone_vlan_filtering:1,
+				/* Pass .port_vlan_add and .port_vlan_del to
+				 * drivers even for bridges that have
+				 * vlan_filtering=0. All drivers should ideally
+				 * set this (and then the option would get
+				 * removed), but it is unknown whether this
+				 * would break things or not.
+				 */
+				configure_vlan_while_not_filtering:1,
+				/* If the switch driver always programs the CPU
+				 * port as egress tagged despite the VLAN
+				 * configuration indicating otherwise, then
+				 * setting @untag_bridge_pvid will force the
+				 * DSA receive path to pop the bridge's
+				 * default_pvid VLAN tagged frames to offer a
+				 * consistent behavior between a
+				 * vlan_filtering=0 and vlan_filtering=1 bridge
+				 * device.
+				 */
+				untag_bridge_pvid:1,
+				/* Let DSA manage the FDB entries towards the
+				 * CPU, based on the software bridge database.
+				 */
+				assisted_learning_on_cpu_port:1,
+				/* In case vlan_filtering_is_global is set, the
+				 * VLAN awareness state should be retrieved
+				 * from here and not from the per-port
+				 * settings.
+				 */
+				vlan_filtering:1,
+				/* MAC PCS does not provide link state change
+				 * interrupt, and requires polling. Flag passed
+				 * on to PHYLINK.
+				 */
+				pcs_poll:1,
+				/* For switches that only have the MRU
+				 * configurable. To ensure the configured MTU
+				 * is not exceeded, normalization of MRU on all
+				 * bridged interfaces is needed.
+				 */
+				mtu_enforcement_ingress:1;
+
 	/* Listener for switch fabric events */
 	struct notifier_block	nb;
 
@@ -371,50 +420,6 @@ struct dsa_switch {
 	/* Number of switch port queues */
 	unsigned int		num_tx_queues;
 
-	/* Disallow bridge core from requesting different VLAN awareness
-	 * settings on ports if not hardware-supported
-	 */
-	bool			vlan_filtering_is_global;
-
-	/* Keep VLAN filtering enabled on ports not offloading any upper. */
-	bool			needs_standalone_vlan_filtering;
-
-	/* Pass .port_vlan_add and .port_vlan_del to drivers even for bridges
-	 * that have vlan_filtering=0. All drivers should ideally set this (and
-	 * then the option would get removed), but it is unknown whether this
-	 * would break things or not.
-	 */
-	bool			configure_vlan_while_not_filtering;
-
-	/* If the switch driver always programs the CPU port as egress tagged
-	 * despite the VLAN configuration indicating otherwise, then setting
-	 * @untag_bridge_pvid will force the DSA receive path to pop the bridge's
-	 * default_pvid VLAN tagged frames to offer a consistent behavior
-	 * between a vlan_filtering=0 and vlan_filtering=1 bridge device.
-	 */
-	bool			untag_bridge_pvid;
-
-	/* Let DSA manage the FDB entries towards the CPU, based on the
-	 * software bridge database.
-	 */
-	bool			assisted_learning_on_cpu_port;
-
-	/* In case vlan_filtering_is_global is set, the VLAN awareness state
-	 * should be retrieved from here and not from the per-port settings.
-	 */
-	bool			vlan_filtering;
-
-	/* MAC PCS does not provide link state change interrupt, and requires
-	 * polling. Flag passed on to PHYLINK.
-	 */
-	bool			pcs_poll;
-
-	/* For switches that only have the MRU configurable. To ensure the
-	 * configured MTU is not exceeded, normalization of MRU on all bridged
-	 * interfaces is needed.
-	 */
-	bool			mtu_enforcement_ingress;
-
 	/* Drivers that benefit from having an ID associated with each
 	 * offloaded LAG should set this to the maximum number of
 	 * supported IDs. DSA will then maintain a mapping of _at
-- 
2.25.1

