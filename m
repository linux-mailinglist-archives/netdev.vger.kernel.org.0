Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF506F4A67
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjEBTco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 15:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjEBTcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 15:32:43 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2058.outbound.protection.outlook.com [40.107.22.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BED31BD4;
        Tue,  2 May 2023 12:32:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHptrXAWhjg/2BjOk8/5tV7nn2tVjCRr0j1hqI54pfI0MXkPEyFQVQrKP6ttRQzdDGoNnNt9qINGxiFxW7NEYtmBewUWoDhmIPzCCVk9iK5VBVA2tZ/DFN3Q5i0vONkzKTpt3XGUqiJPw8PYxaFmsvp7pkHqUn3t+cNmSxOXaIeav6nIt6G+jFjR+9N+B8oCHHctvrMb2GzCqO+CWiCTIpTzwvGaYybWBpCJ0TqyRddvz3GDlfEKhior8oRPqNwbqoXSMhnugX3WmpixbaU9X5qA8KojyMKRVM041txzh7hThUT3Qrfo61eWwCfo4YzdNst3eOfV+kGYd1jKPSb/7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MldvJxy1DAIFiFN8EGunLpgW1zoY5ftErRFdR7dIPM4=;
 b=OPwVO6vaiUBxEKxaMG2eukmT3QDF0b4O1g+tUJDbiyxVvIeJEa6eUrDUT2nIOU86ApIbbOxLNTQPpYa07B60UCAX0WIj/SFMUWRhRI94oUYCEDYS2Dxhoh6rdnQy1gs0vx3ym2gl50RP4stFQrX15Je0AoXjal194OJs4z7W85Ea2ek3G1/2bo8oL5ReANOVlYQrr3j0ViDWjroGVBPAAW9GK1XzLcFMGfLUXBbmX/ZDCirAozFCvcyQW8qMJ+bnM9qKCkks8ov4Ya7tmS/UdT2RflU28Wz2B5kZBh6Q/YRNixFojrYmzpcGq+s4n6cesUfPzOgnETZx7ljQ+EmcFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MldvJxy1DAIFiFN8EGunLpgW1zoY5ftErRFdR7dIPM4=;
 b=lx+asPIqOQzS3r1Jm+px9kdS1RkuuPrIQUj7vLlv/82BTMmH1N3XW8VgRsKVhL8K/g/QTgqZBhCtEEF4AvILWe0IkEV1DXZDmuEw2WnlbThGdOJS9fnf4K+vKkvQ1TRUq619esKyhqdhRJs0vVgoft9Bentjd/1yZ/Sk/ZY+15M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DU2PR04MB8696.eurprd04.prod.outlook.com (2603:10a6:10:2df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 19:32:37 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 19:32:37 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Gagandeep Singh <g.singh@nxp.com>
Subject: [PATCH 1/1] net: fec: enable the XDP_TX support
Date:   Tue,  2 May 2023 14:32:19 -0500
Message-Id: <20230502193219.673637-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::26) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DU2PR04MB8696:EE_
X-MS-Office365-Filtering-Correlation-Id: 427e9219-b0e2-4f97-3245-08db4b43fc18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wClDEEcnHgNZNVWGN7o5F4nDDDoWUi0t4d7vYAuLASxtNSAy+uAg9kbFrQjwmsnuynAUa5BfYoBRBab/ZTraLpeid6cILp4qt0dOGOLCpEIMBU11ROawUhbN8zm48KkjyLnNWF9MPFVvycyMUQjC7A6BpA/vTC4zX35gj6i5vxzJg8Z72+jRGUazsh2csAruog8wXqAHpumn37PgmEdxQs1nCmxCIhB3kFeoVmMxvROXTYGidD8TLoKYpFXHJcXIq5FCQO1oGpSpft/7IH7TsgYWAfqYJP/fldmMWh5aSFQsCQndFTWNGuh1iZyLRTyob+6U+9h80HO5ZdJYi0t8ahiWsD3mdTmCVWHohAFH8mE6Y+9nLlq17HusQs+7N4OrwBc+Hzlz39XOmss1j8Hg9xE4CgqhBlXQJK5/0UQdlWpR1YFyv3o0Ei7AcDenHjOLyzy9xN9PN96OhfuQE+S5+a30BvlzzhsKlfFIVX8eV87tAdZmgxiv2FD1+FThJ8sehh9okTWwAO6wUxtkcUSjoTvjlv5ZmUEiCm6p3jtC18BVRsjQf6//nH9S+NNcrG3hobBKfM/FpdXyQH5Jgi85ZqaXvEyOmwMmKueAYZjC2zs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199021)(55236004)(2616005)(83380400001)(186003)(4326008)(66556008)(66476007)(41300700001)(7416002)(5660300002)(2906002)(66946007)(44832011)(8936002)(8676002)(6512007)(6506007)(26005)(316002)(1076003)(110136005)(86362001)(478600001)(52116002)(38100700002)(38350700002)(36756003)(54906003)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fV+2h6ETXUpKwPBDltYf1lWSwBOJoeDys70+Wbniolwf2D3lQ1IYKEYFrz7V?=
 =?us-ascii?Q?9LaGjE5AO/hu3ktUhOc/I1UWqEIev1bbpqBPnNJYBggeaIka6qU4Pj/qJHm3?=
 =?us-ascii?Q?DnrsLyS0V78r7lGqgXMiHohOZ3zSzDSg8Ev71MfWOLldjm/11NvDXaJMi4Rj?=
 =?us-ascii?Q?CPqYscwtiJUDylMVl+ykBsOXAVAIng2mFKShNwZ6e3wSPu29hyDOdNt+dgXY?=
 =?us-ascii?Q?J5bVBjwvqzuf3ix+F/Wmc3e27nL+wABYNrXEdq+lvpKVFSgjoq7YMTOrxj3r?=
 =?us-ascii?Q?9EYeoZxC0WE52D/sL6EEfnaQEl0zqtgejpCpODmRpRqg9CPk4i2BMfPS/4nc?=
 =?us-ascii?Q?irUhwgnjlfcm8zrI8p2rHwF8rf0rqZTrKoFSPvX9CG8slZKLuWOTly86UJBY?=
 =?us-ascii?Q?GDxbxWWizu+MiWK+vNV5d/W/xgXZ3maenBrQfNhOd1lUVoFOwKu+3AGPAEJe?=
 =?us-ascii?Q?BHocTJqeuBooQWJY4o9BLbO44iiZK326CWtWkkkQGMTObJAQFKH5VRwX8oWE?=
 =?us-ascii?Q?xqqODsDy2V8MMRBmpLCPXeDIJkcCeZdIxU2xDftS6fIkIxl5IsFbKpr/i2UK?=
 =?us-ascii?Q?fgYz/Ds/m7QUYbUgaELhzhjrtWaWSdrZQ5LYrCVHI1oBOJmGU/hvfn2IJTe2?=
 =?us-ascii?Q?FeNsuWE/JMvyLKgM/F7snaiigXizk6QT1vd2E36pV4Ud57tZIfw+xCG8qys6?=
 =?us-ascii?Q?UxkfeSoEibnxkwjVZRUo+QhSO1fJ2eCLHbqCAXSEaiyi7BiiAULfjc35kjOY?=
 =?us-ascii?Q?1TgvGpv8K0mbp4tXmwSFxlURtqHq1dH6Ru6FaKGFWYg7Ng+syyIC4gmphvrN?=
 =?us-ascii?Q?xLBvN/6SDZ+QPhSAPLbqHYJrydfGBl1N5EDiBwiEstYoEaHe58I+3uqy7uuK?=
 =?us-ascii?Q?KS7tLNiOZ1mhlTksEiSg1LNTrN1C5jiwgDiSzIP1kkCxN40oEMOExnOQRL/9?=
 =?us-ascii?Q?FD2D0rApyD+e+RMMvQAoZkBjAFSChiaVmyJdPNuYOiiArOPmuapeZwUjmLBV?=
 =?us-ascii?Q?cESJzQTOq1Z6iOz3Ph0P6uh1kqfX4EyyDDqai+kpdQACeaQFtIMEHK8VRzQV?=
 =?us-ascii?Q?wKpE2qZQMkXNuVCWUceBJ9NZgvH4SqP0Z7uTLhTmHXhPEZ+IJbsb1iq6ecFg?=
 =?us-ascii?Q?ntpWLYShkv/EaQ/wT7gFeDcso7yuU8IdRwlWQVoFtE1E49r4h8SS5O8VTfXB?=
 =?us-ascii?Q?SFXoMvVw0Rq2irPEZDhyCce8BlYlMr3SAev8AFQGtGf3zutJ08VXtf/SrqMd?=
 =?us-ascii?Q?jiBGo59fT8dI7wAGtXoq8ewg3Uq3lYqf3PK3INaJJasE4aS/4wB0y+0rn52o?=
 =?us-ascii?Q?qC8KrFL52XmWjIkgjJppvHD9SYIwqJtCsSFdh13SVmCGv//QHa5kueGzSp9W?=
 =?us-ascii?Q?3p8Xm/ohtVrYo0CEB4gquqyRkrSGBp+S/YAsAlNAR8sO/XccGwhIXx8gpEHc?=
 =?us-ascii?Q?xgronp94w10GOP0+XqRJ1Lu6RWEZv/upDXzurmbb60Fy664lDPRLRHelr8d6?=
 =?us-ascii?Q?64W/RtHnOuoJGDt5Trbb0SDdjSmRXg9Fn2TkLVROiRPBkyw3ZZ2DGJqgxwTY?=
 =?us-ascii?Q?THXoAxhZ7e6DU2ZGbKFs1t2o794tE3gvnXJAUTd+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 427e9219-b0e2-4f97-3245-08db4b43fc18
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 19:32:37.0087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a6ns5ZgFK5ZzBCzl71HWOJtMArsC5Cy/raloTNRaJSoZ1UWBOmo5iBe7n8/iZ/0J65LYqyzqHgDQO8Ag8Uk0hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8696
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the XDP_TX path and correct the return value of the xmit function.

If any individual frame cannot transmit due to lack of BD entries, the
function would still return success for sending all frames. This results
in prematurely indicating frames were sent when they were actually dropped.

The patch resolves the issue by ensureing the return value properly
indicates the actual number of frames successfully transmitted, rather than
potentially reporting success for all frames when some could not transmit.

Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
Signed-off-by: Gagandeep Singh <g.singh@nxp.com>
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 27 ++++++++++++++++-------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 160c1b3525f5..dfc1bcc9a8db 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -75,6 +75,10 @@
 
 static void set_multicast_list(struct net_device *ndev);
 static void fec_enet_itr_coal_set(struct net_device *ndev);
+static int fec_enet_xdp_xmit(struct net_device *dev,
+			     int num_frames,
+			     struct xdp_frame **frames,
+			     u32 flags);
 
 #define DRIVER_NAME	"fec"
 
@@ -1517,6 +1521,7 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
 {
 	unsigned int sync, len = xdp->data_end - xdp->data;
 	u32 ret = FEC_ENET_XDP_PASS;
+	struct xdp_frame *xdp_frame;
 	struct page *page;
 	int err;
 	u32 act;
@@ -1545,11 +1550,12 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
 		}
 		break;
 
-	default:
-		bpf_warn_invalid_xdp_action(fep->netdev, prog, act);
-		fallthrough;
-
 	case XDP_TX:
+		xdp_frame = xdp_convert_buff_to_frame(xdp);
+		ret = fec_enet_xdp_xmit(fep->netdev, 1, &xdp_frame, 0);
+		break;
+
+	default:
 		bpf_warn_invalid_xdp_action(fep->netdev, prog, act);
 		fallthrough;
 
@@ -3798,7 +3804,8 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	entries_free = fec_enet_get_free_txdesc_num(txq);
 	if (entries_free < MAX_SKB_FRAGS + 1) {
 		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
-		return NETDEV_TX_OK;
+		xdp_return_frame(frame);
+		return NETDEV_TX_BUSY;
 	}
 
 	/* Fill in a Tx ring entry */
@@ -3856,6 +3863,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 	struct fec_enet_private *fep = netdev_priv(dev);
 	struct fec_enet_priv_tx_q *txq;
 	int cpu = smp_processor_id();
+	unsigned int sent_frames = 0;
 	struct netdev_queue *nq;
 	unsigned int queue;
 	int i;
@@ -3866,8 +3874,11 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 
 	__netif_tx_lock(nq, cpu);
 
-	for (i = 0; i < num_frames; i++)
-		fec_enet_txq_xmit_frame(fep, txq, frames[i]);
+	for (i = 0; i < num_frames; i++) {
+		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)
+			break;
+		sent_frames++;
+	}
 
 	/* Make sure the update to bdp and tx_skbuff are performed. */
 	wmb();
@@ -3877,7 +3888,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 
 	__netif_tx_unlock(nq);
 
-	return num_frames;
+	return sent_frames;
 }
 
 static const struct net_device_ops fec_netdev_ops = {
-- 
2.34.1

