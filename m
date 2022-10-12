Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE0C5FC401
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 12:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJLKyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 06:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiJLKxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 06:53:49 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80070.outbound.protection.outlook.com [40.107.8.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA24BEFB0;
        Wed, 12 Oct 2022 03:53:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgGRV2etbOejm2CBgiSXUeY69Ug/xKxFoEBBFBLzPFQHEMIj+u+CJ3JxTM4cMskrfQfqiJdLHoOgM68ghkvWz8lxO4aIja0CKRMTb0QXK/V2/KIiTS8nblFxPGvacr9WJU476Vkn87GKKKm2qo/C9j30rQAikijXuwK8Udx1N3A9GB3+GQAaYTswEGRsCu8zD3e1cP0lOkgCPGNadAx6xmQbRPdIodvrtNeIdclvJFzcsH4sp+Vz9qPDivK01QfiY4sAF4EkhmoI+q/hWjmEacPaAFmVRysSY9xm/+mnzDffr3UXC/smB7ccjSA6OXTsa441bBOmu/dVQzhLT9bbHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+pvV3afiDUOQfTaEg2otEN0QHbIqqg1U69u2ZQiJxI=;
 b=Hs3P/Nj/5JRi9ZDb77e4ECH9T0u7vu5TEvywC7M26sMN2FLSUnEH7XvuKtfsHIx1r1WMq6x1XUdf6sd8ZQiuhhkHjjt8Kyhk87rsQIyWjBKO7DHcbFKDEQo7vlWeOSpwm26hvDjyg2vv0v8R0LTK4USp+VCLSSHF4dY9dIWapmraDqRGndm30z62WnS+170mrbsgdEEXh5f7/SKc92ObtQ2vrpvjRGb9yBUgFmZagrrIjUjLYlg9ABzsA3rqdGDDN+yV0DoENiNTnMwtq++4MoURUNiPRDIWdqxDS2zeSieRndj+dJaNEO6F6KcQeRiAIKkLfGE/J5/SI9SKNcE3gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+pvV3afiDUOQfTaEg2otEN0QHbIqqg1U69u2ZQiJxI=;
 b=b4uA7xvMPGnNmrLSG0O6m6mqBW3UeJAn+gHmeKYbyhQ0ACBZBHqRjsU5BcoEwZXX+3o3zxlDVnDY+U7Mt16Nq2DWHFZsErf9Ol3HrHYlkdJD4W59ZiDke1LLXDadOhWvZV5RHItDt8gOhlYQ6qgYaL/KpE+T01m8nWHC+XQ6UHw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by DBBPR04MB7675.eurprd04.prod.outlook.com (2603:10a6:10:207::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 10:53:40 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::d8b1:a777:e29:7a5a]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::d8b1:a777:e29:7a5a%9]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 10:53:40 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, festevam@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 2/3] dt-bindings: add mx93 description
