Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277AE4D1326
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345290AbiCHJQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345279AbiCHJQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:16:30 -0500
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00041.outbound.protection.outlook.com [40.107.0.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2584140A16
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 01:15:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HR/hF/XiZ4obqzcvhLaP6jSRS4TzMSCK8tBJ+WrqpTuGztZIHDLDqfeVRUUmAkOt7bvicunSKio21kiameseuAd1t8Lw0Z+zPtX5FXKRQEvbvipZx21n3RfQLsy00dnhtf+iPuI8W1Dj9spYR1X3ocNlJF7UKMFUeGIYk7RlwPtjHrN3zqKi4wXrG1VV2xC3tfkZ/PYnAJ2O6c30plM/pNl6+MSsvCohysKyfkbTldQFmBqVMskzVTbeBVNsvwQkEPrFrtPHJmebBwgG6/7ac4BXPW9d4iNTzv8YW7X7LBWaXAPdkKLhXQbiRZiciHTvcFs8jiO8ZFmrGpKqCbVsIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3PaQlf1YGm2I9Np5TGYcd0fogH0WEtPPLgagPY7SmhI=;
 b=g7jHS96Tv4vH7Pqu50ElV86tV33Y/BvwImiwJtA/5UgR6mQwiT9Uoyy7LqO/+z1D5PmVtowneouaRHpRlhCEXWCxrgnwK/RgEr441F01tpIGe+guK7GjkGPzA/0x/ZpN7n6zZlW0i85iIBz5awke7ycEj1vDcrGkWmuMiVKfiedSVzwTAHXTY4ycfUc4HSIWdNDRzTJ5wgmraGNLxBuNarK11WQ1B0X/l2g49qxtodOvynYVE2j0veYOskmKrABkSAe7ftIQwEloNkW9kRj3zZNvPzh9/G6PUC7mKvfB5RBU7tktSjyIYVzFPktRoqnkL2qsv9xaAwRFrYYlp0QPzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PaQlf1YGm2I9Np5TGYcd0fogH0WEtPPLgagPY7SmhI=;
 b=SZlSFekDWseMtG2AQb6XBpgJ3YkxOoXNzdTgO3G/QmliXjsZYXzmd/EwNA1yQFt58WZ11Ue0Wu8v97OGKTH23NlhkPYkfzdYOJJ7OiQB/y+nY96nmJScaAcrSLe7oWc6FM6dqRqCYfJPXkYJLk/X/A+qDDXQM3AKtDg/KYp94qw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9303.eurprd04.prod.outlook.com (2603:10a6:102:2b7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.26; Tue, 8 Mar
 2022 09:15:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 09:15:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 3/6] net: dsa: felix: drop "bool change" from felix_set_tag_protocol
Date:   Tue,  8 Mar 2022 11:15:12 +0200
Message-Id: <20220308091515.4134313-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
References: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0347.eurprd06.prod.outlook.com
 (2603:10a6:20b:466::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53c97b69-ee88-4e2c-6c79-08da00e431a0
X-MS-TrafficTypeDiagnostic: PAXPR04MB9303:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9303D760ACE7A3918E563FD2E0099@PAXPR04MB9303.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8LjUq2c7jwgdgNWCKLnX0P34mCOHZhV9t8KbCE3lBX2a0Op3MFI9FZ6X3g2U3Tf7nSBRfUD7Hoeyo+jW/P3Q90FqomDufgOLWtIfYo1gMEyZg2EcdL3h/X3J6VwcUJf2hNn7bTyEhh9n6MATxNFW+Q9xXpeYlu1WsvsZUnzmkblysUobP644I2jMCzQb2d1F5OomyLo+oTTtxzGXW8GqSqcpKlKWNngyyr+UKox0sUM1M0jYwEfjsXH/G++SN0KStVojaa/wS1qGYYqliunhiaAg+MpGvUUNoDJ1YWe10Bwio4RN9MIBGt1iUTzBXF3CfpXpQr0UmdUONTInjykE4zVmLCQ/4EJTwMkn3j1YBnY4IQhPALemso3IKyXp3+OE2cdheq4W7OHqBojHjMiUMGSvnLh5OsIBK/i/yU2yKbTLrUB2nwKiw+ZRrXE3vtWEpXBQGIBvzNHMTm2eeu61/JtgIDGnCeBSAUSxmSTZtpUR4LUrOYrpSG7ybaWs3Oagj0NERJQnghx69afNaLMFAmvHD7MhSBM9/LQ3uk7M6I3PLqC0sO5p5Qth04NXbo6x6hZTuqgpia7vYiQIP6D1a4fPovdYLQubI3yqsE5DDAFQJJ2p1gcdQUmIYkteX0tb6+YyRi/dfAvWNOTJPiI+xefrz1khoMwEhxLuk0kOR99jOA+oZvNs8685ItD/eZwUlr+bh2PSfksWmpTx8sRB/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(66476007)(66556008)(6512007)(86362001)(8676002)(4326008)(44832011)(66946007)(316002)(186003)(5660300002)(83380400001)(54906003)(8936002)(6916009)(1076003)(26005)(36756003)(7416002)(6486002)(6506007)(38350700002)(508600001)(2906002)(6666004)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EUsGSLZvF7dWzFrPPzyL6ToUs2bWJUS/nJgfrsBSaLe2YGWrvBu09cfjJ5au?=
 =?us-ascii?Q?MpLXgPuUoZz1b/Dfm++Z30DPEwdd8AV1aYQmWYjfOtjM5czPgTAEeVHbTt/g?=
 =?us-ascii?Q?rF6fqy4mus05VrjZMPvQ46Oje0NV+Wvqfet3pWD1QmiIEPGCbM9ZbiWa30KK?=
 =?us-ascii?Q?S4OiTlzZBsdHQnOSFs1m5vCu95/tD0pbA81uJ62mDuolLK/N+wOm56bisiWp?=
 =?us-ascii?Q?kzjJpYkooexPjpVOHn++JEmUM9VXgpgFptSmD5qYBRxWWXkHgT7HJNmAyoLv?=
 =?us-ascii?Q?p9xFa85s+nD1VVIRKPCBUhH6fdBrTPnjLIaWUBO84K3h4E5t7B5kqwh2xaPg?=
 =?us-ascii?Q?RWpMjA+aVsaWzL/B2btBbey3i06FcQpCGTrLgtaZ8JbOi2HbOSZQOqf4lnva?=
 =?us-ascii?Q?4pLP1gf53WCCNEArm+nzfgssX8gMzasgezkaHHjcbBOEALgTKOYEjKS7l1CR?=
 =?us-ascii?Q?R4eDyrlwJFR1pVS49mFrlL0LjEACM3GisUeDgrsq5i78eiHebC7XnJ8cey16?=
 =?us-ascii?Q?pgUvHN4dB5r43PMDuDRR0UCXKb2JjUjvDpkq/+m4RVo1SpJRXMzYAuYngONr?=
 =?us-ascii?Q?QlhGrUzADXr5xcJYoAhIM1pMLD7zmJsl9gcyatTMKGk6Hq5tsevLtc0J/C7d?=
 =?us-ascii?Q?mlnJ7LiJNAwGNczccNCSNQ6kL+ASaOnAjOnvom2QpJhm7/Qqeh8JJaX05p1n?=
 =?us-ascii?Q?+yqdeR+sH0BYJ7hq1Hp09BadanhmniWIbjtgiJZ6cprk6kYGLYzNlAkG26uC?=
 =?us-ascii?Q?rxhCgfS3pGhgksKRCKbzx7A8EbvyrCbb2iMNSuxAanHAvEErI16cxCLJVpYf?=
 =?us-ascii?Q?GEKrnSVMIsDEucUswGxy/IJT9zCv6TR1WbEBcfHfRVErz4oESO19Y+9uPzSk?=
 =?us-ascii?Q?0kBgkH/TFJN66/WE3lUzq6Kwmomzy1PgVS/b1D5E1REOx5mC34EPzcRUdlRm?=
 =?us-ascii?Q?dQNkxRdLmf+ILgo9XklIjF8WclXLl22j3jyYLr9VoR73kd1foDEGgJAz5g/F?=
 =?us-ascii?Q?Kysn8Z5B0RkgV07qetSMNsKeB9EjdyDIQycDJhES7svuv7WSLC/vxwO8UdDc?=
 =?us-ascii?Q?95XGo30H4GYp97hPGdd2C5QoqiSkKhra7QHi+rUiC8bDrKub+Zz9UprkND1C?=
 =?us-ascii?Q?95WgWxjIM7cIha4Od1aTWKNtY+4AaIHl34OlejPmOg3n7PU9q0jp2evlUGvn?=
 =?us-ascii?Q?LbBnTjnAPyVSbIAFxCWLQ5mb6kr3H5pmBD/yGlBZNq7v/r7WjCfTJiEOZyt1?=
 =?us-ascii?Q?kn3HXhoZagUOhXDlzl9rEASOkFj24IwQsSZb+0Ooy2pgpDOH/OezInfXLE9g?=
 =?us-ascii?Q?83OcZp0ix3yVpmILPTShcXqYPn6CdwJAFVnieQVhsbED0/H8XCEts545u7iF?=
 =?us-ascii?Q?JSh5YaY5WdHWOjiLq8vzml+kKolqKXJqJBjFIUX+kIH3wsYJ9stFTdpV89Nl?=
 =?us-ascii?Q?52MJ3quCLbraIrcFqdqXVEiId+7v+ra7LrP89cmC2wEdcXLlyRz8U8q2OOW4?=
 =?us-ascii?Q?fH/pRCyICCezQsCEpiQFKd9msG4LGWutorVrL/1+bVBtdGSw3568FPw24BnV?=
 =?us-ascii?Q?rUlXYYBIH5WojfTV3escv1yw29X+RnY58EuoKyAFxVg3UiaheeVgsx82zTMT?=
 =?us-ascii?Q?xSMPe9HCw76LwB4xEHxVGJo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c97b69-ee88-4e2c-6c79-08da00e431a0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 09:15:31.3674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBu7lQhLEU2wW6a9aRoqhugh2RxvUhoQ3uvCearuIujDiwakPK3c6tIQyBiku4cwS8O4gXECRuoCykekgYDfjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9303
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We no longer need the workaround in the felix driver to avoid calling
dsa_port_walk_fdbs() when &dp->fdbs is an uninitialized list, because
that list is now initialized from all call paths of felix_set_tag_protocol().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 65 ++++++++++++++--------------------
 1 file changed, 26 insertions(+), 39 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 7cc67097948b..2c58031e209c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -460,7 +460,7 @@ static int felix_update_trapping_destinations(struct dsa_switch *ds,
 	return 0;
 }
 
-static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu, bool change)
+static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct dsa_port *dp;
@@ -488,19 +488,15 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu, bool change)
 	if (err)
 		return err;
 
