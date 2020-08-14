Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01F8244FCE
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 00:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgHNWSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 18:18:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:20045 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgHNWSA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 18:18:00 -0400
IronPort-SDR: B8b6wZ7Meyk0l8USzb6rlnT+i6gGo+8yXjEWvekTQWDvgmWMxbEinXpbgf7eynAUfVHA4mycM3
 5eeVxefOriaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9713"; a="172545045"
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="172545045"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 15:17:58 -0700
IronPort-SDR: 6iK7bMJ2H7hkvbRJF5vxbuIAu0wA8488akGZkXVMTvtM3LlBTvdFlJ5fiU85y0haRhgPCe/pq1
 NWcYE6AcHmYQ==
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="291857047"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 15:17:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andre Guedes <andre.guedes@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net v2 1/3] igc: Fix PTP initialization
Date:   Fri, 14 Aug 2020 15:17:43 -0700
Message-Id: <20200814221745.666974-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200814221745.666974-1-anthony.l.nguyen@intel.com>
References: <20200814221745.666974-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Right now, igc_ptp_reset() is called from igc_reset(), which is called
from igc_probe() before igc_ptp_init() has a chance to run. It is
detected as an attempt to use an spinlock without registering its key
first. See log below.

To avoid this problem, simplify the initialization: igc_ptp_init() is
only called from igc_probe(), and igc_ptp_reset() is only called from
igc_reset().

[    2.736332] INFO: trying to register non-static key.
[    2.736902] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1f.3/sound/card0/input10
[    2.737513] the code is fine but needs lockdep annotation.
[    2.737513] turning off the locking correctness validator.
[    2.737515] CPU: 8 PID: 239 Comm: systemd-udevd Tainted: G            E     5.8.0-rc7+ #13
[    2.737515] Hardware name: Gigabyte Technology Co., Ltd. Z390 AORUS ULTRA/Z390 AORUS ULTRA-CF, BIOS F7 03/14/2019
[    2.737516] Call Trace:
[    2.737521]  dump_stack+0x78/0xa0
[    2.737524]  register_lock_class+0x6b1/0x6f0
[    2.737526]  ? lockdep_hardirqs_on_prepare+0xca/0x160
[    2.739177]  ? _raw_spin_unlock_irq+0x24/0x50
[    2.739179]  ? trace_hardirqs_on+0x1c/0xf0
[    2.740820]  __lock_acquire+0x56/0x1ff0
[    2.740823]  ? __schedule+0x30c/0x970
[    2.740825]  lock_acquire+0x97/0x3e0
[    2.740830]  ? igc_ptp_reset+0x35/0xf0 [igc]
[    2.740833]  ? schedule_hrtimeout_range_clock+0xb7/0x120
[    2.742507]  _raw_spin_lock_irqsave+0x3a/0x50
[    2.742512]  ? igc_ptp_reset+0x35/0xf0 [igc]
[    2.742515]  igc_ptp_reset+0x35/0xf0 [igc]
[    2.742519]  igc_reset+0x96/0xd0 [igc]
[    2.744148]  igc_probe+0x68f/0x7d0 [igc]
[    2.745796]  local_pci_probe+0x3d/0x70
[    2.745799]  pci_device_probe+0xd1/0x190
[    2.745802]  really_probe+0x15a/0x3f0
[    2.759936]  driver_probe_device+0xe1/0x150
[    2.759937]  device_driver_attach+0xa8/0xb0
[    2.761786]  __driver_attach+0x89/0x150
[    2.761786]  ? device_driver_attach+0xb0/0xb0
[    2.761787]  ? device_driver_attach+0xb0/0xb0
[    2.761788]  bus_for_each_dev+0x66/0x90
[    2.765012]  bus_add_driver+0x12e/0x1f0
[    2.765716]  driver_register+0x8b/0xe0
[    2.766418]  ? 0xffffffffc0230000
[    2.767119]  do_one_initcall+0x5a/0x310
[    2.767826]  ? kmem_cache_alloc_trace+0xe9/0x200
[    2.768528]  do_init_module+0x5c/0x260
[    2.769206]  __do_sys_finit_module+0x93/0xe0
[    2.770048]  do_syscall_64+0x46/0xa0
[    2.770716]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    2.771396] RIP: 0033:0x7f83534589e0
[    2.772073] Code: 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 2e 2e 2e 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 80 24 0d 00 f7 d8 64 89 01 48
[    2.772074] RSP: 002b:00007ffd31d0ed18 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    2.774854] RAX: ffffffffffffffda RBX: 000055d52816aba0 RCX: 00007f83534589e0
[    2.774855] RDX: 0000000000000000 RSI: 00007f83535b982f RDI: 0000000000000006
[    2.774855] RBP: 00007ffd31d0ed60 R08: 0000000000000000 R09: 00007ffd31d0ed30
[    2.774856] R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000000
[    2.774856] R13: 0000000000020000 R14: 00007f83535b982f R15: 000055d527f5e120

Fixes: 5f2958052c58 ("igc: Add basic skeleton for PTP")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 5 ++---
 drivers/net/ethernet/intel/igc/igc_ptp.c  | 2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7a6f2a0d413f..9593aa4eea36 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5142,6 +5142,8 @@ static int igc_probe(struct pci_dev *pdev,
 	device_set_wakeup_enable(&adapter->pdev->dev,
 				 adapter->flags & IGC_FLAG_WOL_SUPPORTED);
 
+	igc_ptp_init(adapter);
+
 	/* reset the hardware with the new settings */
 	igc_reset(adapter);
 
@@ -5158,9 +5160,6 @@ static int igc_probe(struct pci_dev *pdev,
 	 /* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
 
-	/* do hw tstamp init after resetting */
-	igc_ptp_init(adapter);
-
 	/* Check if Media Autosense is enabled */
 	adapter->ei = *ei;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index e67d4655b47e..36c999250fcc 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -496,8 +496,6 @@ void igc_ptp_init(struct igc_adapter *adapter)
 	adapter->tstamp_config.rx_filter = HWTSTAMP_FILTER_NONE;
 	adapter->tstamp_config.tx_type = HWTSTAMP_TX_OFF;
 
-	igc_ptp_reset(adapter);
-
 	adapter->ptp_clock = ptp_clock_register(&adapter->ptp_caps,
 						&adapter->pdev->dev);
 	if (IS_ERR(adapter->ptp_clock)) {
-- 
2.26.2

