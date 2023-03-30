Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B707A6CFDAA
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjC3IDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjC3IDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:03:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEFC76A6
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:03:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F90961F15
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D6BC433EF;
        Thu, 30 Mar 2023 08:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680163399;
        bh=+88X3lmrhIPV77V6GZO5db66ySEEd6tgSIWB0Iuq0o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgPen6+Mqqfg4l4UIdA4iGO3H9ZbdXNQNbOvuBRWcxTYSnPjwtIUhEiTxWkh3PygK
         DrlQSNrM9xBq7WSABBHtrrjj//eELuYydf7vuZRwzGl84TJU7HqMAIlYJhYUA5Cc0I
         S3RE9gLZKCsh+O3G086mKaq/D6ANXK81yqplVrAzjLV3r/e8napm1FEBpEhCkW59UY
         qENgEe3ZTFcCt/FsHCEreQ/FOPP65H2Q0+DhzcI53a0vxliIjiZpFLzNI1njff1dCc
         cvMjvuhweGyD02ZQTfgwPiy81lh/n9vAD85XQ7gSCS752Gm0b+v3EE3uZp5tQR/ZbA
         EuSJVP6+bJ0bw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next 10/10] net/mlx5e: Simulate missing IPsec TX limits hardware functionality
Date:   Thu, 30 Mar 2023 11:02:31 +0300
Message-Id: <94a5d82c0c399747117d8a558f9beebfbcf26154.1680162300.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680162300.git.leonro@nvidia.com>
References: <cover.1680162300.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

ConnectX-7 devices don't have ability to send TX hard/soft limits
events. As a possible workaround, let's rely on existing infrastructure
and use periodic check of cached flow counter. In these periodic checks,
we call to xfrm_state_check_expire() to check and mark state accordingly.

Once the state is marked as XFRM_STATE_EXPIRED, the SA flow rule is
changed to drop all the traffic.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 65 ++++++++++++++++++-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  8 +++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 31 +++++++--
 3 files changed, 99 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 89d5802888a9..bb5e9f5b904e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -40,6 +40,8 @@
 #include "ipsec.h"
 #include "ipsec_rxtx.h"
 
+#define MLX5_IPSEC_RESCHED msecs_to_jiffies(1000)
+
 static struct mlx5e_ipsec_sa_entry *to_ipsec_sa_entry(struct xfrm_state *x)
 {
 	return (struct mlx5e_ipsec_sa_entry *)x->xso.offload_handle;
@@ -50,6 +52,28 @@ static struct mlx5e_ipsec_pol_entry *to_ipsec_pol_entry(struct xfrm_policy *x)
 	return (struct mlx5e_ipsec_pol_entry *)x->xdo.offload_handle;
 }
 
+static void mlx5e_ipsec_handle_tx_limit(struct work_struct *_work)
+{
+	struct mlx5e_ipsec_dwork *dwork =
+		container_of(_work, struct mlx5e_ipsec_dwork, dwork.work);
+	struct mlx5e_ipsec_sa_entry *sa_entry = dwork->sa_entry;
+	struct xfrm_state *x = sa_entry->x;
+
+	spin_lock(&x->lock);
+	xfrm_state_check_expire(x);
+	if (x->km.state == XFRM_STATE_EXPIRED) {
+		sa_entry->attrs.drop = true;
+		mlx5e_accel_ipsec_fs_modify(sa_entry);
+	}
+	spin_unlock(&x->lock);
+
+	if (sa_entry->attrs.drop)
+		return;
+
+	queue_delayed_work(sa_entry->ipsec->wq, &dwork->dwork,
+			   MLX5_IPSEC_RESCHED);
+}
+
 static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct xfrm_state *x = sa_entry->x;
@@ -464,6 +488,31 @@ static int mlx5_ipsec_create_work(struct mlx5e_ipsec_sa_entry *sa_entry)
 	return 0;
 }
 
