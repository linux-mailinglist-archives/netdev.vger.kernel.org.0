Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59164324C68
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 10:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhBYJGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 04:06:08 -0500
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:38956
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234513AbhBYJCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 04:02:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzNJYcwk28hycykV53kewljbrk18j3Zzr0l4GKySpeT9RvTwhAjGR4pwFjgENSWCsYssh8Yr67l+S/WcUA35svomH5OtPpU+M8PpgzAUuceCdIrUQBAH30AkA5CSKlPHDqeMPP3ZjkhRy+Fv1KJ8KFydIeTwqhO9vERVxfcJllRRBu+RrhAo8B1zLs6zqKjvqbYn6p6iKoKCQuDGhpKBXts2/BEhTCwDouArYND/gBEFB0KfisIveiwV4RCdEIyOdnvPGxT0tcwRGrgWlRsyc4uflqGBgUt3HCSvoKmTJLGNAX2YGRVIzMn+VekEmAPUv1xHusQDqPxer+uGMf9ing==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtJGaCcW5v0HrQsesDguxrkhWUbHUpnuuBm0g7E4itQ=;
 b=BdiuFC+8JiB/ZH4iDhMnyyjDKe6W1NLe0pk4jprhZJSM6XXoMgMbZle4rB41BSYK6XkS0h0yochnwlZsWZ5EnZDoPGBiCKe7cGa7oODFExRRJzq9jDeY/T6n1tMK1377I05/FT0nAr6rkODnVVFCPM0jmUF268PHIG++nXZbkaLsAyybHKl29u9v2hr+VaeDFBRuVg3F6TBF9hFh7/1Dzld89I4McCGh0uULa5kT5YaCrMdJrHpk7kpue0UBhENS2/ke1PnR5s3k00mKwG19C3QAmC+9j3JxB0sJ0Vilu8RP/XsgMVoQRh7EJ/1yPzYVzEIdFy7rTHBB9sDgGfbrCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtJGaCcW5v0HrQsesDguxrkhWUbHUpnuuBm0g7E4itQ=;
 b=g8Qgcq6wEtfzLgZ14CCFRfDWjSP4iNJhcwEudD5WtiffBZk3jStTE9XFJkJkdLIYxhkbusCUYPYOR8zOQHIbmZJbKTAOuEeGNqmtBEwOtz0FmmRSYzWuRBo+qjlHVPpYnLuKDoFqo0DTFCTC97cJA9bxqePVt9ggbBtrds++jBU=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7430.eurprd04.prod.outlook.com (2603:10a6:10:1aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Thu, 25 Feb
 2021 09:01:32 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 09:01:32 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V5 net 1/5] net: stmmac: stop each tx channel independently
