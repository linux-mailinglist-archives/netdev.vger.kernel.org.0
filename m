Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF726838C5
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjAaVhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjAaVhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:37:16 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904EF4F867;
        Tue, 31 Jan 2023 13:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675201034; x=1706737034;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=unR+WmUmK4VBozwVw3gzpldtKBQSpmVNCR5q+ctu9Kc=;
  b=OQvzluTCe/5Ir6+zqGJgp+Kk+iE2KQNnDC8kGVPJMR0haa+GwDKmZYTM
   CzCpkKW+tdyvZA95zsvy+S3/7Y3BvpOAgNsCDNTqFCvHr0iUMogrunokU
   OAn0GeXc61R/1EdYe1nhEoSLoowjNYej852rsJac/kzMmtTH3Xj62WKkQ
   kqk0waQgiIzctKRfE/W2teUqC+isDagJM1g+TrQo2tLPpD1P/IPe6kfwF
   fGrjlO4SUvwkcUANHMHtttg43qmDcWg25IMhsF68YKqnPD0S3e8xU8kXi
   EDK5X9rhXRFoVCgp1Idc9X3KEV55eW9MFcCKtgdXE06av8u+0qewhkNwz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="327980284"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="327980284"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 13:37:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="910063010"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="910063010"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 31 Jan 2023 13:37:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        shiraz.saleem@intel.com, mustafa.ismail@intel.com, jgg@nvidia.com,
        leonro@nvidia.com, linux-rdma@vger.kernel.org,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Jakub Andrysiak <jakub.andrysiak@intel.com>
Subject: [PATCH net 2/6] ice: Do not use WQ_MEM_RECLAIM flag for workqueue
Date:   Tue, 31 Jan 2023 13:36:59 -0800
Message-Id: <20230131213703.1347761-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

When both ice and the irdma driver are loaded, a warning in
check_flush_dependency is being triggered. This is due to ice driver
workqueue being allocated with the WQ_MEM_RECLAIM flag and the irdma one
is not.

According to kernel documentation, this flag should be set if the
workqueue will be involved in the kernel's memory reclamation flow.
Since it is not, there is no need for the ice driver's WQ to have this
flag set so remove it.

Example trace:

