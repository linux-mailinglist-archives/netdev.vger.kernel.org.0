Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119F943E804
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhJ1SLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:11:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:46231 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhJ1SLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 14:11:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="230427786"
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="230427786"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 11:08:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="725849091"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 28 Oct 2021 11:08:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Wang Hai <wanghai38@huawei.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next 9/9] ice: fix error return code in ice_get_recp_frm_fw()
Date:   Thu, 28 Oct 2021 11:06:59 -0700
Message-Id: <20211028180659.218912-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
References: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

Return error code if devm_kmemdup() fails in ice_get_recp_frm_fw()

Fixes: fd2a6b71e300 ("ice: create advanced switch recipe")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 2af03b9845eb..793f4a9fc2cd 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1363,8 +1363,10 @@ ice_get_recp_frm_fw(struct ice_hw *hw, struct ice_sw_recipe *recps, u8 rid,
 	recps[rid].root_buf = devm_kmemdup(ice_hw_to_dev(hw), tmp,
 					   recps[rid].n_grp_count * sizeof(*recps[rid].root_buf),
 					   GFP_KERNEL);
-	if (!recps[rid].root_buf)
+	if (!recps[rid].root_buf) {
+		status = ICE_ERR_NO_MEMORY;
 		goto err_unroll;
+	}
 
 	/* Copy result indexes */
 	bitmap_copy(recps[rid].res_idxs, result_bm, ICE_MAX_FV_WORDS);
-- 
2.31.1

