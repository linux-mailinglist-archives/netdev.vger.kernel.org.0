Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2A64C7CBE
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 23:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiB1WEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 17:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiB1WEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 17:04:42 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F24AC486E
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 14:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646085842; x=1677621842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zHwR+1IpnfuWENKaJrvAGweR4aIPrvaZg59LGYsJ3ro=;
  b=nMvgNckbI1WJ2dfIgrzFkFrVwi0nnIjnrT0xo8fVprSsNoigej+VrC7W
   TQ3CIdGofbcEkYgVSBYTVuHxktP2GHsqhCZDAuL8d1XZ4WPq7+6RTHRoh
   dDiEvDqK7cIcW9WHsCOjRcwRqRi8floEzx8G8yErkQUlHxRaUgsU8pCMr
   V/lUfZg17wIDVvUILhvqjaFZjd3gSgHuea0oukPkRR95xdFBP6fPCE2BJ
   2g/JMCKUgyaV9iBLWALEaoKLqRzbjneBHTHv5YUR5aMt4cjAleHBjvYy6
   YzMFEZS0wFsKyK5RF4JBApTwFbvGuzAo3ocykUtYYk7ev1NcBfSUg2EkX
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="236506446"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="236506446"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 14:04:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="575476139"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Feb 2022 14:04:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Corinna Vinschen <vinschen@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net v2 1/4] igc: igc_read_phy_reg_gpy: drop premature return
Date:   Mon, 28 Feb 2022 14:04:09 -0800
Message-Id: <20220228220412.2129191-2-anthony.l.nguyen@intel.com>
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

From: Corinna Vinschen <vinschen@redhat.com>

igc_read_phy_reg_gpy checks the return value from igc_read_phy_reg_mdic
and if it's not 0, returns immediately. By doing this, it leaves the HW
semaphore in the acquired state.

Drop this premature return statement, the function returns after
releasing the semaphore immediately anyway.

Fixes: 5586838fe9ce ("igc: Add code for PHY support")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_phy.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 5cad31c3c7b0..df91d07ce82a 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -779,8 +779,6 @@ s32 igc_read_phy_reg_gpy(struct igc_hw *hw, u32 offset, u16 *data)
 		if (ret_val)
 			return ret_val;
 		ret_val = igc_read_phy_reg_mdic(hw, offset, data);
-		if (ret_val)
-			return ret_val;
 		hw->phy.ops.release(hw);
 	} else {
 		ret_val = igc_read_xmdio_reg(hw, (u16)offset, dev_addr,
-- 
2.31.1

