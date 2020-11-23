Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CDE2C0F00
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389623AbgKWPiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389613AbgKWPit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:49 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FA8C061A4D;
        Mon, 23 Nov 2020 07:38:49 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id bo9so18136566ejb.13;
        Mon, 23 Nov 2020 07:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+zImLwmtn3XFF2OyJg33BL86dhQqi/258wupRnjhZ7Y=;
        b=OafqMegFwBCTQh1D8TZKBdtcOyHp9D5sY3cVDnwFUciifKiXe9KfG9MDfymp0+NK3H
         agHwrgabaHqyNO0o88Olv416CjOZVAec6bNtks3Q3wCFh4WBOpW2OO55jnehqa+tBoQs
         jgK7USZ13qtLhKgYQ+mpnnNoxOhjBlHNIa1ZqzYmczMSCYv7yiq/bCvb6Sh4pOqNuxTA
         cg4FjKpVDjHfiDMD+lapSkAzAcrFEd2UWeBnW4trxp0X1mqkpo45y5zxvhoYZYA8uzsm
         dELebXusLhMK2sNFlL1JLyitRZ3HsYThIOvf8WW+aPWI9/fmlgoi0g7M6Ah0eUmT4b22
         D79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+zImLwmtn3XFF2OyJg33BL86dhQqi/258wupRnjhZ7Y=;
        b=QXuiOCZuiDEjxKeQA7JO9Qo6Fx9subCEHivrv+sGkAzFiCzFZFdCFJjDYx1TM5/WHq
         tZ2wAwXAAav6P6QY99ManS/APmApEoIOxnZTwPPS5YAqEppsaGf1EG750UgbRHIIupQl
         qHiYci557VBDC7N2IVTRYB5HDlRtq8OOsvrUMtdvznuD4+VtE+seFQHJUp4iZlE95TbA
         S6nSKD2AAT6jvaZ1e2/CRrrap0KGgAo8pEiaFLYUM3pBPemOW/yqLf/thlmGn0beugJ5
         f9muVDfCLSfa73xVpo/BN9qcot5YkSFQirLVb48OxO26vPvTkZuxA9n+jh61aRQMzLv0
         xo9w==
X-Gm-Message-State: AOAM5301gJItVEfzXOIIoSpglm9I7OZZBeWJEF5Antg7wFNii5eky0s9
        Gh6SvBmsyQ+Esxe7Ve7lVKU=
X-Google-Smtp-Source: ABdhPJyX9k/7vu7XAW0LN3wAOuzu5adxYCg93cfT8oB3Chja+L7Llqts38g/M1QI0mcqTu15wPI99A==
X-Received: by 2002:a17:906:1542:: with SMTP id c2mr174700ejd.382.1606145926700;
        Mon, 23 Nov 2020 07:38:46 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:46 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH net-next 05/15] net: phy: meson-gxl: implement generic .handle_interrupt() callback
Date:   Mon, 23 Nov 2020 17:38:07 +0200
Message-Id: <20201123153817.1616814-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123153817.1616814-1-ciorneiioana@gmail.com>
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
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

Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/meson-gxl.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index e8f2ca625837..b16b1cc89165 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -222,6 +222,24 @@ static int meson_gxl_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, INTSRC_MASK, val);
 }
 
+static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, INTSRC_FLAG);
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
 static struct phy_driver meson_gxl_phy[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x01814400),
@@ -233,6 +251,7 @@ static struct phy_driver meson_gxl_phy[] = {
 		.read_status	= meson_gxl_read_status,
 		.ack_interrupt	= meson_gxl_ack_interrupt,
 		.config_intr	= meson_gxl_config_intr,
+		.handle_interrupt = meson_gxl_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
 	}, {
@@ -243,6 +262,7 @@ static struct phy_driver meson_gxl_phy[] = {
 		.soft_reset     = genphy_soft_reset,
 		.ack_interrupt	= meson_gxl_ack_interrupt,
 		.config_intr	= meson_gxl_config_intr,
+		.handle_interrupt = meson_gxl_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
 	},
-- 
2.28.0

