Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBEE354842F
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 12:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiFMJ7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiFMJ7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:59:03 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2132.outbound.protection.outlook.com [40.107.212.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58E41CB19
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 02:59:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edM4KI7mRZdxIWOIeYKvEgeGeUSW0FofwE2N6PDR6nrW5+vuzEkdXiMdGmMCAywTK/xJvTDTZKHHMYPWXl6EkA69G5XZK3FqbEauKbCSNKznOqnB6JEaxnXHmXuEqD3AKKfRADCRvjWAMCIbObYjrivjoK+4N0WQXZR8JM3rjnUt3atYi91CBUktig43EmEeS6uWkZvUvoPsWVQ4CxHABimnjEkpdjexTmpJ4L1z8/0yUNavIF13ro2zD9AbvLRcmDgsAjbR/5Gq2+SCZKjfD2UwT3EgL+iSTQiyLjOiTk4B7kbxpkvW0r4eA8FtC5yWySqHd6K/ZuaK4I1y+9nYeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06ncro0B+YvJ9FdMY1yFDHZq8wP+QL8L9wzTir6wj4I=;
 b=hRP6+uzHemd62e1LCpAITH1LW5TFPhLQXkgL887UPw3z/lU8aP1dkG8KET1Vn2z5AdULmNlqkTpmlve5KSVcGB0HX1j+TvVddKuQYvZ+qFQUATyDEJ7r3ertnkLUDbLlCkglCNjPYbLtWniVwhoJ2+93YaqA7HMCYNon9sh60EthSyE5CRvgWKxQUI8mLUCe7ltbX6vEi0fFuicKaBZQo5XIiRqjgF5D+WvndCi0+eooCX4WSfsiQIi8V4MAHTq5LIq8hSrDgmunjJAr9jwmQ5EbkWPrJiYSWAVZRymOYGbjA6VTk7+i4mdXj9jtWVNIWULOIWYdy90t56GM/x7Yqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06ncro0B+YvJ9FdMY1yFDHZq8wP+QL8L9wzTir6wj4I=;
 b=hjBMYV3jSbakfU4iqL7un3RR9weJVrS812h93FPRoGoLAs25Ww0gR9KPi50awiuRp3n7Yk5bzuYzhl4XWejplEzjEs29j3SutuY9jowpnLjenSmMJBv5XxvBMpA+ykEHLoT6bPFP1v9phtJP4r/cm3g1z5pzbxrpti07bidIoss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5625.namprd13.prod.outlook.com (2603:10b6:303:180::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.6; Mon, 13 Jun
 2022 09:58:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%7]) with mapi id 15.20.5353.010; Mon, 13 Jun 2022
 09:58:57 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next] nfp: support 48-bit DMA addressing for NFP3800
