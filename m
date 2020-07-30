Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0E0233767
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgG3RJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:09:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:53573 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbgG3RJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 13:09:45 -0400
IronPort-SDR: LvlKHkf+lANCKOM6kYxHmkNRmPL0SIY62k5+xxzGI1D/HoaYaip1ug5VF/ntRk7Q+N3UVBpfRi
 ROyVW5eyN26A==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149111763"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="149111763"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 10:09:44 -0700
IronPort-SDR: sJB5oB8gcG02Wr62RsCl2UHQYWCSiZCDLYO/Z5GI6oMn5akcTrt7jleJ2VoFEVVLIZGl5q/Bxr
 u+yH9AIuSmJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="272979240"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jul 2020 10:09:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Aaron Ma <aaron.ma@canonical.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net 1/2] e1000e: continue to init PHY even when failed to disable ULP
Date:   Thu, 30 Jul 2020 10:09:37 -0700
Message-Id: <20200730170938.3766899-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730170938.3766899-1-anthony.l.nguyen@intel.com>
References: <20200730170938.3766899-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

After 'commit e086ba2fccda4 ("e1000e: disable s0ix entry and exit flows
 for ME systems")',
ThinkPad P14s always failed to disable ULP by ME.
'commit 0c80cdbf3320 ("e1000e: Warn if disabling ULP failed")'
break out of init phy:

error log:
[   42.364753] e1000e 0000:00:1f.6 enp0s31f6: Failed to disable ULP
[   42.524626] e1000e 0000:00:1f.6 enp0s31f6: PHY Wakeup cause - Unicast Packet
[   42.822476] e1000e 0000:00:1f.6 enp0s31f6: Hardware Error

When disable s0ix, E1000_FWSM_ULP_CFG_DONE will never be 1.
If continue to init phy like before, it can work as before.
iperf test result good too.

Fixes: 0c80cdbf3320 ("e1000e: Warn if disabling ULP failed")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index f999cca37a8a..489bb5b59475 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -301,10 +301,8 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
 	 */
 	hw->dev_spec.ich8lan.ulp_state = e1000_ulp_state_unknown;
 	ret_val = e1000_disable_ulp_lpt_lp(hw, true);
-	if (ret_val) {
+	if (ret_val)
 		e_warn("Failed to disable ULP\n");
-		goto out;
-	}
 
 	ret_val = hw->phy.ops.acquire(hw);
 	if (ret_val) {
-- 
2.26.2

