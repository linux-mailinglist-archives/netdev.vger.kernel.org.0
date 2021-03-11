Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405BC3380B4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhCKWiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:38:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhCKWhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39FA064F91;
        Thu, 11 Mar 2021 22:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502261;
        bh=iRALGk144mG2c5nN2tggwcYtrB8tV017xOgAN0XWtHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOzD4TSqve9gsUT7k9iCecwVD9BMgTy+ZC5YQ9t92uzcvLgrfY3fkU4+M7yARduHb
         KuHgl9OSiDUnbzofdZpfbqY+KCtAwzvHIHDUay1Pdu/Fw/hieS5mz51XiakiPxdl2g
         cCpswJyJHO8l7HyP9ZbtKfQE1BwhNuqzCUvp4pQn/5T270QhnbQPOrW5vc5swW3rcW
         jBgIB2vC5CBRRnwwGirz3I8FE7vE8JMdHvhIZ5x02PryABz17HTeT78WQVq8YTZ4Vr
         /KKiK4yNcrZUhTX4mQixTdQpQUgEeBsnrAfDAi44fIwgA6uSCRt3sHRYu5a3ztOugw
         fNOFw1fgIak9A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Alloc flow spec using kvzalloc instead of kzalloc
Date:   Thu, 11 Mar 2021 14:37:23 -0800
Message-Id: <20210311223723.361301-16-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

flow spec is not small and we do allocate it using kvzalloc
in most places of the driver. fix rest of the places
to use kvzalloc to avoid failure in allocation when
memory is too fragmented.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 14 +++++++-------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  4 ++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index f81da2dc6af1..3a6095c912f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -695,7 +695,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 
 	zone_rule->nat = nat;
 
-	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec)
 		return -ENOMEM;
 
@@ -737,7 +737,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 
 	zone_rule->attr = attr;
 
-	kfree(spec);
+	kvfree(spec);
 	ct_dbg("Offloaded ct entry rule in zone %d", entry->tuple.zone);
 
 	return 0;
@@ -749,7 +749,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 err_mod_hdr:
 	kfree(attr);
 err_attr:
-	kfree(spec);
+	kvfree(spec);
 	return err;
 }
 
@@ -1684,10 +1684,10 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_ct_ft *ft;
 	u32 fte_id = 1;
 
-	post_ct_spec = kzalloc(sizeof(*post_ct_spec), GFP_KERNEL);
+	post_ct_spec = kvzalloc(sizeof(*post_ct_spec), GFP_KERNEL);
 	ct_flow = kzalloc(sizeof(*ct_flow), GFP_KERNEL);
 	if (!post_ct_spec || !ct_flow) {
-		kfree(post_ct_spec);
+		kvfree(post_ct_spec);
 		kfree(ct_flow);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1822,7 +1822,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 
 	attr->ct_attr.ct_flow = ct_flow;
 	dealloc_mod_hdr_actions(&pre_mod_acts);
-	kfree(post_ct_spec);
+	kvfree(post_ct_spec);
 
 	return rule;
 
@@ -1843,7 +1843,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 err_idr:
 	mlx5_tc_ct_del_ft_cb(ct_priv, ft);
 err_ft:
-	kfree(post_ct_spec);
+	kvfree(post_ct_spec);
 	kfree(ct_flow);
 	netdev_warn(priv->netdev, "Failed to offload ct flow, err %d\n", err);
 	return ERR_PTR(err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 381a9c8c9da9..34119ce92031 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -60,7 +60,7 @@ static int rx_err_add_rule(struct mlx5e_priv *priv,
 	struct mlx5_flow_spec *spec;
 	int err = 0;
 
-	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec)
 		return -ENOMEM;
 
@@ -101,7 +101,7 @@ static int rx_err_add_rule(struct mlx5e_priv *priv,
 	if (err)
 		mlx5_modify_header_dealloc(mdev, modify_hdr);
 out_spec:
-	kfree(spec);
+	kvfree(spec);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 703753ac2e02..a215ccee3e61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1446,7 +1446,7 @@ esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 	if (!mlx5_eswitch_reg_c1_loopback_supported(esw))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec)
 		return ERR_PTR(-ENOMEM);
 
@@ -1469,7 +1469,7 @@ esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 	dest.ft = esw->offloads.ft_offloads;
 
 	flow_rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
-	kfree(spec);
+	kvfree(spec);
 
 	if (IS_ERR(flow_rule))
 		esw_warn(esw->dev,
-- 
2.29.2

