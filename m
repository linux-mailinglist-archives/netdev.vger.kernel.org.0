Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1414A6ED
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 16:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgA0PH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 10:07:58 -0500
Received: from inva020.nxp.com ([92.121.34.13]:42224 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbgA0PH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 10:07:57 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CFE9F1A0353;
        Mon, 27 Jan 2020 16:07:55 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C35891A017A;
        Mon, 27 Jan 2020 16:07:55 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 75D4A205A3;
        Mon, 27 Jan 2020 16:07:55 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, ykaukab@suse.de,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH v2 1/2] net: phy: aquantia: add rate_adaptation indication
Date:   Mon, 27 Jan 2020 17:07:50 +0200
Message-Id: <1580137671-22081-2-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHYs are able to perform rate adaptation between
the system interface and the line interfaces. When such
a PHY is deployed, the ethernet driver should not limit
the modes supported or advertised by the PHY. This patch
introduces the bit that allows checking for this feature
in the phy_device structure and its use for the Aquantia
PHYs that have this capability.

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

