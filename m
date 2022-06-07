Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85CD53FD4C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242789AbiFGLSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242787AbiFGLRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:17:49 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130049.outbound.protection.outlook.com [40.107.13.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D50270A;
        Tue,  7 Jun 2022 04:17:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXg5fPFA/BhDZL8QnHfmLVo4NhcozeTlZ9d3JXSV99iCrsz6LEtdnoGjVEYxYbzt/4D8xdp4Pw1V0ptggvph913SvbJGWQBdH+bhfwjcOjd6vPI/YJ5KS+qOn+cG4y9pwuA7i0yBZzJJmydFu0MThT9lovLr1DmcZz6G7MwbusuFvoFQhR7tmSo/igKrbYNut9YalqvrCFCyB70xRc5DoOPZuBN6STEzaJ0+dAQuD6UatKWDGhkp+1BseV5TAeXkP7YvlYMTHynI98ta+3QUTq+eG0VK7seRgLgHVKCM2THj9TUJZ8ADj1yDMVoA4oKIx+Yv4awtTXUlZN1RhMO7pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MXWOS9jMxNTR805o7s/+Eg+NL9Hr9tF2DK0wfmG+t2k=;
 b=hm/WLU3D1NeqVQLDqdRXQwHnvTFPoV+hlv/DrmCHzqC8fXXzcc8xBRSvMZruydFwbL17p7fRvhCRmoeTcjYw9WcWhe9npGbJti2RFQUhjJ85MobXlCaPZaprVrJWhYWKZ2+hFjH3svyaxmmu9YzpMVHyJxsinecY6C8ybJyp5P3vs2PQ+aodP3ZDAFIo9grIt/eJfn5M91LFroTnDVA8vf425JY5WWrc0RfYyaBezXS9sdMowoIZYlFqQ+ONPEXQDHkxTD1w0u/MjyE+d8q4mb0/FnlnLgkZI+/uAlLcIRYasG8sdO58UbsQ+GMpa0Qp0lLxGd7jO4W61kx2I5agdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXWOS9jMxNTR805o7s/+Eg+NL9Hr9tF2DK0wfmG+t2k=;
 b=PD136xuSSoB06HDooRIEXleUme81c7LokitP15NBAgs4rII2ZmbEW+hZ8FeoR12HMwrVWm01GTTOzezypNuTXsCIwrQ1DOPUVb6x2BFFQpODpF3pEZI2ZZYJGeaIpHoKRRpmuOAcUkAofqhK7P4QVpgpUdp7b7Vx/Yy7Y42H22U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB4890.eurprd04.prod.outlook.com (2603:10a6:10:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:17:12 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:17:12 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        <netdev@vger.kernel.org>, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v9 07/12] dt-bindings: net: fec: Add i.MX8DXL compatible string
Date:   Tue,  7 Jun 2022 14:16:20 +0300
Message-Id: <20220607111625.1845393-8-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220607111625.1845393-1-abel.vesa@nxp.com>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::41) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f20bd681-b48a-4fa5-4062-08da48774513
X-MS-TrafficTypeDiagnostic: DB7PR04MB4890:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4890004E827E68A253CD5D1DF6A59@DB7PR04MB4890.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wP5oiWbEmnU7V1F4VnpwjVtDGijUnALgPQhN7utwDL7ZPnYE2PRsTEJqz8dum7g2WiQbhF2V7IG/iOpCfMDjJmqlsVziypi1UNaux3qIJhMWYiDxiOCLv+p1eYL0qwZ4qkuOQGfRdX2WckwvlZqTP2sog8gUK0NDEY1+hNz4q/e5hZzHjY5W6vQyV2an2cFjOQmEmvFuHbwFXK4SYK8whdsTfegZ9nL8Cp+XwGwgLo3eAwWUJsooAaF+3az2bwdin0+hAfRlwnNC98WCyB5aZ7VVPmHdyB6hyTAmiVFmu2NVGJVOfcNAEXvuLUewfrRwnBiP9hhKJxTNv9EMlKJ48seA0Mccq1rB1Y+Jm9+AzfaMnnEvM2MBXdhhgZqAjpdQjpluzeWMiLpAZ1FA9od6RhfeKN256tk5aLihbA42sN8KSyoxIutQ1lj/DaQqUT/yY85CBut26xvt1Y+7SeXUMEOs84lDbg16b0LePsgw/gIekjEpEqgRRy1Pqb8Lm3hmaPzMRC5D8YYjcnS0iDqCRN43qozy4QZBkkxIIDCFgl7ywxRvv3mifGIcNY3AUVxr3HongVIHMwUYzLZx3qPUVW9zlAdpUUUOFNQCL4ujCoxuUOOjxzKqzTzENZNCun9+SFftnLzO2FTydPAqwzoapqEHtqKvRhAACjqLOc80muqR+ciOoka9Sv2T8ymhZA0uem1GhvVMxlxj2V3ZAHbEHE8oP3rP1fyw2W9dwOFFO3g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(4744005)(44832011)(8936002)(5660300002)(921005)(508600001)(6512007)(186003)(1076003)(7416002)(2906002)(6666004)(86362001)(26005)(2616005)(52116002)(6506007)(66476007)(4326008)(66556008)(66946007)(8676002)(38100700002)(6636002)(54906003)(110136005)(316002)(36756003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WM5jNA+yZx5knqce1JygWCQf+Y+UxOjTDGJ146LGWdLSLwRHmRgE/M6InQyZ?=
 =?us-ascii?Q?3DtQR1ifOFKmODSYGZ5BBl6Hpcpeb6Ah0ub5A5hwz5uiBLASjOiIDyJjuZW8?=
 =?us-ascii?Q?eO9WET6pVw3cRE2bLz/VWMxXsNcFjBvTcENOkH6W4oiVHUFMdNooKXGKSumJ?=
 =?us-ascii?Q?44nIiflLIAy0HqDvqBh70Lnno1plP0jRvVvRu6eSmSg7T2N56PRKqzMl55mB?=
 =?us-ascii?Q?ozf3voZu4V/1dTo0cg+wp4ARflZWVk5mfPLgMCDWNJtAUAuRgIZVZsaBrRPD?=
 =?us-ascii?Q?9FmZ7Scyrta11PwTqoL+08E2QGK+xGRZDnw4n/zOKpVR3xyO3Bjm7yEYJ9t2?=
 =?us-ascii?Q?gZdM0M1DGKcmcIPu2x8ECH3Xnh2HDpjAiYpXtDOZ31meGwsLjYYBmdoWoGuO?=
 =?us-ascii?Q?DbADiecSgb2tOF8jKTDXUe4Gn5NUxSea33De6yiJ+sHzhv7sNOhPLB7OJERp?=
 =?us-ascii?Q?QKu7rG09TWExK5B57pk3TGJH7tTf0kD3dC+WkryJRGQgMChYYEq/3xVRnyM2?=
 =?us-ascii?Q?cyG8Aqa1BikXTFN9ffc0dNCkBP7r2RRL5qptH7lqyNb1ZR/s9SORSOg3E3Sh?=
 =?us-ascii?Q?PjEN7mYiLYhJRttRibfHf0QF/aHad4LTJeUwAMlFVKczt6iL++esPtufPMhs?=
 =?us-ascii?Q?2HUWo6wAGNiLYHnLabBptzycSkz1hwVGB0wShKpGz8cEeFYI39Cvc2WsBwUg?=
 =?us-ascii?Q?vhXuzwUDkKc9fYTOq/0UcJ7B5SOLTqVlv+ZlDjphJfW/3xk/kmQVGiVWieQZ?=
 =?us-ascii?Q?ipJuBl6fOuQPLQOBHeSf0I6RSQ38tsrtm5IG7HOvuTZaAPYrqdtUeJb2H26S?=
 =?us-ascii?Q?p/8BrfoN3yHHlnK3OphY3o47H0nJjFDujPwFVbt8AveEJIvTLlbSkT+tKG7j?=
 =?us-ascii?Q?cJE4rOUFY+Y73P+lfLI+Gbciqrmo7TJnueQ9/UMMX+gI1l8FVE26il9HBBJU?=
 =?us-ascii?Q?dzrTbQq5Ts+dtnXn+EVItfCSC7eSbYxXeNvb28IuqGgP2jDVOO6JS1KHhTT2?=
 =?us-ascii?Q?d9ga2hZk+yCIqJW1wbLHnNS8/IzVYHDFc8zz5DXv0UukYwYA7oEZ7dQ52S68?=
 =?us-ascii?Q?w3HBinMh6W/l33YRYl5aV3WSv9k6IYAm6LmgTqhU8N+Pk2SF0Uifp4oqMuLM?=
 =?us-ascii?Q?jgCRAM/QT6vMd5vQycp79aizDexVjMtfgsdcmK6qNRlSIwpgt5OOrei7G49P?=
 =?us-ascii?Q?EquCNy1vhx2CWX2jPU+TPgDm7RaSP5NT0rXgdJKqt1ZXBbnNJjpvuXNFLd3J?=
 =?us-ascii?Q?xrBAF3YOOxpQOtvInnoNrA2B+O5D0SLqF+d3DYJimJzg3Xr8zzDoVl0+YRAG?=
 =?us-ascii?Q?Ww7ZcKJFFn3Tra1Jiw+Yq4ck0UezI4qyFraTNnj3ujCMAdzzBB5ZvHM4+95R?=
 =?us-ascii?Q?rU+2HYaw09turEf6kVfuADLLuo5XmSS6w7tgK81JCLYI5qn79T18diiVp4zG?=
 =?us-ascii?Q?thLElwzOuIbxwKYQPzQnHv1iUMMgCNCNthOtWVTC9P/nKNMGhXgGUVn3GyDe?=
 =?us-ascii?Q?vHWraIp3jkCoUoQT0U3xgTe/gvfRNY7gw1dQ4LRzclBj3qQ6PIgV3xJ3uNNZ?=
 =?us-ascii?Q?bwD2Wu5zPCWrHPc34qwHJ9uS9eghTF0KhlB4eJUSnkGQZav+y3CdJuziKo8w?=
 =?us-ascii?Q?RXF65cG6ZDZN0rvEET8QyIwkCVSwPh6OfEeA9bcvHJT1jCEz+VGIevum5o33?=
 =?us-ascii?Q?47Yx9sxpVihJhDzUbKHu5pjDmr7YlfsfIVtgLNKAiOZW1jpeOkZk9L7vSam1?=
 =?us-ascii?Q?nH6kESis7g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f20bd681-b48a-4fa5-4062-08da48774513
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:17:12.5731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvrmJmvP4Kz35/Ym4hOKN/nys97B3cb10tgRc1fvKZleiDtTgf1D6ibQ8iZVDFWbszKdtgL3TTzujOSP0CIaiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4890
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the i.MX8DXL compatible string for FEC. It also uses
"fsl,imx8qm-fec".

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..92654823f3dd 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -58,6 +58,10 @@ properties:
               - fsl,imx8qxp-fec
           - const: fsl,imx8qm-fec
           - const: fsl,imx6sx-fec
+      - items:
+          - enum:
+              - fsl,imx8dxl-fec
+          - const: fsl,imx8qm-fec
 
   reg:
     maxItems: 1
-- 
2.34.3

