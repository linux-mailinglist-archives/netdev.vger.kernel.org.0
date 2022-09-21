Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D06B5C002B
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 16:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiIUOoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 10:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiIUOoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 10:44:04 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150080.outbound.protection.outlook.com [40.107.15.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F3689CD3;
        Wed, 21 Sep 2022 07:44:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mR2peZ1H9k6a1YzGIz0WXbFkCaKcS8gMTSY8xTTmCOstvlvc1Je+FcPhWFatZ3yYK+/5Bisc+4u6QLvgHrCvyziByCj/gt/K49XQpa6Ui1Vw6R547atrXTobbgooYW7egD8yNXHtq8n9P5uxZDDtG3QnW6fBnJCYAIrg4AlUw1VSCe4m/QUrPqySIm65BhiSjnCKqXINEDm2duV6RiuBlVuDMZ1a8NqPW/LmBpldJpx7VaPdV1Hy0yoLGLQtnXPrd4SueWM/IRb3QV1iqDLyaPna6ePTsMkVmhmtAYX6YaueYqIdtVlEK8CVbyY3MMDux0N72RkYWkhfD5fUjFYXGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=db6nNoWEnarmOec1OGU+5iX4ucQPT+UNWnNHXJvrucE=;
 b=hftb47amULtU+0j7tNI0eAX2fxgDp9jlQK5LDeyG/zG01COHkUFyLL/dNZIs5D2G9v8IrUbWJZZZ7UBrFscjV5RX3Kd2mGVke+0qE1SZSInvVHTo5Nj+Z7ahYFRD8XyF6siov0o7K1W/h0GYW05hiT8IPDJnpD3J+5e1Yg+YnL8Vhs0YA5vI4a3t4PSuDtohwV+KUbXGHJqSMk4bTm/ONPtWcbG5S1AVQINYaPa3eEJDWttMOczgN9FbUMjaA8hunMSrtjEffrmsPB4S0cc+6V/iBn2LVhOdKFbPl/u0w8Y+ceRPU0yZghuUEF+xXzDtcPSsHRYjJnRzxo8x5JS8hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=db6nNoWEnarmOec1OGU+5iX4ucQPT+UNWnNHXJvrucE=;
 b=YEHMwrt6FNcpRX7FkudCPjdk61e0feCurMzeeyfkW9770UzMVTzDWQ0b42hwpy4K4DAc7ZttYCafvlNFaf2dq/TSV3em+PHBMQXgvaLG5JDmyekjYJqPIn9I7TAikFOzFBfK3O1JhhyslpoBIgjwEkoHsnyzWs+n7UvL1hLVKA8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8661.eurprd04.prod.outlook.com (2603:10a6:10:2dc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 14:44:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 14:44:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: enetc: cache accesses to &priv->si->hw
Date:   Wed, 21 Sep 2022 17:43:48 +0300
Message-Id: <20220921144349.1529150-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0023.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8661:EE_
X-MS-Office365-Filtering-Correlation-Id: 96553701-4781-4f9a-51ae-08da9bdfb87e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IQAGjxKvBKvWjnXlP85KcRmv+uxVMrPwsUZOA3s4BrX59y8OL1o9mRKFUPw8LrKZ1EkbMVGySfcgaoiaCOnAn2DI9DiYSHoG4gIgKVjmgd75+9kwX2lXMl0bmGwdQoGcUSzkYwwdZqfGHEx2rjhPcfQ3gzikcgyNPY8NKmHfHDJFdf7jp6oFBl4JtfhzLODCTfx3CeQPRXUCMXk4QqefK4hBrHTTsCH+uF6LutDFJQWyuVxAnRnwBt+DveAqIsMN4TA3LD6UZn1acOO8PLtybqI5ekka1k6U107C+Sad6Othr1F1oJFPALA5bZWbgi5sTfsjt+VK+8p8Bc6xDWhDWKAFaiAbE+YASX2hyHSrdMmzthXWfJhSMMImdopMcYXd9+eagnfx5nI1jBO0H1tNuytJWo1N+uGb4t6ktedejsMXriZYdwhR1slp4sOlzEMLj1S8Gp4qYXCIlonTGUU35Gz2qrS+O26TgzMrkcjDi7ZgB7u+W8naDb0hKyAhcbw/gIXTYfK0PJtUUZLExGszdmxQ3G3SXK+7RVTo3hJAMAuwmbUNUQZy7P4LgF3CEpOqeMdskkPrqOsATRADeraFREwJp5YFgHb/Urqo4syesi6RZekdVIe8ihOu8lBehpdw463+SkeGmqmbXfVMJ8NW/Lp88bZ3y3Nv3GvUB0zb63htN7o0ikGohfDt03L8xiZZlQCXI0FTVeALTlrLYFNsq8K6CqMeDPWQkFzsggxGPJYmXgC/3WiWIszi1j5vc9wAs/rztxjq7ROqDOccnbQ7+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(6486002)(6666004)(2906002)(6512007)(52116002)(26005)(66476007)(316002)(86362001)(66946007)(66556008)(8676002)(4326008)(44832011)(186003)(1076003)(30864003)(6916009)(8936002)(5660300002)(54906003)(36756003)(478600001)(6506007)(38350700002)(38100700002)(2616005)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NsYz5VUA0QibzePZH/rCUDRULJE4qDNWRhIqJqeHFeh55BJON2NSQE/5N5kC?=
 =?us-ascii?Q?3RGaOEMgR76PnZl37TIKIj1YDKp2OQtmva9rOb9dvqjl9oHJkWCuNP//nfzl?=
 =?us-ascii?Q?FMJNIoRFjh+CEY3uIgCQ0NpI7IyPf/UV3t9efDthvehe6nNX6DaUJpaM7g17?=
 =?us-ascii?Q?96ba9+6seF421zKUPnwsMbKMIGSSJUSXfpBjFcDuia1nR91slq6kfKXpMNT7?=
 =?us-ascii?Q?QxRwTP7di+/Nezn9yk3nYcCNt7RV4qZLXOvKV6tJNuAp7TsbWbEslmlyBE7y?=
 =?us-ascii?Q?HBIKsJspC7B5ScCKGwE5UzeFTA08zvQAb+KXDik//O16LUfx6NIh1jNfb1OW?=
 =?us-ascii?Q?3MdImp3RS9J25a7tHxB6/+/h0/GfcegZy4Xo0o+aFEs8H+GkjtF9XXzDIqnz?=
 =?us-ascii?Q?3RsFV/qgZ0FTUeAL1r3MouEcgjBKeXC+YxMbRov/T/diPiuLt1Gzx/FLs0B/?=
 =?us-ascii?Q?UqQ6n67lN341JQkXcSdarZ2PdvZj1vvquP/c8I2eI3lzGvWf2yTFLALP7Y1/?=
 =?us-ascii?Q?t/IFB6oviyAJ+dXl884FEus/C16kwLKYeMz3XO0bgemv+Vm/Gc+cj9urDWU2?=
 =?us-ascii?Q?s9d0GHLfeWDOFil4UQrtFwoypfim3cG/dW/e2GZ1shvTb1eSEKBJbnGkYIBN?=
 =?us-ascii?Q?saD9ynUXJ/GD4MB4Uq4Xc+Ru59FaiXARPvypXlxzUAEUmba2DaPA9QoLjEjU?=
 =?us-ascii?Q?ntMauo3eIX7DjC7XxzK+VeLZyq/r8QyfEx4k46DXQ5V9mrPNDpsySfJYqVa4?=
 =?us-ascii?Q?cy0ts4jeGGiPisRG8hcIZUCvDcLeG+KYv62+42ZfXp0oNqqNWe6shgAXjSkd?=
 =?us-ascii?Q?q7I33AP7HOE04LS1+mdeExJcvEy1bBVN4GVVjmQfabVqKMoR/0FeFrgfGx0m?=
 =?us-ascii?Q?tIGPstH+qpRMNJ046dGvxrVAHahTE5vPTgRrJEpxgcr+zKdnMnQQHU/oY61D?=
 =?us-ascii?Q?FrzVILhYcHjk6IR48oKoYk380eGMkJvl7wrkRK09+F4UWhpSbJGsPiZY8fcs?=
 =?us-ascii?Q?Hi/d1AWyPbFRjPiuu7vZeU9EF1SRL+ju9oRVA7OPkB9xczbXOTtiMJdL4Uvh?=
 =?us-ascii?Q?hxRSCXLtOPU/pp/PzOYm9bDR/AonTTZ/sFM5RP7ixGobcviPd5ysSATmTcTo?=
 =?us-ascii?Q?oW8VKJjkR6o2jtWnWs28iqnmmA90wYsCgUQpsRge+zsfS8/Z8U4E/4LetmoV?=
 =?us-ascii?Q?0EA+x0mUa8wQrbTHCgt+9+c211UfpGk/TxehzeQeVYVXC4esuFG2LXeebPjv?=
 =?us-ascii?Q?dl608vUmkEWy7VYRyEcTeeKacbBD/9TcBwpEuVidfTMthJX311S+YOgQ3Wkg?=
 =?us-ascii?Q?p61krFo68MVqRtuBcXLnBKLHI3HnsloXHZ5/jRvyWEqa9EPwVeIgKm/OXcco?=
 =?us-ascii?Q?T3e22XpXK7wPR6Q3jHdBkD6ZE1lJ03r4Tf2qaXENfJ1ESFK1oD9J+NlZ1mqA?=
 =?us-ascii?Q?uCCiSbHYTdUqL9NkO+tYPVA6aC9UNAtEcxkh48cgHabfmou1xWHc6dNBCBKD?=
 =?us-ascii?Q?tlBkHq6lHipdnaN30SZHQRP6NX/OKJMRw522aKXbfLoddSptyar3FUZJQ+mt?=
 =?us-ascii?Q?1vwXboeB/6tL6Jpgj2enTMlAd1zpCSk8TM+mnfpVWTuc/t8Uh6c9mKfdleCN?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96553701-4781-4f9a-51ae-08da9bdfb87e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 14:44:00.3988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lR9a81PJVIJ8ttzvl9GdLokDAzL+d/Gw01djO9A1jJDeBQTdP7eAFABX4OBRL6JwkJyZNr2Wr+1yQUClvTNgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8661
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The &priv->si->hw construct dereferences 2 pointers and makes lines
longer than they need to be, in turn making the code harder to read.

Replace &priv->si->hw accesses with a "hw" variable when there are 2 or
more accesses within a function that dereference this. This includes
loops, since &priv->si->hw is a loop invariant.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 28 +++++----
 drivers/net/ethernet/freescale/enetc/enetc.h  |  9 +--
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 60 +++++++++----------
 3 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 9f5b921039bd..151fb3fa4806 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2116,13 +2116,14 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 
 static void enetc_setup_bdrs(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_setup_txbdr(&priv->si->hw, priv->tx_ring[i]);
+		enetc_setup_txbdr(hw, priv->tx_ring[i]);
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_setup_rxbdr(&priv->si->hw, priv->rx_ring[i]);
+		enetc_setup_rxbdr(hw, priv->rx_ring[i]);
 }
 
 static void enetc_clear_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
@@ -2155,13 +2156,14 @@ static void enetc_clear_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 
 static void enetc_clear_bdrs(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_clear_txbdr(&priv->si->hw, priv->tx_ring[i]);
+		enetc_clear_txbdr(hw, priv->tx_ring[i]);
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_clear_rxbdr(&priv->si->hw, priv->rx_ring[i]);
+		enetc_clear_rxbdr(hw, priv->rx_ring[i]);
 
 	udelay(1);
 }
@@ -2169,13 +2171,13 @@ static void enetc_clear_bdrs(struct enetc_ndev_priv *priv)
 static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
+	struct enetc_hw *hw = &priv->si->hw;
 	int i, j, err;
 
 	for (i = 0; i < priv->bdr_int_num; i++) {
 		int irq = pci_irq_vector(pdev, ENETC_BDR_INT_BASE_IDX + i);
 		struct enetc_int_vector *v = priv->int_vector[i];
 		int entry = ENETC_BDR_INT_BASE_IDX + i;
-		struct enetc_hw *hw = &priv->si->hw;
 
 		snprintf(v->name, sizeof(v->name), "%s-rxtx%d",
 			 priv->ndev->name, i);
@@ -2263,13 +2265,14 @@ static void enetc_setup_interrupts(struct enetc_ndev_priv *priv)
 
 static void enetc_clear_interrupts(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_txbdr_wr(&priv->si->hw, i, ENETC_TBIER, 0);
+		enetc_txbdr_wr(hw, i, ENETC_TBIER, 0);
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_rxbdr_wr(&priv->si->hw, i, ENETC_RBIER, 0);
+		enetc_rxbdr_wr(hw, i, ENETC_RBIER, 0);
 }
 
 static int enetc_phylink_connect(struct net_device *ndev)
@@ -2436,6 +2439,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
+	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_bdr *tx_ring;
 	int num_stack_tx_queues;
 	u8 num_tc;
@@ -2452,7 +2456,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
 			tx_ring = priv->tx_ring[i];
-			enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, 0);
+			enetc_set_bdr_prio(hw, tx_ring->index, 0);
 		}
 
 		return 0;
@@ -2471,7 +2475,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	 */
 	for (i = 0; i < num_tc; i++) {
 		tx_ring = priv->tx_ring[i];
-		enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, i);
+		enetc_set_bdr_prio(hw, tx_ring->index, i);
 	}
 
 	/* Reset the number of netdev queues based on the TC count */