Date:   Mon, 13 Jun 2022 11:58:31 +0200
Message-Id: <20220613095831.4963-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0031.eurprd03.prod.outlook.com
 (2603:10a6:208:14::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 762447cb-3151-415c-0c6c-08da4d235514
X-MS-TrafficTypeDiagnostic: MW4PR13MB5625:EE_
X-Microsoft-Antispam-PRVS: <MW4PR13MB5625899130EEC713B4275188E8AB9@MW4PR13MB5625.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rmNJF4Bx9zH76Otn1xvomXxeeRpG5X/SwWtH7B7nYLpjGb8Wvv1mpD9eUyY/OYtf4qMOa6xt/+AFL8zRb+IccIifgaEO3O/13L8pROmH8koDujRKJHjMhybIeBfYt6X9UvirXE81BOqb3TE1BntVm+G62/YDOYkoApGptXLJ+fcK3aKB1LsO5U6F6F6GNUGUkjCw7S6i/CFM7TWrbcpQrtyyyQNHtsJ7Dw6A4zKaK8bULknC+9ISExoARapY9LsqSLWPaUYPPWq8ScXlsfMvipk1NeVGWXaxrdca6wlrzzlSBMNCAPeL9lCQ5GRqbhWptiREfSSfz5xT8PVnE/nRFs3XoiG5M2jHi2YMWt0tuESyVazQqN4ECFBpL03tyOvVrXIjdSDBtfL8nMvSLnuYF9MLAR6PEbKtBddM8be+lAUyXeveGGA5oLKZ6IXXibIhv1+6dmHVxanX+XKsmwm+fPBA56my0/8gUXQBg9OkmRaRv2wbt7G50Vkae46KAWwXjDZY50VKDq7IsoWoGGCvl4LNvI7yYZHH5mA5oiaDs6Uj4Fr3xoySLTBGL3LzaXUz+Zom14vPqU/PlSkvL8yF/IlA5mk+QgC5ZGAYzihC41XN45JdN4DpRPgBSmdFET/zwn3SGd0vzupyQJutXWd2WMc7yerhZxdbLTednDHt4rs5s5X/0ciWznDSf23xIQ2+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39830400003)(366004)(136003)(346002)(6666004)(52116002)(6506007)(186003)(107886003)(1076003)(6512007)(38100700002)(41300700001)(2616005)(83380400001)(30864003)(5660300002)(8936002)(44832011)(8676002)(86362001)(4326008)(36756003)(66556008)(66946007)(2906002)(66476007)(110136005)(6486002)(508600001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wn6NpN2ZqHBgRp7qITMecxaTq9qBAvpBbheArE0V9yMcRsBDbPGlONmB3dka?=
 =?us-ascii?Q?U/SmZwzjqlJjp122TJ8ZAWL/dU/NV2ClN9+ChfsKhubRH+C8wsd1yO1QHM1Z?=
 =?us-ascii?Q?Wd0WdvzTZd3wlRfWtrjRl8WVGTs9BbtFjU9kC07JPpWYN1A2QyQTzblNRbie?=
 =?us-ascii?Q?wN7DSBcxpyS0Rb4upglvn3/gbmQ7a+ki0+7A3vweaf11mFcsikJ/sh/NOaQH?=
 =?us-ascii?Q?FJeUE1ap1WMHnps9jYWmQ/TU3cd4cKknqEgyJgJ2+MVAj2KR8EesVCkeTIJw?=
 =?us-ascii?Q?2ACgRwMuouJWXb4nThf4L4GAHeUPuNU3X5QKwIDQbG5xllHM/M83gz89JMwY?=
 =?us-ascii?Q?6sVsJWk3uum23EDB6HG81YOyibtr+b6RC71/Dn+e5YovmxqqxWUl6lLlS/e+?=
 =?us-ascii?Q?Q+gumNBJBhCmdNK9jseBnVMKkZtXXbVkiEaI/enn3/lfohqTXmYNYHkct3ME?=
 =?us-ascii?Q?0V2D9WbyVuj41N+uS3iMRwRWDHXoNQINxC0UjuPhMRC0wwzzJCCjUxRckPcs?=
 =?us-ascii?Q?z1rK0EEqNw1YsS+1NKy0ePlKMON07nQgggtlRFRP5ztrchasINJQS41QIWg9?=
 =?us-ascii?Q?XZwnPA372j/UVWYrWLDfCv+2MccLmVhlrpAKJZ1VtsEtcv4tyDe7EifZ2G0G?=
 =?us-ascii?Q?xHs5M7he/c1rdnpeTkGw7N74vnPMYL0dC0XNkutcmOevIUtchByRR6769K0K?=
 =?us-ascii?Q?0N+a7Zd+8Ss0WYYRVq5PLo5mtJjUCdZVeRlZBzqLVewBYS6q2fA7o+YWTO8Q?=
 =?us-ascii?Q?vDYgVtblHjl6ODdcXaPXce/XdsM6xLzMDozoS7KHhdlso4m0o5FQTJLrsAGB?=
 =?us-ascii?Q?8IfS9XMX0hMmYCYbXUV2tJKSz7y2u4RxyztfnpzezBsvcC2GngknZ8KuIHY5?=
 =?us-ascii?Q?yY0jr5Q3HgrU1tcupPfgrvO/XBB0avYFwbeIz/dKpT/ViO5i9E/FehKmPMdB?=
 =?us-ascii?Q?aMCN2GSV+vstH1ML3Xd9XKqh58Xunuq+gGzjmqaFLYw3/WRKpp4zh34ycG9s?=
 =?us-ascii?Q?migsu5UzwJ3nH5s7yMIatF6XY8P0dfbAN4sthN7OnF5386WHfhp5BNroB70b?=
 =?us-ascii?Q?u/UerR1OCzjxq5G0dOFYQaoOhmnT7g+K01GYvSVxbHUzxDVG7mmrDmZYMiky?=
 =?us-ascii?Q?TS7kTvhX9UYoV0InwqVTQKa3XTlkfd0PRQ0tnz9KHf0MbPomqNEc2hLHcfJn?=
 =?us-ascii?Q?ltS9W+p6Qclazf1zLaZGJk23s+Xab1xVPuu7Gwn99Y4pkJ1uCvIWJlm/PUL2?=
 =?us-ascii?Q?ZjtnOb0UmzIsCP3BQQpsK4lvMuIZNxslfkvlcl6f8M2sSRSseXnP327gPMDE?=
 =?us-ascii?Q?z9BSgcGTdw5+d1bzKGi3iQKL34Wh/PGANJ81Aqpu5YVoLwJLqlyTsQiEe1wq?=
 =?us-ascii?Q?GOPpDQPYaXebB7dKHGYUYjQ2SNNIBwdFMZ+56GONcDR18KRcttobE/2+S5wn?=
 =?us-ascii?Q?9g+ri2Jmax+nAdBNToCXhdCWq9BIB6br1Gmm/Mo+J2CSY98VJz/yOi38vplL?=
 =?us-ascii?Q?cLHtVxphhrCw4k6PKcFASpc4iYfwsEhaIJYcgbObjZKPgVOPOL2F3VXZFkli?=
 =?us-ascii?Q?zpcTI0Ize/Gnark2BaTPU1gvYM6xlIaYnn8FnN8XEwhgxi+r64CQdZPyMHpi?=
 =?us-ascii?Q?zU3bEn60+dG8iGtytgwzheyfU4F9e0JUNHqqSKckLClmOSD72wTKvHeM6IXo?=
 =?us-ascii?Q?2SkllsIwF7P2lyowYthe3XVtGSJ6fshGEQdBT3X2jit0ouOJoXR5VHnMtWqv?=
 =?us-ascii?Q?vXrZR2v9+qBEcD0iBgyiO7E1hYiEpJBRx69g2FozQvwQqC5Lj949E/wA6Lu1?=
X-MS-Exchange-AntiSpam-MessageData-1: b+fXF/Y6xPMmiqBmg4WhMfVlTPdPJ7LWGUY=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 762447cb-3151-415c-0c6c-08da4d235514
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 09:58:57.4792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzxWkcFoGH8H6PMkNntn2qc4tcC8LRLTORWDbSvFykWdWPyXB76t5ulijTZrSCqJzZW8FTh0M0G4DvnzywwDp65jgna45u2uOglVLPn90FI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5625
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

48-bit DMA addressing is supported in NFP3800 HW and implemented
in NFDK firmware, so enable this feature in driver now. Note that
with this change, NFD3 firmware, which doesn't implement 48-bit
DMA, cannot be used for NFP3800 any more.

RX free list descriptor, used by both NFD3 and NFDK, is also modified
to support 48-bit DMA. That's OK because the top bits is always get
set to 0 when assigned with 40-bit address.

Based on initial work of Jakub Kicinski <jakub.kicinski@netronome.com>.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  | 16 +++++++++------
 .../net/ethernet/netronome/nfp/nfd3/rings.c   |  1 +
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c |  8 +++-----
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 16 +++++++--------
 .../net/ethernet/netronome/nfp/nfdk/rings.c   |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  | 20 +++++++++----------
 .../ethernet/netronome/nfp/nfp_net_common.c   |  9 +++++++++
 .../net/ethernet/netronome/nfp/nfp_net_dp.h   |  2 ++
 .../net/ethernet/netronome/nfp/nfp_net_xsk.c  |  8 ++++++--
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.c  |  4 ++--
 10 files changed, 52 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 7db56abaa582..f9410d59146d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -282,7 +282,7 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 	txd = &tx_ring->txds[wr_idx];
 	txd->offset_eop = (nr_frags ? 0 : NFD3_DESC_TX_EOP) | md_bytes;
 	txd->dma_len = cpu_to_le16(skb_headlen(skb));
-	nfp_desc_set_dma_addr(txd, dma_addr);
+	nfp_desc_set_dma_addr_40b(txd, dma_addr);
 	txd->data_len = cpu_to_le16(skb->len);
 
 	txd->flags = 0;
@@ -320,7 +320,7 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 
 			txd = &tx_ring->txds[wr_idx];
 			txd->dma_len = cpu_to_le16(fsize);
-			nfp_desc_set_dma_addr(txd, dma_addr);
+			nfp_desc_set_dma_addr_40b(txd, dma_addr);
 			txd->offset_eop = md_bytes |
 				((f == nr_frags - 1) ? NFD3_DESC_TX_EOP : 0);
 			txd->vals8[1] = second_half;
@@ -562,8 +562,12 @@ nfp_nfd3_rx_give_one(const struct nfp_net_dp *dp,
 	/* Fill freelist descriptor */
 	rx_ring->rxds[wr_idx].fld.reserved = 0;
 	rx_ring->rxds[wr_idx].fld.meta_len_dd = 0;
-	nfp_desc_set_dma_addr(&rx_ring->rxds[wr_idx].fld,
-			      dma_addr + dp->rx_dma_off);
+	/* DMA address is expanded to 48-bit width in freelist for NFP3800,
+	 * so the *_48b macro is used accordingly, it's also OK to fill
+	 * a 40-bit address since the top 8 bits are get set to 0.
+	 */
+	nfp_desc_set_dma_addr_48b(&rx_ring->rxds[wr_idx].fld,
+				  dma_addr + dp->rx_dma_off);
 
 	rx_ring->wr_p++;
 	if (!(rx_ring->wr_p % NFP_NET_FL_BATCH)) {
@@ -817,7 +821,7 @@ nfp_nfd3_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 	txd = &tx_ring->txds[wr_idx];
 	txd->offset_eop = NFD3_DESC_TX_EOP;
 	txd->dma_len = cpu_to_le16(pkt_len);
-	nfp_desc_set_dma_addr(txd, rxbuf->dma_addr + dma_off);
+	nfp_desc_set_dma_addr_40b(txd, rxbuf->dma_addr + dma_off);
 	txd->data_len = cpu_to_le16(pkt_len);
 
 	txd->flags = 0;
@@ -1193,7 +1197,7 @@ nfp_nfd3_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 	txd = &tx_ring->txds[wr_idx];
 	txd->offset_eop = meta_len | NFD3_DESC_TX_EOP;
 	txd->dma_len = cpu_to_le16(skb_headlen(skb));
-	nfp_desc_set_dma_addr(txd, dma_addr);
+	nfp_desc_set_dma_addr_40b(txd, dma_addr);
 	txd->data_len = cpu_to_le16(skb->len);
 
 	txd->flags = 0;
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
index 47604d5e25eb..f31eabdc0631 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
@@ -260,6 +260,7 @@ const struct nfp_dp_ops nfp_nfd3_ops = {
 	.version		= NFP_NFD_VER_NFD3,
 	.tx_min_desc_per_pkt	= 1,
 	.cap_mask		= NFP_NFD3_CFG_CTRL_SUPPORTED,
+	.dma_mask		= DMA_BIT_MASK(40),
 	.poll			= nfp_nfd3_poll,
 	.xsk_poll		= nfp_nfd3_xsk_poll,
 	.ctrl_poll		= nfp_nfd3_ctrl_poll,
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
index c16c4b42ecfd..454fea4c8be2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
@@ -40,7 +40,7 @@ nfp_nfd3_xsk_tx_xdp(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 	txd = &tx_ring->txds[wr_idx];
 	txd->offset_eop = NFD3_DESC_TX_EOP;
 	txd->dma_len = cpu_to_le16(pkt_len);
-	nfp_desc_set_dma_addr(txd, xrxbuf->dma_addr + pkt_off);
+	nfp_desc_set_dma_addr_40b(txd, xrxbuf->dma_addr + pkt_off);
 	txd->data_len = cpu_to_le16(pkt_len);
 
 	txd->flags = 0;
@@ -361,10 +361,8 @@ static void nfp_nfd3_xsk_tx(struct nfp_net_tx_ring *tx_ring)
 
 			/* Build TX descriptor. */
 			txd = &tx_ring->txds[wr_idx];
-			nfp_desc_set_dma_addr(txd,
-					      xsk_buff_raw_get_dma(xsk_pool,
-								   desc[i].addr
-								   ));
+			nfp_desc_set_dma_addr_40b(txd,
+						  xsk_buff_raw_get_dma(xsk_pool, desc[i].addr));
 			txd->offset_eop = NFD3_DESC_TX_EOP;
 			txd->dma_len = cpu_to_le16(desc[i].len);
 			txd->data_len = cpu_to_le16(desc[i].len);
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index e509d6dcba5c..300637e576a8 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -314,7 +314,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
-	nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
+	nfp_desc_set_dma_addr_48b(txd, dma_addr);
 
 	/* starts at bit 0 */
 	BUILD_BUG_ON(!(NFDK_DESC_TX_DMA_LEN_HEAD & 1));
@@ -339,7 +339,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 			dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
 
 			txd->dma_len_type = cpu_to_le16(dlen_type);
-			nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
+			nfp_desc_set_dma_addr_48b(txd, dma_addr);
 
 			dma_len -= dlen_type;
 			dma_addr += dlen_type + 1;
@@ -595,8 +595,8 @@ nfp_nfdk_rx_give_one(const struct nfp_net_dp *dp,
 	/* Fill freelist descriptor */
 	rx_ring->rxds[wr_idx].fld.reserved = 0;
 	rx_ring->rxds[wr_idx].fld.meta_len_dd = 0;
-	nfp_desc_set_dma_addr(&rx_ring->rxds[wr_idx].fld,
-			      dma_addr + dp->rx_dma_off);
+	nfp_desc_set_dma_addr_48b(&rx_ring->rxds[wr_idx].fld,
+				  dma_addr + dp->rx_dma_off);
 
 	rx_ring->wr_p++;
 	if (!(rx_ring->wr_p % NFP_NET_FL_BATCH)) {
@@ -929,7 +929,7 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
-	nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
+	nfp_desc_set_dma_addr_48b(txd, dma_addr);
 
 	tmp_dlen = dlen_type & NFDK_DESC_TX_DMA_LEN_HEAD;
 	dma_len -= tmp_dlen;
@@ -940,7 +940,7 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 		dma_len -= 1;
 		dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
 		txd->dma_len_type = cpu_to_le16(dlen_type);
-		nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
+		nfp_desc_set_dma_addr_48b(txd, dma_addr);
 
 		dlen_type &= NFDK_DESC_TX_DMA_LEN;
 		dma_len -= dlen_type;
@@ -1332,7 +1332,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
-	nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
+	nfp_desc_set_dma_addr_48b(txd, dma_addr);
 
 	tmp_dlen = dlen_type & NFDK_DESC_TX_DMA_LEN_HEAD;
 	dma_len -= tmp_dlen;
@@ -1343,7 +1343,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 		dma_len -= 1;
 		dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
 		txd->dma_len_type = cpu_to_le16(dlen_type);
-		nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
+		nfp_desc_set_dma_addr_48b(txd, dma_addr);
 
 		dlen_type &= NFDK_DESC_TX_DMA_LEN;
 		dma_len -= dlen_type;
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/rings.c b/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
index 301f11108826..f4d94ae0a349 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
@@ -181,6 +181,7 @@ const struct nfp_dp_ops nfp_nfdk_ops = {
 	.version		= NFP_NFD_VER_NFDK,
 	.tx_min_desc_per_pkt	= NFDK_TX_DESC_PER_SIMPLE_PKT,
 	.cap_mask		= NFP_NFDK_CFG_CTRL_SUPPORTED,
+	.dma_mask		= DMA_BIT_MASK(48),
 	.poll			= nfp_nfdk_poll,
 	.ctrl_poll		= nfp_nfdk_ctrl_poll,
 	.xmit			= nfp_nfdk_tx,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 3dd3a92d2e7f..b07cea8e354c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -115,7 +115,7 @@ struct nfp_nfdk_tx_buf;
 #define D_IDX(ring, idx)	((idx) & ((ring)->cnt - 1))
 
 /* Convenience macro for writing dma address into RX/TX descriptors */
-#define nfp_desc_set_dma_addr(desc, dma_addr)				\
+#define nfp_desc_set_dma_addr_40b(desc, dma_addr)			\
 	do {								\
 		__typeof__(desc) __d = (desc);				\
 		dma_addr_t __addr = (dma_addr);				\
@@ -124,13 +124,13 @@ struct nfp_nfdk_tx_buf;
 		__d->dma_addr_hi = upper_32_bits(__addr) & 0xff;	\
 	} while (0)
 
-#define nfp_nfdk_tx_desc_set_dma_addr(desc, dma_addr)			       \
-	do {								       \
-		__typeof__(desc) __d = (desc);				       \
-		dma_addr_t __addr = (dma_addr);				       \
-									       \
-		__d->dma_addr_hi = cpu_to_le16(upper_32_bits(__addr) & 0xff);  \
-		__d->dma_addr_lo = cpu_to_le32(lower_32_bits(__addr));         \
+#define nfp_desc_set_dma_addr_48b(desc, dma_addr)			\
+	do {								\
+		__typeof__(desc) __d = (desc);				\
+		dma_addr_t __addr = (dma_addr);				\
+									\
+		__d->dma_addr_hi = cpu_to_le16(upper_32_bits(__addr));	\
+		__d->dma_addr_lo = cpu_to_le32(lower_32_bits(__addr));	\
 	} while (0)
 
 /**
@@ -225,8 +225,8 @@ struct nfp_net_tx_ring {
 struct nfp_net_rx_desc {
 	union {
 		struct {
-			u8 dma_addr_hi;	/* High bits of the buf address */
-			__le16 reserved; /* Must be zero */
+			__le16 dma_addr_hi; /* High bits of the buf address */
+			u8 reserved; /* Must be zero */
 			u8 meta_len_dd; /* Must be zero */
 
 			__le32 dma_addr_lo; /* Low bits of the buffer address */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 4e56a99087fa..57f284eefeb3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2040,6 +2040,7 @@ nfp_net_alloc(struct pci_dev *pdev, const struct nfp_dev_info *dev_info,
 	      void __iomem *ctrl_bar, bool needs_netdev,
 	      unsigned int max_tx_rings, unsigned int max_rx_rings)
 {
+	u64 dma_mask = dma_get_mask(&pdev->dev);
 	struct nfp_net *nn;
 	int err;
 
@@ -2085,6 +2086,14 @@ nfp_net_alloc(struct pci_dev *pdev, const struct nfp_dev_info *dev_info,
 		goto err_free_nn;
 	}
 
+	if ((dma_mask & nn->dp.ops->dma_mask) != dma_mask) {
+		dev_err(&pdev->dev,
+			"DMA mask of loaded firmware: %llx, required DMA mask: %llx\n",
+			nn->dp.ops->dma_mask, dma_mask);
+		err = -EINVAL;
+		goto err_free_nn;
+	}
+
 	nn->max_tx_rings = max_tx_rings;
 	nn->max_rx_rings = max_rx_rings;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
index c934cc2d3208..83becb338478 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
@@ -117,6 +117,7 @@ enum nfp_nfd_version {
  * @version:			Indicate dp type
  * @tx_min_desc_per_pkt:	Minimal TX descs needed for each packet
  * @cap_mask:			Mask of supported features
+ * @dma_mask:			DMA addressing capability
  * @poll:			Napi poll for normal rx/tx
  * @xsk_poll:			Napi poll when xsk is enabled
  * @ctrl_poll:			Tasklet poll for ctrl rx/tx
@@ -134,6 +135,7 @@ struct nfp_dp_ops {
 	enum nfp_nfd_version version;
 	unsigned int tx_min_desc_per_pkt;
 	u32 cap_mask;
+	u64 dma_mask;
 
 	int (*poll)(struct napi_struct *napi, int budget);
 	int (*xsk_poll)(struct napi_struct *napi, int budget);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
index 86829446c637..aea507aed49d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
@@ -70,8 +70,12 @@ void nfp_net_xsk_rx_ring_fill_freelist(struct nfp_net_rx_ring *rx_ring)
 
 		nfp_net_xsk_rx_bufs_stash(rx_ring, wr_idx, xdp);
 
-		nfp_desc_set_dma_addr(&rx_ring->rxds[wr_idx].fld,
-				      rx_ring->xsk_rxbufs[wr_idx].dma_addr);
+		/* DMA address is expanded to 48-bit width in freelist for NFP3800,
+		 * so the *_48b macro is used accordingly, it's also OK to fill
+		 * a 40-bit address since the top 8 bits are get set to 0.
+		 */
+		nfp_desc_set_dma_addr_48b(&rx_ring->rxds[wr_idx].fld,
+					  rx_ring->xsk_rxbufs[wr_idx].dma_addr);
 
 		rx_ring->wr_p++;
 		wr_ptr_add++;
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
index 28384d6d1c6f..0725b51c2a95 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
@@ -9,7 +9,7 @@
 
 const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT] = {
 	[NFP_DEV_NFP3800] = {
-		.dma_mask		= DMA_BIT_MASK(40),
+		.dma_mask		= DMA_BIT_MASK(48),
 		.qc_idx_mask		= GENMASK(8, 0),
 		.qc_addr_offset		= 0x400000,
 		.min_qc_size		= 512,
@@ -21,7 +21,7 @@ const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT] = {
 		.qc_area_sz		= 0x100000,
 	},
 	[NFP_DEV_NFP3800_VF] = {
-		.dma_mask		= DMA_BIT_MASK(40),
+		.dma_mask		= DMA_BIT_MASK(48),
 		.qc_idx_mask		= GENMASK(8, 0),
 		.qc_addr_offset		= 0,
 		.min_qc_size		= 512,
-- 
2.30.2

