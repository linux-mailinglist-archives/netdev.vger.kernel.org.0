Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027FD6434C4
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 20:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbiLETvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 14:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbiLETvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 14:51:13 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2053.outbound.protection.outlook.com [40.107.7.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C494E2B60D
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 11:49:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGLuuABHxKGRYLhG5BuQtKkMdnW+G5BUwdfT/PkDg+cbp6un6bKPO4AYVt60H8EMJH9ssbx3r3sU8uHx62wZ8VfLe2kHZ2Arxh1f8nPVU+rvY8CGPfK63lBlkaQOh6UsmV63Iqz7mAa1UzV46VIAzmZzxs0CUtE6EdBQxF6UoLdmwIIeQxq7/K0WfKNl7qqtzr3M8ZODUlef9TLOyXTOQ8O7rWfTAro6W5BYHtjmbF73ScuVagu5SQF5lLnzfO/IpsHt+9yJcPxzVM9NQgAyyb3sZR5Lmb1JtwUx8IG4TIwtLQPJAR4zaPsbHRc9WEupLird8LIA6Yu2Y2NnCZbHNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9DnTG37Wd/yX8aDwww+AuwnJFSIdq+wAjOHpvRFFphE=;
 b=Df6SJFekGZx2ysKtB1d2MA1Pm0gckog473NEpw8wELyRqhvPvDjXZtwhSW9O4MWarFQ01SDcta+birucyNL15qT22TGUetdT2kHRbXDBpu3WiOAVIpNhH5GlU2dN9TTjb7nFGS+QuOyJKGkBORPXlmlirl2h0Xk5FuUUcPOKaNO59f2rpC1esGkcGYTwbL3dcyXkVYT2t/5OPP1KJmIhVdd2mPCp1x24TRELdpdVUh0Xe6kjH8gI0XoMNUXojWeNxjEVbv+IEGBGBX72fTy+bS8Yr5JSTBCqsVRPFR1PQP2V+8PcKtinwiOjPjJvvNMAmLXobwJEimUUufF1BTG3AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DnTG37Wd/yX8aDwww+AuwnJFSIdq+wAjOHpvRFFphE=;
 b=atIci9mta7SJBWmzWzOQr6PFSdRmY67JWldmyzWCJ0a+ktqcc3rVV8CHyL35D4zcS8GTcCwzPxT1QuRq/dKFYW7JAxtLPf41LuygNvxL1hnilBr5l0c0NfK3KNk/D2hMpmF6PZxXYVZPzjtYmE43Ru9IuE+nYHxLeoD09e7TG34=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8874.eurprd04.prod.outlook.com (2603:10a6:20b:409::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Mon, 5 Dec
 2022 19:48:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Mon, 5 Dec 2022
 19:48:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH net] net: dsa: mv88e6xxx: accept phy-mode = "internal" for internal PHY ports
Date:   Mon,  5 Dec 2022 21:48:45 +0200
Message-Id: <20221205194845.2131161-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8874:EE_
X-MS-Office365-Filtering-Correlation-Id: 07a7d701-41fa-48bc-d981-08dad6f9c07e
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rQgRwupSJtcRnfwWGLKquvrYDyIqZ7KBE1Y7oBrVJxfYfz4cKn4i2IzdjRe2L7Q9pbrQ5dJKpvoAAS4nQya5GmSHC0rWSXq0uHnDiWtXg0yIo10Ls6H6EZ0hWgXGPMVZdokQI6ftDOlUglwCBJhUvShTd3aDSvGF1XxyCGMpxtJbqlPEnV8/P9VGJvzz02169b+yKvkoLrVBTylZ0SVM2g2RgywXh0S3B5EA+SIe4KkEjpxwIV9lfcPZF8gONEVd2Xjdcl9+lsFMywPRqpg/Dbv1QRozjDbQqDbDVqCqHV/9UQEyL/aLgO9J/bTAM17F9x1bqg5Y7fxwL++m5gsOjvfK7TpCGK/xbZo+UCjuBzhazqB7D/H0BWK4eafqBC/d5yAwXRJ3csXaSihnNm1m/5j6F33cYNU1qN+JAh35dV4CQA6pbCxFnrKwoaQdJsHjO6pL63tTtBu7WwLypTxaze6o0UkNKCokjSo9w0lLObuOTV2lRjSZ04Wm37JPRZ131ZwCivxVX4hYIYdtYUCbdMuhI0dbB4crISPt6etfet1awINrQp4aSRGhaYsXzDJMab/LEbNHAKOAVmsMHcYqhlFOO8DVeu+6FWTZLnKlZplojbNXKsXBS1sdFeoYIYwujVp6IPKUgUXzlxK8SgVdH7w5P14a2xb9WqhWSgpaAqkvBKEp2AZtxWhTaE+LSXm2sTg/Z1fEb1+SBB4JlkvRJGUGL7qdIB86pbGsYCgSLeY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199015)(36756003)(38100700002)(86362001)(38350700002)(2906002)(41300700001)(8936002)(4326008)(5660300002)(44832011)(7416002)(83380400001)(66946007)(66476007)(478600001)(6486002)(66556008)(966005)(2616005)(316002)(54906003)(6916009)(8676002)(6666004)(1076003)(52116002)(6506007)(6512007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qzYh7z4OUIQR6hQ1cv+HoO9ypVvkeS68KD6xPkSxKsEh+r6wJ3F7Eq1OWexr?=
 =?us-ascii?Q?ARulqskYEoCKgiMDryfwcKxsRM6kYZFp8gcUtuMAnmrC0En3kfavi4uwNZ/4?=
 =?us-ascii?Q?GFr+9CmTMsisN44wrP/wqOuM0Lbuhk5DUTPQVtYwj0xYCAJqEsnEAxCtQc+g?=
 =?us-ascii?Q?Kfk81nNHBDP6D70ikAms2Lr4sdXsAwjYesYYwqCh3GlBGcsYK6J+pCg+83cY?=
 =?us-ascii?Q?51Jzfy5cx287HCvLLqkbHyRfXF9ZWNsJM7BhUcSdcCzG7cCFX+EgIEmavsY1?=
 =?us-ascii?Q?z6lwEcDJXVUjyAPwUEZgGl2u4YnzBrHMHFcDNjy7ti5l928Z8LodnK8m9xh1?=
 =?us-ascii?Q?naC2OJy+2vyyDwGACZBqqz3bHbIuhoestmjAl2f+4lqAHdp/v3hdSoDznNCg?=
 =?us-ascii?Q?lTa99JsLQf/3+fXdzD0Wfb7+MHj8+B2mi6U22IhKO4JrlM7Cy7dIoJ5WKlX1?=
 =?us-ascii?Q?OxpkO/8s8dVFTCc4o5xGj3KoH9G7+oxAboKfCJA7W2Yqn7Ju2p//8IupJ/Ty?=
 =?us-ascii?Q?PvKrGy+owYk1+ODaRANI7NW+19Y70Y4EDISNJ05+yVvHpEvDqi51WiIALRUQ?=
 =?us-ascii?Q?G8g9Bjk/sKXjAfT5qJx+wAtR74/oSeUMfqjJhDC+d04JdlbHH2lVM9Bf0Gke?=
 =?us-ascii?Q?peCtVDzNayaD7PYX7oQnz9W93KDn7S6MW099LgcUwm8hyXdjGyhS3d4WQ8xa?=
 =?us-ascii?Q?5xv/cI1TKKhRedGBb8BZpbT3jr5gG19+WRzOcOo2J//P5jQGn8jxaD8QALEU?=
 =?us-ascii?Q?fi2tFqhT3l4FwHGiMNaywvnZsdEbo+G48y17mXUUjs7p2lgxrv/WJDdnxQJP?=
 =?us-ascii?Q?dlig47A6WHKH+0r2gd0AydUwygLQgeJGWX7xPlsppo6OYDmbDv0ZuhYmfMS1?=
 =?us-ascii?Q?cm4EgPhC/JdbZBDp2U5ecVDlCsRwrYHolKKLiHSJ2DjHygLIwAwKtos+k5Ll?=
 =?us-ascii?Q?/yQNbtzdtuShk/CJweehrytbcy/JY0ZNDjgDcjlbtK3SuJwjaDga3ClvKIWj?=
 =?us-ascii?Q?ZnWNto92sSsbN440QqrGVNTydrdh1CpCK5/Qpha5Am2eYJEXBp+xJssa9f3T?=
 =?us-ascii?Q?/WNzIA2t8Ies6wBeymxD8RgPygTq0YLY//M6ncsz7eBHsREM9t9tXqV9koRX?=
 =?us-ascii?Q?mc4L9BPZx+gpmoyyu4T3my4DdaqYJp3XxOl4hwBgxHDJhTmeinYfcQrOsfcx?=
 =?us-ascii?Q?xPV6mSYThaCCe8WrwrpvAXiRPXDKMxh6EEKYy0npKaAXibkJg+EP/QXE2vxA?=
 =?us-ascii?Q?FIVobTQjiNT4MSjW8ZoLYKU6N9Ku7O0LjuIh89IGD8ulK1xvlZb9DzwhoR7x?=
 =?us-ascii?Q?fJ5hV3m3vTAiSwHAXnl0Ngm4cFjK8l+H0uSES6qZ7SSd+5YLbSATU9t2geRS?=
 =?us-ascii?Q?z2GNnbNNvUYxMP2dBoHwkhBoCm8wzAxuhpxqMlOBxroMd/jcFx3iAOdeDq4D?=
 =?us-ascii?Q?8C4Uu2V3qzUVKyqFvOmRPvqRv0FeSt6qOpmg311K/CMCK5EhLAEpfYoV5m4o?=
 =?us-ascii?Q?cNULjLBUrZH7F6/n5ZA3JtdYdJNYZAkpzmBzhfaQeHHbZWE1oxxxXKBJvsBJ?=
 =?us-ascii?Q?k4otu+cOPCkcwOovapLG812lYMx377uXYxxM0sMMmf6BwYUwN/VmzBL/IAyS?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a7d701-41fa-48bc-d981-08dad6f9c07e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 19:48:59.2804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VAbbdHFd2lOuWyYQpCN4poblu4/SGzs9Qzzb0m33aL3PM5i6dq2NyYTboId5djhctyFg8uJ4t6rRpmJK+Nf3cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8874
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethernet-controller dt-schema, mostly pushed forward by Linux, has
the "internal" PHY mode for denoting MAC connections to an internal PHY.

U-Boot may provide device tree blobs where this phy-mode is specified,
so make the Linux driver accept them.

It appears that the current behavior with phy-mode = "internal" was
introduced when mv88e6xxx started reporting supported_interfaces to
phylink. Prior to that, I don't think it would have any issues accepting
this phy-mode.

Fixes: d4ebf12bcec4 ("net: dsa: mv88e6xxx: populate supported_interfaces and mac_capabilities")
Link: https://lore.kernel.org/linux-arm-kernel/20221205172709.kglithpbhdbsakvd@skbuf/T/
Reported-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ccfa4751d3b7..ba4fff8690aa 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -833,10 +833,13 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 
 	chip->info->ops->phylink_get_caps(chip, port, config);
 
-	/* Internal ports need GMII for PHYLIB */
-	if (mv88e6xxx_phy_is_internal(ds, port))
+	if (mv88e6xxx_phy_is_internal(ds, port)) {
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+		/* Internal ports with no phy-mode need GMII for PHYLIB */
 		__set_bit(PHY_INTERFACE_MODE_GMII,
 			  config->supported_interfaces);
+	}
 }
 
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
-- 
2.34.1

