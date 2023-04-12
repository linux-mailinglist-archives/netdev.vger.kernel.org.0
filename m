Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CB86DF61D
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjDLMuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjDLMtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:49:53 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD1272BE;
        Wed, 12 Apr 2023 05:49:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpVtFZp4WSxT7xI1L67qrkNkBqWt7K6CdJaEbD7XdTe4StAaCCQw1upzxhN++Ub/jHlmaR/7l4ngC4qZXGGOXY9jIQYIOus/yVHmcTug9ka27I2zPPuFT38kqLFcA2dcoolqNNx6uKAMCH8yy17m1SzPjFcpCjEImiwFE5wbdd0KQYks5wvpkzxRU6tTIrA8pCS6QuLFHF1WK7sji8b0T6UcVKRxsUz4vqV0DDZchi/6XMD4bRUUo8xwIO/uPUe2IOx7GFFaDICmNyxUF+cy6uSThJHyDgyftqDsdyI06kZHhQa9S3uLifs5Tez9Wv3+9B8teC88FY3H+3dIqm3brg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkfiAaeWtzu2DIh+22VbDXvIUPGPOEA6mt139v4rRdc=;
 b=R7HtedqRgEiwUnUEV5feeRxVcQEk+LQRmtD54tBudeK268Bqqp7b2GK2ULUEavWcmpExgmNSbBcLTP5F/PBuZUvVpdnsCy8eIxgp1M36XPJU0UyqSCuwy7vAUCz4gMxA9ZE9aZ/QdK/ovaYZYihwVPhybhQyt+f74PccuxivqXTM4U0qBlV5dLg9e+R8nb4lhdg7+kwJpDAOuOoY/SGCg3qM+Hl4jL2LJc0gtyoP14nlRJkHPo1CqCjOjTmEyR+hmAC0p66RTNs3PVz6b93TNHcT7drZdLaUBdXrgm+aXmm+agr2tV+CF1P7DugxBy2RlvCd9VFPUX8yuT38ogEQSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkfiAaeWtzu2DIh+22VbDXvIUPGPOEA6mt139v4rRdc=;
 b=EfkaJ8pKESYiNuVM5RUErMf4cRTWN0gyYdJhWmMC9qj98oTemhY3yMbU9291krozMXvJ38C/VZmm5zNE1bZeiZIYbGS9ScE2jLI7tZ1kQMQUc1ghWCU4yLn9elwQRHJKwFFIuTdXIu4ZsMnHP17w6Bade3+XlP32e0y5yPuQR9A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6888.eurprd04.prod.outlook.com (2603:10a6:20b:107::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 12:47:56 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 12:47:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/8] net: mscc: ocelot: remove blank line at the end of ocelot_stats.c
