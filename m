Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0542A3A95A0
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhFPJN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:13:56 -0400
Received: from mail-eopbgr150070.outbound.protection.outlook.com ([40.107.15.70]:61929
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231335AbhFPJNz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 05:13:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ybi5WJd/XM+UoQSsZB7ZEOzsP8/eBbTOfz73TJnMihNfXYVqn7HzKvXafEEHC2gA5B8Hkj764gFBh76ffMKV4Pd1Rq6uNwzsB7IkVGIMh1Zo+0rl8mb9zGATRk96QQ+qrKBMZ+mecDPaLHxhlbxtACQJZJwN9aYWbZ5fJKni48WSA0QMe6e82gFFCREs0+y6VhViqzGpu9KDaLGUPiN6wrVv+CuaTK8cAEaEN252IE4f3Hr4bsxZmkmR08f3GNjJEOiy/cFGw5Y5NGo/AiVK2GMnIL1Pqxvr4WTRaY+m5BMucxD3w87L1Ycr3LG6G+tgy+NT33jIkIr/EKmpQWO0SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGw0fXAZ+3X6PoOdj6a8INxZnDpB/LGVm6hFlXZWnkE=;
 b=Pn7EC5KCf6EJ7bLY4F1+W8Rs9f1GrkBdfTcP/UuHdg46Ro4CGO7LPQgd55wIQbvYL3XT15ASieSnA30aHcwzqipB1lsvzyXaMPXAflkk3+mcehGVHhjMrsDzAiHRYzqtJm6CD+M1aEQBecu+Fs3bMDoFXxOAecZisfL5A4x3OdDYgKzSu76OLV8RM4cvC+jodLSsmzjH/OGjATZL8sRBjUe/NgPc/1RA79RKAcRox881fJcJ04TLPAQeK3axzm7N8Rgjx9/heYKGQRJcG9m2rW7103XHrYigeFRdhGLBq0h18yK/ZKPS+XibNgb9HD8J8N93R8Ew+OuRYjE4iPI0WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGw0fXAZ+3X6PoOdj6a8INxZnDpB/LGVm6hFlXZWnkE=;
 b=nww9ixZbtc8mk/M3ZHsYAzXpkB5Eh2JmHcLqoR6Lt2XDOOMqN7j2BE1fMq/b+GCpBsn1B3YMM/dLD2DF8x+bWmjBTkKpLvDY4cCoIlDKxTRwrHgyKt6p69iO9BXr9in2tl3JGamo8AaCuZMOI13IORBv+qxnAifKk2KkFcqsrg8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VI1PR04MB4735.eurprd04.prod.outlook.com (2603:10a6:803:53::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 16 Jun
 2021 09:11:46 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::d48b:48ed:c060:78de]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::d48b:48ed:c060:78de%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 09:11:46 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com
Subject: [PATCH net] net: stmmac: disable clocks in stmmac_remove_config_dt()
Date:   Wed, 16 Jun 2021 17:10:24 +0800
Message-Id: <20210616091024.13412-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2P153CA0024.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::11)
 To VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0024.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.3 via Frontend Transport; Wed, 16 Jun 2021 09:11:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c7a6b08-af5e-4889-5559-08d930a6c3b0
