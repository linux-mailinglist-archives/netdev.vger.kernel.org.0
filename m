Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4AF69A2FD
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 01:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjBQAjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 19:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjBQAjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 19:39:02 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2070.outbound.protection.outlook.com [40.107.247.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9745E53829
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 16:39:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kr1SYTvbZdEor0B2gB8Qpevvn1kA0+++j8IqlFK9s9ckWpuYusyo+jXyFfPYnfxKnQksof1WQLzltBNa8K8W0ZUiAX7W4Hl0/W3HnjG3BSixb+gF6oQPtyrsItD5MxhX0iMyatFtBsZmY232oD3rjixYo/7LIddk3ukzGvhsNXyJNF2yBgB5jFZGCuKMMYuvpQjH8B4fMGMWpMQCVj7xiz7DzzdGWQlASlagLrVaCa5ntq0C+aeuAE3M5fQ7EXlVRQxd53sKa9HNEEmF+mv2EjNm/V5U77fgcEgYl71zjM7g3wwZrGj/nuKjBcDSpdSq7HeX36qiR+puC6NlWtfBPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LiTqX3ZOlJZU3/jRCEI6Iw59asdq79jRvC3jUtVeEUw=;
 b=LJJL4cJrQTFH0DFaLy9OUPMsnEAw/DHZln1v9HByHmQkMAFHPj3s+G/S2X928EY6H74csHVZ6gAYE0GhbCr6GH2xvADEiO4Cnn/t3bsDV7AlIF/lCoBhA7UllteREUHqe4jv5MbP4kV/nlSdrsBnNWqYS8yF4yM4rPO3xUiI4gzof5RGHM3cOQsohDopVG5UKm/bice+CpM79k/d0HFeHfdtisutBcxSgUr8wgJp0gVMav0zjY5xGDwx/JDqPBf5oQX05FOI4MQMWzRc/PBdXIM0NuhxgdoStql10S96RbRYP1ABDmxRAXgczxbLZuhvqbgyL21AyvZSrhaGZHnWvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiTqX3ZOlJZU3/jRCEI6Iw59asdq79jRvC3jUtVeEUw=;
 b=KoCgsmNLOyjTjUmMH0vm21zVZpE8HQoieymzPdu684SeG/VabZKP2qBC3vhOWdvLr7BJ+BzdQLN+ZUym0Ntgs8RwOX0jVxl3RqZc7WQ9fHq0VVveq4ujeP31/CThJkVMAWSw+IUpG9M6hERei4ks32j2oxIW+zgkbtnFunwSiNo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8562.eurprd04.prod.outlook.com (2603:10a6:20b:421::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Fri, 17 Feb
 2023 00:38:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 00:38:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH net-next] net: mscc: ocelot: fix duplicate driver name error
Date:   Fri, 17 Feb 2023 02:38:45 +0200
Message-Id: <20230217003845.3424338-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0035.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8562:EE_
X-MS-Office365-Filtering-Correlation-Id: 71638622-5a24-4726-a4c0-08db107f5af1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 246HCYav4Hzrkyb63DCBc41XFszUZU9RPRIFLFwBHDBQ/nC9Z9ijB+mzeQBS1CqyJhLiSwQwWhN42JjbLGAV43BxfYur17el/SEC2UtpJF+qWWDKNFwVpC62DAO1qDbTkN9H7Bv5F3I45BoRFXM8Q+oWFzxYoAUZLVR6sfHJZuDMg8K79SZnso9B1H7IN+qohSrhD3L2tH5m9I+s4fAGfR1FiKBnl4ChBeVdSVuSEzaKRx4bEjJUqtKcaIgWiTS2hgbBvZpq59JJBhc+i/Ram4+cdBgOiGHRAJx4NeZeGA7M6LQ0LkA7NI/5oWfj6VwiG12z0C/81Glm56PaLxMuLoLGAxCp5dnGpV8863Z3Wd6zcA+rVJWGlDt4BMg95IgQhHqu0+QoASiQ6fFaGneI2+6CT+VuBXLj/cDaqPxYCMyoH3MGMuJLD0F9CntFJkgi5ZZoqb2EhU+OgezevqyiMM7ezbRkUV4+RtHuFWvmp3Wex64opoUvRBCzXAVwc0hBwqYD4inCDSWUNO7U1bY3CSXhzSrZ+L6cYPVA4vOOn+n/uy7a4vJ1aM5eg/uOUexi3jLROqrVD4G0H8ln2+Y9CY2Z2EQph8WgqIlpZyi655j8OAAKJYRxnBzhaY9Nv1YYMTHOItEaUy/CdXVl6Ci3JeUUND3mIAUusxh1p5PMW82XVe7DT0Er6IgnRHKFNeSgRU2HP4bBFesKMVyaXwrJXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199018)(6486002)(52116002)(478600001)(83380400001)(86362001)(38100700002)(38350700002)(6506007)(26005)(6512007)(186003)(6666004)(36756003)(8936002)(41300700001)(2906002)(2616005)(5660300002)(7416002)(44832011)(1076003)(4326008)(8676002)(6916009)(54906003)(66476007)(66946007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yEz1c/NmO07UAplEy4Dlit0GRVtKLkgMvhk0yJYERu0tvLmsbhANnNsb3Cxs?=
 =?us-ascii?Q?zQs5y2NcIrjp3SKlfpAFjylquuzNecKJFeTw4FAZL2bNFFwTpegnTkCDZCSn?=
 =?us-ascii?Q?3lttmMBwaegM1/Kn/0rtZML3b1OOAN65vMvjN9elDXMiC4jtxlZIMltEoTAc?=
 =?us-ascii?Q?t5wnIo4ys3knp7YeotpgPD44JIgBv9aOgKvhbU8BrDmw5Im14O2uydboIaKr?=
 =?us-ascii?Q?2CVBMTf7NwNknWkKUsOx6lPfhhF1gc2/pEvQ6r0UOvz+7AwrSTH1sS2rd4WE?=
 =?us-ascii?Q?i5kpDfnHYf6uj99hbkXaqwUtJQIolaro1BGOubHjR+CqpYLkMk0K4BLdGg1R?=
 =?us-ascii?Q?KTY5me8y2DBOgTlUhmsE+6DkZFX8Q5kFzebRUTfSH+ZJQCWrUbgV7R+V0qI8?=
 =?us-ascii?Q?gtkHGzZjvI3RxNwMEx6HRB6oSvxwmzjOE5z4iGcRAerPyowwWnbyCgy+2aVD?=
 =?us-ascii?Q?LlLDxJr6Zlfm1v9OdP9oure4jOOacdgxMfSkSv0IYT6UOiIRYZoFS5u5f3Kx?=
 =?us-ascii?Q?Zr1IQ+sBscWnFKKSrNqayeMIgBY10Ve7bjMxqjGovot3jLDBr9Mx58yG9GjT?=
 =?us-ascii?Q?MtLa5Y/KQaY0ihICJu/MoTR5Kh0DCEkgdS3RdWf60HZ09JgOxVgpJbdhZdyt?=
 =?us-ascii?Q?TLyRY+6Fz1VNbosaKjH7XEiBlmYHCJL6XEW1W/dcwdCL5RUFCNC4ZyE5z0vE?=
 =?us-ascii?Q?ytnC2xpHnvtmq/NisoUFGKxBz77hDAbueZDqNeG1t5l7WOOCG0BVMURyxHrV?=
 =?us-ascii?Q?yt+u6zEiJqw0F8v90aKPnZG+02rHBziFNG164GUsjpgRdXB0qbPdjL8cJKwf?=
 =?us-ascii?Q?aeKVlJjhr8yerkOd/lneMDzL0XBuB4lbU8L/n2hpw0/13q+2PVyhHZb93cui?=
 =?us-ascii?Q?bBxV7xCzthsFdWodJBhAvQwpxo279d3eRNuiz77jmA44l7XHB3yYfhDMexg2?=
 =?us-ascii?Q?9Y3PoaZx3eSzclO7qW1AX/XtkrhrM2CovFG9gEXeEWnZm5oeBGQk1jmFKYEz?=
 =?us-ascii?Q?FayrSBsgsu+nbAzlFE3BtsgMrVxK1O8Yyv2ereDqzfxxBVs4rRVj1Frcstri?=
 =?us-ascii?Q?uOcsLKg65G55NivdeiYGO0sqXnv9QbE2rpNghU4ZvQbOF2j/JTUImSoFZ9Nd?=
 =?us-ascii?Q?rneZPTwmF41Ph96vqPG0dztVs4VVIL/IthCN86GxkLpOAbyEJ1nrDvOdnYul?=
 =?us-ascii?Q?YwKr1hdndlIFRFQxRbyVYmC+HePgbqEJg0F7QmqnMlrJk6y0zujmBTz2AHXC?=
 =?us-ascii?Q?NtxUhGh1Xk0DUY4VZKhC6BlJqzlciIN9MfdVAS6+tKnwUMajUPfikK3NT50P?=
 =?us-ascii?Q?yDo4kaJUW0THfGi3aTF1iV8cPGdsry67UHjJO9tZyDHj1Fw918ZcejwdWCGS?=
 =?us-ascii?Q?+tWvNNBP667wbeWL62FotzzYpqpQXZFro+cn04tXwaactvwnE0/PoIRdjFom?=
 =?us-ascii?Q?YNb83HdFsGup9657n5MrZog7ICOas1qqo9fTxglrQmivEeOGsHMVa6OanrOF?=
 =?us-ascii?Q?uoOjZpyI+IM4BKC42wjQvKYZjvA5twkFArGmEsXyznxrA1tBXAxaDO+0lK/7?=
 =?us-ascii?Q?JxkNouU66zOujVzeB1y/hOCW/kiDcDfb+igmJqY7O3zdklApJstAK1RkPqtm?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71638622-5a24-4726-a4c0-08db107f5af1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 00:38:57.7765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7EZ4HZWglUB5bDJokc41v1H+H9tGnfuLCnf+EdaL6km8suQfb416EGr0+gesebvBdCJWSKia4v4Npjz8i9SFqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8562
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiling a kernel which has both CONFIG_NET_DSA_MSCC_OCELOT_EXT
and CONFIG_MSCC_OCELOT_SWITCH enabled, the following error message will
be printed:

[    5.266588] Error: Driver 'ocelot-switch' is already registered, aborting...

Rename the ocelot_ext.c driver to "ocelot-ext-switch" to avoid the name
duplication, and update the mfd_cell entry for its resources.

Fixes: 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch control")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/mfd/ocelot-core.c           | 2 +-
 drivers/net/dsa/ocelot/ocelot_ext.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index c2224f8a16c0..9cccf54fc9c8 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -190,7 +190,7 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.num_resources = ARRAY_SIZE(vsc7512_serdes_resources),
 		.resources = vsc7512_serdes_resources,
 	}, {
-		.name = "ocelot-switch",
+		.name = "ocelot-ext-switch",
 		.of_compatible = "mscc,vsc7512-switch",
 		.num_resources = ARRAY_SIZE(vsc7512_switch_resources),
 		.resources = vsc7512_switch_resources,
diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
index f10271b973b2..6893f03cd392 100644
--- a/drivers/net/dsa/ocelot/ocelot_ext.c
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -438,7 +438,7 @@ MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
 
 static struct platform_driver ocelot_ext_switch_driver = {
 	.driver = {
-		.name = "ocelot-switch",
+		.name = "ocelot-ext-switch",
 		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
 	},
 	.probe = ocelot_ext_probe,
-- 
2.34.1

