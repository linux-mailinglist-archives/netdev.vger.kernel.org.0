Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBF3597BEA
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242946AbiHRDBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242930AbiHRDA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:00:57 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5363A74CB;
        Wed, 17 Aug 2022 20:00:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=km+PJ95VkyenNivIETBtRLjx7xXNKlk5iY1YSPuUcoHz6P4kw+HwK6sO3hB4mcZCbxY0OKA0wBJ1oY2CKRFBlM0WJdUZM/OJEHGAyNcM0NSJEF+0dYbCv/QrPiinKRl6ZqlLLYdh1rFxGJHdgrbbr/suWmNrN9xu5AU59gz0W9EjC4ZR86YvF9xEeHz3mlSqVlS5OASl0CyMOqFjHipSXOQTbcGUFpFus6l5JFWvtMUK8GGTHRtGPNZOHo8L784psoxKWBfO7af1HIBPxIqqKC1I0gJK97EoNLB85/I6amW4OIOJxiLXQnO7l/08k1Xbo1L6bkqRUZfcEdDEIAjp/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsiiVW89XoQLMq5HgXUMki4nZjRqP/+iSXzWB+zkUHc=;
 b=OhxU8L05t+mSL1fwp+8Ipdw2P+3gVpOIE733nptY8WDCEgUnrpe8LVIOv9UPH+1HmqaevI1LrCTOdXmAthir/Lb1kW1kpPiEIxpdz1byVgtt+MB10HR1BoebuNQLabcuFvRxZEZnX4YNC9qzGq7vUS2QHtX+GgLP0snPdcPsbPrYazqqMhknU6scgp6k+Ony+4D5Ysh7YeWF/0f6vqLYvEOWwP1c2B2l8BrPZA9o42PMFmXsjLzpo33XsdmIW0peaTV9kf839X36Yw+tLkA2tnBRUIXuTKkfnnL20cYNYuKe4Cq/SjxOTarbJDzDMDi/AH7qzoVzmpBha3DHOmycVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsiiVW89XoQLMq5HgXUMki4nZjRqP/+iSXzWB+zkUHc=;
 b=l0sPm6nIlsj/DnyvdtWbFoHK6gQlQ37eQ5oaI5+R/FCSMlHrwi9XxxeBvSL9tSfyQTJ5VE3pPkHOfHA96yfV0QBVBlpFnYBGb9u/rMgkukehKZ2Jwsm5e2jhCrvuOmDjyp5LxAkkLVvrWNaS5uARx5EA7laYPuhWPbuxc748AE4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR04MB4637.eurprd04.prod.outlook.com (2603:10a6:803:70::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 03:00:54 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 03:00:54 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 net 1/2] dt-bindings: net: ar803x: add disable-hibernation-mode propetry
