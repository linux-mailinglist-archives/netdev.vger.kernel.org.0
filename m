Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C4352FFA5
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 23:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346860AbiEUVi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 17:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346686AbiEUViS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 17:38:18 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D861C5400F
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 14:38:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nz8G6/YwnshKf3dhzGp19swEtxgpeFl/iZJQTRQ9xRxqCcyFwrEzXSz0vvbHC0Xl/IDykp5XeUT7H1JdIXn+ADVutg0UjytpP+ZwFBmRbvMsPLpR5GDOu6B7ja6W/iyjIj+jx+LwBaqr0Bjlof9tlGdwT/vJ3L8q1WAJB3lGciRuu+SCoyJJqSs3NyQIFSKeRHfCdP8KV11cCYe3IM+qbV4+gBaOoN51xACikEhB9LoFHduPYYSHQpaWE3x4+pe3VSAkgz5Qrb9rg98q7kRIfijxhkIPir074Iar7W0TeAxFF21febgMrfGZpmo2GFHnJlw262B9sgrLO+esjsSjIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0fpvBvw1XgLjKLYjFiuWbjJdQhDf5q9eoYH47+5hIyo=;
 b=clIHZrtlomvg/oEeGINbG19IIFJ70GEem3dsC4Dmqwrgrm72tYj37sEIQ4b01UBfBVkgdOYnMkNnPJpDlbZFmmgigHULjPshAu+iOs7o8kZlnUo1gQPYss6583ZjTmq+s4FeuVcdZ6LLFZHLMY9qbUHnetTvMD1ZuopMlKqQ9OOrxSf6U6A9rM0L23gJhdtZeqiZMQUvGeUOSQ+jqRq4UBaIbQMp3iEUSPY7UHG0a5YURKOt5MhFGYcNcl+O8t5Mn52RPNotVkIL4bEXeRRNaRqkJL+c+x/nVeOYUm8Kmx4pfpf7y8UFAU1N7ayXH9cg5hwGUi046MztIntnODuRYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fpvBvw1XgLjKLYjFiuWbjJdQhDf5q9eoYH47+5hIyo=;
 b=EoaGZFhDZ7TQ/NBj8VA5833s6K2npNA79ijtxKBBfQO15XyqnaDzZ4bn/k7Yb4AmD9qgL0cTbbTusGKOFcK2MG9nDXEyUXdm1b06nRm+EWR2cWnl573kh92u3h+m1vQNFPhC4/+azNZOJ5y7ZDMVGhZL9AmCnSoqZsyfRhhp9LY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6275.eurprd04.prod.outlook.com (2603:10a6:208:147::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 21:38:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Sat, 21 May 2022
 21:38:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 5/6] net: mscc: ocelot: switch from {,un}set to {,un}assign for tag_8021q CPU ports
