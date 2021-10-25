Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6C3439C86
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbhJYRD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234304AbhJYRDF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E73F6108C;
        Mon, 25 Oct 2021 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181243;
        bh=MzF9bSoY4XRFpqWztlQq8RFU/pScLG1NEx9c9VCoIXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Czm/f3383SG3P+1WgqRQfZzaTqQlIBB49j0+frVdG8hLVd+rKCzTGGxPwKlYBduGT
         oM5GOhOXXwV4LGyC5tpFIRAyXuOUh6oXRlW5FwO1YOUpvFxGbfzI9dtBlgLVK9p8+C
         FRq81Kq/9Me19GsOgRMqB3S4rzPPefIe0ac3mIGErP2wcUcCBlBo11LAw6mJ4Q3mBU
         GUgbk/P3Kp5OtJAcRd6VgIv/np1G7ldt5IO4gK0FCsmw0kWuZcQtHhbKxlDCHAr+qc
         1leVCus9SfuggtLrRCSVe/EUrLk8oSwT3f8ZzKDZw2c/Rid84fhHLOmy9liOnipKt+
         9TKpLUv85Nh6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erik Ekman <erik@kryo.se>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, ecree.xilinx@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/13] sfc: Export fibre-specific supported link modes
Date:   Mon, 25 Oct 2021 13:00:19 -0400
Message-Id: <20211025170023.1394358-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170023.1394358-1-sashal@kernel.org>
References: <20211025170023.1394358-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erik Ekman <erik@kryo.se>

[ Upstream commit c62041c5baa9ded3bc6fd38d3f724de70683b489 ]

The 1/10GbaseT modes were set up for cards with SFP+ cages in
3497ed8c852a5 ("sfc: report supported link speeds on SFP connections").
10GbaseT was likely used since no 10G fibre mode existed.

The missing fibre modes for 1/10G were added to ethtool.h in 5711a9822144
("net: ethtool: add support for 1000BaseX and missing 10G link modes")
shortly thereafter.

The user guide available at https://support-nic.xilinx.com/wp/drivers
lists support for the following cable and transceiver types in section 2.9:
- QSFP28 100G Direct Attach Cables
- QSFP28 100G SR Optical Transceivers (with SR4 modules listed)
- SFP28 25G Direct Attach Cables
- SFP28 25G SR Optical Transceivers
- QSFP+ 40G Direct Attach Cables
- QSFP+ 40G Active Optical Cables
- QSFP+ 40G SR4 Optical Transceivers
- QSFP+ to SFP+ Breakout Direct Attach Cables
- QSFP+ to SFP+ Breakout Active Optical Cables
- SFP+ 10G Direct Attach Cables
- SFP+ 10G SR Optical Transceivers
- SFP+ 10G LR Optical Transceivers
- SFP 1000BASE‐T Transceivers
- 1G Optical Transceivers
(From user guide issue 28. Issue 16 which also includes older cards like
SFN5xxx/SFN6xxx has matching lists for 1/10/40G transceiver types.)

Regarding SFP+ 10GBASE‐T transceivers the latest guide says:
"Solarflare adapters do not support 10GBASE‐T transceiver modules."

Tested using SFN5122F-R7 (with 2 SFP+ ports). Supported link modes do not change
depending on module used (tested with 1000BASE-T, 1000BASE-BX10, 10GBASE-LR).
Before:

$ ethtool ext
Settings for ext:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseT/Full
	                        10000baseT/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  Not reported
	Advertised pause frame use: No
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  Not reported
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: No
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: FIBRE
	PHYAD: 255
	Transceiver: internal
        Current message level: 0x000020f7 (8439)
                               drv probe link ifdown ifup rx_err tx_err hw
	Link detected: yes

After:

$ ethtool ext
Settings for ext:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseT/Full
	                        1000baseX/Full
	                        10000baseCR/Full
	                        10000baseSR/Full
	                        10000baseLR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  Not reported
	Advertised pause frame use: No
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  Not reported
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: No
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: FIBRE
	PHYAD: 255
	Transceiver: internal
	Supports Wake-on: g
	Wake-on: d
        Current message level: 0x000020f7 (8439)
                               drv probe link ifdown ifup rx_err tx_err hw
	Link detected: yes

Signed-off-by: Erik Ekman <erik@kryo.se>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/mcdi_port_common.c | 37 +++++++++++++++------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 4bd3ef8f3384..c4fe3c48ac46 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -132,16 +132,27 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
 	case MC_CMD_MEDIA_SFP_PLUS:
 	case MC_CMD_MEDIA_QSFP_PLUS:
 		SET_BIT(FIBRE);
-		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
+		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN)) {
 			SET_BIT(1000baseT_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
-			SET_BIT(10000baseT_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN))
+			SET_BIT(1000baseX_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN)) {
+			SET_BIT(10000baseCR_Full);
+			SET_BIT(10000baseLR_Full);
+			SET_BIT(10000baseSR_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN)) {
 			SET_BIT(40000baseCR4_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN))
+			SET_BIT(40000baseSR4_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN)) {
 			SET_BIT(100000baseCR4_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN))
+			SET_BIT(100000baseSR4_Full);
+		}
+		if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN)) {
 			SET_BIT(25000baseCR_Full);
+			SET_BIT(25000baseSR_Full);
+		}
 		if (cap & (1 << MC_CMD_PHY_CAP_50000FDX_LBN))
 			SET_BIT(50000baseCR2_Full);
 		break;
@@ -192,15 +203,19 @@ u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
 		result |= (1 << MC_CMD_PHY_CAP_100FDX_LBN);
 	if (TEST_BIT(1000baseT_Half))
 		result |= (1 << MC_CMD_PHY_CAP_1000HDX_LBN);
-	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full))
+	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full) ||
+			TEST_BIT(1000baseX_Full))
 		result |= (1 << MC_CMD_PHY_CAP_1000FDX_LBN);
-	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full))
+	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full) ||
+			TEST_BIT(10000baseCR_Full) || TEST_BIT(10000baseLR_Full) ||
+			TEST_BIT(10000baseSR_Full))
 		result |= (1 << MC_CMD_PHY_CAP_10000FDX_LBN);
-	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full))
+	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full) ||
+			TEST_BIT(40000baseSR4_Full))
 		result |= (1 << MC_CMD_PHY_CAP_40000FDX_LBN);
-	if (TEST_BIT(100000baseCR4_Full))
+	if (TEST_BIT(100000baseCR4_Full) || TEST_BIT(100000baseSR4_Full))
 		result |= (1 << MC_CMD_PHY_CAP_100000FDX_LBN);
-	if (TEST_BIT(25000baseCR_Full))
+	if (TEST_BIT(25000baseCR_Full) || TEST_BIT(25000baseSR_Full))
 		result |= (1 << MC_CMD_PHY_CAP_25000FDX_LBN);
 	if (TEST_BIT(50000baseCR2_Full))
 		result |= (1 << MC_CMD_PHY_CAP_50000FDX_LBN);
-- 
2.33.0

