Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C13648CD3
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiLJDbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiLJDbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:31:07 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2101.outbound.protection.outlook.com [40.107.223.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171BA8D1AE;
        Fri,  9 Dec 2022 19:31:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uo0hcq4gnBZoXlYPXXvQnNksi6f7kY4rdhnF2arkhDlzSjVczTs8geSmHbHLfYqD44AcGAsDXtr4uBlx4ZKfjhKD5iypvaqALAwqSbIpiqJ1pvD5Foyl2yKrSJ4ywqyBM15fsFDP5GwSrGFg3vKphAJvPFigv7WX7Cbb/J+D1E7sEhE87waRHXcF4RzvO8cZt5T4OxCha+cIANmm6evHu3vRQKzSARXiL+R46EQCtR2w5YPNplbdX5YgbbrvAv23d8AeGSGzhh/Ai8JAIrXIZEhfu9e5lu2Kgl6zKZZYhI0oD7vE4U0lYiv5Zb/5T0AK70OxJMHTVdkpE3KtU8w4zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFRqqS9Wg0MCBApd//LM6rU6F4S4HoXJZ4paTTxS9dQ=;
 b=TA48CE6drMdat2+zeOQ15Jq2O16v0koHnKHn6xp0OuNwRPzkyesPI2vDaplBOA9QEDL9QHQ2/K/iNDSPV7VUYsY1VTDzr7iqx0TxGEdgWEraeejlNwAn1A2w6hCLS+RZIhLOZq1FRTwLv0RRFMd5Dv05MGoOD1Xn/nAfhRh4Vto+OKsPWVGSLbv3WMOUXYZ+TlM1j0dfBTs4n44BZssJxup+apDqymyYaau5KvLPQS9VCXARQqX5IgYQyV1qN5O2Oip6wEbNTsIbLg4mX+QWGMirlSgyaMpRqvivULynXYV/kQuUj6jLwSgTZ78Xn9bLojgThvbpi3Ov53i0n/7mlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFRqqS9Wg0MCBApd//LM6rU6F4S4HoXJZ4paTTxS9dQ=;
 b=RlMjBKeCVdluoleDWVS/VjOLo8eozxSFGMS+pM0AzZvsn2ARgwN0rr8VSXrRCzF71aliWuWkUkiBPmntsfTFsWo28S6uM603E716JOKjfru/D4coCVEfLuXnduRvFhXWVFpvnrAxy4JdnyYWKeM3tk0mPf9kt+NN/1B2wtFi9r0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4779.namprd10.prod.outlook.com
 (2603:10b6:806:11f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 03:30:59 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 03:30:59 +0000
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
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v5 net-next 05/10] dt-bindings: net: dsa: allow additional ethernet-port properties
Date:   Fri,  9 Dec 2022 19:30:28 -0800
Message-Id: <20221210033033.662553-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210033033.662553-1-colin.foster@in-advantage.com>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4779:EE_
X-MS-Office365-Filtering-Correlation-Id: 650166af-ea17-45d5-b9a1-08dada5ef492
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VK2C/gER7FAoghxvP86Dwn1EihSTQQ/uT80cbO+Kf60+X0l8yaFa+GRdbtANnobs0e11h5YeY4JgNgZQqWz2LpodYZi6+BHKk8bIKjAqmo02dD2U8pONgKrMSODS6JHMkkoKmeIAtw3yJJ1bK8PMuT6dpATT3RoxCMvDxnlDGMD8Uy8g/vMTZDjVo4whp8NvlJaq8605BXb633ghpQc2Bl81UYHvnFY6C2kgvrlMwAgKy5ZBaI+qP6pEu31mblsh5XoPEk8K519fo6oVp22rAa1WYfSqOUKtIrCw2/eZbNzQK84iIIbO+SlxAxuNTdsiWjrjMtctmFXuUBA43mejkf5T/kSEjgB+OSimpEs3tGD1g61iDEW/5xU4XAeLlpg+FKpg71Nv3NTXVyR5THBdARRsPULi3cqU988jAhA02+SJnYX5s1/3fsomIadhtiwboWxtbwn52ihQSphYpaFbKtkxwSw3N0p7nSr9Ww0gwHVus5DHzgMrVIesyuzjsAJfK8zd9pDI9wCgAw4+7iFbqlcy6wsUHJrp7ecHHNThllOWGhgQvTZPpMlICK03hMIQePm+JOIZjAo/aRfIcLYsQOvrwSTg7zBdLlRhdWf+o/GSLkD6veUv+iwNI+Cqs81YYYrVsnO+cu4yktC5H+t70b1k3JkAV5DK8Od9JZOFrWl1YLs9JZZMM7S4gzeRO+Xl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(346002)(396003)(39830400003)(451199015)(6486002)(478600001)(52116002)(2906002)(6506007)(6666004)(86362001)(36756003)(6512007)(26005)(44832011)(186003)(7406005)(7416002)(8936002)(5660300002)(38100700002)(1076003)(38350700002)(2616005)(4326008)(41300700001)(83380400001)(54906003)(66476007)(66556008)(8676002)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BQHHOLBAWe1tNOsqwO5h/CZop1Us7imyd6Ki57nqflWcNaeLshyBNT/45BQA?=
 =?us-ascii?Q?Z6JiskFvivn8UZkIK0FUoW6geFCCi/4aqCLkZtKgconV17vpDxYWkMaxeO5O?=
 =?us-ascii?Q?gKo0aL2U/PbzSdHQm2jFr7HB3Xtk889ReU8RuEK0K5yvgPOMlBlmAUMTQtc5?=
 =?us-ascii?Q?YKC6Lpj9T0Q8nXjaSBdtTW2t5I9Be5na/rPb/PC/7fvjeYC4FpA93vILuLMf?=
 =?us-ascii?Q?Hx9ecMJkT80qMNZDS2UmvFxmxjqTJcBV71tddhqVsdDMuVXOgTGIMq31sAZc?=
 =?us-ascii?Q?OCZ3NSL0zH5cvEwqkXbAYOMwsxAPOCT9Hu2kU4Bz+zHknAwNMAF64qQqkikl?=
 =?us-ascii?Q?DGv0WJhBh794Y5mWIspQd997RLhEz7SkUwgTvihwK/TcO4JnDyoEOGx5qglC?=
 =?us-ascii?Q?R+GbPv/GfvbwnzWOGEKYHJ8vsmD8jiUB8cCKb+2YAJoJzec2e07Xjhu2NiNt?=
 =?us-ascii?Q?AKOxyIXcyLZAFDB2H3ObpR7KSBbY1k+gxAav+r/qGxAQ9uJNz8hXNTqLaTwT?=
 =?us-ascii?Q?K+bdUL84Y3pVtWAunvsSK22zDHIVOu0VVPXz191fdvJCe6kLckeOw8YX3hAz?=
 =?us-ascii?Q?FFH2V0yYJaWBJHrFYvYrBiWvwQd1SEpUcu6nNQ2jdXQQLkUQnUkV2e5uMY29?=
 =?us-ascii?Q?QdnYqlf32lGRWCAlULZNAYGJNFwmxeXWR8nsHZXZgy9JPdgaYNCAmYiT4rTL?=
 =?us-ascii?Q?tPqCreTI3uqlC3RdliUTkcpcEgTEp22H7AuiiirRF7kA3vys+AaALL3P0Pso?=
 =?us-ascii?Q?lkpGpYX+T8cqt7pRdyAc0fEjydPifer8sDpcOQDl1nDkzTvpAdZGyAdjcrgS?=
 =?us-ascii?Q?QQHEpRzcqKhXCnRnC6NNW5mOrt0ulXPSXbN6RVcAFrOnu7jy1pAvkzojWfd7?=
 =?us-ascii?Q?pCkGm10jmycQ1fV25ckeYLe22S4EXw7hQwg4xb1yf6CzGZn5ZxBkZzzFrR7b?=
 =?us-ascii?Q?OJTn4c3kmfrESzF/YbTfnuS7SWMA8npBOCxPIdzpxWfLBHYOzKhypDEOk/hc?=
 =?us-ascii?Q?37Ta2K5PT6UZcMV0BtdJj7c86fn7cEEPk4yLQcbROQmPAeZwWwk6oGn9R3Kg?=
 =?us-ascii?Q?kwi55E0iOtEa2JaK3OOTDeF0NCz9ksAxecYoHKZbqXv5xgLu55MxHMmZrsN0?=
 =?us-ascii?Q?fyn75OalpuH1E1UNQsqulwlKxU0zXdpBSkI2rTPobypEMgmk0sDThF8QNJxT?=
 =?us-ascii?Q?tl671IUQHJ1u2/P+7ohOfHU5KQ8UOKeamWTf5eafNlUfJiRRLujI6Gr1Ypgl?=
 =?us-ascii?Q?RJoVR+/yIwjMmiU0N5rnyc1pbzqTbR+WTmaG2HikO+tb5QTgb39VUPcaFzZz?=
 =?us-ascii?Q?/leu1TTfIX4Z6MIoB2m6KHVgFQjyv6pLHN+5uV2rk2pyxw2id3zV22P0xEFl?=
 =?us-ascii?Q?ME/UhuytRTgDSnb3nV4ejA5be3IUmZiUw/P7zQ0cW+9bk0pXFbPcJ6/uIKTX?=
 =?us-ascii?Q?ubGUpK+FHYiLmfCdK9blJKKnEMDJH7q8467TFSTVGwBf3CfIToF2Elh/h8OP?=
 =?us-ascii?Q?LVg2FzMr7Ij+/V6R83uP1kmr86YXLxfluSJzSpR9VQtNYvkrod5Rnt8Fc6YO?=
 =?us-ascii?Q?4aOV8MSOrbNFXqlhv1F3A0JgYiD7lG47DH9ouyt9LR94uMrxMUBfRYHjjhUh?=
 =?us-ascii?Q?GQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 650166af-ea17-45d5-b9a1-08dada5ef492
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 03:30:59.3102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Ceojmd1Uc1+zGuths1WQs0MU3dRThctI51XRs9EURXpQgIdsW6bAFhIj2OxzzxqhUsODboVjwKmpEVmGhOHVzV4gn6Mja/pf7/XVikAPPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
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
index 9375cdcfbf96..98a79be3bffe 100644
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

