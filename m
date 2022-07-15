Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EDA57692B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 23:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiGOVsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 17:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGOVsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 17:48:00 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543E02B277
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 14:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657921679; x=1689457679;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7iL/029uxJ2XBGzpteqOuHQxx3eYmBxGbY65GTk2iKA=;
  b=PVhU3Iuxp0zpfSTJI7DLUFlxtvZIWY6WlAD3vm9nCUx9Ujx2R9S27YM5
   tk3k9bJSAND6EotS8T4FCWRGzZPD7HDlt6WmuJSNB7+tM1dXfROAm5GzL
   pZxNqOJ8B7l/tIzjx1S+JOkmDjiumhRjDtDUowMXnO6hM1u4L0xPb+irz
   OLHQ0iI/5pHBOxsirFqxT0O02ktXpKdYTqcrYuboU2ByTMFmvQXZWfArO
   Vq5uB07Wg9+rnh6F+9fR67bCq2mCID1kjIshPcs6AAUGLmtz+nyUGSKgi
   uq5badFDrb0zNSTTHuF2yJmOwQZXxqvele5h8kQRayDmz3jRY6DkpEOfY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="266319128"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="266319128"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:47:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="593883578"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 15 Jul 2022 14:47:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Piotr Skajewski <piotrx.skajewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net v2 1/1] ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero
Date:   Fri, 15 Jul 2022 14:44:56 -0700
Message-Id: <20220715214456.2968711-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Skajewski <piotrx.skajewski@intel.com>

It is possible to disable VFs while the PF driver is processing requests
from the VF driver.  This can result in a panic.

BUG: unable to handle kernel paging request at 000000000000106c
PGD 0 P4D 0
Oops: 0000 [#1] SMP NOPTI
CPU: 8 PID: 0 Comm: swapper/8 Kdump: loaded Tainted: G I      --------- -
Hardware name: Dell Inc. PowerEdge R740/06WXJT, BIOS 2.8.2 08/27/2020
RIP: 0010:ixgbe_msg_task+0x4c8/0x1690 [ixgbe]
Code: 00 00 48 8d 04 40 48 c1 e0 05 89 7c 24 24 89 fd 48 89 44 24 10 83 ff
01 0f 84 b8 04 00 00 4c 8b 64 24 10 4d 03 a5 48 22 00 00 <41> 80 7c 24 4c
00 0f 84 8a 03 00 00 0f b7 c7 83 f8 08 0f 84 8f 0a
RSP: 0018:ffffb337869f8df8 EFLAGS: 00010002
RAX: 0000000000001020 RBX: 0000000000000000 RCX: 000000000000002b
RDX: 0000000000000002 RSI: 0000000000000008 RDI: 0000000000000006
RBP: 0000000000000006 R08: 0000000000000002 R09: 0000000000029780
R10: 00006957d8f42832 R11: 0000000000000000 R12: 0000000000001020
R13: ffff8a00e8978ac0 R14: 000000000000002b R15: ffff8a00e8979c80
FS:  0000000000000000(0000) GS:ffff8a07dfd00000(0000) knlGS:00000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000106c CR3: 0000000063e10004 CR4: 00000000007726e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <IRQ>
 ? ttwu_do_wakeup+0x19/0x140
 ? try_to_wake_up+0x1cd/0x550
 ? ixgbevf_update_xcast_mode+0x71/0xc0 [ixgbevf]
 ixgbe_msix_other+0x17e/0x310 [ixgbe]
 __handle_irq_event_percpu+0x40/0x180
 handle_irq_event_percpu+0x30/0x80
 handle_irq_event+0x36/0x53
 handle_edge_irq+0x82/0x190
 handle_irq+0x1c/0x30
 do_IRQ+0x49/0xd0
 common_interrupt+0xf/0xf

This can be eventually be reproduced with the following script:

while :
do
    echo 63 > /sys/class/net/<devname>/device/sriov_numvfs
    sleep 1
    echo 0 > /sys/class/net/<devname>/device/sriov_numvfs
    sleep 1
done

Add lock when disabling SR-IOV to prevent process VF mailbox communication.

Fixes: d773d1310625 ("ixgbe: Fix memory leak when SR-IOV VFs are direct assigned")
Signed-off-by: Piotr Skajewski <piotrx.skajewski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
v2: Hold the lock only around adapter->num_vf instead adapter->vfinfo

 drivers/net/ethernet/intel/ixgbe/ixgbe.h       | 1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  | 3 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 6 ++++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 921a4d977d65..8813b4dd6872 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -779,6 +779,7 @@ struct ixgbe_adapter {
 #ifdef CONFIG_IXGBE_IPSEC
 	struct ixgbe_ipsec *ipsec;
 #endif /* CONFIG_IXGBE_IPSEC */
+	spinlock_t vfs_lock;
 };
 
 static inline int ixgbe_determine_xdp_q_idx(int cpu)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 77c2e70b0860..55f91c9ff047 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6403,6 +6403,9 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
 	/* n-tuple support exists, always init our spinlock */
 	spin_lock_init(&adapter->fdir_perfect_lock);
 
+	/* init spinlock to avoid concurrency of VF resources */
+	spin_lock_init(&adapter->vfs_lock);
+
 #ifdef CONFIG_IXGBE_DCB
 	ixgbe_init_dcb(adapter);
 #endif
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index d4e63f0644c3..a1e69c734863 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -205,10 +205,13 @@ void ixgbe_enable_sriov(struct ixgbe_adapter *adapter, unsigned int max_vfs)
 int ixgbe_disable_sriov(struct ixgbe_adapter *adapter)
 {
 	unsigned int num_vfs = adapter->num_vfs, vf;
+	unsigned long flags;
 	int rss;
 
+	spin_lock_irqsave(&adapter->vfs_lock, flags);
 	/* set num VFs to 0 to prevent access to vfinfo */
 	adapter->num_vfs = 0;
+	spin_unlock_irqrestore(&adapter->vfs_lock, flags);
 
 	/* put the reference to all of the vf devices */
 	for (vf = 0; vf < num_vfs; ++vf) {
@@ -1355,8 +1358,10 @@ static void ixgbe_rcv_ack_from_vf(struct ixgbe_adapter *adapter, u32 vf)
 void ixgbe_msg_task(struct ixgbe_adapter *adapter)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
+	unsigned long flags;
 	u32 vf;
 
+	spin_lock_irqsave(&adapter->vfs_lock, flags);
 	for (vf = 0; vf < adapter->num_vfs; vf++) {
 		/* process any reset requests */
 		if (!ixgbe_check_for_rst(hw, vf))
@@ -1370,6 +1375,7 @@ void ixgbe_msg_task(struct ixgbe_adapter *adapter)
 		if (!ixgbe_check_for_ack(hw, vf))
 			ixgbe_rcv_ack_from_vf(adapter, vf);
 	}
+	spin_unlock_irqrestore(&adapter->vfs_lock, flags);
 }
 
 static inline void ixgbe_ping_vf(struct ixgbe_adapter *adapter, int vf)
-- 
2.35.1

