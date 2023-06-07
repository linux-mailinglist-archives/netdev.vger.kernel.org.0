Return-Path: <netdev+bounces-9077-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A1B72704A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:08:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51444280E60
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395D251816;
	Wed,  7 Jun 2023 21:04:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67615180F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70551C4339C;
	Wed,  7 Jun 2023 21:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686171883;
	bh=r89Xj2j+5/zrHv2pqibN65frjLskJnt4a9WgjDPNKDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7DaN0CvS0ncksR+5THjtKZLsZ3Z5xlFcmVgA8++lJGHH6gXdwYnxXp9MTA0qMWFZ
	 vvNMr76k57+BUtlMpT2HFsL1Mso99cBiepC/E3B/PPlIvUIqmVUObfEKUOQwlgwH7G
	 HtrKpwxOVAqFeCbRfDobMZZG7hTcpLzhEoUztGwTeXEqnYqHQiyI9+rKa3giuhhUjf
	 U0s49n3OktGs1n+A2tou3VsFMvrSSVWOp77vmdZUk6fuEsa8UUiF/RdJJCZzN0AgD5
	 jIkA/FMaZZH7HoU3/y+WWh6iWcW1+y196Qx0dRcRF4MJbBW3BHespdOIL5InUSCjxL
	 86drI60THiCdg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Bodong Wang <bodong@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Subject: [net-next V2 13/14] mlx5/core: E-Switch, Allocate ECPF vport if it's an eswitch manager
Date: Wed,  7 Jun 2023 14:04:09 -0700
Message-Id: <20230607210410.88209-14-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607210410.88209-1-saeed@kernel.org>
References: <20230607210410.88209-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bodong Wang <bodong@nvidia.com>

Eswitch vport is needed for eswitch manager when creating LAG,
to create egress rules. However, this was not handled when ECPF is
an eswitch manager.

Signed-off-by: Bodong Wang <bodong@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 31956cd9d1bb..ecd8864d5d11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1601,7 +1601,8 @@ static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 		idx++;
 	}
 
-	if (mlx5_ecpf_vport_exists(dev)) {
+	if (mlx5_ecpf_vport_exists(dev) ||
+	    mlx5_core_is_ecpf_esw_manager(dev)) {
 		err = mlx5_esw_vport_alloc(esw, idx, MLX5_VPORT_ECPF);
 		if (err)
 			goto err;
-- 
2.40.1


