Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207B667DA96
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbjA0ARp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbjA0AR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:17:27 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2067.outbound.protection.outlook.com [40.107.21.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470D334302
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:17:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtch8Xt3tmH68Z6TLFGBBar0zXfMqRQadUxdVbD6BRRZ+SlMOBEdixPNL/wtlTZ9UVYnJ8iHPb0hBTrF02JmyYplxK3xp2Mfsiichr0gGXKVJV2KOK1v4GsSsshbHDuqr3YjE9tm5Ys6+7/CFE/cFIKychxGBg/p2fz4JgJAs1zwo36cBGu5j0F/AZcWXMb/JuETwZx7nh3kJehUQcLR8uMwsoYZ//u5eUg8CqVFzt5wWgu7C48Q5hiZbSyDHhh71qj2pBuxWWh9haWSiQVyH7CTvkKiBkXsZuXxFmlNWv1IVYQ73yocDe9MSu4ihzV7+2wRc/uqylKrpx+mffPAtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g2UBPkoKlegYzrvy+FGRjz4hE0P0YAoTQlo4ZkLgnq0=;
 b=kJF0Hohxhxqym4SDolLao0dmR5wPB1Q5hkXR5/K0Ljba6mbrBGnnB5+M++sp077NTygWfEuWOaONK74Oj0yBOWZJxBVH5xaoqwy129yOjVqJiDrlB3U0W255Cr8z1DmwcHB9sb/Eqy3RY0Le+oOwFLCJdfynHy2da+i592fsV5q/UU0ThD8X7fjgMTYXTZQDs3KZKn9rxlafR2sO7/KtvkZY972T5HtOy5/W4m+H7HHhjwGmHEUCZ+YGtbQdAhq0FmBPgmaadrsas0QQpmPNr1EbkYLKGx8iQChw7KIXeGg5CDT/ryT2J1oeHrYB2YCElX/5gETjTiMwRjJcWYqbKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2UBPkoKlegYzrvy+FGRjz4hE0P0YAoTQlo4ZkLgnq0=;
 b=U48Y32tkYM+YT3eUso8cJ9aROdrzb6PjAhz2u9JMFn0bG0Lz9Xo7vkFUMzFGJjZ0hAHXFSE7Am51IN2NbTxZhAJrFyxIBIh3GzvfK47GI77eyeMTAIcePFEjcSJ+AGUGR7CGlzRv/kUqgBc8055htApAVoKqB35Z2m4ZXn+0DOU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v3 net-next 03/15] net: enetc: recalculate num_real_tx_queues when XDP program attaches
