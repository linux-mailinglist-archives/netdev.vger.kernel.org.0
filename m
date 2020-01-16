Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D8113EB25
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394340AbgAPRsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:48:24 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40111 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406712AbgAPRqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:46:35 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so20061054wrn.7
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 09:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eB/8hF1mcidWGK3IZWFhtB9tu1T2tIpz6JRb42DwAEE=;
        b=lNqkrBiWP74qfEpWfCkMauOKfd5gjZB5x7wmjz0OPZ9u3Vfu2gshcrTzZhNONGwrb/
         W3/5rv/ytufSlqce0UjO3bUC8fqnroMFKl5MbAl6oyzWm4otmd7noHz5PVq5s7mKK7md
         YCAvCVmmA04OBHY7Xc0ehUxEEfFZ9Xq/knAYQbu3cH1AraBs6FwW362DWDhCNL8q7bcF
         NvUmQqvMsqjQMyWnV6IfAunL+0TMB3Qfd75YGEArWdEPES8Ff/1xu6J4/j2IegUDuuml
         mmQrO9863hCOsqCXo+HVw3hQrNvc7B7BEsOjrGD9zQDz6k+8biLjvVNnMgYhoRFlpQpR
         ZJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eB/8hF1mcidWGK3IZWFhtB9tu1T2tIpz6JRb42DwAEE=;
        b=bewFbunrtcdEiezF1V3DVTwaaOEFUiXOptiMYr5qLAMKw2cP4IvuS5OChRUItVf9Pr
         xAIalCNDI5Wf+5ubfWIcKAaQ3WHZOePdBf6JTK9FkJYCxDGds8Rv5R7wsEFoD75uonma
         myuy9tTsY8q29MmkZg+ihcOppBjROIJtU7DYfsfQbvge+pApLjJ9AnWKuoO78zk28uYP
         hmoeMmEyXP+xijX6kWFU9DEhDcRbCIsgoPysaDSmrmwYRKN8K0Qx343KHGWkBmZq+H9q
         4gLP65bIUO33t+YsYNTMDX7FVk+hdd08XI2KCJW2+FWbW0gjB0/rZ33JmLzkzsdz9p/J
         TMwA==
X-Gm-Message-State: APjAAAV7BILNIUR5o2BfKBe57Z71ctZsob24f3rnvcZiEtgBLzneK83z
        nsAfF3WJAmeIqt8qWAkmv38=
X-Google-Smtp-Source: APXvYqwnadLkhPBwnjsbhi0/pC6+FxdyVHZ0BM7BT6WhRW/lrOpKijSW6MM2MFApwMfHggwxyWnJ7g==
X-Received: by 2002:adf:d846:: with SMTP id k6mr4302617wrl.337.1579196793535;
        Thu, 16 Jan 2020 09:46:33 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id x18sm30458338wrr.75.2020.01.16.09.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 09:46:33 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org,
        Alex Marginean <alexandru.marginean@nxp.com>
Subject: [PATCH net-next] net: phy: don't crash in phy_read/_write_mmd without a PHY driver
Date:   Thu, 16 Jan 2020 19:46:28 +0200
Message-Id: <20200116174628.16821-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

The APIs can be used by Ethernet drivers without actually loading a PHY
driver. This may become more widespread in the future with 802.3z
compatible MAC PCS devices being locally driven by the MAC driver when
configuring for a PHY mode with in-band negotiation.

Check that drv is not NULL before reading from it.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
---
If this hasn't been reported by now I assume it wasn't an issue so far.
So I've targeted the patch for net-next and not provided a Fixes: tag.

 drivers/net/phy/phy-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 769a076514b0..a4d2d59fceca 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -387,7 +387,7 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
 	if (regnum > (u16)~0 || devad > 32)
 		return -EINVAL;
 
-	if (phydev->drv->read_mmd) {
+	if (phydev->drv && phydev->drv->read_mmd) {
 		val = phydev->drv->read_mmd(phydev, devad, regnum);
 	} else if (phydev->is_c45) {
 		u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
@@ -444,7 +444,7 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
 	if (regnum > (u16)~0 || devad > 32)
 		return -EINVAL;
 
-	if (phydev->drv->write_mmd) {
+	if (phydev->drv && phydev->drv->write_mmd) {
 		ret = phydev->drv->write_mmd(phydev, devad, regnum, val);
 	} else if (phydev->is_c45) {
 		u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
-- 
2.17.1

