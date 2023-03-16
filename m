Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500E86BDA75
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjCPUz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCPUzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:55:25 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2071.outbound.protection.outlook.com [40.107.247.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0961888B6
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 13:55:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQb14yN4dTkjDlgAEW3hpG+lMzjcCHph1CuCgkp8DysxG6IgTc9ktm+aTXQhy5BuAZu0GOphW7kOTNShB2rRUS1WajO2DCvjTPJVaK7jFDgB1eVIc2tn0+2ADqgh4KSnAVsETL2JWWjBTB7LDMMRdjjS8+X412CpFAQOIA7ztzQjlj50k7hOPyt16auSHxftIdGTCo4pvBu8b/KiEgBoWQMfXsw4D+KtTd+M+nACfQOeeqODjIRKkoca4pVoFo19oN/XW9HlE++CI8iqLjR3o2IEHYhydaNfEpKWCLpMmPGj16SvBRoe2zWhZLtWTvEb5qkIj3ZW4ik7RXde+GbUSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXr44p+fst/2hgwuxGVR5dc2IvU2Hpcz5cQ4zHm+/OE=;
 b=TEYGFNgGQh7WIFr+y6pakOkbZxAMWaXqOmk7LCih31fhePnYpPiN9BTW9s7C2bqEyCZVPh68aE20TCoa7G3cECSfftvR6/GweEyDn0U8thHVLuWZezmCsv9mEMU8FvJxC1kThZzBvO4JG5swjvw+uHCCXMVLPC+IProoVIcKuhWyYbeJg6v8E6n8WRQYcziJXzZSd8adtd/nrYx3popzFYv1u5m+8sdqFvbOn1prMupT0GtK7r6XETeomTGLqQN66wb147U+cm/jpQ9qV3Gp1IwfpnKQAWxTg0ZmFvuwJVcWTbWsW3fsextiBiTR3wj/JURxHqSMwO1LJAI/6toG1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXr44p+fst/2hgwuxGVR5dc2IvU2Hpcz5cQ4zHm+/OE=;
 b=eMqYbmJV6aCn9pXLgoM/i2xR17JQ3R8+16x2WCNNhiQwrPrDOFPn8bqlQQSiqP6NzW8IjAipouHA/eMsfdJlnNsh6XgZRgZoed7dibGtXWJQAOEhN1J3D08OYEn+Z7a/Q81t2btDnC0+/o2BNTF1wn0XSPLNr6t+yjB4iX445Ww=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAWPR04MB9960.eurprd04.prod.outlook.com (2603:10a6:102:38b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 20:55:20 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::31d:b51c:db92:cb15]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::31d:b51c:db92:cb15%9]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 20:55:18 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 1/1] net: stmmac: start PHY early in __stmmac_open
