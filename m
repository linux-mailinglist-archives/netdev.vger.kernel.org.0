Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3764212AE08
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 19:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfLZSwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 13:52:38 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55757 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfLZSwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 13:52:30 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so4907586wmj.5;
        Thu, 26 Dec 2019 10:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tdk21lW1THUxHtY9vlZ1nRwe59sn6+TCzl9IK6kCrxY=;
        b=iy5TYbCSAWLEklxNjWcYw/NjNKf0lb/V+hYcCMh1kVbwFjgAETRmR2NieVU29nMbjG
         3ColCXXTQ0PqfbprUmdkgtLUaHb1vYj82WbM2M/V3MNOvimf47w7XFn01bmr4+V9CDLK
         VWhuREDvC+8s9OkXhnDIVropP7Wv9E2KuFnhipf4sMbrS+Q9h4uWq5HyeZz6go9/OJoM
         9KdREoM6V0gppd2Won4vWzgUqUB4sR9b9uYDLszLW0kvy0uU5a/C3zGcuBCdNegAsxsu
         mv9mWq+YqWxpj8gUDTonZkALbmA1v3Hu8iYaWXNZSoI9accUVyGZsewf/zxHDGFth1Qu
         mF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tdk21lW1THUxHtY9vlZ1nRwe59sn6+TCzl9IK6kCrxY=;
        b=cV4sobuE6F8syE13tNfi4p+wKnC1J3Vm8HjiSwgT2ORz05TZFw3wHOyGXPhQdHkKJA
         lzi68Kkek9eeaezVyXuVR4AibyIGh1fR25wbGc8O/UMk7j+LetHbzrSmcYZlEYXS4xTx
         lZQLRr/i+VpThli8qzC+f9uY6PcGgpJzXaGrKzkvRhlbTDhebn8mI/JjhRa8tN6320W1
         dc8L2FZTaBNyQrj4mMsWG1XNrZZ+zZwG2qX7zdB6xWvyb2dk4HJwf8jCY4cPU5zrqfsv
         nSfGH8zP+nOJTddSR9HJeegKpnROQA7GVl5OMevKZS5li9fMIuQpmc64l4OpABbUZkK/
         N2NQ==
X-Gm-Message-State: APjAAAVgNDR5iFFAfuNSf6L+jh/0Wj4FZYCNpMD5QwdL/sLe27Z91kYN
        9AGflc8hTm8dYXWCbybVDQg=
X-Google-Smtp-Source: APXvYqytWCvSfGTkES4SMiUhI/nM1xVgQh7JR7YbzW2kovtBSDGlDHHDJAYkz2oB1+Ao2XlCczoPDw==
X-Received: by 2002:a1c:a745:: with SMTP id q66mr14592494wme.167.1577386348409;
        Thu, 26 Dec 2019 10:52:28 -0800 (PST)
Received: from localhost.localdomain (p200300F1373A1900428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:373a:1900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id j12sm32129352wrt.55.2019.12.26.10.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 10:52:27 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/2] net: phy: realtek: add support for configuring the RX delay on RTL8211F
Date:   Thu, 26 Dec 2019 19:51:48 +0100
Message-Id: <20191226185148.3764251-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191226185148.3764251-1-martin.blumenstingl@googlemail.com>
References: <20191226185148.3764251-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On RTL8211F the RX and TX delays (2ns) can be configured in two ways:
- pin strapping (RXD1 for the TX delay and RXD0 for the RX delay, LOW
  means "off" and HIGH means "on") which is read during PHY reset
- using software to configure the TX and RX delay registers

So far only the configuration using pin strapping has been supported.
Add support for enabling or disabling the RGMII RX delay based on the
phy-mode to be able to get the RX delay into a known state. This is
important because the RX delay has to be coordinated between the PHY,
MAC and the PCB design (trace length). With an invalid RX delay applied
(for example if both PHY and MAC add a 2ns RX delay) Ethernet may not
work at all.

Also add debug logging when configuring the RX delay (just like the TX
delay) because this is a common source of problems.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/phy/realtek.c | 46 ++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 879ca37c8508..f5fa2fff3ddc 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -29,6 +29,8 @@
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_TX_DELAY			BIT(8)
+#define RTL8211F_RX_DELAY			BIT(3)
+
 #define RTL8211E_TX_DELAY			BIT(1)
 #define RTL8211E_RX_DELAY			BIT(2)
 #define RTL8211E_MODE_MII_GMII			BIT(3)
@@ -172,38 +174,62 @@ static int rtl8211c_config_init(struct phy_device *phydev)
 static int rtl8211f_config_init(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
-	u16 val;
+	u16 val_txdly, val_rxdly;
 	int ret;
 
-	/* enable TX-delay for rgmii-{id,txid}, and disable it for rgmii and
-	 * rgmii-rxid. The RX-delay can be enabled by the external RXDLY pin.
-	 */
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
+		val_txdly = 0;
+		val_rxdly = 0;
+		break;
+
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		val = 0;
+		val_txdly = 0;
+		val_rxdly = RTL8211F_RX_DELAY;
 		break;
-	case PHY_INTERFACE_MODE_RGMII_ID:
+
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		val = RTL8211F_TX_DELAY;
+		val_txdly = RTL8211F_TX_DELAY;
+		val_rxdly = 0;
+		break;
+
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		val_txdly = RTL8211F_TX_DELAY;
+		val_rxdly = RTL8211F_RX_DELAY;
 		break;
+
 	default: /* the rest of the modes imply leaving delay as is. */
 		return 0;
 	}
 
 	ret = phy_modify_paged_changed(phydev, 0xd08, 0x11, RTL8211F_TX_DELAY,
-				       val);
+				       val_txdly);
 	if (ret < 0) {
 		dev_err(dev, "Failed to update the TX delay register\n");
 		return ret;
 	} else if (ret) {
 		dev_dbg(dev,
 			"%s 2ns TX delay (and changing the value from pin-strapping RXD1 or the bootloader)\n",
-			val ? "Enabling" : "Disabling");
+			val_txdly ? "Enabling" : "Disabling");
 	} else {
 		dev_dbg(dev,
 			"2ns TX delay was already %s (by pin-strapping RXD1 or bootloader configuration)\n",
-			val ? "enabled" : "disabled");
+			val_txdly ? "enabled" : "disabled");
+	}
+
+	ret = phy_modify_paged_changed(phydev, 0xd08, 0x15, RTL8211F_RX_DELAY,
+				       val_rxdly);
+	if (ret < 0) {
+		dev_err(dev, "Failed to update the RX delay register\n");
+		return ret;
+	} else if (ret) {
+		dev_dbg(dev,
+			"%s 2ns RX delay (and changing the value from pin-strapping RXD0 or the bootloader)\n",
+			val_rxdly ? "Enabling" : "Disabling");
+	} else {
+		dev_dbg(dev,
+			"2ns RX delay was already %s (by pin-strapping RXD0 or bootloader configuration)\n",
+			val_rxdly ? "enabled" : "disabled");
 	}
 
 	return 0;
-- 
2.24.1

