Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3FA18BCCE
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgCSQkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:40:18 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41808 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbgCSQkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:40:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id z65so1705366pfz.8;
        Thu, 19 Mar 2020 09:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Spp2H3hwciDP1zBFrVBHl1IpU/knurYnjuBrzYZScTU=;
        b=UpAgYC7nZVkWQF4LvCgpV5BXriVMI8qNFksFs8kzGsHdIv+o6gD8M4zQ1CpiLksx+g
         GKDbgYud0ixo198bAP5YNrGbK4+RBQ2iJ8m2XyFCI+FG5iCacmqTmXT0QcwNUaFWU04N
         xNXgUGGovwiKV0HTIzBo7usKrqSvGMNBts/ZJHiOmrB4cIn6KA/OjkHA0p+REmbgo/6h
         omjg4n1d++HkWdkDZBxeOhBzPeEajlyY9B8a1H1aphY0ihkVL9F6YYXn1ckvjPwBhzZU
         WrvYJKzKH8U2AynfRMYQlQSW2dP0Q48LEvB3aRkQE0JgL7li3ADBiDLSlO8fMMeXkWHL
         qbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Spp2H3hwciDP1zBFrVBHl1IpU/knurYnjuBrzYZScTU=;
        b=IGe0Vx4A7O9Tj1wFjjy1uefb9tdXXc8Vq+UGC9b4tVYNDFJidMEeb/OAGizBGKCkbP
         CZ4Y2jPdn2pdxDIjSd2oSchDvzG4g+kHHLZ/9r29xXkqWBKAR9dopvuZkDdiDBQe1Avj
         92ZtKfY3SvnVW1fDijq7JLJmLVPcmyVdiqGBsF0rADh0iHmS+C8uGQeYouH//D5c8GSh
         UP/q0kP9N9gNZknfM6Z1n+5xyQeAHVAb/3Cs3CPqsTiMlopzPqtWWbeJoL2VBcMLkbtb
         /KE1a3NdRo70jgriUSvVzGzrxx1Aq0OioXLL9UV30PQaMGBEUnmToLYnXev6ePHZWY+R
         OFIQ==
X-Gm-Message-State: ANhLgQ2iMHi9+EFp5q0z3jBXtkwjM7WgmrDud+neOucRAMAhaMvyIhiM
        zwVUpuRb6SoWFGbYDCvSqvY=
X-Google-Smtp-Source: ADFU+vsaJO/NrK2mI3eUq7ZsN5qq4mcDmMwFMUxb7gJtsg8rSJhCsjt8VIN4SpEv0XLLqE8+u8KX0w==
X-Received: by 2002:aa7:84cd:: with SMTP id x13mr5055484pfn.310.1584636015372;
        Thu, 19 Mar 2020 09:40:15 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id b4sm2833621pfd.18.2020.03.19.09.40.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 09:40:14 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, tglx@linutronix.de,
        broonie@kernel.org, corbet@lwn.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next 7/7] net: phy: use phy_read_poll_timeout() to simplify the code
Date:   Fri, 20 Mar 2020 00:39:10 +0800
Message-Id: <20200319163910.14733-8-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200319163910.14733-1-zhengdejin5@gmail.com>
References: <20200319163910.14733-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_poll_timeout() to replace the poll codes for
simplify the code in phy_poll_reset() function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/phy/phy_device.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a585faf8b844..bdef427593c9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1059,23 +1059,17 @@ EXPORT_SYMBOL(phy_disconnect);
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
 
+	ret = phy_read_poll_timeout(val, val < 0 || !(val & BMCR_RESET),
+				    50000, 600000, phydev, MII_BMCR);
+	if (val < 0)
+		ret = val;
 	/* Some chips (smsc911x) may still need up to another 1ms after the
 	 * BMCR_RESET bit is cleared before they are usable.
 	 */
 	msleep(1);
-	return 0;
+	return ret;
 }
 
 int phy_init_hw(struct phy_device *phydev)
-- 
2.25.0

