Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC19E4D4C90
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242349AbiCJPBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344165AbiCJO73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:59:29 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2047.outbound.protection.outlook.com [40.107.20.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F311418A79E;
        Thu, 10 Mar 2022 06:52:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEcN8gPHU/T+6nROK9GDKU4DcsJNZhWl23gS7ikZTKVbjbh5wcONoc7U6AUX/v01zhcLLH23pF/KP+rggcINZokmVAFrmE0ugS0a5ML6BjA1l99OYdy2LwY/77O4znbpocToSp25m/1rSIBTZ0z+uysIKI+lO3GeO+gj+EwP7TsHQ7ha0kzfh/kQDvnZfNqVSDTAq33ugVuZKkk+tHdYnuT1DnLzIcjl6SSiUyrUdKrzLxCAACnBE+Y3iIszBJ0jtTHhRUibfmraDSAxW0H8lBbA4G+FhOcFL7dSoSsGnAh0cnEWGQkSnmtuH3qOM63t7+tcZJUniLGX50rCUN/7Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/kuhjtUjH2ZO4JOH3JCNYaNvISinxJ0qkoklccG6Ow=;
 b=EJpb8dUMU6CdvxP0IQaXjWiPtzsrALSgfnE/WDbaaNS1IdaxCATHoWgAwPOAUXvq4JIEHm4TsxF6YvSoUo8lYaXFCW0oYzWq44zCgPO7WFFN6nfODXQnuQGHqYVIK804xyRFuKnklGEwiSIampn9y1NTDBD/ZdsG9WF0mU71lYWxy1BBeQv1WoX5oU1pvdBpIfNfneU4Odcjyh33hr9lp4oBmEVhsf9kYw19EZmlFtNg7g2buMsMV3nK2SXjKNoj1TOf1opqkDfantodxqjZtTMohX/kuXAHPOk+m2tvwQeIQIikSEUscAdTVPAy/Tb+4/uWIfr2CY+TW5M8KWs1CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/kuhjtUjH2ZO4JOH3JCNYaNvISinxJ0qkoklccG6Ow=;
 b=B7dJToPYRy6f+27EcVqwmdyKnz7bQXfvfYncLqH45yriCQO7kqTJkM5pOzYxST02EqU1GlrHo3oZym6B17Hrvl36WwqwAwEIA9THgUl7nu826TxzZ+mAstg0/x5voLLzFAatLOFaMF+8zSxvFo2/v6A0vzFH1suCrEe/7smKDVI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.29; Thu, 10 Mar
 2022 14:52:28 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 14:52:28 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 5/8] dpaa2-mac: retrieve API version and detect features