Date:   Fri, 27 Jan 2023 02:15:04 +0200
Message-Id: <20230127001516.592984-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: d9efa8b7-91e8-4adb-9c45-08dafffbab0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ZTiYF/2i8RNdy9c55H3uC5k9v3xgi5rXSnnjDkIoUwojm5SbuMQTP7vb46NJVqxan1PPE3xZfigOEfZBGgXTDWod1d8UWv7kL+KJOhJrJ1rLys9qpDgbLgFOTNeqLzg5iMuoUQ6rBPLiJvqp6wH3hWK2LfbHAOAJCFiTIhlLiLvqQCNOLh9E5G0YRqMLdjA8VZNVi1qQIWd6WcpavkKJ26cq7m9aBOfCDNp2dFoG6OIy1Q7RdlfVtxu5Q2syKYCsRVHvsva9EA5d3lX70m89fDYYGPHqPunaJMpQ7Khs7Yx6C/OCGMqRwF3J2MHp/MNy2jXa5hf3w0Nd6qN4DzAl25V6tfEiWdKTLjD3tmFnZmYdhcJGTIJ3HZ3xAFeMpblyjc0Q/ZvifgkZraTHkmyk9IU68V27uAFReWbNIvgruR8v8c9tviHbjTPLW8ez+6TZrm5y2QDv0zcaQHy2mHdvvh3UYL1t3o0Ko7J0g0/9zkmj88DMHDDe3mdu7rMly3LUv0ItbG+/MPBT3PdsRhSuVZxg6wnEn1BqANYc4g20IzPGkdjrsM/7IMbXNg39t5fYToyFGJqjqKDSXYb+qiKkot1dAycJ/Ze0n2OQSDkeI33HCsPHSZin5uN0T7nzFWcW/SdD1ei1nxjsgOvCCnPqoMC3mfGlmE9FKN2e30e2sx4hYoB6MejBGMtlxKvTw4V2CbRvg7OhcnQWnqSdCUVWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f5PwazujxioijyHsmxiETduirO7zBW7KCHo8sr8/7kf/DwMZ/I8jS8A32G/z?=
 =?us-ascii?Q?fmYA8hAXPKdYtqrJRLgmYGQtcS4r92rtmNtDWium1QcfZSsI8x0FvqNAZVie?=
 =?us-ascii?Q?xnrGCFcGimEqTS40wDcml2dImzB+ueMQkj0ANcy5j0u/qxA3zOGxWzdeh5We?=
 =?us-ascii?Q?7js7XJsHb1cd+vWCFKr9c45wGPXIqjrRq7WcCrfRfoYMnSjN00da6eT4dXJH?=
 =?us-ascii?Q?lPiEM5eYSvgCEGLQRVPRwm30cQnAiLIWaSTaviXXVyZp5vVOXQUpqjK2BoHf?=
 =?us-ascii?Q?S561/5euw03nWG7z71dsINMkaW51URhfd0MH0jQn90IOZWzHR90XrJ9LJXea?=
 =?us-ascii?Q?YWsKpGcXopFM8NnfELu6yjt5WLw8uL7JJPvWcKg7kLyNqC7J9IBbJVed31mQ?=
 =?us-ascii?Q?GFmhaPz22UtLEZVXNr1cGN9A3qdN2WuAtN/fxyN+atvWqKioadv0Gr1yXu6J?=
 =?us-ascii?Q?fOIRyQsBAfCPJ4uD4rZXgdxDRuZHJ7uhX4GiVd0qGNCXpuc+gZDncgAmx5Od?=
 =?us-ascii?Q?QBzvLNYFp03YAk1y2afx3rTaPI0ivSdXMKpApPFl63zWGQjX+teLFL1Sbrcg?=
 =?us-ascii?Q?yTnUag4xh+kPxof5HfA+kWqPRrgMNECo6Gi6GtkgZPm2rknipu4NyGcJats1?=
 =?us-ascii?Q?TJiUniET4Vr5KCLNKJMc+QXeT3z8C+Ve0AtBAdRrCOCPL7R2ffKUHY77hBU5?=
 =?us-ascii?Q?bwiz8HikFoiTyJkj6Cipebd6PovgpUS3yhTtgAu5Cui+S92TSYI8nWa1ZNxh?=
 =?us-ascii?Q?6IcZJKQ3XohojvwvDmzeLK53ZCxfEeyOwLaDDpcKotOzqd/o3TTv7K0euhah?=
 =?us-ascii?Q?tsCbZfy5hzZvrGCdzxAiCz6pp7BanZpt3vPo0NkjRSyxjGAy7W+uTS6Orm+X?=
 =?us-ascii?Q?pKQGiglmt6nQ18OsrXfOyaexDjeQUsmWBLB5wkvhlfettPQ0xxP1xOCuv0Tw?=
 =?us-ascii?Q?0+Q035g8USUlK+0R2WCaviaBbHUQG4OnON7JwV3fpNzaP+xtYLWZ2qYSswbY?=
 =?us-ascii?Q?hBAl5D2Ezmn1catSJOVMi2S9c9+laY/t9eideoLwT0cRR4PIzWV87SkHxidk?=
 =?us-ascii?Q?ZqpW3T0MMyScr70L0WycDme2tIG9iE3niRe8nXb4725Cp6atnI9+Vz8JPZOI?=
 =?us-ascii?Q?2ZNNnqublMlOsomjEoRsIsuLRnEeYfyHuHxUFOt0Lx+wzwu/9CnkTgxE/T6l?=
 =?us-ascii?Q?pN30sIGOvsvbodCHG9GZ4fWoL1BpDmtlML1qvkPzC7Zm80iI4k2tjwxhEoRc?=
 =?us-ascii?Q?GBBe15zikFnDABmlL4wgnjv86Fi+fb+Wkfb7Po3sg9G9SJfISLH58iuHhEHh?=
 =?us-ascii?Q?3KbU2TNjeLAkMaRjaPZ/zSZw3V9KdBfspGdPrGtlH4t9BVST3hgNZqP9Ve/E?=
 =?us-ascii?Q?hk8Hfzl3yJzwmHaYid34w6fE0FSWcLRKd5PDViNJQmknDWZ8cxYZ58qO29Us?=
 =?us-ascii?Q?i6e7Nb4y3LczckUhHPCgMxO0HY3RLytTfF9kloJPLkAF1dCyGGeLSX8mQDx9?=
 =?us-ascii?Q?E5h8YPtx/j0McH8wCEJvg/CaUGu6tvEXSYC3gdSSE92dLaaj3lGXDc5ollJN?=
 =?us-ascii?Q?t3WQ6AHWEA/mvw7qXz9CBS5KzvGbTnDbUdLJTHW9r5+RguzYLN7NH89oB211?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9efa8b7-91e8-4adb-9c45-08dafffbab0c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:15:59.9513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMoVpiPUEKkH9DJpnD5DEW9HIh1FdZ/IyH7qys+wxJoWWRvXCST8tecT0ido6xF/JofJ5T3oLX5+/aeOMg2Y5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the blamed net-next commit, enetc_setup_xdp_prog() no longer goes
