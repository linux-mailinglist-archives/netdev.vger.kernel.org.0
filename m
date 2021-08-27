Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB44C3FA0B9
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 22:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhH0UlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 16:41:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:60747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231570AbhH0UlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 16:41:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="197589402"
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="197589402"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 13:40:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="685587305"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 27 Aug 2021 13:40:19 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        maciej.machnikowski@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 2/5] ice: remove dead code for allocating pin_config
Date:   Fri, 27 Aug 2021 13:43:55 -0700
Message-Id: <20210827204358.792803-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210827204358.792803-1-anthony.l.nguyen@intel.com>
References: <20210827204358.792803-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

We have code in the ice driver which allocates the pin_config structure
if n_pins is > 0, but we never set n_pins to be greater than zero.
There's no reason to keep this code until we actually have pin_config
support. Remove this. We can re-add it properly when we implement
support for pin_config for E810-T devices.

Fixes: 172db5f91d5f ("ice: add support for auxiliary input/output pins")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index f54148fb0e21..09d74e94feae 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1064,17 +1064,6 @@ static long ice_ptp_create_clock(struct ice_pf *pf)
 	info = &pf->ptp.info;
 	dev = ice_pf_to_dev(pf);
 
-	/* Allocate memory for kernel pins interface */
-	if (info->n_pins) {
-		info->pin_config = devm_kcalloc(dev, info->n_pins,
-						sizeof(*info->pin_config),
-						GFP_KERNEL);
-		if (!info->pin_config) {
-			info->n_pins = 0;
-			return -ENOMEM;
-		}
-	}
-
 	/* Attempt to register the clock before enabling the hardware. */
 	clock = ptp_clock_register(info, dev);
 	if (IS_ERR(clock))
-- 
2.26.2

