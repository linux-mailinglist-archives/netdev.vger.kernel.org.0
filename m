Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D674C77E8
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 19:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbiB1Sfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 13:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240789AbiB1Sf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 13:35:28 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F9B1CFE6
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 10:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646072438; x=1677608438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m9lJPJzDXYvhOuqEdof+x76kM5t4CDWdNXlkj2uMmVU=;
  b=kK6kMcW5I8VMzzsgT6nxLSTRLLLURiBLWadIstGf+IAfapO0aD8venlc
   KC707M1gMvTlKQMZPzSPmzv6YEtAjoIMHAV+b2D+oRG5re4F5moNUb+gn
   mWr4JNEiIbd6x03OwCHWaOvfSPi+FYTGZcKl0/oGLw21o8hU9UNSxFcRe
   Czii6GGr59IYRJOjPsFHfr3JmCB/6Wq4Z+oieJbJ64bT9ka5jquGyX8ll
   CW8yjWhDiY+E5dMDZ2GQsfi/0KxNYFX63msVtl7ZXs5VWsEE1cJRr+NlR
   WVXPe4pldcEiNmi3X2mTbbATzPMZmJYa979sj0a5USdqnniXVHt+KL3zf
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="316165877"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="316165877"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 10:20:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="575406557"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Feb 2022 10:20:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Corinna Vinschen <vinschen@redhat.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 2/4] igc: igc_write_phy_reg_gpy: drop premature return
Date:   Mon, 28 Feb 2022 10:20:43 -0800
Message-Id: <20220228182045.1562938-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220228182045.1562938-1-anthony.l.nguyen@intel.com>
References: <20220228182045.1562938-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Similar to "igc_read_phy_reg_gpy: drop premature return" patch.
igc_write_phy_reg_gpy checks the return value from igc_write_phy_reg_mdic
and if it's not 0, returns immediately. By doing this, it leaves the HW
semaphore in the acquired state.

Drop this premature return statement, the function returns after
releasing the semaphore immediately anyway.

Fixes: 5586838fe9ce ("igc: Add code for PHY support")
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Reported-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_phy.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index df91d07ce82a..40dbf4b43234 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -746,8 +746,6 @@ s32 igc_write_phy_reg_gpy(struct igc_hw *hw, u32 offset, u16 data)
 		if (ret_val)
 			return ret_val;
 		ret_val = igc_write_phy_reg_mdic(hw, offset, data);
-		if (ret_val)
-			return ret_val;
 		hw->phy.ops.release(hw);
 	} else {
 		ret_val = igc_write_xmdio_reg(hw, (u16)offset, dev_addr,
-- 
2.31.1

