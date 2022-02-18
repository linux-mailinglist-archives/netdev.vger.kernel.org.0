Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB364BC262
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240039AbiBRV4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:56:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238703AbiBRV4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:56:12 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D25153B61
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645221355; x=1676757355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ceaXlOeuPD1enNRKsiuejQJZZygRGqohk2fuV6lCpis=;
  b=UOwF64kI9is4e2NoSKizxO/VcTY1uRHMBZb2hiPbePB5qkPcSxnWEh1/
   V5xGfUhKQi/I73NnpC9cPPsdCw+pE8y4Dw2tGQdhbqQ9fPQWMduJt/KfE
   nElmN0VD+b5L9zBMJQdyqlTohpqKMkBDs4tDapoQ8uEQbGmqURNtXgw3n
   kPV9s66xitCDSAPa+8uCSxHaD8i7SN9eHIndj3rDasEkIMarW5rkm6rei
   x1rn6Qks6pjr1iL/Ym/Ye83S6BwDVM7UjKSX0mIy67XyVbOWWjt+rhiaG
   ssaAEEyMtSZhO6EhAP1s0qIojXyUOKpyST5fFGNBJ9GRLUBjBoJJEoVA9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251179161"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251179161"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:55:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="626757369"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2022 13:55:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net 2/5] ice: fix setting l4 port flag when adding filter
Date:   Fri, 18 Feb 2022 13:55:51 -0800
Message-Id: <20220218215554.415323-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220218215554.415323-1-anthony.l.nguyen@intel.com>
References: <20220218215554.415323-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Accidentally filter flag for none encapsulated l4 port field is always
set. Even if user wants to add encapsulated l4 port field.

Remove this unnecessary flag setting.

Fixes: 9e300987d4a81 ("ice: VXLAN and Geneve TC support")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index e8aab664270a..65cf32eb4046 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -709,7 +709,7 @@ ice_tc_set_port(struct flow_match_ports match,
 			fltr->flags |= ICE_TC_FLWR_FIELD_ENC_DEST_L4_PORT;
 		else
 			fltr->flags |= ICE_TC_FLWR_FIELD_DEST_L4_PORT;
-		fltr->flags |= ICE_TC_FLWR_FIELD_DEST_L4_PORT;
+
 		headers->l4_key.dst_port = match.key->dst;
 		headers->l4_mask.dst_port = match.mask->dst;
 	}
@@ -718,7 +718,7 @@ ice_tc_set_port(struct flow_match_ports match,
 			fltr->flags |= ICE_TC_FLWR_FIELD_ENC_SRC_L4_PORT;
 		else
 			fltr->flags |= ICE_TC_FLWR_FIELD_SRC_L4_PORT;
-		fltr->flags |= ICE_TC_FLWR_FIELD_SRC_L4_PORT;
+
 		headers->l4_key.src_port = match.key->src;
 		headers->l4_mask.src_port = match.mask->src;
 	}
-- 
2.31.1

