Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EC3F5C74
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfKIAof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:44:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:25216 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbfKIAod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 19:44:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 16:44:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="215111195"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2019 16:44:31 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Colin Ian King <colin.king@canonical.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 1/6] ice: fix potential infinite loop because loop counter being too small
Date:   Fri,  8 Nov 2019 16:44:25 -0800
Message-Id: <20191109004430.7219-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
References: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the for-loop counter i is a u8 however it is being checked
against a maximum value hw->num_tx_sched_layers which is a u16. Hence
there is a potential wrap-around of counter i back to zero if
hw->num_tx_sched_layers is greater than 255.  Fix this by making i
a u16.

Addresses-Coverity: ("Infinite loop")
Fixes: b36c598c999c ("ice: Updates to Tx scheduler code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index fc624b73d05d..2fde9653a608 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1036,7 +1036,7 @@ enum ice_status ice_sched_query_res_alloc(struct ice_hw *hw)
 	struct ice_aqc_query_txsched_res_resp *buf;
 	enum ice_status status = 0;
 	__le16 max_sibl;
-	u8 i;
+	u16 i;
 
 	if (hw->layer_info)
 		return status;
-- 
2.21.0

