Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6534F32ED
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbiDEIZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 04:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239422AbiDEIUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:20:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558496E8EE;
        Tue,  5 Apr 2022 01:12:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 188D9B81B90;
        Tue,  5 Apr 2022 08:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CBFC385A2;
        Tue,  5 Apr 2022 08:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649146375;
        bh=Ewcg6XIQpxOcYpK+RJNS2cZyxmvDqGh/zPgxML6vPUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsJ777W/0D7ib0jeZIFyZWRWtJGIr/LKobZza/r4s75TdZwLAmb3Byl5o9Zh1+klE
         CAc/ENkk7MBzkQQWVabXlizT7fftOlf0ukXtZ/vZ3wnRJoda1sYs/8OECcILEbCmB7
         kMmnAMy06GwJgr05kvzYpJO73+3MwpK7JMVnXDM58mmxxYnVwzcmw+0wvV4lZMi5L6
         qcUNZZFrwqmqIrhjarWKnQ3+v+o+cJtyNqGCJSTMropQD+DucGvWB5Gcs5uRM3BiOs
         ovO2WldsXNmgQxoDGsouZYdRuXweUb99CgGpyphXwPQIz/Sz22MwBHtDTGMu7+PBio
         I8UeCci0f51Eg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next 3/3] RDMA/mlx5: Return the firmware result upon destroying QP/RQ
Date:   Tue,  5 Apr 2022 11:12:42 +0300
Message-Id: <b2ddec0b7b1dfc27045c5de1bfb39c234776ac7a.1649139915.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649139915.git.leonro@nvidia.com>
References: <cover.1649139915.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qpc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index d9ce73a2fbeb..73bae024c01a 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -300,8 +300,7 @@ int mlx5_core_destroy_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp)
 	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
 	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
 	MLX5_SET(destroy_qp_in, in, uid, qp->uid);
-	mlx5_cmd_exec_in(dev->mdev, destroy_qp, in);
-	return 0;
+	return mlx5_cmd_exec_in(dev->mdev, destroy_qp, in);
 }
 
 int mlx5_core_set_delay_drop(struct mlx5_ib_dev *dev,
@@ -551,14 +550,14 @@ int mlx5_core_xrcd_dealloc(struct mlx5_ib_dev *dev, u32 xrcdn)
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
@@ -589,8 +588,7 @@ int mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
 				 struct mlx5_core_qp *rq)
 {
 	destroy_resource_common(dev, rq);
-	destroy_rq_tracked(dev, rq->qpn, rq->uid);
-	return 0;
+	return destroy_rq_tracked(dev, rq->qpn, rq->uid);
 }
 
 static void destroy_sq_tracked(struct mlx5_ib_dev *dev, u32 sqn, u16 uid)
-- 
2.35.1

