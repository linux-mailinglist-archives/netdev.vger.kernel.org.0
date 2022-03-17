Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960F84DCAAE
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbiCQQEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236303AbiCQQEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:04:01 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A9B214041
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647532964; x=1679068964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NN6XWuYMNDBhLMKaPP1+k+XxVTLwr50CNNl7hoC+yo0=;
  b=PNCdz7YIFRqNu7u2veko7prtT629pxajzTgna/N6YNnPmUSwikprxy8d
   IvdCZMrszh4K+ajfcwHNSheMYaWJfFDNfjMIRVUccxXAiiE62WBDmiGFb
   nhrU3R5SP9IVczyeWEkTr4B5q88v5ptOR8LzpLWEkaXOnX2t7r+D4ZEAH
   7YywvF1LZN2otLaleqkHySmgH6ipBBusYEjXMz/hF/eyQ28DU/7dIcJpp
   FGs66R+2rhmBIB+BSH7DSGAzjZJg4q7n6Za1/oNfvg5EdsNOaxcI7ifnD
   CHo1QMmdgG3CrjXPIbVK5Mjibtwcy9hXD7dvO00nUXQ3M9t/FYKTGpvoo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="236845992"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="236845992"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 09:02:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="581339482"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 17 Mar 2022 09:02:14 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/2] i40e: little endian only valid checksums
Date:   Thu, 17 Mar 2022 09:02:35 -0700
Message-Id: <20220317160236.3534321-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220317160236.3534321-1-anthony.l.nguyen@intel.com>
References: <20220317160236.3534321-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The calculation of the checksum can fail.
So move converting the checksum to little endian
to inside the return status check.

Signed-off-by: Tom Rix <trix@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_nvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_nvm.c b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
index fe6dca846028..3a38bf8bcde7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_nvm.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
@@ -682,10 +682,11 @@ i40e_status i40e_update_nvm_checksum(struct i40e_hw *hw)
 	__le16 le_sum;
 
 	ret_code = i40e_calc_nvm_checksum(hw, &checksum);
-	le_sum = cpu_to_le16(checksum);
-	if (!ret_code)
+	if (!ret_code) {
+		le_sum = cpu_to_le16(checksum);
 		ret_code = i40e_write_nvm_aq(hw, 0x00, I40E_SR_SW_CHECKSUM_WORD,
 					     1, &le_sum, true);
+	}
 
 	return ret_code;
 }
-- 
2.31.1

