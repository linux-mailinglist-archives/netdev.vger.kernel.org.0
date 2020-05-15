Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32021D5C8B
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgEOWty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:54 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgEOWtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZ2dfpB8HpnGQPdpW4m63mYnLRWGZRD5UHtTY9WYqXlhMpqZtgiOgE6rXQkbc0ZfVEh+x+IHQcGHw7r7a/5KJu11yJjgwIFDidKxNaz0/kXlFirfkQSURxovfKjgVCM8n+ztSwa4CUt1G2l/2rqT8RAsH3aE3uGpNzgpN6jlcIfB/yarhSdNbKmxRIki+ksDNroz3PfkfqdOQtbQjsQv/uNPi9OFsCaWeUYO0AhKf9QRbCTMmmhFbvIuN2m2JVcL90vYN8ASrzasa7MMGeydtIRE1gR9cH9GJUuLIh+Zjyi2x7lYlKdr92FRcavvI2ae6BdTFfr4BpveJzLLW3BWWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfU63Jgj9sK1dYrjvxkpNOH60jfKXRyD40shzBt1FvA=;
 b=kKO+9F6g9LctDlldIr6PJTAPU0M1HGys34KF8TGhmFUIW9vGANYsl3OmdpI6A5iB4HcLvPiEh62XkGj4pyU7D/8xVCd1NG0UG7chI1D9Rxjs4pPNbRlcQ89mUsL/IQUusNwV9ONDN/c5GcWpKqaR9MuJlKsXugA/nlNL1QTnVwCL9wjg/5ZLYSlf/tk1BaK8SpnvXHITjCyFAPM4pJkD3VNiKrkCnXP0OK2urrzGPInqjlEZBpqm1b7lEh7xXALI/0NdBc8ji3Nstmcd3LOMs02kqHOb3YpuaAF2GSBMxqylGt0HworvEM6kIy5sw4mGo420lwN38nKTXa2IGZYcvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfU63Jgj9sK1dYrjvxkpNOH60jfKXRyD40shzBt1FvA=;
 b=OnRQekYVFNQuRNgMqJ9vigqwyvVrZMEF7jVcF2CDvZHHneoV/uNWIN12qdcM/YzXHwPgEHLNfELL+uc6DxYL4yHK+6TfaDt/avKtqnT4Kd2uOBJ8qs4DBDO7Kpnh8JkYcdl65mgI/2Po/Kva3gwd73TDMxh4yYZQAFyvcHYo1Qk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/11] net/mlx5e: Calculate SQ stop room in a robust way
