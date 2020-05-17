Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B281D6CB8
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEQT7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:59:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgEQT7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 15:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v1xeP4w0itTFdgP1h2G6glEWbdylUHJxDwfP8MNQsPM=; b=l5vGWBJODZYp/hbASnQwBKr4I/
        p6p+iZ8uWAMC6iME/dVCIAwJRrpVt8o9UPm946HtJa//EMsI3ruPnqmDeN/B+gPl1wAI7gBCLZ/Tt
        GD7BhbEiYgy+hSicMtgA0WRLvvVbPmO05ZsXfJDgXRX7ElXg1ysRnhwSqvHaYFFPMKTM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaPR9-002Ypd-Ic; Sun, 17 May 2020 21:59:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 7/7] net: phy: marvell: Configure TDR pulse based on measurement length
Date:   Sun, 17 May 2020 21:58:51 +0200
Message-Id: <20200517195851.610435-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200517195851.610435-1-andrew@lunn.ch>
References: <20200517195851.610435-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When performing a TDR measurement for a short distance, the pulse
width should be low, to help differentiate between the outgoing pulse
and any reflection. For longer distances, the pulse should be wider,
to help with attenuation.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5edf969978bd..7ec57b8a1aed 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -214,6 +214,11 @@
 #define MII_VCT5_TX_PULSE_CTRL_MAX_AMP			BIT(7)
 #define MII_VCT5_TX_PULSE_CTRL_GT_140m_46_86mV		(0x6 << 0)
 
+/* For TDR measurements less than 11 meters, a short pulse should be
+ * used.
+ */
+#define TDR_SHORT_CABLE_LENGTH	11
+
 #define MII_VCT7_PAIR_0_DISTANCE	0x10
 #define MII_VCT7_PAIR_1_DISTANCE	0x11
 #define MII_VCT7_PAIR_2_DISTANCE	0x12
@@ -1828,14 +1833,19 @@ static int marvell_vct5_amplitude_graph(struct phy_device *phydev)
 {
 	struct marvell_priv *priv = phydev->priv;
 	int meters;
+	u16 width;
 	int page;
 	int err;
 	u16 reg;
 
+	if (priv->first <= TDR_SHORT_CABLE_LENGTH)
+		width = MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_32nS;
+	else
+		width = MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_128nS;
+
 	reg = MII_VCT5_TX_PULSE_CTRL_GT_140m_46_86mV |
 		MII_VCT5_TX_PULSE_CTRL_DONT_WAIT_LINK_DOWN |
-		MII_VCT5_TX_PULSE_CTRL_MAX_AMP |
-		MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_32nS;
+		MII_VCT5_TX_PULSE_CTRL_MAX_AMP | width;
 
 	err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
 			      MII_VCT5_TX_PULSE_CTRL, reg);
@@ -1859,6 +1869,17 @@ static int marvell_vct5_amplitude_graph(struct phy_device *phydev)
 						      priv->pair);
 		if (err)
 			goto restore_page;
+
+		if (meters > TDR_SHORT_CABLE_LENGTH &&
+		    width == MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_32nS) {
+			width = MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_128nS;
+			reg = MII_VCT5_TX_PULSE_CTRL_GT_140m_46_86mV |
+				MII_VCT5_TX_PULSE_CTRL_DONT_WAIT_LINK_DOWN |
+				MII_VCT5_TX_PULSE_CTRL_MAX_AMP | width;
+			err = __phy_write(phydev, MII_VCT5_TX_PULSE_CTRL, reg);
+			if (err)
+				goto restore_page;
+		}
 	}
 
 restore_page:
-- 
2.26.2

