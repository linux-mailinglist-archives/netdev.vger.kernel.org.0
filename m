Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBAF439E06
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhJYR7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:59:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:30381 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230398AbhJYR7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:59:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10148"; a="229575734"
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="229575734"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 10:56:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="554291195"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 25 Oct 2021 10:56:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Caleb Sander <csander@purestorage.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Joern Engel <joern@purestorage.com>,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 1/4] i40e: avoid spin loop in i40e_asq_send_command()
Date:   Mon, 25 Oct 2021 10:55:05 -0700
Message-Id: <20211025175508.1461435-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Caleb Sander <csander@purestorage.com>

Previously, the kernel could spend up to 250 ms waiting for a command to
be submitted to an admin queue. This function is also called in a loop,
e.g., in i40e_get_module_eeprom() (through i40e_aq_get_phy_register()),
so the time spent in the kernel may be even higher. We observed
scheduling delays of over 2 seconds in production,
with stacktraces pointing to this code as the culprit.

Add a call to cond_resched() so the loop can yield the CPU.
Also compute the total time using the jiffies counter
instead of assuming udelay() waits the precise time interval requested.

Signed-off-by: Caleb Sander <csander@purestorage.com>
Reviewed-by: Joern Engel <joern@purestorage.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 593912b17609..f1fcb867a999 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -902,7 +902,7 @@ i40e_status i40e_asq_send_command(struct i40e_hw *hw,
 	 * we need to wait for desc write back
 	 */
 	if (!details->async && !details->postpone) {
-		u32 total_delay = 0;
+		unsigned long timeout_end = jiffies + usecs_to_jiffies(hw->aq.asq_cmd_timeout);
 
 		do {
 			/* AQ designers suggest use of head for better
@@ -910,9 +910,9 @@ i40e_status i40e_asq_send_command(struct i40e_hw *hw,
 			 */
 			if (i40e_asq_done(hw))
 				break;
+			cond_resched();
 			udelay(50);
-			total_delay += 50;
-		} while (total_delay < hw->aq.asq_cmd_timeout);
+		} while (time_before(jiffies, timeout_end));
 	}
 
 	/* if ready, copy the desc back to temp */
-- 
2.31.1

