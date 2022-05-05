Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EB751C50B
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381893AbiEEQ0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349623AbiEEQ0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:26:10 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7B85BE51
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:22:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TD+Ypz0zWsbDN2MLDl85m/5g1u9GpVEEg2JswFXfRL0dq0c17mJ1lKIsW1lSJo4DWefM+2Kp8U83fvTMqOPYcO27jfSNyRpxE/lW2/IReQ7ns6Vx0E367OS3s91xdaMBbi+ySwwAOnHMxKE5ULF3BGMmmxB+LITy/t6Rt+7XfmRE6NUdKweUpWKrb8rRtSqYIJ8t0erf8wzemV62Zf6pEvXlCIzUXI8Ty7bvOQA1yCnOv65xbCWMTLjdNNNKprk2ZRK4NTaRFhI73lbBWpNo/+FKuFPADomuj45CmOZ3yRafGQy+60sYsZO109jndLk5j/WM+vDprFWTUAmn5fLY6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s4b0bUgy+hT4L9kttHl+4nbmC3gJMVgeMtao2JhZqCE=;
 b=epQUoZlr5BIJnmCS4o+aveSshhNVMRqmW/Et2Cujg57JaleERhX9kSvrHHEnRl9TxLwC/r/p2hRns3PKtB2lq9Ao9H3ibs2yZrtSSaA13nLeC1ijFzBB+6x2CGdkESsjEaJCt+ayoxZDj9C/WB0DJGkT2w+CAV5S2NTInK2O18mo9Yvz7ic4nkymCmDwKOssnR1T0jQ9TwaOU2oZ2bNppN+C8TH/kBXWXH98t3WheNb4gSoEnjQgKgL95VECdWV8JZPUN5+cxEY6BjGE1cFvFAS5SOsle3KrSSi4YRvq+HgRQU8Ubla/vzJNyK+sukmTiFUZhGppukESS1wnjcNBIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4b0bUgy+hT4L9kttHl+4nbmC3gJMVgeMtao2JhZqCE=;
 b=YgyN8uAEnoA3xU+0+20oijwJLV8TWkapJ6liaLg9bWqSkOI9NMRXDOKPQQmEu4IBtf3eRlS54fydWuf67Q+wtBPZa+/G/sF03uNRNRACclXE1NJBqsVtn7BKUD3eYr3WCYLk9NjKew9FJictd0iAo0dujpzMY8QFZaxbtYYzVOc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5522.eurprd04.prod.outlook.com (2603:10a6:208:116::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 16:22:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 16:22:26 +0000
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
Subject: [PATCH net-next 0/4] Simplify migration of host filtered addresses in Felix driver
Date:   Thu,  5 May 2022 19:22:09 +0300
Message-Id: <20220505162213.307684-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0021.eurprd03.prod.outlook.com
 (2603:10a6:208:14::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0c9d8cf-4596-4a7c-4273-08da2eb3716b
X-MS-TrafficTypeDiagnostic: AM0PR04MB5522:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB552295B4AFD6D38DB993C281E0C29@AM0PR04MB5522.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: peqR5Qq3j9fKGZ1+c9TKwfRlpVbRBte/j817iAAPdPpTuzDPXyKdAsqXSJJBwHD8UFCIZt6r+YwDplYGR3wPdfvMen2TAEZ216cIPLAbAoZj9mkeDtwM0wCIdQaLHi2dNZylMqKqByUrzvjjJpHOrB6ElgQRJOpL+mxFdyIa+snAtByNUeTJT2QtCrPecyP+89/9DokZsipIV8YtUB60lSh5/gcRl4/Ozkj7+4cz9mDp4YycoR3HKulNhkAbeiM44c/58xNR9wbW60dqU1bAkci16Mh959Ff1fGquUj2Ahdyf/M3GCXCgvE0Ea+WklwYcYb+4n7tFaCGYDBH/c/mx9QJsdImDH+j8Zxb2ONf2DHX5A6FK7SZzcQ3DEWmLZ2+nfULja5VNPFmvpEiwK9w3CkWJw4HEkWOn271vYrvx3wewPoSuXkrnPEDVnrHasYVhfMdcDJJ0MgNzQWhIqNeWVPUsR9+8qhDF1PuqlovB2Wux1UjqhggsprtqSu2tehwW9m1OKdnGNLYndVCTZFYT8/CSH7SJFSoetfi8Gl1FNaPLPGK8pTaPy7XlJS+ZBEdQ/js54OAocoObLoeykq837k9y3hRxK4pouQssjRkq/Cpt6OuiEvHfxVaK8tF/M14aRedQoNkVUliMRU1FQaPoK8CQuHXwtNu90N0G5ew0P7ZQPzuOKkfdVZc/5yaT2rSZ2qluT6lHTbwCN4UmFwU0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(5660300002)(7416002)(508600001)(8936002)(6506007)(6916009)(2616005)(52116002)(54906003)(186003)(6666004)(6512007)(26005)(36756003)(6486002)(44832011)(83380400001)(66946007)(4326008)(8676002)(66476007)(86362001)(66556008)(1076003)(2906002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tDi23eteSbjMNo++oIIY7aGS86cQS1TN6hYEM21kyO3IoaZBMIXjKAVHt7rL?=
 =?us-ascii?Q?1CiDBkAm0U26G/m+h3UeimYnmO6VXi+L7NdxqMdR2+qFVvlYSe6riqHr1jfd?=
 =?us-ascii?Q?X463SLgMALVFbPEOMBS0opITr5hwcysSmZoyTP7ajEjwXUtoc/Rp41ypgMor?=
 =?us-ascii?Q?GsbTLgnMeVHWCpNUPox+KQFdg6qiENbWeWhrolzJgl1MjRuNjjZIYMuKSXOw?=
 =?us-ascii?Q?2h2lxglxmCzwzRwkY+O3JLNgqph7iUgh65Pp7esiZU502YePLpPCUOBb+lM3?=
 =?us-ascii?Q?Ta9TreffYbBMg39KG8jhIlVJFQgf6ia1WDGAgDVE8qSrDafq03Ga+VW8hnQq?=
 =?us-ascii?Q?HF1nNZGaRghV7joAYdShB0ijI0W1yPWWpykfuRbewQI4k1IYIpBCR1psQnpk?=
 =?us-ascii?Q?8gtW7bzk29bagugThnogzniuJIwESY9mRxcRQ3x67tsZXwN3uBycZO6xOlWN?=
 =?us-ascii?Q?k6mNCb6iGwmaAWVDriGCByKvjQIwIY37/fLAZR2q4ASX2ptZWIaDb33izGA6?=
 =?us-ascii?Q?lNf2WrPbQKGubbvC+a//g0PqenNFZmJ1BxX/RC4vwKtiBnuud55wDrLFqAb9?=
 =?us-ascii?Q?Dfoe84seV1tAQ6IdyX5Jsd2UnlF9SY6F94Pjrb0JAG5438v4M364HRuGwDRt?=
 =?us-ascii?Q?nsBriFW2ljS0T0HVMpsAG6XYtPW9oYxi3ZRN7aqzdkFhOweb1aXYhl0mdxvf?=
 =?us-ascii?Q?8AqHtW8B817IhyvlsayfbkpIlkzZTKKEYDjN6ZYSQGq/8yR41a7Bq1ruUWR7?=
 =?us-ascii?Q?fjc8WA2Ht0VzNJfZPwkyRV9ImtOcrSijyAp7YKMVxdDyBbEMw14io0/NDG9S?=
 =?us-ascii?Q?kCEhcdj1XsvopomWMzi/+7uHRP0KsANq3GqIuIz7l8tSH1UHp8ANAMZPRwTd?=
 =?us-ascii?Q?bHc+UbmlXa6A/AWel3UgVZEDr7nHyW1Ll8qqa7zosd0PMzxXuf16B0W4JZ3p?=
 =?us-ascii?Q?gUo/Ud+EzQQ82f9GhjCf9RNmv2AvJ3Z2Zs0Of9WevIFpq9/2GF7yUbGP9wYG?=
 =?us-ascii?Q?PceE+4tCmrOIONoRVH3D5rYuaQVEwW5HvsJrs6V13RL9DW22HjUJZjnVNbAK?=
 =?us-ascii?Q?Cx4Usx8B8/v4MPNHWe1wsQZnc+QlI9uRNFVc1wJzROQMDRTxR6AOvVa72oCV?=
 =?us-ascii?Q?MVk2KR9qv4sRv0k+Iiu7Ke6VCXTFANrolL9Dy0j1NIiPSpiHIOy7dH+1rv0N?=
 =?us-ascii?Q?COfJoNdgLBlCTjwSIh10vGu7s7LeWWeRocxy/0HdxbHzsBRcDZ5PpoQ3h2Ov?=
 =?us-ascii?Q?1pof0f8H37h76ktdI4gbg5dVBEUu1cL8KEldZOYn7G4KWoRi8Og4MVkIVhgp?=
 =?us-ascii?Q?cK/EwJAvYsUzzxveH3uxpwrBv0DUr2HHmutrBQrjH719XprFVslJKLyf4sX6?=
 =?us-ascii?Q?6P9aHat7qiIv55cxdCU2a+J+aR1Fd9/JmNDRQkafIZSz/98dmSStY2pozsLh?=
 =?us-ascii?Q?05NZ7vlCFqmr5+S4fAwWYCs14WJy99PUD6vRwoAYl8HMTxas4XVXNeUTZdU/?=
 =?us-ascii?Q?1fwHt4Hqcjp+tnc3Rt3h2mOJFOV1LSI16UiWlJUQ0R27bGklgVu3f71+I17S?=
 =?us-ascii?Q?/CFsvwslX0/YXqmzIC9qROtgqZU7WwOgujV/KdHB7DttAmH+KDX+q/L+COnr?=
 =?us-ascii?Q?uKCFiH4EHhnZebXkTh3N/vHKPXX3L2EyEEm1uQ2lyWMnHGGgQv1L75TiAI+M?=
 =?us-ascii?Q?fY8T0hN3tBrLWhSTmYbeKRNCbiqJD3gJiPP2576Du1sIoRaIhvls94+JTxzX?=
 =?us-ascii?Q?6MqKU+bReACtF6vXFInKGYBwajK7vAQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c9d8cf-4596-4a7c-4273-08da2eb3716b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 16:22:26.4787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gcgvithkvs0hZ9D+MhxPmIj5yC1VG5A7w0StXKks7e/dT+h3vN/Lao0C+KeRN0oUK842DdgtZLgeQ9vGfWMxaQ==
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

The purpose of this patch set is to remove the functions
dsa_port_walk_fdbs() and dsa_port_walk_mdbs() from the DSA core, which
were introduced when the Felix driver gained support for unicast
filtering on standalone ports. They get called when changing the tagging
protocol back and forth between "ocelot" and "ocelot-8021q".
I did not realize we could get away without having them.

The patch set was regression-tested using the local_termination.sh
selftest using both tagging protocols.

Vladimir Oltean (4):
  net: dsa: felix: use PGID_CPU for FDB entry migration on NPI port
  net: dsa: felix: stop migrating FDBs back and forth on tag proto
    change
  net: dsa: felix: perform MDB migration based on ocelot->multicast list
  net: dsa: delete dsa_port_walk_{fdbs,mdbs}

 drivers/net/dsa/ocelot/felix.c     | 104 ++---------------------------
 drivers/net/ethernet/mscc/ocelot.c |  61 +++++++++++++++++
 include/net/dsa.h                  |   6 --
 include/soc/mscc/ocelot.h          |   3 +
 net/dsa/dsa.c                      |  40 -----------
 5 files changed, 69 insertions(+), 145 deletions(-)

-- 
2.25.1

