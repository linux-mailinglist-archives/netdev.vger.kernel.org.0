Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E77E15FAC0
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgBNXjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:39:05 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34659 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbgBNXjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:39:03 -0500
Received: by mail-pg1-f195.google.com with SMTP id j4so5714239pgi.1;
        Fri, 14 Feb 2020 15:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r/daHq14j7KlCEleoh0AsLVk0GU+/IpGzIdkWOGu9j8=;
        b=leCAS4Unb6+jGXWE0rvBqK9AwU54E8dbuT0heucRvFgcJhOl9Nnyab6zIU55jawRwQ
         aLYcfghOpARj2JfpIJujnZx4GB4cp8KswWBdWanJ7j/amtHoqW5zjXXNgaDQWhexzu8P
         3TCSICMvcYwRSLEFvqtRK0aFW06N1aD4WcTKj4mqpQa/6YNBJRNYMHeZLRpv8r4iq4MD
         7Ns2gPGVYsiPkVTlTF5QMGr5auYaD3qIlWBugWD9OKzpxkVqxF3lHXeqQh6AcjklvQsH
         r0dtEdcvQQFl3E+koOmMY2DH9xbFDU/SGd9ThW8IzXL2/LPPOR5Z7lrB3a3JOHYIRtWQ
         MeXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r/daHq14j7KlCEleoh0AsLVk0GU+/IpGzIdkWOGu9j8=;
        b=Vkkh62PrUnfgFEgO2coJg7B9Xv9qaqmobeAuHfL6t8wMRA2AwQOABhLIlvK1IYy1Mg
         n26DUN4TjtVUIgAziyDiUPEa6sfWR96BIA5n3JM1m1j/1/XOB/yGmONiYcLioTF4DzXu
         PZt02jsdjkYKLcGFBfNZtWGQoeC2D4hULFqohwWzGEi4TQ7WomQu/TUiWFwqdEdnzi4Q
         6qyHirzH7PaMX0h6EIlFpYzktS9ZKz1EKv3r5BPVQxd9r5EDFacD4CZ9aCG127F1OXlB
         oaossL1SRRdZGfdRpQ+d1DHBlSUL1UYFKmoquWtRdpaoZJrdhDKJ0xLLNdsj7u4x4s01
         7+lw==
X-Gm-Message-State: APjAAAVSLjET7q4TFCDqEsv0itVVp+eolt82jRrzg0FDKlaaiXQQrZ3y
        s+S+bv3CB5mzkcHaz0ACOqRN7tWZ
X-Google-Smtp-Source: APXvYqyR7VvXUTgn8ShzEg8QgrIaIAsIHsVUqJojROs4F12qWanN9/ER6J0swzxRiqGU2nzZwR0OZA==
X-Received: by 2002:a63:2bc3:: with SMTP id r186mr6010885pgr.294.1581723541252;
        Fri, 14 Feb 2020 15:39:01 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p17sm7797397pfn.31.2020.02.14.15.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 15:39:00 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 3/3] net: phy: broadcom: Wire suspend/resume for BCM54810
Date:   Fri, 14 Feb 2020 15:38:53 -0800
Message-Id: <20200214233853.27217-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214233853.27217-1-f.fainelli@gmail.com>
References: <20200214233853.27217-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BCM54810 PHY can use the standard BMCR Power down suspend, but needs
a custom resume routine which first clear the Power down bit, and then
re-initializes the PHY. While in low-power mode, the PHY only accepts
writes to the BMCR register. The datasheet clearly says it:

Reads or writes to any MII register other than MII Control register
(address 00h) while the device is in the standby power-down mode may
cause unpredictable results.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index b4eae84a9195..ab24692a92c6 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -313,6 +313,20 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int bcm54xx_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Writes to register other than BMCR would be ignored
+	 * unless we clear the PDOWN bit first
+	 */
+	ret = genphy_resume(phydev);
+	if (ret < 0)
+		return ret;
+
+	return bcm54xx_config_init(phydev);
+}
+
 static int bcm5482_config_init(struct phy_device *phydev)
 {
 	int err, reg;
@@ -706,6 +720,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg    = bcm5481_config_aneg,
 	.ack_interrupt  = bcm_phy_ack_intr,
 	.config_intr    = bcm_phy_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= bcm54xx_resume,
 }, {
 	.phy_id		= PHY_ID_BCM5482,
 	.phy_id_mask	= 0xfffffff0,
-- 
2.17.1

