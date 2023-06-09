Return-Path: <netdev+bounces-9598-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB745729FDC
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:16:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFE231C210ED
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E2C9200BB;
	Fri,  9 Jun 2023 16:15:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F1A17757
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:15:38 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D17835AD
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686327335; x=1717863335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=olpNJQK0PpXcqiOa1N2oZUMrB9cVFlr8UO1NVFAXt5A=;
  b=BSM6KW1e//y12FYGZUWqgkZpf1tCcgrjManGILBSBPfN8isASW5aNc8N
   9DAknJKJjZYe7Peu8VNWOdXSrVnyNjN72anGfwew+gNh6g+U8ejwgTvAQ
   PJ0G8IfhVbaIoY7rP2Kxw3WqDrAQiKoZZVqWKijIJmayNhpQ9EcZnq2Uq
   bKovKzlAOruWjNFm9mf/rr0/ZhNUlCtxE0N8c9Xkoj7HEK2zDJiMSfMmx
   mV0JfcA7qwYsT02EagbeQrc1GKo9R7HylNwATsj0Lxdc7ewTexg1wt5Fv
   fhxXnrtOOAFWYnkRiq6nRPv6ved3Fb1Voxw03vETfaW+hMrUKVfB7QVOD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="423511390"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="423511390"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:15:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="884645668"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="884645668"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 09 Jun 2023 09:15:34 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	anthony.l.nguyen@intel.com,
	sasha.neftin@intel.com,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net v2 2/3] igc: Fix possible system crash when loading module
Date: Fri,  9 Jun 2023 09:10:57 -0700
Message-Id: <20230609161058.3485225-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230609161058.3485225-1-anthony.l.nguyen@intel.com>
References: <20230609161058.3485225-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Guarantee that when probe() is run again, PTM and PCI busmaster will be
in the same state as it was if the driver was never loaded.

Avoid an i225/i226 hardware issue that PTM requests can be made even
though PCI bus mastering is not enabled. These unexpected PTM requests
can crash some systems.

So, "force" disable PTM and busmastering before removing the driver,
so they can be re-enabled in the right order during probe(). This is
more like a workaround and should be applicable for i225 and i226, in
any platform.

Fixes: 1b5d73fb8624 ("igc: Enable PCIe PTM")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f986e88be5c1..fa764190f270 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6730,6 +6730,9 @@ static void igc_remove(struct pci_dev *pdev)
 
 	igc_ptp_stop(adapter);
 
+	pci_disable_ptm(pdev);
+	pci_clear_master(pdev);
+
 	set_bit(__IGC_DOWN, &adapter->state);
 
 	del_timer_sync(&adapter->watchdog_timer);
-- 
2.38.1


