Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387F4639DBA
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiK0WsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiK0Wr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:47:59 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2130.outbound.protection.outlook.com [40.107.94.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8C1FD22;
        Sun, 27 Nov 2022 14:47:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXgYeM1WdJVnpEgvpDKtkobEskdBhzW3VysBkuXNCdKd6aX55R5r7AVYxeUhKI7ZXmLY0gTtZ1jeExu0qd0dHpEiu9OygFNR9DJ5mN+VKurasrDRPHg7r17tfiXcvUWfpVFGa+hu3uXXzxlBfNGUyTPWFM3Jxz2eZQAB9jk4lL8A9/Bj+HSGCphpRGu3gbGODqUValkzDikWyhnouICQWV5yawXjh80sXungAOmG76wpitqgCo5Nw94m5ba+DbWnQYhKuv68RRZePi//MzCAIUmCYaB7yEFWHhkKrlLnhR5f6fRhXWhNaJ1AlpjmP7+oBM9LE201GZB4MFHmCTJ9SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGNeKwTq2muc0tyiBPIiUzGXXWJxBOJ6TQO7FAkQqFU=;
 b=CRtmRlA4DIBxERZ0+Se4JpVMa8JOlzEbyicCX4uSjP8TdKlWahj9hlDRUSl07SYlNhiJ+X/8lKG7Rh9sBUh0+FzUSN12q4VSyZn/1XVvbZyS02OD++s710SmHQtX11iEMrpmoJixN30dCm2/V8lY0FDJnotYUhA3X3TGA+gLq87i4yd96OU4sjmNB5D8AKbtm9vJRwhoZM0TfDl0Y3ijhIeeAts3TGJ3hlvGjCUXMt/gqJh8dIg/eiBQ/SkNFtO795NgHaQFGf5Q+n+jUIr0Px6pxINJ/nadSHILC6mQpnOu4aaJoz+Ya1s15gJeyl+IGnJNQCGc0IsR82iCEPMGlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGNeKwTq2muc0tyiBPIiUzGXXWJxBOJ6TQO7FAkQqFU=;
 b=KTbmBiEDVD0fJuAFKOccPWJqopQNMoRzAnihflnBnQ6wtDze/nQsRAc4Xau5Jy0LYXy6Z5/ZUnQWjBFvwawKlG6BbSitLdGiZPJ1p6JtdzWgzZ4apKqxqLp5IoZ6TvNIg+MJuLtfEVEFVIFjn16c13DfEasX+gPDf91CIoTWW5Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4998.namprd10.prod.outlook.com
 (2603:10b6:408:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 22:47:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 22:47:56 +0000
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
Subject: [PATCH v3 net-next 05/10] dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
Date:   Sun, 27 Nov 2022 14:47:29 -0800
Message-Id: <20221127224734.885526-6-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2161d582-849f-4dbe-c129-08dad0c96d01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8B18hRQ87JvBQA5Mr2KODuC+Xfju9+IKJVFK1plJ7vz7RWUZ/XsIEnd5MyACQDhw5kJT1B9aBxAZWyAT9Y+acyTGJQuKoSuaYfsHaUCU+MIAH9/Rfvk2tyWD2LFCwN6XqCXjIt4N2gnbBPxI1Q7lMSba0lrNuIhN9jn5Vor7vM6KPr5elxJhkx+ydwP/ogYqSepZS1lEZ8bzFSAK33P7Au4LINZlf0i1FWT5UmvimQbk60tTwlN7YVIobzpLc/8DWThXfOgCWzmZmQWlISDGj+KKRa+maLPaIml2KBH9ByHtnSpfwXVPjdkJnNuRcCS31gSzDa3wtqpe7/d3xvvzLEeFiBwfE1/UgNOPgcE9Aocov/cPNNo6XIoIuR97+efb6RcsM2x7WRfBPc9Q2zXTFlWpO67DMXOygxWDT5SQGIWpu+lfB5jQk3nPVezv+KWi8yxzn1mdljEPl/3whqmBaG0oEzqM8EvXQw030FQHBOza0RSFWB1axnDyRTnqL5B2kzL6ZUYgqTc5z7IgslMi7kd8yPzF/b636wNO4DZrlTDibU3hIW83RCYKP2uDesp0nfrKr5kjJRBWHnqYHqfvF8VyWdlzeZWKiyKlNT7iF4C3oFI11oL7tAsezfgi8BhMTc3FhRMUgGvLHCq9kKf2KA7VFDRBJltaw4csZit9AUQ6NPXplAPKDH5Nf5h0rPKJctNdARMT4aUqysNVLwlf9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39830400003)(376002)(346002)(366004)(451199015)(6506007)(2906002)(36756003)(86362001)(7416002)(7406005)(6486002)(478600001)(52116002)(316002)(66946007)(66556008)(66476007)(6666004)(41300700001)(4326008)(5660300002)(8936002)(54906003)(8676002)(44832011)(38100700002)(38350700002)(2616005)(26005)(186003)(1076003)(83380400001)(6512007)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N8MrGhIHb2ZqEShYAnl+ycBNNgjGxAdCTIBOHRauymhVkM1KOsnIvajiReum?=
 =?us-ascii?Q?EbJv1xSoxwyC/EI7x3uvqToXlVPIvBPvnuZpSKGDQ23qHb32UrY5KYz/eCt5?=
 =?us-ascii?Q?2bL6YAowZ9e98q9ua2CcQbnk0NxvDzetfeQ9H5w3HgoT1ubzN9buCy0pbdRF?=
 =?us-ascii?Q?eZ2N4h/OMBtdS03IEspXP5lqen5YzYjhu7JlLzfAXGW691tlubdoJfJs9EA3?=
 =?us-ascii?Q?UKVGo3NhLDui9a1tIXBDnk+gCpbAmWIWrZVWxF8ldg+tsW7Nbcl3z3OPi3hh?=
 =?us-ascii?Q?wHXOh2DQklJIGFbw86ODDMIHp6Of4VXspgUOAyxJMKcfN9EkqnRNQ2y9DY2t?=
 =?us-ascii?Q?Lf1NDPMl/K8QRsEHH1bOknHtyxOPPJ42FsVC73c9Oog5oXLjn0uC/8yh534H?=
 =?us-ascii?Q?ec7EdRARdTQtNQaEgAAmCwYjtLwh3vQXueB6/the2XRr+Y832E/Cov969Y4R?=
 =?us-ascii?Q?/cZesBtaTCgXxxuR8NvTeFC0dI8SCrPIAIJd+evio6JXg8bDfWuSH9oBU4o4?=
 =?us-ascii?Q?Z4UI1Ocs1IRl86fJvxqblPR6y/yuEV1htZxDFJLgHHhDBfqfYqxkEfPcbOU4?=
 =?us-ascii?Q?oC6JvIz9T0jpKNBHeIl/XKOtTs+h4PILkV9QHfhcrprZMgkULazTTiJn+WQv?=
 =?us-ascii?Q?uvr9CA0urlOzGZezRfYAen5ZTte1JT81DcWuwcvl8qAG+UaYOwJfrxzr/DqE?=
 =?us-ascii?Q?b6tNu+qD/HhbG4ERBQiuvCJmr7Tarcf4XPw12vZPNI0t8WZKPn/sNLHURFC3?=
 =?us-ascii?Q?DuFIiMoOGJqiT5rXBMysiyGppdSN1Z78EsMCcHsP61yUHC9y153SZfBy2tfp?=
 =?us-ascii?Q?gE/Dma0OOP1D0ReLFJrwJGQWqxFcJ/BLiNRHxz7t5rmGGW2mBFhuvCiXNgS4?=
 =?us-ascii?Q?iRu4/7Heen5ol2pe3KcOnnRDD/qsIk4q7ZQ4wv2R+uO7dYHSMgTrp3aQo9nv?=
 =?us-ascii?Q?ObZ3li8F4iV7Obrgx5SLVNAYt/FgHTcsiWjBdAOdIGiGb/Omg6O137MShYYI?=
 =?us-ascii?Q?iQTTJFDgdb88WHlQ6DMtZXSTyyQQV3PSt7+PagEsyBpNMtnEFLFaKpeHAn1h?=
 =?us-ascii?Q?IJxPCvdrKqDs7gc0dSg9SqHwtEIZa5E7hHiijtoHafaQQByU4TXWwveOUagp?=
 =?us-ascii?Q?RigJfEkQLcyWJ5/Ow+yoQ0eWUcQGizzw6DwEyxOYQbxeX6r/t+H+9PXEsxN+?=
 =?us-ascii?Q?gQF+vrZYAo2+KxrwY8H7dE5J6LMAKPaNLBqmhXUkujDkIMgAgF6k78Q/Ms49?=
 =?us-ascii?Q?bhflp64vLSiiP2hcZV+taAmiPbRv724UQHb7v8FfUAAt6nwdlc8RhYS2iVQJ?=
 =?us-ascii?Q?Hv3Q3sVIjLgI+HOFzvmU/TMepSFBtuG19I6i7ycH+2NKWNS6ZBek+RUWUzPH?=
 =?us-ascii?Q?xD7vZ2nNm1Tc85j4Vy7pQMOlv+s1OGCj7r43qCNsLN8va/MXXqdIqI9i1gnD?=
 =?us-ascii?Q?ynb8OZPMLRO7OL9+3FcdqDq6BP1Eh8ZDcksiAq6mX7YM+CpdA8IJJ4v2OM6k?=
 =?us-ascii?Q?klZabp9U7vWTTuMyTYK76VbKwJfdaM0tNAUJ9TWT7uxOZPhsdvH4Zq3tHVA2?=
 =?us-ascii?Q?lAhY5SdMhXkaevbhsv2NSEzyDT2LhVzKm2OektoFFNl8pfiLn8ioDzi7MTiH?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2161d582-849f-4dbe-c129-08dad0c96d01
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 22:47:56.4681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XJwiIpYfWDlzCIc7PUDBCinoGtQ4PLwboCWGdXaFuFNLJEheufcAXNJOepqn06WtJE9TADq5bJODK/kqE10syiUDHUpTO9GZJPzNcAHg4zE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa.yaml binding contains duplicated bindings for address and size
cells, as well as the reference to dsa-port.yaml. Instead of duplicating
this information, remove the reference to dsa-port.yaml and include the
full reference to dsa.yaml.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---

v2 -> v3
  * Remove #address-cells and #size-cells from v2. The examples were
    incorrect and fixed elsewhere.
  * Remove erroneous unevaluatedProperties: true under Ethernet Port.
  * Add back ref: dsa-port.yaml#.

v1 -> v2
  * Add #address-cells and #size-cells to the switch layer. They aren't
    part of dsa.yaml.
  * Add unevaluatedProperties: true to the ethernet-port layer so it can
    correctly read properties from dsa.yaml.

---
 Documentation/devicetree/bindings/net/dsa/qca8k.yaml | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 6fc9bc985726..93a9ddebcac8 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -66,20 +66,15 @@ properties:
                  With the legacy mapping the reg corresponding to the internal
                  mdio is the switch reg with an offset of -1.
 
+$ref: "dsa.yaml#"
+
 patternProperties:
   "^(ethernet-)?ports$":
     type: object
-    properties:
-      '#address-cells':
-        const: 1
-      '#size-cells':
-        const: 0
-
     patternProperties:
       "^(ethernet-)?port@[0-6]$":
         type: object
         description: Ethernet switch ports
-
         $ref: dsa-port.yaml#
 
         properties:
@@ -116,7 +111,7 @@ required:
   - compatible
   - reg
 
-additionalProperties: true
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.25.1

