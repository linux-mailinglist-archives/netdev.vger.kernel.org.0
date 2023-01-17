Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7322B670E1C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjAQXwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjAQXvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:54 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2078.outbound.protection.outlook.com [40.107.14.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BDF4FAC4
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xd4m0cNmI2zB8flNTEjBT1oV9rmph3Pt842m44LtVWy5wV+E86f5X7xs1fdFNBdLXJ1cbQ7F9gozh1mPV8FpUgBQKi1IfJvMuP0ww2c0WEUranDpWYJk7WsyvEeI2nDSyoA12gVmUCckD5cxK9aPRnjaMe6Igy4ruN5xK7GswtXznFqn+R4kl6gjxPjFNLbzOJjDVfPJi+6djgrcNX+UTQAAKpNJKnmU3TK9hDtyDk8/3pBIsNaNqHa+t6E4+/1fp4dbGKiS9Hj8pxFLqvHNGt/jfjvr7d0g2cOnFBykRqEd5xmxd5iBZ0MxQdERZCkCjMlaf5dv6fnot7qvKoynlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1edEyW2mUshQo6NiMgPw4GQNV2C3RxeW3QIQ85/q6o=;
 b=c+ZOi0EnjdU7KcMvQ8ttBYc+5T/4/ZkpbHsPZ+TBjjJrH6ILSh2CeuZUydOHAyRhNzhUqYoSO5KEv1icTDDkAk902ZL23qhEgFUyvPCjV2ku6grbcx1d0yDAUdhAW4ZRnBWipyxGSFa9b0DS+4FmjXwbQGM4iOXf/Ie4uen+lnkdespXguChGdUkDevOI0rnvw2SGE3yuTk8o2GM+THJ7lyI3Q2yvjgmYPVTv1U2c53KiO8WZbs4BkGJNSuZyAapXR5KaKL80Xc0lR+/9xOdANiLM+qH+BQS6UPMp/V5t6WtHrdLcK+BVM8fis6ibVFawyZyvOAx5I9roDyx/HcQzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1edEyW2mUshQo6NiMgPw4GQNV2C3RxeW3QIQ85/q6o=;
 b=LSw+jt8bQFtT2kWHvDjqi/t4xuJOWmVI1mrIaZw1ULrScXvWWHq3KOLuqXYXHOt/oOHPNv7Vn9w85dh5eBSG0KrB1BphXXBMAot9apZLppXqN6fp+GkXCr2QIv7Lg+1O1+Rnu3dXqVuppAEChw/73YTda8wpbjMR3hNAqcnzwlk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 06/12] net: enetc: bring "bool extended" to top-level in enetc_open()
