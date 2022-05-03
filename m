Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0171C51840E
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbiECMST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbiECMSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:18:18 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70079.outbound.protection.outlook.com [40.107.7.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5936332EED
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:14:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHlcdK6FagvFbRf80MU9FVhKyl8m3xhOfzKoK27DdYnPpCMxMbzvrIi6dYnq5w94/wjXZcI66yQ0ZXuWwe/7r8gw8Mhtcq0xCAMcJNGOzaNpzYmKOVAYqMLdPDDENbg3SPliAm55m9TP0keiCvN/TTzK6zx1vEwTx5TPfmlmeqlXa5HCi+1bEo2jMEhBcc4hgGJJFLMNT3oB3Vw12HTi8j8iI1H8Zin3B9yEeLyQZLyJgouQ97Wlng0D2M246oWDPXkDTXbM/a8ZuGuf+LkFp01g3rG6lp4El/zhwQniGTLlHUslBUYRuoGJbV4aVcHFRWUUTK4Btt9+SpOFd9p9Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0t21sZ5f9w4dTHhmCqHKrtP/ZwfJQJpSINlDM1+cVo=;
 b=VvcRfamKyCQscmIqa6IPgZ0XHnILcV18HGudbXHmRUJCk4xXrbW6IWO6uz63LZMctGDizxmMbVcDYWCdrI2HKqMCr0OdACnJrbtRQUg++b6VCOAWlgMDEV6k49COCE+UlbzD4z0INTJBO+gyesbzjrjOCsRr8kjXQT4VjCSsa0vuYVen/M41hn7hm+h8i/chUuyvE4CtRhFZS+JOUIRLFQY/Bl3480yq0Nbob+9/ZdtOSaXln43tgRS6oCQPQ1YbdAEcqJxce/fQohFiSdIml7BnNraoqjybA8PzhxbKizpec9ETKO5LhjpYEAhNipg2ZR+YgeGuskJYPv9bHfC4/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0t21sZ5f9w4dTHhmCqHKrtP/ZwfJQJpSINlDM1+cVo=;
 b=NyNG7ifKHdslL3MHct/t0H3LvIWxm9iEQvfDTZE1GCwWeJI4Hc9XQbqU52zriVd+9PrmdO400JLGreMXIu3/sDJO/9YrpOLDqOghq4fDPBEPw4rYSCqx5Oyg1K2fgZPk9hlml4ZmE7KdwLkqhBZczHeQm/H0rV91tBhC2bAvmXU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by HE1PR0401MB2585.eurprd04.prod.outlook.com (2603:10a6:3:87::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 12:14:42 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:14:42 +0000
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
        Colin Foster <colin.foster@in-advantage.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] selftests: ocelot: tc_flower_chains: specify conform-exceed action for policer
Date:   Tue,  3 May 2022 15:14:28 +0300
Message-Id: <20220503121428.842906-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0032.eurprd02.prod.outlook.com
 (2603:10a6:803:14::45) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbb5d95f-1c31-4c0f-c843-08da2cfe80d0
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2585:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0401MB25851205D99DA06A1284AA60E0C09@HE1PR0401MB2585.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9sw5y+WuuySgb91g1V0nczcJp/NZPFzwFlzX6KlJ+9qDjAAg2fPDv4+bPyJ5kPFO74MrJCzpl0+i1O5dSfbGHZXEpaCTcrmd+OyYtlRjrqEpwiizW2qdawoqUGoJRMIPbJ7gdKSuTcCKjTKhVZbn3O+HJ/reWNx4CjYiufZPhiRrrCNFR1rgorgYt587SeB/FqG0R6mp6NOQr32CyNTXrcs76LmY6CvMQ1rQVDqF3mL7wg7NE7lWIRudu8RKxbd81JIRzOerCvFtLwmcmH1eTHS8kssNRLbskJlKq23igCLPZBvjwlULDJ9unVgq22FKerFFh9m38A2wE7HmKWCSTdG9VunkcY3TbqACtIPH5MGA1AO26Sv4920dsD1NOF766JMsEd/UDYzmPzimC6B5jtv0LgomgeE80cMseMjUiMJ6vKBKEhZxzAPo/P0s11hNqYxPINkPMUC5ZbjH6qmnoIENSPnnfjBJul7QAk0JTOXCz1Y7q0bopRyXwfBfZ9BsimdZ3QesEH4fKQ2f2h/ZcOye86Y0BTqqUvqgGQLPU6o5QNBNnt6XkIcZ4k0kxd1ARBH/a+EpoSpGAMdoAAlkx6Yv+SofE1JrlaH2uOs+ArVACnesAH5Y/XiMruUf8wv5clsvSCYuftZK8cp0/Ov4XpRz+RCvIrOaOAPUxzSrlgDagjB8ARJzI7MzMO44jRy9AlIZZtx9nBc0SWeS9yQUZ/CIO2kwIF19Mv72m/oAIDWryVwvkYLdPf5FmcZadXZkrqIe/l6Obrgg5p/eJHY1phJ/Q3zRHfsBLeteCvID/+E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(36756003)(186003)(83380400001)(1076003)(6512007)(6916009)(508600001)(26005)(2906002)(44832011)(316002)(7416002)(54906003)(52116002)(5660300002)(6506007)(66476007)(8676002)(66946007)(66556008)(6666004)(38100700002)(38350700002)(8936002)(86362001)(966005)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DbPWDPXbSwji1kl3CrgyEKtOlEtN9kf9v7bvQHRsPmeBFKKr07mZjPIgZcQv?=
 =?us-ascii?Q?TNbHob2De68BiyYRAHNY9bE4KaIJnYa24ZInGYUh5Mq1VydbJJxnKkRh351M?=
 =?us-ascii?Q?yTBRAqYTCALxGOlP/LI6dRJRQnDrkZ+Y0n5oeBcQLvgnOOJEXOJVu1cQ0Nbx?=
 =?us-ascii?Q?Xp0IY2D2MGYc0I0OBYyR5JgEa8kLkixeR5sp1fA+E6iMp5UBN6FncAaGwvl0?=
 =?us-ascii?Q?YKKMLLwoEX+eJBRgmxpIsEcylFq+2iEbKjhcjnFvWj5Er2b7k5IMkTF7HOaj?=
 =?us-ascii?Q?sjETgZ6y33AZItp4wRlnhSK8EU6ViFUJBeA/PpvNwnvt3pyGtEjNtv6Lr9Fu?=
 =?us-ascii?Q?TnctffI+QOjsPWjwhUDmrs32zCWlatAqw/bzkTvhBqJjyJ0xYNolTEOGpOQ8?=
 =?us-ascii?Q?RF//3N0fftizJsz4oSQexc9o6CoHW88IxKkXUcPotSs3+A33eCLzr8TNCBRZ?=
 =?us-ascii?Q?TNfui4r3W10cuIAWLMU97p1uQhUbg/7Ltz7RoreSvXSA4k/m/usRQLWntL0B?=
 =?us-ascii?Q?ASlcZQOrNdaEmGx3gU2v7DKUgXnuwM6meVT0wAIStwguS+Wit8CBTkfrvoQF?=
 =?us-ascii?Q?FBdh5iTcIH8IcO2LcyKHv2alhB2+kWPdJFD4cG3YUhzbnnJ51cDqC8dGFVwC?=
 =?us-ascii?Q?Zp4W90xO2KQ+AH1MQDTSZy6ngbQidzFUL2zhg5/Iyh8wgmcfOJlmULJ9b+iL?=
 =?us-ascii?Q?2giImWsuTkqODDJm3jWU3J9acEUBcmkGJuz3lYZkzE+epIRNVf7EhomLmRHn?=
 =?us-ascii?Q?JA9DTURTsUdDBDif2HOSUtxZO5SwR1SweonXzEU//dakvUZsHvhYdPhsmQnz?=
 =?us-ascii?Q?DjNhmNP/19DiIl7zAobfPI6q0H7sRLrnbvZgTBPTBPtZmRnI1QvypnHyaM/0?=
 =?us-ascii?Q?gzcOFT8pVFHGYbfGlEoEWYjMmHUi41Ut47Sx5cPeIABnJUZ4zeAbuV3+EfFy?=
 =?us-ascii?Q?yPU5TRpEX8T4C+3gRJJufDehhef8FCB1vl65Em5Ozc6dhuqfmJyx5CiEdLMd?=
 =?us-ascii?Q?/SGy0a5jDvv7z6SRuaBNdMnaq9rWNc7u9juMp1ZIzn7WWXfPSyWPTZ+0WIWY?=
 =?us-ascii?Q?TG0qK6kA3uDJ7RqSUBY54BiIYLWSTsfepnnHupD7Nyk+p1hG64ZETQF3Q81+?=
 =?us-ascii?Q?jhHAcWPQWq/I99Qgf/ZgD2ecqW6KG00SPhJ7vQtbv9XEGCi7b7eV+4lIUgYe?=
 =?us-ascii?Q?yItqe4bEr1PyQvP9nw4ZUeauZM2eNk1Q3Vl4soCq6QLsXwJrD3Aq6hI4XU7Q?=
 =?us-ascii?Q?XFmCm2verP/piFzm/9TszYPdkAoc5lliFzxYQ/4Y9QAbfvO7wvDRUUQWqpZ7?=
 =?us-ascii?Q?LkaruheIUnJMVPWU81YoPZIZkc66AKzzdZEV/M5uocd6FeeZmuTVyBte8xLd?=
 =?us-ascii?Q?jgPPuSy0edGi9WVH3IxMHjX2rdiihzqkcyymFXsIx0MHJtBQlVskhu+J2MnP?=
 =?us-ascii?Q?y9Nsf8ahMfP8GSoxocwcb3o4yWVXdjua5wTIYIOLVhjHTf/tiK5MWyN+d8PM?=
 =?us-ascii?Q?mMG0HS1SKTISeYllxNedg+Or490MxSpdqyOfyv8AIywL+2QgfFGDN7/0vm4o?=
 =?us-ascii?Q?AkPv4bQLeTpvJfZzW0HnFjssAPvwgg9blU0LbqE4i6Z4byPIXHKzSAb5lFUE?=
 =?us-ascii?Q?oHSYcM/u2l/a034BdwliN0bw86f8XEa0bD0lyktQbvfxrQvFMSOY0hyG1K3U?=
 =?us-ascii?Q?k+fEf6WHPNZZ97NuHvobdingLs5n2v04MM3wicPKJEZgMK8wLBIODrTK+i29?=
 =?us-ascii?Q?48m2rXoCRy5CusvtBnB3q8tgrqJz4h4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb5d95f-1c31-4c0f-c843-08da2cfe80d0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:14:42.2703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22dsh4rfDcVg1nsAiH8Ic9wpYepGXrGMmV6qrzo4zgjfxtiEj/oSmUkpiB7BZT8gnrP9Mo0XJ47/ErCES+8RPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2585
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed here with Ido Schimmel:
https://patchwork.kernel.org/project/netdevbpf/patch/20220224102908.5255-2-jianbol@nvidia.com/

the default conform-exceed action is "reclassify", for a reason we don't
really understand.

The point is that hardware can't offload that police action, so not
specifying "conform-exceed" was always wrong, even though the command
used to work in hardware (but not in software) until the kernel started
adding validation for it.

Fix the command used by the selftest by making the policer drop on
exceed, and pass the packet to the next action (goto) on conform.

Fixes: 8cd6b020b644 ("selftests: ocelot: add some example VCAP IS1, IS2 and ES0 tc offloads")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index 7e684e27a682..4401a654c2c0 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -190,7 +190,7 @@ setup_prepare()
 
 	tc filter add dev $eth0 ingress chain $(IS2 0 0) pref 1 \
 		protocol ipv4 flower skip_sw ip_proto udp dst_port 5201 \
-		action police rate 50mbit burst 64k \
+		action police rate 50mbit burst 64k conform-exceed drop/pipe \
 		action goto chain $(IS2 1 0)
 }
 
-- 
2.25.1

