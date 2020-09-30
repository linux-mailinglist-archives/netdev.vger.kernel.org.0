Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C6627DD4D
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgI3AQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:16:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:41608 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbgI3AQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 20:16:09 -0400
IronPort-SDR: uvPLCbSPYjfWufBqCWFIiJOehpOfBzBUZI8uLekvalZOgTyBTKheJes4FMwkFfnVbgS9ircrAA
 0gYozSyC8tlA==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="180482221"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="180482221"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 17:16:07 -0700
IronPort-SDR: ACqL0YofA8k1Wjiqcl2yKgpnCfCKvCq5DlT/a3YXdPlMqmvIRIcl0zMhWnlBHj9CTrcPtsE2jy
 2dEWCRCqcajw==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="514086698"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 17:16:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Brijesh Behera <brijeshx.behera@intel.com>
Subject: [PATCH net 1/2] ice: increase maximum wait time for flash write commands
Date:   Tue, 29 Sep 2020 17:15:47 -0700
Message-Id: <20200930001548.1927323-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice driver needs to wait for a firmware response to each command to
write a block of data to the scratch area used to update the device
firmware. The driver currently waits for up to 1 second for this to be
returned.

It turns out that firmware might take longer than 1 second to return
a completion in some cases. If this happens, the flash update will fail
to complete.

Fix this by increasing the maximum time that the driver will wait for
both writing a block of data, and for activating the new NVM bank. The
timeout for an erase command is already several minutes, as the firmware
had to erase the entire bank which was already expected to take a minute
or more in the worst case.

In the case where firmware really won't respond, we will now take longer
to fail. However, this ensures that if the firmware is simply slow to
respond, the flash update can still complete. This new maximum timeout
should not adversely increase the update time, as the implementation for
wait_event_interruptible_timeout, and should wake very soon after we get
a completion event. It is better for a flash update be slow but still
succeed than to fail because we gave up too quickly.

Fixes: d69ea414c9b4 ("ice: implement device flash update via devlink")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Brijesh Behera <brijeshx.behera@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fw_update.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index deaefe00c9c0..8968fdd4816b 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -289,7 +289,13 @@ ice_write_one_nvm_block(struct ice_pf *pf, u16 module, u32 offset,
 		return -EIO;
 	}
 
-	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_write, HZ, &event);
+	/* In most cases, firmware reports a write completion within a few
+	 * milliseconds. However, it has been observed that a completion might
+	 * take more than a second to complete in some cases. The timeout here
+	 * is conservative and is intended to prevent failure to update when
+	 * firmware is slow to respond.
+	 */
+	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_write, 15 * HZ, &event);
 	if (err) {
 		dev_err(dev, "Timed out waiting for firmware write completion for module 0x%02x, err %d\n",
 			module, err);
@@ -513,7 +519,7 @@ static int ice_switch_flash_banks(struct ice_pf *pf, u8 activate_flags,
 		return -EIO;
 	}
 
-	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_write_activate, HZ,
+	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_write_activate, 30 * HZ,
 				    &event);
 	if (err) {
 		dev_err(dev, "Timed out waiting for firmware to switch active flash banks, err %d\n",
-- 
2.26.2

