Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28ECBA8DE
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 21:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393152AbfIVTJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 15:09:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391003AbfIVS7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 14:59:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C17222C7;
        Sun, 22 Sep 2019 18:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178764;
        bh=SmGskXg4vCrqIzPMor1xkleDX5ytAivyKJduGEh15Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtCJDQA/Wot75wTMmldG9C493zYMk3jAISwC30B4PtL+bHWxXuiCK49d43URpjiam
         tWRTJY3lVBJZ5YbJNmk3B6/oim6dP40RmcNy8HywJAzlKW+0hoY6gGMIPQVaVQW/fi
         SlSS5Dcs4CocdJRfu3T2VDhH1ADWP8TpIqUMFECI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 84/89] e1000e: add workaround for possible stalled packet
Date:   Sun, 22 Sep 2019 14:57:12 -0400
Message-Id: <20190922185717.3412-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit e5e9a2ecfe780975820e157b922edee715710b66 ]

This works around a possible stalled packet issue, which may occur due to
clock recovery from the PCH being too slow, when the LAN is transitioning
from K1 at 1G link speed.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204057

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 10 ++++++++++
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 00eedf202e62d..1e990f9dd3794 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1447,6 +1447,16 @@ static s32 e1000_check_for_copper_link_ich8lan(struct e1000_hw *hw)
 			else
 				phy_reg |= 0xFA;
 			e1e_wphy_locked(hw, I217_PLL_CLOCK_GATE_REG, phy_reg);
+
+			if (speed == SPEED_1000) {
+				hw->phy.ops.read_reg_locked(hw, HV_PM_CTRL,
+							    &phy_reg);
+
+				phy_reg |= HV_PM_CTRL_K1_CLK_REQ;
+
+				hw->phy.ops.write_reg_locked(hw, HV_PM_CTRL,
+							     phy_reg);
+			}
 		}
 		hw->phy.ops.release(hw);
 
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 00a36df02a3fd..88df80c0894b1 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -228,7 +228,7 @@
 
 /* PHY Power Management Control */
 #define HV_PM_CTRL		PHY_REG(770, 17)
-#define HV_PM_CTRL_PLL_STOP_IN_K1_GIGA	0x100
+#define HV_PM_CTRL_K1_CLK_REQ		0x200
 #define HV_PM_CTRL_K1_ENABLE		0x4000
 
 #define I217_PLL_CLOCK_GATE_REG	PHY_REG(772, 28)
-- 
2.20.1

