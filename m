Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB2413078
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbfECOgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:36:33 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:17096 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbfECOfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 10:35:17 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id A44DC4AD0;
        Fri,  3 May 2019 16:27:44 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 037e069d;
        Fri, 3 May 2019 16:27:43 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 06/10] net: usb: support of_get_mac_address new ERR_PTR error
Date:   Fri,  3 May 2019 16:27:11 +0200
Message-Id: <1556893635-18549-7-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556893635-18549-1-git-send-email-ynezz@true.cz>
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was NVMEM support added to of_get_mac_address, so it could now return
ERR_PTR encoded error values, so we need to adjust all current users of
of_get_mac_address to this new fact.

Signed-off-by: Petr Štetiar <ynezz@true.cz>
---

 Changes since v3:

  * IS_ERR_OR_NULL -> IS_ERR

 drivers/net/usb/smsc75xx.c | 2 +-
 drivers/net/usb/smsc95xx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index ec287c9..d27b627 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -774,7 +774,7 @@ static void smsc75xx_init_mac_address(struct usbnet *dev)
 
 	/* maybe the boot loader passed the MAC address in devicetree */
 	mac_addr = of_get_mac_address(dev->udev->dev.of_node);
-	if (mac_addr) {
+	if (!IS_ERR(mac_addr)) {
 		memcpy(dev->net->dev_addr, mac_addr, ETH_ALEN);
 		return;
 	}
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index e3d08626..ab23911 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -917,7 +917,7 @@ static void smsc95xx_init_mac_address(struct usbnet *dev)
 
 	/* maybe the boot loader passed the MAC address in devicetree */
 	mac_addr = of_get_mac_address(dev->udev->dev.of_node);
-	if (mac_addr) {
+	if (!IS_ERR(mac_addr)) {
 		memcpy(dev->net->dev_addr, mac_addr, ETH_ALEN);
 		return;
 	}
-- 
1.9.1