Date:   Wed, 12 Oct 2022 18:51:28 +0800
Message-Id: <20221012105129.3706062-3-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012105129.3706062-1-xiaoning.wang@nxp.com>
References: <20221012105129.3706062-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0107.apcprd03.prod.outlook.com
 (2603:1096:4:7c::35) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|DBBPR04MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 21ccee03-dc25-4ac8-1218-08daac4005b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v97y1sZgY6KL0tJK2IIb3P37HzlzQ4Dv6deSxftf2ebRhCP1ZtiZqrHNU61w8ifJmdah+Ts5UDXyp7rkUYLHkNSaMq93Ncjeqx4eOL64Ijj5YmhLZEQJsGo4TpwIqXQ1r0FTMsXzclLD73zEcClx0d61yBJt4lJfz8f4Rdj9iXdoJfjm23ZKpLNVsYJJWzOSQ4bQ+6b83XZsJJ3yFTamdpWfvsLZ5NpzoF4C5yG85VzC+K0HuI4MrnrgXI8MZdLw/fRwSMboj53SxgipHofs6irLed9e9YmC0BG42UQgKsTYnIRL6DSgY5j4puUw5NECRnBZhdyjRO3UEmdJQT/NsPws5DbBmffbR3q1BwVMPoBqVuea6xUIT6+Xx+477Bs0iFeONpSl+5Prqcyrimr6R4ixpEQBxiptO5tpd+K2jt8sMR3vxWZiYkQb0kiJbPU8iV4LZ/I/i+ohj2nEo46OsvK+qsZNEbK+3cEnnSO3eXMEzrUg48N2yOFhUcVmBm3qzEj4OdUCakYZOdQhRr8nkL5S226pLHWimjEVfuVYmuRD5TW8VAcyD9OI9Uj/Y5L+jM7AzVfutmZt7M0z3yfEPEIDIBu1514gXET/1I5rrpvs68KLqhc6o1+yLdBaJmU5DO9p3A8liyfPFxJhEmcm2srJXHrJDvz25RDZCFfFg6pGXbebS+mf2kkBdxaH8Bx72GQFbr55kB/c7/1Q5kVXD0q9wZ1v6LUZqdIOgbPzxEd8wcOl0uo1A8SYe9Yi4/o2Nvcn3MLNC3KxCI0RzdZo0c2B8uORyftqpUbu7LHiafPe39vMmlTE52inFTXC4QCHEIpk9+3C3BIKVB7kuv2qCDndmVdJrUXoq+WpaxwKjgU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199015)(6666004)(921005)(478600001)(6506007)(36756003)(52116002)(6486002)(86362001)(38100700002)(38350700002)(966005)(2616005)(6512007)(186003)(1076003)(83380400001)(4326008)(2906002)(41300700001)(8676002)(316002)(26005)(5660300002)(66946007)(7416002)(66476007)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xCygPlhy5Z4mplzB5ReTmGtFz1rAIA3aoKhaSXDSuFysR8oHnGtPgR9t5TCP?=
 =?us-ascii?Q?7DDJ91Q7Au59Y2SbyLHfUUyzlaUIhFB8GMrBQgNyd6BoB/rOu8JIJ8gLfXkW?=
 =?us-ascii?Q?CPhOhKOrsETX+o+rFUq7kLEZ+TCOeeOKRFCJWolI4Dhixqn65DK4iXrJwh+K?=
 =?us-ascii?Q?F0aItPAfJMirm1knJ4kN7IQCYDSAJ2OMjoyCqH6Ost3RuArvwRVRfhKfGN23?=
 =?us-ascii?Q?RUJUJSI1bUT5yUrxJoLMMT8e0tR0+JJkODRTy4XjbgBpyi6beMNIzq/YqxYD?=
 =?us-ascii?Q?bo6n/5oNYvE8V9X1kQ90FdcblSbq4jVK8XPZHe/vYsWJpRoUIX6RmwdJAI5e?=
 =?us-ascii?Q?NTm8yLA2wefx/vio9JxDn/rISpbwrbLTlzXGVVv7Sr8/QYlZg9yrQkoBqBrG?=
 =?us-ascii?Q?1eL6/2FfYTYGOgIvIZViowRF8ztLgo8JZZDTgDf5YRyNqfUayuGbqzDiLaBJ?=
 =?us-ascii?Q?2eH/oOpp3e/AAN2fK4MBsYrWO16NXJ9LULjXEt412xGHqOLpvORm1v8DDGE7?=
 =?us-ascii?Q?wWTXaBueIK8dVAhWZlh+TteyqnZFcTMOn8yCqiYd/0isTghKLGYCv1gSJFhY?=
 =?us-ascii?Q?IAxMlu1pc7de+H9RBq8YATQb3R7WPEou/3xOJ5+r0leN3/x2zYKpjN8iHn8W?=
 =?us-ascii?Q?5B06KpWNxh7t4v90LLbnc6GG8XC/0tOj6I5VbWLRQfzK2MOAa6Vl3oP+yfl+?=
 =?us-ascii?Q?TcBSpfMiMeywVxdNoUypCf0KfEPXiAZDjlhA8PysmagbjMirH3tYbvCQY9hh?=
 =?us-ascii?Q?BOr5yF5SPtdauWKw5jZU+BEnWGplJMEVfIY4DT9wOnYYuD1G9J/7IlsyMkZc?=
 =?us-ascii?Q?+7e9sQBOSuWofsWhz3voy1+bNFVqgnS4Cjio9RzS7TRt14+VrDh63M2Lv85u?=
 =?us-ascii?Q?N3ZOgSZtQnDPIbYQGgJFk4DO+0j7orRMk9TVQ70JBUwZOQ9soaMaRa7t4P46?=
 =?us-ascii?Q?MFE69eZ83lXv+o4CGgtgXK3r2PimEcrFZ4lmx4AaARA4Anvc/rLYwRe15XqL?=
 =?us-ascii?Q?NSxVqIKWYMIjQpVgMUBnHbXUL91jt0tOwi+cfpJ1muHHUHLL0PvB7j5QD7Cl?=
 =?us-ascii?Q?XLUaweC8wZEp7NSm7qsytO/GMJtLXtYQn3lqQbkUkrwB1K86EUhJTdLitujl?=
 =?us-ascii?Q?hPfc/G6XvRxGpW2Yf45IzOSBTL5r7ERxtJAHzGudLG+godjdF6RaHGqqiTiI?=
 =?us-ascii?Q?d69OlBH5lhbh2GRs9+kmifIgvnuvj/Z/SEIhcMtVRai25VGIEUAiuD0BOn9G?=
 =?us-ascii?Q?xAtbrN8Gu2fHJwDaX5BZa3Lqj+4ioacZbIXoEEapN7YwpBk+joSATOp8qbm/?=
 =?us-ascii?Q?Z3L/8q0mm2c9bhI3W5VBSTBztPywV/rbxrw8aycVjiuspOjzDlmlVcTM/2ep?=
 =?us-ascii?Q?10tPGJBWaJkyXFTgU9GbwlZhj/9V5nDwtfBB/d2foFtUYpr7u+XsqElL/K/w?=
 =?us-ascii?Q?O5v1ZhzMcShqfUD3oEAsw0nyooFSVbScd1QBWF/Kyt036B0CGcOYQPEq8yYU?=
 =?us-ascii?Q?BvbJ/RdGrNq6ZHxUHiZZzi5vEPa/cFGxA4leJ1WtJl2UztBEmrL3q5RpHAMc?=
 =?us-ascii?Q?rkOXSM1oBN3rGHbhiaVlFTdgk/3S3PChClcKYxW1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ccee03-dc25-4ac8-1218-08daac4005b0
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 10:53:40.3561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3jkWbHFcimGxggvOWqrOXQ0Ax+q8mKcn83H7GzOercqCXzr+ehvvKvHsUoa7werbsEAW2dkqjJbmapHzcJx/Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7675
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mx93 compatible string for eqos driver.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
index 4c155441acbf..29b0d119405f 100644
--- a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/nxp,dwmac-imx.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP i.MX8 DWMAC glue layer
+title: NXP i.MX8/9 DWMAC glue layer
 
 maintainers:
   - Joakim Zhang <qiangqing.zhang@nxp.com>
@@ -17,6 +17,7 @@ select:
         enum:
           - nxp,imx8mp-dwmac-eqos
           - nxp,imx8dxl-dwmac-eqos
+          - nxp,imx93-dwmac-eqos
   required:
     - compatible
 
@@ -30,6 +31,7 @@ properties:
           - enum:
               - nxp,imx8mp-dwmac-eqos
               - nxp,imx8dxl-dwmac-eqos
+              - nxp,imx93-dwmac-eqos
           - const: snps,dwmac-5.10a
 
   clocks:
-- 
2.34.1