Date:   Wed, 18 Jan 2023 01:02:28 +0200
Message-Id: <20230117230234.2950873-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
References: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: d1d38ffe-c8ac-44f8-a7b3-08daf8df0376
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Z727rP+DWQiDuhRM23WPLH5fwM6R/FgzV6MOoHG4bX9UEJ8Za8uGcenH+BHS3+8W7QAdC+jFDUPKUsloTN5YdCyhSV8hx2fEHOoHYb19DvdhCdasyLTIOYQLcwa/5ciNgUFfCnHI+O+qneZWEx5WwrKu5EpM5MkseyRHlNraBu/32y/83V9vgfvWbdHMIjPywnhniSFXLqE4m10WJBqIDtnacBs1XOJABMndZktfngm72R6NEbM7nGTegw5AUafP1I7LvomVTvu6eLfpWQvpL2vYeCCsadlOIA6pZhyC5NGY8rm2DaLMkbEralVPBVUmaNgN89ungc/WchdkDnMT3Nf53ZP5CIPmW6kti81ZcMqwBdjE3lSXwne+icyh6Ju7OzYA6Z1JxJadjsJh91IJHE7EDq1v+DP0Pq33juK23Mm4VF57ATp3z22iE/tNP0YL+HVdGLsGCIl4K79LuEgWh3HFdE71ONd5VXsUrVzTij+M/LvoO+x3C01J6YLUXktQriyI8hhztVw2LlUvFkubhIFKY0TjKpcyvTEz+zcC9IzXa4nSMALqKPLqADWnRY3q7xQ5osEB/CcHeFoo7+wxbKAP5FjTS0NeWZZK/csin7/b7mLmhiKL15LDvsQq3oT8rmVlqcZtJMvLURjCZvT+DOOpL5sNzr1gLHLB8e7UBlPHajeIf8V21SQsDkDDn+XwtSa7HLMqOErKjwiE0LD8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mGZBZAb/w4rrAybObMGcNAGeCZ/Hy328CRYCWcNYNpL+E1VqX+W8p+ONjYU+?=
 =?us-ascii?Q?WV6oMcGAVuexAQrhz8YcuzFTuCV4+G88aAZW6hLcB1HsS/RUsgbPVUM5S85F?=
 =?us-ascii?Q?JVmaSK5HLUxGqjam7tshVRQv6yo8DnAMNd6nrD+csFrpQ7ekgNYHL+HVayqE?=
 =?us-ascii?Q?81qGGOffZHotIn5VCXKQ5OTdUQ1jVZONy0yDxQ8WnDyT5FIR/KjUKhMxX68r?=
 =?us-ascii?Q?jcCloCEU6Lw0oTwU4ViwJriwNkYv/oMTJnFU1WndzZJYWq/du5ADGmGKdIch?=
 =?us-ascii?Q?Cy4du8sjUOlqnsKwgSSLrSlzy3RzNX9VxZocGRrdlyiJkdG/B/R+dnLvRtgr?=
 =?us-ascii?Q?gjVNw24vETrscPQaHTMq78XjKqp9NVjwPywApEVXKhjf8y4IugTUUKjpDyov?=
 =?us-ascii?Q?7yQRS1i2c5dbSeQ+4M40E24LrsFs6UCgcM/2HcDzqCofkq2XROFQiHCjxErl?=
 =?us-ascii?Q?ILQmgkI87gUMaENhKY3dgp29xygXvouWXr9LztRBt7GpNM4WYiSObbDLOgw7?=
 =?us-ascii?Q?P0TPVA2kwPTy1NSDHKlqp4kQFVkr6sXfeCJNE1JojssgcFTiU6hr3ZsUTMwe?=
 =?us-ascii?Q?d85AnOr48u2tLbfIHZLCVBG8BFkxfWVoSY11m+S86BXEdZEZZxN2YqV6DsN6?=
 =?us-ascii?Q?ojxJWYDIaZ4K/a0sRXzmZtgLnDMA46P4e1K0u6y6y9im9ZYLYYPB2Xrgfx8V?=
 =?us-ascii?Q?uxSmXCUmcM7GeO+NEYEk57beR+JaoPvAEHd+XxyxuO56T9lKPjA37BcYfjJV?=
 =?us-ascii?Q?TOW27dO8RUNYV6jWbpQ8/IR0zTBLT0VLvjWa9+KoDI4HQuVvw4bjyRG+G52I?=
 =?us-ascii?Q?G/RKrOP7CCXSbHIzA48U7xcNWa3W1lbCgkYREdrFctoGK10IpHO7e8/J1+FS?=
 =?us-ascii?Q?DuYfKA2kMLUPWnrxIcfpchPUb6e4V7Hj8kvF4MGLN4ZBz0QtKgCu0kle2YD8?=
 =?us-ascii?Q?atNGEAqoDT/hV7eX5js/IWOnjGjgc7b4iSYLCoUGKUCJecvlVasfrXhQoAdw?=
 =?us-ascii?Q?kk9mGx47RyCUhY4EyzLXzT67/h7fbptoStZ3UCgbdlgmDpeK0E52F6XvhcLE?=
 =?us-ascii?Q?h/OOD2mNnPOD80QWBH0NQIxlkcAF5LdM2b5jiyVaRcvQXXGTXtJ6gWr6mhB1?=
 =?us-ascii?Q?DwZPIaKRE/k9vetso7PkXUPAIN0ksIm+wXJ3/WU4mmS0llFkZJfitTnqSlKx?=
 =?us-ascii?Q?IP/XCFByCTDVHJZ9hESUkyLsuMht2IC40VjAeumlti482MviAy4x7HOzEd+H?=
 =?us-ascii?Q?JBfBqEy7g04BA0iJWDZAIJflGMPIEmKZmQG6frd7VAau7LjIcg9oQ0JfuL9f?=
 =?us-ascii?Q?MrpLKVfpVno98Tyo2a47iwSreWjchImVHcbz40jCXEv0lk4uokVjNN9zv63e?=
 =?us-ascii?Q?pq/Ry1XfsYhnMgNLbG+9T+AiYWyGPqTVII8Fdw+CStaZgHQH215iHC+7ckLa?=
 =?us-ascii?Q?kEPTAKbXcOpzkMO8NF9t1Zuq+tuwrbgHW6unluhHAlaVImOGyjW+ii4Q3ubM?=
 =?us-ascii?Q?fZYpfN08/UVO89n+CVnpgTkznzy2k8e5oaFjUA9BzaIvABYlD5X1YdcdCxNU?=
 =?us-ascii?Q?pjpkldm2npS4H9+TCJB83fAp58ldL+dVC8R8xIQ9mKhtlGWsNForu9nJb0ON?=
 =?us-ascii?Q?DQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1d38ffe-c8ac-44f8-a7b3-08daf8df0376
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:15.4130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BkrOs4MhDQYl/MBfa43ADCX6ySXQOtVfhAvK1sCf1HGi4TITdSOjOxAzQl/apJnmFv3e+9fSuBDGXbHZ/gTxTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extended RX buffer descriptors are necessary if they carry RX
timestamps, which will be true when PTP timestamping is enabled.

