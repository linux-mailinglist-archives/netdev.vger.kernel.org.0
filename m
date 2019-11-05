Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6099F05A4
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 20:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390885AbfKETIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 14:08:11 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38488 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390464AbfKETIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 14:08:10 -0500
Received: by mail-wr1-f66.google.com with SMTP id j15so2112217wrw.5;
        Tue, 05 Nov 2019 11:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NL/tWcEWZq5h+byFMun3DBPGw1BcnDQjeSyrAwCpLXw=;
        b=T5BQF7TEjqjwlAhUHozkCvzUJOg8ttc1k0VyUUWzn8RAgrVClLfnxg+FBtFJL3IXJo
         dMINK4dy0yCFnleT3Z/FGnnw3gLOq/vR9k1KQWTNA4cnk60ARr+/GTpkErKwOhD6xvcR
         jfLySspSiwjQp3BctMXU0aXZLvypO+Irrnn7zvh87qMszyTmbGkZ5iPXwHPk1HT18vFU
         MJD1nqV47cPVBhIFCSObiS6K6kOAv/33McQP12u418bTO4OPMpiE/gvnnu6kGuqwSXb+
         aLHuTAZUGcZTl0xQDnqR6jDFx8wuJhCUhqqsvBwQpdNTs3dGWHSBy0diH/Blm44HRjqJ
         xxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NL/tWcEWZq5h+byFMun3DBPGw1BcnDQjeSyrAwCpLXw=;
        b=eeWnfbEElR8HNxg2dofLB21SjwgWNoSyAShlix2DkM+e9zjftwmv2B6RNHNbjiJdXF
         dOPEh5e1A2GJ3gdV4WhZePJvNq+RiNVaLjV9cf5T5vigoSKm2sKRP0RzB1wffG0NqY1s
         uD4pYCD4Pk8TMw7VjmlvMTD8MpcyBip8aIrAwnrZWX+1RKpfqWi8CGpLuYNO/JNqe37m
         E+iRYjvUyXvQtZsHXff2PKnXc67Wcxup821hI7N+EsPCPqWfXVCAsVqyJBBX1PwHq1px
         kOOBMB99YTLg2fafIgC8mx8xd7Z4ApH/56UTvhFt+SLCQzn+F9/nacDooBI8S+zK1UqQ
         e9fQ==
X-Gm-Message-State: APjAAAW7rRUYhE+ngA+P/E4OS8iwuGdBIn1VHNCvVuSz+1d+xhT4dQTL
        N+Wdwb/lPrRFihDEuNhO514=
X-Google-Smtp-Source: APXvYqwCb2qnxmka4gCujjh3RVuVWbpnypQi3SuZOhNxMWEKPKPertylkK9L1zRFl3RRMBFsNj2Qsw==
X-Received: by 2002:adf:fd4b:: with SMTP id h11mr11371498wrs.191.1572980888099;
        Tue, 05 Nov 2019 11:08:08 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11sm25974703wrf.80.2019.11.05.11.08.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 05 Nov 2019 11:08:07 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 1/3] net: bcmgenet: use RGMII loopback for MAC reset
Date:   Tue,  5 Nov 2019 11:07:24 -0800
Message-Id: <1572980846-37707-2-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572980846-37707-1-git-send-email-opendmb@gmail.com>
References: <1572980846-37707-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in commit 28c2d1a7a0bf ("net: bcmgenet: enable loopback
during UniMAC sw_reset") the UniMAC must be clocked while sw_reset
is asserted for its state machines to reset cleanly.

The transmit and receive clocks used by the UniMAC are derived from
the signals used on its PHY interface. The bcmgenet MAC can be
configured to work with different PHY interfaces including MII,
GMII, RGMII, and Reverse MII on internal and external interfaces.
Unfortunately for the UniMAC, when configured for MII the Tx clock
is always driven from the PHY which places it outside of the direct
control of the MAC.

The earlier commit enabled a local loopback mode within the UniMAC
so that the receive clock would be derived from the transmit clock
which addressed the observed issue with an external GPHY disabling
it's Rx clock. However, when a Tx clock is not available this
loopback is insufficient.

This commit implements a workaround that leverages the fact that
the MAC can reliably generate all of its necessary clocking by
enterring the external GPHY RGMII interface mode with the UniMAC in
local loopback during the sw_reset interval. Unfortunately, this
has the undesirable side efect of the RGMII GTXCLK signal being
driven during the same window.

In most configurations this is a benign side effect as the signal
is either not routed to a pin or is already expected to drive the
pin. The one exception is when an external MII PHY is expected to
drive the same pin with its TX_CLK output creating output driver
contention.

This commit exploits the IEEE 802.3 clause 22 standard defined
isolate mode to force an external MII PHY to present a high
impedance on its TX_CLK output during the window to prevent any
contention at the pin.

The MII interface is used internally with the 40nm internal EPHY
which agressively disables its clocks for power savings leading to
incomplete resets of the UniMAC and many instabilities observed
over the years. The workaround of this commit is expected to put
an end to those problems.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |  2 --
 drivers/net/ethernet/broadcom/genet/bcmmii.c   | 33 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 0f138280315a..a1776ed8d7a1 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1996,8 +1996,6 @@ static void reset_umac(struct bcmgenet_priv *priv)
 
 	/* issue soft reset with (rg)mii loopback to ensure a stable rxclk */
 	bcmgenet_umac_writel(priv, CMD_SW_RESET | CMD_LCL_LOOP_EN, UMAC_CMD);
-	udelay(2);
-	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
 }
 
 static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 17bb8d60a157..fcd181ae3a7d 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -221,8 +221,38 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 	const char *phy_name = NULL;
 	u32 id_mode_dis = 0;
 	u32 port_ctrl;
+	int bmcr = -1;
+	int ret;
 	u32 reg;
 
+	/* MAC clocking workaround during reset of umac state machines */
+	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	if (reg & CMD_SW_RESET) {
+		/* An MII PHY must be isolated to prevent TXC contention */
+		if (priv->phy_interface == PHY_INTERFACE_MODE_MII) {
+			ret = phy_read(phydev, MII_BMCR);
+			if (ret >= 0) {
+				bmcr = ret;
+				ret = phy_write(phydev, MII_BMCR,
+						bmcr | BMCR_ISOLATE);
+			}
+			if (ret) {
+				netdev_err(dev, "failed to isolate PHY\n");
+				return ret;
+			}
+		}
+		/* Switch MAC clocking to RGMII generated clock */
+		bcmgenet_sys_writel(priv, PORT_MODE_EXT_GPHY, SYS_PORT_CTRL);
+		/* Ensure 5 clks with Rx disabled
+		 * followed by 5 clks with Reset asserted
+		 */
+		udelay(4);
+		reg &= ~(CMD_SW_RESET | CMD_LCL_LOOP_EN);
+		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+		/* Ensure 5 more clocks before Rx is enabled */
+		udelay(2);
+	}
+
 	priv->ext_phy = !priv->internal_phy &&
 			(priv->phy_interface != PHY_INTERFACE_MODE_MOCA);
 
@@ -254,6 +284,9 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 		phy_set_max_speed(phydev, SPEED_100);
 		bcmgenet_sys_writel(priv,
 				    PORT_MODE_EXT_EPHY, SYS_PORT_CTRL);
+		/* Restore the MII PHY after isolation */
+		if (bmcr >= 0)
+			phy_write(phydev, MII_BMCR, bmcr);
 		break;
 
 	case PHY_INTERFACE_MODE_REVMII:
-- 
2.7.4

