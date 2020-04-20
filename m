Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64C71B185D
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgDTVYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:24:05 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:60862
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbgDTVYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:24:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtvtO2mnV1s5iwpp2NppX2XURCtdMAek0rpfRIjWtn63j5pQSdM/FTRidXjkZEN7gYflrAKLGngGXLCQYEMTM87iZGeDQ31deZNYlUZv9TkckpG0QBSK2pViFsbem3HyME0wzOSXDpICk/InU/o84Mbp/tYs6RzBXAVdBPW+SY+MLi1t8V7uxVsI1x6a/AyR3mgQSeSoLVEMBhA6F2H/JEmQYNzjxTSu1WIghZMYIa02h9DbmZR+kppJ4eR9LWlMU4mssoVij1KDs67Dv4Les8FXFc4xdtFhbYya/z3qPnl5gnF/tcycu24PkzmtQBooAYWWcO514n2uu1bs3UYLBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOWCUgDJcdXcDFgqm2q7aZ+y4txU8gdk94BGdWRc97Q=;
 b=jZwaI6TaEclpXACx0e7FVQQpIan12SgXhEUEH40oQU08WGbAZco6QsHzV9oJVf84SVJRQYbPRWNVABGRD4zjjsvd8ZqDS9cPEn36iThQALnDtcSn5pWhui6DPypWNg4vu/BYHlKrdY2Co5BOfoy1vaNAouukpMiCauutH57xGY7+iA7emEGxl0Hjfz2CqgjfI/v9QkwpH4+VEzieQ9gALAVrg9c4L1Mvj4H1s/40wVBdFiNXOkaRCAAMDsvgniQyN7s8UvroayAjABxiFcwxesPQ86Cb7HIAg6sAEcwZ7RxsSVA1DR0f4QLIzjPHyWTMmYhy8Pwr1sZnUb2oMMa2ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOWCUgDJcdXcDFgqm2q7aZ+y4txU8gdk94BGdWRc97Q=;
 b=jK2GDQMcWWoYUptN+ln7nI9hREI8Srh8Lp8zJ5N3TkFBUxK5xvAVja90dGuQbw7uHp0kHkDa0Kw0gMEW6BiAd4ahaHC1MqVOOD9ro4KTaUf1bVOUU6de2f3TBXBsZ/E3HJ5deJF14D/MpJyaHh99+2rHBYiFuEJ2MLW3jSOJrXs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6478.eurprd05.prod.outlook.com (2603:10a6:803:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:23:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:23:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/10] net/mlx5: IPsec, Refactor SA handle creation and destruction
Date:   Mon, 20 Apr 2020 14:22:18 -0700
Message-Id: <20200420212223.41574-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420212223.41574-1-saeedm@mellanox.com>
References: <20200420212223.41574-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 21:23:05 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7be2e967-6744-49dc-05ff-08d7e571052e
X-MS-TrafficTypeDiagnostic: VI1PR05MB6478:|VI1PR05MB6478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB64783D0C5F3CF99B78455773BED40@VI1PR05MB6478.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(107886003)(6506007)(86362001)(2906002)(186003)(16526019)(30864003)(26005)(4326008)(5660300002)(36756003)(316002)(1076003)(66556008)(478600001)(956004)(6666004)(66946007)(52116002)(66476007)(6512007)(6486002)(2616005)(54906003)(8676002)(8936002)(81156014)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jACw853o9/lUd9kEiPy3vYnEXf4UGz+u8QAmDCa5ntt1n/d+Be+anFp22tByXcs/j+LLVpD+Ax/PZe4EtHnfDCbfi4ytLyGObjHfFiEJKjebw6c8NsggVpMAKM3l9Wty0sxtKu/WUOBU/8APzrHmOuvx60pVkuBDyAsk0El/oIZu3r4q2hzspmZqxl/3GWD7u7iCSivCIoXeQfGHFK3jWxHkHyrsRuHlftujlkZMYMAEX/ErJtwTti04uNC+7GF7xuiUgH39DtFKU1E5uHzqYtbM3bDjnu3iehg4x68GENzxS3B73sDNicxV9q74y+Ub+SVl2SMcAsdNOreSaImCpDCK2stfigI43wePHhpmhXXS2A9pKRCzD8D2d0bkj608NJ7aYVDtvO6/7nANSq0GhqTrT2Vxgo3vpdMQbLjNs0zWB52k8RBG1OUAYiccdYk0L8a+VScQSt4dobyQ85KqDX5pYCPmh8hWe+N2MY/yR+qVD3KMMoQrvwChZ1cN0TKs
X-MS-Exchange-AntiSpam-MessageData: y9NjXYF9X0+vYZymDuGLJBBFNxnxPOlnGTp8VpNW5M+gd6oERyKnVHvBj38jfHzcggYTsumTQEk/ViOAz+TJh3WfKNratYjTQ7zNIUMIcAym1x6SclKwhksfJlh4s7lhiK9MjjkzlJKwnXlrnD9Fzg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be2e967-6744-49dc-05ff-08d7e571052e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:23:08.2578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hh4trMnlkD04CV2dSGvWUR1sup8X0qSGTvP31DYi90IPnG09gPKnDmlkRdixgzK6KuCr7Kw1Gf8NrV0UsQ77NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6478
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Currently the SA handle is created and managed as part of the common
code for different IPsec supporting HW, this handle is passed to HW
to be used on Rx to identify the SA handle that was used to
return the xfrm state to stack.

