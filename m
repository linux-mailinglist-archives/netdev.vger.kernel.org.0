Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76158601337
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 18:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiJQQNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 12:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiJQQNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 12:13:09 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54106CF5D
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 09:13:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzFYoJ05olT57i74LZoWPYayFguKcDb14umT2ZiripYwB6DlmYdu19p3TXihvyfwbVTtdQHAzRLKQfFppC6RhamBb4vr8COqRZ28DU6EmLTeHJnO2dkot6dZ+tb0VjRJ5GfSl7sb54aqKfZC/kDqxDszZmu5h5NnZ/DnHoJFlZNy3LL7BR67kqyT4HkvawOnknb/Bts+42s9nolvjq1lKkpzcMLzeSs4OMvUwFZdfLIEj0ipCHWNFiFy+KCkNJtD/khEmfgrTvbMc1QFMfiTCyV6+Ws9QJEX48WdhHJlNFq9DGb1Q9Kz8Mtgqw+OxNNeeawddCr4ogQbR9wDgg4CFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZmLiDJHS6JqQD4+ueCwSz75ijRceNtBPi3FoMYn2a0=;
 b=NnwLFU2I7hGUGp40BCiN8YyDjf/eqLFai+BDB5z9tyhY6VZdeZleDD3YUrXmbpcsodJUPyFL/Wm4eH4MLyW4cTAjTt2ol9KMnJCq9DXQ3HyEWX0jJdLxitJralyu+weAtN0B5jOVyQb+7LqRzHDOCD82iEJR2BZwsIlRfb9pxO3vp+7i0L45T9vuN7mcID88jKR32T/H5bFTgXHx+ECmgmIavxmNBC+/q5Z8YFDrSX/9y5j0VeWDCgxAbviYk3m8LkhfXyXOWnQgtylw8t9LVCVog5KD1NruSgwWJbA0z5xSbTsJ785KBQuD7Tz2XVcKFby7UWC0OIsvj7+GI9JVpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZmLiDJHS6JqQD4+ueCwSz75ijRceNtBPi3FoMYn2a0=;
 b=PDW7Pl3KIBGv/VkNRAb0nNcBSDigIYfmGq/cDa9trDEPb/0EJ3Lel3fYUIwoVyzMr02llT5RKgFmT+9Fowpq4BpqQN1q+n42zBD2jpvTxncpl0JIcn+eBVn1NHG7U8ddh2DnR2cGBWUANLh+x+ARTLbTl20/pvuqIB+VHhCPaVM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB9666.eurprd04.prod.outlook.com (2603:10a6:102:241::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 16:13:04 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c%7]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 16:13:04 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [RESEND PATCH 1/1] net: fec: remove the unused functions
