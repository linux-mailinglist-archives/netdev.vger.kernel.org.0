Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3013BCCAF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhGFLT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232861AbhGFLTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0AC461C78;
        Tue,  6 Jul 2021 11:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570194;
        bh=8Uvy0ZR2VNDF31lYFpuwH6pxmHiXXDSje6pg83UwUio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTCQba0LwAsZr9EsTLzeRwxUXseM5UPR+oPXCLrT7QK4nPOYrV2WDXyeHUU+N+H7/
         P92eSSvbu3mjDDGAE8amEK124dxle9uMbdGM2EXQvMNKQf/uol1vN20k/vUXyPQbG8
         xSuNPlWnSHZaPkSGJYYc5SH7p+Yq38vt/haYrpBEG/MOZ3xmxJwW+ZMQCEoev+Ryx/
         zoWDGqG+c6CQqjghiPuTJmmAWEYveALXV7AXfTfZDNCscv0vvC0jAgsPcn9LYz1rx3
         T/vPqhj1YZ5IsKJradvrcJb/aj1HSIfyTh0rbEZABrn/3L9wIUjwMOO2kBb5GmT7NF
         rArHecRl2JR4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 108/189] net: phy: nxp-c45-tja11xx: enable MDIO write access to the master/slave registers
Date:   Tue,  6 Jul 2021 07:12:48 -0400
Message-Id: <20210706111409.2058071-108-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0b5f0f29b118910c89fe249cdfbc11b400a86a18 ]

The SJA1110 switch integrates TJA1103 PHYs, but in SJA1110 switch rev B
silicon, there is a bug in that the registers for selecting the 100base-T1
autoneg master/slave roles are not writable.

To enable write access to the master/slave registers, these additional
PHY writes are necessary during initialization.

The issue has been corrected in later SJA1110 silicon versions and is
not present in the standalone PHY variants, but applying the workaround
unconditionally in the driver should not do any harm.

Suggested-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 26b9c0d7cb9d..b7ce0e737333 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -546,6 +546,12 @@ static int nxp_c45_config_init(struct phy_device *phydev)
 		return ret;
 	}
 
+	/* Bug workaround for SJA1110 rev B: enable write access
+	 * to MDIO_MMD_PMAPMD
+	 */
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F8, 1);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F9, 2);
+
 	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_CONFIG,
 			 PHY_CONFIG_AUTO);
 
-- 
2.30.2