-	if (change) {
-		err = dsa_port_walk_fdbs(ds, cpu,
-					 felix_migrate_fdbs_to_tag_8021q_port);
-		if (err)
-			goto out_tag_8021q_unregister;
+	err = dsa_port_walk_fdbs(ds, cpu, felix_migrate_fdbs_to_tag_8021q_port);
+	if (err)
+		goto out_tag_8021q_unregister;
 
-		err = dsa_port_walk_mdbs(ds, cpu,
-					 felix_migrate_mdbs_to_tag_8021q_port);
-		if (err)
-			goto out_migrate_fdbs;
+	err = dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_tag_8021q_port);
+	if (err)
+		goto out_migrate_fdbs;
 
-		felix_migrate_flood_to_tag_8021q_port(ds, cpu);
-	}
+	felix_migrate_flood_to_tag_8021q_port(ds, cpu);
 
 	err = felix_update_trapping_destinations(ds, true);
 	if (err)
@@ -518,13 +514,10 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu, bool change)
 	return 0;
 
 out_migrate_flood:
-	if (change)
-		felix_migrate_flood_to_npi_port(ds, cpu);
-	if (change)
-		dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_npi_port);
+	felix_migrate_flood_to_npi_port(ds, cpu);
+	dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_npi_port);
 out_migrate_fdbs:
