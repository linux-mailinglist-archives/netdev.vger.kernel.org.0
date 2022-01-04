Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3B74846CC
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiADRPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:15:08 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235724AbiADROp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nD8bRzoBy7NIWazh7fRPBYMTjnol2VMs0ASs5+3rH7KsNB7D4h7/3zGh2pSP3euVzLMajNPy2bSr34J0rCwTNng5xOFTWf2a0GhUhKf+ITeRHSHUmzMIj73XcYw0pZ9RD4ZdagynWFuNrP2SFbSD81NrTctysLqLhr0zR5g79yEJXkRMLcNXQwnOxmlgS3WR7SjEurmYtD50DF1mkIuzTWcRLz6PjloJ8YTSAdI30ki7rem6RAqf2ohbsi0vfaAA17v1VrSPgwuc6vfXt1nAc3oVgOWJu4pxxZ+v5cYV5ElVLTPXNFH3tmFf31q2QktzlMURZeok9AzMO+fFh0M9Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4r/+JADHi7tHwdY3uObPHJE1fi4/O02LFgLf0E7kLao=;
 b=gAFIi7Z3NNuLm1vR0Kops/MnsX92QzF9Jz0PM/G7J5rz0ANIsRR4Hg/zbb5ju1iucCFR++ZYDO41+nsSd2JaftfTRlewObJyeROsP4vkZO6DV4Iwx47lMqNPQM9lUKa1ynqBuqHFycrjNIqGZHw4ubr8B0tFGQhvK92DbkiIziG8MloYHh7YXenQWouhh+cX5tE6drHQkaFV9nCaRG0wgguN6M7vGbXRUT/eLcQ06qlIZ/OKEM6tG+1wjgNza/uj2AW/Vww8WOMEvhYJNvcOhP+2juw8f73zmfANPPU8Rc6Eqi+TSh5xpt/78V4AOs5ILaG8s4X5etI0iq/pAHCTzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4r/+JADHi7tHwdY3uObPHJE1fi4/O02LFgLf0E7kLao=;
 b=B4ImBo9iik9JEggDaLXqtUmh5824DOSx/SltPoETTn7SwRzjdajRjW1inHzJ2MG3Gtdqc6YjdjthXV0zrKtXOyNfPkTUcYq9e+hLfxSAkSyrcT7SrptSWj2KHcOfCdTfVLsN/kSTBGdtAQdliAPRiHMzdWYOzAtlZe+p6UYMlmU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 12/15] net: dsa: merge all bools of struct dsa_switch into a single u32
