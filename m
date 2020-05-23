Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A701DF442
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbgEWCvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:36 -0400
Received: from mga17.intel.com ([192.55.52.151]:37983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387581AbgEWCvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:18 -0400
IronPort-SDR: uTBnea0TTBln73bIPWK0QdGxVQIcvr3dJFlcHCmjBobZvK4KNWzHiHjRG3BTgwQQ+2la6aXakD
 3PCGF4Sp8YOg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:14 -0700
IronPort-SDR: x4mMGxkFYoB/f97GSiYRnEwHs5RTqHMvnaSGslE4mYkFsR/j5YNUsxOSRnhmU+CcUoca3fivbX
 g28qN0wmCfDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291133"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/17] e1000e: Warn if disabling ULP failed
Date:   Fri, 22 May 2020 19:51:07 -0700
Message-Id: <20200523025109.3313635-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
References: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

The hardware may stop working if driver failed to disable ULP mode.

Take the return value of e1000_disable_ulp_lpt_lp() into account, and
pass up the error if it fails.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 735bf25952fc..f999cca37a8a 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -300,7 +300,11 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
 	 * so forcibly disable it.
 	 */
 	hw->dev_spec.ich8lan.ulp_state = e1000_ulp_state_unknown;
-	e1000_disable_ulp_lpt_lp(hw, true);
+	ret_val = e1000_disable_ulp_lpt_lp(hw, true);
+	if (ret_val) {
+		e_warn("Failed to disable ULP\n");
+		goto out;
+	}
 
 	ret_val = hw->phy.ops.acquire(hw);
 	if (ret_val) {
-- 
2.26.2

