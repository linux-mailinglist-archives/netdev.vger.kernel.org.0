Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6402261F647
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 15:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbiKGOjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 09:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbiKGOi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 09:38:57 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80047.outbound.protection.outlook.com [40.107.8.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F281A20F;
        Mon,  7 Nov 2022 06:38:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wo4l1ejjuQezHt56F3VhHA3zIywqka9GxjobiEIZxEoaG2YH2qlJavhl+d3Y3FYzmA1GWH8ADcPkURZ5FJyO+KtbChWzqaXPIHq5U5oBVlXN1tWDsY6gB5YwwLUGhV4r1PT1ZNTG6seZWIrdE46SAxvROiEiFX1HdciZ8BnQCpqWUvSDiKqmJ72i2etmtgfzlZn79avlcCvPgxEQHst/rCQwuqUe/dF/xldJwJmnVvzcOCXN5IPd3uW89R+EhyjMBGbcBQGdFwPK+hpq7N6N+5kEJff2KKaEe7888qY87+PnjAZBbZBKf6KUyaPLcShkH0krMLGNKhcMBVz1cf6bUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBQbjC/nrO2786LNIfK7WsUT+HcBlkTgsK7ptHxzTbc=;
 b=H5KB0v2S17ARbfC3jC+Ccrw3HigDbrhM6dlJQKnWMSu5vKSL/T57Dmca7KUXX9her9GgOpLGIUEBMe5VavM4vlxeSzDwfspF4ImAR+vVKv+lcTow7/NoZMDe8V9nmjTei7KO5yUc99ZqnAwWBkKSEh3UWZM/eYXFvcCseWUsuhH/Md4rSdICgU1WXnq6thB7minoKaDxQ+VrOR7AHrj1ohPBCbeEjHXKZgRcUi3d/wYF/3rYQODsqjZPrVpnzAFeI//eSg/dwdAbBaNI5KMJLkoppI5nRjrFRIBPfM0Q61KEoyPn/S87bDQ0Svz6PLlvuBaQttP5O7TaNCbsNRv0iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBQbjC/nrO2786LNIfK7WsUT+HcBlkTgsK7ptHxzTbc=;
 b=beROjZ4MMTsgOfWuW5TEv0tN/g8dw3cpo3sfLKmqn8ahWsO8XQ6cG4RL33wmAxNjvG0rpS8plc4sMb0eGE9JvVhjei2a3sh+kYnZ2WjP2x2/ltWsMub+Cg/L0TVQS4pdmp/lMIOn7jHdsiYzh2/ZH1sPd1TaZ4c3jRC/VCVAMPo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB8385.eurprd04.prod.outlook.com (2603:10a6:20b:3f3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Mon, 7 Nov
 2022 14:38:54 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 14:38:54 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 1/2] net: fec: simplify the code logic of quirks
Date:   Mon,  7 Nov 2022 08:38:24 -0600
Message-Id: <20221107143825.3368602-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107143825.3368602-1-shenwei.wang@nxp.com>
References: <20221107143825.3368602-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0014.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::27) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AS8PR04MB8385:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f4b321c-a4e7-4842-67e1-08dac0cdcb46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Td3pLXuvoaojBFW9I58iTohWCnprRVSaGqPcOtAgwuH3IyD6sf2X2s6X6QV6NMXw7gvqARFMPzFkYUAh8bN6MBy1OpGzt+hagdQcBMMZGNoGj/p7Jgm4CF7Q232hLGkQkbm60nt0t51XTdJXZ/nzAcUTfkbU1JLWbu9AVWLvv3qyQBiCKQGd9o/JNCXu4YQA6VFabj7a3y4lyt6nav0iL7iNnf1hr6fIBVlbsBztbjmWOloVXdCWwdSHQJVvGHxsAaPAoKjM90qnwcmlwR4531c2T48Z71xHNkF76+/5stDjzMMqOrUfHs6C58g7zpniod8Dz4fAODsw8W5+VbOviWrGQ+Oja0MHV9sWFUJ4+p2k0OOZNOSFOrFnpWB6vnqkiPUl6APYx4kOzS/OiBG7hDpdfAY18P+qt9cIil8R9P4e0G5y/pVcasNSkkJdbvRn3YbKgffBBUNWiSkPkMpMz5SO5kSWI+6J2PAcdKN8havdN8RS7j+tz7cJ9K5DS2v26dvUWF7RKnRz52AdohyLxSqgraoXng4ELMusSD/mSO52fy3gLXG0XuPSxWwaxaztaVKeZIS4EaEUC4dXdpxWqCM/MmOCpWOK5pCYEi+DH1AGSO2jl7UtiWEpRmCQyT8o88IuRZEpRLGy7Sm9DHlRlijNYPvwC2WK22C38lUarjRpca/pyi7pU2VKfaNPFuH9MxN50J/sZh3mfdzfP0cMxevgmgcbvEgrdmantL08oSp5gccq1uYnNmJ8yXEBIABR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(2906002)(66556008)(66476007)(8676002)(4326008)(66946007)(83380400001)(55236004)(52116002)(6666004)(6506007)(478600001)(86362001)(6486002)(2616005)(1076003)(186003)(316002)(6512007)(26005)(110136005)(36756003)(54906003)(5660300002)(8936002)(7416002)(38350700002)(38100700002)(41300700001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pNg1QDecl2Gy+fCdZNePapvRnVB7kJPW6QrCpVBcfjhmB7oSPkBNfPjWnVdS?=
 =?us-ascii?Q?kBFX5T48CbP1P3D35+UjBRKE87YoH2NeuTCnU5A8x/1PXL/zPRm+M9AO+76B?=
 =?us-ascii?Q?lZqPzbR1scz7GhFmKy9BpJPGI27eSC9QGkfZysVmfeTPSvf4TFcVWhvXEXkg?=
 =?us-ascii?Q?b5T19Dw8vqhTWuJLkTaNsHheyhYIRYyhoQvyJbeSSXCAWqvfTdqbkzbToUR8?=
 =?us-ascii?Q?SH6LUzIN7EBwIxq4Hp+6S+l0slmdsC9+x2ApvY1+WI4scxVzH0zHb3eNO6hF?=
 =?us-ascii?Q?cXFTe4ccKfBd7KIJR6w6YPpKuCjMBG2/yczp1QJdal9A5AmwnhAiWGDFaDA3?=
 =?us-ascii?Q?rkRIMUW+WqfG9aHRPKmQcDXR/LscV+q5mkulPN7RAegXrMVCFOXY+GiMXhzU?=
 =?us-ascii?Q?cVa4ah3JXL+RrR9BGxpJ4xX9JO2N4NxDGa6D0mMWvKA1URPXzNgEKm3V5p12?=
 =?us-ascii?Q?wyJVfSI/Ne2qJkciMYQ9bv0EggA0kSQdAP0mMhs7gYNUArb9wF6O0RgAP2M6?=
 =?us-ascii?Q?euZB0mfAQ2/zS0Ketl65SHz4puh4H+38w2O3BIKisYUYhyp+hd05wddxMPEV?=
 =?us-ascii?Q?4X0D0wn3asuNln1NQuVtWkJpSuaT6G/Ehjzc9G5dFWaSxyamaVKtefgFXHeg?=
 =?us-ascii?Q?Qk3Hsohy13aO/WrJefUNwSfOwD4gVZ/3XZE9cR+nqP1UUy3i8UeJyXrdBcns?=
 =?us-ascii?Q?tVpyu1orZZvDqQIc0urvory+80WKSWcNj15BVW5JuE+OY0HpXDUiAEaNTVz6?=
 =?us-ascii?Q?i+yBQXVjcWGpG2KzIhx6I9XHZgzUELLMNX6dYKCo7GkWfdv6cnbEXQ/cLqzF?=
 =?us-ascii?Q?Ii2jd3v0UE6NexRDvh8lMMP65WZNaDPfcjFcAEzr03kUOD6ycZGlpODBbma2?=
 =?us-ascii?Q?4lPhj27NMbq4uoiXrJ4JcCjvQUzhTf8FjXZYbPeZFgtuwtYAvcOnF/vGW/vL?=
 =?us-ascii?Q?vpFEhPIerKmklxT7Prl1luE+m6Eswvu99BLaDG29eLuwAOznjMP886PBFtMJ?=
 =?us-ascii?Q?wsTwQ1l9I8bmLmE4ShGjBKOmcF98EM43ip6MlygzlW8oy2Y6UUqFlkpnihQr?=
 =?us-ascii?Q?ZYnNAuN2xyOwb/dQCQMu65yfSS9+bwZhpOConoWfQkbqPeYp7QCupkMq9vjq?=
 =?us-ascii?Q?5ElyvHQ0RAp8vSfB5Hyk43wzdLC/n2JbdqrJ7R4dmsxWJT8LMUTcCIU9OeMx?=
 =?us-ascii?Q?Cisl7tI6Tk0Q5zu3c2mdEONUF2Menjacp3eFVd9I88shWrkF5+vzmq+iiT7Z?=
 =?us-ascii?Q?P9qKEIuyw/mJVVFEJLhid+GhA9dy9JUOXymoELFirsNAMdEOLi4TY16FBSSu?=
 =?us-ascii?Q?WnvOAXbjdu2WZZj2Q2gX16xXp1j4/PG/3aFJaVfWSUm8FjYQofLUARxVRW07?=
 =?us-ascii?Q?VKtU3errLBIpvl/c4+d2VJwvpbU/dzeAQDMycnVhmlyK8OzjQkREcaMgZ04E?=
 =?us-ascii?Q?FMnF/P7GQNKnaDtjeY/hKce1XsyPwGrDK25rbZiGmy+UFGxU2c6luYVcQJDs?=
 =?us-ascii?Q?Zg6Hq9HXlL1ehm76aZ2tTUsLa9HAm34rVmvjafqlXFFVQn/BMGgqEZ2UOn0S?=
 =?us-ascii?Q?mUVaer9jUT4Xvj2s81pSVLMxRaZL0DNrFlVUAr9L?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4b321c-a4e7-4842-67e1-08dac0cdcb46
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 14:38:53.9907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmOk99sx+wqNPago2QOo66BcR6fkyi/yz2pGPpIU9NjCzAbA0zbCZ1SRe8xteo7wskES4aKGLxFcrMXbWVTC/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code logic of handling the quirk of FEC_QUIRK_HAS_RACC.
If a SoC has the RACC quirk, the driver will enable the 16bit shift
by default in the probe function for a better performance.

This patch handles the logic in one place to make the logic simple
and clean. The patch optimizes the fec_enet_xdp_get_tx_queue function
according to Paolo Abeni's comments, and it also exludes the SoCs that
require to do frame swap from XDP support.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 49 ++++++++++++++---------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6b062a0663f4..3fb870340c22 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1581,8 +1581,20 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	bool	need_swap = fep->quirks & FEC_QUIRK_SWAP_FRAME;
 	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
 	u32 ret, xdp_result = FEC_ENET_XDP_PASS;
+	u32 data_start = FEC_ENET_XDP_HEADROOM;
 	struct xdp_buff xdp;
 	struct page *page;
+	u32 sub_len = 4;
+
+#if !defined(CONFIG_M5272)
+	/*If it has the FEC_QUIRK_HAS_RACC quirk property, the bit of
+	 * FEC_RACC_SHIFT16 is set by default in the probe function.
+	 */
+	if (fep->quirks & FEC_QUIRK_HAS_RACC) {
+		data_start += 2;
+		sub_len += 2;
+	}
+#endif
 
 #ifdef CONFIG_M532x
 	flush_cache_all();
@@ -1645,9 +1657,9 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 
 		if (xdp_prog) {
 			xdp_buff_clear_frags_flag(&xdp);
+			/* subtract 16bit shift and FCS */
 			xdp_prepare_buff(&xdp, page_address(page),
-					 FEC_ENET_XDP_HEADROOM, pkt_len, false);
-
+					 data_start, pkt_len - sub_len, false);
 			ret = fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq, index);
 			xdp_result |= ret;
 			if (ret != FEC_ENET_XDP_PASS)
