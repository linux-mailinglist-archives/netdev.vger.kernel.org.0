Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3506B648CEE
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiLJDcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLJDb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:31:59 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD03190765;
        Fri,  9 Dec 2022 19:31:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7Qj1ADOfsMcPw/eDDPkTBAFT2lmgEbqc/SLiublEAJL4yEZzpvK42ejQ/mdc/SFIk9yJVmhn9GKpwA0q9SytNrHZwVRNFeh3mDLNTZskW1++ARxjvUQOsLN3Uk82bR6HTSO1MY7X/DfWuWrPOXzK+qtQU7xrpPdM7PH554rqkOk/rVp1N+UvBv8LnACADtQeJ2GFp51bpvh+B8cxSo4F/AJ8IbG2w76rtKUbD1p8X+ZnW2iLl7JtXSpo5tzxYtPZdKBRu+/sx56gNI1Njo5wtB6mrHAah1zw9KrtuNJzi6qFpY3lUobp2g3OcpPhFwZUZ3uRqW/tzfyqOAaRpaaAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sO/kjobORaTlv7uA7a6FbeR+ard1OYGe3jZg3deg7XI=;
 b=gUsr0xCIKT4TgEE/7dHIUTgPNEDbbWp9Gg2ZvGmjz1DeVZ3yoPlxYg0gZ1BwiziuRuxBwdL6RJzQGtHJthrzhVtbKyZu3V04WRLJCCTH5zNDo/410B+aycKqTL7mdyojwFCdf3Os1uo8odl3osQ7liLnaEhMlGMgYYBIgSxPDU1x3HsCEzIPLhVQrCtzWRrftwqwLZiAoweU/1GSkYO0Ane2v4H4gTofhhwCZx6ynDQ0FoSJYTVqFQIP4wKiTrXgtPjCDHmVp0QHOLmXrnB44l2d3MAkWAKs5X+MHvJk9ff2DltYrnjeENIIueKbl8WNI0QV2rOSbgA26ERobx8VDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sO/kjobORaTlv7uA7a6FbeR+ard1OYGe3jZg3deg7XI=;
 b=vDxFxZLOye633VfzGbXf9IkWCOMYMEfXeDK2HoCcrPaTvYbTExGoIGN3wF9gTy8+70NaOJnVYjiGD8fj6Lae6AauYpTqBkGc+1mvZU4GpKhN+vzqydIlnE5q4c15QmMQu7kruWE/TeqNjmwHukYxqjcJ25mMoBRcrecUY8xHIqU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4779.namprd10.prod.outlook.com
 (2603:10b6:806:11f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 03:31:11 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 03:31:11 +0000
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
Subject: [PATCH v5 net-next 10/10] dt-bindings: net: mscc,vsc7514-switch: utilize generic ethernet-switch.yaml
Date:   Fri,  9 Dec 2022 19:30:33 -0800
Message-Id: <20221210033033.662553-11-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: f4efedc1-b5c2-41bb-7b96-08dada5efbd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n0jcqVItjZwVaDUgtPK4scFfre9XBG0Bz6xMs2THsb4z1DNTfQbDj+kpcUzs+KsnxkV5EkmLloGFgm45unsycqwYg9qSuK/EK2frGfmMIRzAHrJbk2A9jxE7/turfRrcPzHlD6pJ5RBRfDtc+dqYxESgauRNm3qXL4gCGbY0OiC+V1yGH1mpiIjmkRJA96VdIxF5E0KWYY8K6nU4S6okfy2GQiVaSKQ9uBSuQy93toexUW6MEGoJbf+2NCaOxDwaNXIFTJ41d15594R4MGDwTtKezY+mCgBsLlTmPvaWsYzx/mhr/hL+HstKPWy8HxxgDRxTfDrCYpxwKXPAcq6ZUrL0lKpTYfFzvvZHPp7ZttAvI+NdHJCAE3EfsrOLiZT2vZlCW2vm0SQcACTmtOIvdS+LIgOh8bMwUQg+hJ/2mVzeVYyruwBIEZKUq5RTPtQoXPheQyU/4WJgQv6rpGc/K0hV9bA2Sq9NP35jeK1/IKw0LTTYnaEjQxuLWTnS1w8KqF3PWR5dPMU7JD3fCUOfHqsOLFdYMH1L1zSUNUx9gIOxnAXcBxTWFtwjyXzkToOb8bHOpzmSTyRcB4s+OWzLMH5Dbt3ysVTS5MUAg6pO94jEf0AMz80+cL/rMY7SKElxMrKNqyU3+CPNtMRBD+pgJg0/KwVm7m09A6w+iZRpGTAP4QqX6iKVvpP7FFTP06ZoI3oxqtNbIhmlwcS/XZiupA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(136003)(366004)(376002)(346002)(396003)(451199015)(6486002)(478600001)(52116002)(2906002)(6506007)(6666004)(86362001)(36756003)(6512007)(26005)(44832011)(186003)(7406005)(7416002)(8936002)(5660300002)(38100700002)(1076003)(38350700002)(2616005)(4326008)(41300700001)(83380400001)(54906003)(66476007)(66556008)(8676002)(66946007)(316002)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GQAztZu1tE9JYxPv3QwjdnOjHZGyVET+2ItAUMHTOd1qD87I9O5/CpfrqBMp?=
 =?us-ascii?Q?L2J0dn3Nk8ahwDRVuNkNugQPEl2YHKB18uumDXEGMjukP8fNm33NlZ6gjn8n?=
 =?us-ascii?Q?tDTiYkVz8B73BamWHvxSFiFI6RFimGYqUnydnWExE9VRTsysIuW+izKm8iiP?=
 =?us-ascii?Q?eNKCTX0WDBLzKP5NKz8vPzY5Aie8KG9EMQH1N5RbqrHs+TATQmWv9rNVhUg4?=
 =?us-ascii?Q?gWHgAw2jz1gnH3rptDZxEUiQ0TOvQtR0UDh3HFCKoINriRcFKuXonXiuEumE?=
 =?us-ascii?Q?gTB1OfwGohX1xi10/B/AlHklR7cZeVyEqDwIaqvvO4RUGbCtyulAQdopp2FS?=
 =?us-ascii?Q?zOWXydR/sXwJ3ZeYiUPONKqRxEN15+QlG8VgkQ0A/6eztEJ3KcjW2zTiVpMW?=
 =?us-ascii?Q?r/U7IaAbgecrDWNVMfE1kqFDFxMRYcyyXwM/qMXeI2EtPXi/dPUuf2Newdva?=
 =?us-ascii?Q?gSFBNb+c0FcBi5JGM+MYaYiSOGsHgyi83Muvl72dCE+UyVwD8qHqH80F7f4Z?=
 =?us-ascii?Q?E9KbfLJXfpLImDji98dEcUSoAJvG9aDneA6nHLDn6HznMX24Uc2htnle5zM3?=
 =?us-ascii?Q?c3me2ivtNMgcv2Xiuk4G7zLf1fvOo7ykkoS76RJ9gIEapvpysolVI7BJYJ5L?=
 =?us-ascii?Q?JrdEeXnY2Id/Uj98R5VLcxQJV2UcyAgr5/WFDHtvJxBUQbQC+NaEFPmyId/Z?=
 =?us-ascii?Q?ifJK/eKxcCoqMu8/d9jOtwYzdTBMgeuPE/tBxJeRUiCddZ2asS28V+7r5nR4?=
 =?us-ascii?Q?RQI1q3g9E7/g20I+79ypp1Niq+I2NmP0DCQGuMUYDC+qvcZiGlvU1mu3vCGg?=
 =?us-ascii?Q?S3arVaxK3svAgPthm3rCwvP6wqKDjXS4An3EgJ9Gqej22mpKkqb6J2uRSBVQ?=
 =?us-ascii?Q?9XL6NVOwW9/bFQ2O88kba8B8DZwaNEgfNWj1ugqjoWgirfGyFEwZBAzTEY73?=
 =?us-ascii?Q?iCGG4cVsC2ETfwbmFrVGkI4gRZqdjLOdHX6j+lDOe0PaJmrw53XgHwWnZSoO?=
 =?us-ascii?Q?SPqctfQrjLIk+gjg352NIf9PxHwkfteT1K8YlVVMlbNuD4xomcK8XDKIRPVA?=
 =?us-ascii?Q?qiFgYO8s7Te0liJhhqW4bCuBRK76LN+86wGKsY529ZmOSWoELUM95JUtToQP?=
 =?us-ascii?Q?Wf5p/PYHzm36C/OcZvQGw68ZqgYqtSnK3dZuuzl1MvlEIUdqPlpOVqJebegN?=
 =?us-ascii?Q?1pyHqvwA6sB+C4Eq7Wc9L9A28ZfUxdxX2PlyBUfcAfvvll3eb2GV5tc2vSlg?=
 =?us-ascii?Q?+v56CkPjcUIrHrVrVR9BXkmCBqqPgMWCPiXacToxu0m2MOOd4YIunQzg9OBc?=
 =?us-ascii?Q?aQwXZPP5XVPAd2RfjZ4XqjwI9vLvCnJw0vtSLJevdBmCgEB4qzj2pl7c1ruA?=
 =?us-ascii?Q?2VSXunsp+cbFQKJmWhgzGTeyjjrh6nLGvzEHjLaV/5VSiiZk5ndVtHYNDeov?=
 =?us-ascii?Q?huWh+nfHvMqIxU/3mV8aLek9ThhEH0jGO+8fszu06uVy/pFMfcFng5xzmBQ/?=
 =?us-ascii?Q?BOzjYRAtlFV3x72vSjw55waiokxwnUtl2RFXUXWIWl6AZvycPbiuP/ieAcpD?=
 =?us-ascii?Q?c1Kd9RDpz3+CjxCpzgV4wq+o/jUDFfL9naYL4oDZEMJmDkKvY+t3bnNtYcUW?=
 =?us-ascii?Q?6SLRaC8Iln5z11XcK9qnNWM=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4efedc1-b5c2-41bb-7b96-08dada5efbd1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 03:31:11.4499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0JwQw5kEtAlB3nLVohMtu7etW1hv+Qe/+OEVBTivh9x6HcVwg10nPomBEhyG4r4FZ4toopMgYU5ue3ImKeuZ8jjkfPxhFlfY86Cfddvhk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
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

