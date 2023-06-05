Return-Path: <netdev+bounces-7953-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8D972232A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 764DB28122C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56854156F9;
	Mon,  5 Jun 2023 10:14:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D4A168C7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F80C433A7;
	Mon,  5 Jun 2023 10:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685960062;
	bh=HTWf/oxIAfP0hpG+rblb2ZLBPhey8NXCxPmzKjVmcbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1QifPymeFKhZ6GeHUZrWPGWI/HXFBl9rnrkje2qwTcaHNijawQ3rP784wUbzXRG0
	 WT+iMdD2YC2uM/4f3P8iIuYr2hGO7QLnCjAc7uW6v9xGaUZ4zugG6x1z6WmZtTTnGG
	 ooul3TDHgmbHuhZiEL/VIdFYJxIdOM8LSfUTOYe2lFJbzY/h7vBZfcIlrC5HlGoqHz
	 0t+X+nMLfI/0iPZiOz2EA3GBQe5KE4ccBITLxuvFNeSteb0RP7DwCaCe6TZfUoM0cI
	 IcJVVPanc3RDA9nOU25mZL5f+o5TT0twjbukj1W+1I0gKXjxZocp6+3fl+f+n4bCmx
	 OACW1Lwuo4hlQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Patrisious Haddad <phaddad@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v2 4/4] RDMA/mlx5: Return the firmware result upon destroying QP/RQ
Date: Mon,  5 Jun 2023 13:14:07 +0300
Message-Id: <c6df677f931d18090bafbe7f7dbb9524047b7d9b.1685953497.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685953497.git.leon@kernel.org>
References: <cover.1685953497.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Patrisious Haddad <phaddad@nvidia.com>

Previously when destroying a QP/RQ, the result of the firmware
destruction function was ignored and upper layers weren't informed
about the failure.
Which in turn could lead to various problems since when upper layer
isn't aware of the failure it continues its operation thinking that the
related QP/RQ was successfully destroyed while it actually wasn't,
which could lead to the below kernel WARN.

Currently, we return the correct firmware destruction status to upper
layers which in case of the RQ would be mlx5_ib_destroy_wq() which
was already capable of handling RQ destruction failure or in case of
a QP to destroy_qp_common(), which now would actually warn upon qp
destruction failure.

WARNING: CPU: 3 PID: 995 at drivers/infiniband/core/rdma_core.c:940 uverbs_destroy_ufile_hw+0xcb/0xe0 [ib_uverbs]
Modules linked in: xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi rdma_cm ib_umad ib_ipoib iw_cm ib_cm mlx5_ib ib_uverbs ib_core overlay mlx5_core fuse
CPU: 3 PID: 995 Comm: python3 Not tainted 5.16.0-rc5+ #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:uverbs_destroy_ufile_hw+0xcb/0xe0 [ib_uverbs]
Code: 41 5c 41 5d 41 5e e9 44 34 f0 e0 48 89 df e8 4c 77 ff ff 49 8b 86 10 01 00 00 48 85 c0 74 a1 4c 89 e7 ff d0 eb 9a 0f 0b eb c1 <0f> 0b be 04 00 00 00 48 89 df e8 b6 f6 ff ff e9 75 ff ff ff 90 0f
RSP: 0018:ffff8881533e3e78 EFLAGS: 00010287
RAX: ffff88811b2cf3e0 RBX: ffff888106209700 RCX: 0000000000000000
RDX: ffff888106209780 RSI: ffff8881533e3d30 RDI: ffff888109b101a0
RBP: 0000000000000001 R08: ffff888127cb381c R09: 0de9890000000009
R10: ffff888127cb3800 R11: 0000000000000000 R12: ffff888106209780
R13: ffff888106209750 R14: ffff888100f20660 R15: 0000000000000000
FS:  00007f8be353b740(0000) GS:ffff88852c980000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8bd5b117c0 CR3: 000000012cd8a004 CR4: 0000000000370ea0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ib_uverbs_close+0x1a/0x90 [ib_uverbs]
 __fput+0x82/0x230
 task_work_run+0x59/0x90
 exit_to_user_mode_prepare+0x138/0x140
 syscall_exit_to_user_mode+0x1d/0x50
 ? __x64_sys_close+0xe/0x40
 do_syscall_64+0x4a/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8be3ae0abb
Code: 03 00 00 00 0f 05 48 3d 00 f0 ff ff 77 41 c3 48 83 ec 18 89 7c 24 0c e8 83 43 f9 ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 c1 43 f9 ff 8b 44
RSP: 002b:00007ffdb51909c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000557bb7f7c020 RCX: 00007f8be3ae0abb
RDX: 0000557bb7c74010 RSI: 0000557bb7f14ca0 RDI: 0000000000000005
RBP: 0000557bb7fbd598 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 0000557bb7fbd5b8
R13: 0000557bb7fbd5a8 R14: 0000000000001000 R15: 0000557bb7f7c020
 </TASK>

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qpc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 3a2f755d4985..d9cf6982d645 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -314,8 +314,7 @@ int mlx5_core_destroy_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp)
 	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
 	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
 	MLX5_SET(destroy_qp_in, in, uid, qp->uid);
-	mlx5_cmd_exec_in(dev->mdev, destroy_qp, in);
-	return 0;
+	return mlx5_cmd_exec_in(dev->mdev, destroy_qp, in);
 }
 
 int mlx5_core_set_delay_drop(struct mlx5_ib_dev *dev,
@@ -568,14 +567,14 @@ int mlx5_core_xrcd_dealloc(struct mlx5_ib_dev *dev, u32 xrcdn)
 	return mlx5_cmd_exec_in(dev->mdev, dealloc_xrcd, in);
 }
 
-static void destroy_rq_tracked(struct mlx5_ib_dev *dev, u32 rqn, u16 uid)
+static int destroy_rq_tracked(struct mlx5_ib_dev *dev, u32 rqn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_rq_in)] = {};
 
 	MLX5_SET(destroy_rq_in, in, opcode, MLX5_CMD_OP_DESTROY_RQ);
 	MLX5_SET(destroy_rq_in, in, rqn, rqn);
 	MLX5_SET(destroy_rq_in, in, uid, uid);
-	mlx5_cmd_exec_in(dev->mdev, destroy_rq, in);
+	return mlx5_cmd_exec_in(dev->mdev, destroy_rq, in);
 }
 
 int mlx5_core_create_rq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
@@ -606,8 +605,7 @@ int mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
 				 struct mlx5_core_qp *rq)
 {
 	destroy_resource_common(dev, rq);
-	destroy_rq_tracked(dev, rq->qpn, rq->uid);
-	return 0;
+	return destroy_rq_tracked(dev, rq->qpn, rq->uid);
 }
 
 static void destroy_sq_tracked(struct mlx5_ib_dev *dev, u32 sqn, u16 uid)
-- 
2.40.1


