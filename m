Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91DF670E1B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjAQXwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjAQXv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:56 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2082.outbound.protection.outlook.com [40.107.14.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4AC4FACF
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDsYxBBy1q/oXOHg0dbF0xWvxojvDyb5kh92L1Rta4l/Lp5D0fnTLwToNRIMkEdd7iy95+Eqr2/lW5Xr66SoHmGO/orY8tGXUA9tqy64nYoWgndvaaFIqRAz2Od6akMlOynZuyDB18HILtdNwJHRj62Dig/vPgtmucPAQfkOl/Dh2ARUPT89m/ijDjSpIfDAZ7ZIsYeMzgkkMDBPBuIKGgEPsFO8z2PCdHVLrFRuGmnTJ7y122OCoW5gimp+12kaPlGtICp4nkaJl6gKkVVUuF/KBpihQj8ktkq4fO3ADnwD1NUwWFhRBCQfzj95GV90gai6WQAwCaDsVBS+zxbyLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rlAaXvlpOGNVDnJC/0HrnyhfRvMg3RdAHGyhRGv50kQ=;
 b=OVzlMjvzeTvSGpAH1+v0b/RxUIP6yJmVVfIHI//039javjd5iUePg5k0j60OMRgkZHKUw9fS9f6FeLhJoZrG7KWMlLsz+Dxai4Ywv1LN1MlzV6kXy45Q35IGueZNJrwhssspb6z7ZI1Eh0uNFdX6GiJuk/7n0EClJ8pIekPTc/BeAs9dbEZCRr7vAgWUX7OJhiWongKuQ389Od4Zw2a8ygDYMtkn46QEZQm9xltKhXO2SC5HDHO4aedrsIS/+JkyG5tojqwo3SooRHDVGQ1oEO9iK3AILx04rYklD74lfCO4g3zl+/tMbtSJaVEWwN09WoEkEW4b8scMLjnsakuvng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlAaXvlpOGNVDnJC/0HrnyhfRvMg3RdAHGyhRGv50kQ=;
 b=nDgJNIXoH8LFSukDU84qp+FlI1aTVBhNfoIAZRlilYYN/UjLldB1ysm68x5bQTMC8d4YwYmrcxFTIdCbzMJZdWYl2OnAZaDDXp6wFqME46q3FsMt0uJNQq76CB3+WYcbg13HfcNnUmAdBSwaXUNCYQ5gOYK+aG75a3x84qrcoAg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 08/12] net: enetc: move phylink_start/stop out of enetc_start/stop
