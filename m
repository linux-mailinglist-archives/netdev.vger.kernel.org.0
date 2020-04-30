Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067D71C03D1
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgD3RWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:22:08 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726950AbgD3RWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:22:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZxLwJmv6REiqoksBiGhoyFo2GLZUR+TBgGN3bFG2wbfAMX9/mf7HDwZLyc5dGUYjDk03+3CAHVIQKTO2vkUWpCpCmX8EWynL3XJNMHIFdTeMI+pPlmK7HiumCaLEuRptnXD+8re8HDKHzQDdEPUJwG4WeiM+9eGSKeFGSuNCwgXJMcH5KD2JfX25HmhAq2h+Q29lN1p0gMJLsQeGECMcX1OAQF94R44oLMOwGlwGO97NZjJ12/HDLOH3ecPq9TZkwzHH0PVs3hWDZ9AS3/tddAkQkP24dNIEmefHTeK94hgMVGqbhur6UIshuPrwOZVec6BSVZVQR5XFwLGrmZ3iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCcJ8+8Sq1LsaAa4ZyLUNxHHcsXxxaOjHU9rIBH2zwI=;
 b=NbxpR9CbY5VWyeRTv04Jap0PG3oAy8hOU422GVJ8F6ZJHKw8Oihqw/D2Vu413JU94LVLF6iFNQaaxcBQza+iq1GTGRkpTLNrnDYQay9NPX7RobIxc6Yr/Ffiqml9gfVL5lxodOBGwhGGeg9TIOfP4OLgJc9WwTzvoBYDiqM+SFuTbyedrjKTn8Jhav55TPw9bYuO2syJ/DQ8w5zolaOpylwK80mIrKvLiSNuDJNToOxaLSnU6D7V9fABKIe2p/FIfWDxbdBX8P+PlpJBRS7vbA/anlb0t9KxhIaBjRd0/3/f/bFZv27Hgj4/X4L2okX1CuINLqFoRw11TnEacRcvcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCcJ8+8Sq1LsaAa4ZyLUNxHHcsXxxaOjHU9rIBH2zwI=;
 b=j4HgFbSi1x/WUDGeulIeHQI79bNberdp0HRBZzzD8rhF8KN4vtVolS9Ru8SN76zH+Nh73W2YKseLI+u9BbpqDZdVeTdIp0bFmN3gw96MoqFrv9AhPDke0lHXuRHHg36e/AoECDGPTD65NAhU7ltmRu0+4p8s83Otn41em5qGmHQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/15] net/mlx5e: TX, Generalise code and usage of error CQE dump
Date:   Thu, 30 Apr 2020 10:18:31 -0700
Message-Id: <20200430171835.20812-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:19 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28c87d05-9b87-4734-4bff-08d7ed2ae6f1
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB329677F2943561E1791DA9E7BEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: udRc2opXT/Rzq6s6zJcTDFbkH+RmtxFcasxjm9tAhZ2Q5tbaU4KZTFw6klOzVU9eHyCKRMWQtalwmuSWdTlQ9xRYziymEg+9KGgjCfHNIcW5hCYNW6Xj+4KDU/Mrd80ZmHeHOw8A9xmtNm7QR8ruUp+jbLKbEfYEWeZIc8sOWhpzrD4Jj3DNyOYhZU2R5fdmY3aY7qIltDocrYvBPKiVtgGeUq8HB+6+ctDsBi/OZ7s/nVOpxM2wKAUS3Pj0UwGeTgIQ7YlZP2pUqckTTMeQ502GhqXnyRbMGc0XhvREAXaQY1TbRf4kuyJv7UInyhbp+2qiFNazBJtpTXHUWwm6arEaN6AwOoRqd5Nt71cs9yCaHoVOudNXZsBCLqUIE6V+aGjRkIyyzcAlCmS6oYrT+36xle01VPuCyZejdef01YM7AIkFcxV+WmJ+HgwnbU7sD8wKxEskForKYxJ+PTh1EhOOwhGNccD/CUCaLgF2Fct6Gi+RSsSJ3DbcTT2+Twpk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aP+5EJyOLOAa9Bz52FCTKKFTkGpq13Y96xjDDUY4E3WDoHgaGk7O0zuSiRdeXOthS5XZe6OceylyBoXgy6z4AN1ensz1cKPmPP4zNpVOcq6WYeEIVsxLQ2lmpP8mi4k5jIRVHft/pH0/HaA0jhl6kN0ofafDopaQBtblI2C+f6Ajv+6RyZCadipa+pbjT4c+XSkjK4mdR0XMV8VI0Z4jP9AYi7gG1dh8HndvQd1IwO2lCoMZuWuGBaWlKE2MSgjXxjpKFuh8kwa7k0AzzeIcYYq0zAZukHBB/yx1Kt1J9Wmid77sWScffHNQvw0fzBQMKZ7lepmKOjOP2ENXdWMY1/1AAaSWip7afVr6KmzHEnVjjQ/xAdrngThC3Dd7boYgKl0Z3g1db+r+0U21i98Z88wzr8kj+mynyGZzDe3eRsSHehQHU0IwKDoYbX+CcdLdGLoOklel/RJ9OtdSEsPcMA0/NzbOsAYtbIw0BFH3fErtxXp8V7shIJ8w/0+uZi7qwVt5ktI1otRbcVnGOeW8QoXE0OvGQGvIbmQidZulisdN+H+puoRq8fOJJkKGC4I8ZtZJD1/U2qjJ4lIDfOjLojO7i0pRJXIinBAV69fVDxnVbXqocGw4nznm7Jd2pFQU5Uzjmj0qiynFB0k84MM9fuTJfFFxMQfGvp5aG4ySMv3N0Lz+QoFYudg3Yl7jDGXV0DHpCZBH+eQhkTSbzz1rUICVdxozL4bXYRLO9PHTz8vSKCNQT4OnjpkHVh5co2PmEjbF+zt0ZjSbmBSYLmRaTolWwdTT08y8IKdBaOtqQP8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c87d05-9b87-4734-4bff-08d7ed2ae6f1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:21.8135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8cFf7faj0kswqI4PTsQKZOVnkO2GJe4SrqRSaEBdPrkgUI6qyRi4l0goUxJcHkEnkorE327E+rpFUImnir2n/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Error CQE was dumped only for TXQ SQs.
Generalise the function, and add usage for error completions
on ICO SQs and XDP SQs.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h  | 16 ++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c   | 13 ++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c    |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en_tx.c    | 18 +-----------------
 4 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 9f6967d76053..c0249fc77eaa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -189,6 +189,22 @@ static inline void mlx5e_rqwq_reset(struct mlx5e_rq *rq)
 	}
 }
 
