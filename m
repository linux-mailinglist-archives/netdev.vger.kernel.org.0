Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666DA630007
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiKRWZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbiKRWYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:24:48 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D27326C8
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668810287; x=1700346287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0EiDanQEUNZRbC6xWgtC6wer+7my56JlJKs9d/ibiZk=;
  b=euX31DvJy/okSTcS2FCA5vT8mrS/1B/AAjHt+v+pceir2pZVmw269QgK
   bOhuTolHF5MFwt0X8iGs/BMO/2tXiovfjLzHcKPalNnmBCBTvQBAQEECh
   AtCyzNnIh8t+095RXC/OTmaiIS6DlNkrEFnFECjm5nQqEOzjaZY+4vUdy
   NaF73ZU/bCgMqQ0nMGg2G0nKCfrZzjYu0CQ5VYeXDuhPdVURlmiHmtGnG
   1rXXIObgjF3H9t8MM5r0WN9LIfSstSwrGkShuXqN1PBLGbwBqexgyKCY1
   oTCbgG1l/7DP2jhqvY7OODmBbv+J0qotCH4KOviXarLAUnnKYiTstPvuF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="375394914"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="375394914"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 14:24:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="634580315"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="634580315"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 18 Nov 2022 14:24:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Slawomir Laba <slawomirx.laba@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net 4/4] iavf: Fix race condition between iavf_shutdown and iavf_remove
Date:   Fri, 18 Nov 2022 14:24:39 -0800
Message-Id: <20221118222439.1565245-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221118222439.1565245-1-anthony.l.nguyen@intel.com>
References: <20221118222439.1565245-1-anthony.l.nguyen@intel.com>
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

From: Slawomir Laba <slawomirx.laba@intel.com>

Fix a deadlock introduced by commit
974578017fc1 ("iavf: Add waiting so the port is initialized in remove")
due to race condition between iavf_shutdown and iavf_remove, where
iavf_remove stucks forever in while loop since iavf_shutdown already
set __IAVF_REMOVE adapter state.

Fix this by checking if the __IAVF_IN_REMOVE_TASK has already been
set and return if so.

Fixes: 974578017fc1 ("iavf: Add waiting so the port is initialized in remove")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 801f5b7b8119..d7465296f650 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -5042,23 +5042,21 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 static void iavf_remove(struct pci_dev *pdev)
 {
 	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
-	struct net_device *netdev = adapter->netdev;
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
+	struct iavf_cloud_filter *cf, *cftmp;
 	struct iavf_adv_rss *rss, *rsstmp;
 	struct iavf_mac_filter *f, *ftmp;
-	struct iavf_cloud_filter *cf, *cftmp;
-	struct iavf_hw *hw = &adapter->hw;
+	struct net_device *netdev;
+	struct iavf_hw *hw;
 	int err;
 
-	/* When reboot/shutdown is in progress no need to do anything
-	 * as the adapter is already REMOVE state that was set during
-	 * iavf_shutdown() callback.
-	 */
-	if (adapter->state == __IAVF_REMOVE)
+	netdev = adapter->netdev;
+	hw = &adapter->hw;
+
+	if (test_and_set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
 		return;
 
-	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
 	/* Wait until port initialization is complete.
 	 * There are flows where register/unregister netdev may race.
 	 */
-- 
2.35.1