Date:   Thu, 16 Mar 2023 15:54:49 -0500
Message-Id: <20230316205449.1659395-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0288.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::23) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PAWPR04MB9960:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a983866-4461-48e0-e06a-08db2660bfdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ikPgYo+NfTRz1e7F5Wk5W9+aazDpZJek7FaFEHWoaOtQrslBzKwHY2RDx842x2G9jmqcJnn2ImBhyCDDWK8ZXgp1++u4/eMP85BArlAGjc93Wh5FsxseXxyY4+4PGKfFI4h9kr6atUeeGZg/Wc2oYMOZ9s9+UDNwShXx3W4hiiuuJxAEWL3f3H5gIzzl4KDZ/5xUjd/bVbnKzsm+Z1/MbUzxpssXaYd6g026/jyRG9VAgnKZKHVzEEIbkK3SBCfpaeQ4wzrpfIviC9GNTk/pG0aExa44yvfbRx9dM/DBCqNbCWgylgSGgPDUaxGz5+KOsAcw9ErobDgdmp1POz2jMSE30zAAUn5LBJ3xQUcki1uXyuVKN99aKh5vDRRJp5iHW+M4cYghM6Poi8B2B8F0H2Qv98bkkr5FZuBs7UGi0CFg+D6JSkPCasRSe/pn5FoG0PuvdIWtwBLKZiKv6y07GV5/W6KcTyYipvrc3iuVtEW6gmssbeEEzZy2CdTu0DXl7quRW7H4kYCSSbRAVpnDjyYafcRJe0P8RQ9BAt+VOUbb2VLXwGkSKxWyulpbitd/Jcc9uyizRcFW5qdWnpT0oIhcFwyc4it20+dGPfuTYHAQv+ncm52GOx9UqzcZYSbieAF1i4Zg1mosn2GIwICsjS0ZmJFK2nomcJCf0UQgv9v9IJ1Tsmunj8NxNGrln/BJOSXqccUfN70Xqu2FZVZTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199018)(186003)(83380400001)(2616005)(36756003)(86362001)(38100700002)(2906002)(4326008)(38350700002)(66476007)(41300700001)(66946007)(66556008)(8676002)(8936002)(44832011)(7416002)(5660300002)(6506007)(1076003)(110136005)(26005)(478600001)(54906003)(52116002)(316002)(6666004)(6512007)(6486002)(55236004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?41qaYnkTpF18v7XWluB8XFRYkhsDvZCLMOepZ2guW5nwmytm2GAN9b+xIzZ8?=
 =?us-ascii?Q?+MGYaH/E9dUKSXIY0RmEOULChKz7YvJZA7pKKFQDWxidOeKVJSqHr51uMCt+?=
 =?us-ascii?Q?UJnNM8rkLIXyt6YOjU+rHIVRW+06a1Z9LtQ8GIugvolwmo+e8QmdETl4N0pW?=
 =?us-ascii?Q?ytAh6D/NrtMH78J1eeaQkrH0JMzqJ471jXlC8QyAUgF/1idXVTIMakjhq0VG?=
 =?us-ascii?Q?kGQq4iYLIhZLq0luiO4Hw45mBfZATjOMacNSLRLo/ylbbd9LKMuYW2PNwNhF?=
 =?us-ascii?Q?IM6kHaCVnAMInP8tZH4U5Gv3r3PvRh/jHPpNtykT2WmOgMMwq/o0B+R2UEJ9?=
 =?us-ascii?Q?vwOKros+8c9K+i0ES0SIOEtNfUqBpou2t78NiGnV3YebgFxfXc4p/kvpBlgW?=
 =?us-ascii?Q?Xp7k57mXAjFibTm38yqjHKQQt9WRim3gKLYGzkaGilzToR02K1v8D0gs1Nie?=
 =?us-ascii?Q?sgogB+g9EIu0QNbDlL9xhY2psDLCddM5xomDONr47RG2iBfU4s35xetF5dxo?=
 =?us-ascii?Q?J22Jm5a//Q39RSbHoYBEEMRb2si2RhzXFFDdKcRxqpHZq8FLWXwIEssY4TVL?=
 =?us-ascii?Q?9Zzl462NJX5gBb6dEwPvW22z74vWvzkPbtmdonY59Gj5DLHqy9r7mB5K6u0H?=
 =?us-ascii?Q?pzuIin7l6Nm6bN1C2ExsNiAodASVvf3aQdOeDW6gAsTd8ljKvf8XC/ww/LBN?=
 =?us-ascii?Q?luRrWd9DH+roJckUmW84BB5xszGtMZL5Hj6zMeE65N3jbCRaV+ZsB1SCzKL3?=
 =?us-ascii?Q?KRqVQaC+6dVkEJEQMl2/8M8Lqpuc1RuurHzEKWPOgCbLCzvChzJQI/upzdJQ?=
 =?us-ascii?Q?kvUHbdtdbJ598yB4XrorWwUGWaake3syAzlEGwoMSXPel0eVIfEk6brloxo2?=
 =?us-ascii?Q?/MJTkn6uqGxtW8+8EcYWOSrrhQV35SYayHkM+4xGSoZqFK9a38u104+qjerG?=
 =?us-ascii?Q?7M6KP2Q3IJX8gRhvGLVcoSXw36DhQpieNjeI8Y0wE+3ztlvHuEEVMSLoBSBg?=
 =?us-ascii?Q?GyME0ByLhYyqwTDWPsjvHqlCJN7QFmfqLAqBInvcAd0kz0OSuU/apakrKfrV?=
 =?us-ascii?Q?OCJCGglS9lppeZcPyrtu11Laxn/nnlsyx1mYkgPNVvz7Xy/sZgX3ZV5DKRYb?=
 =?us-ascii?Q?kwVOm9nJKJuI0SgKl1hmJbSxXHy/SS+LvQQ7rg4bIYq6W/2ojbxc72XCcynU?=
 =?us-ascii?Q?5ifbLLFoqKlSelNId2SMh6peR4EDSrdvWOm3oJP0tw9cq4OJtzqG3JjT9lYS?=
 =?us-ascii?Q?k6QL3TI7EQ0AQ6uSEtLPmVoMc3sGnqgjBWnyb1wE9QX6fDQnTmmaaxD+T4ts?=
 =?us-ascii?Q?6BG8rWImKW8iH6kBaGcGCV49wWvsqWyU/gDvjc9Flr6QDyxQ2Pb+X/+du2Ti?=
 =?us-ascii?Q?5/saa0ed5zWga+B+H0c6T0XgCP23L92zbh1Hvft2/CrAKZ+Qq3vgSGYVS9yO?=
 =?us-ascii?Q?LP/D+QX9nVuUunukhL2ixvLHlk+qilsDNArHQFNgP8v4T9omzBr6yq2lBMoD?=
 =?us-ascii?Q?QqawDRjAKkOkiF2hBJ0h/QZPy2YwaHF++Ayolf2i5Pbdt3P/jr579JKwwCS1?=
 =?us-ascii?Q?0ywWbGmHaK6CQqvYa1slvXeUeN4Q6HzHmVR9YbmL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a983866-4461-48e0-e06a-08db2660bfdb
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 20:55:18.5142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w8oxHlufVYgpJlm0mxaJfLSsju73xibKTd/8WvxkMMdFzK20zWihU/XUtyNLEpqB8PVrkK2FL/+VVT0HI/ez/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9960
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By initializing the PHY and establishing the link before setting the
MAC relating configurations, this change ensures that the PHY is
operational before the MAC logic starts relying on it. This can
prevent synchronization errors and improve system stability.

This change especially applies to the RMII mode, where the PHY may drive
the REF_CLK signal, which requires the PHY to be started and operational
before the MAC logic initializes.

This change should not impact other modes of operation.

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8f543c3ab5c5..4feeca4d0503 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3808,6 +3808,10 @@ static int __stmmac_open(struct net_device *dev,
 		}
 	}
 
+	phylink_start(priv->phylink);
+	/* We may have called phylink_speed_down before */
+	phylink_speed_up(priv->phylink);
+
 	/* Extra statistics */
 	memset(&priv->xstats, 0, sizeof(struct stmmac_extra_stats));
 	priv->xstats.threshold = tc;
@@ -3836,10 +3840,6 @@ static int __stmmac_open(struct net_device *dev,
 
 	stmmac_init_coalesce(priv);
 
-	phylink_start(priv->phylink);
-	/* We may have called phylink_speed_down before */
-	phylink_speed_up(priv->phylink);
-
 	ret = stmmac_request_irq(dev);
 	if (ret)
 		goto irq_error;
-- 
2.34.1

