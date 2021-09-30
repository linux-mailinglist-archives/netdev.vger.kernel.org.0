Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED1D41E4AF
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349802AbhI3XWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236819AbhI3XWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E648361A3D;
        Thu, 30 Sep 2021 23:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044055;
        bh=TSuNhyLgFhb5tRd6bVBXZhJTVZ6HUvoYXdi4Tklg/+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lI1gV6v4qK8fd9dyDNgWstSp8sxrBoqpRWBSjqg5DosKjXNACvc5gtgCRVoPedbbw
         hAos4uKnYDJtmBxpxqlxBqLSoILLaOathYZVh1tV2Abcpbi1H5uq0Zr3QAUpBJn8GD
         D74O8kwhr++DS8cJ3xWq29dSVxwJ+FbpoIPdcTSrqZjB7qcwc755glGh1U/ySJcGIA
         B+UpTHLUiRFZLlOX5+cKdai9rY6zMakACAEgCunUiBUGhXvgdyYaHlr/z7WYx0OyjC
         L/Ibz6K1eQTtfA5BRiUkfhLiwFmlR85uOFGIqV5elZzJMb8DlE65LC9DQeqRhq/6YE
         stwJP44epUo/Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Yuval Avnery <yuvalav@mellanox.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5: DR, Add missing query for vport 0
Date:   Thu, 30 Sep 2021 16:20:38 -0700
Message-Id: <20210930232050.41779-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Currently, vport 0 capabilities are not set.
To fix this, we now querying both eswitch manager and vport 0.
Eswitch manager has an access to all the vports - for eswitch manager PF, all
vports can be referred as other vports. The exception is embedded CPU mode,
where there is vport 0 of ECPF and the PF vport 0.

Here is how vport are queried:

For Connect-X5/6:
    PF vport (0) and vports 1..n: vport number, other = true
    esw_manager is vport 0 (PF)
For BlueField (in embedded CPU mode):
    ECPF vport: vport = 0, other = false
    PF vport (0) and 1..n: vport number, other = true
    esw_manager = vport 0 (ECPF)

Also, note that there's no need for other_vport function parameter
in dr_domain_query_vport - this value is now deduced locally in the
function.

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      |  2 +
 .../mellanox/mlx5/core/steering/dr_domain.c   | 37 +++++++++++++------
 .../mellanox/mlx5/core/steering/dr_types.h    |  5 +++
 3 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 0f69321b3269..1d8febed0d76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -195,6 +195,8 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 
 	caps->roce_min_src_udp = MLX5_CAP_ROCE(mdev, r_roce_min_src_udp_port);
 
+	caps->is_ecpf = mlx5_core_is_ecpf_esw_manager(mdev);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 73646322c7bc..b61c5a8ba305 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -125,17 +125,21 @@ static void dr_domain_uninit_resources(struct mlx5dr_domain *dmn)
 }
 
 static int dr_domain_query_vport(struct mlx5dr_domain *dmn,
-				 bool other_vport,
-				 u16 vport_number)
+				 u16 vport_number,
+				 struct mlx5dr_cmd_vport_cap *vport_caps)
 {
-	struct mlx5dr_cmd_vport_cap *vport_caps;
+	u16 cmd_vport = vport_number;
+	bool other_vport = true;
 	int ret;
 
-	vport_caps = &dmn->info.caps.vports_caps[vport_number];
+	if (dmn->info.caps.is_ecpf && vport_number == MLX5_VPORT_ECPF) {
+		other_vport = false;
+		cmd_vport = 0;
+	}
 
 	ret = mlx5dr_cmd_query_esw_vport_context(dmn->mdev,
 						 other_vport,
-						 vport_number,
+						 cmd_vport,
 						 &vport_caps->icm_address_rx,
 						 &vport_caps->icm_address_tx);
 	if (ret)
@@ -143,7 +147,7 @@ static int dr_domain_query_vport(struct mlx5dr_domain *dmn,
 
 	ret = mlx5dr_cmd_query_gvmi(dmn->mdev,
 				    other_vport,
-				    vport_number,
+				    cmd_vport,
 				    &vport_caps->vport_gvmi);
 	if (ret)
 		return ret;
@@ -154,6 +158,13 @@ static int dr_domain_query_vport(struct mlx5dr_domain *dmn,
 	return 0;
 }
 
+static int dr_domain_query_esw_mngr(struct mlx5dr_domain *dmn)
+{
+	return dr_domain_query_vport(dmn,
+				     dmn->info.caps.is_ecpf ? MLX5_VPORT_ECPF : 0,
+				     &dmn->info.caps.esw_manager_vport_caps);
+}
+
 static int dr_domain_query_vports(struct mlx5dr_domain *dmn)
 {
 	struct mlx5dr_esw_caps *esw_caps = &dmn->info.caps.esw_caps;
@@ -161,9 +172,15 @@ static int dr_domain_query_vports(struct mlx5dr_domain *dmn)
 	int vport;
 	int ret;
 
+	ret = dr_domain_query_esw_mngr(dmn);
+	if (ret)
+		return ret;
+
 	/* Query vports (except wire vport) */
 	for (vport = 0; vport < dmn->info.caps.num_esw_ports - 1; vport++) {
-		ret = dr_domain_query_vport(dmn, !!vport, vport);
+		ret = dr_domain_query_vport(dmn,
+					    vport,
+					    &dmn->info.caps.vports_caps[vport]);
 		if (ret)
 			return ret;
 	}
@@ -267,11 +284,7 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 
 		dmn->info.rx.type = DR_DOMAIN_NIC_TYPE_RX;
 		dmn->info.tx.type = DR_DOMAIN_NIC_TYPE_TX;
-		vport_cap = mlx5dr_get_vport_cap(&dmn->info.caps, 0);
-		if (!vport_cap) {
-			mlx5dr_err(dmn, "Failed to get esw manager vport\n");
-			return -ENOENT;
-		}
+		vport_cap = &dmn->info.caps.esw_manager_vport_caps;
 
 		dmn->info.supp_sw_steering = true;
 		dmn->info.tx.default_icm_addr = vport_cap->icm_address_tx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 8e171a6d3a9d..4bf8156f0a87 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -797,8 +797,10 @@ struct mlx5dr_cmd_caps {
 	u32 num_vports;
 	struct mlx5dr_esw_caps esw_caps;
 	struct mlx5dr_cmd_vport_cap *vports_caps;
+	struct mlx5dr_cmd_vport_cap esw_manager_vport_caps;
 	bool prio_tag_required;
 	struct mlx5dr_roce_cap roce_caps;
+	u8 is_ecpf:1;
 	u8 isolate_vl_tc:1;
 };
 
@@ -1104,6 +1106,9 @@ mlx5dr_ste_htbl_may_grow(struct mlx5dr_ste_htbl *htbl)
 static inline struct mlx5dr_cmd_vport_cap *
 mlx5dr_get_vport_cap(struct mlx5dr_cmd_caps *caps, u16 vport)
 {
+	if (caps->is_ecpf && vport == MLX5_VPORT_ECPF)
+		return &caps->esw_manager_vport_caps;
+
 	if (!caps->vports_caps ||
 	    (vport >= caps->num_vports && vport != MLX5_VPORT_UPLINK))
 		return NULL;
-- 
2.31.1

