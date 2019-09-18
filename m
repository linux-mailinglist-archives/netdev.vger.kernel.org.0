Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D8FB6823
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 18:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387606AbfIRQ2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 12:28:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46753 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbfIRQ2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 12:28:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so43845wrv.13;
        Wed, 18 Sep 2019 09:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+0ntiwXvSESB7iaOoEKUuKoBv5qu2y9dPZxgAsEks4E=;
        b=j6O8OoORqIJ+c0lJiu2c0OGPlmDy8cgQxd+S7wBYq/FYyzcR6HqvTzfPGNAAmF0LzZ
         xJQlouhwYeHYD04CjRw/xergiWhEqN5sCG7UsEMr2/voKxYCmw9lyK7z4lytRKhbR4DV
         PemaPb9jBUkuK4/mtg/oB/F8Bqc2mX43MHnLsSzRbkUDeokIVGpgSVIMyx8hdU9MX7P1
         lCRUjZmozXQZ0SLXlHSJRoGFind96cnphL2WyyFIxEunuaT/SgtjBOGcNF7mjgW8pFoQ
         bU4X0T03b9hTDi9z9se2KZ6m67rxguHeNSm4o92Far5TP/mKg3VDC4SB5JA70aJlfl10
         6pmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+0ntiwXvSESB7iaOoEKUuKoBv5qu2y9dPZxgAsEks4E=;
        b=kBDbE+rT9GL15soSBwcIMcnZS7Ro7ZrDpO98Q7oK/w7uPDcGoAdmE8jz39tXVSG7aA
         3Q+d7o00lZKAav3mqwHDN21ZIQIFXSAqX2hCYUQpojRrbkMkvFp8gMHIAU8KI+YQoHoZ
         nNlIft2xJlfBZm6OV9Z4JjYcmqMFGEkcZ93mBGJd3ICOy1GComrwy5FAcbVpDdAJj+FW
         7phNtyibiA0wLD8sqoEjyteRsLtvwUtiBg1UK+hvky890g7vAusTio9T3g5Bv8yMeckI
         nW2SOGr2y9wldJvp13T3F2376If8+KbbtB26eQZqAgtKirE0yFOp5N3pKhXe4C3eId+j
         E1gA==
X-Gm-Message-State: APjAAAXn6WRFuzFyG5mExgzFWupJFgwSW6uvC74c6p8yefzdmd0FCjaM
        7R2nhwP9+iQZtiLOAd8Pw2A=
X-Google-Smtp-Source: APXvYqxbwdaVzV2zUxqpvvbAC/gTxl28+HYZmjcG5MkZXAtHbqI8L3SfMIAUypBWLrwxDsvMzfKAoQ==
X-Received: by 2002:a5d:49c3:: with SMTP id t3mr3940934wrs.151.1568824132964;
        Wed, 18 Sep 2019 09:28:52 -0700 (PDT)
Received: from bfk-3-vm8-e4.cs.niisi.ras.ru (t109.niisi.ras.ru. [193.232.173.109])
        by smtp.gmail.com with ESMTPSA id q19sm11468214wra.89.2019.09.18.09.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 09:28:52 -0700 (PDT)
From:   Peter Mamonov <pmamonov@gmail.com>
To:     andrew@lunn.ch
Cc:     Peter Mamonov <pmamonov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v3] net/phy: fix DP83865 10 Mbps HDX loopback disable function
Date:   Wed, 18 Sep 2019 19:27:55 +0300
Message-Id: <20190918162755.24024-1-pmamonov@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the DP83865 datasheet "the 10 Mbps HDX loopback can be
disabled in the expanded memory register 0x1C0.1". The driver erroneously
used bit 0 instead of bit 1.

Fixes: 4621bf129856 ("phy: Add file missed in previous commit.")
Signed-off-by: Peter Mamonov <pmamonov@gmail.com>
---
Changes since v2:
- None

Changes since v1:
- use BIT() macro
- fix debug message as well

 drivers/net/phy/national.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/national.c b/drivers/net/phy/national.c
index a221dd552c3c..a5bf0874c7d8 100644
--- a/drivers/net/phy/national.c
+++ b/drivers/net/phy/national.c
@@ -105,14 +105,17 @@ static void ns_giga_speed_fallback(struct phy_device *phydev, int mode)
 
 static void ns_10_base_t_hdx_loopack(struct phy_device *phydev, int disable)
 {
+	u16 lb_dis = BIT(1);
+
 	if (disable)
-		ns_exp_write(phydev, 0x1c0, ns_exp_read(phydev, 0x1c0) | 1);
+		ns_exp_write(phydev, 0x1c0,
+			     ns_exp_read(phydev, 0x1c0) | lb_dis);
 	else
 		ns_exp_write(phydev, 0x1c0,
-			     ns_exp_read(phydev, 0x1c0) & 0xfffe);
+			     ns_exp_read(phydev, 0x1c0) & ~lb_dis);
 
 	pr_debug("10BASE-T HDX loopback %s\n",
-		 (ns_exp_read(phydev, 0x1c0) & 0x0001) ? "off" : "on");
+		 (ns_exp_read(phydev, 0x1c0) & lb_dis) ? "off" : "on");
 }
 
 static int ns_config_init(struct phy_device *phydev)
-- 
2.23.0