@@ -2584,19 +2588,21 @@ static int enetc_set_rss(struct net_device *ndev, int en)
 static void enetc_enable_rxvlan(struct net_device *ndev, bool en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_bdr_enable_rxvlan(&priv->si->hw, i, en);
+		enetc_bdr_enable_rxvlan(hw, i, en);
 }
 
 static void enetc_enable_txvlan(struct net_device *ndev, bool en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_bdr_enable_txvlan(&priv->si->hw, i, en);
+		enetc_bdr_enable_txvlan(hw, i, en);
 }
 
 void enetc_set_features(struct net_device *ndev, netdev_features_t features)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 2cfe6944ebd3..748677b2ce1f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -467,19 +467,20 @@ int enetc_set_psfp(struct net_device *ndev, bool en);
 
 static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	u32 reg;
 
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PSIDCAPR);
+	reg = enetc_port_rd(hw, ENETC_PSIDCAPR);
 	priv->psfp_cap.max_streamid = reg & ENETC_PSIDCAPR_MSK;
 	/* Port stream filter capability */
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PSFCAPR);
+	reg = enetc_port_rd(hw, ENETC_PSFCAPR);
 	priv->psfp_cap.max_psfp_filter = reg & ENETC_PSFCAPR_MSK;
 	/* Port stream gate capability */
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PSGCAPR);
+	reg = enetc_port_rd(hw, ENETC_PSGCAPR);
 	priv->psfp_cap.max_psfp_gate = (reg & ENETC_PSGCAPR_SGIT_MSK);
 	priv->psfp_cap.max_psfp_gatelist = (reg & ENETC_PSGCAPR_GCL_MSK) >> 16;
 	/* Port flow meter capability */
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PFMCAPR);
+	reg = enetc_port_rd(hw, ENETC_PFMCAPR);
 	priv->psfp_cap.max_psfp_meter = reg & ENETC_PFMCAPR_MSK;
 }
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index f8a2f02ce22d..2e783ef73690 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -17,8 +17,9 @@ static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
 
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	u32 old_speed = priv->speed;
-	u32 pspeed;
+	u32 pspeed, tmp;
 
 	if (speed == old_speed)
 		return;
