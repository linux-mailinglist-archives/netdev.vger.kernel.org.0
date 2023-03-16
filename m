Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4526BD6F6
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCPRXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjCPRXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:23:17 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768B54233;
        Thu, 16 Mar 2023 10:23:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1ghbZ4gfvpIt01d70RPguuCdbeE07ddC9WfUL2GaMLgHGZ1C/eOVap9cG0JnsZNksQvkJbpL8WpbyZOHU3hn8n31TUMdpJSmRYxQVYHjRBrzJVvO2X01mSgGjvaoKgAcT0TYIPu6dtpofULo83KL9CDSHY8TI4LuoI9VZVe8zvC4+PoGXjCrmehfKK/6weP8bVmVmVK7aGxAF+AUdB9VOePpoXVms/9YJcRSf6FwRwZs4zDqAGkhEFS9j7p0FdEP8VrC9xRkAPkLUAqRpKtGOYF5E7qOhjOiyCFzS8OPUVtHXOIJNHcSzwEZtR+RoFi9mycD3BhKJsJlmfDCDJiog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pE/kksZ9/izowAg1GSlXNRb2ouOGLUVelluEjwyW+P4=;
 b=Ftb1aoVc5Yvk/LOZp936VUX4wrsdKdAxEy0MdG/iCQFwbrlc2ep/D0RcgV5ZPPhMcG0YNtHnQiKU5Tvy4Q4oFkUyqWfnmi1sm4ymRJH5dt8ldwlY/+anjVyX+zIP0TbagoTrAjgYKQg9uI/EOLfzoB2b2NydkO7gprQZPHw+bHkkTeyOlrGYfxXSJuKCZhdkfaKa/xscgnEJoYuG24Uy9j1isAom/8mTh5dO2GDLpzH65NKW12zyFpVE6S/WxlEY85F0UvdDzRL6euBw1Vr4McDHY/oEt4yGjp8t3IxnmTZyXt+5MzqDH5SrY64cbqRosyIR5lX5IW48Sam+pjcxaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pE/kksZ9/izowAg1GSlXNRb2ouOGLUVelluEjwyW+P4=;
 b=m9nkFHL5u/RFkgweiAdHwz9fbP7J0eMe3YpFQ+xjMbdVgAKVvGwVPi4m+d1AGylT6d6dkNPNCulvRZ158fUlXFLS8aFwCuVS7UhNJ3y5mYGsMI8jhHE8vV5PW2hUPO9zgZPhTLAw0iExEoZJyR9w0D4zD5vwq4SuC1ZWPVXjjlw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
 by PA4PR04MB9293.eurprd04.prod.outlook.com (2603:10a6:102:2a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 17:23:03 +0000
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::d590:6d9a:9f14:95b9]) by DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::d590:6d9a:9f14:95b9%8]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 17:23:03 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v13 3/4] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Thu, 16 Mar 2023 22:52:13 +0530
Message-Id: <20230316172214.3899786-4-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
References: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::19)
 To DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8600:EE_|PA4PR04MB9293:EE_
