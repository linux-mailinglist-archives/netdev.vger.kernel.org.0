Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F8C1BFC85
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgD3OGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728522AbgD3Nwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:52:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B963220873;
        Thu, 30 Apr 2020 13:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254769;
        bh=2MUM1kxg04F7boFoXbSoLc0aD7BEzt1xP/aSYnuZZrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oox+YCtq2yd8WD0tCMq0M1uSfk3yroiR28nGEO9ZdK6X0FtV8nPIAYOXEa0q0b0Qg
         ema2Kvtg/8rzt+WgdZYqqzjVzovnRSyo8wtz/Cs1XQnGdnU5XX8xpdQI0N2Obe9I/w
         0tjMRVnowHbEjbKlYMHg2n5vDO/aoMIr+g2W9XDE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julien Beraud <julien.beraud@orolia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 27/57] net: stmmac: fix enabling socfpga's ptp_ref_clock
Date:   Thu, 30 Apr 2020 09:51:48 -0400
Message-Id: <20200430135218.20372-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julien Beraud <julien.beraud@orolia.com>

[ Upstream commit 15ce30609d1e88d42fb1cd948f453e6d5f188249 ]

There are 2 registers to write to enable a ptp ref clock coming from the
fpga.
One that enables the usage of the clock from the fpga for emac0 and emac1
as a ptp ref clock, and the other to allow signals from the fpga to reach
emac0 and emac1.
Currently, if the dwmac-socfpga has phymode set to PHY_INTERFACE_MODE_MII,
PHY_INTERFACE_MODE_GMII, or PHY_INTERFACE_MODE_SGMII, both registers will
be written and the ptp ref clock will be set as coming from the fpga.
Separate the 2 register writes to only enable signals from the fpga to
reach emac0 or emac1 when ptp ref clock is not coming from the fpga.

Signed-off-by: Julien Beraud <julien.beraud@orolia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index e0212d2fc2a12..b7087245af26a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -289,16 +289,19 @@ static int socfpga_gen5_set_phy_mode(struct socfpga_dwmac *dwmac)
 	    phymode == PHY_INTERFACE_MODE_MII ||
 	    phymode == PHY_INTERFACE_MODE_GMII ||
 	    phymode == PHY_INTERFACE_MODE_SGMII) {
-		ctrl |= SYSMGR_EMACGRP_CTRL_PTP_REF_CLK_MASK << (reg_shift / 2);
 		regmap_read(sys_mgr_base_addr, SYSMGR_FPGAGRP_MODULE_REG,
 			    &module);
 		module |= (SYSMGR_FPGAGRP_MODULE_EMAC << (reg_shift / 2));
 		regmap_write(sys_mgr_base_addr, SYSMGR_FPGAGRP_MODULE_REG,
 			     module);
-	} else {
-		ctrl &= ~(SYSMGR_EMACGRP_CTRL_PTP_REF_CLK_MASK << (reg_shift / 2));
 	}
 
+	if (dwmac->f2h_ptp_ref_clk)
+		ctrl |= SYSMGR_EMACGRP_CTRL_PTP_REF_CLK_MASK << (reg_shift / 2);
+	else
+		ctrl &= ~(SYSMGR_EMACGRP_CTRL_PTP_REF_CLK_MASK <<
+			  (reg_shift / 2));
+
 	regmap_write(sys_mgr_base_addr, reg_offset, ctrl);
 
 	/* Deassert reset for the phy configuration to be sampled by
-- 
2.20.1

