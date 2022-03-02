Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B354CAE6E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244977AbiCBTQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244987AbiCBTPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:15:54 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D87B527C2
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:15:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9bIaXKUGDpaUA/LYkThjb7WDCcCzgKfdDfDOFcwBEl/XVASzAneJibBE6mSQ4DQIyYjHoS1/xw/qzaU5X6Inm/WjAnyk9fO88j3wHLOO73tWSHYzTpr9qhlvpSUhnKXcMI/SMz2WPqm/d8CGEaynGc7eWtxCZ8MlSfGt5sWEZ+tc4SGBwb3lEZYTRRWEEG5ai9IARtUEW9FzMkvYHpizLmJckWHO53BxFqeQvHLmBCIVuV2qTty8PWVqYh9melerWGb8Wvz76E8i3sRQiNCzzzv/sY+GxzkUokWtT9LxZ+AnUidqHKOZ6lE2tq/T2g0bD7YJT5sF843QtiYm4gWTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHV3UcYsjqb3/rPZQv9LQoNLfAwG/eEGq6VKTo6yKt0=;
 b=ZCK43K8/n5J93/T/Mg20KaTf5OFrv1GObByc6Pk0NOa4abKSEwbrtN0+yzNgho2it9trXQD/M4ZR3s4R3rqyhsl1A1RissvSH0SbaCW3XHeigYbUDubmQjollSMREuXEGgw1g/wiwshIsWLc38S9CogLz2oFiPFtK11eqVGwYv4JRO1abd9ykGsfP0FRL4riiycCIIoT1lP3mfhOKQNozVJ/biRgK1PYyg+hXjHwgPk4M0lXXrP2dqagMEdU8YQ4CYih9l1/dq4xxHuwiJGVMBlbtGAm3D4wMFh7XErRKm5ATSiHJKTE6xlwYFJKf3joYowjYNgmzeBd1EC59E9KHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHV3UcYsjqb3/rPZQv9LQoNLfAwG/eEGq6VKTo6yKt0=;
 b=sekMYN/LNjGb7Kgcn9r9LSCQ4T//IOQY/mhwAMSzw5RefvuouFSsi9Smp6e+XPaJ43ukbPlLKeQbbMo8tmyQrYFysNagRt4qqRiEwMxZbIGPzE0GydgOzA5f5I7yO5pNA1heULzsZ4BNrftZAN8l0P9/v3TYi6Pirc7pFKZel7w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 19:15:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:15:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 10/10] net: mscc: ocelot: accept configuring bridge port flags on the NPI port
