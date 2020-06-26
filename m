Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15E320B55E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbgFZPyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730104AbgFZPxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:53:52 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAEAC08C5DC
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:51 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j4so7523567wrp.10
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I4rpaOEGU6H+oYaNchZTaDtgcXUEdwPMz6PwjmYhQuA=;
        b=t3JMremrEHYbvu8BWYRK5vIXUxE7NMD4JrgWG6ddzHCCR/Z3LNlDptd8V+Fbub+A+S
         iXVjVjSe/pCf5Xeu+SptMbyMDnb9ass5HOl+fM9eNteh3VAjIUJflJWSa6gtaR8B51yJ
         dk9PZM4BCwoA6Tf2ZcpyQ97nX8Kf2Ry9bd3EAzeKWoBA2NltjBpDe8IgTrYITmoMrdmq
         An9iV7f06x6Vyno0SIDq3B+tYCXZKlD+KAQThmj+Wzm1vxS37bfyTl9D9hsExxufvyic
         YiBV52DuK2i356Rh+1i2qSpF0vlDlSQwfFFk6T5JAfU58MWl3fSiwZ5x5chvkl25wNJG
         /7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I4rpaOEGU6H+oYaNchZTaDtgcXUEdwPMz6PwjmYhQuA=;
        b=fBV8V+jUaNUID2fcm2mVbNdwiRzUXAm5l4d2CR2AnEFyGY7QGKqGSS4VLp8aXWXwu+
         Z/pn7V/zQ0GhcDcV+bzMKVKAaXIizV/rotJj1PinGrN+zCJnTBkweXBEEtCorSHakq3J
         iyZiZwg1RY8l5Osvu59ENRTD83hhYgvhU/Q/b3CACtpu6PS+JqR6CAgLIE26VDakJ2PG
         6ePATpS7Jyph2+t2i9nA6+5E8Jott97eek/6ndadpr70RwbceymF83rLtly8+McOD5TA
         Tgag78YCtMK18dEu0FZQ42IlSnXgb0cTCtg4uVPA9DgFs0J3t97bil3aFboswODPJsq9
         9L1A==
X-Gm-Message-State: AOAM532bGgqEFox8EoaqAt8MKzD7MjyNrffl5OjM5/b2HZyDYLqyczBi
        ZpsXSQdxmZKxyHf2XN1CXtIqvQ==
X-Google-Smtp-Source: ABdhPJyqd5lvQd8IxdSMeRr2YLPH2b3Xm3m/mqtt1qy7XUpRz0ceuuRrZdLdo+dF7vLdHK3c//jh2Q==
X-Received: by 2002:a5d:4107:: with SMTP id l7mr4681479wrp.144.1593186830627;
        Fri, 26 Jun 2020 08:53:50 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id h142sm8242791wme.3.2020.06.26.08.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 08:53:50 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 6/6] net: phy: mdio: reset MDIO devices even if probe() is not implemented
Date:   Fri, 26 Jun 2020 17:53:25 +0200
Message-Id: <20200626155325.7021-7-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200626155325.7021-1-brgl@bgdev.pl>
References: <20200626155325.7021-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Similarily to PHY drivers - there's no reason to require probe() to be
implemented in order to call mdio_device_reset(). MDIO devices can have
resets defined without needing to do anything in probe().

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/mdio_device.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index f60443e48622..be615504b829 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -150,10 +150,10 @@ static int mdio_probe(struct device *dev)
 	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
 	int err = 0;
 
-	if (mdiodrv->probe) {
-		/* Deassert the reset signal */
-		mdio_device_reset(mdiodev, 0);
+	/* Deassert the reset signal */
+	mdio_device_reset(mdiodev, 0);
 
+	if (mdiodrv->probe) {
 		err = mdiodrv->probe(mdiodev);
 		if (err) {
 			/* Assert the reset signal */
@@ -170,12 +170,11 @@ static int mdio_remove(struct device *dev)
 	struct device_driver *drv = mdiodev->dev.driver;
 	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
 
-	if (mdiodrv->remove) {
+	if (mdiodrv->remove)
 		mdiodrv->remove(mdiodev);
 
-		/* Assert the reset signal */
-		mdio_device_reset(mdiodev, 1);
-	}
+	/* Assert the reset signal */
+	mdio_device_reset(mdiodev, 1);
 
 	return 0;
 }
-- 
2.26.1

