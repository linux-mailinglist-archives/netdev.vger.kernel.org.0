Return-Path: <netdev+bounces-4535-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A7A70D33E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 121301C20C20
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213E41B90A;
	Tue, 23 May 2023 05:42:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45011B8FB
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522CEC433D2;
	Tue, 23 May 2023 05:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820573;
	bh=Xmmck3pjuqH/xGIlsZmDzwm296kW5zNTXc+J06C6pfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWrcU8TVnv0AJADYrUlv29zc4XNjhvgXGYRod1TbI6L7Umdk3JGAcN5N3nWiEz1ul
	 nR+QeifgjdAPVksaG+sdHcTHH3zqFShvkZ5HJmdITMXQVe27xCXIICTPSGo3usBiJh
	 w9Y6rXy7KU2tABne3/6XnpSuPWEu5vt/uA2beila2d4q0JTr2xT5ziPFLWL/fp3NsC
	 M3YVp4eDhMILAXpVKQ+mk5Sra5CqhJ8Nd0Y78L/DxQ5b5VCHdN19XlaTv89vta+esJ
	 bnps8Fz8JY42LRohn3b6ATZ6fjEEGDtPnMday1h/XAsVOunxbdQwGaRn58Fp3/IqfL
	 mpNRcEYfxUqSA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>
Subject: [net 01/15] net/mlx5: Collect command failures data only for known commands
Date: Mon, 22 May 2023 22:42:28 -0700
Message-Id: <20230523054242.21596-2-saeed@kernel.org>
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

DEVX can issue a general command, which is not used by mlx5 driver.
In case such command is failed, mlx5 is trying to collect the failure
data, However, mlx5 doesn't create a storage for this command, since
mlx5 doesn't use it. This lead to array-index-out-of-bounds error.

Fix it by checking whether the command is known before collecting the
failure data.

Fixes: 34f46ae0d4b3 ("net/mlx5: Add command failures data to debugfs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index d53de39539a8..d532883b42d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1920,9 +1920,10 @@ static void mlx5_cmd_err_trace(struct mlx5_core_dev *dev, u16 opcode, u16 op_mod
 static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status,
 			   u32 syndrome, int err)
 {
+	const char *namep = mlx5_command_str(opcode);
 	struct mlx5_cmd_stats *stats;
 
-	if (!err)
+	if (!err || !(strcmp(namep, "unknown command opcode")))
 		return;
 
 	stats = &dev->cmd.stats[opcode];
-- 
2.40.1


