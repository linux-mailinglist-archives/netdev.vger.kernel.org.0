Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490CF1E711B
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437964AbgE2AIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:08:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:2081 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437867AbgE2AId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:33 -0400
IronPort-SDR: ox1rLcce4/BvEWr2Gkk7ZEZgbUvw21L97hGOtK13Vy5njn29NdU3X+EkF9OS13zi+2OYsivpV0
 do7uWBPqmGSA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:33 -0700
IronPort-SDR: hoK/leRAwE/wAujydk3hqbAfcI80EvCCOMahM+hzEpPayjkf7jly3vHbv4ixnrfW6HI3wAeQTp
 Pfgut1NAad0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651612"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:32 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] ice: Poll for reset completion when DDP load fails
Date:   Thu, 28 May 2020 17:08:17 -0700
Message-Id: <20200529000831.2803870-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

There are certain cases where the DDP load fails and the FW issues a
core reset. For these cases, wait for reset to complete before
proceeding with reset of the driver init.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b64c4e796636..6583acf32575 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3086,6 +3086,9 @@ ice_log_pkg_init(struct ice_hw *hw, enum ice_status *status)
 		case ICE_AQ_RC_EBADMAN:
 		case ICE_AQ_RC_EBADBUF:
 			dev_err(dev, "An error occurred on the device while loading the DDP package.  The device will be reset.\n");
+			/* poll for reset to complete */
+			if (ice_check_reset(hw))
+				dev_err(dev, "Error resetting device. Please reload the driver\n");
 			return;
 		default:
 			break;
-- 
2.26.2

