Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB7B55F90B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiF2H2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiF2H2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:28:36 -0400
Received: from out199-13.us.a.mail.aliyun.com (out199-13.us.a.mail.aliyun.com [47.90.199.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4171914D3B;
        Wed, 29 Jun 2022 00:28:33 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=mqaio@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VHmjp8f_1656487709;
Received: from localhost(mailfrom:mqaio@linux.alibaba.com fp:SMTPD_---0VHmjp8f_1656487709)
          by smtp.aliyun-inc.com;
          Wed, 29 Jun 2022 15:28:30 +0800
From:   Qiao Ma <mqaio@linux.alibaba.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, gustavoars@kernel.org, cai.huoqing@linux.dev,
        aviad.krawczyk@huawei.com, zhaochen6@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hinic: avoid kernel hung in hinic_get_stats64()
Date:   Wed, 29 Jun 2022 15:28:26 +0800
Message-Id: <07736c2b7019b6883076a06129e06e8f7c5f7154.1656487154.git.mqaio@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using hinic device as a bond slave device, and reading device stats of
master bond device, the kernel may hung.

The kernel panic calltrace as follows:
Kernel panic - not syncing: softlockup: hung tasks
Call trace:
  native_queued_spin_lock_slowpath+0x1ec/0x31c
  dev_get_stats+0x60/0xcc
  dev_seq_printf_stats+0x40/0x120
  dev_seq_show+0x1c/0x40
  seq_read_iter+0x3c8/0x4dc
  seq_read+0xe0/0x130
  proc_reg_read+0xa8/0xe0
  vfs_read+0xb0/0x1d4
  ksys_read+0x70/0xfc
  __arm64_sys_read+0x20/0x30
  el0_svc_common+0x88/0x234
  do_el0_svc+0x2c/0x90
  el0_svc+0x1c/0x30
  el0_sync_handler+0xa8/0xb0
  el0_sync+0x148/0x180

And the calltrace of task that actually caused kernel hungs as follows:
  __switch_to+124
  __schedule+548
  schedule+72
  schedule_timeout+348
  __down_common+188
  __down+24
  down+104
  hinic_get_stats64+44 [hinic]
  dev_get_stats+92
  bond_get_stats+172 [bonding]
  dev_get_stats+92
  dev_seq_printf_stats+60
  dev_seq_show+24
  seq_read_iter+964
  seq_read+220
  proc_reg_read+164
  vfs_read+172
  ksys_read+108
  __arm64_sys_read+28
  el0_svc_common+132
  do_el0_svc+40
  el0_svc+24
  el0_sync_handler+164
  el0_sync+324

When getting device stats from bond, kernel will call bond_get_stats().
It first holds the spinlock bond->stats_lock, and then call
hinic_get_stats64() to collect hinic device's stats.
However, hinic_get_stats64() calls `down(&nic_dev->mgmt_lock)` to
protect its critical section, which may schedule current task out.
And if system is under high pressure, the task cannot be woken up
immediately, which eventually triggers kernel hung panic.

Fixes: edd384f682cc ("net-next/hinic: Add ethtool and stats")
Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_dev.h  | 1 +
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index fb3e89141a0d..1fb343d03fd5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -97,6 +97,7 @@ struct hinic_dev {
 
 	struct hinic_txq_stats          tx_stats;
 	struct hinic_rxq_stats          rx_stats;
+	spinlock_t			stats_lock;
 
 	u8				rss_tmpl_idx;
 	u8				rss_hash_engine;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 56a89793f47d..32a3d700ad26 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -125,11 +125,13 @@ static void update_nic_stats(struct hinic_dev *nic_dev)
 {
 	int i, num_qps = hinic_hwdev_num_qps(nic_dev->hwdev);
 
+	spin_lock(&nic_dev->stats_lock);
 	for (i = 0; i < num_qps; i++)
 		update_rx_stats(nic_dev, &nic_dev->rxqs[i]);
 
 	for (i = 0; i < num_qps; i++)
 		update_tx_stats(nic_dev, &nic_dev->txqs[i]);
+	spin_unlock(&nic_dev->stats_lock);
 }
 
 /**
@@ -859,13 +861,9 @@ static void hinic_get_stats64(struct net_device *netdev,
 	nic_rx_stats = &nic_dev->rx_stats;
 	nic_tx_stats = &nic_dev->tx_stats;
 
-	down(&nic_dev->mgmt_lock);
-
 	if (nic_dev->flags & HINIC_INTF_UP)
 		update_nic_stats(nic_dev);
 
-	up(&nic_dev->mgmt_lock);
-
 	stats->rx_bytes   = nic_rx_stats->bytes;
 	stats->rx_packets = nic_rx_stats->pkts;
 	stats->rx_errors  = nic_rx_stats->errors;
@@ -1239,6 +1237,7 @@ static int nic_dev_init(struct pci_dev *pdev)
 
 	u64_stats_init(&tx_stats->syncp);
 	u64_stats_init(&rx_stats->syncp);
+	spin_lock_init(&nic_dev->stats_lock);
 
 	nic_dev->vlan_bitmap = devm_bitmap_zalloc(&pdev->dev, VLAN_N_VID,
 						  GFP_KERNEL);
-- 
1.8.3.1

