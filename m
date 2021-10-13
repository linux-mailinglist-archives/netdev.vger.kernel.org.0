Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227B242CDD2
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhJMW0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:26:38 -0400
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:19889
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231249AbhJMW0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 18:26:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmLyCT1a7ct4CZWeQtNZn52g+G6ISeNzqdbQYhAC6jThOHujM/T5TJRZA/dL+5wNefWcdHxYtImEDn3jp/ET0TVPkbRmACUoFUUtCpto3jZWhEbnlqFAAASD2+N5Uz8gUsVCln0byA8hdOWaDdLd7Ue5gvd3y7JwrJmFyMvM3N32Ep+7+XiE22fg1169tM4XlEHHLJWLi9vpjS56eo4TreQoR0O9YwR8tS5ZOnUI8xeD4GlFkCeTJVJ4D3wGToSj6mbJy7SxdXa56VMbO+iJzjMv0g2I2lx5Un9tfDbvFoU/M4yJZ/ICKXsHGNYBO9X9POFzRXU9I2jUUYJovCx9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPT7TNgzaDUXLgX1Bh5MQZPBlpTIaOnX09v4AExYD/k=;
 b=oV6WWSjBpPJe4uSTPUvvAlbQsLgvvjsi93rA9axgrqKwu+hesYwpLTdkUmz4IbErLvR66IBsoha/HLwa6CNha80Q4IBlX4V+YaFYDEUzZlbl7m2aPGJHqlWxf8D/YaWW88sS/xkqNwWIeeVbFVLGnqe7+mNFpVYxevjUTMd+WCuD9N3NhqiamFMpCTE+xFULoEBeXAWySF9DSlgjQnRiVTmYhO8nZIWG2EXpX43NdZcEeREyeL0LLFcZQFUJjk1h6RCkFcZcZk55KNcYdlIrgyX7eUrt+BdTd9U89ZkoaeFTAOHLZo5N28S7Sjr27tYnUQzD/6aUBY9yMVhezn82mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPT7TNgzaDUXLgX1Bh5MQZPBlpTIaOnX09v4AExYD/k=;
 b=o+jTm/i78ZzPi8zim5XLNgPLCIqqvFRyoTcMbVPyKHdZrkWWtCXpPUEquIkyyKNTbO9gXq5ix5pmBLeOaLGQG62AlXkfHAGZpr0eFsiBn+bbsxqzSLRFQHX5XWsDRurn5dxZ87xvAaSdQgFLC8ELSn+X/Km4ivJkI/hzCxoqB64=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 22:24:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 22:24:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 4/6] dt-bindings: net: dsa: inherit the ethernet-controller DT schema
