Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27BD04F2C85
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 13:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbiDEIZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 04:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239415AbiDEIUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:20:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8652E8597B;
        Tue,  5 Apr 2022 01:12:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41013B81B92;
        Tue,  5 Apr 2022 08:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83669C385A2;
        Tue,  5 Apr 2022 08:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649146372;
        bh=u3tQN1jErHjyr0UBnv+18ZdETY9+1Yn9vLc97oMtBc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fn08pANTSf5W3DRB8JUbnYHZT6LflVGFEd7vvYkN8u1C3gZt3Q2XAHbN7VVOQ4KqX
         TjydDQkG9dq27WeFpjgmJgBxuSCPdkyCjxx7/+ipbT4TGjyn6eR45u7psPEaNcpuzy
         cfhaOPZCZI5cJZr+I5uBvyQZmINWcka66k0Peq8ZWWf0NeApDJx9WnxGZq/6o3zMJm
         yFZJbrEGiBmtXNxsl6yXz+QasRoXSUyer10Fk05ClTorSsnP/JyKbS2c8r7o0Cy1sH
         bKZ4Z+icjPuX3c1naQXUoKedjQ/XWeOZGJGIrrWrHk0Ed0AD52LKFgyvGp/a7relef
         R5pxh/fXdb9gw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next 2/3] RDMA/mlx5: Handling dct common resource destruction upon firmware failure
Date:   Tue,  5 Apr 2022 11:12:41 +0300
Message-Id: <2a43192bf2649c1076b6a3b92ad6fd7d967d4498.1649139915.git.leonro@nvidia.com>
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

Previously when destroying a DCT, if the firmware function for the
destruction failed, the common resource would have been destroyed
either way, since it was destroyed before the firmware object.
Which leads to kernel warning "refcount_t: underflow" which indicates
possible use-after-free.
Which is triggered when we try to destroy the common resource for the
second time and execute refcount_dec_and_test(&common->refcount).

So, currently before destroying the common resource we check its
refcount and continue with the destruction only if it isn't zero.

refcount_t: underflow; use-after-free.
WARNING: CPU: 8 PID: 1002 at lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
Modules linked in: xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm mlx5_ib ib_uverbs ib_core overlay mlx5_core fuse
CPU: 8 PID: 1002 Comm: python3 Not tainted 5.16.0-rc5+ #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:refcount_warn_saturate+0xd8/0xe0
Code: ff 48 c7 c7 18 f5 23 82 c6 05 60 70 ff 00 01 e8 d0 0a 45 00 0f 0b c3 48 c7 c7 c0 f4 23 82 c6 05 4c 70 ff 00 01 e8 ba 0a 45 00 <0f> 0b c3 0f 1f 44 00 00 8b 07 3d 00 00 00 c0 74 12 83 f8 01 74 13
RSP: 0018:ffff8881221d3aa8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8881313e8d40 RCX: ffff88852cc1b5c8
RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff88852cc1b5c0
RBP: ffff888100f70000 R08: ffff88853ffd1ba8 R09: 0000000000000003
R10: 00000000fffff000 R11: 3fffffffffffffff R12: 0000000000000246
R13: ffff888100f71fa0 R14: ffff8881221d3c68 R15: 0000000000000020
FS:  00007efebbb13740(0000) GS:ffff88852cc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005611aac29f80 CR3: 00000001313de004 CR4: 0000000000370ea0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 destroy_resource_common+0x6e/0x95 [mlx5_ib]
 mlx5_core_destroy_rq_tracked+0x38/0xbe [mlx5_ib]
 mlx5_ib_destroy_wq+0x22/0x80 [mlx5_ib]
 ib_destroy_wq_user+0x1f/0x40 [ib_core]
 uverbs_free_wq+0x19/0x40 [ib_uverbs]
 destroy_hw_idr_uobject+0x18/0x50 [ib_uverbs]
 uverbs_destroy_uobject+0x2f/0x190 [ib_uverbs]
 uobj_destroy+0x3c/0x80 [ib_uverbs]
 ib_uverbs_cmd_verbs+0x3e4/0xb80 [ib_uverbs]
 ? uverbs_free_wq+0x40/0x40 [ib_uverbs]
 ? ip_list_rcv+0xf7/0x120
 ? netif_receive_skb_list_internal+0x1b6/0x2d0
 ? task_tick_fair+0xbf/0x450
 ? __handle_mm_fault+0x11fc/0x1450
 ib_uverbs_ioctl+0xa4/0x110 [ib_uverbs]
 __x64_sys_ioctl+0x3e4/0x8e0
 ? handle_mm_fault+0xb9/0x210
 do_syscall_64+0x3d/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7efebc0be17b
Code: 0f 1e fa 48 8b 05 1d ad 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ed ac 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe71813e78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffe71813fb8 RCX: 00007efebc0be17b
RDX: 00007ffe71813fa0 RSI: 00000000c0181b01 RDI: 0000000000000005
RBP: 00007ffe71813f80 R08: 00005611aae96020 R09: 000000000000004f
R10: 00007efebbf9ffa0 R11: 0000000000000246 R12: 00007ffe71813f80
R13: 00007ffe71813f4c R14: 00005611aae2eca0 R15: 00007efeae6c89d0
 </TASK>

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qpc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 542e4c63a8de..d9ce73a2fbeb 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -178,6 +178,9 @@ static void destroy_resource_common(struct mlx5_ib_dev *dev,
 	struct mlx5_qp_table *table = &dev->qp_table;
 	unsigned long flags;
 
+	if (refcount_read(&qp->common.refcount) == 0)
+		return;
+
 	spin_lock_irqsave(&table->lock, flags);
 	radix_tree_delete(&table->tree,
 			  qp->qpn | (qp->common.res << MLX5_USER_INDEX_LEN));
-- 
2.35.1

