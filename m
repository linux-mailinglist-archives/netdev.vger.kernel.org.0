Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C0D1E97A5
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgEaMgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:12466 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgEaMgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:24 -0400
IronPort-SDR: zLXUX90tsaE/h/gpvy+5WuG8D+5pfVPhFCBAS34czr+N/5hBs+HdMfFZd1Ixi7nRy51O7dFvFA
 STB2fex7g/1Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:22 -0700
IronPort-SDR: h5GYDf+vfyA5IaJkWZNQ2K1txQ5ykdvob9WJaimRNKfAWDF3hNwXNYGcgNS8xz2NdBPreyKPvc
 S2Gp7TU2qMZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345427"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:22 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dan Nowlin <dan.nowlin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/14] ice: Increase timeout after PFR
Date:   Sun, 31 May 2020 05:36:09 -0700
Message-Id: <20200531123619.2887469-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Nowlin <dan.nowlin@intel.com>

To allow for resets during package download, increase the timeout period
after performing a PFR. The time waited is the global config lock
timeout plus the normal PFSWR timeout.

Signed-off-by: Dan Nowlin <dan.nowlin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 8c73e161829d..d4a31c734326 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -964,7 +964,12 @@ static enum ice_status ice_pf_reset(struct ice_hw *hw)
 
 	wr32(hw, PFGEN_CTRL, (reg | PFGEN_CTRL_PFSWR_M));
 
-	for (cnt = 0; cnt < ICE_PF_RESET_WAIT_COUNT; cnt++) {
+	/* Wait for the PFR to complete. The wait time is the global config lock
+	 * timeout plus the PFR timeout which will account for a possible reset
+	 * that is occurring during a download package operation.
+	 */
+	for (cnt = 0; cnt < ICE_GLOBAL_CFG_LOCK_TIMEOUT +
+	     ICE_PF_RESET_WAIT_COUNT; cnt++) {
 		reg = rd32(hw, PFGEN_CTRL);
 		if (!(reg & PFGEN_CTRL_PFSWR_M))
 			break;
-- 
2.26.2

