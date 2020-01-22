Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA56114574F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgAVN7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:59:46 -0500
Received: from inva021.nxp.com ([92.121.34.21]:37390 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgAVN7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 08:59:46 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E7C34200152;
        Wed, 22 Jan 2020 14:59:43 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D5ED22000DC;
        Wed, 22 Jan 2020 14:59:43 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5945220364;
        Wed, 22 Jan 2020 14:59:43 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, ykaukab@suse.de,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation indication
Date:   Wed, 22 Jan 2020 15:59:32 +0200
Message-Id: <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AQR PHYs are able to perform rate adaptation between
the system interface and the line interfaces. When such
a PHY is deployed, the ethernet driver should not limit
the modes supported or advertised by the PHY. This patch
introduces the bit that allows checking for this feature
in the phy_device structure and its use for the Aquantia
PHYs.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 drivers/net/phy/aquantia_main.c | 3 +++
 include/linux/phy.h             | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 975789d9349d..36fdd523b758 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -209,6 +209,9 @@ static int aqr_config_aneg(struct phy_device *phydev)
 	u16 reg;
 	int ret;
 
+	/* add here as this is called for all devices */
+	phydev->rate_adaptation = 1;
+
 	if (phydev->autoneg == AUTONEG_DISABLE)
 		return genphy_c45_pma_setup_forced(phydev);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index dd4a91f1feaa..2a5c202333fc 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -387,6 +387,9 @@ struct phy_device {
 	/* Interrupts are enabled */
 	unsigned interrupts:1;
 
+	/* Rate adaptation in the PHY */
+	unsigned rate_adaptation:1;
+
 	enum phy_state state;
 
 	u32 dev_flags;
-- 
2.1.0

