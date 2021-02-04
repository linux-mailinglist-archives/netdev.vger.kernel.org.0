Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC1430F1F8
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbhBDLXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbhBDLXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:23:06 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3B5C061573
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 03:22:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dm5vggijMNEeEAAAcJT+5o4RugWAM4MEKght8NpkCHU5uqhuuv4KhkBPevxJa+874rLUDolpmtTBbzZgEOxXWLNAO+j1s07MFVjEXyUkozt6+CS0zv2gxTv2vrjN+2kJ8S+ZOGjOgJbn23PAVrFq9NvKYOq8gBQq3FgQ6nr2yLhrJXDumREmmgJxSeD7uKNFLFVWN2LyVO2edW+rTcxS6uX1TElGP1hvZv/YMYT+CZXPH0hG5rkSnbnkkyZz2QDFOnHvgijgFWiw4j0cEPtnLNRVSWKNfO0UbsjIkgO9Zs5b296mx62G29uzffVRNPEzpB8g3VMQzX+brA7qEuCl7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtJGaCcW5v0HrQsesDguxrkhWUbHUpnuuBm0g7E4itQ=;
 b=j0CyScE/GLOyIw5f7ydosj2BOqLz/twnuRWbTWm3a/kG32Fe/cki73sPIzM3CyNMDB7G811oGE+0HF3GgokwczybvXg3Nm7iLoEC52gFySK5cufD6GpzbgJ7qm50sRG64j03p8sOI8jNMFmocuuwJpn/z7upWRTr6pRMg1o3QfTiMTl7qTNT+rLhpnOc2BCfllCKQJG+fCgZFF/wi3SyUSySZ6PaHxIpYhg7v2E+EXnZFusdCcT3B6tqBE/0uSUUIbbAkfIPgFH1LAE0Is2lkwtTGj1trrxUP5dOSKM/utz+mK9I5qdQ4tNP2VfRGbgsIHisXJhDhy++ZoNKyrKaWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtJGaCcW5v0HrQsesDguxrkhWUbHUpnuuBm0g7E4itQ=;
 b=ACF6+q+QjUMIhvJcmNif+M9mnarCV0ZsM3RcA5rUk8lue9bPecG+0w6mRK/WnN/YAWwyfyx+pWl9XagQ1np7WLX9lZ5hvj/jNJAcEuKJlo0hsUL6SzWT1FIiqnVIe5D/HwG7gW9ALXPChYTLBSPxDNsL+W52+7MQoUP5PCKTqQ8=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VE1PR04MB6366.eurprd04.prod.outlook.com (2603:10a6:803:12a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Thu, 4 Feb
 2021 11:21:44 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14%9]) with mapi id 15.20.3825.019; Thu, 4 Feb 2021
 11:21:44 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V4 net 1/5] net: stmmac: stop each tx channel independently
