Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301253F4143
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 21:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbhHVTdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 15:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbhHVTdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 15:33:40 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BDEC0613A4
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 12:32:58 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id n12so22735836edx.8
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 12:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Nzh1d+N/uwFrWUnjgU0gqJLXBqT+FtWJdnjcrat3aI=;
        b=gpGjl8BxzvHz9UV3JmbcUDXQIAv2TRnxsYTg01PLqGl2yVE2/kHSC3pDWe5sLGCuJH
         0vy33j7q/fygzO7L07lHikaP9rfsUdW9hhVtPhBStxS0TUeFe5ytmbFbEgCFDkLsZ1Hw
         XuRSoa1Zhme6SbTWde0YLNv2SwBa0rq23EFvI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Nzh1d+N/uwFrWUnjgU0gqJLXBqT+FtWJdnjcrat3aI=;
        b=ZZNGdqIRQ0AN8uVTNGwYv5yPsxeOqJH83SFLHidxuM6QyWBSZ8/No4AuccUyfMhWHZ
         AvF2S9lJxnhCYE22sjknK8ofqPviFUt09nkkoB+VBk5ttFasuECRuu5Vak7e8vGJPj5M
         qM8g+ibrnEWalIm21nuaMrnSfrmnrOfBOtWEwrVdfV6Cv4NhIuq3aUcHIeXk4/J6nIcp
         mlLwFvYtT+FxPNC1o54rdDYiAI2Qo6yX/wpcmjWOnW9BK8gRX0Egpx5A7+4muV9b3QN8
         jRIQzqJBUGb1W6XSSBYuandvf30jP/WSa4J7cZvBNpc8fk8JCD15/IrxeprnCYm40GFk
         W5IQ==
X-Gm-Message-State: AOAM5315SyXKtMvZgMBuad68txLPnsmdixkM8UTm+5fQSDm6RVKqIQaj
        IU+xLiFfPcnC5Vaf60R3EKvREA==
X-Google-Smtp-Source: ABdhPJxxTnZ46A2c3mivH/HQ4mtkhRWu6XqNbbL/KLMuoe3CcYrUP4qcFmpUgG2qFdxbuUsY7adFug==
X-Received: by 2002:a05:6402:2158:: with SMTP id bq24mr34070883edb.8.1629660776839;
        Sun, 22 Aug 2021 12:32:56 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id cn16sm7780053edb.9.2021.08.22.12.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 12:32:56 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     mir@bang-olufsen.dk, alvin@pqrs.dk,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 5/5] net: phy: realtek: add support for RTL8365MB-VC internal PHYs
Date:   Sun, 22 Aug 2021 21:31:43 +0200
Message-Id: <20210822193145.1312668-6-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210822193145.1312668-1-alvin@pqrs.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

The RTL8365MB-VC ethernet switch controller has 4 internal PHYs for its
user-facing ports. All that is needed is to let the PHY driver core
pick up the IRQ made available by the switch driver.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/phy/realtek.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 11be60333fa8..a5671ab896b3 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -1023,6 +1023,14 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+	}, {
+		PHY_ID_MATCH_EXACT(0x001cc942),
+		.name		= "RTL8365MB-VC Gigabit Ethernet",
+		/* Interrupt handling analogous to RTL8366RB */
+		.config_intr	= genphy_no_config_intr,
+		.handle_interrupt = genphy_handle_interrupt_no_ack,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
 	},
 };
 
-- 
2.32.0

