Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC74662B08B
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 02:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiKPB3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 20:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiKPB3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 20:29:00 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A24E95AC
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 17:28:59 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NBln020Lbz15Mgq;
        Wed, 16 Nov 2022 09:28:36 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 16 Nov
 2022 09:28:56 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jeffrey.t.kirsher@intel.com>,
        <shannon.nelson@intel.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH v2] i40e: Fix error handling in i40e_init_module()
Date:   Wed, 16 Nov 2022 09:27:25 +0800
Message-ID: <20221116012725.13707-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i40e_init_module() won't free the debugfs directory created by
i40e_dbg_init() when pci_register_driver() failed. Add fail path to
call i40e_dbg_exit() to remove the debugfs entries to prevent the bug.

i40e: Intel(R) Ethernet Connection XL710 Network Driver
i40e: Copyright (c) 2013 - 2019 Intel Corporation.
debugfs: Directory 'i40e' with parent '/' already present!

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
changes in v2:
- destroy the workqueue in fail path too.
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
2.17.1

