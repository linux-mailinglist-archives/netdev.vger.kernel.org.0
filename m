Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3639630B242
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhBAVqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:46:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:26807 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhBAVqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 16:46:51 -0500
IronPort-SDR: ohe2jvYSi0w3P4LROZ9yN96V9+L8oR8m5H2fz2xvgxm0AQLs72PoR3eVP8D3H8mZ0AFk95ET9d
 GFI7Q9xpOtwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="177249327"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="177249327"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 13:45:35 -0800
IronPort-SDR: 05zErSUqQECXbnmdWS5s50xzau/LivZ6ebg/944A0F1FvvxR/Hd7RTkRHMXiQvuFPZJnti+B4t
 00Ge0S5o7hNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="354638540"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 01 Feb 2021 13:45:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Kevin Lo <kevlo@kevlo.org>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net v2 2/4] igc: set the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr
Date:   Mon,  1 Feb 2021 13:46:16 -0800
Message-Id: <20210201214618.852831-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210201214618.852831-1-anthony.l.nguyen@intel.com>
References: <20210201214618.852831-1-anthony.l.nguyen@intel.com>
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

