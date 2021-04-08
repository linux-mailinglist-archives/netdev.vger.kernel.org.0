Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AC3358B71
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhDHRea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:34:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:25282 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232474AbhDHReL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 13:34:11 -0400
IronPort-SDR: p2D/QOW78zbzN3vnRI8YmbII/NNA4nLzMS+i+uOSOQ07fD7e64M3HWI64zrRuy3AkKQBZxza9z
 2Od+LOURkm1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="181132911"
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="181132911"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 10:33:58 -0700
IronPort-SDR: puMcOY6C/RUI0g+7K1QpFZ7CHHNG1g4U/ZIMVebT1lHBut3VE2Y/qv1jD72d5aZW/JIAHklY1a
 0YAvsRYowKzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="422343457"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Apr 2021 10:33:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 5/6] i40e: Fix sparse warning: missing error code 'err'
Date:   Thu,  8 Apr 2021 10:35:36 -0700
Message-Id: <20210408173537.3519606-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
References: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Set proper return values inside error checking if-statements.

Previously following warning was produced when compiling against sparse.
i40e_main.c:15162 i40e_init_recovery_mode() warn: missing error code 'err'

Fixes: 4ff0ee1af0169 ("i40e: Introduce recovery mode support")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index c0a4bc2caae9..30ad7c08d0fb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15138,12 +15138,16 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
 	 * in order to register the netdev
 	 */
 	v_idx = i40e_vsi_mem_alloc(pf, I40E_VSI_MAIN);
-	if (v_idx < 0)
+	if (v_idx < 0) {
+		err = v_idx;
 		goto err_switch_setup;
+	}
 	pf->lan_vsi = v_idx;
 	vsi = pf->vsi[v_idx];
-	if (!vsi)
+	if (!vsi) {
+		err = -EFAULT;
 		goto err_switch_setup;
+	}
 	vsi->alloc_queue_pairs = 1;
 	err = i40e_config_netdev(vsi);
 	if (err)
-- 
2.26.2