Date:   Sun, 22 May 2022 00:37:42 +0300
Message-Id: <20220521213743.2735445-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
References: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0079.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36e723c9-e865-4fd8-05bd-08da3b72303b
X-MS-TrafficTypeDiagnostic: AM0PR04MB6275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6275F90CA07DC50B178E9EBFE0D29@AM0PR04MB6275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0A9K8zCJxIh6g3bkrPtg0D9+HecF7SvDpcrkAdyf9cnhaLPQPiwt7FZ1hB38n3toFaI0XKFJqwBOYKYu3AcNAt9UcqNou66c4Rn3H0OgAxXmYh0MY4jaW9QYBJy6vFIiSsGTLRYF3VSQNQffsO+vS5972kJ3WuTtRi4zk6L3jlmWzhilBltgJgarSlXv2dHQfB+juxz4wIjtnE7j0lHzXCJGBv01skM3pV0AZKPPmkMI9T9qPUmBaanksMh/3eW6nKjOEF3sSkTMC+5DWkrO6y9W4C5TjjE453O5kWtMiW2DbSm1pxbjC+1oq2gqIosKbnq2sW+nkwUohQFYKZlGB2b/ySuTeRuLtDn+DQvm+kx6n0V79ics1sn7mjFNTYb2XOrdfR1FDFlyft//o14MMi5+WSTZrwO6JS6+dX0pEHGl/RM/Isy4vRJpnZWnkpab3oOPdzmzRLKiSKLrHrc4B/lteM1W6D/gL0+f3t43ue4hbrK1Mvt5thuOFUDHU9Nr/1yPCe00eSAK011x7n/wRnSt4zGBGPbKSJwQgNSGHOC46vUtqbp7b5fReRwF5ns/wzRx7a4Xua2KsFNAQchNuZ0K7FqIn1Vx6utx7ZtWIqU+uO3sBIYm9bsD9/9QaizTAbXr5UFUSO22HLghk46E2N7UF2BLvLhHEgbKC3CE/QOMZFf0xMkPN/RHhbIygOTkr5jc+vB8JZRh0/qKH97ekw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(86362001)(26005)(6512007)(6506007)(52116002)(36756003)(2906002)(6486002)(8676002)(66946007)(30864003)(4326008)(66476007)(66556008)(54906003)(44832011)(83380400001)(7416002)(2616005)(186003)(508600001)(38350700002)(8936002)(38100700002)(5660300002)(316002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lpDJWKnds9GEA+M717HNJZSk2aVpn2ecP5TOXxz6UZAL3cziLHyGAf2HudBG?=
 =?us-ascii?Q?t4hi1MbBZfBDf2lz8d+NmyQlxywdKkig4rOMCwz2TGRxEyd5ORX8dJ18BM53?=
 =?us-ascii?Q?3Fdg1BK4QVC9o0AJ4rZYZaB5LamvGzQXYExA6yFj/3bc2f7/NHLYtJZJG/ku?=
 =?us-ascii?Q?XqTfyrveFKM9Tbtj8VDhKWx9Ts1B0cVeA+iwhN3kgc3IIBqPLGf6EYqym7wC?=
 =?us-ascii?Q?vLdiUBIitS2sHoJifpUkjOIW3/afFDOHRMhz9cRQsPdD+aJ3bCnmPU2W2xrQ?=
 =?us-ascii?Q?wDtNnAlqiWaSg5guP+HU/QbvAiKfeq3EXsTaKHxgfxxaOCeBhEPRrAWTYwkV?=
 =?us-ascii?Q?uvm3uIzHXaE3vSI4HaiBwy6PfNLqJWttimVGmbpGXyBQYzmFzN6jMnFau79U?=
 =?us-ascii?Q?GniLdY3b9AgJvnFjYj8VDBR6cDvjsffz0wYymfZi7jHk9jm9vqYGdPcsT/88?=
 =?us-ascii?Q?aVA8A6RYsyTuFOyi9hGGvSkgAeuPZR5Yy4s3WdH+Nt1KuKjMcZMj/AXNkTG8?=
 =?us-ascii?Q?ct2z+3zb6OenS94/R5aNJP9Xj88oP7A6og1Z73CJiUrSxJQ3ZXGcKpodvtx2?=
 =?us-ascii?Q?T4iNIBsVkWb6xwM2AtHSEM/CpU28bpqdT7kkH52e4JeU+gJaVwetStcqraMH?=
 =?us-ascii?Q?U0gFIuRykKGeN7wS4wMsf2xhE9g5Nko8bs8vbjzXD3gOBSE6ZhJaH8Yq5Zx4?=
 =?us-ascii?Q?4HOPtAm6eK4WWdXRpSiwFdQUH0A1HIhywfVikAJ6vtlmZi9jPkaGlRanB0a8?=
 =?us-ascii?Q?B02Znf+ZCbsIgBHdI1rFDSBmcZu2psy4ZazsrOSJuKHkCz8Ab92b57NxRASN?=
 =?us-ascii?Q?rNTjMs+DHDykeW6ufxYiuQyg4zsrqDZwOZWBddMsNzyee6bQMYXP37if99Go?=
 =?us-ascii?Q?jEj1XlB9UI3wzj1N883sEJj6wnKBNJ+9v5kQvEVM/nczfFo0KW/f4+8nqsjv?=
 =?us-ascii?Q?u4RwYM2MCKhljnLzkNy2V9U0YnURIpQs9eUYCBz20sPi01c8HWE+vWCKJBku?=
 =?us-ascii?Q?cEsOUPhEqqSd4hy7nFN5UNDpgzE3k/KGxnsZGdo6jwIc2QlK6VNotAoV1K65?=
 =?us-ascii?Q?VKIOnxD/mtGsDioVpIKnfmqi+ginIx/CZREE1Nlwp/8qaTS/zFmenaQpy0qZ?=
 =?us-ascii?Q?lP3qqXKzAs+MzQ3HFAIAg9r25Ii9OAWSPkYSCPNdAIKgc2/2L5oIJ7pxfWCD?=
 =?us-ascii?Q?FDeVp5FsEwxsPFJ3ZuFlF4pWgtRLIXTm8Wob1FaHlRvyl7H+VjDmJIV8Ij5w?=
 =?us-ascii?Q?8vvGvE3YUKzRhyhjAExM54IswN6f94Hg2h/L7kgdVlkSJGvu6Rh9A/5p+wmq?=
 =?us-ascii?Q?ja/KzhcBcHb9qPPUVf5FeyIYRGoHmLRf6500DHjG4hrsVcFtUWrmWK4DZJH8?=
 =?us-ascii?Q?RtljGBFD131lh51ZAtGFIExol5b2dlszpfFOVdtLbCBxt69D+ZiKHkkyCl36?=
 =?us-ascii?Q?a05AifD6a/m7Ok/Q03qcRCiNkTtWwj6aDb+3vAlUzne0dgW9EXbg/6X7Ulce?=
 =?us-ascii?Q?UwT3c1xF9SV0V/qKzaZv9rLr+K6Y5/p/2SkVP276KoU/6HRpD4nV5Mcc/8cQ?=
 =?us-ascii?Q?byqJmJ7eSo2RCuifXw9adg6IZhZvoFUsa+KK7axrSrUPW2RlDU9DiweGink0?=
 =?us-ascii?Q?d1gnxEYcM+5GeULKccAEQkiBCvwrTa2GIxCtby9128llYftVoWtegv4DUhZB?=
 =?us-ascii?Q?vDypF3j/3YxrLw0QU7Hr+QMuW+MMBdHHjsn5wLo7UFmHR6h+Cm9rmPDorX3Y?=
 =?us-ascii?Q?WjGtE83xrEi2cRPf/VsPO1DRYJy1YiI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e723c9-e865-4fd8-05bd-08da3b72303b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 21:38:04.9550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qn4R2tAfrMRYY9qm6UJk7vgpunACkV1HLgWk4s/3du42mNFFh4C/PDuQyYTMVAwOFA/8Cyj3EJ+beRGMB0U1Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a desire for the felix driver to gain support for multiple
