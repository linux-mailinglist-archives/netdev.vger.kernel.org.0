Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C4F4D396A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiCITEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237182AbiCITEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:04:01 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F7FD5571
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646852580; x=1678388580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/inSL9WQXyfcGDF9DaR5FrNbbLiseszpXmCxevEHIdo=;
  b=GGm/xjtEjQAj76tM6JhR+tOx+IDaQDuenHLoBVGFlYVY5PcyxTHKtwh3
   yJOtKcBtrltka1/43r+FJtqCGE2srFCkQNQzc+TZGLVfXQBs0FuCYHdTF
   3yu21FN4WzyAaWc6iMcHG0agvYKVwV5MkS6qvCvqjwm2XDx7JAMqeHBH5
   fAahQrQipHwH2uBAMdA+QpRqMVoT+S2ilwVHEH73uaXTW2XnzxTSbvhMN
   150jaRjT/tnZiuBKvIEmzfiGH9p6oRcFCRIoemlqz3Lf/15t/7apr5ebI
   IH0N/je0ZmFNbW7Q5ypr33o+aBAlnx2l6Yhr/hnkOyqlMTIMQ2enZcgph
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="341494157"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="341494157"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:02:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="781188758"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 09 Mar 2022 11:02:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/5] ice: change "can't set link" message to dbg level
Date:   Wed,  9 Mar 2022 11:03:13 -0800
Message-Id: <20220309190315.1380414-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220309190315.1380414-1-anthony.l.nguyen@intel.com>
References: <20220309190315.1380414-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Toppins <jtoppins@redhat.com>

In the case where the link is owned by manageability, the firmware is
not allowed to set the link state, so an error code is returned.
This however is non-fatal and there is nothing the operator can do,
so instead of confusing the operator with messages they can do nothing
about hide this message behind the debug log level.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 113a2c56c14c..b897926f817d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3960,9 +3960,9 @@ int ice_set_link(struct ice_vsi *vsi, bool ena)
 	 */
 	if (status == -EIO) {
 		if (hw->adminq.sq_last_status == ICE_AQ_RC_EMODE)
-			dev_warn(dev, "can't set link to %s, err %d aq_err %s. not fatal, continuing\n",
-				 (ena ? "ON" : "OFF"), status,
-				 ice_aq_str(hw->adminq.sq_last_status));
+			dev_dbg(dev, "can't set link to %s, err %d aq_err %s. not fatal, continuing\n",
+				(ena ? "ON" : "OFF"), status,
+				ice_aq_str(hw->adminq.sq_last_status));
 	} else if (status) {
 		dev_err(dev, "can't set link to %s, err %d aq_err %s\n",
 			(ena ? "ON" : "OFF"), status,
-- 
2.31.1

