Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C7D63246B
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiKUN4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiKUN4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:21 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D319BFF6B
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lro3AReW6CElY/KaMASLLzq0FcmB8Ta8J/ZshjPHvH4ZkqrDOejcZ4ZiQwrbj7o2iCQ7dh+ozhSlFb0+7Iei0IAwe2yIqxfNdrh8pI5HQnfzsaOUPbGPKuFBN0TSCRb2JPsxnrpd2yLSULRwIPrFFPnPubie8gwtkjNx+Bsux8eL91sxzQ/mYnNr/iEQmH4SQ5P/XtKM2vHvC3L5aZz0Hx5DSn68VQmduo3ukXNkjUhkfdtPofWSTdbhYefpWYMwwjAF+r872XYMWF3MuoybL4i03SEUfDTKqMXKbfC7aOJP4Gtzup5WwRZCLh5szJ+kDm9dlhhDZv1DxLblSXPDCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIvetNs7Q+J3pRHEeWzDkZ6Rsg+XDAgCbO35wD06v5c=;
 b=Lnr66wv3QlygfbV0uIbnGsByMt6DY5SyDKC0yXTnXVm3C6RUlJhc1Tn7VXCMIfrt4yo18lUZRMGkZTxlfSmqIEmEClgtis6gqcWAY3UJ12rZFbHyTGug9KidIrznWINNqyW4WhZ3+Ug2B9EWGEt+cFi3uF3DVWGaX2HVeKKpmndNgZ23gOC+FBDeeHaJ6c/Flxif7VUr4nymPw9FPADAVPvm/JT12rzzz/b4POPlQ5S42V9b4Y9n8lA4aI5XZac+SGpNxspyrSpdnjiGTilNKII+0f49RKXeW78WSWR4uuuBsM1cjRTmLxC4D6Sz/wn2J/i4BXrGlE8przzFxLthqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIvetNs7Q+J3pRHEeWzDkZ6Rsg+XDAgCbO35wD06v5c=;
 b=ImLcbDQ9g5zLbQd1NJr1/2kG9LL/+6d1c2zbOT+SWUKVC6u4NHFBrRFGaqdp2LUKKSYzNSkRrf4wJ5ouGCES+kbay9LHcvYaDOCPjfVyKM7iiM8FQi3uLxVqlmNRdI7kQ4FpnTEl4xc1YbfcXWKnVTvz0oof2NBDBrEzwQbrteI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 04/17] net: dsa: if ds->setup is true, ds->devlink is always non-NULL
