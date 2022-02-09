Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1783A4AF1B5
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbiBIMdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiBIMdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:33:18 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F4DC0613CA;
        Wed,  9 Feb 2022 04:33:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5mvOEUdbWJeYURSrrmsVu5NVthf6dtrg82AvPwtTUXYGhpK5aQbHD6nO88fC7H8gy4Hby75DpIaOD2V9y08EbRIMABABg5mX9yYsDP71uwPcXVLYINHj412yzcvvkfVDcSN4TEhC6aS6Vk3RQiSf1IgmMUnUmJJ4IPLmKskaLX1WZmVPPOYdXwy21y72gc4nvLXtjktmPP/oYI4tkHUzHXsAN/uXrq0cQDmrerprC8xGHJdJQaPQW6TDu8qTSHNrF5TzZD+l6hVwj683kjjsqH76yuW4+weoxRKnp1aQUlz9PBkEIq956h75l3HOolaRS7hP9A1F64YoUHw8rwmKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYamgCQq68gxF2Lh81YHHZ6xA01t/JNHlApKH4CQ8kk=;
 b=iHI9TOmw6rAHrXFByNjsmrWGMNNoPQtxJL7iUxNU8fYDm5Zh0TOKdJ0rpz7LrzuAPEY1E+yEGlWyVyAJ/coR1HHPE+cKF4LZQyKdeYjmuz4up6aJBBJ+EeU9JgD2xxA4hpUSp+m59Ms7jbMiOkAJ0veydpQB/AzkTtJHH6oNoKlur7g+IaPzPrJfUGo+nKffvTvktdjxcChBJi/K75e6s3/ZunnEWi1RLQlUM3MjvWmqoBrD/LsAmmMx0tEvH2yf2m2o6OFbRkGQjE4bDjmA9AYIokS8Hi/33OSjaWp9h+D6sAzv2wedX4o3IR/Pk1LTxZeBcQsjNswQbpO3aK1kIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYamgCQq68gxF2Lh81YHHZ6xA01t/JNHlApKH4CQ8kk=;
 b=Hi1blzSzh4yT1VZ8ToTp5mO+kxAJQPtWp6tzY/IQm6tAq2Pz2jBTQRlntTwqdqp9LpS/jIIFNNcF9wK1uWxbbBVMmza9lLoybG/tn6i2UaiJI2wDT9ANj8+4LlrO8C3sa2V4XLgguMDqJy6QWJkQaeRIvnNRfbscLkLTPtiXZDk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com (2603:10a6:10:1f2::23)
 by DBAPR04MB7398.eurprd04.prod.outlook.com (2603:10a6:10:1a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 9 Feb
 2022 12:33:15 +0000
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::a012:8f08:e448:9f4a]) by DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::a012:8f08:e448:9f4a%3]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 12:33:15 +0000
From:   Po Liu <po.liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, tim.gardner@canonical.com, kuba@kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, Po Liu <po.liu@nxp.com>
Subject: [v2,net-next 1/3] net:enetc: allocate CBD ring data memory using DMA coherent methods
Date:   Wed,  9 Feb 2022 20:33:01 +0800
Message-Id: <20220209123303.22799-1-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220209054929.10266-3-po.liu@nxp.com>
References: <20220209054929.10266-3-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0241.apcprd06.prod.outlook.com
 (2603:1096:4:ac::25) To DBBPR04MB7818.eurprd04.prod.outlook.com
 (2603:10a6:10:1f2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04a93d85-350b-4a22-6805-08d9ebc857ec
X-MS-TrafficTypeDiagnostic: DBAPR04MB7398:EE_
X-Microsoft-Antispam-PRVS: <DBAPR04MB7398DFE4B94A8FA592BA8479922E9@DBAPR04MB7398.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CNM3KDa+W8//Gi+lXr9u4aL9y1ARUl3EADMJlX49Srt7ZASrTHDqXDAnFjoDI6YVbuFFbw1caFqTSdI+i0cIVmpUIBOpC2WZMXYdyGpxUdrtqpPgZW/QZ7fzSZdmuAd/ikbG7r2GF0qWj/dXI2ximuqWq1erT5BGzd59FSMKXN/CZ5A4SJa8FUmXy7J7tpCUlguik0dJpx1BvsTsIuDj6bK7DWWiKldQgeIR9/EWurhUuAFFFGEwJ582OwHMfcIYV9aE1vJ3TjqFlSM4VHzEYHgxJpsSdJ4iNnv1Tbsyq+4+PL0HHYqwa2PIQDsntpH/3wvsjmXn+JafBV0RRbiu+j/NQweCj/tz/+g/GR0rWIf1GjS/cwkWruNkTOpyNF0oxImtY1pnzEzz/6dnwjRoeerIyLFM7EJ7Qg9eKQru3l/m62CwJNInYjGuR4QyyH6lEy7lWycG24yYJeKYHOeYP1gufyLf/a3Jz9M+jmunB/39gjHdz86zBDWUi0WaFxX2HXURXR+LBwfh0MALUzwbJyO+GUecV21vYd+9j5o0rVvrgBLo/bTfN3xaSU7rVIO/j5MqerxnwmjjEM4Ox3dN5Uv8xlRhlAmrKlgG+3y70KbPSDeWIA6f+FY+vVrb2bQcBgLw6haxGEzTAk1UgxZp7JBbMDet3RCgwMiojwCjbEVIqFBlY0/TMtMKa7vqvnfZythNTCot/m9A/vJ4MnoHtqFjML66QYWagCP82cmB9fVPiFVP4MHjam3WTIYQvHJ3Wzk1XWlpATvL44xRF8eFUK15rCXNd5KdzOcnMAc1Dhc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7818.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(66946007)(6506007)(36756003)(186003)(52116002)(6636002)(1076003)(316002)(2616005)(38350700002)(6666004)(38100700002)(66556008)(86362001)(6512007)(2906002)(4326008)(44832011)(5660300002)(45080400002)(66476007)(6486002)(508600001)(8676002)(8936002)(83380400001)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MLYzccEY2DxhfH5Fjf+sJ01giMznHI5zFVOTHnzBFtBnueFwtR9q+islPPil?=
 =?us-ascii?Q?6TegWcaL2UZWvJJ9ds4raGCL+RXKGHAwerQbXAowue9ZaU54j/UC5jvf7qnL?=
 =?us-ascii?Q?OZ+ADbrfvsj2RwjeCKkCbZ7n8QfOwvG7n/WOTLz/Ceyajxc3FWHEq2Ld8/KG?=
 =?us-ascii?Q?Fl7uWTM3y9BAKDnvrrobQrOIMJgvNKs2Lw8tKO73YrXI2wUN1wlKCdYp7dFz?=
 =?us-ascii?Q?/vcm7flOfq3JdLdA6L75TdXCawFibVGArMeArIxEIcMWqI49RdXeHFr4L4ER?=
 =?us-ascii?Q?A5s7AgFxWVj7bhKvwhWKukVnHE8TNhCTJuzHyp9S+xhOOxJ4fD2bOdPwAGUg?=
 =?us-ascii?Q?DwfeFeI6gpTRtQ3TGRrYlo/ei3qYSLMmFCVdIlHt6RR4ULMzGJIloxFWsvYM?=
 =?us-ascii?Q?68D5pZdwLkkQr3WXvqLBljF2c6Mq9b1u+v+iyG+I/GEQkPPsX8S8oorPdrs5?=
 =?us-ascii?Q?KqU1VaAaimbd6w6vAnCBnecNb7v/EcDMB9sz+7rerwUoZ096v6wz8t+ooRHZ?=
 =?us-ascii?Q?aQqAH++4lF7Uu0VCHWDV15QsD9Av3dYnEkkX/orVOuHAFXuWFG2wapmsMi8Y?=
 =?us-ascii?Q?H8GNX/GEt9iK6LAZ1KQy3Qt+e3RdYXviMeHScFpbgroyCMpYURKDRS5eh9td?=
 =?us-ascii?Q?544bSeQH+fboPQwVSVK66msQjwX9Yf8GlCZIobCjLeDLLlKBUdD4Fapis6sJ?=
 =?us-ascii?Q?EOpJ5eSNbF0u35Tg08UVd2EpkRB1ZXe+gvMOmhazqs9gOc3Ctwb5c2rjsZtf?=
 =?us-ascii?Q?NApiLandKSL0LMbWdrz0oV9hA3oPzYsdJb9ENKp1W+UtTEj+9Eg1AV5yXl6t?=
 =?us-ascii?Q?15bffGEhRv1NNUEfgZJiDYV0Zv2o3xmeiZwndLC7lJAOEY5h4VlPIuVxW0r/?=
 =?us-ascii?Q?yEwCoYTlLt7QOWg3zUmvRtkopTeAa2a9/KmjkCRVRFAfjtYr2sCK790ADP/d?=
 =?us-ascii?Q?MP15paQo8eo19B3ejavAymNcv0AqjXZ8NqCwTeR0GM4f0h0nBveO3v6LdCfW?=
 =?us-ascii?Q?D/vdfsoVobRu5wFMmO0JEYqbyiI4+jhSGZ4YPZdEmceN57w81DRmhW+X38h/?=
 =?us-ascii?Q?ZB64sshFiF08lRfkd2G7x41EbiKJmpasoF2KphlTtUAdB3KZp66tdg8dqWF0?=
 =?us-ascii?Q?Hf+rQaqSTL4aSsxZhSe8hfISyrmXT2G4Qd1LVHe/3l74GMrIePz9Vxb+A7c3?=
 =?us-ascii?Q?0kaHGsJfaJT1znNVoV6ErW8vPEZ4pNAVLTYytX6KifX1c9myy6kT5pCl0Wwf?=
 =?us-ascii?Q?bPbl5GUiERSXLRqoRXGrEyfpKAlJT6Cm914qRsI8IIr0e87QfBdgsm/iYAYY?=
 =?us-ascii?Q?Jt7CT5i+0qwssw+0y302UrK3QZqsroSdI6o41u+xwwzwro5HRosWoBxafn3W?=
 =?us-ascii?Q?/ZrleiDMca0BZ8q/XU4PS74rMxvjJzJyTJV8Uq9PaskgdkBQ+PVDX9vMsFaP?=
 =?us-ascii?Q?4zfiwoJVwlIylibQgnsq3Pob9U1gPcc83x1210iG3UHQMQMtQm8cQBvl4GuE?=
 =?us-ascii?Q?wby3zB0Kvvst7nQ99kxG+owUX/+OZnJ1FLJVWHK6V578n8r9satYceWgK7Uu?=
 =?us-ascii?Q?UtgMqVVl5nG29xrYq2s=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a93d85-350b-4a22-6805-08d9ebc857ec
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7818.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 12:33:15.4013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G44mfOrq04uH6fdpRknTzUoB5Giqc/S8xYvblcEDOuuLwKTlGQMp8POJZGsb4Tm3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7398
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To replace the dma_map_single() stream DMA mapping with DMA coherent
method dma_alloc_coherent() which is more simple.

dma_map_single() found by Tim Gardner not proper. Suggested by Claudiu
Manoil and Jakub Kicinski to use dma_alloc_coherent(). Discussion at:

https://lore.kernel.org/netdev/AM9PR04MB8397F300DECD3C44D2EBD07796BD9@AM9PR04MB8397.eurprd04.prod.outlook.com/t/

Fixes: 888ae5a3952ba ("net: enetc: add tc flower psfp offload driver")
cc: Claudiu Manoil <claudiu.manoil@nxp.com>
Reported-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Po Liu <po.liu@nxp.com>
---
changelog:
v2: no changes

 .../net/ethernet/freescale/enetc/enetc_qos.c  | 128 +++++++++---------
 1 file changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 3555c12edb45..d3d7172e0fcc 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -45,6 +45,7 @@ void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 		      | pspeed);
 }
 