@@ -39,16 +40,15 @@ void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 	}
 
 	priv->speed = speed;
-	enetc_port_wr(&priv->si->hw, ENETC_PMR,
-		      (enetc_port_rd(&priv->si->hw, ENETC_PMR)
-		      & (~ENETC_PMR_PSPEED_MASK))
-		      | pspeed);
+	tmp = enetc_port_rd(hw, ENETC_PMR);
+	enetc_port_wr(hw, ENETC_PMR, (tmp & ~ENETC_PMR_PSPEED_MASK) | pspeed);
 }
 
 static int enetc_setup_taprio(struct net_device *ndev,
 			      struct tc_taprio_qopt_offload *admin_conf)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct tgs_gcl_conf *gcl_config;
 	struct tgs_gcl_data *gcl_data;
@@ -61,15 +61,13 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	int err;
 	int i;
 
-	if (admin_conf->num_entries > enetc_get_max_gcl_len(&priv->si->hw))
+	if (admin_conf->num_entries > enetc_get_max_gcl_len(hw))
 		return -EINVAL;
 	gcl_len = admin_conf->num_entries;
 
-	tge = enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET);
+	tge = enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET);
 	if (!admin_conf->enable) {
-		enetc_wr(&priv->si->hw,
-			 ENETC_QBV_PTGCR_OFFSET,
-			 tge & (~ENETC_QBV_TGE));
+		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
 
 		priv->active_offloads &= ~ENETC_F_QBV;
 
@@ -117,14 +115,11 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	cbd.cls = BDCR_CMD_PORT_GCL;
 	cbd.status_flags = 0;
 
-	enetc_wr(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET,
-		 tge | ENETC_QBV_TGE);
+	enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge | ENETC_QBV_TGE);
 
 	err = enetc_send_cmd(priv->si, &cbd);
 	if (err)
