Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFA6640F51
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbiLBUqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbiLBUqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:46:21 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2109.outbound.protection.outlook.com [40.107.94.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52488EC81E;
        Fri,  2 Dec 2022 12:46:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXgJfNuGM8PUCnstziPltBk7K5qp7LXNi3PNz3jvx+73tftOSeEq33ddlfqmWcY1VjNwIkzWgitKKOCbVhAWdB50+nKKcHLM3GCB7a+Oh7wRfgX82KggMmOVWdNt4tujjVfv0jyoyjTdB2KiXDwvzvhMyCrZMSTrJQknW39iIb8XxPP9+mxhcedz3I274dQeYZtIkGEDndlJA9sxRnUw8JS3tRwFjvnz4Gg6IGEUJpObsIeEWrHdD0eCwkbUj5nIwMD8jegx68IDCe5ECVykmcaJztmvwVZzEXnlZuf6MejPHmtlsyz8vBiUElYUBoT1ToodwCwedJfupOU6cCGXPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsHMt7pE+tiQecrta3QILh3daloCZA3Js0ebcUMmVn4=;
 b=EYKxiTHSKgndVPd5YQFNBKeEq1MBCvQo40ZMH8ei2/YI7cgahLC9UGBdIwIOFc7v+bqVxrB2pcnNBS2Ldlk88YwKDMhCsesusRACo3i1bsPUXFxa2JH4OG2tHoI0f5CP04rniPnd+smaBhniMIlg/ecJItmAiPRVmBN8HReyWBKVcrQE0Qvtrw+a5KRP4t+h3h2U4zJCFdxWIFdNBU8c9L4JXUQSNrpRGysWr/2rM8aVnovpXCCmr1a/JB3sQSFNG1Pu6XrLwhPpNNPyQ77iIu9ixR52J0SIKd8FJQZJUmy+LYHvENVgNDS8Xt9YAFyC5DbEbGLIG4ZZE9yhslEW5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsHMt7pE+tiQecrta3QILh3daloCZA3Js0ebcUMmVn4=;
 b=ZSiSIX305EfxK2+b487Oj1Z84vOYMGN6inUJ3pTQNLEyibXfIRuiGpuxKMLQW33AtJEwelQdEPx1ryuXnIjWoYynMukJOWAfGV6Z56SgMz/p87LxMAVqtKz94SZErqIDn90NbiQuyfx4PT7tshUmSTDvS4bB3yvcolVwUdCyUU4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5547.namprd10.prod.outlook.com
 (2603:10b6:510:da::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 20:46:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 20:46:18 +0000
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
Subject: [PATCH v4 net-next 4/9] dt-bindings: net: dsa: allow additional ethernet-port properties
Date:   Fri,  2 Dec 2022 12:45:54 -0800
Message-Id: <20221202204559.162619-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221202204559.162619-1-colin.foster@in-advantage.com>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:303:b8::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH0PR10MB5547:EE_
X-MS-Office365-Filtering-Correlation-Id: cdc46ed9-43d9-4413-c2c8-08dad4a641ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oklFmiuPNN2iwoncpVkKQZgEh6GOAuHRwaC8iqCiIcObOBZVo/s6dJC+ipcXeUzBqnRthYou20guDFo9Zt3B/hn8+ICTzfKBfYrCT71E02+sCuXDv6lPFF9zNz+yDHVXTSGMRf1TMLouFyUeqVCtmRKsA+fYC1F9Txr4eytBjpOyX0LGkZw00yQ75gvI6l1o10A+L/oqmh9+FWsXEKl+NulE8IxuLrGVRU0rwXTlKE0A69/bodKqAPJzkaRBiZhHs+t9PcIjzh5KH3ofxXB51+HwDJwxU03XfGbRzqBy/lZLGtlvMka26JYcrQS6GVhmVXQutBtAsqWlURZbptllHbg2URpjEm9d48wwwO1/dxPIJeh8DPC1QxNQCmACf++LPV1Wr3kfIfQ0/3+3JF1MNJ6IBKAQp61yuHj5ZWacDSTmrdmEfb47CJ+PNDET9QY9dTrZj3V8nTmRaERDsNuGSlc1cvonE5pqW1RkxT9xld+f+k8Ch5UytFo33GffrcSbCCmsYEZdrq4vVdFcnKtCKdZIIyn94QAXuAXHZFL1pxoAohIBxS61W/bxtMTEUi0hzfQeNnhMpydUyK9KULKTzZc3UqD/MZPMmnjD+m8rK0bNL39LjAw7jO2d1djx+w7Fu+rq6aM7Ge9btEzoNCm3ysXh+EsiUY4zj2HZflSe2KxTbJ+/zq5PTlus4/Yvg6HV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(376002)(39830400003)(346002)(451199015)(54906003)(316002)(66556008)(8936002)(44832011)(7416002)(2906002)(7406005)(38350700002)(41300700001)(5660300002)(4326008)(8676002)(66476007)(186003)(66946007)(38100700002)(2616005)(1076003)(83380400001)(52116002)(478600001)(6486002)(86362001)(26005)(6512007)(6506007)(6666004)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EaCmYvGHadnbpRJY3nJrO2pAUAndUqugCHAHPWk07pWt/EqcG8NRNTbMl3zC?=
 =?us-ascii?Q?APo7WkuH2fU82/ninSahPLsJXyuA4imc/XyUdkPaQjdEtvK2mcs6ZqdJYYaS?=
 =?us-ascii?Q?csWT7oqUyhX2Zdd5CZxmIaXyu6U/5YTEbEZYAmLOh69K+MkQT61kaKJnx+Eq?=
 =?us-ascii?Q?Oi8BXPsukLJFYMpZskP6pCmi54BkCJjih7eHE0R4oE584vLaYyqRRhwS9Ltn?=
 =?us-ascii?Q?xJzDhJUKuG1Tq3U6lJCsDsARRFzKhu2NCscpVpM4qw4I1cYucQsbgPoWnR0S?=
 =?us-ascii?Q?Mq4Sw+E0fitNAqQJq/8NtuqJtMsENcvhO5mPJuAlJcfdcbWmD5rMUSJQIr3d?=
 =?us-ascii?Q?pDN+VfQAbZZi4iQjFs1ubKtSM2duzYFsOM2eFQsgpsq6MYYzlJYzIIX3VF0r?=
 =?us-ascii?Q?/hP8sgvMdFbXVb8sAXgtci6BUxylBpSskYSpIZ/kMOksog3r0/N6on5XnDO9?=
 =?us-ascii?Q?h4U4aKUs+9MYL1vlu+MwQ1rPF2lHSDwr4qMug9tPVaHrmIeUaBpx8uZUTJGc?=
 =?us-ascii?Q?GIL7cHTh+SID6ViMMZ9y76N5OiFThpPT6COhPaB5MZcrRZIoCGE2+62QKidy?=
 =?us-ascii?Q?MpFivEIsRm1T9wyBUfGV/vcSx+8ejkzDWTcq93jDkHSKaqW3FF2+r4n71Fgq?=
 =?us-ascii?Q?TtDyA01IGSSiIqTa3RcSRuL4LposBd9r90tDRrUklYXjuy8dSaPQi5O9CNTk?=
 =?us-ascii?Q?KZh1K77KhjW29vRNc0oEAJT4lAprUz0REgCHYoSYW/U6slromKAq8VCO9dke?=
 =?us-ascii?Q?I03dWxbpuJz99xQR0jsgApvwpmpRKgNPEKzVeF1zRnLnRBVVPD+XzjoDf0Qj?=
 =?us-ascii?Q?llScNRj4Y7k05Q2R+LBjrA6hf8WC496vsXzG4syaNo6AcmNJt2ocikf0LrBp?=
 =?us-ascii?Q?rdTCk/CUIfzbkgvcciqxlnitQxa8qnQqwdXnGuM63KVslQf+ID7bfyw+RD8w?=
 =?us-ascii?Q?1ulwoIGSe+eccSaGryb4WKWTRroqvbdgINEtmmDD2/GMGCER9Yhsdq8iKyen?=
 =?us-ascii?Q?Db4AcdtDjxCnhN4Xf3Z1T3EehZdgfbfvsJgluAUhTU0/A57DRmEZRLjW8E1n?=
 =?us-ascii?Q?snVStI/q6EtuT+i5hB0tJ2uh6IXQfBRJNtrCXOHTSDyHB8ykRu/SxFJhcRN4?=
 =?us-ascii?Q?tKI9V5H6fbAJwSIDP/aBQDgsiIgBzCVrFOnuUyrMiASj8RFBOfOsK7eu3H+O?=
 =?us-ascii?Q?qQj+W6xrvZhpCJPIQD7VtLAhAp2AIei79RqXgMaxmdV9JbWEkrgt8H5AtPpg?=
 =?us-ascii?Q?SjDmd6h2nbuIuBfO4E81oxo7Zra+BTswrAv/Id7UTN/gfAUg9M+GfdVQtNnY?=
 =?us-ascii?Q?9IQoXFW7bP2GhcpbpHBwv2FN2/A7HgOlMaLFP9oe2Co+XiDYkg8aCFMjUwm+?=
 =?us-ascii?Q?MXBMA4UASFqclLN2Mw2OCTzHtnjQW87hToUMAcC/cLvALsvZXLlwqSucHI05?=
 =?us-ascii?Q?L9eB7T4cFndxrGaMTDbEzSVaIsjRkKOJFXTNa+DlkZN8/zmU64oFYLgosH1V?=
 =?us-ascii?Q?dwxYUgfhMzsCQs/YOGoUEMzubhyq8WIJU3dSBIu54hls/fb9M20s20S+XiST?=
 =?us-ascii?Q?dNL6xUw+qB73T4kqfkxqqUnLLc3k5vhqQeAMxTRsL+yzEix7ipx5Qsn+rEpM?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc46ed9-43d9-4413-c2c8-08dad4a641ae
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:46:16.0009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbLEcspcWvvxuV0Oed+Dw5fKNh4I9vEZIbrCERaJPGHQed0l4cq+xbW5Pk/yF2yZssu1mpBhGLl6LwBI+vE0blp6hikg5O1IebaWOCXn29c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5547
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly allow additional properties for both the ethernet-port and
ethernet-ports properties. This specifically will allow the qca8k.yaml
binding to use shared properties.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

v3 -> v4
  * Change ethernet-ports node to have "unevaluatedProperties: false"
    instead of "additionalProperties: true"
  * Change ethernet-port node to have "additionalProperties: true" instead
    of "unevaluatedProperties: true"
  * Add Reviewed tag

v2 -> v3
  * No change

v1 -> v2
  * New patch

---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index b9e366e46aed..5081f4979f1b 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -38,6 +38,8 @@ patternProperties:
       '#size-cells':
         const: 0
 
+    unevaluatedProperties: false
+
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         type: object
@@ -45,7 +47,7 @@ patternProperties:
 
         $ref: dsa-port.yaml#
 
-        unevaluatedProperties: false
+        additionalProperties: true
 
 oneOf:
   - required:
-- 
2.25.1