tag_8021q CPU ports, but the current model prevents it.

This is because ocelot_apply_bridge_fwd_mask() only takes into
consideration whether a port is a tag_8021q CPU port, but not whose CPU
port it is.

We need a model where we can have a direct affinity between an ocelot
port and a tag_8021q CPU port. This serves as the basis for multiple CPU
ports.

Declare a "dsa_8021q_cpu" backpointer in struct ocelot_port which
encodes that affinity. Repurpose the "ocelot_set_dsa_8021q_cpu" API to
"ocelot_assign_dsa_8021q_cpu" to express the change of paradigm.

Note that this change makes the first practical use of the new
ocelot_port->index field in ocelot_port_unassign_dsa_8021q_cpu(), where
we need to remove the old tag_8021q CPU port from the reserved VLAN range.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  27 ++----
 drivers/net/dsa/ocelot/felix_vsc9959.c |   3 +-
 drivers/net/ethernet/mscc/ocelot.c     | 120 +++++++++++++++----------
 include/soc/mscc/ocelot.h              |  10 ++-
 4 files changed, 92 insertions(+), 68 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 033f7d5cc03d..01d8a731851e 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -414,21 +414,18 @@ static const struct felix_tag_proto_ops felix_tag_npi_proto_ops = {
 static int felix_tag_8021q_setup(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct dsa_port *dp, *cpu_dp;
+	struct dsa_port *dp;
 	int err;
 
 	err = dsa_tag_8021q_register(ds, htons(ETH_P_8021AD));
 	if (err)
 		return err;
 
-	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		ocelot_port_set_dsa_8021q_cpu(ocelot, cpu_dp->index);
-
-		/* TODO we could support multiple CPU ports in tag_8021q mode */
-		break;
-	}
+	dsa_switch_for_each_user_port(dp, ds)
+		ocelot_port_assign_dsa_8021q_cpu(ocelot, dp->index,
+						 dp->cpu_dp->index);
 
-	dsa_switch_for_each_available_port(dp, ds) {
+	dsa_switch_for_each_available_port(dp, ds)
 		/* This overwrites ocelot_init():
 		 * Do not forward BPDU frames to the CPU port module,
 		 * for 2 reasons:
@@ -442,7 +439,6 @@ static int felix_tag_8021q_setup(struct dsa_switch *ds)
 		ocelot_write_gix(ocelot,
 				 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0),
 				 ANA_PORT_CPU_FWD_BPDU_CFG, dp->index);
-	}
 
 	/* The ownership of the CPU port module's queues might have just been
 	 * transferred to the tag_8021q tagger from the NPI-based tagger.
@@ -459,9 +455,9 @@ static int felix_tag_8021q_setup(struct dsa_switch *ds)
 static void felix_tag_8021q_teardown(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct dsa_port *dp, *cpu_dp;
+	struct dsa_port *dp;
 
-	dsa_switch_for_each_available_port(dp, ds) {
+	dsa_switch_for_each_available_port(dp, ds)
 		/* Restore the logic from ocelot_init:
 		 * do not forward BPDU frames to the front ports.
 		 */
@@ -469,14 +465,9 @@ static void felix_tag_8021q_teardown(struct dsa_switch *ds)
 				 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0xffff),
 				 ANA_PORT_CPU_FWD_BPDU_CFG,
 				 dp->index);
