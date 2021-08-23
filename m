Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C0C3F4C0E
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 16:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhHWODA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 10:03:00 -0400
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:43437 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229758AbhHWOC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 10:02:59 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 005BB342C96;
        Mon, 23 Aug 2021 13:53:34 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-16-227.trex-nlb.outbound.svc.cluster.local [100.96.16.227])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id AB83234305A;
        Mon, 23 Aug 2021 13:53:32 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.16.227 (trex/6.3.3);
        Mon, 23 Aug 2021 13:53:33 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Absorbed-Celery: 1c7a1ad6044ee0c8_1629726813660_91461395
X-MC-Loop-Signature: 1629726813660:3355135082
X-MC-Ingress-Time: 1629726813660
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NS9GFi66ypyDfAeRNPz+5eoUZPUwwd01djzPnBU4FgE=; b=vy4jJnZLhYBp2jfr0Z7vG+Kbio
        k3434ZVd8suyoUPbORTywivOtibD6nEXj/edJpO/EqaQwi2S+rHifrVXh7WnfzFBW3twodJwLgrPN
        lZGSIF2Zvo0Kj40ArjTKMQJB09l9Da/d76GculT3r3nYYn+ZB8PTDvLxrF6ZxDXSV7F7syMZiuqhH
        39B8Q7iPbRANGLbnuX7tRKF/A7mMX8tWqA7RWr+gTD6Uv00i0/ei2trUOeFpn1HT1o/cV8ipnzeG7
        45tAGtPK6gsN2ps7Eo2FH9TTdtApCMULoo8GbH77jg82M03rBFtEVkJwpjzpEtybGIcm4iYao2IO5
        80+s7Mww==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51812 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIAOJ-003PzY-1T; Mon, 23 Aug 2021 14:53:30 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 05/10] lan78xx: Disable USB3 link power state transitions
Date:   Mon, 23 Aug 2021 14:52:24 +0100
Message-Id: <20210823135229.36581-6-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable USB3 link power state transitions from U0 (Fully Powered) to
U1 (Standby with Fast Recovery) or U2 (Standby with Slow Recovery).

The device can initiate U1 and U2 state transitions when there is no
activity on the bus which can save power. However, testing with some
USB3 hosts and hubs showed erratic ping response time due to the time
required to transition back to U0 state.

In the following example the outgoing packets were delayed until the
device transitioned from U2 back to U0 giving the misleading
response time.

console:/data/local # ping 192.168.73.1
PING 192.168.73.1 (192.168.73.1) 56(84) bytes of data.
64 bytes from 192.168.73.1: icmp_seq=1 ttl=64 time=466 ms
64 bytes from 192.168.73.1: icmp_seq=2 ttl=64 time=225 ms
64 bytes from 192.168.73.1: icmp_seq=3 ttl=64 time=155 ms
64 bytes from 192.168.73.1: icmp_seq=4 ttl=64 time=7.07 ms
64 bytes from 192.168.73.1: icmp_seq=5 ttl=64 time=141 ms
64 bytes from 192.168.73.1: icmp_seq=6 ttl=64 time=152 ms
64 bytes from 192.168.73.1: icmp_seq=7 ttl=64 time=51.9 ms
64 bytes from 192.168.73.1: icmp_seq=8 ttl=64 time=136 ms

The following shows the behaviour when the U1 and U2 transitions
were disabled.

