Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1545E51C50F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381918AbiEEQ0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381910AbiEEQ0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:26:12 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3635BE5B
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:22:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVqRpGIkURTgv2b+BanXxjVlHTX7bbJIFR+vctJRg2fBT/k5ZXhqNCCZsd1KS1aXEozeLcG8WTGVJPQAYAfX3b5vx4XhmkmKIfrEWtJ+rBiWFNOvVtTKYul35w1Kb5/dm9nPXYBqx51QSHDu9rh+Mpo+hBc8Xs7lQsjPzrjZA7YwgBPc7E1f+oHJQkb8VtpUmUoXjKWspjuHJhICLIayth7cBgg07aCTqHCOhxSo3WZYAsf6gdAyObvAyC3ntmNX91QN4QjRfyExH1MvXRNprY7OhiDaKM9qNxUQ3PGbaOEQAuR6egv54rGF/IOuqNzcmlsGAWhq75AH8ZcaXj/tMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QoGgvutVoq82KXeMlKiEAvHHSy7NU3ghCWbL563ktFY=;
 b=Aw0LaSi1nRp9ZAiqhEFynwYRFA0bC/4pao5BVv4erasF7SiLpZP7lerjw58oVu0GXHRcceL2SVdm8rlvLkXawh4sHXUkrnOoHGmSaP8ZIfuZ+Amv0pitNugCkyPwtI0gFJ7laaaAfJM1iAlbPEiOVzG6EpcQyjLTo7Nnbu7GjBde4vohHgpG4Iq6JumVSo4vhgMmM6jAiqemLDleHV6A+dBU3DORPycL95vdcGYSl9TUa0ZcaCfab5bdTnzqJdh6ETcPwCBgXyn3/cQCbN4e7ARYRn4oiBflyG+jvrnWsTeQz1t0Ls5ym8tdNbAfSGaDMJOjlsseDiczagOhQD3/gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QoGgvutVoq82KXeMlKiEAvHHSy7NU3ghCWbL563ktFY=;
 b=QbMVPUVnNyCmuVogRevxHWHqgxC1FN1S6jjhLNFLcAG1mlalE2dXNUJKpzczEDHYmMmP4EGbN5YKI9R4L1TP2JJNbFSK78OcP1M4Cc7AIGhyMGDXDs4cU3TiJnle/5jDyEiCMIk4SqXUpgs7oOJCEohsvgWt5K0gmK398sUoaoU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5522.eurprd04.prod.outlook.com (2603:10a6:208:116::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 16:22:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 16:22:30 +0000
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
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 2/4] net: dsa: felix: stop migrating FDBs back and forth on tag proto change
Date:   Thu,  5 May 2022 19:22:11 +0300
Message-Id: <20220505162213.307684-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220505162213.307684-1-vladimir.oltean@nxp.com>
References: <20220505162213.307684-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0021.eurprd03.prod.outlook.com
 (2603:10a6:208:14::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 148baa14-f92d-4d5d-80e6-08da2eb3739b
X-MS-TrafficTypeDiagnostic: AM0PR04MB5522:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB552289FB5A3B4FCA9ABD9913E0C29@AM0PR04MB5522.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +AaLfHUc0Qf1hD8weFjYuF82XeHA6dE9f0zmqD3CeI2mYTzyFeAkVMBpTAjQC5Ok8j28PT4etvfqawfNEc6A28veEXDD0E1PBGv00MCMguiKkFOmpd2VhzD23VMYZ2v3NaA9KMtsBA7JqNqUgZBOUH66M1nYjLZtngCfP6DhSEqk1c4X7qpeNiuOCFZeTBoXZCZNxm3VhCk4sGO1S7HqHja35RQDUk7Ngp2FvF5nudCS0VgXY4/PSQbGnkxVmb39kZM21pLa+iCgA6ZCai9NUXkJAlwKOCXk5bmd2wKNkUpVMbpWI1dNxmodw+QBD6Jt4JKQhW+kjVSwUSXLksjUdlNDLFNU0SB41uyPpHMjLllpLWPOGnghjZmKZwSZjCsQv5hdxpma5aMni22JLFk9kBIVIZDTk5f++/mPEeJ0E2egHsTbygjELA3evH+cnHuSEiTdlopuHrema01nTwEbaWgr2jB4ZQtZRwBcVfgBrMPcMccOO998LuojTEkdwCdhksPeON0gBKC0WePQb1tT7g+nniGRn0o6NO/cDRqM6xs0hh+tpEIWIjb5SgwerxlP6dSKZOmQheFJVjZC/tCq6HclA6A/XPpEq2/Aft1B0+co72q+8VzMVRUtP1jCIRFKQkcQke0BpcUyjRdA3gljhd/wiMLQb5Wr3zl5vDEiNGRXHgOG+R8VZ1AVudNlkN2thRR0ui54/kkNFX3/cjyUZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(5660300002)(7416002)(508600001)(8936002)(6506007)(6916009)(2616005)(52116002)(54906003)(186003)(6666004)(6512007)(26005)(36756003)(6486002)(44832011)(83380400001)(66946007)(4326008)(8676002)(66476007)(86362001)(66556008)(1076003)(2906002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zRj/ZUXlMgNhLRvfFhyOYYv/0cTBlC2jY00M0RAftCniFF5CzioCxdSfNc8d?=
 =?us-ascii?Q?8il+VmU0Wx6R5e7fLIOmBL+Ajj/wrrek5WxfnZeCEDrblTkqjHM49qCSWEYP?=
 =?us-ascii?Q?mPtbtBZdya3Tr7Ri0rW+5R/+1B884367b6AX1m7CHehfBdtUNpqjvHbLULm5?=
 =?us-ascii?Q?p2toaKW0bpp5smsFNGsSIB9Bs/2vGWtOOM/KCeSptGMWRtO0Y6lhiXMBc9ib?=
 =?us-ascii?Q?9HV7IrkGGod9gDHbW20WpbWiSx1Wq3FJ6kYnRnpJW1lKt28wubMx8XG1DD4r?=
 =?us-ascii?Q?D6xR6PehKL9pI9T6Zi8ArFcbKhyRACFBcuqmmmwaiVmquMp+ROaeBASu623C?=
 =?us-ascii?Q?KhPi5gB9kn4BmFzC12VWBZiae2+GOH1gp4J3Wf0WoSQ5830zWfCFg4nveRdR?=
 =?us-ascii?Q?h1qqShvuxbbQyMXV8cFRs1SW1vTFoUzdYKfIESEeOYYdYbhQJjCDMqA4kvnl?=
 =?us-ascii?Q?z9a5plRBx51wFYhX0QZmG41YdEyI4fMsb1XLF1Dlzuycw2YdxoRJMEwjJTXz?=
 =?us-ascii?Q?08kgTiv/8DQ/U0D1wzJeyalbhW/xbO3IZzibHw5YD5B7irpC9PoO8L7P0boV?=
 =?us-ascii?Q?pjtCnNI0v9qP+jpn7Xz9sa04Ks4uCIGmrwJlZjxOyK6U3xVBM3ul5HRVSFck?=
 =?us-ascii?Q?IQ9I/3kocaor1oZQSWMOnMDzsGMlPJN1lJExWK1inBsN4JGFPDtZ8HuXstTe?=
 =?us-ascii?Q?ymaFwx6ic/fMARlIEe3Wno7QDfG4lCrPDJgOZxW66+HQQu5k+4tMNim0khdP?=
 =?us-ascii?Q?wzSG6hAm+K4n9cGlh72WBP6Tc4+02F9KeKKwAiTYBqicYidPVd/0QEcrUQsh?=
 =?us-ascii?Q?NID9+9e6Rrs3BAD4ca4VAR3d1kx+jEReA1imITruHwddb6IW7KLNBiQEC++n?=
 =?us-ascii?Q?eiYj6cEY3cqET/pUj6I2G06qzfNY329eUZkDDjXSVQxncz+hIp66cNy2h7uR?=
 =?us-ascii?Q?u+LLzGnAWiPruIZpLL6/IH93bz3UAi7XpSW9M+G3sAKYinxLvx26xG4BOemZ?=
 =?us-ascii?Q?9BvtH4079rcalJs1bJXGfKcStEUJiXWf/bbi/zgIpw5oWUgszxGA6SQWPpsv?=
 =?us-ascii?Q?wHG1SoU+7Ur+uUi8AsSZyO+gimcnvq1x/ZX/7SrpaVUalkpgUv0VFDE0epNf?=
 =?us-ascii?Q?OMfNgp3LPhISTvoMRY/xORYaChYedasyyIsJN+TZxn02Cb4VzOIecB9qC2cU?=
 =?us-ascii?Q?LcljK+pMHBiDe+fr/1Fss33PTDbGsFzmvb9l2QFp8VMrq9JZrYUcU3IQ0Cfg?=
 =?us-ascii?Q?Uq7Xn9OCLfjmWBCGkPf/Zwh503luptISKyMNKCgMkvHUqFFFUmZSMhMMFr+X?=
 =?us-ascii?Q?UKWDDAnb0yO/RqhGKQGeA3OlfU644CyxxyYtTmngf4V9BB0ysfsU46VBkR+Y?=
 =?us-ascii?Q?GwSbs00J/S/4B21F5ycBh0lHO+K1mt00tx6I0UQLPk69CfeUPnwKUsFOTs5w?=
 =?us-ascii?Q?4fYqXgNEnhmk1TH7f0O4iEXYdmrGhaIr+qNh+FkraaBZ0yKFe4Kq0JPbQCso?=
 =?us-ascii?Q?uRqavVmOlG4gw8kQNFufzJUm3PEaB7JkF2Wnr3GNjTbtyo056OyfW6H5uiQf?=
 =?us-ascii?Q?I+vCeZwslG0LJvqJo2p7/Pi1mzW5kTIruvBewo019I1/TN3abAxBB+t+RAr+?=
 =?us-ascii?Q?Dl9KoGrehUdlseN12MNKSS9psCqGEIaPRx1836RsEXUHlN3ohZK/rDrF8DHZ?=
 =?us-ascii?Q?m9h1i+HW4XHuazQGYezMJ07KmKKReWXORcZxt/C1b9pZ+PhDwPDghqwb/OxC?=
 =?us-ascii?Q?WaI6awHaqnA16e9v3bHsZ1Nk357HM1Q=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 148baa14-f92d-4d5d-80e6-08da2eb3739b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 16:22:30.2909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBNRh4cY8kE+x24RDSLy4YOIMKJmw6KrqxX7UrEHlq09bdKC7lcch5SrPapQiVYTvK+qbwqqsEtFVaNMkYvuvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5522
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just realized we don't need to migrate the host-filtered FDB entries
when the tagging protocol changes from "ocelot" to "ocelot-8021q".

Host-filtered addresses are learned towards the PGID_CPU "multicast"
port group, reserved by software, which contains BIT(ocelot->num_phys_ports).
That is the "special" port entry in the analyzer block for the CPU port
module.

In "ocelot" mode, the CPU port module's packets are redirected to the
NPI port.

In "ocelot-8021q" mode, felix_8021q_cpu_port_init() does something funny
anyway, and changes PGID_CPU to stop pointing at the CPU port module and
start pointing at the physical port where the DSA master is attached.

The fact that we can alter the destination of packets learned towards
PGID_CPU without altering the MAC table entries themselves means that it
is pointless to walk through the FDB entries, forget that they were
learned towards PGID_CPU, and re-learn them towards the "unicast" PGID
associated with the physical port connected to the DSA master. We can
let the PGID_CPU value change simply alter the destination of the
host-filtered unicast packets in one fell swoop.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 55 ++--------------------------------
 1 file changed, 2 insertions(+), 53 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6bb10a0aa11c..4331714a45c5 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -42,22 +42,6 @@ static struct net_device *felix_classify_db(struct dsa_db db)
 	}
 }
 
