Return-Path: <netdev+bounces-11581-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F6CE733A5D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAE7A28186D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F21209B6;
	Fri, 16 Jun 2023 20:01:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5542A1ED44
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03790C433AD;
	Fri, 16 Jun 2023 20:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945697;
	bh=tRyVt2i3Z8UO/jT+gk1qMPTLnbOxDDQNoI6BQ1TUluo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7DNszpFVMJVTtZ+/+hcyCqJFFuy6n7k9zzAeCBOLTKvm3E0tRbjMI3KwBZoqB9mF
	 RbnH4qZn2F62E3L1QoCDWWR8U2Bao5KsY2jbuNYoTMf0o8Q7MdKBgXrC37CuDr6Iz9
	 BAQv8jsiTgoWs6/rWSlKEZObDi+t0ONzT0a9kQCCoAZF56o+LhWrjDcqyFJ38SVQyV
	 H55a9b08WgIoeHJM/QjI5rAGRz5r3mdb4loUeYP8bBhfMqtc+iaK3KgW5wrEVPUBjW
	 V5QP9925z3SzXl/Ii05G0CnMD5qrOR5tRLKTDk1wozfDRtDwq2Swfoy3mhYRLBiQqC
	 m14wlitJMxCyQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [net 12/12] net/mlx5e: Fix scheduling of IPsec ASO query while in atomic
Date: Fri, 16 Jun 2023 13:01:19 -0700
Message-Id: <20230616200119.44163-13-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616200119.44163-1-saeed@kernel.org>
References: <20230616200119.44163-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

ASO query can be scheduled in atomic context as such it can't use usleep.
Use udelay as recommended in Documentation/timers/timers-howto.rst.

Fixes: 76e463f6508b ("net/mlx5e: Overcome slow response for first IPsec ASO WQE")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c   | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index ca16cb9807ea..a3554bde3e07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -606,7 +606,8 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 	do {
 		ret = mlx5_aso_poll_cq(aso->aso, false);
 		if (ret)
-			usleep_range(2, 10);
+			/* We are in atomic context */
+			udelay(10);
 	} while (ret && time_is_after_jiffies(expires));
 	spin_unlock_bh(&aso->lock);
 	return ret;
-- 
2.40.1


