Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EB76E8C04
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbjDTIDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbjDTIDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:03:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2885730F8
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:03:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4605B64147
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D957C433EF;
        Thu, 20 Apr 2023 08:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681977789;
        bh=dNJrN8fjruyL5bGm8ITrqeZapcsVUy++aNvOjiP05OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjAvSFknN+BZbFKFNgfCU60gM8qb8LCMWAZAMXmRmnEJa5w12S6Q3Ceh9wy19hP8z
         9W3iJTAymQ6Qxcni9fpsxM+Ep2wX4bfDASU2coSXi5knsu5d1bZipy3ET9za/q1UYx
         ePkzsUG0KQaU7j4SqzcbGdoYnaVBXVwlO22Gv90szI8+oUBhcGGKzTcjttKfGHH5Zk
         vYdHTumTAmDarI40YTeKf98Z1nBykeTEM2AvSPMyNOIP9nZn1LRfmD69TTM7EH8e9P
         ZidoK/PWXOPcsrlqp4u88RbtFBbbJpk8H5/PBX+h83p2peBKoHA2vgX5SNqmAeT43f
         DZKaUyhc/Nlbg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 4/5] net/mlx5e: Properly release work data structure
Date:   Thu, 20 Apr 2023 11:02:50 +0300
Message-Id: <f6c4092e54ab1e3c88a172ae08eab86297f9a9b3.1681976818.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681976818.git.leon@kernel.org>
References: <cover.1681976818.git.leon@kernel.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

There are some flows in which work structure is not allocated at all
and it is needed to be checked prior release of data structure.

 general protection fault, probably for non-canonical address 0xdffffc000000000a: 0000 [#1] SMP KASAN
 KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
 CPU: 6 PID: 3486 Comm: kworker/6:0 Not tainted 6.3.0-rc5_for_upstream_debug_2023_04_06_11_01 #1
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 Workqueue: events xfrm_state_gc_task
 RIP: 0010:mlx5e_xfrm_free_state+0x177/0x260 [mlx5_core]
 Code: c1 ea 03 80 3c 02 00 0f 85 f5 00 00 00 4c 8b a5 08 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d 7c 24 50 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 b7 00 00 00 49 8b 7c 24 50 e8 85 7c 09 e0 4c 89
 RSP: 0018:ffff888137a8fc50 EFLAGS: 00010206
 RAX: dffffc0000000000 RBX: ffff888180398000 RCX: 0000000000000000
 RDX: 000000000000000a RSI: ffffffffa1878227 RDI: 0000000000000050
 RBP: ffff88812a0c8000 R08: ffff888137a8fb60 R09: 0000000000000000
 R10: fffffbfff09aba0c R11: 0000000000000001 R12: 0000000000000000
 R13: ffff88812a0c8108 R14: ffffffff84c63480 R15: ffff8881acb63118
 FS:  0000000000000000(0000) GS:ffff88881eb00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f667e8bc000 CR3: 0000000004693006 CR4: 0000000000370ea0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:

  ___xfrm_state_destroy+0x3c8/0x5e0
  xfrm_state_gc_task+0xf6/0x140
  ? ___xfrm_state_destroy+0x5e0/0x5e0
  process_one_work+0x7c2/0x1340
  ? lockdep_hardirqs_on_prepare+0x3f0/0x3f0
  ? pwq_dec_nr_in_flight+0x230/0x230
  ? spin_bug+0x1d0/0x1d0
  worker_thread+0x59d/0xec0
  ? __kthread_parkme+0xd9/0x1d0
  ? process_one_work+0x1340/0x1340
  kthread+0x28f/0x330
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30

 Modules linked in: sch_ingress openvswitch nsh mlx5_vdpa vringh vhost_iotlb vdpa mlx5_ib mlx5_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_umad ib_ipoib ib_cm ib_uverbs ib_core vfio_pci vfio_pci_core vfio_iommu_type1 vfio cuse overlay zram zsmalloc fuse [last unloaded: mlx5_core]
 ---[ end trace 0000000000000000 ]---

Fixes: 4562116f8a56 ("net/mlx5e: Generalize IPsec work structs")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 1547d8cda133..59b9927ac90f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -708,7 +708,8 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 release_dwork:
 	kfree(sa_entry->dwork);
 release_work:
-	kfree(sa_entry->work->data);
+	if (sa_entry->work)
+		kfree(sa_entry->work->data);
 	kfree(sa_entry->work);
 err_xfrm:
 	kfree(sa_entry);
@@ -752,7 +753,8 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
 	mlx5_ipsec_free_sa_ctx(sa_entry);
 	kfree(sa_entry->dwork);
-	kfree(sa_entry->work->data);
+	if (sa_entry->work)
+		kfree(sa_entry->work->data);
 	kfree(sa_entry->work);
 sa_entry_free:
 	kfree(sa_entry);
-- 
2.40.0

