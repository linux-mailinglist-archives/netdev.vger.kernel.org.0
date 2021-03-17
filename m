Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0FC33E42B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhCQA6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhCQA50 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B0E464FB4;
        Wed, 17 Mar 2021 00:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942646;
        bh=NRiYaLksz1O3cwEDkbwixLF9qqbvoY9KuChBsaKZ3Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQXxDgWK0IJOdwZF+z/WP5v+nOFYPBp9VQ5p5A86unTNzlAQn10UyWcfgIYta42Cs
         PyMxJsH70m/U6wP2oL0I0un0/5oT5gwPnKs4HLKJMb9BJVkuCfxsFLA9SP7j+ege0x
         No4hjDoxD/BDawNPGAyZZ/1UYnSG1hl6u7p+Ej0iOM4oLzNOCOxkNQ550Ync01JD4e
         +p6lnslS+Z/ZKEGXAP0NsrNm02ScX7n2O6LisuPEA/4ZM8zRetDu0wHYw5LqREoMGt
         N/fjOXwOT3lPRSouB4d0FS9KE3a5W7b47x/egfT1pDZ8ucf7FYc4PwTJoesfSIeW2R
         qIesBpk/tLCMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jason Liu <jason.hui.liu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/54] net: enetc: set MAC RX FIFO to recommended value
Date:   Tue, 16 Mar 2021 20:56:24 -0400
Message-Id: <20210317005654.724862-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

[ Upstream commit 1b2395dfff5bb40228a187f21f577cd90673d344 ]

On LS1028A, the MAC RX FIFO defaults to the value 2, which is too high
and may lead to RX lock-up under traffic at a rate higher than 6 Gbps.
Set it to 1 instead, as recommended by the hardware design team and by
later versions of the ENETC block guide.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Jason Liu <jason.hui.liu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 2 ++
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 014ca6ae121f..b70a36ff9543 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -232,6 +232,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_MAXFRM	0x8014
 #define ENETC_SET_TX_MTU(val)	((val) << 16)
 #define ENETC_SET_MAXFRM(val)	((val) & 0xffff)
+#define ENETC_PM0_RX_FIFO	0x801c
+#define ENETC_PM0_RX_FIFO_VAL	1
 
 #define ENETC_PM_IMDIO_BASE	0x8030
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 796e3d6f23f0..6ebaff9043b8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -495,6 +495,12 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
 
 	enetc_port_wr(hw, ENETC_PM1_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
+
+	/* On LS1028A, the MAC RX FIFO defaults to 2, which is too high
+	 * and may lead to RX lock-up under traffic. Set it to 1 instead,
+	 * as recommended by the hardware team.
+	 */
+	enetc_port_wr(hw, ENETC_PM0_RX_FIFO, ENETC_PM0_RX_FIFO_VAL);
 }
 
 static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
-- 
2.30.1

