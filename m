Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A5164E47C
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 00:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiLOXI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 18:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLOXI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 18:08:56 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0DA2655D
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 15:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671145734; x=1702681734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r1S/Lpt/jVTuL5B3Tpg/bwUo7TTTuCG8bdUyqSh+H0Q=;
  b=DkG42H5W40ugv+seyiakt+hJ6dxHxnbJ6q0t3Eghix7isZPTsKHEpuuC
   Q8WitKJ5G4ib/ZB5Ug4Z/fmgfzVvPVPM5ZGj1wcaybI8cUNHBkO7pM4An
   dZnm4bs2JdVqZ49zmn98/3rkfwuBQqqwVqkb3EWYfTicOU9bucNJ0TBvU
   ibIPgmf8U79ix6iXQJHUmRP66EY1ZIx1LKiRfMfr26cBzJ1bMaLfIvovk
   BsKQ+Yp9fmZRKbXTAy2+uro4Npe4yOjbqwDLPxUeut2z1MHR1huD98Crx
   dcHgJ0y4244mYcwCnSAvGmQAP69Mkf0ANTyhdXAbdSdfGREufFxcBJt1c
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="316469428"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="316469428"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 15:08:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="718172558"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="718172558"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 15 Dec 2022 15:08:07 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com,
        Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 2/6] igc: Use strict cycles for Qbv scheduling
Date:   Thu, 15 Dec 2022 15:07:54 -0800
Message-Id: <20221215230758.3595578-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221215230758.3595578-1-anthony.l.nguyen@intel.com>
References: <20221215230758.3595578-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Configuring strict cycle mode in the controller forces more well
behaved transmissions when taprio is offloaded.

When set this strict_cycle and strict_end, transmission is not
enabled if the whole packet cannot be completed before end of
the Qbv cycle.

Fixes: 82faa9b79950 ("igc: Add support for ETF offloading")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_tsn.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index f975ed807da1..684aedd4d088 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -140,15 +140,8 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		wr32(IGC_STQT(i), ring->start_time);
 		wr32(IGC_ENDQT(i), ring->end_time);
 
-		if (adapter->base_time) {
-			/* If we have a base_time we are in "taprio"
-			 * mode and we need to be strict about the
-			 * cycles: only transmit a packet if it can be
-			 * completed during that cycle.
-			 */
-			txqctl |= IGC_TXQCTL_STRICT_CYCLE |
-				IGC_TXQCTL_STRICT_END;
-		}
+		txqctl |= IGC_TXQCTL_STRICT_CYCLE |
+			IGC_TXQCTL_STRICT_END;
 
 		if (ring->launchtime_enable)
 			txqctl |= IGC_TXQCTL_QUEUE_MODE_LAUNCHT;
-- 
2.35.1

