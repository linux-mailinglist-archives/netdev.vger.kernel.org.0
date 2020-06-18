Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F001FEBC3
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgFRGzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:55:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42147 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbgFRGzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:55:08 -0400
Received: from [114.249.250.117] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <aaron.ma@canonical.com>)
        id 1jloRy-00069K-97; Thu, 18 Jun 2020 06:55:03 +0000
From:   Aaron Ma <aaron.ma@canonical.com>
To:     kuba@kernel.org, jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vitaly.lifshits@intel.com,
        kai.heng.feng@canonical.com, sasha.neftin@intel.com
Subject: [v4][PATCH] e1000e: continue to init phy even when failed to disable ULP
Date:   Thu, 18 Jun 2020 14:54:53 +0800
Message-Id: <20200618065453.12140-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200616100512.22512-1-aaron.ma@canonical.com>
References: <20200616100512.22512-1-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index f999cca37a8a..be7475c5529d 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -303,7 +303,6 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
 	ret_val = e1000_disable_ulp_lpt_lp(hw, true);
 	if (ret_val) {
 		e_warn("Failed to disable ULP\n");
-		goto out;
 	}
 
 	ret_val = hw->phy.ops.acquire(hw);
-- 
2.26.2

