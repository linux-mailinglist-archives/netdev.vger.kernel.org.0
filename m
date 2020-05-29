Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110641E8829
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgE2Trs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:47:48 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:57981
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728160AbgE2Trp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:47:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zh1nlKsx0hDrJTWbKnlzFcoa7XLXRCr7jbNn6OLhZBOSG0C1PZaWuoB7ZVShaO6NWKRrhhsWKu2bD5q06/lfoUxWFk4gBPoErujLdXV8d/Tyk55OdHkcIE8hXzGKpGNKndknnRrcRhCzYpYigvjW8Gf2ZIc5pjR5+iXNvBO6RC/MDEiKeMsNb0BsxHDvkt274MqjKqa7jEmIVx7PsiPd7ilsVvof96kCKOLIr0Ih2Jt+WpgxhEVDRJwpPAuCh7X5loHpyJcrdzrGSwP+iXgaGg+/kB5G/WNUtguUiIMIXrIsGQ0m2hXEL0SUUsTiCdSkX51bxu+/+P0ohWnjontoQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V833slFijePrvrzDu3TV/QTOpigjUjLc81Sd/ie1xas=;
 b=memE8BnnHU7pXoNINJ5AdNK4rD22F+qw8g0uYCmWRQEVHZWmVbJpMIfO/F3PHvb10SbZBpZdEzDjZmCNO8lr+LM58ahsCtvQK+IMdqB8zwvdmOpGmUINPt5VYO0aSccIKedugr+zYt0de+UWW4YOEwr6PeiCDoFUS+U2NNoWM+QAX6cXeEx6wy4+Rhl/cZdhhjEMe5ojft7kYPotx1DBTBkGT/qzi2SaMomnVOZ2dyr1ftAGgdgnv74G3SLyFrdhedcu3Lam2MFZ3h8AyxTt5LbXKS3d1vKZoAc3oA/nLgdCnqemhQv1XylFTA7W1sPY7tAJeNoJAiQ9aOhHwCzOjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V833slFijePrvrzDu3TV/QTOpigjUjLc81Sd/ie1xas=;
 b=F2bAE5GUdD851N8jGMctXWtvAwAGlAlEJZZoxHoK6bCYpoej7q/x/KDIvRQY1tJkre8FwpK6FIBMOWksMg7QW6zUUYt+InkJIsZzlFdOMVO02ziRIGiWn5z9XXBmrB2CWsWjkNb658S03t7QGt9+UdeolUGRDpHQNybjbTm8Vp8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6589.eurprd05.prod.outlook.com (2603:10a6:803:f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 19:47:29 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 19:47:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/11] net/mlx5e: kTLS, Improve rx handler function call
Date:   Fri, 29 May 2020 12:46:41 -0700
Message-Id: <20200529194641.243989-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529194641.243989-1-saeedm@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 19:47:26 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a4e3581e-bdc3-417f-126b-08d804091de5
X-MS-TrafficTypeDiagnostic: VI1PR05MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6589B979B2A27D45300F07ABBE8F0@VI1PR05MB6589.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HyAACotdZiNYorb+Lmui84qtCUkLjQd5AkAbMHXLcSCsAeZhh5jhSzchB8QFIGQmTawUNpOr3YUrMm+6rDIpy2aEvDTnqQhRBHeYKAJgzuk5OPdHXhL7+s4025KTGoAn42A5Uqcmmzm2OkUaqXX1tXI8Tshj97DSpO6fI7Eswl2Hs9pQl9D1gWm2qH6M83NDKFSXKWR+ISHRQh/MY2OXIslIQENqP2ihboRZ4B8tyfBcBz5By7G2puUWGzdi7XE8le5CcKLaZm2KYmPOpnkTIB2Vn6nQFOuy8S0jrP/h/k6ZEUo5eFJY22e6s+2ct8/MctuxHPqf2bJL7WplOff4CPw9tP0HWOOX2IdU87u9Bfl1M0DI2iwnMWTdNVqRIgQO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(6512007)(83380400001)(36756003)(186003)(4326008)(86362001)(8936002)(26005)(107886003)(16526019)(6506007)(316002)(52116002)(8676002)(2616005)(956004)(6666004)(478600001)(66556008)(5660300002)(2906002)(6486002)(1076003)(66476007)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fTVNlbRenIGSfsOlxJ213GCxv49zQSBcfrzaxHKbfYkYM1NlZznaukZvmhjUf14gPCZ/60ksxGoAMdRUAnfG01HfidMcsTB+3qfmF9R5751CzAKpZY+hTMhgDHgerZuzy/JxokWLtFOXmAesdqY3paJaBFPbalXa3vjuUA4DFJc94uDav9PuL4/ASyZtcaUu84hfQEOWdQtKWDNsfyPq+vQcuhAfAGGsEOzwfDRO+OV9hh59fEZzEUeRrNhGktDb6Tc3AE/1F5fid7Mcp0Oj6re/nu3SpZvl0P+0PAKDKAUfBaNQ5puwjX+6eprt/MVTFyiH+RIgZc4J7DqztCogI700neR9UyVfWVsHXDatw+lDZa/byItofLg+78Cz+RnOY7ikQq5hfevDQKTahCinWqYM/OQ/XUNPCiPujgp0/qn62YH9xct4ru5X0h02a+w1AY8b4p1/XWIodY18uc9xxcruNh/CZ2VD3WG8DTP+PgY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e3581e-bdc3-417f-126b-08d804091de5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 19:47:28.3978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v7+4B+xEhKzEz0Qyu7sA8/FOlh8yW59BiNg9wKA1CJBz/R16oMXXEZE+Ldo+oiVkSgY4JDbKdfps45rm057Xvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to this patch mlx5e tls rx handler was called unconditionally on
all rx  packets and the decision whether a packet is a valid tls packet
is done inside that function.  A function call can be expensive especially
for regular rx packet rate.  To avoid this, check the tls validity before
jumping into the tls rx handler.

