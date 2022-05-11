Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F280D522FE6
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiEKJwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238744AbiEKJvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:51:15 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60077.outbound.protection.outlook.com [40.107.6.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BA4377CD
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:50:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoPmDcxvHIl0bgYbMWGmnaMM8LkI4h9CoMozr/Oaby1CzMs9F0hZJYUmgeB+Ow1gs9mLDSyzCxedsViG1idfikZVYJN1xsiXaClop1CYqFLn/TzR6gDSpLp1beQzk7nI3AocE6K3F12DAM/UR4iFcwsIx2NeJxB0Htgw9fNqr9I9h/h0EQgZkho3vz33GH7ILJdTgaS6psBVa/zD6UUAYitDssBRBrHHLd55cQOIwjMiQmh7jnB9VtjP99Wz3YuAKrHDROXJzYnqXLH0cRN2pN+Gp73wVIkLyWsslOpd4TgNaV7vxRvJj3lWihoFVtgOohksi3Zx4pnG94yAC34Sjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/3vPEWO4tzy7NyYnLL0uQQOEabg+wLVr04OHD2FmHM=;
 b=i7f0fTzlBBBjA/H2M6Tz42WSkOZJMG51tGXUx359vaEM36sRB5VDFi46V3SoUuOoQqNMwh7VnBREW7TQYhdQa+7isHhSReAOWeorPi4TAwrvwWv9bXaNRHKhJ5ol0rReSb/qvvsB3AlYyTU4reLBDAV+FzKZbyEwIJ3JpPlHVfCVHmUJhyVGuwgmxuTvYQ6ABsbtbpocbNnTGas/KZz0/PAzOQt0MzjD7NPbCz8CJ+rRhPqiexTP419WnUdFF9NlDY4SFyIhLQPVZ7ovqq+6fXG5gE3nb+eMgUitK4XuCtCPetXKzOJBYeTQAFI0ui/BysVltDYHGSPQCUYBOCW0ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/3vPEWO4tzy7NyYnLL0uQQOEabg+wLVr04OHD2FmHM=;
 b=X2ZSSCGGsE5DuKtlJAPxj7nOg4wo5nwqntxT/xvFOnplVCuaAw2IRG+NzyCXci2El0/PoNdxUR0+pN5Jn1DNWxR986L6jYa8iNEJ79haHeU8hu17Nhc7hGuFOGeimNUjxC2sOx+ctJg3qdmBD8Fx4vqs+rXGt1ApQh2fejo8za8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4964.eurprd04.prod.outlook.com (2603:10a6:208:c8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 09:50:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 09:50:49 +0000
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
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v2 net-next 8/8] net: dsa: felix: reimplement tagging protocol change with function pointers
Date:   Wed, 11 May 2022 12:50:20 +0300
Message-Id: <20220511095020.562461-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511095020.562461-1-vladimir.oltean@nxp.com>
References: <20220511095020.562461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0158.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbd4e43a-2493-486c-f632-08da3333ba3e
X-MS-TrafficTypeDiagnostic: AM0PR04MB4964:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB49642BADC8682715D0598478E0C89@AM0PR04MB4964.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jbTC65fqeaVHYNz7zgpHdJqw3rLzVealiWiNSJ5CmwLgHySnIuYIem9W9kfZkF+bJuh//VYebj8eWP3NK2LXukHMm+ztuqiH2N9zOi8NoDDu8m849OF9SqQwouWug+hg16wHGyAXFtWpEZuJXZkIPu82djlR9vqeDECAUeWT3crvEGcKK54MndXOFrC41iFULcgSSgAqyggs9e3ElDbQACzbAUBfZL/Hj2zIlhiCy6fey8xwXY7Tpmit8utxxbnVOqbhtnhmCBMXIBzyltCGF0Ag1c7qZ8VsGAZGUMBp9LIsxiAhe9m9MpnnIXCP4iZWN0o9W26rwSwLvfQizhdBiYym4pz7SHqBgnyVtgVePkYDwDa3FObHx50HdV3PeYTJkYqThbApGXdlNbjTU7YAqZgBcP4Tmh3oB92k0ZKZ1WhOPklWUXeUKUgVzEaBZQODe2uBXSPCIQLvZTaAtqLcbHZ6t+XuyTPYnYAHqcey0NUPLV2cnu2zWWNhPbF6clO4bgaMrFxOVnMp/AxyD2Q2Y1yHloi+ta3CIl0zgX9Zf7b0e7c9mAUt+7PfpEtF0ksuUjTBSRlieoFz3v/Z9DCufToRiAl42irBAzP10aRJnouPj8w3shG610v3TNIgyU6pchv7ak71+0AIO3AACh5xazMrQIy/FhSmLypDgraERIoBE88SxRADL/nazKdT9jpSxwtRXfyBBF30BiLk8NmY2ureGJFCshk4yP9KWu8+Nmc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(54906003)(38350700002)(66946007)(6916009)(508600001)(66476007)(8676002)(66556008)(186003)(1076003)(316002)(83380400001)(36756003)(2906002)(44832011)(86362001)(6512007)(5660300002)(30864003)(2616005)(7416002)(8936002)(6486002)(6666004)(4326008)(6506007)(26005)(52116002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vJmYNnw2nROQUNgtHMM5Wo2H3a/1fGAXTIaHr2JCGsrWGZxUmeGLq235miO3?=
 =?us-ascii?Q?o1y4xGaSBBze0BvQ+BV2Vtr7P8WPc1jAuQ+7SyXupY1/haOwx8jbsxwVCmim?=
 =?us-ascii?Q?WZWUFFAXXMLyFFXslFtpUTcbfnAETIJmys44HMnNEMT9ZGJVygE4g5acAcIR?=
 =?us-ascii?Q?r6yKhvsKLL5uGdq17O3M7AjtHXpM1mRqzBls+UAVsypzVuY4rU6KIM+AGABb?=
 =?us-ascii?Q?wWLFoM8ZuCecSXS3+ovu4t8NWPz5WQo4pOPyDQMOT0dHevWK1iKcrqfJ55//?=
 =?us-ascii?Q?3nUgFZwCzVr5EZXn06lE/PBwqGp035JwCH76wBKnrmY3jGUpHViV50YUjTmC?=
 =?us-ascii?Q?ctqM6Jtuq8Ty4CqvQByhw200Z9cHC7UIN4h16h3z9tz/9XmbfUaSQ6rMl4ej?=
 =?us-ascii?Q?tAtORIEW6ZyWjVliQN5VqUTO9DPtGXBqL92seXncs/BYqag/LyjJtccB8qxk?=
 =?us-ascii?Q?YpltAJtZsqQBWPqIEHCU6hP2PuOgxCg2Y8q7DEDkU6yljKQsZ/VieRyfUNG1?=
 =?us-ascii?Q?hOyF49BaakfW8iejHrLIzYO4F/BY/bWsYwnZ6CoTNgUzfA+DIth0Yqxk2uZJ?=
 =?us-ascii?Q?f11JGbZS38RpbF0Wzw9PyfOX88J7Mt2+1VjMwQVYwC+4BaFZKsV6tBtYyDGP?=
 =?us-ascii?Q?KOObNyT9+Zgy75Hm8EcEjxF7oL9BlYwqoeV38aP/L/AuK8MAfafzIDSrQ/Qp?=
 =?us-ascii?Q?tQA3lBABAlrBz75AVALT6foviqZbX7AbOgTD/fbSoubPfMwaCdPgD9wtsSX2?=
 =?us-ascii?Q?pMxSuSdGGLhUj7EdQbWxAMbEY5TYtxP5DV4qlMDAZ45TONJJzUz+u7OzgPpO?=
 =?us-ascii?Q?H/UjyRGqi1KeHNzbAz6zYNULddltDejVyOPN/zk6K9yMd7WXN6MUYGn8QaaY?=
 =?us-ascii?Q?F6qFMqcea921Zr2fGIIR2FMmnX/Lx+Dd9qmiH3COTj8PLaFTMjl4DoZw7a5i?=
 =?us-ascii?Q?kLQWVRvNDXCHvmM3NcLchA0ALECRj5Y5bM0vSDy4GB0jvQcOxSESk/U73+vB?=
 =?us-ascii?Q?90NOz9YF1LA7/YpU5UGn/1jWPicolu/ng+G4W8+UsUfuZmY8S5v+FVdd7msY?=
 =?us-ascii?Q?Eo3S3pHJ67pYVkU3vUoGqBlQMZchWsTBcnRdrB6L7sys85rMUueMUMV3Gdpn?=
 =?us-ascii?Q?LUv3am6SWEW/D+YK+HwnD/aGABSTrPjwkwvwXb3OkTR52tgi5bb4xm6iAne0?=
 =?us-ascii?Q?kF8e7hrkrRbGEZMS4yNGx1Ke495z0IUAt15k9XZomRizLa/bYdfOwC94ntwQ?=
 =?us-ascii?Q?movAGjS3rR24QOBqrHdm9b6LysoAW0ubZSYwRwjs8lbcznknxjjpw4mFV5sE?=
 =?us-ascii?Q?qVEyh5Kf2xk4drJoSBnt6b7WgOvjJNyHrxKpQXALEV2/jW48+yGw7le+JdIt?=
 =?us-ascii?Q?10R5oW94PXNprS/JOR4xDkx9wiKMbdUax6II1GiNct7n6SG2Vs9Yv3nGcuLl?=
 =?us-ascii?Q?7xzXXT4ThJHSkyfABiXw7opuKDQl9u3upFM8NsimdXqZA4fWIbLrZjKtLmg4?=
 =?us-ascii?Q?XBLdDxlZpVd4E1PyDK9xGz0nirtf5Y4snVuxeedK1iKQVbfLZjrh8X4wPfYg?=
 =?us-ascii?Q?8uBq5+I3MzTjusjVGuAyAig+hAWmY2vcSUzYxRmNf/ONuuVIUv0xpoe4JS14?=
 =?us-ascii?Q?Hry9uzioBjOyvAyGc/2xxONGB6p6dFuvNJjpuCo5beBVas+7LMmFjnaocDS+?=
 =?us-ascii?Q?Ip6K/ZBSbGdYpoGPtfGZxMH/02vMnBuU+QK5eSkl4JTRN6A1Y6AOyqV9cvH4?=
 =?us-ascii?Q?VeXMO/49Vm7rx7xqRp9R6R/aaRZS2Qg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd4e43a-2493-486c-f632-08da3333ba3e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:50:49.0039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mZSf8xO3SZu22cq/kVnVH5bTa7p43DEu3fmQ1IWwAuDVLJtPnhNRxut2Oc8spau+ACu7+8BjNPd4sH5qWlP0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4964
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error handling for the current tagging protocol change procedure is
a bit brittle (we dismantle the previous tagging protocol entirely
before setting up the new one). By identifying which parts of a tagging
protocol are unique to itself and which parts are shared with the other,
we can implement a protocol change procedure where error handling is a
bit more robust, because we start setting up the new protocol first, and
tear down the old one only after the setup of the specific and shared
parts succeeded.

The protocol change is a bit too open-coded too, in the area of
migrating host flood settings and MDBs. By identifying what differs
between tagging protocols (the forwarding masks for host flooding) we
can implement a more straightforward migration procedure which is
handled in the shared portion of the protocol change, rather than
individually by each protocol.

Therefore, a more structured approach calls for the introduction of a
structure of function pointers per tagging protocol. This covers setup,
teardown and the host forwarding mask. In the future it will also cover
how to prepare for a new DSA master.

The initial tagging protocol setup (at driver probe time) and the final
teardown (at driver removal time) are also adapted to call into the
structured methods of the specific protocol in current use. This is
especially relevant for teardown, where we previously called
felix_del_tag_protocol() only for the first CPU port. But by not
specifying which CPU port this is for, we gain more flexibility to
support multiple CPU ports in the future.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix.c | 399 +++++++++++++++++----------------
 drivers/net/dsa/ocelot/felix.h |  14 ++
 2 files changed, 216 insertions(+), 197 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e76a5d434626..beac90bc642c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -42,43 +42,6 @@ static struct net_device *felix_classify_db(struct dsa_db db)
 	}
 }
 
