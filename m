Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F130F648B7D
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 00:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLIXxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 18:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiLIXxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 18:53:04 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2075.outbound.protection.outlook.com [40.107.8.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41DA167C9
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 15:52:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEi8VOMaN/zCxlc6XcuVyMXQtQU2DVUq3OwYlFE+E0LZhNhq/jnZuOfLidTNI3lQV3WfuscsYgz8ahQFdyHBASUNyRZCF8W/E1zOKmH9OGoh0b85mhbV5u8BApNdXJulD03URkjLffUVjMah2Hl1L+ANo7MATWqQiCXp7e9gH+x5UnuuvqAKYxt/UmlfXst+CAhH/g4lPtNtsN/Eq1mRWN3ob+1x6XMFhrG4b0Ci8wwQmYCJHPxZ1UJGpFlYGC4XmaV5u1UJwKKv0rfUJxIJ7C1zjaa+GPRu2e57Th6RlcqXFF/VWT+eym+v8f6wCOAnoDk1zaq1PLT8BTcLTUteIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIj+owofPLIhnxtRKgoodzNU5rDC4DqIgCCVCjJI8zI=;
 b=jNZ/IGm7aLdw3TTfi3gkpEIINX/U6Hhop2DMrl/T4N5cuqo0EJkD4ug0KkbX+tZKsfjBR0iqn2T4tX8QwP+vh6RuFo152z0PXAwCljBP0g/8JrBmBTj4cDgwbdkPSgN3oI7Y1Z3gn/tm9tL+1aFXLlxo3wGx/NenOgdnfyOyOTVhI87/qgLKuHJg2HvVEhcsTGnQXBuhcEvhtfyHdunWG5P7CU07/9GYVwvaJZzPDAlnXEATwWNZESjSu/Oqmixevh9hM80+4bTfBa9CHqkt8ysyMiTjWMFPpj5U5ej2WcHNwqNX2hleZJ9I0bC4Z6jbDa9/HT8qGGI7wamKhqux9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIj+owofPLIhnxtRKgoodzNU5rDC4DqIgCCVCjJI8zI=;
 b=PleuJ21n2GWfI9gi3zMasKpF+FXKmlWrNjvGSjbr9If0H6Q4ownYfiavFOH9wMDyWkrXhlUgoy523gfuxAADpER3isUDM9cXAKaHFAzpDag8tfuSiibzkR1xEwlWPMt8EnFeYOb8G2wC6oF9+7w8XFOCOuF80owhBQcnQgA2h6U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7062.eurprd04.prod.outlook.com (2603:10a6:20b:122::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Fri, 9 Dec
 2022 23:52:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 23:52:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] net: dsa: tag_8021q: avoid leaking ctx on dsa_tag_8021q_register() error path
Date:   Sat, 10 Dec 2022 01:52:42 +0200
Message-Id: <20221209235242.480344-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0060.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::49) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7062:EE_
X-MS-Office365-Filtering-Correlation-Id: f85df0b3-89c4-4351-7c0a-08dada407bb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ccz3ivU9beuYMDUcqgnDol8jtKer12VPk2pylHoVw8+dRlNWKlTOZupw/7ctZuWoyLQazOSLz8qyD27rGd1hcwUnEpCqGopNZggkWQDvWFDknsEKaFTmwP1WUKjJ+/9KTyOS4k9lAq+l+iLR8vXauts5ffTSD3AcV0Mj+m1932joHkiwaGPghF8dgs3Zhcy9d1OfqJDcB2RiFEa3/RsHe2kQZfgXJrZmiaoZIIUjJJc/94Xio+t/KM/l6Ksj/vKrWhsx+oEwn7WEkSVOdOqXgcimbVxMhhF1i1/WLzFbzJU6wKqzK30B3loQylok12sAwogELZ5zwp+/ShP6bys/7sVAJCdmKPi1yMD2rnlL4ykG8QHXzUa0GqWJWtNRXdBvKjf1b+hfsLxuaIvYuIopozgBwsFeQAqPSCwP0WQIXleyxPeo9xES/d2lxAxQFoXWUdxzqiK2FlNV53Y8cumkRlYGNMQRpOZCbBQtBW16j3my1/GbBhN076DBK4x5noyPi0LYCwgwbxbbVG7aK4SnOUutM1zUkgnAStEHTaA2gStAB9hFrcBFTcywo5PqJ2JD4MGtHUK/Zc0cGbDGO3KFhfA78tNfwTangYLO08ubghdtuDbj98pOdgvr3RZdk9+DH7QiuII8toBR9sMwoik28+qDRSuaDwxnk3lDsHfI6YeREBB/EMz0HjHtC/0ltx/mO/IWirqxYIUJAvET9l8c+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199015)(6666004)(478600001)(5660300002)(52116002)(6506007)(6486002)(26005)(6512007)(6916009)(36756003)(316002)(4326008)(2616005)(8936002)(66946007)(66556008)(8676002)(66476007)(1076003)(41300700001)(186003)(86362001)(38100700002)(38350700002)(44832011)(83380400001)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IBt44puj2SvRPQ+B+4v34uQIIEBdQu9i+LBH/elTp3WypKB6m2S1OjKTTopj?=
 =?us-ascii?Q?ScpT5itgeao1oqOzLnce5lJ956/YzK92rSYprQe/rfw9TQhR19Xz0+tUIyVV?=
 =?us-ascii?Q?DqJe0X4J24BjF+VdfRIlvPvp266eI+yBJabfwBuNGT3P7XYr/lypKAJYnxYC?=
 =?us-ascii?Q?j4iPixVitbt4vWQRpfYDbBSxfIEusYCx1AGy/fBOpZ6tMtMrPmYeobE2Uz8z?=
 =?us-ascii?Q?Rodk68vOLNkC3vTmNLZJsAbP/oRE5n9NHHNweSEfA8hwc0zgRD1WGQzoy7ln?=
 =?us-ascii?Q?zsavvm6lsCfUAq2ZDMSbjCAEsmYvDZR+zU06kKkL6dMUjjrq45MYqUWvTvM4?=
 =?us-ascii?Q?bcT/B+AzDlbCVUGezEcS6Ex6wkcMdl2ZGEW/DWC9zYnQerKuxoIbeqtdxC+R?=
 =?us-ascii?Q?mPeqB+PBAixx76LLtJok/nf11/EisyzlY4FIhXC4+bSSh6lkx0iJ1VlIQd40?=
 =?us-ascii?Q?LpO9gDHGiwuzZWQ4ZLOF87qFIAHMbYyxTlcerQCCHbfvdXQQ/pTuE9w96+IJ?=
 =?us-ascii?Q?x2jWLDrKGjkN74OWwEoPDGtA3GojgvO8dA+LJdA4bWyWq/K6HDX/dDfLkt01?=
 =?us-ascii?Q?dHMyVBxhVfMnCRSzlGfCxWDQsIYkTgJFFUiTY9qP9ynrwsl6KMnrMnSP9dnZ?=
 =?us-ascii?Q?nX350yk968dVBFEzbg3PCZLQceAA1w8WZm6dY27DiggQKninkPifvtjpcva9?=
 =?us-ascii?Q?0pqcTELAd8igBFlcsYzJjIV3ZfumSc8RpWsJntiq4dHw8kgqwEvYnzc2hjBY?=
 =?us-ascii?Q?weKKfL8qxO5ZaGy694jXsQse+IHvykFWio2RAs7BGnHMkFvRMkDR2Be9Lymy?=
 =?us-ascii?Q?3Dufxw06ST7aZPFbwe0HxSLiPpf8EE2ctOB3/aut9sZYzXJtemjVqvhEgjeI?=
 =?us-ascii?Q?BCduQfdOIkobqByvb3oUc03d5jU0J52AUSzxVlVdUmL8HBTl3OaDSnvd3E4Q?=
 =?us-ascii?Q?KxhMg6CC/djuEB2wDkf3gx9aHOn4bN4lz7XZYJoeB55XQr7UrRcchr88cnoi?=
 =?us-ascii?Q?EymLrWMYiEqWQOxQR7O9bFgIdXOW97YXIgam0ZaF2DE+2ioqrUNBHdyzMV5s?=
 =?us-ascii?Q?5fjuR4NfXovLi0msmcrmDaKuI/Gm9C4Ou2aNgRTxWkz0y6JdiRO9shc1UL5J?=
 =?us-ascii?Q?+GV91HK7xl9oH+Xvlf4+82rViBeraoUY53lY5zZMhzEqiRnqBZK7g0pEiM6R?=
 =?us-ascii?Q?XPYN7ZLBqHqj7CfzV4RcBc0ucGwwb4C/iXWwcq7yeKRjZ1kDI2NG9CZVeakB?=
 =?us-ascii?Q?FHgD85QkLM9PvZtCQzR6PqP2CuTIAxclfGsr0MgOxyrZJ4duzO3D5Mu28Q9O?=
 =?us-ascii?Q?7HIPv3d47u/jCwoNB1+EVly6koB83dSstU8JG/NxRGKbAeataW+KEK2xgEAN?=
 =?us-ascii?Q?xCfNFQuaRUwuJ+2JdZzYXPxSnaQEc/lxSAFrpZkRW9yTNvSxus4h3mXMpUHw?=
 =?us-ascii?Q?8SIKnTsH0/WLoDDd7BlC0KzZ6QQ8C+MO9xmW/dG8R7q9sJtNV8BBaqqTICDa?=
 =?us-ascii?Q?CXx3fD00d/SVtyG+2K3jGeYhtRt+t7Xugy/ssbcTBvYl4BgxL0c3m0Hk2S95?=
 =?us-ascii?Q?mR3klsLZT3P4WBL6gbuhyp18xdAqEP9x39edudPZwknZjx/mrlJ62tIWzJEC?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f85df0b3-89c4-4351-7c0a-08dada407bb8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 23:52:51.6983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yG+vM57E9Yl7FFIHvv5Wq4N9Eh95Luk1UMOwW9UC2r7DZLY/Mt/zsKM4/bn8ViHliDsVZ5bjv6BQ6WvrjYyJMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7062
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If dsa_tag_8021q_setup() fails, for example due to the inability of the
device to install a VLAN, the tag_8021q context of the switch will leak.
Make sure it is freed on the error path.

Fixes: 328621f6131f ("net: dsa: tag_8021q: absorb dsa_8021q_setup into dsa_tag_8021q_{,un}register")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_8021q.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index b1263917fcb2..5ee9ef00954e 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -415,6 +415,7 @@ static void dsa_tag_8021q_teardown(struct dsa_switch *ds)
 int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto)
 {
 	struct dsa_8021q_context *ctx;
+	int err;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -427,7 +428,15 @@ int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto)
 
 	ds->tag_8021q_ctx = ctx;
 
-	return dsa_tag_8021q_setup(ds);
+	err = dsa_tag_8021q_setup(ds);
+	if (err)
+		goto err_free;
+
+	return 0;
+
+err_free:
+	kfree(ctx);
+	return err;
 }
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_register);
 
-- 
2.34.1

