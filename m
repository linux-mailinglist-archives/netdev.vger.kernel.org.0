Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B7D2B2716
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgKMVfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:35:34 -0500
Received: from mga06.intel.com ([134.134.136.31]:18348 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgKMVeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:50 -0500
IronPort-SDR: UhjQzBMdbgyLNT8R+kgD8vfHaNJ/aXtk95PmEBUt6V8FXCtMjRgjXh8mGO2ArwpnN7xi+elw9r
 SIge9bsb6rBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="232152356"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="232152356"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:34:39 -0800
IronPort-SDR: 3ydHH19Oi2Xcr+QulEt0og9O9cD7eBmN34LEclxWi3R6wkF8Yr62O59q9WVAL9CRX57hjVtKzN
 G+tyeT6Dwu6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="366861610"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Nov 2020 13:34:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.neti, kuba@kernel.org
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 08/15] ice: don't always return an error for Get PHY Abilities AQ command
Date:   Fri, 13 Nov 2020 13:34:00 -0800
Message-Id: <20201113213407.2131340-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
References: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

There are times when the driver shouldn't return an error when the Get
PHY abilities AQ command (0x0600) returns an error. Instead the driver
should log that the error occurred and continue on. This allows the
driver to load even though the AQ command failed. The user can then
later determine the reason for the failure and correct it.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 7db5fd977367..3c600808d0da 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -925,7 +925,7 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 				     ICE_AQC_REPORT_TOPO_CAP, pcaps, NULL);
 	devm_kfree(ice_hw_to_dev(hw), pcaps);
 	if (status)
-		goto err_unroll_sched;
+		ice_debug(hw, ICE_DBG_PHY, "Get PHY capabilities failed, continuing anyway\n");
 
 	/* Initialize port_info struct with link information */
 	status = ice_aq_get_link_info(hw->port_info, false, NULL, NULL);
-- 
2.26.2

