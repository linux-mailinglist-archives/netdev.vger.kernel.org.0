Return-Path: <netdev+bounces-4545-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0666470D34D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDFDE281283
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386801C742;
	Tue, 23 May 2023 05:43:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E331C777
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FECBC433A1;
	Tue, 23 May 2023 05:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820584;
	bh=OHIgRxtNzK+nrXuDvVWLnj4mb0XoeJAxAMFTznsH1Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZ8+XxnLxRbc/O7u9QA69sitrRKzbDhK03PKVbBNriQZGPEDWi2i0V+5aWLtEr2xo
	 rKvO3+IHE7sUX3cD3c7cpoifwKUtkN32e0B8xv7uWU+qFiPiYbussDpwV2/kKdzmaQ
	 2IfLTlD7LUWnMErLzxNAGWR6WNoc1aOdukKpbaePU9SEortvTOQFTF/bSWMU29acbD
	 9ve5O22cCTlrhnSzqBD3ipU9A4JDGsTv7eRuWmXPoJ5FShy8eP6ZYdnppnlKQvKfnV
	 mLADq4djX7rClFB6MVti+YAXEXq+noWdIywdaNh/uB+WzZQ6/Shnf/KRPaor701OjM
	 TBDXwWtU9CNew==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>
Subject: [net 11/15] net/mlx5: Devcom, fix error flow in mlx5_devcom_register_device
Date: Mon, 22 May 2023 22:42:38 -0700
Message-Id: <20230523054242.21596-12-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523054242.21596-1-saeed@kernel.org>
References: <20230523054242.21596-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

In case devcom allocation is failed, mlx5 is always freeing the priv.
However, this priv might have been allocated by a different thread,
and freeing it might lead to use-after-free bugs.
Fix it by freeing the priv only in case it was allocated by the
running thread.

Fixes: fadd59fc50d0 ("net/mlx5: Introduce inter-device communication mechanism")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index 070d55f13419..8f978491dd32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -112,7 +112,8 @@ struct mlx5_devcom *mlx5_devcom_register_device(struct mlx5_core_dev *dev)
 	priv->devs[idx] = dev;
 	devcom = mlx5_devcom_alloc(priv, idx);
 	if (!devcom) {
-		kfree(priv);
+		if (new_priv)
+			kfree(priv);
 		return ERR_PTR(-ENOMEM);
 	}
 
-- 
2.40.1