Date:   Thu, 18 Aug 2022 11:00:53 +0800
Message-Id: <20220818030054.1010660-2-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220818030054.1010660-1-wei.fang@nxp.com>
References: <20220818030054.1010660-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0038.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::20) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 642a98ae-74e0-419a-114e-08da80c5dd9a
X-MS-TrafficTypeDiagnostic: VI1PR04MB4637:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pcpCXmZDz2g7e83dGGBZ3aY2aZcECwjSQdoWB5J2e2vBW4kF3+B5Z2jApNMLb7aZ/YdEDW3QD9449pF59sv24ZSCP7g92Ry8TEgTvDO96G0w2HeviIo2eYBj6MXoRkAGW5ISqqLKbDL8NJakFXxfD3uM9GI/ekD5AyLIWxNQvH6y4JgtIrhu3i7OcixpHrb9tmmp2GP9fUgqtl1VZ1y4iTV2UQbISTm0PblbFidJs3KLu0OE7CQgRQOu8tj+FIGgK+1J5gkrnR9+7yP7AOZa5S/1z6F+uTWolB5mEMy5L1Zty9ufsbKiwKDxsGKXKBiC49mzfamza/wDU2iG8350TSdRDKv0SHbCAwU3Y+2ftJJj1wZmcgHDQzgMCQ5o/4znSb+yp5inz0H6arvnDAlp3oiVHatLSwiaeFyfeyNU92SoN0l8c/7A982AtkJdNM/A9SoATdtWuujFn9dMTLs+AkVczlebxBoVXFj6DZbcbW02IPZhEcLgnnvTMbdJTDjtq95zuE47gR1BUvihpnAC0Gn5PLt9Slqoi6McPZXC7VanGm+Ske8ndSuHFIGrxEbT/mMawL0xA10UPYtbrWPYIeOn9OJsIQtywnxDpU0oWdPlOa1a6A+kpomyyPcWPS9gm+S9y3kHKaUoamwVv3hvmC5rGByZmeDTIyVS9FsS7ZvFldZRH36IEH5A3Ri4Ys8fYh98VBcKZzYgkwk5ZgvCVpAEBjX7F24vBe2yUbPyEswhKhe260O/P4gxwYjOWfs/d7eR1jBVcjthKKVhXp1VaA6eCgVps8jsS8qajxXTvQ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(83380400001)(52116002)(6512007)(6506007)(26005)(2616005)(1076003)(9686003)(186003)(38350700002)(38100700002)(66556008)(7416002)(8936002)(5660300002)(8676002)(66946007)(66476007)(2906002)(478600001)(6486002)(41300700001)(316002)(921005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ntjZP6mE+d4wLo45p/OryiI9dReXkCSa5vv0ZyB0ABWPVGSmbnFVa6eH9/V?=
 =?us-ascii?Q?r7ywB46bfI+8CsMB2XGBAENaFOFB/g8GaFcwgJgrDnamdY+2gWUzVVNdHrWu?=
 =?us-ascii?Q?t5aZVOViejbJLVM93qePYg4BH7xix6jLNPNGLUSQodz82q4ZFYvObByUSCo1?=
 =?us-ascii?Q?0NwkkNPi1xYlpdz25wVwDEdXmpa8FtBGNCLzVfsXDXQHbJeCsiXu7RqYEeNT?=
 =?us-ascii?Q?KQjVgwIQfEuMRw1Vn38fUZGfqZ21zlCRqy4zugTdxE/FTWybXeK++xDrnMCZ?=
 =?us-ascii?Q?pq3zLoLbR7UjUsohQGerlndeVT/I2CvMcAz/2rH0sQPYg43e5JoPmhAvD9uo?=
 =?us-ascii?Q?p0PeNXpGhs8vbvx+KaDy25C0fI/P57YjadXGThx0KPMSbTMnCPmGuO/Jar+W?=
 =?us-ascii?Q?kLaqYMTIFyAkfcDYIPtHR4j9Xxw9gj+cYzc4bjZuIT9Y0BEPSh96BeZnTqqL?=
 =?us-ascii?Q?0fiX3PrhZ6gIvGb9fI1UwdQSUFD2HoIlds42Br4bPnABhQ2NPnoU0NOs2Jc0?=
 =?us-ascii?Q?rxZpewWPuY4WLeaoOY1VyxjuX0nHm5ObxdClUH2VYvBfFJk4IdPB9/rnYccB?=
 =?us-ascii?Q?4T3oKMd8DNjhnuoAiYbZ8NqQbGSO6MFGbGqpApTNdUSSameXBjHbEEnnBr8C?=
 =?us-ascii?Q?Ga6QjWFwE6U4R8+ucp0rpGDXcBNBZnZHRunCPc8XrZTCnLcqnLOtQ84ldZS0?=
 =?us-ascii?Q?j1OY2c8jcn6MNaTGLih6OPPX+PzE13MFasuZ6mU/z1dbxc6hwOI2gcOQMVEz?=
 =?us-ascii?Q?KmjV0SA0utoslH2wz/OchTzGZzElPTp6ZkNu1ONnjEs2FpXZxXdsvqYa0vza?=
 =?us-ascii?Q?V2V1hIq6iStMl/hUF8TwbzUZPZ1IaPoYQg76cGskNtzO82HkChZgdulUQTit?=
 =?us-ascii?Q?2cDHHik8HuaWgyRBI9YLcO+jdOR6DfX6cpdvFHjTiIqQrQodKVWO+XFUgvXy?=
 =?us-ascii?Q?p+UsTX/lwfoMaZeNy233e8LqBc02AT4K/P/UjhWrRd7egwEdqjDjuP5weGVK?=
 =?us-ascii?Q?Ree9CB7tcJY9+Eb8CLVvoJiuuGrqvhW99G4xSDhHtToW0kGUyn/lgyLq+cIh?=
 =?us-ascii?Q?9rpXBLBRgdAhoxM8tMo1gOijJ9BGkYPu41cDqw4B+8stXDXIlby5o5UDmLiF?=
 =?us-ascii?Q?tA+hLht6oM8BLet3mrhfAWrIPduqZRNTvq/wPwG3U/ada/pH+M1VSUFbf5uD?=
 =?us-ascii?Q?wyywHFzeruPdawv3VtE16k/4Q2fs/uEzrJOjgED9nEm/CN/HZ79KIntE6HVw?=
 =?us-ascii?Q?CTradmUPVWoWafh9EXzlnPYitApEYxfwULuLRnTvCIF1kpWYMh42VdJiQXvc?=
 =?us-ascii?Q?4cositlAo5EUxukyDIFyunGmbIpLYEwnXBSNqt8bvfkLhL3nuRKqYZ4cjSHe?=
 =?us-ascii?Q?wWgTPQDRoRSfdS5awcu1qsZ1V+5r0Q7VqPtcyvaEDkZiRo7X/YEce2PHUM2/?=
 =?us-ascii?Q?epD8M+oAkL3GLBHiRyF5nbG5ccV8jxujMibN92S7gkDY05VAdxXEJn5cYTq6?=
 =?us-ascii?Q?e7NEmU+IyCAiYZqWsi7C4fyzbE7ghiPoop89KdzrR3w4Qjh7xF1AQg6Nt/zZ?=
 =?us-ascii?Q?oR6SGTdTtGoBqFX8rQtgHsDJ+5DI5PB3Y4xTXkd4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 642a98ae-74e0-419a-114e-08da80c5dd9a
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 03:00:54.2526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a3WCQ6OgfnfEz+3a6rhToc4xq+Ahe4zCpIoIvfUnMG+V0Ky6kqFYgpRnXPSKrDy/k3y4wNGK5/lIR5Q5jE74Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4637
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The hibernation mode of Atheros AR803x PHYs defaults to be
enabled after hardware reset. When the cable is unplugged,
the PHY will enter hibernation mode after about 10 seconds
and the PHY clocks will be stopped to save power.
However, some MACs need the phy output clock for proper
functioning of their logic. For instance, stmmac needs the
RX_CLK of PHY for software reset to complete.
Therefore, add a DT property to configure the PHY to disable
this hardware hibernation mode.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
1. Add subject prefix.
2. Modify the property name and description to make them clear.
V3 change:
According to Andrew's suggestion, remodify the description to
make it clear.
---
 Documentation/devicetree/bindings/net/qca,ar803x.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qca,ar803x.yaml b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
index b3d4013b7ca6..161d28919316 100644
--- a/Documentation/devicetree/bindings/net/qca,ar803x.yaml
+++ b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
@@ -40,6 +40,14 @@ properties:
       Only supported on the AR8031.
     type: boolean
 
+  qca,disable-hibernation-mode:
+    description: |
+      Disable Atheros AR803X PHYs hibernation mode. If present, indicates
+      that the hardware of PHY will not enter power saving mode when the
+      cable is disconnected. And the RX_CLK always keeps outputting a
+      valid clock.
+    type: boolean
+
   qca,smarteee-tw-us-100m:
     description: EEE Tw parameter for 100M links.
     $ref: /schemas/types.yaml#/definitions/uint32
-- 
2.25.1