+#define ENETC_QOS_ALIGN	64
 static int enetc_setup_taprio(struct net_device *ndev,
 			      struct tc_taprio_qopt_offload *admin_conf)
 {
@@ -52,10 +53,11 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct tgs_gcl_conf *gcl_config;
 	struct tgs_gcl_data *gcl_data;
+	dma_addr_t dma, dma_align;
 	struct gce *gce;
-	dma_addr_t dma;
 	u16 data_size;
 	u16 gcl_len;
+	void *tmp;
 	u32 tge;
 	int err;
 	int i;
@@ -82,9 +84,16 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	gcl_config = &cbd.gcl_conf;
 
 	data_size = struct_size(gcl_data, entry, gcl_len);
-	gcl_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
-	if (!gcl_data)
+	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
+				 data_size + ENETC_QOS_ALIGN,
+				 &dma, GFP_KERNEL);
+	if (!tmp) {
+		dev_err(&priv->si->pdev->dev,
+			"DMA mapping of taprio gate list failed!\n");
 		return -ENOMEM;
+	}
+	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
+	gcl_data = (struct tgs_gcl_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
 
 	gce = (struct gce *)(gcl_data + 1);
 
@@ -110,16 +119,8 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	cbd.length = cpu_to_le16(data_size);
 	cbd.status_flags = 0;
 
-	dma = dma_map_single(&priv->si->pdev->dev, gcl_data,
-			     data_size, DMA_TO_DEVICE);
-	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
-		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
-		kfree(gcl_data);
-		return -ENOMEM;
-	}
-
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 	cbd.cls = BDCR_CMD_PORT_GCL;
 	cbd.status_flags = 0;
 
