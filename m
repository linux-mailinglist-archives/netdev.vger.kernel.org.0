Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98547636E0A
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiKWXEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKWXEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:04:15 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB1911606E
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669244654; x=1700780654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1zg8ZBigDs34Dt+Sg8ZQh7tu/yhaWVc4OmbfYHq5bP0=;
  b=Th8FRGW4LveTKcBxtHrTXY9+kHOB0QOOsckD/+uq92NgIb9wUZAWMcq1
   bcrUGyKJ81HWUxtryoNueJduDVYvJx4Rn8yTohMXOIjYJQLMdldcaSlAq
   bwhac04lqPIyb2HIB/rvyocnhX2jJDVevva9DUVZQuOSUzd4k/C9HsEN5
   P0FHD6nYKpcuL26SNkOnF5jo5axy66BW+MQrALFlFcbfQtS7u7lqkklH6
   aQV3Xy1b7MeyGTGCu4PYQnrjhJ5Lt1/j07rRkPetuw/G4NLq4H3FEDPHu
   1EpvmcwV4gHfnj4Z/6K0tak/eW9Wa/JWE78w7qDgm9eTDdOLOPSuhyO9e
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297533744"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="297533744"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:04:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="887124328"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="887124328"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 23 Nov 2022 15:04:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Yuan Can <yuancan@huawei.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 4/5] iavf: Fix error handling in iavf_init_module()
Date:   Wed, 23 Nov 2022 15:04:05 -0800
Message-Id: <20221123230406.3562753-5-anthony.l.nguyen@intel.com>
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

The iavf_init_module() won't destroy workqueue when pci_register_driver()
failed. Call destroy_workqueue() when pci_register_driver() failed to
prevent the resource leak.

Similar to the handling of u132_hcd_init in commit f276e002793c
("usb: u132-hcd: fix resource leak")

Fixes: 2803b16c10ea ("i40e/i40evf: Use private workqueue")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d7465296f650..f71e132ede09 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -5196,6 +5196,8 @@ static struct pci_driver iavf_driver = {
  **/
 static int __init iavf_init_module(void)
 {
+	int ret;
+
 	pr_info("iavf: %s\n", iavf_driver_string);
 
 	pr_info("%s\n", iavf_copyright);
@@ -5206,7 +5208,12 @@ static int __init iavf_init_module(void)
 		pr_err("%s: Failed to create workqueue\n", iavf_driver_name);
 		return -ENOMEM;
 	}
-	return pci_register_driver(&iavf_driver);
+
+	ret = pci_register_driver(&iavf_driver);
+	if (ret)
+		destroy_workqueue(iavf_wq);
+
+	return ret;
 }
 
 module_init(iavf_init_module);
-- 
2.35.1