Date:   Thu, 10 Mar 2022 16:51:57 +0200
Message-Id: <20220310145200.3645763-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0288.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e27233b6-1c4c-4b28-fb52-08da02a59861
X-MS-TrafficTypeDiagnostic: AM8PR04MB7281:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB728120513AE632DA08995E33E00B9@AM8PR04MB7281.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vVrzzZyvz2IxBTzTDrzUoYGFYV3N6FFzrBGn8LnS2VST192zUL1t78WkSU5pvfaIu6Td5unvWjdFUiRzhyKevJugD9GAjZ4qHpDC/bhKxao9x7DlKo3OGKEPVlQq9Rt6RI3sNLc253f+XrXmL+RTixiD/qusQmKMaEkF3SCSzM7rieen+mxpddZ+GQtxNjw9dkaU5FKueqTjdU4PyY3MTAwrEadvwFnXMqI9R8VuYwbM8CGe24SYS1V1lPOtTyWFmUP2jVO6bHkU2bfSE9kRJHh427xAdqrnBgh7yzHE/HRZxI3Dq+1rKTmG/4Ta2ob7bVfq9PPlwA3FQv3TWsXM8VaNXA+d2GieajzsoLTqlqKGHdiOaJ1RkcDSxNY0+O+wDK0Ms8MvLXhKMppNm1e1U0YwTR6163X3BCwu0pJ9Y1xk9dGRP6kiVRIgAo4es9pIO8eUqLINhtYAC0iEUvevPSLU/tex2n4vFCqm/injeG5+KMIKvcoB7ts/YflY97BU4uyxd67cxbFF7ewmL2YnSeZFS4W8VPrA9Hvp0KkeSMYj1QfuO9SPRadsVS9QuIdY/IwULFxzSz9ipi36VMkXlJ7cCUKRQk62Ej/P5Rs2asOuoXwc/GyxMS/tId+WZ6b9bKURDpTBzekpGBOXJq8zKRsE5Qhi7eXYEYy7HAkLQyESIgVoMb/P5uFKdttoCsNXnKbmGkdDwaCF01SbnUTDZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(316002)(66556008)(6486002)(52116002)(66476007)(8676002)(5660300002)(6506007)(66946007)(4326008)(2616005)(2906002)(8936002)(86362001)(186003)(44832011)(38350700002)(38100700002)(6666004)(508600001)(36756003)(26005)(83380400001)(7416002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FIX0vCHWZFprexf7nItfpKzEaW67fQ/ciU3uVuk1LFZd2bMvBObhDQ7AUTmR?=
 =?us-ascii?Q?bkORKL33fUEr2Sv6XzaJDFWKs1zBPx2bVXuQNyCiL5CtoCWk4kUeijG2DfDD?=
 =?us-ascii?Q?XVUz7S9ZvTG5al/IZc3GA+jYQoM3r/HUhIpVzx2Jg5QBazdfByQ0MZTCmIRC?=
 =?us-ascii?Q?eM3p3gQ69MPdKaIZO7dYrKiEomqI3RPkDyF4UcfUBzdCK0p7q5YF6sRt//nw?=
 =?us-ascii?Q?HzqxV8RzbkInqSPDtUUTr62d7P9uM3/QAUGqQ5eXQefbQtyJYKgQemSxRZzB?=
 =?us-ascii?Q?DJVmAquWPc4w9e99uYZ4sWEks39njT3yTjRaQkmbUPTKAPeew6ttguu1lezL?=
 =?us-ascii?Q?WQMlvbBVkdwvGGL1ozq5/9NrzqaL9OTaGFn6gV7SuiH3nJexqCVOIoC67lWH?=
 =?us-ascii?Q?eu3x+Dfwk+hTkAhz+SxzmnkCYZPCIPrNmv3WPS/rGqSM1OJFcZJ+9aTwFpKP?=
 =?us-ascii?Q?9EUyzAiiyCkbQjDjRaIPT03Ea9mq3nUECvo+4Y0udHiX6cB3byd1P5xlmzbN?=
 =?us-ascii?Q?wbbtv0JzC4Vkm5nyCTcP7v/IZZS1oGNNO2qaWNNfBaB/phs6ukxGNOCWvSU3?=
 =?us-ascii?Q?zpmhMe5YXThvSPh2Pv7hGY+gfle0FqSyYqmMXT6eoG7jFf0fSQqkSefqmw9f?=
 =?us-ascii?Q?1BPJrJQ2rKsQyDtULBagaoT08FtC0ekB71rzGY2KqHEwUTG0ZDtgchs+0HhU?=
 =?us-ascii?Q?ZLkR4kHVb1DgHpVAhcrFkAx7a1V6Z4cp7B862+fgefE6tFc8ddhgpAzrbzG+?=
 =?us-ascii?Q?tJFPuTmT98m83BYQRi6QUoZT3r8zHbrlN0wyjIKmLO0ecPSD8PhfQwhW8Ezv?=
 =?us-ascii?Q?Tkw1C4TS/fWwWdGbjODKjGFg8bpJ4+1G/1r0wvWcCqp6nqxH1xqy52ZbD0Is?=
 =?us-ascii?Q?dwbzeovXT729JaUxsLzJm13Kx+lo1B9cgR8pgJpkE1PEk4DEBlFP00IXIB4j?=
 =?us-ascii?Q?TabecRh62amebjoFxO0PcqSAawiht/06WJa1BW62m8TxKYvTMW/uF16WJzt3?=
 =?us-ascii?Q?iH0KjERSZr5nXamR4HKNy4Bm9h3kZ8RYqGQ7AM9VBaM50eDPUQxuwbiNt9yc?=
 =?us-ascii?Q?GbjMbrtJ+fZX6LKzR2HDvAXvau+QwLDZoR2LQC+k0j9chUwlq2XUAZTUZJS+?=
 =?us-ascii?Q?QJ3M4s3fJUJqfDQtKf0kp+7uwi83Me7zjJR9CjsA3FfzCA4cSZUawpGPMAdM?=
 =?us-ascii?Q?7OvZmGoDUyqupJz+IDDQ4lxwxl1Y+EAgThpfs48O6SFpbIolzNET/rQhrX47?=
 =?us-ascii?Q?btE08Vvi3n8VHvtOR3+QDk89lIXKcmU0DhtA+j27zxV/VYjp24RhS+Th22NN?=
 =?us-ascii?Q?O9c0K7H743cF4KTh9JlndPu8pYunqxi/vBFl0wx/ZQYk0MOux09po82t3nTw?=
 =?us-ascii?Q?1lM5Lp+HxYU641JVPht05FXa7+tKC4AWdCsp30biEOrM4ruI31ldYF47tN19?=
 =?us-ascii?Q?4fSqD04dyj4Xc8yJSqpEgqpmqE3OM3Ni42wJ58kCnxtu9nG3ahzcym7PAK/W?=
 =?us-ascii?Q?naBmEm8A0Cw7bETHtARhduSRhlwO6F8qQzeTHPTV6VcjAPf3Vwzibzd7JZSd?=
 =?us-ascii?Q?oMbrfr7D5E7auv0FBgFZL7FkTwA3WEi7umEtgFIba+m7tJwHLkOYeQ2GVMVZ?=
 =?us-ascii?Q?rnEgaVUb4WWxZvFsah54Qxo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e27233b6-1c4c-4b28-fb52-08da02a59861
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 14:52:28.0138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4vB7idOX+OS6FdraaZgBMefG7qaTTYTvOgsSlXa+Boqms7arCGKD2r+npy3jorTYX6Hvyy/0X0+YdIBiO7KUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Retrieve the API version running on the firmware and based on it detect
which features are available for usage.
The first one to be listed is the capability to change the MAC protocol
at runtime.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- none

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 30 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 521f036d1c00..c4a49bf10156 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -11,6 +11,28 @@
 #define phylink_to_dpaa2_mac(config) \
 	container_of((config), struct dpaa2_mac, phylink_config)
 
+#define DPMAC_PROTOCOL_CHANGE_VER_MAJOR		4
+#define DPMAC_PROTOCOL_CHANGE_VER_MINOR		8
+
+#define DPAA2_MAC_FEATURE_PROTOCOL_CHANGE	BIT(0)
+
+static int dpaa2_mac_cmp_ver(struct dpaa2_mac *mac,
+			     u16 ver_major, u16 ver_minor)
+{
+	if (mac->ver_major == ver_major)
+		return mac->ver_minor - ver_minor;
+	return mac->ver_major - ver_major;
+}
+
+static void dpaa2_mac_detect_features(struct dpaa2_mac *mac)
+{
+	mac->features = 0;
+
+	if (dpaa2_mac_cmp_ver(mac, DPMAC_PROTOCOL_CHANGE_VER_MAJOR,
+			      DPMAC_PROTOCOL_CHANGE_VER_MINOR) >= 0)
+		mac->features |= DPAA2_MAC_FEATURE_PROTOCOL_CHANGE;
+}
+
 static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 {
 	*if_mode = PHY_INTERFACE_MODE_NA;
@@ -359,6 +381,14 @@ int dpaa2_mac_open(struct dpaa2_mac *mac)
 		goto err_close_dpmac;
 	}
 
+	err = dpmac_get_api_version(mac->mc_io, 0, &mac->ver_major, &mac->ver_minor);
+	if (err) {
+		netdev_err(net_dev, "dpmac_get_api_version() = %d\n", err);
+		goto err_close_dpmac;
+	}
+
+	dpaa2_mac_detect_features(mac);
+
 	/* Find the device node representing the MAC device and link the device
 	 * behind the associated netdev to it.
 	 */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 1331a8477fe4..d2e51d21c80c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -17,6 +17,8 @@ struct dpaa2_mac {
 	struct net_device *net_dev;
 	struct fsl_mc_io *mc_io;
 	struct dpmac_attr attr;
+	u16 ver_major, ver_minor;
+	unsigned long features;
 
 	struct phylink_config phylink_config;
 	struct phylink *phylink;
-- 
2.33.1

