Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CD66B996C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbjCNPfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjCNPez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:34:55 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2051.outbound.protection.outlook.com [40.107.22.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4D0EB43;
        Tue, 14 Mar 2023 08:34:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwDFxWgYfAHOMhPNbuQYkI5a0al1FLB45N6kwLFmo5HvVq0zm55knjnnuetsiPq2lRHxRdpjjHvvNz7lXosNibnJyjQpzbjRmRUqII6zdVlq80jqPhXW2J1QFUI4HfryrICuX5C2AwaoPOfYsJ+ZHxJfyYCVuqpxALhgPqZoiWSP3tAXy/Mo3mmgoMcp+wayrliITGdnviAfVZvl02zTdcqGmY/rXymx0pOgbLNW8qm3uLniEL51Oq5zS1obKQ+qRTS0kb3pohhPxNKTdNd2LXdrKvF5XovcWW7Zf/ghuIpaOjwonpVG0116Axp/tvK6EhEjTkwDp8QXqcMys/Yvow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pE/kksZ9/izowAg1GSlXNRb2ouOGLUVelluEjwyW+P4=;
 b=QDcrwb0SubnBSNvStCSA5DnrMv0xNQ++fRkPFSPtI7vKvmrm8ynajXKAAkaJI9XoiaPKpYzydL/oiWDxo0nJSR89oxuVrv78yqQLFLCdg0UANkPh7AxXwJ1ltYNf5ZxnkApxGFO3ulYX2Q5uigC3QI4r3/3ZqVFTSSE0aLcdPNEqtkal8XvIJEWtdvOFYpQtxYvkptb9Juq2416lvgMQ41TzOpfEsnwHBZcOKPXosTsUjV5nLyqirYSrEZxTA+yqFH7EdmeHx6+WUQ3FPGJr9WG6QXiZxPR1UbTxyQGkHTCiaPk0vSdBmehw0xULqWmjMiqfuNaqjegt9TZJ2VN7EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pE/kksZ9/izowAg1GSlXNRb2ouOGLUVelluEjwyW+P4=;
 b=GaoyfNTFeoZbtuDtUzI2rENBZ5ARXDbF0/MhZLWGYG+dWlYAQafxmxcfWThca0OXIjFHrtZnRu+CshTf8KSbP9M4reX6OP8OytGFtS2baY9IgoxchB5bWm52BCD6TWQCgmetjw/tyffY5ZRlytuhob3cbT/oiQ5RbEO5F3WHKmo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DU0PR04MB9495.eurprd04.prod.outlook.com (2603:10a6:10:32f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:33:06 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:33:05 +0000
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
Subject: [PATCH v11 3/4] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Tue, 14 Mar 2023 21:02:12 +0530
Message-Id: <20230314153213.170045-4-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314153213.170045-1-neeraj.sanjaykale@nxp.com>
References: <20230314153213.170045-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0212.apcprd04.prod.outlook.com
 (2603:1096:4:187::8) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DU0PR04MB9495:EE_
X-MS-Office365-Filtering-Correlation-Id: 879b5c7c-855b-41b7-598b-08db24a16780
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5twCVS00Uot6V0GJh8pCgkrU20bSn59pXiVipLiMz8g30MlaBzrNpKvpqcZcjM10jwjJL4yPTuhG1EMuxMyrGFXQGI61cQwvd/J3qebwWgK4+9B4epMiUYXYW654t5+STyyuTCdrdrbEF9wAa4MFjBUzBEgBfA1b8JOLp253u5wRi6vzE4dZBISCXzJgl28QkClvdnh86IUSJ51KRC0LmYYvk8j0lAfDdbf07y/pa/XlwefvOrAsXwfyFCvid6SpYvEIsMu1p+ru4U33vBztiDotvkyZKmH6WAu5r4FKPvxoS3lReoPDBUMIUnIUQlCx8q8DAUbouDYSdPG25rOTasMx9lgILVbxBTtn24SIEaGU9IXbZ+zwVEXhUDiFrKqEiJ0NAgrs6yE72868Wrb4cAHG2+uTtG4gZr/3XEL2p0EoiBeWTJWNXLUC4qP0MFclIyeyDp2bl1sRNWKTZanOG+0xFVYZAsGu+Fnq9ZG606ACjvOTGFQlcLKAsIMXHq0b0OaIwfmRGF6gZjn50DGJEcJruErnY6bh1i7cpT48Ho4H6pHGfYheAcFJ6RL2KRRjZNBLCKS8MwlhbwHQT4sf+cb5ROMJwJXToVYSJsZ2MUlDBxRBiwJ1kUB5m/8JZsU0qdOtgjXHhHIgmR9xRspEivgTyNGZw+vFW25OiAhEzUqs/C37b/S5Au5Cv7yFwtzXQ6bmWB6xGQYAjhhTm3Rv2v7MXwH7jGqeNfAVkFNolO3r6iPkS0lJFTTXhkcr4Z3s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199018)(2906002)(41300700001)(83380400001)(36756003)(5660300002)(7416002)(66946007)(8676002)(66556008)(38350700002)(38100700002)(921005)(66476007)(86362001)(4326008)(316002)(8936002)(478600001)(186003)(26005)(2616005)(1076003)(6512007)(52116002)(6506007)(966005)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1tET2uGkhsdD2XB9BY5sOSMWSaYK0msX73Bd8jjruIAOHDTrC6D2q4hPriJW?=
 =?us-ascii?Q?j+NGHqIqGRGDXDLzHRsr5bqNYPMH0/GZdEXtuQ31FjpsJjIbp8Ww4/0muZ9v?=
 =?us-ascii?Q?sdjFYhgW7eiPlFSzAAQ9AJDEMx0iMF0/gcQ/7ASI6G8X3SbDb9pXaNLYaf7n?=
 =?us-ascii?Q?ecTZf2kHPmZWRrZU8CUkOVRE7OVilHRQslkNIeqTUlbxHgS5HQg0PY7YVbbm?=
 =?us-ascii?Q?HnrLD/l/CjoIYgDaZKKUBNmeAAUqA+YAhqtQZK51U75h3bgwldcwIl8hss7r?=
 =?us-ascii?Q?1LwaIvv2R5RrwD/EJEGvl4i9VHjxVnlHejXlu7BC0WXCabpiUy5BcS4HRFAJ?=
 =?us-ascii?Q?up4EmAsiW3Z4LiHBd8NcYSBZ889nXtjJRyP85onVYwabv4yeEh/S1IF26NdK?=
 =?us-ascii?Q?Wq8kDPvI93SZPxineJ+35ff7E+5ASvfuLT9NXLeP6JidfVEa/Z0NTT4No0HH?=
 =?us-ascii?Q?sAtn+2+RXKn6s3a7XeYDx+VJOifMGayvkflICC9q35hhaI2hiHUPhK38XkDw?=
 =?us-ascii?Q?IqxA7xKT53q5utvxDLI/9Vp/DYIc3Bti8uEiTfWS/uuflCwf1c/MqHvrtIc/?=
 =?us-ascii?Q?NfVbY6o4FpGK1AVq32OXuwtjJednhDlsSzTe+6yKfJsbt6p7Rk3WaQ6+UkYQ?=
 =?us-ascii?Q?vMexbpIwgSJPG/oyKUUC6aWwgP3f7ZBP9ybNLONZFYhRO+bJ2vaLPU7lCCRf?=
 =?us-ascii?Q?5BUsF7by/EcmOwZzl+ELU5Clpgp7ujSYX8zug2YzFkiYswvGvmlarWoN7Fda?=
 =?us-ascii?Q?c6C4zHRNB8mfy6gUpINNFwFs8uF/RW9Rb9GyAVPq8NySwYTp5pdIdEh3s5bB?=
 =?us-ascii?Q?Cx+1r06/mfw/hqhBonTQuNi+7NLuzH4LgvR2EOKmzfMUwsmm9+FJk+nly8K8?=
 =?us-ascii?Q?G29m7cDZCq79BIQLK2Ku2h9XxDYFuwe2/YbVOxpAkBHqK9G4wX1uwZfJn6P0?=
 =?us-ascii?Q?p6oBpqyH5iJk9b9vReWkXtsLJi1IGA5IpE31AMKLS5c30SJVTfyCJRpQCJZd?=
 =?us-ascii?Q?jFaL0zUOUYFoZRItAd02PfW4bAZfP5kV9QjvTXLo8NxGM+I1pVjJassmcCPb?=
 =?us-ascii?Q?LYb7CD2K3/0EPLooD7kUK2CMEXP/OmsAGCcKVeW7pAas/WaL401+nO33x82A?=
 =?us-ascii?Q?KI4kJBzExBVQkvLJ0geuETsDSbafkslzYXjsasxzuO1QhPrhNOPA40p8W/Dc?=
 =?us-ascii?Q?IawMI8UGzVDjY/w3/vsAhh/c79Au7bwoeD2WPNSSrT0LsWCQlTBCXUzJ/dmt?=
 =?us-ascii?Q?dqiEXeFeqTKQ0wloNbD9fOV7Bvx8h7CqhGoHYXyStGOge4I0OAv261rukJXQ?=
 =?us-ascii?Q?TzGmFfEJVMw57F/kku85+XYCU+jsxmw+GnAxGnCs9Jbs35cboortgR5y6Evf?=
 =?us-ascii?Q?8QFXYih393VWr6lNCDjDLoEbtkzLuwMCbKNrrOC25pH/EtVOJZrdqVY7SeEE?=
 =?us-ascii?Q?qDZEtDvDvZUNk5xil3zM7Oq4zjjDgrOBk/Y5N+HzBw5jqDF7FnEHQYrEnB0P?=
 =?us-ascii?Q?iwAR8qMCVTguSITmFsUqW533d5NdR5QC/A+0T7OfmYQzj01GT+rnml++ZmNC?=
 =?us-ascii?Q?krrytRNyfG7p/AQ0iOIGVf++d7sk/vyxg4kxnEIy9GEwwmpEyzzfjCOglopO?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 879b5c7c-855b-41b7-598b-08db24a16780
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:33:05.0043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kUpk19k/R3cVxd+FVdx5UwUiHGPLyKf9MKMUHVjFtGs9dxjySJXHLqAjPO47w52n53shC+/GlXJGZuP8B+JYXo4+w/GBpYYGdwmvF5Q0SWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9495
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
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

