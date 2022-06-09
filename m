Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838BB5451ED
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344744AbiFIQ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 12:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241494AbiFIQ3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 12:29:23 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CFD1BAE91
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 09:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654792162; x=1686328162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nORWRWRP3MST4Rzpy3Izfg+OXdWs1VITQAZo3lG4bw4=;
  b=D7cGYTWcZV+yTQj7mewfH21xi7GA5d2Pr+VN4jYGhNe/wKM+EQa0+xrX
   Lk1K6woMLf9PUOLDobEr6uYucKFPuMXk51sjzuRuKT3UInQLYihZOUtgt
   TuiyEQdN+4+u1xxwl7a7W+owqn1SxAh4fLfsayaqSWKxmvrPHTv6XHTV+
   xaD6FWTd6Y4f3HHssw+PnkGvWHa4msXNlhZpXP+Ih5pEjpexhZtoBm0fa
   NU7p5cotJIhuw6yORUkCBvkaYGH6etddk1CnsO+qNG4qFQ56JZ5bcNVjV
   4FY3xP6+5VlwkxEuyLTaM7PzYEOm9Zvty7VoZjL0j6TTSGA+4s5lnCLO4
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="278486090"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="278486090"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 09:29:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="615975892"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 09 Jun 2022 09:29:20 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Wilczynski <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 4/4] iavf: Fix issue with MAC address of VF shown as zero
Date:   Thu,  9 Jun 2022 09:26:20 -0700
Message-Id: <20220609162620.2619258-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220609162620.2619258-1-anthony.l.nguyen@intel.com>
References: <20220609162620.2619258-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Wilczynski <michal.wilczynski@intel.com>

After reinitialization of iavf, ice driver gets VIRTCHNL_OP_ADD_ETH_ADDR
message with incorrectly set type of MAC address. Hardware address should
have is_primary flag set as true. This way ice driver knows what it has
to set as a MAC address.

Check if the address is primary in iavf_add_filter function and set flag
accordingly.

To test set all-zero MAC on a VF. This triggers iavf re-initialization
and VIRTCHNL_OP_ADD_ETH_ADDR message gets sent to PF.
For example:

ip link set dev ens785 vf 0 mac 00:00:00:00:00:00

This triggers re-initialization of iavf. New MAC should be assigned.
Now check if MAC is non-zero:

ip link show dev ens785

Fixes: a3e839d539e0 ("iavf: Add usage of new virtchnl format to set default MAC")
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 7dfcf78b57fb..f3ecb3bca33d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -984,7 +984,7 @@ struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 		list_add_tail(&f->list, &adapter->mac_filter_list);
 		f->add = true;
 		f->is_new_mac = true;
-		f->is_primary = false;
+		f->is_primary = ether_addr_equal(macaddr, adapter->hw.mac.addr);
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
 	} else {
 		f->remove = false;
-- 
2.35.1