Date:   Wed,  2 Mar 2022 21:14:17 +0200
Message-Id: <20220302191417.1288145-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0030.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd2c78c7-9ca9-44fb-5f78-08d9fc80f46a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2911AE5E991142E21BFC037BE0039@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qz5aBUIxT/ceWtk1CBvOac5eGvKuNyi30dhlwRZhb58kMAtkxKKQY/M2JLikV7FHIF1fzcj0eKVstUEtY9+nb/92SHVBlHFduRrgZ/8sCMbjhn03f9V+Jnvi1aeffPnrrQRnZfJFpIoiJVrimqboelvtVE9+1u/xr3KO4HRnYTGfvPsDR/1pkrU0xYtVoMnyj2ThI7cQirYq6YETESB5Nr8AufUkBXCMi1FnkyOznEoqWSkM+XgK8oN9u2VICQzh3JvmxMN9XPftopOfNaepUc9zTfbLbUaBGahN2/qeonzBiFacqs33BC/UcRdEYmVCxR1Eb2YmM4p+nQPQDr4Zio3ALKu9/O739eYVwe/YmYZKQRy//BtsEilzn003jZx5z4slAH5HCodsby1u/KNM2O74I0vzBx0iwLZdAhGE5pAGPbb18zc+ICrL8HCtSvvd0yscRPKa96WNpgXPcAvB6KvSbwfrJPYQNQIu34pPD1CzHa167T91cZfLxSIF2dgWHYIcHXij0T46MM1o8ua57GkokW38MffjO6WnWB2YRxvsbyL3xX6KUdb7Ec6yJpWTYCG8btg6x/3MtOmYpz5lMPmf7gepkeriNIcGKpFSN7vnktixanJqDhU5ii1DjvnOqJG33f7gmfjP56EEzBUWSxqecqx9g14ZAZYpmG9KgJF/E9zoVAsMu4UHO2OeGWWEgK+/EhEWaDWP183/2yZ+Gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6916009)(83380400001)(5660300002)(8676002)(4326008)(7416002)(66556008)(66476007)(44832011)(36756003)(54906003)(66946007)(52116002)(8936002)(38100700002)(6506007)(6512007)(6666004)(38350700002)(1076003)(2616005)(26005)(186003)(508600001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VkrYnDacK7hIPe8IrS15lXtKxaYwJ6HaRoYxL9bEUbdL4Gtye3fPDYC2vO9Y?=
 =?us-ascii?Q?+GlqMbb/TE3nq6rl7fpPUxMVLdZZ71hCj6Z2vl257pBsWwQBRjW2Qj/XAw/Y?=
 =?us-ascii?Q?zPTzObFMQXE4uDQfUK/faWQuIb8LKqSu+6KalvvAvuLU575ke+DsV52x2K/1?=
 =?us-ascii?Q?z3499mzhcMzy94VhaMQuDNboRiOWspspS+L/nVA+peJpuFa/5hpLd0zdh8aI?=
 =?us-ascii?Q?x7D1M4a+cjDNuzQWmdD0O2orR+PDiBPoxB7pvuynBo+SgOnMCsw1Kp+g4bNS?=
 =?us-ascii?Q?FVpv151pYuahqHlDeq2csyfV8rUvWas/hBy/BiFUjz3ahOfPJtCrIVBt7OrP?=
 =?us-ascii?Q?yA5250v4SoRFbh/UAiJ7DB3Y4v9U4+JTnxQWtEK57GI4MMkosJ4aO3C4PTRd?=
 =?us-ascii?Q?fkAIMpEFEKfBmAFX8MghyWsNO78ht9j2Qo2iWWTeD2cKeSFcUDE7UaviB7mJ?=
 =?us-ascii?Q?2ac85mSDp8W4Ma0fr5iUMHgWpsoDl6K69mkU3OroMlorfddtll0UGVVk0WKz?=
 =?us-ascii?Q?Rrczi3vrJQumzM5/vNIl/eA/G5XbMiMVzSIUjiyjZKoGrEIbZQvKNXInJ7+R?=
 =?us-ascii?Q?poTmKdwmthkZ8wkDsL8F0y1zd6fE1ShUs04nx9CsfHH202O+VdmoMhCMH7cb?=
 =?us-ascii?Q?TSuMXsVR2P3R3JmEIqPbXQ4kaC8s/4o1KgUgwHNipIXHUI+8pycmsbCcoulL?=
 =?us-ascii?Q?4nGbpOb8WJnf5DLmia6JHkneubm5lYskTOT/fv0x6AhpWOvsP71cqawJZy5y?=
 =?us-ascii?Q?S+O3Vji04ad6Az7/NLeTqu+hLyogJUiV432/66Z4dtxTSQuw1p1twQFcGvNk?=
 =?us-ascii?Q?WIC6EoI+mZ/ncWzc/hh7qMyTCJYYiEKnD4/bqB/76eJe+E95mB3hRz05uN0C?=
 =?us-ascii?Q?5qCPK//ySfNIAfVmIcsXXlHbxnOTEVzeyi9BbKINxmSmF0Lc4F/K/a3NbJAr?=
 =?us-ascii?Q?/2Gm/NazpLyZ+YHg4ybE6IBI4TXciMlEnnToEphNXB2cn/jQmGwf3XMuGFgC?=
 =?us-ascii?Q?g+ZT9w1Kbzq/vfJCsJ/jqiOFae9Qu2C5jYFtPQAHMy3gtUUrE3xvF24K0R4K?=
 =?us-ascii?Q?3/xl6oD2DU6bCfCm9060Ws49Uoi4mCg/Ro3pz+gLi3bdMY5k27cDh5xSyRQE?=
 =?us-ascii?Q?oRZ/CegTl5T2dXqsrndc/mQBCcRuVwX8o1v18TjxpA8bh7pSvNpeKUB/kwbg?=
 =?us-ascii?Q?AgGcjPzthOWdWV65TJejS+FDjAM2rkEsMUOGY5lVUlD1PPQhfspmErD3QA20?=
 =?us-ascii?Q?E9d4KSrs1vv4KQTvBGWShni5wu7sh1G+PTd8UgH7chKqgt6WcSZA2wreN7CN?=
 =?us-ascii?Q?4PqpE39+mk7Xf5Q8RBM/D1YQ0w+XxLMyfKkQLXhUzXpjDmNmMbEhiUg0JaL7?=
 =?us-ascii?Q?4S/bIBTXhMijjMwa0oV1JwIcJgKJojXOz0UXShNZDnDMpy4xDsNXYyfO2Xas?=
 =?us-ascii?Q?FR5uR8oFq5vo8/SFKCxEfths9pu/ZZpS88q/Czu0fxad7Di1R428LdXgGUmK?=
 =?us-ascii?Q?bpgdmQw13VKxnGVZTxGmL9vZo46vTAYPeSy9m7zjuYvUPTx/Rx/IM2tT03SV?=
 =?us-ascii?Q?ofv0nyq277LYufSHWoXspCwd5wB3ahGxlgUJRF7ArdxO9UV3bkYI9WhQ76QW?=
 =?us-ascii?Q?J+cPB3ER8T7ppE8w08Z1wdI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2c78c7-9ca9-44fb-5f78-08d9fc80f46a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:15:03.8136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2O4+G26v5TxGT7jA0BBOp91nUCaKipq3TE0X1ufHh06aKuBDFLdYQiishAbvnAaKAq+X+iF/lwAH1Ce3hqTIFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for the Felix DSA driver to be able to turn on/off flooding
towards its CPU port, we need to redirect calls on the NPI port to
actually act upon the index in the analyzer block that corresponds to
the CPU port module. This was never necessary until now because DSA
(or the bridge) never called ocelot_port_bridge_flags() for the NPI
port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0af321f6fb54..21134125a6e4 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2886,6 +2886,9 @@ EXPORT_SYMBOL(ocelot_port_pre_bridge_flags);
 void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
 			      struct switchdev_brport_flags flags)
 {
+	if (port == ocelot->npi)
+		port = ocelot->num_phys_ports;
+
 	if (flags.mask & BR_LEARNING)
 		ocelot_port_set_learning(ocelot, port,
 					 !!(flags.val & BR_LEARNING));
-- 
2.25.1

