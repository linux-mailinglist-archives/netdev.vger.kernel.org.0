Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C645FF6BFD
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 01:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfKKAma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 19:42:30 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37783 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbfKKAma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 19:42:30 -0500
Received: by mail-pl1-f196.google.com with SMTP id g8so2867132plt.4
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 16:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=3MUQrv52TDHwJI3WWySmoks9iAuFFLfSTiDPcJnHPn0=;
        b=BNJyTMuIiu7bkk4Gdu9Vp1CKAa2THv9QSYi4w06lKhwGvC9MLb0jb1my6nrOyleSwL
         1fw3DtGHxfi4d8mJelG8yQy4kiWmLkBX1d6SmtYlmdj4IZRKbSp0SdAo4z78JND0kg7T
         fZLiz8E9k9pdtw7L7KDGo0r9SamIzBdjevXmeP/Z1f/MRryOZ4TlB6hmr4QRPszMRGEh
         48AwJxRwm7OmoS+EXF2v5F5qOydLL0ZH3R/Jcj81+y4HzOwsTvChR0CIM71fThjuA7Xp
         RZE1Yvr+iUDeuvn6AVen+Bk+pjwTmo4lH3oRAwQFJ8MJAOSghs2Zuaidp+ps6ruiaIil
         idXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3MUQrv52TDHwJI3WWySmoks9iAuFFLfSTiDPcJnHPn0=;
        b=DdPm2olAwhx16wetkEnIxVbFiHqKCVWFiFGnAplmIv53CZ32nTB9D8P7Crs6vT63K1
         Xan7cdIh/1mtufqSAr+YjW/eJr4AMRhjzjz2AKFzLlWc5AavN2Mop1krWyloizvfRBml
         uCoLeNGCIylUF5RO9M+pAJEc0kI9nTd2TJcQo+A/oX9ctBQe5AJjjAyz99sIFGyrMkyf
         TTCrFlDo49kuEi8JKtoRZXk8tI2h/nyISg7xo0io4ttUytV+ZILmowQyWc6bYi6F2UMb
         x2+6DG0Cygg5g74fqc4LqtA+j6VEIzI6Uz4T7LdWqzpMRC00dB9Px6+R4kd3JD8Ymn8r
         ljMA==
X-Gm-Message-State: APjAAAVL1GAThNDLHEGG0U/nwFhL4nMKQPUA9YqfCOMMiaZP8/xWIUyD
        voWJbg79RPBhIGKEH51AfYeuiQ==
X-Google-Smtp-Source: APXvYqyT7MQhZB8LfN4EFcd7B/ijKS5GyMgGJ7iKgxWmshjq8k/VJJA9BkAmTCAQhj8rg/anY8MuGw==
X-Received: by 2002:a17:902:a987:: with SMTP id bh7mr22392010plb.181.1573432947678;
        Sun, 10 Nov 2019 16:42:27 -0800 (PST)
Received: from rip.lixom.net (99-152-116-91.lightspeed.sntcca.sbcglobal.net. [99.152.116.91])
        by smtp.gmail.com with ESMTPSA id q8sm10557061pjp.10.2019.11.10.16.42.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Nov 2019 16:42:26 -0800 (PST)
From:   Olof Johansson <olof@lixom.net>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] net: mdio-octeon: Fix pointer/integer casts
Date:   Sun, 10 Nov 2019 16:42:11 -0800
Message-Id: <20191111004211.96425-1-olof@lixom.net>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes a bunch of these warnings on arm allmodconfig:

In file included from /build/drivers/net/phy/mdio-cavium.c:11:
/build/drivers/net/phy/mdio-cavium.c: In function 'cavium_mdiobus_set_mode':
/build/drivers/net/phy/mdio-cavium.h:114:37: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  114 | #define oct_mdio_readq(addr)  readq((void *)addr)
      |                                     ^
