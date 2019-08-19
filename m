Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C0B94EA7
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbfHSUBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:01:18 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37596 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbfHSUBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:01:16 -0400
Received: by mail-qk1-f194.google.com with SMTP id s14so2523195qkm.4
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oO71kniPK+1M1cROp+mXvyqhfeytILNNMGY0s/SXb68=;
        b=oY5P/6CKiIXph1hjioToeuswDnBUjLmlB0wQkMtFyCpOyPrsmFEJfSXNPkNCSv1BSk
         yR0z1XQMB+2wpYcWz/32lHQruN1a7g52dapUr1pX6Ux+O6lf4IvGLK723ru76yzreUV4
         dWRbXcbe1TEgH2F3tA8+ZezYDv4eXRxa/g/KhHL29LzAqbE7AJZ+1aj/jFRCmOhCVzKm
         eVitZK/Dt8V1nN1DxjZ2tp8ZK4M/tSlNLVMQyCE796Xc8/Iycq3OvU0uKBJJGMHOL8W9
         VVcr79FjJH8sBO5u2AgiRRuIvnLakqhgycEPweEw9OielgceoqYbMuaqDriDeUbmdcUg
         t+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oO71kniPK+1M1cROp+mXvyqhfeytILNNMGY0s/SXb68=;
        b=klYdX1s13WkKukZmNAjgWvz4lCKT3PkKupY+ZzzoEauREUhG/FIX2G6N/qOxOIV54E
         O1Ckky0bPfxs6p6Qw5ANIGVJ/k1So8qn3I3Dp9XLeJIXcZ8KNS4zclbXbI34leO9nXmm
         wVeeRjc8wRQrIWbSdme8h5juB4BZnAE4DRfNf/oEvyyUKt7cK4kgnRMFjDcqmHRuUCa1
         hnWMNfAVYccYw24D0IwBeUYuOez+Q4HJpH3PhWVSuuebxnJi90Y1ywPKHt4yYnFGxCJs
         BOfLOQ7xiujqwgpX55yvcglwmbX0kyWLX8OgpnDdyD785nNYXDnkvYVknUUkILxYr3cW
         k/0A==
X-Gm-Message-State: APjAAAUK4UfowjW1Z2w02/mq+rJA6RVOpAfZOxLXmvpIgcYQyw+oX4Vi
        M29KAKQQdoPWAaAbFeWD0IuVdM/DxI8=
X-Google-Smtp-Source: APXvYqzhs6pXRjjTs20GMNZo8F/biJ00gJyH13OTP/CFiZD3MN5B0GWT4c/Q3cJNrhCiLO5sYJ94LA==
X-Received: by 2002:ae9:ed08:: with SMTP id c8mr22265245qkg.49.1566244875345;
        Mon, 19 Aug 2019 13:01:15 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id p201sm7421187qke.6.2019.08.19.13.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 13:01:14 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 6/6] net: dsa: mv88e6xxx: wrap SERDES IRQ in power function
Date:   Mon, 19 Aug 2019 16:00:53 -0400
Message-Id: <20190819200053.21637-7-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190819200053.21637-1-vivien.didelot@gmail.com>
References: <20190819200053.21637-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that mv88e6xxx_serdes_power is only called after driver setup,
we can wrap the SERDES IRQ code directly within it for clarity.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c72b3db75c54..d0bf98c10b2b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2057,10 +2057,26 @@ static int mv88e6xxx_setup_egress_floods(struct mv88e6xxx_chip *chip, int port)
 static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 				  bool on)
 {
-	if (chip->info->ops->serdes_power)
-		return chip->info->ops->serdes_power(chip, port, on);
+	int err;
 
-	return 0;
+	if (!chip->info->ops->serdes_power)
+		return 0;
+
+	if (on) {
+		err = chip->info->ops->serdes_power(chip, port, true);
+		if (err)
+			return err;
+
+		if (chip->info->ops->serdes_irq_setup)
+			err = chip->info->ops->serdes_irq_setup(chip, port);
+	} else {
+		if (chip->info->ops->serdes_irq_free)
+			chip->info->ops->serdes_irq_free(chip, port);
+
+		err = chip->info->ops->serdes_power(chip, port, false);
+	}
+
+	return err;
 }
 
 static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
@@ -2258,12 +2274,7 @@ static int mv88e6xxx_port_enable(struct dsa_switch *ds, int port,
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
-
 	err = mv88e6xxx_serdes_power(chip, port, true);
-
-	if (!err && chip->info->ops->serdes_irq_setup)
-		err = chip->info->ops->serdes_irq_setup(chip, port);
-
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -2274,13 +2285,8 @@ static void mv88e6xxx_port_disable(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 
 	mv88e6xxx_reg_lock(chip);
-
-	if (chip->info->ops->serdes_irq_free)
-		chip->info->ops->serdes_irq_free(chip, port);
-
 	if (mv88e6xxx_serdes_power(chip, port, false))
 		dev_err(chip->dev, "failed to power off SERDES\n");
-
 	mv88e6xxx_reg_unlock(chip);
 }
 
-- 
2.22.0

