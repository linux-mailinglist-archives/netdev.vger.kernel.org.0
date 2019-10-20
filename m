Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8CADDC03
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfJTDUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:25 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42970 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfJTDUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:23 -0400
Received: by mail-qk1-f196.google.com with SMTP id f16so9059679qkl.9;
        Sat, 19 Oct 2019 20:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vSoUwQMmb28/9YfL/IRu91HWB5Xx5Cph7smwaeepDas=;
        b=RgbxzeyQIGrk+XZy3OCxoZIzCAtBCHUwV1CkM5hY0pOilLYCOU2va+1t/PrMl5ZrkI
         Snpo+mAHh6YAcv3bAA571byXGP4TMMdMHIeHDt3l7phPtGWGN7ULwPSuuKOo/aeX1BJL
         nN5lfxSMnYSyxd5xXKtCTteaqvuP2upmrRX328i47HT24HLFqgAmuFMNbFWorBO0zT7r
         God5N9Y25brAX2cUlHRFsOpAW39Q7ldLVh6wzjxCpHtSb75TKQW+ZkjBHFihDZLEVX6T
         ivAley2EecOH/k6iCaIr7CNLzl4hSUG1SomZvP3QL8BqmyZx/D9QVJFCZ+AXD8kHQSCd
         djQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vSoUwQMmb28/9YfL/IRu91HWB5Xx5Cph7smwaeepDas=;
        b=qh2RNOo+wHAb7VhMZ9bnlclFFTKlWxj0beeqfKWq0g1iAwBPm4Y+unjyTLxe53Vuq7
         0zNFXIyLYGxGzLMT8SI3qlS5bEwn21jMx4lSrhfsZz9YZDqFk3XrMRL1dm2p6hVzNNxH
         AGwAOt9jDx2ihoeHBgipIDhA1G3xCU23hvHNQG3zAbX1sDu5sOCDZNFdt72QwJXjYU+b
         kWIossrVi4/O+gdEXCoPdLNGYdiM8K6ci1CHWhzHYH8zbkvaI372BoGmfi8jJiCCHmlv
         b6/WSWPVevI62mJoWb0hHkgx0EweZqup/Ph1kc0LAGfpGNQ76j7yTxCPRWYabNVz5SNV
         46wg==
X-Gm-Message-State: APjAAAWK0ghIU51tteBruoQoFPedJtVNLwwrrGXzRTScNRiPUHus44eI
        tdjOIRn66a+/wS8iPsDAhio=
X-Google-Smtp-Source: APXvYqzSpyMXGLkTNYIn81f2orGJH9VzyoEpV3t6cSzdECKD/bvv+259OnHCHmaphXKt2EulM57zxA==
X-Received: by 2002:a37:ef04:: with SMTP id j4mr16439936qkk.75.1571541622484;
        Sat, 19 Oct 2019 20:20:22 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y188sm3516599qke.31.2019.10.19.20.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:21 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 11/16] net: dsa: mv88e6xxx: silently skip PVT ops
Date:   Sat, 19 Oct 2019 23:19:36 -0400
Message-Id: <20191020031941.3805884-12-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since mv88e6xxx_pvt_map is a static helper, no need to return
-EOPNOTSUPP if the chip has no PVT, simply silently skip the operation.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
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

