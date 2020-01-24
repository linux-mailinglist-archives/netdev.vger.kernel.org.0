Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7C91486DE
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403908AbgAXOTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403870AbgAXOTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEE30208C4;
        Fri, 24 Jan 2020 14:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875545;
        bh=YXimIeVVabdHST4MA4fpnqw1T32CaDvKUYGappcD4SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYTPECr71HpX0d0IC0d90slm7oKA0KYbgOqTFACS6eajEm5geThMTWbTch7yFS7Zt
         736/7/rWBYr3Eteco4nIlCKtUBL8lmaid5JxajopqxjvnT2IFB2GYWUodL9S9pkxck
         Onnv5m9jvk4lJWA33bV+36I1dMBgphjJP57ce6sw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manfred Rudigier <manfred.rudigier@omicronenergy.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 041/107] igb: Fix SGMII SFP module discovery for 100FX/LX.
Date:   Fri, 24 Jan 2020 09:17:11 -0500
Message-Id: <20200124141817.28793-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manfred Rudigier <manfred.rudigier@omicronenergy.com>

[ Upstream commit 5365ec1aeff5b9f2962a9c9b31d63f9dad7e0e2d ]

Changing the link mode should also be done for 100BaseFX SGMII modules,
otherwise they just don't work when the default link mode in CTRL_EXT
coming from the EEPROM is SERDES.

Additionally 100Base-LX SGMII SFP modules are also supported now, which
was not the case before.

Tested with an i210 using Flexoptix S.1303.2M.G 100FX and
S.1303.10.G 100LX SGMII SFP modules.

Signed-off-by: Manfred Rudigier <manfred.rudigier@omicronenergy.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/e1000_82575.c | 8 ++------
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index 8a6ef35141292..438b42ce2cd9a 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -530,7 +530,7 @@ static s32 igb_set_sfp_media_type_82575(struct e1000_hw *hw)
 		dev_spec->module_plugged = true;
 		if (eth_flags->e1000_base_lx || eth_flags->e1000_base_sx) {
 			hw->phy.media_type = e1000_media_type_internal_serdes;
-		} else if (eth_flags->e100_base_fx) {
+		} else if (eth_flags->e100_base_fx || eth_flags->e100_base_lx) {
 			dev_spec->sgmii_active = true;
 			hw->phy.media_type = e1000_media_type_internal_serdes;
 		} else if (eth_flags->e1000_base_t) {
@@ -657,14 +657,10 @@ static s32 igb_get_invariants_82575(struct e1000_hw *hw)
 			break;
 		}
 
-		/* do not change link mode for 100BaseFX */
-		if (dev_spec->eth_flags.e100_base_fx)
-			break;
-
 		/* change current link mode setting */
 		ctrl_ext &= ~E1000_CTRL_EXT_LINK_MODE_MASK;
 
-		if (hw->phy.media_type == e1000_media_type_copper)
+		if (dev_spec->sgmii_active)
 			ctrl_ext |= E1000_CTRL_EXT_LINK_MODE_SGMII;
 		else
 			ctrl_ext |= E1000_CTRL_EXT_LINK_MODE_PCIE_SERDES;
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 3182b059bf55c..8959418776f67 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -181,7 +181,7 @@ static int igb_get_link_ksettings(struct net_device *netdev,
 				advertising &= ~ADVERTISED_1000baseKX_Full;
 			}
 		}
-		if (eth_flags->e100_base_fx) {
+		if (eth_flags->e100_base_fx || eth_flags->e100_base_lx) {
 			supported |= SUPPORTED_100baseT_Full;
 			advertising |= ADVERTISED_100baseT_Full;
 		}
-- 
2.20.1