-		enetc_wr(&priv->si->hw,
-			 ENETC_QBV_PTGCR_OFFSET,
-			 tge & (~ENETC_QBV_TGE));
+		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
 
 	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
@@ -138,6 +133,7 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 {
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int err;
 	int i;
 
@@ -147,16 +143,14 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 			return -EBUSY;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_set_bdr_prio(&priv->si->hw,
-				   priv->tx_ring[i]->index,
+		enetc_set_bdr_prio(hw, priv->tx_ring[i]->index,
 				   taprio->enable ? i : 0);
 
 	err = enetc_setup_taprio(ndev, taprio);
 
 	if (err)
 		for (i = 0; i < priv->num_tx_rings; i++)
-			enetc_set_bdr_prio(&priv->si->hw,
-					   priv->tx_ring[i]->index,
+			enetc_set_bdr_prio(hw, priv->tx_ring[i]->index,
 					   taprio->enable ? 0 : i);
 
 	return err;
@@ -178,7 +172,7 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	struct tc_cbs_qopt_offload *cbs = type_data;
 	u32 port_transmit_rate = priv->speed;
 	u8 tc_nums = netdev_get_num_tc(ndev);
-	struct enetc_si *si = priv->si;
+	struct enetc_hw *hw = &priv->si->hw;
 	u32 hi_credit_bit, hi_credit_reg;
 	u32 max_interference_size;
 	u32 port_frame_max_size;
@@ -199,15 +193,15 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		 * lower than this TC have been disabled.
 		 */
 		if (tc == prio_top &&
-		    enetc_get_cbs_enable(&si->hw, prio_next)) {
+		    enetc_get_cbs_enable(hw, prio_next)) {
 			dev_err(&ndev->dev,
 				"Disable TC%d before disable TC%d\n",
 				prio_next, tc);
 			return -EINVAL;
 		}
 
-		enetc_port_wr(&si->hw, ENETC_PTCCBSR1(tc), 0);
-		enetc_port_wr(&si->hw, ENETC_PTCCBSR0(tc), 0);
+		enetc_port_wr(hw, ENETC_PTCCBSR1(tc), 0);
+		enetc_port_wr(hw, ENETC_PTCCBSR0(tc), 0);
 
 		return 0;
 	}
@@ -224,13 +218,13 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	 * higher than this TC have been enabled.
 	 */
 	if (tc == prio_next) {
-		if (!enetc_get_cbs_enable(&si->hw, prio_top)) {
+		if (!enetc_get_cbs_enable(hw, prio_top)) {
 			dev_err(&ndev->dev,
 				"Enable TC%d first before enable TC%d\n",
 				prio_top, prio_next);
 			return -EINVAL;
 		}
-		bw_sum += enetc_get_cbs_bw(&si->hw, prio_top);
+		bw_sum += enetc_get_cbs_bw(hw, prio_top);
 	}
 
 	if (bw_sum + bw >= 100) {
@@ -239,7 +233,7 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 	}
 
-	enetc_port_rd(&si->hw, ENETC_PTCMSDUR(tc));
+	enetc_port_rd(hw, ENETC_PTCMSDUR(tc));
 
 	/* For top prio TC, the max_interfrence_size is maxSizedFrame.
 	 *
@@ -259,8 +253,8 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		u32 m0, ma, r0, ra;
 
 		m0 = port_frame_max_size * 8;
-		ma = enetc_port_rd(&si->hw, ENETC_PTCMSDUR(prio_top)) * 8;
-		ra = enetc_get_cbs_bw(&si->hw, prio_top) *
+		ma = enetc_port_rd(hw, ENETC_PTCMSDUR(prio_top)) * 8;
+		ra = enetc_get_cbs_bw(hw, prio_top) *
 			port_transmit_rate * 10000ULL;
 		r0 = port_transmit_rate * 1000000ULL;
 		max_interference_size = m0 + ma +
@@ -280,10 +274,10 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	hi_credit_reg = (u32)div_u64((ENETC_CLK * 100ULL) * hi_credit_bit,
 				     port_transmit_rate * 1000000ULL);
 
-	enetc_port_wr(&si->hw, ENETC_PTCCBSR1(tc), hi_credit_reg);
+	enetc_port_wr(hw, ENETC_PTCCBSR1(tc), hi_credit_reg);
 
 	/* Set bw register and enable this traffic class */
-	enetc_port_wr(&si->hw, ENETC_PTCCBSR0(tc), bw | ENETC_CBSE);
+	enetc_port_wr(hw, ENETC_PTCCBSR0(tc), bw | ENETC_CBSE);
 
 	return 0;
 }
@@ -293,6 +287,7 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_etf_qopt_offload *qopt = type_data;
 	u8 tc_nums = netdev_get_num_tc(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int tc;
 
 	if (!tc_nums)
@@ -304,12 +299,11 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
-	if (enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
+	if (enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
 		return -EBUSY;
 
 	priv->tx_ring[tc]->tsd_enable = qopt->enable;
-	enetc_port_wr(&priv->si->hw, ENETC_PTCTSDR(tc),
-		      qopt->enable ? ENETC_TSDE : 0);
+	enetc_port_wr(hw, ENETC_PTCTSDR(tc), qopt->enable ? ENETC_TSDE : 0);
 
 	return 0;
 }
-- 
2.34.1

