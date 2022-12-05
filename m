Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0867F6436CF
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiLEVZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiLEVYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:24:35 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AE82CCA1
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 13:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670275472; x=1701811472;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9wS9hUmdoD49kpZHynHhKEQ18G4pakIGVa3FOfj0gKo=;
  b=OjATgkv0a480ZHVpnM9vxNyOPGuq23J4ECN/dGrma6zlP8XBDxeOYRw1
   m7LxQxweJA8mZkujsTfeg/8BTPOu6XkkcuwIIYEOlNAkC0wPCNSGunSYA
   mY+um98izxGu6LLs0iY+OPkInPf2w/DGWnXu/HnXBfk0ZRoZ9i/mFHaMO
   f9NSju2xPvpDM5qUIFNnSq2HEJH8LZrP5n7860HHMo8fVTD2m4eKmeEuw
   vCQ+xBnZJba3G5NmYb/+iJtdvO5yKohW+78HHym8Z6+BsyWPBCklIjPAm
   ZvYYlDA8RugMsvpF2yEjSZaI3YeQmGgNvZ4WEOltS6dfRB47bSWcwSTpB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="296157837"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="296157837"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 13:24:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="734744978"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="734744978"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Dec 2022 13:24:31 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com,
        Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 7/8] igc: Use strict cycles for Qbv scheduling
Date:   Mon,  5 Dec 2022 13:24:13 -0800
Message-Id: <20221205212414.3197525-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
References: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_tsn.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 5d351c873c41..d26fc0f47640 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -132,15 +132,8 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
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

