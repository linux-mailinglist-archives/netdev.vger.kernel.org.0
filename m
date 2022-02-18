Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B934BC264
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240043AbiBRV4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:56:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbiBRV4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:56:13 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A2053B61
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645221356; x=1676757356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EZzG0H6Yl+N1On64DI+1xSc/LU79l5DDeK6h7Qtexqw=;
  b=hma2s2PWya6p8VgtSwBgcwAarXFKytsq98roBZPkMAadxkHydqNlCZc4
   X+t4JBEiGpMFvjeTiZn6aP+zoLnPn5T0q4dgzwf3w/gn+aCkmjtaWo4XK
   FBkpD87YcUTtggLv9ciZyYQkxpwID3min1LUyG9yt1M78NK2YKw7mXxMH
   +Ba+eXNgIyPEn9VfChvTiwIpPFpeaXPMz/mmRXsAMoeegVGKYojbhw4E1
   DTGWeWubGX/OsO144rlhx486e1MhBrvU0DIu0OUce/vVvR/EwFbSz97FP
   /ID4H4jfWHSmmaoQ4EeuggSadVltkLN5/nMfsNa4fdTO6Vd37U36XnkCe
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251179164"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251179164"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:55:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="626757378"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2022 13:55:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 5/5] ice: initialize local variable 'tlv'
Date:   Fri, 18 Feb 2022 13:55:54 -0800
Message-Id: <20220218215554.415323-6-anthony.l.nguyen@intel.com>
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

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this issues
ice_common.c:5008:21: warning: The left expression of the compound
  assignment is an uninitialized value. The computed value will
  also be garbage
  ldo->phy_type_low |= ((u64)buf << (i * 16));
  ~~~~~~~~~~~~~~~~~ ^

When called from ice_cfg_phy_fec() ldo is the uninitialized local
variable tlv.  So initialize.

Fixes: ea78ce4dab05 ("ice: add link lenient and default override support")
Signed-off-by: Tom Rix <trix@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index a6d7d3eff186..e2af99a763ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3340,7 +3340,7 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 
 	if (fec == ICE_FEC_AUTO && ice_fw_supports_link_override(hw) &&
 	    !ice_fw_supports_report_dflt_cfg(hw)) {
-		struct ice_link_default_override_tlv tlv;
+		struct ice_link_default_override_tlv tlv = { 0 };
 
 		status = ice_get_link_default_override(&tlv, pi);
 		if (status)
-- 
2.31.1