-/* We are called before felix_npi_port_init(), so ocelot->npi is -1. */
-static int felix_migrate_fdbs_to_npi_port(struct dsa_switch *ds, int port,
-					  const unsigned char *addr, u16 vid,
-					  struct dsa_db db)
-{
-	struct net_device *bridge_dev = felix_classify_db(db);
-	struct ocelot *ocelot = ds->priv;
-	int err;
-
-	err = ocelot_fdb_del(ocelot, port, addr, vid, bridge_dev);
-	if (err)
-		return err;
-
-	return ocelot_fdb_add(ocelot, PGID_CPU, addr, vid, bridge_dev);
-}
-
 static int felix_migrate_mdbs_to_npi_port(struct dsa_switch *ds, int port,
 					  const unsigned char *addr, u16 vid,
 					  struct dsa_db db)
@@ -116,26 +100,6 @@ felix_migrate_flood_to_tag_8021q_port(struct dsa_switch *ds, int port)
 	felix_migrate_pgid_bit(ds, ocelot->num_phys_ports, port, PGID_BC);
 }
 
-/* ocelot->npi was already set to -1 by felix_npi_port_deinit, so
- * ocelot_fdb_add() will not redirect FDB entries towards the
- * CPU port module here, which is what we want.
- */
-static int
-felix_migrate_fdbs_to_tag_8021q_port(struct dsa_switch *ds, int port,
-				     const unsigned char *addr, u16 vid,
-				     struct dsa_db db)
-{
-	struct net_device *bridge_dev = felix_classify_db(db);
-	struct ocelot *ocelot = ds->priv;
-	int err;
-
-	err = ocelot_fdb_del(ocelot, PGID_CPU, addr, vid, bridge_dev);
-	if (err)
-		return err;
-
-	return ocelot_fdb_add(ocelot, port, addr, vid, bridge_dev);
-}
-
 static int
 felix_migrate_mdbs_to_tag_8021q_port(struct dsa_switch *ds, int port,
 				     const unsigned char *addr, u16 vid,
@@ -491,13 +455,9 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	if (err)
 		return err;
 
-	err = dsa_port_walk_fdbs(ds, cpu, felix_migrate_fdbs_to_tag_8021q_port);
-	if (err)
-		goto out_tag_8021q_unregister;
-
 	err = dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_tag_8021q_port);
 	if (err)
