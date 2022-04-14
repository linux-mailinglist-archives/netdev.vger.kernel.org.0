Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC52501906
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240883AbiDNQu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240792AbiDNQuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:50:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237ECCEE22
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649953095; x=1681489095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6+TtaCNM1rw15XLB/bNBV5raCsK/BRkkLwwahiv5HBw=;
  b=RVsJY/zBnEy4BnFHSWQjAIGUchk6syOFF/a7cPcwXmaLgtKvT010M0HY
   qn7h/dzf4dAG845Y3P5t0tqEMmNbD4RxiAeCutkHqK2CVFADhsnM9Rs6F
   Z25F5ek35oSB5fhhXy/8Sr0ZHf9bR+cC1cos0muDJM3ySCMSiOAWM+WXV
   l7TNSeXUovusvLvJdsDxrPLBoor5HJZ6FGfyfnaRrUlRNGS7jgtxkd9wl
   adTB1CmtmqiqN9RWouK/NARInTCvVbNcjMjVujquv38VE2UkQRM2QpOwr
   y84EnWa0t6ruBQBNRcbIZi1TCzR3OORF31rvnEiR642EJY71/5jKnYosM
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="242901622"
X-IronPort-AV: E=Sophos;i="5.90,260,1643702400"; 
   d="scan'208";a="242901622"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 09:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,260,1643702400"; 
   d="scan'208";a="526970488"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2022 09:18:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Jianglei Nie <niejianglei2021@163.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 4/4] ice: Fix memory leak in ice_get_orom_civd_data()
Date:   Thu, 14 Apr 2022 09:15:22 -0700
Message-Id: <20220414161522.2320694-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220414161522.2320694-1-anthony.l.nguyen@intel.com>
References: <20220414161522.2320694-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

A memory chunk was allocated for orom_data in ice_get_orom_civd_data()
by vzmalloc(). But when ice_read_flash_module() fails, the allocated
memory is not freed, which will lead to a memory leak.

We can fix it by freeing the orom_data when ce_read_flash_module() fails.

Fixes: af18d8866c80 ("ice: reduce time to read Option ROM CIVD data")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 4eb0599714f4..13cdb5ea594d 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -641,6 +641,7 @@ ice_get_orom_civd_data(struct ice_hw *hw, enum ice_bank_select bank,
 	status = ice_read_flash_module(hw, bank, ICE_SR_1ST_OROM_BANK_PTR, 0,
 				       orom_data, hw->flash.banks.orom_size);
 	if (status) {
+		vfree(orom_data);
 		ice_debug(hw, ICE_DBG_NVM, "Unable to read Option ROM data\n");
 		return status;
 	}
-- 
2.31.1

