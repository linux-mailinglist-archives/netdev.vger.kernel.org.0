Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE28C2068F5
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388114AbgFXAXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:23:02 -0400
Received: from mga03.intel.com ([134.134.136.65]:52383 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387973AbgFXAWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 20:22:55 -0400
IronPort-SDR: PdEXRuq3KKAQAQV2Gk5uA9IIKiPuCl1gvcrR6LF99HxRO1jO75VJQQqXEGWTS6BhT+ny+53QHQ
 LI5npuRcWcDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="144308298"
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="144308298"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 17:22:55 -0700
IronPort-SDR: h3VcJ3783C4rmZCVoa25BSCo4prvfKpy6iIWbrA/5bzG6mTNMUaWEU+sG5INReMKUgqYpdbB7V
 bpMqlf/icTTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="293374239"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga002.jf.intel.com with ESMTP; 23 Jun 2020 17:22:54 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 3/8] i40e: make PF wait reset loop reliable
Date:   Tue, 23 Jun 2020 17:22:47 -0700
Message-Id: <20200624002252.942257-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624002252.942257-1-jeffrey.t.kirsher@intel.com>
References: <20200624002252.942257-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>

Use jiffies to limit max waiting time for PF reset to succeed.
Previous wait loop was unreliable. It required unreasonably long time
to wait for PF reset after reboot when NIC was about to enter
recovery mode

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5f7f5147f9a7..3978b66dcffd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14606,25 +14606,23 @@ static bool i40e_check_recovery_mode(struct i40e_pf *pf)
  **/
 static i40e_status i40e_pf_loop_reset(struct i40e_pf *pf)
 {
-	const unsigned short MAX_CNT = 1000;
-	const unsigned short MSECS = 10;
+	/* wait max 10 seconds for PF reset to succeed */
+	const unsigned long time_end = jiffies + 10 * HZ;
+
 	struct i40e_hw *hw = &pf->hw;
 	i40e_status ret;
-	int cnt;
 
-	for (cnt = 0; cnt < MAX_CNT; ++cnt) {
+	ret = i40e_pf_reset(hw);
+	while (ret != I40E_SUCCESS && time_before(jiffies, time_end)) {
+		usleep_range(10000, 20000);
 		ret = i40e_pf_reset(hw);
-		if (!ret)
-			break;
-		msleep(MSECS);
 	}
 
-	if (cnt == MAX_CNT) {
+	if (ret == I40E_SUCCESS)
+		pf->pfr_count++;
+	else
 		dev_info(&pf->pdev->dev, "PF reset failed: %d\n", ret);
-		return ret;
-	}
 
-	pf->pfr_count++;
 	return ret;
 }
 
-- 
2.26.2

