Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3359A6277A1
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbiKNI23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbiKNI21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:28:27 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF943DC9
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:28:25 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N9j9l1zm7zHvrl;
        Mon, 14 Nov 2022 16:27:55 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 14 Nov
 2022 16:28:23 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <alexander.h.duyck@intel.com>,
        <jeffrey.t.kirsher@intel.com>, <matthew.vick@intel.com>,
        <jacob.e.keller@intel.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH 1/2] fm10k: Fix error handling in fm10k_init_module()
Date:   Mon, 14 Nov 2022 08:26:39 +0000
Message-ID: <20221114082640.91128-2-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221114082640.91128-1-yuancan@huawei.com>
References: <20221114082640.91128-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.17.1