-static void felix_migrate_pgid_bit(struct dsa_switch *ds, int from, int to,
-				   int pgid)
-{
-	struct ocelot *ocelot = ds->priv;
-	bool on;
-	u32 val;
-
-	val = ocelot_read_rix(ocelot, ANA_PGID_PGID, pgid);
-	on = !!(val & BIT(from));
-	val &= ~BIT(from);
-	if (on)
-		val |= BIT(to);
-	else
-		val &= ~BIT(to);
-
-	ocelot_write_rix(ocelot, val, ANA_PGID_PGID, pgid);
-}
-
-static void felix_migrate_flood_to_npi_port(struct dsa_switch *ds, int port)
-{
-	struct ocelot *ocelot = ds->priv;
-
-	felix_migrate_pgid_bit(ds, port, ocelot->num_phys_ports, PGID_UC);
-	felix_migrate_pgid_bit(ds, port, ocelot->num_phys_ports, PGID_MC);
-	felix_migrate_pgid_bit(ds, port, ocelot->num_phys_ports, PGID_BC);
-}
-
-static void
-felix_migrate_flood_to_tag_8021q_port(struct dsa_switch *ds, int port)
-{
-	struct ocelot *ocelot = ds->priv;
-
-	felix_migrate_pgid_bit(ds, ocelot->num_phys_ports, port, PGID_UC);
-	felix_migrate_pgid_bit(ds, ocelot->num_phys_ports, port, PGID_MC);
-	felix_migrate_pgid_bit(ds, ocelot->num_phys_ports, port, PGID_BC);
-}
-
 /* Set up VCAP ES0 rules for pushing a tag_8021q VLAN towards the CPU such that
  * the tagger can perform RX source port identification.
  */