Date:   Thu,  4 Feb 2021 19:21:40 +0800
Message-Id: <20210204112144.24163-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0128.apcprd03.prod.outlook.com
 (2603:1096:4:91::32) To VI1PR04MB6800.eurprd04.prod.outlook.com
 (2603:10a6:803:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0128.apcprd03.prod.outlook.com (2603:1096:4:91::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Thu, 4 Feb 2021 11:21:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 99e3215a-2dd1-43d8-b39b-08d8c8ff0c53
X-MS-TrafficTypeDiagnostic: VE1PR04MB6366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB63667EE4596567F107E97B8FE6B39@VE1PR04MB6366.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uT8FwibO/wY7FfEKJN3h8t9j7DaGycrjl8rLeTP+mHxV984lArgyN+Oa10ZyhcZ8P5C+BMiv3Jkn5A3gIGADMgDwUtwWx0yiKTnj9xJMIhkRxg1nse+ccdCkMnqrwc+XrbYKJBWFPM4sJdjoxXTuwcnu1T4Rpp0N1H4njXL4u+NZ3+InPzYePTxaRnfoHKv8qbwwKzyqqm7kfW3lUbZKScENTZtkFkFXpfYR0tdeXm8+UHMAhiPkC/fPhgrxWpbiP158PJTFlZwyggrZLlvcorhfgORI649K9Kq0oyY/0LAZKBVlOYd7IaZRgC6ad3krjwQ6THVSrWmNbAeNU/wwOTrL9M7o4yESIyiXQk2QJv8pvn+Rbvh1aQDATcx0eqbduOjTAKMkjo17yk4Mapm1Seg5yLjhpBSseCrOw/JToYLWQkiISUDh/9jY/NM9cE4L/DpwsPcVvzdg8njvXJuODgPhK7GZ8jN25PsykIPB6JQV5zn4xWpeoacZtxuDOgtw6ohSMXAbmG0A/hZfIc5+C5KTvjEbbTI5JlwOGloB6BwH6xJkmi+/Ab9U/z6blGO+aRKUrJ6E1O2iimL5fNejZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(316002)(83380400001)(66476007)(478600001)(4326008)(66556008)(66946007)(4744005)(2906002)(26005)(36756003)(956004)(5660300002)(8676002)(1076003)(6486002)(86362001)(8936002)(69590400011)(186003)(16526019)(52116002)(2616005)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4oNeGM8vJMh9triDw8LxhUJqH6yRg9v4W99s9DUqI8tm49iKoEraj0jle/Y7?=
 =?us-ascii?Q?B9nFQMslVO6aWwKV7vAEeLgrGMrrnfLfi/Z2USjU+6geS+i39TJayyrf6aO/?=
 =?us-ascii?Q?E6E4dIHCLtJtxKXSZh+0D3fimGgd2L/xxR3KmsH4gvsPfCzbcMox6BzojJH0?=
 =?us-ascii?Q?Cr0DbLh3PLt+ywJ1Xxxsb9PLAt0KEjYIzBBf2TBpd8BVNh3kFNZzPP54jToV?=
 =?us-ascii?Q?zFovTHZPhnL6umvt51Mz6eCtZbNPsvpSjd7F10esSaW69bHT5q58QHp/mJDl?=
 =?us-ascii?Q?vQSomfw418AObQFc8YYZr77v7+nFHmyDePPNd8oU/q4ZDiknQ63jg2Ro52PI?=
 =?us-ascii?Q?wX0qdiju6095CJ7PYVTj/ZSAs7ykRRhZ+etjv3Y7grn9KWtYiqEk6S851GT9?=
 =?us-ascii?Q?Js1QNMoIIfjDZXBsowEugahTNguwLkg2Wkvp8yMRX8PQH70IcY5fONtbZW+m?=
 =?us-ascii?Q?R6eBY9atB59r1TiT5u5QmOjAbRGiopHRK0eGcmJZie4l1z2VRjZVQqXHbBFs?=
 =?us-ascii?Q?uPNhqW1nEzdZOWPY0yoKcClvTFoF0puPKZUhKZDJoP81UD0lG5VVpIgvOFng?=
 =?us-ascii?Q?zR95Elr584Cl/hvtg4iYbAza2aK4lxDJq9FzLMn9pC4zvLligodxx4s31UcC?=
 =?us-ascii?Q?DE2nDSMkspT3jXI/ZfUQUNXBlU7/aCcm3ngO4czTuHNXC6C4SWvgXoMsa3js?=
 =?us-ascii?Q?K/o3C6tKK0LtHRxeA+xKfnJPogBmP6gHFHQR5nx3ZgosWn+T9ZOXPvwZ7iTF?=
 =?us-ascii?Q?S9ZGFkeHG16bsWhcLrxY6/UWiX2UIeHGbYnMwb3D/JeAXZO76uYNQdkhhyoq?=
 =?us-ascii?Q?l85amfsMif02lLHNOKd3atRsyOI3h5vEn1G4RmPz2tkr7u7gxlBqFbrgcaRQ?=
 =?us-ascii?Q?7qRCYYxeDalwq3HixYuEHGeUpVgS2kvWVosSZNUg2eppTrQKUpkkKXokajHW?=
 =?us-ascii?Q?EjruVkkxYx1Nyibmk8Av7aCfkGyeintxABiC54S7CPwaygtvOCIZbVsfR5Ok?=
 =?us-ascii?Q?orULBcnS/a8o2alPN88CTWggCFDnmbXjw3kzm1FsXgqkwkn42yMzl6t9nifb?=
 =?us-ascii?Q?YCHJHaE/?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e3215a-2dd1-43d8-b39b-08d8c8ff0c53
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:21:42.5089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ixa2nxsjaBgbNkYdaf0hu0AIU1rboBOirbVsgp0DqoVNho3V8wc9+3Uu2qownWP3Nbno/PNGL/WxLieEd2gHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6366
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

