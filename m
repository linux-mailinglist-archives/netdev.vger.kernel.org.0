Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA664AEDEF
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiBIJZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:25:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiBIJZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:25:02 -0500
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-db5eur03on062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0a::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE0CE0AE452
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:24:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELBeKhGirdbX2wiWQ9YPLoTx0kitJPYARR0+avTYpx293OyDpNTJ2gUeMCgo712UE/bBcNPkU5tntMP+ltZmPht1aSQL7n4l5bnn4jqyA4jleZ54WZV5JFhsY9EcRYWdD+C3PxR+r4tSwDgolAfjzYN3Li53veQqP9CFcqdHa1b/1BWxRoYi09jKa565h+SgunrZjkqxQ9KhqmNSf2iygl+UHVae+YWz5K490VO66FdAGlbfMSxAlYXet9IPyA+Z7tpN2DQ4Xt/TjnGHdWsiCDzOIZmN8J4/hV2RkMY5L60RLzO06/4MVanY9n1VWEQ30Ha14wp7H7xxvyxpqo3dRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r8tw2PfGESWAy7OiggmN6W1fdruCW0dTTFhKxxgjdXs=;
 b=bhID3mB1DZXLKlEoF73uq1EJn17jOWX3mlik2wdobMuhF3p4PZm0HyRuZUIr+nvBy4xcWX59WOnAlaSvQY1mz/docpCT+KVjX1NERJMyO5BYrprbBI/db+SAWMhlVafkdvAGkpof6f8cnYLcDGRZvy+MMF+fzXn2U9Wd2bGjgP78iQEXXZzj+bACn3SHBrp/UNQLxTWy8F7Q4Q1YDw49SfzGR6RSTyCkmYf5qhaOmGvlpfxBLPe0rwI3RurBOS4I9ScBLV2MaOHTknnlyVeOG+ubVnwB+Yb5GR2Z1dN3VvmRGlSv1HlH3WM3GZty5QYss7YiwKWS22Hb6X3PkEY5ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8tw2PfGESWAy7OiggmN6W1fdruCW0dTTFhKxxgjdXs=;
 b=e8v5ay0VSQrCU9bKAtHpbSbaZsztIKTCvJRl2nmINY9wi/DjTpkgnDp9CP2Tefd/b0bC9QtkDkpMElazAdLSy7ERFk5uokE31+hsf34Aonm9WfFFN9hMEQKadjBZJHBVlQKuZxPpnBWd2tNS+GQ9RkhWQpuzOinUIDHPszrL9pk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by DB6PR0401MB2485.eurprd04.prod.outlook.com (2603:10a6:4:33::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 09:24:03 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%9]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 09:24:03 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 4/7] dpaa2-eth: use the S/G table cache also for the normal S/G path
