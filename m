Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D73640F48
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiLBUqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiLBUqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:46:17 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E54E174E;
        Fri,  2 Dec 2022 12:46:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzaxF1iUyGW75v14ILjL5QJimgU809aaDu5syjWYKzUILaZRNVr1qFnIGGTfHszGGJA9EFfXM/moGeGpFGYbYW7B51Xi/dORg2bvczng6PcFWtqyH1DRrK87OzZ+KC5yEscsbmcteiLWl3ea27Ho4z3XEHvGDgF8uOYSi20sskEblJbWBnje4cpdDW4Pa10cIQrXJgRWE4q4uK0DSZeNYsne8xt9BpKMIsssNPi2vmomGqa/5VAcHZKLx+vK3CvcITPPb8HxakEagLdihRxae73s/lz/9fr3hvHBjB32Q41jpK6T+WTvl3/zhNboH+ky6IwmJbdgx6lViJd25kKPQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXFi++lkja16w/FExAPqKh64NH+6QWLAkwGLxKjTCNc=;
 b=j4QMaEQlhGwbTF19KV1Oz3N/y7subJErz4BGsWT8rYAnNiefefhhIVhHkJ7xTHl8fUu/Qo6pna73jUyv5qrgwQDbmcomaMnZ0g0l1+3U/klB+pGjflRqrwMMZqKj1QhyCdBnQGySta4EK+J6/5iT59+grVDOMEqWQ1I4rKVZfCsVHUji94W+MssjCj2peYZQDZB6g2Uz4/j00eYdc1uGbvPL4+JuLhQvbmlVVMeEjUyNqBjfYQzfI8/NdiFDQw7cFUfKHLb3/XScLXQq4Nf50YXblg3D2CU9LpptKtRj0UPYja1cTPtZHCXK48LnX6NaX5ixCVU4x5l8AGAMmTE3jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXFi++lkja16w/FExAPqKh64NH+6QWLAkwGLxKjTCNc=;
 b=y5oxsdAKSd663eaxPO/bBlyKsEYKvAIhov+g05CRmAX+wVlpQiGr0k2uc5NmLfaJSnGP9gY3O9XFaXwXQQKwDZhlsTwcPOvNvXaOpCvYfhEQpolCbvwAt1TZ7OnzxpKRo4NjMlC1TsSwoJ+pbArVjQFFPqgzHmOhAOj/LRRRsmA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BL3PR10MB6258.namprd10.prod.outlook.com
 (2603:10b6:208:38d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 20:46:14 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 20:46:14 +0000
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
Subject: [PATCH v4 net-next 1/9] dt-bindings: net: dsa: sf2: fix brcm,use-bcm-hdr documentation
Date:   Fri,  2 Dec 2022 12:45:51 -0800
Message-Id: <20221202204559.162619-2-colin.foster@in-advantage.com>
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
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BL3PR10MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ceb862d-b331-4adc-0576-08dad4a64004
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d6vSPXLhePwAc1Awb/z1YhET95zN7HmaqAfWiat4lQRdIYCw/juPM2nlwnDyxTHP8Af+mQUnENA/NBSpMpjmkKBy3l0l5Ge080Gr2ESzwPwkJEWfGy3/SHXGd3DReFqTOLq10GAvBfuagB0gfa5Ogj4so2K6/dD3a6kdqrEzzTICyYYud84r5MHcOBifxspcU7mvFXcBcwYWleMptWNSRU+GPFYe0XDReSHQJ5f1rMh+FvatBCzZ35SSQDscOK5oUEW3hkKhImIehuuZed4+rn5SbvPQxgmZ8v7eliurgOyO/zee+ujs3WESlQmzncEPmsMWRaoiZK0K4doxCt3UKqiUQqk2hsltrqUUHeehrz9rLxGXJTpqhRYxh2WEdPTn1otcKxYNTy18xmcPoOdwnYM1cFh/UUA0ptY7tgTQlJDomqcHmMDi7/lwax7DVABwVAFyKniQ+kCgwXKsZYWIM7+e/eFLQ0A562yY+X9I+XbMk3Xs9e18cGehwodVFzHufBgS+riLYrRKltYGheGdOyZPIrUY2sdcNj4SdkpOcRiBJBVaBLYbo/cwIc9aSPvZhFGo9r2HGNm4dMnV41Zyy1COCb27VhGYbNT6kY3VpiCRj3YupWsrv5KJHAundufaLpxtPRdp7Cq3qXWTulvNwXuliLZFLnqqAE/9kW9J5Ss4Urgmk1YPLjqQQd2kcTzfoe1T2sb2dYre32zSwCIEgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39840400004)(346002)(376002)(136003)(366004)(451199015)(36756003)(86362001)(6512007)(54906003)(6486002)(6506007)(52116002)(44832011)(478600001)(7416002)(5660300002)(41300700001)(6666004)(7406005)(66556008)(316002)(4326008)(2906002)(8676002)(66946007)(66476007)(8936002)(38100700002)(38350700002)(1076003)(26005)(186003)(2616005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DwoQ9nKMGN2wIwM+ruDF/Ix7neG6BLeE3klHh7+kwrfY66J9H0UOKwMqwALF?=
 =?us-ascii?Q?0u1ULAeIJngT7NE+AUSO4ZK9+qM4jcEts7RKI5uOd7w3C9T4etVOvwVgRe2y?=
 =?us-ascii?Q?Atx0UiUH0iy84wmo6PPeEPsRSt719POgjOL88e3FOLsRomtB4XBzLsOqDEcz?=
 =?us-ascii?Q?r4P5kIihYCiJDIcFSfmFPboq+BE5eNmiaG3BlZci5e2nEBB7/kXWo11hCOtV?=
 =?us-ascii?Q?xXp5HkUndZHonjrrcKIG+DdSDg9To40LEIn+u6fbWRomDKE2EL4He5QBLbfA?=
 =?us-ascii?Q?Iz6tzhoLF2vjkXklI0MdcsmW8mAYJrrZ7J8PL2no3ZgFvRFn/H46ZUy/6vRx?=
 =?us-ascii?Q?SoHKk4adke2BrnRclj3Vzeu7JMA21Tnub/ViJdWowzIdOxUtqxQ8vLrLUsC0?=
 =?us-ascii?Q?hzkj28Bz710qmjZLbNNehAcxbd+j6W1XvRI7GdXrIRgpRLP41buqCatOjShI?=
 =?us-ascii?Q?IEL4UwVuSy4u3mObDB9yryefu/nXiF4bPWq5SvVrWatjh3+LUkkKyTokzc4K?=
 =?us-ascii?Q?nUJMoAoQ684Bf8wf+vT2FV1ClTE+s+vCWwunmu5lkgH9zjLRPLkZ7xFvoCWy?=
 =?us-ascii?Q?2GC9iXN7f1FHhwedgQDcDvxJ7qGQa7DgRuC/wRXbgIjWudAM6mK7SEL9EwWt?=
 =?us-ascii?Q?Tb7UjD0tUNUaSqa3mwHYq3knHua9Kve+mAsV7hqIZVHu7ZSKdLb6z9XnD+82?=
 =?us-ascii?Q?YebwSDHxQxNcpsotNxU2YwpBflWGCiMlWvaCYmYZRirK+hlF/Xz+CMHlRAIz?=
 =?us-ascii?Q?I1QZDrq+KWAZNm2jUl7SBNn8BTxybsaVuleFFw3GEwrFmw0Zfr8FKNBZbHpQ?=
 =?us-ascii?Q?hGZGKor6SXf5DKAAGoxeApfQy2Uj/zOdQozKqvo8LZ/vxsMP20L+l39YpqqO?=
 =?us-ascii?Q?FpYQeBCc+lqA/p+Ao1k12OcUCDvt8dtnXTMEqrYR4Vf/Z+T2hRKOvBYffNN2?=
 =?us-ascii?Q?DXKR1XyZx5tnDjE207urG30GWm7p3kF8PpuOecj73Tg9N555rLPFgsEQAgYb?=
 =?us-ascii?Q?AVdxM3Q0h0zFvArICVyHxYeTRU3+vNetfEcDVWoWyzmvY3AXrfnIviG2UuPr?=
 =?us-ascii?Q?GQOerpEUXPMa61LpCyZNTGHc51V0BOWADjeeRSrCTjjHErxy+NJ+fumzaueX?=
 =?us-ascii?Q?J6pK2kDJZPOh7WQyPap6uOLzkkRehXSx0lBJNqjoll5uZ2HY7xstudvBdEY9?=
 =?us-ascii?Q?Y4ywEjD8jvLHCtpDEfJqGlaZbWwgF+fDktX8gnIfL+FNhAJEG5ZcIZf5oAz8?=
 =?us-ascii?Q?cJX0+ohr9XaRtGzOlqb9mo/L4Wm/HTYVqnkD5t+hrgxM8VbmvbVKpM50UkY0?=
 =?us-ascii?Q?qmwxarVAs44wV54gM13Skr491mx2pTGO1UhQFR+apk2uawmjZYLvRNDR2Ws/?=
 =?us-ascii?Q?FyPb5/5eNQOwX/Il8Ws5YIeipo82saY6UuB+lg0tycB5RCbPm0Id8gkoLh5g?=
 =?us-ascii?Q?QyWKE1eTQRnd6VLgBRXSykv9G/tFR02vUJP+o/nfnhne7Gpp2diufiMNNOKY?=
 =?us-ascii?Q?PkOKSOaE5E4RM8H+Sp3gxqo+inxo5FlNqJ2sLkp4/hbHq5tS5PDd0hNh55RW?=
 =?us-ascii?Q?3U1hUmOQkleIUczNQFKZzl5EC1ZmbsIv7pf3mUlBHzHIjFVXNgiE4Ixm4VfQ?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ceb862d-b331-4adc-0576-08dad4a64004
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:46:13.2042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: inXOEd69Q4Slpxi17lVvcXFxI3DyZ4tEqDP89cQgXrHlv8IWf1LCbMjbV9bbD2CbRPFzZVKiOphzpi6lWvX/IrX2NcuFyRpMw+O/NgMEBt8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6258
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The property use-bcm-hdr was documented as an entry under the ports node
for the bcm_sf2 DSA switch. This property is actually evaluated for each
port. Correct the documentation to match the actual behavior and properly
reference dsa-port.yaml for additional properties of the node.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v3 -> v4
  * Add Acked and Reviewed tags

v3
  * New patch

---
 .../devicetree/bindings/net/dsa/brcm,sf2.yaml     | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
index d159ac78cec1..eed16e216fb6 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
@@ -85,11 +85,16 @@ properties:
   ports:
     type: object
 
-    properties:
-      brcm,use-bcm-hdr:
-        description: if present, indicates that the switch port has Broadcom
-          tags enabled (per-packet metadata)
-        type: boolean
+    patternProperties:
+      '^port@[0-9a-f]$':
+        $ref: dsa-port.yaml#
+        unevaluatedProperties: false
+
+        properties:
+          brcm,use-bcm-hdr:
+            description: if present, indicates that the switch port has Broadcom
+              tags enabled (per-packet metadata)
+            type: boolean
 
 required:
   - reg
-- 
2.25.1

