Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F61E5F5515
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 15:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJENMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 09:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJENMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 09:12:16 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50072.outbound.protection.outlook.com [40.107.5.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1A379631;
        Wed,  5 Oct 2022 06:11:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PP5brLjnUle2ybL/Npz4atilZAldB9IFSZMAqiZ5vgIvT9BRrokNtBeeBoJmM2lF3fwe6kQms5imjRwW8EddZZrJ6O3KYUC0l5p6obFSNZtDcKP+RQB08CVzPdZyMMSA4np/aiNWlBNc3khggRNRPaghKK++s6u6gt9SlbMg3OEDooORkYEMX1eC6MjfI2h/UEogEgfcVArSA96/t/eE5/psO3tq789UEbNZneg+OtOufkUiebplggA7jc2eX+gmF5l5vLSEH9ozKdQOh9sFET9jihh7r8RzSzYo/ElkHJKNrfRAsaUu2QONvijhhbqalxPQ/WyKdbaoa4b+on+21w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RKa3jLem8PCZLtFjygzRMijl5ULOidM0dY7X6+G/Ag=;
 b=Ng1b5Uq+mK/XEQjxy3Pjdrlm8aiAZpIK7Nn+deB/yd8C4qCeicYX0b01RV/UZFIoiXxzJb7hhWX6EWGw6fAZ4jqxak355SMXfV2Xjg6QvlLLMtDJuC4pJUJG/paKCkwucTxUFofRiOCpqrwQZwaZb7O02CbwRHNVm4qUslsUqN3exuz1OpyEw8j8PMvLEi1iFnUKtSbdnv+bCOFrAY8kDmbMDgaa4TVPXjydN8W6ItVVbAZ0snMuNZlqtBGnobITyzl1MuFnoFRYhywFZXSiBYhB2JTR4JuQuUkHS0tWYNcag4XGClYC6e5FSQzaJHS3p9N+coBdOLzt4hvsSXFZlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RKa3jLem8PCZLtFjygzRMijl5ULOidM0dY7X6+G/Ag=;
 b=G6UYTsPEn3llWmoIrSekFXNVpmYQcY5P15mtXI5r+9zCY6csSh7mA60oGcZxtiTes2NdbxuXKck1LsRMkFxFPnUWUDkOdl0frSsXY6wWVYrWEfTIwYV/hm4Zp/CVwfj2vdTJHsFcgIwnWvZuLzzCY/TexlQpZbWp8r4BPvcBii0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM9PR04MB8100.eurprd04.prod.outlook.com (2603:10a6:20b:3e3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Wed, 5 Oct
 2022 13:11:34 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::d076:3c2e:4567:7187]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::d076:3c2e:4567:7187%7]) with mapi id 15.20.5676.032; Wed, 5 Oct 2022
 13:11:34 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 1/1] net: fec: remove the unused functions
