Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1136051EE8E
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbiEHPb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiEHPbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:31:24 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10053.outbound.protection.outlook.com [40.107.1.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B691BBE
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:27:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIUKQpSBweY6kOEHJeEbI3hzzl+1DPPtUGMGcH2jnUdz8xDUD1j6RHp7nGojwJX+rjX1H6UMDpDIqmvDEOICKkP1LREMrkLwFge152VnOeD1PRcqhk6ZYF41zRSTXV+aIvj0fex/LH2fBUYZqboUvM5VQ0O76JFPwQdRJBjRw0cIhyjo0Awe0O0ToAMOcKuFUuwNKjgBJeJ3yjEPRmHttUbrtzQBZB68Nt45GmH8VgA772jfmtyNNkXD2bTgOS2DUfur+l4rUPZCMT8GRgiWAHf4hPbuEZqDSc31E2rsqHS82AHOWHA3WCSfdUDB2uBg+EwX7cLI8DNnWJsauGDrZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2G+bZVs52Et3I5f9gUzkiliYo4Lm7f7BjiRTUk0ygb4=;
 b=A8cc5yKXoFL3iu8m3jolW9WTW92zpwvmsYvvB8iImCCaXv+V4WXNu33LfMiD327wO8YlzP0u2zyoiCFNFvmpOR7johx/4mfrwSlB5cFX9YGY4f0TZ0xeN3gF8DRscNCYuqiNSoM/a3iu1Aa5HClT+Hc3P43a0RN0F+ASgt1EtVWSUdkUiNQYxKkZndnyWhmacaggRn7mfqIV+RynIlFwbhcDR+PMetgjV6/1jjZF1+zuauTLiJDeJKfWewrEbGKJVg1WRJmd5WYlDxnMhKtIF9uqHVkgT5GR73upTSsbH6iu6HG2L7XHZsyPrF3XQMepnvo3UzqzX2f6Y3Xmr1/Ybg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2G+bZVs52Et3I5f9gUzkiliYo4Lm7f7BjiRTUk0ygb4=;
 b=HlVBVX0E3LSjqIcWh+CeC2EP28Jajr7Vuz0VctjM5CYPTaJ1gHGnSMPyaN+5hSkguMR+y4JkRsLfW+ZMGVdDnvUIXGjjESczOanlUxKRJIsAyWnlNGhQ/tSZBSJ7LfrSboJ1pkLVvhjg3t70kr35MeAlZ2M/PDg/G4etX2ulyGs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2806.eurprd04.prod.outlook.com (2603:10a6:4:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 15:27:30 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Sun, 8 May 2022
 15:27:30 +0000
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
        Linus Walleij <linus.walleij@linaro.org>
Subject: [RFC PATCH net-next 1/8] net: dsa: felix: program host FDB entries towards PGID_CPU for tag_8021q too
Date:   Sun,  8 May 2022 18:27:06 +0300
Message-Id: <20220508152713.2704662-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
References: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0205.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::30) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b5ad26b-d4a8-4654-7579-08da310743c4
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2806:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB280626EC740F97E350ACFDDFE0C79@DB6PR0402MB2806.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vt9cf3R3qXNViIMkd7d1qE/eyISsMQ2EUEct4IQdQsWV4+TTs65t2Qgy+NjgPDceCKNIODZwWryx47436wH0Bsg9ketVlqgUtdFNwn7w9UZzgi1FP41wXbMvRo9E6kaL9Q7oHWvKQ1RQZy69/BuqnNymq1WWaQJAcN9ZbMTvWi2lzmPBCyXJNGOZiXVRywY8vh1biamimydHQtUn9hXSzvscKebjTpP3glb8tQnYsvtcnA9uSRpJhzWsNSOsn0CquZb7C3eAP1UMQS6rLblGdv46NES8rIo/nh7jxyyiyh2RiHh3borkfk4+HuvlEUAyDZroZrMfnxeZFNLvY/8NUmNZ8vhRhvKha6CEUqsdDXj6LHKsOKPmuJAMMKcR+HyhVbbHSbIfKx5XPMIa1DNPB8gfdgfIJ9uxla9FwugjfL8MuOotB37jPDh3CKbMYP/DXrUZI+BKYyx44SG3gRV7/kMICFb9fYvceSuCH5YjSfKidbvwgNNPy/FNuTCuO1wwbxGz0GTRTptmwnNpDJQY/OwFvVdV9Om/eSDNM8SxxiEp/61FzFGPulWUPUH7eTtgGS5NdOuoV7dZ49GT+M+57DGkzR9ULb6ndgTEaErx086tlP26cFq4pDVuN2m1DnWygBKRiLZ5l7/qdCUPTJjaE+b83xk1B0+2LTvUukYTCruFbB/zjE7200Ehu4pwjESenaAu2JsTPK1s7CQ5TkUHww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6666004)(6506007)(36756003)(186003)(508600001)(6486002)(2906002)(38100700002)(38350700002)(5660300002)(6916009)(66946007)(26005)(1076003)(44832011)(7416002)(8936002)(54906003)(66556008)(8676002)(4326008)(83380400001)(86362001)(66476007)(6512007)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8lC8gkNNI1vcScZfmKo+LdiQ/XED00nlIPcn+xx/C36lBbl6gi3jMPX3lsTK?=
 =?us-ascii?Q?kTB2B2FQ1LUueb4ejHZXhDEXj4kMe6E2L37DKQL3LDx5hvCMfHDOET5P9jpI?=
 =?us-ascii?Q?Scd5hIlF7QlfVV+UvL2nRsE8FkufF+GopA9QD9WsTFaBs4egKPGZUkafEnrY?=
 =?us-ascii?Q?mfkd92auPR9kwebUoF0ZylEtKynw6C12nW0oZAuTmE6BFe2C8vEvCBvMh0E+?=
 =?us-ascii?Q?BFnq4cDVhgmZgLmeIQM9gMCbXN6rdLeGCmHeMCRmXqsDUVUacygJ85th7vL/?=
 =?us-ascii?Q?e7SU8H/avdGZAoWxS5c6GzmTaGYOBqS9Lb3RG6CxF0TZLCJqlUbpuKwWTesC?=
 =?us-ascii?Q?JRqGkEd3ZHLJaait9gf5Am9J4KrmNL3pKibsy14RsyDULhEb/Rweonrgsohr?=
 =?us-ascii?Q?Yj6Yp/PwwlmN7GN5smUV/LK+qpBfmT+3tA0k11HFRnoAfiWTuH5pMaY5Hkk4?=
 =?us-ascii?Q?/oqx7564WkYXmUmpgvAiaW/xiMmohd8lzsplq/cVULWHBuNJ790mgOUEgvPa?=
 =?us-ascii?Q?M4jZFscU3bDveCiJoE/JguTI1zYxG1uqLDIa6BHoy9unV88SxrJaulQ/YQ70?=
 =?us-ascii?Q?qI2HJZHtwYyhozbU0ljihz6VHsDcHPxY/4MD5YIWdNM934z13lqYccBWjILG?=
 =?us-ascii?Q?hxGrQwlb0xyg0Lji1tV24lsvYPxsQ8InFss9hXFBVVmiTE+8Uq30KOwm9J+F?=
 =?us-ascii?Q?oH/O6eJgjujpDkjbxzn1e2hTVY2gKcCbnCbpvtZA+1HNDpbjHyQ0b6a3ehBe?=
 =?us-ascii?Q?gXBS+ZWcGj6tGHWjtoah+dENO4Vs8DMzSat6E+0a7fz+GveUB3j6JXxUUKqz?=
 =?us-ascii?Q?kAjU4BGkV3FsVXQ+QiPE5doudqr3I+h3rHhq0a2ZRtF9nwzCxqi/aTVYDScS?=
 =?us-ascii?Q?vtl232d6GIXjdZnhESuCT5YB11UlphYFNSa/WVNdlK1gCtOX4SvtIW/bkdxr?=
 =?us-ascii?Q?yQelKhw7Qi42BvNQzOaHSkbJjYPBXN8ly9I20LYdSZgPxjaCaLO+k0j5Nmtp?=
 =?us-ascii?Q?t5JaVgdiZyxy5uGS/eZUtTU2B/3bIg5Xk5ZMkUS57+t9aej7TE43UpTz7dKt?=
 =?us-ascii?Q?Ye+LyQEMEuaXC2kLF37VVPbuetRk5LTqv7weJPpfzSl15u1B51QbEPcVeI9b?=
 =?us-ascii?Q?eMGvw02BepRMSryruUBxbWE15/6TucCWt0BEHVMs8+mUn2P4qeKk+MNF7KUm?=
 =?us-ascii?Q?IzNnYR1+KKx/nm+i1JBd8VJiItQDCNzsaiHYvdrP4jWfb0sm5DcH45glFpc4?=
 =?us-ascii?Q?+rBX/s8v70JUu0oTts9IwRZ3RYzxiXorvkmJphEm9TkoTUFVwHkH82uthvvd?=
 =?us-ascii?Q?WFYklUsf2ZPbnwynWq5NY3hBEhFlIcFZj7QPpoAe4zSxWAnOVk+a47QEgAG1?=
 =?us-ascii?Q?QgwrDpB/9Hn88wCWZf/XCihBoJzgKUMUtpS+KdEfMSWNcRZr1Sqdn+yqIcRO?=
 =?us-ascii?Q?L+RnpVW8n2szgNGS5wswplt/Okh/qhYFuYjoF6slYaw8081kKk9nFGZojM++?=
 =?us-ascii?Q?b5mjaA9r37U3ozpU9nJMCLE/Zi85e9LQMIr4K3o0ub/k0fzCn2vJHjysCiTm?=
 =?us-ascii?Q?a7xUCovQRwvKYbaDTF19fCRRGYHlMqaDfT+7mWn1P3OLi5Q8cDW/sRZY1D7H?=
 =?us-ascii?Q?hPQsnoKzHIBYZhCqvMp2102pFDe+aO4Bqfvc3sj0nuhnDPuEJReR+5MSRLH1?=
 =?us-ascii?Q?b5eekJGLbfK6Akdv7YwxNwCRGQ1WAKO6xV100k/43KbpFOfcj+QmfcQEOJT+?=
 =?us-ascii?Q?D+gEfbHRYv48SMF6vMAd3QvlkrIYuH0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5ad26b-d4a8-4654-7579-08da310743c4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:27:29.9702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FzJDLbRRfaA4j765sCB9TLRPz6nHnomvnyId0cfn6rNEF1uwcZe2opr5otmwff1gPxdp8h2D6vgmz/Tp9+BLNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I remembered why we had the host FDB migration procedure in place.