-		goto out_migrate_fdbs;
+		goto out_tag_8021q_unregister;
 
 	felix_migrate_flood_to_tag_8021q_port(ds, cpu);
 
@@ -519,8 +479,6 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 out_migrate_flood:
 	felix_migrate_flood_to_npi_port(ds, cpu);
 	dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_npi_port);
-out_migrate_fdbs:
-	dsa_port_walk_fdbs(ds, cpu, felix_migrate_fdbs_to_npi_port);
 out_tag_8021q_unregister:
 	dsa_tag_8021q_unregister(ds);
 	return err;
@@ -600,24 +558,15 @@ static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu)
 	struct ocelot *ocelot = ds->priv;
 	int err;
 
-	err = dsa_port_walk_fdbs(ds, cpu, felix_migrate_fdbs_to_npi_port);
-	if (err)
-		return err;
-
 	err = dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_npi_port);
 	if (err)
-		goto out_migrate_fdbs;
+		return err;
 
 	felix_migrate_flood_to_npi_port(ds, cpu);
 
 	felix_npi_port_init(ocelot, cpu);
 
 	return 0;
-
-out_migrate_fdbs:
-	dsa_port_walk_fdbs(ds, cpu, felix_migrate_fdbs_to_tag_8021q_port);
-
-	return err;
 }
 
 static void felix_teardown_tag_npi(struct dsa_switch *ds, int cpu)
-- 
2.25.1

