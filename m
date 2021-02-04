Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CF430F2C8
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhBDL6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:58:21 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:57392 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235831AbhBDL6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:58:20 -0500
Received: from [51.148.178.73] (port=37344 helo=pbcl-dsk8.fritz.box)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l7crn-008lpZ-MW; Thu, 04 Feb 2021 11:32:07 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next 2/9] lan78xx: disable U1/U2 power state transitions
Date:   Thu,  4 Feb 2021 11:31:14 +0000
Message-Id: <20210204113121.29786-3-john.efstathiades@pebblebay.com>
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

Use macro DEFAULT_U1_U2_INIT_ENABLE to configure default behaviour
of U1/U2 link power state transitions (on/off).

Disable U1/U2 link power state transitions by default to reduce
URB processing latency and maximise throughput.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 1c872edc816a..38664b48329a 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -56,6 +56,8 @@
 #define TX_ALIGNMENT			(4)
 #define RXW_PADDING			2
 
+#define DEFAULT_U1_U2_INIT_ENABLE	false
+
 #define MIN_IPV4_DGRAM			68
 
 #define LAN78XX_USB_VENDOR_ID		(0x0424)
@@ -1351,7 +1353,8 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 
 		phy_ethtool_ksettings_get(phydev, &ecmd);
 
-		if (dev->udev->speed == USB_SPEED_SUPER) {
+		if (DEFAULT_U1_U2_INIT_ENABLE &&
+		    dev->udev->speed == USB_SPEED_SUPER) {
 			if (ecmd.base.speed == 1000) {
 				/* disable U2 */
 				ret = lan78xx_read_reg(dev, USB_CFG1, &buf);
@@ -1368,6 +1371,11 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 				buf |= USB_CFG1_DEV_U1_INIT_EN_;
 				ret = lan78xx_write_reg(dev, USB_CFG1, buf);
 			}
+		} else {
+			ret = lan78xx_read_reg(dev, USB_CFG1, &buf);
+			buf &= ~USB_CFG1_DEV_U2_INIT_EN_;
+			buf &= ~USB_CFG1_DEV_U1_INIT_EN_;
+			ret = lan78xx_write_reg(dev, USB_CFG1, buf);
 		}
 
 		ladv = phy_read(phydev, MII_ADVERTISE);
-- 
2.17.1