@@ -1659,18 +1671,15 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		 * bridging applications.
 		 */
 		skb = build_skb(page_address(page), PAGE_SIZE);
-		skb_reserve(skb, FEC_ENET_XDP_HEADROOM);
-		skb_put(skb, pkt_len - 4);
+		skb_reserve(skb, data_start);
+		skb_put(skb, pkt_len - sub_len);
 		skb_mark_for_recycle(skb);
-		data = skb->data;
 
-		if (need_swap)
+		if (unlikely(need_swap)) {
+			data = page_address(page) + FEC_ENET_XDP_HEADROOM;
 			swap_buffer(data, pkt_len);
-
-#if !defined(CONFIG_M5272)
-		if (fep->quirks & FEC_QUIRK_HAS_RACC)
-			data = skb_pull_inline(skb, 2);
-#endif
+		}
+		data = skb->data;
 
 		/* Extract the enhanced buffer descriptor */
 		ebdp = NULL;
@@ -3562,6 +3571,13 @@ static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 
 	switch (bpf->command) {
 	case XDP_SETUP_PROG:
+		/* No need to support the SoCs that require to
+		 * do the frame swap because the performance wouldn't be
+		 * better than the skb mode.
+		 */
+		if (fep->quirks & FEC_QUIRK_SWAP_FRAME)
+			return -EOPNOTSUPP;
+
 		if (is_run) {
 			napi_disable(&fep->napi);
 			netif_tx_disable(dev);
@@ -3589,17 +3605,12 @@ static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 }
 
 static int
-fec_enet_xdp_get_tx_queue(struct fec_enet_private *fep, int cpu)
+fec_enet_xdp_get_tx_queue(struct fec_enet_private *fep, int index)
 {
-	int index = cpu;
-
 	if (unlikely(index < 0))
-		index = 0;
-
-	while (index >= fep->num_tx_queues)
-		index -= fep->num_tx_queues;
+		return 0;
 
-	return index;
+	return (index % fep->num_tx_queues);
 }
 
 static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
-- 
2.34.1

