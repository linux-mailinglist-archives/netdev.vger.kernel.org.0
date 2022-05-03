Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF0A51839D
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbiECMBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbiECMB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:01:28 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2058.outbound.protection.outlook.com [40.107.20.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128FA2D1CA
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:57:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZue/8XZ06kyUd3W/0AeFrWuyY1VBN+3JBnh6Sj7VopTgS6NlIU/jTZtCmjSFtdITbqdbIGwk5rrvLBYl/O7ZotHxtgH9HxHzWPk3KSV///EydsieY9XXzXUSREbZwnm5Pjy3JbnkPfASx0nAQ6iIMCuVUEU5O8/p08hZ1jfY3hrHiXx8Hf/XazlpiuZq49cbwBL4ZiLr3SOuXtfHfai37SaZNLaO/lw9c/Jd32ovQsW4mlQvqJb5Kvu7ZmaopfAHXDtW7H06D4B+Z1gGR63HfmgB8Gv708+C34x2RdTTbI2ppr5xns3qi+isQElnUERNmyB1iI+pTBuHQZo/f/e+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+VyBPSwdCdMRPZ7sjBypnq7JURITLymu1/FHrdpkvek=;
 b=Lu+wPGrrw/8vD0xOLPLis43jfklb4JvcsfcvmrlE0g2l5wdb4ffsEBPyU2p55bwpm+8Q3emVfIEFrgYM0iqNM8Wr8nm29PyDOqOz30LVVi+jwQxt5A8my15n32GqgiJwt4iuKQsDwW+/IeAq05A1ReNiquzrJwuT88wsFaD1PO4XKX8J8FG9Fc8aCTUK1T7Y+ypjUWpXVhpW/V0fcPSRdjiGzLQozHBpzU9yKvVj9/vAZTFcIo/WyyHBz42kg6Tei8OwvO7pZxtMQpTSljWudYv1GsGtN11w4T1MaA3DYuHB5js25G5TVudpHaK+gAQPa65Q/9eCdEcMnh/3eiKhnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VyBPSwdCdMRPZ7sjBypnq7JURITLymu1/FHrdpkvek=;
 b=k1v22ynTZkHNQNmVxoY2RnGR30/Jbve1eQ4azjtTfthTmMJ2AWs26o7izRyJThLizMlhZOGVRc9HZlgXR4KBDwqXt/PgFM4CIjzcvt8St6OsT+nphoMZl2sCAQAmH0oj+w83AYAl83b8P8p2TACZ/O5R0AqvRT8xchrtPJJDqQA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 11:57:53 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 11:57:53 +0000
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
Subject: [PATCH net 3/6] net: mscc: ocelot: fix last VCAP IS1/IS2 filter persisting in hardware when deleted
Date:   Tue,  3 May 2022 14:57:25 +0300
Message-Id: <20220503115728.834457-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503115728.834457-1-vladimir.oltean@nxp.com>
References: <20220503115728.834457-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::22) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9fa61b8-053e-4973-f7b8-08da2cfc2776
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB4813E5DE9025EEE18B7CF4C0E0C09@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SGjvDdSvL+f9df2Mz6RaCJ3Sdb5PRFvFOjAZWbnpAPds55pvIgdgIU7MEwRU/Gmndsp0qdyU79XkzR2/hK6+ILuojMA+w5Q/m7VuRWdyNid2kdg2UyBSvJHCZFjfDRgBKaHkWSxZnA/KeNEGUTVYq3OBu5rIq0v/tkfZsWkHrWHrXpgq3ICkIHAphfzvSOXj00q6osNlm/T3ABFR3l08WTbllirAgSBQEVicVQSrVGClhUweqsOhwUCgMlnKwYKM3/ihhzYZfE4WKW51tlx+fq3mAFOJjV1tL6iqDyMNVsv9QfLbm+mEul7b3snb5H7KeKw2PsuXqoxcwCOvnChyZwx2pzl9ujS9A4Vc6Xr5B+JtxZjMHyHGgT4W8gfoI9TxC7+fVWiYWDfNYn7b+WsCBmDKuIaWN073ytPjm22cqIVLgIcnHgL5JR+YZLtFdhXVUzwD6HHqoq9dWCYRUMu+Lk/wxD0XqOg7HrgHzqaUYfYSkXPHjgt9svgeq/3EATK0Ndz2+xGyeoxh1uRtiivetOrKrNeKBahdpErUyLextUawhs2OaHCs1eWhiK/ot+kZvZp+PrEbXgtr9TbrcH4OVUhK/ZJeboeuIJBwSFHrvR5pZ676qhsI37EZDWeeb8cTf8iTgaSWz4seKvx/xuMIcinkSmrX6gxB9LGBESvWpxQRgWyQvD3ZkVcVwhlU/853eC/dj3C8zh7i+B28d+Eekg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(44832011)(8936002)(2906002)(8676002)(66476007)(4326008)(1076003)(2616005)(186003)(508600001)(5660300002)(66556008)(7416002)(6506007)(6512007)(6666004)(36756003)(86362001)(52116002)(83380400001)(26005)(38350700002)(38100700002)(6916009)(54906003)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wrNkwSv1MOLhGaEHOxcbxO4y8ESQZSDvh43+BtqNcy0xqvaeepKsdBfh5K+8?=
 =?us-ascii?Q?rLh6GE+LEU3qbxLY5Hbu9yP7wmQXJrNgi62PoE/xYdMckngDE81BFTmYQr9D?=
 =?us-ascii?Q?Jv0XxlIE+/HzuAkr5FvzSbJOcmBp7W6DxZFzUCWYGfHYrjRtqhbQrQUAyEGt?=
 =?us-ascii?Q?0Ki4S0ve9NO284aYPzFNkzVmURqAwVjVz2PNUHkVhIFCvYja1P4l67kITQ1m?=
 =?us-ascii?Q?oNE0xDEGW33OUdryoZTCoEteDn6a0v8TVui/14EFaKyZVstYOeBuqp7zyrOV?=
 =?us-ascii?Q?OqpuQQLV3w8mo7CAIRJaZreHwiS17E1WS8pfZ+sJqthqgDZbAJBjkuEArDuK?=
 =?us-ascii?Q?88MdNf6BxsBJKJy3T5anywf1KX4lsE+OQYf5IjG1NwDdjDC4wQ1yiIJ+EZjm?=
 =?us-ascii?Q?V3L0TagCmJ+hpFhTfnSahBJDvGXEfkFvmmgkEMaB4uXC8pikU/aDVYA0QU9E?=
 =?us-ascii?Q?UHxxPSvIPohs+xGApRtMjUJSmTuF18oO51bMoMLu7qHgejJQ05p0GOgom3b0?=
 =?us-ascii?Q?zh9sAZSMeGs6zLPoSBhfaOxUmK/OBtI5htILTkaO2LEVHbloR542e9uVBYzf?=
 =?us-ascii?Q?hewK5X7h1MorT6gUYPPhthr6a76hGYRd4vgnRaAifSMuIG8Ln0sFrrhy4F2z?=
 =?us-ascii?Q?a+BD9Pw+v/YhvWv0Vq4OhJLwp5AfmI2aOIpJtrTdPSN4oHDy5XRntosrfrHr?=
 =?us-ascii?Q?HWQTNlmJsG/MEUVBcO14BmEX9VcGE7XJEztD90GgG+kn8OlfI/en5UM0P9EC?=
 =?us-ascii?Q?4XtS+MDjD5m1b7z570rRYaYa6wiu0k2VI0m7IxtHRvyci41fC5/c6cXoWUVx?=
 =?us-ascii?Q?IgZsE+N36dowurm6Ro3UCF8/6Z3aRMTCiTHwcKAwB9Fa3Ks5tTp+Ge3jkvMX?=
 =?us-ascii?Q?DQbeENgL/vFgxv51YD2g40U0tHT1iiOfTrXLqNWAP8cggj5pAAVfBw7sUZHg?=
 =?us-ascii?Q?P+X5ijAOmCQVLA8F5tja7P1fRWcmEYK00hYqSpBCxqKSb/cl6iTCO2DLgVt1?=
 =?us-ascii?Q?Sf/pMWuoqgrn4aZaa6v2uuK7dCFBWX+dJu8oBq/fOyzUu7DErjH26gkITOt6?=
 =?us-ascii?Q?FokMYFBTEhsXLdxLZSxID3Hu4nD2qq0j27hVPHqE3VL47fUNdxCWsHZdRwVd?=
 =?us-ascii?Q?ZeecSPzW/VCnfcXxjhC/iQCDpb7XqdhsWRVgBHWZcp58QNm85v9rMzXtwx+B?=
 =?us-ascii?Q?LAb9DRrbaIaJfEtNBnQrHh4e0k1lcRxQ0ou62J3HirROtbSDMNPsf2oQLtDf?=
 =?us-ascii?Q?Z8J448Xn6W595fNUlBt6Dd2rGLKEfXDGOxJOSHZsKWoL6tsP0FXiVG2TA+9Q?=
 =?us-ascii?Q?th+7/7ZijuPR3faS2E/60Cl+iHtkswtCmaL324LY/kpul9mULKwja/t9Hm2Z?=
 =?us-ascii?Q?DIQYDm0j3/FTCbQbPCDDY4XAUDmna6t4NaWX036Q6F7wCoSvjUm3cpIpv9Bv?=
 =?us-ascii?Q?/EFz9Idl6OihSSuY+kJtPFE5DOmh7iPiQ3b5+4anPMZ92bPc47AO6UZe1H3R?=
 =?us-ascii?Q?bjbY827GSzeJIr41FP0zJqT7Oi9LCJArB1lwinyLLRn5nprW4mmrL2Wb8nE+?=
 =?us-ascii?Q?NOv/kegNwMwTRkZzWz38fH+vsJOASh4gZWup27klf517NSqt6NJwuh86S+kM?=
 =?us-ascii?Q?M4IfruL9jz+3r9al2sJt66ZJ75aKyvDOJimqGtLnA0P8HLFeQzJgzQMa2/D3?=
 =?us-ascii?Q?eBNNq+7XuRTxzTeswAXRmfjdgFZjJ3Xq1zlDsX2fyhovkz9MFqDwYBkViJVT?=
 =?us-ascii?Q?WEPtM6xQOiGKqd+4LzjDkV9nwCfOCa8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9fa61b8-053e-4973-f7b8-08da2cfc2776
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 11:57:53.3397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKenrR2VIVyS1+aBVJvps7SRAsUkFvV0f3cQVvUrQLMdWZcK/oFaiiSEGjxFXvK/AawQYQkqMa8M/h8JOYWUwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_vcap_filter_del() works by moving the next filters over the
current one, and then deleting the last filter by calling vcap_entry_set()
with a del_filter which was specially created by memsetting its memory
to zeroes. vcap_entry_set() then programs this to the TCAM and action
RAM via the cache registers.

The problem is that vcap_entry_set() is a dispatch function which looks
at del_filter->block_id. But since del_filter is zeroized memory, the
block_id is 0, or otherwise said, VCAP_ES0. So practically, what we do
is delete the entry at the same TCAM index from VCAP ES0 instead of IS1
or IS2.

The code was not always like this. vcap_entry_set() used to simply be
is2_entry_set(), and then, the logic used to work.

Restore the functionality by populating the block_id of the del_filter
based on the VCAP block of the filter that we're deleting. This makes
vcap_entry_set() know what to do.

Fixes: 1397a2eb52e2 ("net: mscc: ocelot: create TCAM skeleton from tc filter chains")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 571d43e59f63..469145205312 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1248,7 +1248,11 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 	struct ocelot_vcap_filter del_filter;
 	int i, index;
 
+	/* Need to inherit the block_id so that vcap_entry_set()
+	 * does not get confused and knows where to install it.
+	 */
 	memset(&del_filter, 0, sizeof(del_filter));
+	del_filter.block_id = filter->block_id;
 
 	/* Gets index of the filter */
 	index = ocelot_vcap_block_get_filter_index(block, filter);
-- 
2.25.1