The above implementation pose a limitation on managing this handle.

Refactor by moving management of this field to the specific HW code.

Downstream patches will introduce the Connect-X support for IPsec that
will use this handle differently than current implementation.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/accel/ipsec.c |  5 +-
 .../ethernet/mellanox/mlx5/core/accel/ipsec.h |  6 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 68 ++++++++-----------
 .../ethernet/mellanox/mlx5/core/fpga/ipsec.c  | 29 +++++++-
 .../ethernet/mellanox/mlx5/core/fpga/ipsec.h  |  3 +-
 5 files changed, 63 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
index a92cd88d369c..8a4985d8cbfe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
@@ -57,7 +57,8 @@ int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
 }
 
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm)
+				       struct mlx5_accel_esp_xfrm *xfrm,
+				       u32 *sa_handle)
 {
 	__be32 saddr[4] = {}, daddr[4] = {};
 
@@ -71,7 +72,7 @@ void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
 
 	return mlx5_fpga_ipsec_create_sa_ctx(mdev, xfrm, saddr,
 					     daddr, xfrm->attrs.spi,
-					     xfrm->attrs.is_ipv6);
+					     xfrm->attrs.is_ipv6, sa_handle);
 }
 
 void mlx5_accel_esp_free_hw_context(void *context)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
index f9b8e2a041c1..e89747674712 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
@@ -47,7 +47,8 @@ int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
 				   unsigned int count);
 
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm);
+				       struct mlx5_accel_esp_xfrm *xfrm,
+				       u32 *sa_handle);
 void mlx5_accel_esp_free_hw_context(void *context);
 
 int mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev);
@@ -60,7 +61,8 @@ void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev);
 
 static inline void *
 mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				 struct mlx5_accel_esp_xfrm *xfrm)
+				 struct mlx5_accel_esp_xfrm *xfrm,
+				 u32 *sa_handle)
 {
 	return NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 9e6c2216c93e..92eb3bad4acd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -75,18 +75,23 @@ struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *ipsec,
 	return ret;
 }
 
