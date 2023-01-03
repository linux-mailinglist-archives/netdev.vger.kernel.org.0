Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897BF65BA58
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbjACFQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236882AbjACFQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:16:14 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2115.outbound.protection.outlook.com [40.107.92.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B379FDF06;
        Mon,  2 Jan 2023 21:14:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBJUwws6iN/LmP+Us+imF5gdoNtME8beRxXtuxuVqPnqR3MNcAyxiB2/c23iH6Q0IKxps2KdvVBTFhhMZiiPlda8VteM5SnpsjcMHxXDNJ3vgYs5S89EAtpkwGPlNWCFSNZBVg0mhtVU7+gqZO/rPhyTVQGX32HOD34qxt6esQKE/GU1q0+ISA6OqTKAO1NX7/DQAq6Tj874kc83JHo6Uov7r2Pgvdk64AG9p1jSuOURfR9trtQzlb+uWnmx3gwuiXzV8wUVJlrW3l7QrzvwjqeJFRL4cr0U0vHHtPMdgTyTq/O+1acoUTqkufePJ7++4WhlLaA2TN7kfxY+Dfvujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FGEnWSPxHtuwJwaravH52It3HEmuyMSjOlO1B9SS70A=;
 b=hk5AwTSVHjgGKgEvaCkRjiaa59N3NnP+Ku16lYvE/hV2sd11HDfIIGDYhNj06Rp+3cMbqQnFPlohN1no/2qPbA9+2nRBttWlxxF46AXg0gvQmIdQz2jqSGc6gfMTRdxuKU5bUZ8EabWD/LCZH/Gsz2PFEtKtPZ23hsatLszHkCHfbEI5yrZqhSn+ksOPr3qJbR7pemWIms9XAoxLzCVQAnZ+dMsLCdyhbmO9+YzqTTZ84HvlXdzMNH+KubWlPiieaLGA5X4uw06tmWQ1zGV6jdRNQ0Ttm/QehsayOUklPqfHRhzO8nkBYWQWRqDWE0ryfqHr4Z/wse7v/NoauBZ05A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGEnWSPxHtuwJwaravH52It3HEmuyMSjOlO1B9SS70A=;
 b=OriSyn5T3tXr50cSvGD73inLSZYnCEGI3r1tEDEZwiAocHCpn75CRQOXS9gxDmpQXG2b7hrXOtWWj/UpAZmxEyKzfYeVOINMIFxlLCN2QBMWWtbxmLeaGAr4yeAhfv7WHOBvJiymimrwhn7tHACA9snHl0uMmJ5JoVIW+VDo0l4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6252.namprd10.prod.outlook.com
 (2603:10b6:510:210::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 05:14:36 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 05:14:36 +0000
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
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v6 net-next 10/10] dt-bindings: net: mscc,vsc7514-switch: utilize generic ethernet-switch.yaml
Date:   Mon,  2 Jan 2023 21:14:01 -0800
Message-Id: <20230103051401.2265961-11-colin.foster@in-advantage.com>
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
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: 502d8494-b63b-4ace-bb41-08daed4967d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zKY1XVfkkexloecLiHu7+1x8HyRzWVvTg78iwzoWwBIgyCTNPr2sITBqYaw6R0e+G28sbwHFyBpMpp5iKezKf/4FMTnehj63vYlL74IXcJIxpWc7qxDC7MtyNSxe0CXCI7EZCHmrdFg7Rl+j5IGVEo9AiapiMzEGHI8u3xujRtuYqW46chuzlqaFHCEmW3X/414bnB3q5UeKTEKPBXB0ePiHYyvgUFHN5D41G1kvLYyRE3CydygZhYAfH+0S1AL61thYXCt4R7k2zo1ljb2lmaAvR+8VbvuSr1FucLxNqNc2ZwAzbUuwwFwwztjZSJMSfz0q1ZUsMqCjjaQpfSzHCQ84yn5cmgWp89/E7Fei2aRUkv2jFHq9oHaizqDjRimLUl5k0iEMjUz+nZUz38F4YP/hiQs+9YGw9AHyx1EBzUtQgX9h5RBxJ113eiAYPJY5FpVcsWoC0EDEauOX0DpLcxeL9ePD6lUPleAbPSd9ufBUIbV5HD/lZUBuQ1iCVTS7Uco1cK++4BDwTdeS5zWe2QDMoja4xNJTxwnvleeik2IQnB0DorxIf8Co35uDsuW+lEaPOxBLa15qTZVeihkfu1sxzJoqw6Xv/dV7UJW08o6WYnplGkGcI9UXtopc6cRLrMLNeZza/QZw8uk2mbDKtnw5BhaR1gDPYNN5burfpt/DnFsVEnouCP2nY+xUB3C9g4GCQinv3uKo7djCxycpXIAvk02p/9+5w0b51DsoSqWl0J6JjMHqwuxOdVW3aw/N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(346002)(39830400003)(451199015)(41300700001)(4326008)(8936002)(66946007)(7406005)(8676002)(7416002)(5660300002)(316002)(54906003)(2906002)(6486002)(52116002)(6506007)(478600001)(6666004)(66556008)(66476007)(1076003)(2616005)(186003)(86362001)(26005)(6512007)(83380400001)(38350700002)(38100700002)(36756003)(44832011)(22166006)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZHhZl41mnTjP1Hby/gle1Pq7YPhi+dhVNnMVnupqYljkFeDDgra4PIvsoeJp?=
 =?us-ascii?Q?vaIzO0DItdG/ypMndqGfpQcrDa51LL9CBbmkw/HdNtiETDZCvf2Ar8GvoQbK?=
 =?us-ascii?Q?huI1CWBuxWdaOaC4r+JY0xRWN1s3l0WBdzYnGnjIx4FQvQtXZZpf7es/4EzD?=
 =?us-ascii?Q?FmVL11Wo3fbpTGMBQOMcoSB6ojUzK1njxC+gcHwikmREhkN43mMEwOji034p?=
 =?us-ascii?Q?YRNwm/JFUoJm3+PnpQlr+dtrc0DfAPGc2pTBK2fQUP4LX9GZlRkUowgmbpuu?=
 =?us-ascii?Q?+CY7mFoJoFNuDLuzhpPXtTIdMUlI1afk2yRRgW3Vvuw2jb/OV5gAVhQWHN1y?=
 =?us-ascii?Q?i+zHdejk6/LwdJC4HHK5RZx1hZBdRwwrnRuf7zXvxT/2U6dieCpyHx4vXbLs?=
 =?us-ascii?Q?UgWPjYSluucHkUin0+SJKaAN/bFJKxltaqBJiaLuCe3h8JLMF9xnqIJgJWfP?=
 =?us-ascii?Q?zM+sSpw1F4pFBhfjWJwkp6+Aya8bAfUcTgsRVqcOqGLnP9zdjJL8TIDppRl6?=
 =?us-ascii?Q?Yemw2At+coFlnM0ko3yQ/7S03gFzvXlgvuQtXKTIvPDIbcIvHgQfMRCsqC6h?=
 =?us-ascii?Q?6SV0Q+tatY0zdQbBvifE+anL30QzDSKS96yOWJ4fGa8PFDK7wNjGUwccx/JW?=
 =?us-ascii?Q?5aZqRFRDZK0jtou+QMkeo3wgxohBk/rAtLGaciGAEOJY4sVpwPgVZEfTNXfP?=
 =?us-ascii?Q?C/9H9Igw0swwWHr5rwc36FW+r7Yv5Fgu7TCU5LAf798YU0SUe6DHQE8BNEPf?=
 =?us-ascii?Q?6rBeiLczqtttSbzrA1UnJMjVF+eu9x6YWpTf/JxSv8uMh66en4mi0OgquleX?=
 =?us-ascii?Q?BKpOsw2WiaPr3aKn0F5Xc1dOspdTbNeSoe+JgAjFfG4TvJYe/b/LniWB+4fG?=
 =?us-ascii?Q?7m2iGax6h19XDHLZZTdEyXjhv+VXIwMZLrkl7SHgOHfh3PhwKH5okBnAS9Et?=
 =?us-ascii?Q?J09F6m4GGdZuShMBokTIjksDG8H3dE8eDyidxsKyeEs1X/6HHv/6GWqHgFhW?=
 =?us-ascii?Q?Yko7J8jRo/fNK/lPHfqoXeGgjhlQKm0zszhRvY88S9k+WxEKLPWIGyoFGTui?=
 =?us-ascii?Q?6jj7L6pe6ri47+6qD2CNV3gbhV7fRL9ApCblJJm3vNfWX56p8xLRTD+wRttM?=
 =?us-ascii?Q?xrRnk1X6D4t2Cvx11/Tji0psLzF1+CBWg5Hv4fYnaSF1WtWMGst+By27JiLB?=
 =?us-ascii?Q?rTHxeK2hfBBLWkzTvyG+kzYF3RVeojdh+rafPwqmlxTe4AKxHglBerH8yR4z?=
 =?us-ascii?Q?q+Pt7ME5LjhJ3ibBSxKmS+YuxfRb/1xQo2f0Ucm/jp8jOlDkfz8tG5ZeWgHN?=
 =?us-ascii?Q?eeMUEd0G2HHdsDsMGjt4kDA4NMQewSQglTSILCF2b8XVGyOuVOsnDuM/YkLS?=
 =?us-ascii?Q?fwRug78rR3mYzUkaRSR8E00lVqT3OLojoOBNIW8YuXfq9v5xeqpZPCcTx5Jh?=
 =?us-ascii?Q?CuKYU/C24AWB8ZozjhRzAx+VHnd5Voe/kF9GGailO5xSHUffaf9d6253LfmE?=
 =?us-ascii?Q?Me4c0kT4T752+/BETRrzKaoTdQvXjtuHGiKprRq/s+T5lcQhtod7wZyjY9wT?=
 =?us-ascii?Q?1V7obdUV86n1C1+k0atyUYNM9jsDS1vIGJZfc1Xcpl5Uou96hWJkrQdgMuF0?=
 =?us-ascii?Q?YD5EJypPBEL487oqSVQwzZQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 502d8494-b63b-4ace-bb41-08daed4967d8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 05:14:35.9030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rszj/minMArC6hY9eLehksenvIA8tSJpoHO7bwrrBAJRRJ1bb8AWFr4ZeU4i3ohnwtZBJiB2sqZJZfCWFrrgPQFVrC6GZOf43yTzAjhMkjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6252
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several bindings for ethernet switches are available for non-dsa switches
by way of ethernet-switch.yaml. Remove these duplicate entries and utilize
the common bindings for the VSC7514.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v5 -> v6
  * No change

v4 -> v5
  * Add Rob Reviewed tag

v3 -> v4
  * Add Florian Reviewed tag

v2 -> v3:
  * Reference ethernet-switch-port.yaml# instead of ethernet-controller
  * Undo the addition of "unevaluatedProperties: true" from v2. Those
    were only added because of my misunderstandings.
  * Keep #address-cells and #size-cells in the ports node.

v1 -> v2:
  * Fix "$ref: ethernet-switch.yaml" placement. Oops.
  * Add "unevaluatedProperties: true" to ethernet-ports layer so it
    can correctly read into ethernet-switch.yaml
  * Add "unevaluatedProperties: true" to ethernet-port layer so it can
    correctly read into ethernet-controller.yaml

---
 .../bindings/net/mscc,vsc7514-switch.yaml     | 31 ++-----------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
index ee0a504bdb24..5ffe831e59e4 100644
--- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
+++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
@@ -18,10 +18,9 @@ description: |
   packets using CPU. Additionally, PTP is supported as well as FDMA for faster
   packet extraction/injection.
 
-properties:
-  $nodename:
-    pattern: "^switch@[0-9a-f]+$"
+$ref: ethernet-switch.yaml#
 
+properties:
   compatible:
     const: mscc,vsc7514-switch
 
@@ -100,35 +99,11 @@ properties:
 
     patternProperties:
       "^port@[0-9a-f]+$":
-        type: object
-        description: Ethernet ports handled by the switch
 
-        $ref: ethernet-controller.yaml#
+        $ref: ethernet-switch-port.yaml#
 
         unevaluatedProperties: false
 
-        properties:
-          reg:
-            description: Switch port number
-
-          phy-handle: true
-
-          phy-mode: true
-
-          fixed-link: true
-
-          mac-address: true
-
-        required:
-          - reg
-          - phy-mode
-
-        oneOf:
-          - required:
-              - phy-handle
-          - required:
-              - fixed-link
-
 required:
   - compatible
   - reg
-- 
2.25.1

