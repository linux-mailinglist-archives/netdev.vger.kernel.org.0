Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D1668A472
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbjBCVQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbjBCVPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:15:52 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E930A99D4D
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 13:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675458938; x=1706994938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mseGOT95QXFoCbiyUrGupk3KcKoGiMkHzjmHb1IjaqI=;
  b=FJGydTBSroz6NOfXQPpAC/EI1AzPai+CjEC74vA9WqInu7RYOxc8pxeA
   TU4fdBefZgCDTfoq2g4zdJWq3ogyjiN2AZ4i92U1jVZjIjny8WgN4WsrF
   Ggjos+r1Ek/Rb9Mu0y1wYovdJG5fCbKNgXkkErinZYx8Ud+G8zN990ca0
   PPk1lLoILocrBFX0wQTFZ61x+hB8cviiSX2Zsu0hEEZMIYrLo0tXgBhCo
   jAzzDwuINx6XWD442xB09IzXyjdCtAITITZduc+zTyUaDyhJY2+FAd9l0
   EAZubeZVufFM0/4iuvjLsZpQx4ofgOewN8hFJ7mQuzYmDWcArb7qcwYO1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="393446843"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="393446843"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 13:15:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="911280499"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="911280499"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2023 13:15:15 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 07/10] ice: sync netdev filters after clearing VSI
Date:   Fri,  3 Feb 2023 13:14:53 -0800
Message-Id: <20230203211456.705649-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230203211456.705649-1-anthony.l.nguyen@intel.com>
References: <20230203211456.705649-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

In driver reload path the netdev isn't removed, but VSI is. Remove
filters on netdev right after removing them on VSI.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index 40e678cfb507..aff7a141c30d 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -208,6 +208,11 @@ static int ice_fltr_remove_eth_list(struct ice_vsi *vsi, struct list_head *list)
 void ice_fltr_remove_all(struct ice_vsi *vsi)
 {
 	ice_remove_vsi_fltr(&vsi->back->hw, vsi->idx);
+	/* sync netdev filters if exist */
+	if (vsi->netdev) {
+		__dev_uc_unsync(vsi->netdev, NULL);
+		__dev_mc_unsync(vsi->netdev, NULL);
+	}
 }
 
 /**
-- 
2.38.1