Date:   Fri, 15 May 2020 15:48:53 -0700
Message-Id: <20200515224854.20390-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515224854.20390-1-saeedm@mellanox.com>
References: <20200515224854.20390-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:38 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: af4a0a02-e0a4-4ee8-947e-08d7f9224083
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB32002145CE1DC7D14E903E56BEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F8i1w3fg6zxyucx9jLOUB2WKMx1Ag2lXZlmxLXxOFxjnkCgQ9Wx/NuldgUdCtAs8V/CL0rpJS5fZ/afE4SDqMu/FxJ7qRelhbev5TbhfCWiBCAltHiMF66r53XuK4f8NvPNi8oQR6V+hysBEwl/CWACnGiYRBS4GKoay6jGJhgMDI9RsxAxtbv8Vbp8s4idbgg+0rJCn0wYJdmvvydRqabVI5GHpJjlkxUcl7zldOGWtHAuTtAW/27rLlXWRsjydCrloXzZJP6WScm4HtvuMLBGXS5sEzuI74/hlzqGxd4G+H7M3aCKxz1hZtbEyE0yqjpnaGkhH9j9E2ZbDDP9HmGG/dDmxGYS5P3Qnjft8RA3ra4RWYC7D2w2u+89PgnZ948rDrn+m4OOZnA/35DqqYVGYDwNwfXmXLCB8i761umX5kWfvb/igUa9trPbFtNDBnFvhPRWl0yiZgLdeqbRj3FXtAlTiq2I77c2P88j8DZiRoGYAnS+hzK5OxQ6LpoyJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(30864003)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(54906003)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lzNYndlXf6uhfrz5nyPauNAcuV6Z6Fbpv3Jy/P3z9fZ+T2VW3+GcgRVOlHeWMdCe4Csunm31oERz85+RdRYr6ZM/vBSUwvTvnCljIjU+VePcnbNF8JmuVMkjh2wrRONZ8UszmjDGBh+htmRIZRDd9+87QeDFujosaoL7BbEuAkhMMvRziqgRVk9KgdEQfYiikfYdnLp04hI9vDLLVlqQJuaxh6kpU6gubMEhza3oZfKcnIyC7J4JbtM64IlcMWirjsADTAxL8EK7SBJ5OjPDkE5G/i+iZ7Uno25gaLybabZbti37isnrZBc/PtGr1sSAytAenau7SqHgoz2eByxaQ+pdK2FWVGG/YAmnhfI8NsOsZy+SC4JgCrxiBn+k9FdbqXcHe40+ZKKod47x88zfpj42CigT6qEXSChu5WetTX2287W4m9kilQa9qz5PeV7ChhA8uzliAqVWMW9w3hVNTb9/jrsZwxlv/V935U4RKYY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af4a0a02-e0a4-4ee8-947e-08d7f9224083
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:40.5222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eAy3ah8m83Xzp7w2PkNaMDHZ1RY/ywsdGvZNfVDeB57+nbaNbdtfzTb/Boq35IVz85OVr5gv7D67KvMqksNClg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Currently, different formulas are used to estimate the space that may be
taken by WQEs in the SQ during a single packet transmit. This space is
called stop room, and it's checked in the end of packet transmit to find
out if the next packet could overflow the SQ. If it could, the driver
tells the kernel to stop sending next packets.

Many factors affect the stop room:

1. Padding with NOPs to avoid WQEs spanning over page boundaries.

2. Enabled and disabled offloads (TLS, upcoming MPWQE).

3. The maximum size of a WQE.

The padding is performed before every WQE if it doesn't fit the current
page.

The current formula assumes that only one padding will be required per
packet, and it doesn't take into account that the WQEs posted during the
transmission of a single packet might exceed the page size in very rare
circumstances. For example, to hit this condition with 4096-byte pages,
TLS offload will have to interrupt an almost-full MPWQE session, be in
the resync flow and try to transmit a near to maximum amount of data.

To avoid SQ overflows in such rare cases after MPWQE is added, this
patch introduces a more robust formula to estimate the stop room. The
new formula uses the fact that a WQE of size X will not require more
than X-1 WQEBBs of padding. More exact estimations are possible, but
they result in much more complex and error-prone code for little gain.

Before this patch, the TLS stop room included space for both INNOVA and
ConnectX TLS offloads that couldn't run at the same time anyway, so this
patch accounts only for the active one.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 40 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  2 -
 .../mellanox/mlx5/core/en_accel/ktls.c        | 13 ++++++
 .../mellanox/mlx5/core/en_accel/ktls.h        | 12 +++---
 .../mellanox/mlx5/core/en_accel/tls.c         | 14 +++++++
 .../mellanox/mlx5/core/en_accel/tls.h         |  7 ++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 28 +++++++++----
 8 files changed, 84 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index dce2bbbf9109..bfd3e1161bc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -6,25 +6,6 @@
 
 #include "en.h"
 
-#define MLX5E_SQ_NOPS_ROOM (MLX5_SEND_WQE_MAX_WQEBBS - 1)
-#define MLX5E_SQ_STOP_ROOM (MLX5_SEND_WQE_MAX_WQEBBS +\
-			    MLX5E_SQ_NOPS_ROOM)
-
-#ifndef CONFIG_MLX5_EN_TLS
-#define MLX5E_SQ_TLS_ROOM (0)
-#else
-/* TLS offload requires additional stop_room for:
- *  - a resync SKB.
- * kTLS offload requires fixed additional stop_room for:
- * - a static params WQE, and a progress params WQE.
- * The additional MTU-depending room for the resync DUMP WQEs
- * will be calculated and added in runtime.
- */
-#define MLX5E_SQ_TLS_ROOM  \
-	(MLX5_SEND_WQE_MAX_WQEBBS + \
-	 MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS)
-#endif
-
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
 
 enum mlx5e_icosq_wqe_type {
@@ -331,4 +312,25 @@ mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
 	}
 }
 