@@ -392,13 +355,107 @@ static int felix_update_trapping_destinations(struct dsa_switch *ds,
 	return 0;
 }
 
-static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
+/* The CPU port module is connected to the Node Processor Interface (NPI). This
+ * is the mode through which frames can be injected from and extracted to an
+ * external CPU, over Ethernet. In NXP SoCs, the "external CPU" is the ARM CPU
+ * running Linux, and this forms a DSA setup together with the enetc or fman
+ * DSA master.
+ */
+static void felix_npi_port_init(struct ocelot *ocelot, int port)
+{
+	ocelot->npi = port;
+
+	ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
+		     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(port),
+		     QSYS_EXT_CPU_CFG);
+
+	/* NPI port Injection/Extraction configuration */
+	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_XTR_HDR,
+			    ocelot->npi_xtr_prefix);
+	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_INJ_HDR,
+			    ocelot->npi_inj_prefix);
+
+	/* Disable transmission of pause frames */
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
+}
+
+static void felix_npi_port_deinit(struct ocelot *ocelot, int port)
+{
+	/* Restore hardware defaults */
+	int unused_port = ocelot->num_phys_ports + 2;
+
+	ocelot->npi = -1;
+
+	ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPU_PORT(unused_port),
+		     QSYS_EXT_CPU_CFG);
+
+	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_XTR_HDR,
+			    OCELOT_TAG_PREFIX_DISABLED);
+	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_INJ_HDR,
+			    OCELOT_TAG_PREFIX_DISABLED);
+
+	/* Enable transmission of pause frames */
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 1);
+}
+
+static int felix_tag_npi_setup(struct dsa_switch *ds)
+{
+	struct dsa_port *dp, *first_cpu_dp = NULL;
+	struct ocelot *ocelot = ds->priv;
+
+	dsa_switch_for_each_user_port(dp, ds) {
+		if (first_cpu_dp && dp->cpu_dp != first_cpu_dp) {
+			dev_err(ds->dev, "Multiple NPI ports not supported\n");
+			return -EINVAL;
+		}
+
+		first_cpu_dp = dp->cpu_dp;
+	}
+
+	if (!first_cpu_dp)
+		return -EINVAL;
+
+	felix_npi_port_init(ocelot, first_cpu_dp->index);
+
+	return 0;
+}
+
+static void felix_tag_npi_teardown(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct dsa_port *dp;
+
+	felix_npi_port_deinit(ocelot, ocelot->npi);
+}
+
+static unsigned long felix_tag_npi_get_host_fwd_mask(struct dsa_switch *ds)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return BIT(ocelot->num_phys_ports);
+}
+
+static const struct felix_tag_proto_ops felix_tag_npi_proto_ops = {
+	.setup			= felix_tag_npi_setup,
+	.teardown		= felix_tag_npi_teardown,
+	.get_host_fwd_mask	= felix_tag_npi_get_host_fwd_mask,
+};
+
+static int felix_tag_8021q_setup(struct dsa_switch *ds)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct dsa_port *dp, *cpu_dp;
 	int err;
 
