Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61ABF3080A2
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhA1Vj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:39:26 -0500
Received: from mga12.intel.com ([192.55.52.136]:19316 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231508AbhA1VjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 16:39:16 -0500
IronPort-SDR: lY9dViJWCgscoqIMI6fX68AhEN42CmmHHcwQ8QhuU/NCFlJ7Cckzv0sbVy5Y4j+g7NhkNln/sW
 a2xhOlLCm7bQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="159491176"
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="159491176"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 13:38:20 -0800
IronPort-SDR: G4GrsZGZSy2+CPLsyCEd4ElaXMUOazxVsmsS3TaRQpXnt0BYGtrbqDp3l6ZyI4iEUeGWpm1rJ9
 uFbIkKHGRwmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="474241001"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jan 2021 13:38:20 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Kevin Lo <kevlo@kevlo.org>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net 2/4] igc: set the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr
Date:   Thu, 28 Jan 2021 13:38:49 -0800
Message-Id: <20210128213851.2499012-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Lo <kevlo@kevlo.org>

This patch sets the default return value to -IGC_ERR_NVM in
igc_write_nvm_srwr. Without this change it wouldn't lead to a shadow RAM
write EEWR timeout.

Fixes: ab4056126813 ("igc: Add NVM support")
Signed-off-by: Kevin Lo <kevlo@kevlo.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_i225.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index 8b67d9b49a83..7ec04e48860c 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -219,9 +219,9 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 			      u16 *data)
 {
 	struct igc_nvm_info *nvm = &hw->nvm;
+	s32 ret_val = -IGC_ERR_NVM;
 	u32 attempts = 100000;
 	u32 i, k, eewr = 0;
-	s32 ret_val = 0;
 
 	/* A check for invalid values:  offset too large, too many words,
 	 * too many words for the offset, and not enough words.
@@ -229,7 +229,6 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 	if (offset >= nvm->word_size || (words > (nvm->word_size - offset)) ||
 	    words == 0) {
 		hw_dbg("nvm parameter(s) out of bounds\n");
-		ret_val = -IGC_ERR_NVM;
 		goto out;
 	}
 
-- 
2.26.2