+static inline u16 mlx5e_stop_room_for_wqe(u16 wqe_size)
+{
+	BUILD_BUG_ON(PAGE_SIZE / MLX5_SEND_WQE_BB < MLX5_SEND_WQE_MAX_WQEBBS);
+
+	/* A WQE must not cross the page boundary, hence two conditions:
+	 * 1. Its size must not exceed the page size.
+	 * 2. If the WQE size is X, and the space remaining in a page is less
+	 *    than X, this space needs to be padded with NOPs. So, one WQE of
+	 *    size X may require up to X-1 WQEBBs of padding, which makes the
+	 *    stop room of X-1 + X.
+	 * WQE size is also limited by the hardware limit.
+	 */
+
+	if (__builtin_constant_p(wqe_size))
+		BUILD_BUG_ON(wqe_size > MLX5_SEND_WQE_MAX_WQEBBS);
+	else
+		WARN_ON_ONCE(wqe_size > MLX5_SEND_WQE_MAX_WQEBBS);
+
+	return wqe_size * 2 - 1;
+}
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 761c8979bd41..42202d19245c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -257,8 +257,10 @@ enum {
 static int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq)
 {
 	if (unlikely(!sq->mpwqe.wqe)) {
+		const u16 stop_room = mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+
 		if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc,
-						     MLX5E_XDPSQ_STOP_ROOM))) {
+						     stop_room))) {
 			/* SQ is full, ring doorbell */
 			mlx5e_xmit_xdp_doorbell(sq);
 			sq->stats->full++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index e2e01f064c1e..be64eb68f4e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -40,8 +40,6 @@
 	(sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
 #define MLX5E_XDP_TX_DS_COUNT (MLX5E_XDP_TX_EMPTY_DS_COUNT + 1 /* SG DS */)
 
-#define MLX5E_XDPSQ_STOP_ROOM (MLX5E_SQ_STOP_ROOM)
-
 #define MLX5E_XDP_INLINE_WQE_SZ_THRSD (256 - sizeof(struct mlx5_wqe_inline_seg))
 #define MLX5E_XDP_INLINE_WQE_MAX_DS_CNT \
 	DIV_ROUND_UP(MLX5E_XDP_INLINE_WQE_SZ_THRSD, MLX5_SEND_WQE_DS)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 46725cd743a3..417a2d9dd248 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -4,6 +4,19 @@
 #include "en.h"
 #include "en_accel/ktls.h"
 
+u16 mlx5e_ktls_get_stop_room(struct mlx5e_txqsq *sq)
+{
+	u16 num_dumps, stop_room = 0;
+
+	num_dumps = mlx5e_ktls_dumps_num_wqes(sq, MAX_SKB_FRAGS, TLS_MAX_PAYLOAD_SIZE);
+
+	stop_room += mlx5e_stop_room_for_wqe(MLX5E_KTLS_STATIC_WQEBBS);
+	stop_room += mlx5e_stop_room_for_wqe(MLX5E_KTLS_PROGRESS_WQEBBS);
+	stop_room += num_dumps * mlx5e_stop_room_for_wqe(MLX5E_KTLS_DUMP_WQEBBS);
+
+	return stop_room;
+}
+
 static int mlx5e_ktls_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
 {
 	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index dabbc5f226ce..c6180892cfcb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -102,15 +102,16 @@ bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *s
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
+u16 mlx5e_ktls_get_stop_room(struct mlx5e_txqsq *sq);
+
 static inline u8
-mlx5e_ktls_dumps_num_wqebbs(struct mlx5e_txqsq *sq, unsigned int nfrags,
-			    unsigned int sync_len)
+mlx5e_ktls_dumps_num_wqes(struct mlx5e_txqsq *sq, unsigned int nfrags,
+			  unsigned int sync_len)
 {
 	/* Given the MTU and sync_len, calculates an upper bound for the
-	 * number of WQEBBs needed for the TX resync DUMP WQEs of a record.
+	 * number of DUMP WQEs needed for the TX resync of a record.
 	 */
-	return MLX5E_KTLS_DUMP_WQEBBS *
-		(nfrags + DIV_ROUND_UP(sync_len, sq->hw_mtu));
+	return nfrags + DIV_ROUND_UP(sync_len, sq->hw_mtu);
 }
 #else
 
@@ -122,7 +123,6 @@ static inline void
 mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 				      struct mlx5e_tx_wqe_info *wi,
 				      u32 *dma_fifo_cc) {}
-
 #endif
 
 #endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index fba561ffe1d4..c27e9a609d51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -240,3 +240,17 @@ void mlx5e_tls_cleanup(struct mlx5e_priv *priv)
 	kfree(tls);
 	priv->tls = NULL;
 }
+
+u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq)
+{
+	struct mlx5_core_dev *mdev = sq->channel->mdev;
+
+	if (!mlx5_accel_is_tls_device(mdev))
+		return 0;
+
+	if (MLX5_CAP_GEN(mdev, tls_tx))
+		return mlx5e_ktls_get_stop_room(sq);
+
+	/* Resync SKB. */
+	return mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index 9015f3f7792d..9219bdb2786e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -94,6 +94,8 @@ int mlx5e_tls_get_count(struct mlx5e_priv *priv);
 int mlx5e_tls_get_strings(struct mlx5e_priv *priv, uint8_t *data);
 int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *data);
 
