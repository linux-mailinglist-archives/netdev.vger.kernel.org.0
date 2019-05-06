Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A4615578
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 23:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfEFVZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 17:25:50 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:38390 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbfEFVZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 17:25:49 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id BAD2F50A6;
        Mon,  6 May 2019 23:25:46 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 9ba474fd;
        Mon, 6 May 2019 23:25:45 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-usb@vger.kernel.org
Subject: [PATCH net-next v2 4/4] net: usb: smsc: fix warning reported by kbuild test robot
Date:   Mon,  6 May 2019 23:24:47 +0200
Message-Id: <1557177887-30446-5-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1557177887-30446-1-git-send-email-ynezz@true.cz>
References: <1557177887-30446-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes following warning reported by kbuild test robot:

 In function ‘memcpy’,
     inlined from ‘smsc75xx_init_mac_address’ at drivers/net/usb/smsc75xx.c:778:3,
     inlined from ‘smsc75xx_bind’ at drivers/net/usb/smsc75xx.c:1501:2:
 ./include/linux/string.h:355:9: warning: argument 2 null where non-null expected [-Wnonnull]
   return __builtin_memcpy(p, q, size);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
 drivers/net/usb/smsc75xx.c: In function ‘smsc75xx_bind’:
 ./include/linux/string.h:355:9: note: in a call to built-in function ‘__builtin_memcpy’

I've replaced the offending memcpy with ether_addr_copy, because I'm
100% sure, that of_get_mac_address can't return NULL as it returns valid
pointer or ERR_PTR encoded value, nothing else.

I'm hesitant to just change IS_ERR into IS_ERR_OR_NULL check, as this
would make the warning disappear also, but it would be confusing to
check for impossible return value just to make a compiler happy.

Fixes: adfb3cb2c52e ("net: usb: support of_get_mac_address new ERR_PTR error")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 drivers/net/usb/smsc75xx.c | 2 +-
 drivers/net/usb/smsc95xx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index d27b627..e4c2f3a 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -775,7 +775,7 @@ static void smsc75xx_init_mac_address(struct usbnet *dev)
 	/* maybe the boot loader passed the MAC address in devicetree */
 	mac_addr = of_get_mac_address(dev->udev->dev.of_node);
 	if (!IS_ERR(mac_addr)) {
-		memcpy(dev->net->dev_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(dev->net->dev_addr, mac_addr);
 		return;
 	}
 
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index ab23911..a0e1199 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -918,7 +918,7 @@ static void smsc95xx_init_mac_address(struct usbnet *dev)
 	/* maybe the boot loader passed the MAC address in devicetree */
 	mac_addr = of_get_mac_address(dev->udev->dev.of_node);
 	if (!IS_ERR(mac_addr)) {
-		memcpy(dev->net->dev_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(dev->net->dev_addr, mac_addr);
 		return;
 	}
 
-- 
1.9.1

