Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB182E22CB
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 00:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgLWXhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 18:37:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:27330 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727056AbgLWXhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 18:37:11 -0500
IronPort-SDR: rnMJihUfcZIzIPO+Irm8SNpNJPCjFVtFHP6vm4R45Ko01Yev0pkYLH1mgC7Bj79xL1O6uRQUkw
 9Fdu/im8ZrOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9844"; a="176184743"
X-IronPort-AV: E=Sophos;i="5.78,443,1599548400"; 
   d="scan'208";a="176184743"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2020 15:36:29 -0800
IronPort-SDR: dE1Znq0W5LT8U+e9ggg3WcQmLd2+DixBhak5T9vfDz+PwlsnM2SZwSAR9xyMC8B0kNHzbMCMnO
 gAUaeDT6VGGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,443,1599548400"; 
   d="scan'208";a="345253133"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 23 Dec 2020 15:36:29 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mario Limonciello <mario.limonciello@dell.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, alexander.duyck@gmail.com,
        sasha.neftin@intel.com, darcari@redhat.com, Yijun.Shen@dell.com,
        Perry.Yuan@dell.com, anthony.wong@canonical.com,
        hdegoede@redhat.com, Aaron Ma <aaron.ma@canonical.com>,
        Mark Pearson <markpearson@lenovo.com>,
        Yijun Shen <Yijun.shen@dell.com>
Subject: [net 2/4] e1000e: bump up timeout to wait when ME un-configures ULP mode
Date:   Wed, 23 Dec 2020 15:36:23 -0800
Message-Id: <20201223233625.92519-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201223233625.92519-1-anthony.l.nguyen@intel.com>
References: <20201223233625.92519-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

Per guidance from Intel ethernet architecture team, it may take
up to 1 second for unconfiguring ULP mode.

However in practice this seems to be taking up to 2 seconds on
some Lenovo machines.  Detect scenarios that take more than 1 second
but less than 2.5 seconds and emit a warning on resume for those
scenarios.

Suggested-by: Aaron Ma <aaron.ma@canonical.com>
Suggested-by: Sasha Netfin <sasha.neftin@intel.com>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
CC: Mark Pearson <markpearson@lenovo.com>
Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
BugLink: https://bugs.launchpad.net/bugs/1865570
Link: https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20200323191639.48826-1-aaron.ma@canonical.com/
Link: https://lkml.org/lkml/2020/12/13/15
Link: https://lkml.org/lkml/2020/12/14/708
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Yijun Shen <Yijun.shen@dell.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 9aa6fad8ed47..6fb46682b058 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1240,6 +1240,9 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
 		return 0;
 
 	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+		struct e1000_adapter *adapter = hw->adapter;
+		bool firmware_bug = false;
+
 		if (force) {
 			/* Request ME un-configure ULP mode in the PHY */
 			mac_reg = er32(H2ME);
@@ -1248,16 +1251,24 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
 			ew32(H2ME, mac_reg);
 		}
 
-		/* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
+		/* Poll up to 2.5 seconds for ME to clear ULP_CFG_DONE.
+		 * If this takes more than 1 second, show a warning indicating a
+		 * firmware bug
+		 */
 		while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
-			if (i++ == 30) {
+			if (i++ == 250) {
 				ret_val = -E1000_ERR_PHY;
 				goto out;
 			}
+			if (i > 100 && !firmware_bug)
+				firmware_bug = true;
 
 			usleep_range(10000, 11000);
 		}
-		e_dbg("ULP_CONFIG_DONE cleared after %dmsec\n", i * 10);
+		if (firmware_bug)
+			e_warn("ULP_CONFIG_DONE took %dmsec.  This is a firmware bug\n", i * 10);
+		else
+			e_dbg("ULP_CONFIG_DONE cleared after %dmsec\n", i * 10);
 
 		if (force) {
 			mac_reg = er32(H2ME);
-- 
2.26.2

