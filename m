Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414CA636E0C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiKWXEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKWXEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:04:14 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA66E11606C
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669244653; x=1700780653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q7rS1IARs1OcxQdi7exOlod3lrcnP2WnSjJcLaaI8P4=;
  b=TreU5Uridbo6gMV1EJiPv82S1A8xihz8NDw6U4ZFeiuljYCywc3qkhA8
   1MVD0JBWVyUeW8uXRDhYvT/PpHJGmZbyX8oOOYuh0oJ0C2tmGJHLZeLEd
   WCq7IZ7JzPG75uuhO5NGA4zti5zut2rvhUtRAuQetfhcQyk9moydjPYUJ
   9IzaC+QUOViCmTadwM/gwge41Crf43JD/SK/hDxwiZOYs5yPc7hWcLOFX
   QjZRUC4xMRn4SJChmCulsqRn7/8yUQbMJWLHmB6xrAqU4fI5Mc1sveJUa
   qiFnqQYr+o2NA/Og0c+WgxF0z2GpaufbxVieHmNwbuAc8oKM8m2LceEbi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297533736"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="297533736"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:04:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="887124317"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="887124317"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 23 Nov 2022 15:04:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Shang XiaoJing <shangxiaojing@huawei.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Leon Romanovsky <leonro@nvidia.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 2/5] i40e: Fix error handling in i40e_init_module()
Date:   Wed, 23 Nov 2022 15:04:03 -0800
Message-Id: <20221123230406.3562753-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123230406.3562753-1-anthony.l.nguyen@intel.com>
References: <20221123230406.3562753-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shang XiaoJing <shangxiaojing@huawei.com>

i40e_init_module() won't free the debugfs directory created by
i40e_dbg_init() when pci_register_driver() failed. Add fail path to
call i40e_dbg_exit() to remove the debugfs entries to prevent the bug.

i40e: Intel(R) Ethernet Connection XL710 Network Driver
i40e: Copyright (c) 2013 - 2019 Intel Corporation.
debugfs: Directory 'i40e' with parent '/' already present!

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b5dcd15ced36..b3cb587a2032 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -16644,6 +16644,8 @@ static struct pci_driver i40e_driver = {
  **/
 static int __init i40e_init_module(void)
 {
+	int err;
+
 	pr_info("%s: %s\n", i40e_driver_name, i40e_driver_string);
 	pr_info("%s: %s\n", i40e_driver_name, i40e_copyright);
 
@@ -16661,7 +16663,14 @@ static int __init i40e_init_module(void)
 	}
 
 	i40e_dbg_init();
-	return pci_register_driver(&i40e_driver);
+	err = pci_register_driver(&i40e_driver);
+	if (err) {
+		destroy_workqueue(i40e_wq);
+		i40e_dbg_exit();
+		return err;
+	}
+
+	return 0;
 }
 module_init(i40e_init_module);
 
-- 
2.35.1

