Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D880553ED9
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 01:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355026AbiFUXCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 19:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355007AbiFUXCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 19:02:34 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335DA2FFEB
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655852553; x=1687388553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZZNa4fHTeS+lAn+E8zIhfaVcPFsHaNCfuZUxnTQ7Sjc=;
  b=ZuQusQjCHFUYkQ/EIDk0TIi6HDNawv8c7Q4t9/VSkaA9iTBE7aEJ9gdn
   +E06/hurj8v8u6IHYPl2DfYZne+Ql/VjZogg8TrFrJpl28c89mFxemBf4
   m40bkCgYmnhcTsQbMonUnMg7HR1bPBEk25iiZrMnvirN9AUclbqSwp34l
   k+dHpz8QtOkYqtoD0NV+VkGw8cn4fQGHZT8EWhg0nRw7yZDGpLLREe0kV
   m3F9EAnwaFdL7FJASm5TwrSahEm7Jx9DO3bR/IkXlXAXBFI38D/4G8RDV
   mlBkiGrSBSXlLD3PigWyK8d8RWt2xImkE2GJygkkDIc5OsISSJY0PhItr
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="341943798"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="341943798"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 16:02:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="677234992"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Jun 2022 16:02:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Minghao Chi <chi.minghao@zte.com.cn>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Zeal Robot <zealci@zte.com.cn>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/3] i40e: Remove unnecessary synchronize_irq() before free_irq()
Date:   Tue, 21 Jun 2022 15:59:29 -0700
Message-Id: <20220621225930.632741-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621225930.632741-1-anthony.l.nguyen@intel.com>
References: <20220621225930.632741-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Calling synchronize_irq() right before free_irq() is quite useless. On one
hand the IRQ can easily fire again before free_irq() is entered, on the
other hand free_irq() itself calls synchronize_irq() internally (in a race
condition free way), before any state associated with the IRQ is freed.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 83e0cf475ebd..797f61b2cd96 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4162,7 +4162,6 @@ static void i40e_free_misc_vector(struct i40e_pf *pf)
 	i40e_flush(&pf->hw);
 
 	if (pf->flags & I40E_FLAG_MSIX_ENABLED && pf->msix_entries) {
-		synchronize_irq(pf->msix_entries[0].vector);
 		free_irq(pf->msix_entries[0].vector, pf);
 		clear_bit(__I40E_MISC_IRQ_REQUESTED, pf->state);
 	}
@@ -4901,7 +4900,6 @@ static void i40e_vsi_free_irq(struct i40e_vsi *vsi)
 			irq_set_affinity_notifier(irq_num, NULL);
 			/* remove our suggested affinity mask for this IRQ */
 			irq_update_affinity_hint(irq_num, NULL);
-			synchronize_irq(irq_num);
 			free_irq(irq_num, vsi->q_vectors[i]);
 
 			/* Tear down the interrupt queue link list
-- 
2.35.1

