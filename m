Return-Path: <netdev+bounces-7899-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A29A722099
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:10:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E5901C20B84
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3057911CBA;
	Mon,  5 Jun 2023 08:10:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DB4125A5
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3C1C4339B;
	Mon,  5 Jun 2023 08:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685952600;
	bh=RGySQX9OrcQ7NY6je9/jV14spFpiXpO8lbwi3fA32eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwbkq+KT5Jd6+bf/idKFuN4sGrYptV7hUCUZri3zT0j1OGWgc2VHHSEreKRi4LeL/
	 FOgmR2vGL1id8KRwPOubitg9msPP6TKyQd5//NgVRgIzBITHV0SA1E1wUVW/B5xhpk
	 LAWpRl64zjymsAJtwVTOwaHJchJEKnWg8vJ263BEnHQbwXfy/Fp8mUYWUvDpCBnrQR
	 QnUzbHDYTx5vOOjYc8HhqYexB1fpUwDHeKESh9pqrGtvHFx614iEw2WORLun/Dzao4
	 2IAS8gRPRqNUzJ2LMXXmrSXhkPTstlBY00p5JuPn42K9N3t/TlHM9Z3WqxilMM40kS
	 MyAKCYIVw1u3w==
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Patrisious Haddad <phaddad@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Raed Salem <raeds@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net 2/4] net/mlx5e: Fix ESN update kernel panic
Date: Mon,  5 Jun 2023 11:09:50 +0300
Message-Id: <acc45e30ff0cf5220a3fda02411d22880878102f.1685950599.git.leonro@nvidia.com>
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

From: Patrisious Haddad <phaddad@nvidia.com>

Previously during mlx5e_ipsec_handle_event the driver tried to execute
an operation that could sleep, while holding a spinlock, which caused
the kernel panic mentioned below.

Move the function call that can sleep outside of the spinlock context.

 Call Trace:
 <TASK>
 dump_stack_lvl+0x49/0x6c
 __schedule_bug.cold+0x42/0x4e
 schedule_debug.constprop.0+0xe0/0x118
 __schedule+0x59/0x58a
 ? __mod_timer+0x2a1/0x3ef
 schedule+0x5e/0xd4
 schedule_timeout+0x99/0x164
 ? __pfx_process_timeout+0x10/0x10
 __wait_for_common+0x90/0x1da
 ? __pfx_schedule_timeout+0x10/0x10
 wait_func+0x34/0x142 [mlx5_core]
 mlx5_cmd_invoke+0x1f3/0x313 [mlx5_core]
 cmd_exec+0x1fe/0x325 [mlx5_core]
 mlx5_cmd_do+0x22/0x50 [mlx5_core]
 mlx5_cmd_exec+0x1c/0x40 [mlx5_core]
 mlx5_modify_ipsec_obj+0xb2/0x17f [mlx5_core]
 mlx5e_ipsec_update_esn_state+0x69/0xf0 [mlx5_core]
 ? wake_affine+0x62/0x1f8
 mlx5e_ipsec_handle_event+0xb1/0xc0 [mlx5_core]
 process_one_work+0x1e2/0x3e6
 ? __pfx_worker_thread+0x10/0x10
 worker_thread+0x54/0x3ad
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xda/0x101
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x29/0x37
 </TASK>
 BUG: workqueue leaked lock or atomic: kworker/u256:4/0x7fffffff/189754#012     last function: mlx5e_ipsec_handle_event [mlx5_core]
 CPU: 66 PID: 189754 Comm: kworker/u256:4 Kdump: loaded Tainted: G        W          6.2.0-2596.20230309201517_5.el8uek.rc1.x86_64 #2
 Hardware name: Oracle Corporation ORACLE SERVER X9-2/ASMMBX9-2, BIOS 61070300 08/17/2022
 Workqueue: mlx5e_ipsec: eth%d mlx5e_ipsec_handle_event [mlx5_core]
 Call Trace:
 <TASK>
 dump_stack_lvl+0x49/0x6c
 process_one_work.cold+0x2b/0x3c
 ? __pfx_worker_thread+0x10/0x10
 worker_thread+0x54/0x3ad
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xda/0x101
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x29/0x37
 </TASK>
 BUG: scheduling while atomic: kworker/u256:4/189754/0x00000000

Fixes: cee137a63431 ("net/mlx5e: Handle ESN update events")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index df90e19066bc..ca16cb9807ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -305,7 +305,17 @@ static void mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry,
 	}
 
 	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &attrs);
+
+	/* It is safe to execute the modify below unlocked since the only flows
+	 * that could affect this HW object, are create, destroy and this work.
+	 *
+	 * Creation flow can't co-exist with this modify work, the destruction
+	 * flow would cancel this work, and this work is a single entity that
+	 * can't conflict with it self.
+	 */
+	spin_unlock_bh(&sa_entry->x->lock);
 	mlx5_accel_esp_modify_xfrm(sa_entry, &attrs);
+	spin_lock_bh(&sa_entry->x->lock);
 
 	data.data_offset_condition_operand =
 		MLX5_IPSEC_ASO_REMOVE_FLOW_PKT_CNT_OFFSET;
@@ -431,7 +441,7 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 	aso = sa_entry->ipsec->aso;
 	attrs = &sa_entry->attrs;
 
-	spin_lock(&sa_entry->x->lock);
+	spin_lock_bh(&sa_entry->x->lock);
 	ret = mlx5e_ipsec_aso_query(sa_entry, NULL);
 	if (ret)
 		goto unlock;
@@ -447,7 +457,7 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 		mlx5e_ipsec_handle_limits(sa_entry);
 
 unlock:
-	spin_unlock(&sa_entry->x->lock);
+	spin_unlock_bh(&sa_entry->x->lock);
 	kfree(work);
 }
 
-- 
2.40.1


