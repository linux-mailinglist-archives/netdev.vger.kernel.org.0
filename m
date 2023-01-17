Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A86670E21
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjAQXwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjAQXv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:58 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2042.outbound.protection.outlook.com [40.107.14.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95E34FAD8
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4V1oqcpPHQFFHeRbZAWOyPvKaQSRzsXODlyf5iNqOpiQnTUzyJHKo6IpiVR21WU/Jk6cckFcET+yteWwhu6sQgGiT2vEnNDK0Tn6sks1BHFqMZckGdoIAzBKWZ4gevzRyERFAvXhtuxnxtandaQ1zfH9EIKhptOzct+zndjCUtT6XT5TekFX1cwJuik9n0H7fhnptTjGExQxO930ov0211bA1/UHKfAHkzwhuJVVyko4MUERcbXReAu4lDwdcLx0tx3gBe+NkVaU+m1eqsLnbgR7oOfxuwYKehMwjG9SE0iT24PqA9OiO6P4GDrc/ywHf3OE/1x0VO3zhocI9F0cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SrzvWiUk+AocoKkir5Vt3RTpFIDW7OGLnaaLVLqMp0=;
 b=ZRjxS7qke15AfHf5BFfvopauAbKR4jqGQmGHxDxuQgBlHKDLXN6gRfNpYJZxwwvOdki2jUgKQm1iVNrLuyuV9Amyl9e3+bApgIFI6ZpAJ/XzknRHYJkI079eqeklkoRZ1C3JT8x+vRuD4x5qwpQQqL97k2nu01Z8Fj40T6TQl3zL9BLyC+gQGVmi3X2A+XYH8WLJQzAbtyYy975/1OlV9lJkbqpqASxeij52SwJ5rJ7Nk/q6xcd00b2Jg9Ev6GbpzWigGnvcwU2o8It9Fof5ry70xhnkYQ/a31IL7YBJgIYY0WczZuJodgSWgPndYj4SYbY5rUhl4e/xd+oMdLGJ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SrzvWiUk+AocoKkir5Vt3RTpFIDW7OGLnaaLVLqMp0=;
 b=ZtojJk63rNqcGID1etuxqtMhZMV5LNSxk0L0yi//UNpsAF2LO/7IJjsN2qp+k33AMPrLuL9UK2kRdGe2A1ss6Z9Zka/WcjSDk1SDsDp6NDD7F9QpTHN+dv+iKpVWN5ej80erQVgvHLI0FWbTyzTCZ75U4A7ySyr/frXiO7t8Xg4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 12/12] net: enetc: prioritize ability to go down over packet processing
Date:   Wed, 18 Jan 2023 01:02:34 +0200
Message-Id: <20230117230234.2950873-13-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7e29bcf7-966d-402d-2f3c-08daf8df0866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZsDLfO8xyNMopRQQ7eMns5l2ysu/47J+aHrvdPfFcKmhvkLl1a6cJE9sdrEiJWVOuhGdRT92GvBBewGNmAcjv+ogLAVKQaA913AE4uZwRIejX9a8c0ABem5ZqVeoVGE2TzzAyNwwJpwTAfxmHmON84lO45XSDbgKYedjD+bkG9oyXyr7ecDEw3u73fygfrvXwmggXrNrD8Jkdd+LtI2LRJnCP8wF6i8zSbMAx8TMc83XJ54HeOPRN/7yqzPJeE/IRM/m6lB5kIi3qE+gF/2XHokyfALm/jZfb8z3DlDwgGJYzI0vIaZaGjMg61xBitLloE3iWA4iZbv4Kwk2pcaAL0slD0jnDXxLA7vvh3swdX3SirQcHjv65V19pUHd/qERLAsWaPcHM7Y6jaMlGW9PTyXrEZc0J51jroZaSTREJphzPNa5QgmPvzxrQHFqYBajObXd5u6LxQpmEQw2Gg+h+wEnag2fQTuvP8bJLpbGPYhbpZllDQbl2Nk6FsA9SVNWQ0GGZwEaTM3bqrYq1Dd2i6IiNdDF0w+78XrC6J45UL63O2Gan3bgKNBkgyrxflOsWW+rNFmo6KhNCb7ORxzRsM2/IoXilSUlDwv5lTUuhk0O9fsVSlpFkkiqN6wp+gnkcsOSkY71kNeqJVM/xGI7CatW5lAh9dqZ6fBqea4eVH4BCn8pV1BZD4VyroAKAQ47M+8ttRBbnHn7UAz8Z4/Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gWSGnp7FRvyXVHkstKnj3be9awG4Rc+gxGa1CWqyD7ahtKsXRnFfTNtmh80t?=
 =?us-ascii?Q?lW+yPgwNckqoC8eOmgAyvhvsEnQq9E5H2SFysqhH/Sbd4qkfgA52zr0QNx2u?=
 =?us-ascii?Q?wjEP9XnfyXNSaPcQwhpknyL75o4nKdXub8V2tDJbkIk4yicnLzEZJUHTCwb8?=
 =?us-ascii?Q?VzKtY75RaA/Z5Z501ckBBx6jJvTqv20Y0vToHIGvGZyrDjscN03R3XB3114p?=
 =?us-ascii?Q?vA64N4GBlYDHpHy+UyhCohYCxs0ygGbJFYb3A6DngwiEmpJt5sN3NdJ/Q2lP?=
 =?us-ascii?Q?0j1ZOJBnT+ZWFFk5z4MhPN0QCA3bBJfkd3c3k+MURrp2Y8ZmN3NuJtid5WxP?=
 =?us-ascii?Q?8cRpEWpEAwBsJB/tTdHmxozdY8yE+lWDygaYsDqKUIxDqJioyzkKWVMp9S6L?=
 =?us-ascii?Q?F68bZ7moCbjsJZ2fv7QLbAng01zKSjGWjEv5zMUfO0RkiZYTabXZ1Aw1K6vr?=
 =?us-ascii?Q?tQaF1DIi22b8UL0w49UjUTNOQJyMTxFgrRDEld1Gel9YyixYEl9V+hPFOEDP?=
 =?us-ascii?Q?qo6pFKafMunxi1Z4mft/0ga1KdOe7it1OWpzOMT8VEqbuVDRhrlp3zswU+5f?=
 =?us-ascii?Q?YKEu8t/R34UQ1t77r4pq53sHCPAiVq3J9wqCwec6vHd17VsuPhNquopyugOS?=
 =?us-ascii?Q?Jk8anRtuCbPbzXHaDIjRKM1YdzQ4RVlFmyLpNwu7OhuhNIoxgFse1sXJdzFF?=
 =?us-ascii?Q?7+3YSuuriYTRRODr99ZzLgge7GZq6y49B9i1ec8WKujS7PYCGRoEKe1Tsib4?=
 =?us-ascii?Q?IAbO+Gaj/rrUCpfvZ9KeRGL/91mlpZq5D8a5kFlVnHBxc/qCU8B8xTtteGCy?=
 =?us-ascii?Q?yTZdLe797FffZJMz1Xzv7hhT9Io7xsmg0iXrc8HMsncFg+euDfJ+7tiVIC2L?=
 =?us-ascii?Q?/MR/ZJ/LB7tLxbKFPW0uR/8r9n+rbFN0I6LzAwB4NWGTLpq7BAcdMYU4ad1Y?=
 =?us-ascii?Q?k+ii5ykVHB+TsNBTZfj70GP8BsGHeFixS+8tQl6j55q6geNs023tcarUpJKJ?=
 =?us-ascii?Q?5fz8obvNWLaXmdDYAMWo6y1HnHkERFvmlAys+m+8RmnXQ6BxUujht42j55GI?=
 =?us-ascii?Q?r/JepmYPXEj9phQSXKN3NNxzvzXuG33i10w/jw7JMZbRdvHG/rKZ3VbYSZqw?=
 =?us-ascii?Q?5RUL9H+45qUe51kBeoyMOvYpafNGUZlOzJQnsx7Ozjxm5K9utGI8NMiW/p5Q?=
 =?us-ascii?Q?G8RpcyltBXOI9xf54iIiAKFZpZIZSPo5dgsMmmc6sLW34DY0T7waCFRu9d4+?=
 =?us-ascii?Q?lb31DdLv0rZ3AFlQ+sFuUMgp3RFyM7hcYNzOtRiYxqIQgH8uZMHkBa5vGaSZ?=
 =?us-ascii?Q?Q94RjX6J39q2vaksL0ZuJxkJV4t0yTvy4E616kET8S8QDAXDVikwqLxeUiSi?=
 =?us-ascii?Q?9tC6C5wwRL+OdF7yYivFXqjGVGq4O9RU4peHhb6DdRnoQSG7hX2o73KstT6o?=
 =?us-ascii?Q?GCUnsV75krQuGjcbdJQZw7yYZ2fcOdtfI/2Txl3XwQZrsLwYW8ffhpbDpZP0?=
 =?us-ascii?Q?xv2C/RMPntqMfSbtqEionUPdTR3WW/7E3o5kymEeojw13LEs4dcT31n469zx?=
 =?us-ascii?Q?HXhNNCnCBYpb4RayPe5OwSmRDPbLfMIaUKJRIXZGQ+eXkX8l6kgDWOYBr5WR?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e29bcf7-966d-402d-2f3c-08daf8df0866
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:23.4593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RqyNNvH98xScv52Tf/3ajKp/Qq4MOaUvr8CMH2SnotltCz71g9kXPDW+OF+CM/Q7kfsneVgGu0Bl8FA6foBwaQ==
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

napi_synchronize() from enetc_stop() waits until the softirq has
finished execution and no longer wants to be rescheduled. However under
high traffic load, this will never happen, and the interface can never
be closed.

The problem is the fact that the NAPI poll routine is written to update
the consumer index which makes the device want to put more buffers in
the RX ring, which restarts the madness again.

Browsing around, it seems that some drivers like i40e keep a bit
(__I40E_VSI_DOWN) which they use as communication between the control
path and the data path. But that isn't my first choice, because
complications ensue - since the enetc hardirq may trigger while we are
in a theoretical ENETC_DOWN state, it may happen that enetc_msix() masks
it, but enetc_poll() never unmasks it. To prevent a stall in that case,
one would need to schedule all NAPI instances when ENETC_DOWN gets
cleared, to process what's pending.

I find it more desirable for the control path - enetc_stop() - to just
quiesce the RX ring and let the softirq finish what remains there,
without any explicit communication, just by making hardware not provide
any more packets.

This seems possible with the Enable bit of the RX BD ring (RBaMR[EN]).
I can't seem to find an exact definition of what this bit does, but when
the RX ring is disabled, the port seems to no longer update the producer
index, and not react to software updates of the consumer index.

In fact, the RBaMR[EN] bit is already toggled by the driver, but too
late for what we want:

enetc_close()
-> enetc_stop()
   -> napi_synchronize()
-> enetc_clear_bdrs()
   -> enetc_clear_rxbdr()

The enetc_clear_bdrs() function contains not only logic to disable the
RX and TX rings, but also logic to wait for the TX ring stop being busy.

We split enetc_clear_bdrs() into enetc_disable_bdrs() and
enetc_wait_bdrs(). One needs to run before napi_synchronize() and the
other after (NAPI also processes TX completions, so we maximize our
chances of not waiting for the ENETC_TBSR_BUSY bit - unless a packet is
stuck for some reason, ofc).

We also split off enetc_enable_bdrs() from enetc_setup_bdrs(), and call
this from the mirror position in enetc_start() compared to enetc_stop(),
i.e. right before netif_tx_start_all_queues().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 81 +++++++++++++++-----
 1 file changed, 63 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index eeff69336a80..6e54d49176ad 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2088,7 +2088,7 @@ static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 	/* enable Tx ints by setting pkt thr to 1 */
 	enetc_txbdr_wr(hw, idx, ENETC_TBICR0, ENETC_TBICR0_ICEN | 0x1);
 
-	tbmr = ENETC_TBMR_EN | ENETC_TBMR_SET_PRIO(tx_ring->prio);
+	tbmr = ENETC_TBMR_SET_PRIO(tx_ring->prio);
 	if (tx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_TX)
 		tbmr |= ENETC_TBMR_VIH;
 
@@ -2104,7 +2104,7 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring,
 			      bool extended)
 {
 	int idx = rx_ring->index;
-	u32 rbmr;
+	u32 rbmr = 0;
 
 	enetc_rxbdr_wr(hw, idx, ENETC_RBBAR0,
 		       lower_32_bits(rx_ring->bd_dma_base));
@@ -2131,8 +2131,6 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring,
 	/* enable Rx ints by setting pkt thr to 1 */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBICR0, ENETC_RBICR0_ICEN | 0x1);
 
