Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81C768CA92
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjBFXao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjBFXah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:30:37 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA48A12867
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 15:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675726212; x=1707262212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1oJD9WZEOwbMUAIE05cGD0Nkho1HBy8yp6ftNNHf6ZA=;
  b=ZjzDLp8G5u0an7VsXa/v+bmZiRGmWgE9lCFQ3BoO4Ol+txdQevgLl6XW
   wDHru335dVUgI7kKNoiCUcYFCCnfaAeGxgSlUtdQbBg4VghYxPm4CxDjF
   gDryEuuoW1J18UkLJ48/fYUM8hDxem3LLMi04juKBEQlHJ5u/8l5L2opn
   3UEP9F4mN148tsIXtga/Wrtu+3/LeS0oX1Gv0D7LLQSgTnfo5CUVMEy5K
   vvvPq9ClrjjbXyWvAAGRSYakttQhF0QCEFTfBOoSm8RI/rbJeIFn1uYnb
   ELQ3v3hJ9TPTvwNSDAdTvTRSfpRt4gt9dFQl2A9A6SqQxsoiTCpi38IYv
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="309678431"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="309678431"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 15:29:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="809305678"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="809305678"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 06 Feb 2023 15:29:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net v2 5/5] ice: switch: fix potential memleak in ice_add_adv_recipe()
Date:   Mon,  6 Feb 2023 15:29:34 -0800
Message-Id: <20230206232934.634298-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206232934.634298-1-anthony.l.nguyen@intel.com>
References: <20230206232934.634298-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

When ice_add_special_words() fails, the 'rm' is not released, which will
lead to a memory leak. Fix this up by going to 'err_unroll' label.

Compile tested only.

Fixes: 8b032a55c1bd ("ice: low level support for tunnels")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 9b762f7972ce..61f844d22512 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5420,7 +5420,7 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	 */
 	status = ice_add_special_words(rinfo, lkup_exts, ice_is_dvm_ena(hw));
 	if (status)
-		goto err_free_lkup_exts;
+		goto err_unroll;
 
 	/* Group match words into recipes using preferred recipe grouping
 	 * criteria.
-- 
2.38.1

