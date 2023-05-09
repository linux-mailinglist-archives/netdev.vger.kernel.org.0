Return-Path: <netdev+bounces-1232-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 037EB6FCC74
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE44528139E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E16BE182C5;
	Tue,  9 May 2023 17:13:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0AF182BD
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 17:13:06 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D029F3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683652385; x=1715188385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1bcE1wzfvfpnBif2ENOLomp1qbl/hcHKpAgwo+UI0Sg=;
  b=j+hTUa3R9Y6Cahua/OdczyiysaE9Ywqu1eiwlJWr5lBPXNoYxjScs6kq
   nL3DqZYgpNINR1LkthXjsUAbG74tZ0kwWLWh2qyL8iyJ/RP4bmyOnctTZ
   8xlwHSo323a7HJ/Dxupz7Uj41Qr3wiUOak+PHbQO4dYLcm0vuROey/KsP
   mv8gDwpHdWQZ08hkMYZrXrBSyfn3Ks5+gUosjZFbWvdmn4pm7FedcwD1w
   qvw6WBtH5BI4/MscIc4bZKqYw2HqLLGqlydlLMGV+35SeVJiwRGbF8AHE
   LWHb/xTdsexKpv7f5dlDlMh8Zs5WZpir0dro04VYuRTRID9yckV7L+WdM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="339227627"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="339227627"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:13:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="729601145"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="729601145"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga008.jf.intel.com with ESMTP; 09 May 2023 10:13:03 -0700
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
Subject: [PATCH net 2/3] igc: Fix possible system crash when loading module
Date: Tue,  9 May 2023 10:09:34 -0700
Message-Id: <20230509170935.2237051-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230509170935.2237051-1-anthony.l.nguyen@intel.com>
References: <20230509170935.2237051-1-anthony.l.nguyen@intel.com>
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
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
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
index 5767e691b401..5213f3da1fe7 100644
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