While at it, split between kTLS device offload rx handler and FPGA tls rx
handler using a similar method.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  7 +----
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    | 12 +++------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h    | 26 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  5 ++--
 4 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 703ce78d54043..b0e7eb92d7174 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -481,12 +481,7 @@ int mlx5e_ktls_rx_resync(struct net_device *netdev, struct sock *sk,
 void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
 			      struct mlx5_cqe64 *cqe, u32 *cqe_bcnt)
 {
-	u8 tls_offload = get_cqe_tls_offload(cqe);
-
-	if (likely(tls_offload == CQE_TLS_OFFLOAD_NOT_DECRYPTED))
-		return;
-
-	switch (tls_offload) {
+	switch (get_cqe_tls_offload(cqe)) {
 	case CQE_TLS_OFFLOAD_DECRYPTED:
 		skb->decrypted = 1;
 		rq->stats->tls_decrypted_packets++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 182841322ce42..b0c31d49ff8db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -355,19 +355,13 @@ static int tls_update_resync_sn(struct net_device *netdev,
 	return 0;
 }
 
-void mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
-			     struct mlx5_cqe64 *cqe, u32 *cqe_bcnt)
+/* FPGA tls rx handler */
+void mlx5e_tls_handle_rx_skb_metadata(struct mlx5e_rq *rq, struct sk_buff *skb,
+				      u32 *cqe_bcnt)
 {
 	struct mlx5e_tls_metadata *mdata;
 	struct mlx5e_priv *priv;
 
-	if (likely(mlx5_accel_is_ktls_rx(rq->mdev)))
-		return mlx5e_ktls_handle_rx_skb(rq, skb, cqe, cqe_bcnt);
-
-	/* FPGA */
-	if (!is_metadata_hdr_valid(skb))
-		return;
-
 	/* Use the metadata */
 	mdata = (struct mlx5e_tls_metadata *)(skb->data + ETH_HLEN);
 	switch (mdata->content.recv.syndrome) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
index 8bb7906740425..08cb0f91fcd09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
@@ -34,6 +34,7 @@
 #ifndef __MLX5E_TLS_RXTX_H__
 #define __MLX5E_TLS_RXTX_H__
 
+#include "accel/accel.h"
 #include "en_accel/ktls_txrx.h"
 
 #ifdef CONFIG_MLX5_EN_TLS
@@ -49,11 +50,32 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 void mlx5e_tls_handle_tx_wqe(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
 			     struct mlx5e_accel_tx_tls_state *state);
 
-void mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
-			     struct mlx5_cqe64 *cqe, u32 *cqe_bcnt);
+void mlx5e_tls_handle_rx_skb_metadata(struct mlx5e_rq *rq, struct sk_buff *skb,
+				      u32 *cqe_bcnt);
+
+static inline bool mlx5e_accel_is_tls(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
+{
+	return get_cqe_tls_offload(cqe) || is_metadata_hdr_valid(skb);
+}
+
+static inline void
+mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
+			struct mlx5_cqe64 *cqe, u32 *cqe_bcnt)
+{
+	if (likely(mlx5e_accel_is_tls(cqe, skb)))
+		return mlx5e_ktls_handle_rx_skb(rq, skb, cqe, cqe_bcnt);
+
+	/* FPGA */
+	return mlx5e_tls_handle_rx_skb_metadata(rq, skb, cqe_bcnt);
+}
 
 #else
 
+static inline bool
+mlx5e_accel_is_tls(struct mlx5_cqe64 *cqe, struct sk_buff *skb) { return false; }
+static inline void
+mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
+			struct mlx5_cqe64 *cqe, u32 *cqe_bcnt) {}
 static inline u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq)
 {
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 19bcd49224526..35ff190daaa1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1019,9 +1019,8 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 
 	skb->mac_len = ETH_HLEN;
 
-#ifdef CONFIG_MLX5_EN_TLS
-	mlx5e_tls_handle_rx_skb(rq, skb, cqe, &cqe_bcnt);
-#endif
+	if (unlikely(mlx5e_accel_is_tls(cqe, skb)))
+		mlx5e_tls_handle_rx_skb(rq, skb, cqe, &cqe_bcnt);
 
 	if (lro_num_seg > 1) {
 		mlx5e_lro_update_hdr(skb, cqe, cqe_bcnt);
-- 
2.26.2

