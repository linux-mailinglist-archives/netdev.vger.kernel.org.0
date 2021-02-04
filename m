Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1414430F2CE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 13:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbhBDMAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 07:00:12 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:59784 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbhBDMAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 07:00:12 -0500
Received: from [51.148.178.73] (port=37344 helo=pbcl-dsk8.fritz.box)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l7cro-008lpZ-8u; Thu, 04 Feb 2021 11:32:08 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next 8/9] lan78xx: fix exception on link speed change
Date:   Thu,  4 Feb 2021 11:31:20 +0000
Message-Id: <20210204113121.29786-9-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ares.krystal.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pebblebay.com
X-Get-Message-Sender-Via: ares.krystal.co.uk: authenticated_id: john.efstathiades@pebblebay.com
X-Authenticated-Sender: ares.krystal.co.uk: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An exception is sometimes seen when the link speed is changed
from auto-negotiation to a fixed speed, or vice versa. The
exception occurs when the MAC is reset (due to the link speed
change) at the same time as the PHY state machine is accessing
a PHY register.

Add serialisation to the MAC reset to eliminate the race condition.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 54 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 9bd21d17d6f1..0a6f4765f595 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1342,6 +1342,52 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
 
 static void lan78xx_rx_urb_submit_all(struct lan78xx_net *dev);
 
+static int lan78xx_mac_reset(struct lan78xx_net *dev)
+{
+	u32 val;
+	int ret;
+	unsigned long start_time = jiffies;
+
+	mutex_lock(&dev->phy_mutex);
+
+	/* confirm MII not busy */
+	ret = lan78xx_phy_wait_not_busy(dev);
+	if (ret < 0)
+		goto done;
+
+	ret = lan78xx_read_reg(dev, MAC_CR, &val);
+	if (unlikely(ret < 0)) {
+		ret = -EIO;
+		goto done;
+	}
+
+	val |= MAC_CR_RST_;
+	ret = lan78xx_write_reg(dev, MAC_CR, val);
+	if (unlikely(ret < 0)) {
+		ret = -EIO;
+		goto done;
+	}
+
+	/* poll for completion */
+
+	do {
+		ret = lan78xx_read_reg(dev, MAC_CR, &val);
+		if (unlikely(ret < 0)) {
+			ret = -EIO;
+			break;
+		}
+		if (!(val & MAC_CR_RST_)) {
+			ret = 0;
+			break;
+		}
+	} while (!time_after(jiffies, start_time + HZ));
+
+done:
+	mutex_unlock(&dev->phy_mutex);
+
+	return ret;
+}
+
 static int lan78xx_link_reset(struct lan78xx_net *dev)
 {
 	struct phy_device *phydev = dev->net->phydev;
@@ -1360,12 +1406,8 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 		dev->link_on = false;
 
 		/* reset MAC */
-		ret = lan78xx_read_reg(dev, MAC_CR, &buf);
-		if (unlikely(ret < 0))
-			return -EIO;
-		buf |= MAC_CR_RST_;
-		ret = lan78xx_write_reg(dev, MAC_CR, buf);
-		if (unlikely(ret < 0))
+		ret = lan78xx_mac_reset(dev);
+		if (unlikely(ret != 0))
 			return -EIO;
 
 		del_timer(&dev->stat_monitor);
-- 
2.17.1