Right now, the rx_ring->ext_en is set from the function that allocates
ring resources (enetc_alloc_rx_resources() -> enetc_alloc_rxbdr()), and
also used later, in enetc_setup_rxbdr(). It is also used in the
enetc_rxbd() and enetc_rxbd_next() fast path helpers.

We want to decouple resource allocation from BD ring setup, but both
procedures depend on BD size (extended or not). Move the "extended"
boolean to enetc_open() and pass it both to the RX allocation procedure
as well as to the RX ring setup procedure. The latter will set
rx_ring->ext_en from now on.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 94580496ef64..67471c8ea447 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1829,8 +1829,6 @@ static int enetc_alloc_rxbdr(struct enetc_bdr *rxr, bool extended)
 		return err;
 	}
 
-	rxr->ext_en = extended;
-
 	return 0;
 }
 
@@ -1842,9 +1840,8 @@ static void enetc_free_rxbdr(struct enetc_bdr *rxr)
 	rxr->rx_swbd = NULL;
 }
 
-static int enetc_alloc_rx_resources(struct enetc_ndev_priv *priv)
+static int enetc_alloc_rx_resources(struct enetc_ndev_priv *priv, bool extended)
 {
-	bool extended = !!(priv->active_offloads & ENETC_F_RX_TSTAMP);
 	int i, err;
 
 	for (i = 0; i < priv->num_rx_rings; i++) {
@@ -2022,7 +2019,8 @@ static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 	tx_ring->idr = hw->reg + ENETC_SITXIDR;
 }
 
-static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
+static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring,
+			      bool extended)
 {
 	int idx = rx_ring->index;
 	u32 rbmr;
@@ -2054,6 +2052,7 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 
 	rbmr = ENETC_RBMR_EN;
 
+	rx_ring->ext_en = extended;
 	if (rx_ring->ext_en)
 		rbmr |= ENETC_RBMR_BDS;
 
@@ -2075,7 +2074,7 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
 }
 
-static void enetc_setup_bdrs(struct enetc_ndev_priv *priv)
+static void enetc_setup_bdrs(struct enetc_ndev_priv *priv, bool extended)
 {
 	struct enetc_hw *hw = &priv->si->hw;
 	int i;
@@ -2084,7 +2083,7 @@ static void enetc_setup_bdrs(struct enetc_ndev_priv *priv)
 		enetc_setup_txbdr(hw, priv->tx_ring[i]);
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_setup_rxbdr(hw, priv->rx_ring[i]);
+		enetc_setup_rxbdr(hw, priv->rx_ring[i], extended);
 }
 
 static void enetc_clear_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
@@ -2308,8 +2307,11 @@ int enetc_open(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	int num_stack_tx_queues;
+	bool extended;
 	int err;
 
+	extended = !!(priv->active_offloads & ENETC_F_RX_TSTAMP);
+
 	err = enetc_setup_irqs(priv);
 	if (err)
 		return err;
@@ -2322,7 +2324,7 @@ int enetc_open(struct net_device *ndev)
 	if (err)
 		goto err_alloc_tx;
 
-	err = enetc_alloc_rx_resources(priv);
+	err = enetc_alloc_rx_resources(priv, extended);
 	if (err)
 		goto err_alloc_rx;
 
@@ -2337,7 +2339,7 @@ int enetc_open(struct net_device *ndev)
 		goto err_set_queues;
 
 	enetc_tx_onestep_tstamp_init(priv);
-	enetc_setup_bdrs(priv);
+	enetc_setup_bdrs(priv, extended);
 	enetc_start(ndev);
 
 	return 0;
-- 
2.34.1

