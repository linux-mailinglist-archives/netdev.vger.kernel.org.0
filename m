Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED7729E88C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgJ2KJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgJ2KJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:09:00 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576BCC0613CF;
        Thu, 29 Oct 2020 03:09:00 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dk16so2407634ejb.12;
        Thu, 29 Oct 2020 03:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wlhDHzJZLAVQj/JzvRRuXKVcRd2zxkv7u62zoDXNvh8=;
        b=LKEkFDk14+jQHEmu/uqOU6PS/eZnVJal8NUAHwV6aKWwslMh7Y6wE4TMY/1DrR0pmP
         Myj+8w5Ba4nmkAAJlUHphTiIgcZ11/wPNDs9n9L1pIXE4wDH6Hd9UGYVfUIi7ha2ahls
         M9n6r0M1n4BTGGLrCgg8sceaKRqGsovgtFVQfiN0lR74d4CjEp6udg0jkp4POJjxFt3j
         /MxYD/YapqeNpzUUUWKRja9afKY1tmrERYoaTkczL28chd+VDvbQ75Z9xNeYzN0tapwZ
         CYUyc4E6sbamKOS1d+Nli+ZNxfbWnHCMi4N9lL+f9gUHyfmUMTnVgYur/jU5YQcB5xbr
         8kjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wlhDHzJZLAVQj/JzvRRuXKVcRd2zxkv7u62zoDXNvh8=;
        b=GyAI06UPHu35BgvZU35pc563lxQFyOtba9QJchnp54T77nW9L0TawroW6E3pap6x/b
         ObAPZZybkSeDMEFRN9LIUwfwbSZWcOxX8ZtOmTQqtmUrw+l4vPPNLtS/+V3FUpiIfgzu
         lIbMWfvc0ZEdGZHpeXZKt64I+l39DTYiw1uCavIpA6qNynh7sUJblt+lIgXth4dSKVk2
         zbFHpZFyHxdc6y2G4oG80v7L44iSHDygD9vJY1iNIBozRI/cjQS35tYQLCTY3hOypMUj
         2Nkh5rTFG51qOzO7Gcqqtdu6Qqq45hzgfzOJX6tg9scemsOfwSGi9FDlBb/2SMFMtbP4
         VvvA==
X-Gm-Message-State: AOAM533bKMcLHVK66Ns0JQJa6xKm6aEnCGagiPSO9Cixicl+NYQcb7Rl
        /hNHpglquDaHgj06m59C0Yw=
X-Google-Smtp-Source: ABdhPJyX3NTU+RKun1bf+sfXWZqEkfB2cKFgREHqYDjWLvHkrND5j4Y6bzToyv4alOb/fWZzqBbQkA==
X-Received: by 2002:a17:906:da03:: with SMTP id fi3mr3222606ejb.321.1603966139102;
        Thu, 29 Oct 2020 03:08:59 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:58 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 15/19] net: phy: davicom: implement generic .handle_interrupt() calback
Date:   Thu, 29 Oct 2020 12:07:37 +0200
Message-Id: <20201029100741.462818-16-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In an attempt to actually support shared IRQs in phylib, we now move the
responsibility of triggering the phylib state machine or just returning
IRQ_NONE, based on the IRQ status register, to the PHY driver. Having
3 different IRQ handling callbacks (.handle_interrupt(),
.did_interrupt() and .ack_interrupt() ) is confusing so let the PHY
driver implement directly an IRQ handler like any other device driver.
Make this driver follow the new convention.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/davicom.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/phy/davicom.c b/drivers/net/phy/davicom.c
index 942f277463a4..262ff6c79860 100644
--- a/drivers/net/phy/davicom.c
+++ b/drivers/net/phy/davicom.c
@@ -77,6 +77,24 @@ static int dm9161_config_intr(struct phy_device *phydev)
 	return temp;
 }
 
+static irqreturn_t dm9161_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_DM9161_INTR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (irq_status == 0)
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int dm9161_config_aneg(struct phy_device *phydev)
 {
 	int err;
@@ -149,6 +167,7 @@ static struct phy_driver dm91xx_driver[] = {
 	.config_aneg	= dm9161_config_aneg,
 	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
+	.handle_interrupt = dm9161_handle_interrupt,
 }, {
 	.phy_id		= 0x0181b8b0,
 	.name		= "Davicom DM9161B/C",
@@ -158,6 +177,7 @@ static struct phy_driver dm91xx_driver[] = {
 	.config_aneg	= dm9161_config_aneg,
 	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
+	.handle_interrupt = dm9161_handle_interrupt,
 }, {
 	.phy_id		= 0x0181b8a0,
 	.name		= "Davicom DM9161A",
@@ -167,6 +187,7 @@ static struct phy_driver dm91xx_driver[] = {
 	.config_aneg	= dm9161_config_aneg,
 	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
+	.handle_interrupt = dm9161_handle_interrupt,
 }, {
 	.phy_id		= 0x00181b80,
 	.name		= "Davicom DM9131",
@@ -174,6 +195,7 @@ static struct phy_driver dm91xx_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
+	.handle_interrupt = dm9161_handle_interrupt,
 } };
 
 module_phy_driver(dm91xx_driver);
-- 
2.28.0