[  +0.000004] workqueue: WQ_MEM_RECLAIM ice:ice_service_task [ice] is flushing !WQ_MEM_RECLAIM infiniband:0x0
[  +0.000139] WARNING: CPU: 0 PID: 728 at kernel/workqueue.c:2632 check_flush_dependency+0x178/0x1a0
[  +0.000011] Modules linked in: bonding tls xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_cha
in_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink bridge stp llc rfkill vfat fat intel_rapl_msr intel
_rapl_common isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct1
0dif_pclmul crc32_pclmul ghash_clmulni_intel rapl intel_cstate rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_
core_mod ib_iser libiscsi scsi_transport_iscsi rdma_cm ib_cm iw_cm iTCO_wdt iTCO_vendor_support ipmi_ssif irdma mei_me ib_uverbs
ib_core intel_uncore joydev pcspkr i2c_i801 acpi_ipmi mei lpc_ich i2c_smbus intel_pch_thermal ioatdma ipmi_si acpi_power_meter
acpi_pad xfs libcrc32c sd_mod t10_pi crc64_rocksoft crc64 sg ahci ixgbe libahci ice i40e igb crc32c_intel mdio i2c_algo_bit liba
ta dca wmi dm_mirror dm_region_hash dm_log dm_mod ipmi_devintf ipmi_msghandler fuse
[  +0.000161]  [last unloaded: bonding]
[  +0.000006] CPU: 0 PID: 728 Comm: kworker/0:2 Tainted: G S                 6.2.0-rc2_next-queue-13jan-00458-gc20aabd57164 #1
[  +0.000006] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0010.010620200716 01/06/2020
[  +0.000003] Workqueue: ice ice_service_task [ice]
[  +0.000127] RIP: 0010:check_flush_dependency+0x178/0x1a0
[  +0.000005] Code: 89 8e 02 01 e8 49 3d 40 00 49 8b 55 18 48 8d 8d d0 00 00 00 48 8d b3 d0 00 00 00 4d 89 e0 48 c7 c7 e0 3b 08
9f e8 bb d3 07 01 <0f> 0b e9 be fe ff ff 80 3d 24 89 8e 02 00 0f 85 6b ff ff ff e9 06
[  +0.000004] RSP: 0018:ffff88810a39f990 EFLAGS: 00010282
[  +0.000005] RAX: 0000000000000000 RBX: ffff888141bc2400 RCX: 0000000000000000
[  +0.000004] RDX: 0000000000000001 RSI: dffffc0000000000 RDI: ffffffffa1213a80
[  +0.000003] RBP: ffff888194bf3400 R08: ffffed117b306112 R09: ffffed117b306112
[  +0.000003] R10: ffff888bd983088b R11: ffffed117b306111 R12: 0000000000000000
[  +0.000003] R13: ffff888111f84d00 R14: ffff88810a3943ac R15: ffff888194bf3400
[  +0.000004] FS:  0000000000000000(0000) GS:ffff888bd9800000(0000) knlGS:0000000000000000
[  +0.000003] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.000003] CR2: 000056035b208b60 CR3: 000000017795e005 CR4: 00000000007706f0
[  +0.000003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  +0.000003] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  +0.000002] PKRU: 55555554
[  +0.000003] Call Trace:
[  +0.000002]  <TASK>
[  +0.000003]  __flush_workqueue+0x203/0x840
[  +0.000006]  ? mutex_unlock+0x84/0xd0
[  +0.000008]  ? __pfx_mutex_unlock+0x10/0x10
[  +0.000004]  ? __pfx___flush_workqueue+0x10/0x10
[  +0.000006]  ? mutex_lock+0xa3/0xf0
[  +0.000005]  ib_cache_cleanup_one+0x39/0x190 [ib_core]
[  +0.000174]  __ib_unregister_device+0x84/0xf0 [ib_core]
[  +0.000094]  ib_unregister_device+0x25/0x30 [ib_core]
[  +0.000093]  irdma_ib_unregister_device+0x97/0xc0 [irdma]
[  +0.000064]  ? __pfx_irdma_ib_unregister_device+0x10/0x10 [irdma]
[  +0.000059]  ? up_write+0x5c/0x90
[  +0.000005]  irdma_remove+0x36/0x90 [irdma]
[  +0.000062]  auxiliary_bus_remove+0x32/0x50
[  +0.000007]  device_release_driver_internal+0xfa/0x1c0
[  +0.000005]  bus_remove_device+0x18a/0x260
[  +0.000007]  device_del+0x2e5/0x650
[  +0.000005]  ? __pfx_device_del+0x10/0x10
[  +0.000003]  ? mutex_unlock+0x84/0xd0
[  +0.000004]  ? __pfx_mutex_unlock+0x10/0x10
[  +0.000004]  ? _raw_spin_unlock+0x18/0x40
[  +0.000005]  ice_unplug_aux_dev+0x52/0x70 [ice]
[  +0.000160]  ice_service_task+0x1309/0x14f0 [ice]
[  +0.000134]  ? __pfx___schedule+0x10/0x10
[  +0.000006]  process_one_work+0x3b1/0x6c0
[  +0.000008]  worker_thread+0x69/0x670
[  +0.000005]  ? __kthread_parkme+0xec/0x110
[  +0.000007]  ? __pfx_worker_thread+0x10/0x10
[  +0.000005]  kthread+0x17f/0x1b0
[  +0.000005]  ? __pfx_kthread+0x10/0x10
[  +0.000004]  ret_from_fork+0x29/0x50
[  +0.000009]  </TASK>

Fixes: 940b61af02f4 ("ice: Initialize PF and setup miscellaneous interrupt")
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Jakub Andrysiak <jakub.andrysiak@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 055494dbcce0..8b81e661a0c9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5538,7 +5538,7 @@ static int __init ice_module_init(void)
 	pr_info("%s\n", ice_driver_string);
 	pr_info("%s\n", ice_copyright);
 
-	ice_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0, KBUILD_MODNAME);
+	ice_wq = alloc_workqueue("%s", 0, 0, KBUILD_MODNAME);
 	if (!ice_wq) {
 		pr_err("Failed to create workqueue\n");
 		return -ENOMEM;
-- 
2.38.1

