Return-Path: <netdev+bounces-4548-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E8770D350
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:47:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 702A4280FF0
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B811DDF7;
	Tue, 23 May 2023 05:43:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7F01DDEC
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF09CC433A1;
	Tue, 23 May 2023 05:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820589;
	bh=aBoufnckibANK28ILhcdoyTBx3pi0Ka2kNIt3K1kuv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhimUi0mkuJnCzDkIAgCJ6lK3Z1uu034NezTYbFWHkAEWC7GbwiPbYhuNKt4yKw5p
	 B9oH5FXe3qfaZFsah78MTI/yVfOsIFZPA9NpyGxBxfaRRuN/bHy9XNwmOIuHRj1wht
	 OcghyVebtP3OyjbCEjFIadQsMcRp0RZjninVTswqvH35wMOD4su+MIrM1a6AtiGvI3
	 bjYlSQpIohTvgCw00EO1d/V7hk6/siOc2mIKLQFo5p1f5Pjbvhc/lqCmQ/VoH9Phi2
	 4O72pN3LH6DgY3wdLwIS7aM+rucv7p4+XIvXGKP3cWdAhqM5FJoMPAZcmkDmH077py
	 R5Ia0lB1VAsSg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Eli Cohen <elic@nvidia.com>
Subject: [net 14/15] net/mlx5: Fix irq affinity management
Date: Mon, 22 May 2023 22:42:41 -0700
Message-Id: <20230523054242.21596-15-saeed@kernel.org>
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

The cited patch deny the user of changing the affinity of mlx5 irqs,
which break backward compatibility.
Hence, allow the user to change the affinity of mlx5 irqs.

Fixes: bbac70c74183 ("net/mlx5: Use newer affinity descriptor")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index ac1304c2d205..86b528aae6d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -567,7 +567,7 @@ int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
 	struct mlx5_irq *irq;
 	int i;
 
-	af_desc.is_managed = 1;
+	af_desc.is_managed = false;
 	for (i = 0; i < nirqs; i++) {
 		cpumask_set_cpu(cpus[i], &af_desc.mask);
 		irq = mlx5_irq_request(dev, i + 1, &af_desc, rmap);
-- 
2.40.1


