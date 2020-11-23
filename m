Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D7B2C0EFD
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389607AbgKWPir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbgKWPiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:46 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75BFC0613CF;
        Mon, 23 Nov 2020 07:38:45 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id o9so23951026ejg.1;
        Mon, 23 Nov 2020 07:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ylL9xOBdQF/BS35q7ZH2N3c9DEUDL4zcBQVyTtlRMoU=;
        b=T+/gEFeZQ9gUcq3M5cLhO9XfSb7UuiqFAjxoFqRWwi8kg20Sn2eMds0VfeErmH8YWI
         JkWAv0ZZpGwH6GM5WbM5eOQ8XWa0h6MNkdd+SH+503CAk1M/+rKLteKKOl//Q2haWgdy
         OWx3sTFnSWQGwYcPQGy+QdENtrHkHqAbob4MaEhXaGwFAZKQMNbpP4Sus8qnZYc3yK4B
         96PvYqYlsLwXCeym5IR6CSXTGRyshuyCDsMsoHkFawwLTfKRDB/bXJAKx8ap2mz3KpGd
         8KaCRtzJvxXpq+f14W3njdGY+WzKt/CADnDgPK3CpiYTehK9/GtuyWZatbFOyG/x61Vz
         iMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ylL9xOBdQF/BS35q7ZH2N3c9DEUDL4zcBQVyTtlRMoU=;
        b=mmQfm+TCBfsu1qz6YJgoGKoCJvtQOrO8yQpLwXNxHJJaB9jvonzO7r6qF1vtCb1a+4
         +ktupKgzHun9ouXNkzSNjvLSvLeWr76iddeYqOuY9+NUhXzDZOwR3TCE87xEKBL2/LuS
         +cwIwzy1beeTbyD6shqfLW+QdW/jB5oXBeSs4sZnIFOHZAoNRX1NTVExBKsTA1UV8xTw
         TtMDwbQb088zCTjcMam2g2duTZYk7EhovFDd0/gf42esF59UGjfA76YZ1MMiCBSdCjGw
         mfyyFjROgC6eZhdgh5mVDfUcGI15Aq6idGQTH2R0sTYL2xWrg+V23IIFF/kluhZMVGf+
         yD4w==
X-Gm-Message-State: AOAM533uRs5AuTyS1Zhl/uyNUloymql6Rxpgt6g8pt0cnAz0ixRsFiRC
        f8jaLV4qpme9D/U3eu93rMc=
X-Google-Smtp-Source: ABdhPJyGLoFGp2eRYrUDQZlGs8AEZ3n7GqQt+G8MYH8v5uQ2wl/ct1omXT9xIUQvVnvtfdnuPeXKGA==
X-Received: by 2002:a17:906:c51:: with SMTP id t17mr127094ejf.523.1606145922408;
        Mon, 23 Nov 2020 07:38:42 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:41 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next 03/15] net: phy: icplus: implement generic .handle_interrupt() callback
Date:   Mon, 23 Nov 2020 17:38:05 +0200
Message-Id: <20201123153817.1616814-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123153817.1616814-1-ciorneiioana@gmail.com>
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In an attempt to actually support shared IRQs in phylib, we now move the
responsibility of triggering the phylib state machine or just returning
IRQ_NONE, based on the IRQ status register, to the PHY driver. Having
3 different IRQ handling callbacks (.handle_interrupt(),
.did_interrupt() and .ack_interrupt() ) is confusing so let the PHY
driver implement directly an IRQ handler like any other device driver.
Make this driver follow the new convention.

Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/icplus.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index d6e8516cd146..a74ff45fa99c 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -285,16 +285,24 @@ static int ip101a_g_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, IP101A_G_IRQ_CONF_STATUS, val);
 }
 
-static int ip101a_g_did_interrupt(struct phy_device *phydev)
+static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
 {
-	int val = phy_read(phydev, IP101A_G_IRQ_CONF_STATUS);
+	int irq_status;
 
-	if (val < 0)
-		return 0;
+	irq_status = phy_read(phydev, IP101A_G_IRQ_CONF_STATUS);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & (IP101A_G_IRQ_SPEED_CHANGE |
+			    IP101A_G_IRQ_DUPLEX_CHANGE |
+			    IP101A_G_IRQ_LINK_CHANGE)))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
 
-	return val & (IP101A_G_IRQ_SPEED_CHANGE |
-		      IP101A_G_IRQ_DUPLEX_CHANGE |
-		      IP101A_G_IRQ_LINK_CHANGE);
+	return IRQ_HANDLED;
 }
 
 static int ip101a_g_ack_interrupt(struct phy_device *phydev)
@@ -332,8 +340,8 @@ static struct phy_driver icplus_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.probe		= ip101a_g_probe,
 	.config_intr	= ip101a_g_config_intr,
-	.did_interrupt	= ip101a_g_did_interrupt,
 	.ack_interrupt	= ip101a_g_ack_interrupt,
+	.handle_interrupt = ip101a_g_handle_interrupt,
 	.config_init	= &ip101a_g_config_init,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
-- 
2.28.0

