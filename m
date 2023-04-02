Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5716D37DC
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjDBMiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjDBMiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:38:18 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB5E93D1
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:38:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEY5fdOZ4CskLrs2G271RdOR7t1Crd6/nbXNszvciWFPcWboER7XZiLPBVJzRSTMXhmndQqkNazy0G2w59PeD/dfv+do0CskFkbgVg98O/1r0WtxS6ang5voK6aZuxXiGYuMA1zKuKdOWl+d+svasKdEtg/hHnAdQ+l4812Ggr+wBzMZUSCVDe5FmJ+BJbG3Qh94C2WyRXQ7xA+yomnzhiX4b8kiSSM7AZS/DOZayBqiB1RR3SiC0HpxtNm1eYR45U33+QjwP8US6qsf7TX4sFzLxjwAgRF0UAVJMep+XvEjh3iiM52MVQD8x0e7Y2yvBndl8D4fIcosGD0u+Wy8dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJKZ4jScCOD0QKMA46fdwXTSUx6h+4dMxubnj51ST+0=;
 b=lB1otC29A9ax1Cotz6D7O3xBgoEjf80hwrFfWGlr2Un+yg2j+s4B4YMA8DhSgeGHNdz4karBTp5FXOaO6TSgM1W6tw1ffk8pbqIpXzjaltyQhMSNRHHMS5IgmLsR7zASllGC+03oIF9e5VKJUg5Rw/3KN0ja7sW5J4o17N0Cbb+v3el7ASwF1MeTh1D6vD8TdRU/1scKUt2L41VZyGvtPf16eROY/NFI53YWqKCNcr6Ryrq93jhelATdHkgUnsu4fb9jBCznZQrAp18kQtXnu70Z94El/X0xzZ1mkhZMWNtazqmkWTOW9PGPhnRKb6iGnFYXSdbpOEN18PKEbacWkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJKZ4jScCOD0QKMA46fdwXTSUx6h+4dMxubnj51ST+0=;
 b=d1YrLplAsrwVH5KQazb61PV0K4fObHD1lROqwXyvIMEVdZmcHDDazKXlFUIKZO6wvUV57BRuZz32QMhMC41Y6rTjdjfBxMhvVnjCTDZc08IBWVMlFiuepU8qkT9epnS7f0WeqqI3o3USgizmmrZ7C5iFfE1HWC+XN+ZuasnnAEM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB10052.eurprd04.prod.outlook.com (2603:10a6:800:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sun, 2 Apr
 2023 12:38:12 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 12:38:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH net-next 2/7] net: simplify handling of dsa_ndo_eth_ioctl() return code
