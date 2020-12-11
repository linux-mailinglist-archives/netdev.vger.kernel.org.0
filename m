Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212522D7815
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 15:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405299AbgLKOm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:42:58 -0500
Received: from ns.kevlo.org ([220.134.220.36]:29994 "EHLO mail.kevlo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730988AbgLKOm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 09:42:27 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2020 09:42:27 EST
Received: from localhost (ns.kevlo.org [local])
        by ns.kevlo.org (OpenSMTPD) with ESMTPA id 0dc73e40;
        Fri, 11 Dec 2020 22:34:56 +0800 (CST)
Date:   Fri, 11 Dec 2020 22:34:56 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     Sasha Neftin <sasha.neftin@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] igc: set the default return value to -IGC_ERR_NVM in
 igc_write_nvm_srwr
Message-ID: <20201211143456.GA83809@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sets the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr.
Without this change it wouldn't lead to a shadow RAM write EEWR timeout.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index 8b67d9b49a83..b0a5cd31683e 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -221,7 +221,7 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 	struct igc_nvm_info *nvm = &hw->nvm;
 	u32 attempts = 100000;
 	u32 i, k, eewr = 0;
-	s32 ret_val = 0;
+	s32 ret_val = -IGC_ERR_NVM;
 
 	/* A check for invalid values:  offset too large, too many words,
 	 * too many words for the offset, and not enough words.
@@ -229,7 +229,6 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 	if (offset >= nvm->word_size || (words > (nvm->word_size - offset)) ||
 	    words == 0) {
 		hw_dbg("nvm parameter(s) out of bounds\n");
-		ret_val = -IGC_ERR_NVM;
 		goto out;
 	}
 
