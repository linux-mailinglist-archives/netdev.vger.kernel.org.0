Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FDF18FD6D
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 20:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgCWTRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 15:17:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37760 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727689AbgCWTRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 15:17:14 -0400
Received: from [222.129.50.174] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <aaron.ma@canonical.com>)
        id 1jGSZN-00031K-JS; Mon, 23 Mar 2020 19:17:06 +0000
From:   Aaron Ma <aaron.ma@canonical.com>
To:     jeffrey.t.kirsher@intel.com, aaron.ma@canonical.com,
        davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sasha.neftin@intel.com
Subject: [PATCH] e1000e: bump up timeout to wait when ME un-configure ULP mode
Date:   Tue, 24 Mar 2020 03:16:39 +0800
Message-Id: <20200323191639.48826-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ME takes 2+ seconds to un-configure ULP mode done after resume
from s2idle on some ThinkPad laptops.
Without enough wait, reset and re-init will fail with error.

Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
BugLink: https://bugs.launchpad.net/bugs/1865570
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index b4135c50e905..147b15a2f8b3 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1240,9 +1240,9 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
 			ew32(H2ME, mac_reg);
 		}
 
-		/* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
+		/* Poll up to 2.5sec for ME to clear ULP_CFG_DONE. */
 		while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
-			if (i++ == 30) {
+			if (i++ == 250) {
 				ret_val = -E1000_ERR_PHY;
 				goto out;
 			}
-- 
2.17.1

