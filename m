Return-Path: <netdev+bounces-7902-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E41C72209F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:11:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBE4C1C20B65
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FE1125A0;
	Mon,  5 Jun 2023 08:10:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51996134A2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E6DC433D2;
	Mon,  5 Jun 2023 08:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685952611;
	bh=yS3cHrMJRPhY+eyMAyUZotTBE0XZpYGP9AjdkY8FxOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJyIrzQ/HfrCsuYrHYobztx24QpvfMb6Lq2ngS4y3kZYASnvM+CAQkCBQcC0K6PtH
	 faJudd68Lpn/6W8BgUOX8f5seWnefLwvM6fwO1C3oBCjiTaOr5KEqEXevQQOUO5oBZ
	 /UFHq3wFrb4jIUvcJDnUmDa9feQlDWaeJZdNxB9Iu54+X4ZpVfkMXMdR+QRJCxA6Ix
	 tnpCi3IOA0ObRfEeTEXPcIU4r61cRGvgaC6DPkil9qDObEL9uOH1icHCcQPvtEyAQO
	 l2v2Lb2r2/KVfFRZNVYwmN2N1wGQ2V94g8PHK1NYe3x46UixIQq2oe8XTpEOREhURg
	 FfmsDKafSwvhg==
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Raed Salem <raeds@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net 1/4] net/mlx5e: Don't delay release of hardware objects
Date: Mon,  5 Jun 2023 11:09:49 +0300
Message-Id: <e89e4c68b70d8b469e7a31613d56ce2974bc943d.1685950599.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

XFRM core provides two callbacks to release resources, one is .xdo_dev_policy_delete()
and another is .xdo_dev_policy_free(). This separation allows delayed release so
"ip xfrm policy free" commands won't starve. Unfortunately, mlx5 command interface
can't run in .xdo_dev_policy_free() callbacks as the latter runs in ATOMIC context.

 BUG: scheduling while atomic: swapper/7/0/0x00000100
 Modules linked in: act_mirred act_tunnel_key cls_flower sch_ingress vxlan mlx5_vdpa vringh vhost_iotlb vdpa rpcrdma rdma_ucm ib_iser libiscsi ib_umad scsi_transport_iscsi rdma_cm ib_ipoib iw_cm ib_cm mlx5_ib ib_uverbs ib_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcsec_gss_krb5 auth_rpcgss oid_registry overlay mlx5_core zram zsmalloc fuse
 CPU: 7 PID: 0 Comm: swapper/7 Not tainted 6.3.0+ #1
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x33/0x50
  __schedule_bug+0x4e/0x60
  __schedule+0x5d5/0x780
  ? __mod_timer+0x286/0x3d0
  schedule+0x50/0x90
  schedule_timeout+0x7c/0xf0
  ? __bpf_trace_tick_stop+0x10/0x10
  __wait_for_common+0x88/0x190
  ? usleep_range_state+0x90/0x90
  cmd_exec+0x42e/0xb40 [mlx5_core]
  mlx5_cmd_do+0x1e/0x40 [mlx5_core]
  mlx5_cmd_exec+0x18/0x30 [mlx5_core]
  mlx5_cmd_delete_fte+0xa8/0xd0 [mlx5_core]
  del_hw_fte+0x60/0x120 [mlx5_core]
  mlx5_del_flow_rules+0xec/0x270 [mlx5_core]
  ? default_send_IPI_single_phys+0x26/0x30
  mlx5e_accel_ipsec_fs_del_pol+0x1a/0x60 [mlx5_core]
  mlx5e_xfrm_free_policy+0x15/0x20 [mlx5_core]
  xfrm_policy_destroy+0x5a/0xb0
  xfrm4_dst_destroy+0x7b/0x100
  dst_destroy+0x37/0x120
  rcu_core+0x2d6/0x540
  __do_softirq+0xcd/0x273
  irq_exit_rcu+0x82/0xb0
  sysvec_apic_timer_interrupt+0x72/0x90
  </IRQ>
  <TASK>
  asm_sysvec_apic_timer_interrupt+0x16/0x20
 RIP: 0010:default_idle+0x13/0x20
 Code: c0 08 00 00 00 4d 29 c8 4c 01 c7 4c 29 c2 e9 72 ff ff ff cc cc cc cc 8b 05 7a 4d ee 00 85 c0 7e 07 0f 00 2d 2f 98 2e 00 fb f4 <fa> c3 66 66 2e 0f 1f 84 00 00 00 00 00 65 48 8b 04 25 40 b4 02 00
 RSP: 0018:ffff888100843ee0 EFLAGS: 00000242
 RAX: 0000000000000001 RBX: ffff888100812b00 RCX: 4000000000000000
 RDX: 0000000000000001 RSI: 0000000000000083 RDI: 000000000002d2ec
 RBP: 0000000000000007 R08: 00000021daeded59 R09: 0000000000000001
 R10: 0000000000000000 R11: 000000000000000f R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  default_idle_call+0x30/0xb0
  do_idle+0x1c1/0x1d0
  cpu_startup_entry+0x19/0x20
  start_secondary+0xfe/0x120
  secondary_startup_64_no_verify+0xf3/0xfb
  </TASK>
 bad: scheduling from the idle thread!

Fixes: a5b8ca9471d3 ("net/mlx5e: Add XFRM policy offload logic")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 55b38544422f..d1c801723d35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -1040,11 +1040,17 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	return err;
 }
 
-static void mlx5e_xfrm_free_policy(struct xfrm_policy *x)
+static void mlx5e_xfrm_del_policy(struct xfrm_policy *x)
 {
 	struct mlx5e_ipsec_pol_entry *pol_entry = to_ipsec_pol_entry(x);
 
 	mlx5e_accel_ipsec_fs_del_pol(pol_entry);
+}
+
+static void mlx5e_xfrm_free_policy(struct xfrm_policy *x)
+{
+	struct mlx5e_ipsec_pol_entry *pol_entry = to_ipsec_pol_entry(x);
+
 	kfree(pol_entry);
 }
 
@@ -1065,6 +1071,7 @@ static const struct xfrmdev_ops mlx5e_ipsec_packet_xfrmdev_ops = {
 
 	.xdo_dev_state_update_curlft = mlx5e_xfrm_update_curlft,
 	.xdo_dev_policy_add = mlx5e_xfrm_add_policy,
+	.xdo_dev_policy_delete = mlx5e_xfrm_del_policy,
 	.xdo_dev_policy_free = mlx5e_xfrm_free_policy,
 };
 
-- 
2.40.1


