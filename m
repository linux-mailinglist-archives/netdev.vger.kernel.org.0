Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259F56C3944
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjCUShn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCUShm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:37:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCDF50993
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679423861; x=1710959861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4E+paUSytH8dUOeQMhUsIcCaTg/TXhaWS5zlAENzR8U=;
  b=NIdObBhQ6g40OpYzrp0EJds6GZPW+n3A+pJ+hkUdycxsrIUhz/lRUDXe
   jKa77WhL2jczp9cihtAszP3zXD+ljiDPjVSqvfOvYoi1zaj5WDu9tAQem
   yz6e8UAdfYPaHZPtGzVLohXBA2uu6E/ClnLXl+ETLz8rlyVSK4fNGjvbV
   0oRlkYto4GOrMAffoOIs2PC1cW1Hy39STN7xy0sCyCaPO1lmWynBYRVTs
   zpIRDyf5R1rfSSXfoSOksY77PITKmFM172TZOo4FXHmI0ho2UjxvdzqkL
   eZztJV2XQ8CyIiJCa3/7Uhm7U6dSr98ZoURLmkawDY31rG3EcLaBp++/L
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="319420499"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="319420499"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 11:37:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="711922459"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="711922459"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga008.jf.intel.com with ESMTP; 21 Mar 2023 11:37:37 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>, anthony.l.nguyen@intel.com,
        Marius Cornea <mcornea@redhat.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net 1/2] iavf: fix hang on reboot with ice
Date:   Tue, 21 Mar 2023 11:35:47 -0700
Message-Id: <20230321183548.2849671-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230321183548.2849671-1-anthony.l.nguyen@intel.com>
References: <20230321183548.2849671-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

When a system with E810 with existing VFs gets rebooted the following
hang may be observed.

 Pid 1 is hung in iavf_remove(), part of a network driver:
 PID: 1        TASK: ffff965400e5a340  CPU: 24   COMMAND: "systemd-shutdow"
  #0 [ffffaad04005fa50] __schedule at ffffffff8b3239cb
  #1 [ffffaad04005fae8] schedule at ffffffff8b323e2d
  #2 [ffffaad04005fb00] schedule_hrtimeout_range_clock at ffffffff8b32cebc
  #3 [ffffaad04005fb80] usleep_range_state at ffffffff8b32c930
  #4 [ffffaad04005fbb0] iavf_remove at ffffffffc12b9b4c [iavf]
  #5 [ffffaad04005fbf0] pci_device_remove at ffffffff8add7513
  #6 [ffffaad04005fc10] device_release_driver_internal at ffffffff8af08baa
  #7 [ffffaad04005fc40] pci_stop_bus_device at ffffffff8adcc5fc
  #8 [ffffaad04005fc60] pci_stop_and_remove_bus_device at ffffffff8adcc81e
  #9 [ffffaad04005fc70] pci_iov_remove_virtfn at ffffffff8adf9429
 #10 [ffffaad04005fca8] sriov_disable at ffffffff8adf98e4
 #11 [ffffaad04005fcc8] ice_free_vfs at ffffffffc04bb2c8 [ice]
 #12 [ffffaad04005fd10] ice_remove at ffffffffc04778fe [ice]
 #13 [ffffaad04005fd38] ice_shutdown at ffffffffc0477946 [ice]
 #14 [ffffaad04005fd50] pci_device_shutdown at ffffffff8add58f1
 #15 [ffffaad04005fd70] device_shutdown at ffffffff8af05386
 #16 [ffffaad04005fd98] kernel_restart at ffffffff8a92a870
 #17 [ffffaad04005fda8] __do_sys_reboot at ffffffff8a92abd6
 #18 [ffffaad04005fee0] do_syscall_64 at ffffffff8b317159
 #19 [ffffaad04005ff08] __context_tracking_enter at ffffffff8b31b6fc
 #20 [ffffaad04005ff18] syscall_exit_to_user_mode at ffffffff8b31b50d
 #21 [ffffaad04005ff28] do_syscall_64 at ffffffff8b317169
 #22 [ffffaad04005ff50] entry_SYSCALL_64_after_hwframe at ffffffff8b40009b
     RIP: 00007f1baa5c13d7  RSP: 00007fffbcc55a98  RFLAGS: 00000202
     RAX: ffffffffffffffda  RBX: 0000000000000000  RCX: 00007f1baa5c13d7
     RDX: 0000000001234567  RSI: 0000000028121969  RDI: 00000000fee1dead
     RBP: 00007fffbcc55ca0   R8: 0000000000000000   R9: 00007fffbcc54e90
     R10: 00007fffbcc55050  R11: 0000000000000202  R12: 0000000000000005
     R13: 0000000000000000  R14: 00007fffbcc55af0  R15: 0000000000000000
     ORIG_RAX: 00000000000000a9  CS: 0033  SS: 002b

During reboot all drivers PM shutdown callbacks are invoked.
In iavf_shutdown() the adapter state is changed to __IAVF_REMOVE.
In ice_shutdown() the call chain above is executed, which at some point
calls iavf_remove(). However iavf_remove() expects the VF to be in one
of the states __IAVF_RUNNING, __IAVF_DOWN or __IAVF_INIT_FAILED. If
that's not the case it sleeps forever.
So if iavf_shutdown() gets invoked before iavf_remove() the system will
hang indefinitely because the adapter is already in state __IAVF_REMOVE.

Fix this by returning from iavf_remove() if the state is __IAVF_REMOVE,
as we already went through iavf_shutdown().

Fixes: 974578017fc1 ("iavf: Add waiting so the port is initialized in remove")
Fixes: a8417330f8a5 ("iavf: Fix race condition between iavf_shutdown and iavf_remove")
Reported-by: Marius Cornea <mcornea@redhat.com>
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 327cd9b1af2c..095201e83c9d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -5074,6 +5074,11 @@ static void iavf_remove(struct pci_dev *pdev)
 			mutex_unlock(&adapter->crit_lock);
 			break;
 		}
+		/* Simply return if we already went through iavf_shutdown */
+		if (adapter->state == __IAVF_REMOVE) {
+			mutex_unlock(&adapter->crit_lock);
+			return;
+		}
 
 		mutex_unlock(&adapter->crit_lock);
 		usleep_range(500, 1000);
-- 
2.38.1

