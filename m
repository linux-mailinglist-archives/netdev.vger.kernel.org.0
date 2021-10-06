Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189B6424396
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbhJFRBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:01:48 -0400
Received: from mga12.intel.com ([192.55.52.136]:34614 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239430AbhJFRBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 13:01:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="206167854"
X-IronPort-AV: E=Sophos;i="5.85,352,1624345200"; 
   d="scan'208";a="206167854"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2021 09:59:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,352,1624345200"; 
   d="scan'208";a="439189032"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Oct 2021 09:58:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, PJ Waskiewicz <pwaskiewicz@jumptrading.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 2/3] i40e: Fix freeing of uninitialized misc IRQ vector
Date:   Wed,  6 Oct 2021 09:56:58 -0700
Message-Id: <20211006165659.2298400-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006165659.2298400-1-anthony.l.nguyen@intel.com>
References: <20211006165659.2298400-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

When VSI set up failed in i40e_probe() as part of PF switch set up
driver was trying to free misc IRQ vectors in
i40e_clear_interrupt_scheme and produced a kernel Oops:

   Trying to free already-free IRQ 266
   WARNING: CPU: 0 PID: 5 at kernel/irq/manage.c:1731 __free_irq+0x9a/0x300
   Workqueue: events work_for_cpu_fn
   RIP: 0010:__free_irq+0x9a/0x300
   Call Trace:
   ? synchronize_irq+0x3a/0xa0
   free_irq+0x2e/0x60
   i40e_clear_interrupt_scheme+0x53/0x190 [i40e]
   i40e_probe.part.108+0x134b/0x1a40 [i40e]
   ? kmem_cache_alloc+0x158/0x1c0
   ? acpi_ut_update_ref_count.part.1+0x8e/0x345
   ? acpi_ut_update_object_reference+0x15e/0x1e2
   ? strstr+0x21/0x70
   ? irq_get_irq_data+0xa/0x20
   ? mp_check_pin_attr+0x13/0xc0
   ? irq_get_irq_data+0xa/0x20
   ? mp_map_pin_to_irq+0xd3/0x2f0
   ? acpi_register_gsi_ioapic+0x93/0x170
   ? pci_conf1_read+0xa4/0x100
   ? pci_bus_read_config_word+0x49/0x70
   ? do_pci_enable_device+0xcc/0x100
   local_pci_probe+0x41/0x90
   work_for_cpu_fn+0x16/0x20
   process_one_work+0x1a7/0x360
   worker_thread+0x1cf/0x390
   ? create_worker+0x1a0/0x1a0
   kthread+0x112/0x130
   ? kthread_flush_work_fn+0x10/0x10
   ret_from_fork+0x1f/0x40

The problem is that at that point misc IRQ vectors
were not allocated yet and we get a call trace
that driver is trying to free already free IRQ vectors.

Add a check in i40e_clear_interrupt_scheme for __I40E_MISC_IRQ_REQUESTED
PF state before calling i40e_free_misc_vector. This state is set only if
misc IRQ vectors were properly initialized.

Fixes: c17401a1dd21 ("i40e: use separate state bit for miscellaneous IRQ setup")
Reported-by: PJ Waskiewicz <pwaskiewicz@jumptrading.com>
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b5b984754ec9..e04b540cedc8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4871,7 +4871,8 @@ static void i40e_clear_interrupt_scheme(struct i40e_pf *pf)
 {
 	int i;
 
-	i40e_free_misc_vector(pf);
+	if (test_bit(__I40E_MISC_IRQ_REQUESTED, pf->state))
+		i40e_free_misc_vector(pf);
 
 	i40e_put_lump(pf->irq_pile, pf->iwarp_base_vector,
 		      I40E_IWARP_IRQ_PILE_ID);
-- 
2.31.1

