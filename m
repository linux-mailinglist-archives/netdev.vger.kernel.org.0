Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAA2652D97
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 09:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiLUICt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 03:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiLUICp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 03:02:45 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2040.outbound.protection.outlook.com [40.107.14.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86FC15FF6;
        Wed, 21 Dec 2022 00:02:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrzKt3adAGZfFvbgFyWnPxFlz3eOzBP8JGvKx2xI5XFtwjreavfePL1CmK9XRH6jWbfzU5QS+8ohihCJmV9EKuJ1srqqHR3MJaVvVEsXax0zFJ665cxc2m8kr3AlBN4bG2dYUHZveGjtb6KeUlts7SyEC5Av1dTl/0I2a6eOHaNkMyZywC91inv17TJo/mf7Mw4upeSIKNbBcRgByno+t88kBR6opHolwt3Sae7e2oXxkiaPgIksj09TFT6TViLXgWy1xjeVEEE4k3s69wZs7Q8/D6JyYmqEsutAxgMJIFkjmwA4Uhg01xEpQwJs4xrth8qffms/NfodI+cob3/fGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uocUIT9079Ltf+3eXIeJi8GnjNsBVSY0m8bP2M/6vwA=;
 b=MRNbQHBHKRK0Ryi6qkp6JDvaFckltqEpwt4zh11u2EgeAfm5dBniVAnguKlPvxRsgFsHBaNieugTWVybTiIb8gR3a0vR/2G8n5zcB6vuQriFAQ7ZChKSefF2eZ/QTG3CsI9yThypqTmyvgWsGSBRiQxMsk6kFUIoPKZuqcTLUkizNJkLGO0R6oSdaW2kY3kM3HRUQ+hcspbn0D0vrbZJg7s3c+qybCnpdDMvybDdFQP1mhvNYTdljQSb9IvRVJWabDbptMbh8jnmEgOoecuKmz4v/8Bnf5seh5dl31N2h+30Q/hLwpqUZjBSpVYNRaitei32EYblAduQikcuYgZShg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uocUIT9079Ltf+3eXIeJi8GnjNsBVSY0m8bP2M/6vwA=;
 b=l7lvTbcanP+CI7bdxyzidKyjKA56IZqT1GSajYxaBwEv7yW4xAcqhGV49b5Z0q+nNK9jDh5Nc/9OKNojiZ5CalT8LW/6s18ORWw/rvlIYC+kGteOF0h7gX/8CR9lPKWMH/8rNcrqUhiDVftaOtGU9UYXw82zaCae/VaHm1/iXoI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by PAXPR04MB8426.eurprd04.prod.outlook.com (2603:10a6:102:1ca::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 08:02:42 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c%11]) with mapi id 15.20.5924.016; Wed, 21 Dec
 2022 08:02:42 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     linux@armlinux.org.uk, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: stmmac: resume phy separately before calling stmmac_hw_setup()