X-MS-TrafficTypeDiagnostic: VI1PR04MB4735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4735E4F3FD9E203450F2A12BE60F9@VI1PR04MB4735.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:81;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Od3veBHdPnjHLtAydp1LaOboHrIdzB1BDwfCgsZ0dmd1buMahEgu1TKZnJJPYCpVwX/unYHopzF2izVwxUeh1aytWm7yAIRDESFchsz2PejBD2vBm0sIkTZR99VSTa5UoWCjUMmjeoc5ATIoX+OHhw37NFug9pTElfy6xIfPAVA59kOB3kZHz9uUk+V/KVpVc5Z097ILW+YbbmSzdt5M9UtW2PH98Wgb30/P7YD+uFpXHTeVJSdEayuRYb1pPMN80tk15DdCN6XvAvMaz3KkbEw1HujIGzIXEj+/DqF6AjzB6yVIEyy3A66hgFoqll/Ocq8ZGTJ9rzWMJ0EsLnRiZWoTEmQxrcOKAiJqGFcpKSmuoVoHLgwUQQoKFUIcEcsM+y4V1JoCFchnjxN69gz8gRM6NWsDWp/D+8P2Mk05ThgKf0yYvnvNzZN5u6cbGiZxA9PopGNtcHpIBGVWXYrmVSzHe8b5rYXIgoFhTlwkF+cycA4L3KZFuf67Sfu2AQZ09zB42N0bWzXgijw5GmRAJ+fCE5H7j1FlLEneojSdHa/6nMVUTa8GW9LQlUo64nyXUSLd/MSGAbBCRDyb+zQxS0FqIe6Foj0yAUh966w5lU7sz4FFdaAAgS9pkS7o3K1MIOSrs96mvfhe7QwCqgGo2e5kU3Wymv1agSBvaoya9PcATDXxo6lqbDklcp8tokGI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(2906002)(36756003)(1076003)(186003)(38100700002)(26005)(83380400001)(16526019)(6666004)(6512007)(8936002)(38350700002)(6506007)(66476007)(956004)(6486002)(86362001)(2616005)(5660300002)(8676002)(4326008)(316002)(7416002)(66946007)(478600001)(66556008)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZxMFY2l9PkgwoDlIfLfzo8Z2D1dBOQOSmRxV/lEI6fgctaCR6ZNXTqsaOeV1?=
 =?us-ascii?Q?Duj0R9EskJ5saOAGuR2qNpjQF4doRytblPz6pppFxVX6qvYAtx39fwcBIlZV?=
 =?us-ascii?Q?qTHbpPPF/WfPxiyJENv44rifzDcV3k0NwYdSat/lcrPxhIwlqmSyxL1okWo0?=
 =?us-ascii?Q?LW0xHqKxepiMwH4RyjhnP1GDjYLYaMc0ksU9S+vqr3IWZciULNvNzpnSUbB0?=
 =?us-ascii?Q?/b4gzALivHJRegRF0bud8WtKh5kRCMMd28fSuhZIo2ivG9Iy7s8tsqGmuios?=
 =?us-ascii?Q?lFh1GAXUkkSajDW5phoEEa29pxyEuda1RFcaiA8KjeZkLLZz5SZ3OBjrCThk?=
 =?us-ascii?Q?DU5yVL41zfq/Zdwy8fp1mElW1wlC95Qnp3tzbFYmw5cFtiVcDSkT+YG7xDkD?=
 =?us-ascii?Q?ufDgIic0WXp+fN0nj6S7DOlTJbbPjKEteIhUv8FOUH9ElTL5yCEGLbleXVYB?=
 =?us-ascii?Q?4lEScEJGOTPkoLJJ9FMMmgJQ84YSaCP7EPzkjpEKiKgDKY+yklT4rx11Z0lv?=
 =?us-ascii?Q?lBy1Rf2eYRrJLDVboy+k7FoIhQH9z/ZHcn/eyxXVHa2BTFz5WsEYfauc4EWL?=
 =?us-ascii?Q?2QO/C3yEw0yWY9KizdHzAk50J/dqOpAyX0SWP7HGqBlqbxZ8g15QMKUxjCPC?=
 =?us-ascii?Q?qD1SWnwzDCgnE3C4v5jE1RMW4KJxfhpBWfQ4hMOlz07hnaEmauVYnoMLC+t0?=
 =?us-ascii?Q?BZ6u9DRcUFiPEmDw+lbiARmS6443Inzsdl2O/ImqP9NX92b9O09gsN8HeOf6?=
 =?us-ascii?Q?JztlpLcYlsRf+eErcHqrrAMiuytEvnRG6UaknDtWl82RSf9sbUgTpMnwrnCc?=
 =?us-ascii?Q?z8ioJO3Dhpewp8TsF3kPLIauxLmIT9/kKdMPDHZJyMuzKwyOcd01mO3J0SON?=
 =?us-ascii?Q?T/zJ94F25Xb1MdtB7C+B54MLq11lKesoff47bFdZ0eSP1uLTmX8VJuLp6IE1?=
 =?us-ascii?Q?5kenb8Y8jDPj1rgTJt0gh9Vz4uHB3Ar4lFuxlPIJjF3gZrO74aWGJUwp2ncY?=
 =?us-ascii?Q?N2pSXKWCabk3l1pMp93IMiiXAuWOkmdfWQ5poiJQE4I+gg/+qSy6zhF6wE5C?=
 =?us-ascii?Q?f8InV9UuyRIaRfKmjesY+7EWfZEarasF2M+MovPvd1SOlYg4LYWi8BLnj6MP?=
 =?us-ascii?Q?6PaUg8kMup+/1zDzEa00+tpc5/4KZM/h1H1LZPrLQzU/Gm5YBGSPYda0qEh+?=
 =?us-ascii?Q?ylpp+SFe7M4iAdfn1aRoMT/4YvM9/kvRyPEenbNUDSB24divgLC2LopcAQNl?=
 =?us-ascii?Q?NmqLeBOBYNzW9CXxaIXmt1p96KFlAQMrJXCSMI+kIRpRuNReLkaGQy/sUZdL?=
 =?us-ascii?Q?H247Z+hZHuMGDRmkbrWfEQLg?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c7a6b08-af5e-4889-5559-08d930a6c3b0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 09:11:45.8938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GNUxUx2Q5705nY+Bt7CR0Jg1+6JKZCSLOIZ1ZhhseLFzgeCx9c9webJgqElWmh9gFUylPShNjIha6rNXqkBb+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4735
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Platform drivers may call stmmac_probe_config_dt() to parse dt, could
call stmmac_remove_config_dt() in error handing after dt parsed, so need
disable clocks in stmmac_remove_config_dt().

Go through all platforms drivers which use stmmac_probe_config_dt(),
none of them disable clocks manually, so it's safe to disable them in
stmmac_remove_config_dt().

Fixes: commit d2ed0a7755fe ("net: ethernet: stmmac: fix of-node and fixed-link-phydev leaks")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 1e17a23d9118..a696ada013eb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -622,6 +622,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 void stmmac_remove_config_dt(struct platform_device *pdev,
 			     struct plat_stmmacenet_data *plat)
 {
+	clk_disable_unprepare(plat->stmmac_clk);
+	clk_disable_unprepare(plat->pclk);
 	of_node_put(plat->phy_node);
 	of_node_put(plat->mdio_node);
 }
-- 
2.17.1

