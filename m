Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E54562514
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237534AbiF3VXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbiF3VXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:23:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D4713E9E
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624193; x=1688160193;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0T3kOyq65djR9Vn2arouEshO4RuelC97Q/sZ8DMn50A=;
  b=KYdyBSIFBKZS8koSSmBC+K1S8j5mzIuEPbBpjhr/KzbiCHeXYHlirlB1
   /jl4L0Kf5/uW0gmXgsOoT0YanPdyX3+MJVyW6EUlySVJ3tOAZL3B6lnJl
   EoQARgyfxAzY8e78UZJP/GRVyuhHcVmSVhlN52jKvBJBtKaYQBi+ZW9OW
   VIljI4/Vp6qMnT9K9Z1iU5S0cBL3PvtnjO4HT0eCada7LfqDbuOmZsoj8
   urO7w0h9KoG5C3MEr9xESzH25PSwE4/jnFGeqG0WxNbjBoTA2yfiIl3qi
   3FzDTg16/s8PfTgXId/jTcyH716h6Heb2WOZj8K1whMkvNqeHB9Yg3wUt
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="262274445"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="262274445"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:23:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837768335"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:23:01 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Lu Wei <luwei32@huawei.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/5] ice: use eth_broadcast_addr() to set broadcast address
Date:   Thu, 30 Jun 2022 14:19:59 -0700
Message-Id: <20220630212000.3006759-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220630212000.3006759-1-anthony.l.nguyen@intel.com>
References: <20220630212000.3006759-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>

Use eth_broadcast_addr() to set broadcast address instead of memset().

Signed-off-by: Lu Wei <luwei32@huawei.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 2fb3ef918e3b..14795157846b 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1256,7 +1256,7 @@ ice_handle_tclass_action(struct ice_vsi *vsi,
 			   ICE_TC_FLWR_FIELD_ENC_DST_MAC)) {
 		ether_addr_copy(fltr->outer_headers.l2_key.dst_mac,
 				vsi->netdev->dev_addr);
-		memset(fltr->outer_headers.l2_mask.dst_mac, 0xff, ETH_ALEN);
+		eth_broadcast_addr(fltr->outer_headers.l2_mask.dst_mac);
 	}
 
 	/* validate specified dest MAC address, make sure either it belongs to
-- 
2.35.1