-	if (change)
-		dsa_port_walk_fdbs(ds, cpu, felix_migrate_fdbs_to_npi_port);
+	dsa_port_walk_fdbs(ds, cpu, felix_migrate_fdbs_to_npi_port);
 out_tag_8021q_unregister:
 	dsa_tag_8021q_unregister(ds);
 	return err;
@@ -599,33 +592,27 @@ static void felix_npi_port_deinit(struct ocelot *ocelot, int port)
 	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 1);
 }
 
-static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu, bool change)
+static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu)
 {
 	struct ocelot *ocelot = ds->priv;
 	int err;
 
-	if (change) {
-		err = dsa_port_walk_fdbs(ds, cpu,
-					 felix_migrate_fdbs_to_npi_port);
-		if (err)
-			return err;
+	err = dsa_port_walk_fdbs(ds, cpu, felix_migrate_fdbs_to_npi_port);
+	if (err)
+		return err;
 
-		err = dsa_port_walk_mdbs(ds, cpu,
-					 felix_migrate_mdbs_to_npi_port);
-		if (err)
-			goto out_migrate_fdbs;
+	err = dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_npi_port);
+	if (err)
+		goto out_migrate_fdbs;
 
-		felix_migrate_flood_to_npi_port(ds, cpu);
-	}
+	felix_migrate_flood_to_npi_port(ds, cpu);
 
 	felix_npi_port_init(ocelot, cpu);
 
 	return 0;
 
 out_migrate_fdbs:
