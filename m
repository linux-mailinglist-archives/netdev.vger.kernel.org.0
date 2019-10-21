Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E17FDF712
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbfJUUv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:51:56 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35224 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730494AbfJUUvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:54 -0400
Received: by mail-qt1-f194.google.com with SMTP id m15so23396432qtq.2;
        Mon, 21 Oct 2019 13:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oSeB99tFWrSsr858sLtErorntCjYJIilkerqAgdpByo=;
        b=KOdh9YDGlIxLKlwrwjHEzIwis/8g92PV/BE52JCKYFqEkK+Y48TP35JaJp7juAZrvZ
         kba4xzHaPYFpup9+5XQ8DYxyhiiEd+oboNPna18+B2ol3LXvHUeeg8S4zA7Y+PTHTLOw
         7yD5z3ItiaxoTzxYoS96BL9/HfMIJIR7DAzxgG6+Nlgm53rEQ1sDSJRT20oWJnQ4WI9Q
         xs6qdTGugM3TtqbOy6W417fc2mRG5S7NOecOtOPjsDkapsM0JgE+39OlbIZ2jphAJ647
         em1Z1FsMnMjxENW3K3Gcuny+ohotTwFjFtYBKb2JoF6R/oQ5pJ34Hy8c78lZ+T+VzLYj
         MZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oSeB99tFWrSsr858sLtErorntCjYJIilkerqAgdpByo=;
        b=LYLfYRPzK4sGPL8RnKiPVTI2lldEecfOA9wiCTKq1z2pWLWu02UmOUQRzEqAZ4Ezke
         cmiLcgElqng6IuVQbbQNLxHYch6jqC0nP/Ep0M5vHxJ3ko7maKaDhZxJnujWpaAZ2wGg
         cs2zk3X+nkZw/VEue2SHGEkulP6lCp/JhjpwqVAr+CdNsXgRy4wMQIPxs1D1E9C7/j2Z
         sqoPtO8V9Tb4tYLGEDRA1kS32KdlKtYUC1mKuYu1PdKvPCteCL0eI4aFi8p50AHM5IFQ
         QUEsFMyjbpbH5lvfaobAq2sA3Em6+AUc2idd2+e4LEeOFEuFDPH+h/ZL5326XKvEENXo
         hjkw==
X-Gm-Message-State: APjAAAXZucVPHXdCbqsfdOD4jWKfbVY761OCPsYAdw/FRmmahd0VEjHH
        k/VNIA76csmfVaQs+zGiYEn8Jrf0
X-Google-Smtp-Source: APXvYqwZiEckxAYx6BtHCcUSkfV2xWUc7O64jrz4E/bde9ZPekJpT8bgi/75ebalkVMuAm2ydLtasQ==
X-Received: by 2002:ac8:23e8:: with SMTP id r37mr27024688qtr.365.1571691113112;
        Mon, 21 Oct 2019 13:51:53 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id h3sm430795qte.62.2019.10.21.13.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:52 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 11/16] net: dsa: mv88e6xxx: silently skip PVT ops
Date:   Mon, 21 Oct 2019 16:51:25 -0400
Message-Id: <20191021205130.304149-12-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since mv88e6xxx_pvt_map is a static helper, no need to return
-EOPNOTSUPP if the chip has no PVT, simply silently skip the operation.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d67deec77452..510ccdc2d03c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1253,7 +1253,7 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 	u16 pvlan = 0;
 
 	if (!mv88e6xxx_has_pvt(chip))
-		return -EOPNOTSUPP;
+		return 0;
 
 	/* Skip the local source device, which uses in-chip port VLAN */
 	if (dev != chip->ds->index)
@@ -2049,9 +2049,6 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 		}
 	}
 
-	if (!mv88e6xxx_has_pvt(chip))
-		return 0;
-
 	/* Remap the Port VLAN of each cross-chip bridge group member */
 	for (dev = 0; dev < DSA_MAX_SWITCHES; ++dev) {
 		ds = chip->ds->dst->ds[dev];
@@ -2101,9 +2098,6 @@ static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds, int dev,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (!mv88e6xxx_has_pvt(chip))
-		return 0;
-
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_pvt_map(chip, dev, port);
 	mv88e6xxx_reg_unlock(chip);
@@ -2116,9 +2110,6 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds, int dev,
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
-	if (!mv88e6xxx_has_pvt(chip))
-		return;
-
 	mv88e6xxx_reg_lock(chip);
 	if (mv88e6xxx_pvt_map(chip, dev, port))
 		dev_err(ds->dev, "failed to remap cross-chip Port VLAN\n");
-- 
2.23.0