-	}
 
-	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		ocelot_port_unset_dsa_8021q_cpu(ocelot, cpu_dp->index);
-
-		/* TODO we could support multiple CPU ports in tag_8021q mode */
-		break;
-	}
+	dsa_switch_for_each_user_port(dp, ds)
+		ocelot_port_unassign_dsa_8021q_cpu(ocelot, dp->index);
 
 	dsa_tag_8021q_unregister(ds);
 }
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 98caca4317d7..570d0204b7be 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2162,7 +2162,8 @@ static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
 			if (ocelot->npi >= 0)
 				mask |= BIT(ocelot->npi);
 			else
-				mask |= ocelot_get_dsa_8021q_cpu_mask(ocelot);
+				mask |= ocelot_port_assigned_dsa_8021q_cpu_mask(ocelot,
+										port);
 		}
 
 		/* Calculate the minimum link speed, among the ports that are
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d208d57f4894..8da7e25a47c9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2046,57 +2046,68 @@ static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
 	return __ffs(bond_mask);
 }
 
-u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port)
+static u32 ocelot_dsa_8021q_cpu_assigned_ports(struct ocelot *ocelot,
+					       struct ocelot_port *cpu)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[src_port];
-	const struct net_device *bridge;
 	u32 mask = 0;
 	int port;
 
-	if (!ocelot_port || ocelot_port->stp_state != BR_STATE_FORWARDING)
-		return 0;
-
-	bridge = ocelot_port->bridge;
-	if (!bridge)
-		return 0;
-
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		ocelot_port = ocelot->ports[port];
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 		if (!ocelot_port)
 			continue;
 
-		if (ocelot_port->stp_state == BR_STATE_FORWARDING &&
-		    ocelot_port->bridge == bridge)
+		if (ocelot_port->dsa_8021q_cpu == cpu)
 			mask |= BIT(port);
 	}
 
 	return mask;
 }
-EXPORT_SYMBOL_GPL(ocelot_get_bridge_fwd_mask);
 
-u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot)
+u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_port *cpu_port = ocelot_port->dsa_8021q_cpu;
+
+	if (!cpu_port)
+		return 0;
+
+	return BIT(cpu_port->index);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_assigned_dsa_8021q_cpu_mask);
+
+u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[src_port];
+	const struct net_device *bridge;
 	u32 mask = 0;
 	int port;
 
+	if (!ocelot_port || ocelot_port->stp_state != BR_STATE_FORWARDING)
+		return 0;
+
+	bridge = ocelot_port->bridge;
+	if (!bridge)
+		return 0;
+
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		ocelot_port = ocelot->ports[port];
 
 		if (!ocelot_port)
 			continue;
 
-		if (ocelot_port->is_dsa_8021q_cpu)
+		if (ocelot_port->stp_state == BR_STATE_FORWARDING &&
+		    ocelot_port->bridge == bridge)
 			mask |= BIT(port);
 	}
 
 	return mask;
 }
-EXPORT_SYMBOL_GPL(ocelot_get_dsa_8021q_cpu_mask);
+EXPORT_SYMBOL_GPL(ocelot_get_bridge_fwd_mask);
 
 static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
 {
-	unsigned long cpu_fwd_mask;
 	int port;
 
 	lockdep_assert_held(&ocelot->fwd_domain_lock);
@@ -2108,15 +2119,6 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
 	if (joining && ocelot->ops->cut_through_fwd)
 		ocelot->ops->cut_through_fwd(ocelot);
 
-	/* If a DSA tag_8021q CPU exists, it needs to be included in the
-	 * regular forwarding path of the front ports regardless of whether
-	 * those are bridged or standalone.
-	 * If DSA tag_8021q is not used, this returns 0, which is fine because
-	 * the hardware-based CPU port module can be a destination for packets
-	 * even if it isn't part of PGID_SRC.
-	 */
-	cpu_fwd_mask = ocelot_get_dsa_8021q_cpu_mask(ocelot);
-
 	/* Apply FWD mask. The loop is needed to add/remove the current port as
 	 * a source for the other ports.
 	 */
