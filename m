Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15E1673E2B
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjASQFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjASQEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:04:53 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2053.outbound.protection.outlook.com [40.107.20.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C216C547
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:04:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSb6DMKXZFPlvJURdCV4vs2sF9JYMluW+NFKQH8F6Bar8ILmtBLbYj4mbGg2y6263ENrTY8iVNjRzadkkOJkq//6Ltk/1evYiNnq2a/fv8pEwH1qfDbb4cZ/y/9EaQnd97M5AjEv6arnPGVSbEWQVi4C9C0Ro3FPq2kU6UgZeLs2RyRLxdP7mSMS5spzFDL0CCJygXdZV+kRQztINXRMYeiRv3U95joZYzMRO9brew5e8bblLlFwhJ5JqDnnLyhLc2Tj/yh+aq/4VWehAMCsnQ95zqdtQb3w7PXztYwKDwls91yhEmTDtcxEsZuVX0lPWi7QBqMFSTxTyvtlV5UIFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ba5QdOQVFhDa2x1OwdK6sgV5wNdVhoofgtqyMaPwQ/M=;
 b=Uo7HEZPKyolfGJMEJ2FUlg86PXEMd/E/4fDplasY7eEOP+FDQ+jzdPEj0Yvvp12IsYD2YnhCdtowjWBRxgXxnnkHTrD3eLBClDp9jW8UfXYRRKTQCyeqXujxfowSF+w+oPcUSdv3MIibnjlHioIZbSIGoliUOhqrA397GT1cbY8CJBp+Gm9mRO5iv0WygGR5HYSHzRDJhhgujYWM4hKmPuJLoDKc+SZXU/x6BJIOJB8KAuwpqH2A3wA46qpJEkz08KVeUUWSRtEfwgudy1XQTid1CLU/sNyQn4szWLmRWKSSkuCs7Y6uWvcLCjMyTyKsf1TAq2Z2R8LCIaVjuqdLdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ba5QdOQVFhDa2x1OwdK6sgV5wNdVhoofgtqyMaPwQ/M=;
 b=mBSK+6bFC7V6kdffapuzc1aJRKcGeHdJnrQArCLrNFWSGsLZN7FaT6G7rEUs012sMxXvBJvNIHmnL70m9nHV7CjRNDQHJxvoMP+zVdFTpUA6SW7YnSl+fWF0cDeUyApGUV8PncCjnPqEiTvByeEpQALX69zTJIKj/vFGLt8zPj8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 16:04:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 16:04:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next 2/6] net: enetc: detect frame preemption hardware capability
