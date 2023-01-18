Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC43672B4B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 23:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjARW2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 17:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjARW2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 17:28:47 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2133.outbound.protection.outlook.com [40.107.244.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D04148588;
        Wed, 18 Jan 2023 14:28:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caVvVenC6vZqUEPjAvXRUZnehVIdGsI/OGGYa/BXi0cKsHivXEaJP7Y5m8U18AtB/PlvfRwod1rB3xtEa7tqD8mDyxyoahALoFt05u4FYnnow9iEBWvn18fVXY0B/wqZCA2+ZyyPZy0VGJ14kGm5RMAthZ1Ua4jGrNsmiwQ7YBsBXpRwTqvmb+Q8sNM67t1PJHxQyW6Ixh64ab249q1Xis2FD+a5cb8IYRAVagIe9XE6+3UU7bpxTFf1sUIdkJDlX7mXDIyvcjD8mj2q/jQzOQNO0N3dJ/Vt5E8s2yy8AI9xNnyMpoxPaSgYWfaqe9JWayYmrDzHMNjwG3C0zZmz0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QBzbf7j62jlH01WHmCTOPD+Ca+1JXVYczbnC3Gpnlrg=;
 b=oVT9XR3P0ZzMXskMRxE7UldKiLNiDlyai8xNWS4HCp/Oi/CrNPCNbm1wT43JgQpfJbEEA97onzD+HpN5LAYt1fum/SrfD3EISoj3zPFahuifotA65VoMmyFss3+E46EoEitWuD8sKggsU4AhNB7K17adlHsW7DmqvgHrgoCNzKdBqQAyRc3qU6L01GRs844rZFBIvlIZuS7nBvNJr1pKsI9SB3e+IvjpE7sud+GU32vxKhZF86leYvemX6i1+xw9op3iFxD33rtRmuLoLF2yWmz+LxYzn9Dr07QXiQlzFAmL2KTbpLSol3TZYr1vzTzxG7fg8YvwW0DPQcVmDC7d6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBzbf7j62jlH01WHmCTOPD+Ca+1JXVYczbnC3Gpnlrg=;
 b=Z7Ozjfqx5WrYBNJQTBOIoeUwAt91vX2IaMuLmyZplG+HrY1ptOBPXFlDqRDILg2vywZlYCMCfd+mN1/1Q8Hq/yCyGgXVBxq+h3RbR7CGU4Z0/lvi20TyatZ+4fCdxp3N8V2S3c0GlXFesNUxt0jCtJIsWI0DoagAC2ZMU+HZ4m4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS0PR10MB7397.namprd10.prod.outlook.com
 (2603:10b6:8:130::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Wed, 18 Jan
 2023 22:28:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Wed, 18 Jan 2023
 22:28:42 +0000
Date:   Wed, 18 Jan 2023 12:28:36 -1000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <Y8hylFFOw4n5RH83@MSI.localdomain>
References: <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <YzzLCYHmTcrHbZcH@colin-ia-desktop>
 <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
 <Yz2mSOXf68S16Xg/@colin-ia-desktop>
 <28b4d9f9-f41a-deca-aa61-26fb65dcc873@linaro.org>
 <20221008000014.vs2m3vei5la2r2nd@skbuf>
 <c9ce1d83-d1ca-4640-bba2-724e18e6e56b@linaro.org>
 <20221010130707.6z63hsl43ipd5run@skbuf>
 <d27d7740-bf35-b8d4-d68c-bb133513fa19@linaro.org>
 <20221010174856.nd3n4soxk7zbmcm7@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010174856.nd3n4soxk7zbmcm7@skbuf>
X-ClientProxiedBy: SJ0PR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:a03:331::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS0PR10MB7397:EE_
X-MS-Office365-Filtering-Correlation-Id: c0522c5f-d314-4362-a85e-08daf9a35a13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ThtX6Bv1w+xh+QvaJmQfEGeSrpi7k6KsH4f1kyK4QSKshjvOmq1sp3eJJuyG97hLpE4KzMzNXsN7JVlLGwwQJ3+M2VDeL6Sn25Kmqh52KVi5bx+O5S5Rq12CuCM7jxRwgHkojzCUz5p6bzPJ2npIbhrrtmNOvqtJkSGUcw3O4lW8Q1ev2qCAIY6hrBuCJTIy8pitqfj/l5qcom9W445GWzy/k96zJCPVxZHBHnHjrj2VhSxCywWi4zFROMjd+Ry+vmpH9Bs0q9XHjs9g+lXUKCgWpnpI+KpFgchwEcFT8bMaE6s7WoBf9yRbLqlFYJkpuMbrcdCuIKgs4eRhfDVBOkryOldgcShq5WUPikJq3aNLEcAY8QcemI2c3tYQp+RXtAn3cehhgb2icxyyhjGKRNlvTIXLN6INbwSAzG+j6oman9g0zBolZ0RKJFXeXtv6TSv43XpiCFtXGS+fHgJhxkK0bMkKv7WzQotuoph2kx5L49ltA2g4kZBkOH5xKFKc+va+gp92Or5/bcG3HkVugieWOCKzVALB8uE8/TRV8weO83st0kN0t5kv6p97Y4AbU/bET3EJgzO4HGylQ4eQ1H2iY0rqPqKcqfseVLkT3CFjUlCd2wdNpYPZw1KxHcVjZz6KVM7fej2U5uV8OP+pQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(366004)(39840400004)(396003)(451199015)(2906002)(38100700002)(316002)(86362001)(54906003)(7416002)(5660300002)(44832011)(41300700001)(4326008)(66476007)(66556008)(66946007)(8676002)(6916009)(6506007)(6486002)(6666004)(8936002)(83380400001)(6512007)(186003)(9686003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ViJ54NY0SJpFufOUgTv9X/MycTy5rwFQrFu1zWZUuwh4FFaVKwtj1O8tXdTf?=
 =?us-ascii?Q?THcarjoFufO9thNWR0eFDH8I8owCA6YPDthTlEyS7d6DLxYm8ePFcQRuDX4J?=
 =?us-ascii?Q?8XxI228kTxjBDoZO3rDkdr1I6Ap2cgsYvN1mlC7wlHP55oRdCdXeu9ChbqsD?=
 =?us-ascii?Q?eupOjQyAD9qXv0K5CBeV90eOBha2D99ZkAVwCEes5fdbBT2xb43YDSgE0Unx?=
 =?us-ascii?Q?b7l7hLNzk8U3L19hgnAQN0wUs7vz/7KMvVumfhlHfv7vZqhQAA4zwLnYQtZ4?=
 =?us-ascii?Q?M90wrk6a+Hhu75jK+1wstdqs5jqLIfT6BSTrZG3XWaDhqe/Y5hzdG57KQZbF?=
 =?us-ascii?Q?805YCWzWeQnkIFgi8JPx7MD5nyVTKojs3G9EEW90ALWCR+rXbEp0QdaZmcuG?=
 =?us-ascii?Q?tu3/Lvt47Bf+1ET/X+1qHiIXTLj96MK/+vC7oKVw76Zr0ACwUNGbllsGqFp0?=
 =?us-ascii?Q?2pcfAIdwcSJJxLZ6mpH18zxexeQ4Dm/bnXe9XMYfse1nPSclBz4fI/EKBrg9?=
 =?us-ascii?Q?Q9OrBtLKUZK7aSDmbyZUHEqRVQD8OUT69YSjZJgj3TDgOwR0VzjldgBnfV2W?=
 =?us-ascii?Q?IPbRW9v80W+CN1WaQSD16DDPIYS1jURCWfXxaaYwm/Ah1Pai82XKvc0Q22R5?=
 =?us-ascii?Q?KqMUC0AajaTYKEnAndZu1CVHAqd2+b3ItqonnkCFXdwnOisluXIlKEk6JE8v?=
 =?us-ascii?Q?gtHwYwu0LG1HpmW0oJi1JO8/k1lhr5RVtDryHzFlcaWBjev+Y1Wo9gwhuLZw?=
 =?us-ascii?Q?w4T7N0hWTfeDu0bbK3AM4m7DvdStOUxbFG8t4A0js/EY09nUVU+ua7DUsXDT?=
 =?us-ascii?Q?2+Xgs1ddKupv3Ga1h7EdfZph/Yu8EVHh5ZW0R/ahOBdyQlaRROsMEpLJU9I9?=
 =?us-ascii?Q?g2F5SXbenuSPCh/p4//LckncBUrmua3K9+DAMqFAXpbw31XNhOBX77j/3CSx?=
 =?us-ascii?Q?AX8VFxaXERWDcjGU09fk3XsX75vwxeXGv2kl7CEMv0GdP/BPE+NKv076vRcR?=
 =?us-ascii?Q?82HemzAjmV7Pgc58H1bN1Xn/XiPuMGUkWakQ+kryHkWtC9JPdupCC9KA/sei?=
 =?us-ascii?Q?urBbbHStkPxwDZelunyEigo0BkYrbcEf2Ant5kLH0rlRl8CJasKNiPk6bfk0?=
 =?us-ascii?Q?hdSx+Fwl/LUwQwnO8+u8jciqQ0PZvJhRXOPKMeyCYphz8qmFdA37zg9v+OoJ?=
 =?us-ascii?Q?RT/TPrbdGmm+A4fQ+aS2R/tbKphVhdVcwrnFtdW1RGsgunQoU1PpE4SfL0gZ?=
 =?us-ascii?Q?mgxGo6ohp7RdLlFHxzDlhBFRF+dkjmpwTP5ohNYeHsBW56pirhQu1X+mNLyY?=
 =?us-ascii?Q?Bgsyu1QzsmQ0juA/sodpcD+aLEycsLoxftTpjSXCvR+6G2eMUN6U8q4pIq/I?=
 =?us-ascii?Q?xX2roFvfkzVY7CIvI5TJpf8d+SwB6Gqmi4Jfc6Glulq9eouF2OqF+UFEskBn?=
 =?us-ascii?Q?YRFigKVMkkZVTkdJvNhgEc5mzcIwwnYFDm5pBFGd4B7eVChuEWzzHrduHQTB?=
 =?us-ascii?Q?4eko+1W/taHyjM2IhG0Bu4RaaUEYyXEYXMfuBARYcQXjGnk1zFYNLQIBzI74?=
 =?us-ascii?Q?soPBN6sMJAWq8+QryzVuWbEFbN6Esj+uWiYf1Yi1KvEpjlQJbeP3Z0SPjsUf?=
 =?us-ascii?Q?zVcxESXl+h9JScaTWJN7RDd8+xc0YJ3F0kFkF7ghLB2rPEXS8NagNHHGMoEL?=
 =?us-ascii?Q?WNn++Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0522c5f-d314-4362-a85e-08daf9a35a13
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 22:28:42.6631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CLWjU82FOZEYi1p9D5udyIr8g5sAkbfpl6NboYLFqQkFVw+Sep3ODE9BbRJ32RY/UTBqoFT6df9M+JUmjyqcTZaU1oAF1eG8n8j7aBaCLZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7397
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 08:48:56PM +0300, Vladimir Oltean wrote:
> On Mon, Oct 10, 2022 at 09:37:23AM -0400, Krzysztof Kozlowski wrote:
> > What stops you from doing that? What do you need from me?
> 
> To end the discussion on a constructive note, I think if I were Colin,
> I would do the following, in the following order, according to what was
> expressed as a constraint:
> 
...
> 8. Introduce the "mscc,vsc7512-switch" compatible string as part of
>    mscc,vsc7514-switch.yaml, but this will have "$ref: dsa.yaml#" (this
>    will have to be referenced by full path because they are in different
>    folders) instead of "ethernet-switch.yaml". Doing this will include
>    the common bindings for a switch, plus the DSA specifics.

Resurrecting this conversation for a quick question / feedback, now that
steps 1-7 are essentially done with everyone's help.

I don't want to send out a full RFC / Patch, since I can't currently
test on hardware this week. But I'd really like feedback on the
documentation change that is coming up. And I also don't want to
necessarily do a separate RFC for just this patch.

What happens here is interrupts and interrupt-names work as expected.
They're required for the 7514, and optional for the 7512. Fantastic.

I'm not sure if the "$ref: ethernet-switch.yaml" and
"$ref: /schemas/net/dsa/dsa.yaml#" have an effect, since removing that
line outright doesn't seem to have an effect on dt_bindings_check.

The "fdma" doesn't make sense for the 7512, and seems to be handled
correctly by way of maxItems for the two scenarios.


The big miss in this patch is ethernet-switch-port vs dsa-port in the
two scenarios. It isn't working as I'd hoped, where the 7514 pulls in
ethernet-switch-port.yaml and the 7512 pulls in dsa-port.yaml. To squash
errors about the incorrect "ethernet" property I switched this line:

-        $ref: ethernet-switch-port.yaml#
+        $ref: /schemas/net/dsa/dsa-port.yaml#

... knowing full well that the correct solution should be along the
lines of "remove this, and only reference them in the conditional". That
doesn't seem to work though...

Is what I'm trying to do possible? I utilized
Documentation/devicetree/bindings/net/dsa/*.yaml and
Documentation/devicetree/bindings/net/*.yaml and found examples to get
to my current state.


diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
index 5ffe831e59e4..f012c64a0da3 100644
--- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
+++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
@@ -18,13 +18,50 @@ description: |
   packets using CPU. Additionally, PTP is supported as well as FDMA for faster
   packet extraction/injection.
 
-$ref: ethernet-switch.yaml#
+allOf:
+  - if:
+      properties:
+        compatible:
+          const: mscc,vsc7514-switch
+    then:
+      $ref: ethernet-switch.yaml#
+      required:
+        - interrupts
+        - interrupt-names
+      properties:
+        reg:
+          minItems: 21
+        reg-names:
+          minItems: 21
+        ethernet-ports:
+          patternProperties:
+            "^port@[0-9a-f]+$":
+              $ref: ethernet-switch-port.yaml#
+
+  - if:
+      properties:
+        compatible:
+          const: mscc,vsc7512-switch
+    then:
+      $ref: /schemas/net/dsa/dsa.yaml#
+      properties:
+        reg:
+          maxItems: 20
+        reg-names:
+          maxItems: 20
+        ethernet-ports:
+          patternProperties:
+            "^port@[0-9a-f]+$":
+              $ref: /schemas/net/dsa/dsa-port.yaml#
 
 properties:
   compatible:
-    const: mscc,vsc7514-switch
+    enum:
+      - mscc,vsc7512-switch
+      - mscc,vsc7514-switch
 
   reg:
+    minItems: 20
     items:
       - description: system target
       - description: rewriter target
@@ -49,6 +86,7 @@ properties:
       - description: fdma target
 
   reg-names:
+    minItems: 20
     items:
       - const: sys
       - const: rew
@@ -100,7 +138,7 @@ properties:
     patternProperties:
       "^port@[0-9a-f]+$":
 
-        $ref: ethernet-switch-port.yaml#
+        $ref: /schemas/net/dsa/dsa-port.yaml#
 
         unevaluatedProperties: false
 
@@ -108,13 +146,12 @@ required:
   - compatible
   - reg
   - reg-names
-  - interrupts
-  - interrupt-names
   - ethernet-ports
 
 additionalProperties: false
 
 examples:
+  # VSC7514 (Switchdev)
   - |
     switch@1010000 {
       compatible = "mscc,vsc7514-switch";
@@ -162,5 +199,51 @@ examples:
         };
       };
     };
+  # VSC7512 (DSA)
+  - |
+    ethernet-switch@1{
+      compatible = "mscc,vsc7512-switch";
+      reg = <0x71010000 0x10000>,
+            <0x71030000 0x10000>,
+            <0x71080000 0x100>,
+            <0x710e0000 0x10000>,
+            <0x711e0000 0x100>,
+            <0x711f0000 0x100>,
+            <0x71200000 0x100>,
+            <0x71210000 0x100>,
+            <0x71220000 0x100>,
+            <0x71230000 0x100>,
+            <0x71240000 0x100>,
+            <0x71250000 0x100>,
+            <0x71260000 0x100>,
+            <0x71270000 0x100>,
+            <0x71280000 0x100>,
+            <0x71800000 0x80000>,
+            <0x71880000 0x10000>,
+            <0x71040000 0x10000>,
+            <0x71050000 0x10000>,
+            <0x71060000 0x10000>;
+            reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
+            "port2", "port3", "port4", "port5", "port6",
+            "port7", "port8", "port9", "port10", "qsys",
+            "ana", "s0", "s1", "s2";
+
+            ethernet-ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+           port@0 {
+            reg = <0>;
+            ethernet = <&mac_sw>;
+            phy-handle = <&phy0>;
+            phy-mode = "internal";
+          };
+          port@1 {
+            reg = <1>;
+            phy-handle = <&phy1>;
+            phy-mode = "internal";
+          };
+        };
+      };
 
