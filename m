Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796A167CB50
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbjAZMyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236109AbjAZMxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:53:45 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2061.outbound.protection.outlook.com [40.107.247.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5524F6AF6A
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uba1ZhNPD1Mrbyqecs6Y2wewwGFRg9osj0pQF0ga5Tpngp34QNyL++lExy+vl1IS3SS4hmmSOFo9CGIhQUFbeYm5TwCVNkaXARqNHYwe+SBk25KPbZBJm5g9QBa3lSEgQV7ShlaVjvpecsrzVBY5zqJh3iamRdCpo1kA07xBfYi9gt0UCEM81xe2gAY/Q58k4l2hOMFIxLewf4hGiaLIlIiN4GE4abSMB7w38VCQxcGfBqenUKkkk0E44bwPH3WZA/QXGpvEKxN7ZKupjSm4NNXOAQza0PkqklX8V0rJZzBT56wyWqnVk0exZFLZgK9v+wlOe3EVcy2kJZ+WdcxVUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5JBKcqgXxJcH4s0vq9BvOvBAW/G5dVWVtRwbazsL6I=;
 b=aS/ZN22t/F0wV5wOPGc9rXVRrKBkE3cso+RTjruBlQ18sC1QktSxC0l9WISvMJcmJJTyXkWK0NNLaKu/4bKC5QOoDnP4e7UCh6UdKY7JgFl4iGuZqrR+vbEnwkPfuVbitatibxTxsmAerX/ycClxrlSZceHZldaaqCO1BWPWakn6d3InXLrOmB60nRKXQqUNkg9Rgio02+O3CYfB0BAm+vJFwi2sYEXvsYSeG6wrMTKzwG+R6zqHYpjjxiZpWJ6IAvlDb9p9k2Hf0E73iV8vPBGr2jiHbNwK3GoHX7EFvW8K+6m7iVG/zgdbgA1eCAdr5qu0qEqhl2pnb812221vLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5JBKcqgXxJcH4s0vq9BvOvBAW/G5dVWVtRwbazsL6I=;
 b=k1efCfPryLsAmGTxmrhsfPwUH9wXsGi4uoY/Q0fpaUo0jg2X3C/lJqVtsyrWK659rQMcd5cfv/ZmC0xtjBnKXGU6kcJfUiaBZ++8axf6V8L2EzDTK6b4PDBmFHXa00mwDjHSrDiL3vCc8jIjy5heWZ8z5DUNMdJceaG5VbPF7xQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7795.eurprd04.prod.outlook.com (2603:10a6:20b:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 12:53:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 03/15] net: enetc: recalculate num_real_tx_queues when XDP program attaches
Date:   Thu, 26 Jan 2023 14:52:56 +0200
Message-Id: <20230126125308.1199404-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 6842246a-e9a8-44b8-13a4-08daff9c57a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ac+S85imtWtQOslBjBIQQtC5gfXxAiex2rPnLCITIu85J7D7G6JodoYaMoyQIAV0amClQP/n91qHOe4UCX5u2AJMEth5iByv6aXjAwV6Cm3shHi34HjGATp9l+84nVV4CbmHGVlXvh/BRHW5xHeeBxUtFFLSJ6aT0SlUCj/swABUuqHA4wfLssbaxkmghnKKaCrFGIcE8ejBOWwhXVWYgYXsijQnwrg1Rzsl98P1JYVXoCSiOeYF2eznDCPtOEUsTgvX8FwlPMmdOgQZKShO6CzxHPw4MRVrBbrL1ICq5h2TMQ7/g3jkFWT+IxY9nKNYl3QO+9Hx+BeSnHdneSJf9SxAk6l07Y2RQlGxw0HQx+aUakPz6Z2/V1ZtUVl1UsTiG6HTqNHsrq3E4DsUiuFP61EQuoXoFdHtLmiqNPlhPpsooVDwgck2gZa9LqkHHlbKq/OGIzdfpP/PW7uoiiH8g1mi658WqjCMOG/y99MoqrPlqN3rEFB4JgIj2kAMRPzaQzGhKcgX6FWx5sf+TOlUJuBPc+7SlWgF8TaeRgp/FUzuobOXJsVHxWfEx5oGLXYSIK3HKO2DcOG34ZmCmOqSJXN0tN42ga5nUBiP5UStkTLBRH4rU4w47hz2nF5XBaKeOxhY0BfNshsXLPEcCyAFYlsxUJ/agkqPx+5cU43nIiDepgVwJ3J9+AAhn/nB6jH8H/+rw++OAEU8OgFXCdH4zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(478600001)(6666004)(1076003)(66556008)(6486002)(26005)(6512007)(316002)(54906003)(66946007)(52116002)(4326008)(66476007)(8676002)(41300700001)(6916009)(2616005)(83380400001)(5660300002)(8936002)(6506007)(44832011)(2906002)(186003)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?En6oVgxty1OQW1d40PR+Kl4DmPPCTqi6GEItTDNdinaRtsDG+9oQIIp93uB5?=
 =?us-ascii?Q?5AWgAHi2uUT0uRbNMsBc0b+6dr73IEiOzAmX22oO7Tlrc5rG6qIp/g8eywij?=
 =?us-ascii?Q?xFZDEM4DOJYFjyOux73DoRMhNU7Tv8Mz4v5YMDkPtdVdbA0GWlIIKPBLTLX+?=
 =?us-ascii?Q?r2JZ8/Oro7X0qEEM/QTWlZRWykZjZjKo17zy6DJzh33a6hojxMJ/sTGkoteK?=
 =?us-ascii?Q?zPLTY6YgQ7xNDE9rGOXtjOznxBfMmVXU8K7KkAkzSKHC0SmPKwvoAFPl2/2N?=
 =?us-ascii?Q?RU4KSvFF+uEg5nsvb/RMTceY+ZIz8w0RlbVqXCKRMbaW2vlb4qv5KN+QjK2N?=
 =?us-ascii?Q?fSV6p3DqEnYKa1TVMC7g3FtiuCFlZAk8bGktJXpd/JqpbV65CSRtPFykIoxN?=
 =?us-ascii?Q?qvC8Fe2hlHJCzkVnZ9vHjq8V8qEP8cbrnfoZoNfB2KGVE3gM3Ty5yzq/FMNc?=
 =?us-ascii?Q?bfWRM1x665EqPghKL4S77OAuxfjhGMHTdelBhAb7p04teMwtuMkz6rxZdKx1?=
 =?us-ascii?Q?Ht1UzQogrSh3pJT057ZqU+8IU5XGgch6oRJ4lFk87VyNjOzCLqNGCDegSifL?=
 =?us-ascii?Q?ypsiGCMhQFBNOx8Q2dBKyA/FldwdQpiik6umAjJ4v0PPEp+0XKjt9yvhLgoQ?=
 =?us-ascii?Q?ETwQcXOY/b5w78QjCoRQVVWXsYApNnhP2Xh/ICKwvNk1ERArYyG6uCo0XQZS?=
 =?us-ascii?Q?Xda+8sSW86sULOtp5Ww7D0XdFLF5a3MlOJyR/AVuhIHywEMVYjNamkzFDFkT?=
 =?us-ascii?Q?GhSe09OigfuK1fyLGr6LhBTFqGyQ1akAZvyswhVZbUNJUCEAGXWvDt4+MmOU?=
 =?us-ascii?Q?Xzb9G1q0w72tm71j/GWEFBPBA/ckxrKuZ7kK5kmU3Gbh4SkUwTCWfDZGhrWy?=
 =?us-ascii?Q?Y1zn12zUTOTnVwnxRuHvteJhT2HA4OZAUYMJFEuzT8k5SNMKGr2kWdRvaMK7?=
 =?us-ascii?Q?GPKqSmBPb6wmYxpzFMN+MuE9r42u8/IO1CNbICh3FoFlyu2OYdvPjLU2JztD?=
 =?us-ascii?Q?+OFoaRIoMQQx90xxr9qb+4V045bOvMWThQEDertmfD+xXAimdY7xIOxH/YLo?=
 =?us-ascii?Q?7JpOw6KIbCAFFfhzitvwIEwVSNB8mtvZP8zRXehuFTw9aYxpUBnovVfFIamg?=
 =?us-ascii?Q?ocmmIpdffOGoSF7ecYzwFZnVowYe9vtMpYeG9OFnSQncTjgE3yK88JD9rZ+f?=
 =?us-ascii?Q?XS7JAbuK1/broucNrdXtQs+PDYTKaPQcx5Dr4VznUr+soWOt9dQPxh4qdiLZ?=
 =?us-ascii?Q?enzMhJskxhXILzGWjDUKbF6jl0mUI7l7NXxONhyPsxEJqhIkrv9J0CgwyDmo?=
 =?us-ascii?Q?PSYg4VOznd2QaveJs1uUucNnQRoMH+8R4YIF6xVXohqUU4sXCBOs0xnbY1Gx?=
 =?us-ascii?Q?11X9k+e6jX4mFKAukQrh/L9iL8YfF93mxpiQJzvd6ArslHnJNCyh7QsZ4iMs?=
 =?us-ascii?Q?9PN7KMDBWNm2bsl2n1llF6qboi9rWUTRsMhPb9ZM4HBQz5xIq9v3oyiYeZ8K?=
 =?us-ascii?Q?b9RI7rFF0m1hB22S2kKRljl6/+xbTX3kjOZzdpA2VU59ov3oSAqk6m7vQVkp?=
 =?us-ascii?Q?w3pBthW/2+oj2J7vuD4b3jiEgH1uqcItcwCCeIDolKAb/XR9R5MHUmLmWn+A?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6842246a-e9a8-44b8-13a4-08daff9c57a0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:37.8623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yozNa0CFS9N2aZao19W3Pjn5v1W7sLEtcj57jwH6diV/NH+w7Kklwcu2JA8x5mjy9M5nT3XCY4mUVD8OqzR2Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7795
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

