Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6936BD729
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjCPRdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjCPRdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:33:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE92B28E70;
        Thu, 16 Mar 2023 10:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678988015; x=1710524015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3UxIaxg58xCsKw9G8KMosv0BPb0tjmLTPLdeVNEv3PI=;
  b=WLY94sojsmS9h9CBkLq/sFG5Rk+RdeCw8eNBTZ11RIaoQXnwqxwJZBHj
   SkBVPPhvnxFPUg08bF39mPbgVQhjEBbntQvw8qkxMkaZ6vlw3t9XhhLRi
   UmpR6YqcaBvU8RezanFq3499Ak+fXs0qjYBGBNUGilaq48icDxEw++YTx
   9HgVmVU07fFzkFOaFWjJXDHPHNQiemTSGuhC2iL/P9q/cwwXNV0S3/8h0
   66mKXtWSnPgRvSOxyZonnfDM8AhpNuTeLiaV4OiN/kJ5jtxLau9nePC1D
   /NR3zZLypsUq96lSeCimCsI7U8TnkYzEr47bnwGwcb3IKeoKHyhEY71na
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="402948280"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="402948280"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 10:33:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="679982473"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="679982473"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 10:33:20 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, anthony.l.nguyen@intel.com,
        stable@vger.kernel.org, Corinna Vinschen <vinschen@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net 1/5] igb: revert rtnl_lock() that causes deadlock
Date:   Thu, 16 Mar 2023 10:31:40 -0700
Message-Id: <20230316173144.2003469-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230316173144.2003469-1-anthony.l.nguyen@intel.com>
References: <20230316173144.2003469-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

The commit 6faee3d4ee8b ("igb: Add lock to avoid data race") adds
rtnl_lock to eliminate a false data race shown below

 (FREE from device detaching)      |   (USE from netdev core)
igb_remove                         |  igb_ndo_get_vf_config
 igb_disable_sriov                 |  vf >= adapter->vfs_allocated_count?
  kfree(adapter->vf_data)          |
  adapter->vfs_allocated_count = 0 |
                                   |    memcpy(... adapter->vf_data[vf]

The above race will never happen and the extra rtnl_lock causes deadlock
below

[  141.420169]  <TASK>
[  141.420672]  __schedule+0x2dd/0x840
[  141.421427]  schedule+0x50/0xc0
[  141.422041]  schedule_preempt_disabled+0x11/0x20
[  141.422678]  __mutex_lock.isra.13+0x431/0x6b0
[  141.423324]  unregister_netdev+0xe/0x20
[  141.423578]  igbvf_remove+0x45/0xe0 [igbvf]
[  141.423791]  pci_device_remove+0x36/0xb0
[  141.423990]  device_release_driver_internal+0xc1/0x160
[  141.424270]  pci_stop_bus_device+0x6d/0x90
[  141.424507]  pci_stop_and_remove_bus_device+0xe/0x20
[  141.424789]  pci_iov_remove_virtfn+0xba/0x120
[  141.425452]  sriov_disable+0x2f/0xf0
[  141.425679]  igb_disable_sriov+0x4e/0x100 [igb]
[  141.426353]  igb_remove+0xa0/0x130 [igb]
[  141.426599]  pci_device_remove+0x36/0xb0
[  141.426796]  device_release_driver_internal+0xc1/0x160
[  141.427060]  driver_detach+0x44/0x90
[  141.427253]  bus_remove_driver+0x55/0xe0
[  141.427477]  pci_unregister_driver+0x2a/0xa0
[  141.428296]  __x64_sys_delete_module+0x141/0x2b0
[  141.429126]  ? mntput_no_expire+0x4a/0x240
[  141.429363]  ? syscall_trace_enter.isra.19+0x126/0x1a0
[  141.429653]  do_syscall_64+0x5b/0x80
[  141.429847]  ? exit_to_user_mode_prepare+0x14d/0x1c0
[  141.430109]  ? syscall_exit_to_user_mode+0x12/0x30
[  141.430849]  ? do_syscall_64+0x67/0x80
[  141.431083]  ? syscall_exit_to_user_mode_prepare+0x183/0x1b0
[  141.431770]  ? syscall_exit_to_user_mode+0x12/0x30
[  141.432482]  ? do_syscall_64+0x67/0x80
[  141.432714]  ? exc_page_fault+0x64/0x140
[  141.432911]  entry_SYSCALL_64_after_hwframe+0x72/0xdc

Since the igb_disable_sriov() will call pci_disable_sriov() before
releasing any resources, the netdev core will synchronize the cleanup to
avoid any races. This patch removes the useless rtnl_(un)lock to guarantee
correctness.

CC: stable@vger.kernel.org
Fixes: 6faee3d4ee8b ("igb: Add lock to avoid data race")
Reported-by: Corinna Vinschen <vinschen@redhat.com>
Link: https://lore.kernel.org/intel-wired-lan/ZAcJvkEPqWeJHO2r@calimero.vinschen.de/
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Tested-by: Corinna Vinschen <vinschen@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 03bc1e8af575..5532361b0e94 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3863,9 +3863,7 @@ static void igb_remove(struct pci_dev *pdev)
 	igb_release_hw_control(adapter);
 
 #ifdef CONFIG_PCI_IOV
-	rtnl_lock();
 	igb_disable_sriov(pdev);
-	rtnl_unlock();
 #endif
 
 	unregister_netdev(netdev);
-- 
2.38.1

