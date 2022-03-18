Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30C64DD7C5
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbiCRKPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbiCRKPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:15:07 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2122.outbound.protection.outlook.com [40.107.244.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655D3103BA1
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:13:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OtJ6mdCuwdlBLmJH/iqHkrdC62yLZKEb8yCnNHlCLfhdmcXYpmc6uydkVwzJCxMEVkFZhWBMen6ZsrBqu/jybxgWtCo2v/iQkb0+oFmXb2Z2KKP0SY/BlyDFVBm8GqJ2d/+UpetcdolU1KQgmrAuqYwR51ZRdQfu5HxWXHHoAx9i+Yu/VM6PSjRCvp/wWoaTLWyRW9S0/q5l+r6VmvtCCh5c69hsn5c5mi31IOGEKPr3KVcxV9Lfh3DdmckXD/cIFuoHE+k9UBrkpOBYhJTf2B+KpioLwiPj1mJEDRqQdQpWY16lqOWLcuzC1VAc6cW3hSjm+sbnfP/B0LrWcVTaXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJypa0WDicXTBdmLVogDUROeRRVF2MGqLM9Cycpjr6o=;
 b=faDkwWaBiMItVvZyeYU7t3Tsy5WRGIfXjkB6dh7WToXDKd9NGvo6rzTIGpDDZ8smbnbdF8ZVl5OnAMiwr0HOnk6IXD+cd7lVf5ewAovWIDvk7UUxSsFXMlZ0YOp+ngSx00VMc9sa2KTZpuhUaTz1P7QwaqGUnin6faWYTZMch/ZJ7Zh+2m8UCjDSVic5j4Ord96Gpg9YEYaTuxfzyLqc6daUbfhAnYyEIFkt3pCLUaJKtF0mGEKe9Z8jpyPvjr7hxQy+mtw9so2Ai88FX3f/9GEN+m9FRoy5hTAnbjrTn7WtNEBklJJl4ndRf8RfBKMSQu8tvSUp3ayQP0IK9iDvTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJypa0WDicXTBdmLVogDUROeRRVF2MGqLM9Cycpjr6o=;
 b=uJ9SY1HRSgpkBLyL5ODXx6z2B/SgAAnDvYkNDWhEtxQ0qQghT0Y9yo7KX328rXkY/Jdiic0IWPhkNdcFvkOrZ+5fFI8FU+loae0REEiUr905xTDiCpvvsi19BolxRWqMO0UZINw6Q3pAQA4cMJxjSjh/nze8orGhANBsmLQV3S0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR1301MB2090.namprd13.prod.outlook.com (2603:10b6:4:33::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.7; Fri, 18 Mar
 2022 10:13:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5081.015; Fri, 18 Mar 2022
 10:13:40 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 06/10] nfp: use TX ring pointer write back
Date:   Fri, 18 Mar 2022 11:12:58 +0100
Message-Id: <20220318101302.113419-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318101302.113419-1-simon.horman@corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0114.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c977dcf-ac53-44a0-3ae2-08da08c7f94d
X-MS-TrafficTypeDiagnostic: DM5PR1301MB2090:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1301MB2090CFECD94BB2415472B8CAE8139@DM5PR1301MB2090.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XSgQo5MtQ/38lmR5/KkX3laASfm50fZoDdAWl8J2/Hz7Ti02Jm0YXiEp5WJYXilAErnFCps5G75jrB9I/HQ5HC9puqxUWNnma1NhH04wIXbOaX7lf6xTzDxYEAiKzIHFxGsq21zkZPIw9k0Rc5YTT1Jf+pSSJt+V7FEZR5CMQPKnkCOKQVTlVWiIP2FkmOC3XvJA1XdPcaZKgEY188vI/UBA72yjkfhyp5rER5cI5x/INAp/5QGUny5Wagkt3//afcOcLxL/xiWY9+bgMQgFoHqWkWtmQhL29IBj+PIcRPrjTHZLzRY24r3c80qCBbgeGveVktaT1vCC6gEoIEXEElWQco+AA9wBQtxDlmJCW6L1etWTdLc7Oo/VPi255rpaZ5VEnhSVeYMH+CD/v/n3t/TD0M3FJ2Io5/kLn1UDOAxVno4f5eS9FUyVarx6XyW5RToKNuU3JDqKeRHUHUWD9D+Ptg2bHGQ7dUTTySsnp5Kt6g5VsWDXBXgBvZXKrFtfMP8JbW3mD8UD19+nUr3lvtuoi6pA7dAFD34Oe6BLD/jzdpxPV1xe1TdtuZc+YE12QW24Nvseq6uQ6op9ByD9mmqB9v4BhE3ixw/RL9pHdaiOOB6w/y8IZUKCB5tr8nhXmL0VLTSa2TiJLoSdEPjxXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(366004)(39830400003)(346002)(2616005)(107886003)(2906002)(186003)(1076003)(8676002)(86362001)(6512007)(36756003)(6506007)(52116002)(508600001)(83380400001)(5660300002)(66946007)(66556008)(66476007)(44832011)(4326008)(6486002)(38100700002)(316002)(6666004)(110136005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TxaRjBQ+wO672GarOu5ojszKrC1OJBji+Lnax0ZgJYmTMw+LvbGemZcqZl6R?=
 =?us-ascii?Q?yxpzfZpxi7b0HIE7WsMo1Ox73F/+XfCB1lPGWkuMzsM8zMX2dnsGKxW54LC2?=
 =?us-ascii?Q?V0TVB//D6LSpncreRA99oLpxs1QQbMsULAFD2szt2zFOILNZeechS1Wuwq28?=
 =?us-ascii?Q?9x5CrPSVKHH3ZWuI2YFPW2oHiNTDXPimw4BuGtZf6eh0MO1AEwEVKJOvv3xe?=
 =?us-ascii?Q?g6kJo6h4aWMSFc3VqC7UqHlcmETK/mS5rCzO4112meTPVVIRI43zGzz0jrbg?=
 =?us-ascii?Q?hKSHwIle/6i+ewVjCkFxUItntBLYAwiRL2nRfsobOwuJEPfQMfBJI0jIhyoj?=
 =?us-ascii?Q?yZc6uMJfuSIOlLxqBo83/DT1PJCCLqYzUntDy6d7Y60oB7BDcQSOYUiyCPRb?=
 =?us-ascii?Q?kC0x/bm+TWfbAwlCYRtFV05danyptQOVHf9Cp0jhA7gzITj/B6inyGiRkN7G?=
 =?us-ascii?Q?HeZRHIKEXxbDije5aje45y6fO05b1DN6uLoEfBtNccCsBCxsxTPxV5grLgP3?=
 =?us-ascii?Q?oWoZL9Oi2KgUh8ikKKaUvDcBw8b0u/EuGWUm76T6ryEnZnAiRWfNGbFgxXrk?=
 =?us-ascii?Q?ITX/97pz5nqXMfHr5wr/KQAK8aX7TVSB409w2bBXLh0/kbHehMHxOO/Ag2fv?=
 =?us-ascii?Q?ujfhDiEZBc06opl7I+73sEsG8H0p2wTf+y6OxZ194xn19ANlN50+GcEToYZN?=
 =?us-ascii?Q?+zVZV5nvusDNF4IFBS+vpdc7vzg5K/CmRDveb7nJq0qawApqFSWAg18qC+bn?=
 =?us-ascii?Q?/ocsJ+Qufx44FR4Mnaqe0p0ialwKGDXiWuXN/jWeXP5PUsECsqhiBepYWOyk?=
 =?us-ascii?Q?wivIYYu/G23fkljZ/y1OHaD8V2uKmu77NU1HRXw2xfKyBAfk0X1zVvsESC8d?=
 =?us-ascii?Q?FyE+wp83Sksd+ATRKhiHtg9erfo8+pLEyEyPosC8GZUZE9fZBt/p55XohdB7?=
 =?us-ascii?Q?zVWxOqwupx0iVTIxSrHOU+Ayu0xgPvPVX4IkQ4jdRLtvxtBpMtRzcXNg1BE0?=
 =?us-ascii?Q?VF2x9SznH3JLvk9BZyFp3Cg17uWNgPeomVFsI0dFZtsZsiBozLavuDc5EFqS?=
 =?us-ascii?Q?4ue4UCGz97D3NzLugfKl/bPVOdLGNI9OINz2TfjNdQajaLla629Osv3VVRXY?=
 =?us-ascii?Q?1oHgBMu8JDnB8qmEy94Az7WTpkUNOcPtNWG30KL0mamd28/evisApcgriBEj?=
 =?us-ascii?Q?fwduOMZ4pZ93yI2Fv6Drk9TCOlVKG2zvKm5Nu0T6KiJTAazey1nyPlklpGYs?=
 =?us-ascii?Q?vXJ0zObkTRL6X4o2EetzQYp34tmb5BS8TipS+HGgHnC8Mse54CJZbT/9Ey7d?=
 =?us-ascii?Q?+YSBuAmcsOk4aFl79ATZ6B5bWIfbRRtlPYReTZdu1vWaJlUzBq8KWfwyT7Xd?=
 =?us-ascii?Q?I2nxUK/F18mbzNceZ4UeMjJkeCGOtrEEs/Mf3IuYCKnnBU5zvW7AtCRtc1SI?=
 =?us-ascii?Q?c3kkqAQHa65ifmnYsrBhXTWjeSIn0tN+B2elDDziyhmEX5q4FqCXxa3I4DE9?=
 =?us-ascii?Q?WfCyWbcUY068Xa2M4Je8LqVHDRfbGTNSwvwcz3x+WfMCP5n/f4gVj8Bo6A?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c977dcf-ac53-44a0-3ae2-08da08c7f94d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 10:13:40.3104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D54JW14F8N+qfbEFV8wxD2KSTxZOSDVIaE6kAd8HdpUjavxMg/rHalyaCmEegWTEAF8+Q8PmCTd5m+fPbL5XKYB7AUwqJPGBoYgn6kv2Klg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1301MB2090
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

Newer versions of the PCIe microcode support writing back the
position of the TX pointer back into host memory.  This speeds
up TX completions, because we avoid a read from device memory
(replacing PCIe read with DMA coherent read).

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  5 ++--
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  7 +++++
 .../ethernet/netronome/nfp/nfp_net_common.c   |  9 +++++-
 .../ethernet/netronome/nfp/nfp_net_debugfs.c  |  5 +++-
 .../net/ethernet/netronome/nfp/nfp_net_dp.c   | 29 +++++++++++++++++--
 .../net/ethernet/netronome/nfp/nfp_net_dp.h   |  8 +++++
 6 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 619f4d09e4e0..7db56abaa582 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -392,7 +392,7 @@ void nfp_nfd3_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget)
 		return;
 
 	/* Work out how many descriptors have been transmitted */
