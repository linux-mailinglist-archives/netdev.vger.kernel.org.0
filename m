Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A0864781B
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 22:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiLHVjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 16:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiLHVjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 16:39:42 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A6113D4C
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 13:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670535581; x=1702071581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A7a9sqkLbE6Gtt15Ja5DbI50d22X6kyhB4O3QldroEU=;
  b=ZSzWujcE9aGh+emTSEXrXRSd1w0sivwebQX0eQqDLCX6ZIHgn5l+e8yI
   DjzqLc3ayY2TqLb51KsLYE9CWpKBImHbrOUaNmOR5peh22L6tSi8UwsGg
   zna1Vb9qrc7o8g61ZYZslp2wFrw6QpKdpGU/yE7Sy1xrwHRENxvdBIUzd
   F9yj3LFBVGe7NoY90+BeHyMI0IyJJvopPIcyVO0PCzp3Z2CjzDSFUHDum
   ftlWexWjN79FzxNK+YiSNXYDnztm4py3J4Fwq0q2H/QC/bwNZg4v1gNxv
   hHFTNCdP6nHXYt8sxl5r66copsP/NBVXKGT5fxkrqKeM2r1Dw+AopsXjT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="317328180"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="317328180"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:39:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="624873979"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="624873979"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 08 Dec 2022 13:39:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        leon@kernel.org, saeed@kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v3 04/14] ice: fix misuse of "link err" with "link status"
Date:   Thu,  8 Dec 2022 13:39:22 -0800
Message-Id: <20221208213932.1274143-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221208213932.1274143-1-anthony.l.nguyen@intel.com>
References: <20221208213932.1274143-1-anthony.l.nguyen@intel.com>
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

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_ptp_link_change function has a comment which mentions "link
err" when referring to the current link status. We are storing the status
of whether link is up or down, which is not an error.

It is appears that this use of err accidentally got included due to an
overzealous search and replace when removing the ice_status enum and local
status variable.

Fix the wording to use the correct term.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index f93fa0273252..5607ec578499 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1347,7 +1347,7 @@ int ice_ptp_link_change(struct ice_pf *pf, u8 port, bool linkup)
 	if (ptp_port->port_num != port)
 		return -EINVAL;
 
-	/* Update cached link err for this port immediately */
+	/* Update cached link status for this port immediately */
 	ptp_port->link_up = linkup;
 
 	if (!test_bit(ICE_FLAG_PTP, pf->flags))
-- 
2.35.1