-	felix_8021q_cpu_port_init(ocelot, cpu);
+	err = dsa_tag_8021q_register(ds, htons(ETH_P_8021AD));
+	if (err)
+		return err;
+
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		felix_8021q_cpu_port_init(ocelot, cpu_dp->index);
+
+		/* TODO we could support multiple CPU ports in tag_8021q mode */
+		break;
+	}
 
 	dsa_switch_for_each_available_port(dp, ds) {
 		/* This overwrites ocelot_init():
@@ -416,21 +473,6 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 				 ANA_PORT_CPU_FWD_BPDU_CFG, dp->index);
 	}
 
-	err = dsa_tag_8021q_register(ds, htons(ETH_P_8021AD));
-	if (err)
-		return err;
-
-	err = ocelot_migrate_mdbs(ocelot, BIT(ocelot->num_phys_ports),
-				  BIT(cpu));
-	if (err)
-		goto out_tag_8021q_unregister;
-
-	felix_migrate_flood_to_tag_8021q_port(ds, cpu);
-
-	err = felix_update_trapping_destinations(ds, true);
-	if (err)
-		goto out_migrate_flood;
-
 	/* The ownership of the CPU port module's queues might have just been
 	 * transferred to the tag_8021q tagger from the NPI-based tagger.
 	 * So there might still be all sorts of crap in the queues. On the
@@ -441,27 +483,12 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	ocelot_drain_cpu_queue(ocelot, 0);
 
 	return 0;
-
-out_migrate_flood:
-	felix_migrate_flood_to_npi_port(ds, cpu);
-	ocelot_migrate_mdbs(ocelot, BIT(cpu), BIT(ocelot->num_phys_ports));
-out_tag_8021q_unregister:
-	dsa_tag_8021q_unregister(ds);
-	return err;
 }
 
-static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
+static void felix_tag_8021q_teardown(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct dsa_port *dp;
-	int err;
-
-	err = felix_update_trapping_destinations(ds, false);
-	if (err)
-		dev_err(ds->dev, "felix_teardown_mmio_filtering returned %d",
-			err);
-
-	dsa_tag_8021q_unregister(ds);
+	struct dsa_port *dp, *cpu_dp;
 
 	dsa_switch_for_each_available_port(dp, ds) {
 		/* Restore the logic from ocelot_init:
@@ -473,110 +500,99 @@ static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
 				 dp->index);
 	}
 
-	felix_8021q_cpu_port_deinit(ocelot, cpu);
-}
-
-/* The CPU port module is connected to the Node Processor Interface (NPI). This
- * is the mode through which frames can be injected from and extracted to an
- * external CPU, over Ethernet. In NXP SoCs, the "external CPU" is the ARM CPU
- * running Linux, and this forms a DSA setup together with the enetc or fman
- * DSA master.
- */
-static void felix_npi_port_init(struct ocelot *ocelot, int port)
-{
-	ocelot->npi = port;
-
-	ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
-		     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(port),
-		     QSYS_EXT_CPU_CFG);
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		felix_8021q_cpu_port_deinit(ocelot, cpu_dp->index);
 
-	/* NPI port Injection/Extraction configuration */
-	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_XTR_HDR,
-			    ocelot->npi_xtr_prefix);
-	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_INJ_HDR,
-			    ocelot->npi_inj_prefix);
+		/* TODO we could support multiple CPU ports in tag_8021q mode */
+		break;
+	}
 
