Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0B563E0E7
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiK3Tns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiK3Tno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:43:44 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADB093A72
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669837423; x=1701373423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A7a9sqkLbE6Gtt15Ja5DbI50d22X6kyhB4O3QldroEU=;
  b=kzOhLKtOoamqE/UlJgpNh+spulgJmzAhzjDHTg/c6ZaYtlmfOnpVZvxm
   nOw/zcyYTIo9T9z05JI2XzPb8qiHdKeCF8M2e0Km/H0sdw2QgjfKimZGr
   4/attlbl/zHR7tTQfQF00ksejjJTdKQYYdkn7iJZQrvJmSoxcdaS4dGER
   yEv1JwYSFGYVspa8lUDCTH/HHey37Yd30WTCOhLYEeHrvuCihIqcqYHxC
   /BtxsO/D8a0VtLAphAhsgSNJzq4mfsfn/Pj/38jf9x3Bu1UTZB6eOjwnO
   jXCbwv8ybNcd/ENz+fnGxjZ6o2sb2lnGUPsKWaSweGAn1sXNTxYx+q7DE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303098376"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303098376"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:43:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818752283"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818752283"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 11:43:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 04/14] ice: fix misuse of "link err" with "link status"
Date:   Wed, 30 Nov 2022 11:43:20 -0800
Message-Id: <20221130194330.3257836-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

