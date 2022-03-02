Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA094CAE69
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244983AbiCBTQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244981AbiCBTPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:15:54 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92209CEA3A
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:15:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COff9GKejRKdvXbuU30B6cUaujTSwfx0jCw7gK70mpGHVDRQEL7/x2rsxiw632Sx5Bgn0dKonuUADKyFYvei4WfS2jZ/SKdzaTM/3QcxHSdtkBz2bM+m8w3b+ClkMfKCkWExbNfkmznHMmXZoYTbYDvm3VN/IQgP3MDugN2YZ7G3G47o1VmQat5Orh6RDc6FXvPGUH72BbKRWObLDIeSCrKR0LZKF3iPc3WAUMJJi8OSW8VAejAke1QfT7zOpRBoGBLIqmqVprI5zTqeqQRaa5VkxhbP7vOH6/BZnenINmQ8hmBOZn2+HCkc8Cg5APklK4r1KAPe3gEgxje2SF7CWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHgRXAOES2H1AOzrJOY6JyO5rMUkrRl6vWoZ9obEr2g=;
 b=LYEJzfE3UL66oNeyVe1D8kMs32vylfUBzm9bZ3wSW78lid68Z6KbtWOGTekcEkCDEVhMCVfM/C9ieauOdY7qvW0F/byIBZbxfVvc/KDjnj4r/6YPEvY//ovXIBzgaYSMkHldlaHKii0jnkQRe96wzrNOc0QIZn6wck5mZQd3IGcMFWfn/322S0DJhSZbHqB46jtoDlG/fI+yiAbKzpVlF7YaomV1jM4q99boJtz23tAXq5Vqh9b64Vo3anEXy4TcBTm3E2nYCyqT/Ca5/TJndUx8wWrTkl8QNe1A9GmDHzdEeel/U3XI8NBtnnxGgZnzTCkafm/oel8X6gi71zQB9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHgRXAOES2H1AOzrJOY6JyO5rMUkrRl6vWoZ9obEr2g=;
 b=cIbQo1k+CMZH9xciPRMJ0kJnuL0RoQ0IlvKnZjwgNfmnRvlmMcfhvyT4+9BGctchWuXdTpgC9W4jFuGi9dWuq2P75Y+ZJzcPOQNN0t2bSxXXNooGtHGCLpkrQMsVT/ZhoPH9vwiqEjsgFQ5vZ6EIJf+nJcawK/P4rBtP9v7WKAo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 19:15:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:15:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 08/10] net: dsa: felix: start off with flooding disabled on the CPU port
