Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 037A418EE42
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 03:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgCWC5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 22:57:43 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32799 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWC5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 22:57:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id g18so5305931plq.0;
        Sun, 22 Mar 2020 19:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+p4imykiyrHAwd8AvRjrh/eHrAh9QGnbT6l+Vq4Dzzw=;
        b=ncFw2jY0TgTLwHuTDo4qah0cki6+BeyU5InoW6ZbjwrkMIW3Y3zIS9KhtJqmNZBHUh
         f0uxYTlfN+pbpo7YFVbSpRWtq3xKxLN9CCpqXvEBkmNru85kKScwfEuTQve9TGHeHh2A
         +CVyrEpXwog8oaWLwroEUFXYmPBeu8e5hrnLthBl6pMaoD2jFJXauiMauyXDQgSZHqJX
         rA/QBhmDvRJbXMQbQry9iEBM+ln725t6KWd4tHrRWbjYeyZzgEQt+t1hsw/RxiShc6IW
         mEUzbxS9Co2Ja1VsJCgiR3jbmHiktrODTPpkeifULvuGGEyw0BX8IOkL+85Sul6chjT6
         hncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+p4imykiyrHAwd8AvRjrh/eHrAh9QGnbT6l+Vq4Dzzw=;
        b=Fg7YNhlIe7a1CCUqgdaQKYi0VvN8QsJ1dAmpNG4CvmKwlvH3K2fhtCiNZtO/riFDhV
         tQVbnMV1fYb8f0ZXddWC5u1J+Gujs+M5pae2SYfFaVg7N0XzDf6fn0o2yF7kgLGe8hGC
         vN0fkQ7ho2JA0pAAFRpm5GuCAQ0n/oHoTKjJzVmP9mjFRbm/JOwaXSu9ErLFWOq6Cha0
         jfN1zdKLAPRo0PsmaPf2Om1Wt/D44w+9G3Ax5plrEfEPonMSqHJnelXspog/QPXr9zmr
         eH4fICtjjTqTUGq+9dTxVkL1LIZK6xBhXMyyAImaX3FvBP76fJZhHdwvBMBEWwNYpNAP
         lt5g==
X-Gm-Message-State: ANhLgQ28dmCdW96PiGCnSmKxFyyDNEy+BCW8LXpdxfTgFvrllGOEkOeD
        +0LYsN6aeybkM3r2f015hTN/4ogq
X-Google-Smtp-Source: ADFU+vvF86+oBS7yKAsz//EQlALOWUVquJU3oBaTYrr25XcFortgxddANnkWCUmJcx/5eauRA0uMvw==
X-Received: by 2002:a17:902:bccb:: with SMTP id o11mr20085025pls.281.1584932261635;
        Sun, 22 Mar 2020 19:57:41 -0700 (PDT)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id k14sm11941446pfg.15.2020.03.22.19.57.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 19:57:41 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v6 08/10] net: phy: use phy_read_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 10:56:31 +0800
Message-Id: <20200323025633.6069-9-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323025633.6069-1-zhengdejin5@gmail.com>
References: <20200323025633.6069-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_poll_timeout() to replace the poll codes for
simplify the code in phy_poll_reset() function.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v5 -> v6:
	- add some check for keep the code more similar.
v4 -> v5:
	- it can add msleep before call phy_read_poll_timeout()
	  to keep the code more similar. so add it.
v3 -> v4:
	- drop it.
v2 -> v3:
	- adapt to it after modifying the parameter order of the
	  newly added function
v1 -> v2:
	- remove the handle of phy_read()'s return error.

 drivers/net/phy/phy_device.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a585faf8b844..eb1b177a9878 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1059,18 +1059,13 @@ EXPORT_SYMBOL(phy_disconnect);
 static int phy_poll_reset(struct phy_device *phydev)
 {
 	/* Poll until the reset bit clears (50ms per retry == 0.6 sec) */
-	unsigned int retries = 12;
-	int ret;
-
-	do {
-		msleep(50);
-		ret = phy_read(phydev, MII_BMCR);
-		if (ret < 0)
-			return ret;
-	} while (ret & BMCR_RESET && --retries);
-	if (ret & BMCR_RESET)
-		return -ETIMEDOUT;
+	int ret, val;
 
+	msleep(50);
+	ret = phy_read_poll_timeout(phydev, MII_BMCR, val, !(val & BMCR_RESET),
+				    50000, 550000);
+	if (ret)
+		return ret;
 	/* Some chips (smsc911x) may still need up to another 1ms after the
 	 * BMCR_RESET bit is cleared before they are usable.
 	 */
-- 
2.25.0

