Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E676636E09
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiKWXEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiKWXEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:04:14 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA4E11606E
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669244653; x=1700780653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ilPlrh5zUMjoLXrP+JRbSAXsacU/ToBgJHdIgjGxTJ0=;
  b=lFohgLHqwIa38l//z2De0wLsdG/o7s5ehhl+sknX/kKmk/WrMDk3L7L0
   znCsqMhJlYOO888+euxgRIpYDsrG81a1+EIP1lVjIyGV9Tk2OY0GbvH/4
   ZiQmt+t5Jbkbw1djWhIAeyC6fnhewMOFEPtkcK+HvPHcOvWa2ymOimm3l
   bnepl04pQ6ca6HL9WI882TqfOljh6hPmRsi2NvXdclBetm59NUmp2bvfs
   7JgHFaGTiOnIX/uWDBR5jtj029QAGI5H+c1fXkkXSZQlC+mE4vnGgZ27p
   xNok1xM1Cz+FQ7HnPzBezTmiuPpSs84wCubQb0M2gkjUIobNlq+UA4lLS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297533735"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="297533735"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:04:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="887124312"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="887124312"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 23 Nov 2022 15:04:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Shang XiaoJing <shangxiaojing@huawei.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Saeed Mahameed <saeed@kernel.org>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/5] ixgbevf: Fix resource leak in ixgbevf_init_module()
Date:   Wed, 23 Nov 2022 15:04:02 -0800
Message-Id: <20221123230406.3562753-2-anthony.l.nguyen@intel.com>
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

ixgbevf_init_module() won't destroy the workqueue created by
create_singlethread_workqueue() when pci_register_driver() failed. Add
destroy_workqueue() in fail path to prevent the resource leak.

Similar to the handling of u132_hcd_init in commit f276e002793c
("usb: u132-hcd: fix resource leak")

Fixes: 40a13e2493c9 ("ixgbevf: Use a private workqueue to avoid certain possible hangs")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 99933e89717a..e338fa572793 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4869,6 +4869,8 @@ static struct pci_driver ixgbevf_driver = {
  **/
 static int __init ixgbevf_init_module(void)
 {
+	int err;
+
 	pr_info("%s\n", ixgbevf_driver_string);
 	pr_info("%s\n", ixgbevf_copyright);
 	ixgbevf_wq = create_singlethread_workqueue(ixgbevf_driver_name);
@@ -4877,7 +4879,13 @@ static int __init ixgbevf_init_module(void)
 		return -ENOMEM;
 	}
 
-	return pci_register_driver(&ixgbevf_driver);
+	err = pci_register_driver(&ixgbevf_driver);
+	if (err) {
+		destroy_workqueue(ixgbevf_wq);
+		return err;
+	}
+
+	return 0;
 }
 
 module_init(ixgbevf_init_module);
-- 
2.35.1

