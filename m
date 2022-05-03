Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1529951839E
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiECMB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbiECMB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:01:27 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2058.outbound.protection.outlook.com [40.107.20.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1055D26AF2
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:57:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4XVOyOUaXw9uELDPW8X3HDUpHgGRkiKERijLwxB+8ivHTKAASFRoXvMoVlFpsxoGq2246NRMEusrxB4COhJFl5IVGJuwdJeihySP6RlPRTCm9UOy3JjLtzEwSoE0tRwI5+dtGPJiBIYc1C4h3Po8g62PgibAuZDK1X3sZCbsv2KFgfH+45y/UtaCG0BinMeo/cr4wULMSg8HT6oB5T5YEJzFGeyjJjXBZ5RB5187pN5oPYrOnmBPmsnjoxT9zuFJHnGnDtI86p8LOOJ6lIfdcDJFP6LoiFnwG+BtQpyumr86mf8hDCd2QmUSA2e3p2j1DPyaAQdN3GE3Y7unHLE9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4MkwsFHZHF1/GIeId2DDdi1FH3uR2zS7u58Igkl4YQ0=;
 b=j+YSiFunH2OMI5VwqeBUX+/Pjl1idLRfWodvkUGsB1itNmsdr746o6bsGV5Q912z74zBCzIMMyUJW4wTpJanhPO0BCfIVQVsnCnbOJCAaz+k1Vx4/WkotHF6ZNm08mXrWx63PnGYVjGKWPI2hpRCw3EUoAJFRUF1F2r/3/G66VWt8mLkHbvqAWQsPbX+m6oGcF38oQWH+1Yf3vbaTJ5RqKv9KQgDzu8ofu981q/BidzFtTN2ymmLzoI9nL7758Pr1gfW0h3bdYQHpGfP0KxwGIqNnaWNIeJNRSZ7JKNcLOjf+X0+W8AVfdmxtZ/ZadiH+Xhuyr14N9EPsLP+4mJIug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MkwsFHZHF1/GIeId2DDdi1FH3uR2zS7u58Igkl4YQ0=;
 b=ELKmWXQQaiANEpatOPOll22oPyNFCP1cICBMDMPQjb6HGD5M9tE270Hp/mcBrQaqX/xYtz4+7+F8fB3KUwlR2tzIrezuCJUI2fIWsYJdG9zhRt/eggPkjvmE11/IFGKWJNLhNT8XL5nSo4eK/PgaifZMhckpVrWENzUau6+BxmE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 11:57:51 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 11:57:52 +0000
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
Subject: [PATCH net 2/6] net: mscc: ocelot: avoid use after free with deleted tc-trap rules
Date:   Tue,  3 May 2022 14:57:24 +0300
Message-Id: <20220503115728.834457-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: c948c795-a59b-44a1-a3bd-08da2cfc269b
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB4813C382E1EEDD527A283CEFE0C09@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WTcIgmiSOa8qXViK0lkCDSv/6oeRxMu5NdTlhFPb38R3d92ZlxoMsTNbDpZydI8lgc/k9nxaXJ9WESTkX1LrwpxbG3vxVcTK3XtV8xef359A61S6S+aCuwM5xu2mTQhakyttMpdlUdqIW4gsKesjXtExlBmoTIfoMs3SdVt9x6A3gXeGMnr0irFh0M2XPsC5AgFnrXAZv/6IuQQQLWufUKbMUE6NgVggkp5thvZ4EwMSUjYFp9fjT9i1CgzsAOnwsaUk5x7K8xWLp6QZMWLBvRckDnpe51VuMlWyExD0BWDod8jA5j/9YTKLTAInUwOX1Gt0WPnPn8eW6LTyrKlANZCuB1Jg5KgMQ2S0NdT2gTkKmCHIMhAccJoo8061AdnJYvvTmmFAgD1ZPuh9OCUdR9jowfAVDCcsn12WklBGP2iY5s1kDwmSvSKLgONl2YUu1Ub0O0PO7qtue9rQpU2Wf68MqNl2OpCp1PdyVdDrJzPbFvF5qWoAp57xDjz5ZaFrfUIGfWt7mH1Ymf1MDnj/S7WRGEJ0rtgD+hyXEILFq7+Q/gwIW1M+A8tD73lugDyLlUFYEbxu2Jue63O+i25HXPHiqMHD9mdCW13nC8RRhNupex5pN6+TNpW2vmKmBi0aRKNReEEtFc4SD6AR3qt4YwsWlR7GM3FF++DBLQHuzeRrW/X3a1jCwUhimBVs553D3fKM9HneBsNu4T9Tp/AJ9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(44832011)(8936002)(2906002)(8676002)(66476007)(4326008)(1076003)(2616005)(186003)(508600001)(5660300002)(66556008)(7416002)(6506007)(6512007)(6666004)(36756003)(86362001)(52116002)(83380400001)(26005)(38350700002)(38100700002)(6916009)(54906003)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WrovBL/KRnhBz1r4wlNY2iqo1eA6zUyXYxWwEN8Fawr8kA6LsnaZz6qCDcXo?=
 =?us-ascii?Q?5+PBbaufgDvmV+VkjEzwN1J5sRHPfuN/0ctfh7i2EUYca5qciYkZirJ/QSEw?=
 =?us-ascii?Q?4rjKHRu3XiPsi7wMWAaq0rBlpEx3zMDmg+n6Fifxxzw+DhK7/99KYHaCdO4G?=
 =?us-ascii?Q?vQjNQdYi5UQi+7WlkfbOUQjC1dZVwoCzdjQBHUEoaDD2NEhsbz8CnP6VUdKN?=
 =?us-ascii?Q?i6pKwfZJ8WB/Ytihh8BNGEeci3h9KPvwT4/f9OLxYVAs4/extfjDV1FRIH7N?=
 =?us-ascii?Q?6BQYaDzdynXdpZ33Ly5BxJ9FrlyxxHXu2au3n3w2RkTWHNlcm4jOdVrwJXnV?=
 =?us-ascii?Q?4KxhOtELea/8VllFtTyCRBA/lYsQMrraTG7hZ26lUYwkA7UylLQPYYW95oW1?=
 =?us-ascii?Q?diUMIj54h3zRsIIcnqyr2Wam9Cl4R97YvhrqjlVXgEcc69tPiYFdl4Ob0itu?=
 =?us-ascii?Q?cnnwUrDb1ZDobC6KPH0ogOvC7RR1u2+MShTkcKx7jGUVCzNvindSdq3fVHb7?=
 =?us-ascii?Q?+lxcAoOIP4HxbTdbR97wrqlnRmbVcmsYv8V6m4tvak2r3dVrPw3OkcFJmOPl?=
 =?us-ascii?Q?+ab9BG0ge0iy9Yx7Wot3pqQDq63MyBbpgD22IjKDRF1+gCLo4Le+3nY9GttP?=
 =?us-ascii?Q?P33izu925r+FEpCo7Inl3K+ReN+/iZP3t2/9nv9e6E1+1ZRJVkSVSDptky/+?=
 =?us-ascii?Q?rrcCed0Z0Sehc8U5DA7f7vdRbmqLyzAm8dG5FlXF9NjRTsLZ/c7hOfKJi0vW?=
 =?us-ascii?Q?H15B375HwL9jqg6pLJI2tv10HmYHvK3epVgi9mX3Oiii8Aqji49JR+aOkSKh?=
 =?us-ascii?Q?NkcQVtt9Mg0XRhR2blDtYX9ybuIXVGX9ZDk8Uwt0fK4qXQcnf0KT/ZOTifLa?=
 =?us-ascii?Q?Tr1uy8DOPNjs7rEjJQKVa2ShVl0DG3OrRF3dSj2cyg+OoQpjRhbfwH5o2qqW?=
 =?us-ascii?Q?oED0a67HbE2mfpAGOd0LjhhDM8jZkYEfl7MRb/aYon/mvGXxTaSAaV+6AbOy?=
 =?us-ascii?Q?aOf1tB+J5EiJu+Ss1UL/28rbkd2D2G7OhomVHM7k61rpQWsZiR/vTo7tQI8O?=
 =?us-ascii?Q?lvEl9o14z3ECqR4Xkjj/Lb/1lenSo5jT5FC+/d3tsXO7BXAk2LE/Obm81LfD?=
 =?us-ascii?Q?OmN09nnjPY9DS+5Xs2edsHgFvx21Jt3JRcgn+0C2ZomC5rZpoTxkUol8FcsB?=
 =?us-ascii?Q?h9FKOSw9fr7kR2ui+9dJNZy+JKiyTGMg7PoRdxhOiQmTxEZ7V/7RJRpJNcpq?=
 =?us-ascii?Q?yYpTJfZu3BXv9z325gjo9A06QXRKnrricTl2AjyVlJDvKrkYW5gEPYD6JnS2?=
 =?us-ascii?Q?bo2rcpSYBplWV2aNQ9nfAFn52C12aXHmKQymLA7Cjtzl2lfhQnQvgKWSMq2r?=
 =?us-ascii?Q?F3bov9F9WHUpOzT6+CnNpJY9M2Claqe1mIgR64vlL6keWOpWAx041TfJUEw6?=
 =?us-ascii?Q?QUEGGs/c6FjTaPQJWXBRJVJFQfNqvv1NnxgzGdep7mAs++0I4JjDqMM00UfD?=
 =?us-ascii?Q?77hwM5VbZed/XmIne80rvWX6EjfLBtR82lk/rbsGcANhEByKshH/cWWJc5Rb?=
 =?us-ascii?Q?fYQ37TaOKvIFG1KcNCdxpQ2K1Dm3y4TdsyHbR7Z81Njtylk5ueQAFlaadoG2?=
 =?us-ascii?Q?7UMVH3bq+AwF+NUN6FLR9+/N62H7Mj7NS5RWUqCSaL9atxtL9O08YdS6Pi+x?=
 =?us-ascii?Q?hsur93w1npXvxfGoB+55C6/eG7IepEkV9DFADx5haEu5CIK6nhV/nvEZcWHP?=
 =?us-ascii?Q?vnpcrXdKeVdASxRAaV26xszDHgGeirA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c948c795-a59b-44a1-a3bd-08da2cfc269b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 11:57:51.9492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Ti0G25AiDE0y3eN86KnUAp3Sy2t3t5bgtGRvdxCRUpuWm7633LOTPGcsODydcHtCu5h546gz5voUfS3yCy/1Q==
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

The error path of ocelot_flower_parse() removes a VCAP filter from
ocelot->traps, but the main deletion path - ocelot_vcap_filter_del() -
does not.

So functions such as felix_update_trapping_destinations() can still
access the freed VCAP filter via ocelot->traps.

Fix this bug by removing the filter from ocelot->traps when it gets
deleted.

Fixes: e42bd4ed09aa ("net: mscc: ocelot: keep traps in a list")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 1e74bdb215ec..571d43e59f63 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1232,6 +1232,8 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 		if (ocelot_vcap_filter_equal(filter, tmp)) {
 			ocelot_vcap_filter_del_aux_resources(ocelot, tmp);
 			list_del(&tmp->list);
+			if (!list_empty(&tmp->trap_list))
+				list_del(&tmp->trap_list);
 			kfree(tmp);
 		}
 	}
-- 
2.25.1