It is true that host FDB entry migration can be done by changing the
value of PGID_CPU, but the problem is that only host FDB entries learned
while operating in NPI mode go to PGID_CPU. When the CPU port operates
in tag_8021q mode, the FDB entries are learned towards the unicast PGID
equal to the physical port number of this CPU port, bypassing the
PGID_CPU indirection.

So host FDB entries learned in tag_8021q mode are not migrated any
longer towards the NPI port.

Fix this by extracting the NPI port -> PGID_CPU redirection from the
ocelot switch lib, moving it to the Felix DSA driver, and applying it
for any CPU port regardless of its kind (NPI or tag_8021q).

Fixes: 51349ba7f2f0 ("net: dsa: felix: stop migrating FDBs back and forth on tag proto change")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 12 ++++++++++--
 drivers/net/ethernet/mscc/ocelot.c |  7 +------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e30fdde8d189..d0105a11bc4f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -668,15 +668,19 @@ static int felix_fdb_add(struct dsa_switch *ds, int port,
 			 struct dsa_db db)
 {
 	struct net_device *bridge_dev = felix_classify_db(db);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct ocelot *ocelot = ds->priv;
 
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
-	if (dsa_is_cpu_port(ds, port) && !bridge_dev &&
+	if (dsa_port_is_cpu(dp) && !bridge_dev &&
 	    dsa_fdb_present_in_other_db(ds, port, addr, vid, db))
 		return 0;
 
+	if (dsa_port_is_cpu(dp))
+		port = PGID_CPU;
+
 	return ocelot_fdb_add(ocelot, port, addr, vid, bridge_dev);
 }
 
@@ -685,15 +689,19 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 			 struct dsa_db db)
 {
 	struct net_device *bridge_dev = felix_classify_db(db);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct ocelot *ocelot = ds->priv;
 
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
-	if (dsa_is_cpu_port(ds, port) && !bridge_dev &&
+	if (dsa_port_is_cpu(dp) && !bridge_dev &&
 	    dsa_fdb_present_in_other_db(ds, port, addr, vid, db))
 		return 0;
 
+	if (dsa_port_is_cpu(dp))
+		port = PGID_CPU;
+
 	return ocelot_fdb_del(ocelot, port, addr, vid, bridge_dev);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5f81938c58a9..7a9ee91c8427 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1349,15 +1349,10 @@ EXPORT_SYMBOL(ocelot_drain_cpu_queue);
 int ocelot_fdb_add(struct ocelot *ocelot, int port, const unsigned char *addr,
 		   u16 vid, const struct net_device *bridge)
 {
-	int pgid = port;
-
-	if (port == ocelot->npi)
-		pgid = PGID_CPU;
-
 	if (!vid)
 		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
 
-	return ocelot_mact_learn(ocelot, pgid, addr, vid, ENTRYTYPE_LOCKED);
+	return ocelot_mact_learn(ocelot, port, addr, vid, ENTRYTYPE_LOCKED);
 }
 EXPORT_SYMBOL(ocelot_fdb_add);
 
-- 
2.25.1

