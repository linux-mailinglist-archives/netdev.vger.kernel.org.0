Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9CA5ED988
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiI1Jxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbiI1Jwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:52:54 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70074.outbound.protection.outlook.com [40.107.7.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1C4A8333;
        Wed, 28 Sep 2022 02:52:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsHBFp3OfyhcGjvCQkTjJupVH/9aiCpys7EFLkRT9nRdJ0f5R5OEVQmsa4VSEO19oiHE7PgdkJpl4iEj2mJrN348QEo2XV+wMChD7XGKfxHkrM83R/jXNWiIKCBdj/jxdf2bt40Ww34sg0OBXrwCvyMVuyTwzvskHSLcjJThlNEqKBkGjlmyM7WnRRObQLYFxvoxfh4aLLRyD82/M+nsyyusI8A3L6ppYxehcHVGmeWEAntQZryekFoQyausUxkP83WlPpcKrzghHhjGxsZp621OrpleY123uYzqSH3NOcyZFkjzSa1hIuuDDUPNKKtALsopYiTYBfUoTi2Lvmgn0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MoJJ+yZP6EYhlVryQNj/0CkFbxikWQorTWbgw6I1Xjk=;
 b=JYbjArY5QzufQ7FvFft3zQgLyqGvapH8MXtKUjs1PJKdktmlvppX3I20hjGlv+6R3K0lwDQzzM1quZkX3r3Z9vWPLNcWhXWAXORMxWqb+5LeJ0NII8vJOr13DR8asF5YhprfPq1YLGXhePL7wqalbiw9yPRQOIdZ/jyKFACW15L8Af1sYxHFjM42HQweuKUFuELOscSy0GdFpS4BVrzD7IFAk30JFWQ3lkDMVPrNUbSikBn85vs6Z6VlFDRTpBjl4isQqhK+WMIkopxFan3JRfB4AYoDaDBvp2PNV6757ecfMyJvgo56rw53bkKLkLycQJMQ6HyehIecxwVBFmlGHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MoJJ+yZP6EYhlVryQNj/0CkFbxikWQorTWbgw6I1Xjk=;
 b=BLCH9nBZmYEOjr08BgMgQ/wsq72Azq4vHRz9TFIsAVHxr7y2PKkedLxD3FwdhUKxdDVyFsFgkwwMIKsyrg8xYtSr08pXtV865hipOMTkFJe2FBahoW1wRg3V8yoF24RN04JoR6Fn5sNz69lYGdXoV8Tr/KxL4jYmdmFefhhtdbU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7752.eurprd04.prod.outlook.com (2603:10a6:20b:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 28 Sep
 2022 09:52:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 09:52:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 6/8] net: enetc: cache accesses to &priv->si->hw
Date:   Wed, 28 Sep 2022 12:52:02 +0300
Message-Id: <20220928095204.2093716-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
References: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0006.eurprd05.prod.outlook.com
 (2603:10a6:800:92::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: b20ad48e-b8e4-4594-ccd1-08daa13726b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmsPODow5cukO87P/VSe0ZPCGEhnxCKYUc+LD+HOIYJBEHfDqidFw5KS0/0eD1ASen0821uvhE6HA3RPOfJKsmJFTNDYLeasDiHeqp+DbzfSjkKk6KeFnd6bcmU0vUKAwVWTysgjBeQJoksI4I2oq35wbHtTwJwjlVBSbL5fqeh3yQM2CjFj2CwIycBLXAX3/OXOWAxJ8+R+ZpZwENtds35PyS0fK+e7uC0BN5tsht2SrxhL0VfHDPJp2nLQnNamDEO+SlQeuqubvXZc/UwxSZu4pSO2pt2WbeGy1m+i0ZZTHplbWmmSlYCSfG4Gn168i3kke8ZFN8dEi99otXMZLlFLJs0GQBQlLVUXKL7ezSwgzh38zqskZOQwLJdElUuUFWrhrEnDQVfiRNk4JqvfmLjYBm6Z6d6zq2znKtgfn7QK664um+7+mzAJfTFP+sQOLDHkC7YlwA2KZyy6QcqAR4HYj8WaZO1I6FqxDSawDTm+ijMtxsADCit4zzJj+bUmUM+LcPdZ7u0BhnvmLWpZKM8YuzPn7+d6r+D1SDXQkV7GWaM5Auy9iSCEBslV4gxhONBgmSGXGfZ1MLc2egFVlEbB9aVUOQaeRHvLIITFsmi3/6KyeacszPEJaoQNi5lNzbbMhnE6ROxn4ABCyAKZuQWYv8hrKtokF9wknAeGuCwVGtUI/1S/UFJsKczGi+5vsRW+EQeLcpymgrDNNm9YKhgWTk3GI9+MZ1miHVEOXosfBh/rFkqe8aBUu5i85FMkqAQ22iTpqX2e5sp1kcLeyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(38350700002)(38100700002)(5660300002)(6506007)(52116002)(6666004)(6512007)(8936002)(7416002)(2906002)(41300700001)(44832011)(30864003)(36756003)(6486002)(478600001)(86362001)(54906003)(6916009)(26005)(4326008)(83380400001)(1076003)(186003)(8676002)(66476007)(66946007)(66556008)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iRXmrmUmzlt2lRkl+ikoJLx8kma3BuSBWCbx31TU5+4U03xjXA5rWEcfNICQ?=
 =?us-ascii?Q?wAPhml7dSvnfWr9q+tYcy/CsUl8aE6uRqVUVGge73YVnGbVxlkKS1jbIldD2?=
 =?us-ascii?Q?K2IEW5j+giLykS2v9C33W3cDLb0k3xAifO1eDPW6t56QHKXJhb9V7H2U9zhx?=
 =?us-ascii?Q?3n/8vh1RYTJk/ara+1wqDIA/v0qT2Afvzo2aZe9UtKd/zUgF5qdNfO9M4OPT?=
 =?us-ascii?Q?Wat+RTZikF1L0R/YI0EGm6f6uP5zB+SBLm5MX4UTHG6b/zEu27rr29O0bCC3?=
 =?us-ascii?Q?77cJ/s2us1bzzOM7Zn40xsFmPHEBFlUg20Pxmfvh5H7mjmkGvK0zmNnBqsIn?=
 =?us-ascii?Q?OZar2LYvyuVZJ6284yqDp9AIBZKzn6TR0siAGhKzgbvh+FFc15v1G/sMPG6Z?=
 =?us-ascii?Q?ffMmvpquiWfL4hGlQ065+ia0JQE/4nCrcBC/Wl60Kf6xtNHUT0+IrJPz5yRr?=
 =?us-ascii?Q?hgwJxHiWgOKwqDcNG6oqgcDNPz/P0mLEqx9SWnaRcbtSW+/K7NVu5C9aRFie?=
 =?us-ascii?Q?0MRk1qFoOo6CtgB19SPAgIZp6ZAsAQM+pHKln1PHnBbclzwZCcPm1g1oc6gs?=
 =?us-ascii?Q?s9ib/9Roo53C5QzxUlbuA8udtQHUAdPVP3QVHQ3fBIMDeB/MdtBhLDZnRAn3?=
 =?us-ascii?Q?KpPywlHyAX1qcw4shjuDIbgsaNvsf30fpLUnAcYn6SwkS2wdlhZn7sHhPsz7?=
 =?us-ascii?Q?9ki6Y4mzAVBm7IRQrU5eupz5NIFPrvxLyhBee10P/x5HTSI1y9BfLHXJbmPB?=
 =?us-ascii?Q?DLgshPwTuxWBGrOtXgFAuscfE3ZziXV9OkT24lz2d7tQ81WtgoveEGl8EiRz?=
 =?us-ascii?Q?5U4R5L2aiMbd1sXmP0uZ+++bTmzhLyr1sOqZPI/I9QKhwXFF6t0WGue1jaf0?=
 =?us-ascii?Q?Fmx6L9dPB10h5mpVch7ojlXJk6ijV2hYkK/bpTeTbFK8tOAEVIuSeOhtG43G?=
 =?us-ascii?Q?ruE6QpnfBUa2xJiwOZujb7IskAS6Ww8YMecdu+gb6aBOKqgsJVPWtVFZprMd?=
 =?us-ascii?Q?Sv8r6Yu22ACJKcrhOLsYbbZr3+LpwCEehR0Xa7ID1+BtbW7A0vuHLK4gHPSO?=
 =?us-ascii?Q?FyJwblbBtnuEyyFWx261DcNkZxfZ83D+lQPy6rD/sVCYqCVsbeP3r3pyFjVN?=
 =?us-ascii?Q?rGf5416KWHYVi8jFol0w84HvIDZdWe60S4v4/eHNpBPGkTOzAkqk9o5AS3Gk?=
 =?us-ascii?Q?XJtFPGFGeCW4vZaDQNiQDprGevkUEBxpfm/6GNRKK1e5SJCMNtZ36Tj0Ifpy?=
 =?us-ascii?Q?rlc9ulfvMZ0iGPivDN78VCitlEct+Rh5LWdjkNlMCOx5weq+8C2poDbB3nTD?=
 =?us-ascii?Q?s4LhVdeBaJTDTYlyCDi8KG0WFQrHiz0p8RPmUHQbVnwJ7/25nv9Kn1m6Vaww?=
 =?us-ascii?Q?4EePP+yvh4KUXvDirXjI4M4J81vVV0VyxsK+Q1uwyBtClCHSAhfbFOf4TV2o?=
 =?us-ascii?Q?VCQhfENd/6PugKLza6dFl+eXXNforXmDS4+OKIOoIC+b0Lw16/dcomk5OWsd?=
 =?us-ascii?Q?S+yfSl5ftl5145IeXD0y9ZNFFr6ZQKSx/LZhZfrJ8zdjS473FmSeVsfBf90E?=
 =?us-ascii?Q?M1seGWXG9M9yU6WtzRXYJtRwYI78yckZGrlW5IXYqhBGPoiqyVKB6HfoXuye?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20ad48e-b8e4-4594-ccd1-08daa13726b4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 09:52:27.3033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KD2v8QS50UfOMI49/2+TGK36uulLYi5wVZyBo0uVSi7+ICNcsUMJBEsn2B7STwQAAWQeyYERAWMS3szhsDWN1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7752
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
v1->v4: none

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

