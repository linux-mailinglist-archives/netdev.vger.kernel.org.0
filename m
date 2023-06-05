Return-Path: <netdev+bounces-7901-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7234572209E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:10:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AADD28120A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74C011CBE;
	Mon,  5 Jun 2023 08:10:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371FC134A2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D733C433A0;
	Mon,  5 Jun 2023 08:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685952607;
	bh=bsooJ5RgTpZcnA2L4UR5mgAxrPXuxO31pOqhb7t/CdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6pWaOB1L+fOvDVBdkizrqwKpZtu80JKPiYh+rn7zCRgZGIuAddeJvQZ4Np6kBnza
	 G7ngEHb3HTYcloy7QtVSTZ4ukbHa8ggYZaR9ry6xpriGXyIwSGTKutlw8XO8xMy99d
	 DDzdUyQrud5jZNic0DEBk6aIOhhpxhr0DoAIgLq7CCwHM6dkyg0korQlDrJ3Bo+7BM
	 bF84JiVlmxJ50b0VLtvEhSBmeVgvaWaaCKN0UnMnHmidersBWhf2ThIJ6c49M1uN8d
	 19K3yhP9k/JDZH3wLJgQAmJYpGU/fyuDMv6NggRCYqeASytAYZzNp6CcXjdyIGjfeQ
	 2N/kmEIzxxn2g==
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Raed Salem <raeds@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net 4/4] net/mlx5e: Fix scheduling of IPsec ASO query while in atomic
Date: Mon,  5 Jun 2023 11:09:52 +0300
Message-Id: <633cd2b3f23ca9d759781ca1a316f728b001ecd6.1685950599.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685950599.git.leonro@nvidia.com>
References: <cover.1685950599.git.leonro@nvidia.com>
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


