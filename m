Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C413F451BF6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344816AbhKPAJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:09:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:18638 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346045AbhKPAH3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 19:07:29 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="220768898"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="220768898"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 16:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="506163133"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 15 Nov 2021 16:00:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Surabhi Boob <surabhi.boob@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 08/10] iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset
Date:   Mon, 15 Nov 2021 15:59:32 -0800
Message-Id: <20211115235934.880882-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Surabhi Boob <surabhi.boob@intel.com>

While issuing VF Reset from the guest OS, the VF driver prints
logs about critical / Overflow error detection. This is not an
actual error since the VF_MBX_ARQLEN register is set to all FF's
for a short period of time and the VF would catch the bits set if
it was reading the register during that spike of time.
This patch introduces an additional check to ignore this condition
since the VF is in reset.

Fixes: 19b73d8efaa4 ("i40evf: Add additional check for reset")
Signed-off-by: Surabhi Boob <surabhi.boob@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 9c68c8628512..9ca9208aa896 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2409,7 +2409,7 @@ static void iavf_adminq_task(struct work_struct *work)
 
 	/* check for error indications */
 	val = rd32(hw, hw->aq.arq.len);
-	if (val == 0xdeadbeef) /* indicates device in reset */
+	if (val == 0xdeadbeef || val == 0xffffffff) /* device in reset */
 		goto freedom;
 	oldval = val;
 	if (val & IAVF_VF_ARQLEN1_ARQVFE_MASK) {
-- 
2.31.1