-	rbmr = ENETC_RBMR_EN;
-
 	rx_ring->ext_en = extended;
 	if (rx_ring->ext_en)
 		rbmr |= ENETC_RBMR_BDS;
@@ -2151,7 +2149,6 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring,
 	enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
 	enetc_unlock_mdio();
 
-	/* enable ring */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
 }
 
@@ -2167,7 +2164,39 @@ static void enetc_setup_bdrs(struct enetc_ndev_priv *priv, bool extended)
 		enetc_setup_rxbdr(hw, priv->rx_ring[i], extended);
 }
 
-static void enetc_clear_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
+static void enetc_enable_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
+{
+	int idx = tx_ring->index;
+	u32 tbmr;
+
+	tbmr = enetc_txbdr_rd(hw, idx, ENETC_TBMR);
+	tbmr |= ENETC_TBMR_EN;
+	enetc_txbdr_wr(hw, idx, ENETC_TBMR, tbmr);
+}
+
+static void enetc_enable_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
+{
+	int idx = rx_ring->index;
+	u32 rbmr;
+
+	rbmr = enetc_rxbdr_rd(hw, idx, ENETC_RBMR);
+	rbmr |= ENETC_RBMR_EN;
+	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
+}
+
+static void enetc_enable_bdrs(struct enetc_ndev_priv *priv)
+{
+	struct enetc_hw *hw = &priv->si->hw;
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		enetc_enable_txbdr(hw, priv->tx_ring[i]);
+
+	for (i = 0; i < priv->num_rx_rings; i++)
+		enetc_enable_rxbdr(hw, priv->rx_ring[i]);
+}
+
+static void enetc_disable_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 {
 	int idx = rx_ring->index;
 
@@ -2175,13 +2204,30 @@ static void enetc_clear_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, 0);
 }
 
