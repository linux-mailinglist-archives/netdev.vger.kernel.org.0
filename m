Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52E6636E07
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiKWXEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiKWXEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:04:15 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206E5116581
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669244654; x=1700780654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LtbwPrq1em+dMYiw14WHheYtXUaVQnLBj1yPDvE13xM=;
  b=X9tWVEktdAlllDwnN/NC/zk5VY3x+CYX+8mMJ2cVVjdXzmmxV0TIAWwW
   wBKcziJY5sDOxaHG42+JvqkgGtnufKLt4ukVbdP90k0uZramP0rD8OQkV
   CnwZ4GPN1r3hRwjzj1c0NhM6wc4qLOOsvXbzn46XNSkAU7hIR9ng9wsR+
   bB9uBHFwJ0P8qk8JI5UZH8e/+hR9jzggCTYPy1C6TMnGBfpalqPWG3FvD
   +bEAbGAPdZqVPyCDLsZYYDs/UWFCzmpvBSgwCWbrHHhad0xkVIGpSBTu0
   ygH50IlqfVxDRxQtUcCsuLB34LI0Mp06URIFO2ID/b/LNzNXaJWD8YZT7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297533740"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="297533740"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:04:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="887124322"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="887124322"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 23 Nov 2022 15:04:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Yuan Can <yuancan@huawei.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net 3/5] fm10k: Fix error handling in fm10k_init_module()
Date:   Wed, 23 Nov 2022 15:04:04 -0800
Message-Id: <20221123230406.3562753-4-anthony.l.nguyen@intel.com>
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

From: Yuan Can <yuancan@huawei.com>

A problem about modprobe fm10k failed is triggered with the following log
given:

 Intel(R) Ethernet Switch Host Interface Driver
 Copyright(c) 2013 - 2019 Intel Corporation.
 debugfs: Directory 'fm10k' with parent '/' already present!

The reason is that fm10k_init_module() returns fm10k_register_pci_driver()
directly without checking its return value, if fm10k_register_pci_driver()
failed, it returns without removing debugfs and destroy workqueue,
resulting the debugfs of fm10k can never be created later and leaks the
workqueue.

 fm10k_init_module()
   alloc_workqueue()
   fm10k_dbg_init() # create debugfs
   fm10k_register_pci_driver()
     pci_register_driver()
       driver_register()
         bus_add_driver()
           priv = kzalloc(...) # OOM happened
   # return without remove debugfs and destroy workqueue

Fix by remove debugfs and destroy workqueue when
fm10k_register_pci_driver() returns error.

Fixes: 7461fd913afe ("fm10k: Add support for debugfs")
Fixes: b382bb1b3e2d ("fm10k: use separate workqueue for fm10k driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 4a6630586ec9..fc373472e4e1 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -32,6 +32,8 @@ struct workqueue_struct *fm10k_workqueue;
  **/
 static int __init fm10k_init_module(void)
 {
+	int ret;
+
 	pr_info("%s\n", fm10k_driver_string);
 	pr_info("%s\n", fm10k_copyright);
 
@@ -43,7 +45,13 @@ static int __init fm10k_init_module(void)
 
 	fm10k_dbg_init();
 
-	return fm10k_register_pci_driver();
+	ret = fm10k_register_pci_driver();
+	if (ret) {
+		fm10k_dbg_exit();
+		destroy_workqueue(fm10k_workqueue);
+	}
+
+	return ret;
 }
 module_init(fm10k_init_module);
 
-- 
2.35.1

