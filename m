Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF776AC948
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjCFRHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCFRH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:07:27 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2074.outbound.protection.outlook.com [40.107.13.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E8764866;
        Mon,  6 Mar 2023 09:06:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Av41wuFQH7/boyTzLyABQVCtnyE2ZjEi22R9IrV5UCGIka3hHLN0qjLlzWJPdjkHEaPFdUXVLzEmkF9tJetdBvs2phiiF0BgDw0qaQorSR7o8ocSemUhpKsAyNq/2fH/MFoSnaH9KWlv6g8kgju0fQG/JrqpG/zYT6ugUZ6CsSvCD1LiZsOgGJvuUHJhxB5EnUA8jzVgkCoTcV8D/pVb1dEWq2x3Zexx2pESkzj+8BjGkecZ6dN/K7PM0POq957aOEoDzJhU1l51eMQ7i2Rx9W+E46QPSaUjB6yLIwUURY/CgGTnOLc01cfvouzybeQzbfMoK1dRoLZB3eyFgeKWgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lXvJmWsKiEDF7bGa7efvlLRdaiR9wPwcnWO5lzbjF8=;
 b=BWg9Haf9hWoegf+avB6hMES6vXaWbt0xEq8SyKu1LcbyXu/TFRIY69FNVDyXOpRVrroPv1M4ti0z2d+qz/gxpGZhfG6bSHhUkPGeBCu5EsL3HYZCdEeOMwcsv1RJn74wUflxv6PdnBfVJtINAog/cc2qsePQUc93r1gHN69DQsjSel0DpKuJWcsEZKgrZpQqeHlY9MLM/mkPYRY2yvd5NhJA96HNo4J6+mEePlrJUx4WaEOvb/RvviuvKAFKhfceHn7dEafRUTw9NQDWNo4KOUne5Q0pX/YJV4VSNISBIYY8g16bMZ/AD2SjgRK2IOcAAy8Frl/1/Y30trQqLkNcww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lXvJmWsKiEDF7bGa7efvlLRdaiR9wPwcnWO5lzbjF8=;
 b=BHOfPHXFqKxDaQy+7tz34IbG1fbDN7FzP/Kx9oMO8Xl9n7qfZtOq1fkovrHgphZqbMmYETbIedMM3nevnyivKPXwKFC5Zn0ZNMfhYxO+kUNd1fI9SnQlYkk+7oLRQphm+tDS6DyhRKAGjq+Yq6dSxzYaerl+JS22YFEKrHmp9cU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DB9PR04MB9427.eurprd04.prod.outlook.com (2603:10a6:10:369::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 17:06:19 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:06:19 +0000
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
Subject: [PATCH v7 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Mon,  6 Mar 2023 22:35:24 +0530
Message-Id: <20230306170525.3732605-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306170525.3732605-1-neeraj.sanjaykale@nxp.com>
References: <20230306170525.3732605-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:196::19) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DB9PR04MB9427:EE_
X-MS-Office365-Filtering-Correlation-Id: abaa5a08-b728-4b1b-2bf2-08db1e651a81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nOxCMR03MItQ+hvBm8oOIto0oo0gTdjOVI3KHrm6BqSK69yl3BcDYGsGbLHJQsilHToPo9wO/dq2iXCgZgxfFgS+xa+9Dg7Rd026UIxnd+qwoi8cFYKHMSAZgiWZeeqFikpWUvy9z/nPoWgWVoiTpS97P3L37ogBqV+FUTki4iia3lP4PP0eUSQYLpzbW2Gnb+QNo+357Q065MLQG/K+KyIhVdHQgUPbiE88Xb9XnniIyMDB09vHpJGJIfNNU982LS2+9eYDKIbnDHyUBax7d39FkVxEmUhYrbdhpjNQdC/8nP1z23bnA3o/vUQrAuB4h7NLqDccza+N1osc5Eah5dMxfGgIzColxhOOMkpqXJIMvLjuVBJQPtJpTDxVYYaBEcXIycZsTf4gkJmsrhvQss8ue8sifBJ9Rifr8lkKQGSUIvRqLwUhHbfSvKHf28bxcCDa1hux5thI5v2SSMx9hUBzFnsy/Xd8iiJEItDLzIBuLi7k3vDvElm36/nfK+ukUpc8WUMoacqxLulWMcd251YTrCO+Iec9y7Rb/qYH0M53ESloP18OMD3vcmHnk8iyCmWesy873QMpw3HIFzkzmCRyRjPckiNkKLyGXwcv7mp4I/bXr/OnCGBE6/eyOcE9VPBAz5UDPB9FKZPmoIqBYnJ1tpCsnElMshFVStvn31A7DpxpHh0ai9wb3nkUPVa9XBcSF3nfayVxYvP2dv0jI68t2XBE/6HNf4VH6d6JG4019nKJpsIvRVsil+XVfWfV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199018)(8936002)(5660300002)(7416002)(66946007)(66556008)(2906002)(66476007)(8676002)(4326008)(316002)(478600001)(52116002)(6666004)(36756003)(6506007)(6512007)(1076003)(966005)(6486002)(26005)(2616005)(41300700001)(86362001)(83380400001)(921005)(186003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L004VXGJ/w161nMucoPLwZ208BpUgvkcAq5HY/t0I3sWIjY4zVeGHPue0jBx?=
 =?us-ascii?Q?BA4zNBtfMJRSjufKKa0+dDoEIw2FYueADARQ12P2qgRoCnnLVH1ts0iM/lhm?=
 =?us-ascii?Q?92RQCEuqe+fwp8txQQR7R+/4tQNvk3T1PIyio3EXDa+AcICTM+r3hFksQ4YR?=
 =?us-ascii?Q?eCeqL5C14+QA7ByVcHhFDiLcanO32NxP29xUk1ZEBpfjSjBAiorIRQgGYDox?=
 =?us-ascii?Q?kPmPVmjjVzIBBgBOSPMyH0TXhSfZ1AZ2ioEuTqq7XMfWbdjr+LhiAmKf4Q6J?=
 =?us-ascii?Q?Wd4XodfOt8jo1ICdk3oJe7bkDWET7LoUmAv79ngKlh7XgviFZ7wjgiEuoCw5?=
 =?us-ascii?Q?0SBs/9E1CDKH8774DS0M8GhNiFaMW2sekk198vHPjMNtwHMesOQLADdT7bbK?=
 =?us-ascii?Q?rrOR+KZ17O/EFkFZSmM7hJcRpVuY+c3XH8pCuRjIcaKuHL2+CY47UK+Flcpp?=
 =?us-ascii?Q?wWmvajIqksVHkjy2zm5VpSMlPFX5VUILV7pzGaIsTu83krEJ03EwlT9zheG+?=
 =?us-ascii?Q?78aoQoIrgKP5/TtZnfMI+uChwr48Xm3H61i6P3bX6/cZUvT6H/0IXrNNKdQI?=
 =?us-ascii?Q?HDFCNsWq/JgF1dWeDyoTqzxwmiQhMMoW1toHf8TFbDaG2PbJUzUG72yUKQN7?=
 =?us-ascii?Q?bsyRiaj1WJYe3OgFWffquU1dgUdyxPXds0BPflF8Y20g2k683DrD7shQIN9U?=
 =?us-ascii?Q?gIHd4Xa1Sux8Jee7acG5nQNKV8NExhZAktGliHEDGc5XUbKkaL2fA6MmG7sP?=
 =?us-ascii?Q?zGFfcc92UZY5WYYoOYqHHjiHOfuG+W/pJVL2hk5Yev96AxPbYeWtQWMgQihr?=
 =?us-ascii?Q?FtHfTvBOzM6SlS6QNWY49e8d2mHnzdmWPCWFQsO9eb8kyrEM2GC6JKYjZ0ZG?=
 =?us-ascii?Q?qeziHwGwM1QBu5fFEOgB7Yh5/154EDZb/uTJQuqUIyxx+YCoF1V2D4DRHtCp?=
 =?us-ascii?Q?a+7axeBKAxAqnveZ0+K+CAjtoukmZ5PRhnVYE8KwqwIhrfC/JZ5tPrlGDjRc?=
 =?us-ascii?Q?S0XBX0hYrQBij6NPTXBuD1EO3R8T/bGq+Btl9cS1RAVq/MtjRA6KMxop7pRn?=
 =?us-ascii?Q?dPlcj6TkHIxr6QK1bSCp+agqGnNXfOQdbHtZ2+rRK71thjfkZks9qyKpt8Xt?=
 =?us-ascii?Q?p31RGahyniSK776hVXDaRFA6B9rjhadlKZNSdmI9PVsVF2w+YGC2rvrab6Oe?=
 =?us-ascii?Q?FepOO2+HL7fS8Igoo/IEPxGgx8OK/+X+7EU42zS2c9yGdwmAv/SOCA4i983z?=
 =?us-ascii?Q?qO22WSt2CSST7W62/X71299gC0wZ/qJhz9p0WheKnmh6d6y+hxJZuf+tQfy5?=
 =?us-ascii?Q?thAa2j1TDSbqiMiQfXv0PDeyQMyJ4jHdDP5FmYW9JJiwAbJlY72x9ys9GYbP?=
 =?us-ascii?Q?qo2SyJJuQaqumVoCWQzT54E0NYGu1e3cOCcYbIpBvG1HNEm3LxGDPzncnAeR?=
 =?us-ascii?Q?/81Qf9hDdWAW1V0q1M1b0201iveW4j7W0ia5Y+1Kq5ecYJboiacbyUl3hjlG?=
 =?us-ascii?Q?pwVm1MKoC6Htx4XHirUSDlr2hqM2uNpUteaJlvtJwIFD+3MQYrr8MtyqQ4Tm?=
 =?us-ascii?Q?AEgA2fo/WetO6Av+3MWKBBrmSjBpv6t68uagXdGlkOnvdy2ONz1Re7Wmg9FB?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abaa5a08-b728-4b1b-2bf2-08db1e651a81
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:06:19.0603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJMrTG+7wqmVWSo7xyVxIclbOlOFZKPRVAHxniX+XOi+WdCA85bVed5UHop3Fjv59JrMLEuROpbPAuwETFsA2XaAMLhF6w0ddNv1qxz8cuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9427
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
---
 .../net/bluetooth/nxp,88w8987-bt.yaml         | 46 +++++++++++++++++++
 MAINTAINERS                                   |  6 +++
 2 files changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
new file mode 100644
index 000000000000..b913ca59b489
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
@@ -0,0 +1,46 @@
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

