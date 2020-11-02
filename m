Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812232A3677
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgKBWYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:24:24 -0500
Received: from mga05.intel.com ([192.55.52.43]:16123 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgKBWYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:24:19 -0500
IronPort-SDR: KXfrXCIm0LEXuw5PTyBMGhcN+ylyonuj5bIcSTp42KEZDRWfelpouHTPAzHFo7P7h01f1XdxrO
 brAzZ7wqpy5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="253670973"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="253670973"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 14:24:19 -0800
IronPort-SDR: aIi22DFeWELVeyS0ENnGB/kH+YsC11UVPOvXZFYyJZ3xSi8wuHdaCTjKsDjvxXKbHcKtpMBbaq
 WRgbLcxXhj9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="305591784"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2020 14:24:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 08/15] ice: don't always return an error for Get PHY Abilities AQ command
Date:   Mon,  2 Nov 2020 14:23:31 -0800
Message-Id: <20201102222338.1442081-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
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

