Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9E5376DAB
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhEHAaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhEHAaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:22 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D290EC061574;
        Fri,  7 May 2021 17:29:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id s82so6101496wmf.3;
        Fri, 07 May 2021 17:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ceZsngI1VaZJ3EMhxlXbFwwOKDKMAKywASflzR5/4cU=;
        b=s2gSd6cOdhtXlhezgjj1rWHyNyd21tM+E/YyfyY1PuF+sF7vVSt4rtMCwFnlHtB4JF
         9eAwi2fbFLS/XDVG6b+l3NQYSXBLhIQZrzxTas9WWGssfzpWLAIdK+5PREBEhIbA3t6m
         F0dfc+9+RzpNhWNhwla0lNL986K6UWLmanneh5EAF4kpDito8uGexusZPbrKm3Hr3iPm
         AvpJhY/pVRqvO4Lv5duootZQuOkVOVlvaLnwpMB2QERjDDOl8/4trUi8qlzmUF51F2ga
         O1/SLFUYjTWTxsire2EAszO8q6WGIVPHBSUV02bRY/lUHG1+2O9kHoVVQSUjkHuyPrn5
         63OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ceZsngI1VaZJ3EMhxlXbFwwOKDKMAKywASflzR5/4cU=;
        b=eQhrrJn7+ItbMagyNrdtiY2TJz5CZf8vCGo6A3ImX/uvODszGUYoVFgn4ArsoyqJjU
         uZA/mDs7pbUyLho9b//9Uwx7BdZYYX8562Jx7E7HHk4wEJWfdiaBsQBOEWBPzT25NzdV
         esMMlSN4cHwXgxmxSLXNX+serGDG1t5qWfsDe1mslEyt6ZsdXq10ZTGvZdNDP1DMNJ4U
         279wY8zH+ST3BwELKVQ5v9iv4eqislUcpGkq27DC/bNqBiW7LHWLYxOy/6QoAhmVWk/W
         wMRF8kVlXzSyXjn26B2BbLUxNewevjTMMFHLTQONKXVkBrSgT/221hTabksvZ7bsPXXY
         9Uwg==
X-Gm-Message-State: AOAM531va44eCnz5y0dCdxnqDjl70Qc9Wtcbb073i8bTga+1QFjhyOei
        RKGh3W5JKFNZQui6yMNWSLc=
X-Google-Smtp-Source: ABdhPJw0f4QjZtsN5+6wcWvoqKSXCtEuIIDvuv1VrJ4+gLkrwxd3+VxUaVT00M72/X+Y0W430TO8wA==
X-Received: by 2002:a1c:7419:: with SMTP id p25mr24330483wmc.79.1620433760446;
        Fri, 07 May 2021 17:29:20 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:20 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 03/28] net: mdio: ipq8064: enlarge sleep after read/write operation
Date:   Sat,  8 May 2021 02:28:53 +0200
Message-Id: <20210508002920.19945-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the use of the qca8k dsa driver, some problem arised related to
port status detection. With a load on a specific port (for example a
simple speed test), the driver starts to behave in a strange way and
garbage data is produced. To address this, enlarge the sleep delay and
address a bug for the reg offset 31 that require additional delay for
this specific reg.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/mdio/mdio-ipq8064.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index 9862745d1cee..a3f7f9de12b6 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -65,7 +65,7 @@ ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
 	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
-	usleep_range(8, 10);
+	usleep_range(10, 13);
 
 	err = ipq8064_mdio_wait_busy(priv);
 	if (err)
@@ -91,7 +91,14 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
 	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
-	usleep_range(8, 10);
+
+	/* For the specific reg 31 extra time is needed or the next
+	 * read will produce garbage data.
+	 */
+	if (reg_offset == 31)
+		usleep_range(30, 43);
+	else
+		usleep_range(10, 13);
 
 	return ipq8064_mdio_wait_busy(priv);
 }
-- 
2.30.2