X-MS-Office365-Filtering-Correlation-Id: 39359446-c541-439a-2fae-08db26431919
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pRBauS8SU9hPQlP9lmdqOKLQsWZSzcTeIxInr8eBPjfxCmzanxDCDYL8horUlVUACsGLS3yGHf/hZ6EYW+wRHbwl5ulOdjqPQoFnyN3XBN0CtJOAYAwDEWd2KGI0yzWFw2dOVbwRAi6K85DYBbbGEnugBYfhutJkTe2iN9z97NzAl/XylC3dglCO4uKw83E4KwhV4EbsbPxepMuCa8zUwdF7e6ePR4D6+IlLfJRX9djXtKFk2STgIZuO3jskzQJyn3oJnC8Rv+DRqZb8TG7TsI9qddFz4rVl1TNalthyC9lchACaag3/VS6NxliXi7cCYmz9sVo9w/VmDviZOR6wC3EEeohaOyR2U1r6cB05cgisyYjTytbNETwi8sYGlr4nfHxwGBXOHqvFOZklH5N1bN4qNHWRCg/dkKpDDj71t7KQAu7XSBnJU3MY9z8o0glRhxCREPNXtkUEYYAyBKkUkzsztNLnmQ0H4cLkFCl36asgz+hwdwDw+S0u6tDW2jYubrbpDadp7hoBUqI+2yhnYo/52EhQBAb01aRo0ueZ6q/nkj+5dQhQ9rwXzTGq4RNmUZjGS5ehdtYxiXn32/LW3vIRw7iqoZk/eTMFZmtTVzVit8CLf5IqrKLhbPKUoJoWLiGhLQvtmN5Z0pLwNsnWBmK+0FcY7m/PqjhDKYJBzoB+s/jtkmcrbKp5wWIiLeNLlX+RG7Sk/QimKZsXO6lZJ9C2VG8+6zCBWudRs1Lb3fCIaLs9EN09hIJ+VNv3RcIn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(6486002)(52116002)(966005)(6512007)(6506007)(1076003)(478600001)(26005)(83380400001)(2616005)(6666004)(66476007)(66946007)(316002)(186003)(66556008)(2906002)(41300700001)(4326008)(8936002)(5660300002)(8676002)(7416002)(38350700002)(38100700002)(921005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0NOcqTV61Ew74lYtN5Rnw16ajUGbqcNh96L6S5M6f0DCAAKO2hRDLQB/hP3Z?=
 =?us-ascii?Q?BhzI+QLDFZZEULO2+Oy67HEMolnTNd7HCJw7YXbWXqlQto1fDgQJPR3/6bgh?=
 =?us-ascii?Q?Ck7afg0bQKBxvso9HA/bXFMC9IkqoKkVwIyI0nud/oyLA9CdOXPBgY9W0kok?=
 =?us-ascii?Q?c+wKk6hu/nhTz8hrQV4LBeoSp15vpKJCfREvbB+1PvBWQH4IxZ+NR9LdmhBS?=
 =?us-ascii?Q?hwFn1t5cEJnTUSiyCDivYJ0euttT5oK/ddVmjFIMkS29LKF/ow+mCYKagGBn?=
 =?us-ascii?Q?3T9WfiIODSLuyrHo/0aKCFnNS+jtX6Gg/4cWdp2Ti6wEOZdc+cSsSlze4FpI?=
 =?us-ascii?Q?SjG/MucVCR4FUQqMTqCyJv0gWOKJOBjMk7BV/p2o5MsQcFbrqNzf/AFasQQT?=
 =?us-ascii?Q?fqsgI4GtZqbvgYpZSS6/oFhXADPlVf+N5hD5jEkCEvK55n/Ocno4e/o2y056?=
 =?us-ascii?Q?NGFo8UwUJoa15oTrrfV0uR09+c7WEwoqLqsCEiMFj/BgT+iGzf9otgXxwyp7?=
 =?us-ascii?Q?w9YjyT2nDRpFuKF8DkFeACRBM/KjGt5/g13GISuJwhL3UQ/W4idM31fXkSA6?=
 =?us-ascii?Q?yWouhp2gQ0sa2A+vCmCVniNSAqmUVv7TwpGoij0GBQf7PvR7vcl8eJBcID/j?=
 =?us-ascii?Q?3pHkQe42SsKjn7ZlO2ZBMW4Fa0OWPKZ9I2ojTR4QYE+UMHhXvWD9HzFVwXv7?=
 =?us-ascii?Q?gZDggrBqwd1P1APMuDFkZqqlQ7/EyrOie4LJleJSRs8fz0LGreL4vl1tsybj?=
 =?us-ascii?Q?A6rKAXQifVbEYfYbKOD8SXPPfG5H2tv3CQA7kHttqLms9IokyCovJ7fSKl22?=
 =?us-ascii?Q?iy3aJvlcKeX2NkZVv6/sTc3U5yR/CZl7gmLrTW3ehUCHLRgnF2QTz7es9zkV?=
 =?us-ascii?Q?RQ6qDPcy5AB9qdOjaYFTxh4lGn2pbb6Mz8vDX42xg0RYQ63I+nbW8h0dfqEu?=
 =?us-ascii?Q?CM8l9auP6y1ebJfD0DrIttF7RkFMB0uTxFOEszJUtHXCQaNFumCG+MJ3eISx?=
 =?us-ascii?Q?HLUhNhXScpOrgwXGQ6Wkeez+f7Stm5BKvpql/qVuuCd9kaSCzs8Rd35v+HCe?=
 =?us-ascii?Q?9OjRY38VKAaSt2Tas6vI7m6K4kWopJZU/9IXSMl+BXYUVbL1un/PtkQy55n0?=
 =?us-ascii?Q?t+BCfVHiEVuRC05/uSCyoybYUfqpo2Omb41M1dBjellu/rpFT61OquZmQFez?=
 =?us-ascii?Q?juB3SrjnaIsvIxVVQj//g4PVQZYKk+WVT66/dIJWImUB2qW1hUbue6FnHA3Y?=
 =?us-ascii?Q?3S4E1Tq0ek7QSLOwMcVCqhuBZA/M/ZbMi70jZmTaC6EfhNZkCE510rkNUbko?=
 =?us-ascii?Q?vNmkuZ0A4yNQhnSuC7/8SPNwu+EfC3319xHuE9po+XQOMXZmCF++rzTZQClL?=
 =?us-ascii?Q?UIv7nZQUbTPN2MOLg0Gk1PJLgdfI+8H9RJuIVeotbukafVlqJJggnlKdhJOv?=
 =?us-ascii?Q?O9LeR5lpkgsAVhSTodJK78qGMA08/kS4lbF1Fn6LZAIqSgy2C4fkFKB21WA9?=
 =?us-ascii?Q?kMf70Na+LnZjDnPcJMPnQWE84P4FPmZoB6IN7+XQPoFWtplhYs5P44+Y5Yit?=
 =?us-ascii?Q?JrKQhM4A7PTH/ZDDw8kawvDOjZ0PvdHzwqnAH9loXLougNi+Bzo+XPeTU5Q8?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39359446-c541-439a-2fae-08db26431919
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 17:23:03.0520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Im+zVKXyvmg92ajkysKkJiJwVj8g7ccP7YmHvn0dkMpBMRx564KfKVfT7ArO7E7HY6hAAoCsv2jQjWyBtPBWWI0aXt8tXwttlLqRBILPtvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9293
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
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
v2: Resolved dt_binding_check errors. (Rob Herring)
v2: Modified description, added specific compatibility devices, corrected
indentations. (Krzysztof Kozlowski)
v3: Modified description, renamed file (Krzysztof Kozlowski)
v4: Resolved dt_binding_check errors, corrected indentation.
(Rob Herring, Krzysztof Kozlowski)
v5: Corrected serial device name in example. (Krzysztof Kozlowski)
v11: Corrected grammatical errors in description. (Paul Menzel)
---
 .../net/bluetooth/nxp,88w8987-bt.yaml         | 45 +++++++++++++++++++
 MAINTAINERS                                   |  6 +++
 2 files changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
new file mode 100644
index 000000000000..57e4c87cb00b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/bluetooth/nxp,88w8987-bt.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Bluetooth chips
+
+description:
+  This binding describes UART-attached NXP bluetooth chips. These chips
+  are dual-radio chips supporting WiFi and Bluetooth. The bluetooth
+  works on standard H4 protocol over 4-wire UART. The RTS and CTS lines
+  are used during FW download. To enable power save mode, the host
+  asserts break signal over UART-TX line to put the chip into power save
+  state. De-asserting break wakes up the BT chip.
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
+  fw-init-baudrate:
+    description:
+      Chip baudrate after FW is downloaded and initialized.
+      This property depends on the module vendor's
+      configuration. If this property is not specified,
+      115200 is set as default.
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    serial {
+        bluetooth {
+            compatible = "nxp,88w8987-bt";
+            fw-init-baudrate = <3000000>;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 32dd41574930..030ec6fe89df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22835,6 +22835,12 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
 
+NXP BLUETOOTH WIRELESS DRIVERS
+M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
+M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.34.1