-static int mlx5e_ipsec_sadb_rx_add(struct mlx5e_ipsec_sa_entry *sa_entry)
+static int  mlx5e_ipsec_sadb_rx_add(struct mlx5e_ipsec_sa_entry *sa_entry,
+				    unsigned int handle)
 {
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
+	struct mlx5e_ipsec_sa_entry *_sa_entry;
 	unsigned long flags;
-	int ret;
 
-	ret = ida_simple_get(&ipsec->halloc, 1, 0, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
+	rcu_read_lock();
+	hash_for_each_possible_rcu(ipsec->sadb_rx, _sa_entry, hlist, handle)
+		if (_sa_entry->handle == handle) {
+			rcu_read_unlock();
+			return  -EEXIST;
+		}
+	rcu_read_unlock();
 
 	spin_lock_irqsave(&ipsec->sadb_rx_lock, flags);
-	sa_entry->handle = ret;
+	sa_entry->handle = handle;
 	hash_add_rcu(ipsec->sadb_rx, &sa_entry->hlist, sa_entry->handle);
 	spin_unlock_irqrestore(&ipsec->sadb_rx_lock, flags);
 
@@ -103,15 +108,6 @@ static void mlx5e_ipsec_sadb_rx_del(struct mlx5e_ipsec_sa_entry *sa_entry)
 	spin_unlock_irqrestore(&ipsec->sadb_rx_lock, flags);
 }
 
-static void mlx5e_ipsec_sadb_rx_free(struct mlx5e_ipsec_sa_entry *sa_entry)
-{
-	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
-
-	/* xfrm already doing sync rcu between del and free callbacks */
-
-	ida_simple_remove(&ipsec->halloc, sa_entry->handle);
-}
-
 static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct xfrm_replay_state_esn *replay_esn;
@@ -292,6 +288,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	struct net_device *netdev = x->xso.dev;
 	struct mlx5_accel_esp_xfrm_attrs attrs;
 	struct mlx5e_priv *priv;
+	unsigned int sa_handle;
 	int err;
 
 	priv = netdev_priv(netdev);
@@ -309,20 +306,6 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	sa_entry->x = x;
 	sa_entry->ipsec = priv->ipsec;
 
-	/* Add the SA to handle processed incoming packets before the add SA
-	 * completion was received
-	 */
-	if (x->xso.flags & XFRM_OFFLOAD_INBOUND) {
-		err = mlx5e_ipsec_sadb_rx_add(sa_entry);
-		if (err) {
-			netdev_info(netdev, "Failed adding to SADB_RX: %d\n", err);
-			goto err_entry;
-		}
-	} else {
-		sa_entry->set_iv_op = (x->props.flags & XFRM_STATE_ESN) ?
-				mlx5e_ipsec_set_iv_esn : mlx5e_ipsec_set_iv;
-	}
-
 	/* check esn */
 	mlx5e_ipsec_update_esn_state(sa_entry);
 
@@ -333,30 +316,38 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 					   MLX5_ACCEL_XFRM_FLAG_REQUIRE_METADATA);
 	if (IS_ERR(sa_entry->xfrm)) {
 		err = PTR_ERR(sa_entry->xfrm);
-		goto err_sadb_rx;
+		goto err_sa_entry;
 	}
 
 	/* create hw context */
 	sa_entry->hw_context =
 			mlx5_accel_esp_create_hw_context(priv->mdev,
-							 sa_entry->xfrm);
+							 sa_entry->xfrm,
+							 &sa_handle);
 	if (IS_ERR(sa_entry->hw_context)) {
 		err = PTR_ERR(sa_entry->hw_context);
 		goto err_xfrm;
 	}
 
+	if (x->xso.flags & XFRM_OFFLOAD_INBOUND) {
+		err = mlx5e_ipsec_sadb_rx_add(sa_entry, sa_handle);
+		if (err)
+			goto err_hw_ctx;
+	} else {
+		sa_entry->set_iv_op = (x->props.flags & XFRM_STATE_ESN) ?
+				mlx5e_ipsec_set_iv_esn : mlx5e_ipsec_set_iv;
+	}
+
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	goto out;
 
+err_hw_ctx:
+	mlx5_accel_esp_free_hw_context(sa_entry->hw_context);
 err_xfrm:
 	mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
-err_sadb_rx:
-	if (x->xso.flags & XFRM_OFFLOAD_INBOUND) {
-		mlx5e_ipsec_sadb_rx_del(sa_entry);
-		mlx5e_ipsec_sadb_rx_free(sa_entry);
-	}
-err_entry:
+err_sa_entry:
 	kfree(sa_entry);
+
 out:
 	return err;
 }
@@ -385,9 +376,6 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 		mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
 	}
 
-	if (x->xso.flags & XFRM_OFFLOAD_INBOUND)
-		mlx5e_ipsec_sadb_rx_free(sa_entry);
-
 	kfree(sa_entry);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index c8736b6b4172..0604216eb94f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -65,6 +65,7 @@ struct mlx5_fpga_esp_xfrm;
 struct mlx5_fpga_ipsec_sa_ctx {
 	struct rhash_head		hash;
 	struct mlx5_ifc_fpga_ipsec_sa	hw_sa;
+	u32				sa_handle;
 	struct mlx5_core_dev		*dev;
 	struct mlx5_fpga_esp_xfrm	*fpga_xfrm;
 };