@@ -2129,17 +2131,19 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
 			mask = 0;
 		} else if (ocelot_port->is_dsa_8021q_cpu) {
 			/* The DSA tag_8021q CPU ports need to be able to
-			 * forward packets to all other ports except for
-			 * themselves
+			 * forward packets to all ports assigned to them.
 			 */
-			mask = GENMASK(ocelot->num_phys_ports - 1, 0);
-			mask &= ~cpu_fwd_mask;
+			mask = ocelot_dsa_8021q_cpu_assigned_ports(ocelot,
+								   ocelot_port);
 		} else if (ocelot_port->bridge) {
 			struct net_device *bond = ocelot_port->bond;
 
 			mask = ocelot_get_bridge_fwd_mask(ocelot, port);
-			mask |= cpu_fwd_mask;
 			mask &= ~BIT(port);
+
+			mask |= ocelot_port_assigned_dsa_8021q_cpu_mask(ocelot,
+									port);
+
 			if (bond)
 				mask &= ~ocelot_get_bond_mask(ocelot, bond);
 		} else {
@@ -2147,7 +2151,8 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
 			 * ports (if those exist), or to the hardware CPU port
 			 * module otherwise.
 			 */
-			mask = cpu_fwd_mask;
+			mask = ocelot_port_assigned_dsa_8021q_cpu_mask(ocelot,
+								       port);
 		}
 
 		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + port);