@@ -132,8 +133,8 @@ static int enetc_setup_taprio(struct net_device *ndev,
 			 ENETC_QBV_PTGCR_OFFSET,
 			 tge & (~ENETC_QBV_TGE));
 
-	dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_TO_DEVICE);
-	kfree(gcl_data);
+	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
+			  tmp, dma);
 
 	return err;
 }
@@ -463,8 +464,9 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct streamid_data *si_data;
 	struct streamid_conf *si_conf;
+	dma_addr_t dma, dma_align;
 	u16 data_size;
-	dma_addr_t dma;
+	void *tmp;
 	int port;
 	int err;
 
@@ -485,21 +487,20 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 	cbd.status_flags = 0;
 
 	data_size = sizeof(struct streamid_data);
-	si_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
-	if (!si_data)
+	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
+				 data_size + ENETC_QOS_ALIGN,
+				 &dma, GFP_KERNEL);
+	if (!tmp) {
+		dev_err(&priv->si->pdev->dev,
+			"DMA mapping of stream identify failed!\n");
 		return -ENOMEM;
-	cbd.length = cpu_to_le16(data_size);
-
-	dma = dma_map_single(&priv->si->pdev->dev, si_data,
-			     data_size, DMA_FROM_DEVICE);
-	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
-		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
-		err = -ENOMEM;
-		goto out;
 	}