Date:   Wed, 18 Jan 2023 01:02:30 +0200
Message-Id: <20230117230234.2950873-9-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 14b39b99-ae90-4360-a058-08daf8df051c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dY9Z15ezJHMyAXZd2oggTE/5A22P5sGTAEgI0ntBYDT03o+Gfu7QQUck7JGdFqX5COucLHTd3Z/2rHKLKInKDet23PBIKfTb+KHBjLyjbmtcE3Q9ArQDM6+5+jDTjS9YzPcAqHwfak2K4v1nAfAQBGUqvDXUBZXNGVHCQk7pwAaO51xY9SeC37x9PqnXUKQh/ZhlvUtBbAKUaw9A6MPRJyk13FHSTDvvVjAYCLCrcXBhDfXX2Re1GCtUQ9xi0pzYU/stttWtPjimDXhlXazSBa1I3WfsPtuAOliv40OphkdcIDrjKoRlL5UyffzdXNM4PPrerU4NNGfV5NOylcTHLYT+PdT8hSJsSWfWQWJwosPrAXiU2U04NZ1zsCmdncLZIUQgq0LUmXBRe9Il/TmXzd7b/ByelmmAW0mwaZinQdfJgpDOCC1X0B53s9fJpkGLwQEX628TqDkVDa1bjJNtbns8FE8SGg7LzugQ/HjhUzwlkRmSVuz7PRCoOYR1Mo3R/gUIKNYSjq1PM9UA2Brm1w2uFPh6ulLmtd4PTjDKJBTIo597OHoo+2Hl0uwt3ERq1w7rGcjCrElyV1HIuLT5KJekB2mZ+EQjEE+8zsFD5oq2FovuedxjtD3xmC/jiVi5Qo9hd7+8V5CCNSIFk90RHMhCT9Gfcu+wEdgLnzfkrl4VuAWrrqSoVlbIs7yD0UgroQdhopcUIVaNBj7A18Vhog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ur6JAYanNNvKeE4JaZLwSt2scGWpoa4xWw+uEguAlSNIPLyQnv2U+wPyigLf?=
 =?us-ascii?Q?0GV3gV3pHYgqp/gypY59qimhrtdI06uDXvul5qormqfsLbVFR87/NKQLGqbw?=
 =?us-ascii?Q?RRkMtuZmaiIFLgsygPh327AbChD6rQdYseem7OAqFHo63pGai7Q9qFIX7qG5?=
 =?us-ascii?Q?Dinto+ayUFy0tkSMm1C3OcQ2lt9fZHeMGlGCvwYGt3Dnk6rTm12xCWtpj2du?=
 =?us-ascii?Q?NjMI46KyAHvS51eWJjmZrjw8mplOTp/fsC02zc+63Hqnmp27unEldsVJUs1g?=
 =?us-ascii?Q?tJqQyI4rOjCvLFYfhIFSiNxw7MNK/2smAyT+zZSGa7BxffpLw1MlQ0SAUrse?=
 =?us-ascii?Q?dgMRh3vW/oGNe5G2PlTKpACDQyGunj+TREtMKA7ss+puMOxtde0cX2iiO5D9?=
 =?us-ascii?Q?p8Y0Fiom/1rZCrIZ/1UtxYvrE+x3RuFnZ+cwb4/ejQsiIam4V+LAa9Es8MHB?=
 =?us-ascii?Q?m8RvaRV2sHe1bIxB5GyGwT8z4p+6mkDs+psYCpNqpXqNmC53eKMNKUKSVURL?=
 =?us-ascii?Q?zL2B8OTBYHj3t91Qzlo4d9Awz7pYzoZ841IZRW1FFB+jYMZgtnZ0uQKOLIT1?=
 =?us-ascii?Q?6iOrPi9HsGgJUlx421MUJygbch04GoOW9yJQZGomUBm1ReM79UPwiQviZSRr?=
 =?us-ascii?Q?GMtIK9yjKjEiyyjIhQBvdyfczF0pJmFJISliePWy6h6di2Ct7vFndJZHmzqf?=
 =?us-ascii?Q?YrIn6GrdpXFh2t4Wq3ks23ADkNyymWXkpyfgaSqeat8+cv8roHlh/TP0l/GY?=
 =?us-ascii?Q?va8DypyHxMLHsormt2jyiZi4Ed/hiQq0oKjhACQMx15AxjsCVHz1DKwb/9Qz?=
 =?us-ascii?Q?Qcm0PCR9QdprVctOoEo0livaV4rDoFdoPUmZt22DRr5lP8xd4sSajPCdB9rI?=
 =?us-ascii?Q?I5AgWhBPlNsNXh4/8yUVjmHiLqWQEzVryqNllC+g7WKe9zD6vkazyBMzH2iv?=
 =?us-ascii?Q?jBwqHV3Lm+6zyZfJlpb1ZSe3Mr4dSF4JgHOxmIjsoGdufdrZmru73AJjsH9y?=
 =?us-ascii?Q?P/RnBNdtvsDrzM+qV8zA3OsZEfm2oBBSiHuVTImOn+VDlP2sEjKHe/OBYE5Y?=
 =?us-ascii?Q?I1sjZ2UAH1MtbnPnbkkgFxhmo3WCizeWZoRhUvKib2xuKZ0P3rgUbEDUj3gB?=
 =?us-ascii?Q?1oxLDSBTSIBpjZazyZ1OJsibcy+zKJCIDCKheEZSndNV7uQkxnDQiVQoILk5?=
 =?us-ascii?Q?J2av0d09rolrrxtzpdz+ZmODKWW8Y5hxDrIa/6pTy7NNv5rjgdhg/g70aoHz?=
 =?us-ascii?Q?GtMqwQupuCgfSSiBKaVkIZ+SjSF7AWMSo6w3QB2eCdtV6aGRpbKZllH5b3No?=
 =?us-ascii?Q?OXpEtPrfOAiz5bl9Spg6iCrecJGvmBOAFwirD2rweL1hMkL/kMiKQ0CVtPi5?=
 =?us-ascii?Q?/Gn0l9pwcMLG90trUK+GBhJ2Fr85YGntpP+z+TPQJ3HWE3Wpj3YFgpLMpPlV?=
 =?us-ascii?Q?yL+cJwhC2+fx/PYUV9CzvP3ZPAYvO+elru0pJQlgLWe3gsT6NHc7RGV/6KSR?=
 =?us-ascii?Q?V+jEYEnraz+WAXtWuvU+WEc/mDRbR9YL4fbrrkFOWg4iztRXZ+K0yAKH0NvF?=
 =?us-ascii?Q?ARdEPFINeAa806pjon2OSNvObU0gczOu9ZlaV+5m47JLBDInzqtnObkiHeYB?=
 =?us-ascii?Q?7Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b39b99-ae90-4360-a058-08daf8df051c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:18.8346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IREEyytnJFZatR6G9MzHmE1N3OnGmYLK/wLaPeDUwq5nLHMlXbgw7NtHsXaDYOYUPhhiqucPCbu0z1cZMzwOtQ==
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

