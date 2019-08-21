Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2468198560
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbfHUUQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:16:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:19346 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730112AbfHUUQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 16:16:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 13:16:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="203148222"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 21 Aug 2019 13:16:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Marcin Formela <marcin.formela@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] i40e: fix retrying in i40e_aq_get_phy_capabilities
Date:   Wed, 21 Aug 2019 13:16:23 -0700
Message-Id: <20190821201623.5506-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
References: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Formela <marcin.formela@intel.com>

Fixed a bug where driver was breaking out of the loop and
reporting an error without retrying first.

Signed-off-by: Marcin Formela <marcin.formela@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index de996a80013e..46e649c09f72 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1577,19 +1577,22 @@ i40e_status i40e_aq_get_phy_capabilities(struct i40e_hw *hw,
 		status = i40e_asq_send_command(hw, &desc, abilities,
 					       abilities_size, cmd_details);
 
-		if (status)
-			break;
-
-		if (hw->aq.asq_last_status == I40E_AQ_RC_EIO) {
+		switch (hw->aq.asq_last_status) {
+		case I40E_AQ_RC_EIO:
 			status = I40E_ERR_UNKNOWN_PHY;
 			break;
-		} else if (hw->aq.asq_last_status == I40E_AQ_RC_EAGAIN) {
+		case I40E_AQ_RC_EAGAIN:
 			usleep_range(1000, 2000);
 			total_delay++;
 			status = I40E_ERR_TIMEOUT;
+			break;
+		/* also covers I40E_AQ_RC_OK */
+		default:
+			break;
 		}
-	} while ((hw->aq.asq_last_status != I40E_AQ_RC_OK) &&
-		 (total_delay < max_delay));
+
+	} while ((hw->aq.asq_last_status == I40E_AQ_RC_EAGAIN) &&
+		(total_delay < max_delay));
 
 	if (status)
 		return status;
-- 
2.21.0

