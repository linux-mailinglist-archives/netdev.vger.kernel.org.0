Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC32CEB9DF
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbfJaWnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:43:31 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37206 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbfJaWna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 18:43:30 -0400
Received: by mail-wr1-f66.google.com with SMTP id t1so2042358wrv.4;
        Thu, 31 Oct 2019 15:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NVhlq3u3MB0yWfqyvlDf8GNlsP6JBTZWJ25QW6Q4a1k=;
        b=K9S3/BOimBENnHF5gZaXALJDIm92WoYUMKRedQTXSjJyWbd1X35XIyfDutJ4md2rzB
         yNrtLTOhqXfFJQHZgN4fARHcWcBitdRqIcuGxtmbTZtiDq+5L/hLmwGirmYD2PV3/uVV
         l9ARANY56Z0RFhZz+XV8FymNO0yiPZVnwR2G7NYdrvK6UfbjoIEHjocWNatIWWxKgKvC
         EMRHG1aOaBiUTlF80HVib9FKcgcmLGi9lA0TmcgqchAkfP+Bcd1M1TLddFdXE29Z33PX
         tWrbfObkUWElwlhS+PT/Sm9iSNe3ea1DB01es0hASLUl3dRX88LDVYCL5ax+CEVRYdKv
         ICJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NVhlq3u3MB0yWfqyvlDf8GNlsP6JBTZWJ25QW6Q4a1k=;
        b=Q6zeTxB7UFpBwBrY+FDPXzPRz3wBC4Xgny69WOPcUGAww8puobDRwJzH4NWJayZ9br
         vOkQOMU2S5xNsyZS9gUO8eg1SawhIfxqB2hV646FBV9HkCCOIfFlY90Fpfyh34f8vSFj
         YRLx8LAebXkTHuQihDhJxaEYNvv4qv7b8nfDg7O3fQo6zP8EIPClI9K9nmX7tpb0zsD1
         wAHSdN9ytxAaJHpkKqSTiAAJSEds+KR3zOJtElzTAe6zYeDF0DI1zhG7yraUYxuPDFUy
         AZ4PS+COvva1kMN8fRCf5363bMRDLKIYQ0VswF1vReqXDm2UtdUxARoGJJdgDvAPnJ4G
         4kNA==
X-Gm-Message-State: APjAAAWWc7A9PhXnrJE5g1R0hBSx5IqI1IklEGlOTWtrNvdNwXWiDY/S
        WS8w4dEVUriVAFYn/yQ95HHApwqU
X-Google-Smtp-Source: APXvYqy4uZvu1/xe1jdaVQAALYDVcKrohdw8sgU9zNIOJQARdWHgv3XCBCSpUSdEElZjwxlYov4Dbg==
X-Received: by 2002:a5d:6a91:: with SMTP id s17mr8417102wru.224.1572561807881;
        Thu, 31 Oct 2019 15:43:27 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o25sm6280760wro.21.2019.10.31.15.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 15:43:27 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ioana.ciornei@nxp.com, olteanv@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: phylink: Fix phylink_dbg() macro
Date:   Thu, 31 Oct 2019 15:42:26 -0700
Message-Id: <20191031224227.6992-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phylink_dbg() macro does not follow dynamic debug or defined(DEBUG)
and as a result, it spams the kernel log since a PR_DEBUG level is
currently used. Fix it to be defined appropriately whether
CONFIG_DYNAMIC_DEBUG or defined(DEBUG) are set.

Fixes: 17091180b152 ("net: phylink: Add phylink_{printk, err, warn, info, dbg} macros")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phylink.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 20e2ebe458f2..a578f7ebf715 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -87,8 +87,24 @@ struct phylink {
 	phylink_printk(KERN_WARNING, pl, fmt, ##__VA_ARGS__)
 #define phylink_info(pl, fmt, ...) \
 	phylink_printk(KERN_INFO, pl, fmt, ##__VA_ARGS__)
+#if defined(CONFIG_DYNAMIC_DEBUG)
 #define phylink_dbg(pl, fmt, ...) \
+do {									\
+	if ((pl)->config->type == PHYLINK_NETDEV)			\
+		netdev_dbg((pl)->netdev, fmt, ##__VA_ARGS__);		\
+	else if ((pl)->config->type == PHYLINK_DEV)			\
+		dev_dbg((pl)->dev, fmt, ##__VA_ARGS__);			\
+} while (0)
+#elif defined(DEBUG)
+#define phylink_dbg(pl, fmt, ...)					\
 	phylink_printk(KERN_DEBUG, pl, fmt, ##__VA_ARGS__)
+#else
+#define phylink_dbg(pl, fmt, ...)					\
+({									\
+	if (0)								\
+		phylink_printk(KERN_DEBUG, pl, fmt, ##__VA_ARGS__);	\
+})
+#endif
 
 /**
  * phylink_set_port_modes() - set the port type modes in the ethtool mask
-- 
2.17.1

