Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873A52A1E11
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgKAMxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgKAMwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:42 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A735BC061A49;
        Sun,  1 Nov 2020 04:52:41 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id w25so11397087edx.2;
        Sun, 01 Nov 2020 04:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DkCjEL0MCgdHV4tLa5DMDPJaZGJ5GBR0FjCC6JHZI8M=;
        b=tIk4fqS7Zn/4bCkA8rL6l0pW1KH/9lSMlOztyuesSaXOQfjVGZ0BFK5BliY2ffmqQT
         vEuxg7ZbeEwRdXZFNWK5Fyt+XZO2H5/kPqQvIarQJmSEz78nK2uirLNa9DsXBPlKA2yX
         aLIq2HjfWoFh7W65EZ43treaav5sClnNQfRt7+vQipMDWmpsK/s5Lop3Q+/sFqCW2gy8
         ZnkKY/vK3CehmqM81DURP5H5+9MZvGTSt7t4Ibn/8FrB5E21ogHa8/HB50l8JYqoxofD
         9an5r9vHoezTK5TNWzjTMRi0EYz2ziOdeDA4Izd0ObdhCN2Y925In18vn+2R319UTV6A
         xYew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DkCjEL0MCgdHV4tLa5DMDPJaZGJ5GBR0FjCC6JHZI8M=;
        b=kwWHa+RwiRQP0KmnGXWoHWaGphypFs1brMEcqqJ7y9kqzxDs1uVjIgoWX/eEpStYEx
         IXxIjBJteCACXj1CovVvny4eej922s3oj9UofP2WxPEHKWJXs1a2MnMG3P6SNpCXUIOg
         cM3zZ0d65ISdZnRzYuw2S3hvs3/N09eAtN9NBEf8dgFEUE82FoqbYoqt+xrLyDX+ZRst
         /3paNIVL7p7HtXrC1lF9FNE/S3vcP0Ie0qluG10+GpCnIi14YbO5A1KKkQyKpNJdyrxM
         oDiLhn85HnzbpaOdoTP1eh0JG9eg88x1iuF/X7H9efU5HwjGwI6F6nhovWYclGSq5QKS
         Lxkw==
X-Gm-Message-State: AOAM5327iEXzAbGcqB6Zc66t4cXWqrHyxzlFankgyI0QLBk6EteOencY
        sPU8RWDXnixhR/VJcOlKq2A=
X-Google-Smtp-Source: ABdhPJwRH49aNB3cxvv6BCjnYDGqhr3lO0QQ9RxfQ0j4VKRYwNgkZHMY7I5LwkwtWGK8/NaS+CvsDA==
X-Received: by 2002:aa7:c358:: with SMTP id j24mr11935815edr.265.1604235160379;
        Sun, 01 Nov 2020 04:52:40 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:39 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 15/19] net: phy: davicom: implement generic .handle_interrupt() calback
Date:   Sun,  1 Nov 2020 14:51:10 +0200
Message-Id: <20201101125114.1316879-16-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
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
Changes in v2:
 - Adjust .handle_interrupt() so that we only take into account the
   enabled IRQs.

 drivers/net/phy/davicom.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/phy/davicom.c b/drivers/net/phy/davicom.c
index 942f277463a4..bfa6c835070f 100644
--- a/drivers/net/phy/davicom.c
+++ b/drivers/net/phy/davicom.c
@@ -47,6 +47,10 @@
 #define MII_DM9161_INTR_STOP	\
 (MII_DM9161_INTR_DPLX_MASK | MII_DM9161_INTR_SPD_MASK \
  | MII_DM9161_INTR_LINK_MASK | MII_DM9161_INTR_MASK)
+#define MII_DM9161_INTR_CHANGE	\
+	(MII_DM9161_INTR_DPLX_CHANGE | \
+	 MII_DM9161_INTR_SPD_CHANGE | \
+	 MII_DM9161_INTR_LINK_CHANGE)
 
 /* DM9161 10BT Configuration/Status */
 #define MII_DM9161_10BTCSR	0x12
@@ -77,6 +81,24 @@ static int dm9161_config_intr(struct phy_device *phydev)
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
+	if (!(irq_status & MII_DM9161_INTR_CHANGE))
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
@@ -149,6 +171,7 @@ static struct phy_driver dm91xx_driver[] = {
 	.config_aneg	= dm9161_config_aneg,
 	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
+	.handle_interrupt = dm9161_handle_interrupt,
 }, {
 	.phy_id		= 0x0181b8b0,
 	.name		= "Davicom DM9161B/C",
@@ -158,6 +181,7 @@ static struct phy_driver dm91xx_driver[] = {
 	.config_aneg	= dm9161_config_aneg,
 	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
+	.handle_interrupt = dm9161_handle_interrupt,
 }, {
 	.phy_id		= 0x0181b8a0,
 	.name		= "Davicom DM9161A",
@@ -167,6 +191,7 @@ static struct phy_driver dm91xx_driver[] = {
 	.config_aneg	= dm9161_config_aneg,
 	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
+	.handle_interrupt = dm9161_handle_interrupt,
 }, {
 	.phy_id		= 0x00181b80,
 	.name		= "Davicom DM9131",
@@ -174,6 +199,7 @@ static struct phy_driver dm91xx_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt	= dm9161_ack_interrupt,
 	.config_intr	= dm9161_config_intr,
+	.handle_interrupt = dm9161_handle_interrupt,
 } };
 
 module_phy_driver(dm91xx_driver);
-- 
2.28.0

