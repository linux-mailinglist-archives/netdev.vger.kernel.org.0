Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B47667DF0
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240695AbjALSWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240364AbjALSVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:21:23 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A644615720;
        Thu, 12 Jan 2023 09:56:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gpv2Z9XkmV5/O+NO/XmmUf8ftYD1DctaFyGTRXkK9SShSU01GDCeurQHEepweo2fRpln8ZKittZa14+2DpLMZTO4vIlERXGOuKYhD/Me0Uk1Q7sxRfbQxGA+iSWYemDUqrSIs/CUT8PjlKmJKs/a+8Yr0Bh6fIcKAWQ0b3QqsVT3L5aYel5SGw+In/jLnvr//+N5cWGFi4horHjlIxMJtodl6SR/1b9R+HFELh5xlSPYRgt2GyTcXePaHnT93Uvez3ROTfthKpAvpPnFdRwXBDtHsdrSBesvvSrBRmFJj4c1CJaUe61dXEaIDIvX42ivzOweq+tryQwa6/tqoxCnwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NNN4bX3yrRmVP18izGOcKzc3XHhKa7x/a6+yqKqks7c=;
 b=H0Dxodc0vM+tA1N9ciL9ChZJ59AT06FbLowu8569wWNC35GiMdmCxLkWi5fcCi71l5WIDO1ZuQt3zoBRGNPUH1slaRs/TS+y55keaS/cKPsOuazEbOPt64Hd8RgCyxY7Z1VgXoGU6/jR6TV6mGCPwfjoZkAXUlBVWjovgfbjUF/ks2EWGj7LHz28cfUuW+KfmVtkF91B7yMO054x2Thz92t9IOVDSOV5hEALn2NfnKSGxYuMgTcGdwrO7yAQLLkc7wPMIkRZRxqtRRTlLrivnA7v5rg1FPayK/+VkIqS6/ime9+1nuOyNRsO6knC4WhAHVrJxp4jNSzn+v19p0zAUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNN4bX3yrRmVP18izGOcKzc3XHhKa7x/a6+yqKqks7c=;
 b=Ko3+PtFj6y+OGNvEt3G82llIXbbbHKVIxOGpDB636qmTGPI8XuI7vwc4YxkpSDAm5AuR+APIEoXiT/bfEH2+9rsDnTdkHx18pG4aNrdPZWrZtIakVGPdo+kBjmqRrhas5HeiwDu84iLwbu2LYcLn5q1m8rDeueKAlMiHtfV2BVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN7PR10MB6548.namprd10.prod.outlook.com
 (2603:10b6:806:2ab::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 17:56:46 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 17:56:46 +0000
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
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v7 net-next 05/10] dt-bindings: net: dsa: allow additional ethernet-port properties
Date:   Thu, 12 Jan 2023 07:56:08 -1000
Message-Id: <20230112175613.18211-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112175613.18211-1-colin.foster@in-advantage.com>
References: <20230112175613.18211-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SN7PR10MB6548:EE_
X-MS-Office365-Filtering-Correlation-Id: ef6945e0-3f22-4ac7-b24e-08daf4c65f11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ZwupCiZHqOAfc3liVwZMCkXjaLFyx7968X7SIMYby7A8pN/AVKfgI4mqN77PARgU0k+FlPupZM4fQRr2bk2gozb1DaDj3MCmF53pFKpLP7h3fdHhHoJaIdC5fy66/Y76iuZqQ9UAhPLRTZN9hLjPzRev2EwAoEXP47cQI/YyX9Y1cfdTlHDQai21OGnZW46YgRMmeN1rczeDNVmlzeUNxIn75CwhNxX8I2BrNSD6ajrn+mtwrobTfQ9Wf66Dt7rUZHO0R2qbGq8w1GVRLGrRHogLFFRVGYCYL9/feh7oRp8oC/0aF8ROCSHePJPK0DjWSlEfRcOMPqnvohg6zRpty2rHGihRw0rEcKzHEjyGbTyYN8t3Ks1ex4wivKvKmamM+KHF0oYrMbL6D+DL0p3G86w2vL04kiOeOj5Q258qQRdPnq1FiDQt/PdnC/8wFCf1euKLqNuB2EeH2krEdVqw5HJMZ099B5l6E9S6lqr8hXCbSQ2yxC4UX6LAkujMY1YLlSAoqGk6MZ2z28oVYO4pOiNinq1LMU1WkWAL+psIeaoYFQxSdgkLQXVzPSEJmjFdXEAQv+0i1Xj/Vd1Jb/qSIaAo5ie6QA+JOaNhrqIJ//6NSNVPYTywPeX9Rc5WdIs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(39840400004)(366004)(346002)(451199015)(66476007)(41300700001)(66556008)(66946007)(8676002)(7406005)(5660300002)(7416002)(316002)(44832011)(54906003)(4326008)(8936002)(2906002)(86362001)(38100700002)(478600001)(36756003)(6486002)(52116002)(6666004)(186003)(6506007)(1076003)(2616005)(6512007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zZfMUbbHBZ7fj00SKjM6L31mj7p5Itp6lI1JHgfyRz0dch2cvJR0jhb2Wi+t?=
 =?us-ascii?Q?rfcH5JTOti3oIYILZs3mPcn7MeUTHi2H/bjTIJcLRf+qiHJ8cu6oF2phIgO4?=
 =?us-ascii?Q?OdE9eEJ3cf8qp3ojDjXLvNJH4cam+tyNOG1NkSnB0e/LFyOkTcXSUq4uBiD6?=
 =?us-ascii?Q?mJcgSZCyu9JqR4O7hmEhY33HpdqTN05MtrlIRr3R7UysMdLKQoV0pHUmrs+k?=
 =?us-ascii?Q?R/MSfQ1DN6l11cPEnZx0rVMBD22kIulIY3KIkPUm1jMg8TrreJ8xbL/jEl81?=
 =?us-ascii?Q?2FPbkEdAGYyWoGs64fq67+x4cZX0AQZta1yPWOzRuEnCgxY3a4nMNQaUp3k+?=
 =?us-ascii?Q?ms8/vgP1qvte4t87Z+G7XN+6ikjjb4gs+h0QwhBGKaTgsvPXviFmtvg8/Nql?=
 =?us-ascii?Q?OGdFW3sWNt7CQhiwV48ISGsfyadCI7gceqJM2eTcz8m6ivglNEiMxqW5GeH9?=
 =?us-ascii?Q?qD2VGzw6G9ptHwa9E/75XI6y4NJTiut8rJnXgMFc1iuCKNe/RbCxyb50+CoQ?=
 =?us-ascii?Q?stE3lD/n5CCQjdADmLi/slDbkWuZjjOgNtL6iwdtZ5v2JHsSajwlZIy3PzcV?=
 =?us-ascii?Q?IDnaej/UQ07IkmEvC274SmQq504SCPT3+r9sKigXh8PHxrPOnBe5Y2pe+5+Q?=
 =?us-ascii?Q?ZifYGrPgeAyna360EZ8y0AMTD+ZI2mcXcU2+5jmAjE+3RM7IzvvPrIjUnGZL?=
 =?us-ascii?Q?AT1ICiM4/p9tm8QSn2H+dV96hrJL5wRM1NM0GvwZ41VZt4yUx4rE1cOtZIxr?=
 =?us-ascii?Q?so0+JbS+PmDp0HDXBAEY6O8VM7VPZDiF6NcXB5/sFFp0CCpeg1LQZzcIPiwT?=
 =?us-ascii?Q?Z52AISpwzH+6Q0dOm/EwVDnKRGbLeKMYEjoWnsGVKZcR9zws7ZgJvUy6tidg?=
 =?us-ascii?Q?rChW1+apjq0CDqo2fVsoASoRyWAIJuK/SKn5rkvw8Gdzi0xn2sRj0B3iIwey?=
 =?us-ascii?Q?NLz6c+iJWs+nyTsvLkDJXgw3vqtaMq3FWRBnMSZUw+b6tmYY0h82ZX5MKSSz?=
 =?us-ascii?Q?VyyjneKAlDSklhsipSJI3/yWEkFh1KcCetdnIQWaFiKYKlSIBaxlO9Hrq2oc?=
 =?us-ascii?Q?F65t30OcJxdxSAqd+AY2WjupZx3S74/F3+e1zkomvb6cYiwG+i7uGB64kUWM?=
 =?us-ascii?Q?yJMiURBVzP4qdose5Qds74UHA7w67yD41lObb7oIWSLi65RPJ6NgJCC98N/k?=
 =?us-ascii?Q?Z7aKVLsUOCQjMKhiElci9pO/tDqc9hdMIKzSuWBkp2xzL78K1To/5rOQ9mmQ?=
 =?us-ascii?Q?pucua6ndJJEtc9CFET4P/3S5q7olsaH6Y+Lb59ljanNpBaDjkLao8wvYz69T?=
 =?us-ascii?Q?NWJNZFpZdpl+Nfm7kGT3OKq1DY2iy6gFWU3CEroOh4r1tTwP0iRqEeG6UYoL?=
 =?us-ascii?Q?+xoRWXnbbTzDFKLwhUVrgxcNll4rvPv7BEu8d+Bl/GlUrrL+JzYLmvHb4Msi?=
 =?us-ascii?Q?G27hhJIlaU+7k1ggm7Ccm79MR+DFJvUBTS9FgPm6b2LKw4ZXuos8QrGHSEhk?=
 =?us-ascii?Q?0uIFlocWPKTYrZmiALUz5NyR086iuSjAb/DXzr7+sKvV3UiyW0U614mXGCF7?=
 =?us-ascii?Q?OEMr8tD19rdzKWQEIhRjspWikeuSiThf4xM1+q4f9ljBM7DpdjqyXUXatW+q?=
 =?us-ascii?Q?uN3MfQjWPP0nH7FYa48mGGVs+McsuaFSYrPI6H9Hue5UIENSBrWRM690Axup?=
 =?us-ascii?Q?SN/lTUd7IdoeJ67LUcflHB4dYR8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef6945e0-3f22-4ac7-b24e-08daf4c65f11
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 17:56:46.5168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eRRCFaCLm2TL3PhyDvmdgcqCKKChQupiNLpI8Ws6JKjP3TBRvEMzE81nina5LGPY1tqCinj+qFSoz1dP16Lp02SCdmJpteaVhSq+7AjsAXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6548
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
Reviewed-by: Rob Herring <robh@kernel.org>
---

v5 -> v7
  * No change

v4 -> v5
  * Add Rob Reviewed

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
index efaa94cb89ae..7487ac0d6bb9 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -41,6 +41,8 @@ patternProperties:
       '#size-cells':
         const: 0
 
+    unevaluatedProperties: false
+
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         type: object
@@ -48,7 +50,7 @@ patternProperties:
 
         $ref: dsa-port.yaml#
 
-        unevaluatedProperties: false
+        additionalProperties: true
 
 oneOf:
   - required:
-- 
2.25.1

