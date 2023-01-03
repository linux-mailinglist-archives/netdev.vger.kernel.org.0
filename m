Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2A565BA33
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236728AbjACFOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbjACFOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:14:22 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEE66153;
        Mon,  2 Jan 2023 21:14:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtrHRangSm4q1knYJsEJa1DFp/S+34DZkMSdQOdE5yLUU8EseMYOvhebe+zRppZnRayt/2lrjAGqvXy21MYeZbqwJqfcSKTIiCznRlWpB3zayKCehPyV0u73Etmt/sPoJ7ZyPo4lxiPL/90eo2fwmTBRngNjXSQuWUrjU/UcO88DH67A9OXktc6JKxXFXo0GsnnSNl3NEQ2S7LrYKMnCHiPY20dLNbVCjqkucMb/KVIYBSAN/hJ5Beaa91o5mcs0IpMYxSGsDFswY6cKa1DyW2ALVB4fzvn4ERnSKpQd0Zqro+mnDkRP/LpHuxekN0FXziJVLbT+3bk7OoLE6tIFqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAPzpLysuuxO7GPhDSHnGpJVbSKlTzrYLmKsMVJQuzo=;
 b=ThRigdzBh+EQsY+NHKzh4fXvygHyV2mT8VE3Z01U1pETVhiSSg+VPYjDRLfRUJlJ0hI6Tbq53AshWD5A76YhZRgvdS1lF0V2B/mSQkYTpwNNJF8f9og9sOsyj3aFfcW/PExZtjG0/m1q1iSsAsfI7mweSCFqmKSiLq1N5yBcV3sJLTpaZ8t4BXGp3sdYfJeWD5T7dJab9ZaXn3NML2sEp0lomApB1xd5ndCT1zcD0blcPNnhSTyxOmOisGH4u2jsZAYIMVpNfFIg/QDW/T/KlBaVtoFMpDCs5ZEOY5C+D+01DkNTHglNeEhFKV6mbmwGbCcsYl6S2qt8sPVg2Dypzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NAPzpLysuuxO7GPhDSHnGpJVbSKlTzrYLmKsMVJQuzo=;
 b=URbq2eNff1bwiC/ySi4sun2WS+ahwdr2c+lDUgWa4R9IFP2PzPPcAlqqAXDCOIdEu/ddUADHgDrjjGAsEZBOvM5SqXucqSmfOdjlFT6Z4h4WCxt3JpYEyaNBxzpkLg5/9MYENXQn5kdAk+nPFHY/WXftsa6yV341Ga2hGWLwkkQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA1PR10MB5823.namprd10.prod.outlook.com
 (2603:10b6:806:235::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 05:14:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 05:14:16 +0000
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
Subject: [PATCH v6 net-next 01/10] dt-bindings: dsa: sync with maintainers
Date:   Mon,  2 Jan 2023 21:13:52 -0800
Message-Id: <20230103051401.2265961-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230103051401.2265961-1-colin.foster@in-advantage.com>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA1PR10MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: acfc518d-61f6-447d-7699-08daed495c58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgAvbFwNqzbJt9usgG/exkQ7//wTE7So86T0hh8nhjgjpI5tfGX8Z5qhxL5BhOANH6qcG5N+frpYtmn86ebbjdjgjk2FS/OARPOWu1WGOo3aqW0bKIKzB6UjdV/xRx8nQJchWO7HdBGv+2IGwbMnalC/q43VfzsGwLplqOQWabgaKNXFI8sX7DOWS+qWjzynDkrrm0fNuc7HgOt3n+evfcxyBvsxs/XrkUV2NH+Jx23v3w7uYEg0IaZlyt0QcCjcui4NDI7u+PntqxZ+85AiKwmgoPHUfp48qT0F1osZdLwhSCIzly3BSULzOPzKnyyK+pj7qDkgQCGYYz5X1NflJE2M/0/jLPzUst1GbHrOp2K7S8E6h/sGXl+J2N1alYWVlRBGJHPybGPX9+bSimG+KPaoVH9Br01XJIzEWWXgA864hxEm2zzw6jqB9LAqXJsX8Wn47j5jl3sjFeSongUSJpwiGYE4uoAoraipcYANYS6bmP4HoyftargyZ3Nz8zLIoLvIe7QUz7v1XXNC+vwWRazJqoKFFpdIR9VZ548zbDCoknpI1/ZFdD1jROU86TXJ38pDTo97fiEUck8Y0z9ghrhlJdNdY4aK9ADBUFh1LyXZM5LvDn7DCOO7C7jjI5vFSmrXvlAKsFLEqyPfVr5NPdF9a9r0BxskIGyh5DrSZ21sdg1qOnTVmMrUpv1shs/XS7PUj6dLwhHfqvdocfBY7qA6PO6fEBUhOnO0ECMvGKI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(376002)(366004)(136003)(396003)(346002)(451199015)(54906003)(26005)(186003)(52116002)(6666004)(2616005)(66556008)(66476007)(6486002)(1076003)(316002)(66946007)(478600001)(6512007)(4326008)(8936002)(8676002)(7416002)(83380400001)(5660300002)(41300700001)(7406005)(44832011)(2906002)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S2JHwydOQ/LbY05wnHxNfaImAQmx8eNDF0c93O6mDnEaGcKsInP7CPfsnfQp?=
 =?us-ascii?Q?UnjdSFgU30j0DNj9/vbd4eE4rY1s/a1P7xL03SQ16KubX/S0E8fxqzpRFiRR?=
 =?us-ascii?Q?sLV3Ys8ZeH9MBE1VNvxHIPT8nIsMXjk2KBi+Zorp+lVI+JsTsK14azrGd6Iu?=
 =?us-ascii?Q?787HoZ8qbemN2BpegDIWPH2IpTpdn7DF05N2lzHy05amrPjnLyOO0FAGnL01?=
 =?us-ascii?Q?yfXOFQR0JfBdFye6BJz8MXbekgSHgbfsb//gzi333NQHRkB4OPcoLaImA8x2?=
 =?us-ascii?Q?7DaHE1K3ttkz+pHBAMB/EjZ3/HRPl9FCiIHelDmq8J5J148eMh0UoTqOBMnX?=
 =?us-ascii?Q?r6Vk+SHyvKw4/SMiJ2mlglCF+s4h33DmwSVpajDp7xmnr6iHwSUcSVXJBtCx?=
 =?us-ascii?Q?g1kjpHDNcTplfZ0/PSgww9Sb910c3ZM/tZTApZdodQZ2/7xr85ykR4sIxMYN?=
 =?us-ascii?Q?0WODzP+xC47+z+fQ3gx4PVwfbF4s0iwGBo/surqgaOrnQ3qDuPrYmW2ylY9A?=
 =?us-ascii?Q?jJtVq3eyex/praVlHNXNOGy5QxzuHMXaoxVRGX1RLt6bD5H57BPgx4rc3yGV?=
 =?us-ascii?Q?i2jqbq2bolPJ098ZphTlXBs4AH6xagDvZUs+P4ClVsM5BIraPKwfG3YwZO4q?=
 =?us-ascii?Q?zb+sDZyiUWPXydt1DWqvkOwhFifWSkMWp9v2Vc4AhYo5gVaw62crFPuGRHDA?=
 =?us-ascii?Q?qDlsFRvzRTiwx4ALxkiwxEn6fFS38Uw16ZkUFGnEBjvI4T2Bd7duoxWW9G0N?=
 =?us-ascii?Q?87juBDPsdKqdQmmktAhb1CxofLYlxMbqdankOIs+uHSRij3U9s52bQVz1ZuI?=
 =?us-ascii?Q?e1kkaK+6pRKB9efs+t37E7HsyfyHt8hdEhTErfp01GO+cVYfzfsrdOUrErsU?=
 =?us-ascii?Q?tZ22hULffA88KiG/Bo0YxPNrvG8WNNdtq/T2cmcmZxYez/TaPsrRc8ZX1hj7?=
 =?us-ascii?Q?eKCDphpxEN7PDwfqNzFAyUkTbFNFMxPvyoXkzUYAioF0lbK6t+4JR/VAG68w?=
 =?us-ascii?Q?c9nM6LL3lctXZECrk8fH/+MX8Oi66sFGvPAP9nyoH17n5XGRgkDzj63lO1xB?=
 =?us-ascii?Q?fX3U5T0giTeOZ8dhUbsljlAziPV+KFdF5v/24unkHOo5gPolQdXl3Ag80Kyu?=
 =?us-ascii?Q?+KGEZafXWCtWaEpcerByoi0P44wAoBuRUnN3Fu7Hu+rRdV+UsI8IhXRDEPkQ?=
 =?us-ascii?Q?VG1oE9+uvj6RvxFXl3zDnbN2Kynv8cz0yteFcCr+alUlgfDo0WxYDWEmgEC7?=
 =?us-ascii?Q?pD51bc5qvYhKhxMk+Gm9iMCecMyLaqEPCeslyMZJ/4hUr8o7G0S0KvxsZ7SS?=
 =?us-ascii?Q?NwPMr65VrBNa6FBnxSPrAV+xT9ASA5rRimH5DRg/U4ttAG69gR7jHxTR+xMI?=
 =?us-ascii?Q?2CRHN/rcwCFurboPIP/2haLJdntjB5K+LfHU8qhSZWH6FKdhqsn+ovenr+cU?=
 =?us-ascii?Q?c+dx7Vk8TETc98+mlIu3urMWWHmdQNSU4cK8bai+K6DanaIbWdgguZHXB+bI?=
 =?us-ascii?Q?C41blyfnbKTIHoJFpQAoTACs6APnmkJVmEnTihEbxMdQZ3JNiLQA537YAt6e?=
 =?us-ascii?Q?tPCsj2xhIfb5b7yqjt8dtMsBoKG04foX2zdaG2Wq+L7Bf7ztEGZj9l3NrR85?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acfc518d-61f6-447d-7699-08daed495c58
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 05:14:16.6387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lWvdRDf+4xmxrX99pgJc/vVCPtxpenfScjcY8SRP2sJwYHTV7ri0eg3DgM/djBUG2dqQRuJKGn2COIUMZ8drQrI2fKX9nCXC7cPA1PtUb/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5823
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAINTAINERS file has Andrew Lunn, Florian Fainelli, and Vladimir Oltean
listed as the maintainers for generic dsa bindings. Update dsa.yaml and
dsa-port.yaml accordingly.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v5 -> v6
  * No change

v5
  * New patch

---
 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 2 +-
 Documentation/devicetree/bindings/net/dsa/dsa.yaml      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index b173fceb8998..fb338486ce85 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -9,7 +9,7 @@ title: Ethernet Switch port
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
   - Florian Fainelli <f.fainelli@gmail.com>
-  - Vivien Didelot <vivien.didelot@gmail.com>
+  - Vladimir Oltean <olteanv@gmail.com>
 
 description:
   Ethernet switch port Description
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 5469ae8a4389..e189fcc83fc4 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -9,7 +9,7 @@ title: Ethernet Switch
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
   - Florian Fainelli <f.fainelli@gmail.com>
-  - Vivien Didelot <vivien.didelot@gmail.com>
+  - Vladimir Oltean <olteanv@gmail.com>
 
 description:
   This binding represents Ethernet Switches which have a dedicated CPU
-- 
2.25.1

