Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3103C2C0F06
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389613AbgKWPiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389649AbgKWPiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:54 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7492AC0613CF;
        Mon, 23 Nov 2020 07:38:54 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id a16so23934975ejj.5;
        Mon, 23 Nov 2020 07:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ERL5JsBG9HleDkhJxzsPpAkh9W+QG3iEnGrftSlwy8=;
        b=UpVfk6PLa+4AryVCIEwKkaYiFZmI3g+hgKRBbTkRQjojZExlL8ciiRkNgtf6ybrLJf
         otcSmB7ieizjR3anzA4XLGN2ESEKaTLkSh1/4Z5MVHNYKsIz8FvEBkaVwWfI2yrnQL7A
         GHBuQVqnN/FeYdk9w9o94dQanrn4MvjvzpTdelG0Zk6zaEfZlUdMUVXf4AeEZ0U8bBhx
         CcbCNoH8Btw355y9ikTYH1FX2HI+3CO3nYD/busw+hkSakpPcjQDXIqAx4AOBqHLN4yK
         lgz6Zq+wBByp5M9nKJTG9ovctvCFWTi5HNih3QwvXxLDpgxpT0ILaquTpZ81lJOVUtAH
         HOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ERL5JsBG9HleDkhJxzsPpAkh9W+QG3iEnGrftSlwy8=;
        b=PHi4YIa0BmPWbPpkLss0YnaWB6dhWCTicQz5Mpczr8ONSGrvGCQG4ynydJHjcF9M64
         JVZMGvLVyGiKPOelIQJF1eAJQSIqNm5dKkzH0HLr7XL5oQVocE4JyLz8newUJ96IJxft
         trB2NxSoZMjLvyflCnoXgSIowiDI7mbxro3JOJRtsXDxDGmLntRfFhydOdZhc9zwF6NO
         XIItbfGgN9feRXnAK7LbP4eF8NMXckQPdBK0bpuc57O8UbsMipobbLXeBlITWs/wYddX
         Mgz29hwRrkRzSFQ7f+B44SZrio3WOQb7i5cFKaCESFWNkPQngJ5Xqz0jo9VS2+/95tlC
         81Mg==
X-Gm-Message-State: AOAM533NUPuw8G9pGwsAphnRJ41edu7jkr+l3a+LHAs9Yb4rON9MhIEJ
        jYz5RGrgl917omDbLgsqCJk=
X-Google-Smtp-Source: ABdhPJykkoMd1I+9Z1xnDExnu5m9B0zOaD24z7hVCqF3XLjQiRRb2/xR1BkRlpbTJGv/XnCmad94cA==
X-Received: by 2002:a17:906:d8ab:: with SMTP id qc11mr197576ejb.64.1606145933130;
        Mon, 23 Nov 2020 07:38:53 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:52 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 09/15] net: phy: national: implement generic .handle_interrupt() callback
Date:   Mon, 23 Nov 2020 17:38:11 +0200
Message-Id: <20201123153817.1616814-10-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/national.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/phy/national.c b/drivers/net/phy/national.c
index a5bf0874c7d8..8c71fd66b0b1 100644
--- a/drivers/net/phy/national.c
+++ b/drivers/net/phy/national.c
@@ -89,6 +89,27 @@ static int ns_ack_interrupt(struct phy_device *phydev)
 	return ret;
 }
 
+static irqreturn_t ns_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, DP83865_INT_STATUS);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & DP83865_INT_MASK_DEFAULT))
+		return IRQ_NONE;
+
+	/* clear the interrupt */
+	phy_write(phydev, DP83865_INT_CLEAR, irq_status & ~0x7);
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static void ns_giga_speed_fallback(struct phy_device *phydev, int mode)
 {
 	int bmcr = phy_read(phydev, MII_BMCR);
@@ -135,6 +156,7 @@ static struct phy_driver dp83865_driver[] = { {
 	.config_init = ns_config_init,
 	.ack_interrupt = ns_ack_interrupt,
 	.config_intr = ns_config_intr,
+	.handle_interrupt = ns_handle_interrupt,
 } };
 
 module_phy_driver(dp83865_driver);
-- 
2.28.0