We want to introduce a fast interface reconfiguration procedure, which
involves temporarily stopping the rings.

But we want enetc_start() and enetc_stop() to not restart PHY autoneg,
because that can take a few seconds until it completes again.

So we need part of enetc_start() and enetc_stop(), but not all of them.
Move phylink_start() right next to phylink_of_phy_connect(), and
phylink_stop() right next to phylink_disconnect_phy(), both still in
ndo_open() and ndo_stop().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 26 ++++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 543ae8875bc9..014de5425b81 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2322,8 +2322,11 @@ static int enetc_phylink_connect(struct net_device *ndev)
 	struct ethtool_eee edata;
 	int err;
 
-	if (!priv->phylink)
-		return 0; /* phy-less mode */
+	if (!priv->phylink) {
+		/* phy-less mode */
+		netif_carrier_on(ndev);
+		return 0;
+	}
 
 	err = phylink_of_phy_connect(priv->phylink, priv->dev->of_node, 0);
 	if (err) {
@@ -2335,6 +2338,8 @@ static int enetc_phylink_connect(struct net_device *ndev)
 	memset(&edata, 0, sizeof(struct ethtool_eee));
 	phylink_ethtool_set_eee(priv->phylink, &edata);
 
+	phylink_start(priv->phylink);
+
 	return 0;
 }
 
@@ -2376,11 +2381,6 @@ void enetc_start(struct net_device *ndev)
 		enable_irq(irq);
 	}
 
-	if (priv->phylink)
-		phylink_start(priv->phylink);
-	else
-		netif_carrier_on(ndev);
-
 	netif_tx_start_all_queues(ndev);
 }
 
@@ -2461,11 +2461,6 @@ void enetc_stop(struct net_device *ndev)
 		napi_disable(&priv->int_vector[i]->napi);
 	}
 
-	if (priv->phylink)
-		phylink_stop(priv->phylink);
-	else
-		netif_carrier_off(ndev);
-
 	enetc_clear_interrupts(priv);
 }
 
@@ -2476,8 +2471,13 @@ int enetc_close(struct net_device *ndev)
 	enetc_stop(ndev);
 	enetc_clear_bdrs(priv);
 
-	if (priv->phylink)
+	if (priv->phylink) {
+		phylink_stop(priv->phylink);
 		phylink_disconnect_phy(priv->phylink);
+	} else {
+		netif_carrier_off(ndev);
+	}
+
 	enetc_free_rxtx_rings(priv);
 
 	/* Avoids dangling pointers and also frees old resources */
-- 
2.34.1