-	/* Disable transmission of pause frames */
-	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
+	dsa_tag_8021q_unregister(ds);
 }
 
-static void felix_npi_port_deinit(struct ocelot *ocelot, int port)
+static unsigned long felix_tag_8021q_get_host_fwd_mask(struct dsa_switch *ds)
 {
-	/* Restore hardware defaults */
-	int unused_port = ocelot->num_phys_ports + 2;
+	return dsa_cpu_ports(ds);
+}
 
-	ocelot->npi = -1;
+static const struct felix_tag_proto_ops felix_tag_8021q_proto_ops = {
+	.setup			= felix_tag_8021q_setup,
+	.teardown		= felix_tag_8021q_teardown,
+	.get_host_fwd_mask	= felix_tag_8021q_get_host_fwd_mask,
+};
 
-	ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPU_PORT(unused_port),
-		     QSYS_EXT_CPU_CFG);
+static void felix_set_host_flood(struct dsa_switch *ds, unsigned long mask,
+				 bool uc, bool mc, bool bc)
+{
+	struct ocelot *ocelot = ds->priv;
+	unsigned long val;
 
-	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_XTR_HDR,
-			    OCELOT_TAG_PREFIX_DISABLED);
-	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_INJ_HDR,
-			    OCELOT_TAG_PREFIX_DISABLED);
+	val = uc ? mask : 0;
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_UC);
 
