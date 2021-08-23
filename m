Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9673F4C19
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 16:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhHWOLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 10:11:33 -0400
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:29385 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229834AbhHWOLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 10:11:32 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 7A6173432FF;
        Mon, 23 Aug 2021 13:53:34 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-133-152.trex.outbound.svc.cluster.local [100.96.133.152])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 351803433A0;
        Mon, 23 Aug 2021 13:53:33 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.133.152 (trex/6.3.3);
        Mon, 23 Aug 2021 13:53:34 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Soft-Quick: 0551dece3e58c4e1_1629726814168_1414366319
X-MC-Loop-Signature: 1629726814168:1364314280
X-MC-Ingress-Time: 1629726814168
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fV4yWEquu4Ia3Qoprg1yduyIPeuKPKvMjUc39+dc8PQ=; b=vQdE7BsXFNRiFDZIllW010v28y
        JvxKNr4TLpk+MoPnUPujZjA+2cjkV9Pa6ZCiqUvE9/PCL2ApgmRwVK/vSZv3yOArQ4JSf1/jPeTSk
        1tUrzqU3B7MIM3az59O/OXiJTr30nY3/8cOkjsw11VuYG1ofd+oieiaqIlSM6wpbtxo7ZU+uYqXY/
        KwsHjTNrb2KSHWaP38dnhcgS6fHS7AGJ6bzCo66WkVbh3HHm6rnQUyMVtmk+nEhoE0YJ5KLITIQ1M
        8kicOussc+OZTCsIBtZPDrhBD3P7OeeWJUC1JbSCjHeGzEeOIpQ8nIADPO1ogKkt2XlX0PSb934Vd
        Dy+qX9PA==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51812 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIAOJ-003PzY-76; Mon, 23 Aug 2021 14:53:30 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 06/10] lan78xx: Fix exception on link speed change
Date:   Mon, 23 Aug 2021 14:52:25 +0100
Message-Id: <20210823135229.36581-7-john.efstathiades@pebblebay.com>
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

An exception is sometimes seen when the link speed is changed
from auto-negotiation to a fixed speed, or vice versa. The
exception occurs when the MAC is reset (due to the link speed
change) at the same time as the PHY state machine is accessing
a PHY register. The following changes fix this problem.

Rework the MAC reset to ensure there is no outstanding MDIO
register transaction before the reset and then wait until the
reset is complete before allowing any further MAC register access.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 54 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3181753b1621..9be823616dd7 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1169,6 +1169,52 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
 	return 0;
 }
 
+static int lan78xx_mac_reset(struct lan78xx_net *dev)
+{
+	unsigned long start_time = jiffies;
+	u32 val;
+	int ret;
+
+	mutex_lock(&dev->phy_mutex);
+
+	/* Resetting the device while there is activity on the MDIO
+	 * bus can result in the MAC interface locking up and not
+	 * completing register access transactions.
+	 */
+	ret = lan78xx_phy_wait_not_busy(dev);
+	if (ret < 0)
+		goto done;
+
+	ret = lan78xx_read_reg(dev, MAC_CR, &val);
+	if (ret < 0)
+		goto done;
+
+	val |= MAC_CR_RST_;
+	ret = lan78xx_write_reg(dev, MAC_CR, val);
+	if (ret < 0)
+		goto done;
+
+	/* Wait for the reset to complete before allowing any further
+	 * MAC register accesses otherwise the MAC may lock up.
+	 */
+	do {
+		ret = lan78xx_read_reg(dev, MAC_CR, &val);
+		if (ret < 0)
+			goto done;
+
+		if (!(val & MAC_CR_RST_)) {
+			ret = 0;
+			goto done;
+		}
+	} while (!time_after(jiffies, start_time + HZ));
+
+	ret = -ETIME;
+done:
+	mutex_unlock(&dev->phy_mutex);
+
+	return ret;
+}
+
 static int lan78xx_link_reset(struct lan78xx_net *dev)
 {
 	struct phy_device *phydev = dev->net->phydev;
@@ -1190,12 +1236,8 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 		dev->link_on = false;
 
 		/* reset MAC */
-		ret = lan78xx_read_reg(dev, MAC_CR, &buf);
-		if (unlikely(ret < 0))
-			return ret;
-		buf |= MAC_CR_RST_;
-		ret = lan78xx_write_reg(dev, MAC_CR, buf);
-		if (unlikely(ret < 0))
+		ret = lan78xx_mac_reset(dev);
+		if (ret < 0)
 			return ret;
 
 		del_timer(&dev->stat_monitor);
-- 
2.25.1

