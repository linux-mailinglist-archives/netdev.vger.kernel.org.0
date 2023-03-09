Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13F56B2D17
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 19:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjCISqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 13:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCISql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 13:46:41 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F11FA8C2
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 10:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678387590; x=1709923590;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UfpSmpps+208/PXu1Y2qLyM1fk0INH595Zg2fe+B5qI=;
  b=nDVQFeQ7EAbRKcLAx/smLCNANNljCq6Cu8J9iAQhihkNoJGUwfjT7FY2
   UbskEEnnINmOhtGZsU+Y88uExiKK89MeJlj1KbEuCirSMlEoUu8yDFCxZ
   le/vyar6AWjjvrjQCAs07JZSbMHCzX0ix6+Q7styjFEdqSzloDuLs7wVK
   JjbX/y27Mn4S0O+KUbG50zTIxjR0/ZeP6ZqJg9nJjvijT/N+3YHoCLIRB
   Ro2Q1LIF+B/fbSPAs3tuwDpv5Db7Sg7Zfkve0dSvnLM1sbknLHh9CLaPU
   6aO2Ic637ZAlrcteSvepbSWPGpRTxJlhR9KRHFBLQMIxLbKn0fESjCR6h
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="336548682"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="336548682"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 10:46:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="820734112"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="820734112"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 09 Mar 2023 10:46:30 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Ivan Vecera <ivecera@redhat.com>, anthony.l.nguyen@intel.com,
        Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net 1/1] i40e: Fix kernel crash during reboot when adapter is in recovery mode
Date:   Thu,  9 Mar 2023 10:45:09 -0800
Message-Id: <20230309184509.984639-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
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

From: Ivan Vecera <ivecera@redhat.com>

If the driver detects during probe that firmware is in recovery
mode then i40e_init_recovery_mode() is called and the rest of
probe function is skipped including pci_set_drvdata(). Subsequent
i40e_shutdown() called during shutdown/reboot dereferences NULL
pointer as pci_get_drvdata() returns NULL.

To fix call pci_set_drvdata() also during entering to recovery mode.

Reproducer:
1) Lets have i40e NIC with firmware in recovery mode
2) Run reboot

Result:
[  139.084698] i40e: Intel(R) Ethernet Connection XL710 Network Driver
[  139.090959] i40e: Copyright (c) 2013 - 2019 Intel Corporation.
[  139.108438] i40e 0000:02:00.0: Firmware recovery mode detected. Limiting functionality.
[  139.116439] i40e 0000:02:00.0: Refer to the Intel(R) Ethernet Adapters and Devices User Guide for details on firmware recovery mode.
[  139.129499] i40e 0000:02:00.0: fw 8.3.64775 api 1.13 nvm 8.30 0x8000b78d 1.3106.0 [8086:1583] [15d9:084a]
[  139.215932] i40e 0000:02:00.0 enp2s0f0: renamed from eth0
[  139.223292] i40e 0000:02:00.1: Firmware recovery mode detected. Limiting functionality.
[  139.231292] i40e 0000:02:00.1: Refer to the Intel(R) Ethernet Adapters and Devices User Guide for details on firmware recovery mode.
[  139.244406] i40e 0000:02:00.1: fw 8.3.64775 api 1.13 nvm 8.30 0x8000b78d 1.3106.0 [8086:1583] [15d9:084a]
[  139.329209] i40e 0000:02:00.1 enp2s0f1: renamed from eth0
...
[  156.311376] BUG: kernel NULL pointer dereference, address: 00000000000006c2
[  156.318330] #PF: supervisor write access in kernel mode
[  156.323546] #PF: error_code(0x0002) - not-present page
[  156.328679] PGD 0 P4D 0
[  156.331210] Oops: 0002 [#1] PREEMPT SMP NOPTI
[  156.335567] CPU: 26 PID: 15119 Comm: reboot Tainted: G            E      6.2.0+ #1
[  156.343126] Hardware name: Abacus electric, s.r.o. - servis@abacus.cz Super Server/H12SSW-iN, BIOS 2.4 04/13/2022
[  156.353369] RIP: 0010:i40e_shutdown+0x15/0x130 [i40e]
[  156.358430] Code: c1 fc ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 48 89 fd 53 48 8b 9f 48 01 00 00 <f0> 80 8b c2 06 00 00 04 f0 80 8b c0 06 00 00 08 48 8d bb 08 08 00
[  156.377168] RSP: 0018:ffffb223c8447d90 EFLAGS: 00010282
[  156.382384] RAX: ffffffffc073ee70 RBX: 0000000000000000 RCX: 0000000000000001
[  156.389510] RDX: 0000000080000001 RSI: 0000000000000246 RDI: ffff95db49988000
[  156.396634] RBP: ffff95db49988000 R08: ffffffffffffffff R09: ffffffff8bd17d40
[  156.403759] R10: 0000000000000001 R11: ffffffff8a5e3d28 R12: ffff95db49988000
[  156.410882] R13: ffffffff89a6fe17 R14: ffff95db49988150 R15: 0000000000000000
[  156.418007] FS:  00007fe7c0cc3980(0000) GS:ffff95ea8ee80000(0000) knlGS:0000000000000000
[  156.426083] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  156.431819] CR2: 00000000000006c2 CR3: 00000003092fc005 CR4: 0000000000770ee0
[  156.438944] PKRU: 55555554
[  156.441647] Call Trace:
[  156.444096]  <TASK>
[  156.446199]  pci_device_shutdown+0x38/0x60
[  156.450297]  device_shutdown+0x163/0x210
[  156.454215]  kernel_restart+0x12/0x70
[  156.457872]  __do_sys_reboot+0x1ab/0x230
[  156.461789]  ? vfs_writev+0xa6/0x1a0
[  156.465362]  ? __pfx_file_free_rcu+0x10/0x10
[  156.469635]  ? __call_rcu_common.constprop.85+0x109/0x5a0
[  156.475034]  do_syscall_64+0x3e/0x90
[  156.478611]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  156.483658] RIP: 0033:0x7fe7bff37ab7

Fixes: 4ff0ee1af016 ("i40e: Introduce recovery mode support")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 467001db5070..228cd502bb48 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15525,6 +15525,7 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
 	int err;
 	int v_idx;
 
+	pci_set_drvdata(pf->pdev, pf);
 	pci_save_state(pf->pdev);
 
 	/* set up periodic task facility */
-- 
2.38.1

