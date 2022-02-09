Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0936B4AE992
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiBIFzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:55:02 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiBIFv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:51:59 -0500
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40055.outbound.protection.outlook.com [40.107.4.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C296FC0A8845;
        Tue,  8 Feb 2022 21:52:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sd6AyO7piBhp0/rpnw44asCEwQNzk0dl32iGtrkVM4LWUMY7TxNIP7n5ggMFBlahJE/SpecJx9noduy9qwCWplN2avjuGngvEZeij2MuxO0WsRWSP6gSeleIh2jl0Kdzl1C5toeyyxygoGU7ywxOE+JHkV6QRGtAv9PeAaNyE6ZHNT/RgM7DAN1hW6Tlr67k9BrAhiuQVQdSz4OKSJ7fCZAM0SGQ400lcy7w6+aA0eX1HHpJFV0RGeQ+tB6pHMEkVDF+dmSw9Zd+m0jC3/ZG0BUA7lngrOxo7lhycZRQUlAFPPpNMXdvV4CBEMWexjDjG+1QUTbzzvmpJyi0wZsHQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PS2wYtU4KWqu5L1tmZcEyJTpBNImlXTaxR1TH15rUvI=;
 b=iJqTA1r9lecSmQTzN0oAUwyF8Cs22kbXTimuwmLCj49iAG/qGPkOYgsejt5LD5EUBFsPbv6Igw+CypmJCUjU10fZwuZGVyFhqg/p98eW+qBb4N3jRwfgvIkClL7erRcW0h1Riw+UQ3vQN2eKMEghyVQEiw086rk8bZ7zhHVlV7fmZTx813/Cr16mJ90I0L81qzoTwGsOIpjAfUwkQX9ytSqnLNHrUs9zaacIL5tLfi8F96sp7Lp3mFRtxVQFnHhDFnnL7y0c6YSKEzLd7eVLjxeRnS84RC0q5WLaevXT0aVZq7JWkmdXM7s6Ejfs9A1rs19f1LT48mW5FEVC68DLeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PS2wYtU4KWqu5L1tmZcEyJTpBNImlXTaxR1TH15rUvI=;
 b=gnrdGeqWzK+uSNia7xAM2MZw5DH8Ag/S5DQhe1wh0/k64pKQnrsVjQP0MaHNEHFSylfnf3Tk54BADxYrogdI0fvMKnEheHu59FtTg0UELIdK3iW9zmZzr0qGxkna+j6fq1bzNJa6WZNhNTWKU/cGJcGAHB+qm2wG70HAOKUr0vc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PA4PR04MB7823.eurprd04.prod.outlook.com (2603:10a6:102:c1::14)
 by DB7PR04MB5002.eurprd04.prod.outlook.com (2603:10a6:10:19::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 05:50:26 +0000
Received: from PA4PR04MB7823.eurprd04.prod.outlook.com
 ([fe80::653b:a7f3:f5c9:b7a5]) by PA4PR04MB7823.eurprd04.prod.outlook.com
 ([fe80::653b:a7f3:f5c9:b7a5%5]) with mapi id 15.20.4951.018; Wed, 9 Feb 2022
 05:50:26 +0000
From:   Po Liu <po.liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, tim.gardner@canonical.com, kuba@kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, Po Liu <po.liu@nxp.com>
Subject: [v1,net-next 1/3] net:enetc: allocate CBD ring data memory using DMA coherent methods
Date:   Wed,  9 Feb 2022 13:49:27 +0800
Message-Id: <20220209054929.10266-1-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To PA4PR04MB7823.eurprd04.prod.outlook.com (2603:10a6:102:c1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49d71912-8d88-40c8-8ba5-08d9eb9011f3
X-MS-TrafficTypeDiagnostic: DB7PR04MB5002:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB5002139A5E8A2BC40A175986922E9@DB7PR04MB5002.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f+c6vb+2VfWdN53jChpi8p0T1h81ypyNUd6CJprdesBwJ/D756R2ETKuT946WSqFJMTamjuyXQshomrOlEkBqXwF6A6QoxVSxE1KF+39gw6aiyRuS/K1V5AT1MwFXcLzPYt59V4vvocJgNkP1wzirp4Pp6MT7khWpy/Q5G2+DbaVdeDm/bqP5iTh/nGxL3slgbaS28+NYe2wnqUIchW9WZA3zYj5Wb6L8mtrDdzuMJvQCKMR9dNMmfDndsLjIbhdGWR7iKR73UuSpeZC7bYlIriYHOwcQe/tMR/B7WBFCxMFGtwbst62+eAJdXEdIqkJMfWByjp8Q5kc/iJXRtCyGK1JXpjxzSy22iIORxTigjqCOmuiWN+7LOxlcXrzUx//vPQ20bjNZTFGPY3nDpISVwdGlGpiUMCnNpgNdv7OK4/kjWZCCTDNgah9WovijRCzOFN+21h1cgwiubwKZNJ3XV/iEyIlNc591C+JKj0aX0Y9eqPFC35U1cg73csD4EkBvW94iajbnCvHOm0CFMlJuVVv+1L+FF6c+QCE8jDrBg2s6t62Ts+VluehFlxWo/moUqcp++ijIohF+D7gfGDA0OA2PsIdLK0ywE1iabYYdMzLh3iiYKfqIZnJNFk5bhdo6SBKR9inz0I8qc6e0pJT8h4pc2awYgCyMLpeHhKOyTCy6woXnptNyrmpiNvzWFFNdyEpgbulzDnAH1a/FXP5iujx7TqkfGzAy2kndy2Om8dtIvqhcsywPsoV19m22EcjTI5ZUHoCqYBcZtQPPhSqQ2TXISKpbhBd4jdoMPliclo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7823.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(45080400002)(4326008)(44832011)(316002)(6636002)(5660300002)(6512007)(26005)(6486002)(966005)(86362001)(6506007)(2906002)(2616005)(186003)(1076003)(66476007)(8936002)(66556008)(508600001)(66946007)(38100700002)(38350700002)(8676002)(36756003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7UsUyiK6XdOjyU7APAkgHCDfqMdai+upwfp8v/4kFD5bNoyaGiuZ16MWsDGO?=
 =?us-ascii?Q?7heKj7Ft5WwyyyuUh2z4i+Qo4g9bkjdD05TzDvpH7I6DYj/coMgs2BCD6rt+?=
 =?us-ascii?Q?w281eENCQbPGRM5QGgPxQenab7xYWMSJ9vdUItjbUslO3y7qZ50HFDqdqOP8?=
 =?us-ascii?Q?15aUAOXduRPwAsguG4R62LDGF6NJkO3SIbYZOpWbQpcP2TJHfS1bJmjcUht0?=
 =?us-ascii?Q?bsoZWaZg2qJabyb83eGJGJ8CuU2L7NUFa6w+1L/jt80Xd4jXqB1727hbxeV4?=
 =?us-ascii?Q?KDZwzL3aSTQXvUnjlyCG0e1xScM+3B+k6fIYlwLVZ8clc2/1AWIMpjR4n4tb?=
 =?us-ascii?Q?8RvcJSg9fmRWlTFqkRX0GmrCRozkHIDS576cC1KI1PXQj4QsxHhOr7oBsyCn?=
 =?us-ascii?Q?IkefqKnwyV1o+37Yo1n61+pVRDskJBsMKuDLLidxB/ec8WCvqACI9dHceHDX?=
 =?us-ascii?Q?qKGRqcpuaDbsm0xB/fTqvHFXugkXizk/ST48n+lNX5aS0qwzuAmD2AdZJYMv?=
 =?us-ascii?Q?u8iWCrq/Ea4Nu8/awothLsK/mnI/YplXClZ99DfC6H6FbjeykOVsPcEBT74l?=
 =?us-ascii?Q?v+StTnV5XvE5Kc+s4azDNmXvfSlLfTuah86ExZvBG3g0ioDss6Gfmvg8Tbml?=
 =?us-ascii?Q?j4u1O53hv+G7AI0MlJXzR85IUHi1eHBxDZhsryyqWzWm2kuQsrNw2+F7Emxo?=
 =?us-ascii?Q?VmedxoZqwth1biOzDz7SynaIjEQfG6Oei4bBhW3IETjlIipsbVbmThQt3nrX?=
 =?us-ascii?Q?unaLqMTLpDs8YkBdOi4Iwx0ryi5luPZtaqz42KSk/p8QzUiPnQw2a/A3ZOzD?=
 =?us-ascii?Q?pn/i9am1NB/1HcSihdiA0r6Wq9yzNqho1CekU+P/yOE9usXPtKklQoSFBmJF?=
 =?us-ascii?Q?bKUTnc8xxazTkyzgf5cJQil//5Y0KeIwF6WMaHPRzqf95EiBaZxUaSSDD1Me?=
 =?us-ascii?Q?kCfuXTGIfq/LJzDiZDILAm0Qo2TpK4Fw1Gw8SyQqDM/p5LOuzl6z0Xd1LiKe?=
 =?us-ascii?Q?wp6G96E2p467/4MPa4BOpHryUkoH7MxZLUU9fz47jFZCZHYx6MMIs/5ayIz1?=
 =?us-ascii?Q?X1rvnaoXlpmbWLg5I5RLoL17Vy4rwj34e8BBwR2acenlgjm3Z8ukY5haiXV4?=
 =?us-ascii?Q?9PqAh8rKpIItDhwZY+xDtbvELf9nxpgs/7F8R5tFqT4LXJdA2kOJ2Iv2Ywjl?=
 =?us-ascii?Q?SG/2VwaKKdgAldLJXSweQT3Sl/qRhQ0w9R7Ed6BUjDxiIE+U0T8tWzUHwPcV?=
 =?us-ascii?Q?znYFgbHDtYlHD8GiYx9t/lJwCHfn2YVXukC217irQ45gscFiH7JgLamesCMK?=
 =?us-ascii?Q?UNsmLSrgGs8Cur3vh+VNuRin2JWzHp8UV9GZRmHGRlUpdwIaQ5zvbZitKe9s?=
 =?us-ascii?Q?RWY6aY1M0v3hWS46dOc5SuVnP3T3kJT058lr7q77oYg02q9hGeYeT5jj+aA6?=
 =?us-ascii?Q?GosjLAztmxoVdhgu0zKLK4pt2fqkCVVMlVlZAf6qfdfYTDf2KmPYGDXi70RY?=
 =?us-ascii?Q?Fppk3dcS/OO1PK5ekgpiYF73kSjfrvZcmKQwQWjfMMHnX3/EZ3U+O8M8dLC5?=
 =?us-ascii?Q?VYZncnsz1kxwmkNIuoY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d71912-8d88-40c8-8ba5-08d9eb9011f3
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7823.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 05:50:26.2220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6J+MQjw9w/2VusAt/GfZ01bnQ2HBf18AB9W9QFGgl1vZ1ziYx24GharLacImHKq6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5002
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