Date:   Thu, 25 Feb 2021 17:01:10 +0800
Message-Id: <20210225090114.17562-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225090114.17562-1-qiangqing.zhang@nxp.com>
References: <20210225090114.17562-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR0101CA0036.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0036.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 09:01:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fc0feba1-13a6-45f3-11b2-08d8d96bf1dc
X-MS-TrafficTypeDiagnostic: DBAPR04MB7430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7430F5552A3F38DD8A300495E69E9@DBAPR04MB7430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qBOG0467/Sb+53smRF18c+W/rR9dDjBOXlu9AIagZMGD6zZhrF25VJ5mFWNi39tYITfpQ7eAdwjQEoZoFZ8Fa4Cpzwc47eYZRtKszciPjvYPzTP/S87w7mTqemCS9tpST0og4FikZVbdBtA9BQ3WlsWQXa5W+u0kktv9D4fMvsrCxwGsW4Y0t2IhzucIeS48DSaBZbZuJ5ORCS2o3e3IW0rzc1ylYQMRP8WDj3raWdjngglfjtIiQ0x/402hvr9Bh3ZAF8Sf3eTJWAkeNSNCTH3xWlFJymXOlEwliEIT0A8NTbs+1cNbCR4iwBf+yH8zycEBuEcdKHH8xIhPq52zAnxu4eMU7iNhlaitaojofoXlYxYB308jHcuIxZxjCva169ex+DujnIuYpHGVK9oMRiCEH+1H3H++nx3GqtnpW1n7fx6I38iTZsWtRZRCgudV29zQrUU6NWG7e5LqBT4BYXtLjHprAC7bYQeYD+se0yXfFJleVC1Sd8PcPetYw3lYMe+ZgKsYQBk4pj5MYk8aKZdPSCiEXU9QQ/VxrHtIp+qK0LX7oZIQnFUCRDcsAP5w8mEn6yXK58iFfFgvY8xAAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(69590400012)(2906002)(86362001)(186003)(4744005)(8676002)(66556008)(66476007)(83380400001)(8936002)(36756003)(66946007)(478600001)(2616005)(6666004)(6486002)(1076003)(6512007)(316002)(16526019)(6506007)(52116002)(4326008)(5660300002)(956004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?R7a3Cidol2rVXfOFlttWZFXrILUmY/f7H6JlBYbbRxLSRnuUONYI43YV/NLR?=
 =?us-ascii?Q?MjjdWR1YNTuH/ys8atui7Qc0FQflDQTB89kwVHEREBcVbzU2/h/xOOrfth8J?=
 =?us-ascii?Q?7FdgakrkCRcMNjWF+kggt5+PrmTI/kUchcEtphr1FUK4t1X8reM3fPNu9Mi0?=
 =?us-ascii?Q?xMquUggw7TvuhrBJTYyon/XR0WFwxBy2CNRYMGth+FVdEIWhAxECRWFj8Pf1?=
 =?us-ascii?Q?DihJtPtW9Nt0fliNqEePDPN4Uqw0A+s/U3fiXe3Qq1Y+BE+p/NurBTe9vDyy?=
 =?us-ascii?Q?LWkCk/GO3cnSoTpxPbeEpN7t1mxBFhvQ67PK876+8aG/Cf2iU7s4SNzxof1O?=
 =?us-ascii?Q?4MVbJTWdkWJTOoXgZ6ruFzRwTxAzN8hjOJM4IsgL8vJTczZncKjidcLeyFUj?=
 =?us-ascii?Q?ljwgrnicJ86XzEI/k+VtGGuLAqUTKmqPVAxKSpDRnrdSvMYjg9rQ8UhfFPHv?=
 =?us-ascii?Q?TK2JAcfJAo07a12MPjKfdZpZFLiZB8XpOT2UKxPmXDI1wrEkSTr49PKfI+DS?=
 =?us-ascii?Q?SL+6wvtPVvxxqjyGI9KfHqUjYn5jvPS70XgvO+F5gptL06m6i5Hi1HMOT8JV?=
 =?us-ascii?Q?TemajjzJ1KOHO7gPEiaMJsbpsZvsTDzgAX8ZtSe9gY+bdZLxr5XiXpQSZt7e?=
 =?us-ascii?Q?3yhH3VonfPkKc8bWoAHw1jJe2nD6GMuIkzrB7IV9VB8OQVLlOOMAyHgNjxxb?=
 =?us-ascii?Q?aWme0EMiA/6tpfHpknO45f+b0pl6lrzazvgFqP/jMUIMINWudfVfN7THislz?=
 =?us-ascii?Q?3+cpLvEPTb1bKH9j/PRnGQA4Hp9ueg8nqRgRXzLMLb8zVcJSPgxUEqjyim88?=
 =?us-ascii?Q?MJ7MhHIynAVEqzIv/oonYHfVL3cB7Qhug1uhhFlJKqDk4Ov7ypEaUBCdutD9?=
 =?us-ascii?Q?XjrNW0bGrk3gzZ+oM1YDZchDra9h1m9bJvWaeNDmwTE68Xx5lohc9kD1INw+?=
 =?us-ascii?Q?DYtl/4CWn5veibxezWjgCd+LN3/fVsgjT6vQUhA7GeubxGd0jKa9Qpr/HM/y?=
 =?us-ascii?Q?rqOExTtpopRVsodN9QA+9x7+Q8++WanjMGlkuzFYk+rwM+H0d1AJwjAhBPGe?=
 =?us-ascii?Q?/ss+Si6yStRxZ8JJoBH2eFew7IImBHIePvgS8/wPMhapatYSLcVSFMUtgEA7?=
 =?us-ascii?Q?4uJfEySuXoRlHqKv0ZnJke9eBH+gO9OH0A6f1IZ+/skot+DKYUGRrXYE1tRq?=
 =?us-ascii?Q?GLbIHTpxAmShRmXwu9UEVLQl+orTffzAfL7hzd5H0fhyx73lraPViGrtkD/f?=
 =?us-ascii?Q?84R/zxYgaRKGuBw+H0xv6F9GM9VFLZJbkB1pL4O9S2qb35RJ8GEdKXQ+vpQx?=
 =?us-ascii?Q?01SpgIAAbI11ywGp56sh0fjx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0feba1-13a6-45f3-11b2-08d8d96bf1dc
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 09:01:31.9078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nk9P9Anb6wTxSyFcipD6sFp6+pD7v/FUSMqRq6GPxvWoBobyEgTNPIS3aRLlwodoRBA6z5ORdDfNDm/hrDxXXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If clear GMAC_CONFIG_TE bit, it would stop all tx channels, but users
may only want to stop specific tx channel.

Fixes: 48863ce5940f ("stmmac: add DMA support for GMAC 4.xx")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 0b4ee2dbb691..71e50751ef2d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -53,10 +53,6 @@ void dwmac4_dma_stop_tx(void __iomem *ioaddr, u32 chan)
 
 	value &= ~DMA_CONTROL_ST;
 	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
-
-	value = readl(ioaddr + GMAC_CONFIG);
-	value &= ~GMAC_CONFIG_TE;
-	writel(value, ioaddr + GMAC_CONFIG);
 }
 
 void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan)
-- 
2.17.1