@@ -119,6 +120,8 @@ struct mlx5_fpga_ipsec {
 	 */
 	struct rb_root rules_rb;
 	struct mutex rules_rb_lock; /* rules lock */
+
+	struct ida halloc;
 };
 
 static bool mlx5_fpga_is_ipsec_device(struct mlx5_core_dev *mdev)
@@ -666,7 +669,8 @@ void *mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
 				    struct mlx5_accel_esp_xfrm *accel_xfrm,
 				    const __be32 saddr[4],
 				    const __be32 daddr[4],
-				    const __be32 spi, bool is_ipv6)
+				    const __be32 spi, bool is_ipv6,
+				    u32 *sa_handle)
 {
 	struct mlx5_fpga_ipsec_sa_ctx *sa_ctx;
 	struct mlx5_fpga_esp_xfrm *fpga_xfrm =
@@ -704,6 +708,17 @@ void *mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
 		goto exists;
 	}
 
+	if (accel_xfrm->attrs.action & MLX5_ACCEL_ESP_ACTION_DECRYPT) {
+		err = ida_simple_get(&fipsec->halloc, 1, 0, GFP_KERNEL);
+		if (err < 0) {
+			context = ERR_PTR(err);
+			goto exists;
+		}
+
+		sa_ctx->sa_handle = err;
+		if (sa_handle)
+			*sa_handle = sa_ctx->sa_handle;
+	}
 	/* This is unbounded fpga_xfrm, try to add to hash */
 	mutex_lock(&fipsec->sa_hash_lock);
 
@@ -744,7 +759,8 @@ void *mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
 				       rhash_sa));
 unlock_hash:
 	mutex_unlock(&fipsec->sa_hash_lock);
-
+	if (accel_xfrm->attrs.action & MLX5_ACCEL_ESP_ACTION_DECRYPT)
+		ida_simple_remove(&fipsec->halloc, sa_ctx->sa_handle);
 exists:
 	mutex_unlock(&fpga_xfrm->lock);
 	kfree(sa_ctx);
@@ -816,7 +832,7 @@ mlx5_fpga_ipsec_fs_create_sa_ctx(struct mlx5_core_dev *mdev,
 	/* create */
 	return mlx5_fpga_ipsec_create_sa_ctx(mdev, accel_xfrm,
 					     saddr, daddr,
-					     spi, is_ipv6);
+					     spi, is_ipv6, NULL);
 }
 
 static void
@@ -836,6 +852,10 @@ mlx5_fpga_ipsec_release_sa_ctx(struct mlx5_fpga_ipsec_sa_ctx *sa_ctx)
 		return;
 	}
 
+	if (sa_ctx->fpga_xfrm->accel_xfrm.attrs.action &
+	    MLX5_ACCEL_ESP_ACTION_DECRYPT)
+		ida_simple_remove(&fipsec->halloc, sa_ctx->sa_handle);
+
 	mutex_lock(&fipsec->sa_hash_lock);
 	WARN_ON(rhashtable_remove_fast(&fipsec->sa_hash, &sa_ctx->hash,
 				       rhash_sa));
@@ -1299,6 +1319,8 @@ int mlx5_fpga_ipsec_init(struct mlx5_core_dev *mdev)
 		goto err_destroy_hash;
 	}
 
+	ida_init(&fdev->ipsec->halloc);
+
 	return 0;
 
 err_destroy_hash:
@@ -1331,6 +1353,7 @@ void mlx5_fpga_ipsec_cleanup(struct mlx5_core_dev *mdev)
 	if (!mlx5_fpga_is_ipsec_device(mdev))
 		return;
 
+	ida_destroy(&fdev->ipsec->halloc);
 	destroy_rules_rb(&fdev->ipsec->rules_rb);
 	rhashtable_destroy(&fdev->ipsec->sa_hash);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
index d01b1fc8e11b..9ba637f0f0f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
@@ -47,7 +47,8 @@ void *mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
 				    struct mlx5_accel_esp_xfrm *accel_xfrm,
 				    const __be32 saddr[4],
 				    const __be32 daddr[4],
-				    const __be32 spi, bool is_ipv6);
+				    const __be32 spi, bool is_ipv6,
+				    u32 *sa_handle);
 void mlx5_fpga_ipsec_delete_sa_ctx(void *context);
 
 int mlx5_fpga_ipsec_init(struct mlx5_core_dev *mdev);
-- 
2.25.3

