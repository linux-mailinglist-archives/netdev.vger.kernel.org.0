Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862D75ECCAD
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiI0TQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiI0TP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:15:58 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80057.outbound.protection.outlook.com [40.107.8.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788406D9F6
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 12:15:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=daR5lihBwCpkQTOauLLGJJkjBE9GCj3VagLGwGcMmfEHDA7x/Boz8UXCXOi6kOEHdexRK9WT7YvN7KnY1af16XEt7pjcUw7AiAqTG/zGDHi3KIKFa0d4+mL5bXvsHvySLmyvggZ3uGb1XOsvcLDzKlSe197IbWeWlWsDyiAwRyQRpBJSVvj3oID7Z/QaJf4RHnyNYzsIP0a9XKCVF+wiN8DLHIXwuIUfHQqZGErP4Q4oYFoYfrG/ReakfMBozdE5tymhQCUKd+KyhzwcsDoK2aRYAjKZ6rnsMiDbDtBYh95lf60XOp/ST9VXAXijxp1apa0TCkSAjaTfvZNCkVkmFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RRRkS+w6rdw4coL7Fs5EUvCTnlglGOeidu66pGN28Go=;
 b=GK35VOFy5PGCirFa2kRGJlzg/VNixcnDwFyU88+GqKDkMb48bt6HWdk++Q+5JWlsP+FUsPO4fMdLilHn1zk5XX+OjyLalWPS6nYMUa2v5gK8pAmsgkGHIPBeszBZitm5K2ldDpdXm6LcK6Vdea99yjRms++825fM8y8OqADY/EcIqhm4aQxtr0KIaMPFBeqqg2oosTB1mege+tAEme23fmxyg3N9u0OJdTWUAiKKv/B4GR5FSrsKTuAPXPH2rPOvrDpjKx8ZRhheVk6GSeahtT3cM9k93gJ8PZGnn/Oo3ZirsIvBjb3FZdlfpFDgJcC+JjamlcLpvaBHKqRqahm6sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRRkS+w6rdw4coL7Fs5EUvCTnlglGOeidu66pGN28Go=;
 b=ftu0v++Kys7uYIqWJX+f+5oUuSte/0GDuQxpzwXwHYn5dWjvVXeZ8H4GmLxKRi9OAlQb7/Ehc2wYBvsDklV860xPjdvBHPh6kY5eIeDPcIgYAnwD4xvrmSw85PHORy94jguWhV37sEfvVhTqKLMEd/tKOL+RrCpfQ5qldp0VDAY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7029.eurprd04.prod.outlook.com (2603:10a6:20b:118::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 19:15:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 19:15:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net-next 4/5] net: dsa: felix: use DEFINE_RES_MEM_NAMED for resources
Date:   Tue, 27 Sep 2022 22:15:19 +0300
Message-Id: <20220927191521.1578084-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
References: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0287.eurprd07.prod.outlook.com
 (2603:10a6:800:130::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: f290a347-b888-44c9-485e-08daa0bca8a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2edmb9HzFxPqw9G0KiytZOcNDksmGWuycN2TAeTgHijr3WMpNjTxiK8sbckHxPD8E89iqKdEFqyy7p0x+KVwSQ18zg6JyxLFoEF22jjiMRBFpyerf+jtjKYNNySg52qdRjTc08tPdhBVIgpLTa5Nztoo5niUbTxG0miPY6IHPnHYxGZoXjYPnnMZSR9kQtAf4kq43cXgSXCU0g3u2E28BOxPG7eRUEDi8mtt6Uk5bMf9FudQ0n54fwxWv/7CCXTiYukZC4TWgv9jCEG4ogktKJ+24s2+VpIIMXwomYtt25C6jk9xxVzQp6US2ODMWDWc7vR1x9i4t/m09/pPH4v5ArRg2ldJu4AjRKKQWvF5vkR3d2MQ+HXmUHToQJ362y2pZysRpn0cM9xrxIJOfcbSFqXCqe0HHvNvrUSYQ7mQv7uUyxmMR50ZcNGUNwXNWJ9rRY2PX6PIYrTTkOOOYYZZ2Rj7dmD1xDBNBuiUygsBb+tbAmOtjh0DM8YXNELuUyt89hJczt/f4vXsOGtDZMiaTBE1Ybnrh6sBnyvUSG+fGI+KTcbn0iqDGnXziZE3NfpMqf2ESDiwrJkJVDB25FSPULDK2uZ6TlIMYEqqJv1rR5w5yfmqgOmK2MCy4ETfGCTVA5qdf02dpk8zN46Sd2IxgW/SHRVpCfUCsX3mE2RW/wuP9mWaf58zeNWCBLT9s0QICFldxMCzaflDsyq7WVcS/McXh81Lo/8dqtYlLF+sHvntUS91mVvO4B7jVZ5q5pPBLI+BQyw0gPQ5u5Q3IiA3mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(86362001)(38100700002)(38350700002)(36756003)(2906002)(44832011)(2616005)(6506007)(478600001)(6486002)(6666004)(186003)(83380400001)(52116002)(26005)(1076003)(6512007)(54906003)(7416002)(8936002)(316002)(8676002)(6916009)(66476007)(66946007)(5660300002)(4326008)(41300700001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MEon/pxLAK0ueDrPimQ26JyNqWG04zIssHHR7s1MpjTKBWyBDeI713z5S+HC?=
 =?us-ascii?Q?7n7zC6XGaTFyZqDQD8jZTMkeihbVC9an/NSup3MlusroTFWMnLa0NhTJW1Kr?=
 =?us-ascii?Q?9APiJmFJcNEYW+rn7nsXdBvYdRsKVV7+tUlcI6GS7xxk1p7hm18Gnkf4KeWI?=
 =?us-ascii?Q?z2saqyrtHPQbKyW1HWcuqyb4OygR/0BFdjkjPRMgnyBSQDjTG6ESj5LHbLeL?=
 =?us-ascii?Q?2VBPKjKBC0EWEo55Bg/Mc4cInTTKAWyeLKcggDtjbp0Juep9lrsiWSgIQPef?=
 =?us-ascii?Q?9gFCuwJNPfkoNyhBXEFbhek/2F3Vt/SBoClgblg+hoPLGag8EK2gbsTLur8C?=
 =?us-ascii?Q?d+EF5FEs7yxvsmQPT2RtJVF4pqX8dXzs2VZuWKibP1EWR5SiGBex2JY0aNQp?=
 =?us-ascii?Q?ZBpmpOrIg+XSxYVB6xG4tpUqO2S15yQMzjE18rUnq9qnpdhi8+8sQe990IKU?=
 =?us-ascii?Q?YRODwP0tPG0GOIcJ5XQo4qbp8NhRB7ZLpnHigNzeTDszObcU5fOpWwHim+9W?=
 =?us-ascii?Q?OkKlNREyF/mi2zUb1sx0w0HaTmBtmaMOFa47lVWYwiUWJGdp8CCA+N9g5yXC?=
 =?us-ascii?Q?QuKixcIpLvwGv8m8lswKjIiN0XRYD3j9JBcoPLpgU2AeVRlUlBfn5mMRwjkf?=
 =?us-ascii?Q?aU4007XMvA1pMQW4yYkphsW/8aeqkSy5bAbgSm3gsYkTuWO18LFxsH9agqc7?=
 =?us-ascii?Q?378o3IDR7W73oi3iB+i22XNIwE5Y+xR5O6xqKKuhCFEQm8avswKgitkFwuCJ?=
 =?us-ascii?Q?7QNtAMCkWvN0zOd422tY+D6d8fUgIdfzVXjihLfNn3ouSYlfq2KS9QSvIJSt?=
 =?us-ascii?Q?WdpjsCrAl1pjsFGxsU/Bnngejrc6Xue2mNgVLageMVZXxzrOILqisIwOpTbr?=
 =?us-ascii?Q?Hbe+Yy/GwBySxKfl5WdBy7YN6F+qgBZ5KojWzS934ohk2K/Kr1xz7eWcPVjw?=
 =?us-ascii?Q?paIBbRe9pFmOzAvK14E3foLpm52pZlOcDtxa2Eu20xYzFhr4mk2X+azGhIv1?=
 =?us-ascii?Q?z4WofpvJXqQ8QLpWfWbd053OQviuZEMSG62VC/4mllE/bFgtyTvJoKMiGYY/?=
 =?us-ascii?Q?NeNMmAzDJNismRvtxrxi9RDrQfiikPu+P6SOa86pTpIZ8Z+Re0uWvL1hWhkD?=
 =?us-ascii?Q?Hu32zXos+n/UHnj82VLgc+pfypHuYzb1304u1vwuGzsZ03Fp5mh67Ipxn32r?=
 =?us-ascii?Q?xAKZC3f9fL9Qqrcb7cItK6+3NGCvWAR5VhWqncWlz2tZjngstqm5mUpXJhsT?=
 =?us-ascii?Q?CPz8xfMPXUlzk6Xp5E51HOS35tIhY9vVCmxZlyd0/30dDLafqaMeUt6fN9XC?=
 =?us-ascii?Q?Kaqc3DRZhbywA+Zw+CWb2uUzxM1u6dES/Ftp5TRRKez+dnVEKxVGlISJpGbX?=
 =?us-ascii?Q?bQMmMsCxiPdc7XIJynmy+sybx/uSRyTh3a9Xm/Fp45erW+OhP+JJqN/X21r0?=
 =?us-ascii?Q?svwIavFMRRaRXVzDeGlI52De/aQiGEth9aIxSe+eXZNArcv/wvhgahN51t+U?=
 =?us-ascii?Q?I+wWCRbrN5Q6wMsCGGSTqhoc3A29YzPM8y0iBpkjdr3+BfhUVrdyy6fxv0FL?=
 =?us-ascii?Q?EEr+7AQ6ZGIkYMmyExyzGrANSdTgerBT6Hk+8cNUn7nabC73NOwL6p1NKzEi?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f290a347-b888-44c9-485e-08daa0bca8a5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 19:15:37.2390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MDLHqr99uSzrkPZlmcJ5z46mX7jsLTr8Uj5y9oqn9IU32aeHzH/XAn78UOL6AfSuQCF0OLQo0EA9rAVktm1vDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7029
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use less verbose resource definitions in vsc9959 and vsc9953. This also
sets IORESOURCE_MEM in the constant array of resources, so we don't have
to do this from felix_init_structs() - in fact, in the future, we may
even support IORESOURCE_REG resources.

Note that this macro takes start and length as argument, and we had
start and end before. So transform end into length.

While at it, sort the resources according to their offset.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           |   2 -
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 104 ++++----------------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 120 ++++-------------------
 3 files changed, 38 insertions(+), 188 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index b7a66c151be3..6a7643c31c46 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1356,7 +1356,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 			continue;
 
 		memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
-		res.flags = IORESOURCE_MEM;
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
@@ -1393,7 +1392,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		}
 
 		memcpy(&res, &felix->info->port_io_res[port], sizeof(res));
-		res.flags = IORESOURCE_MEM;
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index e465e3f85467..1872727e80df 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -478,99 +478,32 @@ static const u32 *vsc9959_regmap[TARGET_MAX] = {
 
 /* Addresses are relative to the PCI device's base address */
 static const struct resource vsc9959_target_io_res[TARGET_MAX] = {
-	[ANA] = {
-		.start	= 0x0280000,
-		.end	= 0x028ffff,
-		.name	= "ana",
-	},
-	[QS] = {
-		.start	= 0x0080000,
-		.end	= 0x00800ff,
-		.name	= "qs",
-	},
-	[QSYS] = {
-		.start	= 0x0200000,
-		.end	= 0x021ffff,
-		.name	= "qsys",
-	},
-	[REW] = {
-		.start	= 0x0030000,
-		.end	= 0x003ffff,
-		.name	= "rew",
-	},
-	[SYS] = {
-		.start	= 0x0010000,
-		.end	= 0x001ffff,
-		.name	= "sys",
-	},
-	[S0] = {
-		.start	= 0x0040000,
-		.end	= 0x00403ff,
-		.name	= "s0",
-	},
-	[S1] = {
-		.start	= 0x0050000,
-		.end	= 0x00503ff,
-		.name	= "s1",
-	},
-	[S2] = {
-		.start	= 0x0060000,
-		.end	= 0x00603ff,
-		.name	= "s2",
-	},
-	[PTP] = {
-		.start	= 0x0090000,
-		.end	= 0x00900cb,
-		.name	= "ptp",
-	},
-	[GCB] = {
-		.start	= 0x0070000,
-		.end	= 0x00701ff,
-		.name	= "devcpu_gcb",
-	},
+	[SYS]  = DEFINE_RES_MEM_NAMED(0x0010000, 0x0010000, "sys"),
+	[REW]  = DEFINE_RES_MEM_NAMED(0x0030000, 0x0010000, "rew"),
+	[S0]   = DEFINE_RES_MEM_NAMED(0x0040000, 0x0000400, "s0"),
+	[S1]   = DEFINE_RES_MEM_NAMED(0x0050000, 0x0000400, "s1"),
+	[S2]   = DEFINE_RES_MEM_NAMED(0x0060000, 0x0000400, "s2"),
+	[GCB]  = DEFINE_RES_MEM_NAMED(0x0070000, 0x0000200, "devcpu_gcb"),
+	[QS]   = DEFINE_RES_MEM_NAMED(0x0080000, 0x0000100, "qs"),
+	[PTP]  = DEFINE_RES_MEM_NAMED(0x0090000, 0x00000cc, "ptp"),
+	[QSYS] = DEFINE_RES_MEM_NAMED(0x0200000, 0x0020000, "qsys"),
+	[ANA]  = DEFINE_RES_MEM_NAMED(0x0280000, 0x0010000, "ana"),
 };
 
 static const struct resource vsc9959_port_io_res[] = {
-	{
-		.start	= 0x0100000,
-		.end	= 0x010ffff,
-		.name	= "port0",
-	},
-	{
-		.start	= 0x0110000,
-		.end	= 0x011ffff,
-		.name	= "port1",
-	},
-	{
-		.start	= 0x0120000,
-		.end	= 0x012ffff,
-		.name	= "port2",
-	},
-	{
-		.start	= 0x0130000,
-		.end	= 0x013ffff,
-		.name	= "port3",
-	},
-	{
-		.start	= 0x0140000,
-		.end	= 0x014ffff,
-		.name	= "port4",
-	},
-	{
-		.start	= 0x0150000,
-		.end	= 0x015ffff,
-		.name	= "port5",
-	},
+	DEFINE_RES_MEM_NAMED(0x0100000, 0x0010000, "port0"),
+	DEFINE_RES_MEM_NAMED(0x0110000, 0x0010000, "port1"),
+	DEFINE_RES_MEM_NAMED(0x0120000, 0x0010000, "port2"),
+	DEFINE_RES_MEM_NAMED(0x0130000, 0x0010000, "port3"),
+	DEFINE_RES_MEM_NAMED(0x0140000, 0x0010000, "port4"),
+	DEFINE_RES_MEM_NAMED(0x0150000, 0x0010000, "port5"),
 };
 
 /* Port MAC 0 Internal MDIO bus through which the SerDes acting as an
  * SGMII/QSGMII MAC PCS can be found.
  */
-static const struct resource vsc9959_imdio_res = {
-	.start		= 0x8030,
-	.end		= 0x8040,
-	.name		= "imdio",
-};
+static const struct resource vsc9959_imdio_res =
+	DEFINE_RES_MEM_NAMED(0x8030, 0x8040, "imdio");
 
 static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 6, 6),
@@ -1026,7 +959,6 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	imdio_base = pci_resource_start(pdev, VSC9959_IMDIO_PCI_BAR);
 
 	memcpy(&res, &vsc9959_imdio_res, sizeof(res));
-	res.flags = IORESOURCE_MEM;
 	res.start += imdio_base;
 	res.end += imdio_base;
 
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index e807db0dea98..66237c4385ac 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -459,109 +459,29 @@ static const u32 *vsc9953_regmap[TARGET_MAX] = {
 
 /* Addresses are relative to the device's base address */
 static const struct resource vsc9953_target_io_res[TARGET_MAX] = {
-	[ANA] = {
-		.start	= 0x0280000,
-		.end	= 0x028ffff,
-		.name	= "ana",
-	},
-	[QS] = {
-		.start	= 0x0080000,
-		.end	= 0x00800ff,
-		.name	= "qs",
-	},
-	[QSYS] = {
-		.start	= 0x0200000,
-		.end	= 0x021ffff,
-		.name	= "qsys",
-	},
-	[REW] = {
-		.start	= 0x0030000,
-		.end	= 0x003ffff,
-		.name	= "rew",
-	},
-	[SYS] = {
-		.start	= 0x0010000,
-		.end	= 0x001ffff,
-		.name	= "sys",
-	},
-	[S0] = {
-		.start	= 0x0040000,
-		.end	= 0x00403ff,
-		.name	= "s0",
-	},
-	[S1] = {
-		.start	= 0x0050000,
-		.end	= 0x00503ff,
-		.name	= "s1",
-	},
-	[S2] = {
-		.start	= 0x0060000,
-		.end	= 0x00603ff,
-		.name	= "s2",
-	},
-	[PTP] = {
-		.start	= 0x0090000,
-		.end	= 0x00900cb,
-		.name	= "ptp",
-	},
-	[GCB] = {
-		.start	= 0x0070000,
-		.end	= 0x00701ff,
-		.name	= "devcpu_gcb",
-	},
+	[SYS]  = DEFINE_RES_MEM_NAMED(0x0010000, 0x0010000, "sys"),
+	[REW]  = DEFINE_RES_MEM_NAMED(0x0030000, 0x0010000, "rew"),
+	[S0]   = DEFINE_RES_MEM_NAMED(0x0040000, 0x0000400, "s0"),
+	[S1]   = DEFINE_RES_MEM_NAMED(0x0050000, 0x0000400, "s1"),
+	[S2]   = DEFINE_RES_MEM_NAMED(0x0060000, 0x0000400, "s2"),
+	[GCB]  = DEFINE_RES_MEM_NAMED(0x0070000, 0x0000200, "devcpu_gcb"),
+	[QS]   = DEFINE_RES_MEM_NAMED(0x0080000, 0x0000100, "qs"),
+	[PTP]  = DEFINE_RES_MEM_NAMED(0x0090000, 0x00000cc, "ptp"),
+	[QSYS] = DEFINE_RES_MEM_NAMED(0x0200000, 0x0020000, "qsys"),
+	[ANA]  = DEFINE_RES_MEM_NAMED(0x0280000, 0x0010000, "ana"),
 };
 
 static const struct resource vsc9953_port_io_res[] = {
-	{
-		.start	= 0x0100000,
-		.end	= 0x010ffff,
-		.name	= "port0",
-	},
-	{
-		.start	= 0x0110000,
-		.end	= 0x011ffff,
-		.name	= "port1",
-	},
-	{
-		.start	= 0x0120000,
-		.end	= 0x012ffff,
-		.name	= "port2",
-	},
-	{
-		.start	= 0x0130000,
-		.end	= 0x013ffff,
-		.name	= "port3",
-	},
-	{
-		.start	= 0x0140000,
-		.end	= 0x014ffff,
-		.name	= "port4",
-	},
-	{
-		.start	= 0x0150000,
-		.end	= 0x015ffff,
-		.name	= "port5",
-	},
-	{
-		.start	= 0x0160000,
-		.end	= 0x016ffff,
-		.name	= "port6",
-	},
-	{
-		.start	= 0x0170000,
-		.end	= 0x017ffff,
-		.name	= "port7",
-	},
-	{
-		.start	= 0x0180000,
-		.end	= 0x018ffff,
-		.name	= "port8",
-	},
-	{
-		.start	= 0x0190000,
-		.end	= 0x019ffff,
-		.name	= "port9",
-	},
+	DEFINE_RES_MEM_NAMED(0x0100000, 0x0010000, "port0"),
+	DEFINE_RES_MEM_NAMED(0x0110000, 0x0010000, "port1"),
+	DEFINE_RES_MEM_NAMED(0x0120000, 0x0010000, "port2"),
+	DEFINE_RES_MEM_NAMED(0x0130000, 0x0010000, "port3"),
+	DEFINE_RES_MEM_NAMED(0x0140000, 0x0010000, "port4"),
+	DEFINE_RES_MEM_NAMED(0x0150000, 0x0010000, "port5"),
+	DEFINE_RES_MEM_NAMED(0x0160000, 0x0010000, "port6"),
+	DEFINE_RES_MEM_NAMED(0x0170000, 0x0010000, "port7"),
+	DEFINE_RES_MEM_NAMED(0x0180000, 0x0010000, "port8"),
+	DEFINE_RES_MEM_NAMED(0x0190000, 0x0010000, "port9"),
 };
 
 static const struct reg_field vsc9953_regfields[REGFIELD_MAX] = {
-- 
2.34.1

