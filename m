Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB04D1BCE34
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgD1VJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:09:08 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:50637 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgD1VJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:09:06 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 72F7122727;
        Tue, 28 Apr 2020 23:09:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588108144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G8Or1GwmdPmml+wVX3TSQBhgpBzIcthdpQ8T1ot15Vc=;
        b=rsikoOW6LOknce9VK54zuLGDqf3j5CRvv//EhQnI1V0ML9TFm8Fv9DvTnvatb1r0OIerYV
        zDSl819mk9cqeRToAILUMdEF4w2IIr8G9l6Ga9C2y3Ujt75PzJroq4T/n0B7xOftbA20ex
        msv9CZJgfj4i/iNakS925h0TyCnT58E=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 3/4] net: phy: bcm54140: apply the workaround on b0 chips
Date:   Tue, 28 Apr 2020 23:08:53 +0200
Message-Id: <20200428210854.28088-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200428210854.28088-1-michael@walle.cc>
References: <20200428210854.28088-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 72F7122727
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lower three bits of the phy_id specifies the chip stepping. The
workaround is specifically for the B0 stepping. Apply it only on these
chips.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/bcm54140.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
index edafc9dc2f63..d73cbddbc69b 100644
--- a/drivers/net/phy/bcm54140.c
+++ b/drivers/net/phy/bcm54140.c
@@ -115,6 +115,9 @@
 #define BCM54140_HWMON_IN_ALARM_BIT(ch) ((ch) ? BCM54140_RDB_MON_ISR_3V3 \
 					      : BCM54140_RDB_MON_ISR_1V0)
 
+#define BCM54140_PHY_ID_REV(phy_id)	((phy_id) & 0x7)
+#define BCM54140_REV_B0			1
+
 #define BCM54140_DEFAULT_DOWNSHIFT 5
 #define BCM54140_MAX_DOWNSHIFT 9
 
@@ -632,9 +635,11 @@ static int bcm54140_config_init(struct phy_device *phydev)
 	int ret;
 
 	/* Apply hardware errata */
-	ret = bcm54140_b0_workaround(phydev);
-	if (ret)
-		return ret;
+	if (BCM54140_PHY_ID_REV(phydev->phy_id) == BCM54140_REV_B0) {
+		ret = bcm54140_b0_workaround(phydev);
+		if (ret)
+			return ret;
+	}
 
 	/* Unmask events we are interested in. */
 	reg &= ~(BCM54140_RDB_INT_DUPLEX |
-- 
2.20.1

