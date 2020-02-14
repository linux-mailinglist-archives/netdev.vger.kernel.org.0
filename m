Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D76615F227
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389036AbgBNSHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:07:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731578AbgBNPyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B5E24682;
        Fri, 14 Feb 2020 15:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695677;
        bh=WbO+uEKXoG/iwhQ7nd5kQE3ky3wQoI1Lapj7wUubyT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aF0UVRCYrk2lBDvIoSNB1Xnuv47cA/XxrcQ5UlibtDQMUTNnPP+Y45N/i2kxKzF6Q
         Ka9REjM7UWFhMw6kWyt3I09ZMAZ2sSN2aaocQNDzyVMOLb28fCrjSH/paQYc50NZ3R
         qxLlA2fUXH5nhFMjMbgFkDRuGflTHfT1rTsPuFzk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 264/542] net: phy: realtek: add logging for the RGMII TX delay configuration
Date:   Fri, 14 Feb 2020 10:44:16 -0500
Message-Id: <20200214154854.6746-264-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 3aec743d69822d22d4a5b60deb9518ed8be6fa67 ]

RGMII requires a delay of 2ns between the data and the clock signal.
There are at least three ways this can happen. One possibility is by
having the PHY generate this delay.
This is a common source for problems (for example with slow TX speeds or
packet loss when sending data). The TX delay configuration of the
RTL8211F PHY can be set either by pin-strappping the RXD1 pin (HIGH
means enabled, LOW means disabled) or through configuring a paged
register. The setting from the RXD1 pin is also reflected in the
register.

Add debug logging to the TX delay configuration on RTL8211F so it's
easier to spot these issues (for example if the TX delay is enabled for
both, the RTL8211F PHY and the MAC).
This is especially helpful because there is no public datasheet for the
RTL8211F PHY available with all the RX/TX delay specifics.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 476db5345e1af..879ca37c85081 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -171,7 +171,9 @@ static int rtl8211c_config_init(struct phy_device *phydev)
 
 static int rtl8211f_config_init(struct phy_device *phydev)
 {
+	struct device *dev = &phydev->mdio.dev;
 	u16 val;
+	int ret;
 
 	/* enable TX-delay for rgmii-{id,txid}, and disable it for rgmii and
 	 * rgmii-rxid. The RX-delay can be enabled by the external RXDLY pin.
@@ -189,7 +191,22 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 		return 0;
 	}
 
-	return phy_modify_paged(phydev, 0xd08, 0x11, RTL8211F_TX_DELAY, val);
+	ret = phy_modify_paged_changed(phydev, 0xd08, 0x11, RTL8211F_TX_DELAY,
+				       val);
+	if (ret < 0) {
+		dev_err(dev, "Failed to update the TX delay register\n");
+		return ret;
+	} else if (ret) {
+		dev_dbg(dev,
+			"%s 2ns TX delay (and changing the value from pin-strapping RXD1 or the bootloader)\n",
+			val ? "Enabling" : "Disabling");
+	} else {
+		dev_dbg(dev,
+			"2ns TX delay was already %s (by pin-strapping RXD1 or bootloader configuration)\n",
+			val ? "enabled" : "disabled");
+	}
+
+	return 0;
 }
 
 static int rtl8211e_config_init(struct phy_device *phydev)
-- 
2.20.1