Date:   Thu, 14 Oct 2021 01:23:11 +0300
Message-Id: <20211013222313.3767605-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0154.eurprd05.prod.outlook.com
 (2603:10a6:207:3::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM3PR05CA0154.eurprd05.prod.outlook.com (2603:10a6:207:3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 22:24:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9c73f9e-cbe4-4418-4c63-08d98e983578
X-MS-TrafficTypeDiagnostic: VI1PR04MB4816:
X-Microsoft-Antispam-PRVS: <VI1PR04MB481676B19175A8A69F0120B4E0B79@VI1PR04MB4816.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8/wKrgIb6q8JywUS+EgQizqnEJssnYWt7j0w2o3FlMX9AcsVEtyOk1g0wM6nJ84AZdtOtUeGz69GHzHxTiQdWXcFg01tlyiEKIQDKgztHMfndPskeV4u8A1n9ZH7rc2rKGGE5GqSQSRleh+Am8XZ8xk7rJ5yfyMWu1JYtG6k7wCiXt+uObunUxGC6Hlklj2ASlg4Qo/mWwIF85VlbzrLkPg7+zvucHeywelBWu6CIHP9JA+LjCTXJlCYK3iBGMHkSmSuRO/3PzJ2g/pJAix4HWAypKgh6hoHYo68jSbOVBdY4u1CsIUpPDDSgr7DYR2UbmVCy6pwl7i4uFEY8MJzZZS0JJSkVB0bJaT4InQHVK4sqyj5xG47b4DPTN35EQQYZJHBHOo6QWhk7+sCmby8sG4GwDZy5hsxFfqUBBRhUseueskE0uY9lDt+7hyR6o0K+v4BWbP0foC15mcm9oh9+uU8Rg7Hicca72pka7nPTqJ+SrnYZzxlWQBgWDmsB2o2gl40aIof1a1NRWBoTFxv671VvmR6eG1JIeUc1i3hpmnJxgFTZK0NN8ZsGcluMeLvTZiq97AdzxDuMUagd4KYNpWcCDK7xCZk0QNyFK2exzhdHKzInUJNC7svYtZ+wiFTts1NBYEN4ANAXHwHfyrcEaayNPY1SeRF/02Qe4BZxZ8OAKLer6dpfzvsP/+yI5NshHFdZl19nQqZTmzxzN2WOzg/PQbaZ4Qy0hwKIPOqk1ubZzjrzWllsy47LV3O3FBlmri3uGXJkBAszxk+S4hjruvVcVd+Q/FGf4c9e37GcnU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(956004)(38350700002)(1076003)(38100700002)(6666004)(2616005)(6486002)(26005)(316002)(54906003)(110136005)(2906002)(8676002)(6506007)(36756003)(4744005)(66946007)(6512007)(66556008)(66476007)(8936002)(186003)(4326008)(86362001)(508600001)(44832011)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5vPXiOj01mStcYmZ+3BXBQnjY+mSDj3G/5yGuytIDg7/bDZKIMma6FNoAmSr?=
 =?us-ascii?Q?9mCZ6lrLMk0vHSTdvQwrT8YMn1DG3q+JqRF85qNuGDPJeHLWsBiOMpcmVQf8?=
 =?us-ascii?Q?eUJsXBryaREECbsiJEwg3ReKTjyKIluV4ckXyCXn2UcMTkk/OLIxml7xj02w?=
 =?us-ascii?Q?St9chKOb/HMy+c5pXexJNEozAzTU4/wk7mqZSHB+HAcXKmyKdkuggats3rjc?=
 =?us-ascii?Q?O/fDI0m5EpEijZ9gNz9CDnA6c84BN0klfEFp071kH2QZBLll8i8lPKxDEXh5?=
 =?us-ascii?Q?gWuUouxU5/L5XeVWc4JzDTyS+aD1Ny1uHuuS9WSwnv8VpUY2ONFKuWFAPaCn?=
 =?us-ascii?Q?jDWUseHdnKE19pTXQ5VFB1rv1SS3FDlH4qsrnKA5oU3hEuf16kJzOhVjDKkc?=
 =?us-ascii?Q?vdASrI43AnCq1Ku5aIcQ/i54jGWZyPF1qzSHkPlYPqY/rD/kH9pvxizjdOpW?=
 =?us-ascii?Q?feMh2T9Pd3uXk12uduzMx9udsGROv4Y1g2Z0qt3O5VbC0aGsAEqx/gq8XKKm?=
 =?us-ascii?Q?eO0vSePTjhgumKbfZzPKFvQwf4tdtytk5o8Kcd0yVLkUxOY9kICx+9nrZR69?=
 =?us-ascii?Q?QkvhLBMjlBnqr/hQuEJLflYF5Sbr/sBNGhAhDZbzBgTDh8VqjXiAN7jIpz+f?=
 =?us-ascii?Q?/YGE/IZ9PCzVXFAXUiJQaUKHlE14O/8CYD9neSCTXERCmHPA8rlG3qcsyLHe?=
 =?us-ascii?Q?ftPpuvaYn1Wfs47Y4kj6c9SEPQZE7faJF/TQFdyrLy4hZIxrJsAGHL7nvqrM?=
 =?us-ascii?Q?wVescH3Uj9DQGxr0A25tWoivyGXsJ00fup4J7jjLBV8CLhxg7f+m60G7dV4T?=
 =?us-ascii?Q?/+mz3sInVq32SXwNt8PNg4ndxhcuAT/LlmcB0TEutOYAEu0xaIPG0UfhSo88?=
 =?us-ascii?Q?1CKp+bwestj82FZ392WSnDciqRg1lPidNdNBniSIMKRoZBlGBehHGsAje7xK?=
 =?us-ascii?Q?o3bnVvp5X2f2EaJauz4ILYLE1qN/Zc6p9/xLa0h4Qt+yOfrORazZvSN3P3j2?=
 =?us-ascii?Q?dZuOrkaPSpy2DPp2YVIpiyS8dmHmhfpyia/Pym4VqyTEYSJCUJ6QV4sL6Mhu?=
 =?us-ascii?Q?GQY1NXE/XRltAByrdWWnD+qYqxW3M+zyR5xR//hGBz33tG2jyfuMrzGAr+8D?=
 =?us-ascii?Q?TcMOCE8dZ5zU+4R7sO0IVbenB4APyMNa9L8UH5xXX/I3/vhZ1bNJaZ20pJrN?=
 =?us-ascii?Q?WdnqpatUCoV770+n81lhKtTBau7UFU3hvqRblaJlReUWjpmZB1C90fGCNph6?=
 =?us-ascii?Q?2CxcT6+CWN45Y0ZPumfWxe8XCuaCZAVps6488FfEEFWmaIDn7otq4WJX6YQG?=
 =?us-ascii?Q?bDlWr+Ts1Oz+9GiXNKlw98/t?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c73f9e-cbe4-4418-4c63-08d98e983578
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 22:24:23.4634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6QhpZk6LkMmTjK5vU8IMSP8mGH6zMd3vwGYrEE0X8s5eXl8O/s8O65OUYFPebNDCvnZzXKNYym5GPg8wu9oqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since a switch is basically a bunch of Ethernet controllers, just
inherit the common schema for one to get stronger type validation of the
properties of a port.

For example, before this change it was valid to have a phy-mode = "xfi"
even if "xfi" is not part of ethernet-controller.yaml, now it is not.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 224cfa45de9a..9cfd08cd31da 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -46,6 +46,9 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
+        allOf:
+          - $ref: "http://devicetree.org/schemas/net/ethernet-controller.yaml#"
+
         properties:
           reg:
             description: Port number
-- 
2.25.1