through enetc_open(), and therefore, the function which was supposed to
detect whether a BPF program exists (in order to crop some TX queues
from network stack usage), enetc_num_stack_tx_queues(), no longer gets
called.

We can move the netif_set_real_num_rx_queues() call to enetc_alloc_msix()
(probe time), since it is a runtime invariant. We can do the same thing
with netif_set_real_num_tx_queues(), and let enetc_reconfigure_xdp_cb()
explicitly recalculate and change the number of stack TX queues.

Fixes: c33bfaf91c4c ("net: enetc: set up XDP program under enetc_reconfigure()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 35 ++++++++++++--------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 5d7eeb1b5a23..e18a6c834eb4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2454,7 +2454,6 @@ int enetc_open(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_bdr_resource *tx_res, *rx_res;
-	int num_stack_tx_queues;
 	bool extended;
 	int err;
 
@@ -2480,16 +2479,6 @@ int enetc_open(struct net_device *ndev)
 		goto err_alloc_rx;
 	}
 
-	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
-
-	err = netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
-	if (err)
-		goto err_set_queues;
-
-	err = netif_set_real_num_rx_queues(ndev, priv->num_rx_rings);
-	if (err)
-		goto err_set_queues;
-
 	enetc_tx_onestep_tstamp_init(priv);
 	enetc_assign_tx_resources(priv, tx_res);
 	enetc_assign_rx_resources(priv, rx_res);
@@ -2498,8 +2487,6 @@ int enetc_open(struct net_device *ndev)
 
 	return 0;
 
-err_set_queues:
-	enetc_free_rx_resources(rx_res, priv->num_rx_rings);
 err_alloc_rx:
 	enetc_free_tx_resources(tx_res, priv->num_tx_rings);
 err_alloc_tx:
@@ -2683,9 +2670,18 @@ EXPORT_SYMBOL_GPL(enetc_setup_tc_mqprio);
 static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 {
 	struct bpf_prog *old_prog, *prog = ctx;
-	int i;
+	int num_stack_tx_queues;
+	int err, i;
 
 	old_prog = xchg(&priv->xdp_prog, prog);
+
+	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
+	err = netif_set_real_num_tx_queues(priv->ndev, num_stack_tx_queues);
+	if (err) {
+		xchg(&priv->xdp_prog, old_prog);
+		return err;
+	}
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
@@ -2906,6 +2902,7 @@ EXPORT_SYMBOL_GPL(enetc_ioctl);
 int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
+	int num_stack_tx_queues;
 	int first_xdp_tx_ring;
 	int i, n, err, nvec;
 	int v_tx_rings;
@@ -2982,6 +2979,16 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 		}
 	}
 
+	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
+
+	err = netif_set_real_num_tx_queues(priv->ndev, num_stack_tx_queues);
+	if (err)
+		goto fail;
+
+	err = netif_set_real_num_rx_queues(priv->ndev, priv->num_rx_rings);
+	if (err)
+		goto fail;
+
 	first_xdp_tx_ring = priv->num_tx_rings - num_possible_cpus();
 	priv->xdp_tx_ring = &priv->tx_ring[first_xdp_tx_ring];
 
-- 
2.34.1