-static void enetc_clear_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
+static void enetc_disable_txbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 {
-	int delay = 8, timeout = 100;
-	int idx = tx_ring->index;
+	int idx = rx_ring->index;
 
 	/* disable EN bit on ring */
 	enetc_txbdr_wr(hw, idx, ENETC_TBMR, 0);
+}
+
+static void enetc_disable_bdrs(struct enetc_ndev_priv *priv)
+{
+	struct enetc_hw *hw = &priv->si->hw;
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		enetc_disable_txbdr(hw, priv->tx_ring[i]);
+
+	for (i = 0; i < priv->num_rx_rings; i++)
+		enetc_disable_rxbdr(hw, priv->rx_ring[i]);
+}
+
+static void enetc_wait_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
+{
+	int delay = 8, timeout = 100;
+	int idx = tx_ring->index;
 
 	/* wait for busy to clear */
 	while (delay < timeout &&
@@ -2195,18 +2241,13 @@ static void enetc_clear_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 			    idx);
 }
 
-static void enetc_clear_bdrs(struct enetc_ndev_priv *priv)
+static void enetc_wait_bdrs(struct enetc_ndev_priv *priv)
 {
 	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_clear_txbdr(hw, priv->tx_ring[i]);
-
-	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_clear_rxbdr(hw, priv->rx_ring[i]);
-
-	udelay(1);
+		enetc_wait_txbdr(hw, priv->tx_ring[i]);
 }
 
 static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
