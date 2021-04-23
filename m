Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B76E368A94
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbhDWBsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbhDWBsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:33 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5EFC061574;
        Thu, 22 Apr 2021 18:47:57 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id r20so21855159ejo.11;
        Thu, 22 Apr 2021 18:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q9gaocBlk1TPMqWqSo24Pc1wb4Ov1hZl7cSxG+HTprk=;
        b=Dj+5ckk2rTGumx9FfCWvmxxcDx06KjZjwBK6VYRhtTnCAoh/a9B6l0QFPEPPn6W3ub
         mtqBtwQliJ17nn4bppWH9j+uJsxY3SxWJm8gY8C1wRBnpoR3bFJr6COtgCLgBDtirELG
         8U6HZ5CSXvt4YJVhH89sJbXKsbSdZm3gg7UQqmtuiK37We6oK385EJJnNJtq8zfJcU5b
         9Uk9hGLeDcM6epx9chmdlhklIFBh3pVcr3Q2L1y3DeRWa+vosSaz86hGvPoGNkgpcpfh
         /30g4sLFaqkmp9STm9UOa3UgLVm54nhboXhL5dCdtbESVM0XczRSL7CO0rGpQoAbspbE
         tcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q9gaocBlk1TPMqWqSo24Pc1wb4Ov1hZl7cSxG+HTprk=;
        b=RSUKKu6TQ7Z+RwcOGM3HxC/QydpHP/81TkntmMhA09uTJp/eRcTMfHYtzVbUS1Ch7A
         H6pAnJfJo5l8tyFYi1zR34UkXH6nFTGbibMHfwn4EvZXj4xj66bMfJZT3TJBFBsbB3gH
         H99YuGGTubS2ufEJtSQ6buKFg4fzV+RbeIFz3dS+pf+nxUJZBxFHDek/dh/vjofZNqrO
         gZEGiu9MmD7h36h/n9NzGHcFkwNvI9+N06UqnG6Jyh5T6FsBY9tDzam5klqKR2bmMufk
         wqbPHnPt4u6s/7aPzBhBqd7vO0NwmEplC8awPBmIuNfdMkDRRXquJtCLfyKiLTSDisyw
         U5gg==
X-Gm-Message-State: AOAM532ciCRK4H0DFQGk6Ay4tK9cH8JZn8oJTVkfUauri8sF8DCdOjRQ
        CM3I4MwImtlpCJ9B644XXww=
X-Google-Smtp-Source: ABdhPJwtwQQgziVfHwY7UWl0SRDKT0e8BrDzig5Jv05DklRZ2tfQdUYLG2GGAhyp2Kyow6HtXYrikw==
X-Received: by 2002:a17:906:b2d8:: with SMTP id cf24mr1561407ejb.305.1619142476265;
        Thu, 22 Apr 2021 18:47:56 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:47:55 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] drivers: net: mdio: mdio-ip8064: improve busy wait delay
Date:   Fri, 23 Apr 2021 03:47:29 +0200
Message-Id: <20210423014741.11858-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the use of the qca8k dsa driver, some problem arised related to
port status detection. With a load on a specific port (for example a
simple speed test), the driver starts to bheave in a strange way and
garbage data is produced. To address this, enlarge the sleep delay and
address a bug for the reg offset 31 that require additional delay for
this specific reg.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/mdio/mdio-ipq8064.c | 36 ++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index 1bd18857e1c5..5bd6d0501642 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -15,25 +15,26 @@
 #include <linux/mfd/syscon.h>
 
 /* MII address register definitions */
-#define MII_ADDR_REG_ADDR                       0x10
-#define MII_BUSY                                BIT(0)
-#define MII_WRITE                               BIT(1)
-#define MII_CLKRANGE_60_100M                    (0 << 2)
-#define MII_CLKRANGE_100_150M                   (1 << 2)
-#define MII_CLKRANGE_20_35M                     (2 << 2)
-#define MII_CLKRANGE_35_60M                     (3 << 2)
-#define MII_CLKRANGE_150_250M                   (4 << 2)
-#define MII_CLKRANGE_250_300M                   (5 << 2)
+#define MII_ADDR_REG_ADDR			0x10
+#define MII_BUSY				BIT(0)
+#define MII_WRITE				BIT(1)
+#define MII_CLKRANGE(x)				((x) << 2)
+#define MII_CLKRANGE_60_100M			MII_CLKRANGE(0)
+#define MII_CLKRANGE_100_150M			MII_CLKRANGE(1)
+#define MII_CLKRANGE_20_35M			MII_CLKRANGE(2)
+#define MII_CLKRANGE_35_60M			MII_CLKRANGE(3)
+#define MII_CLKRANGE_150_250M			MII_CLKRANGE(4)
+#define MII_CLKRANGE_250_300M			MII_CLKRANGE(5)
 #define MII_CLKRANGE_MASK			GENMASK(4, 2)
 #define MII_REG_SHIFT				6
 #define MII_REG_MASK				GENMASK(10, 6)
 #define MII_ADDR_SHIFT				11
 #define MII_ADDR_MASK				GENMASK(15, 11)
 
-#define MII_DATA_REG_ADDR                       0x14
+#define MII_DATA_REG_ADDR			0x14
 
-#define MII_MDIO_DELAY_USEC                     (1000)
-#define MII_MDIO_RETRY_MSEC                     (10)
+#define MII_MDIO_DELAY_USEC			(1000)
+#define MII_MDIO_RETRY_MSEC			(10)
 
 struct ipq8064_mdio {
 	struct regmap *base; /* NSS_GMAC0_BASE */
@@ -65,7 +66,7 @@ ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
 	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
-	usleep_range(8, 10);
+	usleep_range(10, 13);
 
 	err = ipq8064_mdio_wait_busy(priv);
 	if (err)
@@ -91,7 +92,14 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
 	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
-	usleep_range(8, 10);
+
+	/* For the specific reg 31 extra time is needed or the next
+	 * read will produce grabage data.
+	 */
+	if (reg_offset == 31)
+		usleep_range(30, 43);
+	else
+		usleep_range(10, 13);
 
 	return ipq8064_mdio_wait_busy(priv);
 }
-- 
2.30.2