Date:   Wed, 21 Dec 2022 16:01:44 +0800
Message-Id: <20221221080144.2549125-3-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221221080144.2549125-1-xiaoning.wang@nxp.com>
References: <20221221080144.2549125-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:196::10) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|PAXPR04MB8426:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a95fdf1-618e-4dc2-0750-08dae329bc7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lwA+oJWn2fgqD9tae56bDtEC8n1O4I4m79+VvJC/Z3IDW/51NC8nE1P9xtKDyRMuL+1SLA7peYVZbC6pzRwHoFjqK4hdCHL+hzRZQMbe3ud0f3gsn/OsW6hxp/F9fjlOo0XmTBYtNix0DqUInyvB4VO/uppj1QGRo+YyHydeB93TW+MNPbh2AVoECBtSebNnFKAUMK/6mJd8BGHnwpc8FaCIOBUSQiU7c1MMThPr9qaa12jE+0hBnmOkGOXE1HGjBYaAdJClqOlU6cNsAqOnBq14pYq9VtukSyk8BOVKPaLRXXurB3X8ZjW7wxlJ/Q/eUPOiTViYPnHT4a5Ygd64eTDMbRqgKknPs/y93ZmLy4mrsZmMS2TVeP3ECKTUn6tLxcJq07ZixdXqMF5eSRPzSvV6Dx3xtM7MHGUotVaRaqzIIFzNSDu6GBps2zBq1W68elR2Gh0MmqVYjV+xu4dly/pUQMvMWhEcMP4r2JVCuX1Tx5u4kp9ZgS2Woj4YFbiFQL8grrpa2YgcA4OBvIwkKoi2R/CW6BD9kbK6ny+yf8weUJF2A5Lty6VsKF+/WF2H/vMTisszebBI9ayiAYRYzMO6fRQh8GtaEQXOG5bDjew+AlAVsViwLp+vrekdNUo/sbL/ioJk9B56TDt6J+1jDbZfQaF7zyUCBnjVUH2J493plFmVrqINnjOVHIrXuCJbGmcpZXV0KweLFGKt1Fcjxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199015)(478600001)(6486002)(6506007)(186003)(6512007)(2906002)(26005)(36756003)(52116002)(41300700001)(66476007)(66556008)(66946007)(8676002)(4326008)(5660300002)(7416002)(83380400001)(921005)(1076003)(316002)(8936002)(38350700002)(38100700002)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cb/jqMKrevFSKhDf6sLL3E5E7DKHdb9eDZ6C1BE78sc9ZYaNjzBLplf/4LAZ?=
 =?us-ascii?Q?evXkY8u9hAb6dizJJH4YbYeYndpjzz1F/X2EfZlNWA90u2tIj49Txi3IWUE1?=
 =?us-ascii?Q?VX+wstBLnoYkM3moLpo8hLJ/ue0M2q3VC6TJS9CljwXHuRRd0ye/B2gA/z7S?=
 =?us-ascii?Q?rWcpDPralf0mB1mAEU27wGd26NFkQTPeS7u3e67aK7NJrNFvibynQ+6NscS3?=
 =?us-ascii?Q?ooHHRbKHj4w8Yxm38C95QiwLvEHWL2cuuoxqhtTK15LAHrEKXQGYIwizoM3i?=
 =?us-ascii?Q?olHsn64T93mpmfI9GmpWTKWoX1Y1I8tMlbHSdG2UKuiX3H4HWqj6gmk80GWD?=
 =?us-ascii?Q?ZltcFSkJRy6EMJIAXhb/hVVo+i/ZZdgLh24hfFoux5/Q0vV+PyHKoAdwqGlG?=
 =?us-ascii?Q?XxMRo49o/dBZdbW2UETFNiYzlowcE2TuJWjvhDSVYCp8Z/SQwWDVk+eXhIws?=
 =?us-ascii?Q?3/NIT7oE3kr/oDSQTN6a4Nz2ERkz4JPJeyht6VqcE+NtzIoCZ/kcHIi+1lN+?=
 =?us-ascii?Q?rT95b0cOnRfbfqfkXtsE/uxHQB5UUWvoIkxeLWcFDEsBaHel1dNs2YO9nPIg?=
 =?us-ascii?Q?r69NT7DymAl1nVpBJgOEoackMTMlM3QDdOi3jopSqMFjtBZI4C7gykNuEGQ9?=
 =?us-ascii?Q?i9DsvmJddN8cMXFs1HYA2ud0ydZoL0rjksanFw0GMgr0Z1CA5xUhfC9rwV7p?=
 =?us-ascii?Q?wJVPjj0b7YdO4BWrzT7cHfEriawcoT6ztaqzZd6BlEzSNqXC6MJCIv4JhdvK?=
 =?us-ascii?Q?gmpx8H5kmZRwLa1CD7dzNr9zDiEv4YhN5+MzDr0KeYt3f7tiJqtIHaO3873V?=
 =?us-ascii?Q?yYY0PssPFeK9gIJHq8oV09IH74mEPWzkEr/UsduvJwVUlUCtgoYXYs4k6LDb?=
 =?us-ascii?Q?7jehsk8z9hWsyodT6QoB7Jvd/ZeOf6y4FOM9PoggW8/Suw023lCBGEqXBiEI?=
 =?us-ascii?Q?2N2+WXg0WxDzVymgQtI7mQFOQQ5zuBecbx1urVc8jkDdlai6E2WjEaO5sQmh?=
 =?us-ascii?Q?lU7tLRmTvdNoCEgTIZZo2mGLcSnrOQwnJKWF5y3GHe5K1ipsjKjg/qKzNt5g?=
 =?us-ascii?Q?S+2RMpyVecCPt8pCWaoHnP/OGeQxIa4JtAN4tQ7UmXKBnt7fA3f9SrnjVjXb?=
 =?us-ascii?Q?+5RRU7rkWGsZy9HrrOX+MIoGukzh5dckAxom9pD+RTevyr/5ara6wRO/c5NE?=
 =?us-ascii?Q?pTlU/qBJYY4TkwJ6vMc9QLBAA5wE/W7m4LYI9VwhNVr7yYtK5a67tPbDKYHY?=
 =?us-ascii?Q?aNF8NvWivVkozcV6gtM4f/FrorPDJbvmuN8ECpNwW6ZfIIba3o3gsMlcFjwm?=
 =?us-ascii?Q?kZE4W9BtztLzewpO6dmgigwduKAP5c7ZeoEawQ0U88knl/PlceJaZvzU8PXP?=
 =?us-ascii?Q?p4IRUhww/8LFuvOx/IxTMqs1vkQb5XXE/LCHr+GY9qcManp0Xsho4Hgrajgz?=
 =?us-ascii?Q?+faMMdj8Ptpi28+i18V2LKZHNBg3op9+FbCUL5bozribU+JFgXyy/bcZHEHg?=
 =?us-ascii?Q?kN9M1qR+xSC2S5v3tk9/DGyRI5eKCC0SViglNGO/gKBXx82ebDBcI9ago2RR?=
 =?us-ascii?Q?nQD3Lyzzybt+SaJ2DTTLHMKs/2CNAedUCtSMpRqF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a95fdf1-618e-4dc2-0750-08dae329bc7a
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 08:02:42.4436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQ19MTJ+keJQGMjcedrJT/8GOVa4mVi2s05Pn5AF2UQUgf8entqhxGw13hFNtBz4MVqM1SCtuLYhSRv58u0HUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8426
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some platforms, mac cannot work after resumed from the suspend with WoL
enabled.

