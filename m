Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9398A1B1885
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgDTVhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:37:23 -0400
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:19937
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgDTVhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:37:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jelWKhcsuqVmNwohgjUkroXOWLS1Vaj3f04sHjz2ppirS6DNx5KdUlaJ7JcK+Ej0UMVEshgPC2d36ggHYfAQolv9+XGv1ILYkqNxkwF9W/XJUowdhgGlDTLynUIfsrLodJMImsjE0DAbD2mXBXniHWRa+ubbKBpHGs7mhjrxqfZlnudN9KlRI+QRdasLhduBuFvj635ZHE7tVuw6EPhOmQWP1Lv7D+hgplUZyYVlT6xAEhs5dm47o01VK4AJBGgnWPDtyjnynQlf8P9cez5eAW+J4eUppPQjdbuICT98MinNCBD8jU6pqxlTvh+te0vzK/2S3x8eCCN2cqg42cZ7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fo9k5nwP54t0PdxWN324X8w6ftmwdz/03T0cZs1OlYE=;
 b=fOYzMqCd449L8N4/Grerz43hJuLvDvfB5Q6Hisz0whiHbId6qeaGm97HS2HymHuG8uFaG18by/1bUxQW9y1yN7NULJROGadt6HN7mBg4DVYLozGFBwkh29TAeMdgdJLS2SCmxnzq+7EgIsoQg9v6jTMT6AS5zCK09cK6R68vTH7DndhgRBAfrOuPYHt0yDS1OnTRnrvcvLp5xUycGm9x8Q/Y6x7HX7UiVAQhTMitSNqYczWJMDkqV0Lzi2Svb3VmE8MiDKVE0DfsOGQP0cL9DVs4kKAMfLAjtm2TfwceHl3jFSz0Mk4JOrRYZRN0PSJq/C0RxkK1SVslMqSyO8zowA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fo9k5nwP54t0PdxWN324X8w6ftmwdz/03T0cZs1OlYE=;
 b=KIG1X8ea0zp2pIBpNykCxwb6JkliKJXYY7LhsMB0R7T1Hr1kABckdSQoUMFnb4rD3+eP46isRnAJEgUXFlwpEK1DPU6ayqPai/c6K5Sdf0Sga5oHeoIyexFU0NkMvZ+gZEXS9A5hM6Xd/thbU43qWbn1bUYgjrJr4YBw7P190cM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6509.eurprd05.prod.outlook.com (2603:10a6:803:f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:36:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:36:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/5] net/mlx5e: Don't trigger IRQ multiple times on XSK wakeup to avoid WQ overruns