Date:   Mon, 17 Oct 2022 11:12:36 -0500
Message-Id: <20221017161236.1563975-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0102.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::43) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PAXPR04MB9666:EE_
X-MS-Office365-Filtering-Correlation-Id: ee7ece7c-8669-4bbb-83b7-08dab05a77da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Kmubt+Kve2yTg9T0FFPH9qEDbvFfTdvVyXn9GVRl7oGA+UnMMDqq6NMkk6tRliLmSjnsN1yG40f1713uHr8hOEIvWU2zdYzz3JCagMHPRBEAI2OQuoEQnolJ0Gz18JGDg3K5OCAB97Y9WvF3IHM4aO2gDapCLqEgEpIzP+MQy43HqP3a4dqRHNSBgVeIjOb16bE9Acl3JGYbObPPR2yKN7jfZHG3lX5SmLbOVHrDISz+HfHbS7mVqVjy/aUIH9lat7qc+j/aGvbC+HdWWMDC7di13LXSTe/WIHIseVeAkjusoxFwB3nuEp6i55aI8DkXc30OCVT6iF1G4XEmXnsvD1NpJKjfPqMxrPuHuUTtHjl4MyJGLLLxmhTkxBlEySpLcH/mx8ydhksFa+lHhR9AE0qz29g2zMHo9SmiIPnLjYbQr1kXA0ieee953+km09w42WCBRtlVbLvK0YlV4fiQM6oBRdpGRehuGJsbiPVwwLeJoZEg20HOxRxJrxgczslOOeQavEPDTobnc+g5RpkMLk71o46DPWc3Oh4TEriUBoP1uAjM2cq2uQMaXyj5jsHPZ88UXIbp2DaNxaFSX80+uphqjU9c4yhDOSsWACKeNGW2Ezxy+aLvMdq6K6+/GFuK8lZeLBNrJPPOqVENeKhBzcJB9QajTQLvf6PMZZ1KlnomAHd6ssR/yYuxRReQR9jgr0jrREJVPvWEGxoWrY4//tML2rWnUGfooBPr+RRByfltOQMCbH+41k9mJqmG75o6BU8LwGzcwawQYzTTEHMdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199015)(6486002)(110136005)(316002)(478600001)(6666004)(66556008)(66476007)(6512007)(5660300002)(1076003)(186003)(2906002)(66946007)(8676002)(4326008)(6506007)(52116002)(2616005)(41300700001)(44832011)(26005)(8936002)(55236004)(36756003)(86362001)(83380400001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k3sXAgi4+80KVlsJUcwDWHJcfrp4nFzmLNsLRQpwY7etPU3F5epY4fJ6jffA?=
 =?us-ascii?Q?0PgCr2gp7ZRqywwmJACApovA0NBYZ1LL/gjs1/qCPEjGujYlf4oQZu530LiZ?=
 =?us-ascii?Q?lD/8JzSBwaw6YRh6kl35vCqmgaBZAyT05UXTjNwM9OWgZMwiwgZJhyGZ6oiI?=
 =?us-ascii?Q?dB1ldEMBqxK1OWc/3GDgh43bl+gnNntKEEe/RVInhPfwPkuZJhw/RGUg0v5A?=
 =?us-ascii?Q?np4Fsj3pGRuMdjL5inRaJtlWtC9V4mV1PuLsBEu/TgwxRVOLfUPEQpu1LtON?=
 =?us-ascii?Q?kdwZOG39L4BTXuMtcziK9AS0NClFtnEQLfY65fHr4hl5D/szXRBPBiXfbE0g?=
 =?us-ascii?Q?ngcEml09V4KYdHnqMfNb/jrLJAkm+rGRkL9jNPbOQC4EfKHMiNxk+6aC71lx?=
 =?us-ascii?Q?piopIXcECMEin/sIf3Osg17HKzTA7sqRbpDk71DLP5eCjpHPlTGLWCWuM7ef?=
 =?us-ascii?Q?ZgsQNa4e38nvBb5U4fCl1sveUDcGzOgYyxUn/2fbpeeFVohU2PbWKLc36x+4?=
 =?us-ascii?Q?GYwJXBJC0iYIzRzuw/MxqMrBlpw/aL3KqHgn3jQx/xPWUMI3gPu9oqTT9acG?=
 =?us-ascii?Q?Hy0B1oclv+JUT0dPwmbZ5WYOKy1qx+dEDfNXkq/NDPdhwNAq7Vqk0S3+XSQF?=
 =?us-ascii?Q?XqxWCQXp7k2lnUqMEq4hcglvE0iGA3Ru3yZXTlYSQ4Z3/gj0A2bTaIZF9YYN?=
 =?us-ascii?Q?YTwsntxWE3LiBbD8SbLDhJ8VjYDjkx3hOTi0o9kkbnBkjx/ta84oYsJpwIXT?=
 =?us-ascii?Q?eGiWbJhcZrfuyqT9T8vFChcrce0IndrKlV66+os7NY1BOW7pTvWWYsKHSCpp?=
 =?us-ascii?Q?1OhU392fTYI64JfTRmOpvBNnE3phXTmn6Rg5MeGeKfvX3Yk/J6t0uC446bVt?=
 =?us-ascii?Q?m9tn4UFqKz+vn3AIOmnI9nN7EoZ383bReRUJeS2TuRM9NpSkyAeQc5Suc2xP?=
 =?us-ascii?Q?XkxV26upSNWm+mfCZ/L8hM32S7mtJybaor2DGeNRQwTOPxMI4q0pipNSMPPg?=
 =?us-ascii?Q?DPME1yjsaItrvjUg8eDT9E7G580VY3BaXyjDQm7ErdiHK8kM02ddO+kVpEUM?=
 =?us-ascii?Q?R2atGW2N3sVmY92a8nhPIkCr1wB1gOa39ykcnCcbrmKLWzGE/bUu5MK1jgT9?=
 =?us-ascii?Q?u9FFXHeWFKHOb+jym+5wUEr9D2BW4Pj2CLf7QlCHez5SxEJDGxOG2oUxEQrY?=
 =?us-ascii?Q?la4pnS19KHFgoXo3OKq4W28Fj0YfrxDK1+oE+19v6t7EaPmuBasxohveR02Y?=
 =?us-ascii?Q?2YrmjIJtLf0h2Cl7Qix1M5iDzfaxufV8rFUJddjhFbUeKbsNqhH8pILww2CH?=
 =?us-ascii?Q?AF0eQXN5YQeWobc/vPMK6QpNRuL9Sm19n4NItmcJLyvyfGxjh89Bzlkx20Ie?=
 =?us-ascii?Q?sFkG1YUxLmGqJw2tLB5Hl6Q8AZoGimx3ZEasTFa/HeGc8kIgY2Vpw6oMi/wI?=
 =?us-ascii?Q?aXCKzLYT98eu//Q629Zcbudm8wXVtQZEwbTP32Vs/Qb1uauFwuaok29uOgQJ?=
 =?us-ascii?Q?2QaOc1a3KjZq9RlJwGT44RXHDnczGcQ6/en44hKTHwPGA1X4Q2tVNdQBa9TZ?=
 =?us-ascii?Q?sT9T1PMQ4ibCbPeXxVrITmn1QByZ/IZJOPGF59TP?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7ece7c-8669-4bbb-83b7-08dab05a77da
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 16:13:04.1480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqSKq8cAfTFr9nydYVTuQyWL2Q/6+tESJPiKn8QGjkGmtkXvrZ+yFMzCO5unJw/st7FSxNhoQ2PkuJkoapTZGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9666
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
 Changes in RESEND
  - No changes. Resend after the merge window

 drivers/net/ethernet/freescale/fec_main.c | 57 -----------------------
 1 file changed, 57 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 98d5cd313fdd..6986b74fb8af 100644
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

