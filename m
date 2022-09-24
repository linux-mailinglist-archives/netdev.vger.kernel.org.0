Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C823E5E8BC0
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 13:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiIXLRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 07:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbiIXLRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 07:17:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A45F23176
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 04:17:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19B3B60F2B
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 11:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE131C433C1;
        Sat, 24 Sep 2022 11:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664018250;
        bh=nkWbBhuh6BhHBkgxDYQHeJXjCF71hzzxusyR2F2LCxM=;
        h=From:To:Cc:Subject:Date:From;
        b=DGofexTsejcXaOETgUU8j66CTonjETguaFljuqW3HhPUmTftLBvPnOihgEhuT1F0w
         5e7DcpVtLHpI7ZR91GbVuJddtcEhxGTtU0sEgdw3i5KDN963khRjusi/FRYA5BG5l9
         dibCtv3oimP7xirxY9rGD61HTmsrWkc8oAj5Iq/sJlGUt3iLR2cMm++TD7Lv7ZYzba
         2oFxQf1MnRVwp3KUzTxBHZ/KKNMu5MdJKjsbkQtoLu3QeeJVWW5G5ppErJdVwNm0ko
         yRAEEs2Yq27LYSwYDtP4G0pDhBzP7A7DHewQKi7Q9+rDidC8gI6uSwW3d9oLka9CX6
         IFpLUcsb08vcA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next] net/mlx5: Make ASO poll CQ usable in atomic context
Date:   Sat, 24 Sep 2022 14:17:24 +0300
Message-Id: <d941bb44798b938705ca6944d8ee02c97af7ddd5.1664017836.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Poll CQ functions shouldn't sleep as they are called in atomic context.
The following splat appears once the mlx5_aso_poll_cq() is used in such
flow.

 BUG: scheduling while atomic: swapper/17/0/0x00000100
 Modules linked in: sch_ingress openvswitch nsh mlx5_vdpa vringh vhost_iotlb vdpa mlx5_ib mlx5_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter overlay rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm ib_uverbs ib_core fuse [last unloaded: mlx5_core]
 CPU: 17 PID: 0 Comm: swapper/17 Tainted: G        W          6.0.0-rc2+ #13
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x34/0x44
  __schedule_bug.cold+0x47/0x53
  __schedule+0x4b6/0x670
  ? hrtimer_start_range_ns+0x28d/0x360
  schedule+0x50/0x90
  schedule_hrtimeout_range_clock+0x98/0x120
  ? __hrtimer_init+0xb0/0xb0
  usleep_range_state+0x60/0x90
  mlx5_aso_poll_cq+0xad/0x190 [mlx5_core]
  mlx5e_ipsec_aso_update_curlft+0x81/0xb0 [mlx5_core]
  xfrm_timer_handler+0x6b/0x360
  ? xfrm_find_acq_byseq+0x50/0x50
  __hrtimer_run_queues+0x139/0x290
  hrtimer_run_softirq+0x7d/0xe0
  __do_softirq+0xc7/0x272
  irq_exit_rcu+0x87/0xb0
  sysvec_apic_timer_interrupt+0x72/0x90
  </IRQ>
  <TASK>
  asm_sysvec_apic_timer_interrupt+0x16/0x20
 RIP: 0010:default_idle+0x18/0x20
 Code: ae 7d ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 8b 05 b5 30 0d 01 85 c0 7e 07 0f 00 2d 0a e3 53 00 fb f4 <c3> 0f 1f 80 00 00 00 00 0f 1f 44 00 00 65 48 8b 04 25 80 ad 01 00
 RSP: 0018:ffff888100883ee0 EFLAGS: 00000242
 RAX: 0000000000000001 RBX: ffff888100849580 RCX: 4000000000000000
 RDX: 0000000000000001 RSI: 0000000000000083 RDI: 000000000008863c
 RBP: 0000000000000011 R08: 00000064e6977fa9 R09: 0000000000000001
 R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  default_idle_call+0x37/0xb0
  do_idle+0x1cd/0x1e0
  cpu_startup_entry+0x19/0x20
  start_secondary+0xfe/0x120
  secondary_startup_64_no_verify+0xcd/0xdb
  </TASK>
 softirq: huh, entered softirq 8 HRTIMER 00000000a97c08cb with preempt_count 00000100, exited with 00000000?

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Hi,

I kept this patch for a long time in my IPsec tree and planned to submit
it together with mlx5 IPsec series as no other users except TC used this API.
Unfortunately, MACsec started to use this poll CQ API too and spread the
same mistake.