Date:   Mon, 20 Apr 2020 14:36:04 -0700
Message-Id: <20200420213606.44292-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420213606.44292-1-saeedm@mellanox.com>
References: <20200420213606.44292-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0017.namprd20.prod.outlook.com (2603:10b6:a03:1f4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 21:36:44 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: becbec3c-0c59-4ad7-855a-08d7e572ecd0
X-MS-TrafficTypeDiagnostic: VI1PR05MB6509:|VI1PR05MB6509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB650955884D0D5045A9F3A98CBED40@VI1PR05MB6509.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(1076003)(6486002)(66946007)(26005)(36756003)(6506007)(81156014)(66556008)(8936002)(6916009)(54906003)(2906002)(52116002)(66476007)(316002)(8676002)(5660300002)(478600001)(107886003)(4326008)(956004)(86362001)(2616005)(6666004)(6512007)(186003)(16526019)(54420400002)(309714004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mzutCxx3T4kgWAIsteD5SGFzJ+DUqkC2g1Nkj+FgWI9n/tWlL25D9sGGSTAlVDtlK37DuSKvC6W29PnvAIrrcvmnyyt/KXmg1oqNwM8lUlaG2twOsBs2XtrGajnOqI1gESktjcVBwE4PNwMrcOkKhQJZa3wc97K5EAXNy8Na72lpmQ1fcYAxAe7SNO19CEuJ3HXKccx/MWiYyNrVnoXNs8SHfJMJLVa0oFEVnMsCBSzVzUhfubcLG0VOgXy4SCyknPpXeIw/M+16w8h3ejxzlMh6iBaKCART3Cpk3aB1PIgUPc6YbvJQWrc77JP/ZCh26mjGL9rDzIrSHoDQlSYJXklNoXrJ/sJEQwzrnOxwZ+t7aH3RraKq83OP9Cd4ctXW/k0p0y88lFlnBXWa9vl8hr9hyPvIhTxjITE7iMFeey4eS1gor62k0Rt+iFmvNLWoMfnigTvOErZdus1zCRk3psMKVz3kkI3wqs21qsytchcTEFxpKLAp/4X7dHVMga8iNhWbsgkg4J74ZKwsU5suUA==
X-MS-Exchange-AntiSpam-MessageData: Rrbjy0IwGrtc0ux+estztXq/dVzEcmiNJkwZ3hS2SK6OkSZZs5xoQg0gkD+Fb5n73mE2NxfUlpTs9KkyCgNGVADVdFqjaj2sVBdvuCNWrifbe2eON/CoUn0Wj400iKQ5R9s4Oph52QdRgzX7uioyMg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: becbec3c-0c59-4ad7-855a-08d7e572ecd0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:36:46.0524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QjozgWfu7fJUigT14lIehWHHxtwyesnJA4/e7CLRLhaoLHttLD2yNsTtTaw3fHQlEPr4FQNrzGVFfUIGc4FD7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6509
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

XSK wakeup function triggers NAPI by posting a NOP WQE to a special XSK
ICOSQ. When the application floods the driver with wakeup requests by
calling sendto() in a certain pattern that ends up in mlx5e_trigger_irq,
the XSK ICOSQ may overflow.

Multiple NOPs are not required and won't accelerate the process, so
avoid posting a second NOP if there is one already on the way. This way
we also avoid increasing the queue size (which might not help anyway).

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c   | 6 +++++-
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 12a61bf82c14..23701c0e36ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -367,6 +367,7 @@ enum {
 	MLX5E_SQ_STATE_AM,
 	MLX5E_SQ_STATE_TLS,
 	MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE,
+	MLX5E_SQ_STATE_PENDING_XSK_TX,
 };
 
 struct mlx5e_sq_wqe_info {
@@ -960,7 +961,7 @@ void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
 void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq);
-void mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
+int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
 bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq);
 void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix);
 void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index fe2d596cb361..3bcdb5b2fc20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -33,6 +33,9 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 		if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &c->xskicosq.state)))
 			return 0;
 
+		if (test_and_set_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->xskicosq.state))
+			return 0;
+
 		spin_lock(&c->xskicosq_lock);
 		mlx5e_trigger_irq(&c->xskicosq);
 		spin_unlock(&c->xskicosq_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6173faf542b0..e2beb89c1832 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -589,7 +589,7 @@ bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 	return !!err;
 }
 
-void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
+int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 {
 	struct mlx5e_icosq *sq = container_of(cq, struct mlx5e_icosq, cq);
 	struct mlx5_cqe64 *cqe;
@@ -597,11 +597,11 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 	int i;
 
 	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state)))
-		return;
+		return 0;
 
 	cqe = mlx5_cqwq_get_cqe(&cq->wq);
 	if (likely(!cqe))
-		return;
+		return 0;
 
 	/* sq->cc must be updated only after mlx5_cqwq_update_db_record(),
 	 * otherwise a cq overrun may occur
@@ -650,6 +650,8 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 	sq->cc = sqcc;
 
 	mlx5_cqwq_update_db_record(&cq->wq);
+
+	return i;
 }
 
 bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 87c49e7a164c..acb20215a33b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -152,7 +152,11 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 				mlx5e_post_rx_wqes,
 				rq);
 	if (xsk_open) {
-		mlx5e_poll_ico_cq(&c->xskicosq.cq);
+		if (mlx5e_poll_ico_cq(&c->xskicosq.cq))
+			/* Don't clear the flag if nothing was polled to prevent
+			 * queueing more WQEs and overflowing XSKICOSQ.
+			 */
+			clear_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->xskicosq.state);
 		busy |= mlx5e_poll_xdpsq_cq(&xsksq->cq);
 		busy_xsk |= mlx5e_napi_xsk_post(xsksq, xskrq);
 	}
-- 
2.25.3

