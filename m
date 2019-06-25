Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5BE55C90
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfFYXp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:45:56 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:38331 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYXpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:45:55 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45YN8K1gPKz1rMql;
        Wed, 26 Jun 2019 01:45:53 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45YN8K1SbJz20V2K;
        Wed, 26 Jun 2019 01:45:53 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id zMbUW3EnbCwz; Wed, 26 Jun 2019 01:45:52 +0200 (CEST)
X-Auth-Info: yK+J/bilyF4MKXd7HEea1uBvwXc1lHtJKiWSUPWYFbY=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 26 Jun 2019 01:45:51 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH V4 02/10] net: dsa: microchip: Remove ksz_{get,set}()
Date:   Wed, 26 Jun 2019 01:43:40 +0200
Message-Id: <20190625234348.16246-3-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625234348.16246-1-marex@denx.de>
References: <20190625234348.16246-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions and callbacks are never used, remove them.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
V2: No change
V3: - Rebase on next/master
    - Test on KSZ9477EVB
V4: Add RB
---
 drivers/net/dsa/microchip/ksz9477_spi.c |  2 --
 drivers/net/dsa/microchip/ksz_common.h  | 24 ------------------------
 drivers/net/dsa/microchip/ksz_priv.h    |  2 --
 drivers/net/dsa/microchip/ksz_spi.h     | 10 ----------
 4 files changed, 38 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index e7118319c192..86d12d48a2a9 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -80,8 +80,6 @@ static const struct ksz_io_ops ksz9477_spi_ops = {
 	.write8 = ksz_spi_write8,
 	.write16 = ksz_spi_write16,
 	.write32 = ksz_spi_write32,
-	.get = ksz_spi_get,
-	.set = ksz_spi_set,
 };
 
 static int ksz9477_spi_probe(struct spi_device *spi)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 1781539c3a81..c15b49528bad 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -105,30 +105,6 @@ static inline int ksz_write32(struct ksz_device *dev, u32 reg, u32 value)
 	return ret;
 }
 
-static inline int ksz_get(struct ksz_device *dev, u32 reg, void *data,
-			  size_t len)
-{
-	int ret;
-
-	mutex_lock(&dev->reg_mutex);
-	ret = dev->ops->get(dev, reg, data, len);
-	mutex_unlock(&dev->reg_mutex);
-
-	return ret;
-}
-
-static inline int ksz_set(struct ksz_device *dev, u32 reg, void *data,
-			  size_t len)
-{
-	int ret;
-
-	mutex_lock(&dev->reg_mutex);
-	ret = dev->ops->set(dev, reg, data, len);
-	mutex_unlock(&dev->reg_mutex);
-
-	return ret;
-}
-
 static inline void ksz_pread8(struct ksz_device *dev, int port, int offset,
 			      u8 *data)
 {
diff --git a/drivers/net/dsa/microchip/ksz_priv.h b/drivers/net/dsa/microchip/ksz_priv.h
index 5ef6153bd2cc..d3ddf98156bb 100644
--- a/drivers/net/dsa/microchip/ksz_priv.h
+++ b/drivers/net/dsa/microchip/ksz_priv.h
@@ -109,8 +109,6 @@ struct ksz_io_ops {
 	int (*write8)(struct ksz_device *dev, u32 reg, u8 value);
 	int (*write16)(struct ksz_device *dev, u32 reg, u16 value);
 	int (*write32)(struct ksz_device *dev, u32 reg, u32 value);
-	int (*get)(struct ksz_device *dev, u32 reg, void *data, size_t len);
-	int (*set)(struct ksz_device *dev, u32 reg, void *data, size_t len);
 };
 
 struct alu_struct {
diff --git a/drivers/net/dsa/microchip/ksz_spi.h b/drivers/net/dsa/microchip/ksz_spi.h
index 427811bd60b3..976bace31f37 100644
--- a/drivers/net/dsa/microchip/ksz_spi.h
+++ b/drivers/net/dsa/microchip/ksz_spi.h
@@ -56,14 +56,4 @@ static int ksz_spi_write32(struct ksz_device *dev, u32 reg, u32 value)
 	return ksz_spi_write(dev, reg, &value, 4);
 }
 
-static int ksz_spi_get(struct ksz_device *dev, u32 reg, void *data, size_t len)
-{
-	return ksz_spi_read(dev, reg, data, len);
-}
-
-static int ksz_spi_set(struct ksz_device *dev, u32 reg, void *data, size_t len)
-{
-	return ksz_spi_write(dev, reg, data, len);
-}
-
 #endif
-- 
2.20.1

