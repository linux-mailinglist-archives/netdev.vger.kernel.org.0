Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D024C7CBD
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 23:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiB1WEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 17:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiB1WEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 17:04:42 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B978BC4B55
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 14:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646085842; x=1677621842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m9lJPJzDXYvhOuqEdof+x76kM5t4CDWdNXlkj2uMmVU=;
  b=F6+h9g4gXLFPktaD+B7ZqSGFhPE/ht7wUkPHgsXgD9GfvECayujnQK2o
   kJ546aa6C9LmlmIYtEos6I+vntNGG5SdyHXyaT9g66VO4pLIXAWRV3u8p
   aNl6Ia8dC3rw+QdqZtv3hdR0+hJqzUY9j0z9J7XGfJyC6HDWr88/ZwIsk
   fDG8cKiD3kydxmhpUK28thXMeq6suaR8Lh/Q0gq+6iDlQD1SJPoXfT30z
   Lt/EJBhIeNTC55bPySckCUxe1Ft187hxh3bqB3jImLu4nKJcafyuJp+AT
   zb0iSLYXgYBu73y8oQtf7B479PGFWq1V4Ap9N2BQl7CEPaBj5qUhH36zE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="236506447"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="236506447"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 14:04:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="575476143"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Feb 2022 14:04:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Corinna Vinschen <vinschen@redhat.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net v2 2/4] igc: igc_write_phy_reg_gpy: drop premature return
Date:   Mon, 28 Feb 2022 14:04:10 -0800
Message-Id: <20220228220412.2129191-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220228220412.2129191-1-anthony.l.nguyen@intel.com>
References: <20220228220412.2129191-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

