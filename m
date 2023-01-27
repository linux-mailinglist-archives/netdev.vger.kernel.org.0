Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F275467EE52
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjA0Tig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjA0TiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:38:19 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F058A557;
        Fri, 27 Jan 2023 11:37:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7atpFT0xTmf39gzKjGOlX+EsLmkfU17dHTYU+s5EktfnpreZZSH46En7uKN2ZQO64Q6N6qa/J8xJXv8HAz5qULaquZNI94DeTQNBaZbzKV90nOpJKN2x3nFEyoscTd8LzYR4hiLd5OJ8LbcxJYRKF8PJvHV5xltGgcPsLCwolq67yVVzggs4fNYhXr3gBX+FkdcyaXj1NR6FqltQjnihYWA9qv9cGHNboHNDgAmX14Eeu+0eDP4H5kGQk0LJgqkSKITpt5dn7wwvj9MbqJDRGJD7t3fyySDgn0Y4QOqC2I+VnOoE8JrSpIdfbfAb1TjSgUbMXh/rGOEapu6IibV+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdhnVSCLNmHkgWtUzcrvMxgOXOh7kZaU3PvxcLyzANo=;
 b=B+J5EVgckdzDNjznYxfyhT9hIvEleurbbifQLPExjn1vO6pb7nl5b27QbXQlucbeHgthMbuXo1RY6pdOlZo+yP9MWFn1pOww/tJX/NLQo2Lp28MjkCKQH5uitZXd1XW8bGgIo1jlGPuT6fbzB2xFpHNQVYWyf46dA6aXtejKubVoQ3H126l/mGsqVI8F6xOiWuBQjl+obRJqehmnhWQvZj8sBB8RiH6HF+F70NpkFDkehJ4Dl2TM7bR06GG6lFL8BSRlLz62tGayRGuWj+kkEQd9FCNFLeCHNugRl8K7ZJJ0muoxnqWNz/rUcJJHacIP2im09P4+PYG7f7jv8VBN2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdhnVSCLNmHkgWtUzcrvMxgOXOh7kZaU3PvxcLyzANo=;
 b=ZhUlGlGMd5YJpW7bjwScl5W500OXuuXXj14Gf40OTSaBrpPHcZdV1JCPQPy18h5G+Mh7Eox4rvuThnUEXJ/WwQg+SHDkQs3BmOQFyf+MYN1lA3i+dq+bzfInGeuQqQRl5CyOtWHL+IGVcSawTwKvT6hjp3qnvN1fMH1X/ZOUBnU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:30 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:30 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v5 net-next 11/13] dt-bindings: mfd: ocelot: add ethernet-switch hardware support