+static inline void mlx5e_dump_error_cqe(struct mlx5e_cq *cq, u32 sqn,
+					struct mlx5_err_cqe *err_cqe)
+{
+	struct mlx5_cqwq *wq = &cq->wq;
+	u32 ci;
+
+	ci = mlx5_cqwq_ctr2ix(wq, wq->cc - 1);
+
+	netdev_err(cq->channel->netdev,
+		   "Error cqe on cqn 0x%x, ci 0x%x, sqn 0x%x, opcode 0x%x, syndrome 0x%x, vendor syndrome 0x%x\n",
+		   cq->mcq.cqn, ci, sqn,
+		   get_cqe_opcode((struct mlx5_cqe64 *)err_cqe),
+		   err_cqe->syndrome, err_cqe->vendor_err_synd);
+	mlx5_dump_err_cqe(cq->mdev, err_cqe);
+}
+
 /* SW parser related functions */
 
 struct mlx5e_swp_spec {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f049e0ac308a..f9dad2639061 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -415,11 +415,6 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 
 		wqe_counter = be16_to_cpu(cqe->wqe_counter);
 
-		if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ))
-			netdev_WARN_ONCE(sq->channel->netdev,
-					 "Bad OP in XDPSQ CQE: 0x%x\n",
-					 get_cqe_opcode(cqe));
-
 		do {
 			struct mlx5e_xdp_wqe_info *wi;
 			u16 ci;
@@ -432,6 +427,14 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 
 			mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, true);
 		} while (!last_wqe);
+
+		if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
+			netdev_WARN_ONCE(sq->channel->netdev,
+					 "Bad OP in XDPSQ CQE: 0x%x\n",
+					 get_cqe_opcode(cqe));
+			mlx5e_dump_error_cqe(&sq->cq, sq->sqn,
+					     (struct mlx5_err_cqe *)cqe);
+		}
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
 	if (xsk_frames)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index e2beb89c1832..4db1c92f0019 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -631,6 +631,8 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 				netdev_WARN_ONCE(cq->channel->netdev,
 						 "Bad OP in ICOSQ CQE: 0x%x\n",
 						 get_cqe_opcode(cqe));
+				mlx5e_dump_error_cqe(&sq->cq, sq->sqn,
+						     (struct mlx5_err_cqe *)cqe);
 				if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
 					queue_work(cq->channel->priv->wq, &sq->recover_work);
 				break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index fd6b2a1898c5..1679557f34c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -399,22 +399,6 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	return mlx5e_sq_xmit(sq, skb, wqe, pi, netdev_xmit_more());
 }
 
-static void mlx5e_dump_error_cqe(struct mlx5e_txqsq *sq,
-				 struct mlx5_err_cqe *err_cqe)
-{
-	struct mlx5_cqwq *wq = &sq->cq.wq;
-	u32 ci;
-
-	ci = mlx5_cqwq_ctr2ix(wq, wq->cc - 1);
-
-	netdev_err(sq->channel->netdev,
-		   "Error cqe on cqn 0x%x, ci 0x%x, sqn 0x%x, opcode 0x%x, syndrome 0x%x, vendor syndrome 0x%x\n",
-		   sq->cq.mcq.cqn, ci, sq->sqn,
-		   get_cqe_opcode((struct mlx5_cqe64 *)err_cqe),
-		   err_cqe->syndrome, err_cqe->vendor_err_synd);
-	mlx5_dump_err_cqe(sq->cq.mdev, err_cqe);
-}
-
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 {
 	struct mlx5e_sq_stats *stats;
@@ -501,7 +485,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 		if (unlikely(get_cqe_opcode(cqe) == MLX5_CQE_REQ_ERR)) {
 			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING,
 					      &sq->state)) {
-				mlx5e_dump_error_cqe(sq,
+				mlx5e_dump_error_cqe(&sq->cq, sq->sqn,
 						     (struct mlx5_err_cqe *)cqe);
 				mlx5_wq_cyc_wqe_dump(&sq->wq, ci, wi->num_wqebbs);
 				queue_work(cq->channel->priv->wq,
-- 
2.25.4

