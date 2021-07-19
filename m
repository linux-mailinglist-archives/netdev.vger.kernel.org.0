Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E55C3CE5F5
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 18:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348761AbhGSPzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 11:55:40 -0400
Received: from mga17.intel.com ([192.55.52.151]:56311 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349219AbhGSPuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 11:50:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="191369966"
X-IronPort-AV: E=Sophos;i="5.84,252,1620716400"; 
   d="scan'208";a="191369966"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 09:28:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,252,1620716400"; 
   d="scan'208";a="631955284"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 19 Jul 2021 09:28:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 2/3] iavf: do not override the adapter state in the watchdog task
Date:   Mon, 19 Jul 2021 09:31:53 -0700
Message-Id: <20210719163154.986679-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210719163154.986679-1-anthony.l.nguyen@intel.com>
References: <20210719163154.986679-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

The iavf watchdog task overrides adapter->state to __IAVF_RESETTING
when it detects a pending reset. Then schedules iavf_reset_task() which
takes care of the reset.

The reset task is capable of handling the reset without changing
adapter->state. In fact we lose the state information when the watchdog
task prematurely changes the adapter state. This may lead to a crash if
instead of the reset task the iavf_remove() function gets called before
the reset task.
In that case (if we were in state __IAVF_RUNNING previously) the
iavf_remove() function triggers iavf_close() which fails to close the
device because of the incorrect state information.

This may result in a crash due to pending interrupts.
kernel BUG at drivers/pci/msi.c:357!
[...]
Call Trace:
 [<ffffffffbddf24dd>] pci_disable_msix+0x3d/0x50
 [<ffffffffc08d2a63>] iavf_reset_interrupt_capability+0x23/0x40 [iavf]
 [<ffffffffc08d312a>] iavf_remove+0x10a/0x350 [iavf]
 [<ffffffffbddd3359>] pci_device_remove+0x39/0xc0
 [<ffffffffbdeb492f>] __device_release_driver+0x7f/0xf0
 [<ffffffffbdeb49c3>] device_release_driver+0x23/0x30
 [<ffffffffbddcabb4>] pci_stop_bus_device+0x84/0xa0
 [<ffffffffbddcacc2>] pci_stop_and_remove_bus_device+0x12/0x20
 [<ffffffffbddf361f>] pci_iov_remove_virtfn+0xaf/0x160
 [<ffffffffbddf3bcc>] sriov_disable+0x3c/0xf0
 [<ffffffffbddf3ca3>] pci_disable_sriov+0x23/0x30
 [<ffffffffc0667365>] i40e_free_vfs+0x265/0x2d0 [i40e]
 [<ffffffffc0667624>] i40e_pci_sriov_configure+0x144/0x1f0 [i40e]
 [<ffffffffbddd5307>] sriov_numvfs_store+0x177/0x1d0
Code: 00 00 e8 3c 25 e3 ff 49 c7 86 88 08 00 00 00 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 8b 7b 28 e8 0d 44
RIP  [<ffffffffbbbf1068>] free_msi_irqs+0x188/0x190

The solution is to not touch the adapter->state in iavf_watchdog_task()
and let the reset task handle the state transition.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 44bafedd09f2..44cadf4ebb24 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1988,7 +1988,6 @@ static void iavf_watchdog_task(struct work_struct *work)
 		/* check for hw reset */
 	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
 	if (!reg_val) {
-		adapter->state = __IAVF_RESETTING;
 		adapter->flags |= IAVF_FLAG_RESET_PENDING;
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-- 
2.26.2

