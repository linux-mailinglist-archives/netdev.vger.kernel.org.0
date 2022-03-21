Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70D94E248C
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346448AbiCUKoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346440AbiCUKoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:44:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2131.outbound.protection.outlook.com [40.107.243.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211E614A6D5
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:42:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TX8CdeL8WDtkCQi4+ZSPeu8h3S4INvLeu/M1zhp2OZdE6lT3OTiuQIpLBpbBviuFWdUgCkbUnEEk20Oub2ZLU1WWHjBu9TGaEltmsUL+8Y5biHQj+Lmcb/y7XPsAFejeuA9YRsW6pozJl80R0L2AAH4hs72O6Xaknmxcm/6RrLKDWCzuVAF7sPe2bJCOSZ1jJZguKDb6jvlNBSOGkD6QkR/HaY1R2QjfHUi9wd80IyRWd+Kl08v4QqAfJm97Qpt2ANrTCRDkD7j0CgnYzIoa4wmOrUM8KLYz96Uk8KKzUO+J3WEp1eDz9HrYjEf9IZkjj2pZw/hSiXqOAiYpA1X0qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJypa0WDicXTBdmLVogDUROeRRVF2MGqLM9Cycpjr6o=;
 b=Z4P+T2birFcMcaFtxseJSTM34WzwrPfAHLqGGnN+PnRSEy8r/jnguNSjIiiSSKIUkKPQX7IjluQ06PVjwQ18/KKObTQMSdPdGKWWGQnaKqGbaHL1qFu/HNVn81WSW3K8bdWMwESr/m2u/TUCYWv6ngv/UYQRAaLZuQtOWCDEnObSoFhm5lF+j4ESbr83oAzAIOaJ/2TEMlke3ADPAazJu1H3g76dQAT3ya5NWRIcjJV/WHX6QkNcidcMJuhNnvyZBzV4IEudgHP4M2mirYicDbYCz3TGSS54UhsoRaSBnPBKC/s64q+YVzDQzoEourZbwNgZnsjFoUBEXr2WWzPKzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJypa0WDicXTBdmLVogDUROeRRVF2MGqLM9Cycpjr6o=;
 b=Cekir4WCfshwYYMJ3gjLJXqN8nNkD5xlGRFIoSD0RG17SBSMU2/gd+aJIG5zMya34LsVKg1FSYXxi9aCPSUbsigqswasoFPkgvE3Wz/qgTeB2ikLGE8RYDurIghjFLwZeCFQoVX1txeR/fpK36JCbyMawU6YLkpNWJO0abszwio=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1512.namprd13.prod.outlook.com (2603:10b6:903:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.15; Mon, 21 Mar
 2022 10:42:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5102.015; Mon, 21 Mar 2022
 10:42:34 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v2 06/10] nfp: use TX ring pointer write back
Date:   Mon, 21 Mar 2022 11:42:05 +0100
Message-Id: <20220321104209.273535-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321104209.273535-1-simon.horman@corigine.com>
References: <20220321104209.273535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0001.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71d73e03-a39c-4688-fbec-08da0b27822a
X-MS-TrafficTypeDiagnostic: CY4PR13MB1512:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB15120326E1BDB64D3170F977E8169@CY4PR13MB1512.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pmisslyfVVUXeoVBZafP2eZaEaJPdXn2jR5pW/oJkmE51ZT7KyPbgPYvn+VcYB/sOd/xlyKGNRsNTtXP6CUc0VvnYzE41Av4FH9/xAHuoxZttQD1H9xw5BZHaDSGDTRJl9WlIXa1WLTVwxhTgauGnQ7dCzIx52uRHX1FhrBPgV7crmM9jru+0UKUV/DgYbiMQEnLjjHbzm5YM9Gev18urcZiSZADJmlFLqJkfcD2Aut+qjnQcEnD3q2NquFkfBZx8t2Hb4NcPgkIbSaeiDjht6Omc1Jk0TDWzlb+ImaEaHI186nbZ1m6NNp0qRyS77FstC1aGzboGEs99BdNnVESP4xY+ETAwbfZiypf4ut6o5TV9cQ9QYobuYxXwMUOWoeT1MN2i80orfWUQ/oqWSarbMFZ8GzYuMCuFkcJtHWLaKC1MwZkcIcR3b+qlZ7MEtpXjgS5tY8Xs5/Y1bIAkXP2hfU8vIAuHLnd7Ze0/U5w9VG73VogfodHe4JEhWiaZ78zu8VINgUm/r/yWsHGK6cwuEn+3JkbkaRg9TJ+fCONt538jVKjYH5qtbW/kanAjmtb8hGdWL4cN2zz224G0NV5s3DSAREBOM+ro6Eu/fTS/AXM8sdnt6/EuIYrD2c33VguyD5I24Cbgpw+dd0Ohh325A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(376002)(366004)(346002)(8936002)(186003)(1076003)(6512007)(110136005)(6506007)(2906002)(8676002)(5660300002)(86362001)(52116002)(107886003)(6666004)(6486002)(44832011)(66946007)(4326008)(38100700002)(66556008)(2616005)(66476007)(316002)(83380400001)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uMHpqeve+L30q1kwnLAJDSZGq5vRsR2Oi86SzfOspJ6CLCUK0WOmsEL9Gzim?=
 =?us-ascii?Q?C8pRXxgnI6RoHJBIb1M2AdszEjF9GoE+vXaBkkn57nZiNt0oV4B4oRg24wCl?=
 =?us-ascii?Q?Y0izMlgYVheqRPOZ0ZMn4oNoZiX4np8cA/0esUZCK7rg6vIJMxgTDWG1x0Gc?=
 =?us-ascii?Q?/l4kPuWueiJgTTc6erWc56+qfqCgwBIm340FLUrJcLQM5aNKWFGltVHoW/dE?=
 =?us-ascii?Q?gN7Z7g1SGwQsRBgLWQAtR1E254i1EpD36REAlCcxUAbzQg/YUQXXUOTGTO4f?=
 =?us-ascii?Q?7zJ5mVvTKG5P7+503E0dnQ1Wymye7YuWFsISTkDUA9s08moOGm2LJ/MQN2/B?=
 =?us-ascii?Q?5pT3jFmEPNe+ZI2RIkLZe4QoCDzmb4v/uzLufGhGnoJek1XdqfNL3ZPrnjHg?=
 =?us-ascii?Q?iNRzK48tbb+cH1CW4GRufq0MHgw00gsAMdOvsJN+dtIuahS0zdjgxMdcsmL6?=
 =?us-ascii?Q?KwoxLNmp6xrIfDmji3u6tqUIl87I5BIAmNxpyFQ2mqtqZuaOCOWRtxxqmTLz?=
 =?us-ascii?Q?ujqo6JUJRrw7pYDJihMEpXeGKl2PNWYNj3dOWQMA9qBhxjfRsVkhfpY6atLq?=
 =?us-ascii?Q?pheCBAN86gWehUE4B+Sq5aAooM1/6NV4Y/z6oPmJ/XodA91ME8ezvbCRlzQD?=
 =?us-ascii?Q?uIp6sY+ae76uM0D0S6v0WXy4kc8UlAeK9JoEFZxVCsPpqu212QF0dWMMHHIA?=
 =?us-ascii?Q?egrw6tvVlow9YImQHpH+aSqC5GrkaG4nlEeQl14Gsns9PDmg9wpFMsqIIMJy?=
 =?us-ascii?Q?9pfZ8fYLj6ucgUrR3X9YMxdI+w4gzTix1BEYEzwIUEyNiMRuom4Xdx5LxnbG?=
 =?us-ascii?Q?bklT/BT+4EvncDpvQ4LtipiKB3iYVuqTHyn3ZnI6XQNKVxvl+BTeA9tjA2FF?=
 =?us-ascii?Q?pzCAFpIPBTwZ6WFj9QmpSbPEZvELETWELJbK22kUVWeSdCt+7493xL8BWtNd?=
 =?us-ascii?Q?nIgUXAqKhjNaTSRZbJE3h3aVMFpR/8ZI4PmwEk5NQBbJqux7eucKKRTwTlH4?=
 =?us-ascii?Q?Nz/3GK30f/cZ0sXJKm3iz8+6k/n6jyjHjnRPpqy9fMEHLXoPkt2fDz7TAT1+?=
 =?us-ascii?Q?yWi0LPoQSe5gSeAzm9G80wd+QVY/TU4tOZPBdtQ2GHa5Dji89VWzp9ZB4C3G?=
 =?us-ascii?Q?7yCcbxT2ai6PUH4UYiZOn2mzSc8SLVJCsHKmBKLEjegSw/sWEj0pEZSbfmZd?=
 =?us-ascii?Q?JXe9vQrQcyLiB6XVdwmf8fRspG5fMh4+j/awCBzYUOLgwC38goX7NqabiSl7?=
 =?us-ascii?Q?zz1qJTNGUjl2x9lV/CzcwZdLNwCbG8LIvoRgAHPEjCp+MSw57orzjQ1lVKjO?=
 =?us-ascii?Q?HEHXR0SLu/IBgfJxSQjlG+W1DJpTNwrFbtoim/s1/D5cwUhJMDHwFgV01kDJ?=
 =?us-ascii?Q?zTtuuI0FURf/TGf8GR2p+1vPljjAaYPMxHeDmS4eGl/8VIFO9x1eMFbIjwqp?=
 =?us-ascii?Q?0ZHJggqYypszC7mJ6KX6yd0UcD7dIyWMurQbXoupXJwNcBM+6b2SgpGrSrww?=
 =?us-ascii?Q?F3fmGDTEc6m5ZgozpJtFJjFg/irB5fAuXWXwLAifb5QNCxy0w8RgD8LbDw?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d73e03-a39c-4688-fbec-08da0b27822a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 10:42:34.4331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDoWQg1kkwgbCJ3l4w1yPvXNVVWIYYMS3uwSgFB5PXq0HTiE3wZ/p0UEvc9pZcagF0luRzy6q5Tl+GkhUkA5pb2pS38+jpFT2xn8iqSJnqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1512
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

