Return-Path: <netdev+bounces-1231-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A942F6FCC73
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:13:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A0EF28136F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9878B182AC;
	Tue,  9 May 2023 17:13:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860FE17AD7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 17:13:06 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F26AB
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683652385; x=1715188385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Incsq6Pn1Z9IUkTEpPUdh20BK7H7a0CHw4oJRUlQoyg=;
  b=P06WeHW3rIoEjvI4Ta6KWL9DjuRp/st15VlHBSimpcefsr0IKd2CymnC
   nT4WcXm/V0689xkhZXk5IwKm2v71JU+i/lg18zRr8zK45LGgQTGwfkSDs
   goCC/bC2NLR6zq2AV1hdl7pQr7cJzp555SeADu5rJuxWwupBLD0xMAmnM
   412l9phoNsRh69XTAXeWAiUe6VepycDROcNQgMc+JFioVK0gicIoZX7LO
   RaxO7kdUM89IBsxjzEu7RNjLBwUdOvO0IF+bVWh80NNm59mzOeqPnt7o9
   g1cV4STaGu9k/2UhmvhW3Mrwq5+uqA8/BlJrtsNe61UK0ThMMJaqDbJbE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="339227620"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="339227620"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:13:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="729601142"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="729601142"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga008.jf.intel.com with ESMTP; 09 May 2023 10:13:03 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	anthony.l.nguyen@intel.com,
	sasha.neftin@intel.com,
	Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 1/3] igc: Clean the TX buffer and TX descriptor ring
Date: Tue,  9 May 2023 10:09:33 -0700
Message-Id: <20230509170935.2237051-2-anthony.l.nguyen@intel.com>
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

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

There could be a race condition during link down where interrupt
being generated and igc_clean_tx_irq() been called to perform the
TX completion. Properly clear the TX buffer and TX descriptor ring
to avoid those case.

Fixes: 13b5b7fd6a4a ("igc: Add support for Tx/Rx rings")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1c4676882082..5767e691b401 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -254,6 +254,13 @@ static void igc_clean_tx_ring(struct igc_ring *tx_ring)
 	/* reset BQL for queue */
 	netdev_tx_reset_queue(txring_txq(tx_ring));
 
+	/* Zero out the buffer ring */
+	memset(tx_ring->tx_buffer_info, 0,
+	       sizeof(*tx_ring->tx_buffer_info) * tx_ring->count);
+
+	/* Zero out the descriptor ring */
+	memset(tx_ring->desc, 0, tx_ring->size);
+
 	/* reset next_to_use and next_to_clean */
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
-- 
2.38.1


