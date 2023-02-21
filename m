Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE8669E490
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbjBUQ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbjBUQ1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:27:03 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2069.outbound.protection.outlook.com [40.107.241.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170232A17C;
        Tue, 21 Feb 2023 08:26:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYWb7j6Icpoq7VP7Aalr5/78P0jE6G7cARme2TQpn2E20Q6V9qRjdIcMrKm6T5nrpf1di5CW63e+GOWmIcasmzJqx7dhkafyGfKKgeundvfiqAfjiMUdL5ElldPMoNOiu9v3b6EQZFxGfpo5d4NpCNGGnxK2nEb4lYBB4RtY5D/Becr6cfDYq+Wfxx4ZwxKKgaeBqRM2NwVgG7NI9fWKpi314bfvfaDM1OTeR7Zlucn9+L6iymcV0hA8AceRgewRiqKs/VXOUUjj5yW+yjQdG0bYNVEvFqqA0j5WYDKbuh4Mr9OU+SoQMDATgNaLxh92kGMSuKqWXwKLcpfV4dKpoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5B8T3+EmEU7dbJ/NPkWa0z9D64bwDxxU/OFZZNh458=;
 b=JkNHOc3zVFz6XXBEus3RgI67JLc7ISHqT1qKNCoHBRiIA34ZjoyCcWxoEavHNUYrxIqAzj4hzMB9WlQmCulq8JZvkjLnd4hPAyRsdWMSobqaF4UATwNoVKcsZ/aOhInlyoP17tr8RoZ7r0ESpKnCpUWdxWJQPNJVL1LvvxN7iX6hKhyInT/NS1Z2GgGPPu/pG4WswPkcGDAc6UbIx/RAD3m02OAg/dAvpNKb/fULGaFWqAmDaRIs1gg2co1erfjjgLsCwsxSv83VT7O0b8+h3WSrxC+Sc2UGbLwrBjSWsHo7mTnVCd/cF2tJf6KEoOx1e1iJ7k98hraorkwYjd7vYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5B8T3+EmEU7dbJ/NPkWa0z9D64bwDxxU/OFZZNh458=;
 b=nQl6SOmyajk1Bo/QOUQGhtsoYK4kjZUU8idy4kNtUIl7lbPFf2J6YA6/MpkqeQccvsCuaBVtOu8UdqlUlzoUhWc/d1DtAKKz7gIXciTyQ/AWRLM7HSpDW77HE3PSfs+/b9nJTn6hJl6vGylq09UIoun3z2YGavVd7fiPpIznx1w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
 by AS1PR04MB9405.eurprd04.prod.outlook.com (2603:10a6:20b:4db::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 16:26:46 +0000
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::6aa0:508c:be53:7efe]) by DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::6aa0:508c:be53:7efe%6]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 16:26:46 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v4 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Tue, 21 Feb 2023 21:55:40 +0530
Message-Id: <20230221162541.3039992-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230221162541.3039992-1-neeraj.sanjaykale@nxp.com>
References: <20230221162541.3039992-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0036.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::11) To DU2PR04MB8600.eurprd04.prod.outlook.com
 (2603:10a6:10:2db::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8600:EE_|AS1PR04MB9405:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bf1d9d9-87ea-41f2-3470-08db14286cfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oiYElODHqTdNrdi4TUAOUqaRhtaAg1VD2FA5GkJpW/d9c1fwhnLUUfT8wXvRuC267Vk1P8clM8PZ5EHCACxCOiGvYPQo0zZ983j/6qNUv2/gBgLKPirS63BH8va9G6VX71ri/lvQNADgj5YyIem7zC9H5sWlXhLsO7cD5Hg6XM9Z9u2iGx2H8IZXOcKTN4FZNbP9l+IsaDlw0kM3oYGhQiEvd+/oQpCcmHVjjyjTr3LgnD/uLY92go+QBaXbnKcrqZasXeuPuqTsX1p0D2j0+9bHGcIlDDfZ6hDHL9jxFeRGOi2855wnzldC29E/6Qq4Zlvbz5tmAZMa3Ee1qeTKXu51fq9pzg2DUy7SIasWNLYNlKM/hF8wfTKPZk4CNjwcSsg5hPh6L1PPWKWfIjNpVkH/sn5ipPxR1sLKYWAKzwlw1zRdJXxAIo5iDMinFRdoUtA1uJNkPkOpPQ8xnQohTCFRrqXHBPIulFejO91MSwKPd3OVB1qFd5FVlTYjtYFmG9ATT8jK671tWi2kZYjm6yqTQDgTwzY6EM4xKG/wn97S6ltEtkMcrqP/S8tsv8QR/dSOJjN6EEnfhoEEV5CiLFTId8bGlmRr/ZxcIJd6E25OqeYuIQgQu5pSPToaje5p41J5Pc7Ohg/LkF0gE8maZcp6y2XnheKPPE8CfPwHVtiEPdDMX01Xoy3e4g/PZIeOcpRlH7R6fGUbyyFzWqgBNKfDG/Jrt2f3efzhM/bdOM+ZrKgUFixIvaWXAYGXqfyR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199018)(38350700002)(83380400001)(921005)(86362001)(36756003)(38100700002)(2906002)(8936002)(41300700001)(5660300002)(7416002)(6512007)(186003)(26005)(6666004)(6506007)(1076003)(2616005)(4326008)(316002)(8676002)(66556008)(966005)(6486002)(66476007)(52116002)(478600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AuiWidlUDWdHYDM+TdkfpMi6E+BDNJY+h38sXFTbEuOPYJkQzMzEtLABb+8L?=
 =?us-ascii?Q?SvEdlggBwNirEEok+4fNXNDZskdbRNcWE6JRUQ8FBiPjf3SIbCymFiNxYFEr?=
 =?us-ascii?Q?tzxm9QOqF6qhgAeYxQ+5dXYuHB0/BE62CpXIHmhh3TQLL93UkujBO0Cf9G1r?=
 =?us-ascii?Q?bysSnKGUBxQNo1m7hZp7B1qNizwAEZBAlRi30EoEbbvXt+avG4jOl8cIndG3?=
 =?us-ascii?Q?wcllSy1oInBChqb2OS8cm3RfIz3v50fTLjMBSl+HHoQjQVVmYsI5Eb7cdatK?=
 =?us-ascii?Q?4Y+SPsBwxCIR7ZuIAqf8TJVO9mgZbJCLv1SWyuCV7tKvqxUo2ve7Q7SubzaY?=
 =?us-ascii?Q?52x1f1kFRLRirm5f/pl9HVQL45tKVsmot8QvoBU4Ir8qdycDCcKEAOwfD2OK?=
 =?us-ascii?Q?5UuuF1c3CYQzBZZFDeATRAiMW3M1yBaK+htsixKr5U22mj3nQtGrAi00Ej1+?=
 =?us-ascii?Q?6qby5zmocJc1bBYejkovYSXwIBqiObGs9hbw6ehpm9jgVTQh/9IwSv8tlMBk?=
 =?us-ascii?Q?lHo8pAI33NiO6y6DIdsQxPqpNxhjSXl4VzBkObOHATLTnpQKrJxHhjDiWRA1?=
 =?us-ascii?Q?zO8ec8uMc5MV54p0/Dw2/unseJbmXj1bLOZvt6MFj962/Ei3fnoOG7hd4Hde?=
 =?us-ascii?Q?ZbQfBps5ljYfTSwkrN1COX66QlDQAdSjSrfAZH8ZLK4KksvkkWmHEjjvwCDM?=
 =?us-ascii?Q?AFW9U7iBz/Ca2+0icio0RY7t8W97n5uentWUUdpGguLCD6JkpD3NYQttZSUq?=
 =?us-ascii?Q?ikYZKPa3hKG5q1aNGXOe0lZ8Fi6JQFQBvk1FfY2HrOGONq2bbaR19Jw1u0eR?=
 =?us-ascii?Q?8otpgz3tgOb+bD0n0NET6CGzWxtGpV8M/cIeRQn/7G6R1MjF9y1qAtf9/BfV?=
 =?us-ascii?Q?QNoYaF7BUwyXiapB4tzhWgr0VXqdAL//4zdH2W8b4ClN54/BXuV5i7BwO4df?=
 =?us-ascii?Q?z43td0LkAlFtgTXn8Ko5s5dCP/Zr3+OKN/2OVADMsOlSnF22hyKCc3v5/IQx?=
 =?us-ascii?Q?zZ/OkyroKzMw/Ts/5K2+Lj93n5g6cvyoXXRMpnNgnwohm01JWFJub3rZDrBE?=
 =?us-ascii?Q?N+vznpu2Bwi4dOEUHbrnvbvFkzb5MwrJzfzUVR//PXu8a2YI6FE3oZFR/KiX?=
 =?us-ascii?Q?f9d9Ddo5A/Feq78OMm1aRVFIwiW2geWV6PaVE1ZfU3UeZJId741E5J5Olrar?=
 =?us-ascii?Q?Q159PrkKvEwmvnH5mqiCiky0vG0FI0hVml0MyiLg5A3sOgqLRDUOc/HwqaH7?=
 =?us-ascii?Q?B7fP0Wfa9CkqXAo9vtDa63goWBWRJxlG4vGCJC2MWscHnFkYaOiZbW8BEgS1?=
 =?us-ascii?Q?6enBb+UUnsUU7FhPsr4ZT58cG4DlCSqsbD+hy0ASTKsg2T5Ej9cP9Xn05LeX?=
 =?us-ascii?Q?MTafzie7jLIu9SiESfadlRZQFNQQgSa4dSH0YQ+ZIAaO3Tz5J/6guKSZ7qZt?=
 =?us-ascii?Q?Pp8O5Z/H1YiS/n5ygIKxhSZQVQzsIRvs0F9xPNDFbg0lh9CiaxDort3xoeDB?=
 =?us-ascii?Q?CAP//iF7haZT0nAdUU7GPI1z6D+o18fP5R9vgjw+tZ+sFKYmRoDGwPYf0+I1?=
 =?us-ascii?Q?L3d9U2M2pEVcPKyype4JA/Fff/xxEFu1THcgTx8BuX8BWqmk/r0j1P9eYI68?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf1d9d9-87ea-41f2-3470-08db14286cfb
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 16:26:46.5831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yc1QGasWIEyKerG+7Z2HGrlBOo+oEFxXQ1JGt17BL0tq7KCcPH6Ask6vzwOeAjXu4D+nJ848Nxc+IumwS98GbYKiSrSKwrKL/51F//TaNHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9405
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding document for NXP bluetooth chipsets attached over UART.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
v2: Resolved dt_binding_check errors. (Rob Herring)
v2: Modified description, added specific compatibility devices, corrected indentations. (Krzysztof Kozlowski)
v3: Modified description, renamed file (Krzysztof Kozlowski)
v4: Resolved dt_binding_check errors, corrected indentation. (Rob
Herring, Krzysztof Kozlowski)
---
 .../bindings/net/bluetooth/nxp,w8987-bt.yaml  | 38 +++++++++++++++++++
 MAINTAINERS                                   |  6 +++
 2 files changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,w8987-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,w8987-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,w8987-bt.yaml
new file mode 100644
index 000000000000..de361ce4ab73
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,w8987-bt.yaml
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/bluetooth/nxp,w8987-bt.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Bluetooth chips
+
+description:
+  This binding describes UART-attached NXP bluetooth chips.
+  These chips are dual-radio chips supporting WiFi and Bluetooth.
+  The bluetooth works on standard H4 protocol over 4-wire UART.
+  The RTS and CTS lines are used during FW download.
+  To enable power save mode, the host asserts break signal
+  over UART-TX line to put the chip into power save state.
+  De-asserting break wakes-up the BT chip.
+
+maintainers:
+  - Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
+
+properties:
+  compatible:
+    enum:
+      - nxp,88w8987-bt
+      - nxp,88w8997-bt
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    uart2 {
+        bluetooth {
+            compatible = "nxp,88w8987-bt";
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 32dd41574930..6d36f52dc124 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22835,6 +22835,12 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
 
+NXP BLUETOOTH WIRELESS DRIVERS
+M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
+M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/bluetooth/nxp,w8987-bt.yaml
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.34.1

