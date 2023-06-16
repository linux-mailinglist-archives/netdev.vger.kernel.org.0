Return-Path: <netdev+bounces-11572-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A00A0733A4E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8FEB1C20BA5
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FD51F92B;
	Fri, 16 Jun 2023 20:01:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699781F171
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C454CC433C9;
	Fri, 16 Jun 2023 20:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945684;
	bh=tk8mSySx/+N6xAYpD6RSNaRIKBshA/59xYwo2wGVXPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HF5S001MLTFX25RFzXr0nJ2JvmWcWpd95c6/iU2LiBEEJ0agmsalFCwTVhliDBGKE
	 LY+LYyyZFEBbiqyanN10P/kvVE/vzoiQ57brYPuggsYAUmdz34P+kNZ2wHu7tp9sEz
	 /QVnngSM4xCO7NpO/dfzlfMHsw8+UYWkr8Da82Ca8WCt9mNxFUPbmXiTnyDpcJwNHX
	 fFlnC5aD2tWH3yp5birRNLbOLebXlfU6xz1j+I9j6vEvbx4np7vyvBJx3Twdfr4uEg
	 rz/2Cu8U4eLase0P110QWSA3DYd2/McSox56e2VVm/vIxCNZe2THogQyIkX6WExcia
	 7Dl6lvLvi0gWg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [net 02/12] net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ
Date: Fri, 16 Jun 2023 13:01:09 -0700
Message-Id: <20230616200119.44163-3-saeed@kernel.org>
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

From: Maxim Mikityanskiy <maxtram95@gmail.com>

The cited commit missed setting napi_id on XSK RQs, it only affected
regular RQs. Add the missing part to support socket busy polling on XSK
RQs.

Fixes: a2740f529da2 ("net/mlx5e: xsk: Set napi_id to support busy polling")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index ed279f450976..36826b582484 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -86,7 +86,7 @@ static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
 	if (err)
 		return err;
 
-	return  xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, 0);
+	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, c->napi.napi_id);
 }
 
 static int mlx5e_open_xsk_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-- 
2.40.1


