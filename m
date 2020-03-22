Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F67D18E73C
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgCVG4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:56:38 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50462 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgCVG4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:56:36 -0400
Received: by mail-pj1-f67.google.com with SMTP id v13so4530123pjb.0;
        Sat, 21 Mar 2020 23:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NlpkrNH8Vqp4VWa2PUxHS4ZCSTCXzOnC9l8dpUh9E04=;
        b=Mnkvwrd9JPEINP3EiVygq7CmAm0Rv2H7iUE6WzullP97qAHT7m3wSlXx00bXGY5mpu
         aOFebhsnY/p+5c8QiVDQ5LC1mgPd68Q+4E1lB3Sgp3tdHVfC2yAuZJcSRQsOHyGWXCrx
         KYTg8JxxE3d3yS74Gxc19w07bstCKnGa3nQdVhYxdMw1uFfrsRv0pUUsoA/HUKaS2mxR
         WcE3qUA3JeeWQWTwVQWccErLMqOlj/6TzP0WWflq6wYeB9AoPuPcVD29zLQPyFOmQ83w
         w1GoAqYuuegG+GGHyVLDa0ah69+ehaA0PFWAVvWRBcEqPoMyPa5DpGO0qSZ5glMiJFZQ
         bJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NlpkrNH8Vqp4VWa2PUxHS4ZCSTCXzOnC9l8dpUh9E04=;
        b=CTueIFOml7yI7F0tH1BGiu6L2V7z7KQxNuOIBqipOwM/e+4OAJm2Qajqws8XQFeLWg
         evtVTHuOxunoMrFdvaxQsFTSnfgqyRflbqgJBFD10+F/vG9Z5FuNccozWEL3yp4hwbaD
         PMrzhEhYDzD3fneolVU9yjqvwq2I0RsmIn0Ln9SVeCZnANNrz8oxh8zC+qsA1FWzjKdh
         lmZSVIDcoDpoxFPNBHeu4pNX3qKgXRV4Fjci6ZOgyrZ50/55GJ5Lv6NmFra8uXnwNRRd
         Scj05kD8ZZ7ZDaXK16MXkq3waCwJs6tw1vNf+cxiStI/QxQjodVNUQOPoEiZ3INqegWa
         rCUA==
X-Gm-Message-State: ANhLgQ2qE+Salq+NuwsijkwUfhUvdBzt2OgHb59M7Ak9Mn+opQAHXCcf
        ExDJ1jnUSk83R/4hQH4nWns=
X-Google-Smtp-Source: ADFU+vs6l79wfzDQJQnRfoFQbGssozis7iaIzNyRNXK/VYIzlnFWX3rGtzVnFgbP2oDuVT6QYp88xw==
X-Received: by 2002:a17:90a:c482:: with SMTP id j2mr18659260pjt.71.1584860194831;
        Sat, 21 Mar 2020 23:56:34 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id i11sm8839886pje.30.2020.03.21.23.56.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 23:56:34 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        gregkh@linuxfoundation.org, broonie@kernel.org,
        alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v4 8/9] net: phy: smsc: use phy_read_poll_timeout() to simplify the code
Date:   Sun, 22 Mar 2020 14:55:54 +0800
Message-Id: <20200322065555.17742-9-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322065555.17742-1-zhengdejin5@gmail.com>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_poll_timeout() to replace the poll codes for
simplify lan87xx_read_status() function.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v3 -> v4:
	- add this patch by Andrew's suggestion. Thanks Andrew!

 drivers/net/phy/smsc.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index b73298250793..46b50b78c6f3 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -112,8 +112,6 @@ static int lan87xx_read_status(struct phy_device *phydev)
 	int err = genphy_read_status(phydev);
 
 	if (!phydev->link && priv->energy_enable) {
-		int i;
-
 		/* Disable EDPD to wake up PHY */
 		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
@@ -125,15 +123,11 @@ static int lan87xx_read_status(struct phy_device *phydev)
 			return rc;
 
 		/* Wait max 640 ms to detect energy */
-		for (i = 0; i < 64; i++) {
-			/* Sleep to allow link test pulses to be sent */
-			msleep(10);
-			rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
-			if (rc < 0)
-				return rc;
-			if (rc & MII_LAN83C185_ENERGYON)
-				break;
-		}
+		phy_read_poll_timeout(phydev, MII_LAN83C185_CTRL_STATUS, rc,
+				      rc & MII_LAN83C185_ENERGYON, 10000,
+				      640000);
+		if (rc < 0)
+			return rc;
 
 		/* Re-enable EDPD */
 		rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
-- 
2.25.0