Date:   Wed,  9 Feb 2022 11:23:32 +0200
Message-Id: <20220209092335.3064731-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
References: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0037.eurprd03.prod.outlook.com (2603:10a6:208::14)
 To AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df4ca472-7c63-48d0-b56e-08d9ebade9a7
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2485:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0401MB248570FF4A2104F8844926A6E02E9@DB6PR0401MB2485.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTYGraxb2ZlBCLe5ynSRoldsgKEe+YM1Jc+538yAuhJL+BDKkB5H1ivy7UvwdjyiE566HAiO5YLfb20mo/Ic3FwihUo8xEHGPmSdLWNCJrQfSEr6AaQcRoU60Re4BBlCIHmZZAEY6kknhCEXY5FtR0SwEEOrvPFKL31Wo/yatgZsnXhxnEsvvQyYwWvoJSGK0/WUqZRnIJ0ukaoBl5uLKBoWrSxzQf7izqNxu7eWKfyZCml9+WGaGUZvNNp3yRyGS/7wgHs9NzP1iWNTKCgsHWHahi3YRFjJ8dhkA4q4evQDagb+z1aJTFwDx4CoLUkH8l5op0h2j8M8gXXGBiy6eeoeshMVIunsydeZ1wGnoa8y5K0qflHN57GTf+fg+EvaTUBmh3pusRABH4l7rFs3zptYXfjSoAhxMFPiWIruD6XbAi1Uy+OYSLNx4cP3X6gvg+h/Xhx2oQ0HCDley9BZrYB5snuNhMe9wOQmUP9uaQbflPTofVTvvNLA4dfpLEZM0g8JppraHy9WdDR6HD5GQTRghyUiyvOxEU+a+pbwYHw3FcoHkaBF7C2hinTAXs9a5qQRHFEugKPJD4OZyTMtpeJno9MJ6euyS5e7QbT6+NW2riZngUqQ3fhKvcWbW/hVhatpcUnpkoRtpHBfCTzxSlbBVrZjOP+GjJeuLKpGnIX7jZnEekconUO9mttJZgEY2dwimsYchE4kEFhgMbofmFn6KRqLGOzzTYThDGeh7Ogv9X5fb3Q2M7Zbnd7EcVxo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(26005)(2616005)(1076003)(6486002)(52116002)(6506007)(6512007)(86362001)(6666004)(83380400001)(38100700002)(38350700002)(4326008)(8676002)(66476007)(66556008)(66946007)(316002)(44832011)(36756003)(2906002)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?djdVRiAY0qNWPahl2LeLjbPTnfur1zUBcxSjqw/zzAlALq1sRRpzEkn6rtw7?=
 =?us-ascii?Q?ac9gWSTAsWtiJhXmZDN30yCqAA4eb1s/iNkQEaX6HJE4+Hz4jwRS4DODV7Ag?=
 =?us-ascii?Q?zYpmNNpGPXirvFYfrN3t7rH/dcsBZCyQ+k0AztWaseb9/PCtay0UX3a0lXOP?=
 =?us-ascii?Q?j92roWK+tpgAg1TvQGnZrB8Ik+IvozvXk+w4sSgGap+MboOz7iaJXSkyAS0v?=
 =?us-ascii?Q?C2wNxJzrL67z60Ux/FjphHU3FxNvfCh/6ZO19ywkOwViRcVasNZ4pcrm/xW8?=
 =?us-ascii?Q?HO6Dn6Jm96yJkwcF3AzCVCPAhoDw2iYO49K7FVLmd8JEuFl36/6SnYRok4e0?=
 =?us-ascii?Q?nHwHV49g4tyqzcEF8f7czOKqmQQ0DuNuHxgo2ahXb2b6yf+1669xGF575enz?=
 =?us-ascii?Q?uJNtnjKDTItEp1SICv4AipPElyB5Qv+3SJOLhPCZhyJ+4WFIx2EtgdpiBusG?=
 =?us-ascii?Q?2n7vIkUyXjfmUIZykkxwMKbHfWbuvm4q1tnzH0yA6ZLGraVzieTJ5MuAiu4R?=
 =?us-ascii?Q?9BnhAhOK9qRjjvAxJ9v9Rt/b6tSXLMkCK29z0MTJ7KHDQhovMlRM/eR9Pd1c?=
 =?us-ascii?Q?cXfjzl/sMYM0nmqtR9ioZMa6x9Z0dLOphwzUIjhI9jcDA2ENG+j2dIIO2S9u?=
 =?us-ascii?Q?6dDRDlYCmke/+Qxn2z5z1VVbyk8xEw/I32kifR5ef3anUj4ePbw7AqdvbMaX?=
 =?us-ascii?Q?nN+/YfH5oZ6dc3TzlQNGwGYVNxPxxQ8/8lQpNIxeSrgImqcnyBVedAZFYUO/?=
 =?us-ascii?Q?JDZZQM9d9hw48ojitvP6Lddd1nJDl9L4YCA/YJphVs8MH9DpVg25NOIGPINK?=
 =?us-ascii?Q?vnbBNsgiHiL6vIoEvgYgan7gRs4ASD8xJQYsYZqWOXz2LxQ03IgXLA0co2b0?=
 =?us-ascii?Q?JPz+EoRriQLbTujofMAqPUK3piZF9tedNAubygTgK5XFTQeYUvYzkXCoocuI?=
 =?us-ascii?Q?7Kof1DeW+6dimz9sxZAmp0QFTPvXbIel9o/tTk5INW9T/aEyBmQskIE1j1Fp?=
 =?us-ascii?Q?ZkJ1C/jx+61DW8Z9hLX5F7QdSdGvLJmUoLqn6hgYyIjt8VBHzKv8GKoYfF5c?=
 =?us-ascii?Q?Q0ViB3KBPv9SRWcl7YPL9XCJKJYCOFAHsTRSTVyYFzxQF6Sxl2kN5AooPWev?=
 =?us-ascii?Q?W8Vu5kyPgEtxn26enUYbaw9BJ9L0zgOEUBIp7eDtqw3KOfiHQWCPi69OH0B6?=
 =?us-ascii?Q?yGWmp/tF0zE6YJR5fdcmmskSAYxg851ld6yEcxRse7Mxr7sD4GJNAtI01g9S?=
 =?us-ascii?Q?/IsnSbG7rJeEHCximzFnoxL7y0wWoqd+DIAEQUzE0zPR+0HyI0kuE1usIDXA?=
 =?us-ascii?Q?D63YSfX7Ptvt/vhcPms/LGbSefSgeAKyoGJCNJ8EsQHlhJU9OoaCmVvQHqhH?=
 =?us-ascii?Q?+RXmc7YnT2VIS/bCsCPYRabJopYFrFxQlWJw131lxTO0li2HeAVVADgOdkGU?=
 =?us-ascii?Q?1Wyre9GPBwU8R0QcAtMLQ4SvDhj0lljL2fVmgFOfYwdPtmVZi9Qqk7kfSW19?=
 =?us-ascii?Q?VlMtCCpqq7PF5NsOcAH+ZhecEd5w0L/wnwS+8sC8/rjduxEvdo9crwIK0/IE?=
 =?us-ascii?Q?D43aFH2JiV1nQSCrro7Rwg7yn5nnadYF+CAgzp+6zQAn2MU+fOQ96oESK6Aq?=
 =?us-ascii?Q?BYu2YFABbrAwIu20z2anae4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df4ca472-7c63-48d0-b56e-08d9ebade9a7
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 09:24:03.2837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjJHmWF1M/mVS9tnJnlyp7kgA9GEwqp1CvtSpVKIVdmphCtW1PZ7P6VlbZ8oWg9C31PYhbkrPskoTinkNjhzgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2485
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of allocating memory for an S/G table each time a nonlinear skb
is processed, and then freeing it on the Tx confirmation path, use the
S/G table cache in order to reuse the memory.