-	/* Enable transmission of pause frames */
-	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 1);
+	val = mc ? mask : 0;
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MCIPV6);
 }
 
-static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu)
+static void
+felix_migrate_host_flood(struct dsa_switch *ds,
+			 const struct felix_tag_proto_ops *proto_ops,
+			 const struct felix_tag_proto_ops *old_proto_ops)
 {
 	struct ocelot *ocelot = ds->priv;
-	int err;
-
-	err = ocelot_migrate_mdbs(ocelot, BIT(cpu),
-				  BIT(ocelot->num_phys_ports));
-	if (err)
-		return err;
-
-	felix_migrate_flood_to_npi_port(ds, cpu);
+	struct felix *felix = ocelot_to_felix(ocelot);
+	unsigned long mask;
 
-	felix_npi_port_init(ocelot, cpu);
+	if (old_proto_ops) {
+		mask = old_proto_ops->get_host_fwd_mask(ds);
+		felix_set_host_flood(ds, mask, false, false, false);
+	}
 
-	return 0;
+	mask = proto_ops->get_host_fwd_mask(ds);
+	felix_set_host_flood(ds, mask, !!felix->host_flood_uc_mask,
+			     !!felix->host_flood_mc_mask, true);
 }
 
-static void felix_teardown_tag_npi(struct dsa_switch *ds, int cpu)
+static int felix_migrate_mdbs(struct dsa_switch *ds,
+			      const struct felix_tag_proto_ops *proto_ops,
+			      const struct felix_tag_proto_ops *old_proto_ops)
 {
 	struct ocelot *ocelot = ds->priv;
+	unsigned long from, to;
+
+	if (!old_proto_ops)
+		return 0;
+
+	from = old_proto_ops->get_host_fwd_mask(ds);
+	to = proto_ops->get_host_fwd_mask(ds);
 
-	felix_npi_port_deinit(ocelot, cpu);
+	return ocelot_migrate_mdbs(ocelot, from, to);
 }
 
