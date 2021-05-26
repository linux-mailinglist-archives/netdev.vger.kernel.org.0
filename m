Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA2A391DFE
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhEZRYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:24:04 -0400
Received: from mga07.intel.com ([134.134.136.100]:18184 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234556AbhEZRXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 13:23:48 -0400
IronPort-SDR: LJckDxnIc19oS/SkXuvgR2G4gFSn05W8ulNlyfIjdrGibXU2f5/7livbTo1GGmm/YLfnLv5GFZ
 iDWt3XNwnibA==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="266415784"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="266415784"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 10:21:26 -0700
IronPort-SDR: sPL8B+wIMiydbkCYNMlJVK1TmayVqrfxj7PnbfCuxbJjJ68oPSs71o6BEVDki1nrZOUquJGDv2
 6UWqp2HSlM6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="443149198"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 26 May 2021 10:21:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 03/11] fm10k: move error check
Date:   Wed, 26 May 2021 10:23:38 -0700
Message-Id: <20210526172346.3515587-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
References: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The error check and set_bit are placed in such a way that sparse (C=2)
warns:
.../fm10k_pci.c:1395:9: warning: context imbalance in 'fm10k_msix_mbx_pf' - different lock contexts for basic block

Which seems a little odd, but the code can obviously be moved
to where the variable is being set without changing functionality
at all, and it even seems to make a bit more sense with the check
closer to the set.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index 9e3103fae723..dbcae92bb18d 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -1370,7 +1370,6 @@ static irqreturn_t fm10k_msix_mbx_pf(int __always_unused irq, void *data)
 	struct fm10k_hw *hw = &interface->hw;
 	struct fm10k_mbx_info *mbx = &hw->mbx;
 	u32 eicr;
-	s32 err = 0;
 
 	/* unmask any set bits related to this interrupt */
 	eicr = fm10k_read_reg(hw, FM10K_EICR);
@@ -1386,15 +1385,16 @@ static irqreturn_t fm10k_msix_mbx_pf(int __always_unused irq, void *data)
 
 	/* service mailboxes */
 	if (fm10k_mbx_trylock(interface)) {
-		err = mbx->ops.process(hw, mbx);
+		s32 err = mbx->ops.process(hw, mbx);
+
+		if (err == FM10K_ERR_RESET_REQUESTED)
+			set_bit(FM10K_FLAG_RESET_REQUESTED, interface->flags);
+
 		/* handle VFLRE events */
 		fm10k_iov_event(interface);
 		fm10k_mbx_unlock(interface);
 	}
 
-	if (err == FM10K_ERR_RESET_REQUESTED)
-		set_bit(FM10K_FLAG_RESET_REQUESTED, interface->flags);
-
 	/* if switch toggled state we should reset GLORTs */
 	if (eicr & FM10K_EICR_SWITCHNOTREADY) {
 		/* force link down for at least 4 seconds */
-- 
2.26.2

