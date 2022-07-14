Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3CD575467
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240065AbiGNSGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239994AbiGNSGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:06:15 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FDA481D3
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657821974; x=1689357974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6AHuNKILqY2uhlEZ/5QL/7o4XsP3a4Gycwx6z7WWvCE=;
  b=UhvhsOWlQvH2VJ3oco1wFkTAj22ZxNCHE4bIYfzRYpPxZZI8V3DuZQPY
   /8MzHogcaVuVhPAESkw6udaOChCD21AuVxA9B+WJjgnw+z3T8y1ZpOMHX
   dSSuZ5yXYcKfAAcfd3fc4aruCfUELAaCgjaGvEDpqnaecjrC/AfckobLl
   rbwB8kPlZPYXoe+qZxGV5qo/KP3IAYv1sST1wwZkULRCHjrYL34kNs1Fr
   k4JvC/WqwxopNvyM3le94+91SFO1pO7RXov4zT7yxMAXuIJ5DdvWOJskN
   H0XipBAWurzvFheePnRMMUSzuJM2cl7F/tHbVZqwKXrowaGzT2zjjO7Vz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286336088"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="286336088"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:06:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="685666833"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jul 2022 11:06:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Zhuo Chen <chenzhuo.1@bytedance.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Muchun Song <songmuchun@bytedance.com>,
        Sen Wang <wangsen.harry@bytedance.com>,
        Wenliang Wang <wangwenliang.1995@bytedance.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/3] ice: Remove pci_aer_clear_nonfatal_status() call
Date:   Thu, 14 Jul 2022 11:03:11 -0700
Message-Id: <20220714180311.933648-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714180311.933648-1-anthony.l.nguyen@intel.com>
References: <20220714180311.933648-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhuo Chen <chenzhuo.1@bytedance.com>

After commit 62b36c3ea664 ("PCI/AER: Remove
pci_cleanup_aer_uncorrect_error_status() calls"), calls to
pci_cleanup_aer_uncorrect_error_status() have already been removed. But in
commit 5995b6d0c6fc ("ice: Implement pci_error_handler ops")
pci_cleanup_aer_uncorrect_error_status  was used again, so remove it in
this patch.

Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Sen Wang <wangsen.harry@bytedance.com>
Cc: Wenliang Wang <wangwenliang.1995@bytedance.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2309a6b96a52..f28f6c0ef301 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5317,12 +5317,6 @@ static pci_ers_result_t ice_pci_err_slot_reset(struct pci_dev *pdev)
 			result = PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	err = pci_aer_clear_nonfatal_status(pdev);
-	if (err)
-		dev_dbg(&pdev->dev, "pci_aer_clear_nonfatal_status() failed, error %d\n",
-			err);
-		/* non-fatal, continue */
-
 	return result;
 }
 
-- 
2.35.1

