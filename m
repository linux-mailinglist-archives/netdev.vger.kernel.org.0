Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63002522FE0
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbiEKJuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbiEKJuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:50:39 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20077.outbound.protection.outlook.com [40.107.2.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3D154004
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:50:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5K+CGze+xTGIBbIC539fUV7IKyGdXuCWmwSlBY4+IBJnwS5sUqBQGut4SWKoX8FhEjAWecMxEcd8rKAlB5pTGNeOnz1e7xSRLXWEIoW6PzfTqbTbqKh3rxHxgosAEac8Fldic8ANuOXCHyyFXxJ9t1Z/QdZOr8IzIGmIdti45pB8VkDvlBecByiAZ/ZdDR9fYCodrg756ahAKrJ02wi4juS6GEZdrwsc4whxVcHYLCnK6eL5VCDvvoAGr+P+PCmjoDnPO9cZMnRhEbBNzMkwDalIpHXrJT8lgPlX0ZnE4Uaa9Pg/M6jj2NLBaJ/1Jtyt0b3sN//2df7IoZogHRQ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irWVgOG0NwOYjjtKdRxvRVXxcmvd1vozq+NbJxq3DJU=;
 b=Z0iZkxwJ+sOW1cQ82R//4TCodzq5vdVoRO+FhlPXJxAnJK477HZQsMATjkM1Knv3AqiJFxDAAyrkcotbMaKnbFbdNhBSK9zzxrkrqvGhhsRvn0S9jTZVidRMNE3yR7wsZIomx0rY+20CpPyakCSsZWpyRrCwpBBF2YoyNzyzFlY1V5FddFk5BAnqLyfq7mDOtpP50itMVls1YpKAeqphr7spmeLNo+6tXi+z1FP0uuP71syi2VGOHHwiHkRaTe03fhIKHiq3uiZgTK5IPVP+nfUTTun2UxKUKO6MGHiR1jZCuRTHhN5zFQ1lqm7EFcgsp12QAYxas5ftLit8h5cRlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irWVgOG0NwOYjjtKdRxvRVXxcmvd1vozq+NbJxq3DJU=;
 b=QfR88wh/Fv2XSJUwK0gQscEp6Is36Up8I3nz1j2Fj4NTYAWuqEx/DF7Amlxk5hbyZqR36u2SndRXxZ46cQ//vf87l4hejKqPvs3Bcb5CfKnFkvrMVvv+2uxMZkek2awdXjAP2u4YStNCpGU36lnh5ISqmbGVHyJ+fgwZeNbTDp4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9155.eurprd04.prod.outlook.com (2603:10a6:102:22e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Wed, 11 May
 2022 09:50:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 09:50:36 +0000
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
Subject: [PATCH v2 net-next 2/8] net: dsa: felix: bring the NPI port indirection for host MDBs to surface
Date:   Wed, 11 May 2022 12:50:14 +0300
Message-Id: <20220511095020.562461-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: f9694d03-fbfb-4c69-ab28-08da3333b2d7
X-MS-TrafficTypeDiagnostic: PAXPR04MB9155:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9155A51FD1D11D4E39AE95BAE0C89@PAXPR04MB9155.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tjs1JH44/1e7uVXLxpQa8+qA4fZPWrKwimp/EnkjnOLSLkFIcqAvp79/eURqz/UlEEsS7HnBz7OLnnkr3BKy4fl3dsVSHA5+0dUjteH6iN4V82zCBHkQiKBel0+iCzs1VXBhTQ/9Uo9k8pmwjAVjKj4CDz+7fIqkoxcM90cxTTKOJE9egL6rRHy4hOciXKMt07rcl4/GRc9zgasvTnbemL3uR0ELReH2ptHGwC4KXf2mpCgi68NORLTTPQOEueC0fPokaEwzSvPqB51qQPw3edVgjuVp2SSoORNzg07EZRyx9D0u/noDKzxjeUGBHiYp4hLIOtU7vQRM4ZlZobZePNU7j5pUdm3oryFNCuKghsA4inVU3D4QVlVyWuiOQkEQ8fg5MMKsLmKpjuxDfcRVT2G/aUgrQQAOwYhB9NUgxRnBwLqXEq7cweTZLVUlMrtZymq1Sk2Bw9nIx9NSuGNdS+AY1P9syisIuxmwmParMi0y7/NsNpejjMwwOYwSVSDWlvcc5n/6ZSa1814glXEJNn4UDtv85ilynkfpSazesCDm7b1RMNSi9/lzs/FPc4MQkwU3yUeu96/oqjYCBD2+uttaOIfX1g27oJD4xMFggAFbWKgCdlGiZLuRwU9w6gGxJ8zB71cytrDBK6Hm6GGcTroRtMbIuUcizLPXPwuQFSwtaq1Va+TyU9sA63KGtIxuzCh6W5XBodvIMLcTThvx0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(186003)(38100700002)(38350700002)(1076003)(7416002)(2906002)(44832011)(5660300002)(8936002)(36756003)(2616005)(8676002)(6506007)(6666004)(66556008)(66946007)(54906003)(4326008)(66476007)(6916009)(52116002)(316002)(26005)(6512007)(6486002)(508600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fo0wsLDKarnEudleD8KZHXmxOu2CFJl08v3AVm01yZWZLdjt6kcbK+mumNrl?=
 =?us-ascii?Q?s5OA8xrf73Hpba8fSnBlBm1yTyI7uVzIPlAgZZ4pWOYUt399cPLXNxO6ftnu?=
 =?us-ascii?Q?H/oGERYkjdMWMSBGiIy3s/Z9CILQ5OoWlGSBTwOIkcDUR9lfHhdeeWvNSQFl?=
 =?us-ascii?Q?ir4BOSjtn48rsG9EBKdxEjwp1o0YcLYHBSJJ6l1bHm6UMcHb3IgCntnHhunH?=
 =?us-ascii?Q?xCIVsBc958jmThZlaul210GSodnXz3oqYLF8cr0FE+yBt3p8kkCd3y6tmp3k?=
 =?us-ascii?Q?dlrpac33gmKtpHTTSa3QCk46QPfgBFZf2RkaR+1qlwV/acP9rYaw+S0zB0kx?=
 =?us-ascii?Q?RJX6OFlZpA1RRZc29wlyreX26seYFWfYj9kmPZzyN7edg/YuA9g+Kx6raeCY?=
 =?us-ascii?Q?hkpalRd0/8wZ6B2NIQK1Ic3N948eyAZG58Wbi+DzqWWl0RJvIkZR1by81494?=
 =?us-ascii?Q?V1m52l4fFAvNk9dpt0vq1JZaozBAsz7+0JlxXHLiUC/VPnw38kHGwJgG6o21?=
 =?us-ascii?Q?xvwaNFPTpwEWJZXlns8AXm5yuqJGnpOZmI8PXSnBVTNKRWPbcUg9eUR8jCv9?=
 =?us-ascii?Q?0pw6SJtclGG4Q9Ihhgh+Mk0E97QtD/FqpWK75hIrMQ/xEt0iB6NNcxG3R2S+?=
 =?us-ascii?Q?VH3Up5bpzStvlMA3muN6kMsSlbnsxzF5sF+1OgOi9XmjRkJme+7VzvLICXir?=
 =?us-ascii?Q?ATlOFM6AUDZtZkP1JPM9zH7slO8XYNWz/pmYplI/gDgDcZ9lfSyZyeqUJcXn?=
 =?us-ascii?Q?6WS9TFx9OO5l5Z+f+btJBpAAbJ8ZoJT30+Ey6TEPpNXFq4qRCjfTCmh+56pE?=
 =?us-ascii?Q?xoBEqdwBdqhL0at3qa2q5dTJQiKp12mJUdoYbSDQsdGpSaArw7lvw69Dczso?=
 =?us-ascii?Q?V7kSFQzTrQEk/ncGu2DmH+eGAwTmCaVKuYFGALATY7UlPhKBlvfYhNYbZKpN?=
 =?us-ascii?Q?noAtYm3kbtiWIgTRm/2uYo+St26Peef5N0oDo+m1t4DKcg+g5gNuxX+vDbCH?=
 =?us-ascii?Q?kMJtoJtk869koWSBeGGWH+/VifDkTnWYXzx5IVdTqzMMPdBDEiXCRjMFv1/0?=
 =?us-ascii?Q?9IFXr9QRon5t1lQkhD0kjtqhKV+68nfx7UtYEnEUrRVoJ2pcCq4absCdVkmV?=
 =?us-ascii?Q?Lg41LvOBSlcnJXVxYBeYRQivkQ2Sj2wlo4P/n8Bx8L0aHRWOPwZfK4B+8+Ku?=
 =?us-ascii?Q?pgHeJKyfVcAiaXqD475gLGm4Nw1FjlW4ymp497LOOExv3t6ZhsEC/72ay9tq?=
 =?us-ascii?Q?DuURhTeMxJqyBQbM2kOrbHpBbFe/kyFojL2WKTfHVLUcGU0W2DsL8VBul2T9?=
 =?us-ascii?Q?Kjouqe7GzsVyJ755Df7zMT+1bVV6aq5y7hPTTa5DwWE8PsbkcXAkwN3kheTI?=
 =?us-ascii?Q?+yc5wsyWvXJ8PEjV54ZIKvDjGYPAkXcURfd3LAMf5Ocl+JhhdfLXfDuhY5Y+?=
 =?us-ascii?Q?jFLBsvmUqC6s2QlpgyX0Jj9smLuNEdwG13UUF58pBwAyt8YbYtvbV+MQVOrL?=
 =?us-ascii?Q?ilP4EoLARU4Jrut74Etwm8fTq9vohK1TPj4CCfvrs9ZpcqV99S1K3DQ6SM7V?=
 =?us-ascii?Q?ikGV5CX5nqip1cIwwVYn5+5J7mImv0q6lDGUPyV+JMQAVYPWk3gfrJAg9Qm1?=
 =?us-ascii?Q?0etJZMTMshGILO8p+o+34qDVwNjTy4BmyYfBuHn/QQyn98G6SrrD9nc4CSsb?=
 =?us-ascii?Q?ZMIdbGnZOVR4tVFDZYtXf883EeB5MQHW4rwRObB2i0nekXLr7KL0sinMX/1U?=
 =?us-ascii?Q?Wo/YiWYCwlXqdxNnLonn8Pfqu5vuK7M=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9694d03-fbfb-4c69-ab28-08da3333b2d7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:50:36.4736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n79ePPxaK1+2Y9gu15vBlWnSJLsReog5ZvioTUJkGNHRv+9dOeOpTMRMogpvvv3yzS3O6XrLZYyK/XKcEuKwoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9155
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For symmetry with host FDBs where the indirection is now handled outside
the ocelot switch lib, do the same for host MDB entries. The only caller
of the ocelot switch lib which uses the NPI port is the Felix DSA driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix.c     | 6 ++++++
 drivers/net/ethernet/mscc/ocelot.c | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 5af4f9b3ee32..f8a587ae9c6b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -745,6 +745,9 @@ static int felix_mdb_add(struct dsa_switch *ds, int port,
 	    dsa_mdb_present_in_other_db(ds, port, mdb, db))
 		return 0;
 
+	if (port == ocelot->npi)
+		port = ocelot->num_phys_ports;
+
 	return ocelot_port_mdb_add(ocelot, port, mdb, bridge_dev);
 }
 
@@ -762,6 +765,9 @@ static int felix_mdb_del(struct dsa_switch *ds, int port,
 	    dsa_mdb_present_in_other_db(ds, port, mdb, db))
 		return 0;
 
+	if (port == ocelot->npi)
+		port = ocelot->num_phys_ports;
+
 	return ocelot_port_mdb_del(ocelot, port, mdb, bridge_dev);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7a9ee91c8427..29e8011e4a91 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2339,9 +2339,6 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 	struct ocelot_pgid *pgid;
 	u16 vid = mdb->vid;
 
-	if (port == ocelot->npi)
-		port = ocelot->num_phys_ports;
-
 	if (!vid)
 		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
 
@@ -2399,9 +2396,6 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 	struct ocelot_pgid *pgid;
 	u16 vid = mdb->vid;
 
-	if (port == ocelot->npi)
-		port = ocelot->num_phys_ports;
-
 	if (!vid)
 		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
 
-- 
2.25.1