Date:   Wed,  5 Oct 2022 08:11:09 -0500
Message-Id: <20221005131109.356046-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0094.namprd05.prod.outlook.com
 (2603:10b6:a03:334::9) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM9PR04MB8100:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f0d6ab7-ef34-4a22-f77a-08daa6d32062
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: La77F6A3B59ekVQlg0AbfZx7VRq343ZkbXGBM9TPflTYfgoti0EMrzLrxW1hs6t0NdIR5To16ZyNd5j/Zqbzhv7ZPafQ870bSaqc/GtzxS59rYPI1oZZtHiRtnTfbiF4xDfPLXGQjPn1ZTPzYMG1YUu0OHB0bqSgLo6DZgP/omlUtFhBNwoyIuD0S6i4Kbb6v+9254sZhB1P6UOrj9LxDojOv3zc+xjW0R5e2JfSDKVbNyFRcOrvtrjYiFnJdF34TfrFbYUzbyds0nbX0JnZauPVoZ3vA8clygHi3sftOG2DAEbkuqfILUlzlKt7CYZQJYLvNfgpHJSH5nsu1bU/IrFYmyIDwivWhf1dPl8Fj7PBrs1j/uK4j+6E/8RMVVf2EmtrDoh3muwfo0JO3RsbMhe7upxRntzWyk9+NRWjc1/y0PNR6zy81DCPireTA+Ohg/fYixDI90h8jqm762rtZlqfNVhpgehmLoReTio99p6KtmkZUZl7tWKU8mgC4GT5P+HGingDrL2MHn1TCC6ET71gZlS5vH29Vv1NP3B/kL2t2oztLUGNYgQk82mLosuh4kyTSRvqnH+pF6c3hxSoqQzxac3Ko6UCnSYS/ZH1yf42KAIkBU8ai6BLhZZHyZgwGZHdlBYqStjkBEC9W1DQz6wgW3P/Lvh/DQn4Yg5qGljFX4WBVanntYHADPhsr11DyjCrip4oMXzx/CsmyKxGlIImFgblBXDfdFylsfQwo8Mmb3Np3rO+bIfjidpe8Rad
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199015)(83380400001)(1076003)(66946007)(5660300002)(66476007)(66556008)(8936002)(4326008)(6666004)(52116002)(6506007)(41300700001)(36756003)(38350700002)(478600001)(186003)(2906002)(7416002)(2616005)(38100700002)(44832011)(6512007)(110136005)(55236004)(86362001)(316002)(26005)(54906003)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ab6G57uZSmrx9HkYlkp9nHE6JFSPdNqclgATyJznh5pXoDpapi37t6LAv0Il?=
 =?us-ascii?Q?iFeyI/FBNPA13Pb9SzGrRdi8D95ON/V/hZ5niaNZXMQ98Et1wKE4NLFsw5Qu?=
 =?us-ascii?Q?8dvcWPMEI4ijoRdlDuGGYq81RpjLMR10GQLlWMMDNyahg/Zx2C/X2OGTtGOR?=
 =?us-ascii?Q?iUKcbeMb1Zsvrlr1G00F/30EMNCcL/O/7ZTWKhewrrpwr/Jsl2zHYUXIbzY2?=
 =?us-ascii?Q?xZuDQJRZ8vs5itRLtbu83eU/q0DPkxtqJ8jbKf9wNU5aEvqHLmS2qM9uW7UP?=
 =?us-ascii?Q?JPWe5Ljd6B67PdRQg+KL/ee5XBDSqD60yjwwdnerkp1Ew8PVsnYNytrs6sb7?=
 =?us-ascii?Q?wRfTYVQBWP7rHSUZC3HqNOeZwYQJ1HtIn0LZSdkXEA9UkrXPChFQxfcDEUkn?=
 =?us-ascii?Q?dvkt4c1M+EejCSDWajtiYbeh9Miy1AXL0WLoL0E2YerSJR6IvsxTzbYCELX0?=
 =?us-ascii?Q?NjySQWY6gZqB1HST4DUbQu2FVPTuOFO3/8XPIwxci5noAk7LgyMHTBQGkNIq?=
 =?us-ascii?Q?5MyYs8NvGx9ec/lAIybvCjiTgaEX+PaH3r24w+IMAxlDu8QAGRUXWdf9aIsU?=
 =?us-ascii?Q?C7ITfZncMWzKrLYGIz8pqZAfBY0WNsrjnMgj5PLSfdfAMxa6qEiRsqbQbNpk?=
 =?us-ascii?Q?ZXATZYgjm1BHmnCZTi8R616TO4R1OJM+ge1OsjenJwzm/bMylehOC++osq91?=
 =?us-ascii?Q?+MkCg0wJ7JQsTlZr83Q5ihAXaGL/zCNRx7ncr28uQLODoXZQ8KTBFaP+hdNb?=
 =?us-ascii?Q?EsDDbQgYDOVWZYCoq/X+KCy9hFAZwcSGPNB+Eb8qSxkxrIfUmaQkM/yuzVDK?=
 =?us-ascii?Q?E+fzawdMwKB+E40sveBwN7fEz5T+EQ39euHKfm6bZunbxEF1Lzv54IOGC6qA?=
 =?us-ascii?Q?9lEicf4NVmh1beLhT/hiZI9VS9FIBSJ9CmkRYBvkZqqKDhbmhpQw0FDQps9Y?=
 =?us-ascii?Q?OhrwJSafly5lxOhPOQwfVfdqNxwYVVj9+Jf6SEIm1ag7UaO4IKM/MoxJ2EPO?=
 =?us-ascii?Q?CTxPsvz+NJG9uTU+1BNCwsB4E8mc9lHJ7zjFYmJRHsdRMKMfqrunv+tMYFi9?=
 =?us-ascii?Q?66+0uh4o5AdQxAPUwsw6gKSj7Ih4QyAjv7VHvBDLsQbQE9MVz1evbzoDRzdx?=
 =?us-ascii?Q?n1KZYYAnotgI46BM4A9AmDx8XcE0WN7w25DP0/XvRxEo3inXu4/of+kzB8K7?=
 =?us-ascii?Q?pq/MKT/NN30FtsPqA4IBVhnTemqdBNZwXnn0wC5JSAfx4hQsweUjrhyf3HMN?=
 =?us-ascii?Q?nhc4jCyIReQt1bYQXIOXAkeaIGZ6BHq51a0zQWFP98MW7CPYqIW2/keaP6tR?=
 =?us-ascii?Q?WKI/soQhVPrvkG4U/x+1NzApAWfwHe9Dlnfv9CsKL9aVK/ItgAlMrx7983pU?=
 =?us-ascii?Q?4LJoAD3p00DnmXjnOv+8R4DkCoBRQ4Sw2VmUc8PTwCclkuI6KVfYCV3uTZZU?=
 =?us-ascii?Q?Gu5S/07vTlkL/NKLdWm5l44GZRfgABG29tcdtVjvDl3/KlAOF649+u9x4I9+?=
 =?us-ascii?Q?eLZo13eQrEkAYtHwvGjsaCFgQ7a7ekCJIRGWWom6SJSvZYAY0Y1a0a/qak8v?=
 =?us-ascii?Q?bT/cyhl1x5A4638zQvaA/RjTWkYppp93WgW0Kro3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0d6ab7-ef34-4a22-f77a-08daa6d32062
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 13:11:34.6470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hs3Rc7nPm1PLtNMcpW/wDRbQa2sk8TRJV2CYYFldVNNcpSCDWOcMtQR422BQGJNw5BnaXPDV0lmwTpN/FnZXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removed those unused functions since we simplified the driver
by using the page pool to manage RX buffers.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 57 -----------------------
 1 file changed, 57 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 18a29d5614e5..de73c7a60bc9 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -365,16 +365,6 @@ static void swap_buffer(void *bufaddr, int len)
 		swab32s(buf);
 }
 