-static int felix_set_tag_protocol(struct dsa_switch *ds, int cpu,
-				  enum dsa_tag_protocol proto)
+/* Configure the shared hardware resources for a transition between
+ * @old_proto_ops and @proto_ops.
+ * Manual migration is needed because as far as DSA is concerned, no change of
+ * the CPU port is taking place here, just of the tagging protocol.
+ */
+static int
+felix_tag_proto_setup_shared(struct dsa_switch *ds,
+			     const struct felix_tag_proto_ops *proto_ops,
+			     const struct felix_tag_proto_ops *old_proto_ops)
 {
+	bool using_tag_8021q = (proto_ops == &felix_tag_8021q_proto_ops);
 	int err;
 
-	switch (proto) {
-	case DSA_TAG_PROTO_SEVILLE:
-	case DSA_TAG_PROTO_OCELOT:
-		err = felix_setup_tag_npi(ds, cpu);
-		break;
-	case DSA_TAG_PROTO_OCELOT_8021Q:
-		err = felix_setup_tag_8021q(ds, cpu);
-		break;
-	default:
-		err = -EPROTONOSUPPORT;
-	}
+	err = felix_migrate_mdbs(ds, proto_ops, old_proto_ops);
+	if (err)
+		return err;
 
-	return err;
-}
+	felix_update_trapping_destinations(ds, using_tag_8021q);
 
-static void felix_del_tag_protocol(struct dsa_switch *ds, int cpu,
-				   enum dsa_tag_protocol proto)
-{
-	switch (proto) {
-	case DSA_TAG_PROTO_SEVILLE:
-	case DSA_TAG_PROTO_OCELOT:
-		felix_teardown_tag_npi(ds, cpu);
-		break;
-	case DSA_TAG_PROTO_OCELOT_8021Q:
-		felix_teardown_tag_8021q(ds, cpu);
-		break;
-	default:
-		break;
-	}
+	felix_migrate_host_flood(ds, proto_ops, old_proto_ops);
+
+	return 0;
 }
 
 /* This always leaves the switch in a consistent state, because although the
@@ -586,33 +602,45 @@ static void felix_del_tag_protocol(struct dsa_switch *ds, int cpu,
 static int felix_change_tag_protocol(struct dsa_switch *ds,
 				     enum dsa_tag_protocol proto)
 {
+	const struct felix_tag_proto_ops *old_proto_ops, *proto_ops;
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	enum dsa_tag_protocol old_proto = felix->tag_proto;
-	struct dsa_port *cpu_dp;
 	int err;
 
-	if (proto != DSA_TAG_PROTO_SEVILLE &&
-	    proto != DSA_TAG_PROTO_OCELOT &&
-	    proto != DSA_TAG_PROTO_OCELOT_8021Q)
+	switch (proto) {
+	case DSA_TAG_PROTO_SEVILLE:
+	case DSA_TAG_PROTO_OCELOT:
+		proto_ops = &felix_tag_npi_proto_ops;
+		break;
+	case DSA_TAG_PROTO_OCELOT_8021Q:
+		proto_ops = &felix_tag_8021q_proto_ops;
+		break;
+	default:
 		return -EPROTONOSUPPORT;
+	}
 
-	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		felix_del_tag_protocol(ds, cpu_dp->index, old_proto);
+	old_proto_ops = felix->tag_proto_ops;
 
-		err = felix_set_tag_protocol(ds, cpu_dp->index, proto);
-		if (err) {
-			felix_set_tag_protocol(ds, cpu_dp->index, old_proto);
-			return err;
-		}
+	err = proto_ops->setup(ds);
+	if (err)
+		goto setup_failed;
 
-		/* Stop at first CPU port */
-		break;
-	}
+	err = felix_tag_proto_setup_shared(ds, proto_ops, old_proto_ops);
+	if (err)
+		goto setup_shared_failed;
 
+	if (old_proto_ops)
+		old_proto_ops->teardown(ds);
+
+	felix->tag_proto_ops = proto_ops;
 	felix->tag_proto = proto;
 
 	return 0;