We found the stmmac_hw_setup() when system resumes will called after the
stmmac_mac_link_up(). So the correct values set in stmmac_mac_link_up()
are overwritten by stmmac_core_init() in phylink_resume().

So call the new added function in phylink to resume phy fristly.
Then can call the stmmac_hw_setup() before calling phy_resume().

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c6951c976f5d..d0bdc9b6dbe8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7532,16 +7532,9 @@ int stmmac_resume(struct device *dev)
 	}
 
 	rtnl_lock();
-	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
-		phylink_resume(priv->phylink);
-	} else {
-		phylink_resume(priv->phylink);
-		if (device_may_wakeup(priv->device))
-			phylink_speed_up(priv->phylink);
-	}
-	rtnl_unlock();
 
-	rtnl_lock();
+	phylink_phy_resume(priv->phylink);
+
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
@@ -7559,6 +7552,11 @@ int stmmac_resume(struct device *dev)
 	stmmac_enable_all_dma_irq(priv);
 
 	mutex_unlock(&priv->lock);
+
+	phylink_resume(priv->phylink);
+	if (device_may_wakeup(priv->device) && !priv->plat->pmt)
+		phylink_speed_up(priv->phylink);
+
 	rtnl_unlock();
 
 	netif_device_attach(ndev);
-- 
2.34.1

