Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A563F695E
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhHXS6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:58:20 -0400
Received: from crane.ash.relay.mailchannels.net ([23.83.222.43]:59254 "EHLO
        crane.ash.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233940AbhHXS6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:58:13 -0400
X-Greylist: delayed 15822 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2021 14:58:11 EDT
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id CCBB0321CFC;
        Tue, 24 Aug 2021 18:57:22 +0000 (UTC)
Received: from ares.krystal.co.uk (100-101-162-88.trex-nlb.outbound.svc.cluster.local [100.101.162.88])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 20D50322351;
        Tue, 24 Aug 2021 18:57:20 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.101.162.88 (trex/6.4.3);
        Tue, 24 Aug 2021 18:57:22 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Attack-Thoughtful: 1b673c3f296beca9_1629831442540_804651709
X-MC-Loop-Signature: 1629831442540:3574260364
X-MC-Ingress-Time: 1629831442539
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kbSFeOsjvVC/aVHn3HnLP3khE+0Ljbf1Xt1deuUC75I=; b=cUPOvrIgSUHbnLGldttZAOfDux
        KcpfFfQQJ80Z2ZsM/QY7N9T24wiczaZtOLZ53uQcpEiAwPUM7Sv+MR6t6ac3ag7wGjOfpsuZhdKw0
        5rZAziRxKiVBObCOtZTepQE322LssXf1D62JvXJQCTjR5AtiEflAthbPEbUlxqsgQSmaviMYA5k9q
        QyhuZhZyUF1cWTGdkHwquDmyWGLsDY8R8djiQ5hIJwNGhC9dwznb+2IW+GK8jyukR0WiesPdBodJV
        BdzL/83BIvBF3nEnN7qAd6tMFQmCW9nIB+5/zoyI0Y5k2ZkWVxikfh3LS4KtxtCsqC13WCQkqHtYn
        JmuroJ8w==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51816 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIbbs-00BQSi-5i; Tue, 24 Aug 2021 19:57:19 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-usb@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next v2 06/10] lan78xx: Fix exception on link speed change
Date:   Tue, 24 Aug 2021 19:56:09 +0100
Message-Id: <20210824185613.49545-7-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
References: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
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
index 1909d6003453..2eb853b13c2a 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1163,6 +1163,52 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
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
+	ret = -ETIMEDOUT;
+done:
+	mutex_unlock(&dev->phy_mutex);
+
+	return ret;
+}
+
 static int lan78xx_link_reset(struct lan78xx_net *dev)
 {
 	struct phy_device *phydev = dev->net->phydev;
@@ -1184,12 +1230,8 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
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