-static void swap_buffer2(void *dst_buf, void *src_buf, int len)
-{
-	int i;
-	unsigned int *src = src_buf;
-	unsigned int *dst = dst_buf;
-
-	for (i = 0; i < len; i += 4, src++, dst++)
-		*dst = swab32p(src);
-}
-
 static void fec_dump(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
@@ -1494,53 +1484,6 @@ static void fec_enet_tx(struct net_device *ndev)
 		fec_enet_tx_queue(ndev, i);
 }
 
-static int __maybe_unused
-fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff *skb)
-{
-	struct  fec_enet_private *fep = netdev_priv(ndev);
-	int off;
-
-	off = ((unsigned long)skb->data) & fep->rx_align;
-	if (off)
-		skb_reserve(skb, fep->rx_align + 1 - off);
-
-	bdp->cbd_bufaddr = cpu_to_fec32(dma_map_single(&fep->pdev->dev, skb->data, FEC_ENET_RX_FRSIZE - fep->rx_align, DMA_FROM_DEVICE));
-	if (dma_mapping_error(&fep->pdev->dev, fec32_to_cpu(bdp->cbd_bufaddr))) {
-		if (net_ratelimit())
-			netdev_err(ndev, "Rx DMA memory map failed\n");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static bool __maybe_unused
-fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
-		   struct bufdesc *bdp, u32 length, bool swap)
-{
-	struct  fec_enet_private *fep = netdev_priv(ndev);
-	struct sk_buff *new_skb;
-
-	if (length > fep->rx_copybreak)
-		return false;
-
-	new_skb = netdev_alloc_skb(ndev, length);
-	if (!new_skb)
-		return false;
-
-	dma_sync_single_for_cpu(&fep->pdev->dev,
-				fec32_to_cpu(bdp->cbd_bufaddr),
-				FEC_ENET_RX_FRSIZE - fep->rx_align,
-				DMA_FROM_DEVICE);
-	if (!swap)
-		memcpy(new_skb->data, (*skb)->data, length);
-	else
-		swap_buffer2(new_skb->data, (*skb)->data, length);
-	*skb = new_skb;
-
-	return true;
-}
-
 static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
 				struct bufdesc *bdp, int index)
 {
-- 
2.34.1