Date:   Thu, 19 Jan 2023 18:04:27 +0200
Message-Id: <20230119160431.295833-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119160431.295833-1-vladimir.oltean@nxp.com>
References: <20230119160431.295833-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0130.eurprd04.prod.outlook.com
 (2603:10a6:208:55::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: b574ff3d-30f1-4d17-bf26-08dafa36e112
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KLHh879YatWIzuioJXOaix3gxP285c36WHj2Fh7BDn+rj9OkdKZUcHvV7/QuUnZl81AyW799567BEcZpOsFYgwb9hCvY4WEP6PJk3sqf+XL0hX1F177jK8ByMjscx+vyj+8NFmyUwGIr9RZuS1hHWUngs16hbRe94YYPVPgshZSWZ0cR7n27NxTzJKGMbxDGo1eUEucEx/gjnKQWRWENKl2M98kHBFokk+WNGErwXj3A6YVO5B97wuDoZYcpj5yBBvEhvyarYK5WL+hgg0GdcoLAO9vk5gY5RnWieH2upx8Mdd5CThuKIzrwa4aoGjzgj4bIDbw8dQOpOw+WTkK40rco7ZzlKPE5laItOeUG+P/fGrkCHmC5TOZJnpgWLKOEqHYnp45/C9UY7+yOK5XdCJ/aq/EJ0kjSkxmGsju6IoXPLKIMVf2/4YXLs53mQ+JlyAYQLdEEx7s2zN96Cj8NSPV+WZtWO+HsES/4wvNYPltr5UioPkOILVgfuzl5gsVfG3rQW1jkiggt2n3zbmNWsE5dvo6zEgHBkLaT37q1N91NniU/Sc8PsIDqYQPBnmzlmCvS0E66eWe5RQMqsNU2x7aFEqgIa1nVYqwQvuMXhb3XQPJbNYApGogCSWyOb1CxFu26Oq9vNKbx4exDu0kv2TRI4ypjyjcolH+rMfPF+icg9ss7uUXmM8c/OaL9oOTRAfvCHCwSSWq+D6JWybxKcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(2906002)(41300700001)(83380400001)(6916009)(8676002)(66946007)(66476007)(66556008)(4326008)(36756003)(44832011)(2616005)(8936002)(316002)(5660300002)(54906003)(1076003)(6666004)(38100700002)(186003)(26005)(38350700002)(6506007)(52116002)(86362001)(478600001)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8JxTk218J3nLzIKPXX5KfQ7PVLzrLs6MuOWVPsNO84yzzfJVRYF1fpQc1rlW?=
 =?us-ascii?Q?URREyrzl2jk9Dqg8kJtVu1rEzwU3mAxHf4fshRNhehXUCZr41CVPxKUBslgi?=
 =?us-ascii?Q?aRhS9HPuPFwcbEnlxptEmpV1EWmGN0pYR2TlsGfdULhbNkWyZRtVzypcj13r?=
 =?us-ascii?Q?X84ByQk3XovxViUgTU24RMLtMqhHsIFzNacWoFGBKb6zIuYqnSAD+WK6FipF?=
 =?us-ascii?Q?o9iiLUgCo1ngsqBFiyGi59Bnfkp3uj9+he1PnsdIGekp3RT/sRdAxQ2wcSI6?=
 =?us-ascii?Q?5P6pPTS15MiODiIdhB/3E5pQQbA2uew8dXpyOvvmV+gFZZcDU/HrYMCJyOzi?=
 =?us-ascii?Q?ZsDw8Cr6PUPyhA6wUDCfLhfEI/KlW6pc+A1/7+uudmUp9+TykEAPZxr7aPBZ?=
 =?us-ascii?Q?LFC2KGkoHtsv4qzaceKOeEFnmmeviH3ijIH1PI3u40mz0bs1y5j+LUQiL6O7?=
 =?us-ascii?Q?7s2j8VThiNSvRwJTpN649QiuOXHeI9o0Rb7YuJqYX9QIg/n4Zc+J3ccH5GuT?=
 =?us-ascii?Q?P5BRsSlv/2W23KXB8+AeYwbNU+emVf+Y1v4RQDF4Feq0Pi4wugyS28TRVg+E?=
 =?us-ascii?Q?oAB1vxNq7P6uJORuAFQOJpH0Y6XbeXACLrvqdiWpCkTKa4FkKD+GTd4Ai6WH?=
 =?us-ascii?Q?5KglPDTNmOtNO/vXBXtEFcEA9xy7FzVPF151yka05/IrO0Vlz/P3MVPIfvfO?=
 =?us-ascii?Q?wur8Yz5TPq4uCc2lv8rhK1yEfkOekaqzBcWu2pD5EaPJiogX3whRjhqiWaTj?=
 =?us-ascii?Q?DSFykUYskLa0fWgKgoclNMM090ynDt1zpzKoydCwItPst8GVOcIzz64uPxRY?=
 =?us-ascii?Q?cHBc3E+9Bjlqzgr+HAAM58WNcDgcXwNqtqvthiq8boyj9+u5D2KORBDdrG9A?=
 =?us-ascii?Q?HiEcdMwXfyjRKHeuNsnMN+4BO/cRu3rXtvQH6HxZPjvspa0cx9Dd6xQTuWc7?=
 =?us-ascii?Q?expehepbzLhZodyLCMmKylHqbMnBPkKxsQ1qYqUlhTvJ9XxjDOPTH6FQQLBv?=
 =?us-ascii?Q?3vJiNThggD93JmErzt2oJjr/TDnlxzVq31E/NsY/07lxSCTOTH7SRaPIkutd?=
 =?us-ascii?Q?MeDr3z6eUHuMJx/FWt2tnrQp+83HBrmhbX96pZVv+ANKiQsPlvcg2wClhifr?=
 =?us-ascii?Q?XOlM15gHkEVp4oqG5nvElw6hhZJqHb7u42hI146QMw8SwMRcPobYhVbLhG43?=
 =?us-ascii?Q?nimoDhp0FSmlnKA1kowBc6yIre7GOTj2RucaPGAvRTIsoMaxN+CszjH8upBq?=
 =?us-ascii?Q?GSDTHscnL9wFItm/Q7s7LlnGEQkQXTFHmcsFB/PjNOkr6JwHXt0ciDCLkPB8?=
 =?us-ascii?Q?y4alTCRgPcJSg5h0iWN5KZcFeII9Gs6i1faAxEFMfEg12JJD4+KlIGj2BkB+?=
 =?us-ascii?Q?K8tW4aoTADbbHII9Pb5HGMlKzBoQTC+R1yRk7LNQHhZR8kNMGZkYxiIdjalh?=
 =?us-ascii?Q?VgNO6MjCIseDXSEa3+xaGjh3SALFvCIav0GOQNpiTW32q9lrjiUjA022STjH?=
 =?us-ascii?Q?trNlJNy1BsCp3ftlnRvmdl0mLLfs+jL7OVFBxzm3RbHLfi6EX0fJXlc74vq9?=
 =?us-ascii?Q?E1o2JGyUaTk/YOKExhY9arjErzDkQ6Gu0Kjddz//UZ/LlrkmLGDqh6NnqaGJ?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b574ff3d-30f1-4d17-bf26-08dafa36e112
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 16:04:43.9501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ez3G7ozIRzC+tE1KCwwB67SWQ/75QyTfvxd0JQu6vgsspFEwKfQ6R0zoNwT73SX8UzXi4DOrCgyBZMnVj1q4yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8036
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to other TSN features, query the Station Interface capability
register to see whether preemption is supported on this port or not.
On LS1028A, preemption is available on ports 0 and 2, but not on 1
and 3.

This will allow us in the future to write the pMAC registers only on the
ENETC ports where a pMAC actually exists.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c    | 3 +++
 drivers/net/ethernet/freescale/enetc/enetc.h    | 5 +++--
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 3 ++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 91f61249451a..c4b8d35f6cf2 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1713,6 +1713,9 @@ void enetc_get_si_caps(struct enetc_si *si)
 	if (val & ENETC_SIPCAPR0_QBV)
 		si->hw_features |= ENETC_SI_F_QBV;
 
+	if (val & ENETC_SIPCAPR0_QBU)
+		si->hw_features |= ENETC_SI_F_QBU;
+
 	if (val & ENETC_SIPCAPR0_PSFP)
 		si->hw_features |= ENETC_SI_F_PSFP;
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 6a87aa972e1e..cb227c93a07b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -229,8 +229,9 @@ enum enetc_errata {
 	ENETC_ERR_UCMCSWP	= BIT(1),
 };
 
-#define ENETC_SI_F_QBV BIT(0)
-#define ENETC_SI_F_PSFP BIT(1)
+#define ENETC_SI_F_PSFP BIT(0)
+#define ENETC_SI_F_QBV  BIT(1)
+#define ENETC_SI_F_QBU  BIT(2)
 
 /* PCI IEP device data */
 struct enetc_si {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 18ca1f42b1f7..cc8f1afdc3bc 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -18,9 +18,10 @@
 #define ENETC_SICTR0	0x18
 #define ENETC_SICTR1	0x1c
 #define ENETC_SIPCAPR0	0x20
-#define ENETC_SIPCAPR0_QBV	BIT(4)
 #define ENETC_SIPCAPR0_PSFP	BIT(9)
 #define ENETC_SIPCAPR0_RSS	BIT(8)
+#define ENETC_SIPCAPR0_QBV	BIT(4)
+#define ENETC_SIPCAPR0_QBU	BIT(3)
 #define ENETC_SIPCAPR1	0x24
 #define ENETC_SITGTGR	0x30
 #define ENETC_SIRBGCR	0x38
-- 
2.34.1

