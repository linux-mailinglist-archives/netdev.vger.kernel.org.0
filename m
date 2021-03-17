Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506B133E37B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhCQA4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230332AbhCQA4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03F6164F9E;
        Wed, 17 Mar 2021 00:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942568;
        bh=ceNAXzieXZP26BzWhfFDXAQnIPrngnKGF56RCwkyc/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIQ90gdu3vBy3m8d2jwydO8kvVUy3k3Khw+kGb557/666/Fc7Vluhd8vJB+BBkK7j
         f6r39eLPzBBTJBqB3tk903qa9kfeIBfT9XfaC/OjBTfa58U+DAP073Okiarz2JMhom
         NEnd+FllH41D8NoHQV+ebhb0LnSUriaXxsylq5cmDYtsC8NEkgcxToWKTB5Sbo8a9d
         +sUyo+bGlVSyVZM4A0kTJ2EXyt/auRvR3WJhBz1HQstO2xJ0mIY0eUgsdIL6FUb7vf
         vgMFJKKyvVBiW3n2xeS+yzOUDlsNqZjqpdeYOp9DPLaqYNdoU2TuuEYqoUndUOcl9Y
         hYY+xqj9KwAWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jason Liu <jason.hui.liu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 26/61] net: enetc: set MAC RX FIFO to recommended value
Date:   Tue, 16 Mar 2021 20:55:00 -0400
Message-Id: <20210317005536.724046-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
index c71fe8d751d5..66f2abbb8581 100644
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
index 515c5b29d7aa..90979ae71c74 100644
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

