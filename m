Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529996A0663
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbjBWKhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbjBWKhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:37:25 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2045.outbound.protection.outlook.com [40.107.7.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A6F51FB7;
        Thu, 23 Feb 2023 02:37:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDaIpD6DUnbNpUuteG5KhY2PHWC1E7Fb8xmIB6+Ez5Yww8RzIuUmdPVxGiflGQHmZ2IieZrl45XhTIbcLR9U5tf7q9rYT2k1HVnD7FzbiuVbG1/m9KcnmuT403y/g1VxjWC1ygerkBybEyeLxTUCs6XesFdkeVtVTaCi4S7bejTtH3DbS5xmgf6SvREO3PBtWcWqCYRUXKv3csYoD4+1rgryClEAAvcF7v33loC27/THgAvqIiGjpGvwM7ISyKs2Jy5fhkcpBXv2q/jeCK5zbamYnAdLsYKwaHqKg+nFEiwOiwwkbl1QwiA7oDVHK1+W5mfXYJRnYHeHbt1zW7KQQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OsiN5ZZwPc03BkQeMZTXhfObCW9KQHB+d+9chCcqxsc=;
 b=E/DYzwHXPOcwfk+IgSPtMDBi8slBEDsHMqayQHtOueAJik2YxctpIuxdupTv8D3TyX+vvZajfeW1GaplIrYgN0HZfDV4T4qDWkH19LgyKo2hIkcnM14yXWkvJMA2vau3ozYHVCDI9WS6AcBR4U7Hu6Q9Aaq6cs3QbgEI6L8NRnVgdaB/U4wtPr2XbygZRORi3bt9QuyddcwVBJmG3POccevumBoC/VB6CCLng/jK0qIyBO5MSe2jEzmZSNHtd1x4clRtfPNj6ZwZ0g66ukFVQDWJA4mcd/DSEB1C7slLiiKflA+KIxKvWSB8SpwtBZjpmoc7DAeNSHKEzl7Zt/gaEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsiN5ZZwPc03BkQeMZTXhfObCW9KQHB+d+9chCcqxsc=;
 b=kKOhFyUBpY0yY62p+y+CRZoPCO4QPU00bFOJbzMilFzFzw1ULmQ9Ku4Rv9Rr10II9N3JJJISHtxpsytO+WoQ/oIXPHgUL9UQJsW/XKk8OQVFJt3MUlTW4wXECHmmkBwzJg67zx83m+aJKWNU6kQLrqvivl/a30Q1ebv+IorPVhY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by PAXPR04MB8239.eurprd04.prod.outlook.com (2603:10a6:102:1c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 10:37:11 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 10:37:11 +0000
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
Subject: [PATCH v5 2/3] dt-bindings: net: Bluetooth: Add NXP bluetooth support
Date:   Thu, 23 Feb 2023 16:06:13 +0530
Message-Id: <20230223103614.4137309-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230223103614.4137309-1-neeraj.sanjaykale@nxp.com>
References: <20230223103614.4137309-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0137.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::42) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|PAXPR04MB8239:EE_
X-MS-Office365-Filtering-Correlation-Id: c1173d5c-9b24-4807-b17b-08db1589eb5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Q2+4h5O4T6na3IlT7u1zKGrwVtHvyRGimx2XTq0uQRXZpryQ9xVdYSPQjFS8bmG6gpbYDvM1/n2ncKTb0PV3o2BW8syi0D16U6BrYwzikr9oGrQNDVcOczd/gXOSbFS5ei5NFeKYkf2UX8OPcndt1slnRrVJob+EV0PHNoxBUAbzhFdHuO7WCpfPY8E+xPnOfomcBw0Z/Vki/OezqYpgPfglt5kjXJhSdFmHZBbdrChcJ7bkC9kx+ZMQKw+Dq3UsD357RBs6kgmOyfeNI6Sd4Jg6/gEenEoDZ9equKPMD/rFt1UxSvf9Fqju5EoZhKhNr9QidsTRcf+RonL8B2NshQOXBh1l2A2qOaCjXaGNmfhbAACg8NWk8Ur2MqBDlo0Wbl1YecaNs/SILNdUuz7ZGBkMF09sOuGqTtEnA6BuSmaoWZcOvVznDjO5kAl5V+9bhuT3Sug98dXdfycdfrGEA2BacOMmOcqUmMju2OKNpl7ee8wwNVimSPQ5GxBUukAQQDxpzh/jxe79RTR9xc6BGlxfJ9Evrz+HpmWfKrH798qQfSwdWuJ/1gUpZVEkBiix2CxilJC+VhyjtOWAVlysa9sYrgYHZFNaDxWlGqTlJrKwXZpOhkx7ACBistd3FHHFscG7WYefcftWWrF+5U+0wUd8AqV/4gZsSVVZwW2bI+jVbv92qw7OX7lbfNsB99ca2FjAZ5B7N9rFUDskPB/fQdXR1pDQ9r906ovng8W2OjC5Hc9H2jkvZJpCB1u22FE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(4326008)(921005)(86362001)(36756003)(38100700002)(38350700002)(66946007)(8676002)(1076003)(66556008)(186003)(6506007)(66476007)(26005)(41300700001)(6512007)(6486002)(966005)(52116002)(478600001)(316002)(2616005)(2906002)(83380400001)(5660300002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ak4rEgfgakpZySk2MDqeWSnjN6XQ5YCXnkC41SHxW9CDYzBEv1atwdJNAjL?=
 =?us-ascii?Q?7NRgcnq647t0XYt0Es9vJ/2MJLEjp0257f5RhHOUbLfBNczp1A/Jhhh2OVOo?=
 =?us-ascii?Q?9ovY4Y2GgnRUMlNsxw6I4JIXYC9b4uguKBltSlRzRBDWGqWC2104TovDoEvM?=
 =?us-ascii?Q?RvJ59sfQC1e/O5wjRVcLGwrz/fvf9Tfq7zpMvGOh5YAM4iP9dw0OooeT79rK?=
 =?us-ascii?Q?v2loUK3eCVY4e8Dd/kxm85YbdBrACX3VeoehtZQrqYqqMrbpDEESFFPHLCx3?=
 =?us-ascii?Q?Vz9q7zBpw6d0fyLqYOB7aqHlKtAB12p8phnW3nqVbUEjcJvL7mr5G1RAIYPn?=
 =?us-ascii?Q?ONtFmTgN1UtJebhNe5++izRrAl5HMVEZreq0g5xVEev6khJy98H9yZCjYjFL?=
 =?us-ascii?Q?fnZ0++K6Z3rLyF4wA09cD3ulvTRm35xqtvLEYmvPAuygICV0iE7njql+WYh8?=
 =?us-ascii?Q?LRVShGH0ihcaoe+LTZjqh73y8AR8wIgREG/kxCFqMLjWDpyveRzE0ydMpCkj?=
 =?us-ascii?Q?0866KoR3UPz11G1Tedo/I7J3btfHuT8BKjqz867KB4HXQPKjpr5jJfTNBWK2?=
 =?us-ascii?Q?lHQ5bEeeFTstn8PLZ6eP8vEshho6vmyULtjQ4fN/DGNcen5uDlL9QYWACA7m?=
 =?us-ascii?Q?Zu9FqGmto4AXgyVp8SWzO4GwFa28kbni+PwMbv4RSncgA1CkSf1GhfasMops?=
 =?us-ascii?Q?vutg3008hS/5073OhEcXpbo3shtBfX/6CZP+UcglF3MljkJsjeyKfFcR2JBj?=
 =?us-ascii?Q?XagzbDwosNB3dTMUr3MPjHQbdblmrDznU81U5igV1SfPn7pDeZLWcS9wTA/w?=
 =?us-ascii?Q?xwGQdZu5FWP3otv5gZnV47txgIL63SGVNjUGTeWPIzgbi1AKiKx9scJTOi7/?=
 =?us-ascii?Q?NMaPzGtjlaMclxhwWu61/KQPHE1Phtp5rIqVcuOPu7l+aRwdEWDlpb9sFgsR?=
 =?us-ascii?Q?5HbPZb/GCrJWM+6KHxf+C5N4JP4QRpd6B5+v8yxIPY6dDA+KbSPgwaUZmSLz?=
 =?us-ascii?Q?Yn7Q7YC4WDpKFjMeMuahTTCvTvbRYOz5LLBNyvgv9kL6udm9roAEXki136Ey?=
 =?us-ascii?Q?70t+hJXzqIgvJVceoXKbgoy+/kXDfUkeNdFoii6JNG06EQ0hqrH0xaRgNq/q?=
 =?us-ascii?Q?pKGbLEtDkPgnCnlMdiehFVDDzFLseHNQ6J7qlcVFX/bdUk5g1F0oNAm/6RtP?=
 =?us-ascii?Q?atrudu03nC+eDww+GNjumazQCYENDiI3pT2riAv6zmuZZ4g1YuseF2+iiATl?=
 =?us-ascii?Q?qSMW5Sp5k5G0JLazB5cYiG4dgl46cAz3eWC50t9LVAZrIVkfcvVy+k6EIZyj?=
 =?us-ascii?Q?0C/WG4b9qa7H4oLtV6pI/jCvrO/iTEx6vivd5h5kHXJKVLIVMRHrR3iYZQOz?=
 =?us-ascii?Q?+dyeHsROMHHSyDAeoaxG0WyxXo8FqajshQCvvPWzrz3RqX5DPV5DV0ZHrPqX?=
 =?us-ascii?Q?zbMstrifviFsU4aYCooGVU3gLWNGTpbnIUEo2itRjVkgPp9UVKsjSL/VnaX+?=
 =?us-ascii?Q?Gl6KbiRN5Lt2Di+lKn6J7rTlKT4Qf/85P3AX+/Fbqkv+MYFjdV6IawqWL8jV?=
 =?us-ascii?Q?u6yyEpCsr0TAdDf5u6JxTDtqC0wemGhPsbtVymTpnlYjnCgh1N4zuLW4eFIV?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1173d5c-9b24-4807-b17b-08db1589eb5a
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 10:37:10.9630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TIOxTU60gRqmjW0FlRd1F6As5VIwrgHA3TCYfmtufi+vq4jEiv+s0y2cUab7oh+hw6x1dEGWTqOORU3nRR38W2JsgF8DZRVKsJfoahzvVKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8239
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding document for NXP bluetooth chipsets attached over UART.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
v2: Resolved dt_binding_check errors. (Rob Herring)
v2: Modified description, added specific compatibility devices,
corrected indentations. (Krzysztof Kozlowski)
v3: Modified description, renamed file (Krzysztof Kozlowski)
v4: Resolved dt_binding_check errors, corrected indentation.
(Rob Herring, Krzysztof Kozlowski)
v5: Corrected serial device name in example. (Krzysztof Kozlowski)
---
 .../net/bluetooth/nxp,88w8987-bt.yaml         | 38 +++++++++++++++++++
 MAINTAINERS                                   |  6 +++
 2 files changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
new file mode 100644
index 000000000000..d2f3f2b6e15d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/bluetooth/nxp,88w8987-bt.yaml#
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
+    serial {
+        bluetooth {
+            compatible = "nxp,88w8987-bt";
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