+static int mlx5e_ipsec_create_dwork(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	struct xfrm_state *x = sa_entry->x;
+	struct mlx5e_ipsec_dwork *dwork;
+
+	if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
+		return 0;
+
+	if (x->xso.dir != XFRM_DEV_OFFLOAD_OUT)
+		return 0;
+
+	if (x->lft.soft_packet_limit == XFRM_INF &&
+	    x->lft.hard_packet_limit == XFRM_INF)
+		return 0;
+
+	dwork = kzalloc(sizeof(*dwork), GFP_KERNEL);
+	if (!dwork)
+		return -ENOMEM;
+
+	dwork->sa_entry = sa_entry;
+	INIT_DELAYED_WORK(&dwork->dwork, mlx5e_ipsec_handle_tx_limit);
+	sa_entry->dwork = dwork;
+	return 0;
+}
+
 static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 				struct netlink_ext_ack *extack)
 {
@@ -504,10 +553,14 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	if (err)
 		goto err_xfrm;
 
+	err = mlx5e_ipsec_create_dwork(sa_entry);
+	if (err)
+		goto release_work;
+
 	/* create hw context */
 	err = mlx5_ipsec_create_sa_ctx(sa_entry);
 	if (err)
-		goto release_work;
+		goto release_dwork;
 
 	err = mlx5e_accel_ipsec_fs_add_rule(sa_entry);
 	if (err)
@@ -523,6 +576,10 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 		goto err_add_rule;
 
 	mlx5e_ipsec_set_esn_ops(sa_entry);
+
+	if (sa_entry->dwork)
+		queue_delayed_work(ipsec->wq, &sa_entry->dwork->dwork,
+				   MLX5_IPSEC_RESCHED);
 out:
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	return 0;
@@ -531,6 +588,8 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
 err_hw_ctx:
 	mlx5_ipsec_free_sa_ctx(sa_entry);
+release_dwork:
+	kfree(sa_entry->dwork);
 release_work:
 	kfree(sa_entry->work);
 err_xfrm:
@@ -562,8 +621,12 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	if (sa_entry->work)
 		cancel_work_sync(&sa_entry->work->work);
 
+	if (sa_entry->dwork)
+		cancel_delayed_work_sync(&sa_entry->dwork->dwork);
+
 	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
 	mlx5_ipsec_free_sa_ctx(sa_entry);
+	kfree(sa_entry->dwork);
 	kfree(sa_entry->work);
 sa_entry_free:
 	kfree(sa_entry);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index ab48fb9b4698..52890d7dce6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -93,6 +93,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 	struct upspec upspec;
 	u8 dir : 2;
 	u8 type : 2;
+	u8 drop : 1;
 	u8 family;
 	struct mlx5_replay_esn replay_esn;
 	u32 authsize;
@@ -140,6 +141,11 @@ struct mlx5e_ipsec_work {
 	void *data;
 };
 
+struct mlx5e_ipsec_dwork {
+	struct delayed_work dwork;
+	struct mlx5e_ipsec_sa_entry *sa_entry;
+};
+
 struct mlx5e_ipsec_aso {
 	u8 __aligned(64) ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
 	dma_addr_t dma_addr;
@@ -193,6 +199,7 @@ struct mlx5e_ipsec_sa_entry {
 	u32 enc_key_id;
 	struct mlx5e_ipsec_rule ipsec_rule;
 	struct mlx5e_ipsec_work *work;
+	struct mlx5e_ipsec_dwork *dwork;
 	struct mlx5e_ipsec_limits limits;
 };
 
@@ -235,6 +242,7 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry);
 void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry);
 int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
 void mlx5e_accel_ipsec_fs_del_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
+void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry);
 
 int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
 void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 0539640a4d88..b47794d4146e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -926,9 +926,12 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
-	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			   MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
+	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
 			   MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	if (attrs->drop)
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
+	else
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[0].ft = rx->ft.status;
 	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
@@ -1018,9 +1021,13 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
-	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			   MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT |
+	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT |
 			   MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	if (attrs->drop)
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
+	else
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+
 	dest[0].ft = tx->ft.status;
 	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
@@ -1430,3 +1437,19 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 	kfree(ipsec->tx);
 	return err;
 }
+
+void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	struct mlx5e_ipsec_sa_entry sa_entry_shadow = {};
+	int err;
+
+	memcpy(&sa_entry_shadow, sa_entry, sizeof(*sa_entry));
+	memset(&sa_entry_shadow.ipsec_rule, 0x00, sizeof(sa_entry->ipsec_rule));
+
+	err = mlx5e_accel_ipsec_fs_add_rule(&sa_entry_shadow);
+	if (err)
+		return;
+
+	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
+	memcpy(sa_entry, &sa_entry_shadow, sizeof(*sa_entry));
+}
-- 
2.39.2