Date:   Tue,  4 Jan 2022 19:14:10 +0200
Message-Id: <20220104171413.2293847-13-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 664f0f79-f480-4b6b-4fb6-08d9cfa5b1ef
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104B6AC970493F5B68996EEE04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xSOG66Z8YnoL9KK+HK3pspQb+qA/Szj+hbsf4Tm5vV4TzeTBlud0u8u7tNT9HYA7Z6xRoEHJpVjyIYSh+4r2vwGmJGydtlh2UwkRZ4qpb3J0d1HnzAZHeJQCZStx6qr2fR4PI19YS//DWQEvYhL02DwNFD6j5ckbMsqHVBVwwirbbC6cJNBMXLi6v0ULSK8Pe0B/NHlijhqlznR3f5kATJdzkfr+A3+3apxR4pYWCegX2RP9ylwoKGP50uHDzchB3M72kMKzrjWEQ6J68pp6FY/ukZqbH55d0YLxVGzb6IenC32K5I1h3lo5a09ji/taWsOammul9xIxRRnZPL+KYEmPOiaY6nGCHWBcvdTtTwkYcO2M8NR+dmKRP9rui3Ir1iZ2f72ZNtzyWLrmZSuY/Z+VmB0P/6Z6EEjApizdx5yJsPrubz7ZMJ41I5BPTBwv779yeXpl8FQ5dalx+s2+oiUKypa42SmLLs7zxqTELaQme+oWkWpZSH9vqulGTw07yjVInej9hTVyOVx98RWDnSChqtI+qKWMcD/CNTMlDeey47M5I4O+ydu8RWKHkIB3JsV77OAd2WwmwRR+WPSW3/wtO5t2U2tNo8yfTI+Im5zLFd1FNDHNDyzgLWr4Vm4tqtKqdh7Hd7vG+aw7pFyOE6x1hMl+95C7yqqMTWJIg9vj2A7T8t2KSPpmXn7Lr1au7v3cNw6/B//Hi9zQGb65yWvnfx5f4ZCGCuffrYrHnzc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h1Vb58M+cHPD4GBn5cg5YKj4Bkr69/YVbsSIgcuTGfANvCnHaxrfyO6WKuUO?=
 =?us-ascii?Q?SvZ9BiDfoYfJjLqtmsck8m8ZrSOmz1l4A/lbAdIFORvJxqKBiBuxKnLM1doa?=
 =?us-ascii?Q?SoICScF4+fuMn3I7qfFAUKcx0A5PZ8RYI599h/if2cTPZz4/fJLiN6xgqEAr?=
 =?us-ascii?Q?E0SAemQ5rFhQBh2N4hNsNdnvA+JUabOxrbiSzVyTqx31Slqk4dBphGJ04Eos?=
 =?us-ascii?Q?cDQcwOM2vgA24jSqmLy9DAqs5ic3V0X/e7CNUw9W/idjpDi2Vbid53l8KmnS?=
 =?us-ascii?Q?uUko2NrDgjHUBPXPPEfuia58VBWRLSTvRju+EJVcr4XPygVyNf4so7bdoyhd?=
 =?us-ascii?Q?bRcaV3dZ8A+fk9MOgF2x2vANJsfVVZ9ge5QJViOpLXfFzis8xCUpgpJrUNd4?=
 =?us-ascii?Q?lvXyOgqHGG9Yq5KNxAFM9Vk4T48+oxSyaxQHlp6iVVGDCkG3FCL2sLnB2mgY?=
 =?us-ascii?Q?vMecydE4ndI0b/30YHLvO7oYZmN8Db3df7r2ZCIB3RQ2y7SofhqNTWPFybfv?=
 =?us-ascii?Q?mGRgnfk/8L0fXZGI7aNBjCWUBorSzVMvfCYp5ZctwMuTy22b0gDMOXzJrIL4?=
 =?us-ascii?Q?4MynnpsNF7p9KfwKOy9XC22uNK3nbwQq57SlyUQ95OXVNYtYMv2j1Vxs+V24?=
 =?us-ascii?Q?nXEhssTS+k5IXh/tN9SP8F1hxwahxgSrsE/7t0iKpn+F/45MrgRrFgESu4wT?=
 =?us-ascii?Q?7ZIjDD9bIkyRvuaEsZEV8WjgSiAaKhnz56+O1NmI9tPKszvwSnBEmluM4WXS?=
 =?us-ascii?Q?HrQCEkXtxQRYfX5V97/7htJriT85iS5kyY/vYutsMLvsZ49S+DpfweHtH/19?=
 =?us-ascii?Q?1DUr7LoGmhzqf+G7dbqEel1Py6rq/YKM8+IN0JRbH+bK0i4FcQMx/p3JSE5v?=
 =?us-ascii?Q?YtOAjomhiztqjoBJmGuFpnVBH+UJsDHM0+PJ6cRN570WFsbTfYbuxxR5Kq5O?=
 =?us-ascii?Q?4VQVFU/whDd7GLfjpHeloLaZAn4puMqymwF+Xewp8XVbGLj5/bOLPgpEsRF4?=
 =?us-ascii?Q?5Ax2Cyq7lauAfRNBXm76nhpbHI5WVuGS25hlKFTUIxY95JN2foe7DsCbASRe?=
 =?us-ascii?Q?9nyqnKlJLHLg9jtimgai9ahEVAp+ab1sBVoyqzfkkSxDD8Wrf/dIDvW+gMtY?=
 =?us-ascii?Q?9WvroQE+8l8aZUcTQyDLUVVl2tWNm3ag2DeS5pSdy6cq6ev03lildMyJL+Qn?=
 =?us-ascii?Q?MLbcUHaZuoE09qQvxGZCuONPGaHKCnkRLt7KG9Ou+/GDBru7Efg1XfYHYcHV?=
 =?us-ascii?Q?1IBDV233K/uhYOebR4+iEqraWwwjE7XKEeWItvmDc4ht6XU6Wp9sFrYdXAlP?=
 =?us-ascii?Q?Hv34SwhvrwliPo4FXhTcA6mfzzpBK57sS1XXmFjvowfZb1TU8ecJ4WK2fsWu?=
 =?us-ascii?Q?EhuYJpfMgzLHAdao09WRKUtymPKO2u3J1awUYHkZ2y6LCl7bti7/kxpXcAA6?=
 =?us-ascii?Q?LpbJdvVSJEpOq11wLybcMBOJ2mbpN0Xb3LerkEmj4jdPjUZ7NW3fpK6YXfJe?=
 =?us-ascii?Q?SOS+X50fWtJ2DT0VFple7aky/kYP58abIQxOWc9fYwnjOHp+E934rkxg73Pt?=
 =?us-ascii?Q?hZ8URahOhQrs2cYEgYhZkCRDgX0b2Yb7LIywoUaZqNKQsraw+LnBen8VAfoP?=
 =?us-ascii?Q?GoYrAU2gZto3oc498nvHSqQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 664f0f79-f480-4b6b-4fb6-08d9cfa5b1ef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:41.3314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MiEKAiLBuMX3gdwanO7HKKJV9Fxp7EykhGNF0ahgj171jLoYS1fYX3/Qje/Fc3cC8ZzPQ8PkPZSN04Dds/l2Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
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