+
+setup_shared_failed:
+	proto_ops->teardown(ds);
+setup_failed:
+	return err;
 }
 
 static enum dsa_tag_protocol felix_get_tag_protocol(struct dsa_switch *ds,
@@ -630,7 +658,7 @@ static void felix_port_set_host_flood(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	unsigned long mask, val;
+	unsigned long mask;
 
 	if (uc)
 		felix->host_flood_uc_mask |= BIT(port);
@@ -642,18 +670,9 @@ static void felix_port_set_host_flood(struct dsa_switch *ds, int port,
 	else
 		felix->host_flood_mc_mask &= ~BIT(port);
 
-	if (felix->tag_proto == DSA_TAG_PROTO_OCELOT_8021Q)
-		mask = dsa_cpu_ports(ds);
-	else
-		mask = BIT(ocelot->num_phys_ports);
-
-	val = (felix->host_flood_uc_mask) ? mask : 0;
-	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_UC);
-
-	val = (felix->host_flood_mc_mask) ? mask : 0;
-	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MC);
-	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MCIPV4);
-	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MCIPV6);
+	mask = felix->tag_proto_ops->get_host_fwd_mask(ds);
+	felix_set_host_flood(ds, mask, !!felix->host_flood_uc_mask,
+			     !!felix->host_flood_mc_mask, true);
 }
 
 static int felix_set_ageing_time(struct dsa_switch *ds,
@@ -1332,7 +1351,6 @@ static int felix_setup(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	unsigned long cpu_flood;
 	struct dsa_port *dp;
 	int err;
 
@@ -1366,21 +1384,10 @@ static int felix_setup(struct dsa_switch *ds)
 	if (err)
 		goto out_deinit_ports;
 
-	dsa_switch_for_each_cpu_port(dp, ds) {
-		/* The initial tag protocol is NPI which always returns 0, so
-		 * there's no real point in checking for errors.
-		 */
-		felix_set_tag_protocol(ds, dp->index, felix->tag_proto);
-
-		/* Start off with flooding disabled towards the NPI port
-		 * (actually CPU port module).
-		 */
-		cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
-		ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_UC);
-		ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_MC);
-
-		break;
-	}
+	/* The initial tag protocol is NPI which won't fail during initial
+	 * setup, there's no real point in checking for errors.
+	 */
+	felix_change_tag_protocol(ds, felix->tag_proto);
 
 	ds->mtu_enforcement_ingress = true;
 	ds->assisted_learning_on_cpu_port = true;
@@ -1409,10 +1416,8 @@ static void felix_teardown(struct dsa_switch *ds)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_port *dp;
 
-	dsa_switch_for_each_cpu_port(dp, ds) {
-		felix_del_tag_protocol(ds, dp->index, felix->tag_proto);
-		break;
-	}
+	if (felix->tag_proto_ops)
+		felix->tag_proto_ops->teardown(ds);
 
 	dsa_switch_for_each_available_port(dp, ds)
 		ocelot_deinit_port(ocelot, dp->index);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index b34bde43f11b..9e07eb7ee28d 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -59,6 +59,19 @@ struct felix_info {
 				      struct resource *res);
 };
 
+/* Methods for initializing the hardware resources specific to a tagging
+ * protocol (like the NPI port, for "ocelot" or "seville", or the VCAP TCAMs,
+ * for "ocelot-8021q").
+ * It is important that the resources configured here do not have side effects
+ * for the other tagging protocols. If that is the case, their configuration
+ * needs to go to felix_tag_proto_setup_shared().
+ */
+struct felix_tag_proto_ops {
+	int (*setup)(struct dsa_switch *ds);
+	void (*teardown)(struct dsa_switch *ds);
+	unsigned long (*get_host_fwd_mask)(struct dsa_switch *ds);
+};
+
 extern const struct dsa_switch_ops felix_switch_ops;
 
 /* DSA glue / front-end for struct ocelot */
@@ -71,6 +84,7 @@ struct felix {
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
 	enum dsa_tag_protocol		tag_proto;
+	const struct felix_tag_proto_ops *tag_proto_ops;
 	struct kthread_worker		*xmit_worker;
 	unsigned long			host_flood_uc_mask;
 	unsigned long			host_flood_mc_mask;
-- 
2.25.1