@@ -2191,43 +2196,66 @@ static void ocelot_update_pgid_cpu(struct ocelot *ocelot)
 	ocelot_write_rix(ocelot, pgid_cpu, ANA_PGID_PGID, PGID_CPU);
 }
 
-void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port)
+void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port,
+				      int cpu)
 {
+	struct ocelot_port *cpu_port = ocelot->ports[cpu];
 	u16 vid;
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
-	ocelot->ports[port]->is_dsa_8021q_cpu = true;
+	ocelot->ports[port]->dsa_8021q_cpu = cpu_port;
+
+	if (!cpu_port->is_dsa_8021q_cpu) {
+		cpu_port->is_dsa_8021q_cpu = true;
 
-	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
-		ocelot_vlan_member_add(ocelot, port, vid, true);
+		for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
+			ocelot_vlan_member_add(ocelot, cpu, vid, true);
 
-	ocelot_update_pgid_cpu(ocelot);
+		ocelot_update_pgid_cpu(ocelot);
+	}
 
 	ocelot_apply_bridge_fwd_mask(ocelot, true);
 
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
-EXPORT_SYMBOL_GPL(ocelot_port_set_dsa_8021q_cpu);
+EXPORT_SYMBOL_GPL(ocelot_port_assign_dsa_8021q_cpu);
 
-void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port)
+void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port)
 {
+	struct ocelot_port *cpu_port = ocelot->ports[port]->dsa_8021q_cpu;
+	bool keep = false;
 	u16 vid;
+	int p;
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
-	ocelot->ports[port]->is_dsa_8021q_cpu = false;
+	ocelot->ports[port]->dsa_8021q_cpu = NULL;
+
+	for (p = 0; p < ocelot->num_phys_ports; p++) {
+		if (!ocelot->ports[p])
+			continue;
+
+		if (ocelot->ports[p]->dsa_8021q_cpu == cpu_port) {
+			keep = true;
+			break;
+		}
+	}
+
+	if (!keep) {
+		cpu_port->is_dsa_8021q_cpu = false;
 
-	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
-		ocelot_vlan_member_del(ocelot, port, vid);
+		for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
+			ocelot_vlan_member_del(ocelot, cpu_port->index, vid);
 
-	ocelot_update_pgid_cpu(ocelot);
+		ocelot_update_pgid_cpu(ocelot);
+	}
 
 	ocelot_apply_bridge_fwd_mask(ocelot, true);
 
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
-EXPORT_SYMBOL_GPL(ocelot_port_unset_dsa_8021q_cpu);
+EXPORT_SYMBOL_GPL(ocelot_port_unassign_dsa_8021q_cpu);
 
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2c90a24ca064..5f88385a7748 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -654,6 +654,8 @@ struct ocelot_mirror {
 	int to;
 };
 
+struct ocelot_port;
+
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
@@ -662,6 +664,8 @@ struct ocelot_port {
 	struct net_device		*bond;
 	struct net_device		*bridge;
 
+	struct ocelot_port		*dsa_8021q_cpu;
+
 	/* VLAN that untagged frames are classified to, on ingress */
 	const struct ocelot_bridge_vlan	*pvid_vlan;
 
@@ -865,8 +869,9 @@ void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
 void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
-void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port);
-void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port);
+void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port, int cpu);
+void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port);
+u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port);
 
 /* DSA callbacks */
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
@@ -878,7 +883,6 @@ void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled,
 			       struct netlink_ext_ack *extack);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
-u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot);
 u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port);
 int ocelot_port_pre_bridge_flags(struct ocelot *ocelot, int port,
 				 struct switchdev_brport_flags val);
-- 
2.25.1

