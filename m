Return-Path: <netdev+bounces-4539-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5675570D346
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25F7F1C20C12
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BC841C759;
	Tue, 23 May 2023 05:42:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD48A1C74E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A67C433EF;
	Tue, 23 May 2023 05:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820577;
	bh=871i7EDFk6b+f5Q1npWHpS3RSeVI13PuWwYuXi38Q1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6PJkSSG824B9Ue9ENhePmyc9iJezCvzc3fRjPHmE6mvRxnvndR2wEJreg8QHT7Hi
	 v5xj896fDKwD7qVRWV9BG+IZlyhjx46RqHh2XMJ4U6/HEUls8ggGf9Mllnc2T2ZB9a
	 473ncUHXqrGDwawz4E3c5LpknNyNDekysJCVMGKNHTRyCaHZcTdo+B4jF5pL+2IKo/
	 MF/7dgP14u+CUO6LGeGWMkeBB1iWyWcR4Q8WZfSZEe7cpbSH++DHQcUS1kXxPywYQV
	 cEG1uA78z0+94O8aO//y1+tlL6wC9KecPJuPHpzMi+4rxwZBnbHb3iPrRtgscJE2Zv
	 gVIJU5sitcLCA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net 05/15] net/mlx5e: Use correct encap attribute during invalidation
Date: Mon, 22 May 2023 22:42:32 -0700
Message-Id: <20230523054242.21596-6-saeed@kernel.org>
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

From: Vlad Buslov <vladbu@nvidia.com>

With introduction of post action infrastructure most of the users of encap
attribute had been modified in order to obtain the correct attribute by
calling mlx5e_tc_get_encap_attr() helper instead of assuming encap action
is always on default attribute. However, the cited commit didn't modify
mlx5e_invalidate_encap() which prevents it from destroying correct modify
header action which leads to a warning [0]. Fix the issue by using correct
attribute.

[0]:

Feb 21 09:47:35 c-237-177-40-045 kernel: WARNING: CPU: 17 PID: 654 at drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:684 mlx5e_tc_attach_mod_hdr+0x1cc/0x230 [mlx5_core]
Feb 21 09:47:35 c-237-177-40-045 kernel: RIP: 0010:mlx5e_tc_attach_mod_hdr+0x1cc/0x230 [mlx5_core]
Feb 21 09:47:35 c-237-177-40-045 kernel: Call Trace:
Feb 21 09:47:35 c-237-177-40-045 kernel:  <TASK>
Feb 21 09:47:35 c-237-177-40-045 kernel:  mlx5e_tc_fib_event_work+0x8e3/0x1f60 [mlx5_core]
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? mlx5e_take_all_encap_flows+0xe0/0xe0 [mlx5_core]
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? lock_downgrade+0x6d0/0x6d0
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? lockdep_hardirqs_on_prepare+0x273/0x3f0
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? lockdep_hardirqs_on_prepare+0x273/0x3f0
Feb 21 09:47:35 c-237-177-40-045 kernel:  process_one_work+0x7c2/0x1310
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? lockdep_hardirqs_on_prepare+0x3f0/0x3f0
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? pwq_dec_nr_in_flight+0x230/0x230
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? rwlock_bug.part.0+0x90/0x90
Feb 21 09:47:35 c-237-177-40-045 kernel:  worker_thread+0x59d/0xec0
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? __kthread_parkme+0xd9/0x1d0

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 20c2d2ecaf93..6a052c6cfc15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1369,11 +1369,13 @@ static void mlx5e_invalidate_encap(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow *flow;
 
 	list_for_each_entry(flow, encap_flows, tmp_list) {
-		struct mlx5_flow_attr *attr = flow->attr;
 		struct mlx5_esw_flow_attr *esw_attr;
+		struct mlx5_flow_attr *attr;
 
 		if (!mlx5e_is_offloaded_flow(flow))
 			continue;
+
+		attr = mlx5e_tc_get_encap_attr(flow);
 		esw_attr = attr->esw_attr;
 
 		if (flow_flag_test(flow, SLOW))
-- 
2.40.1


