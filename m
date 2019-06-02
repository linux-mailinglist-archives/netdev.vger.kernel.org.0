Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9964B32383
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 16:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfFBONO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 10:13:14 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35242 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfFBONN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 10:13:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zu1c9gNK8kb9nagzN3GuqSkjYz8u3X/+NvilC4tuuOE=; b=eMyyomeBwt57yb+y6qLMm4dZGf
        //aSrsYcYndcM1ovMNWBIOAKTXLu5r81+C0uK36TzHl/8+X8wmzUrmMsvtb+bdGk5YdWh7xM/q76+
        elp3bbdIunWvGHm2PyntiGHdRhLI4UVtNWcjaCvdzpsE4jsLSy3rmuLr0PtVIKaYQrfIn1FBu/aWc
        SSmC93DTmu3009NW1KW0jjJBl6kWBy4Fkanhs/6o151xWCRznCpowZpgdMlsz270Jj20BT/erUTQB
        hi7erydCLVkKXUTkfFBVmq34cKDy74+A9ug0p00AkuwCOvua84bMHT0+aKTM1AGDaeisZcoL9rvs0
        2i9gbp+w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47164 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hXREL-0005Qi-96; Sun, 02 Jun 2019 15:13:01 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hXREK-0005KT-1e; Sun, 02 Jun 2019 15:13:00 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH] net: sfp: read eeprom in maximum 16 byte increments
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hXREK-0005KT-1e@rmk-PC.armlinux.org.uk>
Date:   Sun, 02 Jun 2019 15:13:00 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some SFP modules do not like reads longer than 16 bytes, so read the
EEPROM in chunks of 16 bytes at a time.  This behaviour is not specified
in the SFP MSAs, which specifies:

 "The serial interface uses the 2-wire serial CMOS E2PROM protocol
  defined for the ATMEL AT24C01A/02/04 family of components."

and

 "As long as the SFP+ receives an acknowledge, it shall serially clock
  out sequential data words. The sequence is terminated when the host
  responds with a NACK and a STOP instead of an acknowledge."

We must avoid breaking a read across a 16-bit quantity in the diagnostic
page, thankfully all 16-bit quantities in that page are naturally
aligned.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index d4635c2178d1..71812be0ac64 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -281,6 +281,7 @@ static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
 {
 	struct i2c_msg msgs[2];
 	u8 bus_addr = a2 ? 0x51 : 0x50;
+	size_t this_len;
 	int ret;
 
 	msgs[0].addr = bus_addr;
@@ -292,11 +293,26 @@ static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
 	msgs[1].len = len;
 	msgs[1].buf = buf;
 
-	ret = i2c_transfer(sfp->i2c, msgs, ARRAY_SIZE(msgs));
-	if (ret < 0)
-		return ret;
+	while (len) {
+		this_len = len;
+		if (this_len > 16)
+			this_len = 16;
 
-	return ret == ARRAY_SIZE(msgs) ? len : 0;
+		msgs[1].len = this_len;
+
+		ret = i2c_transfer(sfp->i2c, msgs, ARRAY_SIZE(msgs));
+		if (ret < 0)
+			return ret;
+
+		if (ret != ARRAY_SIZE(msgs))
+			break;
+
+		msgs[1].buf += this_len;
+		dev_addr += this_len;
+		len -= this_len;
+	}
+
+	return msgs[1].buf - (u8 *)buf;
 }
 
 static int sfp_i2c_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
-- 
2.7.4