Date:   Fri, 27 Jan 2023 11:35:57 -0800
Message-Id: <20230127193559.1001051-12-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ca9c652-f4d1-4e2c-d1ad-08db009dc9f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z9cc7cJAXn0hi5m/oFOjCFCuf91vVdYqP6aT7HSWp6kh8HKtxkHOGAy5httTjXTHhsyTSrcVRTPbDZ0BH6SpUKYsU0mXDY0KO0l0Vd8uYY25i9SUnQveDKyIbNCjRrSlNWt3mQwu1RijUrWBRTBlM3n9PV0YPCmPCpRrXmKPMbTJkOVzNZaRdaoU8tzbU9jpXnfLtPWs7KrzayC37F647sPdaGvR9Fq4zXJywfWN2d5uuv/5n1uRRUoQJf913NuMAIkZ4gcCdWlbYhMjh8jqFhuGQ858awpM5/kgEhdfkWiWONsb3CNKn7pp6yS7M17+DUnhvwa+Cu2yith3qJbk9iCCTTEWBofuaajb0Su3P/VCL0uAq9F8+l3Vjk5f0NrwcoTZGGMOtbdtvuttdVP6/h4jS0wm4KxOwe0DB+oDncyBEOtdvYO34CWP3QZAD2fICM6mepjvrd4NXmCp/JqFtKLgpq1dPkFPj34/oILBZv+XAGfKgmnpw86QXJWMBE59/sZeqnekeqcndIM5IrA8fFU8C6DhgAASCHn2RHGFVdy9jcwd+AxNrOTcqWtfqvO1FUAPCN1MRwe7cXdFapElkgSrFptBUGObNNPB9JUmqC/ba+h/3YAIuBg/oDr9liIroN9ZxNwXELzxBJSh2x18ywV2rAcj46Wl2rHvNb4TjxremF76hD0i07JM+FxKb67MRWSJLYCQm3YjDHeTVdojSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39840400004)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(4744005)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mrG/4MMMcUWqWKvNnvFJHF7WodAItmu4VydDgX1HaFw4BJ5pBTrUpd50dLBd?=
 =?us-ascii?Q?cjMRxACDyE6MHc1UMrO8HYA7vtLBiddBZfZSYJf4pSnqW23gsXxIPRGsFZ2B?=
 =?us-ascii?Q?nEr00iuqtuqF6Seo5YPzwy4dYntQOBM3N31iZP6Yy78aXpB74eAQnjaWuT7p?=
 =?us-ascii?Q?dYf9Y/8ov998yNmGfcf2aFoJDWTy8bybeyYPhh645jd+M04+kpmZM4AQ+MDX?=
 =?us-ascii?Q?5Jbz4D7/gYWWVRfoPohUAJrp/3mTwov53NullqyIRbOkXaxz0Z7Fa0ui3WVE?=
 =?us-ascii?Q?LIVHZ95PjbbehangqoVvZZ+E1R6z4unFJ15wvUtcCsczeQ8BA+AHwhmeDU8l?=
 =?us-ascii?Q?GdCUuQdrvBgWvJ08T+NNWMujL8D3YJ/5GgvKemPP9cXkpxUCGTB9bLMhL4jt?=
 =?us-ascii?Q?CCV/qAD6R4wk3QOImvktjgqCdueN37Y9dcQLSExbClOCLkSkl+JWlecQk2J0?=
 =?us-ascii?Q?u+wFKc0nMMvXKfGnKFP8yAb2BTlDYetduz1QLKQPbGwAh/6J3XCI3bRQjAyJ?=
 =?us-ascii?Q?tls7VgN2KUtnnAGlNsoCPiP/P3anUPMnEaWEsYyf1Yg8ZZv7GDhFM1x88Jos?=
 =?us-ascii?Q?YfqmS+RVwQpa7ssIKm+lujhLO5aws5HvEV+fzcCZDFnWmy0whmI5nJ12UOWf?=
 =?us-ascii?Q?/d/8Q7v0leN0tfiV6c/II7iWuAAIWvtGzPDhckB6tYuF5bXq6dJ+LXBIgKyY?=
 =?us-ascii?Q?O9xtujjBIQZoBc5PVZXq04Wxp9Vsu4t3LHuXnCB23UF/Ia3fnemfzQpHdw9+?=
 =?us-ascii?Q?WHazhWRqmaBKRXqiejt3kDbq+HhWcs6PVFviNPv+pkbtE6Oam3GkLxIWFLVE?=
 =?us-ascii?Q?ui7pxkA0pwMxwYGnvczEJH62gLTO8qm17/QMfA3pK0CpywlYrfRPNtczmO2L?=
 =?us-ascii?Q?TYpFBCbIrZjFJLXtpyqhR3Y+RvLpKnQZ6YXDViZQJUPU3j4s65ZodE6R5Sgv?=
 =?us-ascii?Q?rXKTyjilDf97yYG4LjzXn5+p5QPKka6a+zudYpeqlNxJliF/VLeQeAObPcH5?=
 =?us-ascii?Q?Jrf7orMxztxuRtYQ5YjlHTdPIgXHrcvc04XbyhuzCM9YBM2nEwEFT3uazIsk?=
 =?us-ascii?Q?il5wG4EJqsB/mv4gL8Ja2ScWAiMAY3LG7N4gY2RYy93Lm+9S36GlKmqY/F12?=
 =?us-ascii?Q?6n0g3hCYK5PzwJ10rghe78tC42knCjBNy0p4ytvVAh41YrdrOA57k3n5yl53?=
 =?us-ascii?Q?4eF3axfMrsYoNe0bWOmBFC9yvCCG23f6w8kE42aZ2pYF3fdlxfsiucSJqRjf?=
 =?us-ascii?Q?1vIAIf8vZ5nVVjvQRe1yzIgBMGitO6SRkg/jsXsOOnvzgqlfgDgpQFelHXmj?=
 =?us-ascii?Q?1asuUuzu2JthSzWWKR2RHU1qWijI5dxs7phMYYt1a70Lfe1vAsw0VWG39egC?=
 =?us-ascii?Q?YciivX5zwOHFTQa/YxvCMjpgSUC0k6AOWaRDcRdKIe3r1tCjxeqpc92nTvoo?=
 =?us-ascii?Q?w7HMTeGD2dRT8Het/gMHJhj2qlzHoJf2RVG+XuYukdP/OeffTCVY22PrVy3T?=
 =?us-ascii?Q?2KtoXFYUVGso+IkJ9d5BQb+pYkiCDNshu6HsIO9bSKBFL5sGNd4/mh6Mu9mD?=
 =?us-ascii?Q?tQ7iNZYC18xe8lv4vMSi3tR65ywV29sGYNdeIEpGtYZkt/XyVWz/j2XcSvuo?=
 =?us-ascii?Q?9Dp39fLoeosN3PIcKmIaX2k=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca9c652-f4d1-4e2c-d1ad-08db009dc9f5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:30.3440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LR607aQpoDuhaGtZKl9lw1FzHjBkuwLVz/KBRzFvjiC2HWUiA7xkSrb6zXsU+dnuIOelXFAjuq6zXPRLLRARJu5XwTUNyzfcmWLZ/7rmSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of the Ocelot chips are the Ethernet switching
functionalities. Document the support for these features.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v5
    * Update ref to mscc,vsc7514-switch.yaml instead of
      mscc.ocelot.yaml
    * Add unevaluatedProperties: false

v4
    * New patch

---
 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
index 1d1fee1a16c1..8bd1abfc44d9 100644
--- a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
@@ -57,6 +57,15 @@ patternProperties:
         enum:
           - mscc,ocelot-miim
 
+  "^ethernet-switch@[0-9a-f]+$":
+    type: object
+    $ref: /schemas/net/mscc,vsc7514-switch.yaml
+    unevaluatedProperties: false
+    properties:
+      compatible:
+        enum:
+          - mscc,vsc7512-switch
+
 required:
   - compatible
   - reg
-- 
2.25.1

