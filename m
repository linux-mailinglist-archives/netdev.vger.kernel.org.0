Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D738D20AC55
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 08:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgFZG2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 02:28:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:19556 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgFZG2w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 02:28:52 -0400
IronPort-SDR: 8mvdY7uh1tJtoATudfOaTXTixz05PeZVPR9OBOBACT4YqqrkNtHBMyjZQFnoGqZP7OZbA+V1hu
 TbViV0XRVApA==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="144301921"
X-IronPort-AV: E=Sophos;i="5.75,282,1589266800"; 
   d="scan'208";a="144301921"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 23:28:51 -0700
IronPort-SDR: 0aQ0AEk4Pi+6rWYimC1ZGFDPjjMLQF5rHAKQS6ppwkaWKUIpjnRhyBDVd+1vIjebznuj67fcFd
 CHkXUiyhXzhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,282,1589266800"; 
   d="scan'208";a="280062456"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 25 Jun 2020 23:28:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 3/8] i40e: make PF wait reset loop reliable
Date:   Thu, 25 Jun 2020 23:28:45 -0700
Message-Id: <20200626062850.1649538-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626062850.1649538-1-jeffrey.t.kirsher@intel.com>
References: <20200626062850.1649538-1-jeffrey.t.kirsher@intel.com>
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

