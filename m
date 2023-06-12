Return-Path: <netdev+bounces-10229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5791372D136
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85F711C208F5
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ED6FD2F7;
	Mon, 12 Jun 2023 20:58:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E0719E4B
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 20:58:01 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9E746B4
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686603462; x=1718139462;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=olpNJQK0PpXcqiOa1N2oZUMrB9cVFlr8UO1NVFAXt5A=;
  b=hOdsekQFZzG2yMqC49nSlN2xLSaTM+Xl0smuqlqvgLvio9jVoqFpGSqO
   JssMCB0dm1w+8RxxrLXztw5J7JGV2fbDzJeeErVUkE3NUEm8aR/Bi5Zc2
   Dt6fO/WaVm155nstsjc8VJkLKlOG/qtYnOivtAlUIzJBpebUZJv0bqx9l
   dNGoIItUceAdPAXzytNYEGKhlkISUmKwdvcHpzuRq7SdOct0GDpY4HBF5
   XqfZxHbroZpc9muhsRPORIa7qUAndiraTLgwzshltwUECRn9p+YKyc2tp
   ocyqRZRgdPCOQ6/rMsPsOvsZaFEAe69ZSKrc5Ua49fmTpxuXfjdKycebs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="386548211"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="386548211"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 13:56:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="885586121"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="885586121"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 12 Jun 2023 13:56:50 -0700
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
Subject: [PATCH net v3 2/3] igc: Fix possible system crash when loading module
Date: Mon, 12 Jun 2023 13:52:07 -0700
Message-Id: <20230612205208.115292-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230612205208.115292-1-anthony.l.nguyen@intel.com>
References: <20230612205208.115292-1-anthony.l.nguyen@intel.com>
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