I have no idea what "With newer FW, the wait for the first ASO WQE..."
comment in TC means, the sentence is a magic to me, so I leave it as is.
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c  |  6 +++++-
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c  |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c      | 10 +---------
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h      |  2 +-
 4 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index a53e205f4a89..b9011356299e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -115,6 +115,7 @@ mlx5e_tc_meter_modify(struct mlx5_core_dev *mdev,
 	struct mlx5e_flow_meters *flow_meters;
 	u8 cir_man, cir_exp, cbs_man, cbs_exp;
 	struct mlx5_aso_wqe *aso_wqe;
+	unsigned long expires;
 	struct mlx5_aso *aso;
 	u64 rate, burst;
 	u8 ds_cnt;
@@ -187,7 +188,10 @@ mlx5e_tc_meter_modify(struct mlx5_core_dev *mdev,
 	mlx5_aso_post_wqe(aso, true, &aso_wqe->ctrl);
 
 	/* With newer FW, the wait for the first ASO WQE is more than 2us, put the wait 10ms. */
-	err = mlx5_aso_poll_cq(aso, true, 10);
+	expires = jiffies + msecs_to_jiffies(10);
+	do {
+		err = mlx5_aso_poll_cq(aso, true);
+	} while (err && time_is_after_jiffies(expires));
 	mutex_unlock(&flow_meters->aso_lock);
 
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index a13169723153..31e1973c3740 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1441,7 +1441,7 @@ static int macsec_aso_set_arm_event(struct mlx5_core_dev *mdev, struct mlx5e_mac
 			   MLX5_ACCESS_ASO_OPC_MOD_MACSEC);
 	macsec_aso_build_ctrl(aso, &aso_wqe->aso_ctrl, in);
 	mlx5_aso_post_wqe(maso, false, &aso_wqe->ctrl);
-	err = mlx5_aso_poll_cq(maso, false, 10);
+	err = mlx5_aso_poll_cq(maso, false);
 	mutex_unlock(&aso->aso_lock);
 
 	return err;
@@ -1466,7 +1466,7 @@ static int macsec_aso_query(struct mlx5_core_dev *mdev, struct mlx5e_macsec *mac
 	macsec_aso_build_wqe_ctrl_seg(aso, &aso_wqe->aso_ctrl, NULL);
 
 	mlx5_aso_post_wqe(maso, false, &aso_wqe->ctrl);
-	err = mlx5_aso_poll_cq(maso, false, 10);
+	err = mlx5_aso_poll_cq(maso, false);
 	if (err)
 		goto err_out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
index 21e14507ff5c..baa8092f335e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -381,20 +381,12 @@ void mlx5_aso_post_wqe(struct mlx5_aso *aso, bool with_data,
 	WRITE_ONCE(doorbell_cseg, NULL);
 }
 
-int mlx5_aso_poll_cq(struct mlx5_aso *aso, bool with_data, u32 interval_ms)
+int mlx5_aso_poll_cq(struct mlx5_aso *aso, bool with_data)
 {
 	struct mlx5_aso_cq *cq = &aso->cq;
 	struct mlx5_cqe64 *cqe;
-	unsigned long expires;
 
 	cqe = mlx5_cqwq_get_cqe(&cq->wq);
-
-	expires = jiffies + msecs_to_jiffies(interval_ms);
-	while (!cqe && time_is_after_jiffies(expires)) {
-		usleep_range(2, 10);
-		cqe = mlx5_cqwq_get_cqe(&cq->wq);
-	}
-
 	if (!cqe)
 		return -ETIMEDOUT;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
index d854e01d7fc5..2d40dcf9d42e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
@@ -83,7 +83,7 @@ void mlx5_aso_build_wqe(struct mlx5_aso *aso, u8 ds_cnt,
 			u32 obj_id, u32 opc_mode);
 void mlx5_aso_post_wqe(struct mlx5_aso *aso, bool with_data,
 		       struct mlx5_wqe_ctrl_seg *doorbell_cseg);
-int mlx5_aso_poll_cq(struct mlx5_aso *aso, bool with_data, u32 interval_ms);
+int mlx5_aso_poll_cq(struct mlx5_aso *aso, bool with_data);
 
 struct mlx5_aso *mlx5_aso_create(struct mlx5_core_dev *mdev, u32 pdn);
 void mlx5_aso_destroy(struct mlx5_aso *aso);
-- 
2.37.3

