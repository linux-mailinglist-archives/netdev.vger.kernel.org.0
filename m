Return-Path: <netdev+bounces-3981-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6721C709EAA
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FB651C212BB
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD2B13AF6;
	Fri, 19 May 2023 17:56:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4D613ACF
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7A5C433D2;
	Fri, 19 May 2023 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518977;
	bh=fufz/CzqMaOjpRpZawicoQQjBelG84c+MIxUnuVsW0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPVxtvHijggcLbsVogSx97+xONUY7kDv5/SlYEq6t+LX1PlEKmxblg6ixCcIffaZs
	 V6C0lMx6iu53UK2qwuos/7GCY5pkpn7FaiAwn6/6dX/X1xal2WorKoxhJn+Rv4kIDO
	 B2Zwe1t5BGLVPKUwTAiNlDbXPU7sJTgaU6mAnAKWDrDBymBPA3zq4aUp7x4wjDX1mR
	 vxBl0oieH2Bva6iAo0A4oMgq2JleCa40a2AsbwT0LXZ381XDTfY/yVQPNrIiU/5ktg
	 hdeUaBg4OXdeW/3wtG8CwiYzSBwRKWre8Zf+JLzwvDOSK8pAHU5YQMzTerBt7iPYh7
	 s4j/vZajZCmKQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: E-Switch, Check device is PF when stopping esw offloads
Date: Fri, 19 May 2023 10:55:51 -0700
Message-Id: <20230519175557.15683-10-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

Checking sriov is done on the pci device so it can return true
on other devices like SF but nothing should be done in this case.
Add a check that the device is PF.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 66a522d08be1..44b5d1359155 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3301,7 +3301,7 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 	/* If changing from switchdev to legacy mode without sriov enabled,
 	 * no need to create legacy fdb.
 	 */
-	if (!mlx5_sriov_is_enabled(esw->dev))
+	if (!mlx5_core_is_pf(esw->dev) || !mlx5_sriov_is_enabled(esw->dev))
 		return 0;
 
 	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
-- 
2.40.1


