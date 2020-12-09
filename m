Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31652D4C98
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 22:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387966AbgLIVPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 16:15:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:24061 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387611AbgLIVOv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 16:14:51 -0500
IronPort-SDR: w1Qayq3SiPVXu98lZCP8iGfNRLTtafhYrvqjt+BA2VOnAHEkVgoAZm4iWA30+czNt75j7lGC1m
 9hTlbc9nEj7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="170641630"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="170641630"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 13:13:53 -0800
IronPort-SDR: kOOrGCTmqYHRL8jrKfVX25kOWDIpz2T/iWTlCGkL3MEdco3Cxx5KU2j5IBWQdcmghOB9AAvGXs
 q4HKgcmM4RMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="408228645"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 09 Dec 2020 13:13:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v4 2/9] ice: don't always return an error for Get PHY Abilities AQ command
Date:   Wed,  9 Dec 2020 13:13:05 -0800
Message-Id: <20201209211312.3850588-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209211312.3850588-1-anthony.l.nguyen@intel.com>
References: <20201209211312.3850588-1-anthony.l.nguyen@intel.com>
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
 drivers/net/ethernet/intel/ice/ice_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 7db5fd977367..ab9d7ae93706 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -925,7 +925,8 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 				     ICE_AQC_REPORT_TOPO_CAP, pcaps, NULL);
 	devm_kfree(ice_hw_to_dev(hw), pcaps);
 	if (status)
-		goto err_unroll_sched;
+		dev_warn(ice_hw_to_dev(hw), "Get PHY capabilities failed status = %d, continuing anyway\n",
+			 status);
 
 	/* Initialize port_info struct with link information */
 	status = ice_aq_get_link_info(hw->port_info, false, NULL, NULL);
-- 
2.26.2

