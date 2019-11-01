Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9EFEC424
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfKAOAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:00:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58254 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfKAOAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:00:24 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iQXTN-00055Z-FX; Fri, 01 Nov 2019 14:00:17 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ice: fix potential infinite loop because loop counter being too small
Date:   Fri,  1 Nov 2019 14:00:17 +0000
Message-Id: <20191101140017.16646-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
2.20.1