@@ -2381,6 +2422,8 @@ void enetc_start(struct net_device *ndev)
 		enable_irq(irq);
 	}
 
+	enetc_enable_bdrs(priv);
+
 	netif_tx_start_all_queues(ndev);
 }
 
@@ -2452,6 +2495,8 @@ void enetc_stop(struct net_device *ndev)
 
 	netif_tx_stop_all_queues(ndev);
 
+	enetc_disable_bdrs(priv);
+
 	for (i = 0; i < priv->bdr_int_num; i++) {
 		int irq = pci_irq_vector(priv->si->pdev,
 					 ENETC_BDR_INT_BASE_IDX + i);
@@ -2461,6 +2506,8 @@ void enetc_stop(struct net_device *ndev)
 		napi_disable(&priv->int_vector[i]->napi);
 	}
 
+	enetc_wait_bdrs(priv);
+
 	enetc_clear_interrupts(priv);
 }
 
@@ -2469,7 +2516,6 @@ int enetc_close(struct net_device *ndev)
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 
 	enetc_stop(ndev);
-	enetc_clear_bdrs(priv);
 
 	if (priv->phylink) {
 		phylink_stop(priv->phylink);
@@ -2521,7 +2567,6 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	}
 
 	enetc_stop(priv->ndev);
-	enetc_clear_bdrs(priv);
 	enetc_free_rxtx_rings(priv);
 
 	/* Interface is down, run optional callback now */
-- 
2.34.1

