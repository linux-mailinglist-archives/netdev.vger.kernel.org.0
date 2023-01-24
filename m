Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4295367A074
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbjAXRsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbjAXRsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:48:19 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2066.outbound.protection.outlook.com [40.107.104.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C84D4B75A;
        Tue, 24 Jan 2023 09:48:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZI7crzO1gnWGb8xceVmM1zROMCRu/B2pBte6KakIeAJ+PkZ/TChE3i+QJm87NDBr+VrfE2YAgqnQOtQHnxSHTg2ibzXBaKjeNsQR8/AMuaPgjqPAzazGvHqWtr/1F4kGtMaSJyyncTqA1bIpM+KcnoJlRUqEuxowejmyl/wfGhVK7mynM9eQCJzi2K1LNArF2vqgqiG4FOZpCqqXVpKN00nLnhz/Siz9L2gzJcP3TgK6xgOr+4eW8CbFedTumjf8adrWmRj8iOX5saDRedVSbBJGa2HdKHKXSSRIj84n0dUq26mz8aC4KAmxQc67N3LwAPPGrq/7NU2jWrEsc86lbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxEmtjIDLqHIUoQzvjLer60Az/pczxPEiTFwZJpb7jM=;
 b=U35Bzm4Z/ZuP0RtIXQBQl561vVGKqnDKC+5HDZ2hzDyokrM1BdKrjqtjNMAPyeWkzjXYH0h9tokuAp1hnyp2l7YlsK2S5JbEdRLRt3Dxhcy4WjtjGVJSBcKBJ8BRWVP+mASyzo1DTYMYK1IL7DZ3omepvry+aOl2KP1BeB8IKCD+syzGkN5OeU3LFw7g/PxDl+MMzvk7ze1xrSmz7TRh5TC0W4O5k4wnwq2r4GXncFTlz9nMVl5jyiOLalVN0IFlpB9jp2KKaqkLLO+t6pRqBCAGL8YiGH8ld/6oddLZYhmxQeZHEEwfElzp/U8hR2Rz59H5yM3BpEEQOLtvq+piTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxEmtjIDLqHIUoQzvjLer60Az/pczxPEiTFwZJpb7jM=;
 b=n+4mVt2fSJq0ybVUPpQQlQ+GzWSD1hgp40/UI61klECSPhv6kIh627IMfjiE78pYp8ESkOsH1+c3tv+Nm4tOJIdenDL+VneiVXRp4Fc7kFlVqEL2BPFXaukpzZZx9Tk4FIjU/FulpXm7S3q6SrK4poIXx2Qsmj9xK47J8QgYCAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM0PR04MB7026.eurprd04.prod.outlook.com (2603:10a6:208:192::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Tue, 24 Jan
 2023 17:48:12 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%5]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 17:48:12 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v1 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Tue, 24 Jan 2023 23:17:13 +0530
Message-Id: <20230124174714.2775680-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
References: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:194::12) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|AM0PR04MB7026:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c523973-5355-4b46-6b5a-08dafe3329a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6e4xe3n6L0dDu8qT3iKvkF3K58cySKUZeADZolL2FrkFoAUY1BGTF06EBT1kxDxjDcaZELU52c7OyZtTV61I9lO56yMbaFeEwUjNkuSQ442hAqj03iwzJrtD51kzVyyoiQ8JGh6C+KFvsZE/2biBVuUwwr2NacNXie2No5YdJnDuRsrwUZpCqUBmUAIWFG2E7R3DhTNwfi6EDLZyCkPjBu6sJXs6JbE7bmebf/sj8ChbXIbNgnXOI6e93vuab8/gLXIxjyMp7jaMKz615zPQR1yAe2OAIEcufM+ApSQ73cee0ctuD2J4MXxwDARVbL5N88/6HKzke7GAlHvC9gav6PmEOUBJm0ePDwrNtKjpliE0601oq3QHIDQEfucC3RrEFUF6cTGTM/dsAWU/1PzfjC+LxZcR2YbjiWRHahoTrkpJ+4EXrp+fddIqlsag4N+ene7EEAGpaARajQR6zWIyacqy5ZQFeXU9K+/nVRn6RQxHqJoozYa9iSLqHt3rCUg2OUW2pIfO81sGoSbevk71pLLbnPzkPAG/exaYD8jTNfLUS/By6SVje8dNMbS+bQn1nBvHs0DZOJBx2cXpdknMD4akQsdo6vQWjTclInkihTkzt+cmBy3OYiPeuybnNlJ07zwmQuIrJnIzFnHUpIrEs0oMaaGGjFMFdmhj78ijfm7w8kqdABTtNm2VJMxsh1XCJ3a6JEMf9VkRa5c1th7/QZYTvpdLNGwU7ICawVUer7NHV2hShQfVoSXmXr4/yz4wQpc36Mwn2iog4nGwhpZ+RtF1BxUxn37toA00NrH2vk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199015)(36756003)(86362001)(921005)(66556008)(66476007)(4326008)(66946007)(2906002)(8936002)(8676002)(5660300002)(7416002)(38350700002)(38100700002)(52116002)(316002)(478600001)(6486002)(41300700001)(6506007)(26005)(83380400001)(2616005)(1076003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZQtWR01gUAeOPUQ13zld5AXEdDkZkevC/OxUJuMK5EzdMqLzErOWiuxrr84g?=
 =?us-ascii?Q?WOgnUUPuLNG3RzSmw5l0x4Pt4dAlswapMnreCpaMcV23VxODOSugV6UQ180j?=
 =?us-ascii?Q?ONoaYtPXreSNHQxwB7YoOP4bmUmwZA8SBAZ/pJFcFAlxR9GxSAxcQLbtvewe?=
 =?us-ascii?Q?odRgFqIunP5ZZkocl8rIuE+HDh3b2GmGoGVjop/49frkwjGI5F6WAFp8O/7l?=
 =?us-ascii?Q?NEfGNqt+RF6ZcDhxNhQjHU/cVKzglGpFSxFVf1iarlrg9d2Vh8QD9BxsbbwR?=
 =?us-ascii?Q?TU4ufIHren03RP1hoU+OXWatwup/BqURNaTU9fHchNvW/18LEueyxP5t99mb?=
 =?us-ascii?Q?Ef1gd7/OxHwLqCwXNtUTYVcWHD+PPUqshWABol44yxDSZuzovLyNwMdgra9Y?=
 =?us-ascii?Q?0GcjY4sdDpu3RYgMyUlU0x5Q6NULDciUX0a+IXzc7ZRo7NK7HqJWSszusiN6?=
 =?us-ascii?Q?+Mz6ctSGkHugHThrSjuaOucC193Q3FyklmGniRM8PfQx9YrTmBnXU7RyX6Wo?=
 =?us-ascii?Q?clY9tdPYtwSGQHugHbmedoDUkgv3EwpbjQnak44Vaf+9uiw9bYJfg20vtFUX?=
 =?us-ascii?Q?6bKQ1XlIJhlpNbFzZ/uFgfRuuw6VO3JFOILUOFxG4W+nfjYUYnuygnIa4d8/?=
 =?us-ascii?Q?6rhJxrcCrkuXzapKlgHcMoHPegxjquTCcJmz0UvubnGYFwtpmMaGeiz8Fwh3?=
 =?us-ascii?Q?Jrcdo0SLT1GL5bOqE1QPuK9et5UfJGwnz+BqRG7R68UINNfJHXf/wz/clIhr?=
 =?us-ascii?Q?gqULjUVHWgf2Riw7a9m37sHnLfkmr9ESlQtWHvS9twYqbGCVkYVEigcvHHkH?=
 =?us-ascii?Q?dsan6WRaDD+mrL/w1QauExGQbksVt8YU8+WYdDAwknQUrUX6bVsrY+RnzZTL?=
 =?us-ascii?Q?ZD9pIuTJMqnFRykqfwE0XxN2yBfb2zbMPNz9EMbKcNUoaCvwjWJ+UopXXOpb?=
 =?us-ascii?Q?UAeZQZuLwtbvpXYOV6dKrdloKh7EdVelUlvt/6D9LhFIKLnpXRs3oqvqYtPU?=
 =?us-ascii?Q?ROo451a4K9QVmxRbGrbRPnoOgyc1ZvwsUv5XfB/jyba/3zbL326ajpdCOBHZ?=
 =?us-ascii?Q?poOSapErkgcTR0QTfGKbo3T7hxb679MfiqrfaUe+MRl/M82EjlGryMrH9WzU?=
 =?us-ascii?Q?Ba3srpiHQ0cZdRxzzU8nks0Ud7P94i6hLz5FOqxj+gbQJl1god0BK0XjnCCp?=
 =?us-ascii?Q?oMGl40hsyZFaDRJ5EWjgplAIZrxsy0ROJeM87TvjBrLtPusL+O+t9Hkr5CH5?=
 =?us-ascii?Q?n688D9o6JZTezPKzAvFodZQBMJ9u3oJTWi5knIItx1un1MCvA3+YL8odUlj6?=
 =?us-ascii?Q?0OYqIfp0bnOUcbPyDT/3gzHTZgbSrOtHs0fmRLJt/IiPRIZueeU91KhpxfDw?=
 =?us-ascii?Q?5YQYYoYaTnQQ5yjSFI9jJjv/JlcLgWQL7WcsZivZMjfJLmff/VeWdfgqCJrI?=
 =?us-ascii?Q?HsmJFq/kHVck9GZcRngfKrh0qzqNbuzUxjL76GPPV9T7qTYiRJgCiR7USfig?=
 =?us-ascii?Q?+rQvZSHRX14RgHqUl1q5N5B7GYdYSstw/KEtXq5v65hEnPi4aRD2wEivNcOI?=
 =?us-ascii?Q?k1DCUszF0IZDKHJL4iagESIaXANGZZ/mfZ9N3v5Oy/cQqfcTiH35lsrr+Srj?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c523973-5355-4b46-6b5a-08dafe3329a7
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 17:48:12.3846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6S1L4PLxiusn4dFzyUGTXZ+7vZDMCUb6HMHDWEuisTy/oFo5RcdrLDPVvgZgnQZDfqWhIqQyvp2Ae8QDdfZFnU2DhP/bJdEgiz0PZp7R7Xw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7026
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding document for generic and legacy NXP bluetooth
chipset.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
 .../bindings/net/bluetooth/nxp-bluetooth.yaml | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
new file mode 100644
index 000000000000..d6226838ab1c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
@@ -0,0 +1,67 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/bluetooth/nxp-bluetooth.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: NXP Bluetooth chips
+
+description:
+  This documents the binding structure and common properties for serial
+  attached NXP Bluetooth devices.
+
+maintainers:
+  - Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
+
+properties:
+  compatible:
+    enum:
+      - nxp,nxp-generic-bt-chip
+      - nxp,nxp-legacy-bt-chip
+
+  firmware-name:
+    description:
+      Specify firmware file name. If this property is not
+      specified, it is fetched from the user-space config
+      file nxp/bt_mod_para.conf
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    &uart1 {
+      pinctrl-names = "default";
+      pinctrl-0 = <&pinctrl_uart1>;
+      assigned-clocks = <&clk IMX8MM_CLK_UART1>;
+      assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_80M>;
+      fsl,uart-has-rtscts;
+      status = "okay";
+      bluetooth {
+              compatible = "nxp,nxp-generic-bt-chip";
+      };
+    };
+  - |
+    &uart2 {
+      bluetooth {
+              compatible = "nxp,nxp-generic-bt-chip";
+              firmware-name = "uartuart_n61x_v1.bin"
+      };
+    };
+  - |
+    &uart3 {
+      bluetooth {
+              compatible = "nxp,nxp-legacy-bt-chip";
+      };
+    };
+  - |
+    &uart4 {
+      bluetooth {
+              compatible = "nxp,nxp-legacy-bt-chip";
+              firmware-name = "uartuart8987_bt.bin"
+      };
+    };
+
+
-- 
2.34.1

