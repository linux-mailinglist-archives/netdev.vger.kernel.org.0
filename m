Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B7046A4BA
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245446AbhLFSj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:39:58 -0500
Received: from mga05.intel.com ([192.55.52.43]:31032 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243627AbhLFSj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 13:39:58 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="323631992"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="323631992"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 10:36:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="461943027"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Dec 2021 10:36:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net v2 1/5] iavf: restore MSI state on reset
Date:   Mon,  6 Dec 2021 10:35:15 -0800
Message-Id: <20211206183519.2733180-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211206183519.2733180-1-anthony.l.nguyen@intel.com>
References: <20211206183519.2733180-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

If the PF experiences an FLR, the VF's MSI and MSI-X configuration will
be conveniently and silently removed in the process. When this happens,
reset recovery will appear to complete normally but no traffic will
pass. The netdev watchdog will helpfully notify everyone of this issue.

To prevent such public embarrassment, restore MSI configuration at every
reset. For normal resets, this will do no harm, but for VF resets
resulting from a PF FLR, this will keep the VF working.

Fixes: 5eae00c57f5e ("i40evf: main driver core")
Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 14934a7a13ef..cfdbf8c08d18 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2248,6 +2248,7 @@ static void iavf_reset_task(struct work_struct *work)
 	}
 
 	pci_set_master(adapter->pdev);
+	pci_restore_msi_state(adapter->pdev);
 
 	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
 		dev_err(&adapter->pdev->dev, "Reset never finished (%x)\n",
-- 
2.31.1

