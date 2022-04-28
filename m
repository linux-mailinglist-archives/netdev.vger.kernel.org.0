Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1082513AE0
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350502AbiD1Rap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350450AbiD1Rab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:30:31 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F6E3C712
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651166836; x=1682702836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tmhtyc5shv1prcs+aSllAWpjuIe9K/M5rKs/Df8gji4=;
  b=DI1sTwjeh9BZzv6R42p6Zm1CWTZPHXtFLow7+Q0WZAXXYxhfNYKpeyt8
   iz/F+9cC0NikfOgLOaZarrHZu1wuepmIlPGukM4qMGOzUl7dVsIzN2jN2
   6qDdOX+lS7erMwxx40EDNspqCIroCf75Q//C2m6DxYhY339BHuH503Kyw
   PB8zEC6srrF8NvWRtJxfPS3T4XwTJINHb5ss+XolRHeSZhdm7aUCYkFoH
   7sVoNEayM07U/22AL3MYj3vkdEwnbWrtEAcnCDgtzgf6fLHQDKBT2H9/K
   7ogZjTe/lMyY9I9RsTjfHrf0Vlx8Rd1HBiizRV42Ei/w6PynzXpCd+uHY
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="329306355"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="329306355"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 10:27:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="581497037"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 10:27:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 04/11] ice: return ENOSPC when exceeding ICE_MAX_CHAIN_WORDS
Date:   Thu, 28 Apr 2022 10:24:23 -0700
Message-Id: <20220428172430.1004528-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

When number of words exceeds ICE_MAX_CHAIN_WORDS, -ENOSPC
should be returned not -EINVAL. Do not overwrite this
error code in ice_add_tc_flower_adv_fltr.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Suggested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 5 ++++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 1 -
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 496250f9f8fc..9f0a4dfb4818 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5992,9 +5992,12 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 				word_cnt++;
 	}
 
-	if (!word_cnt || word_cnt > ICE_MAX_CHAIN_WORDS)
+	if (!word_cnt)
 		return -EINVAL;
 
+	if (word_cnt > ICE_MAX_CHAIN_WORDS)
+		return -ENOSPC;
+
 	/* locate a dummy packet */
 	profile = ice_find_dummy_packet(lkups, lkups_cnt, rinfo->tun_type);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index e1e294a1654c..1308adcfde1b 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -745,7 +745,6 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 	} else if (ret) {
 		NL_SET_ERR_MSG_MOD(tc_fltr->extack,
 				   "Unable to add filter due to error");
-		ret = -EIO;
 		goto exit;
 	}
 
-- 
2.31.1

