Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D74035F8DE
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352680AbhDNQTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:19:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:61890 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352669AbhDNQTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 12:19:10 -0400
IronPort-SDR: LZE8/1Sj1JKGHaNMC14y+7wtZH0J2kPaYdMp4XpLCfQxQlOUFqDUX4hqbnSA6aOynch2uIuqnm
 Mv/2jPRZs9mg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="182179983"
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="182179983"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 09:18:48 -0700
IronPort-SDR: e3aveOUeBhG1EPyd56iGE7O5a8L0ZfvvdoIacOkUN0cbOLKx+ZkKZa1ykqekNx7FvQu18CtnKI
 cv7ubCiqrdDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="452520787"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 14 Apr 2021 09:18:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Yongxin Liu <yongxin.liu@windriver.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 2/3] ixgbe: fix unbalanced device enable/disable in suspend/resume
Date:   Wed, 14 Apr 2021 09:20:31 -0700
Message-Id: <20210414162032.3846384-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414162032.3846384-1-anthony.l.nguyen@intel.com>
References: <20210414162032.3846384-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yongxin Liu <yongxin.liu@windriver.com>

pci_disable_device() called in __ixgbe_shutdown() decreases
dev->enable_cnt by 1. pci_enable_device_mem() which increases
dev->enable_cnt by 1, was removed from ixgbe_resume() in commit
6f82b2558735 ("ixgbe: use generic power management"). This caused
unbalanced increase/decrease. So add pci_enable_device_mem() back.

Fix the following call trace.

  ixgbe 0000:17:00.1: disabling already-disabled device
  Call Trace:
   __ixgbe_shutdown+0x10a/0x1e0 [ixgbe]
   ixgbe_suspend+0x32/0x70 [ixgbe]
   pci_pm_suspend+0x87/0x160
   ? pci_pm_freeze+0xd0/0xd0
   dpm_run_callback+0x42/0x170
   __device_suspend+0x114/0x460
   async_suspend+0x1f/0xa0
   async_run_entry_fn+0x3c/0xf0
   process_one_work+0x1dd/0x410
   worker_thread+0x34/0x3f0
   ? cancel_delayed_work+0x90/0x90
   kthread+0x14c/0x170
   ? kthread_park+0x90/0x90
   ret_from_fork+0x1f/0x30

Fixes: 6f82b2558735 ("ixgbe: use generic power management")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 45d2c8f37c01..cffb95f8f632 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6899,6 +6899,11 @@ static int __maybe_unused ixgbe_resume(struct device *dev_d)
 
 	adapter->hw.hw_addr = adapter->io_addr;
 
+	err = pci_enable_device_mem(pdev);
+	if (err) {
+		e_dev_err("Cannot enable PCI device from suspend\n");
+		return err;
+	}
 	smp_mb__before_atomic();
 	clear_bit(__IXGBE_DISABLED, &adapter->state);
 	pci_set_master(pdev);
-- 
2.26.2