Date:   Mon, 21 Nov 2022 15:55:42 +0200
Message-Id: <20221121135555.1227271-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f32aa8b-165c-4f21-0f3a-08dacbc827d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9y1savaHkCPHacJN6nr5SzEXMl1B0aku5tuo63Q/6G5dG2oYPtOl9RpuTGyZd0TRfn2cQEm4uNTKuIoM17LQVG7XsdK6W179X24Z1tWsjAdjwsXwBexpNX1Y4LdXEir+vhdkOMDEXOhGzjEuqNPM14FViDSErA9Xgq0/zy5pOpNwP9tX950KRBOYN/Hp/d97/Y5UvDgvG0RMT3J8cSCHPEJAQZ2WOPnIX50qe+KSOSaVQfFvkDbiXnwdkYTd13CO2L66YMaUuNm/nqarKvw85b/2VUC4XVGZwJp8IGPPrQu4ZlCWQp9cTPINq2pg3NAFf3Gon5R6h2pe/HSORgXmntSqIaM8voV802iPuoTvlR/DZ/L7BbsTtamGM8Xlc5PuIY0UMxShD/Ae4Up9Vmt9OMnHNA3qeG0pRinFDLSoYFf1Y9rY2Rhcbr8ic9f9ZRB/h47NB0U06VLK3cH1EpTH9FLbSRwiKdD7VgNFk8ns77qHAHPnqRQ5P0ksBEmMN3z+qBsyQyVKgpgbcpYA+GdwH++tfQ6DJGKsYGJYT1vlxpMMl6l39dOBUD4TygoHkN6pYcQTGjzxPWf+8U8L6y6oza0kUzrhpxrg4Mq62qd7PgLwCA31sussUUDnF3W2T2bctsWCtcWWQ3gZuijUMZKnMWS7uCHya9DiCqYpH5Y+MQWeP+BJQGrCI2uR12lr2clx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KTrpcJLYDPnxk32xM0VYu/adpRq+SM7rHEvJrAwkBH7QmgOgZwP+C/quueHY?=
 =?us-ascii?Q?kVIRTymqjVth5omYTxxhJlMNRhPoIW23Kgr3eb1FXTFC8iZo1dMZO4jItogq?=
 =?us-ascii?Q?Pr5tWQqL8bVMvgvAW4kw6jhByK+G+x6E6qcEPsuRRuYvyilILCPeAHyPefgX?=
 =?us-ascii?Q?nP8zA1tvujky7dmLNp8BWW48YSbyJaWuWJz1CpeMV5bBrnY7Qa+pev1IxZGo?=
 =?us-ascii?Q?z3V8TxwzC+GndA4Eu0KRqKBex+2UcOHk4i9qgS0unRrOhq4XrqLnDFIdSla7?=
 =?us-ascii?Q?2svjN4yRXY9dtVw8ijuaeZ52YDQRbr4zv+YgaeqhvZunfEHxsvWBR7PkaRcU?=
 =?us-ascii?Q?sAkiIewM4m6M/0Bt90CasKmVIek33qAQBgPrVWgLy1AGH3+SKDuqpdUv/bni?=
 =?us-ascii?Q?0teJWGn0p4Ij79xB6Zwo3I4zDZmJZv0bWRQHdTV9pCdmxjXP4g6ThC8+8vku?=
 =?us-ascii?Q?L1SdTtE2PoO/99ARMJZB45GT920FSvc578ZK2GkpIhQiS/0IZ3NO76A93WG8?=
 =?us-ascii?Q?PzZkbiR7O/Tl6oPd2PF+fR/Gq0EjywSRV9B1ajCauLL9/lkH39x6qvj0qnJ2?=
 =?us-ascii?Q?1Q4w1DT+i5tPaXpTtJNGPOGLtKc7+h4becF5iWFikaLVAPQnFHKOhy1yGQCH?=
 =?us-ascii?Q?g5CmzPZrACarI+/nUqkyLEa4ueA8p/dkh+wFa26XWoITG65kd2ao9+RsE7Hc?=
 =?us-ascii?Q?YSa5gl+6RAttFxeOQHt8f9GWqS3NrAIOSEMdmRFMy++NI+qaoVIZZpNUnOiX?=
 =?us-ascii?Q?iHwN7Iz3/hskevpZihynphHAuWnwx7dCAj1pD4YchJMjC3m4Fcvmp0bisI9k?=
 =?us-ascii?Q?EAwuM8ne/G9xrEnaaAmJS0EYtayP+5uaM9No0qI90RLebchOg02GBjhRJOLi?=
 =?us-ascii?Q?1dTzp1eguC7u9UjQMA9f6YB/7w97TyWDsfF112nV3VzRPacF7szcyREqDZgx?=
 =?us-ascii?Q?+oI12NZa0T3grsNrpcw5vJ1Z1xUlQkOVQCX1ax8PtG/TdHKr48ds3/+WhWyn?=
 =?us-ascii?Q?z6SvqwcSaVRdTUOtJWPkMZKGR+65lziQOfS2ju8o5m+yzY7QjsFV8AtKYxvQ?=
 =?us-ascii?Q?Lhoxv1NzI8C0o955ecTPza4U6hhLtaIsCLY2GmSK9QBKalDCbmVEHEj55A+R?=
 =?us-ascii?Q?se7eNMGJpez0SfaouT9f71NO2v0LtRwpL+n9vj4iMFlYxdrALB8xxLzSsvaQ?=
 =?us-ascii?Q?BbtIEDzBd9oCYavMf6F3jSuTO0y/CeLAW7PsxqjfHFL8ZKjnAOmXsPXi2/4U?=
 =?us-ascii?Q?vq17NBF9+77h6o4Syrrybun3EvfgUrPx9dqFIKRgxWSWqbumlhmWW3OuXQKx?=
 =?us-ascii?Q?iOPZdi/o7ghwd/360lamrMM9OwNYgCd3GZHtC//oS6CaJOhO5iGUV6DAQGB/?=
 =?us-ascii?Q?jc8n961/lNM0ut48XvW97n++4CQ7mD2lRCFr3McZKR8NgehRUgzgpfnaIylu?=
 =?us-ascii?Q?TsYxc34FoxKxFRBp9StIO7Vc7n1ZIRc0MgtYy7qDUq+cDfYTwBaI/lbidr4t?=
 =?us-ascii?Q?5f9J1ZKLOqgnqLQ8Ut1Z7+5icHFkdiAYTOeA1W0u5gQ/gIoAF50PV9lc8JCi?=
 =?us-ascii?Q?fYuMyO2Jba5m4KJBYJN6IsD8rULNESsLQqZg480IX5hU2MNz2ntGxgdjKxOE?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f32aa8b-165c-4f21-0f3a-08dacbc827d1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:15.1381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IPj8E5MAKEfvU9XLMShhjdjUdSYnzxsA6E1gcFrC09hFoUKfiwWPy6Yy08UVb/dXGwLa5eQ+Z3cZLCqu9o07Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify dsa_switch_teardown() to remove the NULL checking for
ds->devlink.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 05e682c25590..f890dfcbf412 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -682,8 +682,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 			goto free_slave_mii_bus;
 	}
 
-	ds->setup = true;
 	devlink_register(ds->devlink);
+
+	ds->setup = true;
 	return 0;
 
 free_slave_mii_bus:
@@ -705,8 +706,7 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	if (!ds->setup)
 		return;
 
-	if (ds->devlink)
-		devlink_unregister(ds->devlink);
+	devlink_unregister(ds->devlink);
 
 	if (ds->slave_mii_bus && ds->ops->phy_read) {
 		mdiobus_unregister(ds->slave_mii_bus);
@@ -721,10 +721,8 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 
 	dsa_switch_unregister_notifier(ds);
 
-	if (ds->devlink) {
-		devlink_free(ds->devlink);
-		ds->devlink = NULL;
-	}
+	devlink_free(ds->devlink);
+	ds->devlink = NULL;
 
 	ds->setup = false;
 }
-- 
2.34.1