For this to work we have to change the size of the cached buffers so
that it can hold the maximum number of scatterlist entries.

Other than that, each allocate/free call is replaced by a call to the
dpaa2_eth_sgt_get/dpaa2_eth_sgt_recycle functions, introduced in the
previous patch.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 15 ++++++---------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |  2 ++
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 006ab355a21d..73e242fad000 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -767,7 +767,8 @@ static void *dpaa2_eth_sgt_get(struct dpaa2_eth_priv *priv)
 	int sgt_buf_size;
 
 	sgt_cache = this_cpu_ptr(priv->sgt_cache);
-	sgt_buf_size = priv->tx_data_offset + sizeof(struct dpaa2_sg_entry);
+	sgt_buf_size = priv->tx_data_offset +
+		DPAA2_ETH_SG_ENTRIES_MAX * sizeof(struct dpaa2_sg_entry);
 
 	if (sgt_cache->count == 0)
 		sgt_buf = napi_alloc_frag_align(sgt_buf_size, DPAA2_ETH_TX_BUF_ALIGN);
@@ -837,7 +838,7 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 	/* Prepare the HW SGT structure */
 	sgt_buf_size = priv->tx_data_offset +
 		       sizeof(struct dpaa2_sg_entry) *  num_dma_bufs;
-	sgt_buf = napi_alloc_frag_align(sgt_buf_size, DPAA2_ETH_TX_BUF_ALIGN);
+	sgt_buf = dpaa2_eth_sgt_get(priv);
 	if (unlikely(!sgt_buf)) {
 		err = -ENOMEM;
 		goto sgt_buf_alloc_failed;
@@ -886,7 +887,7 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 	return 0;
 
 dma_map_single_failed:
-	skb_free_frag(sgt_buf);
+	dpaa2_eth_sgt_recycle(priv, sgt_buf);
 sgt_buf_alloc_failed:
 	dma_unmap_sg(dev, scl, num_sg, DMA_BIDIRECTIONAL);
 dma_map_sg_failed:
@@ -1099,12 +1100,8 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 	}
 
 	/* Free SGT buffer allocated on tx */
-	if (fd_format != dpaa2_fd_single) {
-		if (swa->type == DPAA2_ETH_SWA_SG)
-			skb_free_frag(buffer_start);
-		else
-			dpaa2_eth_sgt_recycle(priv, buffer_start);
-	}
+	if (fd_format != dpaa2_fd_single)
+		dpaa2_eth_sgt_recycle(priv, buffer_start);
 
 	/* Move on with skb release */
 	napi_consume_skb(skb, in_napi);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index e54e70ebdd05..7f9c6f4dea53 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -493,6 +493,8 @@ struct dpaa2_eth_trap_data {
 	struct dpaa2_eth_priv *priv;
 };
 
+#define DPAA2_ETH_SG_ENTRIES_MAX	(PAGE_SIZE / sizeof(struct scatterlist))
+
 #define DPAA2_ETH_DEFAULT_COPYBREAK	512
 
 /* Driver private data */
-- 
2.33.1

