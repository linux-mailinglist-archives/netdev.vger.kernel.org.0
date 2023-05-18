Return-Path: <netdev+bounces-3718-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3CBA708688
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70BDE2819EC
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E174B24E95;
	Thu, 18 May 2023 17:14:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D789527210
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 17:14:10 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7852819A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684430043; x=1715966043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MX7hGUG3qibYzoR2iA862ViPMHTBMV9RjXGRDlQ7ES8=;
  b=V00LEh7ONUN3V/FeF5IFQR0HBhmD/CFPtOlJHuXsVOYfY/x31CdiuIkg
   gCpQgS+f6CNSB5KHeqhpOKwvB8f0uDThYvCqm/PZZCkCRuIV2M+bnXLwF
   0oNn/dK+UQCp9t5GzZQ5xuQdjnJ4w3pz07pCoW640VAFVrdchip8hbpSq
   2epv4NiZ9E0jldbJd0FZ1gSWX1V7lebBat1owMwup9SQPThFId7qnzrih
   IwqTHCwYPRU5k8hSi7WP9hQk6OD6TPjzEmVjTCLIJHwV++8ITZiJjKD1U
   KgwZrdGf/wYPpqfATH8ZO6CAXZRsEeLYlZOayArmSwHjvGnRtuCz+zMEa
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="354468740"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="354468740"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 10:13:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="702207874"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="702207874"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 18 May 2023 10:13:29 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tom Rix <trix@redhat.com>,
	anthony.l.nguyen@intel.com,
	Simon Horman <simon.horman@corigine.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net-next 2/3] igb: Define igb_pm_ops conditionally on CONFIG_PM
Date: Thu, 18 May 2023 10:09:41 -0700
Message-Id: <20230518170942.418109-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230518170942.418109-1-anthony.l.nguyen@intel.com>
References: <20230518170942.418109-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Tom Rix <trix@redhat.com>

For s390, gcc with W=1 reports
drivers/net/ethernet/intel/igb/igb_main.c:186:32: error:
  'igb_pm_ops' defined but not used [-Werror=unused-const-variable=]
  186 | static const struct dev_pm_ops igb_pm_ops = {
      |                                ^~~~~~~~~~

The only use of igb_pm_ops is conditional on CONFIG_PM.
The definition of igb_pm_ops should also be conditional on CONFIG_PM

Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 58872a4c2540..c5cdb880774d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -183,11 +183,13 @@ static int igb_resume(struct device *);
 static int igb_runtime_suspend(struct device *dev);
 static int igb_runtime_resume(struct device *dev);
 static int igb_runtime_idle(struct device *dev);
+#ifdef CONFIG_PM
 static const struct dev_pm_ops igb_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(igb_suspend, igb_resume)
 	SET_RUNTIME_PM_OPS(igb_runtime_suspend, igb_runtime_resume,
 			igb_runtime_idle)
 };
+#endif
 static void igb_shutdown(struct pci_dev *);
 static int igb_pci_sriov_configure(struct pci_dev *dev, int num_vfs);
 #ifdef CONFIG_IGB_DCA
-- 
2.38.1


