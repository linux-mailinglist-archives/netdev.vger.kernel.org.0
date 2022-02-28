Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2657F4C7CBC
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 23:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiB1WEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 17:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiB1WEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 17:04:43 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAFAC4B59
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 14:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646085843; x=1677621843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PhNLCIVQy2ZVGj1MGX4JBDIa0mR+HVaezoumaPtKyzk=;
  b=TGcO1nxnb9fv9XnKCJfcG7JX6d2i62wGs9gPngorb7sgctiFLn70bBDV
   cOycFNhsfP59xbnSLSBJnvTkXENVhUaJaVAyRFMMotomi3mqpmZLvUniP
   5DeYz+AAaeDQI9jCRCZ7uV8R1DxJH+5vy+5knb5IUdl5A6CNlZp5ocJUG
   fgqpQna07ibaJbu0F+F7lNTKvJlyJqXUVAm0qxgVL0M0QWLsKzICYcAdz
   IQnhO2YLDrELCIlgCr90nEKS0IORu+jvRbKJrNgxhp4MWBk6Fa3y2bxSH
   8M2OmLhX0G4VHP/EeAac6pVF1roxfqkFj01w+qn7Nw0HXwsWuQtbUfYUU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="236506449"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="236506449"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 14:04:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="575476151"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Feb 2022 14:04:01 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net v2 4/4] e1000e: Correct NVM checksum verification flow
Date:   Mon, 28 Feb 2022 14:04:12 -0800
Message-Id: <20220228220412.2129191-5-anthony.l.nguyen@intel.com>
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

Update MAC type check e1000_pch_tgp because for e1000_pch_cnp,
NVM checksum update is still possible.
Emit a more detailed warning message.

Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=1191663
Fixes: 4051f68318ca ("e1000e: Do not take care about recovery NVM checksum")
Reported-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index e298da712758..d60e2016d03c 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -4140,9 +4140,9 @@ static s32 e1000_validate_nvm_checksum_ich8lan(struct e1000_hw *hw)
 		return ret_val;
 
 	if (!(data & valid_csum_mask)) {
-		e_dbg("NVM Checksum Invalid\n");
+		e_dbg("NVM Checksum valid bit not set\n");
 
-		if (hw->mac.type < e1000_pch_cnp) {
+		if (hw->mac.type < e1000_pch_tgp) {
 			data |= valid_csum_mask;
 			ret_val = e1000_write_nvm(hw, word, 1, &data);
 			if (ret_val)
-- 
2.31.1