Date:   Wed, 12 Apr 2023 15:47:33 +0300
Message-Id: <20230412124737.2243527-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0056.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: b19eff83-ebd3-4d37-eb85-08db3b542370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iGV2iW2P2h/j0me3Cr+dSDV9aFRtt32XKb5BEQJu8HXHCJAK3hgTLyuedo9cTCQZCxRhhm3gLbqtkx7H62qkEzNtrij7M8OhqeytfuJ+jJFqT2jYC7j8G15aAri4Vtrh3SO94zYsfTnNZabETuw+q+f+9YtyrEkpAHcJ+8XMrqwPNTbxbFeVRAuhPe5TrIZv/J4yBlKBJ8UBh0TGSM/IebD0o3fw+i5LYT07zbgRctSzU6JVzQHKArYVXe5q2+k951dCG813wDFRH8EhSUctElUH90v0//yiosDkXkVRs3dOkfxpX2DHgdvSkAguItuIA8yVSjuUIMydy4Gu2fR51cAzlH+fUCPRFmqSFwkDxdX13GPMXJ1QOsC+e0tvYYootlSqMJkzh6PLbpEUqwTlwCKEr1wEds7k71+eWo97Mz8TV765ESCFecbXzj5/rHFRjeFkzEBu9s80cbjPP0mLelCVuvIdUB9cdGz/d2W4Yb/mbiCOSfZAitZId4jHWkNHhOCVUzX16cT/OE4ouoj3G6lqBcHcYWHOIUSWa3tqzh11Gwq1MuL5cxjtppvB6hLQsiwVHos8fFQV7cbyjOddSWw9u8nKwwm186Cpa6jKntfpb981+049wNIthtEHnT1b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(478600001)(52116002)(86362001)(83380400001)(6512007)(36756003)(38350700002)(2616005)(38100700002)(316002)(2906002)(4744005)(1076003)(6506007)(26005)(54906003)(44832011)(186003)(5660300002)(66476007)(6486002)(6666004)(6916009)(8936002)(66556008)(41300700001)(8676002)(7416002)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6/TUqMAweglwJtqBPzd1/ecujvdXb33vhMb/+hJYv0I0WU6UJiRBrqCuOMBx?=
 =?us-ascii?Q?jSf54i4w8iI7Xz3z3kyKNUOUj/Bh31mO2+0dle9eFHst3SoavgMdRwbimM1r?=
 =?us-ascii?Q?1LaV/MZSbAJu5ECSeizS17ilnzDUo+C+x/m2fxJD0jmARUQoa8BmReS2mmS8?=
 =?us-ascii?Q?0Y9ho2ElnNHJ11Wgtj1Rd25/CDQTkAZ2fGoyksy0nZYgW51rK3KJiKBYEDLC?=
 =?us-ascii?Q?KNL2JLYxDgtlLl/WqR7Tuzr/ChCAoEZwvMZN+Y9Dfu0DxN6nLY2Xz1Sx7P4E?=
 =?us-ascii?Q?nW8elglA7cS/RXjT9zmUmB5xBtuwDrOSrFZaUcAtm/t5VDmVUuF6KoxBMe+L?=
 =?us-ascii?Q?kMp451UejWYv89bVzBFEcoli4GQoROkmsUuxZ3fTaPRnyLUynm5DyA8uQIRr?=
 =?us-ascii?Q?DD55Hn53PhOx9Pfx8fibGkuZv7H8lCjm1dQaZPJZhzRIZHS40OIprUfJuUeI?=
 =?us-ascii?Q?2+aQsI1IzYMh8m7HYdUcVqqyONRSOEAlS6cj1YiCMII7flxqKFz0S6iDKVuh?=
 =?us-ascii?Q?E9RcQY7yp8keWPH0GxKzSu2ME4J5vDaIXUYihbhubrIJ90HHiFi+r2yAorpF?=
 =?us-ascii?Q?3J3/+v3IRsrRHqwkA7MzfV5EYpu8RzhJhYbag4Z7LLGBTmyHb1Uvmee+UfsG?=
 =?us-ascii?Q?8w7BrvWKlLE5ekhpWml8rIXABMuIbmfs1h2/FF8gLE4Ps5KUpXR1LTOrDLXu?=
 =?us-ascii?Q?0VzU6AH1EtOO3WEeoTO6tB3JK5xd6ZEh7qVRpKZvHC8vXtPy3Heu6GcT2B4x?=
 =?us-ascii?Q?zQ5Lt8DryraSUpHzusOgmlamcfHxtB3vx1yrnbp9ahR6Mkm1X1CP4jwQdh6M?=
 =?us-ascii?Q?GcDUUQ6B8m3A/D071DBMyiw9BRO6NHcpvwTaKxzJ3vB8KG3osJE3pVI02FaC?=
 =?us-ascii?Q?P/bQBglY5WJxUWGe/lYfgE0+rASlnwWvkFI/cWrEqCgkQpOOSlVA9o4FxE1R?=
 =?us-ascii?Q?mIC5Vj/3vGM3T/bLUESBuc31eiKbmDuR97TsEo6+gCOPQj7bOSl93BP07H2x?=
 =?us-ascii?Q?dnmE2pBYC8URCjlTcrE+hXGu3xCsIo61YtIpCkB04ODQUPVXQcCTy2pY26VU?=
 =?us-ascii?Q?T5hchHdj4G0yjsrGYM4QMbP9h6srkzjntGXKSE38l4G1lXXg/31bCBIpqwCj?=
 =?us-ascii?Q?8e2Nd6cl+3k29aS8sX9Ott9AHU+kXZTaADoffLogrX9Gkca9hInSrQkSWESb?=
 =?us-ascii?Q?x/FbOw9yFZ/DoEek164pntZQXFU/pQo0CcQQsZTbJ4Bdxawam36vxpbQO060?=
 =?us-ascii?Q?CcHqA41diBPMkWYEXhNUbH8ag2dKLEKUK8k0K8gBYDdfOW5ENNZYmfy8BiZf?=
 =?us-ascii?Q?a4hvsptUicKTvQs2bnNgEoI7kV4rBGfEnZAIaYPQWhiwd5Oo4F0FDBjfpEoL?=
 =?us-ascii?Q?Zt4hW1t675H0u43v5ExzXJk20Iu+ZSrqpycTwFu+VjEdzmTwdv5xP0jbNlQm?=
 =?us-ascii?Q?S9f8wjib1jpGdYJ90XCD+64Cx+GfSTmKFrcB6FK+lN0BxjLtg+RXpNdIcIcE?=
 =?us-ascii?Q?6ItmtLU2FgLeMoEYM+OuV1rzCklOwa3zWdmUSpHmAcHHcCkqv7BsbjscIx1x?=
 =?us-ascii?Q?noddCyEh7vy8roSWkDqddmcc4VROc3L0c6F/KXe3cQii3s+tE3SIUfO6XVSj?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b19eff83-ebd3-4d37-eb85-08db3b542370
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 12:47:56.3025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPdQ2NDdMedgfteV+4u3ug+v3Oe5U4aOQ+qkH2Z1volhoLP0y9P9y0NUqdru1A94KeJMn9czSvgsEfSwqaBReA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6888
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a3bb8f521fd8 ("net: mscc: ocelot: remove unnecessary exposure of
stats structures") made an unnecessary change which was to add a new
line at the end of ocelot_stats.c. Remove it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index b50d9d9f8023..99a14a942600 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -981,4 +981,3 @@ void ocelot_stats_deinit(struct ocelot *ocelot)
 	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 }
-
-- 
2.34.1