-	qcp_rd_p = nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
+	qcp_rd_p = nfp_net_read_tx_cmpl(tx_ring, dp);
 
 	if (qcp_rd_p == tx_ring->qcp_rd_p)
 		return;
@@ -467,13 +467,14 @@ void nfp_nfd3_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget)
 static bool nfp_nfd3_xdp_complete(struct nfp_net_tx_ring *tx_ring)
 {
 	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
 	u32 done_pkts = 0, done_bytes = 0;
 	bool done_all;
 	int idx, todo;
 	u32 qcp_rd_p;
 
 	/* Work out how many descriptors have been transmitted */
-	qcp_rd_p = nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
+	qcp_rd_p = nfp_net_read_tx_cmpl(tx_ring, dp);
 
 	if (qcp_rd_p == tx_ring->qcp_rd_p)
 		return true;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 4e288b8f3510..3c386972f69a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -126,6 +126,7 @@ struct nfp_nfd3_tx_buf;
  * @r_vec:      Back pointer to ring vector structure
  * @idx:        Ring index from Linux's perspective
  * @qcp_q:      Pointer to base of the QCP TX queue
+ * @txrwb:	TX pointer write back area
  * @cnt:        Size of the queue in number of descriptors
  * @wr_p:       TX ring write pointer (free running)
  * @rd_p:       TX ring read pointer (free running)
@@ -145,6 +146,7 @@ struct nfp_net_tx_ring {
 
 	u32 idx;
 	u8 __iomem *qcp_q;
+	u64 *txrwb;
 
 	u32 cnt;
 	u32 wr_p;
@@ -444,6 +446,8 @@ struct nfp_stat_pair {
  * @ctrl_bar:		Pointer to mapped control BAR
  *
  * @ops:		Callbacks and parameters for this vNIC's NFD version
+ * @txrwb:		TX pointer write back area (indexed by queue id)
+ * @txrwb_dma:		TX pointer write back area DMA address
  * @txd_cnt:		Size of the TX ring in number of min size packets
  * @rxd_cnt:		Size of the RX ring in number of min size packets
  * @num_r_vecs:		Number of used ring vectors
@@ -480,6 +484,9 @@ struct nfp_net_dp {
 
 	const struct nfp_dp_ops *ops;
 
+	u64 *txrwb;
+	dma_addr_t txrwb_dma;
+
 	unsigned int txd_cnt;
 	unsigned int rxd_cnt;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index dd234f5228f1..5cac5563028c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1427,6 +1427,8 @@ struct nfp_net_dp *nfp_net_clone_dp(struct nfp_net *nn)
 	new->rx_rings = NULL;
 	new->num_r_vecs = 0;
 	new->num_stack_tx_rings = 0;
+	new->txrwb = NULL;
+	new->txrwb_dma = 0;
 
 	return new;
 }
@@ -1963,7 +1965,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->fw_ver.resv, nn->fw_ver.class,
 		nn->fw_ver.major, nn->fw_ver.minor,
 		nn->max_mtu);
-	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
+	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
 		nn->cap,
 		nn->cap & NFP_NET_CFG_CTRL_PROMISC  ? "PROMISC "  : "",
 		nn->cap & NFP_NET_CFG_CTRL_L2BC     ? "L2BCFILT " : "",
@@ -1981,6 +1983,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->cap & NFP_NET_CFG_CTRL_CTAG_FILTER ? "CTAG_FILTER " : "",
 		nn->cap & NFP_NET_CFG_CTRL_MSIXAUTO ? "AUTOMASK " : "",
 		nn->cap & NFP_NET_CFG_CTRL_IRQMOD   ? "IRQMOD "   : "",
+		nn->cap & NFP_NET_CFG_CTRL_TXRWB    ? "TXRWB "    : "",
 		nn->cap & NFP_NET_CFG_CTRL_VXLAN    ? "VXLAN "    : "",
 		nn->cap & NFP_NET_CFG_CTRL_NVGRE    ? "NVGRE "	  : "",
 		nn->cap & NFP_NET_CFG_CTRL_CSUM_COMPLETE ?
@@ -2352,6 +2355,10 @@ int nfp_net_init(struct nfp_net *nn)
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_IRQMOD;
 	}
 
+	/* Enable TX pointer writeback, if supported */
+	if (nn->cap & NFP_NET_CFG_CTRL_TXRWB)
+		nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXRWB;
+
 	/* Stash the re-configuration queue away.  First odd queue in TX Bar */
 	nn->qcp_cfg = nn->tx_bar + NFP_QCP_QUEUE_ADDR_SZ;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
index 791203d07ac7..d8b735ccf899 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
@@ -99,11 +99,14 @@ static int nfp_tx_q_show(struct seq_file *file, void *data)
 	d_rd_p = nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
 	d_wr_p = nfp_qcp_wr_ptr_read(tx_ring->qcp_q);
 
-	seq_printf(file, "TX[%02d,%02d%s]: cnt=%u dma=%pad host=%p   H_RD=%u H_WR=%u D_RD=%u D_WR=%u\n",
+	seq_printf(file, "TX[%02d,%02d%s]: cnt=%u dma=%pad host=%p   H_RD=%u H_WR=%u D_RD=%u D_WR=%u",
 		   tx_ring->idx, tx_ring->qcidx,
 		   tx_ring == r_vec->tx_ring ? "" : "xdp",
 		   tx_ring->cnt, &tx_ring->dma, tx_ring->txds,
 		   tx_ring->rd_p, tx_ring->wr_p, d_rd_p, d_wr_p);
+	if (tx_ring->txrwb)
+		seq_printf(file, " TXRWB=%llu", *tx_ring->txrwb);
+	seq_putc(file, '\n');
 
 	nfp_net_debugfs_print_tx_descs(file, &nn->dp, r_vec, tx_ring,
 				       d_rd_p, d_wr_p);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
index 431bd2c13221..34dd94811df3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
@@ -44,12 +44,13 @@ void *nfp_net_rx_alloc_one(struct nfp_net_dp *dp, dma_addr_t *dma_addr)
 /**
  * nfp_net_tx_ring_init() - Fill in the boilerplate for a TX ring
  * @tx_ring:  TX ring structure
+ * @dp:	      NFP Net data path struct
  * @r_vec:    IRQ vector servicing this ring
  * @idx:      Ring index
  * @is_xdp:   Is this an XDP TX ring?
  */
 static void
-nfp_net_tx_ring_init(struct nfp_net_tx_ring *tx_ring,
+nfp_net_tx_ring_init(struct nfp_net_tx_ring *tx_ring, struct nfp_net_dp *dp,
 		     struct nfp_net_r_vector *r_vec, unsigned int idx,
 		     bool is_xdp)
 {
@@ -61,6 +62,7 @@ nfp_net_tx_ring_init(struct nfp_net_tx_ring *tx_ring,
 	u64_stats_init(&tx_ring->r_vec->tx_sync);
 
 	tx_ring->qcidx = tx_ring->idx * nn->stride_tx;
+	tx_ring->txrwb = dp->txrwb ? &dp->txrwb[idx] : NULL;
 	tx_ring->qcp_q = nn->tx_bar + NFP_QCP_QUEUE_OFF(tx_ring->qcidx);
 }
 
@@ -187,14 +189,22 @@ int nfp_net_tx_rings_prepare(struct nfp_net *nn, struct nfp_net_dp *dp)
 	if (!dp->tx_rings)
 		return -ENOMEM;
 
+	if (dp->ctrl & NFP_NET_CFG_CTRL_TXRWB) {
+		dp->txrwb = dma_alloc_coherent(dp->dev,
+					       dp->num_tx_rings * sizeof(u64),
+					       &dp->txrwb_dma, GFP_KERNEL);
+		if (!dp->txrwb)
+			goto err_free_rings;
+	}
+
 	for (r = 0; r < dp->num_tx_rings; r++) {
 		int bias = 0;
 
 		if (r >= dp->num_stack_tx_rings)
 			bias = dp->num_stack_tx_rings;
 
-		nfp_net_tx_ring_init(&dp->tx_rings[r], &nn->r_vecs[r - bias],
-				     r, bias);
+		nfp_net_tx_ring_init(&dp->tx_rings[r], dp,
+				     &nn->r_vecs[r - bias], r, bias);
 
 		if (nfp_net_tx_ring_alloc(dp, &dp->tx_rings[r]))
 			goto err_free_prev;
@@ -211,6 +221,10 @@ int nfp_net_tx_rings_prepare(struct nfp_net *nn, struct nfp_net_dp *dp)
 err_free_ring:
 		nfp_net_tx_ring_free(dp, &dp->tx_rings[r]);
 	}
+	if (dp->txrwb)
+		dma_free_coherent(dp->dev, dp->num_tx_rings * sizeof(u64),
+				  dp->txrwb, dp->txrwb_dma);
+err_free_rings:
 	kfree(dp->tx_rings);
 	return -ENOMEM;
 }
@@ -224,6 +238,9 @@ void nfp_net_tx_rings_free(struct nfp_net_dp *dp)
 		nfp_net_tx_ring_free(dp, &dp->tx_rings[r]);
 	}
 
+	if (dp->txrwb)
+		dma_free_coherent(dp->dev, dp->num_tx_rings * sizeof(u64),
+				  dp->txrwb, dp->txrwb_dma);
 	kfree(dp->tx_rings);
 }
 
@@ -377,6 +394,11 @@ nfp_net_tx_ring_hw_cfg_write(struct nfp_net *nn,
 			     struct nfp_net_tx_ring *tx_ring, unsigned int idx)
 {
 	nn_writeq(nn, NFP_NET_CFG_TXR_ADDR(idx), tx_ring->dma);
+	if (tx_ring->txrwb) {
+		*tx_ring->txrwb = 0;
+		nn_writeq(nn, NFP_NET_CFG_TXR_WB_ADDR(idx),
+			  nn->dp.txrwb_dma + idx * sizeof(u64));
+	}
 	nn_writeb(nn, NFP_NET_CFG_TXR_SZ(idx), ilog2(tx_ring->cnt));
 	nn_writeb(nn, NFP_NET_CFG_TXR_VEC(idx), tx_ring->r_vec->irq_entry);
 }
@@ -388,6 +410,7 @@ void nfp_net_vec_clear_ring_data(struct nfp_net *nn, unsigned int idx)
 	nn_writeb(nn, NFP_NET_CFG_RXR_VEC(idx), 0);
 
 	nn_writeq(nn, NFP_NET_CFG_TXR_ADDR(idx), 0);
+	nn_writeq(nn, NFP_NET_CFG_TXR_WB_ADDR(idx), 0);
 	nn_writeb(nn, NFP_NET_CFG_TXR_SZ(idx), 0);
 	nn_writeb(nn, NFP_NET_CFG_TXR_VEC(idx), 0);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
index 81be8d17fa93..99579722aacf 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
@@ -60,6 +60,14 @@ static inline void nfp_net_tx_xmit_more_flush(struct nfp_net_tx_ring *tx_ring)
 	tx_ring->wr_ptr_add = 0;
 }
 
+static inline u32
+nfp_net_read_tx_cmpl(struct nfp_net_tx_ring *tx_ring, struct nfp_net_dp *dp)
+{
+	if (tx_ring->txrwb)
+		return *tx_ring->txrwb;
+	return nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
+}
+
 static inline void nfp_net_free_frag(void *frag, bool xdp)
 {
 	if (!xdp)
-- 
2.30.2