Date:   Wed,  2 Mar 2022 21:14:15 +0200
Message-Id: <20220302191417.1288145-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0030.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b80bbdb3-80f8-4d69-64f1-08d9fc80f2e3
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB29112FD4758E9E3F888FBB24E0039@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6jjLQDJHKEKa9eraoFGIAtNOroxPNRh2PzFe882vfqd/NCPK/HgpBfMsZIrRKuxdRupwfCCyzjn4gmABFW8PHwSakvjSJKfqIMOrrpYuhJ5cxl+ym4WaPMO5AbpiFiYtA5RNRQMMKIVnjzQgX/MAKoU9X6xzMTcDIt0/zYxFnbmnXzyes3RqZhXSKDeR2jseCcuKs6Lc8loMG0llYAa1sY0Bl0/umnp0Wi4xeMmD3wnDFtWUUY1EbE3v92oCI38OJ7kxlf1QNCPWDnidVU1rZNRTvvD+phxS3f+MV/f9nbm8ms8h8d68ihKEx1xjvLNUK01VRtFOfZKQqNUdoGsfx87gQ8oNF3FHNBC15DD2YiO4OeB7kgGNb3D8VEGNx12khN2zgDii7dCoYn9tusmGU2VoMxJcHexFzZmWSneneUZ+9vOYuzH9okPuWfBo1bR9GXNheTv85lZ0gAaE3WDQ2aELup6PxlS8A0Af1JfRwn6AqpNQjWGz0+tML2RfpoFLpTq5D+Fk1jTIPNgcuwc5uaIxfXJHmAFE4CcRKwMqKQK8GcxLSkqLqut7965wta+W+8j0QGIGOX+usxwJDNsD9pdhBBLxyiGOriJ8/+v7qnluabhhSLhCxCWNORfX9XnblIDma/Ai9xli1d7LovrbFr3w1Jcqu0a/7JQL268Q6feK4cKrpi8DOp7skystPiN3UEoltYpGcsVCHG4vKbvo5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6916009)(83380400001)(5660300002)(8676002)(4326008)(7416002)(66556008)(66476007)(44832011)(36756003)(54906003)(66946007)(52116002)(8936002)(38100700002)(6506007)(6512007)(6666004)(38350700002)(1076003)(2616005)(26005)(186003)(508600001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P5NO6fTo3xhRZ3CxznA9T7X1yQF1tX54MZIrACyM71sM8vNKrQ67rMJpw2dw?=
 =?us-ascii?Q?e5WwU57MJHVo07x4AdrVgy1zqss3XjgjvAnZ/fgAEOi5fgiWCVIHlfBf6Xfm?=
 =?us-ascii?Q?CNt2BGJlOR5gIZ2sHXf4x2CXnEZKwmnGFSnvJfXHRIuyC5ewwXNqS9tw3SjZ?=
 =?us-ascii?Q?azpsGPEScDvcR9sQJTf/VLICmuny/iouqs7opYTEpiRdPPoC+aN8I3mBVqS/?=
 =?us-ascii?Q?M00ArJVUnbORpGo0T85FieO+WE795gcFInKaA2+qZAWlO7LIhAfD7jD/BqTb?=
 =?us-ascii?Q?r9fbL9bSW1B0WMM8TGKhN6prOaFk7HzHxJCGO8mxLroCL4h3dQPJsmv+goRR?=
 =?us-ascii?Q?bLabUzkuqHnfZooN8bRbEAserdMoKVEaa2zFne4p0+zeEwK69B/OraY2zZcz?=
 =?us-ascii?Q?c5CLoi1B5gzyM1JJ8yV1bfXH8mmRRhGDfhJqlEv05yOoAb0Pc4DyXoqGWRUS?=
 =?us-ascii?Q?3eonPK9cXl1M+73P28FdILlJ5S6HDhg0X/YY3ffSorl3MTYhfeOwGh/4Kd7e?=
 =?us-ascii?Q?1qmPD1GpOtP7l4V4iHjnPtineJIGOt4votcoQYXMxgPPZcZAhrimFD1Sg7YI?=
 =?us-ascii?Q?MWVHVzIj5DIACNmaqKxKZY0dkG9rMRZhAAMyJFu50PSin/FM1VI3KM5R5rVs?=
 =?us-ascii?Q?3zlVHweL7jEd2IZ6/oQ+ooSO0536Kw97AK07+oBeFMXZuhtTmGWUB+FeddWY?=
 =?us-ascii?Q?K4fccakb26NA3v0kDMtgPI/Sdy+/QaPMRMXZP4ZkXu5lnetrgLKQGkoBSNML?=
 =?us-ascii?Q?HHO3Bj7tNaYgSUXm7jh5QZZ636e1wZNbm5LuPvwdtBY3K653Shg1xE4gqr51?=
 =?us-ascii?Q?FN73mkcOrzTSfqZ/InY3ji4n2/J3e/XnsSd+adRaA7H+daf7XDzGUkj6GMxP?=
 =?us-ascii?Q?WN75bkWx//YAS1RBtXk8JJ/recpftu2/jmR+w9ZX7n6EIMMzhQ94tMJslTHk?=
 =?us-ascii?Q?gwndvBnZd7vpHg8XdE9nRqlXlaW9g5+ICGGcWhbX6KVoS8deAveWsnuNmF/W?=
 =?us-ascii?Q?s+TBQj+GOPPpbUnImh0wZnLlpzPhMnCsYcMIQ4IFndYswpkSTEDayZHsPpyz?=
 =?us-ascii?Q?0ULMTZsIxQlU8D03xi+Cnz+UOKVi2u2O/kk6Bi3IFff7zwBApsQhimBj1Off?=
 =?us-ascii?Q?DSA7xDE86c3dMlHjBv6nvHT4WvIkH8tlhgz31w+MemNe+oqf86w7xE7zixTO?=
 =?us-ascii?Q?fGBYgzZz3+8ihPOU0p1Tn+D8IH5uM9AzDb06wovQ9bWPN+PKd5tpCb843sU+?=
 =?us-ascii?Q?4feKEIB/gLN/6xZngEUP3A6pstaC6OrH4Sgn26qo2HUuZJ5iZeJEtr3lDARJ?=
 =?us-ascii?Q?Np0GhBHQFiNSMvDvwycUupMp4GmdFqMGYU5HkKh360/ZXVQPKmGCOAU0ank9?=
 =?us-ascii?Q?yvVEaGrN4B8/omw/o9ypwLe+FrwHhu9/EwGkgW4a45Fa2xOhE1dItjFJP60M?=
 =?us-ascii?Q?i1+DjSXPvBAsDGQ/nVb/2ToODcDSP2IPm0NevQCE1W/JfJZl89DxFu0JiFhT?=
 =?us-ascii?Q?i9QqwIT/DCHio6Lj3g6JCdse2PhzLpsM+YFPGo4lw6q8Dtvglh2k3I0ghNZM?=
 =?us-ascii?Q?oaSsikixNTz9SuDe7eEU4jtnaky6Kt13hX8xBizNGu/BDJ8UMHz6ct2KNqR4?=
 =?us-ascii?Q?X9tMivCGJtRaoSzfGFVFAxk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b80bbdb3-80f8-4d69-64f1-08d9fc80f2e3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:15:01.2200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FIyk4v1PJQFo+ywPQ+xYf68fetpNSsrkwRpsV6AIJiP7+9sRR1WA6VsFQZpuDFIf1G/QvzajSnrF+KWWSYkLdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver probes with all ports as standalone, and it supports unicast
filtering. So DSA will call port_fdb_add() for all necessary addresses
on the current CPU port. We also handle migrations when the CPU port
hardware resource changes (on tagging protocol change), so there should
not be any unknown address that we have to receive while not promiscuous.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f263712a007b..e9ce0d687713 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -614,7 +614,6 @@ static void felix_npi_port_deinit(struct ocelot *ocelot, int port)
 static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu, bool change)
 {
 	struct ocelot *ocelot = ds->priv;
-	unsigned long cpu_flood;
 	int err;
 
 	if (change) {
@@ -633,22 +632,6 @@ static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu, bool change)
 
 	felix_npi_port_init(ocelot, cpu);
 
-	/* Include the CPU port module (and indirectly, the NPI port)
-	 * in the forwarding mask for unknown unicast - the hardware
-	 * default value for ANA_FLOODING_FLD_UNICAST excludes
-	 * BIT(ocelot->num_phys_ports), and so does ocelot_init,
-	 * since Ocelot relies on whitelisting MAC addresses towards
-	 * PGID_CPU.
-	 * We do this because DSA does not yet perform RX filtering,
-	 * and the NPI port does not perform source address learning,
-	 * so traffic sent to Linux is effectively unknown from the
-	 * switch's perspective.
-	 */
-	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
-	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_UC);
-	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_MC);
-	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_BC);
-
 	return 0;
 
 out_migrate_fdbs:
-- 
2.25.1