console:/data/local # ping 192.168.73.1
PING 192.168.73.1 (192.168.73.1) 56(84) bytes of data.
64 bytes from 192.168.73.1: icmp_seq=1 ttl=64 time=6.66 ms
64 bytes from 192.168.73.1: icmp_seq=2 ttl=64 time=2.97 ms
64 bytes from 192.168.73.1: icmp_seq=3 ttl=64 time=2.02 ms
64 bytes from 192.168.73.1: icmp_seq=4 ttl=64 time=2.42 ms
64 bytes from 192.168.73.1: icmp_seq=5 ttl=64 time=2.47 ms
64 bytes from 192.168.73.1: icmp_seq=6 ttl=64 time=2.55 ms
64 bytes from 192.168.73.1: icmp_seq=7 ttl=64 time=2.43 ms
64 bytes from 192.168.73.1: icmp_seq=8 ttl=64 time=2.13 ms

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 44 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 746aeeaa9d6e..3181753b1621 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -430,6 +430,12 @@ struct lan78xx_net {
 #define	PHY_LAN8835			(0x0007C130)
 #define	PHY_KSZ9031RNX			(0x00221620)
 
+/* Enabling link power state transitions will reduce power consumption
+ * when the link is idle. However, this can cause problems with some
+ * USB3 hubs resulting in erratic packet flow.
+ */
+static bool enable_link_power_states;
+
 /* use ethtool to change the level for any given device */
 static int msg_level = -1;
 module_param(msg_level, int, 0);
@@ -1173,7 +1179,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 	/* clear LAN78xx interrupt status */
 	ret = lan78xx_write_reg(dev, INT_STS, INT_STS_PHY_INT_);
 	if (unlikely(ret < 0))
-		return -EIO;
+		return ret;
 
 	mutex_lock(&phydev->lock);
 	phy_read_status(phydev);
@@ -1186,11 +1192,11 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 		/* reset MAC */
 		ret = lan78xx_read_reg(dev, MAC_CR, &buf);
 		if (unlikely(ret < 0))
-			return -EIO;
+			return ret;
 		buf |= MAC_CR_RST_;
 		ret = lan78xx_write_reg(dev, MAC_CR, buf);
 		if (unlikely(ret < 0))
-			return -EIO;
+			return ret;
 
 		del_timer(&dev->stat_monitor);
 	} else if (link && !dev->link_on) {
@@ -1198,23 +1204,49 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 
 		phy_ethtool_ksettings_get(phydev, &ecmd);
 
-		if (dev->udev->speed == USB_SPEED_SUPER) {
+		if (enable_link_power_states &&
+		    dev->udev->speed == USB_SPEED_SUPER) {
 			if (ecmd.base.speed == 1000) {
 				/* disable U2 */
 				ret = lan78xx_read_reg(dev, USB_CFG1, &buf);
+				if (ret < 0)
+					return ret;
 				buf &= ~USB_CFG1_DEV_U2_INIT_EN_;
 				ret = lan78xx_write_reg(dev, USB_CFG1, buf);
+				if (ret < 0)
+					return ret;
 				/* enable U1 */
 				ret = lan78xx_read_reg(dev, USB_CFG1, &buf);
+				if (ret < 0)
+					return ret;
 				buf |= USB_CFG1_DEV_U1_INIT_EN_;
 				ret = lan78xx_write_reg(dev, USB_CFG1, buf);
+				if (ret < 0)
+					return ret;
 			} else {
 				/* enable U1 & U2 */
 				ret = lan78xx_read_reg(dev, USB_CFG1, &buf);
+				if (ret < 0)
+					return ret;
 				buf |= USB_CFG1_DEV_U2_INIT_EN_;
 				buf |= USB_CFG1_DEV_U1_INIT_EN_;
 				ret = lan78xx_write_reg(dev, USB_CFG1, buf);
+				if (ret < 0)
+					return ret;
 			}
+		} else {
+			/* Disabling initiation of U1 and U2 transitions
+			 * prevents erratic ping times when connected to
+			 * some USB3 hubs.
+			 */
+			ret = lan78xx_read_reg(dev, USB_CFG1, &buf);
+			if (ret < 0)
+				return ret;
+			buf &= ~USB_CFG1_DEV_U2_INIT_EN_;
+			buf &= ~USB_CFG1_DEV_U1_INIT_EN_;
+			ret = lan78xx_write_reg(dev, USB_CFG1, buf);
+			if (ret < 0)
+				return ret;
 		}
 
 		ladv = phy_read(phydev, MII_ADVERTISE);
@@ -1231,6 +1263,8 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 
 		ret = lan78xx_update_flowcontrol(dev, ecmd.base.duplex, ladv,
 						 radv);
+		if (ret < 0)
+			return ret;
 
 		if (!timer_pending(&dev->stat_monitor)) {
 			dev->delta = 1;
@@ -1241,7 +1275,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 		tasklet_schedule(&dev->bh);
 	}
 
-	return ret;
+	return 0;
 }
 
 /* some work can't be done in tasklets, so we use keventd
-- 
2.25.1