+u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq);
+
 #else
 
 static inline void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
@@ -108,6 +110,11 @@ static inline int mlx5e_tls_get_count(struct mlx5e_priv *priv) { return 0; }
 static inline int mlx5e_tls_get_strings(struct mlx5e_priv *priv, uint8_t *data) { return 0; }
 static inline int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *data) { return 0; }
 
+static inline u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 65e2b364443e..75f178a43822 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1122,6 +1122,22 @@ static int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *sq, int numa)
 	return 0;
 }
 
+static int mlx5e_calc_sq_stop_room(struct mlx5e_txqsq *sq, u8 log_sq_size)
+{
+	int sq_size = 1 << log_sq_size;
+
+	sq->stop_room  = mlx5e_tls_get_stop_room(sq);
+	sq->stop_room += mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+
+	if (WARN_ON(sq->stop_room >= sq_size)) {
+		netdev_err(sq->channel->netdev, "Stop room %hu is bigger than the SQ size %d\n",
+			   sq->stop_room, sq_size);
+		return -ENOSPC;
+	}
+
+	return 0;
+}
+
 static void mlx5e_tx_err_cqe_work(struct work_struct *recover_work);
 static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 			     int txq_ix,
@@ -1146,20 +1162,16 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	sq->stats     = &c->priv->channel_stats[c->ix].sq[tc];
-	sq->stop_room = MLX5E_SQ_STOP_ROOM;
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
 	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
 	if (MLX5_IPSEC_DEV(c->priv->mdev))
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
-#ifdef CONFIG_MLX5_EN_TLS
-	if (mlx5_accel_is_tls_device(c->priv->mdev)) {
+	if (mlx5_accel_is_tls_device(c->priv->mdev))
 		set_bit(MLX5E_SQ_STATE_TLS, &sq->state);
-		sq->stop_room += MLX5E_SQ_TLS_ROOM +
-			mlx5e_ktls_dumps_num_wqebbs(sq, MAX_SKB_FRAGS,
-						    TLS_MAX_PAYLOAD_SIZE);
-	}
-#endif
+	err = mlx5e_calc_sq_stop_room(sq, params->log_sq_size);
+	if (err)
+		return err;
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
-- 
2.25.4

