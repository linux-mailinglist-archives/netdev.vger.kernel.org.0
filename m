Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2065904C9
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiHKQqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239115AbiHKQpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:45:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09594C4C9C
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660234649; x=1691770649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RXcfGZlZnkvf2BtTsgGiKVn2mmSeilu35t5cqrSPKQg=;
  b=mcjjSh8MGCK7RQrXli39j50FyEHm8TCzDbdmfayI9SUm2Dhyrc/PHy4M
   B3gx7fapGUl0vQaNAhtI5mImcav5klJ3igBBVpwt3tisn0nyiU06FR4gp
   rIFW+qytPD/fMLwL2qxAlsdetDw7qduY2oSzKzvEKF57DIAzNeTijvBfW
   yjanFixQFau+QBh+IdlT5Cspv3a8OeowyHywJwN/Qc70dILTORG7Ork3M
   HaoH2TiDnmYovYgnHhcQxcPbWLUmPeremoQumAAYbqU7dFakOhsAoaT87
   MUzm69uFwajD4uSbcU/Ew6VK9pp68HQtXwcJd98uiwofWRLgtgarGBmdb
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="274448354"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="274448354"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 09:17:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="731928499"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 11 Aug 2022 09:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Benjamin Mikailenko <benjamin.mikailenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net 1/2] ice: Fix VSI rebuild WARN_ON check for VF
Date:   Thu, 11 Aug 2022 09:17:13 -0700
Message-Id: <20220811161714.305094-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811161714.305094-1-anthony.l.nguyen@intel.com>
References: <20220811161714.305094-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Mikailenko <benjamin.mikailenko@intel.com>

In commit b03d519d3460 ("ice: store VF pointer instead of VF ID")
WARN_ON checks were added to validate the vsi->vf pointer and
catch programming errors. However, one check to vsi->vf was missed.
This caused a call trace when resetting VFs.

Fix ice_vsi_rebuild by encompassing VF pointer in WARN_ON check.

Fixes: b03d519d3460 ("ice: store VF pointer instead of VF ID")
Signed-off-by: Benjamin Mikailenko <benjamin.mikailenko@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a830f7f9aed0..0d4dbca88964 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3181,7 +3181,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 	pf = vsi->back;
 	vtype = vsi->type;
-	if (WARN_ON(vtype == ICE_VSI_VF) && !vsi->vf)
+	if (WARN_ON(vtype == ICE_VSI_VF && !vsi->vf))
 		return -EINVAL;
 
 	ice_vsi_init_vlan_ops(vsi);
-- 
2.35.1