Date:   Sun,  2 Apr 2023 15:37:50 +0300
Message-Id: <20230402123755.2592507-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB10052:EE_
X-MS-Office365-Filtering-Correlation-Id: 07b34845-d3d8-48df-3d4c-08db33771e57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iaomrOhMlA6YzOMEonMlArna5HTghAuPaL/Y5JLZSf8E8URE8lj1dqrlCxenS9lbOu0DrJHRaYSxDzae/lItAR+42JDFdaQQ9GZVDOzcUcVENUOzGS2AnANcN+6luVaHebdt4wpbYYePcexJmikBa0kULrVlNyM3QiOeJMyuaD+dfchwiHboCSdAJG5NSWmXGR8aNKXL8AY/geIBIhi+JjYUsDjALF+vN9cM/C9IPCrZ9tszlAUIgbYypfgCQQoMS7nfEUsHpk/gVJH+X+ttRNgdrhubR3uUZSdN6hemd8Gw2m7bUaiwzbwtdiqxDQM6JrD/OA/AMz0kdmM+km1nxRE/pHBo+beZgDHV4wFB+Fq6L0muE6y/y1lU3iON0eHbv1zSQpSEJ7amb03fi4bGhmviPeo3uQ1eho/GWSwPZivwaCAysbbBMgNbZjIfUysPHo9tM+MZDh9yw+nxHPe+ZVeDnM1w/+JdhJpX6zNCCJRJcQfvoAgTCnHGko4a9Q2OHt0BB0jfQlmypVuGn6HuNykKFjbpMnPfqUKhJYHHMeb3FPP0R3apiiUS9kgQQeWjTqpKcOUTNnH7tm6bQdK1+fZFiGRDbqcSByq3b3yTpMLrVJFuXFGS7jMpZEnZUb5K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(451199021)(66476007)(86362001)(36756003)(83380400001)(52116002)(41300700001)(316002)(66946007)(54906003)(6486002)(4326008)(66556008)(6916009)(8676002)(478600001)(4744005)(7416002)(5660300002)(44832011)(2906002)(38100700002)(38350700002)(186003)(6506007)(6666004)(1076003)(26005)(6512007)(2616005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RnbQ0XFaWjErEqvjpjjLH9G+Bfxc4F2VJZi7i+eDr8N6Ve3gQLsT1lSo2Lba?=
 =?us-ascii?Q?GjUiTag8cC4PoQL86/BmcOhZUWmXHAt7psHnvf7To5q8BlG5UIdHAn9Yz0k7?=
 =?us-ascii?Q?2IGlJ6EdMOg7g/UqMclrYzwbBJ/pHytkqWGd8p1KskIb22kzt19160gESYLS?=
 =?us-ascii?Q?w6ITWOV+k2p1/PljNrr7oAUoaQT1LFqc7JpdGSBKxA2/eKSNj+R0aMsoVAE4?=
 =?us-ascii?Q?IxXr6Lc53pkxUpQLbqfsYwc4B/2DX6syKmJFh3xyhpo0XO13MlGa3JUk7g+9?=
 =?us-ascii?Q?Q5h4RbBa6dKKPl7IDnmeqazRQ2cgJgg0Fsx62cXwoH0S8Zq4sXHOBJabmayw?=
 =?us-ascii?Q?aApi55wTSRZj9b2IJyxHud2EyvJOZHcILPhrnkFeaRD/aIig9SbIzR8Pfm6D?=
 =?us-ascii?Q?1JrMgjxg5raSC+IhJh9V9tBD6dCRKkKkNHhFgtiixOPhvTIQSlolOnlTkcQB?=
 =?us-ascii?Q?yGp99gvUB/i2cZi+ftTTg/+jfFM+DhNWA29QUdWgRqa0kkqCFzTmLbPyDE+m?=
 =?us-ascii?Q?Fij9q0DrxuzVwO+EXiJp2PmIgMzd/bfD200Z8PU0BxjijvgWsx5m5B4zV0xZ?=
 =?us-ascii?Q?lR9HAEecVB2iENhLkLDIqJGlK8Xa0/fx/ItD9akaqiG0kq4PUUQEN3GWEmVy?=
 =?us-ascii?Q?/jzrYv7qeX9U7bIoufydMUExJSANXdnVjn4p5vIqkViym8O8gZpvMHxHRE2t?=
 =?us-ascii?Q?EDn+lLnQgVuHH6xXsmUor4NYwEp9uBt4gIQoH2eT81IoIAx1AzjZJtweeY7j?=
 =?us-ascii?Q?kVvTc7qLxwazZO6v2/Km7oN96Alrh38C3/fRLo7b1L6c2GQ+wcAaXebxHiju?=
 =?us-ascii?Q?xp9vzuLxMcEKfRfYuWrSl1lBrgtRRcd4xOXalUrdNWliq1WOtI/AreqnT7HZ?=
 =?us-ascii?Q?wg2eXCO0u8xTYm0Zn+IRaXFtq6sT+XX/hURVfBr2KDf5pI+GaO/VEaK6jT7+?=
 =?us-ascii?Q?JUxuoIxy0Ktj2dKhgdxIgkZTjGmfugTGXFTvuzL7ZUIlAfS9OvO+1ppI82DS?=
 =?us-ascii?Q?kGdWBI1k21Sd96k27V2oqmUkiuLfYnnkxXlp96z8MTAXcUAmTJTw068m/iXh?=
 =?us-ascii?Q?I4bfHXLYQ9GIz6rMMCZt7vH0/z01ymScgKejTQ73aJimlAOTx6vyJuBS9V0M?=
 =?us-ascii?Q?iaSu+nHE83yV+Du6RXCxZQqtf9t6hNXPmJRcPoOzZEBxHZ2LAFzYDT2BEtaV?=
 =?us-ascii?Q?8SAgkzzNcRenbkxhcz4tyv7bgM8SFW0MT6aHmCP4aYi6Cd7ecxTqWvUHW6Hq?=
 =?us-ascii?Q?3XTR8LDL95761d7xNSkFSgq8uzywtSOHiEB7fFWaSCtiQPeayXMaMkqnOO/L?=
 =?us-ascii?Q?vX0rA1Pbew+E+S/U+Z/RkVCrsl5rG55f656oNSCFu8RoXc5uwLMOyz9wrT9d?=
 =?us-ascii?Q?EP80CGVxAOk38kBEmU40TDFCp7YwMfbU8BJ9Kn5aksvhgyvSpPSxk+UDsmqm?=
 =?us-ascii?Q?wa0VB6TFGoJcrcmtU+laTYNsm4rF9d91F0VCuMP4IX/CZ1jFy6lpmtq4QYVE?=
 =?us-ascii?Q?SZpHU2kcud+ClWpRa7vOBkze2TrrlD4dAVP44h711lL2zTBWtqvLNUMwlUhf?=
 =?us-ascii?Q?fO6AArmXLuaMSbHFAz1R52D2qRCvJGhhtUq1Na2fI6ASwZqsKdQwVsHDzA6j?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b34845-d3d8-48df-3d4c-08db33771e57
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 12:38:10.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXwYLllckGF7OVIuvtBG7q5FKaWll619U6qq2batoYqJmBxcoaFnMCBDqr9OeNbZ07d3iGVKn7tDX2AFNfH59w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB10052
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the expression "x == 0 || x != -95", the term "x == 0" does not
change the expression's logical value, because 0 != -95, and so,
if x is 0, the expression would still be true by virtue of the second
term. If x is non-zero, the expression depends on the truth value of
the second term anyway. As such, the first term is redundant and can
be deleted.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/dev_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 1c0256ea522f..b299fb23fcfa 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -249,7 +249,7 @@ static int dev_eth_ioctl(struct net_device *dev,
 	int err;
 
 	err = dsa_ndo_eth_ioctl(dev, ifr, cmd);
-	if (err == 0 || err != -EOPNOTSUPP)
+	if (err != -EOPNOTSUPP)
 		return err;
 
 	if (ops->ndo_eth_ioctl) {
-- 
2.34.1