+	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
+	si_data = (struct streamid_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
 
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
+	cbd.length = cpu_to_le16(data_size);
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 	eth_broadcast_addr(si_data->dmac);
 	si_data->vid_vidm_tg = (ENETC_CBDR_SID_VID_MASK
 			       + ((0x3 << 14) | ENETC_CBDR_SID_VIDM));
@@ -539,8 +540,8 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	cbd.length = cpu_to_le16(data_size);
 
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 
 	/* VIDM default to be 1.
 	 * VID Match. If set (b1) then the VID must match, otherwise
@@ -561,10 +562,8 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	err = enetc_send_cmd(priv->si, &cbd);
 out:
-	if (!dma_mapping_error(&priv->si->pdev->dev, dma))
-		dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_FROM_DEVICE);
-
-	kfree(si_data);
+	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
+			  tmp, dma);
 
 	return err;
 }
@@ -633,8 +632,9 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 {
 	struct enetc_cbd cbd = { .cmd = 2 };
 	struct sfi_counter_data *data_buf;
-	dma_addr_t dma;
+	dma_addr_t dma, dma_align;
 	u16 data_size;
+	void *tmp;
 	int err;
 
 	cbd.index = cpu_to_le16((u16)index);
@@ -643,19 +643,19 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 	cbd.status_flags = 0;
 
 	data_size = sizeof(struct sfi_counter_data);
-	data_buf = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
-	if (!data_buf)
+	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
+				 data_size + ENETC_QOS_ALIGN,
+				 &dma, GFP_KERNEL);
+	if (!tmp) {
+		dev_err(&priv->si->pdev->dev,
+			"DMA mapping of stream counter failed!\n");
 		return -ENOMEM;
-
-	dma = dma_map_single(&priv->si->pdev->dev, data_buf,
-			     data_size, DMA_FROM_DEVICE);
-	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
-		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
-		err = -ENOMEM;
-		goto exit;
 	}
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
+	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
+	data_buf = (struct sfi_counter_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
+
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 
 	cbd.length = cpu_to_le16(data_size);
 
@@ -684,7 +684,9 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 				data_buf->flow_meter_dropl;
 
 exit:
-	kfree(data_buf);
+	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
+			  tmp, dma);
+
 	return err;
 }
 
@@ -723,9 +725,10 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 	struct sgcl_conf *sgcl_config;
 	struct sgcl_data *sgcl_data;
 	struct sgce *sgce;
-	dma_addr_t dma;
+	dma_addr_t dma, dma_align;
 	u16 data_size;
 	int err, i;
+	void *tmp;
 	u64 now;
 
 	cbd.index = cpu_to_le16(sgi->index);
@@ -772,24 +775,20 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 	sgcl_config->acl_len = (sgi->num_entries - 1) & 0x3;
 
 	data_size = struct_size(sgcl_data, sgcl, sgi->num_entries);
-
-	sgcl_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
-	if (!sgcl_data)
-		return -ENOMEM;
-
-	cbd.length = cpu_to_le16(data_size);
-
-	dma = dma_map_single(&priv->si->pdev->dev,
-			     sgcl_data, data_size,
-			     DMA_FROM_DEVICE);
-	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
-		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
-		kfree(sgcl_data);
+	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
+				 data_size + ENETC_QOS_ALIGN,
+				 &dma, GFP_KERNEL);
+	if (!tmp) {
+		dev_err(&priv->si->pdev->dev,
+			"DMA mapping of stream counter failed!\n");
 		return -ENOMEM;
 	}
+	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
+	sgcl_data = (struct sgcl_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
 
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
+	cbd.length = cpu_to_le16(data_size);
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 
 	sgce = &sgcl_data->sgcl[0];
 
@@ -844,7 +843,8 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 	err = enetc_send_cmd(priv->si, &cbd);
 
 exit:
-	kfree(sgcl_data);
+	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
+			  tmp, dma);
 
 	return err;
 }
-- 
2.17.1

