Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790CB1C827C
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 08:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgEGG1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 02:27:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39670 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgEGG1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 02:27:21 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jWZyi-0000tF-64; Thu, 07 May 2020 06:25:52 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jeffrey.t.kirsher@intel.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] e1000e: Warn if disabling ULP failed
Date:   Thu,  7 May 2020 14:25:45 +0800
Message-Id: <20200507062545.15461-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware may stop working if driver failed to disable ULP mode.

Take the return value of e1000_disable_ulp_lpt_lp() into account, and
pass up the error if it fails.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 15f6c0a4dc63..9cbd2d6c7da4 100644
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
2.17.1

