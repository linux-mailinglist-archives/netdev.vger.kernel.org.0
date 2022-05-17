Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F6F52A993
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 19:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344757AbiEQRs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 13:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351610AbiEQRsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 13:48:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86EB50449
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 10:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652809732; x=1684345732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TtdOvjr+Txaf2+TnH0b4Oi55APTlisfvTBmSJAPqXxw=;
  b=fm4GCU5XyRL9y2ZNWGmtCtOua0Z8O/h5wMyvwLthRkbFBEmFelv5cLAy
   gQbbkBS+nD11JblfuEHEbKQWezz609v90cV2wLXtD/IhmQ84wOsUurwMk
   UdN5MDZw0knWSSYPr5XZP8lWsqEYe3RSlr5lZwAiEZQkYZjHlhCp7ksfn
   iibzfQfToW266qZYFBlUtyOprRQFvhaHLLiRBu1SRTPnka9ccoU73wdkD
   18KTcuMDmvL69kmGQQcu0Cp7yp0+HIiV6D+ifoqYNYeo1PqMOliy1UoNj
   ZHTyhYfHpc8LfLKKRIvfSP8DCRB2Nl83SrYmXyzrdhwyPPx9fXRhMqS1i
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="253316425"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="253316425"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 10:48:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="545015279"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 17 May 2022 10:48:50 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 2/3] ice: fix possible under reporting of ethtool Tx and Rx statistics
Date:   Tue, 17 May 2022 10:45:46 -0700
Message-Id: <20220517174547.1757401-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220517174547.1757401-1-anthony.l.nguyen@intel.com>
References: <20220517174547.1757401-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

The hardware statistics counters are not cleared during resets so the
drivers first access is to initialize the baseline and then subsequent
reads are for reporting the counters. The statistics counters are read
during the watchdog subtask when the interface is up. If the baseline
is not initialized before the interface is up, then there can be a brief
window in which some traffic can be transmitted/received before the
initial baseline reading takes place.

Directly initialize ethtool statistics in driver open so the baseline will
be initialized when the interface is up, and any dropped packets
incremented before the interface is up won't be reported.

Fixes: 28dc1b86f8ea9 ("ice: ignore dropped packets during init")
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 949669fed7d6..963a5f40e071 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6172,9 +6172,10 @@ static int ice_up_complete(struct ice_vsi *vsi)
 			ice_ptp_link_change(pf, pf->hw.pf_id, true);
 	}
 
-	/* clear this now, and the first stats read will be used as baseline */
-	vsi->stat_offsets_loaded = false;
-
+	/* Perform an initial read of the statistics registers now to
+	 * set the baseline so counters are ready when interface is up
+	 */
+	ice_update_eth_stats(vsi);
 	ice_service_task_schedule(pf);
 
 	return 0;
-- 
2.35.1

