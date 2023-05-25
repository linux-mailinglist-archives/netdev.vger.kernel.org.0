Return-Path: <netdev+bounces-5213-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01052710385
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F0011C20E7E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DA1DA951;
	Thu, 25 May 2023 03:49:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BE3BA5F
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED0EC433AA;
	Thu, 25 May 2023 03:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986561;
	bh=7dBZHjGA0Mc43JOeGq1YxEAG+OrU5x1gWpqfTMRO234=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdezeLmttq61d8PfTnWCXkxyNF+of+xRAJET3bP79u4GvndP2UVVrxfq4moycvzZk
	 0DG7jCcXyGvI0s2IRTiK2qtVlTRCOJshJ+NmxnojrKvutsw4Yg/hlRmOQ8W1Ku2+Xg
	 Jhd5UDVMbdtEDJf6jSTkqyqrMkptnqXYsCIAg0Rfo8qkkSd1bUvbNErISGSn4eJwQX
	 std9PiCqSl2RnJrqxNuPk1TlSPkNibJMf4TNuYgGlopySt4UkZXlI4IyrPxZmC7Mhu
	 x2fEwnMnBHN5kJCwAWSfNaG+5LS4rT0sDtgbJ3k9ey7cAgOicLEnkQ7+jC/dm9JGmi
	 cKnPKgA7FNlTg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	kernel test robot <lkp@intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [net 13/17] net/mlx5: Fix check for allocation failure in comp_irqs_request_pci()
Date: Wed, 24 May 2023 20:48:43 -0700
Message-Id: <20230525034847.99268-14-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

This function accidentally dereferences "cpus" instead of returning
directly.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202305200354.KV3jU94w-lkp@intel.com/
Fixes: b48a0f72bc3e ("net/mlx5: Refactor completion irq request/release code")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index fe698c79616c..3db4866d7880 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -824,7 +824,7 @@ static int comp_irqs_request_pci(struct mlx5_core_dev *dev)
 	ncomp_eqs = table->num_comp_eqs;
 	cpus = kcalloc(ncomp_eqs, sizeof(*cpus), GFP_KERNEL);
 	if (!cpus)
-		ret = -ENOMEM;
+		return -ENOMEM;
 
 	i = 0;
 	rcu_read_lock();
-- 
2.40.1