-	if (change)
-		dsa_port_walk_fdbs(ds, cpu,
-				   felix_migrate_fdbs_to_tag_8021q_port);
+	dsa_port_walk_fdbs(ds, cpu, felix_migrate_fdbs_to_tag_8021q_port);
 
 	return err;
 }
@@ -638,17 +625,17 @@ static void felix_teardown_tag_npi(struct dsa_switch *ds, int cpu)
 }
 
 static int felix_set_tag_protocol(struct dsa_switch *ds, int cpu,
-				  enum dsa_tag_protocol proto, bool change)
+				  enum dsa_tag_protocol proto)
 {
 	int err;
 
 	switch (proto) {
 	case DSA_TAG_PROTO_SEVILLE:
 	case DSA_TAG_PROTO_OCELOT:
-		err = felix_setup_tag_npi(ds, cpu, change);
+		err = felix_setup_tag_npi(ds, cpu);
 		break;
 	case DSA_TAG_PROTO_OCELOT_8021Q:
-		err = felix_setup_tag_8021q(ds, cpu, change);
+		err = felix_setup_tag_8021q(ds, cpu);
 		break;
 	default:
 		err = -EPROTONOSUPPORT;
@@ -692,9 +679,9 @@ static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
 
 	felix_del_tag_protocol(ds, cpu, old_proto);
 
-	err = felix_set_tag_protocol(ds, cpu, proto, true);
+	err = felix_set_tag_protocol(ds, cpu, proto);
 	if (err) {
-		felix_set_tag_protocol(ds, cpu, old_proto, true);
+		felix_set_tag_protocol(ds, cpu, old_proto);
 		return err;
 	}
 
@@ -1393,7 +1380,7 @@ static int felix_setup(struct dsa_switch *ds)
 		/* The initial tag protocol is NPI which always returns 0, so
 		 * there's no real point in checking for errors.
 		 */
-		felix_set_tag_protocol(ds, dp->index, felix->tag_proto, false);
+		felix_set_tag_protocol(ds, dp->index, felix->tag_proto);
 		break;
 	}
 
-- 
2.25.1

