Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63F3639DAD
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiK0Wr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiK0Wrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:47:51 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2122.outbound.protection.outlook.com [40.107.94.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F02DEA5;
        Sun, 27 Nov 2022 14:47:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUOba+5FGzHHn5OfAj2bHEsgzs0+kYlikEw9qbSYDWJSvwav0vHZJNGiI/+bP93dWRWE3rdTKbj1t2hrjERaMM5/ekS8RR8P+MF8zWJHhZg7WzNDO8U8JwGYcWWbg7b+bRVff2LixEFl54iOuaMmRGsO2rClj40ifXb/M4C0HpxLZqIgvvymcYMndRqAwBL2YvtI0LKFbU8ZB/ESPRIVGf5QTKh990PLsS1zr/T/nzJH7hXv3SeZtddKVh95H0cwOQa65/ERUZYubXpLmM5bL/UnYeZVnTaulI9iCto0ulsaIzImZSgCtm3yPsnHdxyzBjM6VDTiThXXhRoDf0UY+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VcwbYvPfkgKX57nv/HQgdtVmPrQNyzNR0nOY1spdUs=;
 b=YfgOGANTsS25fAq/wQHcoh8tCRR9Ya5vmP20SlM+VMinJ/CXHnIPiDdtTXXwuMpMuhF6Tb+0jff9fPfoqnHv6Ag0cIHKYsp6pIclliEZpvQny9QQcUM2m7eMNc803AphDki0081wCRx+fGccZjgsXTmQMZ10jMJaZpogP+dOn17XQpyz1z8u+9kjd+o9rila0fivSc5v47RIEwLBv8td22FLxWxfMIAGeEMzmBIFaAwuXzTDwEC3M+hwoHM1rLmUD4DI+jSS10jGT9z/27GhRGSh+XpelecHb3HUfA0OszktrkCWQptM5Rejo8ewFCsemz6KBywp5ktumyAtIjtXJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VcwbYvPfkgKX57nv/HQgdtVmPrQNyzNR0nOY1spdUs=;
 b=cULrDWOufSl0LyKF6yhIdsahHQo2H6716+VooQswRqZnEJp7nNpID2T6RaSlf4aroV7Eey2kGY3q4/vIuH5aza9C2UvclSwjF183O4RzX0tyw5v29U7DhZM2XjdHZNe2ps3a0YuSWAD3EgOTTWJIL+NhNtg+S6S2LsCONtJ1vPQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4998.namprd10.prod.outlook.com
 (2603:10b6:408:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 22:47:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 22:47:50 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 02/10] dt-bindings: net: dsa: qca8k: remove address-cells and size-cells from switch node
Date:   Sun, 27 Nov 2022 14:47:26 -0800
Message-Id: <20221127224734.885526-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221127224734.885526-1-colin.foster@in-advantage.com>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB4998:EE_
X-MS-Office365-Filtering-Correlation-Id: c6c06d9b-403f-47aa-4a13-08dad0c9696e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yTZYmSCYWruhqgTVLsVSpH8p1BQx5kaiEZxjtvRP5UXbtclk89vRLanripzmHbz1trRg0T84QAXdgZlswqTWJweYfCzHtQNq4dwXOjd1cYbtvHkHFvowqWaFMY6i5YxOYJpFKnWThfuv8qJrM9nadhqqqSoe4v7r4E9jZi3Up+gvXxY5wrQERiNH8oGVKNwr942nlP1+ftjIJNKdzW17TZX2D4e9AWgxMWV5Ox7k9ZwdGKzbTPwxW2Q61rP9KZoC/KNlxcjNTO+WB44hFNISq0h+37B/zvGMPibo/ACLospPNjpZA25+p17mnd0yN3QVbmM0MMVp1Pytqn2RlZrgTB7Ad1riL5anymapfQwtdT7O390X+s9c9Rm8IcTctgKB18llber/Ys6IL/Ud1XL8v34MmX/WgMKQe4xcezo2ysSIiUG3Tpchju9A6mT2gheNwbw9Jtoyamj/DQUxe9GjQQfzJDpEyLIg/pjvRLlIWpPDSTUObCVu1Ssm7ua6H0ZuKETs2KxEJW8+tzgwyhjOMAH3zUbAE/HxesJjyMjgd2DTD45mbQjwbwZRx/ug4rmRt9ttf+epbWXfohVwwf9C6lSm8DQ1wmIpOWq4gWlzKo04UbAlKMBE1x353ruz7GWD9EPAerOKLYW/EGpvjI9MflL7aYznAp8wnhbk1pFdF6QMBBrwtdmHn58mGqpscrYe0GegXDvGOxFQEyCtxGQEBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39830400003)(376002)(346002)(366004)(451199015)(6506007)(2906002)(36756003)(86362001)(7416002)(7406005)(6486002)(478600001)(52116002)(316002)(66946007)(66556008)(66476007)(6666004)(41300700001)(4326008)(5660300002)(8936002)(54906003)(8676002)(44832011)(38100700002)(38350700002)(2616005)(26005)(186003)(1076003)(83380400001)(6512007)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?72aIsioU4xVFom81S3CskUab/yKHzuRbZtdEFRS1XBzbkDOmApsfD791FzCT?=
 =?us-ascii?Q?jUHubOFE5bZTuZMo0T3JqHnzrtxBEfywvNFanCvIv/gKIYJKTOHT//FOJ8Sv?=
 =?us-ascii?Q?pbj+V/LKl2W/LaRH7WnRNMg0+nMt6C7j3WA1YvkTqIvphYyYG8hJYrxgKPUa?=
 =?us-ascii?Q?yZQGiuF7nw3QT+hnQBUY22dqdhot5TWOe5qWjpBEffefG7qcKRPE3Nyo52MW?=
 =?us-ascii?Q?faYsTSXtGZhXh0mdDiF0yRyWD+FGztJ1VFfvOAfWsQhsKhcqKjY3ztV2rbAZ?=
 =?us-ascii?Q?PXOzd/osAhd1gucF6yYkxH1AznLV+1BIMZgtPCvu9WBZyOV9hDyLxpMWpPnl?=
 =?us-ascii?Q?yG1lOnAgDa7D/hIYSRiC2bRZ9w7wKcOpiy5XR2thcDWAHR7ovLQ2UQnG/++2?=
 =?us-ascii?Q?7I/dZPD7aeRAN/HfM5TukckeMdtvDASPzuVjKDX0qVaZ1Jtael64xh522032?=
 =?us-ascii?Q?Hs2ruBlKL0CMBjPvyXijfC7VY7/VHQUieshflr1eCMIJnWvVuAEXCJEBeAK/?=
 =?us-ascii?Q?6PJvRhJNLoj4eckhGt7HpNbGG15XXLBS6+4lu1vt7tK0OfiR4ZGaXj3fv/PJ?=
 =?us-ascii?Q?3xa1BZWHTJqS14vO60oohCGbHDCleBD8RYczalzyVLoAoSMeojDOORO+Sgmf?=
 =?us-ascii?Q?uoT0gr4O5ns3FdPsr0RPNNw+KUrbQWn83Aj9fQbkUtH8pY69V89WHEtPFGAY?=
 =?us-ascii?Q?b4FpvlKOTnpsnteIM1NEhfy0gdKZdYRzuStsM/hNEFA9rIaBiGC0Yg2KTHIq?=
 =?us-ascii?Q?U6BFuMhA2ZWU25YWCIHkmkaZgeQorDNJW1cAKYzMAsn2ceIwTeTfumNZPCYS?=
 =?us-ascii?Q?DxzaZKvMfMj4b/ze31BrBBOgwNpBzUoxn12IDNt70biHbVlbYv8xQScQ/LV9?=
 =?us-ascii?Q?hZCSp3TiEmugFlu/8HZum8O7YlpJ54e28QXHl9n/ML0eJsG2JEjCnLDVI/Gn?=
 =?us-ascii?Q?JkFHTVAjNo1IOKt4V3djyTm+zo5Dk7t61tGOTaCAn4Nu/lknqF9BiT+9uTRA?=
 =?us-ascii?Q?irOIhBmUT0xQ3HhFP/FylCLvvzeZOx1TC5P+p01SZskWlexEucDKS99XTrCI?=
 =?us-ascii?Q?q0w1Rw+Qn0VIAQAqbat2+uXJMKew56YeEpGMiQXBWpQ7EDK7kVJKXMEoLcgC?=
 =?us-ascii?Q?ZGdAPoAX+0YC32ewq3rFjbfqpjTGdGOVd3BOC+7xbKLiLuQpvfCfxu+t9F2y?=
 =?us-ascii?Q?PBXxmRUg7sVqwgy4OsbbFj29Z+fBI5n40ALk9XGh+M8VbFX+nN3WLpGePrJr?=
 =?us-ascii?Q?1JfEGg9tHCF/9lm0zTWeV0LMPTBsAzZjKqLcAspMl2uscWxeQvCCRpGokdHV?=
 =?us-ascii?Q?dNxObSBWSzr1pHUY6Q13Fl+XWa+s81PdXV1qLXB55J3tZ1ljqPL85hS8prUa?=
 =?us-ascii?Q?dssX5yMB1eJCuzHfcsU7BiWNiW9We8LL5HSbMJT8ZOZpWJJA/oIFCZG0YiBC?=
 =?us-ascii?Q?MqBqfhXZqKTswinZS8X93HzJlqKhUXYXe05LamQdRDLE9L+rECO2x7Pzz2w7?=
 =?us-ascii?Q?/gzmcvZicRlVlxyQIaZhY4nnR78Fx4ga3dFAPG5pWWUvdxkqbqrAiG7vBZZk?=
 =?us-ascii?Q?8csh9F0T6LzN8dLy6gy4fqAkZTrA+rqU4dA+obJPYZhHdRb5Y0mIngg3yd2x?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c06d9b-403f-47aa-4a13-08dad0c9696e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 22:47:50.4217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ED8TWGw9lP0LLb+KSZ3shqiKhHGjyd39JGsimFLg7zenxHIk5s8DxBtyGN9tG4AoYFaVvNiEtzSzIQaTWQNtdiL2HIjAFuvI3V7qma78r0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The children of the switch node don't have a unit address, and therefore
should not need the #address-cells or #size-cells entries. Fix the example
schemas accordingly.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v3
  * New patch

---
 Documentation/devicetree/bindings/net/dsa/qca8k.yaml | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 978162df51f7..6fc9bc985726 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -148,8 +148,6 @@ examples:
 
         switch@10 {
             compatible = "qca,qca8337";
-            #address-cells = <1>;
-            #size-cells = <0>;
             reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
             reg = <0x10>;
 
@@ -209,8 +207,6 @@ examples:
 
         switch@10 {
             compatible = "qca,qca8337";
-            #address-cells = <1>;
-            #size-cells = <0>;
             reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
             reg = <0x10>;
 
-- 
2.25.1

