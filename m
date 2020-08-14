Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BD2244F3A
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 22:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgHNUhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 16:37:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:30571 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgHNUhA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 16:37:00 -0400
IronPort-SDR: fQlDBoy8G90Jtx29b3zv/Zzb6VGoy3/zh5MXQJi1mKg+tU6l3z+4O2+poOu9sKK2p98u/BgWwZ
 xwwzUSIvxyTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9713"; a="239311225"
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="239311225"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 13:36:58 -0700
IronPort-SDR: V8pCPnDa/9xkc+pqtpayOTKd2fmAYFiu9JXTwifPmPw3rEn3el0KNorvg9iHk5erVyj1sCpgov
 qf6YMQsa15zg==
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="318996892"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 13:36:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net 3/3] i40e: Fix crash during removing i40e driver
Date:   Fri, 14 Aug 2020 13:36:43 -0700
Message-Id: <20200814203643.186034-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200814203643.186034-1-anthony.l.nguyen@intel.com>
References: <20200814203643.186034-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>

Fix the reason of crashing system by add waiting time to finish reset
recovery process before starting remove driver procedure.
Now VSI is releasing if VSI is not in reset recovery mode.
Without this fix it was possible to start remove driver if other
processing command need reset recovery procedure which resulted in
null pointer dereference. VSI used by the ethtool process has been
cleared by remove driver process.

[ 6731.508665] BUG: kernel NULL pointer dereference, address: 0000000000000000
[ 6731.508668] #PF: supervisor read access in kernel mode
[ 6731.508670] #PF: error_code(0x0000) - not-present page
[ 6731.508671] PGD 0 P4D 0
[ 6731.508674] Oops: 0000 [#1] SMP PTI
[ 6731.508679] Hardware name: Intel Corporation S2600WT2R/S2600WT2R, BIOS SE5C610.86B.01.01.0021.032120170601 03/21/2017
[ 6731.508694] RIP: 0010:i40e_down+0x252/0x310 [i40e]
[ 6731.508696] Code: c7 78 de fa c0 e8 61 02 3a c1 66 83 bb f6 0c 00 00 00 0f 84 bf 00 00 00 45 31 e4 45 31 ff eb 03 41 89 c7 48 8b 83 98 0c 00 00 <4a> 8b 3c 20 e8 a5 79 02 00 48 83 bb d0 0c 00 00 00 74 10 48 8b 83
[ 6731.508698] RSP: 0018:ffffb75ac7b3faf0 EFLAGS: 00010246
[ 6731.508700] RAX: 0000000000000000 RBX: ffff9c9874bd5000 RCX: 0000000000000007
[ 6731.508701] RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffff9c987f4d9780
[ 6731.508703] RBP: ffffb75ac7b3fb30 R08: 0000000000005b60 R09: 0000000000000004
[ 6731.508704] R10: ffffb75ac64fbd90 R11: 0000000000000001 R12: 0000000000000000
[ 6731.508706] R13: ffff9c97a08e0000 R14: ffff9c97a08e0a68 R15: 0000000000000000
[ 6731.508708] FS:  00007f2617cd2740(0000) GS:ffff9c987f4c0000(0000) knlGS:0000000000000000
[ 6731.508710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6731.508711] CR2: 0000000000000000 CR3: 0000001e765c4006 CR4: 00000000003606e0
[ 6731.508713] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6731.508714] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 6731.508715] Call Trace:
[ 6731.508734]  i40e_vsi_close+0x84/0x90 [i40e]
[ 6731.508742]  i40e_quiesce_vsi.part.98+0x3c/0x40 [i40e]
[ 6731.508749]  i40e_pf_quiesce_all_vsi+0x55/0x60 [i40e]
[ 6731.508757]  i40e_prep_for_reset+0x59/0x130 [i40e]
[ 6731.508765]  i40e_reconfig_rss_queues+0x5a/0x120 [i40e]
[ 6731.508774]  i40e_set_channels+0xda/0x170 [i40e]
[ 6731.508778]  ethtool_set_channels+0xe9/0x150
[ 6731.508781]  dev_ethtool+0x1b94/0x2920
[ 6731.508805]  dev_ioctl+0xc2/0x590
[ 6731.508811]  sock_do_ioctl+0xae/0x150
[ 6731.508813]  sock_ioctl+0x34f/0x3c0
[ 6731.508821]  ksys_ioctl+0x98/0xb0
[ 6731.508828]  __x64_sys_ioctl+0x1a/0x20
[ 6731.508831]  do_syscall_64+0x57/0x1c0
[ 6731.508835]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 4b8164467b85 ("Add common function for finding VSI by type")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b5399357a667..2e433fdbf2c3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15463,6 +15463,9 @@ static void i40e_remove(struct pci_dev *pdev)
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(0), 0);
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(1), 0);
 
+	while (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state))
+		usleep_range(1000, 2000);
+
 	/* no more scheduling of any task */
 	set_bit(__I40E_SUSPENDED, pf->state);
 	set_bit(__I40E_DOWN, pf->state);
-- 
2.26.2