/build/drivers/net/phy/mdio-cavium.c:21:16: note: in expansion of macro 'oct_mdio_readq'
   21 |  smi_clk.u64 = oct_mdio_readq(p->register_base + SMI_CLK);
      |                ^~~~~~~~~~~~~~

Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/net/phy/mdio-cavium.h  | 14 +++++++-------
 drivers/net/phy/mdio-octeon.c  |  5 ++---
 drivers/net/phy/mdio-thunder.c |  2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/phy/mdio-cavium.h
index b7f89ad27465f..1cf81f0bc585f 100644
--- a/drivers/net/phy/mdio-cavium.h
+++ b/drivers/net/phy/mdio-cavium.h
@@ -90,7 +90,7 @@ union cvmx_smix_wr_dat {
 
 struct cavium_mdiobus {
 	struct mii_bus *mii_bus;
-	u64 register_base;
+	void __iomem *register_base;
 	enum cavium_mdiobus_mode mode;
 };
 
@@ -98,20 +98,20 @@ struct cavium_mdiobus {
 
 #include <asm/octeon/octeon.h>
 
-static inline void oct_mdio_writeq(u64 val, u64 addr)
+static inline void oct_mdio_writeq(u64 val, void __iomem *addr)
 {
-	cvmx_write_csr(addr, val);
+	cvmx_write_csr((u64)addr, val);
 }
 
-static inline u64 oct_mdio_readq(u64 addr)
+static inline u64 oct_mdio_readq(void __iomem *addr)
 {
-	return cvmx_read_csr(addr);
+	return cvmx_read_csr((u64)addr);
 }
 #else
 #include <linux/io-64-nonatomic-lo-hi.h>
 
-#define oct_mdio_writeq(val, addr)	writeq(val, (void *)addr)
-#define oct_mdio_readq(addr)		readq((void *)addr)
+#define oct_mdio_writeq(val, addr)	writeq(val, addr)
+#define oct_mdio_readq(addr)		readq(addr)
 #endif
 
 int cavium_mdiobus_read(struct mii_bus *bus, int phy_id, int regnum);
diff --git a/drivers/net/phy/mdio-octeon.c b/drivers/net/phy/mdio-octeon.c
index 8327382aa5689..c58ab8acd485a 100644
--- a/drivers/net/phy/mdio-octeon.c
+++ b/drivers/net/phy/mdio-octeon.c
@@ -44,8 +44,7 @@ static int octeon_mdiobus_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	bus->register_base =
-		(u64)devm_ioremap(&pdev->dev, mdio_phys, regsize);
+	bus->register_base = devm_ioremap(&pdev->dev, mdio_phys, regsize);
 	if (!bus->register_base) {
 		dev_err(&pdev->dev, "dev_ioremap failed\n");
 		return -ENOMEM;
@@ -56,7 +55,7 @@ static int octeon_mdiobus_probe(struct platform_device *pdev)
 	oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
 
 	bus->mii_bus->name = KBUILD_MODNAME;
-	snprintf(bus->mii_bus->id, MII_BUS_ID_SIZE, "%llx", bus->register_base);
+	snprintf(bus->mii_bus->id, MII_BUS_ID_SIZE, "%p", bus->register_base);
 	bus->mii_bus->parent = &pdev->dev;
 
 	bus->mii_bus->read = cavium_mdiobus_read;
diff --git a/drivers/net/phy/mdio-thunder.c b/drivers/net/phy/mdio-thunder.c
index b6128ae7f14f3..280cf84d4116e 100644
--- a/drivers/net/phy/mdio-thunder.c
+++ b/drivers/net/phy/mdio-thunder.c
@@ -84,7 +84,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		nexus->buses[i] = bus;
 		i++;
 
-		bus->register_base = (u64)nexus->bar0 +
+		bus->register_base = nexus->bar0 +
 			r.start - pci_resource_start(pdev, 0);
 
 		smi_en.u64 = 0;
-- 
2.11.0

